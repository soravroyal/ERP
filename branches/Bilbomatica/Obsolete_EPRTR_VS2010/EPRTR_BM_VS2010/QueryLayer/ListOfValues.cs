using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using LinqUtilities;
using QueryLayer.LinqFramework;

namespace QueryLayer
{


    /// <summary>
    /// LOV class, used to populate all list values on all search sites (using LINQ)
    /// The LOV's are cached the first time they are accessed.
    /// </summary>
    public static class ListOfValues
    {
        #region LOV caches
        private static List<LOV_ANNEXIACTIVITY> lovAnnexIActivityCache = null;
        private static List<LOV_AREAGROUP> lovAreaGroupCache = null;
        private static List<LOV_COUNTRY> lovCountryCache = null;
        private static List<LOV_COUNTRYAREAGROUP> countryAreaGroupCache = null;
        private static List<LOV_NACEACTIVITY> lovNaceActivityCache = null;
        private static List<LOV_NUTSREGION> lovNUTSRegionCache = null;
        private static List<LOV_POLLUTANT> lovPollutantCache = null;
        private static List<LOV_RIVERBASINDISTRICT> lovRiverBasinDistrictCache = null;
        private static List<RECEIVINGCOUNTRY> receivingCountryCache = null;
        private static List<REPORTINGCOUNTRY> reportingCountryCache = null;
        private static List<REPORTINGYEAR> reportingYearCache = null;
        private static IEnumerable<LOV_Culture> lovCultureCache = null;
        private static IEnumerable<string> lovCultureCodesCache = null;
     

        #endregion

        #region LOV_AREAGROUP
        /// <summary>
        /// Returns a specific LOV_AREAGROUP given by the id
        /// </summary>
        public static LOV_AREAGROUP GetAreaGroup(int lovAreaGroupId)
        {
            return getLovAreaGroupCache().Where(m => m.LOV_AreaGroupID == lovAreaGroupId).Single<LOV_AREAGROUP>();
        }

        /// <summary>
        /// Returns all area groups (EU27, EU25 etc)
        /// </summary>
        public static IEnumerable<LOV_AREAGROUP> AreaGroups()
        {
            return getLovAreaGroupCache();
        }


        private static List<LOV_AREAGROUP> getLovAreaGroupCache()
        {
            if (ListOfValues.lovAreaGroupCache == null)
            {
                DataClassesLOVDataContext db = getLOVDataContext();
                ListOfValues.lovAreaGroupCache = db.LOV_AREAGROUPs.ToList<LOV_AREAGROUP>();

            }
            return ListOfValues.lovAreaGroupCache;
        }


        #endregion

        #region LOV_COUNTRY

        /// <summary>
        /// Returns a specific LOV_COUNTRY given by the id
        /// </summary>
        public static LOV_COUNTRY GetCountry(int lovCountryId)
        {
            return GetLovCountryCache().Where(m => m.LOV_CountryID == lovCountryId).Single<LOV_COUNTRY>();
        }

        /// <summary>
        /// Returns a specific LOV_COUNTRY given by the code
        /// </summary>
        public static LOV_COUNTRY GetCountry(string lovCountryCode)
        {
            return GetLovCountryCache().Where(m => m.Code == lovCountryCode).Single<LOV_COUNTRY>();
        }

        /// <summary>
        /// Returns all reporting countries
        /// </summary>
        public static IEnumerable<REPORTINGCOUNTRY> ReportingCountries()
        {
            IEnumerable<REPORTINGCOUNTRY> countries = getReportingCountryCache().Where(m => m.EndYear == null);
            return countries;
        }


        /// <summary>
        /// Returns a specific REPORTINGCOUNTRY given by the code. Returns null if no country could be found
        /// </summary>
        public static REPORTINGCOUNTRY GetReportingCountry(string countryCode)
        {
            return getReportingCountryCache().Where(m => m.Code == countryCode).SingleOrDefault<REPORTINGCOUNTRY>();
        }


        /// <summary>
        /// Returns all countries receiving waste
        /// </summary>
        public static IEnumerable<RECEIVINGCOUNTRY> ReceivingCountries()
        {
            IEnumerable<RECEIVINGCOUNTRY> countries = GetReceivingCountryCache().Where(m => m.EndYear == null);
            return countries;
        }

