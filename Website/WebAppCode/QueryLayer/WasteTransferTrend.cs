using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using LinqUtilities;
using QueryLayer.Enums;
using QueryLayer.Filters;
using QueryLayer.LinqFramework;
using QueryLayer.Utilities;

namespace QueryLayer
{
    /// <summary>
    /// Methods for collectiong data for Waste transfer trends
    /// </summary>
    public static class WasteTransferTrend
    {
        public static string CODE_TNE = EnumUtil.GetStringValue(QuantityUnit.Tonnes);

        // ---------------------------------------------------------------------------------------------------
        // Count method 
        // ---------------------------------------------------------------------------------------------------
        #region count
        /// <summary>
        /// Returns the number of facilities corresponding to the filter, per waste type
        /// Overloaded with TimeSeries filter for ease of use.
        /// </summary>
        public static QueryLayer.WasteTransfers.FacilityCountObject GetCountFacilities(WasteTransferTimeSeriesFilter tsFilter)
        {
            // conversion removes all year span information
            var filter = FilterConverter.ConvertToWasteTransferSearchFilter(tsFilter);

            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER_TREATMENT), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferSearch(filter, param, true);

            // Exclude EPER reporting years
            Expression prop = Expression.Property(param, "ReportingYear");
            Expression val = Expression.Constant(2007);
            Expression yearExp = Expression.GreaterThanOrEqual(prop, val);

            exp = Expression.AndAlso(yearExp, exp);

            Expression<Func<WASTETRANSFER_TREATMENT, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER_TREATMENT, bool>>(exp, param);

            return WasteTransfers.GetFacilityCounts(lambda);
        }
        #endregion

        // ---------------------------------------------------------------------------------------------------
        // Time series
        // ---------------------------------------------------------------------------------------------------
        #region timeseries

        /// <summary>
        /// return timeseries
        /// </summary>
        public static List<TimeSeriesClasses.WasteTransfer> GetTimeSeries(WasteTransferTimeSeriesFilter filter, WasteTypeFilter.Type wastetype)
        {
            DataClassesWasteTransferDataContext db = getDataContext();

            // apply filter
            Expression<Func<WASTETRANSFER, bool>> lambda = getLambdaExpression(filter, wastetype);

            // get data and group by year (which get assigned to x.Key by link)
            IQueryable<IGrouping<int, WASTETRANSFER>> group = db.WASTETRANSFERs.Where(lambda).GroupBy(p => p.ReportingYear).OrderBy(p => p.Key);

            // lookup wastetype. Table has only one row per faciltiy report
            IEnumerable<TimeSeriesClasses.WasteTransfer> data = null;
            switch (wastetype)
            {
                case WasteTypeFilter.Type.HazardousCountry:
                    data = group.Select(x => new TimeSeriesClasses.WasteTransfer(x.Key, x.Count(), WasteTypeFilter.Type.HazardousCountry, x.Sum(p => p.QuantityTotalHWIC), x.Sum(p => p.QuantityRecoveryHWIC), x.Sum(p => p.QuantityDisposalHWIC), x.Sum(p => p.QuantityUnspecHWIC)));
                    break;
                case WasteTypeFilter.Type.HazardousTransboundary:
                    data = group.Select(x => new TimeSeriesClasses.WasteTransfer(x.Key, x.Count(), WasteTypeFilter.Type.HazardousTransboundary, x.Sum(p => p.QuantityTotalHWOC), x.Sum(p => p.QuantityRecoveryHWOC), x.Sum(p => p.QuantityDisposalHWOC), x.Sum(p => p.QuantityUnspecHWOC)));
                    break;
                case WasteTypeFilter.Type.NonHazardous:
                    data = group.Select(x => new TimeSeriesClasses.WasteTransfer(x.Key, x.Count(), WasteTypeFilter.Type.NonHazardous, x.Sum(p => p.QuantityTotalNONHW), x.Sum(p => p.QuantityRecoveryNONHW), x.Sum(p => p.QuantityDisposalNONHW), x.Sum(p => p.QuantityUnspecNONHW)));
                    break;
                default:
                    throw new ArgumentOutOfRangeException("wastetype", String.Format("Illegal wastetype: {0}", wastetype.ToString()));
            }


            //add information about no. of reporting countries
            IEnumerable<Facility.ReportingCountries> years = Facility.GetReportingCountries(filter.AreaFilter).ToList();

            IEnumerable<TimeSeriesClasses.WasteTransfer> res = from l in data.ToList()
                                                               join r in years on l.Year equals r.Year
                                                               select new TimeSeriesClasses.WasteTransfer(
                                                                   l.Year,
                                                                   l.Facilities,
                                                                   l.WasteType,
                                                                   l.QuantityTotal,
                                                                   l.QuantityRecovery,
                                                                   l.QuantityDisposal,
                                                                   l.QuantityUnspec,
                                                                   r.Countries);

            return res.OrderBy(p => p.Year).ToList();
        }
        #endregion

