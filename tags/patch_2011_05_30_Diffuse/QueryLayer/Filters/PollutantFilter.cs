using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{

    /// <summary>
    /// Holds information about selected pollutantgroup and pollutant
    /// </summary>
    [Serializable]
    public class PollutantFilter : ICloneable
    {
        public const int AllGroupsID = -1;
        public const int AllPollutantsInGroupID = -1;

        /// <value>
        /// Selected pollutant group ID
        /// </value>
        public int PollutantGroupID {get; set;}

        /// <value>
        /// Selected pollutant ID. 
        /// </value>
        public int PollutantID {get; set;}


        /// <summary>
        /// Returns the level of pollutants to search for, i.e. pollutantgroup or specific pollutant
        /// </summary>
        public Level SearchLevel()
        {
            if (PollutantGroupID == AllGroupsID)
            {
                return Level.All;
            }
            else if (PollutantID == AllPollutantsInGroupID)
            {
                return Level.PollutantGroup;
            }
            else
            {
                return Level.Pollutant;
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
        /// Defines the possible levels of pollutants that can be selected
        /// </summary>
        public enum Level
        {
            All = 0,
            PollutantGroup,
            Pollutant
        }

    }
}