using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Data.Linq.SqlClient;

using QueryLayer.Filters;
using QueryLayer.Utilities;
using System.Text.RegularExpressions;


namespace QueryLayer.LinqFramework
{
	/// <summary>
	/// Summary description for LinqExpressionBuilder
	/// </summary>
	public class LinqExpressionBuilder
	{
		public LinqExpressionBuilder()
		{
		}

        /// <summary>
        /// Returns a "Where" Expression based on the contents of the FacilitySearchFilter passed to this method
        /// </summary>
        /// <param name="filter">A FacilitySearchFilter object</param>
        /// <param name="parameter">The ParameterExpression object</param>
        /// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
        public static Expression GetLinqExpressionFacilitySearch(FacilitySearchFilter filter, ParameterExpression parameter)
        {
            Expression facilitySearchExpression = null;

            if (filter == null)
            {
                return null;
            }
            else
            {
                // Year expression
                facilitySearchExpression = GetLinqExpressionYear(filter.YearFilter, parameter);

                // Area expression
                Expression area = GetLinqExpressionArea(filter.AreaFilter, parameter);
                if (area != null)
                {

                    // this added code handles situation where Year filter was null
                    // that is when filter originates in Poll Release Time Series
                    if (facilitySearchExpression != null)
                    {
                        facilitySearchExpression = Expression.And(facilitySearchExpression, area);
                    }
                    else
                    {
                        facilitySearchExpression = area;
                    }
                }

                // Activity expression
                Expression activity = GetLinqExpressionActivity(filter.ActivityFilter, parameter);
                if (activity != null)
                    facilitySearchExpression = Expression.And(facilitySearchExpression, activity);

                // Pollutant expression
                Expression pollutant = GetLinqExpressionPollutant(filter.PollutantFilter, parameter);
                if (pollutant != null)
                    facilitySearchExpression = Expression.And(facilitySearchExpression, pollutant);

                // PollutantReleaseMedium expression
                Expression pollutantReleaseMedium = GetLinqExpressionMedium(filter.MediumFilter, parameter);
                if (pollutantReleaseMedium != null)
                    facilitySearchExpression = Expression.And(facilitySearchExpression, pollutantReleaseMedium);

                // WasteTransferType expression
                Expression wasteTransferType = GetLinqExpressionWasteTransferType(filter.WasteTypeFilter, parameter, true);
                if (wasteTransferType != null)
                    facilitySearchExpression = Expression.And(facilitySearchExpression, wasteTransferType);

                // WasteTransferTreatment expression
                Expression wasteTransferTreatment = GetLinqExpressionWasteTransferTreatmentCode(filter.WasteTreatmentFilter, parameter);
                if (wasteTransferTreatment != null)
                    facilitySearchExpression = Expression.And(facilitySearchExpression, wasteTransferTreatment);

                // WasteTransferReceiver expression
                Expression wasteTransferReceiver = GetLinqExpressionWasteTransferReceiver(filter.WasteReceiverFilter, parameter);
                if (wasteTransferReceiver != null)
                    facilitySearchExpression = Expression.And(facilitySearchExpression, wasteTransferReceiver);

                //Add location filter
                Expression facilityLocation = GetLinqExpressionFacilityLocation(filter.FacilityLocationFilter, parameter);
                if (facilityLocation != null)
                    facilitySearchExpression = Expression.And(facilitySearchExpression, facilityLocation);

                // Add distinct expression
                Expression distinct = LinqExpressionBuilder.GetLinqExpressionFacilitySearchDistinct(filter, parameter);
                if (distinct != null)
                {
                    facilitySearchExpression = Expression.And(facilitySearchExpression, distinct);
                }

            }

            return facilitySearchExpression;
        }
        
		/// <summary>
		/// Returns a "Where" Expression based on the contents of the IndustrialActivitySearchFilter passed to this method
		/// </summary>
		/// <param name="filter">An IndustrialActivitySearchFilter object</param>
		/// <param name="parameter">The ParameterExpression object</param>
		/// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
		public static Expression GetLinqExpressionIndustrialActivitySearch(IndustrialActivitySearchFilter filter, ParameterExpression parameter)
		{
			Expression industrialActivityExpression = null;

			if (filter == null)
			{
				return null;
			}
			else
			{
				// Year expression
				industrialActivityExpression = GetLinqExpressionYear(filter.YearFilter, parameter);

				// Area expression
				Expression area = GetLinqExpressionArea(filter.AreaFilter, parameter);
				if (area != null)
					industrialActivityExpression = Expression.And(industrialActivityExpression, area);

				// Activity expression
				Expression activity = GetLinqExpressionActivity(filter.ActivityFilter, parameter);
				if (activity != null)
					industrialActivityExpression = Expression.And(industrialActivityExpression, activity);
			}

			return industrialActivityExpression;
		}

        /// <summary>
        /// Returns a "Where" Expression based on the contents of the AreaOverviewSearchFilter passed to this method
        /// </summary>
        /// <param name="filter">An AreaOverviewSearchFilter object</param>
        /// <param name="parameter">The ParameterExpression object</param>
        /// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
        public static Expression GetLinqExpressionAreaOverviewSearch(AreaOverviewSearchFilter filter, ParameterExpression parameter)
        {
            Expression areaOverviewExpression = null;

            if (filter == null)
            {
                return null;
            }
            else
            {
                // Year expression
                areaOverviewExpression = GetLinqExpressionYear(filter.YearFilter, parameter);

                // Area expression
                Expression area = GetLinqExpressionArea(filter.AreaFilter, parameter);
                areaOverviewExpression = CombineAnd(areaOverviewExpression, area);
            }

            return areaOverviewExpression;
        }



		/// <summary>
		/// Returns a "Where" Expression based on the contents of the AreaFilter passed to this method
		/// </summary>
		/// <param name="filter">An AreaFilter object</param>
		/// <param name="parameter">The ParameterExpression object</param>
		/// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
		public static Expression GetLinqExpressionArea(AreaFilter filter, ParameterExpression parameter)
		{
			Expression areaExpression = null;

			if (filter == null)
			{
				return null;
			}
			else
			{
				if (filter.SearchLevel() == AreaFilter.Level.AreaGroup)
				{
					if (filter.AreaGroupID != null)
					{
						IEnumerable<int> countryIds = ListOfValues.GetCountryIdsInArea(filter.AreaGroupID);
						areaExpression = GetInExpr(parameter, "LOV_CountryID", countryIds.ToList<int>());
					}
				}
				else 
				{
					areaExpression = GetEqualsExpr(parameter, "LOV_CountryID", (int)filter.CountryID);
                    
                    if (filter.SearchLevel() == AreaFilter.Level.Region)
                    {
                        if (filter.TypeRegion == AreaFilter.RegionType.NUTSregion)
                        {
                            areaExpression = CombineAnd(areaExpression, GetEqualsExpr(parameter, "LOV_NUTSRLevel2ID", filter.RegionID));
                        }
                        else if (filter.TypeRegion == AreaFilter.RegionType.RiverBasinDistrict)
                        {
                            areaExpression = CombineAnd(areaExpression, GetEqualsExpr(parameter, "LOV_RiverBasinDistrictID", filter.RegionID));
                        }
                    }
				}
			}

			return areaExpression;
		}

