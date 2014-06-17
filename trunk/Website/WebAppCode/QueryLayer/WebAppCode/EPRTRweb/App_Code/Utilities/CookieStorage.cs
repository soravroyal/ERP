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
    /// Summary description for CookieStorage
    /// </summary>
    public class CookieStorage
    {
        //Area
        private static string HAS_AREAFILTER = "HasAreaFilter";
        private static string HAS_YEARFILTER = "HasYearFilter";
        
        private static string AREAGROUP = "AreaGroupID";
        private static string COUNTRY = "CountryID";
        private static string REGION = "RegionID";
        private static string REGIONTYPE = "TypeRegion";

        private static string YEAR = "Year";
        

        /// <summary>
        /// 
        /// </summary>
        public static AreaFilter GetAreaFilter(HttpRequest request)
        {
            // check if browser supports cookies
            AreaFilter filter = null;
            if (request.Browser.Cookies)
            {
                if (hasFilter(request, HAS_AREAFILTER))
                {
                    filter = new AreaFilter();
                    filter.AreaGroupID = Global.ToIntNullable(request.Cookies[AREAGROUP].Value);
                    filter.CountryID = Global.ToIntNullable(request.Cookies[COUNTRY].Value);
                    filter.RegionID = Global.ToIntNullable(request.Cookies[REGION].Value);
                    filter.TypeRegion = Global.ToEnum<AreaFilter.RegionType>(request.Cookies[REGIONTYPE].Value);
                }
            }
            return filter;    
        }

        /// <summary>
        /// 
        /// </summary>
        public static YearFilter GetYearFilter(HttpRequest request)
        {
            // check if browser supports cookies
            YearFilter filter = null;
            if (request.Browser.Cookies)
            {
                if (hasFilter(request, HAS_YEARFILTER))
                {
                    filter = new YearFilter();
                    filter.Year = Global.ToInt(request.Cookies[YEAR].Value, 0);
                }
            }
            return filter;    
        }


        /// <summary>
        /// 
        /// </summary>
        public static void SetFilter(HttpResponse response, AreaFilter filter)
        {
            if (response!=null)
            {
                response.Cookies[HAS_AREAFILTER].Value = "1";
                response.Cookies[AREAGROUP].Value = filter.AreaGroupID.ToString();
                response.Cookies[COUNTRY].Value = filter.CountryID.ToString();
                response.Cookies[REGION].Value = filter.RegionID.ToString();
                response.Cookies[REGIONTYPE].Value = filter.TypeRegion.ToString();
            }
        }
        
        /// <summary>
        /// 
        /// </summary>
        public static void SetFilter(HttpResponse response, YearFilter filter)
        {
            if (response != null)
            {
                response.Cookies[HAS_YEARFILTER].Value = "1";
                response.Cookies[YEAR].Value = filter.Year.ToString();
            }
        }
         
       
        private static bool hasFilter(HttpRequest request, string name)
        {
            if (request.Cookies[name] == null) 
                return false;
            
            string value = request.Cookies[name].Value.ToLower();
            if (String.IsNullOrEmpty(value)) return false;
            return (value.Equals("1") || value.Equals("true")) ? true : false;
        }
        

        /// <summary>
        /// expand map details
        /// </summary>
        private static string EXPAND_QUERY = "expanQuery";
        private static string EXPAND_SECTOR = "expanSector";
        private static string EXPAND_HEADER = "expanHeader";
        private static string EXPAND_VISIBLE = "expanVisible";
                
        public static void SaveExpandMap(HttpResponse response, string query, string sector, string header, string visibleLayers)
        {
            if (response != null)
            {
                response.Cookies[EXPAND_QUERY].Value = Global.textToBase64(query);
                response.Cookies[EXPAND_SECTOR].Value = Global.textToBase64(sector);
                response.Cookies[EXPAND_HEADER].Value = Global.textToBase64(header);
                response.Cookies[EXPAND_VISIBLE].Value = Global.textToBase64(visibleLayers);
            }
        }
        public static void GetExpandMap(HttpRequest request, out string query, out string sector, out string header, out string visibleLayers)
        {
            query = String.Empty;
            sector = String.Empty;
            header = String.Empty;
            visibleLayers = String.Empty;

            if (request.Browser.Cookies)
            {
                query = (request.Cookies[EXPAND_QUERY] != null) ? request.Cookies[EXPAND_QUERY].Value : String.Empty;
                sector = (request.Cookies[EXPAND_SECTOR] != null) ? request.Cookies[EXPAND_SECTOR].Value : String.Empty;
                header = (request.Cookies[EXPAND_HEADER] != null) ? request.Cookies[EXPAND_HEADER].Value : String.Empty;
                visibleLayers = (request.Cookies[EXPAND_VISIBLE] != null) ? request.Cookies[EXPAND_VISIBLE].Value : String.Empty;
                query = Global.base64ToText(query);
                sector = Global.base64ToText(sector);
                header = Global.base64ToText(header);
                visibleLayers = Global.base64ToText(visibleLayers);
            }
        }
                
    }
}