using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{
    /// <summary>
    /// Holds information about selected activities (sector, activity, sub-activity) including type (E-PRTR, NACE, IPPC)
    /// </summary>
    [Serializable]
    public class ActivityFilter : ICloneable
    {
        public const int AllSectorsID = -1;
        public const int AllActivitiesInSectorID = -1;
        public const int AllSubActivitiesInActivityID = -1;
        public const int SubActivitiesUnspecifiedID = -2;

        public ActivityFilter()
        {
            this.SectorIds = new List<int>();
            this.ActivityIds = new List<int>();
            this.SubActivityIds = new List<int>();
        }


        /// <value>
        /// Selected sectors given by LOV id
        /// </value>
        public List<int> SectorIds {get; set;}

        /// <value>
        /// Selected activities given by LOV id
        /// </value>
        public List<int> ActivityIds{get; set;}

        /// <value>
        /// Selected subactivities given by LOV id
        /// </value>
        public List<int> SubActivityIds{get; set;}

        /// <value>
        /// The type of activity to search for
        /// </value>
        public Type ActivityType {get; set;}


        /// <summary>
        /// Returns the level of activities to search for, i.e. sector, activity or subactivity
        /// </summary>
        public Level SearchLevel()
        {
            if (SectorIds.Contains(AllSectorsID)){
                return Level.All;
            }
            else if (SectorIds.Count>1 || ActivityIds.Contains(AllActivitiesInSectorID))
            {
                return Level.Sector;
            }
            else if (ActivityIds.Count>1 || SubActivityIds.Contains(AllSubActivitiesInActivityID))
            {
                return Level.Activity;
            }
            else
            {
                return Level.SubActivity;
            }

        }

        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            ActivityFilter clone = this.MemberwiseClone() as ActivityFilter;

            clone.SectorIds = new List<int>(this.SectorIds);
            clone.ActivityIds = new List<int>(this.ActivityIds);
            clone.SubActivityIds = new List<int>(this.SubActivityIds);

            return clone;
        }



        /// <summary>
        /// Defines the possible levels of activities that can be selected
        /// </summary>
        public enum Level
        {
            All = 0,
            Sector,
            Activity,
            SubActivity
        }


        /// <summary>
        /// Defines the possible types of activities
        /// </summary>
        public enum Type
        {
            AnnexI = 0,
            NACE,
            IPPC
        }


    }
}
