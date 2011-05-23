using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{
    /// <summary>
    /// Holds all sub-filters included in the waste transfer search
    /// </summary>
    [Serializable]
    public class WasteTransferSearchFilter : ICloneable
    {
        public AreaFilter AreaFilter {get; set;}
        public YearFilter YearFilter { get; set; }
        public ActivityFilter ActivityFilter { get; set; }
        public WasteTypeFilter WasteTypeFilter { get; set; }
        public WasteTreatmentFilter WasteTreatmentFilter { get; set; }
        public int Count {get; set;}

        public WasteTransferSearchFilter()
        {
            Count = 0;
        }

        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            WasteTransferSearchFilter clone = this.MemberwiseClone() as WasteTransferSearchFilter;

            clone.AreaFilter = this.AreaFilter != null ? this.AreaFilter.Clone() as AreaFilter : null;
            clone.YearFilter = this.YearFilter != null ? this.YearFilter.Clone() as YearFilter : null;
            clone.ActivityFilter = this.ActivityFilter != null ? this.ActivityFilter.Clone() as ActivityFilter : null;
            clone.WasteTypeFilter = this.WasteTypeFilter != null ? this.WasteTypeFilter.Clone() as WasteTypeFilter : null;
            clone.WasteTreatmentFilter = this.WasteTreatmentFilter != null ? this.WasteTreatmentFilter as WasteTreatmentFilter : null;
            return clone;
        }

    }
}
