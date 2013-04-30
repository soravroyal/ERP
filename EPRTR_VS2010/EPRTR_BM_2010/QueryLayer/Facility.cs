using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using LinqUtilities;
using QueryLayer.Filters;
using QueryLayer.LinqFramework;
using QueryLayer.Utilities;

namespace QueryLayer
{
    /// <summary>
    /// FacilityRow
    /// </summary>
    public class FacilityRow
    {
        public FacilityRow(int facilityId, int facilityReportId, string facilityName, string postalCode, string address, string city, string activityCode, string countryCode, bool confidentialIndicator, int reportingYear)
        {
            this.facilityId = facilityId;
            this.facilityReportId = facilityReportId;
            this.facilityName = facilityName;
            this.postalCode = postalCode;
            this.address = address;
            this.city = city;
            this.activityCode = activityCode;
            this.countryCode = countryCode;
            this.confidentialIndicator = confidentialIndicator;
            this.reportingYear = reportingYear;
        }

        private int facilityId;
        public int FacilityId
        {
            get { return this.facilityId; }
            set { this.facilityId = value; }
        }
        private int facilityReportId;
        public int FacilityReportId
        {
            get { return this.facilityReportId; }
            set { this.facilityReportId = value; }
        }
        private string facilityName;
        public string FacilityName
        {
            get { return this.facilityName; }
            set { this.facilityName = value; }
        }
        private string postalCode;
        public string PostalCode
        {
            get { return this.postalCode; }
            set { this.postalCode = value; }
        }
        private string address;
        public string Address
        {
            get { return this.address; }
            set { this.address = value; }
        }
        private string city;
        public string City
        {
            get { return this.city; }
            set { this.city = value; }
        }
        private string activityCode;
        public string ActivityCode
        {
            get { return this.activityCode; }
            set { this.activityCode = value; }
        }
        private string countryCode;
        public string CountryCode
        {
            get { return this.countryCode; }
            set { this.countryCode = value; }
        }

        private bool confidentialIndicator;
        public bool ConfidentialIndicator
        {
            get { return confidentialIndicator; }
            set { confidentialIndicator = value; }
        }
        private int reportingYear;
        public int ReportingYear
        {
            get { return reportingYear; }
            set { reportingYear = value; }
        }
    }
    
    /// <summary>
    /// Holds methods to collect data for the faacility search - includeing facility details
    /// </summary>
    public static class Facility
    {

        // ----------------------------------------------------------------------------------
        // FacilityList
        // ----------------------------------------------------------------------------------
        #region FacilityList

        /// <summary>
        /// Return facility list
        /// </summary>
        public static List<FacilityRow> FacilityList(FacilitySearchFilter filter, string column, bool descending, int startRowIndex, int maxRows)
        {
            // Create basic expression
            Expression<Func<FACILITYSEARCH_ALL, bool>> lambda = getLambdaExpression(filter);

            // get number of distinct facilities for this search
            DataClassesFacilityDataContext db = getDataContext();
            filter.Count = getDistinctFacilityReportIds(db, lambda).Count();

            IEnumerable<FacilityRow> dataDistinct = null;
            if (filter.Count > 0)
            {
                //get data of correct type
                IQueryable<FACILITYSEARCH_MAINACTIVITY> distinctFacilities = getDistinctFacilities(db, lambda);
                dataDistinct = distinctFacilities.orderBy(column, descending)
                    .Skip(startRowIndex).Take(maxRows)
                    .Select<FACILITYSEARCH_MAINACTIVITY, FacilityRow>(v => new FacilityRow(v.FacilityID,
                                                                                           v.FacilityReportID,
                                                                                           v.FacilityName,
                                                                                           v.PostalCode,
                                                                                           v.Address,
                                                                                           v.City,
                                                                                           v.IAActivityCode,
                                                                                           v.CountryCode,
                                                                                           v.ConfidentialIndicator,
                                                                                           v.ReportingYear));
            }
            
            //add rows to result. Speedup paging by adding empty rows at the start and end of list.
            List<FacilityRow> result = new List<FacilityRow>();
            for (int i = 0; i < startRowIndex; i++)
                result.Add(null);

            if (dataDistinct != null)
                result.AddRange(dataDistinct);
            
            int addcount = result.Count;
            for (int i = 0; i < filter.Count - addcount; i++)
                result.Add(null);

            return result;
        }