        // ---------------------------------------------------------------------------------------------------
        // Comparison
        // ---------------------------------------------------------------------------------------------------
        #region comparison

        /// <summary>
        /// GetComparisonTimeSeries
        /// </summary>
        public static TimeSeriesClasses.ComparisonWasteTransfer GetComparisonTimeSeries(WasteTransferTimeSeriesFilter filter, int yearFrom, int yearTo, WasteTypeFilter.Type wasteType)
        {
            // Create lambda with pollutant release filter
            Expression<Func<WASTETRANSFER, bool>> lambda = getLambdaExpression(filter, wasteType);

            DataClassesWasteTransferDataContext db = new DataClassesWasteTransferDataContext();
                                    
            // group by reporting year, get from and to data
            IQueryable<IGrouping<int, WASTETRANSFER>> groupFrom = db.WASTETRANSFERs.Where(lambda).Where(p => p.ReportingYear == yearFrom).GroupBy(p => p.ReportingYear);
            IQueryable<IGrouping<int, WASTETRANSFER>> groupTo = db.WASTETRANSFERs.Where(lambda).Where(p => p.ReportingYear == yearTo).GroupBy(p => p.ReportingYear);

            // Facility IDs when year is 'yearTo' 
            var vTo = db.WASTETRANSFERs.Where(lambda).Where(p => p.ReportingYear == yearTo).Select(p => p.FacilityID).Distinct();
            IQueryable<IGrouping<int, WASTETRANSFER>> groupDataFromBoth = db.WASTETRANSFERs.Where(lambda).Where(p => p.ReportingYear == yearFrom && vTo.Contains(p.FacilityID)).GroupBy(p => p.ReportingYear);

            // Facility IDs when year is 'yearFrom' 
            var vFrom = db.WASTETRANSFERs.Where(lambda).Where(p => p.ReportingYear == yearFrom).Select(p => p.FacilityID).Distinct();
            IQueryable<IGrouping<int, WASTETRANSFER>> groupDataToBoth = db.WASTETRANSFERs.Where(lambda).Where(p => p.ReportingYear == yearTo && vFrom.Contains(p.FacilityID)).GroupBy(p => p.ReportingYear);
            
            // result lists
            IEnumerable<TimeSeriesClasses.TsWasteCompare> dataFrom = null, dataTo = null;
            IEnumerable<TimeSeriesClasses.TsWasteCompare> dataFromBoth = null, dataToBoth = null;
            
            switch (wasteType)
            {
                case WasteTypeFilter.Type.HazardousCountry:
                    dataFrom = groupFrom.Select(x => new TimeSeriesClasses.TsWasteCompare(x.Count(), x.Sum(p => p.QuantityTotalHWIC), x.Sum(p => p.QuantityRecoveryHWIC), x.Sum(p => p.QuantityDisposalHWIC), x.Sum(p => p.QuantityUnspecHWIC)));
                    dataTo = groupTo.Select(x => new TimeSeriesClasses.TsWasteCompare(x.Count(), x.Sum(p => p.QuantityTotalHWIC), x.Sum(p => p.QuantityRecoveryHWIC), x.Sum(p => p.QuantityDisposalHWIC), x.Sum(p => p.QuantityUnspecHWIC)));
                    dataFromBoth = groupDataFromBoth.Select(x => new TimeSeriesClasses.TsWasteCompare(x.Count(), x.Sum(p => p.QuantityTotalHWIC), x.Sum(p => p.QuantityRecoveryHWIC), x.Sum(p => p.QuantityDisposalHWIC), x.Sum(p => p.QuantityUnspecHWIC)));
                    dataToBoth = groupDataToBoth.Select(x => new TimeSeriesClasses.TsWasteCompare(x.Count(), x.Sum(p => p.QuantityTotalHWIC), x.Sum(p => p.QuantityRecoveryHWIC), x.Sum(p => p.QuantityDisposalHWIC), x.Sum(p => p.QuantityUnspecHWIC)));
                    break;
                case WasteTypeFilter.Type.HazardousTransboundary:
                    dataFrom = groupFrom.Select(x => new TimeSeriesClasses.TsWasteCompare(x.Count(), x.Sum(p => p.QuantityTotalHWOC), x.Sum(p => p.QuantityRecoveryHWOC), x.Sum(p => p.QuantityDisposalHWOC), x.Sum(p => p.QuantityUnspecHWOC)));
                    dataTo = groupTo.Select(x => new TimeSeriesClasses.TsWasteCompare(x.Count(), x.Sum(p => p.QuantityTotalHWOC), x.Sum(p => p.QuantityRecoveryHWOC), x.Sum(p => p.QuantityDisposalHWOC), x.Sum(p => p.QuantityUnspecHWOC)));
                    dataFromBoth = groupDataFromBoth.Select(x => new TimeSeriesClasses.TsWasteCompare(x.Count(), x.Sum(p => p.QuantityTotalHWOC), x.Sum(p => p.QuantityRecoveryHWOC), x.Sum(p => p.QuantityDisposalHWOC), x.Sum(p => p.QuantityUnspecHWOC)));
                    dataToBoth = groupDataToBoth.Select(x => new TimeSeriesClasses.TsWasteCompare(x.Count(), x.Sum(p => p.QuantityTotalHWOC), x.Sum(p => p.QuantityRecoveryHWOC), x.Sum(p => p.QuantityDisposalHWOC), x.Sum(p => p.QuantityUnspecHWOC)));
                    break;
                case WasteTypeFilter.Type.NonHazardous:
                    dataFrom = groupFrom.Select(x => new TimeSeriesClasses.TsWasteCompare(x.Count(), x.Sum(p => p.QuantityTotalNONHW), x.Sum(p => p.QuantityRecoveryNONHW), x.Sum(p => p.QuantityDisposalNONHW), x.Sum(p => p.QuantityUnspecNONHW)));
                    dataTo = groupTo.Select(x => new TimeSeriesClasses.TsWasteCompare(x.Count(), x.Sum(p => p.QuantityTotalNONHW), x.Sum(p => p.QuantityRecoveryNONHW), x.Sum(p => p.QuantityDisposalHWIC), x.Sum(p => p.QuantityUnspecNONHW)));
                    dataFromBoth = groupDataFromBoth.Select(x => new TimeSeriesClasses.TsWasteCompare(x.Count(), x.Sum(p => p.QuantityTotalNONHW), x.Sum(p => p.QuantityRecoveryNONHW), x.Sum(p => p.QuantityDisposalNONHW), x.Sum(p => p.QuantityUnspecNONHW)));
                    dataToBoth = groupDataToBoth.Select(x => new TimeSeriesClasses.TsWasteCompare(x.Count(), x.Sum(p => p.QuantityTotalNONHW), x.Sum(p => p.QuantityRecoveryNONHW), x.Sum(p => p.QuantityDisposalNONHW), x.Sum(p => p.QuantityUnspecNONHW)));
                    break;
                default: return null;
            }

            TimeSeriesClasses.ComparisonWasteTransfer result = new TimeSeriesClasses.ComparisonWasteTransfer(yearFrom, yearTo);

            var res = dataFrom.SingleOrDefault();
            if (res != null) result.SetFrom(res.Count, res.Quantity, res.Recovery, res.Disposal, res.Unspecified);

            res = dataTo.SingleOrDefault();
            if (res != null) result.SetTo(res.Count, res.Quantity, res.Recovery, res.Disposal, res.Unspecified);

            res = dataFromBoth.SingleOrDefault();
            if (res != null) result.SetBothFrom(res.Count, res.Quantity, res.Recovery, res.Disposal, res.Unspecified);

            res = dataToBoth.SingleOrDefault();
            if (res != null) result.SetBothTo(res.Count, res.Quantity, res.Recovery, res.Disposal, res.Unspecified);
            return result;
        }

