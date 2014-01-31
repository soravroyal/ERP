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
             /* const string quote = "\"";
              string layerName = quote + "EprtrFacilities_Dyna_WGS84_1098" + quote;
              string serviceName = quote + "http://discomap.eea.europa.eu/ArcGIS/rest/services/Air/EprtrFacilities_Dyna_WGS84/MapServer/1" + quote;
              string queryFunction = "filterFacilityDetails(" + layerName + "," + serviceName + "," + quote + mapfilter.SqlWhere + quote + ")";
              ScriptManager.RegisterStartupScript(control, control.GetType(), "funcionDetails", queryFunction, true);
  */
            ScriptManager.RegisterStartupScript(control, control.GetType(), "reloadMap", "reloadMap(" +facilityReportID+ ");", true);
        }



      
    }
}
