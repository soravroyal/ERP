using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using LinqUtilities;
using QueryLayer.Enums;
using QueryLayer.Filters;
using QueryLayer.LinqFramework;
using QueryLayer.Utilities;

namespace QueryLayer
{
    /// <summary>
    /// Holds methods to collect data for the Area overview search
    /// </summary>
    public static class AreaOverview
    {

        static string CODE_KG = EnumUtil.GetStringValue(QuantityUnit.Kilo);
        static string CODE_TNE = EnumUtil.GetStringValue(QuantityUnit.Tonnes);

        public static string CODE_NONHW = WasteTransfers.CODE_NONHW;
        public static string CODE_HWIC = WasteTransfers.CODE_HWIC;
        public static string CODE_HWOC = WasteTransfers.CODE_HWOC;
        public static string CODE_HW = WasteTransfers.CODE_HW;

        #region Pollutants genereral

        /// <summary>
        /// Holds data for rows in area search activity tree for pollutants (releases / transfers)
        /// </summary>
        [Serializable]
        public class AOPollutantTreeListRow : ActivityTreeListRow
        {

            public AOPollutantTreeListRow(PollutantReleases.ActivityTreeListRow treeListRow, List<string> pollutantCodes)
                : base(treeListRow.SectorCode, treeListRow.ActivityCode, treeListRow.SubactivityCode, treeListRow.HasChildren)
            {
                initializePollutantList(pollutantCodes);
            }

            public AOPollutantTreeListRow(PollutantTransfers.ActivityTreeListRow treeListRow, List<string> pollutantCodes)
                : base(treeListRow.SectorCode, treeListRow.ActivityCode, treeListRow.SubactivityCode, treeListRow.HasChildren)
            {
                initializePollutantList(pollutantCodes);
            }


            public List<PollutantData> PollutantList { get; private set; }


            //fill pollutant list with default data
            private void initializePollutantList(List<string> pollutantCodes)
            {

                this.PollutantList = new List<PollutantData>();

                if (pollutantCodes != null)
                {
                    foreach (string code in pollutantCodes)
                    {
                        this.PollutantList.Add(new PollutantData(code));
                    }
                }
            }

            public void AddPollutantData(PollutantData pollutantData)
            {
                PollutantData data = PollutantList.SingleOrDefault(d => d.PollutantCode == pollutantData.PollutantCode);

                if (data != null)
                {
                    data.SetData(pollutantData.Facilities, pollutantData.Quantity);
                }

            }

        }

        /// <summary>
        /// Holds pollutant data for one "cell" in area search
        /// </summary>
        [Serializable]
        public class PollutantData
        {
            public PollutantData(string pollutantCode)
            {
                this.PollutantCode = pollutantCode;
            }

            public PollutantData(string pollutantCode, int? facilities, double? quantity)
                : this(pollutantCode)
            {
                SetData(facilities, quantity);
            }

            public void SetData(int? facilities, double? quantity)
            {
                this.Facilities = facilities;
                this.Quantity = quantity;
                this.Unit = CODE_KG;
                //this.Unit = CODE_TNE;
            }

            public string PollutantCode { get; private set; }
            public int? Facilities { get; private set; }
            public double? Quantity { get; private set; }
            public String Unit { get; private set; }

        }


        #endregion

        // ----------------------------------------------------------------------------------
        // Pollutant Releases
        // ----------------------------------------------------------------------------------
        #region PollutantReleases
 
        /// <summary>
        /// Find all pollutant codes for pollutant releases fullfilling the filter within the medium and pollutant group given
        /// </summary>
        public static List<string> GetPollutantReleasePollutantCodes(AreaOverviewSearchFilter filter, MediumFilter.Medium medium, int pollutantGroupID)
        {
            PollutantReleaseSearchFilter prFilter = convertToPollutantReleaseSearchFilter(filter, medium, pollutantGroupID);

            //distinct pollutants
            return PollutantReleases.GetPollutantCodes(prFilter);
        }