        /// <summary>
        /// return timeseries
        /// </summary>
        public static List<TimeSeriesClasses.WasteTransfer> GetTimeSeries(int facilityID, WasteTypeFilter.Type wasteType)
        {
            DataClassesWasteTransferDataContext db = getDataContext();

            //table has only one row per facility per year with aggregated data.
            IEnumerable<TimeSeriesClasses.WasteTransfer> data = db.WASTETRANSFERs.Where(s => s.FacilityID == facilityID)
                                               .OrderBy( s => s.ReportingYear)
                                               .Select(s => new TimeSeriesClasses.WasteTransfer(
                                                   s.ReportingYear,
                                                   1,
                                                   wasteType,
                                                   LinqFunctionsWaste.QuantityTotal(wasteType)(s),
                                                   LinqFunctionsWaste.QuantityRecovery(wasteType)(s),
                                                   LinqFunctionsWaste.QuantityDisposal(wasteType)(s),
                                                   LinqFunctionsWaste.QuantityUnspec(wasteType)(s)
                                                   ));

            return data.ToList();
        }

        #endregion

        // ---------------------------------------------------------------------------------------------------
        // confidentiality
        // ---------------------------------------------------------------------------------------------------
        #region Confidentiality


        public static IEnumerable<TimeSeriesClasses.ConfidentialityWaste> GetConfidentiality(int facilityId, WasteTypeFilter.Type wasteType)
        {
            DataClassesWasteTransferDataContext db = getDataContext();

            // apply filter
            Expression<Func<WASTETRANSFER, bool>> lambda = getLambdaExpression(wasteType);

            //table have only one record per facility, so no aggregation is needed.
            IEnumerable<TimeSeriesClasses.ConfidentialityWaste> data = db.WASTETRANSFERs.Where(lambda)
                                                    .Where(v => v.FacilityID == facilityId)
                                                    .OrderBy(v => v.ReportingYear)
                                                    .Select(v => new TimeSeriesClasses.ConfidentialityWaste
                                                    {
                                                        Year = v.ReportingYear,
                                                        CountTotal = 1,
                                                        CountConfTotal = Convert.ToInt32(LinqFunctionsWaste.ConfidentialityIndicator(wasteType)(v)),
                                                        CountConfQuantity = Convert.ToInt32(LinqFunctionsWaste.ConfidentialityIndicatorQuantity(wasteType)(v))
                                                    });

            return data;
        }

