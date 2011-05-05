using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer.Filters;
using QueryLayer;

namespace EPRTR.DiffuseSources
{
    /// <summary>
    /// Summary description for DiffuseMapUtils
    /// </summary>
    public static class DiffuseSources
    {
        private const string RESOURCETYPE = "DiffuseSources";

        // pollutant reltated to water
        private const string CODE_NITROGEN = "TOTAL - NITROGEN";
        private const string CODE_PHOSPHORUS = "TOTAL - PHOSPHORUS";

        // pollutant reltated to air
        private const string CODE_CO = "CO";
        private const string CODE_CO2 = "CO2";
        private const string CODE_NH3 = "NH3"; 
        private const string CODE_NOX = "NOX";
        private const string CODE_PM10 = "PM10";
        private const string CODE_SO2 = "SOX";
        

        //Industrial Activity codes for point sources
        private static List<string> CODES_INDUSTRIAL = new List<string>() { };
        private static List<string> CODES_NON_INDUSTRIAL = new List<string>() { "1.(c)" };
        private static List<string> CODES_ROAD = new List<string>() { };
        private static List<string> CODES_AGRICULTURE = new List<string>() { "7.(a)" };
        private static List<string> CODES_DOMESTIC_SHIPPING = new List<string>() { };
        private static List<string> CODES_DOMESTIC_AVIATION = new List<string>() { };
        private static List<string> CODES_INTERNATIONAL_AVIATION = new List<string>() { };
        private static List<string> CODES_EMPTY = new List<string>() { };

        //diffuse sector codes
        private const string SECTOR_CODE_INDUSTRIAL = "IndustrialReleases";
        private const string SECTOR_CODE_NON_INDUSTRIAL = "NonIndustrialCombustion";
        private const string SECTOR_CODE_ROAD = "RoadTransport";
        private const string SECTOR_CODE_AGRICULTURE = "Agriculture";
        private const string SECTOR_CODE_DOMESTIC_SHIPPING = "DomesticShipping";
        private const string SECTOR_CODE_DOMESTIC_AVIATION= "DomesticAviation";
        private const string SECTOR_CODE_INTERNATIONAL_SHIPPING = "InternationalShipping";

        private static List<string> sectorList = null;

        #region definition of maps

        private static Dictionary<string, Map> mapList = null;

