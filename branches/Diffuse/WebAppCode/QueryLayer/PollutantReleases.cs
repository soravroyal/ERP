using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using QueryLayer.Enums;
using QueryLayer.Filters;
using QueryLayer.LinqFramework;
using QueryLayer.Utilities;

namespace QueryLayer
{
    /// <summary>
    /// Holds methods to collect data for the Pollutant release search
    /// </summary>
    public static class PollutantReleases
    {
        static string CODE_KG = EnumUtil.GetStringValue(QuantityUnit.Kilo);
       // static string CODE_TNE = EnumUtil.GetStringValue(QuantityUnit.Tonnes);
        // ----------------------------------------------------------------------------------
        // Summary
        // ----------------------------------------------------------------------------------
        #region Summary

        public static void Summery(PollutantReleaseSearchFilter filter, out List<Summary.Quantity> air, out List<Summary.Quantity> water, out List<Summary.Quantity> soil)
        {
            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            
            // apply filter
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(filter, param);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);
            
            var summeryFiltered = db.POLLUTANTRELEASEs.Where(lambda);

            var summery0 = from s in summeryFiltered select new { s.IAActivityCode, s.QuantityAir, s.QuantityWater, s.QuantitySoil };
            var summery1 = from s in summery0 group s by new { s.IAActivityCode };
            var summery2 = from s in summery1
                           select new
                           {
                               code = s.Select(x => x.IAActivityCode).First(),
                               count = s.Count(),
                               sumAir = s.Sum(x => x.QuantityAir),
                               sumWater = s.Sum(x => x.QuantityWater),
                               sumSoil = s.Sum(x => x.QuantitySoil)
                           };

            // fill data
            air = new List<Summary.Quantity>();
            water = new List<Summary.Quantity>();
            soil = new List<Summary.Quantity>();

            double sumAirTotal = 0;
            double sumWaterTotal = 0;
            double sumSoilTotal = 0;

            filter.Count = 0;
            foreach (var v in summery2)
            {
                if (v.sumAir.HasValue && v.sumAir > 0)
                {
                    air.Add(new Summary.Quantity(v.code, v.sumAir));
                    sumAirTotal += v.sumAir.Value;
                }
                if (v.sumWater.HasValue && v.sumWater > 0)
                {
                    water.Add(new Summary.Quantity(v.code, v.sumWater));
                    sumWaterTotal += v.sumWater.Value;
                }
                if (v.sumSoil.HasValue && v.sumSoil > 0)
                {
                    soil.Add(new Summary.Quantity(v.code, v.sumSoil));
                    sumSoilTotal += v.sumSoil.Value;
                }
                filter.Count += (int)v.count;
            }

            // Get top 10 list, sorted by quantity
            air = Summary.GetTop10(air, sumAirTotal);
            water = Summary.GetTop10(water, sumWaterTotal);
            soil = Summary.GetTop10(soil, sumSoilTotal);
        }


        #endregion

        // ----------------------------------------------------------------------------------
        // Activities
        // ----------------------------------------------------------------------------------
        #region Activities
        

        public interface PollutantReleaseRow
        {
            int Facilities{ get; }
            double? QuantityAir { get; }
            double? QuantityWater { get; }
            double? QuantitySoil { get; }
            double? AccidentalAir { get; }
            double? AccidentalWater { get; }
            double? AccidentalSoil { get; }
            string UnitAir { get; }
            string UnitWater { get; }
            string UnitSoil { get; }
        }

        [Serializable]
        public class ActivityTreeListRow : QueryLayer.Utilities.ActivityTreeListRow, PollutantReleaseRow
        {
            public ActivityTreeListRow(string sectorCode, string activityCode, string subActivityCode,
                          string pollutantCode,  
                          int facilities, int accidentalFacilities,
                          double? quantityAir, double? accidentalAir,
                          double? quantityWater, double? accidentalWater,
                          double? quantitySoil, double? accidentalSoil,
                          bool hasChildren)
                : base(sectorCode, activityCode, subActivityCode, hasChildren)
            {
                this.PollutantCode = pollutantCode;
                this.Facilities = facilities;
                this.AccidentalFacilities = accidentalFacilities;

                this.QuantityAir = quantityAir;
                this.QuantityWater = quantityWater;
                this.QuantitySoil = quantitySoil;

                this.AccidentalAir = accidentalAir;
                this.AccidentalWater = accidentalWater;
                this.AccidentalSoil = accidentalSoil;

                //pollutant releases are always reported in kg
                this.UnitAir = CODE_KG;
                this.UnitWater = CODE_KG;
                this.UnitSoil = CODE_KG;
                // this.UnitAir = CODE_TNE;
                //this.UnitWater = CODE_TNE;
                 //this.UnitSoil = CODE_TNE;
            }

            public int Facilities { get; internal set; }
            public int AccidentalFacilities { get; internal set; }

            public string PollutantCode { get; private set; }

            public double? QuantityAir { get; private set; }
            public double? QuantityWater { get; private set; }
            public double? QuantitySoil { get; private set; }

            public double? AccidentalAir { get; private set; }
            public double? AccidentalWater { get; private set; }
            public double? AccidentalSoil { get; private set; }

            public string UnitAir { get; private set; }
            public string UnitWater { get; private set; }
            public string UnitSoil { get; private set; }

        }


