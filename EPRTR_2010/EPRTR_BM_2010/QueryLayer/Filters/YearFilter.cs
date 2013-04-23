using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{
	/// <summary>
    /// Holds information about selected reporting year
    /// </summary>
    [Serializable]
    public class YearFilter : ICloneable
	{
		public int Year { get; set; }

        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            return this.MemberwiseClone();
        }
    
    }


}