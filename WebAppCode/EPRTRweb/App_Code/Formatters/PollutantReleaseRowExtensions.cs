using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer;
using EPRTR.Localization;

namespace EPRTR.Formatters
{
    /// <summary>
    /// Extension methods for PollutantReleaseRows
    /// /// </summary>
    public static class PollutantReleaseRow
    {


        #region Methods for releases to air
        /// <summary>
        /// returns formatted total quantity for air
        /// </summary>
        public static string FormatTotalAir(this PollutantReleases.PollutantReleaseRow row)
        {
            return QuantityFormat.Format(row.QuantityAir, row.UnitAir);
        }

        /// <summary>
        /// returns formatted accidental quantity for air
        /// </summary>
        public static string FormatAccidentalAir(this PollutantReleases.PollutantReleaseRow row)
        {
            return QuantityFormat.Format(row.AccidentalAir, row.UnitAir);
        }

        /// <summary>
        /// returns formatted tooltip text for quantities
        /// </summary>
        public static string ToolTipAir(this PollutantReleases.PollutantReleaseRow row)
        {
            return ToolTip(row.FormatTotalAir(), row.FormatAccidentalAir());
        }


        #endregion

        #region Methods for releases to soil
        /// <summary>
        /// returns formatted total quantity for soil
        /// </summary>
        public static string FormatTotalSoil(this PollutantReleases.PollutantReleaseRow row)
        {
            return QuantityFormat.Format(row.QuantitySoil, row.UnitSoil);
        }

        /// <summary>
        /// returns formatted accidental quantity for soil
        /// </summary>
        public static string FormatAccidentalSoil(this PollutantReleases.PollutantReleaseRow row)
        {
            return QuantityFormat.Format(row.AccidentalSoil, row.UnitSoil);
        }

        /// <summary>
        /// returns formatted tooltip text for quantities
        /// </summary>
        public static string ToolTipSoil(this PollutantReleases.PollutantReleaseRow row)
        {
            return ToolTip(row.FormatTotalSoil(), row.FormatAccidentalSoil());
        }

        #endregion

        #region Methods for releases to water
        /// <summary>
        /// returns formatted total quantity for water
        /// </summary>
        public static string FormatTotalWater(this PollutantReleases.PollutantReleaseRow row)
        {
            return QuantityFormat.Format(row.QuantityWater, row.UnitWater);
        }

        /// <summary>
        /// returns formatted accidental quantity for water
        /// </summary>
        public static string FormatAccidentalWater(this PollutantReleases.PollutantReleaseRow row)
        {
            return QuantityFormat.Format(row.AccidentalWater, row.UnitWater);
        }

        /// <summary>
        /// returns formatted tooltip text for quantities
        /// </summary>
        public static string ToolTipWater(this PollutantReleases.PollutantReleaseRow row)
        {
            return ToolTip(row.FormatTotalWater(), row.FormatAccidentalWater());
        }

        #endregion

        #region helper methods
        private static string ToolTip(string totalString, string accidentalString)
        {
            return string.Format(Resources.GetGlobal("Pollutant", "PollutantReleaseQuantityToolTip"), totalString, accidentalString);
        }
        #endregion


    }
}