        /// <summary>
        /// return full list of pollutant releases with all rows expanded for the pollutant group given, level 0. 
        /// For each row added, the pollutant list will be initialized with the pollutantCodes given
        /// </summary>
        public static IEnumerable<AOPollutantTreeListRow> GetPollutantReleaseActivityTree(AreaOverviewSearchFilter filter, MediumFilter.Medium medium, int pollutantGroupID, List<string> pollutantCodes)
        {
            IEnumerable<AOPollutantTreeListRow> sectors = GetPollutantReleaseSectors(filter, medium, pollutantGroupID, pollutantCodes);

            List<string> sectorCodes = sectors.Where(p => p.HasChildren).Select(p => p.SectorCode).ToList();
            IEnumerable<AOPollutantTreeListRow> activities = GetPollutantReleaseActivities(filter, medium, pollutantGroupID, sectorCodes, pollutantCodes).ToList();

            List<string> activityCodes = activities.Where(p => p.HasChildren).Select(p => p.ActivityCode).ToList();
            IEnumerable<AOPollutantTreeListRow> subactivities = GetPollutantReleaseSubActivities(filter, medium, pollutantGroupID, activityCodes, pollutantCodes).ToList();

            //create result with full tree
            IEnumerable<AOPollutantTreeListRow> result = sectors.Union(activities).Union(subactivities)
                                                               .OrderBy(s => s.SectorCode)
                                                               .ThenBy(s => s.ActivityCode)
                                                               .ThenBy(s => s.SubactivityCode);

            return result;
        }



        /// <summary>
        /// return total list of pollutant releases for the medium and pollutant group given, level 0. 
        /// For each row added, the pollutant list will be initialized with the pollutantCodes given
        /// </summary>
        public static List<AOPollutantTreeListRow> GetPollutantReleaseSectors(AreaOverviewSearchFilter filter, MediumFilter.Medium medium, int pollutantGroupID, List<string> pollutantCodes)
        {
            PollutantReleaseSearchFilter prFilter = convertToPollutantReleaseSearchFilter(filter, medium, pollutantGroupID);

            var releases = PollutantReleases.GetSectors(prFilter).ToList();
            List<AOPollutantTreeListRow> aoRows = convertData(releases, medium, pollutantCodes);

            return aoRows;
        }

        /// <summary>
        /// Return all activities (level 1) for pollutant releases that fullfill search criteria within the sectorCodes, medium and pollutant group given. 
        /// If sectorCodes are null, all activities will be returned. If sectorCodes is empty no activities will be returned.
        /// For each row added, the pollutant list will be initialized with the pollutantCodes given
        /// </summary>
        public static IEnumerable<AOPollutantTreeListRow> GetPollutantReleaseActivities(AreaOverviewSearchFilter filter,MediumFilter.Medium medium, int pollutantGroupID, List<string> sectorCodes, List<string> pollutantCodes)
        {
            if (sectorCodes != null && sectorCodes.Count() == 0)
                return new List<AOPollutantTreeListRow>();

            PollutantReleaseSearchFilter prFilter = convertToPollutantReleaseSearchFilter(filter, medium, pollutantGroupID);
            var releases = PollutantReleases.GetActivities(prFilter, sectorCodes).ToList();

            return convertData(releases, medium, pollutantCodes);
        }


        /// <summary>
        /// Return all subactivities (level 2) for pollutant releases that fullfill search criteria within the medium, pollutant group and activityCodes given. 
        /// If activityCodes are null, all subactivities will be returned. If activityCodes is empty no subactivities will be returned.
        /// Notice that this will include one subactivity "Not specified on this level" for each activity, even if the activity do not have any subactivities at all!
        /// For each row added, the pollutant list will be initialized with the pollutantCodes given
        /// </summary>
        public static List<AOPollutantTreeListRow> GetPollutantReleaseSubActivities(AreaOverviewSearchFilter filter, MediumFilter.Medium medium, int pollutantGroupID, List<string> activityCodes, List<string> pollutantCodes)
        {
            if (activityCodes != null && activityCodes.Count() == 0)
                return new List<AOPollutantTreeListRow>();

            PollutantReleaseSearchFilter prFilter = convertToPollutantReleaseSearchFilter(filter, medium, pollutantGroupID);

            var releases = PollutantReleases.GetSubActivities(prFilter, activityCodes).ToList();
            return convertData(releases, medium, pollutantCodes);
        }