        public static List<TimeSeriesClasses.ConfidentialityWaste> GetCountConfidentialFacilities(WasteTransferTimeSeriesFilter filter, WasteTypeFilter.Type wasteType)
        {
            DataClassesWasteTransferDataContext db = getDataContext();
            Expression<Func<WASTETRANSFER_CONFIDENTIAL, bool>> lambda = getLambdaExpressionConfidential(filter, wasteType);
            
            //count all confidential claims
            //table has one row per facility per wastetype so distinct is needed
            List<TimeSeriesClasses.ConfidentialityWaste> confidential = db.WASTETRANSFER_CONFIDENTIALs.Where(lambda)
                        .GroupBy(v => v.ReportingYear)
                        .OrderBy(v => v.Key)
                        .Select(v => new TimeSeriesClasses.ConfidentialityWaste
                        {
                            Year = v.Key,
                            CountConfTotal = v.Select(x => x.FacilityReportID).Distinct().Count(),
                            CountConfQuantity= v.Where(x => (bool)x.ConfidentialityOnQuantity).Select(x => x.FacilityReportID).Distinct().Count(),
                            CountConfTreatment= v.Where(x => (bool)x.ConfidentialityOnTreatmant).Select(x => x.FacilityReportID).Distinct().Count()
                        }).ToList();

            if (confidential.Count() > 0)
            {
                List<TimeSeriesClasses.WasteTransfer> all = GetTimeSeries(filter, wasteType);
                foreach (TimeSeriesClasses.WasteTransfer wt in all)
                {
                    TimeSeriesClasses.ConfidentialityWaste conf = confidential.SingleOrDefault(c => c.Year.Equals(wt.Year));
                    if (conf != null)
                    {
                        conf.CountTotal = wt.Facilities;
                    }
                    else
                    {
                        confidential.Add(new TimeSeriesClasses.ConfidentialityWaste { Year = wt.Year, CountTotal = wt.Facilities });
                    }
                }

                return confidential.OrderBy(c => c.Year).ToList();
            }

            return new List<TimeSeriesClasses.ConfidentialityWaste>();
        }

        /// <summary>
        /// return true if confidentiality might effect result
        /// </summary>
        public static bool IsAffectedByConfidentiality(WasteTransferTimeSeriesFilter filter)
        {
            Expression<Func<WASTETRANSFER_CONFIDENTIAL, bool>> lambda = getLambdaExpressionConfidential(filter);
            DataClassesWasteTransferDataContext db = getDataContext();

            return db.WASTETRANSFER_CONFIDENTIALs.Any(lambda);
        }