        public static Expression GetLinqExpressionYear(YearFilter filter, ParameterExpression parameter)
        {
            Expression expr = null;

            if (filter != null)
            {
                expr = GetEqualsExpr(parameter, "ReportingYear", filter.Year);
            }
            return expr;
        }

        public static Expression GetLinqExpressionPeriod(PeriodFilter filter, ParameterExpression parameter)
        {
            Expression expr = null;

            if (filter != null)
            {
                Expression exprStart = GetGreaterThanOrEqualExpr(parameter, "ReportingYear", filter.StartYear);
                Expression exprEnd = GetLessThanOrEqualExpr(parameter, "ReportingYear", filter.EndYear);

                expr = CombineAnd(exprStart, exprEnd);
            }
            return expr;
        }


		/// <summary>
		/// Returns a "Where" Expression based on the contents of the ActivityFilter passed to this method
		/// </summary>
		/// <param name="filter">An ActivityFilter object</param>
		/// <param name="parameter">The ParameterExpression object</param>
		/// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
        public static Expression GetLinqExpressionActivity(ActivityFilter filter, ParameterExpression parameter)
        {
            Expression activityExpression = null;
            String sectorID = string.Empty;
            String activityID = string.Empty;
            String subActID = string.Empty;

            if (filter == null)
            {
                return null;
            }
            // All levels, no filter needed
            else if (filter.SearchLevel() == ActivityFilter.Level.All)
            {
                return null;
            }
            else  // Industrial
            {

                #region Industrial
                if (filter.ActivityType == ActivityFilter.Type.AnnexI)
                {
                    sectorID = "LOV_IASectorID";
                    activityID = "LOV_IAActivityID";
                    subActID = "LOV_IASubActivityID";

                    activityExpression = GetActivityExpr(filter, parameter, activityExpression, sectorID, activityID, subActID);
                } 
                #endregion

                #region IPPC
                // IPPC
                else if (filter.ActivityType == ActivityFilter.Type.IPPC)
                {
                    sectorID = "LOV_IASectorID";
                    activityID = "LOV_IAActivityID";
                    subActID = "LOV_IASubActivityID";

                    activityExpression = GetActivityExpr(filter, parameter, activityExpression, sectorID, activityID, subActID);
                }

                
                #endregion

                #region NACE
                // NACE
                else if (filter.ActivityType == ActivityFilter.Type.NACE)
                {
                    sectorID = "LOV_NACESectorID";
                    activityID = "LOV_NACEActivityID";
                    subActID = "LOV_NACESubActivityID";

                    activityExpression = GetActivityExpr(filter, parameter, activityExpression, sectorID, activityID, subActID);
                }
                #endregion
            }

            return activityExpression;
        }
		
        /// <summary>
        /// GetLinqExpressionFacilitySearchConfidential
        /// </summary>
        public static Expression GetLinqExpressionFacilitySearchConfidential(FacilitySearchFilter filter, ParameterExpression parameter)
        {
            //create special filter for confidentiality search. 
            FacilitySearchFilter confFilter = new FacilitySearchFilter();

            //year is kept the same
            confFilter.YearFilter = filter.YearFilter;

            //Facilityname + town: Can be kept confidential. Do not include in search

            //Country, RDB/NUTS cannot be kept confidential
            confFilter.AreaFilter = filter.AreaFilter;

            //activity: cannot be kept confidential. Include in search
            confFilter.ActivityFilter = filter.ActivityFilter;

            //pollutant: only include pollutant group. Pollutant can be kept confidential
            if (filter.PollutantFilter != null)
            {
                PollutantFilter pollutantFilter = new PollutantFilter();
                confFilter.PollutantFilter = pollutantFilter;
                pollutantFilter.PollutantGroupID = filter.PollutantFilter.PollutantGroupID;
            }

            //medium: cannot be kept confidential. Include in search
            confFilter.MediumFilter = filter.MediumFilter;

            //waste type cannot be kept confidential. Include in search
            confFilter.WasteTypeFilter = filter.WasteTypeFilter;

            //waste treatment+ wastereceiver: don't include in search. Can be kept confidential

            Expression facilitySearchExpression = GetLinqExpressionFacilitySearch(confFilter, parameter);

            //add criteria for confidential indicators. If original filter does not contain Pollutants or waste, these will not affect result. 
            Expression expr = GetEqualsExpr(parameter, "ConfidentialIndicatorFacility", 1);

            if (filter.IsPollutantIncluded())
            {
                expr = CombineOr(expr, GetEqualsExpr(parameter, "ConfidentialIndicatorPollutant", 1));
            }
            if (filter.IsWasteIncluded())
            {
                expr = CombineOr(expr, GetEqualsExpr(parameter, "ConfidentialIndicatorWaste", 1));
            }

            facilitySearchExpression = Expression.And(facilitySearchExpression, expr);

            return facilitySearchExpression;
        }
        
		/// <summary>
		/// Returns a "Where" Expression based on the contents of the PollutantFilter passed to this method
		/// </summary>
		/// <param name="filter">A PollutantFilter object</param>
		/// <param name="parameter">The ParameterExpression object</param>
		/// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
		public static Expression GetLinqExpressionPollutant(PollutantFilter filter, ParameterExpression parameter)
		{
			Expression pollutantExpression = null;

			if (filter == null)
			{
				return null;
			}
			else
			{
				if (filter.SearchLevel() == PollutantFilter.Level.All)
				{
					return pollutantExpression;
				}
				else if (filter.SearchLevel() == PollutantFilter.Level.PollutantGroup)
				{
					pollutantExpression = GetEqualsExpr(parameter, "LOV_PollutantGroupID", filter.PollutantGroupID);
				}
				else if (filter.SearchLevel() == PollutantFilter.Level.Pollutant)
				{
					pollutantExpression = GetEqualsExpr(parameter, "LOV_PollutantID", filter.PollutantID);
				}
			}

			return pollutantExpression;
		}
       