        /// <summary>
        /// Return the number of facilites having pollutant releases
        /// </summary>
        public static int GetFacilityCountPollutantRelease(AreaOverviewSearchFilter filter)
        {
            PollutantReleaseSearchFilter prFilter = FilterConverter.ConvertToPollutantReleaseSearchFilter(filter);
            return PollutantReleases.GetFacilityCount(prFilter);
        }

        private static List<AOPollutantTreeListRow> convertData(List<PollutantReleases.ActivityTreeListRow> releases, MediumFilter.Medium medium, List<string> pollutantCodes)
        {
            List<AOPollutantTreeListRow> aoRows = new List<AOPollutantTreeListRow>();

            for (int i = 0; i < releases.Count(); i++)
            {
                PollutantReleases.ActivityTreeListRow row = releases[i];

                double? quantity = null;
                switch (medium)
                {
                    case MediumFilter.Medium.Air:
                        quantity = row.QuantityAir;
                        break;
                    case MediumFilter.Medium.Soil:
                        quantity = row.QuantitySoil;
                        break;
                    case MediumFilter.Medium.Water:
                        quantity = row.QuantityWater;
                        break;
                    default:
                        break;
                }

                PollutantData rowData = new PollutantData(row.PollutantCode, row.Facilities, quantity);

                AOPollutantTreeListRow aoRow = aoRows.Where(r => r.SectorCode == row.SectorCode && r.ActivityCode == row.ActivityCode && r.SubactivityCode == row.SubactivityCode)
                                                    .SingleOrDefault();

                if (aoRow == null)
                {
                    //add new row
                    aoRow = new AOPollutantTreeListRow(row, pollutantCodes);
                    aoRows.Add(aoRow);
                }

                aoRow.AddPollutantData(rowData);
            }
            return aoRows;
        }

        private static PollutantReleaseSearchFilter convertToPollutantReleaseSearchFilter(AreaOverviewSearchFilter filter, MediumFilter.Medium? medium, int pollutantGroupID)
        {
            PollutantReleaseSearchFilter prFilter = FilterConverter.ConvertToPollutantReleaseSearchFilter(filter);

            PollutantFilter pollutantFilter = new PollutantFilter();
            pollutantFilter.PollutantGroupID = pollutantGroupID;
            pollutantFilter.PollutantID = PollutantFilter.AllPollutantsInGroupID;

            prFilter.PollutantFilter = pollutantFilter;

            if (medium != null)
            {
                prFilter.MediumFilter = new MediumFilter(medium.Value);
            }

            return prFilter;
        }

        #endregion


        // ----------------------------------------------------------------------------------
        // Pollutant Transfers
        // ----------------------------------------------------------------------------------
        #region PollutantTransfers
        /// <summary>
        /// Find all pollutant codes for pollutant transfer fullfilling the filter within the pollutant group given
        /// </summary>
        public static List<string> GetPollutantTransferPollutantCodes(AreaOverviewSearchFilter filter, int pollutantGroupID)
        {
            PollutantTransfersSearchFilter ptFilter = convertToPollutantTransferSearchFilter(filter, pollutantGroupID);

            //distinct pollutants
            return PollutantTransfers.GetPollutantCodes(ptFilter);
        }

        /// <summary>
        /// return full list of pollutant transfers with all rows expanded for the pollutant group given, level 0. 
        /// For each row added, the pollutant list will be initialized with the pollutantCodes given
        /// </summary>
        public static IEnumerable<AOPollutantTreeListRow> GetPollutantTransferActivityTree(AreaOverviewSearchFilter filter, int pollutantGroupID, List<string> pollutantCodes)
        {
            IEnumerable<AOPollutantTreeListRow> sectors = GetPollutantTransferSectors(filter, pollutantGroupID, pollutantCodes);

            List<string> sectorCodes = sectors.Where(p => p.HasChildren).Select(p => p.SectorCode).ToList();
            IEnumerable<AOPollutantTreeListRow> activities = GetPollutantTransferActivities(filter, pollutantGroupID, sectorCodes, pollutantCodes).ToList();

            List<string> activityCodes = activities.Where(p => p.HasChildren).Select(p => p.ActivityCode).ToList();
            IEnumerable<AOPollutantTreeListRow> subactivities = GetPollutantTransferSubActivities(filter, pollutantGroupID, activityCodes, pollutantCodes).ToList();

            //create result with full tree
            IEnumerable<AOPollutantTreeListRow> result = sectors.Union(activities).Union(subactivities)
                                                               .OrderBy(s => s.SectorCode)
                                                               .ThenBy(s => s.ActivityCode)
                                                               .ThenBy(s => s.SubactivityCode);

            return result;
        }


