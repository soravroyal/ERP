using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{
    /// <summary>
    /// Holds information about selected receiving country for waste transfers outside country (transboundary)
    /// </summary>
    [Serializable]
    public class WasteReceiverFilter : ICloneable
    {
        public const int AllCountriesID = -1;

        /// <value>
        /// The ID of the selected country.
        /// </value>
        public int CountryID {get; set;}


         /// <summary>
        /// Returns the level of countries to search for, i.e. all or specific country
        /// </summary>
        public Level SearchLevel()
        {
            if (CountryID == AllCountriesID)
            {
                return Level.All;
            }
            else
            {
                return Level.Country;
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
        /// Defines the possible levels of countries that can be selected
        /// </summary>
        public enum Level
        {
            All = 0,
            Country
        }

    }
}