        /// <summary>
        /// Returns a list of country ID's within the areagroup given
        /// </summary>
        public static IEnumerable<int> GetCountryIdsInArea(int? areaGroupId)
        {
            DataClassesLOVDataContext db = getLOVDataContext();

            IEnumerable<int> countries = from c in getCountryAreaGroupCache()
                                         where c.LOV_AreaGroupID == areaGroupId
                                         select c.LOV_CountryID;

            return countries;
        }

        private static List<LOV_COUNTRY> GetLovCountryCache()
        {
            if (ListOfValues.lovCountryCache == null)
            {
                DataClassesLOVDataContext db = getLOVDataContext();
                ListOfValues.lovCountryCache = db.LOV_COUNTRies.ToList<LOV_COUNTRY>();

            }
            return ListOfValues.lovCountryCache;
        }

        private static IEnumerable<RECEIVINGCOUNTRY> GetReceivingCountryCache()
        {
            if (ListOfValues.receivingCountryCache == null)
            {
                DataClassesLOVDataContext db = getLOVDataContext();
                ListOfValues.receivingCountryCache = db.RECEIVINGCOUNTRies.ToList<RECEIVINGCOUNTRY>();
                //populate list immediately
            }
            return ListOfValues.receivingCountryCache;
        }

        private static List<REPORTINGCOUNTRY> getReportingCountryCache()
        {
            if (ListOfValues.reportingCountryCache == null)
            {
                DataClassesLOVDataContext db = getLOVDataContext();
                ListOfValues.reportingCountryCache = db.REPORTINGCOUNTRies.ToList<REPORTINGCOUNTRY>();
            }
            return ListOfValues.reportingCountryCache;
        }

        private static List<LOV_COUNTRYAREAGROUP> getCountryAreaGroupCache()
        {
            if (ListOfValues.countryAreaGroupCache == null)
            {
                DataClassesLOVDataContext db = getLOVDataContext();
                ListOfValues.countryAreaGroupCache = db.LOV_COUNTRYAREAGROUPs.ToList<LOV_COUNTRYAREAGROUP>();
            }
            return ListOfValues.countryAreaGroupCache;
        }

        #endregion

        #region LOV_RIVERBASINDISTRICT

        /// <summary>
        /// Returns a specific LOV_RIVERBASINDISTRICT given by the id
        /// </summary>
        public static LOV_RIVERBASINDISTRICT GetRiverBasinDistrict(int lovRiverBasinDistrictId)
        {
            return getLovRiverBasinDistrictCache().Where(m => m.LOV_RiverBasinDistrictID == lovRiverBasinDistrictId).Single<LOV_RIVERBASINDISTRICT>();
        }


        /// <summary>
        /// Returns a specific LOV_RIVERBASINDISTRICT given by the code. Returns null if no country could be found
        /// </summary>
        public static LOV_RIVERBASINDISTRICT GetRiverBasinDistrict(string rbdCode)
        {
            return getLovRiverBasinDistrictCache().Where(m => m.Code == rbdCode).SingleOrDefault<LOV_RIVERBASINDISTRICT>();
        }


        /// <summary>
        /// Return all river basin districts for given country.
        /// </summary>
        public static IEnumerable<LOV_RIVERBASINDISTRICT> RiverBasinDistricts(int countryId)
        {
            IEnumerable<LOV_RIVERBASINDISTRICT> rbds = getLovRiverBasinDistrictCache().Where(m => m.LOV_CountryID == countryId && m.EndYear == null);
            return rbds;
        }

        private static List<LOV_RIVERBASINDISTRICT> getLovRiverBasinDistrictCache()
        {
            if (ListOfValues.lovRiverBasinDistrictCache == null)
            {
                DataClassesLOVDataContext db = getLOVDataContext();
                IEnumerable<LOV_RIVERBASINDISTRICT> data = db.LOV_RIVERBASINDISTRICTs;

                ListOfValues.lovRiverBasinDistrictCache = data.ToList<LOV_RIVERBASINDISTRICT>();
            }
            return ListOfValues.lovRiverBasinDistrictCache;
        }

        #endregion

        #region LOV_ANNEXIACTIVITY

