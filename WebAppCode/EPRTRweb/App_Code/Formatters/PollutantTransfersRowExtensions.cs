using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer;
using EPRTR.Localization;

namespace EPRTR.Formatters
{
    /// <summary>
    /// Extension methods for TreeListRows
    /// /// </summary>
    public static class PollutantTransfersRowExtensions
    {

        #region Methods for transfers to waste water
        /// <summary>
        /// returns formatted total quantity for waste-water
        /// </summary>
        public static string FormatTotal(this PollutantTransfers.PollutantTransferRow row)
        {
            return QuantityFormat.Format(row.Quantity, row.Unit);
        }

        /// <summary>
        /// returns formatted tooltip text for quantities
        /// </summary>
        public static string ToolTip(this PollutantTransfers.PollutantTransferRow row)
        {
            return ToolTip(row.FormatTotal());
        }


        #endregion


        #region helper methods
        private static string ToolTip(string totalString)
        {
            return string.Format(Resources.GetGlobal("Pollutant", "PollutantTransferQuantityToolTip"), totalString);
        }
        #endregion


    }
}
