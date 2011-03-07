using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer;
using EPRTR.Localization;
using EPRTR.Formatters;
using QueryLayer.Filters;
using EPRTR.Utilities;
using QueryLayer.Utilities;

namespace EPRTR.HeaderBuilders
{
    /// <summary>
    /// Base classe to builds headers for sheets and CSV files
    /// </summary>
    public abstract class HeaderBuilder
    {

        #region Facilitydetails

        //creates header for facility ids and adds to dictionary
        protected static void addFacilityIdentification(Dictionary<string, string> header, Facility.FacilityBasic basic)
        {
            if (basic != null)
            {
                header.Add(Resources.GetGlobal("Facility", "EPRTRFacilityID"), basic.FacilityID.ToString());
                header.Add(Resources.GetGlobal("Facility", "NationalID"), basic.NationalID);
            }
        }

        //creates header for facility name and adds to dictionary
        protected static void addFacilityName(Dictionary<string, string> header, Facility.FacilityBasic basic)
        {
            if (basic != null)
            {
                header.Add(Resources.GetGlobal("Facility", "FacilityName"), ConfidentialFormat.Format(basic.FacilityName, basic.Confidential));
            }
        }

        //creates header for facility address and adds to dictionary
        protected static void addFacilityAddress(Dictionary<string, string> header, Facility.FacilityBasic basic)
        {
            if (basic != null)
            {
                header.Add(Resources.GetGlobal("Facility", "FacilityAddress"), AddressFormat.Format(basic.Address, basic.City, basic.PostalCode, basic.Confidential));
            }
        }

        //creates header for facility country and adds to dictionary
        protected static void addFacilityCountry(Dictionary<string, string> header, Facility.FacilityBasic basic)
        {
            if (basic != null)
            {
                header.Add(Resources.GetGlobal("Common", "Country"), LOVResources.CountryName(basic.CountryCode));
            }
        }

        //creates header for facility reproting year and adds to dictionary
        protected static void addFacilityYear(Dictionary<string, string> header, Facility.FacilityBasic basic)
        {
            if (basic != null)
            {
                string key = Resources.GetGlobal("Common", "Year");

                string published;
                if (basic.Published.HasValue)
                {
                    published = string.Format("{0}: {1}", Resources.GetGlobal("Common", "Published"), basic.Published.Format());
                }
                else
                {
                    published = Resources.GetGlobal("Common", "NotPublished");
                }
                string value = string.Format("{0} ({1})", basic.ReportingYear.ToString(), published);

                header.Add(key, value);
            }
        }


        //creates header for regulation (unformal) used in reporting and adds to dictionary
        protected static void addRegulation(Dictionary<string, string> header, int reportingYear)
        {
            string key = Resources.GetGlobal("Common", "Regulation");

            string code = ListOfValues.GetRegulationCode(reportingYear);
            string value = LOVResources.RegulationName(code);

            header.Add(key, value);
        }


        //creates header for regulation (legal name) used in reporting and adds to dictionary
        protected static void addLegalRegulation(Dictionary<string, string> header, int reportingYear)
        {
            string key = Resources.GetGlobal("Common", "Regulation");

            string code = ListOfValues.GetRegulationCode(reportingYear);
            string value = LOVResources.LegalRegulationName(code);

            header.Add(key, value);
        }

        #endregion

        #region headers for subfilters
        //creates header for Area and adds to dictionary
        protected static void addArea(Dictionary<string, string> header, AreaFilter filter)
        {
            if (filter != null)
            {
                string key = Resources.GetGlobal("Common", "Area");
                string value = string.Empty;

                AreaFilter.Level level = filter.SearchLevel();

                if (level == AreaFilter.Level.AreaGroup)
                {
                    string code = ListOfValues.GetAreaGroup((int)filter.AreaGroupID).Code;
                    value = LOVResources.AreaGroupName(code);
                }
                else if (level == AreaFilter.Level.Country)
                {
                    string code = ListOfValues.GetCountry((int)filter.CountryID).Code;
                    value = LOVResources.CountryName(code);
                }
                else if (level == AreaFilter.Level.Region)
                {
                    if (filter.TypeRegion == AreaFilter.RegionType.RiverBasinDistrict)
                    {
                        string code = ListOfValues.GetRiverBasinDistrict((int)filter.RegionID).Code;
                        value = LOVResources.RiverBasinDistrictName(code);
                    }
                    else if (filter.TypeRegion == AreaFilter.RegionType.NUTSregion)
                    {
                        if (filter.RegionID != null)
                        {
                            string code = ListOfValues.GetNUTSRegion((int)filter.RegionID).Code;
                            value = LOVResources.NutsRegionName(code);
                        }
                        else
                        {
                            value = LOVResources.NutsRegionName(TreeListRow.CODE_UNKNOWN);
                        }
                    }
                    else
                    {
                        throw new InvalidOperationException(string.Format("Illgegal RegionType {0}", filter.TypeRegion));
                    }

                }

                header.Add(key, value);
            }
        }