        private static Dictionary<string, Map> getMapList()
        {
            if (mapList == null)
            {
                mapList = new Dictionary<string, Map>();

                #region water
                mapList.addMap("water:::0::4::5", "wnrbd", MediumFilter.Medium.Water, CODE_NITROGEN, CODES_AGRICULTURE, 2007);
                mapList.addMap("water:::0::3::5", "wnaggr", MediumFilter.Medium.Water, CODE_NITROGEN, CODES_AGRICULTURE, 2007);
                
                mapList.addMap("water:::0::1::5", "wprbd", MediumFilter.Medium.Water, CODE_PHOSPHORUS, CODES_AGRICULTURE, 2007);
                mapList.addMap("water:::0::2::5", "wpaggr", MediumFilter.Medium.Water, CODE_PHOSPHORUS, CODES_AGRICULTURE, 2007);
                #endregion

                #region air
                string prefix = MediumFilter.Medium.Air.ToString()+"_"+CODE_NOX+"_";
                mapList.addMap("air:::0", prefix+SECTOR_CODE_INDUSTRIAL, MediumFilter.Medium.Air, CODE_NOX, CODES_INDUSTRIAL, 2007);
                mapList.addMap("air:::1", prefix+SECTOR_CODE_NON_INDUSTRIAL, MediumFilter.Medium.Air, CODE_NOX, CODES_NON_INDUSTRIAL, 2007);
                mapList.addMap("air:::2", prefix + SECTOR_CODE_ROAD, MediumFilter.Medium.Air, CODE_NOX, CODES_ROAD, 2007);
                mapList.addMap("air:::3", prefix + SECTOR_CODE_DOMESTIC_SHIPPING, MediumFilter.Medium.Air, CODE_NOX, CODES_DOMESTIC_SHIPPING, 2007);
                mapList.addMap("air:::4", prefix + SECTOR_CODE_DOMESTIC_AVIATION, MediumFilter.Medium.Air, CODE_NOX, CODES_DOMESTIC_AVIATION, 2007);
                mapList.addMap("air:::27", prefix + SECTOR_CODE_INTERNATIONAL_SHIPPING, MediumFilter.Medium.Air, CODE_NOX, CODES_INTERNATIONAL_AVIATION, 2007);

                prefix = MediumFilter.Medium.Air.ToString() + "_" + CODE_SO2 + "_";
                mapList.addMap("air:::5", prefix + SECTOR_CODE_INDUSTRIAL, MediumFilter.Medium.Air, CODE_SO2, CODES_INDUSTRIAL, 2007);
                mapList.addMap("air:::6", prefix + SECTOR_CODE_NON_INDUSTRIAL, MediumFilter.Medium.Air, CODE_SO2, CODES_NON_INDUSTRIAL, 2007);
                mapList.addMap("air:::7", prefix + SECTOR_CODE_ROAD, MediumFilter.Medium.Air, CODE_SO2, CODES_ROAD, 2007);
                mapList.addMap("air:::8", prefix + SECTOR_CODE_DOMESTIC_SHIPPING, MediumFilter.Medium.Air, CODE_SO2, CODES_DOMESTIC_SHIPPING, 2007);
                mapList.addMap("air:::9", prefix + SECTOR_CODE_DOMESTIC_AVIATION, MediumFilter.Medium.Air, CODE_SO2, CODES_DOMESTIC_AVIATION, 2007);
                mapList.addMap("air:::28", prefix + SECTOR_CODE_INTERNATIONAL_SHIPPING, MediumFilter.Medium.Air, CODE_SO2, CODES_INTERNATIONAL_AVIATION, 2007);

                prefix = MediumFilter.Medium.Air.ToString() + "_" + CODE_PM10 + "_";
                mapList.addMap("air:::10", prefix + SECTOR_CODE_INDUSTRIAL, MediumFilter.Medium.Air, CODE_PM10, CODES_INDUSTRIAL, 2007);
                mapList.addMap("air:::11", prefix + SECTOR_CODE_NON_INDUSTRIAL, MediumFilter.Medium.Air, CODE_PM10, CODES_NON_INDUSTRIAL, 2007);
                mapList.addMap("air:::12", prefix + SECTOR_CODE_ROAD, MediumFilter.Medium.Air, CODE_PM10, CODES_ROAD, 2007);
                mapList.addMap("air:::13", prefix + SECTOR_CODE_DOMESTIC_SHIPPING, MediumFilter.Medium.Air, CODE_PM10, CODES_DOMESTIC_SHIPPING, 2007);
                mapList.addMap("air:::14", prefix + SECTOR_CODE_DOMESTIC_AVIATION, MediumFilter.Medium.Air, CODE_PM10, CODES_DOMESTIC_AVIATION, 2007);
                mapList.addMap("air:::15", prefix + SECTOR_CODE_AGRICULTURE, MediumFilter.Medium.Air, CODE_PM10, CODES_AGRICULTURE, 2007);
                mapList.addMap("air:::29", prefix + SECTOR_CODE_INTERNATIONAL_SHIPPING, MediumFilter.Medium.Air, CODE_PM10, CODES_INTERNATIONAL_AVIATION, 2007);

                prefix = MediumFilter.Medium.Air.ToString() + "_" + CODE_NH3 + "_";
                mapList.addMap("air:::16", prefix + SECTOR_CODE_AGRICULTURE, MediumFilter.Medium.Air, CODE_NH3, CODES_AGRICULTURE, 2007);

                prefix = MediumFilter.Medium.Air.ToString() + "_" + CODE_CO + "_";
                mapList.addMap("air:::17", prefix + SECTOR_CODE_INDUSTRIAL, MediumFilter.Medium.Air, CODE_CO, CODES_INDUSTRIAL, 2007);
                mapList.addMap("air:::18", prefix + SECTOR_CODE_NON_INDUSTRIAL, MediumFilter.Medium.Air, CODE_CO, CODES_NON_INDUSTRIAL, 2007);
                mapList.addMap("air:::19", prefix + SECTOR_CODE_ROAD, MediumFilter.Medium.Air, CODE_CO, CODES_ROAD, 2007);
                mapList.addMap("air:::20", prefix + SECTOR_CODE_DOMESTIC_SHIPPING, MediumFilter.Medium.Air, CODE_CO, CODES_DOMESTIC_SHIPPING, 2007);
                mapList.addMap("air:::21", prefix + SECTOR_CODE_DOMESTIC_AVIATION, MediumFilter.Medium.Air, CODE_CO, CODES_DOMESTIC_AVIATION, 2007);
                mapList.addMap("air:::30", prefix + SECTOR_CODE_INTERNATIONAL_SHIPPING, MediumFilter.Medium.Air, CODE_CO, CODES_INTERNATIONAL_AVIATION, 2007);

                prefix = MediumFilter.Medium.Air.ToString() + "_" + CODE_CO2 + "_";
                mapList.addMap("air:::22", prefix + SECTOR_CODE_INDUSTRIAL, MediumFilter.Medium.Air, CODE_CO2, CODES_INDUSTRIAL, 2007);
                mapList.addMap("air:::23", prefix + SECTOR_CODE_NON_INDUSTRIAL, MediumFilter.Medium.Air, CODE_CO2, CODES_NON_INDUSTRIAL, 2007);
                mapList.addMap("air:::24", prefix + SECTOR_CODE_ROAD, MediumFilter.Medium.Air, CODE_CO2, CODES_ROAD, 2007);
                mapList.addMap("air:::25", prefix + SECTOR_CODE_DOMESTIC_SHIPPING, MediumFilter.Medium.Air, CODE_CO2, CODES_DOMESTIC_SHIPPING, 2007);
                mapList.addMap("air:::26", prefix + SECTOR_CODE_DOMESTIC_AVIATION, MediumFilter.Medium.Air, CODE_CO2, CODES_DOMESTIC_AVIATION, 2007);
                mapList.addMap("air:::31", prefix + SECTOR_CODE_INTERNATIONAL_SHIPPING, MediumFilter.Medium.Air, CODE_CO2, CODES_INTERNATIONAL_AVIATION, 2007);

                #endregion
            }
            return mapList;
        }

