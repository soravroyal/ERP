using System;
using System.Linq;
using System.Linq.Expressions;
using QueryLayer.Filters;
using QueryLayer.Utilities;

namespace QueryLayer.LinqFramework
{

    static class LinqFunctionsPollutantRelease
    {

        public static Func<POLLUTANTRELEASE, double?> QuantityTotal(MediumFilter.Medium medium)
        {
            Expression<Func<POLLUTANTRELEASE, double?>> func;

            switch (medium)
            {
                case MediumFilter.Medium.Air:
                    func = z => z.QuantityAir;
                    break;
                case MediumFilter.Medium.Soil:
                    func = z => z.QuantitySoil;
                    break;
                case MediumFilter.Medium.Water:
                    func = z => z.QuantityWater;
                    break;
                default:
                    throw new ArgumentOutOfRangeException("medium", String.Format("Illegal medium:{0}", medium.ToString()));
            }
            return func.Compile();
        }


        /// <summary>
        /// Group by depending on the region type
        /// </summary>
        public static IQueryable<IGrouping<TreeListRowGroupByKey, POLLUTANTRELEASE>> GroupBy(this IQueryable<POLLUTANTRELEASE> source, AreaFilter.RegionType regionType)
        {
            switch (regionType)
            {
                case AreaFilter.RegionType.NUTSregion:
                    return source.GroupBy(p => new TreeListRowGroupByKey { Code = p.NUTSLevel2RegionCode, ParentCode = p.CountryCode });
                case AreaFilter.RegionType.RiverBasinDistrict:
                    return source.GroupBy(p => new TreeListRowGroupByKey { Code = p.RiverBasinDistrictCode, ParentCode = p.CountryCode });
                default:
                    throw new ArgumentOutOfRangeException("RegionType", String.Format("Illegal region type:{0}", regionType.ToString()));
            }

        }

        /// <summary>
        /// Group by Area depending on the Area filter
        /// </summary>
        public static IQueryable<IGrouping<TreeListRowGroupByKey, POLLUTANTRELEASE>> GroupBy(this IQueryable<POLLUTANTRELEASE> source, AreaFilter areaFilter)
        {
            if (areaFilter == null)
            {
                throw new ArgumentNullException();
            }

            if (areaFilter.SearchLevel() == AreaFilter.Level.AreaGroup)
            {
                //group by country
                return source.GroupBy(p => new TreeListRowGroupByKey { Code = p.CountryCode, ParentCode = null });
            }
            else
            {
                //group by region
                return source.GroupBy(areaFilter.TypeRegion);
            }

        }

    }
}
