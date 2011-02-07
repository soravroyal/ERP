using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;

using QueryLayer.Filters;
using QueryLayer.LinqFramework;
using QueryLayer.Utilities;
using QueryLayer.Enums;

namespace QueryLayer
{
    /// <summary>
    /// Holds methods to collect data for the Pollutant transfer search
    /// </summary>
    public static class PollutantTransfers
    {
        static string CODE_KG = EnumUtil.GetStringValue(QuantityUnit.Kilo);
       // static string CODE_TNE = EnumUtil.GetStringValue(QuantityUnit.Tonnes);

        /// <summary>
        /// Class for pollutant activity/area data row
        /// </summary>
        [Serializable]
        public class TransfersTreeListRow : TreeListRow, PollutantTransferRow
        {
            private int facilities;
            private double quantity;
            private string unit;

            public TransfersTreeListRow(string code, string parentCode, int facilities, double quantity, int level, bool hasChildren):base(code, parentCode,level, hasChildren)
            {
                this.facilities = facilities;
                this.quantity = quantity;
                this.unit = CODE_KG;
                //this.unit = CODE_TNE;
            }

            /// <summary>
            /// Returns the number of facilities
            /// </summary>
            public int Facilities { 
                get { return this.facilities; }
                set { this.facilities = value; }
            }
            public double Quantity { get { return this.quantity; } }
            public string Unit { get { return this.unit; } }
        }

        

        // ----------------------------------------------------------------------------------
        // Summery
        // ----------------------------------------------------------------------------------
        #region summery

        /// <summary>
        /// Summery
        /// </summary>
        public static List<Summary.Quantity> Summery(PollutantTransfersSearchFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();

            // apply filter
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfers(filter, param);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);
            var summeryFiltered = db.POLLUTANTTRANSFERs.Where(lambda);

            var summery0 = from s in summeryFiltered select new { s.IAActivityCode, s.Quantity };
            var summery1 = from s in summery0 group s by new { s.IAActivityCode };
            var summery2 = from s in summery1
                          select new
                          {
                              code = s.Select(x => x.IAActivityCode).First(),
                              count = s.Count(),
                              sumQuantity = s.Sum(x => x.Quantity)
                          };

            double total = 0;
            filter.Count = 0;
            
            List<Summary.Quantity> final = new List<Summary.Quantity>();
            foreach (var v in summery2)
            {
                if (v.sumQuantity > 0)
                {
                    final.Add(new Summary.Quantity(v.code, v.sumQuantity));
                    total += v.sumQuantity;
                    filter.Count += v.count;
                }
            }

            // Get top 10 list, sorted by quantity
            final = Summary.GetTop10(final, total);
            return final;
        }

        #endregion

        // ----------------------------------------------------------------------------------
        // Area lists
        // ----------------------------------------------------------------------------------
        #region activity

        /// <summary>
        /// Class for pollutant activity data row
        /// </summary>
        [Serializable]
        public class ActivityTreeListRow : QueryLayer.Utilities.ActivityTreeListRow, PollutantTransferRow
        {
            public ActivityTreeListRow(string sectorCode, string activityCode, string subActivityCode,
                          string pollutantCode,  
                          int facilities, 
                          double quantity, 
                          bool hasChildren)
                : base(sectorCode, activityCode, subActivityCode, hasChildren)
            {
                this.PollutantCode = pollutantCode;
                this.Facilities = facilities;
                this.Quantity = quantity;
                this.Unit = CODE_KG;
                //this.Unit = CODE_TNE;

            }

            /// <summary>
            /// Returns the number of facilities
            /// </summary>
            public int Facilities{ get; internal set; }
            public string PollutantCode { get; private set; }
            public double Quantity { get; private set; }
            public string Unit { get; private set; }
        }

        public interface PollutantTransferRow
        {
            int Facilities {get;}
            double Quantity { get;}
            string Unit { get;}
        }