        private static void addMap(this Dictionary<string, Map> list, string layerId, string cmsLayerId, MediumFilter.Medium medium, string pollutantCode, List<string> activityCodes, int year)
        {
            Map map = new Map(layerId, cmsLayerId, medium, pollutantCode, activityCodes, year);
            list.Add(layerId, map);
        }
        #endregion

        public class Map
        {
            // used to link to map service
            public string LayerId { get; private set; }

            // used to get text labels
            public string CmsLayerId { get; private set; }

            public MediumFilter.Medium Medium { get; private set; }

            public MapFilter MapFilterExpanded { get; private set; }
            public MapFilter MapFilterSmall { get; private set; }

            private DiffuseSourcesFilter filter = new DiffuseSourcesFilter();

            public Map(string layerId, string cmsLayerId, MediumFilter.Medium medium, string pollutantCode, List<string> activityCodes, int year)
            {
                this.LayerId = layerId;
                this.CmsLayerId = cmsLayerId;
                this.Medium = medium;

                //year
                filter.YearFilter = new YearFilter { Year = year };

                //set pollutant filter
                LOV_POLLUTANT pollutant = ListOfValues.GetPollutant(pollutantCode);
                filter.PollutantFilter = new PollutantFilter();
                filter.PollutantFilter.PollutantID = pollutant.LOV_PollutantID;
                filter.PollutantFilter.PollutantGroupID = (int)pollutant.ParentID;

                //set medium filter
                filter.MediumFilter = new MediumFilter();
                switch (medium)
                {
                    case MediumFilter.Medium.Air:
                        filter.MediumFilter.ReleasesToAir = true;
                        break;
                    case MediumFilter.Medium.Soil:
                        filter.MediumFilter.ReleasesToSoil = true;
                        break;
                    case MediumFilter.Medium.Water:
                        filter.MediumFilter.ReleasesToWater = true;
                        break;
                    default:
                        filter.MediumFilter = null;
                        break;
                }

                //set activity filter
                if (activityCodes.Count > 0)
                {
                    IEnumerable<LOV_ANNEXIACTIVITY> activities = ListOfValues.GetAnnexIActivities(activityCodes);
                    filter.ActivityFilter = new ActivityFilter();
                    filter.ActivityFilter.ActivityType = ActivityFilter.Type.AnnexI;
                    filter.ActivityFilter.SectorIds = activities.Select(a => (int)a.ParentID).ToList<int>();
                    filter.ActivityFilter.ActivityIds = activities.Select(a => a.LOV_AnnexIActivityID).ToList<int>();
                    filter.ActivityFilter.SubActivityIds = new List<int>() { ActivityFilter.AllSubActivitiesInActivityID };
                }
                
                //create mapfilter for expanded map
                this.MapFilterExpanded = QueryLayer.PollutantReleases.GetMapFilter(filter);

                if (activityCodes.Count > 0)
                {
                    this.MapFilterExpanded.Layers = String.Format("facilities,{0}", LayerId); //Don't show any layers as default
                }
                else
                {
                    this.MapFilterExpanded.Layers = LayerId;
                }

                this.MapFilterExpanded.VisibleLayers = LayerId; //only turn on diffuse layer

                //create mapfilter for small map (does not show facilities)
                this.MapFilterSmall = new MapFilter();
                this.MapFilterSmall.Layers = LayerId;

            }

