using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace StylingHelper
{
    /// <summary>
    /// Helper methods for generating css class names
    /// </summary>
    public static class CssBuilder
    {
        /// <summary>
        /// returns the class name of the css for sheet look depenent of the sheet level
        /// </summary>
        public static string SheetCss(int? sheetLevel)
        {
            if (sheetLevel == null)
            {
                sheetLevel = 0; //set default level
            }
            return "look_sheet_level" + sheetLevel;
        }


        /// <summary>
        /// returns the class name of the css for a tree row depenent of the row level
        /// </summary>
        public static string TreeLevelCss(int? rowLevel)
        {
            if (rowLevel == null)
            {
                rowLevel = 0; //set default level
            }
            return "TreeLevel" + rowLevel;
        }

        /// <summary>
        /// returns the class name of the css for a tree row indent depenent of the row level
        /// </summary>
        public static string IndentLevelCss(int? level)
        {
            if (level == null)
            {
                level = 0; //set default level
            }
            return "indentLevel" + level;
        }

    }
}
