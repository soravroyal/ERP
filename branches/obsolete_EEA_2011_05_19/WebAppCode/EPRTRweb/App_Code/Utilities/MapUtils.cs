using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using QueryLayer.Filters;
using System.Text;

namespace EPRTR.Utilities
{

    /// <summary>
    /// Summary description for MapUtils
    /// </summary>
    public static class MapUtils
    {

        public const string EXPAND_QUERY = "expandQuery";
        public const string EXPAND_SECTOR = "expandSector";
        public const string EXPAND_HEAD = "expandHead";
        public const string EXPAND_VISIBLE = "expandVisible";

        #region Result Map
        //Add result map (small map on search pages)
        public static void AddSmallMap(string mapid, Page page, Global.MainSearchPages searchpage, string applicationPath)
        {
            string configfile = string.Empty;

            switch (searchpage)
            {
                case Global.MainSearchPages.FacilityLevels:
                    configfile = "config_facilitylevels_result.xml"; 
                    break;
                case Global.MainSearchPages.FacilityLevelsEPER:
                    configfile = "config_facilitylevels_result.xml";
                    break;
                case Global.MainSearchPages.IndustrialActivity:
                    configfile = "config_industrialactivity_result.xml";
                    break;
                case Global.MainSearchPages.AreaOverview:
                    //same map as industrial activity search
                    configfile = "config_industrialactivity_result.xml";
                    break;
                case Global.MainSearchPages.PollutantReleases:
                    configfile = "config_pollutantrelease_result.xml";
                    break;
                case Global.MainSearchPages.PollutantTransfers:
                    configfile = "config_pollutanttransfer_result.xml";
                    break;
                case Global.MainSearchPages.WasteTransfers:
                    configfile = "config_wastetransfer_result.xml";
                    break;
                case Global.MainSearchPages.DiffuseWater:
                    configfile = "config_diffuse_water_result.xml";
                    break;
                case Global.MainSearchPages.DiffuseAir:
                    configfile = "config_diffuse_air_result.xml";
                    break;
                case Global.MainSearchPages.TimeSeriesPollutantReleases:
                    configfile = "config_ts_pollutantrelease_result.xml";
                    break;
                case Global.MainSearchPages.TimeSeriesPollutantTransfers:
                    configfile = "config_ts_pollutanttransfer_result.xml";
                    break;
                case Global.MainSearchPages.TimeSeriesWasteTransfers:
                    configfile = "config_ts_wastetransfer_result.xml";
                    break;

                default:
                    throw new ArgumentOutOfRangeException("searchPage", "Search page does not have a small map");
            }

            string script = getScriptAddSmallMap(mapid, configfile, applicationPath);
            ScriptManager.RegisterStartupScript(page.Master, page.Master.GetType(), page.UniqueID, script, true);
        }


        /// <summary>
        /// update flash map
        /// </summary>
        public static void UpdateSmallMap(string mapid, Control control, string clientID, MapFilter mapfilter, string header, string applicationPath)
        {
            MapFilter clone = mapfilter.Clone() as MapFilter;
            //always include all layers on small map, since there is only one layer.
            clone.Layers = ActivityFilter.AllSectorsID.ToString();

            if (!String.IsNullOrEmpty(mapfilter.SqlWhere))
            {
                //header is not needed for small map
                string script = getScriptInitializeMap(mapid, clone, "", false);
                ScriptManager.RegisterClientScriptBlock(control, control.GetType(), mapid + clientID, script, true);
                
            }
        }

        /// <summary>
        /// update flash map
        /// </summary>
        public static void UpdateDiffuseMap(string mapid, Control control, string clientID, MapFilter mapfilter, string header, string applicationPath)
        {
            //header is not needed for small map
            string script = getScriptInitializeMap(mapid, mapfilter, "", false);
            ScriptManager.RegisterClientScriptBlock(control, control.GetType(), mapid + clientID, script, true);
        }
        
        #endregion

