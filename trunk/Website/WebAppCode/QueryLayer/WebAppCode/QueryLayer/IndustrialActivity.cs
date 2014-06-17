using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using LinqUtilities;
using QueryLayer.Filters;
using QueryLayer.LinqFramework;
using QueryLayer.Utilities;

namespace QueryLayer
{
    /// <summary>
    /// Holds methods to collect data for the Industrial Activity search
    /// </summary>
    public static class IndustrialActivity
    {

        // ----------------------------------------------------------------------------------
        // Pollutant Releases
        // ----------------------------------------------------------------------------------
        #region PollutantReleases

        /// <summary>
        /// Class for treelist row for Industrial activities. Includes group Code
        /// </summary>
        [Serializable]
        public class IAReleasesTreeListRow : PollutantReleases.ReleasesTreeListRow
        {
            private int countPollutants;

            public IAReleasesTreeListRow(string code,
                          string groupCode,
                          int facilities,
                          int accidentalFacilities,
                          double? quantityAir, double? accidentalAir, 
                          double? quantityWater, double? accidentalWater, 
                          double? quantitySoil, double? accidentalSoil,
                          int level, int countPollutants, bool hasChildren)
                : base(code, groupCode, facilities, accidentalFacilities, quantityAir, accidentalAir, quantityWater, accidentalWater, quantitySoil, accidentalSoil, level, hasChildren)
            {
                this.countPollutants = countPollutants;
            }


            public string GroupCode { get { return this.ParentCode; } }

            /// <summary>
            /// Returns the number of pollutants. NB! Will not include any confidential groups
            /// </summary>
            public int CountChildPollutants { get { return this.countPollutants; } }

            public bool ConfidentialIndicator
            {
                get
                {
                    return Level == 1 && Code.Equals(GroupCode);
                }
            }
        }


        /// <summary>
        /// get transfers
        /// </summary>
        private static IEnumerable<IAReleasesTreeListRow> getReleases(DataClassesPollutantReleaseDataContext db, Expression<Func<POLLUTANTRELEASE, bool>> lambda, out int facilitiesCount)
        {

            // count number of distinct facilities for this filter
            facilitiesCount = db.POLLUTANTRELEASEs.Where(lambda).Select(x => x.FacilityReportID).Distinct().Count();

            //Count facilities per group (level = 0).
            IEnumerable<IAReleasesTreeListRow> groupsx = db.POLLUTANTRELEASEs.Where(lambda)
                                                            .GroupBy(s => s.PollutantGroupCode)
                                                            .Select(v => new IAReleasesTreeListRow(
                                                                                v.Key,
                                                                                v.Key,
                                                                                v.Select(x => x.FacilityReportID).Distinct().Count(),
                                                                                0, // Value never used, for this Level
                                                                                null, null, null, null, null, null, 
                                                                                0,
                                                                                v.Where(x => x.ConfidentialIndicator == false).Select(x => x.PollutantCode).Distinct().Count(),
                                                                                true)
                                                            );


            //collect pollutants and aggregate data (level = 1).
            IEnumerable<IAReleasesTreeListRow> pollutantsx = db.POLLUTANTRELEASEs.Where(lambda)
                                                                .GroupBy(s => new { s.PollutantGroupCode, s.PollutantCode })
                                                                .Select(v => new IAReleasesTreeListRow(
                                                                                    v.Key.PollutantCode,
                                                                                    v.Key.PollutantGroupCode,
                                                                                    v.Count(),
                                                                                    v.Count(z => z.QuantityAccidentalAir > 0 || z.QuantityAccidentalSoil > 0 || z.QuantityAccidentalWater > 0),
                                                                                    v.Sum(x => x.QuantityAir), 
                                                                                    v.Sum(x => x.QuantityAccidentalAir), 
                                                                                    v.Sum(x => x.QuantityWater), 
                                                                                    v.Sum(x => x.QuantityAccidentalWater), 
                                                                                    v.Sum(x => x.QuantitySoil), 
                                                                                    v.Sum(x => x.QuantityAccidentalSoil), 
                                                                                    1, 0, false)
                                                                );




            //create result with both groups and pollutants in.
            IEnumerable<IAReleasesTreeListRow> result = groupsx.Union(pollutantsx)
                                                               .OrderBy(s => s.GroupCode)
                                                               .ThenBy(s => s.Level)
                                                               .ThenBy(s => s.ConfidentialIndicator)
                                                               .ThenBy(s => s.Code);

            return result;
        }



