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
    /// Holds methods to collect data for the Pollutant transfer trends
    /// </summary>
    public static class PollutantTransferTrend
    {
        public static string CODE_KG = EnumUtil.GetStringValue(QuantityUnit.Kilo);
       // public static string CODE_TNE = EnumUtil.GetStringValue(QuantityUnit.Tonnes);

        // ---------------------------------------------------------------------------------------------------
        // Comparison
        // ---------------------------------------------------------------------------------------------------
        #region comparison

        /// <summary>
        /// Returns data for comparison of two years corresponding to the filter given.
        /// </summary>
        /// <param name="filter"></param>
        /// <param name="yearFrom"></param>
        /// <param name="yearTo"></param>
        /// <returns></returns>
        public static TimeSeriesClasses.ComparisonPollutant GetComparisonTimeSeries(PollutantTransferTimeSeriesFilter filter, int yearFrom, int yearTo)
        {
            TimeSeriesClasses.ComparisonPollutant result = new TimeSeriesClasses.ComparisonPollutant(yearFrom, yearTo);

            // Create lambda with pollutant release filter
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = getLambdaExpression(filter);                        

            DataClassesPollutantTransferDataContext db = new DataClassesPollutantTransferDataContext();
            
            // facilities
            var dataFrom = db.POLLUTANTTRANSFERs.Where(lambda).Where(p => p.ReportingYear == yearFrom).GroupBy(p => p.ReportingYear)
                             .Select(p => new { count = p.Count(), quantity = p.Sum(x => x.Quantity) });
            var dataTo = db.POLLUTANTTRANSFERs.Where(lambda).Where(p => p.ReportingYear == yearTo).GroupBy(p => p.ReportingYear)
                             .Select(p => new { count = p.Count(), quantity = p.Sum(x => x.Quantity) });

            // reporting in both years
            var vTo = db.POLLUTANTTRANSFERs.Where(lambda).Where(p => p.ReportingYear == yearTo).Select(p => p.FacilityID).Distinct();
            var dataFromBoth = db.POLLUTANTTRANSFERs.Where(lambda)
                                 .Where(p => p.ReportingYear == yearFrom && vTo.Contains(p.FacilityID)).GroupBy(p => p.ReportingYear)
                                 .Select(p => new { count = p.Count(), quantity = p.Sum(x => x.Quantity) });
            var vFrom = db.POLLUTANTTRANSFERs.Where(lambda).Where(p => p.ReportingYear == yearFrom).Select(p => p.FacilityID).Distinct();
            var dataToBoth = db.POLLUTANTTRANSFERs.Where(lambda)
                                 .Where(p => p.ReportingYear == yearTo && vFrom.Contains(p.FacilityID)).GroupBy(p => p.ReportingYear)
                                 .Select(p => new { count = p.Count(), quantity = p.Sum(x => x.Quantity) });

            var resFrom = dataFrom.SingleOrDefault();
            if (resFrom != null)
            {
                result.FacilitiesFrom = resFrom.count;
                result.QuantityFrom = resFrom.quantity;
            }
            var resTo = dataTo.SingleOrDefault();
            if (resTo != null)
            {
                result.FacilitiesTo = resTo.count;
                result.QuantityTo = resTo.quantity;
            }
            var resBothFrom = dataFromBoth.SingleOrDefault();
            if (resBothFrom != null)
            {
                result.BothFacilities = resBothFrom.count;
                result.BothQuantityFrom = resBothFrom.quantity;
            }
            var resBothTo = dataToBoth.SingleOrDefault();
            if (resBothTo != null)
            {
                result.BothFacilities = resBothTo.count;
                result.BothQuantityTo = resBothTo.quantity;
            }
            return result;
        }

        #endregion

        // ---------------------------------------------------------------------------------------------------
        // Timeseries
        // ---------------------------------------------------------------------------------------------------
        #region Timeseries

        /// <summary>
        /// Get timeseries on aggregated level
        /// </summary>
        public static List<TimeSeriesClasses.PollutantTransfers> GetTimeSeries(PollutantTransferTimeSeriesFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getDataContext();

            // apply filter
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = getLambdaExpression(filter);

            //get data from database
            var data = db.POLLUTANTTRANSFERs.Where(lambda)
                                            .GroupBy(p => p.ReportingYear)
                                            .OrderBy(p => p.Key)
                                            .Select(x => new {
                                                Year = x.Key, 
                                                Quantity = x.Sum(p => p.Quantity), 
                                                Facilities = x.Count()}).ToList();

            //add information about no. of reporting countries
            IEnumerable<Facility.ReportingCountries> years = Facility.GetReportingCountries(filter.AreaFilter).ToList();

            IEnumerable<TimeSeriesClasses.PollutantTransfers> res = from l in data
                                                                    join r in years on l.Year equals r.Year
                                                                    select new TimeSeriesClasses.PollutantTransfers(
                                                                            l.Year, l.Quantity, l.Facilities, r.Countries);

            return res.OrderBy(p => p.Year).ToList();
        }


        /// <summary>
        /// Get timeseries on facility level
        /// </summary>
        public static List<TimeSeriesClasses.PollutantTransfers> GetTimeSeries(int facilityid, string pollutantCode)
        {
            DataClassesPollutantTransferDataContext db = getDataContext();


            // get data and group by year (which get assigned to x.Key by link)
            IEnumerable<TimeSeriesClasses.PollutantTransfers> data = db.POLLUTANTTRANSFERs.Where(f => f.FacilityID == facilityid && f.PollutantCode == pollutantCode)
                                                                    .GroupBy(p => p.ReportingYear)
                                                                    .OrderBy(p => p.Key)
                                                                    .Select(x => new TimeSeriesClasses.PollutantTransfers(
                                                                        x.Key,
                                                                        x.Sum(p => p.Quantity)));

            return data.ToList();
        }

        #endregion

        // ---------------------------------------------------------------------------------------------------
        // confidentiality
        // ---------------------------------------------------------------------------------------------------
        #region Confidentiality

        /// <summary>
        /// return true if confidentiality might effect result
        /// </summary>
        public static bool IsAffectedByConfidentiality(PollutantTransferTimeSeriesFilter filter)
        {
            //create new filter with confidential within group instead of pollutant itself
            PollutantTransferTimeSeriesFilter filterConf = filter.Clone() as PollutantTransferTimeSeriesFilter;
            filterConf.PollutantFilter.PollutantID = filter.PollutantFilter.PollutantGroupID;

            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = getLambdaExpression(filterConf);
            DataClassesPollutantTransferDataContext db = getDataContext();

            return db.POLLUTANTTRANSFERs.Any(lambda); 
        }

        /// <summary>
        /// return true if confidentiality might effect result
        /// </summary>
        public static bool IsAffectedByConfidentiality(int facilityID, string pollutantCode)
        {
            //Find data for confidential in the group of the pollutant
            LOV_POLLUTANT pollutant = ListOfValues.GetPollutant(pollutantCode);

            string groupCode = pollutant.ParentID.HasValue ? ListOfValues.GetPollutant(pollutant.ParentID.Value).Code : pollutantCode;

            var confidentialData = GetTimeSeries(facilityID, groupCode);

            return confidentialData.Any();
        }


        /// <summary>
        /// Get confidential data for timeseries on facility level. 
        /// The list will always contain data corresponding to the pollutant, even if no confidentiality claims has been made for any years
        /// </summary>
        public static List<TimeSeriesClasses.ConfidentialityPollutant> GetConfidentialTimeSeries(int facilityID, string pollutantCode)
        {
            //Find data for pollutant
            List<TimeSeriesClasses.PollutantTransfers> pollutantData = GetTimeSeries(facilityID, pollutantCode);

            //Find data for confidential in the group of the pollutant
            LOV_POLLUTANT pollutant = ListOfValues.GetPollutant(pollutantCode);
            string groupCode = pollutant.ParentID.HasValue ? ListOfValues.GetPollutant(pollutant.ParentID.Value).Code : null;

            List<TimeSeriesClasses.PollutantTransfers> confidentialData = GetTimeSeries(facilityID, groupCode);

            //merge the two lists.
            List<TimeSeriesClasses.ConfidentialityPollutant> result = mergeList(pollutantData, confidentialData);

            return result;
        }

        /// <summary>
        /// Get confidential data for timeseries on aggregated level. If no confidentiality claims is found the list will be empty.
        /// </summary>
        public static List<TimeSeriesClasses.ConfidentialityPollutant> GetConfidentialTimeSeries(PollutantTransferTimeSeriesFilter filter)
        {
            //Find data for confidential in the group of the pollutant
            PollutantTransferTimeSeriesFilter filterConf = filter.Clone() as PollutantTransferTimeSeriesFilter;
            filterConf.PollutantFilter.PollutantID = filter.PollutantFilter.PollutantGroupID;

            List<TimeSeriesClasses.PollutantTransfers> confidentialData = GetTimeSeries(filterConf);

            if (confidentialData.Count() > 0)
            {
                //Find data for pollutant
                List<TimeSeriesClasses.PollutantTransfers> pollutantData = GetTimeSeries(filter);

                //merge the two lists and return.
                return mergeList(pollutantData, confidentialData);
            }

            return new List<TimeSeriesClasses.ConfidentialityPollutant>();
        }


        /// <summary>
        /// Merge a list of timeseries for pollutants and confidential in group. 
        /// All years included in each of the two lists will be included in the merged list.
        /// </summary>
        /// <param name="pollutantData">A list of time series data for the pollutant</param>
        /// <param name="confidentialData">A list of time series data for confidential the group </param>
        /// <returns></returns>
        private static List<TimeSeriesClasses.ConfidentialityPollutant> mergeList(List<TimeSeriesClasses.PollutantTransfers> pollutantData, List<TimeSeriesClasses.PollutantTransfers> confidentialData)
        {
            //take all pollutants and add confidential data where avaialable
            var pol = from p in pollutantData
                      join c in confidentialData on p.Year equals c.Year into g
                      from c in g.DefaultIfEmpty()
                      select new { Year = p.Year, Quantity = (double?)p.Quantity, QuantityGroup = c != null ? (double?)c.Quantity : null };

            //take all confidential data and add pollutant data where avaialable
            var conf = from c in confidentialData
                       join p in pollutantData on c.Year equals p.Year into g
                       from p in g.DefaultIfEmpty()
                       select new { Year = c.Year, Quantity = p != null ? (double?)p.Quantity : null, QuantityGroup = (double?)c.Quantity };

            //Combinde the two lists. Union will remove any dublets
            IEnumerable<TimeSeriesClasses.ConfidentialityPollutant> query = pol.Union(conf).Select(g => new TimeSeriesClasses.ConfidentialityPollutant(g.Year, g.Quantity, g.QuantityGroup));

            //Order merged list by year
            return query.OrderBy(p => p.Year).ToList();
        }



        #endregion

        // ----------------------------------------------------------------------------------
        // Map filters
        // ----------------------------------------------------------------------------------
        #region Map

        /// <summary>
        /// returns the MapFilter (sql and layers) corresponding to the filter. 
        /// </summary>
        public static MapFilter GetMapFilter(PollutantTransferTimeSeriesFilter filter)
        {
            //parameter must be "p" to match map config file
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "p");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfers(filter, param);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);

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
        #region datacontext
        /// <summary>
        /// creates a new DataCotext and add logger
        /// </summary>
        private static DataClassesPollutantTransferDataContext getDataContext()
        {
            DataClassesPollutantTransferDataContext db = new DataClassesPollutantTransferDataContext();
            db.Log = new DebuggerWriter();
            return db;
        }


        /// <summary>
        /// create a lambda expression from the filter given
        /// </summary>
        private static Expression<Func<POLLUTANTTRANSFER, bool>> getLambdaExpression(PollutantTransferTimeSeriesFilter filter)
        {
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfers(filter, param);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);

            return lambda;
        }

        #endregion

    }
}
