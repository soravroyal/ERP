using EPRTR.Localization;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using StylingHelper;

namespace EPRTR.Formatters
{
    /// <summary>
    /// Extension methods for ActivityTreeListRows
    /// /// </summary>
    public static class ActivityTreeListRowExtensions
    {
        /// <summary>
        /// returns the name of the sector / activity / subactivity
        /// </summary>
        public static string GetName(this ActivityTreeListRow row)
        {
            return LOVResources.AnnexIActivityName(row.Code);
        }

        public static string GetRowCssClass(this ActivityTreeListRow row)
        {
            return "generalListStyle_row "+ CssBuilder.TreeLevelCss(row.Level);
        }

        public static string GetIndentCssClass(this ActivityTreeListRow row)
        {
            return CssBuilder.IndentLevelCss(row.Level);
        }

        public static bool AllowFacilityLink(this ActivityTreeListRow row)
        {
            return !TreeListRow.CODE_UNKNOWN.Equals(row.Code);
        }

        public static string GetCodeAndParent(this ActivityTreeListRow row)
        {
            return row.Code + "&" + row.ParentCode;
        }

    }
}
