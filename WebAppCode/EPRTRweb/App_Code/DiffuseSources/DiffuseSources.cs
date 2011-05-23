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
        private const string CODE_NOX = "NOX";
        private const string CODE_SOX = "SOX";
        private const string CODE_CO = "CO";
        private const string CODE_PM10 = "PM10";
        private const string CODE_NH3 = "NH3";


        private static List<string> CODES_AGRICULTURE = new List<string>() { "7.(a)" };
        private static List<string> CODES_NON_INDUSTRIAL_COMBUSTION = new List<string>() { "1.(c)" };
        private static List<string> CODES_EMPTY = new List<string>() { };



        #region definition of maps

        private static Dictionary<string, Map> mapList = null;

        private static Dictionary<string, Map> getMapList()
        {
            if (mapList == null)
            {
                mapList = new Dictionary<string, Map>();

                mapList.addMap("water:::0::4::5", "wnrbd", MediumFilter.Medium.Water, CODE_NITROGEN, CODES_AGRICULTURE, 2007);
                mapList.addMap("water:::0::3::5", "wnaggr", MediumFilter.Medium.Water, CODE_NITROGEN, CODES_AGRICULTURE, 2007);
                
                mapList.addMap("water:::0::1::5", "wprbd", MediumFilter.Medium.Water, CODE_PHOSPHORUS, CODES_AGRICULTURE, 2007);
                mapList.addMap("water:::0::2::5", "wpaggr", MediumFilter.Medium.Water, CODE_PHOSPHORUS, CODES_AGRICULTURE, 2007);


                mapList.addMap("air:::0", "AirNOx_NonIndustrialCombustion", MediumFilter.Medium.Air, CODE_NOX, CODES_NON_INDUSTRIAL_COMBUSTION, 2007);
                mapList.addMap("air:::1", "AirNOx_RoadTransport", MediumFilter.Medium.Air, CODE_NOX, CODES_EMPTY, 2007);
                mapList.addMap("air:::2", "AirNOx_OtherMobileSources", MediumFilter.Medium.Air, CODE_NOX, CODES_AGRICULTURE, 2007);

                mapList.addMap("air:::3", "AirSO2_NonIndustrialCombustion", MediumFilter.Medium.Air, CODE_SOX, CODES_NON_INDUSTRIAL_COMBUSTION, 2007);
                mapList.addMap("air:::4", "AirSO2_RoadTransport", MediumFilter.Medium.Air, CODE_SOX, CODES_AGRICULTURE, 2007);
                mapList.addMap("air:::5", "AirSO2_OtherMobileSources", MediumFilter.Medium.Air, CODE_SOX, CODES_AGRICULTURE, 2007);

                mapList.addMap("air:::6", "AirCO_NonIndustrialCombustion", MediumFilter.Medium.Air, CODE_CO, CODES_NON_INDUSTRIAL_COMBUSTION, 2007);
                mapList.addMap("air:::7", "AirCO_RoadTransport", MediumFilter.Medium.Air, CODE_CO, CODES_AGRICULTURE, 2007);
                mapList.addMap("air:::8", "AirCO_OtherMobileSources", MediumFilter.Medium.Air, CODE_CO, CODES_AGRICULTURE, 2007);

                mapList.addMap("air:::9", "AirPM10_NonIndustrialCombustion", MediumFilter.Medium.Air, CODE_PM10, CODES_AGRICULTURE, 2007);
                mapList.addMap("air:::10", "AirPM10_RoadTransport", MediumFilter.Medium.Air, CODE_PM10, CODES_AGRICULTURE, 2007);
                mapList.addMap("air:::11", "AirPM10_OtherMobileSources", MediumFilter.Medium.Air, CODE_PM10, CODES_AGRICULTURE, 2007);
                mapList.addMap("air:::12", "AirPM10_Agriculture", MediumFilter.Medium.Air, CODE_PM10, CODES_AGRICULTURE, 2007);

                mapList.addMap("air:::13", "AirNH3_Agriculture", MediumFilter.Medium.Air, CODE_NH3, CODES_AGRICULTURE, 2007);
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
            return getMapList().Values.Where(m => m.Medium == medium && m.CmsLayerId.Contains(sector)).ToArray<Map>();
        }



        private static string getCMSText(string layerId, string key)
        {
            string resourceKey = String.Format("{0}.{1}", layerId, key);
            return CMSTextCache.CMSText(RESOURCETYPE, resourceKey);
        }
    }
}