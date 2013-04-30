using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EPRTR.Localization;
using QueryLayer;

namespace EPRTR.Formatters
{
    /// <summary>
    /// Creates a combined address string.
    /// </summary>
    public static class FacilityDetailsFormat
    {

        /// <summary>
        /// Returnes a combined national ID string with national ID and year.
        /// </summary>
        public static string FormatNationalId(FACILITYDETAIL_DETAIL fac)
        {

            return fac.NationalID + " " +string.Format(Resources.GetGlobal("Facility", "InYear"), fac.ReportingYear);
            
        }
    }
}
