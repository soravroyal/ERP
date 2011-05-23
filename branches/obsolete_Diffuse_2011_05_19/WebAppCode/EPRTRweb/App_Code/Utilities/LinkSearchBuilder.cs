using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;

namespace EPRTR.Utilities
{
/// <summary>
/// Parses request to build filters for searches
/// </summary>
    public class LinkSearchBuilder
    {
        #region parameterNames
        //year
        private static string YEAR = "Year";

        //period
        private static string STARTYEAR = "StartYear";
        private static string ENDYEAR = "EndYear";

        //Area
        private static string AREAGROUP = "AreaGroupID";
        private static string COUNTRY = "CountryID";
        private static string REGION = "RegionID";
        private static string REGIONTYPE = "TypeRegion";

        //Activity
        private static string ACTIVITYTYPE = "ActivityType";
        private static string SECTORS = "Sectors";
        private static string ACTIVITIES = "Activities";
        private static string SUBACTIVITIES = "SubActivities";

        //pollutant
        private static string POLLUTANTGROUP = "PollutantGroupID";
        private static string POLLUTANT = "PollutantID";

        //medium
        private static string MEDIUM_AIR = "MediumAir";
        private static string MEDIUM_WATER = "MediumWater";
        private static string MEDIUM_SOIL = "MediumSoil";
        private static string MEDIUM_WASTEWASTER = "MediumWasteWater";

        //waste
        private static string WASTETYPE_HWIC = "HazardousWasteCountry";
        private static string WASTETYPE_HWOC = "HazardousWasteTransboundary";
        private static string WASTETYPE_NONHW = "NonHazardousWaste";

        private static string WASTETREATMENT_D = "WasteTreatmentDisposal";
        private static string WASTETREATMENT_R = "WasteTreatmentRecovery";
        private static string WASTETREATMENT_U = "WasteTreatmentUnspecified";

        private static string WASTERECEIVER = "WasteCountryID";

        //location
        private static string FACILITYLOCATION_NAME = "FacilityLocationName";
        private static string FACILITYLOCATION_CITY = "FacilityLocationCity";

        #endregion

        // --------------------------------------------------------------------------------------------------------------------
        // FacilitySearch Filter
        // --------------------------------------------------------------------------------------------------------------------
        #region FacilitySearchFilter


        public static string SerializeToUrl(FacilitySearchFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                // Area
                result += SerializeToUrl(filter.AreaFilter);
                                
                // Year
                result += SerializeToUrl(filter.YearFilter);

                // Pollutant
                result += SerializeToUrl(filter.PollutantFilter);

                // Medium
                result += SerializeToUrl(filter.MediumFilter);

                // Activity
                result += SerializeToUrl(filter.ActivityFilter);

                // Waste Type
                result += SerializeToUrl(filter.WasteTypeFilter);

                // Waste Receiver
                result += SerializeToUrl(filter.WasteReceiverFilter);

                // Waste Treatment
                result += SerializeToUrl(filter.WasteTreatmentFilter);

                // Location
                result += SerializeToUrl(filter.FacilityLocationFilter);
            }

            result = result.Remove(result.Length - 1);
            return result;
        }


        /// <summary>
        /// returns if request contains paramters for any of the subfilters in FacilitySearchFilter
        /// </summary>
        public static bool HasFacilitySearchFilter(HttpRequest request)
        {
            if (request == null)
                return false;
            else
                return HasAreaFilter(request) ||
                   HasYearFilter(request) ||
                   HasPollutantFilter(request) ||
                   HasMediumFilter(request) ||
                   HasActivityFilter(request) ||
                   HasWasteTypeFilter(request) ||
                   HasWasteReceiverFilter(request) ||
                   HasWasteTreatmentFilter(request);
        }

        #endregion

        // --------------------------------------------------------------------------------------------------------------------
        // Industrial Activity Filter
        // --------------------------------------------------------------------------------------------------------------------
        #region IndustrialActivitySearchFilter

        public static string SerializeToUrl(IndustrialActivitySearchFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                // Area
                result += SerializeToUrl(filter.AreaFilter);

                // Year
                result += SerializeToUrl(filter.YearFilter);

                // Activity
                result += SerializeToUrl(filter.ActivityFilter);
            }