        public class FacilityCSV
        {
            internal FacilityCSV(int reportingYear, int facilityReportID, string nationalID, int facilityID,
                string facilityName, string parentCompanyName, string postalCode, string address, string city,
                string iAActivityCode, string countryCode, string riverBasinDistrictCode, string nutsLevel2RegionCode, bool confidentialIndicatorFacility)
            {
                Year = reportingYear.ToString();
                FacilityReportID = facilityReportID.ToString();
                NationalID = nationalID;
                EPRTRFacilityID = facilityID.ToString();
                FacilityName = facilityName;
                ParentCompany = parentCompanyName;
                PostalCode = postalCode;
                Address = address;
                City = city;
                ActivityCode = iAActivityCode;
                ActivityName = String.Empty;
                CountryCode = countryCode;
                CountryName = String.Empty;
                RiverBasinCode = riverBasinDistrictCode;
                RiverBasinName = String.Empty;
                NutsRegionCode = nutsLevel2RegionCode;
                NutsRegionName = String.Empty;
                Confidential = confidentialIndicatorFacility;
                URL = String.Empty;
            }

            public string Year { get; set; }
            public string FacilityReportID { get; set; }
            public string NationalID { get; set; }
            public string EPRTRFacilityID { get; set; }
            public string FacilityName { get; set; }
            public string ParentCompany { get; set; }
            public string PostalCode { get; set; }
            public string Address { get; set; }
            public string City { get; set; }
            public string ActivityCode { get; set; }
            public string ActivityName { get; set; }
            public string CountryCode { get; set; }
            public string CountryName { get; set; }
            public string RiverBasinCode { get; set; }
            public string RiverBasinName { get; set; }
            public string NutsRegionCode { get; set; }
            public string NutsRegionName { get; set; }
            public string URL { get; set; }
            public bool Confidential { get; set; }
        }


        public static List<FacilityCSV> GetFacilityListCSV(FacilitySearchFilter filter)
        {
            if (filter == null) return null;

            // db handler
            DataClassesFacilityDataContext db = getDataContext();

            // Create basic expression
            Expression<Func<FACILITYSEARCH_ALL, bool>> lambda = getLambdaExpression(filter);

            //get data for correct type
            IQueryable<FACILITYSEARCH_MAINACTIVITY> distinctFacilities = getDistinctFacilities(db, lambda);
            IEnumerable<FacilityCSV> dataDistinct = distinctFacilities.orderBy("FacilityName", false).Select<FACILITYSEARCH_MAINACTIVITY, FacilityCSV>(v => 
                                                                new FacilityCSV(v.ReportingYear,
                                                                v.FacilityReportID,
                                                                v.NationalID,
                                                                v.FacilityID,
                                                                v.FacilityName,
                                                                v.ParentCompanyName,
                                                                v.PostalCode,
                                                                v.Address,
                                                                v.City,
                                                                v.IAActivityCode,
                                                                v.CountryCode,
                                                                v.RiverBasinDistrictCode,
                                                                v.NUTSLevel2RegionCode,
                                                                v.ConfidentialIndicator));

            return dataDistinct.ToList();
        }

        private static IQueryable<FACILITYSEARCH_MAINACTIVITY> getDistinctFacilities(DataClassesFacilityDataContext db, Expression<Func<FACILITYSEARCH_ALL, bool>> lambda)
        {
            //prepare inner query for distinct facilityreportids. 
            IQueryable<int> facilityReportIds = getDistinctFacilityReportIds(db, lambda);

            //get data - using inner query
            //IQueryable<FACILITYSEARCH_MAINACTIVITY> dataDistinct = db.FACILITYSEARCH_MAINACTIVITies.
            //                                        Where(d => facilityReportIds.Contains(d.FacilityReportID));

            //get data - using inner join
            IQueryable<FACILITYSEARCH_MAINACTIVITY> dataDistinct  = from f in db.FACILITYSEARCH_MAINACTIVITies
                                                                    join fid in facilityReportIds on f.FacilityReportID equals fid
                                                                    select f;

            return dataDistinct;
        }


        private static IQueryable<int> getDistinctFacilityReportIds(DataClassesFacilityDataContext db, Expression<Func<FACILITYSEARCH_ALL, bool>> lambda)
        {
            //prepare inner query for distinct facilityreportids. 
            IQueryable<int> facilityReportIds = db.FACILITYSEARCH_ALLs.
                                                Where(lambda).
                                                Select<FACILITYSEARCH_ALL, int>(d => d.FacilityReportID).Distinct<int>();

            return facilityReportIds;

        }