        /// <summary>
        /// return total list of areas
        /// </summary>
        public static IEnumerable<IAReleasesTreeListRow> GetPollutantReleases(IndustrialActivitySearchFilter filter)
        {
			DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");

            PollutantReleaseSearchFilter filterRelease = FilterConverter.ConvertToPollutantReleaseSearchFilter(filter);
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(filterRelease, param);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);

            int facilitiesCount = 0;
            List<IAReleasesTreeListRow> pollutants = getReleases(db, lambda, out facilitiesCount).ToList<IAReleasesTreeListRow>();
            filter.Count = facilitiesCount;

            return pollutants;
        }


        #endregion


        // ----------------------------------------------------------------------------------
        // Pollutant Transfers
        // ----------------------------------------------------------------------------------
        #region PollutantTransfers
        
        /// <summary>
        /// Class for treelist row for Industrial activities. Includes group Code
        /// </summary>
        [Serializable]
        public class IATransfersTreeListRow : PollutantTransfers.TransfersTreeListRow
        {
            private int countPollutants;

            public IATransfersTreeListRow(string code, string groupCode, int facilities, double quantity, int level, int countPollutants, bool hasChildren)
                : base(code, groupCode, facilities, quantity, level, hasChildren)
            {
                this.countPollutants = countPollutants;
            }

            /// <summary>
            /// Returns the number of pollutants. NB! Will not include any confidential groups
            /// </summary>
            public int CountChildPollutants { get { return this.countPollutants; } }

            public string GroupCode { get { return this.ParentCode; } }

            public bool ConfidentialIndicator { 
                get { 
                    return Level == 1 && Code.Equals(GroupCode); 
                }
            }
        
        }


        /// <summary>
        /// get transfers
        /// </summary>
        private static IEnumerable<IATransfersTreeListRow> getTransfers(DataClassesPollutantTransferDataContext db, Expression<Func<POLLUTANTTRANSFER, bool>> lambda, out int facilitiesCount)
        {

            // count number of distinct facilities for this filter
            facilitiesCount = db.POLLUTANTTRANSFERs.Where(lambda).Select(x => x.FacilityReportID).Distinct().Count();

            //Count facilities per group (level = 0).
            IEnumerable<IATransfersTreeListRow> groupsx = db.POLLUTANTTRANSFERs.Where(lambda)
                                                            .GroupBy(s => s.PollutantGroupCode)
                                                            .Select(v => new IATransfersTreeListRow(
                                                                                v.Key,
                                                                                v.Key,
                                                                                v.Select(x => x.FacilityReportID).Distinct().Count(),
                                                                                0,
                                                                                0,
                                                                                v.Where(x => x.ConfidentialIndicator == false).Select(x => x.PollutantCode).Distinct().Count(),
                                                                                true)
                                                            );

            //collect pollutants and aggregate data (level = 1).
            IEnumerable<IATransfersTreeListRow> pollutantsx = db.POLLUTANTTRANSFERs.Where(lambda)
                                                                .GroupBy(s => new { s.PollutantGroupCode, s.PollutantCode })
                                                                .Select(v => new IATransfersTreeListRow( 
                                                                                    v.Key.PollutantCode,
                                                                                    v.Key.PollutantGroupCode,
                                                                                    v.Count(),
                                                                                    v.Sum(x => x.Quantity),
                                                                                    1,
                                                                                    0,
                                                                                    false)
                                                                );


            //create result with both groups and pollutants in.
            IEnumerable<IATransfersTreeListRow> result = groupsx.Union(pollutantsx)
                                                               .OrderBy(s => s.GroupCode)
                                                               .ThenBy(s => s.Level)
                                                               .ThenBy(s => s.ConfidentialIndicator)
                                                               .ThenBy(s => s.Code);

            return result;
        }




        public static IEnumerable<IATransfersTreeListRow> GetPollutantTransfers(IndustrialActivitySearchFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "s");
            