        #region Expanded map
        public static void CreateExpandedMap(string expandedMapid, Control control, string searchpage, string sqlWhere, string sectors, string header, string extent, string applicationPath, string visibleLayers)
        {
            bool blank = String.IsNullOrEmpty(sqlWhere) && String.IsNullOrEmpty(sectors);

            sqlWhere = sqlWhere == null ? string.Empty : sqlWhere;
            sectors = sectors == null ? string.Empty : sectors;
            visibleLayers = visibleLayers == null ? string.Empty : visibleLayers;
            header = header == null ? string.Empty : header;
            extent = extent == null ? string.Empty : extent;

            string configfile = string.Empty;

            Global.MainSearchPages mainPage = (Global.MainSearchPages)Enum.Parse(typeof(Global.MainSearchPages), searchpage);

            switch (mainPage)
            {
                case Global.MainSearchPages.FacilityLevels:
                    configfile = "config_facilitylevels_ex.xml";
                    break;
                case Global.MainSearchPages.FacilityLevelsEPER:
                    configfile = "config_facilitylevels_ex.xml";
                    break;
                case Global.MainSearchPages.IndustrialActivity:
                    configfile = "config_industrialactivity_ex.xml";
                    break;
                case Global.MainSearchPages.AreaOverview: //same map as industrial activity
                    configfile = "config_industrialactivity_ex.xml";
                    break;
                case Global.MainSearchPages.PollutantReleases:
                    configfile = "config_pollutantrelease_ex.xml";
                    break;
                case Global.MainSearchPages.PollutantTransfers:
                    configfile = "config_pollutanttransfer_ex.xml";
                    break;
                case Global.MainSearchPages.WasteTransfers:
                    configfile = "config_wastetransfer_ex.xml";
                    break;
                case Global.MainSearchPages.MapSearch:
                    configfile = "config_mapsearch_ex.xml";
                    break;
                case Global.MainSearchPages.DiffuseWater:
                    configfile = "config_diffuse_water_ex.xml";
                    break;
                case Global.MainSearchPages.DiffuseAir:
                    configfile = "config_diffuse_air_ex.xml";
                    break;
                case Global.MainSearchPages.TimeSeriesPollutantReleases:
                    configfile = "config_ts_pollutantrelease_ex.xml";
                    break;
                case Global.MainSearchPages.TimeSeriesPollutantTransfers:
                    configfile = "config_ts_pollutanttransfer_ex.xml";
                    break;
                case Global.MainSearchPages.TimeSeriesWasteTransfers:
                    configfile = "config_ts_wastetransfer_ex.xml";
                    break;
                default:
                    // default, we need to avoid a flash error here
                    configfile = "config_facilitylevels_ex.xml";
                    break;
        }

            string script = getScriptAddExpandedMap(expandedMapid, configfile, sqlWhere, sectors, header, extent, blank, applicationPath, visibleLayers);
            //ScriptManager.RegisterClientScriptBlock(control, control.GetType(), expandedMapid + control.ClientID, script, true);
            ScriptManager.RegisterStartupScript(control, control.GetType(), expandedMapid + control.ClientID, script, true);
        }

        public static string GetExpandScript(string searchpage, string headline, string query, string sector, string header, string smallMapId, string visibleLayers)
        {
            // add security since the url can been seen in firefox
            headline = HttpUtility.UrlEncode(Global.textToBase64(headline));
            query = HttpUtility.UrlEncode(Global.textToBase64(query));
            sector = HttpUtility.UrlEncode(Global.textToBase64(sector));
            header = HttpUtility.UrlEncode(Global.textToBase64(header));
            visibleLayers = HttpUtility.UrlEncode(Global.textToBase64(visibleLayers));
                        
            string expandLink = String.Format("MapExpanded.aspx?searchpage={0}&headline={1}&query={2}&sector={3}&header={4}&visible={5}", searchpage, headline, query, sector, header,visibleLayers);
            string script = String.Format("ExpandedMapClicked('{0}','{1}');", expandLink, smallMapId);
            return script;
        }

