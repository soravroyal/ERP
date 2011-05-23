using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer;
using EPRTR.Localization;

namespace EPRTR.Formatters
{
    /// <summary>
    /// Summary description for WasteConfidentialReasonExtension
    /// </summary>
    public static class WasteConfidentialReasonExtension
    {

        public static string FormatReasonWasteType(this WasteTransfers.WasteConfidentialReason r)
        {
            return LOVResources.WasteTypeName(r.WasteTypeCode);
        }

        public static string FormatReason(this WasteTransfers.WasteConfidentialReason r)
        {
            return LOVResources.ConfidentialityReason(r.ReasonCode);
        }

        public static string FormatReasonFacilities(this WasteTransfers.WasteConfidentialReason r)
        {
            return NumberFormat.Format(r.Facilities);
        }

    }
}
