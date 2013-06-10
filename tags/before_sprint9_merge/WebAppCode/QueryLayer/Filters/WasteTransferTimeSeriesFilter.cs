using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{
    /// <summary>
    /// Holds all sub-filters included in the waste transfer time series search
    /// </summary>
    [Serializable]
    public class WasteTransferTimeSeriesFilter : ICloneable
    {
        public AreaFilter AreaFilter {get; set;}
        public PeriodFilter PeriodFilter { get; set; }
        public ActivityFilter ActivityFilter { get; set; }
        public WasteTypeFilter WasteTypeFilter { get; set; }
        public WasteTreatmentFilter WasteTreatmentFilter { get; set; }

        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            WasteTransferTimeSeriesFilter clone = this.MemberwiseClone() as WasteTransferTimeSeriesFilter;

            clone.AreaFilter = this.AreaFilter != null ? this.AreaFilter.Clone() as AreaFilter : null;
            clone.PeriodFilter = this.PeriodFilter != null ? this.PeriodFilter.Clone() as PeriodFilter : null;
            clone.ActivityFilter = this.ActivityFilter != null ? this.ActivityFilter.Clone() as ActivityFilter : null;
            clone.WasteTypeFilter = this.WasteTypeFilter != null ? this.WasteTypeFilter.Clone() as WasteTypeFilter : null;
            clone.WasteTreatmentFilter = this.WasteTreatmentFilter != null ? this.WasteTreatmentFilter.Clone() as WasteTreatmentFilter : null;

            return clone;
        }

    }
}