        /// <summary>
        /// Returns a specific LOV_ANNEXIACTIVITY given by the id
        /// </summary>
        public static LOV_ANNEXIACTIVITY GetAnnexIActicvity(int lovAnnexIActivityId)
        {
            return getLovAnnexIActivityCache().Where(m => m.LOV_AnnexIActivityID == lovAnnexIActivityId).Single<LOV_ANNEXIACTIVITY>();
        }

        /// <summary>
        /// Returns a specific LOV_ANNEXIACTIVITY given by the code
        /// </summary>
        public static LOV_ANNEXIACTIVITY GetAnnexIActicvity(string code)
        {
            return getLovAnnexIActivityCache().Where(m => m.Code.Equals(code)).SingleOrDefault<LOV_ANNEXIACTIVITY>();
        }

        /// <summary>
        /// Return all activites with a given parentID. parentID null will return sectors
        /// </summary>
        public static IEnumerable<LOV_ANNEXIACTIVITY> AnnexIActivites(int? parentId)
        {
            IEnumerable<LOV_ANNEXIACTIVITY> activites = getLovAnnexIActivityCache().Where(m => object.Equals(m.ParentID, parentId));
            return activites;
        }

        /// <summary>
        /// Return all AnnexI sectors. 
        /// </summary>
        public static IEnumerable<LOV_ANNEXIACTIVITY> AnnexISectors()
        {
            return AnnexIActivites(null);
        }

        /// <summary>
        /// Return all AnnexI activities within the ids given
        /// </summary>
        public static IEnumerable<LOV_ANNEXIACTIVITY> GetAnnexIActivities(List<int> lovAnnexIActivityIds)
        {
            if (lovAnnexIActivityIds.Count() > 0)
            {
                ParameterExpression param = Expression.Parameter(typeof(LOV_ANNEXIACTIVITY), "s");
                Expression exp = LinqExpressionBuilder.GetInExpr(param, "LOV_AnnexIActivityID", lovAnnexIActivityIds);
                Expression<Func<LOV_ANNEXIACTIVITY, bool>> lambda = Expression.Lambda<Func<LOV_ANNEXIACTIVITY, bool>>(exp, param);

                IEnumerable<LOV_ANNEXIACTIVITY> result = getLovAnnexIActivityCache().AsQueryable<LOV_ANNEXIACTIVITY>().Where(lambda);
                return result;
            }
            else return new List<LOV_ANNEXIACTIVITY>();
        }

        /// <summary>
        /// Return all AnnexI activities within the codes given
        /// </summary>
        public static IEnumerable<LOV_ANNEXIACTIVITY> GetAnnexIActivities(List<string> lovAnnexIActivityCodes)
        {
            IEnumerable<LOV_ANNEXIACTIVITY> result = getLovAnnexIActivityCache().Where<LOV_ANNEXIACTIVITY>(x => lovAnnexIActivityCodes.Contains(x.Code));
            return result;
        }

        private static List<LOV_ANNEXIACTIVITY> getLovAnnexIActivityCache()
        {
            if (ListOfValues.lovAnnexIActivityCache == null)
            {
                DataClassesLOVDataContext db = getLOVDataContext();
                ListOfValues.lovAnnexIActivityCache = db.LOV_ANNEXIACTIVITies.ToList<LOV_ANNEXIACTIVITY>();
            }
            return ListOfValues.lovAnnexIActivityCache;
        }

        #endregion

        #region LOV_NACEACTIVITY


        /// <summary>
        /// Returns a specific LOV_NACEACTIVITY given by the id
        /// </summary>
        public static LOV_NACEACTIVITY GetNaceActicvity(int lovNaceActivityId)
        {
            return getLovNaceActivityCache().Where(m => m.LOV_NACEActivityID == lovNaceActivityId).Single<LOV_NACEACTIVITY>();
        }

        /// <summary>
        /// Return all activites with a given parentID. parentID null will return sectors
        /// </summary>
        public static IEnumerable<LOV_NACEACTIVITY> NaceActivites(int? parentId)
        {
            IEnumerable<LOV_NACEACTIVITY> activites = getLovNaceActivityCache().Where(m => object.Equals(m.ParentID, parentId)).OrderBy(y=> y.Code);
            return activites;
        }

        /// <summary>
        /// Return all NACE sectors. 
        /// </summary>
        public static IEnumerable<LOV_NACEACTIVITY> NaceSectors()
        {
            return NaceActivites(null);
        }