        /// <summary>
        /// return true if confidentiality might effect result
        /// </summary>
        public static bool IsAffectedByConfidentiality(WasteTransferTimeSeriesFilter filter, WasteTypeFilter.Type wasteType)
        {
            Expression<Func<WASTETRANSFER_CONFIDENTIAL, bool>> lambda = getLambdaExpressionConfidential(filter, wasteType);
            DataClassesWasteTransferDataContext db = getDataContext();

            return db.WASTETRANSFER_CONFIDENTIALs.Any(lambda);
        }


        /// <summary>
        /// return true if confidentiality might effect result
        /// </summary>
        public static bool IsAffectedByConfidentiality(int facilityID, WasteTypeFilter.Type wasteType)
        {
            var confidentialData = GetTimeSeries(facilityID, wasteType);
            return confidentialData.Any();
        }

        #endregion


        // ----------------------------------------------------------------------------------
        // Map filters
        // ----------------------------------------------------------------------------------
        #region Map
        /// <summary>
        /// returns the MapFilter (sql and sectors) corresponding to the filter. The map always uses the WASTETRANSFER table for lookup
        /// </summary>
        public static MapFilter GetMapFilter(WasteTransferTimeSeriesFilter filter)
        {
            //parameter must be "p" to match map config file
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER), "p");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransfer(filter, param, false);
            Expression<Func<WASTETRANSFER, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER, bool>>(exp, param);

            // create sql and sectors to map. Do not remove parameter prefix.
            MapFilter mapFilter = new MapFilter();
            mapFilter.SqlWhere = LinqExpressionBuilder.GetSQL(lambda.Body, null);
            mapFilter.SetLayers(filter.ActivityFilter);

            return mapFilter;
        }

        #endregion

        // ---------------------------------------------------------------------------------------------------
        // Data context
        // ---------------------------------------------------------------------------------------------------
        #region Data context
        private static DataClassesWasteTransferDataContext getDataContext()
        {
            DataClassesWasteTransferDataContext db = new DataClassesWasteTransferDataContext();
            db.Log = new DebuggerWriter();
            return db;
        }

        private static Expression<Func<WASTETRANSFER, bool>> getLambdaExpression(WasteTransferTimeSeriesFilter filter)
        {
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransfer(filter, param, false);

            Expression<Func<WASTETRANSFER, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER, bool>>(exp, param);

            return lambda;
        }


        private static Expression<Func<WASTETRANSFER, bool>> getLambdaExpression(WasteTypeFilter.Type wasteType)
        {
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransferType(wasteType, param, false);
            Expression<Func<WASTETRANSFER, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER, bool>>(exp, param);

            return lambda;
        }


        private static Expression<Func<WASTETRANSFER, bool>> getLambdaExpression(WasteTransferTimeSeriesFilter filter, WasteTypeFilter.Type wasteType)
        {
            Expression<Func<WASTETRANSFER, bool>> lambda = getLambdaExpression(filter);
            ParameterExpression param = lambda.Parameters[0];

            //Apply waste type
            Expression expType = LinqExpressionBuilder.GetLinqExpressionWasteTransferType(wasteType, param, false);
            Expression exp = LinqExpressionBuilder.CombineAnd(lambda.Body, expType);

            lambda = Expression.Lambda<Func<WASTETRANSFER, bool>>(exp, param);

            return lambda;
        }

        //Table only contains confidential data
        private static Expression<Func<WASTETRANSFER_CONFIDENTIAL, bool>> getLambdaExpressionConfidential(WasteTransferTimeSeriesFilter filter)
        {
            ParameterExpression param = Expression.Parameter(typeof(WASTETRANSFER_CONFIDENTIAL), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionWasteTransfer(filter, param, true);

            Expression<Func<WASTETRANSFER_CONFIDENTIAL, bool>> lambda = Expression.Lambda<Func<WASTETRANSFER_CONFIDENTIAL, bool>>(exp, param);

            return lambda;
        }

        private static Expression<Func<WASTETRANSFER_CONFIDENTIAL, bool>> getLambdaExpressionConfidential(WasteTransferTimeSeriesFilter filter, WasteTypeFilter.Type wasteType)
        {
            Expression<Func<WASTETRANSFER_CONFIDENTIAL, bool>> lambda = getLambdaExpressionConfidential(filter);
            ParameterExpression param = lambda.Parameters[0];

            //Apply waste type
            Expression expType = LinqExpressionBuilder.GetLinqExpressionWasteTransferType(wasteType, param, true);
            Expression exp = LinqExpressionBuilder.CombineAnd(lambda.Body, expType);

            lambda = Expression.Lambda<Func<WASTETRANSFER_CONFIDENTIAL, bool>>(exp, param);
            return lambda;
        }

        #endregion
    
    }
}
