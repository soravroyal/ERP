using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer.Filters;
using EPRTR.Enums;
using EPRTR.Localization;

namespace EPRTR.Utilities
{
    /// <summary>
    /// Class with helper functions to redirect to other searches
    /// </summary>
    public static class LinkSearchRedirecter
    {

        /// <summary>
        /// Redirects to Facility search
        /// </summary>
        public static void ToFacilitySearch(HttpResponse response, FacilitySearchFilter filter)
        {
            redirect(response, "FacilityLevels.aspx", LinkSearchBuilder.SerializeToUrl(filter));
        }

        /// <summary>
        /// Redirects to Facility search EPER
        /// </summary>
      /*  public static void ToFacilitySearchEPER(HttpResponse response, FacilitySearchFilter filter)
        {
            redirect(response, "FacilityLevelsEPER.aspx", LinkSearchBuilder.SerializeToUrl(filter));
        }
        */
        /// <summary>
        /// Redirects to IndustrialActivity search
        /// </summary>
        public static void ToIndustrialActivity(HttpResponse response, IndustrialActivitySearchFilter filter, Sheets.IndustrialActivity sheet)
        {
            string content = sheet.ToString();
            redirect(response, "IndustialActivity.aspx", content, LinkSearchBuilder.SerializeToUrl(filter));
        }

        /// <summary>
        /// Redirects to Pollutant release search
        /// </summary>
        public static void ToPollutantReleases(HttpResponse response, PollutantReleaseSearchFilter filter)
        {
            redirect(response,"PollutantReleases.aspx", LinkSearchBuilder.SerializeToUrl(filter));
        }

        /// <summary>
        /// Redirects to Pollutant transfer search
        /// </summary>
        public static void ToPollutantTransfers(HttpResponse response, PollutantTransfersSearchFilter filter)
        {
            redirect(response, "PollutantTransfers.aspx", LinkSearchBuilder.SerializeToUrl(filter));
        }

        /// <summary>
        /// Redirects to Watse transfer search
        /// </summary>
        public static void ToWasteTransfers(HttpResponse response, WasteTransferSearchFilter filter)
        {
            redirect(response, "WasteTransfer.aspx", LinkSearchBuilder.SerializeToUrl(filter));
        }

        /// <summary>
        /// Redirects to Watse transfer search
        /// </summary>
        public static void ToTimeSeries(HttpResponse response, PollutantReleaseSearchFilter filter)
        {
            response.Cookies[Global.PREFIX + Resources.GetGlobal("Web.sitemap", Global.TimeSeries)].Value = "true";
            redirect(response, "TimeSeriesPollutantReleases.aspx", LinkSearchBuilder.SerializeToUrl(filter));
        }

        /// <summary>
        /// Redirects to Watse transfer search
        /// </summary>
        public static void ToTimeSeries(HttpResponse response, PollutantTransfersSearchFilter filter)
        {
            response.Cookies[Global.PREFIX + Resources.GetGlobal("Web.sitemap", Global.TimeSeries)].Value = "true";
            redirect(response, "TimeSeriesPollutantTransfers.aspx", LinkSearchBuilder.SerializeToUrl(filter));
        }

        /// <summary>
        /// Redirects to Watse transfer search
        /// </summary>
        public static void ToTimeSeries(HttpResponse response, WasteTransferSearchFilter filter)
        {
            response.Cookies[Global.PREFIX + Resources.GetGlobal("Web.sitemap", Global.TimeSeries)].Value = "true";
            redirect(response, "TimeSeriesWasteTransfers.aspx", LinkSearchBuilder.SerializeToUrl(filter));
        }

        /// <summary>
        /// redirects to the page given, with the given content shown and the filter params given
        /// </summary>
        private static void redirect(HttpResponse response, string page, string content, string filter)
        {
            string param = String.Empty;

            if (!String.IsNullOrEmpty(content))
            {
                param = String.Format("content={0}&{1}", content, filter);
            }
            else
            {
                param = filter;
            }

            redirect(response, page, param);
        }


        //redirects to the page given, with the request params given
        private static void redirect(HttpResponse response, string page, string requestParams)
        {
            string url = String.Format("{0}?{1}", page, requestParams);
            response.Redirect(url);
        }

    }
}