        /// <summary>
        /// return total list of pollutant transfers for the pollutant group given, level 0. 
        /// For each row added, the pollutant list will be initialized with the pollutantCodes given
        /// </summary>
        public static List<AOPollutantTreeListRow> GetPollutantTransferSectors(AreaOverviewSearchFilter filter, int pollutantGroupID, List<string> pollutantCodes)
        {
            PollutantTransfersSearchFilter prFilter = convertToPollutantTransferSearchFilter(filter, pollutantGroupID);

            var releases = PollutantTransfers.GetSectors(prFilter).ToList();
            List<AOPollutantTreeListRow> aoRows = convertData(releases, pollutantCodes);

            return aoRows;
        }

        /// <summary>
        /// Return all activities (level 1) for pollutant transfers that fullfill search criteria within the sectorCodes and pollutant group given. 
        /// If sectorCodes are null, all activities will be returned. If sectorCodes is empty no activities will be returned.
        /// For each row added, the pollutant list will be initialized with the pollutantCodes given
        /// </summary>
        public static IEnumerable<AOPollutantTreeListRow> GetPollutantTransferActivities(AreaOverviewSearchFilter filter, int pollutantGroupID, List<string> sectorCodes, List<string> pollutantCodes)
        {
            if (sectorCodes != null && sectorCodes.Count() == 0)
                return new List<AOPollutantTreeListRow>();

            PollutantTransfersSearchFilter prFilter = convertToPollutantTransferSearchFilter(filter, pollutantGroupID);
            var releases = PollutantTransfers.GetActivities(prFilter, sectorCodes).ToList();

            return convertData(releases,pollutantCodes);
        }


        /// <summary>
        /// Return all subactivities (level 2) for pollutant transfers that fullfill search criteria within the pollutant group and activityCodes given. 
        /// If activityCodes are null, all subactivities will be returned. If activityCodes is empty no subactivities will be returned.
        /// Notice that this will include one subactivity "Not specified on this level" for each activity, even if the activity do not have any subactivities at all!
        /// For each row added, the pollutant list will be initialized with the pollutantCodes given
        /// </summary>
        public static List<AOPollutantTreeListRow> GetPollutantTransferSubActivities(AreaOverviewSearchFilter filter, int pollutantGroupID, List<string> activityCodes, List<string> pollutantCodes)
        {
            if (activityCodes != null && activityCodes.Count() == 0)
                return new List<AOPollutantTreeListRow>();

            PollutantTransfersSearchFilter prFilter = convertToPollutantTransferSearchFilter(filter, pollutantGroupID);

            var releases = PollutantTransfers.GetSubActivities(prFilter, activityCodes).ToList();
            return convertData(releases, pollutantCodes);
        }

        /// <summary>
        /// Return the number of facilites having pollutant transfers
        /// </summary>
        public static int GetFacilityCountPollutantTransfer(AreaOverviewSearchFilter filter)
        {
            PollutantTransfersSearchFilter ptFilter = FilterConverter.ConvertToPollutantTransfersSearchFilter(filter);
            return PollutantTransfers.GetFacilityCount(ptFilter);
        }


        private static List<AOPollutantTreeListRow> convertData(List<PollutantTransfers.ActivityTreeListRow> transfers, List<string> pollutantCodes)
        {
            List<AOPollutantTreeListRow> aoRows = new List<AOPollutantTreeListRow>();

            for (int i = 0; i < transfers.Count(); i++)
            {
                PollutantTransfers.ActivityTreeListRow row = transfers[i];

                PollutantData rowData = new PollutantData(row.PollutantCode, row.Facilities, row.Quantity);

                AOPollutantTreeListRow aoRow = aoRows.Where(r => r.SectorCode == row.SectorCode && r.ActivityCode == row.ActivityCode && r.SubactivityCode == row.SubactivityCode)
                                                    .SingleOrDefault();

                if (aoRow == null)
                {
                    //add new row
                    aoRow = new AOPollutantTreeListRow(row, pollutantCodes);
                    aoRows.Add(aoRow);
                }

                aoRow.AddPollutantData(rowData);
            }
            return aoRows;
        }