            result = result.Remove(result.Length - 1);
            return result;
        }

        /// <summary>
        /// returns if request contains paramters for any of the subfilters in IndustrialActivitySearchFilter
        /// </summary>
        public static bool HasIndustrialActivitySearchFilter(HttpRequest request)
        {
            if (request == null)
                return false;
            else
                return HasAreaFilter(request) ||
                   HasYearFilter(request) ||
                   HasActivityFilter(request);
        }

        /// <summary>
        /// returns if request contains paramters for any of the subfilters in AreaOverviewSearchFilter
        /// </summary>
        public static bool HasAreaOverviewSearchFilter(HttpRequest request)
        {
            if (request == null)
                return false;
            else
                return HasAreaFilter(request) ||
                   HasYearFilter(request);
        }
        #endregion


        // --------------------------------------------------------------------------------------------------------------------
        // PollutantReleaseSearch Filter
        // --------------------------------------------------------------------------------------------------------------------
        #region PollutantReleaseSearchFilter


        public static string SerializeToUrl(PollutantReleaseSearchFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                // Area
                result += SerializeToUrl(filter.AreaFilter);

                // Year
                result += SerializeToUrl(filter.YearFilter);

                // Pollutant
                result += SerializeToUrl(filter.PollutantFilter);

                // Medium
                result += SerializeToUrl(filter.MediumFilter);

                // Activity
                result += SerializeToUrl(filter.ActivityFilter);
            }

            result = result.Remove(result.Length - 1);
            return result;
        }

        /// <summary>
        /// returns true if request contains paramters for any of the subfilters in PollutantReleaseSearchFilter
        /// </summary>
        public static bool HasPollutantReleaseSearchFilter(HttpRequest request)
        {
            if (request == null)
                return false;
            else
                return HasAreaFilter(request) ||
                   HasYearFilter(request) ||
                   HasPollutantFilter(request) ||
                   HasMediumFilter(request) ||
                   HasActivityFilter(request);
        }

        #endregion


        // --------------------------------------------------------------------------------------------------------------------
        // PollutantTransfersSearchFilter
        // --------------------------------------------------------------------------------------------------------------------
        #region PollutantTransfersSearchFilter


        public static string SerializeToUrl(PollutantTransfersSearchFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                // Area
                result += SerializeToUrl(filter.AreaFilter);

                // Year
                result += SerializeToUrl(filter.YearFilter);

                // Pollutant
                result += SerializeToUrl(filter.PollutantFilter);

                // Activity
                result += SerializeToUrl(filter.ActivityFilter);
            }

            result = result.Remove(result.Length - 1);
            return result;
        }

        /// <summary>
        /// returns if request contains paramters for any of the subfilters in PollutantTransferSearchFilter
        /// </summary>
        public static bool HasPollutantTransferSearchFilter(HttpRequest request)
        {
            if (request == null)
                return false;
            else
                return HasAreaFilter(request) ||
                   HasYearFilter(request) ||
                   HasPollutantFilter(request) ||
                   HasActivityFilter(request);
        }

        #endregion


        // --------------------------------------------------------------------------------------------------------------------
        // PollutantReleasesTimeSeries Filter
        // --------------------------------------------------------------------------------------------------------------------
        #region PollutantReleasesTimeSeriesFilter


        public static string SerializeToUrl(PollutantReleasesTimeSeriesFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                // Area
                result += SerializeToUrl(filter.AreaFilter);

                // Year
                result += SerializeToUrl(filter.PeriodFilter);

                // Pollutant
                result += SerializeToUrl(filter.PollutantFilter);

                // Medium
                result += SerializeToUrl(filter.MediumFilter);

                // Activity
                result += SerializeToUrl(filter.ActivityFilter);
            }

            result = result.Remove(result.Length - 1);
            return result;
        }

        /// <summary>
        /// returns true if request contains paramters for any of the subfilters in PollutantReleasesTimeSeriesFilter
        /// </summary>
        public static bool HasPollutantReleasesTimeSeriesFilter(HttpRequest request)
        {
            if (request == null)
                return false;
            else
                return HasAreaFilter(request) ||
                   HasPeriodFilter(request) ||
                   HasPollutantFilter(request) ||
                   HasMediumFilter(request) ||
                   HasActivityFilter(request);
        }

        #endregion


        // --------------------------------------------------------------------------------------------------------------------
        // PollutantTransferTimeSeries Filter
        // --------------------------------------------------------------------------------------------------------------------
        #region PollutantTransferTimeSeriesFilter


        public static string SerializeToUrl(PollutantTransferTimeSeriesFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                // Area
                result += SerializeToUrl(filter.AreaFilter);

                // Year
                result += SerializeToUrl(filter.PeriodFilter);

                // Pollutant
                result += SerializeToUrl(filter.PollutantFilter);

                // Activity
                result += SerializeToUrl(filter.ActivityFilter);
            }

            result = result.Remove(result.Length - 1);
            return result;
        }

        /// <summary>
        /// returns if request contains paramters for any of the subfilters in PollutantTransferSearchFilter
        /// </summary>
        public static bool HasPollutantTransferTimeSeriesFilter(HttpRequest request)
        {
            if (request == null)
                return false;
            else
                return HasAreaFilter(request) ||
                   HasPeriodFilter(request) ||
                   HasPollutantFilter(request) ||
                   HasActivityFilter(request);
        }

        #endregion

        // --------------------------------------------------------------------------------------------------------------------
        // WasteTransferSearch Filter
        // --------------------------------------------------------------------------------------------------------------------
        #region WasteTransferSearchFilter


        public static string SerializeToUrl(WasteTransferSearchFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                // Area
                result += SerializeToUrl(filter.AreaFilter);

                // Year
                result += SerializeToUrl(filter.YearFilter);

                // Activity
                result += SerializeToUrl(filter.ActivityFilter);

                // Waste Type
                result += SerializeToUrl(filter.WasteTypeFilter);
            }

            result = result.Remove(result.Length - 1);
            return result;
        }

        /// <summary>
        /// returns if request contains paramters for any of the subfilters in WasteTransferSearchFilter
        /// </summary>
        public static bool HasWasteTransferSearchFilter(HttpRequest request)
        {
            if (request == null)
                return false;
            else
                return HasAreaFilter(request) ||
                   HasYearFilter(request) ||
                   HasActivityFilter(request) ||
                   HasWasteTypeFilter(request);
        }

        #endregion

        // --------------------------------------------------------------------------------------------------------------------
        // WasteTransfer Time series Filter
        // --------------------------------------------------------------------------------------------------------------------
        #region WasteTransferTimeSeriesFilter


        public static string SerializeToUrl(WasteTransferTimeSeriesFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                // Area
                result += SerializeToUrl(filter.AreaFilter);

                // Period
                result += SerializeToUrl(filter.PeriodFilter);

                // Activity
                result += SerializeToUrl(filter.ActivityFilter);

                // Waste Type
                result += SerializeToUrl(filter.WasteTypeFilter);
            }

            result = result.Remove(result.Length - 1);
            return result;
        }

        /// <summary>
        /// returns if request contains paramters for any of the subfilters in WasteTransferTimeSeriesFilter
        /// </summary>
        public static bool HasWasteTransferTimeSeriesFilter(HttpRequest request)
        {
            if (request == null)
                return false;
            else
                return HasAreaFilter(request) ||
                   HasPeriodFilter(request) ||
                   HasActivityFilter(request) ||
                   HasWasteTypeFilter(request);
        }

        #endregion


        // --------------------------------------------------------------------------------------------------------------------
        // Year filter
        // --------------------------------------------------------------------------------------------------------------------
        #region YearFilter
        public static bool HasYearFilter(HttpRequest request)
        {
            if (request == null)
                return false;

            List<string> names = new List<string> { YEAR };
            return hasAny(request, names);
        }
        
        private static string SerializeToUrl(YearFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                result += addParameter(YEAR, filter.Year);
            }
            return result;
        }
        
        public static YearFilter GetYearFilter(HttpRequest request)
        {
            if (HasYearFilter(request))
            {
                YearFilter filter = new YearFilter();
                filter.Year = toInt(request.QueryString[YEAR]);
                return filter;
            }
            return null;
        }
        #endregion


        // --------------------------------------------------------------------------------------------------------------------
        // Period filter
        // --------------------------------------------------------------------------------------------------------------------
        #region PeriodFilter
        public static bool HasPeriodFilter(HttpRequest request)
        {
            if (request == null)
                return false;

            List<string> names = new List<string> { STARTYEAR, ENDYEAR };
            return hasAny(request, names);
        }

        private static string SerializeToUrl(PeriodFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                result += addParameter(STARTYEAR, filter.StartYear);
                result += addParameter(ENDYEAR, filter.EndYear);
            }
            return result;
        }

        public static PeriodFilter GetPeriodFilter(HttpRequest request)
        {
            if (HasYearFilter(request))
            {
                PeriodFilter filter = new PeriodFilter();
                filter.StartYear = toInt(request.QueryString[STARTYEAR]);
                filter.EndYear = toInt(request.QueryString[ENDYEAR]);
                return filter;
            }
            return null;
        }
        #endregion

        // --------------------------------------------------------------------------------------------------------------------
        // Area filter
        // --------------------------------------------------------------------------------------------------------------------
        #region AreaFilter

        //will include trailing &
        private static string SerializeToUrl(AreaFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                // Area
                result += addParameter(AREAGROUP, filter.AreaGroupID);
                result += addParameter(COUNTRY, filter.CountryID);
                result += addParameter(REGION, filter.RegionID);
                result += addParameter(REGIONTYPE, filter.TypeRegion.ToString());
            }

            return result;
        }

        public static AreaFilter GetAreaFilter(HttpRequest request)
        {
            if (HasAreaFilter(request))
            {
                AreaFilter filter = new AreaFilter();
                filter.AreaGroupID = toIntNullable(request.QueryString[AREAGROUP]);
                filter.CountryID = toIntNullable(request.QueryString[COUNTRY]);
                filter.RegionID = toIntNullable(request.QueryString[REGION]);
                filter.TypeRegion = toEnum<AreaFilter.RegionType>(request.QueryString[REGIONTYPE]);
                return filter;
            }
            return null;
        }

        public static bool HasAreaFilter(HttpRequest request)
        {
            if (request == null)
                return false;

            List<string> names = new List<string> { AREAGROUP, COUNTRY, REGION, REGIONTYPE };
            return hasAny(request, names);
        }


        public static AreaFilter GetAreaFilter(AreaFilter searchAreaFilter, string areaCode, string parentCode)
        {

            //for total-rows the activityfilter corresponds to the filter from the search
            if (TreeListRow.CODE_TOTAL.Equals(areaCode))
            {
                return searchAreaFilter == null ? null : searchAreaFilter.Clone() as AreaFilter;
            }

            AreaFilter areaFilter = new AreaFilter();
            areaFilter.TypeRegion = searchAreaFilter.TypeRegion;

            // Search for country according to code
            REPORTINGCOUNTRY country = ListOfValues.GetReportingCountry(areaCode);

            if (country != null)
            {
                //country level
                areaFilter.CountryID = country.LOV_CountryID;
                areaFilter.RegionID = AreaFilter.AllRegionsInCountryID;
            }
            else
            {
                country = ListOfValues.GetReportingCountry(parentCode);
                areaFilter.CountryID = country.LOV_CountryID;

                //NUTS or RBD level
                if (areaFilter.TypeRegion.Equals(AreaFilter.RegionType.RiverBasinDistrict))
                {
                    LOV_RIVERBASINDISTRICT rbd = ListOfValues.GetRiverBasinDistrict(areaCode);
                    if (rbd != null)
                    {
                        areaFilter.RegionID = rbd.LOV_RiverBasinDistrictID;
                    }
                }
                else if (areaFilter.TypeRegion.Equals(AreaFilter.RegionType.NUTSregion))
                {
                    LOV_NUTSREGION nuts = ListOfValues.GetNutsRegion(areaCode);

                    if (nuts != null && !TreeListRow.CODE_UNKNOWN.Equals(areaCode))
                    {
                        areaFilter.RegionID = nuts.LOV_NUTSRegionID;
                    }
                    else
                    {
                        areaFilter.RegionID = null;
                    }
                }
            }


            return areaFilter;
        }

        #endregion

        // --------------------------------------------------------------------------------------------------------------------
        // Activity filter
        // --------------------------------------------------------------------------------------------------------------------
        #region ActivityFilter

        private static string SerializeToUrl(ActivityFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                result += addParameter(ACTIVITYTYPE, filter.ActivityType.ToString());
                result += addParameter(SECTORS, listOfValues(filter.SectorIds, ActivityFilter.AllSectorsID));
                result += addParameter(ACTIVITIES, listOfValues(filter.ActivityIds, ActivityFilter.AllActivitiesInSectorID));
                result += addParameter(SUBACTIVITIES, listOfValues(filter.SubActivityIds, ActivityFilter.AllSubActivitiesInActivityID));
            }

            return result;
        }

        public static ActivityFilter GetActivityFilter(HttpRequest request)
        {

            if (HasActivityFilter(request))
            {
                ActivityFilter filter = new ActivityFilter();
                filter.ActivityType = toEnum<ActivityFilter.Type>(request.QueryString[ACTIVITYTYPE]);
                filter.SectorIds = toList(request.QueryString[SECTORS], ActivityFilter.AllSectorsID);
                filter.ActivityIds = toList(request.QueryString[ACTIVITIES], ActivityFilter.AllActivitiesInSectorID);
                filter.SubActivityIds = toList(request.QueryString[SUBACTIVITIES], ActivityFilter.AllSubActivitiesInActivityID);
                return filter;
            }
            return null;
        }

        public static bool HasActivityFilter(HttpRequest request)
        {
            if (request == null)
                return false;

            List<string> names = new List<string> { ACTIVITYTYPE, SECTORS, ACTIVITIES, SUBACTIVITIES };
            return hasAny(request, names);
        }

        
        /// <summary>
        /// GetActivityFilter
        /// </summary>
        /// <param name="searchActivityFilter">Input filter is discarded after this method is run</param>
        /// <param name="code">Note: code can be sector, activity or subactivity code</param>
        /// <param name="parentCode"></param>
        /// <returns></returns>
        public static ActivityFilter GetActivityFilter(ActivityFilter searchActivityFilter, string code, string parentCode)
        {
            //for total-rows the activityfilter corresponds to the filter from the search
            if (TreeListRow.CODE_TOTAL.Equals(code))
            {
                return searchActivityFilter == null ? null : searchActivityFilter.Clone() as ActivityFilter;
            }

            ActivityFilter activityfilter = new ActivityFilter();

            LOV_ANNEXIACTIVITY parent = ListOfValues.GetAnnexIActicvity(parentCode);
            LOV_ANNEXIACTIVITY selected = ListOfValues.GetAnnexIActicvity(code);

            if (parent == null)
            {
                //selected is on sectorlevel
                activityfilter.SectorIds.Add(selected.LOV_AnnexIActivityID);
                activityfilter.ActivityIds.Add(ActivityFilter.AllActivitiesInSectorID);
                activityfilter.SubActivityIds.Add(ActivityFilter.AllSubActivitiesInActivityID);
            }
            else
            {
                //selected is on sectorlevel or activity 
                if (parent.ParentID == null)
                {
                    //selected is on activity level
                    activityfilter.SectorIds.Add(parent.LOV_AnnexIActivityID);
                    activityfilter.ActivityIds.Add(selected.LOV_AnnexIActivityID);
                    activityfilter.SubActivityIds.Add(ActivityFilter.AllSubActivitiesInActivityID);

                }
                else
                {
                    //selected is on subactivity level
                    LOV_ANNEXIACTIVITY sector = ListOfValues.GetAnnexIActicvity((int)parent.ParentID);
                    activityfilter.SectorIds.Add(sector.LOV_AnnexIActivityID);
                    activityfilter.ActivityIds.Add(parent.LOV_AnnexIActivityID);

                    if (TreeListRow.CODE_UNSPECIFIED.Equals(code))
                    {
                        activityfilter.SubActivityIds.Add(ActivityFilter.SubActivitiesUnspecifiedID);
                    }
                    else
                    {
                        activityfilter.SubActivityIds.Add(selected.LOV_AnnexIActivityID);
                    }
                }
            }
            return activityfilter;
        }

        #endregion

        // --------------------------------------------------------------------------------------------------------------------
        // Pollutant filter
        // --------------------------------------------------------------------------------------------------------------------
        #region PollutantFilter
        private static string SerializeToUrl(PollutantFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                result += addParameter(POLLUTANTGROUP, filter.PollutantGroupID);
                result += addParameter(POLLUTANT, filter.PollutantID);
            }
            return result;
        }

        public static PollutantFilter GetPollutantFilter(HttpRequest request)
        {
            if (HasPollutantFilter(request))
            {
                PollutantFilter filter = new PollutantFilter();
                filter.PollutantGroupID = toInt(request.QueryString[POLLUTANTGROUP]);
                filter.PollutantID = toInt(request.QueryString[POLLUTANT]);
                return filter;
            }
            return null;
        }

        public static bool HasPollutantFilter(HttpRequest request)
        {
            if (request == null)
                return false;

            List<string> names = new List<string> { POLLUTANTGROUP, POLLUTANT };
            return hasAny(request, names);
        }

        /// <summary>
        /// GetPollutantFilter
        /// </summary>
        public static PollutantFilter GetPollutantFilter(string code, int level)
        {
            PollutantFilter filter = new PollutantFilter();
            LOV_POLLUTANT pollutant = ListOfValues.GetPollutant(code);

            if (level == 1)
            {
                if (pollutant.ParentID != null)
                {
                    filter.PollutantID = pollutant.LOV_PollutantID;
                    filter.PollutantGroupID = pollutant.ParentID.Value;
                }
                else
                {
                    // confidential in group, same id
                    filter.PollutantID = pollutant.LOV_PollutantID;
                    filter.PollutantGroupID = pollutant.LOV_PollutantID;
                }
            }
            else if (level == 0)
            {
                filter.PollutantID = PollutantFilter.AllPollutantsInGroupID;
                filter.PollutantGroupID = pollutant.LOV_PollutantID;
            }

            return filter;
        }

        #endregion

        // --------------------------------------------------------------------------------------------------------------------
        // Medium filter
        // --------------------------------------------------------------------------------------------------------------------
        #region MediumFilter
        
        private static string SerializeToUrl(MediumFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                result += addParameter(MEDIUM_AIR, filter.ReleasesToAir ? 1 : 0);
                result += addParameter(MEDIUM_SOIL, filter.ReleasesToSoil ? 1 : 0);
                result += addParameter(MEDIUM_WATER, filter.ReleasesToWater ? 1 : 0);
                result += addParameter(MEDIUM_WASTEWASTER, filter.TransferToWasteWater ? 1 : 0);
            }

            return result;
        }

        public static MediumFilter GetMediumFilter(HttpRequest request)
        {
            if (HasMediumFilter(request))
            {
                MediumFilter filter = new MediumFilter();
                filter.ReleasesToAir = toBool(request.QueryString[MEDIUM_AIR]);
                filter.ReleasesToWater = toBool(request.QueryString[MEDIUM_WATER]);
                filter.ReleasesToSoil = toBool(request.QueryString[MEDIUM_SOIL]);
                filter.TransferToWasteWater = toBool(request.QueryString[MEDIUM_WASTEWASTER]);
                return filter;
            }
            return null;
        }

        public static bool HasMediumFilter(HttpRequest request)
        {
            if (request == null)
                return false;

            List<string> names = new List<string> { MEDIUM_AIR, MEDIUM_WATER, MEDIUM_SOIL, MEDIUM_WASTEWASTER };
            return hasAny(request, names);
        }

        /// <summary>
        /// GetMediumFilter
        /// </summary>
        public static MediumFilter GetMediumFilter(bool air, bool water, bool soil, bool wastewater)
        {
            MediumFilter filter = new MediumFilter();
            filter.TransferToWasteWater = wastewater;
            filter.ReleasesToAir = air;
            filter.ReleasesToWater = water;
            filter.ReleasesToSoil = soil;
            return filter;
        }

        #endregion

        // --------------------------------------------------------------------------------------------------------------------
        // WasteType filter
        // --------------------------------------------------------------------------------------------------------------------
        #region WasteTypeFilter

        private static string SerializeToUrl(WasteTypeFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                result += addParameter(WASTETYPE_HWIC, filter.HazardousWasteCountry ? 1 : 0);
                result += addParameter(WASTETYPE_HWOC, filter.HazardousWasteTransboundary ? 1 : 0);
                result += addParameter(WASTETYPE_NONHW, filter.NonHazardousWaste ? 1 : 0);
            }
            return result;
        }

        public static WasteTypeFilter GetWasteTypeFilter(HttpRequest request)
        {
            if (HasWasteTypeFilter(request))
            {
                WasteTypeFilter filter = new WasteTypeFilter();
                filter.HazardousWasteCountry = toBool(request.QueryString[WASTETYPE_HWIC]);
                filter.HazardousWasteTransboundary = toBool(request.QueryString[WASTETYPE_HWOC]);
                filter.NonHazardousWaste = toBool(request.QueryString[WASTETYPE_NONHW]);
                return filter;
            }
            return null;
        }

        public static bool HasWasteTypeFilter(HttpRequest request)
        {
            if (request == null)
                return false;

            List<string> names = new List<string> { WASTETYPE_HWIC, WASTETYPE_HWOC, WASTETYPE_NONHW };
            return hasAny(request, names);

        }

        /// <summary>
        /// GetWasteTypeFilter
        /// </summary>
        public static WasteTypeFilter GetWasteTypeFilter(string code)
        {
            code = code.ToUpper();
            WasteTypeFilter filter = new WasteTypeFilter();

            // get transfer waste type
            string nonhw = EnumUtil.GetStringValue(WasteTypeFilter.Type.NonHazardous);
            string hwic = EnumUtil.GetStringValue(WasteTypeFilter.Type.HazardousCountry);
            string hwoc = EnumUtil.GetStringValue(WasteTypeFilter.Type.HazardousTransboundary);
            string hw = EnumUtil.GetStringValue(WasteTypeFilter.Type.Hazardous);

            if (code.Equals(hw))
            {
                filter.NonHazardousWaste = false;
                filter.HazardousWasteCountry = true;
                filter.HazardousWasteTransboundary = true;
            }
            else
            {
                filter.NonHazardousWaste = code.Equals(nonhw);
                filter.HazardousWasteCountry = code.Equals(hwic);
                filter.HazardousWasteTransboundary = code.Equals(hwoc);
            }

            return filter;
        }
        #endregion

        // --------------------------------------------------------------------------------------------------------------------
        // WasteTreatment filter
        // --------------------------------------------------------------------------------------------------------------------
        #region WasteTreamentFilter

        private static string SerializeToUrl(WasteTreatmentFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                result += addParameter(WASTETREATMENT_D, filter.Disposal ? 1 : 0);
                result += addParameter(WASTETREATMENT_R, filter.Recovery ? 1 : 0);
                result += addParameter(WASTETREATMENT_U, filter.Unspecified ? 1 : 0);
            }

            return result;
        }

        public static WasteTreatmentFilter GetWasteTreatmentFilter(HttpRequest request)
        {
            if (HasWasteTreatmentFilter(request))
            {
                WasteTreatmentFilter filter = new WasteTreatmentFilter();
                filter.Disposal = toBool(request.QueryString[WASTETREATMENT_D]);
                filter.Recovery = toBool(request.QueryString[WASTETREATMENT_R]);
                filter.Unspecified = toBool(request.QueryString[WASTETREATMENT_U]);
                return filter;
            }
            return null;
        }

        public static bool HasWasteTreatmentFilter(HttpRequest request)
        {
            if (request == null)
                return false;

            List<string> names = new List<string> { WASTETREATMENT_D, WASTETREATMENT_R, WASTETREATMENT_U };
            return hasAny(request, names);
        }

        /// <summary>
        /// GetWasteTreatmentFilter
        /// </summary>
        public static WasteTreatmentFilter GetWasteTreatmentFilter(bool unspecified, bool recovery, bool disposal)
        {
            WasteTreatmentFilter filter = new WasteTreatmentFilter();
            filter.Unspecified = unspecified;
            filter.Recovery = recovery;
            filter.Disposal = disposal;
            return filter;
        }
        #endregion

        // --------------------------------------------------------------------------------------------------------------------
        // WasteReceiver filter
        // --------------------------------------------------------------------------------------------------------------------
        #region WasteReceiverFilter

        private static string SerializeToUrl(WasteReceiverFilter filter)
        {
            string result = String.Empty;

            if (filter != null)
            {
                result += addParameter(WASTERECEIVER, filter.CountryID);
            }

            return result;
        }

        public static WasteReceiverFilter GetWasteReceiverFilter(HttpRequest request)
        {
            if (HasWasteReceiverFilter(request))
            {
                WasteReceiverFilter filter = new WasteReceiverFilter();
                filter.CountryID = toInt(request.QueryString[WASTERECEIVER]);
                return filter;
            }
            return null;
        }

        public static bool HasWasteReceiverFilter(HttpRequest request)
        {
            if (request == null)
                return false;

            List<string> names = new List<string> { WASTERECEIVER };
            return hasAny(request, names);
        }
        #endregion



        // --------------------------------------------------------------------------------------------------------------------
        // WasteReceiver filter
        // --------------------------------------------------------------------------------------------------------------------
        #region LocalisationFilter

        private static string SerializeToUrl(FacilityLocationFilter filter)
        {
            string result = String.Empty;
            if (filter != null)
            {
                result += addParameter(FACILITYLOCATION_NAME, filter.FacilityName);
                result += addParameter(FACILITYLOCATION_CITY, filter.CityName);
            }
            return result;
        }

        public static FacilityLocationFilter GetFacilityLocationFilter(HttpRequest request)
        {
            if (HasFacilityLocationFilter(request))
            {
                FacilityLocationFilter filter = new FacilityLocationFilter();
                filter.FacilityName = request.QueryString[FACILITYLOCATION_NAME];
                filter.CityName = request.QueryString[FACILITYLOCATION_CITY];
                return filter;
            }
            return null;
        }

        public static bool HasFacilityLocationFilter(HttpRequest request)
        {
            if (request == null)
                return false;

            List<string> names = new List<string> { FACILITYLOCATION_NAME, FACILITYLOCATION_CITY };
            return hasAny(request, names);
        }

        #endregion


        // --------------------------------------------------------------------------------------------------------------------
        // Helper functions
        // --------------------------------------------------------------------------------------------------------------------
        #region helperfunctions

        private static string addParameter(string param, int? value)
        {
            if (value.HasValue)
                return String.Format("{0}={1}&", param, value);
            return String.Empty;
        }
        /*private static string addParameter(string param, string value)
        {
            return String.Format("{0}={1}&", param, value);
        }
        */
        private static string addParameter(string param, object value)
        {
            if (value == null) return String.Empty;
            return String.Format("{0}={1}&", param, value);
        }

        private static string listOfValues(List<int> values, int all)
        {
            string result = String.Empty;
            if (values != null && values.Count > 0)
            {
                foreach (var item in values)
                    result += item.ToString() + ",";
            }
            else
                result += all.ToString() + ",";
            return result;
        }

        private static int toInt(string value)
        {
            int v = -1;
            try
            {
                v = Convert.ToInt32(value);
            }
            catch { /*ignore all errors*/ }
            return v;
        }
        private static int? toIntNullable(string value)
        {
            if (String.IsNullOrEmpty(value)) return null;
            int? v = null;
            try
            {
                v = Convert.ToInt32(value);
            }
            catch { /*ignore all errors*/  }
            return v;
        }
        private static bool toBool(string value)
        {
            if (String.IsNullOrEmpty(value)) return false;
            return value.Equals("1") ? true : false;
        }

        private static List<int> toList(string value, int all)
        {
            // empty list with all as default
            if (String.IsNullOrEmpty(value)) return new List<int>() { all };

            // fill list with values
            List<int> result = new List<int>();

            string[] elements = value.Split(',');
            for (int i = 0; i < elements.Length; i++)
            {
                if (!String.IsNullOrEmpty(elements[i]))
                    result.Add(toInt(elements[i]));
            }

            // default is all, if no elements is found
            if (result.Count == 0)
                result.Add(all);

            return result;
        }

        private static T toEnum<T>(string s)
        {
            if (String.IsNullOrEmpty(s)) return default(T);
            return (T)Enum.Parse(typeof(T), s);
        }

        private static bool hasAny(HttpRequest request, List<string> names)
        {
            bool hasAny = false;
            foreach (string name in names)

                for (int i = 0; !hasAny && i < names.Count(); i++)
                {
                    hasAny = !String.IsNullOrEmpty(request.QueryString[name]);
                }

            return hasAny;
        }
        #endregion












    }
}
