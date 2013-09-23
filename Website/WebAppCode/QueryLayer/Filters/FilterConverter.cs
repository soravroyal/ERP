using System;

namespace QueryLayer.Filters
{
    /// <summary>
    /// Holds converters to create a filter from another
    /// </summary>
    public static class FilterConverter
    {

        public static FacilitySearchFilter ConvertToFacilitySearchFilter(PollutantReleaseSearchFilter filter)
        {
            FacilitySearchFilter converted = new FacilitySearchFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.YearFilter = clone(filter.YearFilter) as YearFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            converted.PollutantFilter = clone(filter.PollutantFilter) as PollutantFilter;
            converted.MediumFilter = clone(filter.MediumFilter) as MediumFilter;
            return converted;
        }

        public static FacilitySearchFilter ConvertToFacilitySearchFilter(PollutantTransfersSearchFilter filter)
        {
            FacilitySearchFilter converted = new FacilitySearchFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.YearFilter = clone(filter.YearFilter) as YearFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            converted.PollutantFilter = clone(filter.PollutantFilter) as PollutantFilter;

            // create medium filter with transfers
            MediumFilter mediumFilter = new MediumFilter();
            mediumFilter.TransferToWasteWater = true;
            converted.MediumFilter = mediumFilter;

            return converted;
        }

        public static FacilitySearchFilter ConvertToFacilitySearchFilter(WasteTransferSearchFilter filter)
        {
            FacilitySearchFilter converted = new FacilitySearchFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.YearFilter = clone(filter.YearFilter) as YearFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            converted.WasteTypeFilter = clone(filter.WasteTypeFilter) as WasteTypeFilter;
            converted.WasteTreatmentFilter = clone(filter.WasteTreatmentFilter) as WasteTreatmentFilter;
            converted.WasteReceiverFilter = null;

            return converted;
        }

        public static FacilitySearchFilter ConvertToFacilitySearchFilter(IndustrialActivitySearchFilter filter)
        {
            FacilitySearchFilter converted = new FacilitySearchFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.YearFilter = clone(filter.YearFilter) as YearFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            return converted;
        }


        public static IndustrialActivitySearchFilter ConvertToIndustrialActivitySearchFilter(PollutantReleaseSearchFilter filter)
        {
            IndustrialActivitySearchFilter converted = new IndustrialActivitySearchFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.YearFilter = clone(filter.YearFilter) as YearFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            return converted;
        }

        public static IndustrialActivitySearchFilter ConvertToIndustrialActivitySearchFilter(PollutantTransfersSearchFilter filter)
        {
            IndustrialActivitySearchFilter converted = new IndustrialActivitySearchFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.YearFilter = clone(filter.YearFilter) as YearFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            return converted;
        }

        public static IndustrialActivitySearchFilter ConvertToIndustrialActivitySearchFilter(WasteTransferSearchFilter filter)
        {
            IndustrialActivitySearchFilter converted = new IndustrialActivitySearchFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.YearFilter = clone(filter.YearFilter) as YearFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            return converted;
        }

        #region Convert to Pollutant Release
        public static PollutantReleaseSearchFilter ConvertToPollutantReleaseSearchFilter(IndustrialActivitySearchFilter filter)
        {
            PollutantReleaseSearchFilter converted = new PollutantReleaseSearchFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.YearFilter = clone(filter.YearFilter) as YearFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            return converted;
        }

        public static PollutantReleaseSearchFilter ConvertToPollutantReleaseSearchFilter(DiffuseSourcesFilter filter)
        {
            PollutantReleaseSearchFilter converted = new PollutantReleaseSearchFilter();

            converted.YearFilter = clone(filter.YearFilter) as YearFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            converted.PollutantFilter = clone(filter.PollutantFilter) as PollutantFilter;
            converted.MediumFilter = clone(filter.MediumFilter) as MediumFilter;

            return converted;
        }

        public static PollutantReleaseSearchFilter ConvertToPollutantReleaseSearchFilter(AreaOverviewSearchFilter filter)
        {
            PollutantReleaseSearchFilter converted = new PollutantReleaseSearchFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.YearFilter = clone(filter.YearFilter) as YearFilter;
            return converted;
        }

        /// <summary>
        /// Pollutant Release filter has no match for Year, so this attribute is set to null
        /// </summary>
        /// <param name="filter">Source filter</param>
        /// <returns>Targer filter</returns>
        public static PollutantReleaseSearchFilter ConvertToPollutantReleaseSearchFilter(PollutantReleasesTimeSeriesFilter filter)
        {
            var converted = new PollutantReleaseSearchFilter();

            converted.AreaFilter = filter.AreaFilter;
            converted.ActivityFilter = filter.ActivityFilter;
            converted.MediumFilter = filter.MediumFilter;
            converted.PollutantFilter = filter.PollutantFilter;

            // search for any year
            converted.YearFilter = null;

            return converted;
        }

