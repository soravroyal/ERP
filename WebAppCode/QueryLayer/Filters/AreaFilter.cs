using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{

    /// <summary>
    /// Holds information about selected areagroup, country and region/river basin district
    /// </summary>
    [Serializable]
    public class AreaFilter : ICloneable
    {
        public const int AllCountriesInAreaGroupID = -1;
        public const int AllRegionsInCountryID = -1;

        /// <value>
        /// The ID of the selected region. The type of region is determined by the <see cref="RegionType"/>
        /// </value>
        public int? RegionID {get; set;}

        /// <value>
        /// The type of region 
        /// </value>
        public RegionType TypeRegion{get; set;}

        /// <value>
        /// The ID of the selected areagoup. Null if a specific country is selected.
        /// </value>
        public int? AreaGroupID {get; set;}

        /// <value>
        /// The ID of the selected country. Will be null if a specific country is not selected.
        /// </value>
        public int? CountryID {get; set;}

        /// <summary>
        /// Returns the level of area to search for, i.e. areagroup, country or region
        /// </summary>
        public Level SearchLevel()
        {
            if (RegionID != AllRegionsInCountryID)
            {
                return Level.Region;
            }
            else if (CountryID != AllCountriesInAreaGroupID)
            {
                return Level.Country;
            }
            else
            {
                return Level.AreaGroup;
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
        /// Defines the possible levels of area that can be selected
        /// </summary>
        public enum Level
        {
            AreaGroup = 0,
            Country,
            Region
        }

        /// <summary>
        /// Defines the possible types of regions
        /// </summary>
        public enum RegionType
        {
            NUTSregion = 0,
            RiverBasinDistrict
        }

    }
}
