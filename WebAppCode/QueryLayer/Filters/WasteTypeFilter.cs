using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using QueryLayer.Utilities;

namespace QueryLayer.Filters
{
	/// <summary>
	/// Holds information about selected waste type for waste transfers
	/// </summary>
	[Serializable]
	public class WasteTypeFilter :ICloneable
	{
		/// <summary>
		/// true if selection includes transfer of non hazardous waste, false otherwise
		/// </summary>
		public bool NonHazardousWaste { get; set; }

		/// <summary>
		/// true if selection includes transfer of hazardous waste within country (domestic), false otherwise
		/// </summary>
		public bool HazardousWasteCountry { get; set; }

		/// <summary>
		/// true if selection includes transfer of hazardous waste outside country (transboundary), false otherwise
		/// </summary>
		public bool HazardousWasteTransboundary { get; set; }

        /// <summary>
        /// Returns true if the filter includes the waste type given.
        /// </summary>
        public bool InludesWasteType(WasteTypeFilter.Type wasteType)
        {
            switch (wasteType)
            {
                case Type.NonHazardous:
                    return NonHazardousWaste;
                case Type.HazardousCountry:
                    return HazardousWasteCountry;
                case Type.HazardousTransboundary:
                    return HazardousWasteTransboundary;
                case Type.Hazardous:
                    return HazardousWasteCountry || HazardousWasteTransboundary;
                default:
                    throw new ArgumentOutOfRangeException("Unknown waste type") ;
            }
        }



        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            return this.MemberwiseClone();
        }

		/// <summary>
		/// Defines the possible waste types in the database
		/// </summary>
		public enum Type
		{
			[StringValue("NON-HW")]
			NonHazardous = 0,
			
            [StringValue("HWIC")]
			HazardousCountry,
			
            [StringValue("HWOC")]
			HazardousTransboundary,
            
            [StringValue("HW")] //representes the total of HWOC and HWIC (not included in the search options)
            Hazardous
		}

        public WasteTypeFilter()
        {
            // default contructor
        }

        public WasteTypeFilter(WasteTypeFilter.Type wasteType)
        {
            this.HazardousWasteCountry = false;
            this.HazardousWasteTransboundary = false;
            this.NonHazardousWaste = false;
            
            switch (wasteType)
            {
                case WasteTypeFilter.Type.HazardousCountry:
                    {
                        HazardousWasteCountry = true;
                        break;
                    }
                case WasteTypeFilter.Type.HazardousTransboundary:
                    {
                        HazardousWasteTransboundary = true;
                        break;
                    }
                case WasteTypeFilter.Type.NonHazardous:
                    {
                        NonHazardousWaste = true;
                        break;
                    }
            }
        }
	}
}