        /// <summary>
        /// Return all NACE activities within the ids given
        /// </summary>
        public static IEnumerable<LOV_NACEACTIVITY> GetNaceActivities(List<int> lovNaceActivityIds)
        {
            ParameterExpression param = Expression.Parameter(typeof(LOV_NACEACTIVITY), "s");
            Expression exp = LinqExpressionBuilder.GetInExpr(param, "LOV_NACEActivityID", lovNaceActivityIds);
            Expression<Func<LOV_NACEACTIVITY, bool>> lambda = Expression.Lambda<Func<LOV_NACEACTIVITY, bool>>(exp, param);

            IEnumerable<LOV_NACEACTIVITY> result = getLovNaceActivityCache().AsQueryable<LOV_NACEACTIVITY>().Where(lambda);
            return result;
        }


        private static List<LOV_NACEACTIVITY> getLovNaceActivityCache()
        {
            if (ListOfValues.lovNaceActivityCache == null)
            {
                DataClassesLOVDataContext db = getLOVDataContext();
                ListOfValues.lovNaceActivityCache = db.LOV_NACEACTIVITies.ToList<LOV_NACEACTIVITY>();
            }
            return ListOfValues.lovNaceActivityCache;
        }

        //public static List<LOV_NACEACTIVITY> GetNaceActivities(

        #endregion

        #region LOV_NUTSREGION

        /// <summary>
        /// Returns a specific LOV_NUTSREGION given by the id
        /// </summary>
        public static LOV_NUTSREGION GetNUTSRegion(int lovNUTSRegionId)
        {
            return getLovNUTSRegionCache().Where(m => m.LOV_NUTSRegionID == lovNUTSRegionId).Single<LOV_NUTSREGION>();
        }

        /// <summary>
        /// Returns a specific LOV_NUTSREGION given by the code. Returns null if no country could be found
        /// </summary>
        public static LOV_NUTSREGION GetNutsRegion(string nutsCode)
        {
            return getLovNUTSRegionCache().Where(m => m.Code == nutsCode).SingleOrDefault<LOV_NUTSREGION>();
        }


        /// <summary>
        /// Return all NUTS regions for given country on the given level. Exclude "Extra" regions
        /// </summary>
        public static IEnumerable<LOV_NUTSREGION> NUTSRegions(int countryId, int level)
        {
            //Extra regions have a code of the format: ##Z, ##ZZ or ##ZZZ where ## is the two digit country code.
            IEnumerable<LOV_NUTSREGION> rbds = getLovNUTSRegionCache().Where(m =>
                                                    m.LOV_CountryID == countryId &&
                                                    m.EndYear == null && m.Level == level &&
                                                    !m.Code.Substring(2).StartsWith("Z"));


            return rbds;
        }

        private static List<LOV_NUTSREGION> getLovNUTSRegionCache()
        {
            if (ListOfValues.lovNUTSRegionCache == null)
            {
                DataClassesLOVDataContext db = getLOVDataContext();
                IEnumerable<LOV_NUTSREGION> data = db.LOV_NUTSREGIONs;

                ListOfValues.lovNUTSRegionCache = data.ToList<LOV_NUTSREGION>();
            }
            return ListOfValues.lovNUTSRegionCache;
        }

        #endregion

        #region LOV_POLLUTANT

        /// <summary>
        /// Returns a specific LOV_POLLUTANT given by the id
        /// </summary>
        public static LOV_POLLUTANT GetPollutant(int lovPollutantId)
        {
            return getLovPollutantCache().Where(m => m.LOV_PollutantID == lovPollutantId).Single<LOV_POLLUTANT>();
        }

        /// <summary>
        /// Returns a specific LOV_POLLUTANT given by the code
        /// </summary>
        public static LOV_POLLUTANT GetPollutant(string code)
        {
            return getLovPollutantCache().Where(m => m.Code == code).Single<LOV_POLLUTANT>();
        }

        /// <summary>
        /// returns true if the LOV_POLLUTANT given by the code is a pollutantGroup (only main groups are considered)
        /// </summary>
        public static bool IsPollutantGroup(string code)
        {
            if (string.IsNullOrEmpty(code)) return false;
            return GetPollutant(code).ParentID == null;
        }