		/// <summary>
		/// Returns a "Where" Expression based on the contents of the MediumFilter passed to this method
		/// </summary>
		/// <param name="filter">A MediumFilter object</param>
		/// <param name="parameter">The ParameterExpression object</param>
		/// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
		public static Expression GetLinqExpressionMedium(MediumFilter filter, ParameterExpression parameter)
		{
			Expression mediumExpression = null;

			if (filter == null)
			{
				return null;
			}
            else if (!filter.ReleasesToAir && !filter.ReleasesToSoil && !filter.ReleasesToWater && !filter.TransferToWasteWater)
            {
                mediumExpression = GetFalseExpr();
            }
			else
			{
				if (filter.ReleasesToAir)
				{
					mediumExpression = CombineOr(mediumExpression, GetLinqExpressionMedium(MediumFilter.Medium.Air, parameter));
				}

				if (filter.ReleasesToSoil)
				{
					mediumExpression = CombineOr(mediumExpression, GetLinqExpressionMedium(MediumFilter.Medium.Soil, parameter));
				}

				if (filter.ReleasesToWater)
				{
					mediumExpression = CombineOr(mediumExpression, GetLinqExpressionMedium(MediumFilter.Medium.Water, parameter));
				}

				if (filter.TransferToWasteWater)
				{
					mediumExpression = CombineOr(mediumExpression, GetLinqExpressionMedium(MediumFilter.Medium.WasteWater, parameter));
				}
			}

			return mediumExpression;
		}

		/// <summary>
		/// Returns a "Where" Expression based on the contents of the MediumFilter passed to this method - MediumFilter contents can be null
		/// </summary>
		/// <param name="filter">A MediumFilter object</param>
		/// <param name="parameter">The ParameterExpression object</param>
		/// <returns>An Expression containing the "Where" part of a LINQ-statement - also when MediumFilter contents are null</returns>
		public static Expression GetLinqExpressionMediumRelease(MediumFilter filter, ParameterExpression parameter)
		{
			Expression mediumExpression = null;

			if (filter == null)
			{
				return null;
			}
            else if (!filter.ReleasesToAir && !filter.ReleasesToSoil && !filter.ReleasesToWater && !filter.TransferToWasteWater)
            {
                mediumExpression = GetFalseExpr();
            }
			else
			{
				if (filter.ReleasesToAir)
				{
					mediumExpression = CombineOr(mediumExpression, GetLinqExpressionMediumRelease(MediumFilter.Medium.Air, parameter));
				}

				if (filter.ReleasesToSoil)
				{
					mediumExpression = CombineOr(mediumExpression, GetLinqExpressionMediumRelease(MediumFilter.Medium.Soil, parameter));
				}

				if (filter.ReleasesToWater)
				{
					mediumExpression = CombineOr(mediumExpression, GetLinqExpressionMediumRelease(MediumFilter.Medium.Water, parameter));
				}
			}

			return mediumExpression;
		}

        /// <summary>
        /// GetLinqExpressionWasteTransferSearch
        /// </summary>
        public static Expression GetLinqExpressionWasteTransferSearch(WasteTransferSearchFilter filter, ParameterExpression parameter, bool hasWasteTypeCode)
		{
			Expression wasteTransferSearchExpression = null;

			if (filter == null)
			{
				return wasteTransferSearchExpression;
			}
			else
			{
				// Year expression
                if (filter.YearFilter!=null)
                    wasteTransferSearchExpression = GetLinqExpressionYear(filter.YearFilter, parameter);

				// Area expression
				Expression area = GetLinqExpressionArea(filter.AreaFilter, parameter);
				if (area != null)
					wasteTransferSearchExpression = (wasteTransferSearchExpression==null) ? area : Expression.And(wasteTransferSearchExpression, area);

				// WasteTransferType expression
                if (filter.WasteTypeFilter != null)
                {
                    Expression wasteTransferType = GetLinqExpressionWasteTransferType(filter.WasteTypeFilter, parameter, hasWasteTypeCode);
                    if (wasteTransferType != null)
                        wasteTransferSearchExpression = Expression.And(wasteTransferSearchExpression, wasteTransferType);
                }

                // WasteTreatmentFilter expression
                if (filter.WasteTreatmentFilter != null)
                {
                    Expression wasteTreatmentExpr = null;

                    if (parameter.Type.FullName == typeof(QueryLayer.WASTETRANSFER_HAZARDOUSTREATER).FullName)
                    {
                        // Approach is used only for table WASTETRANSFER_HAZARDOUSTREATER(S)
                        // that has a WasteTreatmentCode column
                        wasteTreatmentExpr = GetLinqExpressionWasteTransferTreatmentCode(filter.WasteTreatmentFilter, parameter);
                    }
                    else
                    {
                        // Different approach used for tables:
                        //  WASTETRANSFER_RECEIVINGCOUNTRY
                        //  WASTETRANSFER_CONFIDENTIAL
                        //  WASTETRANSFER_TREATMENT
                        //  WASTETRANSFER
                        //
                        // that don't have WasteTreatmentCode columns
                        
                        wasteTreatmentExpr = GetLinqExpressionWasteTransferTreatment(filter.WasteTreatmentFilter, parameter);
                    }
                    
                    if (wasteTreatmentExpr != null)
                        wasteTransferSearchExpression = Expression.And(wasteTransferSearchExpression, wasteTreatmentExpr);
                }

				// Activity expression
				Expression activity = GetLinqExpressionActivity(filter.ActivityFilter, parameter);
				if (activity != null)
					wasteTransferSearchExpression = Expression.And(wasteTransferSearchExpression, activity);

				return wasteTransferSearchExpression;
			}
		}


        /// <summary>
        /// GetLinqExpressionWasteTransferSearch
        /// </summary>
        public static Expression GetLinqExpressionWasteTransfer(WasteTransferTimeSeriesFilter filter, ParameterExpression parameter, bool hasWasteTypeCode)
        {
            Expression expr = null;

            if (filter == null)
            {
                return expr;
            }
            else
            {
                // Period expression
                expr = GetLinqExpressionPeriod(filter.PeriodFilter, parameter);

                // Area expression
                Expression area = GetLinqExpressionArea(filter.AreaFilter, parameter);
                expr = CombineAnd(expr, area);

                // WasteTransferType expression
                Expression wasteTransferType = GetLinqExpressionWasteTransferType(filter.WasteTypeFilter, parameter, hasWasteTypeCode);
                expr = CombineAnd(expr, wasteTransferType);

                // Activity expression
                Expression activity = GetLinqExpressionActivity(filter.ActivityFilter, parameter);
                expr = CombineAnd(expr, activity);

                return expr;
            }
        }


