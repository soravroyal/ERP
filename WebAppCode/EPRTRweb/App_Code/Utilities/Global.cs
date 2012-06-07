using System;
using System.Web.UI;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;
using System.Web.UI.WebControls;
using System.Web.UI.DataVisualization.Charting;

/// <summary>
/// Summary description for Global
/// </summary>
namespace EPRTR.Utilities
{
    
    public static class Global
    {

        // ----------------------------------------------------------------------------------
        // Constants
        // ----------------------------------------------------------------------------------
        #region constants

        //menu
        public const string PREFIX = "menutree_";
        public const string SearchEPRTRData = "SearchEPRTRData";
        public const string SearchEPERData = "SearchEPERData";
        public const string Download = "Download";
        public const string Links = "Links";
        public const string Library = "Library";
        public const string DiffuseSources = "DiffuseSources";
        public const string TimeSeries = "TimeSeries";
        
        // print
        public const string DETAIL_CONTROL = "printDetailControl";
        public const string GLOBAL_CONTROL = "printGlobalControl";
        public const int PRINT_WIDTH = 850;
        public const int PRINT_HEIGHT = 500;
        
        // font for time series
        public static Font FontTimeSeries = new Font("Verdana", 7.5f, FontStyle.Regular);

        // Timeseries colors
        public static Color ColorAirTotal = Color.FromArgb(255, 147, 173, 205); //#93adcd
        public static Color ColorAirAccidental = Color.FromArgb(255, 126, 148, 175);//#7E94AF
        public static Color ColorAirBothYears = Color.FromArgb(255, 179, 179, 179); //#b3b3b3

        public static Color ColorWaterTotal = Color.FromArgb(255, 198, 212, 170); //#c6d4aa
        public static Color ColorWaterAccidental = Color.FromArgb(255, 169, 181, 146); //#A9B592
        public static Color ColorWaterBothYears = Color.FromArgb(255, 179, 179, 179); //#b3b3b3

        public static Color ColorSoilTotal = Color.FromArgb(255, 213, 185, 164); //#d5b9a4
        public static Color ColorSoilAccidental = Color.FromArgb(255, 182, 158, 140); //#B69E8C
        public static Color ColorSoilBothYears = Color.FromArgb(255, 179, 179, 179); //#b3b3b3

        public static Color ColorWasteWater = Color.FromArgb(255, 199, 213, 171); //#C7D5AB
        public static Color ColorWasteWaterBothYears = Color.FromArgb(255, 179, 179, 179); //#b3b3b3

        public static Color ColorWasteTotal = Color.FromArgb(255, 190, 190, 190); //#bebebe
        
				//public static Color ColorWasteRecovery = Color.FromArgb(255, 214, 186, 165); //#d6baa5   
        //public static Color ColorWasteDisposal = Color.FromArgb(255, 198, 212, 170); //#c6d4aa
				public static Color ColorWasteRecovery = Color.FromArgb(255, 198, 212, 170); //#c6d4aa   
				public static Color ColorWasteDisposal = Color.FromArgb(255, 214, 186, 165); //#d6baa5			

				public static Color ColorWasteUnspec= Color.FromArgb(255, 198, 235, 247); //#C6EBF7
        public static Color ColorWasteBothYears = Color.FromArgb(255, 179, 179, 179); //#b3b3b3


        // Timeseries colors
        public static ChartHatchStyle HatchStyleBothYears = ChartHatchStyle.BackwardDiagonal;
        public static ChartHatchStyle HatchStyleTotal = ChartHatchStyle.None;
        #endregion


        // ----------------------------------------------------------------------------------
        // Enums
        // ----------------------------------------------------------------------------------
        #region enums

        /// <summary>
        /// Enums
        /// </summary>
        public enum MainSearchPages
        {
            FacilityLevels = 0,
            FacilityLevelsEPER,
            IndustrialActivity,
            AreaOverview,
            PollutantReleases,
            PollutantTransfers,
            WasteTransfers,
            MapSearch,
            DiffuseWater,
            DiffuseAir,
            TimeSeriesPollutantReleases,
            TimeSeriesPollutantTransfers,
            TimeSeriesWasteTransfers
        };
        #endregion


        // ----------------------------------------------------------------------------------
        // Enums
        // ----------------------------------------------------------------------------------
        #region globalfunctions

        /// <summary>
        /// Get window open call for print script
        /// </summary>
        public static string GetPrintScript(string aspx, string pageValue, int width, int height)
        {
            return String.Format("window.open('{0}?page={1}','','height={2}px,width={3}px,scrollbars=1,resizable=yes,toolbar=no,status=no,replace=true');", aspx, pageValue, height, width);
        }


        /// <summary>
        /// Convert to int
        /// </summary>
        public static int ToInt(string value, int defaultValue)
        {
            int v = defaultValue;
            try
            {
                v = Convert.ToInt32(value);
            }
            catch 
            { 
                //ignore all errors, return default value
                return defaultValue;
            }
            return v;
        }

        /// <summary>
        /// Convert to int?
        /// </summary>
        public static int? ToIntNullable(string value)
        {
            if (String.IsNullOrEmpty(value)) return null;
            int? v = null;
            try
            {
                v = Convert.ToInt32(value);
            }
            catch 
            {
                //ignore all errors, return null
                return null;
            }
            return v;
        }

        /// <summary>
        /// Convert to bool
        /// </summary>
        public static bool ToBool(string value)
        {
            if (String.IsNullOrEmpty(value)) return false;
            value = value.ToLower();
            return (value.Equals("1") || value.Equals("true")) ? true : false;
        }

        /// <summary>
        /// Convert to enum
        /// </summary>
        public static T ToEnum<T>(string s)
        {
            if (String.IsNullOrEmpty(s)) return default(T);
            return (T)Enum.Parse(typeof(T), s);
        }

        /// <summary>
        /// convert base64 to string
        /// </summary>
        public static string base64ToText(string sbase64)
        {
            // safe check
            if (String.IsNullOrEmpty(sbase64)) return String.Empty;

            try
            {
                byte[] bytes = System.Convert.FromBase64String(sbase64);
                System.Text.ASCIIEncoding encoding = new System.Text.ASCIIEncoding();
                return encoding.GetString(bytes, 0, bytes.Length);
            }
            catch /*ignore all exceptions*/
            {
                return String.Empty;
            }
        }

        /// <summary>
        /// convert string to base64
        /// </summary>
        public static string textToBase64(string sAscii)
        {
            // safe check
            if (String.IsNullOrEmpty(sAscii)) return String.Empty;

            try
            {
                System.Text.ASCIIEncoding encoding = new System.Text.ASCIIEncoding();
                byte[] bytes = encoding.GetBytes(sAscii);
                return System.Convert.ToBase64String(bytes, 0, bytes.Length);
            }
            catch /*ignore all exceptions*/
            {
                return String.Empty;
            }
        }     

        
        #endregion


        


    }
}