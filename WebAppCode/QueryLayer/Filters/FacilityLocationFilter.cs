using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{

    /// <summary>
    /// Holds information about facility name/parentcompany and town/village to search for
    /// </summary>
    [Serializable]
    public class FacilityLocationFilter : ICloneable
    {
        /// <summary>
        /// The town/village must include this text
        /// </summary>
        public string CityName { get; set; }

        /// <summary>
        /// The facility name or parent companyname must include this text
        /// </summary>
        public string FacilityName { get; set; }

        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            return this.MemberwiseClone();
        }

    }
}