        /// <summary>
        /// Only include confidential reportings
        /// </summary>
        public static Expression GetLinqExpressionWasteTransferConfidentialSearch(WasteTransferSearchFilter filter, ParameterExpression parameter, bool hasWasteTypeCode)
        {
            Expression wasteTransferSearchExpression = GetLinqExpressionWasteTransferSearch(filter, parameter, hasWasteTypeCode);
            Expression expr = GetLinqExpressionWasteConfidential(true, parameter);

            wasteTransferSearchExpression = wasteTransferSearchExpression != null ? Expression.And(wasteTransferSearchExpression, expr) : expr;

            return wasteTransferSearchExpression;
        }


        /// <summary>
        /// Get expression to search for confidential waste
        /// </summary>
        /// <param name="confidential">if true only include confidential data otherwise only include non-confidential data</param>
        public static Expression GetLinqExpressionWasteConfidential(bool confidential, ParameterExpression parameter)
        {
            int value = confidential ? 1 : 0;

            Expression expr = GetEqualsExpr(parameter, "ConfidentialIndicatorWaste", value);

            return expr;
        }

        /// <summary>
        /// GetLinqExpressionWasteTreaters
        /// </summary>
        public static Expression GetLinqExpressionWasteTreaters(WasteTransferSearchFilter filter, string whpCountryCode, ParameterExpression parameter)
        {
            Expression exp = GetLinqExpressionWasteTransferSearch(filter, parameter, false);
            exp = CombineAnd(exp, GetEqualsExpr(parameter, "WHPCountryCode", whpCountryCode));

            return exp;
        }

		/// <summary>
		/// Returns a "Where" Expression based on the contents of the WasteTypeFilter passed to this method
		/// </summary>
		/// <param name="filter">A WasteTypeFilter object</param>
		/// <param name="parameter">The ParameterExpression object</param>
		/// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
        public static Expression GetLinqExpressionWasteTransferType(WasteTypeFilter filter, ParameterExpression parameter, bool hasWasteTypeCode)
		{
			Expression wasteTransferTypeExpression = null;

			if (filter == null)
			{
				return null;
			}
            else if (!filter.NonHazardousWaste && !filter.HazardousWasteCountry && !filter.HazardousWasteTransboundary)
            {
                wasteTransferTypeExpression = GetFalseExpr();
            }
            else
            {
                if (filter.NonHazardousWaste)
                {
                    wasteTransferTypeExpression = CombineOr(wasteTransferTypeExpression, GetLinqExpressionWasteTransferType(WasteTypeFilter.Type.NonHazardous, parameter, hasWasteTypeCode));
                }

                if (filter.HazardousWasteCountry)
                {
                    wasteTransferTypeExpression = CombineOr(wasteTransferTypeExpression, GetLinqExpressionWasteTransferType(WasteTypeFilter.Type.HazardousCountry, parameter, hasWasteTypeCode));
                }

                if (filter.HazardousWasteTransboundary)
                {
                    wasteTransferTypeExpression = CombineOr(wasteTransferTypeExpression, GetLinqExpressionWasteTransferType(WasteTypeFilter.Type.HazardousTransboundary, parameter, hasWasteTypeCode));
                }

                // Add Hazardous 
                if (filter.HazardousWasteCountry && filter.HazardousWasteTransboundary)
                    wasteTransferTypeExpression = CombineOr(wasteTransferTypeExpression, GetLinqExpressionWasteTransferType(WasteTypeFilter.Type.Hazardous, parameter, hasWasteTypeCode));
            }

			return wasteTransferTypeExpression;
		}

		/// <summary>
		/// Returns a "Where" Expression based on the contents of the WasteTreatmentFilter passed to this method
		/// </summary>
		/// <param name="filter">A WasteTreatmentFilter object</param>
		/// <param name="parameter">The ParameterExpression object</param>
		/// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
		public static Expression GetLinqExpressionWasteTransferTreatmentCode(WasteTreatmentFilter filter, ParameterExpression parameter)
		{
			Expression wasteTransferTreatmentExpression = null;

			if (filter == null)
			{
				return null;
			}
            else if (!filter.Recovery && !filter.Disposal && !filter.Unspecified)
            {
                wasteTransferTreatmentExpression = GetFalseExpr();
            }
			else
			{
				if (filter.Recovery)
					wasteTransferTreatmentExpression = CombineOr(
                        wasteTransferTreatmentExpression, 
                        GetLinqExpressionWasteTransferTreatmentCode(WasteTreatmentFilter.Treatment.Recovery, parameter));

				if (filter.Disposal)
					wasteTransferTreatmentExpression = CombineOr(
                        wasteTransferTreatmentExpression, 
                        GetLinqExpressionWasteTransferTreatmentCode(WasteTreatmentFilter.Treatment.Disposal, parameter));

				if (filter.Unspecified)
					wasteTransferTreatmentExpression = CombineOr(
                        wasteTransferTreatmentExpression, 
                        GetLinqExpressionWasteTransferTreatmentCode(WasteTreatmentFilter.Treatment.Unspecified, parameter));

                    wasteTransferTreatmentExpression = CombineOr(
                        wasteTransferTreatmentExpression,
                        GetLinqExpressionWasteTransferTreatmentCodeIsNull(parameter));
			}

			return wasteTransferTreatmentExpression;
		}


        public static Expression GetLinqExpressionWasteTransferTreatment(WasteTreatmentFilter filter, ParameterExpression parameter)
        {
            Expression wasteTransferTreatmentExpression = null;

            if (filter == null)
            {
                return null;
            }
            else if (!filter.Recovery && !filter.Disposal && !filter.Unspecified)
            {
                wasteTransferTreatmentExpression = GetFalseExpr();
            }
            else
            {
                if (filter.Recovery)
                {
                    wasteTransferTreatmentExpression = CombineOr(
                        wasteTransferTreatmentExpression, 
                        GetEqualsExpr(parameter, "HasReportedRecovery", true));
                }
                if (filter.Disposal)
                {
                    wasteTransferTreatmentExpression = CombineOr(
                        wasteTransferTreatmentExpression, 
                        GetEqualsExpr(parameter, "HasReportedDisposal", true));
                }
                if (filter.Unspecified)
                {
                    wasteTransferTreatmentExpression = CombineOr(
                        wasteTransferTreatmentExpression, 
                        GetEqualsExpr(parameter, "HasReportedUnspecified", true));
                }
                   
            }

            return wasteTransferTreatmentExpression;
        }