        /// <summary>
        /// get lambda for pollutant transfers
        /// </summary>
        private static Expression<Func<POLLUTANTRELEASE, bool>> getActivityAreaLambda(PollutantReleaseSearchFilter filter)
        {
            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(filter, param);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);
            return lambda;
        }

        /// <summary>
        /// return full activity tree with all rows expanded
        /// </summary>
        public static IEnumerable<ActivityTreeListRow> GetActivityTree(PollutantReleaseSearchFilter filter)
        {
            IEnumerable<ActivityTreeListRow> sectors = GetSectors(filter).ToList();

            List<string> sectorCodes = sectors.Where(p => p.HasChildren).Select(p => p.SectorCode).ToList();
            IEnumerable<ActivityTreeListRow> activities = GetActivities(filter, sectorCodes).ToList();

            List<string> activityCodes = activities.Where(p => p.HasChildren).Select(p => p.ActivityCode).ToList();
            IEnumerable<ActivityTreeListRow> subactivities = GetSubActivities(filter, activityCodes).ToList();

            //create result with full tree
            IEnumerable<ActivityTreeListRow> result = sectors.Union(activities).Union(subactivities)
                                                               .OrderBy(s => s.SectorCode)
                                                               .ThenBy(s => s.ActivityCode)
                                                               .ThenBy(s => s.SubactivityCode);

            return result; 
        }

        /// <summary>
        /// return all sectors that fullfill search criteria
        /// </summary>
        public static IEnumerable<ActivityTreeListRow> GetSectors(PollutantReleaseSearchFilter filter)
        {
            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = getActivityAreaLambda(filter);


            //find data for sector level. Sector level always has children.
            IEnumerable<ActivityTreeListRow> sectors = db.POLLUTANTRELEASEs.Where(lambda)
                                                     .GroupBy(p => new { SectorCode = p.IASectorCode, PollutantCode = p.PollutantCode })
                                                     .Select(x => new ActivityTreeListRow(
                                                         x.Key.SectorCode,
                                                         null,
                                                         null,
                                                         x.Key.PollutantCode,
                                                         x.Count(),
                                                         x.Count(z => z.QuantityAccidentalAir > 0 || z.QuantityAccidentalSoil > 0 || z.QuantityAccidentalWater > 0),
                                                         x.Sum(p => p.QuantityAir),
                                                         x.Sum(p => p.QuantityAccidentalAir),
                                                         x.Sum(p => p.QuantityWater),
                                                         x.Sum(p => p.QuantityAccidentalWater),
                                                         x.Sum(p => p.QuantitySoil),
                                                         x.Sum(p => p.QuantityAccidentalSoil),
                                                         true));


            List<ActivityTreeListRow> result = sectors.ToList(); //make sure sql is executed now to do it only once

            List<ActivityTreeListRow>totals = result.GroupBy(p => new { PollutantCode = p.PollutantCode })
                                             .Select(x => new ActivityTreeListRow(
                                                 ActivityTreeListRow.CODE_TOTAL,
                                                 null,
                                                 null,
                                                 x.Key.PollutantCode,
                                                 x.Sum(p => p.Facilities),
                                                 x.Sum(p => p.AccidentalFacilities),
                                                 x.SumOrNull(p => p.QuantityAir),
                                                 x.SumOrNull(p => p.AccidentalAir),
                                                 x.SumOrNull(p => p.QuantityWater),
                                                 x.SumOrNull(p => p.AccidentalWater),
                                                 x.SumOrNull(p => p.QuantitySoil),
                                                 x.SumOrNull(p => p.AccidentalSoil),
                                                 false)).ToList();


            //only add total to result if more than one sector.
            if (result.Select(r => r.SectorCode).Distinct().Count() > 1)
            {
                result.AddRange(totals);
            }

            //find facility count
            int facilityCount = 0;
            if (result.Count == 1)
            {
                facilityCount = result.Single().Facilities;
            }
            else if (totals.Count == 1)
            {
                facilityCount = totals.Single().Facilities;
            }
            else
            {
                facilityCount = GetFacilityCount(filter);
            }

            filter.Count = facilityCount;

            return result;
        }

        /// <summary>
        /// return all activities (level 1) that fullfill search criteria within the sectorCodes given. 
        /// If sectorCodes are null, all activities will be returned. If sectorCodes is empty no activities will be returned.
        /// </summary>
        public static IEnumerable<ActivityTreeListRow> GetActivities(PollutantReleaseSearchFilter filter, List<string> sectorCodes)
        {
            if (sectorCodes != null && sectorCodes.Count() == 0)
                return new List<ActivityTreeListRow>();

            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = getActivityAreaLambda(filter);

            if (sectorCodes != null)
            {
                ParameterExpression param = lambda.Parameters[0];
                Expression sectorExp = LinqExpressionBuilder.GetInExpr(param, "IASectorCode", sectorCodes);

                Expression exp = LinqExpressionBuilder.CombineAnd(lambda.Body, sectorExp);
                lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);
            }

            //find data for activity level
            IEnumerable<ActivityTreeListRow> activities = db.POLLUTANTRELEASEs.Where(lambda)
                                         .GroupBy(p => new { SectorCode = p.IASectorCode, ActivityCode = p.IAActivityCode, PollutantCode = p.PollutantCode })
                                         .Select(x => new ActivityTreeListRow(
                                             x.Key.SectorCode,
                                             x.Key.ActivityCode,
                                             null,
                                             x.Key.PollutantCode,
                                             x.Count(),
                                             x.Count(z => z.QuantityAccidentalAir > 0 || z.QuantityAccidentalSoil > 0 || z.QuantityAccidentalWater > 0),
                                             x.Sum(p => p.QuantityAir),
                                             x.Sum(p => p.QuantityAccidentalAir),
                                             x.Sum(p => p.QuantityWater),
                                             x.Sum(p => p.QuantityAccidentalWater),
                                             x.Sum(p => p.QuantitySoil),
                                             x.Sum(p => p.QuantityAccidentalSoil),
                                             x.First(p => !p.IASubActivityCode.Equals(null)) != null));

            return activities;
        }

        /// <summary>
        /// Return all subactivities (level 2) that fullfill search criteria. 
        /// If activityCodes are null, all activities will be returned. If activityCodes is empty no activities will be returned.
        /// Notice that this will include one subactivity "Not specified on this level" for each activity, even if the activity do not have any subactivities at all!
        /// </summary>
        public static IEnumerable<ActivityTreeListRow> GetSubActivities(PollutantReleaseSearchFilter filter, List<string> activityCodes)
        {
            if (activityCodes != null && activityCodes.Count() == 0)
                return new List<ActivityTreeListRow>();

            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = getActivityAreaLambda(filter);

            //add activities to expression
            if (activityCodes != null)
            {
                ParameterExpression param = lambda.Parameters[0];
                Expression activityExp = LinqExpressionBuilder.GetInExpr(param, "IAActivityCode", activityCodes);

                Expression exp = LinqExpressionBuilder.CombineAnd(lambda.Body, activityExp);
                lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);
            }

            //find data for sub-activity level, this level never has children.

            IEnumerable<ActivityTreeListRow> subactivities = db.POLLUTANTRELEASEs.Where(lambda)
                                         .GroupBy(p => new { SectorCode = p.IASectorCode, ActivityCode = p.IAActivityCode, SubActivityCode = p.IASubActivityCode, PollutantCode = p.PollutantCode })
                                         .Select(x => new ActivityTreeListRow(
                                             x.Key.SectorCode,
                                             x.Key.ActivityCode,
                                             !x.Key.SubActivityCode.Equals(null) ? x.Key.SubActivityCode : ActivityTreeListRow.CODE_UNSPECIFIED,
                                             x.Key.PollutantCode,
                                             x.Count(),
                                             x.Count(z => z.QuantityAccidentalAir > 0 || z.QuantityAccidentalSoil > 0 || z.QuantityAccidentalWater > 0),
                                             x.Sum(p => p.QuantityAir),
                                             x.Sum(p => p.QuantityAccidentalAir),
                                             x.Sum(p => p.QuantityWater),
                                             x.Sum(p => p.QuantityAccidentalWater),
                                             x.Sum(p => p.QuantitySoil),
                                             x.Sum(p => p.QuantityAccidentalSoil),
                                             false));

            return subactivities; 
        }


        /// <summary>
        /// Find all reported pollutant codes fullfilling the filter
        /// </summary>
        public static List<string> GetPollutantCodes(PollutantReleaseSearchFilter filter)
        {
            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = getActivityAreaLambda(filter);

            //distinct pollutants
            List<string> codes = db.POLLUTANTRELEASEs.Where(lambda)
                                    .Select(r => r.PollutantCode).Distinct().ToList();

            return codes;
        }

        #endregion

        // ----------------------------------------------------------------------------------
        // Area
        // ----------------------------------------------------------------------------------
        #region Area

        [Serializable]
        public class ReleasesTreeListRow : TreeListRow, PollutantReleaseRow
        {
            public ReleasesTreeListRow(string code, string parentCode,
                          int facilities, int facilitiesAccidental,
                          double? quantityAir, double? accidentalAir,
                          double? quantityWater, double? accidentalWater,
                          double? quantitySoil, double? accidentalSoil,
                          int level, bool hasChildren)
                : base(code, parentCode, level, hasChildren)
            {
                this.Facilities = facilities;
                this.AccidentalFacilities = facilitiesAccidental;
                     
                this.QuantityAir = quantityAir;
                this.QuantityWater = quantityWater;
                this.QuantitySoil = quantitySoil;

                this.AccidentalAir = accidentalAir;
                this.AccidentalWater = accidentalWater;
                this.AccidentalSoil = accidentalSoil;

                //pollutant releases are always reported in kg
                this.UnitAir = CODE_KG;
                this.UnitWater = CODE_KG;
                this.UnitSoil = CODE_KG;
               // this.UnitAir = CODE_TNE;
                //this.UnitWater = CODE_TNE;
                //this.UnitSoil = CODE_TNE;
            }

            public int Facilities { get; internal set; }
            public int AccidentalFacilities { get; internal set; }

            public double? QuantityAir { get; private set; }
            public double? QuantityWater { get; private set; }
            public double? QuantitySoil { get; private set; }

            public double? AccidentalAir { get; private set; }
            public double? AccidentalWater { get; private set; }
            public double? AccidentalSoil { get; private set; }

            public string UnitAir { get; private set; }
            public string UnitWater { get; private set; }
            public string UnitSoil { get; private set; }

        }


        /// <summary>
        /// get areas
        /// </summary>
        private static List<ReleasesTreeListRow> getAreas(DataClassesPollutantReleaseDataContext db, Expression<Func<POLLUTANTRELEASE, bool>> lambda, out int facilitiesCount)
        {
            int level = 0;
            bool hasChildren = true; //country level always has children.

            //The parent code is set to the code itself on grounds of later sorting.
            IEnumerable<ReleasesTreeListRow> data = db.POLLUTANTRELEASEs.Where(lambda)
                                                     .GroupBy(p => p.CountryCode)
                                                     .OrderBy(x => x.Key)
                                                     .Select(x => new ReleasesTreeListRow(
                                                         x.Key,
                                                         x.Key,
                                                         x.Count(),
                                                         x.Count(z => z.QuantityAccidentalAir > 0 || z.QuantityAccidentalSoil > 0 || z.QuantityAccidentalWater > 0),
                                                         x.Sum(p => p.QuantityAir),
                                                         x.Sum(p => p.QuantityAccidentalAir),
                                                         x.Sum(p => p.QuantityWater),
                                                         x.Sum(p => p.QuantityAccidentalWater),
                                                         x.Sum(p => p.QuantitySoil),
                                                         x.Sum(p => p.QuantityAccidentalSoil),
                                                         level,
                                                         hasChildren));

            List<ReleasesTreeListRow> result = data.ToList(); //make sure sql is executed now to do it only once

            //Facilites can be summed since each facility only belongs to one country

            ReleasesTreeListRow total = result.GroupBy(p => 1)
                                             .Select(x => new ReleasesTreeListRow(
                                                 ReleasesTreeListRow.CODE_TOTAL,
                                                 null,
                                                 x.Sum(p => p.Facilities),
                                                 x.Sum(p => p.AccidentalFacilities),
                                                 x.SumOrNull(p => p.QuantityAir),
                                                 x.SumOrNull(p => p.AccidentalAir),
                                                 x.SumOrNull(p => p.QuantityWater),
                                                 x.SumOrNull(p => p.AccidentalWater),
                                                 x.SumOrNull(p => p.QuantitySoil),
                                                 x.SumOrNull(p => p.AccidentalSoil),
                                                 level,
                                                 false)).SingleOrDefault();


            facilitiesCount = total != null ? total.Facilities : 0;

            //only add total to result if more than one row.
            if (result.Count() > 1)
            {
                result.Add(total);
            }

            return result;

        }


        /// <summary>
        /// get sub areas
        /// </summary>
        private static List<ReleasesTreeListRow> getSubAreas(DataClassesPollutantReleaseDataContext db, string countryCode, Expression<Func<POLLUTANTRELEASE, bool>> lambda, AreaFilter.RegionType regionType)
        {
            int level = 1;
            bool hasChildren = false; //subarea level never has children.
            string code_unknown = regionType == AreaFilter.RegionType.RiverBasinDistrict ? ReleasesTreeListRow.CODE_UNKNOWN : null;

            IEnumerable<ReleasesTreeListRow> data = db.POLLUTANTRELEASEs.Where(lambda).Where(p => p.CountryCode == countryCode)
                                         .GroupBy(regionType)
                                         .OrderBy(x => x.Key.Code.Equals(code_unknown))
                                         .ThenBy(x => x.Key.Code)
                                         .Select(x => new ReleasesTreeListRow(
                                             !x.Key.Code.Equals(null) ? x.Key.Code : ReleasesTreeListRow.CODE_UNKNOWN,
                                             x.Key.ParentCode,
                                             x.Count(),
                                             x.Count(z => z.QuantityAccidentalAir > 0 || z.QuantityAccidentalSoil > 0 || z.QuantityAccidentalWater > 0),
                                             x.Sum(p => p.QuantityAir),
                                             x.Sum(p => p.QuantityAccidentalAir),
                                             x.Sum(p => p.QuantityWater),
                                             x.Sum(p => p.QuantityAccidentalWater),
                                             x.Sum(p => p.QuantitySoil),
                                             x.Sum(p => p.QuantityAccidentalSoil),
                                             level,
                                             hasChildren));

            List<ReleasesTreeListRow> result = data.ToList();

            return result;

        }


        /// <summary>
        /// return total list of areas
        /// </summary>
        public static List<ReleasesTreeListRow> GetArea(PollutantReleaseSearchFilter filter)
        {
            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = getActivityAreaLambda(filter);
            int facilitiesCount = 0;
            List<ReleasesTreeListRow> areas = getAreas(db, lambda, out facilitiesCount);
            filter.Count = facilitiesCount;
            return areas;
        }

        /// <summary>
        /// return expanded tree according to expandrows input
        /// </summary>
        public static List<ReleasesTreeListRow> GetAreaTree(Dictionary<string, bool> expandRows, PollutantReleaseSearchFilter filter, List<ReleasesTreeListRow> areasOrg)
        {
            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = getActivityAreaLambda(filter);

            // only fill from db if areasOrg==null
            List<ReleasesTreeListRow> areas = null;
            if (areasOrg != null)
            {
                areas = new List<ReleasesTreeListRow>();
                areas.AddRange(areasOrg);
            }
            else
            {
                int facilitiesCount = 0;
                areas = getAreas(db, lambda, out facilitiesCount);
                filter.Count = facilitiesCount;
            }

            foreach (ReleasesTreeListRow a in areas)
            {
                a.IsExpanded = false;
            }

                        
            foreach (KeyValuePair<string, bool> kvp in expandRows)
            {
                // if not expanded goto next
                if (!kvp.Value) continue;

                // expanded, find in list (search all nodes)
                int row = 0;
                foreach (ReleasesTreeListRow s in areas)
                {
                    string code = (s.Code != null) ? s.Code.ToString() : String.Empty;
                    if (code == kvp.Key)
                    {
                        s.IsExpanded = true;
                        // find sub area
                        List<ReleasesTreeListRow> activities = getSubAreas(db, code, lambda, filter.AreaFilter.TypeRegion);
                        // insert area
                        foreach (ReleasesTreeListRow a in activities)
                        {
                            areas.Insert(row + 1, a);
                            row++;
                        }
                        break;
                    }
                    row++;
                }
            }

            return areas;

        }
        #endregion

        // ----------------------------------------------------------------------------------
        // AreaComparison
        // ----------------------------------------------------------------------------------
        #region AreaComparison
        [Serializable]
        public class AreaComparison
        {
            public AreaComparison(string area, double? quantity, int facilities)
            {
                this.Area = area;
                this.Quantity = quantity; 
                this.Facilities = facilities;
            }
            public string Area { get; set; }
            public double? Quantity { get; private set; }
            public double? Percent { get; internal set; }
            public int Facilities { get; private set; }
        }

        
        /// <summary>
        /// GetAreaComparison for a specific medium
        /// </summary>
        public static List<AreaComparison> GetAreaComparison(PollutantReleaseSearchFilter filter, MediumFilter.Medium medium)
        {
            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();

            // apply filter
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(filter, param);

            //apply medium condition
            Expression expMedium = LinqExpressionBuilder.GetLinqExpressionMediumRelease(medium, param);
            if (exp != null)
                exp = Expression.And(exp, expMedium);

            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);

            IQueryable<IGrouping<TreeListRowGroupByKey, POLLUTANTRELEASE>> group = db.POLLUTANTRELEASEs.Where(lambda)
                                                                    .GroupBy(filter.AreaFilter);

            IEnumerable<AreaComparison> data = null;

            switch (medium)
            {
                case MediumFilter.Medium.Air:
                    data = group.Select(x => new AreaComparison(
                                        x.Key.Code,
                                        x.Sum(p => p.QuantityAir),
                                        x.Count()));
                    break;
                case MediumFilter.Medium.Soil:
                    data = group.Select(x => new AreaComparison(
                                        x.Key.Code,
                                        x.Sum(p => p.QuantitySoil),
                                        x.Count()));
                    break;
                case MediumFilter.Medium.Water:
                    data = group.Select(x => new AreaComparison(
                                        x.Key.Code,
                                        x.Sum(p => p.QuantityWater),
                                        x.Count()));
                    break;
                default:
                    throw new ArgumentOutOfRangeException("medium", String.Format("Illegal medium: {0}", medium.ToString()));
            }
            
            //Make sure sql is executed now and ordered by size
            List<AreaComparison> result = data.OrderBy(p => p.Quantity).ToList();

            //Calculate percentages
            double? tot = result.SumOrNull(p => p.Quantity);
            if (tot > 0)
            {
                foreach (AreaComparison ac in result)
                    ac.Percent = (ac.Quantity / tot) * 100.0;
            }

            return result;
        }

        #endregion

        // ----------------------------------------------------------------------------------
        // Facilities
        // ----------------------------------------------------------------------------------
        #region Facilities

        public class ResultFacility
        {
            // public properties
            public string FacilityName { get; private set; }
            public double? QuantityTotal { get; private set; }
            public double? QuantityAccidental { get; private set; }
            public string QuantityTotalUnit { get; private set; }
            public string QuantityAccidentalUnit { get; private set; }
            public double? PercentageAccidental { get; private set; }
            public string ActivityCode { get; private set; }
            public string CountryCode { get; private set; }
            public int FacilityReportId { get; private set; }
            public string Unit { get; private set; }
            public bool ConfidentialIndicatorFacility { get; private set; }
            public bool ConfidentialIndicator { get; private set; }

            public ResultFacility(int facilityReportId, string facilityName, double? quantityTotal, double? quantityAccidental, double? percent, string activityCode, string countryCode, bool confidentialFacilitity, bool confidential)
            {
                this.FacilityReportId = facilityReportId;
                this.FacilityName = facilityName;
                this.QuantityTotal = quantityTotal;
                this.QuantityAccidental = quantityAccidental;
                this.PercentageAccidental = percent;
                this.ActivityCode = activityCode;
                this.CountryCode = countryCode;
                this.ConfidentialIndicatorFacility = confidentialFacilitity;
                this.ConfidentialIndicator = confidential;
                this.Unit = CODE_KG; //pollutant releases are always reported in kgs
                //this.Unit = CODE_TNE; //pollutant releases are always reported in toneladas
            }

        }


        public class ResultFacilityCSV
        {
            // public properties
            public int FacilityId { get; private set; }
            public string FacilityName { get; private set; }
            public double? QuantityTotal { get; private set; }
            public double? QuantityAccidental { get; private set; }
            public string QuantityTotalUnit { get; private set; }
            public string QuantityAccidentalUnit { get; private set; }
            public double? PercentageAccidental { get; private set; }
            public string ActivityCode { get; private set; }
            public string CountryCode { get; private set; }
            public int FacilityReportId { get; private set; }
            public string Unit { get; private set; }
            public bool ConfidentialIndicatorFacility { get; private set; }
            public bool ConfidentialIndicator { get; private set; }
            public string Url;

            public ResultFacilityCSV(int facilityReportId, int facilityId, string facilityName, double? quantityTotal, double? quantityAccidental, double? percent, string activityCode, string countryCode, bool confidentialFacilitity, bool confidential)
            {
                this.FacilityReportId = facilityReportId;
                this.FacilityId = facilityId;
                this.FacilityName = facilityName;
                this.QuantityTotal = quantityTotal;
                this.QuantityAccidental = quantityAccidental;
                this.PercentageAccidental = percent;
                this.ActivityCode = activityCode;
                this.CountryCode = countryCode;
                this.ConfidentialIndicatorFacility = confidentialFacilitity;
                this.ConfidentialIndicator = confidential;
                this.Unit = CODE_KG; //pollutant releases are always reported in kgs
                //this.Unit = CODE_TNE; //pollutant releases are always reported in toneladas
            }

        }

        /// <summary>
        /// Returns the number of facilities corresponding to the filter. Always use POLLUTANTRELEASE table, since it has the fewest records.
        /// </summary>
        public static int GetFacilityCount(PollutantReleaseSearchFilter filter)
        {
            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(filter, param);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);

            //find total no. of facilities. 
            int count = db.POLLUTANTRELEASEs
                                .Where(lambda)
                                .Select<POLLUTANTRELEASE, int>(d => (int)d.FacilityReportID).Distinct()
                                .Count();

            return count;
        }


        /// <summary>
        /// Returns the number of facilities for each medium type. 
        /// </summary>
        public static FacilityCountObject GetFacilityCounts(PollutantReleaseSearchFilter filter)
        {
            
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(filter, param);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);

            var count = GetFacilityCounts(lambda, filter.MediumFilter);
            
            return count;
        }

        internal static FacilityCountObject GetFacilityCounts(Expression<Func<POLLUTANTRELEASE, bool>> lambda, Filters.MediumFilter mediumFilter)
        {
            var db = getPollutantReleaseDataContext();

            var count = new FacilityCountObject();

            if (mediumFilter == null || mediumFilter.ReleasesToAir)
            {
                count.Air = db.POLLUTANTRELEASEs
                    .Where(lambda).Where(x => x.QuantityAir != null)
                    .Select(x => x.FacilityID).Distinct().Count();
            }

            if (mediumFilter == null || mediumFilter.ReleasesToWater)
            {
                count.Water = db.POLLUTANTRELEASEs
                    .Where(lambda).Where(x => x.QuantityWater != null)
                    .Select(x => x.FacilityID).Distinct().Count();
            }

            if (mediumFilter == null || mediumFilter.ReleasesToSoil)
            {
                count.Soil = db.POLLUTANTRELEASEs
                   .Where(lambda).Where(x => x.QuantitySoil != null)
                   .Select(x => x.FacilityID).Distinct().Count();
            }
            count.WasteWater = 0;
            return count;
        }


        public class FacilityCountObject
        {
            internal FacilityCountObject()
            {
            }
            public FacilityCountObject(int air, int water, int soil, int wasteWater)
            {
                this.Air = air;
                this.Water = water;
                this.Soil = soil;
                this.WasteWater = wasteWater;
            }

            public int? Air { get; internal set; }
            public int? Water { get; internal set; }
            public int? Soil { get; internal set; }
            public int? WasteWater { get; internal set; }
        }
        
        /// <summary>
        /// Generates facility list for Pollutant Release search results
        /// </summary>
        /// <param name="filter">Holds the search criteria</param>
        /// <param name="sortColumn">Specifies the column used for sorting</param>
        /// <param name="descending">Indicate whether sorting is descending</param>
        /// <param name="startRowIndex">Starting index for paging</param>
        /// <param name="pagingSize">Determines the number of rows displayed on each page of the list.</param>
        /// <param name="selectedMedium">Specifies which medium the user has chosen.</param>
        /// <returns></returns>
        public static object FacilityList(PollutantReleaseSearchFilter filter, string sortColumn, bool descending, int startRowIndex, int pagingSize, MediumFilter.Medium? selectedMedium)
        {
            List<ResultFacility> result = new List<ResultFacility>();
            filter.Count = GetFacilityCount(filter);

            //create filter for selected medium.
            PollutantReleaseSearchFilter customFilter = filter.Clone() as PollutantReleaseSearchFilter;
            customFilter.MediumFilter = new MediumFilter();

            switch (selectedMedium)
            {
                case MediumFilter.Medium.Air:
                    customFilter.MediumFilter.ReleasesToAir = true;
                    break;
                case MediumFilter.Medium.Water:
                    customFilter.MediumFilter.ReleasesToWater = true;
                    break;
                case MediumFilter.Medium.Soil:
                    customFilter.MediumFilter.ReleasesToSoil = true;
                    break;
                default:
                    customFilter = null;
                    break;
            }

            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            IEnumerable<ResultFacility> data = null;

            if (customFilter != null)
            {
                //create lambda expression
                ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");
                Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(customFilter, param);
                Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);

                //table has only one row per pollutant per facility so distinct or aggregations is not needed.

                // set the number of found rows for this filter
                customFilter.Count = db.POLLUTANTRELEASEs.
                                    Where(lambda).Select(d => d.FacilityReportID).Count();

                //get data of correct type
                if (customFilter.Count > 0)
                {
                    data = db.POLLUTANTRELEASEs
                                   .Where(lambda)
                                   .orderBy(sortColumn, descending)
                                   .Skip(startRowIndex).Take(pagingSize)
                                   .Select<POLLUTANTRELEASE, ResultFacility>(v => new ResultFacility(
                                       (int)v.FacilityReportID,
                                       v.FacilityName,
                                       getQuantity(selectedMedium)(v),
                                       getAccidental(selectedMedium)(v), 
                                       getPercentage(selectedMedium)(v),
                                       v.IAActivityCode,
                                       v.CountryCode,
                                       v.ConfidentialIndicatorFacility,
                                       v.ConfidentialIndicator
                                       ));
                }

                //add rows to result. Speedup paging by adding empty rows at the start and end of list.
                for (int i = 0; i < startRowIndex; i++)
                    result.Add(null);

                if (data != null)
                    result.AddRange(data);

                int addcount = result.Count;
                for (int i = 0; i < customFilter.Count - addcount; i++)
                    result.Add(null);

            }


            return result;
        }


        public static IEnumerable<ResultFacilityCSV> GetFacilityListCSV(PollutantReleaseSearchFilter filter, MediumFilter.Medium? selectedMedium)
        {
            //create filter for selected medium.
            PollutantReleaseSearchFilter customFilter = filter.Clone() as PollutantReleaseSearchFilter;

            customFilter.MediumFilter = new MediumFilter(selectedMedium == null ? MediumFilter.Medium.Air : (MediumFilter.Medium)selectedMedium);

            //create lambda expression
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(customFilter, param);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);

            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();
            IEnumerable<ResultFacilityCSV> data = db.POLLUTANTRELEASEs
                .Where(lambda)
                .Select<POLLUTANTRELEASE, ResultFacilityCSV>(v => new ResultFacilityCSV(
                    (int)v.FacilityReportID,
                    v.FacilityID,
                    v.FacilityName, 
                    getQuantity(selectedMedium)(v),
                    getAccidental(selectedMedium)(v),
                    getPercentage(selectedMedium)(v),
                    v.IAActivityCode,
                    v.CountryCode,
                    v.ConfidentialIndicatorFacility,
                    v.ConfidentialIndicator
                   ));

            return data;
        }



        //function to select the rigth Quantity property depenedend on medium
        private static Func<POLLUTANTRELEASE, double?> getQuantity(MediumFilter.Medium? medium)
        {
            Expression<Func<POLLUTANTRELEASE, double?>> func = s => null;

            switch (medium)
            {
                case MediumFilter.Medium.Air:
                    func = s => s.QuantityAir;
                    break;
                case MediumFilter.Medium.Water:
                    func = s => s.QuantityWater;
                    break;
                case MediumFilter.Medium.Soil:
                    func = s => s.QuantitySoil;
                    break;
                default:
                    throw new ArgumentOutOfRangeException("medium", "Illegal medium");
            }

            return func.Compile();
        }


        //function to select the rigth Accidental property depenedend on medium
        private static Func<POLLUTANTRELEASE, double?> getAccidental(MediumFilter.Medium? medium)
        {
            Expression<Func<POLLUTANTRELEASE, double?>> func = s => null;

            switch (medium)
            {
                case MediumFilter.Medium.Air:
                    func = s => s.QuantityAccidentalAir;
                    break;
                case MediumFilter.Medium.Water:
                    func = s => s.QuantityAccidentalWater;
                    break;
                case MediumFilter.Medium.Soil:
                    func = s => s.QuantityAccidentalSoil;
                    break;
                default:
                    throw new ArgumentOutOfRangeException("medium", "Illegal medium");
            }

            return func.Compile();
        }

        //function to select the rigth percentage property depenedend on medium
        private static Func<POLLUTANTRELEASE, double?> getPercentage(MediumFilter.Medium? medium)
        {
            Expression<Func<POLLUTANTRELEASE, double?>> func = s => null;

            switch (medium)
            {
                case MediumFilter.Medium.Air:
                    func = s => s.PercentAccidentalAir;
                    break;
                case MediumFilter.Medium.Water:
                    func = s => s.PercentAccidentalWater;
                    break;
                case MediumFilter.Medium.Soil:
                    func = s => s.PercentAccidentalSoil;
                    break;
                default:
                    throw new ArgumentOutOfRangeException("medium", "Illegal medium");
            }

            return func.Compile();
        }


        #endregion
                        
        // ----------------------------------------------------------------------------------
        // Confidential
        // ----------------------------------------------------------------------------------
        #region Confidential

        public class ConfidentialTotal
        {
            private string code;
            public ConfidentialTotal(string code) 
            {
                this.code = code;
            }

            public string Code
            {
                get { return this.code; }
            }
            public int FacilitiesAir { get; set; }
            public int FacilitiesWater { get; set; }
            public int FacilitiesSoil { get; set; }
        }
        
        public class ConfidentialPollutant
        {
            private string code;
            private double quantityAir;
            private double quantityWater;
            private double quantitySoil;
            
            public ConfidentialPollutant(string code, double? quantityAir, double? quantityWater, double? quantitySoil)
            {
                this.code = code;
                this.quantityAir = quantityAir.HasValue ? quantityAir.Value : -1;
                this.quantityWater = quantityWater.HasValue ? quantityWater.Value : -1;
                this.quantitySoil = quantitySoil.HasValue ? quantitySoil.Value : -1;
            }

            public string Code { get { return this.code; } }
            public double QuantityAir { get { return this.quantityAir; } }
            public double QuantityWater { get { return this.quantityWater; } }
            public double QuantitySoil { get { return this.quantitySoil; } }
        }


        public class ConfidentialReason
        {
            private string codeAir, codeWater, codeSoil;
            private double quantityAir;
            private double quantityWater;
            private double quantitySoil;

            public ConfidentialReason(string codeAir, string codeWater, string codeSoil, double? quantityAir, double? quantityWater, double? quantitySoil)
            {
                this.codeAir = codeAir;
                this.codeSoil = codeSoil;
                this.codeWater = codeWater;

                this.quantityAir = quantityAir.HasValue ? quantityAir.Value : -1;
                this.quantityWater = quantityWater.HasValue ? quantityWater.Value : -1;
                this.quantitySoil = quantitySoil.HasValue ? quantitySoil.Value : -1;
            }

            public string CodeAir { get { return this.codeAir; } }
            public string CodeWater { get { return this.codeWater; } }
            public string CodeSoil { get { return this.codeSoil; } }
            public double QuantityAir { get { return this.quantityAir; } }
            public double QuantityWater { get { return this.quantityWater; } }
            public double QuantitySoil { get { return this.quantitySoil; } }
        }
        
        
        /// <summary>
        /// return total list confidential pollutants
        /// </summary>
        public static IEnumerable<ConfidentialTotal> GetConfidentialPollutant(PollutantReleaseSearchFilter filter)
        {
            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();

            // create expression and new lambda. Include pollutant itself.
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleasesConfidential(filter, param, true);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);
            
            // fetch data according to filter
            var pollutant0 = db.POLLUTANTRELEASEs.Where(lambda);
            
            // pick what we need
            var pollutant1 = from c in pollutant0 
                             select new 
                             { 
                                 c.PollutantCode,
                                 c.FacilityName,
                                 c.QuantityAir,
                                 c.QuantityWater,
                                 c.QuantitySoil
                             };

            // get all pollutants 
            List<ConfidentialPollutant> pollutants = new List<ConfidentialPollutant>();
            foreach (var v in pollutant1)
                pollutants.Add(new ConfidentialPollutant(v.PollutantCode, v.QuantityAir, v.QuantityWater, v.QuantitySoil));  
            
            // final result
            List<ConfidentialTotal> final = new List<ConfidentialTotal>();
            
            // select distinct list of pollutnat codes
            IEnumerable<string> pollutantcodes = (from p in pollutants select p.Code).Distinct();
            foreach (string s in pollutantcodes)
            {
                ConfidentialTotal ct = new ConfidentialTotal(s);
                                
                // count up reported facilities according to quantity number.
                foreach (ConfidentialPollutant cp in pollutants)
                {
                    if (cp.Code.Equals(s))
                    {
                        if (cp.QuantityAir >= 0) ct.FacilitiesAir++;
                        if (cp.QuantityWater >= 0) ct.FacilitiesWater++;
                        if (cp.QuantitySoil >= 0) ct.FacilitiesSoil++;
                    }
                }

                final.Add(ct);
            }
            return final;
        }


        /// <summary>
        /// return total list confidential reasons
        /// </summary>
        public static IEnumerable<ConfidentialTotal> GetConfidentialReason(PollutantReleaseSearchFilter filter)
        {
            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();

            // create expression and new lambda. Only include confidential group - not ppollutant itself
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleasesConfidential(filter, param, false);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);
            
            // fetch data according to filter
            var reason0 = db.POLLUTANTRELEASEs.Where(lambda);
            
            // pick what we need
            var reason1 = from c in reason0 
                             select new 
                             { 
                                 c.ConfidentialCodeAir,
                                 c.ConfidentialCodeWater,
                                 c.ConfidentialCodeSoil,
                                 c.QuantityAir,
                                 c.QuantityWater,
                                 c.QuantitySoil
                             };


            // get all reasons 
            List<ConfidentialReason> reasons = new List<ConfidentialReason>();
            foreach (var v in reason1)
                reasons.Add(new ConfidentialReason(v.ConfidentialCodeAir, v.ConfidentialCodeWater, v.ConfidentialCodeSoil, v.QuantityAir, v.QuantityWater, v.QuantitySoil));

            // final result
            List<ConfidentialTotal> final = new List<ConfidentialTotal>();
            
            // Count up reported facilities according to quantity number.
            // Count for Air
            int count = 0;
            IEnumerable<string> reasonsAir = (from p in reasons select p.CodeAir).Distinct();
            foreach (string s in reasonsAir)
            {
                if (s == null) continue;
                count = 0;
                foreach (ConfidentialReason cr in reasons)
                {
                    if (!String.IsNullOrEmpty(cr.CodeAir) && cr.CodeAir.Equals(s) && cr.QuantityAir >= 0)
                        count++;
                }
                AddRowToConfidentialReason(final, s, count, 0, 0);
            }
            // Count for Water
            IEnumerable<string> reasonsWater = (from p in reasons select p.CodeWater).Distinct();
            foreach (string s in reasonsWater)
            {
                if (s == null) continue;
                count = 0;
                foreach (ConfidentialReason cr in reasons)
                {
                    if (!String.IsNullOrEmpty(cr.CodeWater) && cr.CodeWater.Equals(s) && cr.QuantityWater >= 0)
                        count++;
                }
                AddRowToConfidentialReason(final, s, 0, count, 0);
            }
            // Count for Soil
            IEnumerable<string> reasonsSoil = (from p in reasons select p.CodeSoil).Distinct();
            foreach (string s in reasonsSoil)
            {
                if (s == null) continue;
                count = 0;
                foreach (ConfidentialReason cr in reasons)
                {
                    if (!String.IsNullOrEmpty(cr.CodeSoil) && cr.CodeSoil.Equals(s) && cr.QuantitySoil >=0)
                        count++;
                }
                AddRowToConfidentialReason(final, s, 0, 0, count);
            }
        
            return final.OrderBy(x => x.Code);
        }

        /// <summary>
        /// Add row to confidential reason
        /// </summary>
        private static void AddRowToConfidentialReason(List<ConfidentialTotal> final, string code, int countAir, int countWater, int countSoil)
        {
            foreach (ConfidentialTotal ct in final)
            {
                if (ct.Code.Equals(code))
                {
                    ct.FacilitiesAir += countAir;
                    ct.FacilitiesWater += countWater;
                    ct.FacilitiesSoil += countSoil;
                    return;
                }
            }

            // reach here add new object
            ConfidentialTotal ctNew = new ConfidentialTotal(code);
            ctNew.FacilitiesAir = countAir;
            ctNew.FacilitiesWater = countWater;
            ctNew.FacilitiesSoil = countSoil;
            final.Add(ctNew);
        }
        

        /// <summary>
        /// return true if confidentiality might effect result
        /// </summary>
        public static bool IsAffectedByConfidentiality(PollutantReleaseSearchFilter filter)
        {
            DataClassesPollutantReleaseDataContext db = getPollutantReleaseDataContext();

            // create expression and new lambda. Only include confidential group - not ppollutant itself
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleasesConfidential(filter, param, false);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);

            return db.POLLUTANTRELEASEs.Any(lambda);
        }
        #endregion

        // ----------------------------------------------------------------------------------
        // Map filters
        // ----------------------------------------------------------------------------------
        #region Map

        /// <summary>
        /// returns the MapFilter (sql and layers) corresponding to the filter. 
        /// </summary>
        public static MapFilter GetMapFilter(PollutantReleaseSearchFilter filter)
        {
            ParameterExpression param = Expression.Parameter(typeof(POLLUTANTRELEASE), "s");
            Expression exp = LinqExpressionBuilder.GetLinqExpressionPollutantReleases(filter, param);
            Expression<Func<POLLUTANTRELEASE, bool>> lambda = Expression.Lambda<Func<POLLUTANTRELEASE, bool>>(exp, param);

            // create sql and sectors to map
            MapFilter mapFilter = new MapFilter();
            mapFilter.SqlWhere = LinqExpressionBuilder.GetSQL(exp, param);
            mapFilter.SetLayers(filter.ActivityFilter);

            return mapFilter;
        }


        /// <summary>
        /// returns the MapFilter (sql) corresponding to the filter. Layers will not be set.
        /// </summary>
        public static MapFilter GetMapFilter(DiffuseSourcesFilter filter)
        {
            //convert filter to pollutant release search
            PollutantReleaseSearchFilter searchFilter = FilterConverter.ConvertToPollutantReleaseSearchFilter(filter);
            return GetMapFilter(searchFilter);
        }


        #endregion


        #region Data context
        private static DataClassesPollutantReleaseDataContext getPollutantReleaseDataContext()
		{
			DataClassesPollutantReleaseDataContext db = new DataClassesPollutantReleaseDataContext();
			db.Log = new DebuggerWriter();
			return db;
		}
		#endregion
    }
}