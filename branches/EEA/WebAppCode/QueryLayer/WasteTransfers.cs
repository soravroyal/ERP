using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Diagnostics;

using QueryLayer.Filters;
using QueryLayer.LinqFramework;
using QueryLayer.Utilities;
using QueryLayer.Enums;
using System.Collections;

namespace QueryLayer
{

    /// <summary>
    /// Holds methods to collect data for the Waste transfer search
    /// </summary>
    public static class WasteTransfers
    {

        public static string CODE_NONHW = EnumUtil.GetStringValue(WasteTypeFilter.Type.NonHazardous);
        public static string CODE_HWIC = EnumUtil.GetStringValue(WasteTypeFilter.Type.HazardousCountry);
        public static string CODE_HWOC = EnumUtil.GetStringValue(WasteTypeFilter.Type.HazardousTransboundary);
        public static string CODE_HW = EnumUtil.GetStringValue(WasteTypeFilter.Type.Hazardous);

        static string CODE_TNE = EnumUtil.GetStringValue(QuantityUnit.Tonnes);

        // ----------------------------------------------------------------------------------
        // Summary
        // ----------------------------------------------------------------------------------
        #region Summary
        public static IEnumerable<Summary.WasteSummaryTreeListRow> GetWasteTransfers(WasteTransferSearchFilter filter)
        {
            //set total no. of facilities
            filter.Count = GetFacilityCount(filter);


            if (filter.Count == 0)
            {
                // if no checks are set, display no data
                return null;
            }

            //get data from database - assume level=0 and hasChildren = false. Will be updated afterwards if needed.
			DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER_TREATMENT), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferSearch(filter, param, true);
            Expression<Func<WASTETRANSFER_TREATMENT, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER_TREATMENT, bool>>(exp, param);

            IEnumerable<Summary.WasteSummaryTreeListRow> data = db.WASTETRANSFER_TREATMENTs.Where(lambda)
                                                            .GroupBy(s => s.WasteTypeCode)
                                                            .Select(v => new Summary.WasteSummaryTreeListRow(
                                                                                v.Key,
                                                                                v.Select(x => x.FacilityReportID).Distinct().Count(), 
                                                                                v.Sum(x => x.QuantityRecovery),
                                                                                v.Sum(x => x.QuantityDisposal),
                                                                                v.Sum(x => x.QuantityUnspec),
                                                                                v.Sum(x => x.QuantityTotal),
                                                                                0,
                                                                                false)
                                                            );



            //add the data to the final result in wanted order. And update level/hasChildren if needed.
            List<Summary.WasteSummaryTreeListRow> result = new List<Summary.WasteSummaryTreeListRow>();

            // get string representations of wastetype
            Summary.WasteSummaryTreeListRow nonhw = data.SingleOrDefault(d => d.Code.Equals(CODE_NONHW));
            Summary.WasteSummaryTreeListRow hwic = data.SingleOrDefault(d => d.Code.Equals(CODE_HWIC));
            Summary.WasteSummaryTreeListRow hwoc = data.SingleOrDefault(d => d.Code.Equals(CODE_HWOC));
            Summary.WasteSummaryTreeListRow hw = data.SingleOrDefault(d => d.Code.Equals(CODE_HW)); 

            if (nonhw != null)
            {
                result.Add(nonhw);
            }

            if (hw != null)
            {
                hw.HasChildren = true; //otherwise it would not exist in data
                result.Add(hw);
            }

            if (hwic != null)
            {
                if (hw != null)
                {
                    hwic.Level = 1;
                }
                result.Add(hwic);
            }

            if (hwoc != null)
            {
                if (hw != null)
                {
                    hwoc.Level = 1;
                }
                result.Add(hwoc);
            }


            return result;

        }

        /// <summary>
        /// Extract numbers from list for non hazardous piechart
        /// </summary>
        public static List<Summary.WastePieChart> GetPieChartNonHazardous(IEnumerable<Summary.WasteSummaryTreeListRow> data)
        {
            string codeNONHW = EnumUtil.GetStringValue(WasteTypeFilter.Type.NonHazardous);
            List<Summary.WastePieChart> list = new List<Summary.WastePieChart>();

            if (data != null)
            {
                Summary.WasteSummaryTreeListRow nonhw = data.SingleOrDefault(d => d.Code.Equals(codeNONHW));

                if (nonhw != null)
                {
                    list.Add(new Summary.WastePieChart(nonhw.RecoveryPercent, "Recovery"));
                    list.Add(new Summary.WastePieChart(nonhw.DisposalPercent, "Disposal"));
                    list.Add(new Summary.WastePieChart(nonhw.UnspecifiedPercent, "Unspecified"));
                }
            }
            return list;
        }

        public static List<Summary.WastePieChart> GetPieChartHazardous(IEnumerable<Summary.WasteSummaryTreeListRow> data)
        {
            string codeHWIC = EnumUtil.GetStringValue(WasteTypeFilter.Type.HazardousCountry);
            string codeHWOC = EnumUtil.GetStringValue(WasteTypeFilter.Type.HazardousTransboundary);

            List<Summary.WastePieChart> list = new List<Summary.WastePieChart>();

            if (data != null)
            {
                Summary.WasteSummaryTreeListRow hwic = data.SingleOrDefault(d => d.Code.Equals(codeHWIC));
                Summary.WasteSummaryTreeListRow hwoc = data.SingleOrDefault(d => d.Code.Equals(codeHWOC));

                if (hwic != null)
                    list.Add(new Summary.WastePieChart(hwic.RecoveryPercent, "RecoveryDomestic"));
                if (hwoc != null)
                    list.Add(new Summary.WastePieChart(hwoc.RecoveryPercent, "RecoveryTransboundary"));

                if (hwic != null)
                    list.Add(new Summary.WastePieChart(hwic.DisposalPercent, "DisposalDomestic"));
                if (hwoc != null)
                    list.Add(new Summary.WastePieChart(hwoc.DisposalPercent, "DisposalTransboundary"));

                if (hwic != null)
                    list.Add(new Summary.WastePieChart(hwic.UnspecifiedPercent, "UnspecifiedDomestic"));
                if (hwoc != null)
                    list.Add(new Summary.WastePieChart(hwoc.UnspecifiedPercent, "UnspecifiedTransboundary"));
            }
            return list;
        }






        /// <summary>
        /// Returns the number of facilities corresponding to the filter. Always use WASTETRANSFER table, since it has the fewest records.
        /// </summary>
        public static int GetFacilityCount(WasteTransferSearchFilter filter)
        {
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferSearch(filter, param, false);
            Expression<Func<WASTETRANSFER, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER, bool>>(exp, param);

            //find total no. of facilities. Table only have one record per facility, so distinct is not needed.
            int count = db.WASTETRANSFERs
                                .Where(lambda)
                                .Select<WASTETRANSFER, int>(d => d.FacilityReportID)
                                .Count();

            return count;
            
        }

        #endregion

        // ----------------------------------------------------------------------------------
        // Activities
        // ----------------------------------------------------------------------------------
        #region Activities

        [Serializable]
        public class ActivityTreeListRow : QueryLayer.Utilities.ActivityTreeListRow, WasteTransferRow
        {
            public ActivityTreeListRow(string sectorCode, string activityCode, string subActivityCode,
                                        int facilities,
                                        double? quantityRecoveryHWIC, double? quantityDisposalHWIC, double? quantityUnspecHWIC,
                                        double? quantityRecoveryHWOC, double? quantityDisposalHWOC, double? quantityUnspecHWOC,
                                        double? quantityRecoveryNONHW, double? quantityDisposalNONHW, double? quantityUnspecNONHW,
                                        bool hasChildren)
                : base(sectorCode, activityCode, subActivityCode, hasChildren)
            {
                this.Facilities = facilities;

                //Hazardous inside Country
                this.QuantityRecoveryHWIC = quantityRecoveryHWIC;
                this.QuantityDisposalHWIC = quantityDisposalHWIC;
                this.QuantityUnspecHWIC = quantityUnspecHWIC;

                this.TotalHWIC = quantityRecoveryHWIC.Add(quantityDisposalHWIC, quantityUnspecHWIC );

                //Hazardous outside country
                this.QuantityRecoveryHWOC = quantityRecoveryHWOC;
                this.QuantityDisposalHWOC = quantityDisposalHWOC;
                this.QuantityUnspecHWOC = quantityUnspecHWOC;
                this.TotalHWOC = quantityRecoveryHWOC.Add(quantityDisposalHWOC , quantityUnspecHWOC);

                // Hazardous total
                this.QuantityRecoverySum = quantityRecoveryHWIC.Add(quantityRecoveryHWOC);
                this.QuantityDisposalSum = quantityDisposalHWIC.Add(quantityDisposalHWOC);
                this.QuantityUnspecSum =   quantityUnspecHWIC.Add(quantityUnspecHWOC);
                this.TotalSum = TotalHWIC.Add(TotalHWOC);
                
                // Non Hazardous
                this.QuantityRecoveryNONHW = quantityRecoveryNONHW;
                this.QuantityDisposalNONHW = quantityDisposalNONHW;
                this.QuantityUnspecNONHW = quantityUnspecNONHW;
                this.TotalNONHW = quantityRecoveryNONHW.Add(quantityDisposalNONHW ,quantityUnspecNONHW);

                //waste is always reported in t
                this.UnitCodeNONHW = QuantityUnit.Tonnes;
                this.UnitCodeHWIC = QuantityUnit.Tonnes;
                this.UnitCodeHWOC = QuantityUnit.Tonnes;
                this.UnitCodeSum = QuantityUnit.Tonnes;
            }

            public int Facilities { get; internal set; }

            public double? TotalHWIC { get; internal set; }
            public double? QuantityRecoveryHWIC { get; internal set; }
            public double? QuantityDisposalHWIC { get; internal set; }
            public double? QuantityUnspecHWIC { get; internal set; }
            public QuantityUnit UnitCodeHWIC { get; internal set; }

            public double? TotalHWOC { get; internal set; }
            public double? QuantityRecoveryHWOC { get; internal set; }
            public double? QuantityDisposalHWOC { get; internal set; }
            public double? QuantityUnspecHWOC { get; internal set; }
            public QuantityUnit UnitCodeHWOC { get; internal set; }

            public double? TotalSum { get; internal set; }
            public double? QuantityRecoverySum { get; internal set; }
            public double? QuantityDisposalSum { get; internal set; }
            public double? QuantityUnspecSum { get; internal set; }
            public QuantityUnit UnitCodeSum { get; internal set; }