        //creates header for Year and adds to dictionary
        protected static void addYear(Dictionary<string, string> header, YearFilter filter)
        {
            if (filter != null)
            {
                string key = Resources.GetGlobal("Common", "Year");
                string value = filter.Year.ToString();
                header.Add(key, value);
            }
        }
        
        /// <summary>
        /// creates header for Area and adds to dictionary
        /// </summary>
        protected static void addActivity(Dictionary<string, string> header, ActivityFilter filter)
        {
            if (filter != null)
            {
                // set the key 
                string key;

                switch (filter.ActivityType)
                {
                    case ActivityFilter.Type.AnnexI:
                        key = Resources.GetGlobal("Activity", "AnnexI");
                        break;
                    case ActivityFilter.Type.NACE:
                        key = Resources.GetGlobal("Activity", "NACE");
                        break;
                    case ActivityFilter.Type.IPPC:
                        key = Resources.GetGlobal("Activity", "IPPC");
                        break;
                    default:
                        key = "";
                        break;
                }


                // set the value
                string value = string.Empty;

                ActivityFilter.Level level = filter.SearchLevel();

                if (level == ActivityFilter.Level.All)
                {
                    value = Resources.GetGlobal("Common", "AllSectors");
                }
                else
                {
                    switch(filter.ActivityType)
                    {
                        case ActivityFilter.Type.AnnexI:
                            {
                                value = GetActivityAnnexI(filter);
                                break;
                            }
                        case ActivityFilter.Type.NACE:
                            {
                                value = GetActivityNACE(filter);
                                break;
                            }
                        case ActivityFilter.Type.IPPC:
                            {
                                //value = GetActivityIPPC(filter);
                                break;
                            }
                        default:
                            {
                                break;
                            }
                    }
                }
                header.Add(key, value);
            }
        }

        private static string GetActivityAnnexI(ActivityFilter filter)
        {
            ActivityFilter.Level level = filter.SearchLevel();

            // return value: string describing the activity
            string value = "";

            if (level == ActivityFilter.Level.Sector)
            {
                if (filter.SectorIds.Count() == 1)
                {
                    value = LOVResources.AnnexIActivityName(filter.SectorIds.First());
                }
                else
                {
                    value = Resources.GetGlobal("Common", "SeveralSectors");
                }

            }
            else if (level == ActivityFilter.Level.Activity)
            {
                if (filter.ActivityIds.Count() == 1)
                {
                    value = LOVResources.AnnexIActivityName(filter.ActivityIds.First());
                }
                else
                {
                    //only only sector will be selected
                    string sector = LOVResources.AnnexIActivityName(filter.SectorIds.First());
                    value = string.Format(Resources.GetGlobal("Common", "SeveralActivities"), sector);
                }


            }
            else if (level == ActivityFilter.Level.SubActivity)
            {
                
                if (filter.SubActivityIds.Count() == 1)
                {
                    int id = filter.SubActivityIds.First();

                    if(id.Equals(ActivityFilter.SubActivitiesUnspecifiedID))
                    {
                        value = Resources.GetGlobal("Common", "Unspecified");
                    } 
                    else
                    {
                        value = LOVResources.AnnexIActivityName(id);
                    }
                }
                else
                {
                    //only one activity will be selected
                    string activity = LOVResources.AnnexIActivityName(filter.ActivityIds.First());
                    value = string.Format(Resources.GetGlobal("Common", "SeveralSubActivities"), activity);
                }
            }

            return value;
        }

        private static string GetActivityNACE(ActivityFilter filter)
        {
            ActivityFilter.Level level = filter.SearchLevel();

            // return value: string describing the activity
            string value = "";

            if (level == ActivityFilter.Level.Sector)
            {
                if (filter.SectorIds.Count() == 1)
                {
                    value = LOVResources.NaceActivityName(filter.SectorIds.First());
                }
                else
                {
                    value = Resources.GetGlobal("Common", "SeveralSectors");
                }
            }
            else if (level == ActivityFilter.Level.Activity)
            {
                if (filter.ActivityIds.Count() == 1)
                {
                    value = LOVResources.NaceActivityName(filter.ActivityIds.First());
                }
                else
                {
                    //only one sector is selceted
                    string sector = LOVResources.NaceActivityName(filter.SectorIds.First());
                    value = string.Format(Resources.GetGlobal("Common", "SeveralActivities"), sector);
                }


            }
            else if (level == ActivityFilter.Level.SubActivity)
            {
                if (filter.SubActivityIds.Count() == 1)
                {
                    //NACE cannot be unspecified
                    value = LOVResources.NaceActivityName(filter.SubActivityIds.First());
                }
                else
                {
                    //only one activity is selcted
                    string activity = LOVResources.NaceActivityName(filter.ActivityIds.First());
                    value = string.Format(Resources.GetGlobal("Common", "SeveralSubActivities"), activity);
                }
            }

            return value;
        }


