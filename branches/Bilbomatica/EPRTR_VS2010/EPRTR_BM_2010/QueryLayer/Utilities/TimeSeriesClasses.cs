using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using QueryLayer.Enums;
using QueryLayer.Filters;

namespace QueryLayer.Utilities
{
    public static class TimeSeriesClasses
    {
        static string CODE_KG = EnumUtil.GetStringValue(QuantityUnit.Kilo);
        static string CODE_TNE = EnumUtil.GetStringValue(QuantityUnit.Tonnes);



        /// <summary>
        /// timeseries data for pollutant releases
        /// </summary>
        [Serializable]
        public class PollutantReleases
        {
            public PollutantReleases(int year)
            {
                this.Year = year;
            }

            public PollutantReleases(int year, int facilities, double? quantity, double? quantityAccidental):this(year)
            {
                this.Facilities = facilities;
                this.Quantity = quantity;
                this.QuantityAccidental = quantityAccidental;
                this.QuantityUnit = CODE_KG;
                this.QuantityAccidentalUnit = CODE_KG;

                //this.QuantityUnit = CODE_TNE;
                //this.QuantityAccidentalUnit = CODE_TNE;


                this.AccidentalPercent = null;
                if (this.Quantity.HasValue && this.QuantityAccidental.HasValue)
                {
                    this.AccidentalPercent = this.Quantity > 0 ? (this.QuantityAccidental / this.Quantity) * 100.0 : 0;
                }

            }

            public PollutantReleases(int year, int facilities, double? quantity, double? quantityAccidental, int countries):this(year,facilities,quantity,quantityAccidental)
            {
                this.Countries = countries;
            }

            public int Year { get; private set; }
            public int Facilities { get; private set; }
            public int Countries { get; set; }
            public double? Quantity { get; private set; }
            public string QuantityUnit { get; private set; }
            public double? QuantityAccidental { get; private set; }
            public string QuantityAccidentalUnit { get; private set; }
            public double? AccidentalPercent { get; private set; }
        }

        /// <summary>
        /// timeseries data for pollutant transfers
        /// </summary>
        [Serializable]
        public class PollutantTransfers
        {
            public PollutantTransfers(int year)
            {
                this.Year = year;
            }

            public PollutantTransfers(int year, double? quantity):this(year)
            {
                this.Quantity = quantity;
                this.QuantityUnit = CODE_KG;
                //this.QuantityUnit = CODE_TNE;
            }

            public PollutantTransfers(int year, double? quantity, int facilities, int countries)
                : this(year, quantity)
            {
                this.Facilities = facilities;
                this.Countries = countries;
            }

            public int Facilities { get; private set; }
            public int Countries { get; set; }
            public int Year { get; private set; }
            public double? Quantity { get; private set; }
            public string QuantityUnit { get; private set; }
        }

        /// <summary>
        /// timeseries data for waste transfers
        /// </summary>
        [Serializable]
        public class WasteTransfer
        {

            /// <summary>
            /// Constructor for quanitiy, waste
            /// </summary>
            public WasteTransfer(int year, WasteTypeFilter.Type wasteType)
            {
                this.Year = year;
                this.WasteType = wasteType;
            }

            public WasteTransfer(int year, int facilities, WasteTypeFilter.Type wasteType, double? total, double? recovery, double? disposal, double? unspec)
                :this(year, wasteType)
            {
                this.Facilities = facilities; 
                this.QuantityTotal = total;
                this.QuantityRecovery = recovery;
                this.QuantityDisposal = disposal;
                this.QuantityUnspec = unspec;
                this.QuantityUnit = CODE_TNE; //waste is always reported in tonnes
            }

            public WasteTransfer(int year, int facilities, WasteTypeFilter.Type wasteType, double? total, double? recovery, double? disposal, double? unspec,int countries)
                : this(year, facilities, wasteType, total, recovery, disposal, unspec)
            {

                this.Countries = countries;
            }

            public int Year { get; set; }
            public int Facilities { get; set; }
            public int Countries { get; set; }

