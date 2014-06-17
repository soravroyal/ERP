using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using QueryLayer.Filters;

namespace QueryLayer.Utilities
{

    /// <summary>
    /// Base Class for Area Tree list result rows, e.g. pollutant area data row
    /// </summary>
    [Serializable]
    public abstract class AreaTreeListRow : TreeListRow
    {
        public new const string CODE_TOTAL = "TOT";
        public new const string CODE_UNSPECIFIED = "unspecified";
        public new const string CODE_UNKNOWN = "UNKNOWN";

        public AreaTreeListRow(string countryCode, string regionCode, AreaFilter.RegionType regionType, bool hasChildren)
        {
            this.CountryCode = countryCode;
            this.RegionCode = regionCode;
            this.RegionType = regionType;

            this.HasChildren = hasChildren;
            this.IsExpanded = false;

            //set properties for backward compability
            if (!String.IsNullOrEmpty(regionCode))
            {
                base.Level = 1;
                base.Code = regionCode;
                base.ParentCode = countryCode;
            }
            else
            {
                this.Level = 0;
                base.Code = countryCode;
                base.ParentCode = null;
            }
        }

        /// <value>
        /// The country code
        /// </value>
        public string CountryCode { get; private set; }

        /// <value>
        /// The region code
        /// </value>
        public string RegionCode { get; private set; }

        /// <value>
        /// The region type
        /// </value>
        public AreaFilter.RegionType RegionType { get; private set; }

    }

}
