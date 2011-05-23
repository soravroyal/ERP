using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Filters
{
    /// <summary>
    /// Holds information which need to be passed to the flash map service
    /// </summary>
    [Serializable]
    public class MapFilter : ICloneable
    {
        /// <summary>
        /// constructor
        /// </summary>
        public MapFilter()
        {
            this.Layers = String.Empty;
            this.SqlWhere = String.Empty;
            this.VisibleLayers = String.Empty;
        }

        /// <summary>
        /// Defines the sql clause for flash maps
        /// </summary>
        public string SqlWhere { get;  set; }

        
        /// <summary>
        /// Defines the layerlist for flash maps. If the list ends with ", false" the visibility of the layers will not be touched
        /// </summary>
        public string Layers { get;  set; }

        /// <summary>
        /// Defines the layers to be set Visible. If the string is empty, default visibility will be used.
        /// </summary>
        public string  VisibleLayers { get; set; }
                
        /// <summary>
        /// Will set the layerlist based on activityfilter
        /// </summary>
        public void SetLayers(ActivityFilter activityfilter)
        {
            if (activityfilter != null)
            {
                if(!activityfilter.ActivityType.Equals(ActivityFilter.Type.AnnexI))
                {
                    this.Layers = ActivityFilter.AllSectorsID.ToString();
                }
                else if (activityfilter.SearchLevel() == ActivityFilter.Level.All)
                {
                    this.Layers = ActivityFilter.AllSectorsID.ToString();
                }
                else
                {
                    IEnumerable<LOV_ANNEXIACTIVITY> list = ListOfValues.GetAnnexIActivities(activityfilter.SectorIds);
                    if (list.Count() > 0)
                    {
                        this.Layers = String.Empty;
                        foreach (LOV_ANNEXIACTIVITY item in list)
                        {
                            if (String.IsNullOrEmpty(this.Layers))
                                this.Layers += "sector" + item.Code;
                            else
                                this.Layers += ",sector" + item.Code;
                        }
                    }
                    else
                        this.Layers = ActivityFilter.AllSectorsID.ToString();
                }
            }
            else
                this.Layers = ActivityFilter.AllSectorsID.ToString(); //all sectors

        }


        /// <summary>
        /// Creates a new object that is a deep copy of the current instance.
        /// </summary>
        public object Clone()
        {
            return this.MemberwiseClone();
        }

    }
}