        private static PollutantTransfersSearchFilter convertToPollutantTransferSearchFilter(AreaOverviewSearchFilter filter, int pollutantGroupID)
        {
            PollutantTransfersSearchFilter ptFilter = FilterConverter.ConvertToPollutantTransfersSearchFilter(filter);

            PollutantFilter pollutantFilter = new PollutantFilter();
            pollutantFilter.PollutantGroupID = pollutantGroupID;
            pollutantFilter.PollutantID = PollutantFilter.AllPollutantsInGroupID;

            ptFilter.PollutantFilter = pollutantFilter;

            return ptFilter;
        }

        #endregion

        // ----------------------------------------------------------------------------------
        // Waste Transfers
        // ----------------------------------------------------------------------------------
        #region WasteTransfers

        /// <summary>
        /// Holds data for rows in area search activity tree for waste transfers
        /// </summary>
        [Serializable]
        public class AOWasteTreeListRow : ActivityTreeListRow
        {

            public AOWasteTreeListRow(WasteTransfers.SimpleActivityTreeListRow treeListRow)
                : base(treeListRow.SectorCode, treeListRow.ActivityCode, treeListRow.SubactivityCode, treeListRow.HasChildren)
            {
                initializeWasteList();
            }


            public List<WasteData> WasteList { get; private set; }


            //fill waste list with all waste types
            private void initializeWasteList()
            {
                this.WasteList = new List<WasteData>();

                foreach (string wt in GetWasteTypes())
                {
                    this.WasteList.Add(new WasteData(wt));
                }
            }

            public void AddWasteData(WasteData wasteData)
            {
                WasteData data = getWasteData(wasteData.WasteCode);

                if (data != null)
                {
                    data.SetData(wasteData.Facilities, wasteData.Quantity);
                }

            }

            public int? GetFacilities(string wasteType)
            {
                WasteData wd = getWasteData(wasteType);
                return wd.Facilities;
            }

            public double? GetQuantity(string wasteType)
            {
                WasteData wd = getWasteData(wasteType);
                return wd.Quantity;
            }

            public string GetUnit(string wasteType)
            {
                return CODE_TNE; //waste is always tonnes
            }

            private WasteData getWasteData(string wasteType)
            {
                return this.WasteList.SingleOrDefault(d => d.WasteCode == wasteType);
            }


        }

        /// <summary>
        /// Holds waste data for one "cell" in area search
        /// </summary>
        [Serializable]
        public class WasteData
        {
            public WasteData(string wasteCode)
            {
                this.WasteCode = wasteCode;
            }

            public WasteData(string wasteCode, int? facilities, double? quantity)
                : this(wasteCode)
            {
                SetData(facilities, quantity);
            }

            public void SetData(int? facilities, double? quantity)
            {
                this.Facilities = facilities;
                this.Quantity = quantity;
                this.Unit = CODE_TNE;
            }

            public string WasteCode { get; private set; }
            public int? Facilities { get; private set; }
            public double? Quantity { get; private set; }
            public String Unit { get; private set; }

        }


        /// <summary>
        /// return full activity tree with all rows expanded
        /// </summary>
        public static IEnumerable<AreaOverview.AOWasteTreeListRow> GetWasteTransferActivityTree(AreaOverviewSearchFilter filter)
        {
            IEnumerable<AreaOverview.AOWasteTreeListRow> sectors = GetWasteTransferSectors(filter).ToList();

            List<string> sectorCodes = sectors.Where(p => p.HasChildren).Select(p => p.SectorCode).ToList();
            IEnumerable<AreaOverview.AOWasteTreeListRow> activities = GetWasteTransferActivities(filter, sectorCodes).ToList();

            List<string> activityCodes = activities.Where(p => p.HasChildren).Select(p => p.ActivityCode).ToList();
            IEnumerable<AreaOverview.AOWasteTreeListRow> subactivities = GetWasteTransferSubActivities(filter, activityCodes).ToList();

            //create result with full tree.
            IEnumerable<AreaOverview.AOWasteTreeListRow> result = sectors.Union(activities).Union(subactivities)
                                                               .OrderBy(s => s.SectorCode)
                                                               .ThenBy(s => s.ActivityCode)
                                                               .ThenBy(s => s.SubactivityCode);

            return result;
        }


