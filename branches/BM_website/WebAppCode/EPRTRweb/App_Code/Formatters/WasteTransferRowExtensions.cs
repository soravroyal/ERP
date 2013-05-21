using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer;
using EPRTR.Localization;

namespace EPRTR.Formatters
{
    /// <summary>
    /// Extension methods for Wastetransfer rows
    /// /// </summary>
    public static class WasteTransferRowExtensions
    {

        #region Methods for transfers of non-hw waste
        /// <summary>
        /// returns formatted total quantity for NON-HW waste
        /// </summary>
        public static string FormatNONHWTotal(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.TotalNONHW, row.UnitCodeNONHW);
        }

        /// <summary>
        /// returns formatted recovery quantity for NON-HW waste
        /// </summary>
        public static string FormatNONHWRecovery(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.QuantityRecoveryNONHW, row.UnitCodeNONHW);
        }
        /// <summary>
        /// returns formatted disposal quantity for NON-HW waste
        /// </summary>
        public static string FormatNONHWDisposal(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.QuantityDisposalNONHW, row.UnitCodeNONHW);
        }
        /// <summary>
        /// returns formatted unspecified quantity for NON-HW waste
        /// </summary>
        public static string FormatNONHWUnspec(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.QuantityUnspecNONHW, row.UnitCodeNONHW);
        }

        /// <summary>
        /// returns formatted tooltip text for NON-HW
        /// </summary>
        public static string ToolTipNONHW(this WasteTransfers.WasteTransferRow row)
        {
            return ToolTip(row.FormatNONHWTotal(), row.FormatNONHWRecovery(), row.FormatNONHWDisposal(), row.FormatNONHWUnspec());
        }


        #endregion


        #region Methods for transfers of hw, domestic
        /// <summary>
        /// returns formatted total quantity for HWIC waste
        /// </summary>
        public static string FormatHWICTotal(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.TotalHWIC, row.UnitCodeHWIC);
        }

        /// <summary>
        /// returns formatted recovery quantity for HWIC waste
        /// </summary>
        public static string FormatHWICRecovery(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.QuantityRecoveryHWIC, row.UnitCodeHWIC);
        }
        /// <summary>
        /// returns formatted disposal quantity for HWIC waste
        /// </summary>
        public static string FormatHWICDisposal(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.QuantityDisposalHWIC, row.UnitCodeHWIC);
        }
        /// <summary>
        /// returns formatted unspecified quantity for HWIC waste
        /// </summary>
        public static string FormatHWICUnspec(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.QuantityUnspecHWIC, row.UnitCodeHWIC);
        }

        /// <summary>
        /// returns formatted tooltip text for HWIC
        /// </summary>
        public static string ToolTipHWIC(this WasteTransfers.WasteTransferRow row)
        {
            return ToolTip(row.FormatHWICTotal(), row.FormatHWICRecovery(), row.FormatHWICDisposal(), row.FormatHWICUnspec());
        }


        #endregion

        #region Methods for transfers of hw, transboundary
        /// <summary>
        /// returns formatted total quantity for HWOC waste
        /// </summary>
        public static string FormatHWOCTotal(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.TotalHWOC, row.UnitCodeHWOC);
        }

        /// <summary>
        /// returns formatted recovery quantity for HWOC waste
        /// </summary>
        public static string FormatHWOCRecovery(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.QuantityRecoveryHWOC, row.UnitCodeHWOC);
        }
        /// <summary>
        /// returns formatted disposal quantity for HWOC waste
        /// </summary>
        public static string FormatHWOCDisposal(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.QuantityDisposalHWOC, row.UnitCodeHWOC);
        }
        /// <summary>
        /// returns formatted unspecified quantity for HWOC waste
        /// </summary>
        public static string FormatHWOCUnspec(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.QuantityUnspecHWOC, row.UnitCodeHWOC);
        }

        /// <summary>
        /// returns formatted tooltip text for HWOC
        /// </summary>
        public static string ToolTipHWOC(this WasteTransfers.WasteTransferRow row)
        {
            return ToolTip(row.FormatHWOCTotal(), row.FormatHWOCRecovery(), row.FormatHWOCDisposal(), row.FormatHWOCUnspec());
        }


        #endregion

        #region Methods for transfers of hw, total
        /// <summary>
        /// returns formatted total quantity for HW waste
        /// </summary>
        public static string FormatHWTotal(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.TotalSum, row.UnitCodeSum);
        }

        /// <summary>
        /// returns formatted recovery quantity for HW waste
        /// </summary>
        public static string FormatHWRecovery(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.QuantityRecoverySum, row.UnitCodeSum);
        }
        /// <summary>
        /// returns formatted disposal quantity for HW waste
        /// </summary>
        public static string FormatHWDisposal(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.QuantityDisposalSum, row.UnitCodeSum);
        }
        /// <summary>
        /// returns formatted unspecified quantity for HW waste
        /// </summary>
        public static string FormatHWUnspec(this WasteTransfers.WasteTransferRow row)
        {
            return QuantityFormat.Format(row.QuantityUnspecSum, row.UnitCodeSum);
        }

        /// <summary>
        /// returns formatted tooltip text for HW
        /// </summary>
        public static string ToolTipHW(this WasteTransfers.WasteTransferRow row)
        {
            return ToolTip(row.FormatHWTotal(), row.FormatHWRecovery(), row.FormatHWDisposal(), row.FormatHWUnspec());
        }


        #endregion

        #region helper methods
        private static string ToolTip(string total, string recovery, string disposal, string unspec)
        {
            return string.Format(Resources.GetGlobal("WasteTransfers","QuantityToolTip"), total, recovery,disposal,unspec);
        }
        #endregion


    }
}
