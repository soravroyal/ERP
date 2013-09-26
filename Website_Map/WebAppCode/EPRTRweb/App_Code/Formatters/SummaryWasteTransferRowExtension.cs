using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer;
using EPRTR.Localization;
using QueryLayer.Utilities;

namespace EPRTR.Formatters
{
    /// <summary>
    /// Extension methods for SummaryWasteTransferRowExtension
    /// /// </summary>
    public static class SummaryWasteTransferRowExtension
    {

        /// <summary>
        /// returns formatted total quantity. 
        /// </summary>
        public static string FormatTotal(this Summary.WasteSummaryTreeListRow row)
        {
            return QuantityFormat.Format(row.TotalQuantity, row.Unit);
        }

        /// <summary>
        /// returns formatted recovery quantity. Will include percent 
        /// </summary>
        public static string FormatRecovery(this Summary.WasteSummaryTreeListRow row)
        {
            return QuantityFormat.Format(row.Recovery, row.Unit);
        }
        /// <summary>
        /// returns formatted disposal quantity. Will include percent 
        /// </summary>
        public static string FormatDisposal(this Summary.WasteSummaryTreeListRow row)
        {
            return QuantityFormat.Format(row.Disposal, row.Unit);
        }
        /// <summary>
        /// returns formatted unspecified quantity. Will include percent 
        /// </summary>
        public static string FormatUnspec(this Summary.WasteSummaryTreeListRow row)
        {
            return QuantityFormat.Format(row.Unspecified, row.Unit);
        }

        /// <summary>
        /// returns formatted percent. Always show with one decimal
        /// </summary>
        public static string FormatRecoveryPercent(this Summary.WasteSummaryTreeListRow row)
        {
            return QuantityFormat.FormatPercentage(row.RecoveryPercent,1);
        }
        public static string FormatDisposalPercent(this Summary.WasteSummaryTreeListRow row)
        {
            return QuantityFormat.FormatPercentage(row.DisposalPercent, 1);
        }
        public static string FormatUnspecPercent(this Summary.WasteSummaryTreeListRow row)
        {
            return QuantityFormat.FormatPercentage(row.UnspecifiedPercent,1);
        }
        

        #region helper methods
        /// <summary>
        /// Add percent to string
        /// </summary>
        private static string AddPercent(string quantity, double pct)
        {
            return string.Format("{0} ({1})", quantity, QuantityFormat.FormatPercentage(pct));
        }
        #endregion


    }
}