        /// <summary>
        /// return total list of waste transfers, level 0. 
        /// </summary>
        public static IEnumerable<AreaOverview.AOWasteTreeListRow> GetWasteTransferSectors(AreaOverviewSearchFilter filter)
        {
            WasteTransferSearchFilter wtFilter = FilterConverter.ConvertToWasteTransferSearchFilter(filter);
            var transfers = WasteTransfers.GetSectorsPerWasteType(wtFilter).ToList();
            return convertData(transfers);
        }

        /// <summary>
        /// Return all activities (level 1) for waste transfers that fullfill search criteria within the sectorCodes given. 
        /// </summary>
        public static IEnumerable<AreaOverview.AOWasteTreeListRow> GetWasteTransferActivities(AreaOverviewSearchFilter filter, List<string> sectorCodes)
        {
            WasteTransferSearchFilter wtFilter = FilterConverter.ConvertToWasteTransferSearchFilter(filter);
            var transfers = WasteTransfers.GetActivitiesPerWasteType(wtFilter, sectorCodes).ToList();
            return convertData(transfers);
        }

        /// <summary>
        /// Return all subactivities (level 2) for waste transfers that fullfill search criteria within the activityCodes given. 
        /// If activityCodes are null, all subactivities will be returned. If activityCodes is empty no subactivities will be returned.
        /// Notice that this will include one subactivity "Not specified on this level" for each activity, even if the activity do not have any subactivities at all!
        /// </summary>
        public static IEnumerable<AreaOverview.AOWasteTreeListRow> GetWasteTransferSubActivities(AreaOverviewSearchFilter filter, List<string> activityCodes)
        {
            WasteTransferSearchFilter wtFilter = FilterConverter.ConvertToWasteTransferSearchFilter(filter);
            var transfers = WasteTransfers.GetSubActivitiesPerWasteType(wtFilter, activityCodes).ToList();
            
            return convertData(transfers);
        }


        /// <summary>
        /// Return the number of facilites having waste transfers
        /// </summary>
        public static int GetFacilityCountWasteTransfer(AreaOverviewSearchFilter filter)
        {
            WasteTransferSearchFilter wtFilter = FilterConverter.ConvertToWasteTransferSearchFilter(filter);
            return WasteTransfers.GetFacilityCount(wtFilter);
        }

        private static List<AOWasteTreeListRow> convertData(List<WasteTransfers.SimpleActivityTreeListRow> transfers)
        {
            List<AOWasteTreeListRow> aoRows = new List<AOWasteTreeListRow>();

            for (int i = 0; i < transfers.Count(); i++)
            {
                WasteTransfers.SimpleActivityTreeListRow row = transfers[i];

                WasteData rowData = new WasteData(row.WasteType, row.Facilities, row.QuantityTotal);

                AOWasteTreeListRow aoRow = aoRows.Where(r => r.SectorCode == row.SectorCode && r.ActivityCode == row.ActivityCode && r.SubactivityCode == row.SubactivityCode)
                                                    .SingleOrDefault();

                if (aoRow == null)
                {
                    //add new row
                    aoRow = new AOWasteTreeListRow(row);
                    aoRows.Add(aoRow);
                }

                aoRow.AddWasteData(rowData);
            }
            return aoRows;
        }

        /// <summary>
        /// Find all waste types 
        /// </summary>
        public static List<string> GetWasteTypes()
        {
            //always include all waste types
            List<string> wasteTypes = new List<string>();
            wasteTypes.Add(WasteTransfers.CODE_HWIC);
            wasteTypes.Add(WasteTransfers.CODE_HWOC);
            wasteTypes.Add(WasteTransfers.CODE_HW);
            wasteTypes.Add(WasteTransfers.CODE_NONHW);

            return wasteTypes;

        }

        #endregion


        // ----------------------------------------------------------------------------------
        // Confidentiality
        // ----------------------------------------------------------------------------------
        #region Confidentiality