        //creates the lambda expression for facilitysearch
        private static Expression<Func<FACILITYSEARCH_ALL, bool>> getLambdaExpression(FacilitySearchFilter filter)
        {
            ParameterExpression param = Expression.Parameter(typeof(FACILITYSEARCH_ALL), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionFacilitySearch(filter, param);

            // create lambda according to filters
            Expression<Func<FACILITYSEARCH_ALL, bool>> lambda = Expression.Lambda<Func<FACILITYSEARCH_ALL, bool>>(exp, param);

            return lambda;
        }
        #endregion


        // ----------------------------------------------------------------------------------
        // FacilityBasic
        // ----------------------------------------------------------------------------------
        #region FacilityBasic

        /// <summary>
        /// Holds basic information about a facility
        /// </summary>
        [Serializable]
        public class FacilityBasic
        {
            internal FacilityBasic(int facilityReportId, int facilityID, string nationalID, string facilityName, string address, string city, string postalCode, string countryCode, bool confidential, int reportingYear, DateTime? published, int? pollutantReleaseConfidential, int? pollutantTransferConfidential, int? wasteConfidential)
            {
                this.FacilityReportId = facilityReportId;
                this.FacilityID = facilityID;
                this.NationalID = nationalID;
                this.FacilityName = facilityName;
                this.Address = address;
                this.City = city;
                this.PostalCode = postalCode;
                this.CountryCode = countryCode;
                this.Confidential = confidential;
                this.ReportingYear = reportingYear;
                this.Published = published;
                this.PollutantReleaseConfidential = getBoolValue(pollutantReleaseConfidential);
                this.PollutantTransferConfidential = getBoolValue(pollutantTransferConfidential);
                this.WasteConfidential = getBoolValue(wasteConfidential);
            }

            public int FacilityReportId { get; private set; }
            public int FacilityID{ get; private set; }
            public string NationalID { get; private set; }
            public string FacilityName{ get; private set; }
            public string Address{ get; private set; }
            public string City{ get; private set; }
            public string PostalCode{ get; private set; }
            public string CountryCode{ get; private set; }
            public bool Confidential{ get; private set; }
            public bool PollutantReleaseConfidential{ get; private set; }
            public bool PollutantTransferConfidential{ get; private set; }
            public bool WasteConfidential{ get; private set; }
            public int ReportingYear{ get; private set; }
            public DateTime? Published{ get; private set; }

            private bool getBoolValue(int? param)
            {
                return param != null && param == 1;

            }

        }

        /// <summary>
        /// Returns basic inforamtion about a facility given by facilityReportId
        /// </summary>
        public static FacilityBasic GetFacilityBasic(int facilityReportId)
        {
            DataClassesFacilityDataContext db = getDataContext();

            IEnumerable<FacilityBasic> data = from d in db.FACILITYDETAIL_DETAILs
                                              where d.FacilityReportID == facilityReportId
                                              select new FacilityBasic(d.FacilityReportID, d.FacilityID, d.NationalID, d.FacilityName, d.Address, d.City, d.PostalCode, d.CountryCode, d.ConfidentialIndicator, d.ReportingYear, d.Published, d.ConfidentialIndicatorPollutantRelease, d.ConfidentialIndicatorPollutantTransfer, d.ConfidentialIndicatorWaste);

            return data.FirstOrDefault();

        }

        /// <summary>
        /// Returns basic inforamtion about a facility given by facilityId and reportingyear
        /// </summary>
        public static FacilityBasic GetFacilityBasic(int facilityId, int reportingYear)
        {
            DataClassesFacilityDataContext db = getDataContext();

            IEnumerable<FacilityBasic> data = from d in db.FACILITYDETAIL_DETAILs
                                              where d.FacilityID == facilityId && d.ReportingYear==reportingYear
                                              select new FacilityBasic(d.FacilityReportID, d.FacilityID, d.NationalID, d.FacilityName, d.Address, d.City, d.PostalCode, d.CountryCode, d.ConfidentialIndicator, d.ReportingYear, d.Published, d.ConfidentialIndicatorPollutantRelease, d.ConfidentialIndicatorPollutantTransfer, d.ConfidentialIndicatorWaste);

            return data.FirstOrDefault();

        }


        //RRP START 18-04-2013
        /// <summary>
        /// Returns Max Year of the facilityId
        /// </summary>
        public static int GetMaxYearFacilityId(int facilityId)
        {
            DataClassesFacilityDataContext db = getDataContext();

            IEnumerable<int> data = from d in db.FACILITYDETAIL_DETAILs
                                              where d.FacilityID == facilityId
                                              select db.FACILITYDETAIL_DETAILs.Max(x => x.ReportingYear);

            return data.FirstOrDefault();

        }
        //RRP END 18-04-2013

        #endregion //FacilityBasic


        // ----------------------------------------------------------------------------------
        // FacilityReportingYear
        // ----------------------------------------------------------------------------------
        #region FacilityReportingYear
        /// <summary>
        /// Links facilityreport id with reporting year.
        /// </summary>
        [Serializable]
        public class FacilityReportingYear
        {
            int reportingYear;
            int facilityReportId;
            int facilityId;

            internal FacilityReportingYear(int year, int facilityReportId, int facilityId)
            {
                    this.reportingYear = year;
                    this.facilityReportId = facilityReportId;
                    this.facilityId = facilityId;
             }

            public int ReportingYear { get { return this.reportingYear; } }
            public int FacilityReportId { get { return this.facilityReportId; } }
            public int FacilityId { get { return this.facilityId; } }
        }


        
        public static IEnumerable<FacilityReportingYear> GetReportingYearsEPER(int facilityId)
        {
            DataClassesFacilityDataContext db = getDataContext();
            IEnumerable<FacilityReportingYear> res = from r in db.FACILITYDETAIL_DETAILs
                                                     where r.FacilityID == facilityId && (r.ReportingYear == 2001 || r.ReportingYear == 2004)
                                                     select new FacilityReportingYear(r.ReportingYear, r.FacilityReportID, facilityId);

            res = res.OrderBy(p => p.ReportingYear);
            return res;
        }


        public static IEnumerable<FacilityReportingYear> GetReportingYears(int facilityId)
        {
            DataClassesFacilityDataContext db = getDataContext();
            IEnumerable<FacilityReportingYear> res = from r in db.FACILITYDETAIL_DETAILs
                                                     where r.FacilityID == facilityId //&& (r.ReportingYear != 2001 && r.ReportingYear != 2004)
                                                     select new FacilityReportingYear(r.ReportingYear, r.FacilityReportID, facilityId);

            res = res.OrderBy(p => p.ReportingYear);
            return res;
        }


        /// <summary>
        /// Links the number of reporitng countries with reporting year.
        /// </summary>
        [Serializable]
        public class ReportingCountries
        {
            internal ReportingCountries(int year, int countries)
            {
                this.Year = year;
                this.Countries = countries;
            }

            public int Year { get; private set;}
            public int Countries{ get; private set;}
        }

        /// <summary>
        /// Return the number of countries having reported per year for the area filter given
        /// </summary>
        /// <param name="areaFilter"></param>
        /// <returns></returns>
        public static IEnumerable<ReportingCountries> GetReportingCountries(AreaFilter areaFilter)
        {
            DataClassesFacilityDataContext db = getDataContext();

            ParameterExpression param = Expression.Parameter(typeof(FACILITYSEARCH_MAINACTIVITY), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionArea(areaFilter, param);

            // create lambda according to filters
            Expression<Func<FACILITYSEARCH_MAINACTIVITY, bool>> lambda = Expression.Lambda<Func<FACILITYSEARCH_MAINACTIVITY, bool>>(exp, param);

            IEnumerable<ReportingCountries> years = db.FACILITYSEARCH_MAINACTIVITies.Where(lambda)
                                                    .GroupBy(f => f.ReportingYear)
                                                    .Select(s => new  ReportingCountries(
                                                        s.Key, 
                                                        s.Select(x => x.CountryCode).Distinct().Count()));

            return years;
        }

        /// <summary>
        /// Determine whether its a an EPER year
        /// </summary>
        /// <param name="facilityReportId"></param>
        /// <returns>True if given facility report id belongs to an EPER year, otherwise False</returns>
        public static bool IsEPERReportingYear(int facilityReportId)
        {
            DataClassesFacilityDataContext db = new DataClassesFacilityDataContext();
            FACILITYDETAIL_DETAIL facility = db.FACILITYDETAIL_DETAILs.Where(x => x.FacilityReportID == facilityReportId).FirstOrDefault();

            return facility != null ? (facility.ReportingYear < 2007) : false;
        }

        #endregion


        // ----------------------------------------------------------------------------------
        // FacilityDetails
        // ----------------------------------------------------------------------------------
        #region FacilityDetails
        public static IEnumerable<FACILITYDETAIL_DETAIL> GetFacilityDetails(int facilityReportId)
        {
            DataClassesFacilityDataContext db = getDataContext();

            IEnumerable<FACILITYDETAIL_DETAIL> data = db.FACILITYDETAIL_DETAILs.Where(p => p.FacilityReportID == facilityReportId);
            return data;
        }
        
        public static IEnumerable<FACILITYDETAIL_COMPETENTAUTHORITYPARTY> GetFacilityCompetentAuthority(int facilityReportId)
        {
            DataClassesFacilityDataContext db = getDataContext();

            IEnumerable<FACILITYDETAIL_COMPETENTAUTHORITYPARTY> data = db.FACILITYDETAIL_COMPETENTAUTHORITYPARTies.Where(p => p.FacilityReportID == facilityReportId);
            return data;
        }
        
        public static IEnumerable<FACILITYDETAIL_ACTIVITY> GetActivities(int facailityReportID)
        {
            DataClassesFacilityDataContext db = getDataContext();

            IEnumerable<FACILITYDETAIL_ACTIVITY> data = db.FACILITYDETAIL_ACTIVITies.Where(c => c.FacilityReportID == facailityReportID).OrderBy(c => c.RankingNumeric);
            return data;
        }
        

        /// <summary>
        /// Get pollutant releases for a specific facility report and medium
        /// </summary>
        public static IEnumerable<FACILITYDETAIL_POLLUTANTRELEASE> GetPollutantReleases(int reportID,MediumFilter.Medium medium)
        {
            string pollutantTo = EnumUtil.GetStringValue(medium);

            DataClassesFacilityDataContext db = getDataContext();
            IEnumerable<FACILITYDETAIL_POLLUTANTRELEASE> data = db.FACILITYDETAIL_POLLUTANTRELEASEs.Where(p => p.FacilityReportID == reportID && p.PollutantTo.Equals(pollutantTo)).OrderBy(x=> x.PollutantCode);
            return data;
        }

        /// <summary>
        /// get pollutant transfers for a specific facility report
        /// </summary>
        public static IEnumerable<FACILITYDETAIL_POLLUTANTTRANSFER> GetPollutantTransfers(int reportID)
        {
            DataClassesFacilityDataContext db = getDataContext();
            IEnumerable<FACILITYDETAIL_POLLUTANTTRANSFER> data = db.FACILITYDETAIL_POLLUTANTTRANSFERs.Where(p => p.FacilityReportID == reportID).OrderBy(x => x.PollutantCode);
            return data;
        }


        /// <summary>
        /// get waste transfers for a specific facility report and wste type
        /// </summary>
        public static IEnumerable<FACILITYDETAIL_WASTETRANSFER> GetWasteTransfers(int reportID, WasteTypeFilter.Type type)
        {
            string wasteType = EnumUtil.GetStringValue(type);
            DataClassesFacilityDataContext db = getDataContext();
            IEnumerable<FACILITYDETAIL_WASTETRANSFER> data = db.FACILITYDETAIL_WASTETRANSFERs.Where(c => c.FacilityReportID == reportID && c.WasteTypeCode.Equals(wasteType));

            return data;
        }


        #endregion


        // ----------------------------------------------------------------------------------
        // Confidentiality
        // ----------------------------------------------------------------------------------
        #region Confidentiality
        public static bool IsAffectedByConfidentiality(FacilitySearchFilter filter)
        {
            DataClassesFacilityDataContext db = getDataContext();
            ParameterExpression param = Expression.Parameter(typeof(FACILITYSEARCH_ALL), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionFacilitySearchConfidential(filter, param);

            // create lambda according to filters
            Expression<Func<FACILITYSEARCH_ALL, bool>> lambda = Expression.Lambda<Func<FACILITYSEARCH_ALL, bool>>(exp, param);
            // return true if found any
            return getDistinctFacilityReportIds(db, lambda).Any(); 
        }
        #endregion


        #region Map

        /// <summary>
        /// returns the MapFilter (sql and layers) corresponding to the filter. 
        /// </summary>
        public static MapFilter GetMapFilter(FacilitySearchFilter filter)
        {
            Expression<Func<FACILITYSEARCH_ALL, bool>> lambda = getLambdaExpression(filter);

            // create sql and sectors to map
            MapFilter mapFilter = new MapFilter();
            mapFilter.SqlWhere = LinqExpressionBuilder.GetSQL(lambda, lambda.Parameters[0]);
            mapFilter.SetLayers(filter.ActivityFilter);

            return mapFilter;
        }

        #endregion

        #region datacontext
        /// <summary>
        /// creates a new DataCotext and add logger
        /// </summary>
        private static DataClassesFacilityDataContext getDataContext()
        {
            DataClassesFacilityDataContext db = new DataClassesFacilityDataContext();
            db.Log = new DebuggerWriter();
            return db;
        }
        #endregion
    }
}