            public double? QuantityTotal { get; private set; }
            public double? QuantityRecovery { get; private set; }
            public double? QuantityDisposal { get; private set; }
            public double? QuantityUnspec { get; private set; }
            public string QuantityUnit { get; private set; }
            public WasteTypeFilter.Type WasteType { get; private set; }
        }

        /// <summary>
        /// Comparison
        /// </summary>
        public class ComparisonPollutant
        {
            public ComparisonPollutant(int yearFrom, int yearTo)
            {
                // single facility
                this.YearFrom = yearFrom;
                this.YearTo = yearTo;
                this.FacilitiesFrom = 0;
                this.FacilitiesTo = 0;
                this.BothFacilities = 0;

                this.QuantityFrom = null;
                this.AccidentalFrom = null;
                this.QuantityTo = null;
                this.AccidentalTo = null;
                this.BothQuantityFrom = null;
                this.BothQuantityTo = null;
                this.BothAccidentalFrom = null;
                this.BothAccidentalTo = null;
            }

            public int YearFrom { get; set; }
            public int YearTo { get; set; }

            // facilities
            public int FacilitiesFrom { get; set; }
            public int FacilitiesTo { get; set; }
            public double? QuantityFrom { get; set; }
            public double? QuantityTo { get; set; }
            public double? AccidentalFrom { get; set; }
            public double? AccidentalTo { get; set; }

            // reporting facilities in both years
            public int BothFacilities { get; set; }
            public double? BothQuantityFrom { get; set; }
            public double? BothQuantityTo { get; set; }
            public double? BothAccidentalFrom { get; set; }
            public double? BothAccidentalTo { get; set; }

            public void SetFrom(int facilities, double? quantity, double? accidental)
            {
                FacilitiesFrom = facilities;
                QuantityFrom = quantity;
                AccidentalFrom = accidental;
            }
            public void SetTo(int facilities, double? quantity, double? accidental)
            {
                FacilitiesTo = facilities;
                QuantityTo = quantity;
                AccidentalTo = accidental;
            }
            public void SetBothFrom(int facilities, double? quantity, double? accidental)
            {
                BothFacilities = facilities;
                BothQuantityFrom = quantity;
                BothAccidentalFrom = accidental;
            }
            public void SetBothTo(int facilities, double? quantity, double? accidental)
            {
                BothFacilities = facilities;
                BothQuantityTo = quantity;
                BothAccidentalTo = accidental;
            }
        }
        
        /// <summary>
        /// timeseries data for waste transfers
        /// </summary>
        public class ComparisonWasteTransfer
        {
            public ComparisonWasteTransfer(int yearFrom, int yearTo)
            {

                // single facility
                this.YearFrom = yearFrom;
                this.YearTo = yearTo;
                //this.FacilitiesFrom = 0;
                //this.FacilitiesTo = 0;
                //this.TotalFrom = null;
                //this.TotalTo = null;
                //this.RecoveryFrom = null;
                //this.RecoveryTo = null;
                //this.DisposalFrom = null;
                //this.DisposalTo = null;

                // both years
                //this.BothFacilities = 0;
                //this.BothTotalFrom = null;
                //this.BothTotalTo = null;
                //this.BothRecoveryFrom = null;
                //this.BothRecoveryTo = null;
                //this.BothDisposalFrom = null;
                //this.BothDisposalTo = null;
            }

            public int YearFrom { get; set; }
            public int YearTo { get; set; }

            // facilities
            public int FacilitiesFrom { get; set; }
            public int FacilitiesTo { get; set; }
            public double? TotalFrom { get; set; }
            public double? TotalTo { get; set; }
            public double? RecoveryFrom { get; set; }
            public double? RecoveryTo { get; set; }
            public double? DisposalFrom { get; set; }
            public double? DisposalTo { get; set; }
            public double? UnspecFrom { get; set; }
            public double? UnspecTo { get; set; }

            // reporting facilities in both years
            public int BothFacilities { get; set; }
            public double? BothTotalFrom { get; set; }
            public double? BothTotalTo { get; set; }
            public double? BothRecoveryFrom { get; set; }
            public double? BothRecoveryTo { get; set; }
            public double? BothDisposalFrom { get; set; }
            public double? BothDisposalTo { get; set; }
            public double? BothUnspecFrom { get; set; }
            public double? BothUnspecTo { get; set; }

