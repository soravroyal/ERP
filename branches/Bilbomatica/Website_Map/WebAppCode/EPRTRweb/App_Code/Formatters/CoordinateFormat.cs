using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EPRTR.Localization;
using QueryLayer;
using QueryLayer.Enums;

namespace EPRTR.Formatters
{
    /// <summary>
    /// Summary description for ConfidentialFormat
    /// </summary>
    public static class CoordinateFormat
    {
        private const string NO_DATA_INDICATOR = "-";
        private const string DEGREES = "°";

        /// <summary>
        /// Formats co-ordinate data.
        /// </summary>
        /// <param name="coord">incoming data example: "POINT (13.4321 47.5678)"</param>
        /// <param name="coordStatus">example: "(13.4321°; 47.5678°)"</param>
        /// <returns></returns>
        public static string Format(string coord, string coordStatus)
        {
            string result = string.Empty;

            CoordinateStatus status = (CoordinateStatus)Enum.Parse(typeof (CoordinateStatus), coordStatus, true);
            
            switch (status)
            {
                case CoordinateStatus.Valid:
                    {
                        // incoming data example: "POINT (13.4321 47.5678)"
                        // outgoing data example: "(13.4321*; 47.5678*)"
                        //   where * is degrees symbol
                        
                        string coordStripped = coord.Replace("POINT ", "").Replace("(", "").Replace(")", "");
                        string[] xy = coordStripped.Split(' ');
                        result = String.Format("({0}{2}; {1}{2})", xy[0], xy[1], DEGREES);
                        break;
                    }
                default:
                    {
                        result = NO_DATA_INDICATOR;
                        break;
                    }
            }

            return result;
        }
    }
}