            public double? TotalNONHW { get; internal set; }
            public double? QuantityRecoveryNONHW { get; internal set; }
            public double? QuantityDisposalNONHW { get; internal set; }
            public double? QuantityUnspecNONHW { get; internal set; }
            public QuantityUnit UnitCodeNONHW { get; internal set; }

        }

        [Serializable]
        public class SimpleActivityTreeListRow : QueryLayer.Utilities.ActivityTreeListRow
        {
            public SimpleActivityTreeListRow(string sectorCode, string activityCode, string subActivityCode,
                                        string wastetypeCode, 
                                        int facilities,
                                        double? quantityRecovery, 
                                        double? quantityDisposal, 
                                        double? quantityUnspec,
                                        double? quantityTotal,
                                        bool hasChildren)
                : base(sectorCode, activityCode, subActivityCode, hasChildren)
            {
                this.Facilities = facilities;
                this.WasteType = wastetypeCode;
                this.QuantityTotal = quantityTotal;
                this.QuantityRecovery = quantityRecovery;
                this.QuantityDisposal = quantityDisposal;
                this.QuantityUnspec = quantityUnspec;

                //waste is always reported in t
                this.UnitCode = CODE_TNE; //waste is always tonnes 
            }

            public int Facilities { get; internal set; }
            public string WasteType { get; internal set; }
            public double? QuantityTotal { get; internal set; }
            public double? QuantityRecovery { get; internal set; }
            public double? QuantityDisposal { get; internal set; }
            public double? QuantityUnspec { get; internal set; }
            public String UnitCode { get; internal set; }

        }

        public interface WasteTransferRow
        {
            int Facilities { get; }

            double? TotalHWIC { get; }
            double? QuantityRecoveryHWIC { get; }
            double? QuantityDisposalHWIC { get; }
            double? QuantityUnspecHWIC { get; }
            QuantityUnit UnitCodeHWIC { get; }

            double? TotalHWOC { get; }
            double? QuantityRecoveryHWOC { get; }
            double? QuantityDisposalHWOC { get; }
            double? QuantityUnspecHWOC { get; }
            QuantityUnit UnitCodeHWOC { get; }

            double? TotalSum { get; }
            double? QuantityRecoverySum { get; }
            double? QuantityDisposalSum { get; }
            double? QuantityUnspecSum { get; }
            QuantityUnit UnitCodeSum { get; }

            double? TotalNONHW { get; }
            double? QuantityRecoveryNONHW { get; }
            double? QuantityDisposalNONHW { get; }
            double? QuantityUnspecNONHW { get; }
            QuantityUnit UnitCodeNONHW { get; }

        }