            public void SetFrom(int facilities, double? total, double? recovery, double? disposal, double? unspec)
            {
                FacilitiesFrom = facilities;
                TotalFrom = total;
                RecoveryFrom = recovery;
                DisposalFrom = disposal;
                UnspecFrom = unspec;
            }
            public void SetTo(int facilities, double? total, double? recovery, double? disposal, double? unspec)
            {
                FacilitiesTo = facilities;
                TotalTo = total;
                RecoveryTo = recovery;
                DisposalTo = disposal;
                UnspecTo = unspec;
            }
            public void SetBothFrom(int facilities, double? total, double? recovery, double? disposal, double? unspec)
            {
                BothFacilities = facilities;
                BothTotalFrom = total;
                BothRecoveryFrom = recovery;
                BothDisposalFrom = disposal;
                BothUnspecFrom = unspec;
            }
            public void SetBothTo(int facilities, double? total, double? recovery, double? disposal, double? unspec)
            {
                BothFacilities = facilities;
                BothTotalTo = total;
                BothRecoveryTo = recovery;
                BothDisposalTo = disposal;
                BothUnspecTo = unspec;
            }


        }

        /// <summary>
        /// Holds information about confidentiality for pollutants for a given year.
        /// Includes the quantity of the pollutant and the quantity reported confidential within the pollutant group.
        /// </summary>
        public class ConfidentialityPollutant
        {
            public ConfidentialityPollutant(int year, double? quantityPollutant, double? quantityConfidential)
            {
                this.Year = year;
                this.QuantityPollutant = quantityPollutant;
                this.QuantityConfidential = quantityConfidential;
                this.UnitPollutant = CODE_KG;
                this.UnitConfidential = CODE_KG;
                //this.UnitPollutant = CODE_TNE;
                //this.UnitConfidential = CODE_TNE;
            }

            public int Year { get; private set; }
            public double? QuantityPollutant { get; private set; }
            public string UnitPollutant { get; private set; }
            public double? QuantityConfidential { get; private set; }
            public string UnitConfidential { get; private set; }
        }


        /// <summary>
        /// Holds information about the number of facilities claiming confidentiality on waste for a given year.
        /// </summary>
        public class ConfidentialityWaste
        {
            
            public int Year { get; set; }
            public int CountTotal { get; set; }
            public int CountConfTotal { get; set; }
            public int CountConfQuantity { get; set; }
            public int CountConfTreatment { get; set; }
        }

        /// <summary>
        /// return map with reporting countries for a list of years
        /// [year][count]
        /// </summary>
        public static Dictionary<int, int> GetReportingYears()
        {
            Dictionary<int, int> yearContries = new Dictionary<int, int>();
            var reportingyears = ListOfValues.ReportingYears(true);
            foreach (var v in reportingyears)
                yearContries.Add(v.Year, v.Countries.HasValue ? v.Countries.Value : 0);
            return yearContries;
        }


        // -----------------------------------------------------------------------------------------------
        // Internal classes for comparison
        // -----------------------------------------------------------------------------------------------
        #region internalclasses

        /// <summary>
        /// Comparison for waste transfer
        /// </summary>
        internal class TsWasteCompare
        {
            public TsWasteCompare() { }
            public TsWasteCompare(int count, double? quantity, double? recovery, double? disposal, double? unspec)
            {
                this.Count = count;
                this.Quantity = quantity;
                this.Recovery = recovery;
                this.Disposal = disposal;
                this.Unspecified = unspec;
            }
            public int Count { get; set; }
            public double? Quantity { get; set; }
            public double? Recovery { get; set; }
            public double? Disposal { get; set; }
            public double? Unspecified { get; set; }
        }

        /// <summary>
        /// Comparison for pollutant
        /// </summary>
        internal class TsPollutantCompare
        {
            public TsPollutantCompare() { }
            public TsPollutantCompare(int count, double? quantity, double? accidental)
            {
                this.Count = count;
                this.Quantity = quantity;
                this.Accidental = accidental;
            }
            public int Count { get; set; }
            public double? Quantity { get; set; }
            public double? Accidental { get; set; }
        }

        #endregion

    }
}
