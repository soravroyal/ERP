using System.Collections.Generic;
using QueryLayer;
using QueryLayer.Filters;
using EPRTR.Localization;
using EPRTR.Formatters;
using System;
using System.Configuration;

namespace EPRTR.HeaderBuilders
{
    /// <summary>
    /// Builds headers for CSV downloads
    /// </summary>
    public class CsvHeaderBuilder : HeaderBuilder
    {

        /// <summary>
        /// returns a dictionary with csv headers <key, value> for facility details
        /// </summary>
        public static Dictionary<string, string> GetFacilityTrendHeader(
            int facilityReportId,
            bool confidentialityAffected)
        {
            Facility.FacilityBasic basic = Facility.GetFacilityBasic(facilityReportId);

            Dictionary<string, string> header = makeHeader();
            addFacilityIdentification(header, basic);
            addFacilityName(header, basic);
            addFacilityAddress(header, basic);
            addFacilityCountry(header, basic);
            addConfidentiality(header, confidentialityAffected);

            return header;
        }


        /// <summary>
        /// returns a dictionary with csv headers <key, value> for facility search
        /// </summary>
        public static Dictionary<string, string> GetFacilitySearchHeader(
            FacilitySearchFilter filter,
            bool confidentialityAffected)
        {
            Dictionary<string, string> header = makeHeader();

            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);
            addFacilityLocation(header, filter.FacilityLocationFilter);
            addActivity(header, filter.ActivityFilter);
            addPollutant(header, filter.PollutantFilter);
            addMedium(header, filter.MediumFilter);
            addAccidental(header, filter.AccidentalFilter);
            addWasteType(header, filter.WasteTypeFilter);
            addWasteTreatment(header, filter.WasteTreatmentFilter);

            addWasteReceiver(header, filter.WasteReceiverFilter);
            addConfidentiality(header, confidentialityAffected);

            return header;
        }

        /// <summary>
        /// returns a dictionary with csv headers <key, value> for pollutant transfer search
        /// </summary>
        public static Dictionary<string, string> GetPollutantTransferSearchHeader(PollutantTransfersSearchFilter filter)
        {
            Dictionary<string, string> header = makeHeader();

            addPollutant(header, filter.PollutantFilter);
            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);

            return header;
        }

        public static Dictionary<string, string> GetPollutantTransferSearchHeader(
            PollutantTransfersSearchFilter filter,
            bool confidentialityAffected)
        {
            var header = GetPollutantTransferSearchHeader(filter);
            addConfidentiality(header, confidentialityAffected);
            return header;

        }

        /// <summary>
        /// returns a dictionary with csv headers <key, value> for pollutant release search
        /// </summary>
        public static Dictionary<string, string> GetPollutantReleaseSearchHeader(
            PollutantReleaseSearchFilter filter,
            bool confidentialityAffected)
        {
            Dictionary<string, string> header = makeHeader();

            addPollutant(header, filter.PollutantFilter);
            addMedium(header, filter.MediumFilter);
            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);

            addConfidentiality(header, confidentialityAffected);

            return header;
        }

        /// <summary>
        /// returns a dictionary with csv headers <key, value> for pollutant release search
        /// </summary>
        public static Dictionary<string, string> GetPollutantReleaseSearchHeader(
            PollutantReleaseSearchFilter filter,
            MediumFilter.Medium medium,
            bool confidentialityAffected)
        {
            Dictionary<string, string> header = makeHeader();

            addPollutant(header, filter.PollutantFilter);
            addMedium(header, medium);
            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);

            addConfidentiality(header, confidentialityAffected);

            return header;
        }

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for waste transfer search
        /// </summary>
        public static Dictionary<string, string> GetWasteTransfersSearchHeader(
            WasteTransferSearchFilter filter,
            bool confidentialityAffected)
        {
            Dictionary<string, string> header = makeHeader();

            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);
            addWasteType(header, filter.WasteTypeFilter);
            addConfidentiality(header, confidentialityAffected);

            return header;
        }

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for Industrial activity search
        /// </summary>
        public static Dictionary<string, string> GetIndustrialActivitySearchHeader(IndustrialActivitySearchFilter filter)
        {
            Dictionary<string, string> header = makeHeader();

            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);
            addActivity(header, filter.ActivityFilter);

            return header;
        }


        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for Industrial activity search
        /// </summary>
        public static Dictionary<string, string> GetIndustrialActivitySearchHeader(
            IndustrialActivitySearchFilter filter,
            bool confidentialityAffected)
        {
            var header = GetIndustrialActivitySearchHeader(filter);
            addConfidentiality(header, confidentialityAffected);
            return header;
        }