		/// <summary>
		/// Returns a "Where" Expression based on the contents of the WasteReceiverFilter passed to this method
		/// </summary>
		/// <param name="filter">A WasteReceiverFilter object</param>
		/// <param name="parameter">The ParameterExpression object</param>
		/// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
		public static Expression GetLinqExpressionWasteTransferReceiver(WasteReceiverFilter filter, ParameterExpression parameter)
		{
			if (filter == null)
			{
				return null;
			}
			else
			{
				if (filter.SearchLevel() == WasteReceiverFilter.Level.All)
				{
					return null;
				}
				else
				{
					return GetEqualsExpr(parameter, "WHPCountryID", filter.CountryID);
				}
			}
		}

		/// <summary>
		/// Returns a "Where" Expression based on the contents of the PollutantReleaseSearchFilter passed to this method
		/// </summary>
		/// <param name="filter">A PollutantReleaseSearchFilter object</param>
		/// <param name="parameter">The ParameterExpression object</param>
		/// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
		public static Expression GetLinqExpressionPollutantReleases(PollutantReleaseSearchFilter filter, ParameterExpression parameter)
		{
			Expression pollutantReleasesExpression = null;

			if (filter == null)
			{
				return null;
			}
			else
			{
				// Year expression
                if (filter.YearFilter !=null) //timeseries have year as null
				    pollutantReleasesExpression = GetLinqExpressionYear(filter.YearFilter, parameter);

				// Area expression
				Expression area = GetLinqExpressionArea(filter.AreaFilter, parameter);
				if (area != null)
					pollutantReleasesExpression = pollutantReleasesExpression == null ? area : Expression.And(pollutantReleasesExpression, area);

				// Pollutant expression
				Expression pollutant = GetLinqExpressionPollutant(filter.PollutantFilter, parameter);
				if (pollutant != null)
					pollutantReleasesExpression = Expression.And(pollutantReleasesExpression, pollutant);

				// PollutantReleaseMedium expression
				Expression pollutantReleaseMedium = GetLinqExpressionMediumRelease(filter.MediumFilter, parameter);
				if (pollutantReleaseMedium != null)
					pollutantReleasesExpression = Expression.And(pollutantReleasesExpression, pollutantReleaseMedium);

				// Activity expression
				Expression activity = GetLinqExpressionActivity(filter.ActivityFilter, parameter);
				if (activity != null)
					pollutantReleasesExpression = Expression.And(pollutantReleasesExpression, activity);
			}

			return pollutantReleasesExpression;
		}

        /// <summary>
        /// Returns a "Where" Expression based on the contents of the PollutantReleasesTimeSeriesFilter passed to this method
        /// </summary>
        /// <param name="filter">A PollutantReleasesTimeSeriesFilter object</param>
        /// <param name="parameter">The ParameterExpression object</param>
        /// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
        public static Expression GetLinqExpressionPollutantReleases(PollutantReleasesTimeSeriesFilter filter, ParameterExpression parameter)
        {
            if (filter == null)
            {
                return null;
            }
            
            Expression expr = null;

            // Period expression
            expr = GetLinqExpressionPeriod(filter.PeriodFilter, parameter);

            // Area expression
            Expression area = GetLinqExpressionArea(filter.AreaFilter, parameter);
            expr = CombineAnd(expr, area);

            // Pollutant expression
            Expression pollutant = GetLinqExpressionPollutant(filter.PollutantFilter, parameter);
            expr = CombineAnd(expr, pollutant);

            //Medium expression
            Expression medium = GetLinqExpressionMediumRelease(filter.MediumFilter, parameter);
            expr = CombineAnd(expr, medium);
            
            // Activity expression
            Expression activity = GetLinqExpressionActivity(filter.ActivityFilter, parameter);
            expr = CombineAnd(expr, activity);

            return expr;
        }

		/// <summary>
		/// Returns a "Where" Expression based on the contents of the PollutantTransfersSearchFilter passed to this method
		/// </summary>
		/// <param name="filter">A PollutantTransfersSearchFilter object</param>
		/// <param name="parameter">The ParameterExpression object</param>
        /// <param name="includePollutant">If true the pollutant itself will be included. Otherwise only the confidential within the group</param>
		/// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
		public static Expression GetLinqExpressionPollutantReleasesConfidential(PollutantReleaseSearchFilter filter, ParameterExpression parameter, bool includePollutant)
		{
			if (filter == null) return null;
			Expression pollutantReleasesExpression = null;

			// year filter
            if (filter.YearFilter!=null)
                pollutantReleasesExpression = GetLinqExpressionYear(filter.YearFilter, parameter);

			// Area expression
			Expression area = GetLinqExpressionArea(filter.AreaFilter, parameter);
            if (area != null)
                pollutantReleasesExpression = (pollutantReleasesExpression == null) ? area : Expression.And(pollutantReleasesExpression, area);

			// Activity expression
			Expression activity = GetLinqExpressionActivity(filter.ActivityFilter, parameter);
			if (activity != null)
				pollutantReleasesExpression = Expression.And(pollutantReleasesExpression, activity);

			// special case for medium 
			Expression medium = GetLinqExpressionMediumRelease(filter.MediumFilter, parameter);
			if (medium != null)
				pollutantReleasesExpression = Expression.And(pollutantReleasesExpression, medium);

            //Pollutants. Special case for pollutant ID in confidential
            Expression pollutant = GetLinqExpressionPollutantConfidential(filter.PollutantFilter, parameter, !includePollutant);
            if (pollutant != null)
                pollutantReleasesExpression = Expression.And(pollutantReleasesExpression, pollutant);

			return pollutantReleasesExpression;
		}

		/// <summary>
		/// Returns a "Where" Expression based on the contents of the PollutantTransfersSearchFilter passed to this method
		/// </summary>
		/// <param name="filter">A PollutantTransfersSearchFilter object</param>
		/// <param name="parameter">The ParameterExpression object</param>
		/// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
		public static Expression GetLinqExpressionPollutantTransfers(PollutantTransfersSearchFilter filter, ParameterExpression parameter)
		{

			Expression pollutantTransfersExpression = null;

			if (filter == null)
			{
				return null;
			}
			else
			{
				// Year expression
                if (filter.YearFilter!=null)
                    pollutantTransfersExpression = GetLinqExpressionYear(filter.YearFilter, parameter);

				// Area expression
				Expression area = GetLinqExpressionArea(filter.AreaFilter, parameter);
				if (area != null)
					pollutantTransfersExpression = (pollutantTransfersExpression==null) ? area : Expression.And(pollutantTransfersExpression, area);

				// Pollutant expression
				Expression pollutant = GetLinqExpressionPollutant(filter.PollutantFilter, parameter);
				if (pollutant != null)
					pollutantTransfersExpression = Expression.And(pollutantTransfersExpression, pollutant);

				// Activity expression
				Expression activity = GetLinqExpressionActivity(filter.ActivityFilter, parameter);
				if (activity != null)
					pollutantTransfersExpression = Expression.And(pollutantTransfersExpression, activity);

			}

			return pollutantTransfersExpression;
		}

