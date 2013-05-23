using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EPRTR.Enums
{

    public static class Sheets
    {
        public enum FacilitySearch
        {
            Facilities = 0,
            Confidentiality
        }

        public enum FacilityDetails
        {
            Details = 0,
            PollutantReleases,
            PollutantTransfers,
            Waste,
            Confidentiality,
            Emissions,
            EmissionsTransfer
        }

        public enum IndustrialActivity
        {
            PollutantReleases = 0,
            PollutantTransfers,
            WasteTransfers,
            Confidentiality
        }

        public enum PollutantReleases
        {
            Summary = 0,
            Activities,
            Areas,
            AreaComparison,
            Facilities,
            Confidentiality
        }

        public enum PollutantTransfers
        {
            Summary = 0,
            Activities,
            Areas,
            AreaComparison,
            Facilities,
            Confidentiality
        }

        public enum WasteTransfers
        {
            Summary = 0,
            Activities,
            Areas,
            AreaComparison,
            Facilities,
            HazTransboundary,
            HazReceivers,
            Confidentiality
        }

        public enum WasteReceiverDetails
        {
            Treaters = 0,
            Confidentiality
        }

        public enum DiffuseSources
        {
            GeneralInfo = 0,
            Methodology,
            SourceData
        }
        
        public enum TimeSeries
        {
            TimeSeries = 0,
            Comparison,
            Confidentiality
        }

        public enum AreaOverview
        {
            PollutantReleases = 0,
            PollutantTransfers,
            WasteTransfers,
            Confidentiality
        }

    }
}