        #endregion // Pollutant Release
        
        #region Convert to Pollutant Transfer
        public static PollutantTransfersSearchFilter ConvertToPollutantTransfersSearchFilter(IndustrialActivitySearchFilter filter)
        {
            PollutantTransfersSearchFilter converted = new PollutantTransfersSearchFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.YearFilter = clone(filter.YearFilter) as YearFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            return converted;
        }

        public static PollutantTransfersSearchFilter ConvertToPollutantTransfersSearchFilter(AreaOverviewSearchFilter filter)
        {
            PollutantTransfersSearchFilter converted = new PollutantTransfersSearchFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.YearFilter = clone(filter.YearFilter) as YearFilter;
            return converted;
        }
        #endregion Pollutant Transfer

        #region Convert to Waste Transfer
        public static WasteTransferSearchFilter ConvertToWasteTransferSearchFilter(IndustrialActivitySearchFilter filter)
        {
            WasteTransferSearchFilter converted = new WasteTransferSearchFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.YearFilter = clone(filter.YearFilter) as YearFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            return converted;
        }


        public static WasteTransferSearchFilter ConvertToWasteTransferSearchFilter(AreaOverviewSearchFilter filter)
        {
            WasteTransferSearchFilter converted = new WasteTransferSearchFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.YearFilter = clone(filter.YearFilter) as YearFilter;
            return converted;
        }

        public static WasteTransferSearchFilter ConvertToWasteTransferSearchFilter(WasteTransferTimeSeriesFilter filter)
        {
            WasteTransferSearchFilter converted = new WasteTransferSearchFilter();

            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.WasteTypeFilter = clone(filter.WasteTypeFilter) as WasteTypeFilter;
            converted.YearFilter = null;

            return converted;
        }

        #endregion  Waste Transfer

        public static PollutantTransferTimeSeriesFilter ConvertToPollutantTransferTimeSeriesFilter(PollutantTransfersSearchFilter filter)
        {
            PollutantTransferTimeSeriesFilter converted = new PollutantTransferTimeSeriesFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            converted.PollutantFilter = clone(filter.PollutantFilter) as PollutantFilter;
            return converted;
        }

        public static PollutantTransferTimeSeriesFilter ConvertToPollutantTransferTimeSeriesFilter(IndustrialActivitySearchFilter filter)
        {
            PollutantTransferTimeSeriesFilter converted = new PollutantTransferTimeSeriesFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            return converted;
        }


        public static PollutantReleasesTimeSeriesFilter ConvertToPollutantReleasesTimeSeriesFilter(PollutantReleaseSearchFilter filter)
        {
            PollutantReleasesTimeSeriesFilter converted = new PollutantReleasesTimeSeriesFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            converted.PollutantFilter = clone(filter.PollutantFilter) as PollutantFilter;
            converted.MediumFilter = clone(filter.MediumFilter) as MediumFilter;
            return converted;
        }

        public static PollutantReleasesTimeSeriesFilter ConvertToPollutantReleasesTimeSeriesFilter(IndustrialActivitySearchFilter filter)
        {
            PollutantReleasesTimeSeriesFilter converted = new PollutantReleasesTimeSeriesFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            return converted;
        }

        public static WasteTransferTimeSeriesFilter ConvertToWasteTransferTimeSeriesFilter(WasteTransferSearchFilter filter)
        {
            WasteTransferTimeSeriesFilter converted = new WasteTransferTimeSeriesFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            converted.WasteTypeFilter = clone(filter.WasteTypeFilter) as WasteTypeFilter;
            converted.WasteTreatmentFilter = clone(filter.WasteTreatmentFilter) as WasteTreatmentFilter;

            return converted;
        }


        public static WasteTransferTimeSeriesFilter ConvertToWasteTransferTimeSeriesFilter(IndustrialActivitySearchFilter filter)
        {
            WasteTransferTimeSeriesFilter converted = new WasteTransferTimeSeriesFilter();
            converted.AreaFilter = clone(filter.AreaFilter) as AreaFilter;
            converted.ActivityFilter = clone(filter.ActivityFilter) as ActivityFilter;
            return converted;
        }
        
        private static object clone(ICloneable filter)
        {
            return filter != null ? filter.Clone() : null;
        }

    }
}