            public string GetTitleShort()
            {
                return getCMSText(CmsLayerId, "TitleShort");
            }

            public string GetTitleFull()
            {
                return getCMSText(CmsLayerId, "TitleFull");
            }

            public string GetGeneralInformation()
            {
                return getCMSText(CmsLayerId, "GeneralInformation");
            }

            public string GetMethodology()
            {
                return getCMSText(CmsLayerId, "Methodology");
            }

            public string GetSourceData()
            {
                return getCMSText(CmsLayerId, "SourceData");
            }


        }

        public static Map GetMap(string layerId)
        {
            return getMapList()[layerId];
        }


        public static Map[] GetMaps(MediumFilter.Medium medium, string sector)
        {
            return getMapList().Values.Where(m => m.Medium == medium && m.CmsLayerId.EndsWith(sector)).ToArray<Map>();
        }


        public static List<string> GetSectors()
        {
            if (sectorList == null)
            {
                sectorList = new List<string>();
                sectorList.Add(SECTOR_CODE_INDUSTRIAL);
                sectorList.Add(SECTOR_CODE_NON_INDUSTRIAL);
                sectorList.Add(SECTOR_CODE_ROAD);
                sectorList.Add(SECTOR_CODE_DOMESTIC_SHIPPING);
                sectorList.Add(SECTOR_CODE_DOMESTIC_AVIATION);
                sectorList.Add(SECTOR_CODE_INTERNATIONAL_SHIPPING);
                sectorList.Add(SECTOR_CODE_AGRICULTURE);
            }
            return sectorList;
        }


        private static string getCMSText(string layerId, string key)
        {
            string resourceKey = String.Format("{0}.{1}", layerId, key);
            return CMSTextCache.CMSText(RESOURCETYPE, resourceKey);
        }
    }
}