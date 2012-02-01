using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{
    /// <summary>
    /// Holds all sub-filters included in the pollutant transfer search
    /// </summary>
    [Serializable]
    public class PollutantTransfersSearchFilter : ICloneable
    {
        public AreaFilter AreaFilter { get; set; }
        public YearFilter YearFilter { get; set; }
        public PollutantFilter PollutantFilter { get; set; }
        public ActivityFilter ActivityFilter { get; set; }
		public int Count { get; set; }

        public PollutantTransfersSearchFilter()
        {
            Count = 0;
        }

        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            PollutantTransfersSearchFilter clone = this.MemberwiseClone() as PollutantTransfersSearchFilter;

            clone.AreaFilter = this.AreaFilter != null ? this.AreaFilter.Clone() as AreaFilter : null;
            clone.YearFilter = this.YearFilter != null ? this.YearFilter.Clone() as YearFilter : null;
            clone.PollutantFilter = this.PollutantFilter != null ? this.PollutantFilter.Clone() as PollutantFilter : null;
            clone.ActivityFilter = this.ActivityFilter != null ? this.ActivityFilter.Clone() as ActivityFilter : null;

            return clone;
        }

    }

}