        /// <summary>
        /// get lambda for pollutant transfers
        /// </summary>
        private static Expression<Func<WASTETRANSFER, bool>> getActivityAreaLambda(WasteTransferSearchFilter filter)
        {
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferSearch(filter, param, false);
            Expression<Func<WASTETRANSFER, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER, bool>>(exp, param);
            return lambda;
        }
        /// <summary>
        /// get lambda for table WASTETRANSFER_TREATMENT
        /// </summary>
        private static Expression<Func<WASTETRANSFER_TREATMENT, bool>> getLambdaWASTETRANSFER_TREATMENT(WasteTransferSearchFilter filter)
        {
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER_TREATMENT), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferSearch(filter, param, true);
            Expression<Func<WASTETRANSFER_TREATMENT, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER_TREATMENT, bool>>(exp, param);
            return lambda;
        }

        

        /// <summary>
        /// return full activity tree with all rows expanded
        /// </summary>
        public static IEnumerable<ActivityTreeListRow> GetActivityTree(WasteTransferSearchFilter filter)
        {
            IEnumerable<ActivityTreeListRow> sectors = GetSectors(filter).ToList();

            List<string> sectorCodes = sectors.Where(p => p.HasChildren).Select(p => p.SectorCode).ToList();
            IEnumerable<ActivityTreeListRow> activities = GetActivities(filter, sectorCodes).ToList();

            List<string> activityCodes = activities.Where(p => p.HasChildren).Select(p => p.ActivityCode).ToList();
            IEnumerable<ActivityTreeListRow> subactivities = GetSubActivities(filter, activityCodes).ToList();

            //create result with full tree.
            IEnumerable<ActivityTreeListRow> result = sectors.Union(activities).Union(subactivities)
                                                               .OrderBy(s => s.SectorCode)
                                                               .ThenBy(s => s.ActivityCode)
                                                               .ThenBy(s => s.SubactivityCode);

            return result;
        }


        /// <summary>
        /// return all sectors that fullfill search criteria
        /// </summary>
        public static IEnumerable<ActivityTreeListRow> GetSectors(WasteTransferSearchFilter filter)
        {
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            Expression<Func<WASTETRANSFER, bool>> lambda = getActivityAreaLambda(filter);

            //find data for sector level. Sector level always has children.
            IEnumerable<ActivityTreeListRow> sectors = db.WASTETRANSFERs.Where(lambda)
                                                     .GroupBy(p => new { SectorCode = p.IASectorCode})
                                                     .Select(x => new ActivityTreeListRow(
                                                         x.Key.SectorCode,
                                                         null,
                                                         null,
                                                         x.Count(),
                                                         x.Sum(p => p.QuantityRecoveryHWIC),
                                                         x.Sum(p => p.QuantityDisposalHWIC),
                                                         x.Sum(p => p.QuantityUnspecHWIC),
                                                         x.Sum(p => p.QuantityRecoveryHWOC),
                                                         x.Sum(p => p.QuantityDisposalHWOC),
                                                         x.Sum(p => p.QuantityUnspecHWOC),
                                                         x.Sum(p => p.QuantityRecoveryNONHW),
                                                         x.Sum(p => p.QuantityDisposalNONHW),
                                                         x.Sum(p => p.QuantityUnspecNONHW),
                                                         true));


            List<ActivityTreeListRow> result = sectors.ToList(); //make sure sql is executed now to do it only once

            ActivityTreeListRow total = result.GroupBy(p => 1)
                                             .Select(x => new ActivityTreeListRow(
                                                 ActivityTreeListRow.CODE_TOTAL,
                                                 null,
                                                 null,
                                                 x.Sum(p => p.Facilities),
                                                 x.SumOrNull(p => p.QuantityRecoveryHWIC),
                                                 x.SumOrNull(p => p.QuantityDisposalHWIC),
                                                 x.SumOrNull(p => p.QuantityUnspecHWIC),
                                                 x.SumOrNull(p => p.QuantityRecoveryHWOC),
                                                 x.SumOrNull(p => p.QuantityDisposalHWOC),
                                                 x.SumOrNull(p => p.QuantityUnspecHWOC),
                                                 x.SumOrNull(p => p.QuantityRecoveryNONHW),
                                                 x.SumOrNull(p => p.QuantityDisposalNONHW),
                                                 x.SumOrNull(p => p.QuantityUnspecNONHW),
                                                 false)).SingleOrDefault();


            int facilitiesCount = total != null ? total.Facilities : 0;

            //only add total to result if more than one row.
            if (result.Count() > 1)
            {
                result.Add(total);
            }

            return result;
        }


        /// <summary>
        /// return all activities (level 1) that fullfill search criteria within the sectorCodes given. 
        /// If sectorCodes are null, all activities will be returned. If sectorCodes is empty no activities will be returned.
        /// </summary>
        public static IEnumerable<ActivityTreeListRow> GetActivities(WasteTransferSearchFilter filter, List<string> sectorCodes)
        {
            if (sectorCodes != null && sectorCodes.Count() == 0)
                return new List<ActivityTreeListRow>();

            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            Expression<Func<WASTETRANSFER, bool>> lambda = getActivityAreaLambda(filter);

            if (sectorCodes != null)
            {
                ParameterExpression param = lambda.Parameters[0];
                Expression sectorExp = LinqExpressionBuilder.GetInExpr(param, "IASectorCode", sectorCodes);

                Expression exp = LinqExpressionBuilder.CombineAnd(lambda.Body, sectorExp);
                lambda = Expression.Lambda<Func<WASTETRANSFER, bool>>(exp, param);
            }

            //find data for activity level
            IEnumerable<ActivityTreeListRow> activities = db.WASTETRANSFERs.Where(lambda)
                                         .GroupBy(p => new { SectorCode = p.IASectorCode, ActivityCode = p.IAActivityCode })
                                         .Select(x => new ActivityTreeListRow(
                                             x.Key.SectorCode,
                                             x.Key.ActivityCode,
                                             null,
                                             x.Count(),
                                             x.Sum(p => p.QuantityRecoveryHWIC),
                                             x.Sum(p => p.QuantityDisposalHWIC),
                                             x.Sum(p => p.QuantityUnspecHWIC),
                                             x.Sum(p => p.QuantityRecoveryHWOC),
                                             x.Sum(p => p.QuantityDisposalHWOC),
                                             x.Sum(p => p.QuantityUnspecHWOC),
                                             x.Sum(p => p.QuantityRecoveryNONHW),
                                             x.Sum(p => p.QuantityDisposalNONHW),
                                             x.Sum(p => p.QuantityUnspecNONHW),
                                             x.First(p => !p.IASubActivityCode.Equals(null)) != null));

            return activities;
        }

        /// <summary>
        /// Return all subactivities (level 2) that fullfill search criteria. 
        /// If activityCodes are null, all activities will be returned. If activityCodes is empty no activities will be returned.
        /// Notice that this will include one subactivity "Not specified on this level" for each activity, even if the activity do not have any subactivities at all!
        /// </summary>
        public static IEnumerable<ActivityTreeListRow> GetSubActivities(WasteTransferSearchFilter filter, List<string> activityCodes)
        {
            if (activityCodes != null && activityCodes.Count() == 0)
                return new List<ActivityTreeListRow>();

            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            Expression<Func<WASTETRANSFER, bool>> lambda = getActivityAreaLambda(filter);

            //add activities to expression
            if (activityCodes != null)
            {
                ParameterExpression param = lambda.Parameters[0];
                Expression activityExp = LinqExpressionBuilder.GetInExpr(param, "IAActivityCode", activityCodes);

                Expression exp = LinqExpressionBuilder.CombineAnd(lambda.Body, activityExp);
                lambda = Expression.Lambda<Func<WASTETRANSFER, bool>>(exp, param);
            }

            //find data for sub-activity level, this level never has children.
            IEnumerable<ActivityTreeListRow> subactivities = db.WASTETRANSFERs.Where(lambda)
                                                                 .GroupBy(p => new { SectorCode = p.IASectorCode, ActivityCode = p.IAActivityCode, SubActivityCode = p.IASubActivityCode})
                                                                 .Select(x => new ActivityTreeListRow(
                                                                     x.Key.SectorCode,
                                                                     x.Key.ActivityCode,
                                                                     !x.Key.SubActivityCode.Equals(null) ? x.Key.SubActivityCode : ActivityTreeListRow.CODE_UNSPECIFIED,
                                                                     x.Count(),
                                                                     x.Sum(p => p.QuantityRecoveryHWIC),
                                                                     x.Sum(p => p.QuantityDisposalHWIC),
                                                                     x.Sum(p => p.QuantityUnspecHWIC),
                                                                     x.Sum(p => p.QuantityRecoveryHWOC),
                                                                     x.Sum(p => p.QuantityDisposalHWOC),
                                                                     x.Sum(p => p.QuantityUnspecHWOC),
                                                                     x.Sum(p => p.QuantityRecoveryNONHW),
                                                                     x.Sum(p => p.QuantityDisposalNONHW),
                                                                     x.Sum(p => p.QuantityUnspecNONHW),
                                                                     false));

            return subactivities;
        }

        /// <summary>
        /// return all sectors that fullfill search criteria. One row per sector per waste type
        /// </summary>
        public static IEnumerable<SimpleActivityTreeListRow> GetSectorsPerWasteType(WasteTransferSearchFilter filter)
        {
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            Expression<Func<WASTETRANSFER_TREATMENT, bool>> lambda = getLambdaWASTETRANSFER_TREATMENT(filter);

            //find data for sector level. Sector level always has children.
            IEnumerable<SimpleActivityTreeListRow> sectors = db.WASTETRANSFER_TREATMENTs.Where(lambda)
                                                     .GroupBy(p => new { SectorCode = p.IASectorCode, WasteTypeCode = p.WasteTypeCode })
                                                     .Select(x => new SimpleActivityTreeListRow(
                                                         x.Key.SectorCode,
                                                         null,
                                                         null,
                                                         x.Key.WasteTypeCode,
                                                         x.Count(),
                                                         x.Sum(p => p.QuantityRecovery),
                                                         x.Sum(p => p.QuantityDisposal),
                                                         x.Sum(p => p.QuantityUnspec),
                                                         x.Sum(p => p.QuantityTotal),
                                                         true));


            List<SimpleActivityTreeListRow> result = sectors.ToList(); //make sure sql is executed now to do it only once

            List<SimpleActivityTreeListRow> totals = result.GroupBy(p => new { WasteTypeCode = p.WasteType })
                                             .Select(x => new SimpleActivityTreeListRow(
                                                 ActivityTreeListRow.CODE_TOTAL,
                                                 null,
                                                 null,
                                                 x.Key.WasteTypeCode,
                                                 x.Sum(p => p.Facilities),
                                                 x.SumOrNull(p => p.QuantityRecovery),
                                                 x.SumOrNull(p => p.QuantityDisposal),
                                                 x.SumOrNull(p => p.QuantityUnspec),
                                                 x.SumOrNull(p => p.QuantityTotal),
                                                 false)).ToList();


            //only add total to result if more than one sector.
            if (result.Select(r => r.SectorCode).Distinct().Count() > 1)
            {
                result.AddRange(totals);
            }

            //find facility count
            int facilityCount = 0;
            if (result.Count == 1)
            {
                facilityCount = result.Single().Facilities;
            }
            else if (totals.Count == 1)
            {
                facilityCount = totals.Single().Facilities;
            }
            else
            {
                facilityCount = GetFacilityCount(filter);
            }

            filter.Count = facilityCount;

            return result;
        }


        /// <summary>
        /// return all activities (level 1) that fullfill search criteria within the sectorCodes given. 
        /// If sectorCodes are null, all activities will be returned. If sectorCodes is empty no activities will be returned.
        /// One row per activity per waste type
        /// </summary>
        public static IEnumerable<SimpleActivityTreeListRow> GetActivitiesPerWasteType(WasteTransferSearchFilter filter, List<string> sectorCodes)
        {
            if (sectorCodes != null && sectorCodes.Count() == 0)
                return new List<SimpleActivityTreeListRow>();

            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            Expression<Func<WASTETRANSFER_TREATMENT, bool>> lambda = getLambdaWASTETRANSFER_TREATMENT(filter);

            if (sectorCodes != null)
            {
                ParameterExpression param = lambda.Parameters[0];
                Expression sectorExp = LinqExpressionBuilder.GetInExpr(param, "IASectorCode", sectorCodes);

                Expression exp = LinqExpressionBuilder.CombineAnd(lambda.Body, sectorExp);
                lambda = Expression.Lambda<Func<WASTETRANSFER_TREATMENT, bool>>(exp, param);
            }

            //find data for activity level
            IEnumerable<SimpleActivityTreeListRow> activities = db.WASTETRANSFER_TREATMENTs.Where(lambda)
                                         .GroupBy(p => new { SectorCode = p.IASectorCode, ActivityCode = p.IAActivityCode, WasteTypeCpde = p.WasteTypeCode })
                                         .Select(x => new SimpleActivityTreeListRow(
                                             x.Key.SectorCode,
                                             x.Key.ActivityCode,
                                             null,
                                             x.Key.WasteTypeCpde,
                                             x.Count(),
                                             x.Sum(p => p.QuantityRecovery),
                                             x.Sum(p => p.QuantityDisposal),
                                             x.Sum(p => p.QuantityUnspec),
                                             x.Sum(p => p.QuantityTotal),
                                             x.First(p => !p.IASubActivityCode.Equals(null)) != null));

            return activities;
        }

        /// <summary>
        /// Return all subactivities (level 2) that fullfill search criteria. 
        /// If activityCodes are null, all activities will be returned. If activityCodes is empty no activities will be returned.
        /// Notice that this will include one subactivity "Not specified on this level" for each activity, even if the activity do not have any subactivities at all!
        /// One row per subactivity per waste type
        /// </summary>
        public static IEnumerable<SimpleActivityTreeListRow> GetSubActivitiesPerWasteType(WasteTransferSearchFilter filter, List<string> activityCodes)
        {
            if (activityCodes != null && activityCodes.Count() == 0)
                return new List<SimpleActivityTreeListRow>();

            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            Expression<Func<WASTETRANSFER_TREATMENT, bool>> lambda = getLambdaWASTETRANSFER_TREATMENT(filter);

            //add activities to expression
            if (activityCodes != null)
            {
                ParameterExpression param = lambda.Parameters[0];
                Expression activityExp = LinqExpressionBuilder.GetInExpr(param, "IAActivityCode", activityCodes);

                Expression exp = LinqExpressionBuilder.CombineAnd(lambda.Body, activityExp);
                lambda = Expression.Lambda<Func<WASTETRANSFER_TREATMENT, bool>>(exp, param);
            }

            //find data for sub-activity level, this level never has children.
            IEnumerable<SimpleActivityTreeListRow> subactivities = db.WASTETRANSFER_TREATMENTs.Where(lambda)
                                                                 .GroupBy(p => new { SectorCode = p.IASectorCode, ActivityCode = p.IAActivityCode, SubActivityCode = p.IASubActivityCode, WasteTypeCode = p.WasteTypeCode })
                                                                 .Select(x => new SimpleActivityTreeListRow(
                                                                     x.Key.SectorCode,
                                                                     x.Key.ActivityCode,
                                                                     !x.Key.SubActivityCode.Equals(null) ? x.Key.SubActivityCode : ActivityTreeListRow.CODE_UNSPECIFIED,
                                                                     x.Key.WasteTypeCode,
                                                                     x.Count(),
                                                                     x.Sum(p => p.QuantityRecovery),
                                                                     x.Sum(p => p.QuantityDisposal),
                                                                     x.Sum(p => p.QuantityUnspec),
                                                                     x.Sum(p => p.QuantityTotal),
                                                                     false));

            return subactivities;
        }


        #endregion

        // ----------------------------------------------------------------------------------
        // Areas
        // ----------------------------------------------------------------------------------
        #region Areas


        [Serializable]
        public class WasteTreeListRow : TreeListRow, WasteTransferRow
        {
            private int facilities;

            public double? totalHWIC;
            public double? quantityRecoveryHWIC;
            public double? quantityDisposalHWIC;
            public double? quantityUnspecHWIC;
            public QuantityUnit unitCodeHWIC;

            private double? totalHWOC;
            private double? quantityRecoveryHWOC;
            private double? quantityDisposalHWOC;
            private double? quantityUnspecHWOC;
            private QuantityUnit unitCodeHWOC;

            private double? totalSum;
            private double? quantityRecoverySum;
            private double? quantityDisposalSum;
            private double? quantityUnspecSum;
            private QuantityUnit unitCodeSum;

            private double? totalNONHW;
            private double? quantityRecoveryNONHW;
            private double? quantityDisposalNONHW;
            private double? quantityUnspecNONHW;
            private QuantityUnit unitCodeNONHW;


            public WasteTreeListRow(string code, string parentCode,
                                        int facilities,
                                        double? quantityRecoveryHWIC, double? quantityDisposalHWIC, double? quantityUnspecHWIC,
                                        double? quantityRecoveryHWOC, double? quantityDisposalHWOC, double? quantityUnspecHWOC,
                                        double? quantityRecoveryNONHW, double? quantityDisposalNONHW, double? quantityUnspecNONHW,
                                        int level, bool hasChildren)
                : base(code, parentCode, level, hasChildren)
            {
                this.facilities = facilities;

                //Hazardous inside Country
                this.quantityRecoveryHWIC = quantityRecoveryHWIC;
                this.quantityDisposalHWIC = quantityDisposalHWIC;
                this.quantityUnspecHWIC = quantityUnspecHWIC;

                this.totalHWIC = this.quantityRecoveryHWIC.Add(this.quantityDisposalHWIC, this.quantityUnspecHWIC);

                //Hazardous outside country
                this.quantityRecoveryHWOC = quantityRecoveryHWOC;
                this.quantityDisposalHWOC = quantityDisposalHWOC;
                this.quantityUnspecHWOC = quantityUnspecHWOC;
                this.totalHWOC = this.quantityRecoveryHWOC.Add(this.quantityDisposalHWOC, this.quantityUnspecHWOC);

                // Hazardous total
                this.quantityRecoverySum = this.quantityRecoveryHWIC.Add(this.quantityRecoveryHWOC);
                this.quantityDisposalSum = this.quantityDisposalHWIC.Add(this.quantityDisposalHWOC);
                this.quantityUnspecSum = this.quantityUnspecHWIC.Add(this.quantityUnspecHWOC);
                this.totalSum = this.totalHWIC.Add(this.totalHWOC);

                // Non Hazardous
                this.quantityRecoveryNONHW = quantityRecoveryNONHW;
                this.quantityDisposalNONHW = quantityDisposalNONHW;
                this.quantityUnspecNONHW = quantityUnspecNONHW;
                this.totalNONHW = this.quantityRecoveryNONHW.Add(this.quantityDisposalNONHW, this.quantityUnspecNONHW);

                //waste is always reported in t
                this.unitCodeNONHW = QuantityUnit.Tonnes;
                this.unitCodeHWIC = QuantityUnit.Tonnes;
                this.unitCodeHWOC = QuantityUnit.Tonnes;
                this.unitCodeSum = QuantityUnit.Tonnes;
            }

            public int Facilities { get { return this.facilities; } }

            public double? TotalHWIC { get { return this.totalHWIC; } }
            public double? QuantityRecoveryHWIC { get { return this.quantityRecoveryHWIC; } }
            public double? QuantityDisposalHWIC { get { return this.quantityDisposalHWIC; } }
            public double? QuantityUnspecHWIC { get { return this.quantityUnspecHWIC; } }
            public QuantityUnit UnitCodeHWIC { get { return this.unitCodeHWIC; } }

            public double? TotalHWOC { get { return this.totalHWOC; } }
            public double? QuantityRecoveryHWOC { get { return this.quantityRecoveryHWOC; } }
            public double? QuantityDisposalHWOC { get { return this.quantityDisposalHWOC; } }
            public double? QuantityUnspecHWOC { get { return this.quantityUnspecHWOC; } }
            public QuantityUnit UnitCodeHWOC { get { return this.unitCodeHWOC; } }

            public double? TotalSum { get { return this.totalSum; } }
            public double? QuantityRecoverySum { get { return this.quantityRecoverySum; } }
            public double? QuantityDisposalSum { get { return this.quantityDisposalSum; } }
            public double? QuantityUnspecSum { get { return this.quantityUnspecSum; } }
            public QuantityUnit UnitCodeSum { get { return this.unitCodeSum; } }

            public double? TotalNONHW { get { return this.totalNONHW; } }
            public double? QuantityRecoveryNONHW { get { return this.quantityRecoveryNONHW; } }
            public double? QuantityDisposalNONHW { get { return this.quantityDisposalNONHW; } }
            public double? QuantityUnspecNONHW { get { return this.quantityUnspecNONHW; } }
            public QuantityUnit UnitCodeNONHW { get { return this.unitCodeNONHW; } }

        }

        /// <summary>
        /// get areas
        /// </summary>
        private static List<WasteTreeListRow> getAreas(DataClassesWasteTransferDataContext db, Expression<Func<WASTETRANSFER, bool>> lambda, out int facilitiesCount)
        {
            int level = 0;
            bool hasChildren = true; //country level always has children.

            //The parent code is set to the code itself on grounds of later sorting.
            IEnumerable<WasteTreeListRow> data = db.WASTETRANSFERs.Where(lambda)
                                                     .GroupBy(p => p.CountryCode)
                                                     .OrderBy(x => x.Key)
                                                     .Select(x => new WasteTreeListRow(
                                                         x.Key,
                                                         x.Key,
                                                         x.Count(),
                                                         x.Sum(p => p.QuantityRecoveryHWIC),
                                                         x.Sum(p => p.QuantityDisposalHWIC),
                                                         x.Sum(p => p.QuantityUnspecHWIC),
                                                         x.Sum(p => p.QuantityRecoveryHWOC),
                                                         x.Sum(p => p.QuantityDisposalHWOC),
                                                         x.Sum(p => p.QuantityUnspecHWOC),
                                                         x.Sum(p => p.QuantityRecoveryNONHW),
                                                         x.Sum(p => p.QuantityDisposalNONHW),
                                                         x.Sum(p => p.QuantityUnspecNONHW),
                                                         level,
                                                         hasChildren));

            List<WasteTreeListRow> result = data.ToList(); //make sure sql is executed now to do it only once

            WasteTreeListRow total = result.GroupBy(p => 1)
                                             .Select(x => new WasteTreeListRow(
                                                 "TOT",
                                                 null,
                                                 x.Sum(p => p.Facilities),
                                                 x.SumOrNull(p => p.QuantityRecoveryHWIC),
                                                 x.SumOrNull(p => p.QuantityDisposalHWIC),
                                                 x.SumOrNull(p => p.QuantityUnspecHWIC),
                                                 x.SumOrNull(p => p.QuantityRecoveryHWOC),
                                                 x.SumOrNull(p => p.QuantityDisposalHWOC),
                                                 x.SumOrNull(p => p.QuantityUnspecHWOC),
                                                 x.SumOrNull(p => p.QuantityRecoveryNONHW),
                                                 x.SumOrNull(p => p.QuantityDisposalNONHW),
                                                 x.SumOrNull(p => p.QuantityUnspecNONHW),
                                                 level,
                                                 false)).SingleOrDefault();


            facilitiesCount = total != null ? total.Facilities : 0;

            //only add total to result if more than one row.
            if (result.Count() > 1)
            {
                result.Add(total);
            }

            return result;

        }

        /// <summary>
        /// get sub area
        /// </summary>
        private static List<WasteTreeListRow> getSubAreas(DataClassesWasteTransferDataContext db, string countryCode, Expression<Func<WASTETRANSFER, bool>> lambda, AreaFilter.RegionType regionType)
        {
            int level = 1;
            bool hasChildren = false; //subarea level never has children.
            string code_unknown = regionType == AreaFilter.RegionType.RiverBasinDistrict ? WasteTreeListRow.CODE_UNKNOWN : null;

            IEnumerable<WasteTreeListRow> data = db.WASTETRANSFERs.Where(lambda).Where(p => p.CountryCode == countryCode)
                                         .GroupBy(regionType)
                                         .OrderBy(x => x.Key.Code.Equals(code_unknown))
                                         .ThenBy(x => x.Key.Code)
                                         .Select(x => new WasteTreeListRow(
                                             !x.Key.Code.Equals(null) ? x.Key.Code : WasteTreeListRow.CODE_UNKNOWN,
                                             x.Key.ParentCode,
                                             x.Count(),
                                             x.Sum(p => p.QuantityRecoveryHWIC),
                                             x.Sum(p => p.QuantityDisposalHWIC),
                                             x.Sum(p => p.QuantityUnspecHWIC),
                                             x.Sum(p => p.QuantityRecoveryHWOC),
                                             x.Sum(p => p.QuantityDisposalHWOC),
                                             x.Sum(p => p.QuantityUnspecHWOC),
                                             x.Sum(p => p.QuantityRecoveryNONHW),
                                             x.Sum(p => p.QuantityDisposalNONHW),
                                             x.Sum(p => p.QuantityUnspecNONHW),
                                             level,
                                             hasChildren));

            List<WasteTreeListRow> result = data.ToList();

            return result;
        }

        /// <summary>
        /// get area
        /// </summary>
        public static List<WasteTreeListRow> GetArea(WasteTransferSearchFilter filter)
        {
			DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            Expression<Func<WASTETRANSFER, bool>> lambda = getActivityAreaLambda(filter);
            int facilitiesCount = 0;
            List<WasteTreeListRow> areas = getAreas(db, lambda, out facilitiesCount);
            filter.Count = facilitiesCount;
            return areas;
        }

        /// <summary>
        /// get area tree
        /// </summary>
        public static List<WasteTreeListRow> GetAreaTree(Dictionary<string, bool> expandRows, WasteTransferSearchFilter filter, List<WasteTransfers.WasteTreeListRow> areasOrg)
        {
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            Expression<Func<WASTETRANSFER, bool>> lambda = getActivityAreaLambda(filter);

            // only fill sectors from db if sectorsOrg==null
            List<WasteTreeListRow> areas = null;
            if (areasOrg != null)
            {
                areas = new List<WasteTreeListRow>();
                areas.AddRange(areasOrg);
            }
            else
            {
                int facilitiesCount = 0;
                areas = getAreas(db, lambda, out facilitiesCount);
                filter.Count = facilitiesCount;
            }

            foreach (WasteTreeListRow a in areas)
            {
                a.IsExpanded = false;
            }


            foreach (KeyValuePair<string, bool> kvp in expandRows)
            {
                // if not expanded goto next
                if (!kvp.Value) continue;

                // expanded, find in list (search all nodes)
                int row = 0;
                foreach (WasteTreeListRow s in areas)
                {
                    string code = (s.Code != null) ? s.Code.ToString() : String.Empty;
                    if (code == kvp.Key)
                    {
                        s.IsExpanded = true;
                        // find sub area
                        List<WasteTreeListRow> activities = getSubAreas(db, code, lambda, filter.AreaFilter.TypeRegion);
                        // insert area
                        foreach (WasteTreeListRow a in activities)
                        {
                            areas.Insert(row + 1, a);
                            row++;
                        }
                        break;
                    }
                    row++;
                }
            }
            
            return areas;
        }

        #endregion

        // ----------------------------------------------------------------------------------
        // AreaComparison
        // ----------------------------------------------------------------------------------
        #region AreaComparison

        [Serializable]
        public class AreaComparison
        {
            public AreaComparison(string area, double? total, double? recovery, double? disposal, double? unspecified, int facilities)
            {
                this.Area = area;
                this.Total = total; 
                this.Recovery = recovery; 
                this.Disposal = disposal; 
                this.Unspecified = unspecified; 
                this.Facilities = facilities;

                this.TotalAnnexI = null; 
                this.RecoveryAnnexI = null; 
                this.DisposalAnnexI = null; 
                this.UnspecifiedAnnexI = null; 
            }

            public string Area { get; set; }
            
            // The percent will be:
            // Total percent = (Total / TotalCount) * 100
            // Recovery percent = (Recovery / TotalCount) * 100
            //  :
            public double? Total { get; set; }
            public double? Recovery { get; set; }
            public double? Disposal { get; set; }
            public double? Unspecified { get; set; }
            
            /// <summary>
            /// Total in selected area
            /// </summary>
            public double? TotalCount{get; set;}


            // The Annex percent will be:
            // TotalAnnexI percent = (TotalAnnexI / TotalCount) * 100
            // RecoveryAnnexI percent = (RecoveryAnnexI / TotalCount) * 100
            //  :
            public double? TotalAnnexI { get; set; } //double-counting for total
            public double? RecoveryAnnexI { get; set; } //double-counting for recover
            public double? DisposalAnnexI { get; set; } //double-counting for disposal
            public double? UnspecifiedAnnexI { get; set; } //double-counting for unspec
            public double? TotalCountAnnexI;
            
            // number of facilities
            public int Facilities { get; set; }
        }

        /// <summary>
        /// Get lambda for all Area comparison
        /// </summary>
        private static Expression<Func<WASTETRANSFER, bool>> GetAreaComparisonLambda(DataClassesWasteTransferDataContext db, WasteTransferSearchFilter filter)
        {
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferSearch(filter, param, false);
            return Expression.Lambda<Func<WASTETRANSFER, bool>>(exp, param);
        }

        /// <summary>
        /// Get lambda for all Area comparison
        /// </summary>
        private static Expression<Func<WASTETRANSFER, bool>> GetAreaComparisonAnnexLambda()
        {
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER), "s");
            Expression prop = Expression.Property(param, "IAActivityCode");
            Expression exp = Expression.Equal(prop, Expression.Constant("5.(a)"));
            exp = Expression.Or(exp, Expression.Equal(prop, Expression.Constant("5.(b)")));
            exp = Expression.Or(exp, Expression.Equal(prop, Expression.Constant("5.(c)")));
            exp = Expression.Or(exp, Expression.Equal(prop, Expression.Constant("5.(d)")));
            exp = Expression.Or(exp, Expression.Equal(prop, Expression.Constant("5.(e)")));
            return Expression.Lambda<Func<WASTETRANSFER, bool>>(exp, param);
        }


        /// <summary>
        /// Return area compare for HWOC
        /// </summary>
        public static List<AreaComparison> GetAreaComparison(WasteTransferSearchFilter filter, WasteTypeFilter.Type wasteType)
        {
            // create lambda
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            Expression<Func<WASTETRANSFER, bool>> lambda = GetAreaComparisonLambda(db, filter);
            Expression<Func<WASTETRANSFER, bool>> lambdaAnnex = GetAreaComparisonAnnexLambda();
            // query data
            List<AreaComparison> final = getAreaComparison(db, filter, lambda, null, wasteType);
            List<AreaComparison> finalAnnex = getAreaComparison(db, filter, lambda, lambdaAnnex, wasteType);
            // merge lists
            mergeLists(final, finalAnnex);
            return final;
        }

        private static List<AreaComparison> getAreaComparison(DataClassesWasteTransferDataContext db, WasteTransferSearchFilter filter, Expression<Func<WASTETRANSFER, bool>> lambda, Expression<Func<WASTETRANSFER, bool>> annexLambda, WasteTypeFilter.Type wasteType)
        {
            //apply wasteType condition
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER), "s");
            Expression expWasteType = LinqExpressionBuilder.GetLinqExpressionWasteTransferType(wasteType, param, false);
            Expression<Func<WASTETRANSFER, bool>> wt = Expression.Lambda<Func<WASTETRANSFER, bool>>(expWasteType, param);

            //apply where clause
            IQueryable<WASTETRANSFER> baseData= db.WASTETRANSFERs.Where(lambda).Where(wt);
            if (annexLambda != null)
                baseData = baseData.Where(annexLambda);

            //group by area dependend on filter
            IQueryable<IGrouping<TreeListRowGroupByKey, WASTETRANSFER>> group = baseData.GroupBy(filter.AreaFilter);

            //select data depenedend on wastetype
            IEnumerable<AreaComparison> data = null;
            switch (wasteType)
            {
                case WasteTypeFilter.Type.NonHazardous:
                    data = group.Select(x => new AreaComparison(
                                        x.Key.Code,
                                        x.Sum(p => p.QuantityTotalNONHW),
                                        x.Sum(p => p.QuantityRecoveryNONHW),
                                        x.Sum(p => p.QuantityDisposalNONHW),
                                        x.Sum(p => p.QuantityUnspecNONHW),
                                        x.Count()));
                    break;
                case WasteTypeFilter.Type.HazardousCountry:
                    data = group.Select(x => new AreaComparison(
                                        x.Key.Code,
                                        x.Sum(p => p.QuantityTotalHWIC),
                                        x.Sum(p => p.QuantityRecoveryHWIC),
                                        x.Sum(p => p.QuantityDisposalHWIC),
                                        x.Sum(p => p.QuantityUnspecHWIC),
                                        x.Count()));
                    break;
                case WasteTypeFilter.Type.HazardousTransboundary:
                    data = group.Select(x => new AreaComparison(
                                        x.Key.Code,
                                        x.Sum(p => p.QuantityTotalHWOC),
                                        x.Sum(p => p.QuantityRecoveryHWOC),
                                        x.Sum(p => p.QuantityDisposalHWOC),
                                        x.Sum(p => p.QuantityUnspecHWOC),
                                        x.Count()));
                    break;
                default:
                    throw new ArgumentOutOfRangeException("wasteType", String.Format("Illegal waste type: {0}", wasteType.ToString()));
            }

            //Make sure sql is executed now and ordered by size
            List<AreaComparison> result = data.OrderBy(p => p.Total).ToList();

            //Calculate percentages
            double? tot = result.Sum(p => p.Total);
            foreach (AreaComparison ac in result)
                ac.TotalCount = tot;

            return result;
        }



        private static void mergeLists(List<AreaComparison> final, List<AreaComparison> other)
        {
            // merge lists
            foreach (AreaComparison f in final)
            {
                foreach (AreaComparison o in other)
                {  
                    // transfer data to the object f, if region codes are the same
                    // i.e.:
                    //  - both area code are null, i.e. "N/A" is shown in GUI
                    // <OR>
                    //  - both share an actual value
                    if (f.Area == o.Area)
                    {
                        f.TotalAnnexI = o.Total;
                        f.RecoveryAnnexI = o.Recovery;
                        f.DisposalAnnexI = o.Disposal;
                        f.UnspecifiedAnnexI = o.Unspecified;
                        f.TotalCountAnnexI = o.TotalCount;
                        break;
                    }
                }
            }
        }

        #endregion
        
        // ----------------------------------------------------------------------------------
        // Facilities
        // ----------------------------------------------------------------------------------
        #region Facilities

        public class ResultFacility
        {
            // public properties
            public string FacilityName { get; private set; }
            public string ActivityCode { get; private set; }
            public string CountryCode { get; private set; }
            public int FacilityReportId { get; private set; }
            
            public double? QuantityTotal { get; private set; }
            public double? QuantityRecovery { get; private set; }
            public double? QuantityDisposal { get; private set; }
            public double? QuantityUnspecified { get; private set; }

            public string QuantityCommonUnit { get; private set; }

            public bool ConfidentialIndicatorFacility { get; private set; }
            public bool ConfidentialIndicatorRecovery { get; private set; }
            public bool ConfidentialIndicatorDisposal { get; private set; }
            public bool ConfidentialIndicatorUnspecified { get; private set; }

            // properties used used only by CSV download
            public string Url { get; set; }
            public int FacilityId { get; private set; }

            // public ctor
            public ResultFacility(string facilityName, 
                                  string activityCode, 
                                  string countryCode,
                                  int facilityReportId,
                                  double? quantityRecovery,
                                  double? quantityDisposal,
                                  double? quantityUnspecified,
                                  double? quantityTotal,
                                  string unitCode,
                                  bool confidentialIndicatorFacility,
                                  bool? confidentialIndicatorRecovery,
                                  bool? confidentialIndicatorDisposal,
                                  bool? confidentialIndicatorUnspecified,
                                  int facilityId
                                  )
            {
                FacilityName = facilityName;
                ActivityCode = activityCode;
                CountryCode = countryCode;
                FacilityReportId = facilityReportId;

                QuantityRecovery = quantityRecovery;
                QuantityDisposal = quantityDisposal;
                QuantityUnspecified = quantityUnspecified;
                QuantityTotal = quantityTotal; ;
                QuantityCommonUnit = unitCode;

                ConfidentialIndicatorFacility = confidentialIndicatorFacility;
                ConfidentialIndicatorRecovery = confidentialIndicatorRecovery != null ? (bool)confidentialIndicatorRecovery : false;
                ConfidentialIndicatorDisposal = confidentialIndicatorDisposal != null ? (bool)confidentialIndicatorDisposal : false;
                ConfidentialIndicatorUnspecified = confidentialIndicatorUnspecified != null ? (bool)confidentialIndicatorUnspecified : false;

                FacilityId = facilityId;
            }
        }

        /// <summary>
        /// Generates facility list for Waste Transfer search results
        /// </summary>
        /// <param name="filter">Holds the search criteria</param>
        /// <param name="sortColumn">Specifies the column used for sorting</param>
        /// <param name="descending">Indicate whether sorting is descending</param>
        /// <param name="startRowIndex">Starting index for paging</param>
        /// <param name="pagingSize">Determines the number of rows displayed on each page of the list.</param>
        /// <param name="selectedWasteType">Specifies which type of waste the user has chosen.</param>
        /// <returns></returns>
        public static IEnumerable<WasteTransfers.ResultFacility> FacilityList(
             WasteTransferSearchFilter filter,
             string sortColumn,
             bool descending,
             int startRowIndex,
             int pagingSize,
             WasteTypeFilter.Type? selectedWasteType)
        {

            List<ResultFacility> result = new List<ResultFacility>();
            filter.Count = GetFacilityCount(filter);
            
            //create filter for selected waste type.
            WasteTransferSearchFilter customFilter = filter.Clone() as WasteTransferSearchFilter;
            customFilter.WasteTypeFilter = new WasteTypeFilter();           
            
            switch (selectedWasteType)
            {
                case WasteTypeFilter.Type.NonHazardous:
                    customFilter.WasteTypeFilter.NonHazardousWaste = true;
                    break;
                case WasteTypeFilter.Type.HazardousCountry:
                    customFilter.WasteTypeFilter.HazardousWasteCountry = true;
                    break;
                case WasteTypeFilter.Type.HazardousTransboundary:
                    customFilter.WasteTypeFilter.HazardousWasteTransboundary = true;
                    break;
                default:
                    customFilter = null;
                    break;
            }

            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            IEnumerable<WasteTransfers.ResultFacility> data = null;

            if (customFilter != null)
            {
                //create lambda expression
                ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER_TREATMENT), "s");
                Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferSearch(customFilter, param, true);
                Expression<Func<WASTETRANSFER_TREATMENT, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER_TREATMENT, bool>>(exp, param);

                //find total no. of facilities for this wastetype
                IQueryable<int> facilityReportIds = db.WASTETRANSFER_TREATMENTs.
                                    Where(lambda).
                                    Select<WASTETRANSFER_TREATMENT, int>(d => (d.FacilityReportID)).Distinct<int>();

                // set the number of found rows for this filter
                customFilter.Count = facilityReportIds.Count();

                //get data of correct type
                if (customFilter.Count > 0)
                {
                    data = db.WASTETRANSFER_TREATMENTs
                                   .Where(lambda)
                                   .orderBy(getSortColumns(sortColumn, descending))
                                   .Skip(startRowIndex).Take(pagingSize)
                                   .Select<WASTETRANSFER_TREATMENT, ResultFacility>(v => new ResultFacility(v.FacilityName,
                                                                                               v.IAActivityCode, 
                                                                                               v.CountryCode, 
                                                                                               v.FacilityReportID, 
                                                                                               v.QuantityRecovery, 
                                                                                               v.QuantityDisposal, 
                                                                                               v.QuantityUnspec, 
                                                                                               v.QuantityTotal,
                                                                                               v.UnitCode,
                                                                                               v.ConfidentialIndicatorFacility,
                                                                                               v.ConfidentialIndicatorRecovery,
                                                                                               v.ConfidentialIndicatorDisposal,
                                                                                               v.ConfidentialIndicatorUnspec,
                                                                                               v.FacilityID));
                }
            
                //add rows to result. Speedup paging by adding empty rows at the start and end of list.
                for (int i = 0; i < startRowIndex; i++)
                    result.Add(null);

                if (data != null)
                    result.AddRange(data);

                int addcount = result.Count;
                for (int i = 0; i < customFilter.Count - addcount; i++)
                    result.Add(null);

            }

            return result;                
        }

        //includes confidential indicator in sorting.
        private static SortColumn[] getSortColumns(string sortColumn, bool descending)
        {
            List<SortColumn> sortColumns = new List<SortColumn>();
            sortColumns.Add(new SortColumn(sortColumn, descending));

            string thenByColumn = String.Empty;

            switch (sortColumn)
            {
                case "QuantityRecovery": thenByColumn = "ConfidentialIndicatorRecovery";
                    break;
                case "QuantityDisposal": thenByColumn = "ConfidentialIndicatorDisposal";
                    break;
                case "QuantityUnspec": thenByColumn = "ConfidentialIndicatorUnspec";
                    break;
                default:
                    break;
            }

            if (!String.IsNullOrEmpty(thenByColumn))
            {
                sortColumns.Add(new SortColumn(thenByColumn, descending));
            }

            return sortColumns.ToArray<SortColumn>();
        }

        #endregion

        // ----------------------------------------------------------------------------------
        // Facilities CSV
        // ----------------------------------------------------------------------------------
        public static IEnumerable<ResultFacility> GetFacilityListCSV(WasteTransferSearchFilter filter)
        {
            //create lambda expression
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER_TREATMENT), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferSearch(filter, param, true);
            Expression<Func<WASTETRANSFER_TREATMENT, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER_TREATMENT, bool>>(exp, param);

            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            var data = db.WASTETRANSFER_TREATMENTs
                   .Where(lambda)
                   .OrderBy(x => x.FacilityName)
                   .Select<WASTETRANSFER_TREATMENT, ResultFacility>(v => new ResultFacility(v.FacilityName,
                                                                               v.IAActivityCode, 
                                                                               v.CountryCode, 
                                                                               v.FacilityReportID, 
                                                                               v.QuantityRecovery, 
                                                                               v.QuantityDisposal, 
                                                                               v.QuantityUnspec, 
                                                                               v.QuantityTotal,
                                                                               v.UnitCode,
                                                                               v.ConfidentialIndicatorFacility,
                                                                               v.ConfidentialIndicatorRecovery,
                                                                               v.ConfidentialIndicatorDisposal,
                                                                               v.ConfidentialIndicatorUnspec,
                                                                               v.FacilityID
                                                                               ));
                

            return data;
        }

        
        

        // ----------------------------------------------------------------------------------
        // Hazardous Waste Recievers
        // ----------------------------------------------------------------------------------
        #region HazardousWasteRecievers

        private static Expression<Func<WASTETRANSFER_RECEIVINGCOUNTRY, bool>> getRecievingCountryLambda(WasteTransferSearchFilter filter)
        {
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER_RECEIVINGCOUNTRY), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferSearch(filter, param, false);
            Expression<Func<WASTETRANSFER_RECEIVINGCOUNTRY, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER_RECEIVINGCOUNTRY, bool>>(exp, param);
            return lambda;
        }

        public class ResultHazardousWasteRecievingCountry
        {
            // public properties
            public string RecievingCountryCode { get; private set; }
            public int NumOfFacilities { get; private set; }
            public double? QuantityTotal { get; private set; }
            public double? QuantityRecovery { get; private set; }
            public double? QuantityDisposal { get; private set; }
            public double? QuantityUnspecified { get; private set; }
            public string QuantityCommonUnit { get; private set; }
            public bool ShowAsLink { get; private set; }

            // public ctor
            public ResultHazardousWasteRecievingCountry(string countryCode, int numOfFacilities,
                double? quantityRecovery, double? quantityDisposal,
                double? quantityUnspec, double? quantityTotal,
                bool showAsLink)
            {
                RecievingCountryCode = countryCode;
                NumOfFacilities = numOfFacilities;
                QuantityRecovery = quantityRecovery;
                QuantityDisposal = quantityDisposal;
                QuantityUnspecified = quantityUnspec;
                QuantityTotal = quantityTotal;
                QuantityCommonUnit = CODE_TNE; //waste is always reported as tonnes
                ShowAsLink = showAsLink;
            }
        }

        /// <summary>
        /// Generates facility list for Pollutant Transfer search results
        /// </summary>
        /// <param name="filter">Holds the search criteria</param>
        /// <returns></returns>
        public static IEnumerable<ResultHazardousWasteRecievingCountry> HazardousWasteRecieverList(
             WasteTransferSearchFilter filter)
        {
            //table only contains waste with type HWOC
            if (!filter.WasteTypeFilter.HazardousWasteTransboundary)
            {
                return new List<ResultHazardousWasteRecievingCountry>();;
            }

            // db handler
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            WasteTransferSearchFilter customFilter = filter.Clone() as WasteTransferSearchFilter;
            customFilter.WasteTypeFilter = null;

            Expression<Func<WASTETRANSFER_RECEIVINGCOUNTRY, bool>> lambda = getRecievingCountryLambda(customFilter);

            //find totals grouped by receiving country. Will be ordered by receiving country but with NULL always last
            IEnumerable<ResultHazardousWasteRecievingCountry> data = db.WASTETRANSFER_RECEIVINGCOUNTRies
                                                                .Where(lambda)
                                                                .GroupBy(v => v.ReceivingCountryCode)
                                                                .OrderByDescending(v => !v.Key.Equals(null))
                                                                .ThenBy(v => v.Key)
                                                                .Select(v => new ResultHazardousWasteRecievingCountry(
                                                                        v.Key,
                                                                        v.Select(x => x.FacilityReportID).Distinct().Count(),
                                                                        v.Sum(x => x.QuantityRecovery),
                                                                        v.Sum(x => x.QuantityDisposal),
                                                                        v.Sum(x => x.QuantityUnspec),
                                                                        v.Sum(x => x.QuantityTotal),
                                                                        !v.Key.Equals(null)));

            //find total for all receiving countries
            IEnumerable<ResultHazardousWasteRecievingCountry> total = db.WASTETRANSFER_RECEIVINGCOUNTRies
                                                                .Where(lambda)
                                                                .GroupBy(v => 1)
                                                                .OrderBy(v => v.Key)
                                                                .Select(v => new ResultHazardousWasteRecievingCountry(
                                                                        "TOTAL_KEY",
                                                                        v.Select(x => x.FacilityReportID).Distinct().Count(),
                                                                        v.Sum(x => x.QuantityRecovery),
                                                                        v.Sum(x => x.QuantityDisposal),
                                                                        v.Sum(x => x.QuantityUnspec),
                                                                        v.Sum(x => x.QuantityTotal),
                                                                        true));
                                                                        
            //update count in filter
            ResultHazardousWasteRecievingCountry tot = total.SingleOrDefault();
            filter.Count = tot != null ? tot.NumOfFacilities : 0;

            return data.Union(total);
        }



        /// <summary>
        /// gets lamda expression for hazartdous waste receivers for a specific country
        /// </summary>
        /// <param name="filter"></param>
        private static Expression<Func<WASTETRANSFER_HAZARDOUSTREATER, bool>> getHazardousTreatersLambda(WasteTransferSearchFilter filter, string whpCountryCode)
        {
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER_HAZARDOUSTREATER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTreaters(filter, whpCountryCode, param);

            Expression<Func<WASTETRANSFER_HAZARDOUSTREATER, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER_HAZARDOUSTREATER, bool>>(exp, param);
            return lambda;
        }

        /// <summary>
        /// gets lamda expression for hazartdous waste receivers with confidentiality claims
        /// </summary>
        /// <param name="filter"></param>
        /// <param name="onlyConfidential">If true only confidential reportins will be included. Otherise both confidential and non-confidential will be included</param>
        private static Expression<Func<WASTETRANSFER_HAZARDOUSTREATER, bool>> getHazardousTreatersConfidentialLambda(WasteTransferSearchFilter filter, string whpCountryCode)
        {
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER_HAZARDOUSTREATER), "s");

            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTreaters(filter, whpCountryCode, param);
            Expression expConf =  LinqExpressionBuilder.GetEqualsExpr(param, "ConfidentialIndicator", 1);
            exp = LinqExpressionBuilder.CombineAnd(exp, expConf);

            Expression<Func<WASTETRANSFER_HAZARDOUSTREATER, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER_HAZARDOUSTREATER, bool>>(exp, param);
            return lambda;
        }



        public class ResultHazardousWasteTreater
        {
            public ResultHazardousWasteTreater(WASTETRANSFER_HAZARDOUSTREATER datarow)
            {
                FromFacilityName = datarow.FacilityName;
                FacilityConfidentialIndicator = datarow.ConfidentialIndicatorFacility;

                TreaterName = datarow.WHPName;
                TreaterAddress = datarow.WHPAddress;
                TreaterPostalCode = datarow.WHPPostalCode;
                TreaterCity = datarow.WHPCity;
                TreaterCountryCode = datarow.WHPCountryCode;

                TreaterSiteAddress = datarow.WHPSiteAddress;
                TreaterSitePostalCode = datarow.WHPSitePostalCode;
                TreaterSiteCity = datarow.WHPSiteCity;
                TreaterSiteCountryCode = datarow.WHPSiteCountryCode;

                Quantity = datarow.Quantity;
                Unit = datarow.UnitCode;
                Treatment = datarow.WasteTreatmentCode;
                ConfidentialIndicator = datarow.ConfidentialIndicator;
            }

            public string FromFacilityName { get; private set; }
            public bool FacilityConfidentialIndicator { get; private set; }
            public string TreaterName { get; private set; }
            public string TreaterAddress { get; private set; }
            public string TreaterCity { get; private set; }
            public string TreaterPostalCode { get; private set; }
            public string TreaterCountryCode { get; private set; }
            public string TreaterSiteAddress { get; private set; }
            public string TreaterSiteCity { get; private set; }
            public string TreaterSitePostalCode { get; private set; }
            public string TreaterSiteCountryCode { get; private set; }
            public double? Quantity { get; private set; }
            public string Unit { get; private set; }
            public string Treatment { get; private set; }
            public bool ConfidentialIndicator { get; private set; }
        }


        public static object HazardousWasteTreaterList(
           WasteTransferSearchFilter filter,
           string sortColumn,
           bool descending,
           int startRowIndex,
           int pagingSize,
           string whpCountryCode)
        {
            // add dummy rows (pageing)          
            var result = new List<WasteTransfers.ResultHazardousWasteTreater>();
            for (int i = 0; i < startRowIndex; i++)
            {
                result.Add(null);
            }

            // db handler
            var db = getWasteTransferDataContext();

            WasteTransferSearchFilter hazFilter = createHazReceiverFilter(filter);
            Expression<Func<WASTETRANSFER_HAZARDOUSTREATER, bool>> lambda = getHazardousTreatersLambda(hazFilter, whpCountryCode);

            IEnumerable<WASTETRANSFER_HAZARDOUSTREATER> data = db.WASTETRANSFER_HAZARDOUSTREATERs
                .Where(lambda)
                .orderBy(sortColumn, descending);
            
            if (data == null)
            {
                return null;
            }

            int numOfTotalRows = data.Count();

            data = data.Skip(startRowIndex).Take(pagingSize);

            foreach (var dataRow in data)
            {
                result.Add(new ResultHazardousWasteTreater(dataRow));
            }

            // add dummy rows for pageing purposes
            int addcount = result.Count;
            for (int i = 0; i < numOfTotalRows - addcount; i++)
            {
                result.Add(null);
            }

            return result;
        }

        private static WasteTransferSearchFilter createHazReceiverFilter(WasteTransferSearchFilter filter)
        {
            WasteTransferSearchFilter hazFilter = filter.Clone() as WasteTransferSearchFilter;
            hazFilter.WasteTypeFilter = null; //don't search for wastetype

            return hazFilter;
        }
        
        
        /// <summary>
        /// Class for confidentila sub sheet
        /// </summary>
        public class HazardousWasteConfidential
        {
            public HazardousWasteConfidential(string code, int facilities)
            {
                this.Code = code;
                this.Facilities = facilities;
            }
            public int Facilities { get; set; }
            public string Code { get; set; }
        }

        /// <summary>
        /// GetHazardousWasteConfidentialReporting
        /// </summary>
        public static List<HazardousWasteConfidential> GetHazardousWasteConfidentialReporting(WasteTransferSearchFilter filter, string whPCountryCode)
        {
            WasteTransferSearchFilter hazFilter = createHazReceiverFilter(filter);

            Expression<Func<WASTETRANSFER_HAZARDOUSTREATER, bool>> lambda = getHazardousTreatersLambda(hazFilter, whPCountryCode);
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            IEnumerable<WASTETRANSFER_HAZARDOUSTREATER> data = db.WASTETRANSFER_HAZARDOUSTREATERs.Where(lambda);

            // count all facilities
            int wasteAllCount = (from w in data select w.FacilityReportID).Distinct().Count();

            // count all facilities with confidential set to true
            var wasteConf = from w in data where (w.ConfidentialIndicator == true) select w;
            int wasteConfCount = (from w in wasteConf select w.FacilityReportID).Distinct().Count();

            List<HazardousWasteConfidential> final = new List<HazardousWasteConfidential>();
            final.Add(new HazardousWasteConfidential("ContentWastetransfers", wasteAllCount));
            final.Add(new HazardousWasteConfidential("ContentWastetransfersConfidential", wasteConfCount));
            
            return final;
        }

        /// <summary>
        /// GetHazardousWasteConfidentialReason
        /// </summary>
        public static IEnumerable<HazardousWasteConfidential> GetHazardousWasteConfidentialReason(WasteTransferSearchFilter filter, string whpCountryCode)
        {
            WasteTransferSearchFilter hazFilter = createHazReceiverFilter(filter);
            Expression<Func<WASTETRANSFER_HAZARDOUSTREATER, bool>> lambda = getHazardousTreatersLambda(hazFilter,whpCountryCode);
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();

            IEnumerable<HazardousWasteConfidential> reasons = db.WASTETRANSFER_HAZARDOUSTREATERs.Where(lambda)
                                                           .Where(v => v.ConfidentialIndicator)
                                                           .GroupBy(s => s.ConfidentialCode)
                                                           .OrderBy(s => s.Key)
                                                           .Select(s => new HazardousWasteConfidential(
                                                                            s.Key,
                                                                            s.Select(x => x.FacilityReportID).Distinct().Count()));
            return reasons;
        }

        /// <summary>
        /// return true if confidentiality might effect result
        /// </summary>
        public static bool IsHazardousWasteAffectedByConfidentiality(WasteTransferSearchFilter filter, string whpCountryCode)
        {
            WasteTransferSearchFilter hazFilter = createHazReceiverFilter(filter);
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER_HAZARDOUSTREATER), "s");
            Expression<Func<WASTETRANSFER_HAZARDOUSTREATER, bool>> lambda = getHazardousTreatersConfidentialLambda(hazFilter, whpCountryCode);

            return db.WASTETRANSFER_HAZARDOUSTREATERs.Any(lambda);
        }

        #endregion
              
        // ----------------------------------------------------------------------------------
        // Transboundary Hazardous Waste  
        // ----------------------------------------------------------------------------------
        #region TransboundaryHazardousWaste
        
        [Serializable]
        public class TransboundaryHazardousWasteData
        {
            public const string OTHER = "OTH";

            public TransboundaryHazardousWasteData()
            {
            }

            public string TransferTo { get; set; }
            public string TransferFrom { get; set; }
            public double? Total { get; set; }
            public double? Recovery { get; set; }
            public double? Disposal { get; set; }
            public double? UnSpecified { get; set; }
            public int Facilities { get; set; }
            public int Year { get; set; }
            public string Unit { get { return CODE_TNE; } } //waste is always reported in tonnes
        }


        /// <summary>
        /// GetTransferToCountries
        /// Get all reporting countries which will be used as transferto (receiving) countries
        /// </summary>
        public static List<string> GetTransferToCountries()
        {
            IEnumerable<REPORTINGCOUNTRY> countries = ListOfValues.ReportingCountries().OrderBy(x => x.Code);
            List<string> transferTo = new List<string>();
            foreach (REPORTINGCOUNTRY rc in countries)
                transferTo.Add(rc.Code);
            transferTo.Add("OTHER");

            return transferTo;
        }

        /// <summary>
        /// Will return all transboundary reportings aggregated by transferring and receiving country.
        /// </summary>
        /// <param name="aggregateOthers">If true receiving countries outside E-PRTR will be aggreagted - otherwise the will be included seperately.</param>
        /// <returns></returns>
        public static IEnumerable<TransboundaryHazardousWasteData> GetTransboundaryHazardousWasteData(WasteTransferSearchFilter filter, bool aggregateOthers)
        {
            //table only contains waste with type HWOC
            if (!filter.WasteTypeFilter.HazardousWasteTransboundary)
            {
                return new List<TransboundaryHazardousWasteData>();
            }

            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            WasteTransferSearchFilter customFilter = filter.Clone() as WasteTransferSearchFilter;
            customFilter.WasteTypeFilter = null;

            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER_RECEIVINGCOUNTRY), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferSearch(customFilter, param, false);
            Expression<Func<WASTETRANSFER_RECEIVINGCOUNTRY, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER_RECEIVINGCOUNTRY, bool>>(exp, param);


            IEnumerable<TransboundaryHazardousWasteData> result = new List<TransboundaryHazardousWasteData>();

            if (!aggregateOthers)
            {
                result = db.WASTETRANSFER_RECEIVINGCOUNTRies.Where(lambda)
                                                      .GroupBy(v => new { To = v.ReceivingCountryCode, From = v.CountryCode })
                                                      .OrderBy(v => v.Key.To)
                                                      .ThenBy(v => v.Key.From)
                                                      .Select(v => new TransboundaryHazardousWasteData()
                                                      {
                                                          TransferTo = v.Key.To,
                                                          TransferFrom = v.Key.From,
                                                          Total = v.Sum(x => x.QuantityTotal),
                                                          Recovery = v.Sum(x => x.QuantityRecovery),
                                                          Disposal = v.Sum(x => x.QuantityDisposal),
                                                          UnSpecified = v.Sum(x => x.QuantityUnspec),
                                                          Facilities = v.Select(x => x.FacilityReportID).Distinct().Count(),
                                                          Year = filter.YearFilter.Year,
                                                      });

            }
            else
            {

                //find codes for receiving countries that are not E-PRTR reporters.
                IEnumerable<string> otherCountries = ListOfValues.ReceivingCountries()
                                                    .Where(r => !ListOfValues.ReportingCountries().Select(c => c.Code).Contains(r.Code))
                                                    .Select(v => v.Code);

                //aggregate per receiving countries are E-PRTR reporters
                IEnumerable<TransboundaryHazardousWasteData> eprtr = db.WASTETRANSFER_RECEIVINGCOUNTRies.Where(lambda)
                                                    .Where(v => !otherCountries.Contains(v.ReceivingCountryCode))                                 
                                                    .GroupBy(v => new { To = v.ReceivingCountryCode, From = v.CountryCode })
                                                    .OrderBy(v => v.Key.To)
                                                    .ThenBy(v => v.Key.From)
                                                    .Select(v => new TransboundaryHazardousWasteData()
                                                    {
                                                        TransferTo = v.Key.To,
                                                        TransferFrom = v.Key.From,
                                                        Total = v.Sum(x => x.QuantityTotal),
                                                        Recovery = v.Sum(x => x.QuantityRecovery),
                                                        Disposal = v.Sum(x => x.QuantityDisposal),
                                                        UnSpecified = v.Sum(x => x.QuantityUnspec),
                                                        Facilities = v.Select(x => x.FacilityReportID).Distinct().Count(),
                                                        Year = filter.YearFilter.Year,
                                                    });

                //aggregate all receiving countries are not E-PRTR reporter as one. Include confidential receivers (i.e. receving cod is null)
                IEnumerable<TransboundaryHazardousWasteData> other = db.WASTETRANSFER_RECEIVINGCOUNTRies.Where(lambda)
                                                    .Where(c => otherCountries.Contains(c.ReceivingCountryCode) || c.ReceivingCountryCode.Equals(null))
                                                    .GroupBy(v => new {From = v.CountryCode })
                                                    .OrderBy(v => v.Key.From)
                                                    .Select(v => new TransboundaryHazardousWasteData()
                                                    {
                                                        TransferTo = TransboundaryHazardousWasteData.OTHER,
                                                        TransferFrom = v.Key.From,
                                                        Total = v.Sum(x => x.QuantityTotal),
                                                        Recovery = v.Sum(x => x.QuantityRecovery),
                                                        Disposal = v.Sum(x => x.QuantityDisposal),
                                                        UnSpecified = v.Sum(x => x.QuantityUnspec),
                                                        Facilities = v.Select(x => x.FacilityReportID).Distinct().Count(),
                                                        Year = filter.YearFilter.Year,
                                                    });


                result = eprtr.Union(other);
            }

            return result;

        }


       #endregion

        // ----------------------------------------------------------------------------------
        // Confidential
        // ----------------------------------------------------------------------------------
        #region Confidential
                
        public class FacilityCountObject
        {
            internal FacilityCountObject()
            {
            }
            public FacilityCountObject(string desc, int nonhw, int hwic, int hwoc)
            {
                this.Desc = desc;
                this.NONHW = nonhw;
                this.HWIC = hwic;
                this.HWOC = hwoc;
            }

            public string Desc { get; internal set; }
            public int? NONHW { get; internal set; }
            public int? HWIC { get; internal set; }
            public int? HWOC { get; internal set; }
            public int? Total { get; internal set; }
        }

        /// <summary>
        /// Returns the number of facilities corresponding to the filter, per waste type
        /// </summary>
        public static FacilityCountObject GetFacilityCounts(WasteTransferSearchFilter filter)
        {
            
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER_TREATMENT), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferSearch(filter, param, true);
            Expression<Func<WASTETRANSFER_TREATMENT, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER_TREATMENT, bool>>(exp, param);

            return GetFacilityCounts(lambda);
 
        }

        internal static FacilityCountObject GetFacilityCounts(Expression<Func<WASTETRANSFER_TREATMENT, bool>> lambda)
        {
            var db = getWasteTransferDataContext();

            //count per waste type
            var countsType = db.WASTETRANSFER_TREATMENTs.Where(lambda)
                        .GroupBy(v => v.WasteTypeCode)
                        .Select(v => new
                        {
                            WasteType = v.Key,
                            Facilities = v.Select(y => y.FacilityID).Distinct().Count()
                        });

            //count total
            var countsTotal = db.WASTETRANSFER_TREATMENTs.Where(lambda)
                        .GroupBy(v => 1)
                        .Select(v => new
                        {
                            WasteType = "TOTAL",
                            Facilities = v.Select(y => y.FacilityID).Distinct().Count()
                        });

            var counts = countsType.Union(countsTotal).ToList();

            var nonhw = counts.SingleOrDefault(x => x.WasteType == CODE_NONHW);
            var hwic = counts.SingleOrDefault(x => x.WasteType == CODE_HWIC);
            var hwoc = counts.SingleOrDefault(x => x.WasteType == CODE_HWOC);
            var total = counts.SingleOrDefault(x => x.WasteType == "TOTAL");

            FacilityCountObject count = new FacilityCountObject();
            count.Desc = "WasteTransfers"; //will be used as key in resources
            count.NONHW = nonhw != null ? nonhw.Facilities : (int?)null;
            count.HWIC = hwic != null ? hwic.Facilities : (int?)null;
            count.HWOC = hwoc != null ? hwoc.Facilities : (int?)null;
            count.Total = total != null ? total.Facilities : (int?)null;

            return count;

        }
        /// <summary>
        /// Will return a list of countings of all facilities reporting togehter with facilities reporting confidnetiality.
        /// </summary>
        /// <param name="filter"></param>
        /// <returns></returns>
        public static List<FacilityCountObject> GetCountConfidentialFacilities(WasteTransferSearchFilter filter)
        {
            List<FacilityCountObject> final = new List<FacilityCountObject>();

            //First add all facilities reporting
            FacilityCountObject countAll = GetFacilityCounts(filter);
            final.Add(countAll);

            //Then add confidential reportings
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER_CONFIDENTIAL), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferSearch(filter, param, true);
            Expression<Func<WASTETRANSFER_CONFIDENTIAL, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER_CONFIDENTIAL, bool>>(exp, param);

            //table has one row per facility per wastetype so distinct is needed

            //count per waste type
            var countsAll = db.WASTETRANSFER_CONFIDENTIALs.Where(lambda)
                        .GroupBy(v => v.WasteTypeCode)
                        .Select(v => new
                        {
                            WasteType = v.Key,
                            Facilities = v.Select(x => x.FacilityReportID).Distinct().Count() });

            //count total
            var countsTotal = db.WASTETRANSFER_CONFIDENTIALs.Where(lambda)
                                    .GroupBy(v => 1)
                                    .Select(v => new
                                    {
                                        WasteType = "TOTAL",
                                        Facilities = v.Select(x => x.FacilityReportID).Distinct().Count() });

            var counts = countsAll.Union(countsTotal).ToList();

            var nonhw = counts.SingleOrDefault(x => x.WasteType == CODE_NONHW);
            var hwic = counts.SingleOrDefault(x => x.WasteType == CODE_HWIC);
            var hwoc = counts.SingleOrDefault(x => x.WasteType == CODE_HWOC);
            var total = counts.SingleOrDefault(x => x.WasteType == "TOTAL");

            FacilityCountObject count = new FacilityCountObject();
            count.Desc = "WasteTransfersConfidentiality"; //will be used as key in resources
            count.NONHW = nonhw != null ? nonhw.Facilities : (int?)null;
            count.HWIC = hwic != null ? hwic.Facilities : (int?)null;
            count.HWOC = hwoc != null ? hwoc.Facilities : (int?)null;
            count.Total = total != null ? total.Facilities : (int?)null;

            final.Add(count);
            return final;
        }


        public class WasteConfidentialReason
        {
            public WasteConfidentialReason(string wasteTypeCode, string reasonCode, int facilities)
            {
                this.WasteTypeCode = wasteTypeCode;
                this.ReasonCode = reasonCode;
                this.Facilities = facilities;
            }

            public int Facilities { get; set; }
            public string WasteTypeCode { get; set; }
            public string ReasonCode { get; set; }
        }


        public static IEnumerable<WasteConfidentialReason> GetWasteConfidentialReason(WasteTransferSearchFilter filter)
        {
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER_CONFIDENTIAL), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferSearch(filter, param, true);
            Expression<Func<WASTETRANSFER_CONFIDENTIAL, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER_CONFIDENTIAL, bool>>(exp, param);

            //multiple rows per facility, so distinct is needed. 
            IEnumerable<WasteConfidentialReason> reasons = db.WASTETRANSFER_CONFIDENTIALs.Where(lambda)
                                                           .GroupBy(s => new { s.WasteTypeCode, s.ConfidentialCode})
                                                           .OrderBy(s => s.Key.WasteTypeCode)
                                                           .ThenBy(s => s.Key.ConfidentialCode)
                                                           .Select(s => new WasteConfidentialReason(
                                                                            s.Key.WasteTypeCode,
                                                                            s.Key.ConfidentialCode,
                                                                            s.Select(x => x.FacilityReportID).Distinct().Count()));
            return reasons;
        }

        /// <summary>
        /// return true if confidentiality might effect result
        /// </summary>
        public static bool IsAffectedByConfidentiality(WasteTransferSearchFilter filter)
        {
            DataClassesWasteTransferDataContext db = getWasteTransferDataContext();
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferConfidentialSearch(filter, param, false);
            Expression<Func<WASTETRANSFER, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER, bool>>(exp, param);

            return db.WASTETRANSFERs.Any(lambda);
        }

        
        
        #endregion

        // ----------------------------------------------------------------------------------
        // Map filters
        // ----------------------------------------------------------------------------------
        #region Map
        /// <summary>
        /// returns the MapFilter (sql and sectors) corresponding to the filter. The map always uses the WASTETRANSFER table for lookup
        /// </summary>
        public static MapFilter GetMapFilter(WasteTransferSearchFilter filter)
        {
            MapFilter mapFilter = new MapFilter();
            ParameterExpression paramMap = Expression.Parameter(typeof(WASTETRANSFER), "s");
            Expression expMap = LinqExpressionBuilder.GetLinqExpressionWasteTransferSearch(filter, paramMap, false);
            mapFilter.SqlWhere = LinqExpressionBuilder.GetSQL(expMap, paramMap);
            mapFilter.SetLayers(filter.ActivityFilter);

            return mapFilter;
        }

        #endregion

		#region Data context
		private static DataClassesWasteTransferDataContext getWasteTransferDataContext()
		{
			DataClassesWasteTransferDataContext db = new DataClassesWasteTransferDataContext();
			db.Log = new DebuggerWriter();
			return db;
		}
		#endregion
    }
}