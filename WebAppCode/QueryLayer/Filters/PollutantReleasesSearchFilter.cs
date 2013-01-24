using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{
    /// <summary>
    /// Holds all sub-filters included in the pollutant release search
    /// </summary>
    [Serializable]
    public class PollutantReleaseSearchFilter : ICloneable
    {
        public AreaFilter AreaFilter { get; set; }
        public YearFilter YearFilter { get; set; }
        public PollutantFilter PollutantFilter { get; set; }
        public MediumFilter MediumFilter { get; set; }
        public ActivityFilter ActivityFilter { get; set; }
        public int Count { get; set; }

        public PollutantReleaseSearchFilter()
        {
            Count = 0;
        }

        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            PollutantReleaseSearchFilter clone = this.MemberwiseClone() as PollutantReleaseSearchFilter;

            clone.AreaFilter = this.AreaFilter != null ? this.AreaFilter.Clone() as AreaFilter : null;
            clone.YearFilter = this.YearFilter != null ? this.YearFilter.Clone() as YearFilter : null;
            clone.PollutantFilter = this.PollutantFilter != null ? this.PollutantFilter.Clone() as PollutantFilter : null;
            clone.MediumFilter = this.MediumFilter != null ? this.MediumFilter.Clone() as MediumFilter : null;
            clone.ActivityFilter = this.ActivityFilter != null ? this.ActivityFilter.Clone() as ActivityFilter : null;

            return clone;
        }

    }
}
