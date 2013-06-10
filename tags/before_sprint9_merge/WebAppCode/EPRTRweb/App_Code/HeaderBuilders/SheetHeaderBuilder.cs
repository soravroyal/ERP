using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer.Filters;
using QueryLayer;

namespace EPRTR.HeaderBuilders
{
    /// <summary>
    /// Builds headers for sheets
    /// </summary>
    public class SheetHeaderBuilder : HeaderBuilder
    {

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for the facility given
        /// </summary>
        public static Dictionary<string, string> GetFacilityDetailHeader(Facility.FacilityBasic facilityBasic)
        {
            Dictionary<string, string> header = new Dictionary<string, string>();
            if (facilityBasic != null)
            {
                addFacilityName(header, facilityBasic);
                addFacilityAddress(header, facilityBasic);
                addFacilityCountry(header, facilityBasic);
                addFacilityYear(header, facilityBasic);
                addRegulation(header, facilityBasic.ReportingYear);
            }

            return header;
        }

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for facility details
        /// </summary>
        public static Dictionary<string, string> GetFacilityDetailPollutantTrendHeader(Facility.FacilityBasic facilityBasic, string pollutantCode)
        {
            Dictionary<string, string> header = new Dictionary<string, string>();
            addFacilityName(header, facilityBasic);
            addFacilityAddress(header, facilityBasic);
            addFacilityCountry(header, facilityBasic);
            //string codeEPER = pollutantCode + "EPER";
            addPollutant(header, pollutantCode);
            return header;
        }

        public static Dictionary<string, string> GetFacilityDetailPollutantTrendHeaderEPER(Facility.FacilityBasic facilityBasic, string pollutantCodeEPER, string pollutantCode)
        {
            Dictionary<string, string> header = new Dictionary<string, string>();
            addFacilityName(header, facilityBasic);
            addFacilityAddress(header, facilityBasic);
            addFacilityCountry(header, facilityBasic);
            addPollutantEPER(header, pollutantCodeEPER, pollutantCode);
            return header;
        }

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for facility details
        /// </summary>
        public static Dictionary<string, string> GetFacilityDetailWasteTrendHeader(Facility.FacilityBasic facilityBasic, WasteTypeFilter.Type wasteType)
        {
            Dictionary<string, string> header = new Dictionary<string, string>();
            addFacilityName(header, facilityBasic);
            addFacilityAddress(header, facilityBasic);
            addFacilityCountry(header, facilityBasic);
            addWasteType(header, wasteType);
            return header;
        }
                
        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for facility search
        /// </summary>
        public static Dictionary<string, string> GetFacilitySearchHeader(FacilitySearchFilter filter, bool includeFacilityCount)
        {
            Dictionary<string, string> header = new Dictionary<string, string>();

            addArea(header, filter.AreaFilter);
            addYear(header, filter.YearFilter);
            if (includeFacilityCount)
            {
                addCount(header, filter.Count);
            }

            return header;
        }

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for pollutant transfer search
        /// </summary>
        public static Dictionary<string, string> GetPollutantTransferSearchHeader(PollutantTransfersSearchFilter filter, bool includeFacilityCount)
        {
            Dictionary<string, string> header = new Dictionary<string, string>();

            addPollutant(header, filter.PollutantFilter);
            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);
            if (includeFacilityCount)
            {
                addCount(header, filter.Count);
            }

            return header;
        }

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for pollutant release search
        /// </summary>
        public static Dictionary<string, string> GetPollutantReleaseSearchHeader(PollutantReleaseSearchFilter filter, bool includeFacilityCount)
        {
            Dictionary<string, string> header = new Dictionary<string, string>();

            addPollutant(header, filter.PollutantFilter);
            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);
            if (includeFacilityCount)
            {
                addCount(header, filter.Count);
            }

