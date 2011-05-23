using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using QueryLayer.Utilities;

namespace QueryLayer.Filters
{
	/// <summary>
	/// Holds information about selected waste treatment for waste transfers
	/// </summary>
	[Serializable]
    public class WasteTreatmentFilter : ICloneable
	{

		/// <summary>
		/// true if selection includes transfers for recovery, false otherwise
		/// </summary>
		public bool Recovery { get; set; }

		/// <summary>
		/// true if selection includes transfers for disposal, false otherwise
		/// </summary>
		public bool Disposal { get; set; }

		/// <summary>
		/// true if selection includes transfers with treatment not defined (due to confidentiality), false otherwise
		/// </summary>
		public bool Unspecified { get; set; }


        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            return this.MemberwiseClone();
        }

		/// <summary>
		/// Defines the possible waste treatments in the database where UNSPEC corresponds to NULL in the database
		/// </summary>
		public enum Treatment
		{
			[StringValue("U")]
			Unspecified = 0,
			[StringValue("R")]
			Recovery,
			[StringValue("D")]
			Disposal
		}
	}
}