using EPRTR.Localization;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using StylingHelper;

namespace EPRTR.Formatters
{
    /// <summary>
    /// Extension methods for TreeListRows
    /// /// </summary>
    public static class TreeListRowExtensions
    {

        public static string GetAreaName(this TreeListRow row, AreaFilter areaFilter)
        {
            switch (row.Level)
            {
                case 0: //country
                    return LOVResources.CountryName(row.Code);

                case 1: //River absin district or NUTS
                    {
                        AreaFilter.RegionType type = areaFilter.TypeRegion;

                        if (type == AreaFilter.RegionType.RiverBasinDistrict)
                        {
                            return LOVResources.RiverBasinDistrictName(row.Code);
                        }
                        else
                        {
                            return LOVResources.NutsRegionName(row.Code);
                        }
                    }

                default:
                    return string.Empty;

            }
        }

        public static string GetAnnexIActivityName(this TreeListRow row)
        {
            return LOVResources.AnnexIActivityName(row.Code);
        }

        public static string GetRowCssClass(this TreeListRow row)
        {
            return "generalListStyle_row "+ CssBuilder.TreeLevelCss(row.Level);
        }

        public static string GetIndentCssClass(this TreeListRow row)
        {
            return CssBuilder.IndentLevelCss(row.Level);
        }

        public static string GetCodeAndParent(this TreeListRow row)
        {
            return row.Code + "&" + row.ParentCode; 
        }

        public static bool AllowFacilityLink(this TreeListRow row)
        {
            return !TreeListRow.CODE_UNKNOWN.Equals(row.Code);
        }

    }
}