		/// <summary>
		/// Returns a "Where" Expression based on the confidential contents of the PollutantTransfersSearchFilter passed to this method
		/// </summary>
		/// <param name="filter">A PollutantTransfersSearchFilter object</param>
		/// <param name="parameter">The ParameterExpression object</param>
        /// <param name="includePollutant">If true the pollutant itself will be included. Otherwise only the confidential within the group</param>
		/// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
		public static Expression GetLinqExpressionPollutantTransfersConfidential(PollutantTransfersSearchFilter filter, ParameterExpression parameter, bool includePollutant)
		{
			if (filter == null) return null;
			Expression pollutantTransfersExpression = null;

			// Year filter, time series has yearfilter as null
            if (filter.YearFilter!=null)
                pollutantTransfersExpression = GetLinqExpressionYear(filter.YearFilter, parameter);

            // Area expression
			Expression area = GetLinqExpressionArea(filter.AreaFilter, parameter);
			if (area != null)
				pollutantTransfersExpression = (pollutantTransfersExpression==null) ? area : Expression.And(pollutantTransfersExpression, area);

			// Activity expression
			Expression activity = GetLinqExpressionActivity(filter.ActivityFilter, parameter);
			if (activity != null)
				pollutantTransfersExpression = Expression.And(pollutantTransfersExpression, activity);

            //Pollutants. Special case for pollutant ID in confidential
            Expression pollutant = GetLinqExpressionPollutantConfidential(filter.PollutantFilter, parameter,  !includePollutant);
            if (pollutant != null)
                pollutantTransfersExpression = Expression.And(pollutantTransfersExpression, pollutant);


			return pollutantTransfersExpression;
		}

        /// <summary>
        /// Returns a "Where" Expression based on the contents of the PollutantTransferTimeSeriesFilter passed to this method
        /// </summary>
        /// <param name="filter">A PollutantTransferTimeSeriesFilter object</param>
        /// <param name="parameter">The ParameterExpression object</param>
        /// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
        public static Expression GetLinqExpressionPollutantTransfers(PollutantTransferTimeSeriesFilter filter, ParameterExpression parameter)
        {
            if (filter == null)
            {
                return null;
            }
            
            Expression expr = null;

            // Period expression
            expr = GetLinqExpressionPeriod(filter.PeriodFilter, parameter);

            // Area expression
            Expression area = GetLinqExpressionArea(filter.AreaFilter, parameter);
            expr = CombineAnd(expr, area);

            // Pollutant expression
            Expression pollutant = GetLinqExpressionPollutant(filter.PollutantFilter, parameter);
            expr = CombineAnd(expr, pollutant);

            // Activity expression
            Expression activity = GetLinqExpressionActivity(filter.ActivityFilter, parameter);
            expr = CombineAnd(expr, activity);

            return expr;
        }


        /// <summary>
        /// Transfer of: Non hazardous waste, Hazardous waste-within country, Hazardous waste-transboundary
        /// </summary>
        public static Expression GetLinqExpressionWasteTransferType(WasteTypeFilter.Type wasteTransferType, ParameterExpression parameter, bool hasWasteTypeCode)
        {
            if (hasWasteTypeCode)
            {
                return GetEqualsExpr(parameter, "WasteTypeCode", EnumUtil.GetStringValue(wasteTransferType));
            }
            else
            {
                if (wasteTransferType == WasteTypeFilter.Type.NonHazardous)
                    return GetNotEqualsExpr(parameter, "ConfidentialIndicatorNONHW", null);
                else if (wasteTransferType == WasteTypeFilter.Type.HazardousCountry)
                    return GetNotEqualsExpr(parameter, "ConfidentialIndicatorHWIC", null);
                else if (wasteTransferType == WasteTypeFilter.Type.HazardousTransboundary)
                    return GetNotEqualsExpr(parameter, "ConfidentialIndicatorHWOC", null);
                else
                    return null;
            }
        }

        /// <summary>
        /// return sql string needed by flex map. Will remove all parameter prefixes (e.g. "p.") unless the parameter given is null
        /// </summary>
        public static string GetSQL(Expression exp, ParameterExpression param)
        {

            string sql = exp.ToString();

            if (param != null)
            {
                // Remove expression parameter
                string p = String.Format("{0} =>", param.ToString());
                sql = sql.Replace(p, "");

                p = param.ToString() + ".";
                sql = sql.Replace(p, "");
            }

            // Remove convert calls
            sql = sql.Replace("Convert", "");
            sql = sql.Replace("||", "Or");
            sql = sql.Replace("&&", "And");
            sql = sql.Replace("\"", "'");
            sql = sql.Replace("= True", "= 1");
            sql = sql.Replace("= False", "= 0");
            sql = sql.Replace("=True", "=1");
            sql = sql.Replace("=False", "=0");
            sql = sql.Replace("!= null", "IS NOT NULL");

            //replace "Like(FacilityName, '%skdsdkfh%')" with "FacilityName LIKE '%skdsdkfh%'"
            sql = Regex.Replace(sql, @"Like\((.*?), (.*?)\)", "$1 LIKE $2");

            return sql;
        }


        /// <summary>
        /// Get SQL free text
        /// </summary>
        public static string GetSQLAddFreeText(string parameter, string value)
        {
            return String.Format(" And LOWER({0}) LIKE '%{1}%'", parameter, value.ToLower());
        }
        


		/// <summary>
        /// GetLinqExpressionFacilityLocation
		/// </summary>
		private static Expression GetLinqExpressionFacilityLocation(FacilityLocationFilter filter, ParameterExpression parameter)
		{
			Expression facilityLocationExpression = null;

            if (filter != null)
            {
                if (!String.IsNullOrEmpty(filter.FacilityName))
                {
                    // look for the specified Facility name in the beginning of all words in 
                    // both FACILITY NAME and PARENT COMPANY NAME
                    facilityLocationExpression = CombineOr(
                        facilityLocationExpression, 
                        GetLikeStartsWithExpr(parameter, "FacilitySearchName", filter.FacilityName));
                    
                    facilityLocationExpression = CombineOr(
                        facilityLocationExpression,
                        GetLikeStartsWithExpr(parameter, "ParentCompanySearchName", filter.FacilityName));
                }

                if (!String.IsNullOrEmpty(filter.CityName))
                {
                    // If a City name is specified, limit the result set using the AND operation.
                    // The specified City name can appear anywhere in the city name.
                    facilityLocationExpression = CombineAnd(
                        facilityLocationExpression,
                        GetLikeExpr(parameter, "CitySearchName", filter.CityName));
                        
                }
            }

            return facilityLocationExpression;
		}

       
        /// <summary>
        /// GetLinqExpressionMedium
        /// </summary>
        private static Expression GetLinqExpressionMedium(MediumFilter.Medium medium, ParameterExpression parameter)
		{
			return GetEqualsExpr(parameter, "MediumCode", EnumUtil.GetStringValue(medium));
		}