        public static bool IsPollutantGroupEPER(string code, string codeEPER)
        {
            if (string.IsNullOrEmpty(codeEPER)) return false;
            return GetPollutant(code).ParentID == null;
        }

        /// <summary>
        /// Return all pollutants with a given parentID. 
        /// <param name="parentId">parentID null will return main pollutant groups</param>
        /// </summary>
        public static IEnumerable<LOV_POLLUTANT> Pollutants(int? parentId)
        {
            IEnumerable<LOV_POLLUTANT> pollutants = getLovPollutantCache()
                                                    .Where(m => object.Equals(m.ParentID, parentId))
                                                    .OrderBy(p => p.Code);
            return pollutants;
        }

        

        public static IEnumerable<LOV_POLLUTANT> PollutantsEPER(int? parentId)
        {
            int intStartYear = 2001;
            IEnumerable<LOV_POLLUTANT> pollutants = getLovPollutantCache().Where(m => object.Equals(m.ParentID, parentId) && m.StartYear == intStartYear).OrderBy(p => p.Code);
            //&& m.EndYear == null).OrderBy(p => p.Code);
            return pollutants;
        }

        /// <summary>
        /// Return all leaf E-PRTR pollutants within a given group given by parentID. 
        /// Any sub-groups (e.g. BTEX)willnot be added.
        /// <param name="parentId">parentID null will return main pollutant groups</param>
        /// </summary>
        public static IEnumerable<LOV_POLLUTANT> GetLeafPollutants(int parentId)
        {
            List<LOV_POLLUTANT> leafPollutants = new List<LOV_POLLUTANT>();
            int intEndYear = 2007;

            //find pollutants directly beloning to group
            IEnumerable<LOV_POLLUTANT> pollutants = Pollutants(parentId);

            //if pollutant has children add these insted of pollutant.
            foreach (LOV_POLLUTANT p in pollutants)
            {
                IEnumerable<LOV_POLLUTANT> children = GetLeafPollutants(p.LOV_PollutantID);

                //only add EPRTR pollutants
                children = children.Where(m => (m.EndYear == null || m.EndYear >= intEndYear));

                if (children.Count() > 0)
                {
                    leafPollutants.AddRange(children);
                }
                else if (p.EndYear == null || p.EndYear >= intEndYear) //only add EPRTR pollutants
                {
                    leafPollutants.Add(p);
                }

            }

            return leafPollutants.OrderBy(p => p.Code);
        }

        /// <summary>
        public static IEnumerable<LOV_POLLUTANT> GetLeafPollutantsEPER(int parentId)
        {
            List<LOV_POLLUTANT> leafPollutants = new List<LOV_POLLUTANT>();

            //find pollutants directly beloning to group
            IEnumerable<LOV_POLLUTANT> pollutants = PollutantsEPER(parentId);

            //if pollutant has children add these insted of pollutant.
            foreach (LOV_POLLUTANT p in pollutants)
            {
               
                    leafPollutants.Add(p);
        

            }

            return leafPollutants.OrderBy(p => p.Code);
        }

        /// <summary>
        /// Return all leaf pollutants within a given group given by parentCode. 
        /// Any sub-groups (e.g. BTEX)willnot be included, but its children will.
        /// </summary>
        public static int CountLeafPollutants(string parentCode)
        {
            LOV_POLLUTANT group = GetPollutant(parentCode);

            if (group != null)
            {
                return GetLeafPollutants(group.LOV_PollutantID).Count();
            }

            return 0;
        }
        /// <summary>
        /// Return all pollutant groups
        /// </summary>
        public static IEnumerable<LOV_POLLUTANT> PollutantGroups()
        {
            return Pollutants(null);
        }

        public static IEnumerable<LOV_POLLUTANT> PollutantGroupsEPER()
        {
            return PollutantsEPER(null);
        }

        private static List<LOV_POLLUTANT> getLovPollutantCache()
        {
            if (ListOfValues.lovPollutantCache == null)
            {
                DataClassesLOVDataContext db = getLOVDataContext();
                ListOfValues.lovPollutantCache = db.LOV_POLLUTANTs.ToList<LOV_POLLUTANT>();

            }
            return ListOfValues.lovPollutantCache;
        }
     
        #endregion