            return header;
        }


        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for waste transfer search
        /// </summary>
        public static Dictionary<string, string> GetWasteTransferSearchHeader(WasteTransferSearchFilter filter, bool includeFacilityCount)
        {
            Dictionary<string, string> header = new Dictionary<string, string>();

            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);
            if (includeFacilityCount)
            {
                addCount(header, filter.Count);
            }

            return header;
        }


        /// <summary>
        /// returns a dictionary with sheet headers for time series pollutant release search
        /// </summary>
        public static Dictionary<string, string> GetTimeSeriesPollutantReleaseHeader(PollutantReleasesTimeSeriesFilter filter)
        {
            Dictionary<string, string> header = new Dictionary<string, string>();
            addArea(header, filter.AreaFilter);
            addActivity(header, filter.ActivityFilter);
            addPollutant(header, filter.PollutantFilter);
            addMedium(header, filter.MediumFilter);
            return header;
        }

        /// <summary>
        /// returns a dictionary with sheet headers for time series pollutant transfer search
        /// </summary>
        public static Dictionary<string, string> GetTimeSeriesPollutantTransferHeader(PollutantTransferTimeSeriesFilter filter)
        {
            Dictionary<string, string> header = new Dictionary<string, string>();
            addArea(header, filter.AreaFilter);
            addActivity(header, filter.ActivityFilter);
            addPollutant(header, filter.PollutantFilter);
            return header;
        }

        /// <summary>
        /// returns a dictionary with sheet headers for timeseries waste transfer search
        /// </summary>
        public static Dictionary<string, string> GetTimeSeriesWasteTransferHeader(WasteTransferTimeSeriesFilter filter)
        {
            Dictionary<string, string> header = new Dictionary<string, string>();
            addArea(header, filter.AreaFilter);
            addActivity(header, filter.ActivityFilter);
            addWasteType(header, filter.WasteTypeFilter);
                       
            return header;
        }
        

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for Industrial activity search. Will not include the number of facilities.
        /// </summary>
        public static Dictionary<string, string> GetIndustrialActivitySearchHeader(IndustrialActivitySearchFilter filter)
        {
            Dictionary<string, string> header = new Dictionary<string, string>();

            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);
            addActivity(header, filter.ActivityFilter);

            return header;
        }

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for Industrial activity search. Will include the number of facilites
        /// </summary>
        /// <param name="countTotal">The total number of facilities fullfilling the search critieria</param>
        /// <param name="countSheet">The number of facilites fullfilling the search criteria for the selected sheet (e.g. Pollutant releases)</param>
        public static Dictionary<string, string> GetIndustrialActivitySearchHeader(IndustrialActivitySearchFilter filter, int countTotal, int countSheet)
        {
            Dictionary<string, string> header = GetIndustrialActivitySearchHeader(filter);

            addCount(header, countTotal, countSheet);

            return header;
        }

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for Industrial activity search. Will not include the number of facilities.
        /// </summary>
        public static Dictionary<string, string> GetAreaOverviewSearchHeader(AreaOverviewSearchFilter filter)
        {
            Dictionary<string, string> header = new Dictionary<string, string>();

            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);

            return header;
        }

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for Industrial activity search. Will include the number of facilites
        /// </summary>
        /// <param name="countTotal">The total number of facilities fullfilling the search critieria</param>
        /// <param name="countSheet">The number of facilites fullfilling the search criteria for the selected sheet (e.g. Pollutant releases)</param>
        public static Dictionary<string, string> GetAreaOverviewSearchHeader(AreaOverviewSearchFilter filter, int countTotal, int countSheet)
        {
            Dictionary<string, string> header = GetAreaOverviewSearchHeader(filter);

            addCount(header, countTotal, countSheet);

            return header;
        }

        /// <summary>
        /// returns a dictionary with SUBsheet headers <key, value> for hazardous waste reciever details
        /// </summary>
        public static Dictionary<string, string> GetWasteTransferHazRecieverHeader(WasteTransferSearchFilter filter, bool includeFacilityCount, string countryCode)
        {
            Dictionary<string, string> header = new Dictionary<string, string>();

            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);
            
            if (includeFacilityCount)
            {
                addCount(header, filter.Count);
            }
            // A header detail should be added here
            addWasteReceiver(header, countryCode);

            return header;
        }
    }
}