using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace StylingHelper
{
    /// <summary>
    /// object for comparison tables. E.g. used in time series comparison
    /// </summary>
    public class CompareDetailElement
    {
        public CompareDetailElement()
        {
        }

        public CompareDetailElement(string label, string value1, string value2)
        {
            this.Label = label;
            this.Value1 = value1;
            this.Value2 = value2;
        }

        public CompareDetailElement(string label, string value1, string value2, int level)
            : this(label, value1, value2)
        {
            this.Level = level;
        }

        public string Label { get; set; }
        public string Value1 { get; set; }
        public string Value2 { get; set; }
        public int Level { get; set; }
    }

}