#region AreaOverview

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for Area overview search
        /// </summary>
        public static Dictionary<string, string> GetAreaoverviewPollutantTransferSearchHeader(
            AreaOverviewSearchFilter filter, int pollutantGroupID,
            bool confidentialityAffected)
        {
            Dictionary<string, string> header = makeHeader();
            addLegalRegulation(header,filter.YearFilter.Year);
            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);
            addPollutantGroup(header, pollutantGroupID);

            addConfidentiality(header, confidentialityAffected);
            return header;
        }


        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for Area overview search
        /// </summary>
        public static Dictionary<string, string> GetAreaoverviewPollutantReleaseSearchHeader(
            AreaOverviewSearchFilter filter, int pollutantGroupID, MediumFilter.Medium medium,
            bool confidentialityAffected)
        {
            Dictionary<string, string> header = makeHeader();
            addLegalRegulation(header, filter.YearFilter.Year);
            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);
            addPollutantGroup(header, pollutantGroupID);
            addMedium(header, medium);

            addConfidentiality(header, confidentialityAffected);
            return header;
        }


        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for Area overview search
        /// </summary>
        public static Dictionary<string, string> GetAreaoverviewWasteTransferSearchHeader(
            AreaOverviewSearchFilter filter, bool confidentialityAffected)
        {
            Dictionary<string, string> header = makeHeader();
            addLegalRegulation(header, filter.YearFilter.Year);
            addYear(header, filter.YearFilter);
            addArea(header, filter.AreaFilter);

            addConfidentiality(header, confidentialityAffected);
            return header;
        }

#endregion

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for pollutant releases time series search
        /// </summary>
        public static Dictionary<string, string> GetTsPollutantReleasesSearchHeader(
            PollutantReleasesTimeSeriesFilter filter,
            MediumFilter.Medium currentMedium,
            bool confidentialityAffected)
        {
            Dictionary<string, string> header = makeHeader();

            addArea(header, filter.AreaFilter);
            addActivity(header, filter.ActivityFilter);
            addPollutant(header, filter.PollutantFilter);
            addMedium(header, currentMedium);
            addConfidentiality(header, confidentialityAffected);

            return header;
        }

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for pollutant transfers time series search
        /// </summary>
        public static Dictionary<string, string> GetTsPollutantTransfersSearchHeader(
            PollutantTransferTimeSeriesFilter filter,
            bool confidentialityAffected)
        {
            Dictionary<string, string> header = makeHeader();

            addArea(header, filter.AreaFilter);
            addActivity(header, filter.ActivityFilter);
            addPollutant(header, filter.PollutantFilter);
            addConfidentiality(header, confidentialityAffected);

            return header;
        }

        /// <summary>
        /// returns a dictionary with sheet headers <key, value> for waste transfers time series search
        /// </summary>
        public static Dictionary<string, string> GetTsWasteTransfersSearchHeader(
            WasteTransferTimeSeriesFilter filter,
            WasteTypeFilter.Type currentWasteType,
            bool confidentialityAffected)
        {
            Dictionary<string, string> header = makeHeader();

            addArea(header, filter.AreaFilter);
            addActivity(header, filter.ActivityFilter);
            addWasteType(header, currentWasteType);
            addConfidentiality(header, confidentialityAffected);

            return header;
        }



        protected static void addDatabaseDate(Dictionary<string, string> header)
        {
            string appIsReview = ConfigurationManager.AppSettings["IsReview"];
            if (!String.IsNullOrEmpty(appIsReview) && appIsReview.ToLower().Equals("true"))
            {
                header.Add(Resources.GetGlobal("Common", "DatabaseDateReview"), ListOfValues.GetLatestReviewDate().Format());
            }
            else
            {
                header.Add(Resources.GetGlobal("Common", "DatabaseDate"), ListOfValues.GetLatestPublicationDate().Format());
            }
        }

        protected static Dictionary<string, string> makeHeader()
        {
            Dictionary<string, string> header = new Dictionary<string, string>();

            addDatabaseDate(header);

            return header;

        }

    }
}