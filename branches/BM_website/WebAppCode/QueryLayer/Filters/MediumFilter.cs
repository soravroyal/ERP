using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using QueryLayer.Utilities;

namespace QueryLayer.Filters
{
	/// <summary>
	/// Holds information about selected medium for pollutant releases and transfers
	/// </summary>
	[Serializable]
	public class MediumFilter : ICloneable
	{
		/// <summary>
		/// true if selection includes releaes to air, false otherwise
		/// </summary>
		public bool ReleasesToAir { get; set; }

		/// <summary>
		/// true if selection includes releaes to soil, false otherwise
		/// </summary>
		public bool ReleasesToSoil { get; set; }

		/// <summary>
		/// true if selection includes releaes to water, false otherwise
		/// </summary>
		public bool ReleasesToWater { get; set; }

		/// <summary>
		/// true if selection includes transfers to wastewater, false otherwise
		/// </summary>
		public bool TransferToWasteWater { get; set; }


        /// <summary>
        /// Returns true if the filter includes the medium given.
        /// </summary>
        public bool InludesMedium(MediumFilter.Medium medium)
        {
            switch (medium)
            {
                case Medium.Air:
                    return ReleasesToAir;
                case Medium.Water:
                    return ReleasesToWater;
                case Medium.Soil:
                    return ReleasesToSoil;
                case Medium.WasteWater:
                    return TransferToWasteWater;

                default:
                    throw new ArgumentOutOfRangeException("Unknown medium");
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
		/// Defines the possible mediums in the database
		/// </summary>
		public enum Medium
		{
			[StringValue("AIR")]
			Air = 0,
			[StringValue("LAND")]
			Soil,
			[StringValue("WATER")]
			Water,
			[StringValue("WASTEWATER")]
			WasteWater
		}

        public MediumFilter()
        {
            // default contructor
        }

        public MediumFilter(MediumFilter.Medium medium)
        {
            ReleasesToAir = false;
            ReleasesToWater = false;
            ReleasesToSoil = false;
            TransferToWasteWater = false;

            switch (medium)
            {
                case MediumFilter.Medium.Air:
                    {
                        ReleasesToAir = true;
                        break;
                    }
                case MediumFilter.Medium.Water:
                    {
                        ReleasesToWater = true;
                        break;
                    }
                case MediumFilter.Medium.Soil:
                    {
                        ReleasesToSoil = true;
                        break;
                    }
                case MediumFilter.Medium.WasteWater:
                    {
                        TransferToWasteWater = true;
                        break;
                    }
            }

        }

	}
}
