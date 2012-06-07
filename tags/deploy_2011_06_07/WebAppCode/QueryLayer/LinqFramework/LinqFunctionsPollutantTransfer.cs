using System;
using System.Linq;
using QueryLayer.Filters;
using QueryLayer.Utilities;


namespace QueryLayer.LinqFramework
{
    static class LinqFunctionsPollutantTransfer
    {


        /// <summary>
        /// Group by Area depending on the region type
        /// </summary>
        public static IQueryable<IGrouping<TreeListRowGroupByKey, POLLUTANTTRANSFER>> GroupBy(this IQueryable<POLLUTANTTRANSFER> source, AreaFilter.RegionType regionType)
        {
            switch (regionType)
            {
                case AreaFilter.RegionType.NUTSregion:
                    return source.GroupBy(p => new TreeListRowGroupByKey{Code = p.NUTSLevel2RegionCode, ParentCode=p.CountryCode});
                case AreaFilter.RegionType.RiverBasinDistrict:
                    return source.GroupBy(p => new TreeListRowGroupByKey { Code = p.RiverBasinDistrictCode, ParentCode = p.CountryCode });
                default:
                    throw new ArgumentOutOfRangeException("RegionType", String.Format("Illegal region type:{0}", regionType.ToString()));
            }

        }


        /// <summary>
        /// Group by Area depending on the Area filter
        /// </summary>
        public static IQueryable<IGrouping<TreeListRowGroupByKey, POLLUTANTTRANSFER>> GroupBy(this IQueryable<POLLUTANTTRANSFER> source, AreaFilter areaFilter)
        {
            if (areaFilter == null)
            {
                throw new ArgumentNullException();
            }

            if (areaFilter.SearchLevel() == AreaFilter.Level.AreaGroup)
            {
                //group by country
                return source.GroupBy(p => new TreeListRowGroupByKey{Code = p.CountryCode, ParentCode=null});
            }
            else
            {
                //group by region
                return source.GroupBy(areaFilter.TypeRegion);
            }

        }
    }
}