        /// <summary>
        /// return true if confidentiality might effect pollutant release result
        /// </summary>
        public static bool IsPollutantReleaseAffectedByConfidentiality(AreaOverviewSearchFilter filter)
        {
            int pollutantGroupID = PollutantFilter.AllGroupsID; // include all pollutant groups
            return IsPollutantReleaseAffectedByConfidentiality(filter, null, pollutantGroupID);
        }


        /// <summary>
        /// return true if confidentiality might effect pollutant release result
        /// </summary>
        public static bool IsPollutantReleaseAffectedByConfidentiality(AreaOverviewSearchFilter filter, MediumFilter.Medium? medium, int pollutantGroupID)
        {
            PollutantReleaseSearchFilter prFilter = convertToPollutantReleaseSearchFilter(filter, medium, pollutantGroupID);
            return PollutantReleases.IsAffectedByConfidentiality(prFilter);
        }

        /// <summary>
        /// return true if confidentiality might effect pollutant transfer result
        /// </summary>
        public static bool IsPollutantTransferAffectedByConfidentiality(AreaOverviewSearchFilter filter)
        {
            int pollutantGroupID = PollutantFilter.AllGroupsID; // include all pollutant groups
            return IsPollutantTransferAffectedByConfidentiality(filter, pollutantGroupID);
        }

        /// <summary>
        /// return true if confidentiality might effect pollutant transfer result
        /// </summary>
        public static bool IsPollutantTransferAffectedByConfidentiality(AreaOverviewSearchFilter filter, int pollutantGroupID)
        {
            PollutantTransfersSearchFilter ptFilter = convertToPollutantTransferSearchFilter(filter, pollutantGroupID);
            return PollutantTransfers.IsAffectedByConfidentiality(ptFilter);
        }


        /// <summary>
        /// return true if confidentiality might effect waste result
        /// </summary>
        public static bool IsWasteAffectedByConfidentiality(AreaOverviewSearchFilter filter)
        {
            WasteTransferSearchFilter wtFilter = FilterConverter.ConvertToWasteTransferSearchFilter(filter);
            return WasteTransfers.IsAffectedByConfidentiality(wtFilter);
        }


        #endregion

        // ----------------------------------------------------------------------------------
        // Map
        // ----------------------------------------------------------------------------------
        #region Map


        /// <summary>
        /// returns the MapFilter (sql and layers) corresponding to the filter. 
        /// </summary>
        public static MapFilter GetMapFilter(AreaOverviewSearchFilter filter)
        {
            DataClassesFacilityDataContext db = getFacilityDataContext();
            ParameterExpression param = Expression.Parameter(typeof(FACILITYSEARCH_MAINACTIVITY), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionAreaOverviewSearch(filter, param);
            Expression<Func<FACILITYSEARCH_MAINACTIVITY, bool>> lambda = Expression.Lambda<Func<FACILITYSEARCH_MAINACTIVITY, bool>>(exp, param);

            // create sql and sectors to map
            MapFilter mapFilter = new MapFilter();
            mapFilter.SqlWhere = LinqExpressionBuilder.GetSQL(exp, param);
            mapFilter.SetLayers(null);

            return mapFilter;
        }

        #endregion

        #region Data context
        private static DataClassesPollutantReleaseDataContext getPollutantReleaseDataContext()
        {
            DataClassesPollutantReleaseDataContext db = new DataClassesPollutantReleaseDataContext();
            db.Log = new DebuggerWriter();
            return db;
        }

        private static DataClassesPollutantTransferDataContext getPollutantTransferDataContext()
        {
            DataClassesPollutantTransferDataContext db = new DataClassesPollutantTransferDataContext();
            db.Log = new DebuggerWriter();
            return db;
        }

        private static DataClassesWasteTransferDataContext getWasteTransferDataContext()
        {
            DataClassesWasteTransferDataContext db = new DataClassesWasteTransferDataContext();
            db.Log = new DebuggerWriter();
            return db;
        }

        private static DataClassesFacilityDataContext getFacilityDataContext()
        {
            DataClassesFacilityDataContext db = new DataClassesFacilityDataContext();
            db.Log = new DebuggerWriter();
            return db;
        }


        #endregion


    }
}
