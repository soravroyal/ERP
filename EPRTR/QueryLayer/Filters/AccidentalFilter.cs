using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using QueryLayer.Utilities;

namespace QueryLayer.Filters
{
    /// <summary>
    /// Holds information about to include only accidental releases
    /// </summary>
    [Serializable]
    public class AccidentalFilter : ICloneable
    {
        /// <summary>
        /// true if selection includes only accidental releases, false otherwise
        /// </summary>
        public bool AccidentalOnly { get; set; }


        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            return this.MemberwiseClone();
        }


        /// <summary>
        /// accidental only will be false
        /// </summary>
        public AccidentalFilter()
        {
            // default contructor
            AccidentalOnly = false;
        }

        public AccidentalFilter(bool accidentalOnly)
        {
            this.AccidentalOnly = accidentalOnly;
        }
    }
}