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
    /// Holds methods to collect data for the Pollutant release trends
    /// </summary>
    public static class PollutantReleaseTrend
    {
        public static string CODE_KG = EnumUtil.GetStringValue(QuantityUnit.Kilo);
        //public static string CODE_TNE = EnumUtil.GetStringValue(QuantityUnit.Tonnes);


        // ---------------------------------------------------------------------------------------------------
        // Time series
        // ---------------------------------------------------------------------------------------------------
        #region timeseries


        /// <summary>
        /// Get timeseries on aggregated level
        /// </summary>
        public static List<TimeSeriesClasses.PollutantReleases> GetTimeSeries(PollutantReleasesTimeSeriesFilter filter, MediumFilter.Medium medium)
        {
            // apply filter
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = getLambdaExpression(filter, medium);

            DataClassesPollutantReleaseDataContext db = getDataContext(); 

            // get data and group by year (which get assigned to x.Key by link)
            IQueryable<IGrouping<int,POLLUTANTRELEASE>> group = db.POLLUTANTRELEASEs.Where(lambda).GroupBy(p => p.ReportingYear).OrderBy(p => p.Key);

            // lookup medium
            IEnumerable<TimeSeriesClasses.PollutantReleases> data = null;
            switch (medium)
            {
                case MediumFilter.Medium.Air:
                    data = group.Select(x => new TimeSeriesClasses.PollutantReleases(x.Key,x.Count(), x.Sum(p => p.QuantityAir),x.Sum(p => p.QuantityAccidentalAir)));
                    break;
                case MediumFilter.Medium.Soil:
                    data = group.Select(x => new TimeSeriesClasses.PollutantReleases(x.Key, x.Count(), x.Sum(p => p.QuantitySoil), x.Sum(p => p.QuantityAccidentalSoil)));
                    break;
                case MediumFilter.Medium.Water:
                    data = group.Select(x => new TimeSeriesClasses.PollutantReleases(x.Key, x.Count(), x.Sum(p => p.QuantityWater), x.Sum(p => p.QuantityAccidentalWater)));
                    break;
                default:
                    throw new ArgumentOutOfRangeException("medium", String.Format("Illegal medium: {0}", medium.ToString()));
            }

            IEnumerable<Facility.ReportingCountries> years = Facility.GetReportingCountries(filter.AreaFilter).ToList();

            IEnumerable<TimeSeriesClasses.PollutantReleases> res = from l in data.ToList()
                                                                    join r in years on l.Year equals r.Year
                                                                    select new TimeSeriesClasses.PollutantReleases( l.Year, l.Facilities, l.Quantity, l.QuantityAccidental, r.Countries);
            
            return res.OrderBy(p => p.Year).ToList();
        }
        
                
        /// <summary>
        /// Get timeseries on facility level
        /// </summary>
        public static List<TimeSeriesClasses.PollutantReleases> GetTimeSeries(int facilityid, string pollutantCode, MediumFilter.Medium medium)
        {
            DataClassesPollutantReleaseDataContext db = getDataContext();

            //apply medium condition
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = getLambdaExpression(medium);

            // get data and group by year (which get assigned to x.Key by link)

            IQueryable<IGrouping<int, POLLUTANTRELEASE>> group = db.POLLUTANTRELEASEs.Where(f => f.FacilityID == facilityid && f.PollutantCode == pollutantCode).Where(lambda).GroupBy(p => p.ReportingYear);

            // lookup medium
            IEnumerable<TimeSeriesClasses.PollutantReleases> data = null;
            switch (medium)
            {
                case MediumFilter.Medium.Air:
                    data = group.Select(x => new TimeSeriesClasses.PollutantReleases(x.Key, x.Count(), x.Sum(p => p.QuantityAir), x.Sum(p => p.QuantityAccidentalAir)));
                    break;
                case MediumFilter.Medium.Soil:
                    data = group.Select(x => new TimeSeriesClasses.PollutantReleases(x.Key, x.Count(), x.Sum(p => p.QuantitySoil), x.Sum(p => p.QuantityAccidentalSoil)));
                    break;
                case MediumFilter.Medium.Water:
                    data = group.Select(x => new TimeSeriesClasses.PollutantReleases(x.Key, x.Count(), x.Sum(p => p.QuantityWater), x.Sum(p => p.QuantityAccidentalWater)));
                    break;
                default:
                    throw new ArgumentOutOfRangeException("medium", String.Format("Illegal medium: {0}", medium.ToString()));
            }

            return data.OrderBy(p => p.Year).ToList();
        }


        #endregion

        // ---------------------------------------------------------------------------------------------------
        // Comparison
        // ---------------------------------------------------------------------------------------------------
        #region comparison
        /// <summary>
        /// GetComparisonTimeSeries
        /// </summary>
        public static TimeSeriesClasses.ComparisonPollutant GetComparisonTimeSeries(PollutantReleasesTimeSeriesFilter filter, int yearFrom, int yearTo, MediumFilter.Medium medium)
        {
            // Create lambda with pollutant release filter
            DataClassesPollutantReleaseDataContext db = getDataContext();
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(filter, param);
            // apply medium
            Expression expMedium = LinqExpressionBuilder.GetLinqExpressionMediumRelease(medium, param);
            if (exp != null && expMedium != null) exp = Expression.And(exp, expMedium);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);

            // group by reporting year, get from and to data
            IQueryable<IGrouping<int, POLLUTANTRELEASE>> groupFrom = db.POLLUTANTRELEASEs.Where(lambda).Where(p => p.ReportingYear == yearFrom).GroupBy(p => p.ReportingYear);
            IQueryable<IGrouping<int, POLLUTANTRELEASE>> groupTo = db.POLLUTANTRELEASEs.Where(lambda).Where(p => p.ReportingYear == yearTo).GroupBy(p => p.ReportingYear);

            // Facility IDs when year is 'yearTo' 
            var vTo = db.POLLUTANTRELEASEs.Where(lambda).Where(p => p.ReportingYear == yearTo).Select(p => p.FacilityID).Distinct();
            IQueryable<IGrouping<int, POLLUTANTRELEASE>> groupDataFromBoth = db.POLLUTANTRELEASEs.Where(lambda).Where(p => p.ReportingYear == yearFrom && vTo.Contains(p.FacilityID)).GroupBy(p => p.ReportingYear);

            // Facility IDs when year is 'yearFrom' 
            var vFrom = db.POLLUTANTRELEASEs.Where(lambda).Where(p => p.ReportingYear == yearFrom).Select(p => p.FacilityID).Distinct();
            IQueryable<IGrouping<int, POLLUTANTRELEASE>> groupDataToBoth = db.POLLUTANTRELEASEs.Where(lambda).Where(p => p.ReportingYear == yearTo && vFrom.Contains(p.FacilityID)).GroupBy(p => p.ReportingYear);

            // result lists
            IEnumerable<TimeSeriesClasses.TsPollutantCompare> dataFrom = null, dataTo = null;
            IEnumerable<TimeSeriesClasses.TsPollutantCompare> dataFromBoth = null, dataToBoth = null;
            switch (medium)
            {
                case MediumFilter.Medium.Air:
                    dataFrom = groupFrom.Select(x => new TimeSeriesClasses.TsPollutantCompare(x.Count(), x.Sum(p => p.QuantityAir), x.Sum(p => p.QuantityAccidentalAir)));
                    dataTo = groupTo.Select(x => new TimeSeriesClasses.TsPollutantCompare(x.Count(), x.Sum(p => p.QuantityAir), x.Sum(p => p.QuantityAccidentalAir)));
                    dataFromBoth = groupDataFromBoth.Select(x => new TimeSeriesClasses.TsPollutantCompare(x.Count(), x.Sum(p => p.QuantityAir), x.Sum(p => p.QuantityAccidentalAir)));
                    dataToBoth = groupDataToBoth.Select(x => new TimeSeriesClasses.TsPollutantCompare(x.Count(), x.Sum(p => p.QuantityAir), x.Sum(p => p.QuantityAccidentalAir)));
                    break;
                case MediumFilter.Medium.Water:
                    dataFrom = groupFrom.Select(x => new TimeSeriesClasses.TsPollutantCompare(x.Count(), x.Sum(p => p.QuantityWater), x.Sum(p => p.QuantityAccidentalWater)));
                    dataTo = groupTo.Select(x => new TimeSeriesClasses.TsPollutantCompare(x.Count(), x.Sum(p => p.QuantityWater), x.Sum(p => p.QuantityAccidentalWater)));
                    dataFromBoth = groupDataFromBoth.Select(x => new TimeSeriesClasses.TsPollutantCompare(x.Count(), x.Sum(p => p.QuantityWater), x.Sum(p => p.QuantityAccidentalWater)));
                    dataToBoth = groupDataToBoth.Select(x => new TimeSeriesClasses.TsPollutantCompare(x.Count(), x.Sum(p => p.QuantityWater), x.Sum(p => p.QuantityAccidentalWater)));
                    break;
                case MediumFilter.Medium.Soil:
                    dataFrom = groupFrom.Select(x => new TimeSeriesClasses.TsPollutantCompare(x.Count(), x.Sum(p => p.QuantitySoil), x.Sum(p => p.QuantityAccidentalSoil)));
                    dataTo = groupTo.Select(x => new TimeSeriesClasses.TsPollutantCompare(x.Count(), x.Sum(p => p.QuantitySoil), x.Sum(p => p.QuantityAccidentalSoil)));
                    dataFromBoth = groupDataFromBoth.Select(x => new TimeSeriesClasses.TsPollutantCompare(x.Count(), x.Sum(p => p.QuantitySoil), x.Sum(p => p.QuantityAccidentalSoil)));
                    dataToBoth = groupDataToBoth.Select(x => new TimeSeriesClasses.TsPollutantCompare(x.Count(), x.Sum(p => p.QuantitySoil), x.Sum(p => p.QuantityAccidentalSoil)));
                    break;
                default: return null;
            }
            TimeSeriesClasses.ComparisonPollutant result = new TimeSeriesClasses.ComparisonPollutant(yearFrom, yearTo);

            var res = dataFrom.SingleOrDefault();
            if (res != null) result.SetFrom(res.Count, res.Quantity, res.Accidental);
            res = dataTo.SingleOrDefault();
            if (res != null) result.SetTo(res.Count, res.Quantity, res.Accidental);
            res = dataFromBoth.SingleOrDefault();
            if (res != null) result.SetBothFrom(res.Count, res.Quantity, res.Accidental);
            res = dataToBoth.SingleOrDefault();
            if (res != null) result.SetBothTo(res.Count, res.Quantity, res.Accidental);
            return result;
        }
        
        #endregion

        // ---------------------------------------------------------------------------------------------------
        // confidentiality
        // ---------------------------------------------------------------------------------------------------
        #region Confidentiality

        /// <summary>
        /// Get confidential data for timeseries on facility level. 
        /// The list will always contain data corresponding to the pollutant, even if no confidentiality claims has been made for any years
        /// </summary>
        public static List<TimeSeriesClasses.ConfidentialityPollutant> GetConfidentialTimeSeries(int facilityID, string pollutantCode, MediumFilter.Medium medium)
        {
            //Find data for pollutant
            List<TimeSeriesClasses.PollutantReleases> pollutantData = GetTimeSeries(facilityID, pollutantCode, medium);

            //Find data for confidential in the group of the pollutant
            LOV_POLLUTANT pollutant = ListOfValues.GetPollutant(pollutantCode);
            string groupCode = pollutant.ParentID.HasValue ? ListOfValues.GetPollutant(pollutant.ParentID.Value).Code : null;

            List<TimeSeriesClasses.PollutantReleases> confidentialData = GetTimeSeries(facilityID, groupCode, medium);

            //merge the two lists.
            List<TimeSeriesClasses.ConfidentialityPollutant> result = mergeList(pollutantData, confidentialData);

            return result;
        }


        /// <summary>
        /// Get confidential data for timeseries on aggregated level. If no confidentiality claims is found the list will be empty.
        /// </summary>
        public static List<TimeSeriesClasses.ConfidentialityPollutant> GetConfidentialTimeSeries(PollutantReleasesTimeSeriesFilter filter, MediumFilter.Medium medium)
        {
            //Find data for confidential in the group of the pollutant
            PollutantReleasesTimeSeriesFilter filterConf = filter.Clone() as PollutantReleasesTimeSeriesFilter;
            filterConf.PollutantFilter.PollutantID = filter.PollutantFilter.PollutantGroupID;

            List<TimeSeriesClasses.PollutantReleases> confidentialData = GetTimeSeries(filterConf, medium);

            if (confidentialData.Count() > 0)
            {
                //Find data for pollutant
                List<TimeSeriesClasses.PollutantReleases> pollutantData = GetTimeSeries(filter, medium);

                //merge the two lists and return.
                return mergeList(pollutantData, confidentialData);
            }

            return new List<TimeSeriesClasses.ConfidentialityPollutant>();
        }


        /// <summary>
        /// Merge a list of timeseries for pollutants and confidential in group. 
        /// All years included in each of the two lists will be included in the merged list.
        /// </summary>
        /// <param name="pollutantData">A li´st of time series data for the pollutant</param>
        /// <param name="confidentialData">A list of time series data for confidential the group </param>
        /// <returns></returns>
        private static List<TimeSeriesClasses.ConfidentialityPollutant> mergeList(List<TimeSeriesClasses.PollutantReleases> pollutantData, List<TimeSeriesClasses.PollutantReleases> confidentialData)
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


        /// <summary>
        /// return true if confidentiality might effect result
        /// </summary>
        public static bool IsAffectedByConfidentiality(PollutantReleasesTimeSeriesFilter filter)
        {
            //create new filter with confidential within group instead of pollutant itself
            PollutantReleasesTimeSeriesFilter filterConf = createConfidentialFilter(filter);

            Expression<Func<POLLUTANTRELEASE, bool>> lambda = getLambdaExpression(filterConf);
            DataClassesPollutantReleaseDataContext db = getDataContext();

            return db.POLLUTANTRELEASEs.Any(lambda); 
        }

        /// <summary>
        /// return true if confidentiality might effect result
        /// </summary>
        public static bool IsAffectedByConfidentiality(PollutantReleasesTimeSeriesFilter filter, MediumFilter.Medium medium)
        {
            //create new filter with confidential within group instead of pollutant itself
            PollutantReleasesTimeSeriesFilter filterConf = createConfidentialFilter(filter);

            Expression<Func<POLLUTANTRELEASE, bool>> lambda = getLambdaExpression(filterConf, medium);
            DataClassesPollutantReleaseDataContext db = getDataContext();

            return db.POLLUTANTRELEASEs.Any(lambda);
        }


        public static bool IsAffectedByConfidentiality(int facilityID, string pollutantCode, MediumFilter.Medium medium)
        {
            //Find data for confidential in the group of the pollutant
            LOV_POLLUTANT pollutant = ListOfValues.GetPollutant(pollutantCode);

            string groupCode = pollutant.ParentID.HasValue ? ListOfValues.GetPollutant(pollutant.ParentID.Value).Code : pollutantCode;

            var confidentialData = GetTimeSeries(facilityID, groupCode, medium);

            return confidentialData.Any();
        }

        private static PollutantReleasesTimeSeriesFilter createConfidentialFilter(PollutantReleasesTimeSeriesFilter filter)
        {
            PollutantReleasesTimeSeriesFilter filterConf = filter.Clone() as PollutantReleasesTimeSeriesFilter;
            filterConf.PollutantFilter.PollutantID = filter.PollutantFilter.PollutantGroupID;

            return filterConf;
        }
        #endregion


        // ---------------------------------------------------------------------------------------------------
        // Map filter
        // ---------------------------------------------------------------------------------------------------
        #region Map

        /// <summary>
        /// returns the MapFilter (sql and layers) corresponding to the filter. 
        /// </summary>
        public static MapFilter GetMapFilter(PollutantReleasesTimeSeriesFilter filter)
        {
            //parameter must be "p" to match map config file
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "p");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(filter, param);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);

            // create sql and sectors to map. Do not remove parameter prefix.
            MapFilter mapFilter = new MapFilter();
            mapFilter.SqlWhere = LinqExpressionBuilder.GetSQL(lambda.Body, null);
            mapFilter.SetLayers(filter.ActivityFilter);

            return mapFilter;
        }

        public static MapFilter GetMapJavascriptFilter(PollutantReleasesTimeSeriesFilter filter)
        {
            //parameter must be "p" to match map config file
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "p");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(filter, param);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);

            // create sql and sectors to map. Do not remove parameter prefix.
            MapFilter mapFilter = new MapFilter();
            mapFilter.SqlWhere = LinqExpressionBuilder.GetSQLJavascript(lambda.Body, null);
            mapFilter.SqlWhere = "FacilityReportID IN (select p.FacilityReportID from POLLUTANTRELEASE p where " + mapFilter.SqlWhere + ")";
            mapFilter.SetLayers(filter.ActivityFilter);

            return mapFilter;
        }


        

        #endregion

        // ---------------------------------------------------------------------------------------------------
        // Data context & lambda expressions
        // ---------------------------------------------------------------------------------------------------
        #region datacontext
        /// <summary>
        /// creates a new DataCotext and add logger
        /// </summary>
        private static DataClassesPollutantReleaseDataContext getDataContext()
        {
            DataClassesPollutantReleaseDataContext db = new DataClassesPollutantReleaseDataContext();
            db.Log = new DebuggerWriter();
            return db;
        }


        private static Expression<Func<POLLUTANTRELEASE, bool>> getLambdaExpression(PollutantReleasesTimeSeriesFilter filter)
        {
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "p");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(filter, param);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);

            return lambda;
        }


        private static Expression<Func<POLLUTANTRELEASE, bool>> getLambdaExpression(MediumFilter.Medium medium)
        {
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "p");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionMediumRelease(medium, param);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);

            return lambda;
        }

        private static Expression<Func<POLLUTANTRELEASE, bool>> getLambdaExpression(PollutantReleasesTimeSeriesFilter filter, MediumFilter.Medium medium)
        {
            // apply filter
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "p");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(filter, param);

            //apply medium condition
            Expression expMedium = LinqExpressionBuilder.GetLinqExpressionMediumRelease(medium, param);
            exp = LinqExpressionBuilder.CombineAnd(exp, expMedium);

            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);
            
            return lambda;
        }

        #endregion

        // ---------------------------------------------------------------------------------------------------
        // Facility couting
        // ---------------------------------------------------------------------------------------------------
        #region Facility counting
        /// <summary>
        /// Returns the number of facilities for each medium type. 
        /// </summary>
        public static PollutantReleases.FacilityCountObject GetFacilityCounts(PollutantReleasesTimeSeriesFilter tsFilter)
        {
            // removes all year span information
            var filter = FilterConverter.ConvertToPollutantReleaseSearchFilter(tsFilter);

            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "POLLUTANTRELEASE");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(filter, param);
            
            // Exclude EPER reporting years
            Expression prop = Expression.Property(param, "ReportingYear");
			Expression val = Expression.Constant(2007);
			Expression yearExp = Expression.GreaterThanOrEqual(prop, val);

            exp = Expression.AndAlso(yearExp, exp);
            
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);

            return PollutantReleases.GetFacilityCounts(lambda, filter.MediumFilter);
        }
        #endregion

    }

}
