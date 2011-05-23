using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{
    /// <summary>
    /// Holds all sub-filters included in the pollutant transfer time series
    /// </summary>
    [Serializable]
    public class PollutantTransferTimeSeriesFilter : ICloneable
    {
        public AreaFilter AreaFilter { get; set; }
        public PeriodFilter PeriodFilter { get; set; }
        public PollutantFilter PollutantFilter { get; set; }
        public ActivityFilter ActivityFilter { get; set; }


        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            PollutantTransferTimeSeriesFilter clone = this.MemberwiseClone() as PollutantTransferTimeSeriesFilter;

            clone.AreaFilter = this.AreaFilter != null ? this.AreaFilter.Clone() as AreaFilter : null;
            clone.PeriodFilter = this.PeriodFilter != null ? this.PeriodFilter.Clone() as PeriodFilter  : null;
            clone.PollutantFilter = this.PollutantFilter != null ? this.PollutantFilter.Clone() as PollutantFilter : null;
            clone.ActivityFilter = this.ActivityFilter != null ? this.ActivityFilter.Clone() as ActivityFilter : null;

            return clone;
        }
    }

}
