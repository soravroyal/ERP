using System;
using System.Linq;
using System.Linq.Expressions;
using QueryLayer.Filters;
using QueryLayer.Utilities;

namespace QueryLayer.LinqFramework
{
    /// <summary>
    /// Holds linq functions for waste dataclasses
    /// </summary>
    static class LinqFunctionsWaste
    {

        #region WASTETRANSFER
        /// <summary>
        /// Select the correct total quantity dependend on the waste type
        /// </summary>
        public static Func<WASTETRANSFER, double?> QuantityTotal(WasteTypeFilter.Type wasteType)
        {
            Expression<Func<WASTETRANSFER, double?>> func;

            switch (wasteType)
            {
                case WasteTypeFilter.Type.NonHazardous:
                    func = z => z.QuantityTotalNONHW;
                    break;
                case WasteTypeFilter.Type.HazardousCountry:
                    func = z => z.QuantityTotalHWIC;
                    break;
                case WasteTypeFilter.Type.HazardousTransboundary:
                    func = z => z.QuantityTotalHWOC;
                    break;
                default:
                    throw new ArgumentOutOfRangeException("wasteType", String.Format("Illegal waste type:{0}", wasteType.ToString()));
            }
            return func.Compile();
        }

        /// <summary>
        /// Select the correct recovery quantity dependend on the waste type
        /// </summary>
        public static Func<WASTETRANSFER, double?> QuantityRecovery(WasteTypeFilter.Type wasteType)
        {
            Expression<Func<WASTETRANSFER, double?>> func;

            switch (wasteType)
            {
                case WasteTypeFilter.Type.NonHazardous:
                    func = s => s.QuantityRecoveryNONHW;
                    break;
                case WasteTypeFilter.Type.HazardousCountry:
                    func = s => s.QuantityRecoveryHWIC;
                    break;
                case WasteTypeFilter.Type.HazardousTransboundary:
                    func = s => s.QuantityRecoveryHWOC;
                    break;
                default:
                    throw new ArgumentOutOfRangeException("wasteType", String.Format("Illegal waste type:{0}", wasteType.ToString()));
            }
            return func.Compile();
        }


        /// <summary>
        /// Select the correct disposal quantity dependend on the waste type
        /// </summary>
        public static Func<WASTETRANSFER, double?> QuantityDisposal(WasteTypeFilter.Type wasteType)
        {
            Expression<Func<WASTETRANSFER, double?>> func;

            switch (wasteType)
            {
                case WasteTypeFilter.Type.NonHazardous:
                    func = s => s.QuantityDisposalNONHW;
                    break;
                case WasteTypeFilter.Type.HazardousCountry:
                    func = s => s.QuantityDisposalHWIC;
                    break;
                case WasteTypeFilter.Type.HazardousTransboundary:
                    func = s => s.QuantityDisposalHWOC;
                    break;
                default:
                    throw new ArgumentOutOfRangeException("wasteType", "Illegal waste type");
            }
            return func.Compile();
        }

        /// <summary>
        /// Select the correct unspecified quantity dependend on the waste type
        /// </summary>
        public static Func<WASTETRANSFER, double?> QuantityUnspec( WasteTypeFilter.Type wasteType)
        {
            Expression<Func<WASTETRANSFER, double?>> func;

            switch (wasteType)
            {
                case WasteTypeFilter.Type.NonHazardous:
                    func = s => s.QuantityUnspecNONHW;
                    break;
                case WasteTypeFilter.Type.HazardousCountry:
                    func = s => s.QuantityUnspecHWIC;
                    break;
                case WasteTypeFilter.Type.HazardousTransboundary:
                    func = s => s.QuantityUnspecHWOC;
                    break;
                default:
                    throw new ArgumentOutOfRangeException("wasteType", "Illegal waste type");
            }
            return func.Compile();
        }



        /// <summary>
        /// Select the correct ConfidentialIndicatordependend on the waste type
        /// </summary>
        public static Func<WASTETRANSFER, bool> ConfidentialityIndicator(WasteTypeFilter.Type wasteType)
        {
            Expression<Func<WASTETRANSFER, bool>> func;

            switch (wasteType)
            {
                case WasteTypeFilter.Type.NonHazardous:
                    func = s => (bool)s.ConfidentialIndicatorNONHW;
                    break;
                case WasteTypeFilter.Type.HazardousCountry:
                    func = s => (bool)s.ConfidentialIndicatorHWIC;
                    break;
                case WasteTypeFilter.Type.HazardousTransboundary:
                    func = s => (bool)s.ConfidentialIndicatorHWOC;
                    break;
                default:
                    throw new ArgumentOutOfRangeException("wasteType", String.Format("Illegal waste type:{0}", wasteType.ToString()));
            }
            return func.Compile();
        }


        /// <summary>
        /// Select the correct ConfidentialIndicatordependend on the waste type
        /// </summary>
        public static Func<WASTETRANSFER, bool> ConfidentialityIndicatorQuantity( WasteTypeFilter.Type wasteType)
        {
            Expression<Func<WASTETRANSFER, bool>> func;

            switch (wasteType)
            {
                case WasteTypeFilter.Type.NonHazardous:
                    func = s => (bool)s.ConfidentialIndicatorNONHW && s.QuantityTotalNONHW.Equals(null);
                    break;
                case WasteTypeFilter.Type.HazardousCountry:
                    func = s => (bool)s.ConfidentialIndicatorHWIC && s.QuantityTotalHWIC.Equals(null);
                    break;
                case WasteTypeFilter.Type.HazardousTransboundary:
                    func = s => (bool)s.ConfidentialIndicatorHWOC && s.QuantityTotalHWOC.Equals(null);
                    break;
                default:
                    throw new ArgumentOutOfRangeException("wasteType", String.Format("Illegal waste type:{0}", wasteType.ToString()));
            }
            return func.Compile();
        }


        /// <summary>
        /// Group by depending on the region type
        /// </summary>
        public static IQueryable<IGrouping<TreeListRowGroupByKey, WASTETRANSFER>> GroupBy(this IQueryable<WASTETRANSFER> source, AreaFilter.RegionType regionType)
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
        public static IQueryable<IGrouping<TreeListRowGroupByKey, WASTETRANSFER>> GroupBy(this IQueryable<WASTETRANSFER> source, AreaFilter areaFilter)
        {
            if (areaFilter == null)
            {
                throw new ArgumentNullException();
            }

            if (areaFilter.SearchLevel() == AreaFilter.Level.AreaGroup)
            {
                //group by country
                return source.GroupBy( p => new TreeListRowGroupByKey{Code=p.CountryCode, ParentCode=null});
            }
            else
            {
                //group by region
                return source.GroupBy(areaFilter.TypeRegion);
            }

        }

        #endregion
    }
}
