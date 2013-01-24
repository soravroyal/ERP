using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{
    /// <summary>
    /// Holds all sub-filters included in the activity search
    /// </summary>
    [Serializable]
    public class AreaOverviewSearchFilter : ICloneable
    {
        public AreaFilter AreaFilter { get; set; }
        public YearFilter YearFilter { get; set; }
        public int Count;

        public AreaOverviewSearchFilter()
        {
            Count = 0;
        }

        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            AreaOverviewSearchFilter clone = this.MemberwiseClone() as AreaOverviewSearchFilter;

            clone.AreaFilter = this.AreaFilter != null ? this.AreaFilter.Clone() as AreaFilter : null;
            clone.YearFilter = this.YearFilter != null ? this.YearFilter.Clone() as YearFilter : null;

            return clone;
        }


    }
}