        /// <summary>
        /// get lambda for pollutant transfers
        /// </summary>
        private static Expression<Func<POLLUTANTTRANSFER, bool>> getActivityAreaLambda(PollutantTransfersSearchFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfers(filter, param);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);
            return lambda;
        }
                
        /// <summary>
        /// Returns the number of facilities corresponding to the filter. Always use POLLUTANTTRANSFER table, since it has the fewest records.
        /// </summary>
        public static int GetFacilityCount(PollutantTransfersSearchFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfers(filter, param);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);

            //find total no. of facilities. 
            int count = db.POLLUTANTTRANSFERs
                                .Where(lambda)
                                .Select<POLLUTANTTRANSFER, int>(d => (int)d.FacilityReportID).Distinct()
                                .Count();

            return count;
        }

        /// <summary>
        /// return full activity tree with all rows expanded
        /// </summary>
        public static IEnumerable<ActivityTreeListRow> GetActivityTree(PollutantTransfersSearchFilter filter)
        {
            IEnumerable<ActivityTreeListRow> sectors = GetSectors(filter).ToList();

            List<string> sectorCodes = sectors.Where(p => p.HasChildren).Select(p => p.SectorCode).ToList();
            IEnumerable<ActivityTreeListRow> activities = GetActivities(filter, sectorCodes).ToList();

            List<string> activityCodes = activities.Where(p => p.HasChildren).Select(p => p.ActivityCode).ToList();
            IEnumerable<ActivityTreeListRow> subactivities = GetSubActivities(filter, activityCodes).ToList();

            //create result with full tree
            IEnumerable<ActivityTreeListRow> result = sectors.Union(activities).Union(subactivities)
                                                               .OrderBy(s => s.SectorCode)
                                                               .ThenBy(s => s.ActivityCode)
                                                               .ThenBy(s => s.SubactivityCode);

            return result;
        }



        /// <summary>
        /// return all sectors that fullfill search criteria
        /// </summary>
        public static IEnumerable<ActivityTreeListRow> GetSectors(PollutantTransfersSearchFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = getActivityAreaLambda(filter);


            //find data for sector level. Sector level always has children.
            IEnumerable<ActivityTreeListRow> sectors = db.POLLUTANTTRANSFERs.Where(lambda)
                                                     .GroupBy(p => new { SectorCode = p.IASectorCode, PollutantCode = p.PollutantCode })
                                                     .Select(x => new ActivityTreeListRow(
                                                         x.Key.SectorCode,
                                                         null,
                                                         null,
                                                         x.Key.PollutantCode,
                                                         x.Count(),
                                                         x.Sum(p => p.Quantity),
                                                         true));


            List<ActivityTreeListRow> result = sectors.ToList(); //make sure sql is executed now to do it only once

            List<ActivityTreeListRow> totals = result.GroupBy(p => new { PollutantCode = p.PollutantCode })
                                             .Select(x => new ActivityTreeListRow(
                                                 ActivityTreeListRow.CODE_TOTAL,
                                                 null,
                                                 null,
                                                 x.Key.PollutantCode,
                                                 x.Sum(p => p.Facilities),
                                                 x.Sum(p => p.Quantity),
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
        /// </summary>
        public static IEnumerable<ActivityTreeListRow> GetActivities(PollutantTransfersSearchFilter filter, List<string> sectorCodes)
        {
            if (sectorCodes != null && sectorCodes.Count() == 0)
                return new List<ActivityTreeListRow>();

            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = getActivityAreaLambda(filter);

            if (sectorCodes != null)
            {
                ParameterExpression param = lambda.Parameters[0];
                Expression sectorExp = LinqExpressionBuilder.GetInExpr(param, "IASectorCode", sectorCodes);

                Expression exp = LinqExpressionBuilder.CombineAnd(lambda.Body, sectorExp);
                lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);
            }

            //find data for activity level
            IEnumerable<ActivityTreeListRow> activities = db.POLLUTANTTRANSFERs.Where(lambda)
                                         .GroupBy(p => new { SectorCode = p.IASectorCode, ActivityCode = p.IAActivityCode, PollutantCode = p.PollutantCode })
                                         .Select(x => new ActivityTreeListRow(
                                             x.Key.SectorCode,
                                             x.Key.ActivityCode,
                                             null,
                                             x.Key.PollutantCode,
                                             x.Count(),
                                             x.Sum(p => p.Quantity),
                                             x.First(p => !p.IASubActivityCode.Equals(null)) != null));

            return activities;
        }

        /// <summary>
        /// Return all subactivities (level 2) that fullfill search criteria. 
        /// If activityCodes are null, all activities will be returned. If activityCodes is empty no activities will be returned.
        /// Notice that this will include one subactivity "Not specified on this level" for each activity, even if the activity do not have any subactivities at all!
        /// </summary>
        public static IEnumerable<ActivityTreeListRow> GetSubActivities(PollutantTransfersSearchFilter filter, List<string> activityCodes)
        {
            if (activityCodes != null && activityCodes.Count() == 0)
                return new List<ActivityTreeListRow>();

            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = getActivityAreaLambda(filter);

            //add activities to expression
            if (activityCodes != null)
            {
                ParameterExpression param = lambda.Parameters[0];
                Expression activityExp = LinqExpressionBuilder.GetInExpr(param, "IAActivityCode", activityCodes);

                Expression exp = LinqExpressionBuilder.CombineAnd(lambda.Body, activityExp);
                lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);
            }

            //find data for sub-activity level, this level never has children.
            IEnumerable<ActivityTreeListRow> subactivities = db.POLLUTANTTRANSFERs.Where(lambda)
                                                                 .GroupBy(p => new { SectorCode = p.IASectorCode, ActivityCode = p.IAActivityCode, SubActivityCode = p.IASubActivityCode, PollutantCode = p.PollutantCode })
                                                                 .Select(x => new ActivityTreeListRow(
                                                                     x.Key.SectorCode,
                                                                     x.Key.ActivityCode,
                                                                     !x.Key.SubActivityCode.Equals(null) ? x.Key.SubActivityCode : ActivityTreeListRow.CODE_UNSPECIFIED,
                                                                     x.Key.PollutantCode,
                                                                     x.Count(),
                                                                     x.Sum(p => p.Quantity),
                                                                     false));

            return subactivities;
        }



        /// <summary>
        /// Find all reported pollutant codes fullfilling the filter
        /// </summary>
        public static List<string> GetPollutantCodes(PollutantTransfersSearchFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = getActivityAreaLambda(filter);

            //distinct pollutants
            List<string> codes = db.POLLUTANTTRANSFERs.Where(lambda)
                                    .Select(r => r.PollutantCode).Distinct().ToList();

            return codes;
        }

        #endregion
        
        // ----------------------------------------------------------------------------------
        // Areas
        // ----------------------------------------------------------------------------------
        #region Areas

        /// <summary>
        /// get areas
        /// </summary>
        private static List<TransfersTreeListRow> getAreas(DataClassesPollutantTransferDataContext db, Expression<Func<POLLUTANTTRANSFER, bool>> lambda, out int facilitiesCount)
        {
            int level = 0;
            bool hasChildren = true; //country level always has children.

            //The parent code is set to the code itself on grounds of later sorting.
            IEnumerable<TransfersTreeListRow> data = db.POLLUTANTTRANSFERs.Where(lambda)
                                                     .GroupBy(p => p.CountryCode)
                                                     .OrderBy(x => x.Key)
                                                     .Select(x => new TransfersTreeListRow(
                                                         x.Key,
                                                         x.Key,
                                                         x.Count(),
                                                         x.Sum(p => p.Quantity),
                                                         level,
                                                         hasChildren));

            List<TransfersTreeListRow> result = data.ToList(); //make sure sql is executed now.

            //Calculate total. Facilities can be summed, since each facility is only included in one row (=country)
            TransfersTreeListRow total = result.GroupBy(p => 1)
                                         .Select(x => new TransfersTreeListRow(
                                             TransfersTreeListRow.CODE_TOTAL,
                                             null,
                                             x.Sum(p => p.Facilities),
                                             x.Sum(p => p.Quantity),
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
        /// get sub areas
        /// </summary>
        private static List<TransfersTreeListRow> getSubAreas(DataClassesPollutantTransferDataContext db, string countryCode, Expression<Func<POLLUTANTTRANSFER, bool>> lambda, AreaFilter.RegionType regionType)
        {
            int level = 1;
            bool hasChildren = false; //subarea level never has children.
            string code_unknown = regionType == AreaFilter.RegionType.RiverBasinDistrict ? TreeListRow.CODE_UNKNOWN : null;

            IEnumerable<TransfersTreeListRow> data = db.POLLUTANTTRANSFERs.Where(lambda).Where(p => p.CountryCode == countryCode)
                                         .GroupBy(regionType)
                                         .OrderBy(x => x.Key.Code.Equals(code_unknown))
                                         .ThenBy(x => x.Key.Code)
                                         .Select(x => new TransfersTreeListRow(
                                             !x.Key.Code.Equals(null) ? x.Key.Code : TransfersTreeListRow.CODE_UNKNOWN,
                                             x.Key.ParentCode,
                                             x.Count(),
                                             x.Sum(p => p.Quantity),
                                             level,
                                             hasChildren));

            List<TransfersTreeListRow> result = data.ToList();

            return result;
        }

        /// <summary>
        /// return total list of areas
        /// </summary>
        public static List<TransfersTreeListRow> GetArea(PollutantTransfersSearchFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = getActivityAreaLambda(filter);
            int facilitiesCount = 0;
            List<TransfersTreeListRow> areas = getAreas(db, lambda, out facilitiesCount);
            filter.Count = facilitiesCount;
            return areas;
        }
        
        /// <summary>
        /// return expanded tree according to expandrows input
        /// </summary>
        public static List<TransfersTreeListRow> GetAreaTree(Dictionary<string, bool> expandRows, PollutantTransfersSearchFilter filter, List<TransfersTreeListRow> areasOrg)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = getActivityAreaLambda(filter);

            // only fill areas from db if areasOrg==null
            List<TransfersTreeListRow> areas = null;
            if (areasOrg != null)
            {
                areas = new List<TransfersTreeListRow>();
                areas.AddRange(areasOrg);
            }
            else
            {
                int facilitiesCount = 0;
                areas = getAreas(db, lambda, out facilitiesCount);
                filter.Count = facilitiesCount;
            }

            foreach (TransfersTreeListRow s in areas)
            {
                s.IsExpanded = false;
            }

            // loop through expand list
            foreach (KeyValuePair<string, bool> kvp in expandRows)
            {
                // if not expanded goto next
                if (!kvp.Value) continue;

                // expanded, find in list (search all nodes)
                int row = 0;
                foreach (TransfersTreeListRow s in areas)
                {
                    string code = (s.Code != null) ? s.Code.ToString() : String.Empty;
                    if (code == kvp.Key)
                    {
                        s.IsExpanded = true;
                        // find sub area
                        List<TransfersTreeListRow> activities = getSubAreas(db, code, lambda, filter.AreaFilter.TypeRegion);
                        // insert area
                        foreach (TransfersTreeListRow a in activities)
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
            public AreaComparison(string areacode, double quantity, int facilities)
            {
                this.Area = areacode;
                this.Quantity = quantity;
                this.Percent = 0;
                this.Facilities = facilities;
            }

            public string Area { get; set; }
            public double Quantity { get; private set; }
            public double Percent { get; internal set; }
            public int Facilities { get; private set; }
        }

        /// <summary>
        /// GetAreaComparison
        /// </summary>
        public static List<AreaComparison> GetAreaComparison(PollutantTransfersSearchFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            
            // apply filter
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfers(filter, param);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);

            AreaFilter areaFilter = filter.AreaFilter;

            IEnumerable<AreaComparison> data = db.POLLUTANTTRANSFERs.Where(lambda)
                                         .GroupBy(areaFilter)
                                         .Select(x => new AreaComparison(
                                             x.Key.Code,
                                             x.Sum(p => p.Quantity),
                                             x.Count()));

            //Make sure sql is executed now and ordered by size
            List<AreaComparison> result = data.OrderBy(p => p.Quantity).ToList();

            //Calculate percentages
            double tot = result.Sum(p => p.Quantity);
            if (tot > 0)
            {
                foreach (AreaComparison ac in result)
                    ac.Percent = (ac.Quantity / tot) * 100.0;
            }

            return result;

        }
        #endregion

        // ----------------------------------------------------------------------------------
        // Facilities
        // ----------------------------------------------------------------------------------
        #region Facilities

        /// <summary>
        /// Class fpr facility data row
        /// </summary>
        public class ResultFacility
        {
            public string ActivityCode {get; private set; }
            public string FacilityName { get; private set; }
            public double Quantity { get; private set; }
            public string CountryCode { get; private set; }
            public int FacilityReportId { get; private set; }
            public QuantityUnit QuantityUnit { get; private set; }
            public bool ConfidentialIndicator { get; private set; }
            public bool ConfidentialIndicatorFacility { get; private set; }

            // Only used with CSV download
            public int FacilityId { get; private set; }
            public string Url { get; set; }

            public ResultFacility(string activityCode, string name, double quantity, string countryCode, int facilityReportId, QuantityUnit quantityUnit, bool confidentialIndicatorFacility, bool confidentialIndicator, int facilityId)
            {
                ActivityCode = activityCode;
                FacilityName = name;
                Quantity = quantity;
                CountryCode = countryCode;
                FacilityReportId = facilityReportId;
                QuantityUnit = quantityUnit;
                ConfidentialIndicatorFacility = confidentialIndicatorFacility;
                ConfidentialIndicator = confidentialIndicator;
                FacilityId = facilityId;
            }
        }

        public class ResultFacilityCSV : ResultFacility
        {
            // public properties
            public int FacilityId { get; private set; }
            public string MethodBasisCode { get; private set; }
            public string MethodTypeCode { get; private set; }
            public string MethodDesignation { get; private set; }
            public string Url;

            public ResultFacilityCSV(string activityCode, string name, double quantity, string countryCode, int facilityReportId, QuantityUnit quantityUnit, bool confidentialIndicatorFacility, bool confidentialIndicator, int facilityId, string methodBasisCode, string methodTypeCode, String methodDesignation) :
                base(activityCode,name, quantity,countryCode,facilityReportId, quantityUnit, confidentialIndicatorFacility,confidentialIndicator, facilityId)
            {
                this.MethodBasisCode = methodBasisCode;
                this.MethodTypeCode = methodTypeCode;
                this.MethodDesignation = methodDesignation;
            }

        }



        /// <summary>
        /// Generates facility list for Pollutant Transfer search results
        /// </summary>
        /// <param name="filter">Holds the search criteria</param>
        /// <param name="sortColumn">Specifies the column used for sorting</param>
        /// <param name="descending">Indicate whether sorting is descending</param>
        /// <param name="startRowIndex">Starting index for paging</param>
        /// <param name="p"></param>
        /// <returns></returns>
        public static object FacilityList(PollutantTransfersSearchFilter filter, string sortColumn, bool descending, int startRowIndex, int pagingSize)
        {
            // add rows (pageing)          
            List<PollutantTransfers.ResultFacility> result = new List<PollutantTransfers.ResultFacility>();
            for (int i = 0; i < startRowIndex; i++)
                result.Add(null);

            // create expression
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfers(filter, param);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);
            
            // apply lambda
            IEnumerable<POLLUTANTTRANSFER> data = db.POLLUTANTTRANSFERs.Where(lambda).orderBy(sortColumn, descending); 
            
            // set the number of found rows for this filter
            filter.Count = data.Count();
            data = data.Skip(startRowIndex).Take(pagingSize);
            
            // default unit for Pollutant Transfers
            foreach (var v in data)
            {
                QuantityUnit unit = (v.UnitCode == QuantityUnit.Tonnes.ToString()) ? QuantityUnit.Tonnes : QuantityUnit.Kilo;
                result.Add(new PollutantTransfers.ResultFacility(
                    v.IAActivityCode, 
                    v.FacilityName, 
                    v.Quantity, 
                    v.CountryCode, 
                    v.FacilityReportID, 
                    unit, 
                    v.ConfidentialIndicatorFacility, 
                    v.ConfidentialIndicator,
                    v.FacilityID));
            }

            // add rows (pageing)          
            int addcount = result.Count;
            for (int i = 0; i < filter.Count - addcount; i++)
                result.Add(null);

            return result;
        }
        #endregion

        // ----------------------------------------------------------------------------------
        // Facilities - CSV
        // ----------------------------------------------------------------------------------
        #region Facilities - CSV
        public static IEnumerable<PollutantTransfers.ResultFacilityCSV> GetFacilityListCSV(PollutantTransfersSearchFilter filter)
        {
            List<PollutantTransfers.ResultFacilityCSV> result = new List<PollutantTransfers.ResultFacilityCSV>();

            // create expression
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfers(filter, param);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);

            // apply lambda
            var data = db.POLLUTANTTRANSFERs.Where(lambda).OrderBy(x => x.FacilityName);

            // default unit for Pollutant Transfers
            foreach (var v in data)
            {
                QuantityUnit unit = (v.UnitCode == QuantityUnit.Tonnes.ToString()) ? QuantityUnit.Tonnes : QuantityUnit.Kilo;
                var row = new PollutantTransfers.ResultFacilityCSV(
                    v.IAActivityCode, 
                    v.FacilityName, 
                    v.Quantity, 
                    v.CountryCode, 
                    v.FacilityReportID, 
                    unit, 
                    v.ConfidentialIndicatorFacility,
                    v.ConfidentialIndicator,
                    v.FacilityID,
                    v.MethodCode,
                    v.MethodTypeCode,
                    v.MethodTypeDesignation);
                
                result.Add(row);
            }

            return result;
        }
        #endregion Facilities - CSV

        // ----------------------------------------------------------------------------------
        // Confidential
        // ----------------------------------------------------------------------------------
        #region Confidential

        public class TransfersConfidentialRow
        {
            private string code;
            private int facilities;

            public TransfersConfidentialRow(string code, int facilities)
            {
                this.facilities = facilities;
                this.code = code;
            }

            public string Code { get { return this.code; } }
            public int Facilities { get { return this.facilities; } }
        }
        

        /// <summary>
        /// return total list confidential pollutants
        /// </summary>
        public static IEnumerable<TransfersConfidentialRow> GetConfidentialPollutant(PollutantTransfersSearchFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();

            // apply filter for confidential, include pollutants
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfersConfidential(filter, param, true);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);
            
            // sum up facilities
            var pollutant0 = db.POLLUTANTTRANSFERs.Where(lambda);
            var pollutant1 = from p in pollutant0 group p by new { p.PollutantCode };
            var pollutant2 = from p in pollutant1 
                       select new
                       {
                           code = p.Select(x => x.PollutantCode).First(),
                           count = p.Count()
                       };

            // build result
            List<TransfersConfidentialRow> result = new List<TransfersConfidentialRow>();
            foreach (var v in pollutant2)
                result.Add(new TransfersConfidentialRow(v.code, v.count));
            return result;
        }


        /// <summary>
        /// return total list confidential reasons
        /// </summary>
        public static IEnumerable<TransfersConfidentialRow> GetConfidentialReason(PollutantTransfersSearchFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();

            // apply filter for confidential, do not include the pollutant itself
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfersConfidential(filter, param, false);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);

            var reason0 = db.POLLUTANTTRANSFERs.Where(lambda);
            var reason1 = from p in reason0 group p by new { p.ConfidentialCode };
            var reason2 = from p in reason1
                       select new
                       {
                           code = p.Select(x => x.ConfidentialCode).First(),
                           count = p.Count()
                       };
            
            // build result
            List<TransfersConfidentialRow> result = new List<TransfersConfidentialRow>();
            foreach (var v in reason2)
                result.Add(new TransfersConfidentialRow(v.code, v.count));
            return result.OrderBy(x => x.Code);
        }


        /// <summary>
        /// return true if confidentiality might effect result
        /// </summary>
        public static bool IsAffectedByConfidentiality(PollutantTransfersSearchFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();

            // apply filter for confidential, do not include the pollutant itself
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfersConfidential(filter, param, false);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);

            return db.POLLUTANTTRANSFERs.Any(lambda);
        }

        #endregion

        // ----------------------------------------------------------------------------------
        // Map filters
        // ----------------------------------------------------------------------------------
        #region Map

        /// <summary>
        /// returns the MapFilter (sql and layers) corresponding to the filter. 
        /// </summary>
        public static MapFilter GetMapFilter(PollutantTransfersSearchFilter filter)
        {
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfers(filter, param);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);

            // create sql and sectors to map
            MapFilter mapFilter = new MapFilter();
            mapFilter.SqlWhere = LinqExpressionBuilder.GetSQL(exp, param);
            mapFilter.SetLayers(filter.ActivityFilter);

            return mapFilter;
        }
        #endregion

        #region Data context
        private static DataClassesPollutantTransferDataContext getPollutantTransferDataContext()
		{
			DataClassesPollutantTransferDataContext db = new DataClassesPollutantTransferDataContext();
			db.Log = new DebuggerWriter();
			return db;
		}
		#endregion
    }
}
