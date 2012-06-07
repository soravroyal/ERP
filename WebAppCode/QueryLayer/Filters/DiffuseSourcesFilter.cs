using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{
    /// <summary>
    /// Holds all sub-filters defining facilities corresponding to diffuce sources
    /// </summary>
    [Serializable]

    public class DiffuseSourcesFilter : ICloneable
    {
        public YearFilter YearFilter { get; set; }
        public ActivityFilter ActivityFilter { get; set; }
        public PollutantFilter PollutantFilter { get; set; }
        public MediumFilter MediumFilter { get; set; }


        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            DiffuseSourcesFilter clone = this.MemberwiseClone() as DiffuseSourcesFilter;

            clone.YearFilter = this.YearFilter != null ? this.YearFilter.Clone() as YearFilter : null;
            clone.ActivityFilter = this.ActivityFilter != null ? this.ActivityFilter.Clone() as ActivityFilter : null;
            clone.PollutantFilter = this.PollutantFilter != null ? this.PollutantFilter.Clone() as PollutantFilter : null;
            clone.MediumFilter = this.MediumFilter != null ? this.MediumFilter.Clone() as MediumFilter : null;

            return clone;
        }
    }


}