        public static string GetButtonExpandScript(string jsFunction, string buttonClientID)
        {
            string script = String.Empty;
            script += "try{ var btnExpand = $get('" + buttonClientID + "'); ";
            script += "if (typeof(expandHandler) != 'undefined') { $removeHandler(btnExpand, 'click', expandHandler); } ";
            script += "expandHandler = function(evt) { " + jsFunction + " evt.preventDefault(); }; $addHandler(btnExpand, 'click', expandHandler); ";
            script += "} catch(err) {  } ";
            return script;
        }
        
        #endregion

        #region Map search

        public static void AddMapSearchMap(string mapid, Control control, string clientID, string applicationPath)
        {
            string configfile = "config_mapsearch.xml";
            string script = getScriptAddMapSearchMap(mapid, configfile, applicationPath);
            ScriptManager.RegisterClientScriptBlock(control, control.GetType(), clientID, script, true);
        }




        #endregion

        #region Facility details map

        public static void AddDetailsMap(Control control, string clientid, string mapid, int facilityReportId, string sectors, string applicationPath)
        {
            string reportid = "FacilityReportID = " + facilityReportId;
            string configfile = "config_facilitydetails.xml";

            string script = getScriptAddDetailsMap(mapid, configfile, reportid, sectors, applicationPath);
            ScriptManager.RegisterClientScriptBlock(control, control.GetType(), clientid, script, true);
        }

        private static string getScriptAddDetailsMap(string mapid, string configfile, string reportid, string sectors, string applicationPath)
        {
            //build up js callback function to be called by map when the map is ready
            StringBuilder sb = new StringBuilder();
            sb.Append("function() {");
            sb.AppendFormat(@"SetDetailsMapPoint('{0}', '{1}', '{2}');", mapid, reportid, sectors);
            sb.Append("}");
            String callback = sb.ToString();

            return String.Format(@"AddDetailsMap('{0}','{1}','{2}','{3}',""{4}"")", mapid, configfile, applicationPath, getCultureCode(),callback);
        }

        #endregion

        //wraps javascript functions
        #region JavaScript wrappers

        
        private static string getScriptAddExpandedMap(string mapid, string configfile, string filter, string layers, string header, string extent, bool blank, string applicationPath, string visibleLayers)
        {
            //build up js callback function to be called by map when the map is ready
            StringBuilder sb = new StringBuilder();
            sb.Append("function() {");
            if (!blank)
            {
                sb.AppendFormat(@"InitializeMap('{0}', ""{1}"", '{2}', '{3}', 1, '{4}');", mapid, filter, layers, header, visibleLayers);
            }
            sb.AppendFormat(@"SetExtent('{0}', '{1}');", mapid, extent);
            sb.Append("}");

            String callback = sb.ToString();

            return String.Format(@"AddExpandedMap('{0}','{1}','{2}','{3}',{4});", mapid, configfile, applicationPath, getCultureCode(), callback);
        }

        private static string getScriptAddSmallMap(string id, string configfile, string applicationPath)
        {
            return string.Format("AddSmallMap(\"{0}\",\"{1}\",\"{2}\",\"{3}\");", id, configfile, applicationPath, getCultureCode());
        }

        private static string getScriptInitializeMap(string mapid, MapFilter mapfilter, string header, bool isExpanded)
        {
            //InitializeMap(id, filter, layers, header, isExpanded, visibleLayers)
            return String.Format(@"InitializeMap('{0}', ""{1}"",'{2}','{3}',{4},'{5}');", mapid, mapfilter.SqlWhere, mapfilter.Layers, header, convertBool(isExpanded), mapfilter.VisibleLayers);
        }

        private static string getScriptAddMapSearchMap(string mapid, string configfile, string applicationFile)
        {
            return String.Format("AddMapSearch(\"{0}\",\"{1}\",\"{2}\",\"{3}\");", mapid, configfile, applicationFile, getCultureCode());
        }


        private static int convertBool(bool b)
        {
            return b ? 1 : 0;
        }

        private static string getCultureCode()
        {
            return System.Threading.Thread.CurrentThread.CurrentCulture.ToString().Replace("-", "_");
        }

        #endregion

    }



}
