using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{
	/// <summary>
    /// Holds information about selected reporting years (period)
    /// </summary>
    [Serializable]
    public class PeriodFilter : ICloneable
	{
        /// <value>
        /// The first year to include in search. If null, no lower limit will be included
        /// </value>
		public int? StartYear { get; set; }

        /// <value>
        /// The last year to include in search. If null, no upper limit will be included
        /// </value>
        public int? EndYear { get; set; }

        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            return this.MemberwiseClone();
        }
	}
}