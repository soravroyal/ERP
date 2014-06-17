using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EPRTR.Localization;
using EPRTR.Formatters;
using QueryLayer;

namespace EPRTR.Formatters
{

    /// <summary>
    /// Extension methods for FacilityCountObject
    /// </summary>
    public static class WasteConfidentialFacilitiesExtension
    {

        public static string FormatFacilitiesDesc(this WasteTransfers.FacilityCountObject f)
        {
            return Resources.GetGlobal("WasteTransfers", f.Desc);
        }

        public static string FormatFacilitiesNonHW(this WasteTransfers.FacilityCountObject f)
        {
            return NumberFormat.Format(f.NONHW);
        }

        public static string FormatFacilitiesHWIC(this WasteTransfers.FacilityCountObject f)
        {
            return NumberFormat.Format(f.HWIC);
        }

        public static string FormatFacilitiesHWOC(this WasteTransfers.FacilityCountObject f)
        {
            return NumberFormat.Format(f.HWOC);
        }

        public static string FormatFacilitiesTotal(this WasteTransfers.FacilityCountObject f)
        {
            return NumberFormat.Format(f.Total);
        }

    }

}
