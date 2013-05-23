using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Utilities
{

    /// <summary>
    /// Base Class for Activity Tree list result rows, e.g. pollutant activity data row
    /// </summary>
    [Serializable]
    public abstract class ActivityTreeListRow : TreeListRow
    {
        public new const string CODE_TOTAL = "TOT";
        public new const string CODE_UNSPECIFIED = "unspecified";
        public new const string CODE_UNKNOWN = "UNKNOWN";

        public ActivityTreeListRow(string sectorCode, string activityCode, string subActivityCode, bool hasChildren)
        {
            this.SectorCode = sectorCode;
            this.ActivityCode = activityCode;
            this.SubactivityCode = subActivityCode;

            this.HasChildren = hasChildren;
            this.IsExpanded = false;

            //set properties for backward compability
            if (!String.IsNullOrEmpty(subActivityCode))
            {
                base.Level = 2;
                base.Code = subActivityCode;
                base.ParentCode = activityCode;
            }
            else if (!String.IsNullOrEmpty(activityCode))
            {
                this.Level = 1;
                base.Code = activityCode;
                base.ParentCode = sectorCode;
            }
            else
            {
                this.Level = 0;
                base.Code = sectorCode;
                base.ParentCode = null;
            }
        }

        /// <value>
        /// The sector code
        /// </value>
        public string SectorCode { get; private set; }

        /// <value>
        /// The activity code
        /// </value>
        public string ActivityCode { get; private set; }

        /// <value>
        /// The subactivity code
        /// </value>
        public string SubactivityCode { get; private set; }

    }

}