        //creates header for Pollutant filter and adds to dictionary
        protected static void addPollutant(Dictionary<string, string> header, PollutantFilter filter)
        {
            if (filter != null)
            {
                string key = Resources.GetGlobal("Common", "Pollutant");
                string value = string.Empty;

                PollutantFilter.Level level = filter.SearchLevel();

                if (level == PollutantFilter.Level.All)
                {
                    value = Resources.GetGlobal("Common", "AllPollutants");
                }
                else if (level == PollutantFilter.Level.PollutantGroup)
                {
                    value = LOVResources.PollutantGroupName(ListOfValues.GetPollutant(filter.PollutantGroupID).Code);
                }
                else
                {
                    value = LOVResources.PollutantName(ListOfValues.GetPollutant(filter.PollutantID).Code);
                }

                header.Add(key, value);
            }
        }

        //creates header for Pollutant filter and adds to dictionary
        protected static void addPollutant(Dictionary<string, string> header, string pollutantCode)
        {
            if (!string.IsNullOrEmpty(pollutantCode))
            {
                string key = Resources.GetGlobal("Common", "Pollutant");
                string value = LOVResources.PollutantName(pollutantCode);

                header.Add(key, value);
            }
        }

        protected static void addPollutantEPER(Dictionary<string, string> header, string pollutantCodeEPER, string pollutantCode)
        {
            if (!string.IsNullOrEmpty(pollutantCode))
            {
                string key = Resources.GetGlobal("Common", "ContentEmissions");
                string value = LOVResources.PollutantNameEPER(pollutantCode, pollutantCodeEPER);

                header.Add(key, value);
            }
        }

        //creates header for Pollutant group and adds to dictionary
        protected static void addPollutantGroup(Dictionary<string, string> header, int pollutantGroupId)
        {
            if (pollutantGroupId != null)
            {
                string key = Resources.GetGlobal("Common", "PollutantGroup");
                string value = LOVResources.PollutantGroupName(pollutantGroupId);

                header.Add(key, value);
            }
        }

        /// <summary>
        ///Creates header for number of facilities and adds to dictionary. Includes both total count in search and specific count. 
        /// </summary>
        protected static void addCount(Dictionary<string, string> header, int countTotal, int count)
        {
            string tot = String.Format("({0}: {1})", Resources.GetGlobal("Common", "TotalInSearch"),NumberFormat.Format(countTotal));
            String value = String.Format("{0} {1}", NumberFormat.Format(count), tot);
            header.Add(Resources.GetGlobal("Common", "Facilities"), value);
        }

        //creates header for number of facilities and adds to dictionary
        protected static void addCount(Dictionary<string, string> header, int count)
        {
            header.Add(Resources.GetGlobal("Common", "Facilities"), NumberFormat.Format(count));
        }

        //creates header for Facility location (facility/parent company name and town/village) and adds to dictionary
        protected static void addFacilityLocation(Dictionary<string, string> header, FacilityLocationFilter filter)
        {
            if (filter != null)
            {
                if (!string.IsNullOrEmpty(filter.FacilityName))
                {
                    header.Add(Resources.GetGlobal("Common", "FacilityParentCompanyName"), filter.FacilityName);
                }
                if (!string.IsNullOrEmpty(filter.CityName))
                {
                    header.Add(Resources.GetGlobal("Common", "TownVillage"), filter.CityName);
                }
            }
        }


        //creates header for medium (releases and transfers)and adds to dictionary
        protected static void addMedium(Dictionary<string, string> header, MediumFilter filter)
        {
            if (filter != null)
            {

                string value = string.Empty;

                //releases
                if (filter.ReleasesToAir)
                {
                    value = addResource(value, "LOV_MEDIUM", "AIR");
                }
                if (filter.ReleasesToWater)
                {
                    value = addResource(value, "LOV_MEDIUM", "WATER");
                }
                if (filter.ReleasesToSoil)
                {
                    value = addResource(value, "LOV_MEDIUM", "LAND");
                }

                if (!String.IsNullOrEmpty(value))
                {
                    header.Add(Resources.GetGlobal("Common", "ReleasesTo"), value);
                }

                //transfers
                if (filter.TransferToWasteWater)
                {
                    header.Add(Resources.GetGlobal("Common", "TransfersTo"), Resources.GetGlobal("LOV_MEDIUM", "WASTEWATER"));
                }
            }

        }