        /// <summary>
        /// GetLinqExpressionMediumRelease
        /// </summary>
        internal static Expression GetLinqExpressionMediumRelease(MediumFilter.Medium medium, ParameterExpression parameter)
		{
			Expression mediumReleaseExpression = null;

			// Kig på om medium værdien er tom (null) eller indeholder en værdi
			if (medium == MediumFilter.Medium.Air)
			{
				return GetNotEqualsExpr(parameter, "QuantityAir", null);
			}
			else if (medium == MediumFilter.Medium.Soil)
			{
				return GetNotEqualsExpr(parameter, "QuantitySoil", null);
			}
			else if (medium == MediumFilter.Medium.Water)
			{
				return GetNotEqualsExpr(parameter, "QuantityWater", null);
			}
			else
			{
				return mediumReleaseExpression;
			}
		}
                
        /// <summary>
        /// Treatment: Recovery='R', Disposal='D', Unspecified='U'
        /// </summary>
        private static Expression GetLinqExpressionWasteTransferTreatmentCode(WasteTreatmentFilter.Treatment wasteTransferTreatment, ParameterExpression parameter)
		{
            string value = EnumUtil.GetStringValue(wasteTransferTreatment);
            return GetEqualsExpr(parameter, "WasteTreatmentCode", value);
		}

        private static Expression GetLinqExpressionWasteTransferTreatmentCodeIsNull(ParameterExpression parameter)
        {
            return GetEqualsExpr(parameter, "WasteTreatmentCode", (string)null);
        }


        /// <summary>
        /// GetLinqExpressionPollutantConfidential
        /// If true only confidential reportings will be included. Otherwise The pollutant it self will be included too
        /// </summary>
        private static Expression GetLinqExpressionPollutantConfidential(PollutantFilter filter, ParameterExpression parameter, bool onlyConfidential)
        {
            Expression pollutant = GetLinqExpressionPollutant(filter, parameter);

            if (pollutant != null && filter.SearchLevel() == PollutantFilter.Level.Pollutant)
            {
                //search for reporting on group level too
                Expression pollutantGroup = GetEqualsExpr(parameter, "LOV_PollutantID", filter.PollutantGroupID);
                pollutant = CombineOr(pollutant, pollutantGroup);
            }

            if (onlyConfidential)
            {
                Expression expr = GetEqualsExpr(parameter, "ConfidentialIndicator", 1);
                pollutant = pollutant != null ? Expression.And(pollutant, expr) : expr;
            }

            return pollutant;
        }

        /// <summary>
        /// GetActivityExpr
        /// </summary>
        private static Expression GetActivityExpr(ActivityFilter filter, ParameterExpression parameter, Expression activityExpression, String sectorID, String activityID, String subActID)
        {
            // Only Sectors selected
            if (filter.SearchLevel() == ActivityFilter.Level.Sector)
            {
                activityExpression = GetInExpr(parameter, sectorID, filter.SectorIds);
            }
            else
            {
                //One sector is always selected
                activityExpression = GetEqualsExpr(parameter, sectorID, filter.SectorIds.First());
                
                // Only activities selected
                if (filter.SearchLevel() == ActivityFilter.Level.Activity)
                {
                    activityExpression = CombineAnd(activityExpression,GetInExpr(parameter, activityID, filter.ActivityIds));
                }
                else if (filter.SearchLevel() == ActivityFilter.Level.SubActivity)
                {
                    //one activity is always selected
                    activityExpression = CombineAnd(activityExpression, GetEqualsExpr(parameter, activityID, filter.ActivityIds.First()));

                    //one activity and subactivities selected
                    if (filter.SubActivityIds.Contains(ActivityFilter.SubActivitiesUnspecifiedID))
                    {
                        activityExpression = CombineAnd(activityExpression, SubActFilterExpr(filter, parameter, activityExpression, subActID));
                    }
                    else
                    {
                        // list of specific sub activities selected, unspecified or all is NOT selected if reach here
                        activityExpression = CombineAnd(activityExpression, GetInExpr(parameter, subActID, filter.SubActivityIds));
                    }
                }
            }
            return activityExpression;
        }

        /// <summary>
        /// SubActFilterExpr
        /// </summary>
        private static Expression SubActFilterExpr(ActivityFilter filter, ParameterExpression parameter, Expression activityExpression, string LOVSubActID)
        {
            // remove unspecified id (-2)
            //filter.SubActivityIds.Remove(ActivityFilter.SubActivitiesUnspecifiedID);

            // add unspecified as null 
            Expression prop = Expression.Property(parameter, LOVSubActID);
            activityExpression = Expression.Equal(prop, Expression.Constant(null));

            // add list of specific sub activities (if any)

            Expression exp = GetInExpr(parameter, LOVSubActID, filter.SubActivityIds);
            if (exp != null)
                activityExpression = Expression.Or(activityExpression, exp);
            return activityExpression;
        }

        /// <summary>
        /// Returns a part of the "Where" Expression for facility search optimizing the search, by limiting search to rows marked distinct if possible
        /// </summary>
        /// <param name="filter">A FacilitySearchFilter object</param>
        /// <param name="parameter">The ParameterExpression object</param>
        /// <returns>An Expression containing the "Where" part of a LINQ-statement</returns>
        private static Expression GetLinqExpressionFacilitySearchDistinct(FacilitySearchFilter filter, ParameterExpression parameter)
        {
            Expression distinctExpression = null;

            if (filter == null)
            {
                return null;
            }

            // create lambda according to filters
            if (filter.OnlyMainFilter())
            {
                // Add distinct to query
                Expression prop = Expression.Property(parameter, "DistinctID");
                prop = Expression.Convert(prop, typeof(bool));
                Expression val = Expression.Constant(true);
                distinctExpression = Expression.Equal(prop, val);
            }
            return distinctExpression;

        }


        // ---------------------------------------------------------------------------------------------------
        // Internal methods
        // ---------------------------------------------------------------------------------------------------
        #region internal

