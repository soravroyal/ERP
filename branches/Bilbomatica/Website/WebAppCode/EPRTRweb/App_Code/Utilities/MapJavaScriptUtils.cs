using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using QueryLayer.Filters;
namespace EPRTR.Utilities
{

    /// <summary>
    /// Descripción breve de MapJavaScriptUtils
    /// </summary>
    public static class MapJavaScriptUtils
    {

        public static void UpdateJavaScriptMap(MapFilter mapfilter, Control control)
        {
            const string quote = "\"";
            string layerName = quote + "EprtrFacilities_Dyna_WGS84_1098" + quote;          
            string serviceName = quote + "http://discomap.eea.europa.eu/ArcGIS/rest/services/Air/EprtrFacilities_Dyna_WGS84/MapServer/0" + quote;
            string queryFunction = "filterFacility(" + layerName + "," + serviceName + "," + quote + mapfilter.SqlWhere + quote + ")";
            ScriptManager.RegisterStartupScript(control, control.GetType(), "funcionInicial", queryFunction, true);
           
        }

    

        public static void UpdateJavaScriptMapDetails(Control control, string facilityReportID)
        {
               ScriptManager.RegisterStartupScript(control, control.GetType(), "reloadMap", "reloadMap(" +facilityReportID+ ");", true);
        }

        public static void UpdateJavaScriptMapDiffuse(Control control,string layerID, string layer)
        {
             const string quote = "\"";
                string layerName = "";
                if (layer == "water")
                {
                    layerName = quote + "EPRTRDiffuseWater_Dyna_WGS84_4145" + quote;
                }
                else
                {
                    layerName = quote + "EPRTRDiffuseEmissionsAir_Dyna_WGS84_8638" + quote;
                }
                string serviceName = quote + "http://discomap.eea.europa.eu/ArcGIS/rest/services/Water/EPRTRDiffuseWater_Dyna_WGS84/MapServer/" + quote;
                string queryFunction = "filterDiffuse(" + layerName + "," + serviceName + ","+ quote + layerID + quote + ")";
                ScriptManager.RegisterStartupScript(control, control.GetType(), "funcionInicial", queryFunction, true);
    
        }



      
    }
}
