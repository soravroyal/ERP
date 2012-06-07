using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Utilities
{

    class TreeListRowGroupByKey
    {
        public TreeListRowGroupByKey() { }

        public string Code { get; set; }
        public string ParentCode { get; set; }
    }

    /// <summary>
    /// Base Class for Tree list result rows, e.g. pollutant activity/area data row
    /// </summary>
    [Serializable]
    public abstract class TreeListRow
    {
        public const string CODE_TOTAL = "TOT";
        public const string CODE_UNSPECIFIED = "unspecified";
        public const string CODE_UNKNOWN = "UNKNOWN";

        protected TreeListRow()
        {
        }

        public TreeListRow(string code, string parentCode, int level, bool hasChildren)
        {
            this.Level = level;
            this.HasChildren = hasChildren;
            this.Code = code;
            this.ParentCode = parentCode;
        }

        /// <value>
        /// A code identifing the row (must be unique within the tree), i.e. activity code
        /// </value>
        public string Code{ get; protected set; }


        /// <value>
        /// A code identifing the parent row (must be unique within the tree), i.e. sector code
        /// </value>
        public string ParentCode { get; protected set; }

        /// <value>
        /// The level of thsi row in the tree. 
        /// </value>
        public int Level {get; set;} 

        /// <value>
        /// True if this row has any child-rows.
        /// </value>
        public bool HasChildren{get; set;}  


        /// <value>
        /// True if this row is currently expanded in the tree.
        /// </value>
        public bool IsExpanded { get; set; }
        }


    }