        /// <summary>
		/// Combines two expressions with AND. Handles if either one of them is null.
		/// </summary>
		/// <returns>The combined expression. NB! expr1 will be updated</returns>
		internal static Expression CombineAnd(Expression expr1, Expression expr2)
		{
			if (expr2 != null)
			{
				if (expr1 != null)
				{
					expr1 = Expression.And(expr1, expr2);
				}
				else
				{
					expr1 = expr2;
				}
			}
			return expr1;
		}

		/// <summary>
		/// Combines two expressions with OR. Handles if either one of them is null.
		/// </summary>
		/// <returns>The combined expression. NB! expr1 will be updated</returns>
		internal static Expression CombineOr(Expression expr1, Expression expr2)
		{
			if (expr2 != null)
			{
				if (expr1 != null)
				{
					expr1 = Expression.Or(expr1, expr2);
				}
				else
				{
					expr1 = expr2;
				}
			}
			return expr1;
		}

		/// <summary>
		/// return equals expression
		/// </summary>
		internal static Expression GetEqualsExpr(ParameterExpression parameter, string property, int value)
		{
			Expression prop = Expression.Property(parameter, property);
			prop = Expression.Convert(prop, typeof(int));
			Expression val = Expression.Constant(value);
			return Expression.Equal(prop, val);
		}

        /// <summary>
        /// return equals expression
        /// </summary>
        internal static Expression GetEqualsExpr(ParameterExpression parameter, string property, int? value)
		{
			Expression prop = Expression.Property(parameter, property);
			Expression val = Expression.Constant(value, prop.Type);
			return Expression.Equal(prop, val);
		}

        /// <summary>
        /// return equals expression
        /// </summary>
        internal static Expression GetEqualsExpr(ParameterExpression parameter, string property, string value)
		{
			Expression prop = Expression.Property(parameter, property);
			Expression val = Expression.Constant(value);
			return Expression.Equal(prop, val);
		}

        /// <summary>
        /// return equals expression for bool
        /// </summary>
        internal static Expression GetEqualsExpr(ParameterExpression parameter, string property, bool value)
        {
            Expression prop = Expression.Property(parameter, property);
            Expression val = Expression.Constant(value);
            return Expression.Equal(prop, val);
        }


        /// <summary>
        /// return not equals expression
        /// </summary>
        internal static Expression GetNotEqualsExpr(ParameterExpression parameter, string property, string value)
		{
			Expression prop = Expression.Property(parameter, property);
			Expression val = Expression.Constant(value);
			return Expression.NotEqual(prop, val);
		}

        /// <summary>
        /// return equals expression
        /// </summary>
        internal static Expression GetEqualsExpr(ParameterExpression parameter, string property, ActivityFilter.Type value)
		{
			Expression prop = Expression.Property(parameter, property);
			Expression val = Expression.Constant(value);
			return Expression.Equal(prop, val);
		}

        /// <summary>
        /// return equals expression
        /// </summary>
        internal static Expression GetEqualsExpr(ParameterExpression parameter, string property, ActivityFilter.Level value)
		{
			Expression prop = Expression.Property(parameter, property);
			Expression val = Expression.Constant(value);
			return Expression.Equal(prop, val);
		}

		/// <summary>
		/// Create IN expression
		/// Fileds which are null, must be converted to int32 (not-nullable) to get Expression.Equals(...) to work
		/// </summary>
		internal static Expression GetInExpr(ParameterExpression parameter, string property, List<int> values)
		{
			Expression exp = null;
			Expression prop = Expression.Property(parameter, property);
			prop = Expression.Convert(prop, typeof(int));
			foreach (int v in values)
			{
				Expression val = Expression.Constant(v);
				var tmp = Expression.Equal(prop, val);
				exp = (exp == null) ? tmp : Expression.OrElse(exp, tmp);
			}
			return exp;
		}

        /// <summary>
        /// Create IN expression
        /// </summary>
        internal static Expression GetInExpr(ParameterExpression parameter, string property, List<string> values)
        {
            Expression exp = null;
            Expression prop = Expression.Property(parameter, property);
            foreach (string v in values)
            {
                Expression val = Expression.Constant(v);
                var tmp = Expression.Equal(prop, val);
                exp = (exp == null) ? tmp : Expression.OrElse(exp, tmp);
            }
            return exp;
        }

        /// <summary>
        /// return like equals expression
        /// </summary>
        internal static Expression GetLikeExpr(ParameterExpression parameter, string property, string value)
        {
            Expression prop = Expression.Property(parameter, property);
            Expression val = Expression.Constant("%" + value + "%");
            Type type = typeof(SqlMethods);

            Type[] paramTypes = new Type[] { typeof(String), typeof(String) };
            MethodInfo method = type.GetMethod("Like", paramTypes);
            return Expression.Call(method, prop, val); 

        }

        /// <summary>
        /// return like equals expression
        /// </summary>
        internal static Expression GetLikeStartsWithExpr(ParameterExpression parameter, string property, string value)
        {
            Expression prop = Expression.Property(parameter, property);

            Type type = typeof(SqlMethods);

            Type[] paramTypes = new Type[] { typeof(String), typeof(String) };
            MethodInfo method = type.GetMethod("Like", paramTypes);

            // find either beginning of FIRST word
            Expression val1 = Expression.Constant(value + "%");
            // or beginning of SUBSEQUENT words
            Expression val2 = Expression.Constant("% " + value + "%");
            
            Expression res1 = Expression.Call(method, prop, val1);
            Expression res2 = Expression.Call(method, prop, val2);

            var res = CombineOr(res1, res2);
            return res;
        }

        
        /// <summary>
        /// Will return an expression that is always false, i.e. no results will be found from query!
        /// </summary>
        internal static Expression GetFalseExpr()
        {
            return Expression.Equal(Expression.Constant(1), Expression.Constant(0));
        }

        /// <summary>
        /// return equals expression
        /// </summary>
        internal static Expression GetGreaterThanOrEqualExpr(ParameterExpression parameter, string property, int? value)
        {
            if (value.HasValue)
            {
                Expression prop = Expression.Property(parameter, property);
                Expression val = Expression.Constant(value);
                return Expression.GreaterThanOrEqual(prop, val);
            }
            else
            {
                return null;
            }
        }


        /// <summary>
        /// return equals expression
        /// </summary>
        internal static Expression GetLessThanOrEqualExpr(ParameterExpression parameter, string property, int? value)
        {
            if (value.HasValue)
            {
                Expression prop = Expression.Property(parameter, property);
                Expression val = Expression.Constant(value);
                return Expression.LessThanOrEqual(prop, val);
            }
            else
            {
                return null;
            }
        }

        #endregion


    }
}