        #region ReportingYear
        /// <summary>
        /// Return reporting years
        /// </summary>
        /// <param name="showEPER">If true EPERyears (2001+2004) will be returned, otherwise E-PRTR years (>=2007)</param>
        public static IEnumerable<int> ReportYears(bool includeEPER)
        {
            
            if (includeEPER)
            {
                IEnumerable<int> years = new List<int> { 2001, 2004 };
                return years;
            }
            else
            {
                int startYear = includeEPER ? 2001 : 2007;
                IEnumerable<int> years = from y in getReportingYearCache()
                                         where y.Year >= startYear
                                         select y.Year;
                return years;

            }
        }

        public static IEnumerable<int> ReportYearsSeries()
        {
  
                int startYear =  2001;
                IEnumerable<int> years = from y in getReportingYearCache()
                                         where y.Year >= startYear
                                         select y.Year;
                return years;
     
        }
    

        /// <summary>
        /// Return reporting years
        /// </summary>
        /// <param name="showEPER">If true EPERyears (2001+2004) will be returned, otherwise E-PRTR years (>=2007)</param>
        public static IEnumerable<REPORTINGYEAR> ReportingYears(bool includeEPER)
        {
            if (includeEPER)
            {
                int startYear = 2001;
                int endYear = 2004;
                IEnumerable<REPORTINGYEAR> years = getReportingYearCache().Where(y => y.Year >= startYear && y.Year <= endYear).OrderBy(y => y.Year);
                return years;
            }
            else
            {   
                 //(time Series of the Facility Search For E-PRTR)
                IEnumerable<REPORTINGYEAR> years = getReportingYearCache().OrderBy(y => y.Year);
                return years;
            }

        }


        /// <summary>
        /// Return reporting years
        /// </summary>
        /// Time Series of the main menu
        public static IEnumerable<REPORTINGYEAR> ReportingYearsTimeSeries()
        {
                int startYear = 2007; //(time Series)
                IEnumerable<REPORTINGYEAR> years = getReportingYearCache().Where(y => y.Year >= startYear).OrderBy(y => y.Year);
                return years;
        }


        private static List<REPORTINGYEAR> getReportingYearCache()
        {
            if (ListOfValues.reportingYearCache == null)
            {
                DataClassesLOVDataContext db = getLOVDataContext();
                ListOfValues.reportingYearCache = db.REPORTINGYEARs.ToList<REPORTINGYEAR>();

            }
            return ListOfValues.reportingYearCache;
        }

        #endregion

        #region LOV_Regulation

        /// <summary>
        /// Returns the regulation code (EPER or EPRTR) for a given reporting year
        /// </summary>
        public static string GetRegulationCode(int year)
        {
            if (year < 2007)
            {
                return "EPER";
            }
            else
            {
                return "EPRTR";
            }
        }

        #endregion


        #region LOV_Culture

        public static IEnumerable<LOV_Culture> GetAllCultures()
        {
            if (ListOfValues.lovCultureCache == null)
            {
                var db = getCultureDataContext();
                ListOfValues.lovCultureCache = db.LOV_Cultures.ToList();
            }
            return ListOfValues.lovCultureCache;
        }

        public static IEnumerable<string> GetAllCultureCodes()
        {
            if (lovCultureCodesCache == null)
            {
                var db = getCultureDataContext();;
                lovCultureCodesCache = from c in db.LOV_Cultures
                                       select c.Code;
                
                lovCultureCodesCache  =  lovCultureCodesCache.ToList();
            }

            return lovCultureCodesCache;
        }
        #endregion

        #region LatestPublication

        public static DateTime? GetLatestPublicationDate()
        {
            DataClassesLOVDataContext db = getLOVDataContext();
            return db.LATEST_DATAIMPORTs.Max(x => x.Published);
        }

        public static DateTime? GetLatestReviewDate()
        {
            DataClassesLOVDataContext db = getLOVDataContext();
            return db.LATEST_DATAIMPORTs.Max(x => x.ForReview);
        }

        #endregion

        #region Data context
        private static DataClassesLOVDataContext getLOVDataContext()
        {
            DataClassesLOVDataContext db = new DataClassesLOVDataContext();
            db.Log = new DebuggerWriter();
            return db;
        }

        private static DataClassesCultureDataContext getCultureDataContext()
        {
            var db = new DataClassesCultureDataContext();
            db.Log = new DebuggerWriter();
            return db;
        }
        #endregion

    }
}