            PollutantTransfersSearchFilter filterTransfer = FilterConverter.ConvertToPollutantTransfersSearchFilter(filter);
            filterTransfer.ActivityFilter = filter.ActivityFilter;
            filterTransfer.AreaFilter = filter.AreaFilter;
            filterTransfer.YearFilter = filter.YearFilter;
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfers(filterTransfer, param);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);

            int facilitiesCount = 0;
            List<IATransfersTreeListRow> pollutants = getTransfers(db, lambda, out facilitiesCount).ToList<IATransfersTreeListRow>();
            filter.Count = facilitiesCount;
            return pollutants;
        }
        #endregion


        // ----------------------------------------------------------------------------------
        // WasteTransfers
        // ----------------------------------------------------------------------------------
        #region WasteTransfers

        /// <summary>
        /// get waste transfers
        /// </summary>
        public static IEnumerable<Summary.WasteSummaryTreeListRow> GetWasteTransfers(IndustrialActivitySearchFilter filter)
        {
            // Result is the same as for wastetransfer, without the filtering on wastetype 
            WasteTransferSearchFilter filterWaste = FilterConverter.ConvertToWasteTransferSearchFilter(filter);
            IEnumerable<Summary.WasteSummaryTreeListRow> wastes = WasteTransfers.GetWasteTransfers(filterWaste);
            filter.Count = filterWaste.Count;
            
            return wastes;
        }
        
        #endregion


        // ----------------------------------------------------------------------------------
        // Confidential
        // ----------------------------------------------------------------------------------
        #region Confidential

        [Serializable]
        public class ConfidentialReleasesRow
        {
            public string PollutantCode { get; set; }
            public string ReasonCode { get; set; }
            public int FacilitiesAir { get; set; }
            public int FacilitiesWater { get; set; }
            public int FacilitiesSoil { get; set; }
            public int FacilitiesAirConfidential { get; set; }
            public int FacilitiesWaterConfidential { get; set; }
            public int FacilitiesSoilConfidential { get; set; }

            public ConfidentialReleasesRow(string pollutantGroupCode)
            {
                this.PollutantCode = pollutantGroupCode;
                this.ReasonCode = String.Empty;
            }
            public ConfidentialReleasesRow(string pollutantGroupCode, string reasonCode, int facilitiesAir, int facilitiesWater, int facilitiesSoil)
            {
                this.PollutantCode = pollutantGroupCode;
                this.ReasonCode = reasonCode;
                this.FacilitiesAir = facilitiesAir;
                this.FacilitiesWater = facilitiesWater;
                this.FacilitiesSoil = facilitiesSoil;
            }
        }
        
        [Serializable]
        public class ConfidentialTransfersRow
        {
            public string PollutantCode { get; set; }
            public string ReasonCode { get; set; }
            public int Facilities { get; set; }
            public int FacilitiesConfidential { get; set; }
            
            public ConfidentialTransfersRow(string pollutantCode)
            {
                this.PollutantCode = pollutantCode;
                this.ReasonCode = String.Empty;
            }
            public ConfidentialTransfersRow(string pollutantCode, string reasonCode, int facilities)
            {
                this.PollutantCode = pollutantCode;
                this.ReasonCode = reasonCode;
                this.Facilities = facilities;
            }
        }
        
        /// <summary>
        /// getPollutantReleasesLambda
        /// </summary>
        private static Expression<Func<POLLUTANTRELEASE, bool>> getPollutantReleasesLambda(DataClassesPollutantReleaseDataContext db, IndustrialActivitySearchFilter filter)
        {
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");
            PollutantReleaseSearchFilter filterReleases = FilterConverter.ConvertToPollutantReleaseSearchFilter(filter);
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(filterReleases, param);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);
            return lambda;
        }

        /// <summary>
        /// get lambda for confidential pollutant transfers
        /// </summary>
        private static Expression<Func<POLLUTANTRELEASE, bool>> getPollutantReleasesConfidentialLambda(DataClassesPollutantReleaseDataContext db, IndustrialActivitySearchFilter filter, bool includePollutant)
        {
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");
            PollutantReleaseSearchFilter filterReleases = FilterConverter.ConvertToPollutantReleaseSearchFilter(filter);
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleasesConfidential(filterReleases, param, includePollutant);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);
            return lambda;
        }


        /// <summary>
        /// return confidential realeases for facilities
        /// </summary>
        public static IEnumerable<ConfidentialReleasesRow> GetConfidentialReleasesFacility(IndustrialActivitySearchFilter filter)
        {
            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = getPollutantReleasesLambda(db, filter);

            var pollutantAll = db.POLLUTANTRELEASEs.Where(lambda);
            var pollutantConfidential = from c in pollutantAll where (c.ConfidentialIndicator != null && c.ConfidentialIndicator == true) select c;
            
            // get list of confidential
            var conf1 = from p in pollutantConfidential group p by new { p.PollutantGroupCode };
            var conf2 = from p in conf1 
                        select new
                        {
                            pollutantGroup = p.Select(x => x.PollutantGroupCode).First(),
                            countAir = p.Count(x => x.QuantityAir!=null && x.QuantityAir >= 0),
                            countWater = p.Count(x => x.QuantityWater!=null && x.QuantityWater >= 0),
                            countSoil = p.Count(x => x.QuantitySoil!=null && x.QuantitySoil >= 0)
                        };

            // get list of not confidential (all)
            var all1 = from p in pollutantAll group p by new { p.PollutantGroupCode };
            var all2 = from p in all1
                        select new
                        {
                            pollutantGroup = p.Select(x => x.PollutantGroupCode).First(),
                            countAir = p.Count(x => x.QuantityAir != null && x.QuantityAir >= 0),
                            countWater = p.Count(x => x.QuantityWater != null && x.QuantityWater >= 0),
                            countSoil = p.Count(x => x.QuantitySoil != null && x.QuantitySoil >= 0)
                        };

            // merge results
            List<ConfidentialReleasesRow> final = new List<ConfidentialReleasesRow>();
            foreach (var v1 in conf2)
            {
                foreach (var v2 in all2)
                {
                    if (v1.pollutantGroup.Equals(v2.pollutantGroup))
                    {
                        ConfidentialReleasesRow cr = new ConfidentialReleasesRow(v1.pollutantGroup);
                        // set confidential
                        cr.FacilitiesAirConfidential = v1.countAir;
                        cr.FacilitiesWaterConfidential = v1.countWater;
                        cr.FacilitiesSoilConfidential = v1.countSoil;
                        // set not confidential (all)
                        cr.FacilitiesAir = v2.countAir;
                        cr.FacilitiesWater = v2.countWater;
                        cr.FacilitiesSoil = v2.countSoil;
                        final.Add(cr);
                        break;
                    }
                }
            }
            
            return final;
        }

        /// <summary>
        /// return confidential realeases for reason
        /// </summary>
        public static IEnumerable<ConfidentialReleasesRow> GetConfidentialReleasesReason(IndustrialActivitySearchFilter filter)
        {
            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = getPollutantReleasesLambda(db, filter);

            //reason = ConfidentialityID 
            var pollutantBase = db.POLLUTANTRELEASEs.Where(lambda);
            var pollutantConf = from c in pollutantBase where (c.ConfidentialIndicator!=null && c.ConfidentialIndicator == true) select c;
                        
            // select distinct list of pollutnat codes
            IEnumerable<string> pollutantGroupCodes = (from p in pollutantConf select p.PollutantGroupCode).Distinct();
            
            // final result
            List<ConfidentialReleasesRow> finalAir = new List<ConfidentialReleasesRow>();
            List<ConfidentialReleasesRow> finalWater = new List<ConfidentialReleasesRow>();
            List<ConfidentialReleasesRow> finalSoil = new List<ConfidentialReleasesRow>();
            
            // Air count facilities
            var air1 = from p in pollutantConf where( p.ConfidentialCodeAir!=null) group p by new { p.PollutantGroupCode, p.ConfidentialCodeAir };
            var air2 = from p in air1
                       select new
                       {
                           pollutantGroupCode = p.Select(x => x.PollutantGroupCode).First(),
                           reason = p.Select(x => x.ConfidentialCodeAir).First(),
                           countAir = p.Count(x => x.QuantityAir != null && x.QuantityAir >= 0)
                       };
            foreach (var v in air2)
                finalAir.Add(new ConfidentialReleasesRow(v.pollutantGroupCode, v.reason, v.countAir, 0, 0));
            

            // Water count facilities
            var water1 = from p in pollutantConf where (p.ConfidentialCodeWater != null) group p by new { p.PollutantGroupCode, p.ConfidentialCodeWater };
            var water2 = from p in water1
                       select new
                       {
                           pollutantGroupCode = p.Select(x => x.PollutantGroupCode).First(),
                           reason = p.Select(x => x.ConfidentialCodeWater).First(),
                           countWater = p.Count(x => x.QuantityWater != null && x.QuantityWater >= 0)
                       };
            foreach (var v in water2)
                finalWater.Add(new ConfidentialReleasesRow(v.pollutantGroupCode, v.reason, 0, v.countWater, 0));


            // Soil count facilities
            var soil1 = from p in pollutantConf where (p.ConfidentialCodeSoil != null) group p by new { p.PollutantGroupCode, p.ConfidentialCodeSoil };
            var soil2 = from p in soil1
                         select new
                         {
                             pollutantGroupCode = p.Select(x => x.PollutantGroupCode).First(),
                             reason = p.Select(x => x.ConfidentialCodeSoil).First(),
                             countSoil = p.Count(x => x.QuantitySoil != null && x.QuantitySoil >= 0)
                         };
            foreach (var v in soil2)
                finalSoil.Add(new ConfidentialReleasesRow(v.pollutantGroupCode, v.reason, 0, 0, v.countSoil));
            
            // Merge water and soil lists into air list and return it
            foreach (var f in finalAir)
            {
                foreach (var w in finalWater)
                {
                    if (f.PollutantCode.Equals(w.PollutantCode) && f.ReasonCode.Equals(w.ReasonCode))
                    {
                        f.FacilitiesWater = w.FacilitiesWater;
                        break;
                    }
                }
            }
            foreach (var f in finalAir)
            {
                foreach (var s in finalSoil)
                {
                    if (f.PollutantCode.Equals(s.PollutantCode) && f.ReasonCode.Equals(s.ReasonCode))
                    {
                        f.FacilitiesSoil = s.FacilitiesSoil;
                        break;
                    }
                }
            }

            
            List<ConfidentialReleasesRow> final = new List<ConfidentialReleasesRow>();
            var finalOrdered = finalAir.OrderBy(x => x.PollutantCode);

            string headCode = String.Empty;
            foreach (var v in finalOrdered)
            {
                if (v.PollutantCode != headCode)
                    headCode = v.PollutantCode;
                else
                    v.PollutantCode = String.Empty;
                final.Add(v);
            }

            return final;
        }
        
        
        /// <summary>
        /// get lambda for pollutant transfers
        /// </summary>
        private static Expression<Func<POLLUTANTTRANSFER, bool>> getPollutantTransfersLambda(DataClassesPollutantTransferDataContext db, IndustrialActivitySearchFilter filter)
        {
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "s");
            PollutantTransfersSearchFilter filterTransfers = FilterConverter.ConvertToPollutantTransfersSearchFilter(filter);
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfers(filterTransfers, param);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);
            return lambda;
        }


        /// <summary>
        /// get lambda for confidential pollutant transfers
        /// </summary>
        private static Expression<Func<POLLUTANTTRANSFER, bool>> getPollutantTransfersConfidentialLambda(DataClassesPollutantTransferDataContext db, IndustrialActivitySearchFilter filter, bool includePollutant)
        {
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTTRANSFER), "s");
            PollutantTransfersSearchFilter filterTransfers = FilterConverter.ConvertToPollutantTransfersSearchFilter(filter);
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantTransfersConfidential(filterTransfers, param, includePollutant);
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = Expression.Lambda<Func<POLLUTANTTRANSFER, bool>>(exp, param);
            return lambda;
        }
        
        /// <summary>
        /// Get list for confidential transfers
        /// </summary>
        public static IEnumerable<ConfidentialTransfersRow> GetConfidentialTransfersFacility(IndustrialActivitySearchFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = getPollutantTransfersLambda(db, filter);
            var pollutantAll = db.POLLUTANTTRANSFERs.Where(lambda);
            var pollutantConfidential = from c in pollutantAll where (c.ConfidentialIndicator != null && c.ConfidentialIndicator == true) select c;

            // get list of confidential
            var conf1 = from p in pollutantConfidential group p by new { p.PollutantGroupCode };
            var conf2 = from p in conf1
                        select new
                        {
                            pollutantGroup = p.Select(x => x.PollutantGroupCode).First(),
                            facilities = p.Count(x => x.Quantity != null && x.Quantity >= 0),
                        };

            // get list of not confidential (all)
            var all1 = from p in pollutantAll group p by new { p.PollutantGroupCode };
            var all2 = from p in all1
                       select new
                       {
                           pollutantGroup = p.Select(x => x.PollutantGroupCode).First(),
                           facilities = p.Count(x => x.Quantity != null && x.Quantity >= 0),
                       };

            // merge results
            List<ConfidentialTransfersRow> final = new List<ConfidentialTransfersRow>();
            foreach (var v1 in conf2)
            {
                foreach (var v2 in all2)
                {
                    if (v1.pollutantGroup.Equals(v2.pollutantGroup))
                    {
                        ConfidentialTransfersRow cr = new ConfidentialTransfersRow(v1.pollutantGroup);
                        cr.FacilitiesConfidential = v1.facilities; // set confidential
                        cr.Facilities = v2.facilities; // set not confidential (all)
                        final.Add(cr);
                        break;
                    }
                }
            }

            return final;
            

            //var pollutantConfOn = from c in pollutantConfAll where (c.ConfidentialIndicator != null && c.ConfidentialIndicator == true) select c;
            //var pollutantConfOff = from c in pollutantConfAll where c.ConfidentialIndicator == false select c;

            // select distinct list of pollutnat codes
            /*IEnumerable<string> pollutantcodes = (from p in pollutantConfAll select p.PollutantGroupCode).Distinct();

            // loop through all pollutants
            List<ConfidentialTransfersRow> final = new List<ConfidentialTransfersRow>();
            foreach (string s in pollutantcodes)
            {
                ConfidentialTransfersRow ct = new ConfidentialTransfersRow(s);
                ct.FacilitiesConfidential = (from c in pollutantConfOn where c.PollutantGroupCode == s && c.Quantity != null select c).Count();
                ct.Facilities = (from c in pollutantConfOff where c.PollutantGroupCode == s && c.Quantity != null select c).Count();
                // add confidential to the total count of facilities
                ct.Facilities += ct.FacilitiesConfidential;
                final.Add(ct);
            }

            return final;
            */
        }

        /// <summary>
        /// Gets Confidential Transfers Reason
        /// </summary>
        /// <param name="filter"></param>
        /// <returns>IEnumerable<ConfidentialTransfersRow></returns>
        public static IEnumerable<ConfidentialTransfersRow> GetConfidentialTransfersReason(IndustrialActivitySearchFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = getPollutantTransfersLambda(db, filter);
            
            //reason = ConfidentialityID 
            var pollutantBase = db.POLLUTANTTRANSFERs.Where(lambda);
            var pollutantConf = from c in pollutantBase where (c.ConfidentialIndicator != null && c.ConfidentialIndicator == true) select c;

            // select distinct list of pollutnat codes
            IEnumerable<string> pollutantGroupCodes = (from p in pollutantConf select p.PollutantGroupCode).Distinct();

            // final result
            List<ConfidentialTransfersRow> finaltmp = new List<ConfidentialTransfersRow>();
            
            // Air count facilities
            var air1 = from p in pollutantConf where (p.ConfidentialCode != null) group p by new { p.PollutantGroupCode, p.ConfidentialCode };
            var air2 = from p in air1
                       select new
                       {
                           pollutantGroupCode = p.Select(x => x.PollutantGroupCode).First(),
                           reason = p.Select(x => x.ConfidentialCode).First(),
                           facilities = p.Count(x => x.Quantity != null && x.Quantity >= 0)
                       };
            foreach (var v in air2)
                finaltmp.Add(new ConfidentialTransfersRow(v.pollutantGroupCode, v.reason, v.facilities));


            List<ConfidentialTransfersRow> final = new List<ConfidentialTransfersRow>();
            var finalOrdered = finaltmp.OrderBy(x => x.PollutantCode);

            string headCode = String.Empty;
            foreach (var v in finalOrdered)
            {
                if (v.PollutantCode != headCode)
                    headCode = v.PollutantCode;
                else
                    v.PollutantCode = String.Empty;
                final.Add(v);
            }

            return final;
        }
                

        /// <summary>
        /// Waste confidential facilities wrapper
        /// </summary>
        public static List<WasteTransfers.FacilityCountObject> GetWasteConfidentialFacilities(IndustrialActivitySearchFilter filter)
        {
            WasteTransferSearchFilter filterWaste = FilterConverter.ConvertToWasteTransferSearchFilter(filter);
            return WasteTransfers.GetCountConfidentialFacilities(filterWaste);        
        }


        /// <summary>
        /// Waste reason facilities wrapper
        /// </summary>
        public static IEnumerable<WasteTransfers.WasteConfidentialReason> GetWasteConfidentialReason(IndustrialActivitySearchFilter filter)
        {
            WasteTransferSearchFilter filterWaste = FilterConverter.ConvertToWasteTransferSearchFilter(filter);
            return WasteTransfers.GetWasteConfidentialReason(filterWaste);        
        }


        /// <summary>
        /// return true if confidentiality might effect pollutant release result
        /// </summary>
        public static bool IsPollutantReleaseAffectedByConfidentiality(IndustrialActivitySearchFilter filter)
        {
            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = getPollutantReleasesConfidentialLambda(db, filter, false);
            return db.POLLUTANTRELEASEs.Any(lambda);
        }

        /// <summary>
        /// return true if confidentiality might effect pollutant transfer result
        /// </summary>
        public static bool IsPollutantTransferAffectedByConfidentiality(IndustrialActivitySearchFilter filter)
        {
            DataClassesPollutantTransferDataContext db = getPollutantTransferDataContext();
            Expression<Func<POLLUTANTTRANSFER, bool>> lambda = getPollutantTransfersConfidentialLambda(db, filter, false);
            return db.POLLUTANTTRANSFERs.Any(lambda);
        }


        /// <summary>
        /// return true if confidentiality might effect waste result
        /// </summary>
        public static bool IsWasteAffectedByConfidentiality(IndustrialActivitySearchFilter filter)
        {
            WasteTransferSearchFilter filterWaste = FilterConverter.ConvertToWasteTransferSearchFilter(filter);
            return WasteTransfers.IsAffectedByConfidentiality(filterWaste);
        }

        #endregion


        #region count
        /// <summary>
        /// Returns the number of facilities corresponding to the filter. Always use FACILITY_MAIN table, since it has the fewest records.
        /// </summary>
        public static int GetFacilityCount(IndustrialActivitySearchFilter filter)
        {
            DataClassesFacilityDataContext db = getFacilityDataContext();
            ParameterExpression param = Expression.Parameter(typeof(FACILITYSEARCH_MAINACTIVITY), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionIndustrialActivitySearch(filter, param);
            Expression<Func<FACILITYSEARCH_MAINACTIVITY, bool>> lambda = Expression.Lambda<Func<FACILITYSEARCH_MAINACTIVITY, bool>>(exp, param);

            //find total no. of facilities. Table only have one record per facility, so distinct is not needed.
            int count = db.FACILITYSEARCH_MAINACTIVITies
                                .Where(lambda)
                                .Count();

            return count;
        }
        #endregion

        #region Map


        /// <summary>
        /// returns the MapFilter (sql and layers) corresponding to the filter. 
        /// </summary>
        public static MapFilter GetMapFilter(IndustrialActivitySearchFilter filter)
        {
            DataClassesFacilityDataContext db = getFacilityDataContext();
            ParameterExpression param = Expression.Parameter(typeof(FACILITYSEARCH_MAINACTIVITY), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionIndustrialActivitySearch(filter, param);
            Expression<Func<FACILITYSEARCH_MAINACTIVITY, bool>> lambda = Expression.Lambda<Func<FACILITYSEARCH_MAINACTIVITY, bool>>(exp, param);

            // create sql and sectors to map
            MapFilter mapFilter = new MapFilter();
            mapFilter.SqlWhere = LinqExpressionBuilder.GetSQL(exp, param);
            mapFilter.SetLayers(filter.ActivityFilter);

            return mapFilter;
        }

        public static MapFilter GetMapJavascriptFilter(IndustrialActivitySearchFilter filter)        {
           
            ParameterExpression param = Expression.Parameter(typeof(FACILITYSEARCH_MAINACTIVITY), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionIndustrialActivitySearch(filter, param);
            Expression<Func<FACILITYSEARCH_MAINACTIVITY, bool>> lambda = Expression.Lambda<Func<FACILITYSEARCH_MAINACTIVITY, bool>>(exp, param);

            // create sql and sectors to map
            MapFilter mapFilter = new MapFilter();
            mapFilter.SqlWhere = LinqExpressionBuilder.GetSQL(exp, param);            

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
