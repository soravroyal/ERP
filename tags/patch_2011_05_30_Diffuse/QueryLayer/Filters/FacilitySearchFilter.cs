using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{
    /// <summary>
    /// Holds all sub-filters included in the facility search
    /// </summary>
    [Serializable]
    public class FacilitySearchFilter : ICloneable
    {
        public AreaFilter AreaFilter { get; set; }
		public FacilityLocationFilter FacilityLocationFilter { get; set; }
		public YearFilter YearFilter { get; set; }
		public ActivityFilter ActivityFilter { get; set; }
		public PollutantFilter PollutantFilter { get; set; }
        public MediumFilter MediumFilter { get; set; }
		public WasteTypeFilter WasteTypeFilter { get; set; }
        public WasteTreatmentFilter WasteTreatmentFilter { get; set; }
        public WasteReceiverFilter WasteReceiverFilter { get; set; }

		public int Count { get; set; }


        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            FacilitySearchFilter clone = this.MemberwiseClone() as FacilitySearchFilter;

            clone.AreaFilter = this.AreaFilter != null ? this.AreaFilter.Clone() as AreaFilter : null;
            clone.FacilityLocationFilter = this.FacilityLocationFilter != null ? this.FacilityLocationFilter.Clone() as FacilityLocationFilter : null;
            clone.YearFilter = this.YearFilter != null ? this.YearFilter.Clone() as YearFilter : null;
            clone.ActivityFilter = this.ActivityFilter != null ? this.ActivityFilter.Clone() as ActivityFilter : null;
            clone.PollutantFilter = this.PollutantFilter != null ? this.PollutantFilter.Clone() as PollutantFilter : null;
            clone.MediumFilter = this.MediumFilter != null ? this.MediumFilter.Clone() as MediumFilter : null;
            clone.WasteTypeFilter = this.WasteTypeFilter != null ? this.WasteTypeFilter.Clone() as WasteTypeFilter: null;
            clone.WasteTreatmentFilter = this.WasteTreatmentFilter != null ? this.WasteTreatmentFilter.Clone() as WasteTreatmentFilter : null;
            clone.WasteReceiverFilter = this.WasteReceiverFilter != null ? this.WasteReceiverFilter.Clone() as WasteReceiverFilter : null; 

            return clone;
        }

        public FacilitySearchFilter()
        {
            Count = 0;
        }

        /// <summary>
        /// returns true if filter contains any criteria for pollutant releases or transfers
        /// </summary>
        public bool IsPollutantIncluded()
        {
            return PollutantFilter != null || MediumFilter != null;
        }

        /// <summary>
        /// returns true if filter contains any criteria for waste transfers
        /// </summary>
        public bool IsWasteIncluded()
        {
            return WasteTypeFilter!= null || WasteTreatmentFilter != null || WasteReceiverFilter != null;
        }

        /// <summary>
        /// returns true if filters only covers main data (i.e. not pollutants or waste)
        /// </summary>
        internal bool OnlyMainFilter()
        {
            return !IsPollutantIncluded() && !IsWasteIncluded();
        }
    }
}