        //creates header for medium and adds to dictionary
        protected static void addMedium(Dictionary<string, string> header, MediumFilter.Medium medium)
        {
            addMedium(header, new MediumFilter(medium));
        }

        //creates header for waste type and adds to dictionary
        protected static void addWasteType(Dictionary<string, string> header, WasteTypeFilter filter)
        {
            if (filter != null)
            {
                string delimiter = "; ";
                string value = string.Empty;

                if (filter.NonHazardousWaste)
                {
                    value = addResource(value, "LOV_WASTETYPE", "NON-HW", delimiter);
                }
                if (filter.HazardousWasteCountry)
                {
                    value = addResource(value, "LOV_WASTETYPE", "HWIC", delimiter);
                }
                if (filter.HazardousWasteTransboundary)
                {
                    value = addResource(value, "LOV_WASTETYPE", "HWOC", delimiter);
                }

                if (!String.IsNullOrEmpty(value))
                {
                    header.Add(Resources.GetGlobal("Common", "WasteTransfers"), value);
                }
            }

        }

         //creates header for waste type and adds to dictionary
        protected static void addWasteType(Dictionary<string, string> header, WasteTypeFilter.Type wasteType)
        {
            addWasteType(header, new WasteTypeFilter(wasteType));
        }


        //creates header for waste treatment and adds to dictionary
        protected static void addWasteTreatment(Dictionary<string, string> header, WasteTreatmentFilter filter)
        {
            if (filter != null)
            {

                string value = string.Empty;

                if (filter.Recovery)
                {
                    value = addResource(value, "LOV_WASTETREATMENT", "R");
                }
                if (filter.Disposal)
                {
                    value = addResource(value, "LOV_WASTETREATMENT", "D");
                }
                if (filter.Unspecified)
                {
                    value = addResource(value, "Common", "TreatmentUnspecified");
                }

                if (!String.IsNullOrEmpty(value))
                {
                    header.Add(Resources.GetGlobal("Common", "Treatment"), value);
                }
            }

        }

        //creates header for waste receiver and adds to dictionary
        protected static void addWasteReceiver(Dictionary<string, string> header, string countryCode)
        {
            if (!String.IsNullOrEmpty(countryCode))
            {
                string key = Resources.GetGlobal("Common", "ReceivingCountry");
                string value = LOVResources.CountryName(countryCode);
                header.Add(key, value);
            }
        }

        //creates header for waste receiver and adds to dictionary
        protected static void addWasteReceiver(Dictionary<string, string> header, WasteReceiverFilter filter)
        {
            if (filter != null)
            {
                string key = Resources.GetGlobal("Common", "ReceivingCountry");
                string value = String.Empty;

                if (filter.CountryID == -1)
                {
                    value = Resources.GetGlobal("Common", "AllReceivingCountries");
                }
                else
                {
                    string code = ListOfValues.GetCountry((int)filter.CountryID).Code;
                    value = LOVResources.CountryName(code);
                }

                header.Add(key, value);

            }
        }




        #endregion

        protected static void addConfidentiality(Dictionary<string, string> header, bool confidentialityAffected)
        {
            if (confidentialityAffected)
            {
                string key = Resources.GetGlobal("Common", "CsvConfWarning");
                string value = String.Empty;
                header.Add(key, value);
            }
        }

        //adds a resource to value string by concatenating with comma.
        private static string addResource(string value, string resourceType, string resourceKey)
        {
            string defaultDelimiter = ", ";
            return StringConcat(value, Resources.GetGlobal(resourceType, resourceKey), defaultDelimiter);
        }

        //adds a resource to value string by concatenating with comma.
        private static string addResource(string value, string resourceType, string resourceKey, string delimiter)
        {
            return StringConcat(value, Resources.GetGlobal(resourceType, resourceKey), delimiter);
        }


        /// <summary>
        /// Concatenate two strings with a comma. Handles if any of the strings is null or empty
        /// </summary>
        protected static string StringConcat(string str1, string str2, string delimiter)
        {
            if (string.IsNullOrEmpty(str2))
            {
                return str1;
            }
            else if (string.IsNullOrEmpty(str1))
            {
                return str2;
            }
            else
            {
                return str1 + delimiter + str2;
            }
        }
    }
}
