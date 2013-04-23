using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StylingHelper
{
    /// <summary>
    /// object for report-details view in details view.
    /// </summary>
    public class FacilityDetailElement
    {
        public FacilityDetailElement(string label, string value)
        {
            this.Label = label;
            this.Value = value;
        }

        public FacilityDetailElement(string label, string value, bool isHeader)
            : this(label, value)
        {
            this.IsHeader = isHeader;
        }

        public string Label { get; set; }
        public string Value { get; set; }
        public bool IsHeader { get; set; }
    }
}
