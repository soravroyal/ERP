using QueryLayer;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using QueryLayer.Filters;
using System;
using System.Collections.Generic;
using System.Data.Linq;
using System.Linq;

namespace IntegrationTest
{
	/// <summary>
	///This is a test class for FacilityTest and is intended to contain all FacilityTest Unit Tests
	///</summary>
	[TestClass()]
	public class FacilityTest
	{
		private TestContext testContextInstance;

		/// <summary>
		///Gets or sets the test context which provides information about and functionality for the current test run.
		///</summary>
		public TestContext TestContext
		{
			get
			{
				return testContextInstance;
			}
			set
			{
				testContextInstance = value;
			}
		}

		#region Additional test attributes
		// 
		//You can use the following additional attributes as you write your tests:
		//
		//Use ClassInitialize to run code before running the first test in the class
		//[ClassInitialize()]
		//public static void MyClassInitialize(TestContext testContext)
		//{
		//}
		//
		//Use ClassCleanup to run code after all tests in a class have run
		//[ClassCleanup()]
		//public static void MyClassCleanup()
		//{
		//}
		//
		//Use TestInitialize to run code before running each test
		//[TestInitialize()]
		//public void MyTestInitialize()
		//{
		//}
		//
		//Use TestCleanup to run code after each test has run
		//[TestCleanup()]
		//public void MyTestCleanup()
		//{
		//}
		//
		#endregion

		/// <summary>
		///Facility Search, EU25, Activity 1+3+4+8, Pollutant Expanded, Waste Transfer Expanded
		///</summary>
		[TestMethod()]
		public double FacilityTestA()
		{
			DateTime testStartTime;
			DateTime testEndTime;
			TimeSpan testDelta;

			FacilitySearchFilter filter = new FacilitySearchFilter();

			filter.ActivityFilter = new ActivityFilter();
			filter.ActivityFilter.ActivityIds.Add(-1);
			filter.ActivityFilter.SectorIds.Add(1);
			filter.ActivityFilter.SectorIds.Add(3);
			filter.ActivityFilter.SectorIds.Add(4);
			filter.ActivityFilter.SectorIds.Add(8);
			filter.ActivityFilter.SubActivityIds.Add(-1);

			filter.AreaFilter = new AreaFilter();
			filter.AreaFilter.AreaGroupID = 3;
			filter.AreaFilter.CountryID = -1;
			filter.AreaFilter.RegionID = -1;

			filter.FacilityLocationFilter = new FacilityLocationFilter();
			filter.FacilityLocationFilter.CityName = "";
			filter.FacilityLocationFilter.FacilityName = "";

			filter.MapFilter = new MapFilter();
			//filter.MapFilter.Sectors = ""; // Read Only
			filter.MapFilter.SqlWhere = "(((((((ReportingYear) = 2007) And ((((((((((((((((((((((((((LOV_CountryID) = 15) Or ((LOV_CountryID) = 22)) Or ((LOV_CountryID) = 57)) Or ((LOV_CountryID) = 58)) Or ((LOV_CountryID) = 59)) Or ((LOV_CountryID) = 68)) Or ((LOV_CountryID) = 73)) Or ((LOV_CountryID) = 74)) Or ((LOV_CountryID) = 81)) Or ((LOV_CountryID) = 85)) Or ((LOV_CountryID) = 100)) Or ((LOV_CountryID) = 106)) Or ((LOV_CountryID) = 109)) Or ((LOV_CountryID) = 122)) Or ((LOV_CountryID) = 128)) Or ((LOV_CountryID) = 129)) Or ((LOV_CountryID) = 137)) Or ((LOV_CountryID) = 156)) Or ((LOV_CountryID) = 177)) Or ((LOV_CountryID) = 178)) Or ((LOV_CountryID) = 201)) Or ((LOV_CountryID) = 202)) Or ((LOV_CountryID) = 207)) Or ((LOV_CountryID) = 213)) Or ((LOV_CountryID) = 234))) And (((((LOV_IASectorID) = 1) Or ((LOV_IASectorID) = 3)) Or ((LOV_IASectorID) = 4)) Or ((LOV_IASectorID) = 8))) And ((((MediumCode = 'AIR') Or (MediumCode = 'LAND')) Or (MediumCode = 'WATER')) Or (MediumCode = 'WASTEWATER'))) And ((((WasteTypeCode = 'NON-HW') Or (WasteTypeCode = 'HWIC')) Or (WasteTypeCode = 'HWOC')) Or (WasteTypeCode = 'HW'))) And (((WasteTreatmentCode = 'R') Or (WasteTreatmentCode = 'D')) Or (WasteTreatmentCode = 'NULL')))";

			filter.MediumFilter = new MediumFilter();
			filter.MediumFilter.ReleasesToAir = true;
			filter.MediumFilter.ReleasesToSoil = true;
			filter.MediumFilter.ReleasesToWater = true;
			filter.MediumFilter.TransferToWasteWater = true;

			filter.PollutantFilter = new PollutantFilter();
			filter.PollutantFilter.PollutantGroupID = -1;
			filter.PollutantFilter.PollutantID = -1;

			filter.WasteReceiverFilter = new WasteReceiverFilter();
			filter.WasteReceiverFilter.CountryID = -1;

			filter.WasteTreatmentFilter = new WasteTreatmentFilter();
			filter.WasteTreatmentFilter.Disposal = true;
			filter.WasteTreatmentFilter.Recovery = true;
			filter.WasteTreatmentFilter.Unspecified = true;

			filter.WasteTypeFilter = new WasteTypeFilter();
			filter.WasteTypeFilter.HazardousWasteCountry = true;
			filter.WasteTypeFilter.HazardousWasteTransboundary = true;
			filter.WasteTypeFilter.NonHazardousWaste = true;

			filter.YearFilter = new YearFilter();
			filter.YearFilter.Year = 2007;

			string column = "FacilityName";
			bool descending = false;
			int startRowIndex = 0;
			int maxRows = 30;

			testStartTime = DateTime.Now;
			List<FacilityRow> actual = Facility.FacilityList(filter, column, descending, startRowIndex, maxRows);
			testEndTime = DateTime.Now;

			testDelta = testEndTime - testStartTime;

			return testDelta.TotalSeconds;
		}

		/// <summary>
		///Facility Search, All Reporting Countries, Activity Collapsed, Pollutant Collapsed, Waste Transfer Collapsed
		///</summary>
		[TestMethod()]
		public double FacilityListTestB()
		{
			DateTime testStartTime;
			DateTime testEndTime;
			TimeSpan testDelta;

			FacilitySearchFilter filter = new FacilitySearchFilter();

			filter.ActivityFilter = new ActivityFilter();
			filter.ActivityFilter.SectorIds.Add(-1);

			filter.AreaFilter = new AreaFilter();
			filter.AreaFilter.AreaGroupID = 1;
			filter.AreaFilter.CountryID = -1;
			filter.AreaFilter.RegionID = -1;

			filter.FacilityLocationFilter = new FacilityLocationFilter();

			filter.MapFilter = new MapFilter();
			//filter.MapFilter.Sectors = ""; // Read Only
			filter.MapFilter.SqlWhere = "((((ReportingYear) = 2007) And ((((((((((((((((((((((((((((((((LOV_CountryID) = 15) Or ((LOV_CountryID) = 22)) Or ((LOV_CountryID) = 34)) Or ((LOV_CountryID) = 57)) Or ((LOV_CountryID) = 58)) Or ((LOV_CountryID) = 59)) Or ((LOV_CountryID) = 68)) Or ((LOV_CountryID) = 73)) Or ((LOV_CountryID) = 74)) Or ((LOV_CountryID) = 81)) Or ((LOV_CountryID) = 85)) Or ((LOV_CountryID) = 100)) Or ((LOV_CountryID) = 101)) Or ((LOV_CountryID) = 106)) Or ((LOV_CountryID) = 109)) Or ((LOV_CountryID) = 122)) Or ((LOV_CountryID) = 127)) Or ((LOV_CountryID) = 128)) Or ((LOV_CountryID) = 129)) Or ((LOV_CountryID) = 137)) Or ((LOV_CountryID) = 156)) Or ((LOV_CountryID) = 166)) Or ((LOV_CountryID) = 177)) Or ((LOV_CountryID) = 178)) Or ((LOV_CountryID) = 182)) Or ((LOV_CountryID) = 201)) Or ((LOV_CountryID) = 202)) Or ((LOV_CountryID) = 207)) Or ((LOV_CountryID) = 213)) Or ((LOV_CountryID) = 214)) Or ((LOV_CountryID) = 234))) And ((DistinctID) = 1))";

			filter.YearFilter = new YearFilter();
			filter.YearFilter.Year = 2007;

			string column = "FacilityName";
			bool descending = false;
			int startRowIndex = 0;
			int maxRows = 30;

			testStartTime = DateTime.Now;
			List<FacilityRow> actual = Facility.FacilityList(filter, column, descending, startRowIndex, maxRows);
			testEndTime = DateTime.Now;

			testDelta = testEndTime - testStartTime;

			return testDelta.TotalSeconds;
		}

		/// <summary>
		///Facility Search, France
		///</summary>
		[TestMethod()]
		public double FacilityListTestC()
		{
			DateTime testStartTime;
			DateTime testEndTime;
			TimeSpan testDelta;

			FacilitySearchFilter filter = new FacilitySearchFilter();

			filter.ActivityFilter = new ActivityFilter();
			filter.ActivityFilter.SectorIds.Add(-1);

			filter.AreaFilter = new AreaFilter();
			filter.AreaFilter.AreaGroupID = 1;
			filter.AreaFilter.CountryID = 74;
			filter.AreaFilter.RegionID = -1;

			filter.FacilityLocationFilter = new FacilityLocationFilter();

			filter.MapFilter = new MapFilter();
			//filter.MapFilter.Sectors = ""; // Read Only
			filter.MapFilter.SqlWhere = "((((ReportingYear) = 2007) And (LOV_CountryID = 74)) And ((DistinctID) = 1))";

			filter.YearFilter = new YearFilter();
			filter.YearFilter.Year = 2007;

			string column = "FacilityName";
			bool descending = false;
			int startRowIndex = 0;
			int maxRows = 30;

			testStartTime = DateTime.Now;
			List<FacilityRow> actual = Facility.FacilityList(filter, column, descending, startRowIndex, maxRows);
			testEndTime = DateTime.Now;

			testDelta = testEndTime - testStartTime;

			return testDelta.TotalSeconds;
		}

		/// <summary>
		///Facility Search, Denmark
		///</summary>
		[TestMethod()]
		public double FacilityListTestD()
		{
			DateTime testStartTime;
			DateTime testEndTime;
			TimeSpan testDelta;

			FacilitySearchFilter filter = new FacilitySearchFilter();

			filter.ActivityFilter = new ActivityFilter();
			filter.ActivityFilter.SectorIds.Add(-1);

			filter.AreaFilter = new AreaFilter();
			filter.AreaFilter.AreaGroupID = 1;
			filter.AreaFilter.CountryID = 59;
			filter.AreaFilter.RegionID = -1;

			filter.FacilityLocationFilter = new FacilityLocationFilter();

			filter.MapFilter = new MapFilter();
			//filter.MapFilter.Sectors = ""; // Read Only
			filter.MapFilter.SqlWhere = "((((ReportingYear) = 2007) And (LOV_CountryID = 59)) And ((DistinctID) = 1))";

			filter.YearFilter = new YearFilter();
			filter.YearFilter.Year = 2007;

			string column = "FacilityName";
			bool descending = false;
			int startRowIndex = 0;
			int maxRows = 30;

			testStartTime = DateTime.Now;
			List<FacilityRow> actual = Facility.FacilityList(filter, column, descending, startRowIndex, maxRows);
			testEndTime = DateTime.Now;

			testDelta = testEndTime - testStartTime;

			return testDelta.TotalSeconds;
		}

		/// <summary>
		///Facility Search, Default
		///</summary>
		[TestMethod()]
		public double FacilityListTestE()
		{
			DateTime testStartTime;
			DateTime testEndTime;
			TimeSpan testDelta;

			FacilitySearchFilter filter = new FacilitySearchFilter();

			filter.ActivityFilter = new ActivityFilter();
			filter.ActivityFilter.SectorIds.Add(-1);
			filter.ActivityFilter.ActivityIds.Add(-1);
			filter.ActivityFilter.SubActivityIds.Add(-1);

			filter.AreaFilter = new AreaFilter();
			filter.AreaFilter.AreaGroupID = 1;
			filter.AreaFilter.CountryID = -1;
			filter.AreaFilter.RegionID = -1;

			filter.FacilityLocationFilter = new FacilityLocationFilter();
			filter.FacilityLocationFilter.CityName = "";
			filter.FacilityLocationFilter.FacilityName = "";

			filter.MapFilter = new MapFilter();
			//filter.MapFilter.Sectors = ""; // Read Only
			filter.MapFilter.SqlWhere = "((((((ReportingYear) = 2007) And ((((((((((((((((((((((((((((((((LOV_CountryID) = 15) Or ((LOV_CountryID) = 22)) Or ((LOV_CountryID) = 34)) Or ((LOV_CountryID) = 57)) Or ((LOV_CountryID) = 58)) Or ((LOV_CountryID) = 59)) Or ((LOV_CountryID) = 68)) Or ((LOV_CountryID) = 73)) Or ((LOV_CountryID) = 74)) Or ((LOV_CountryID) = 81)) Or ((LOV_CountryID) = 85)) Or ((LOV_CountryID) = 100)) Or ((LOV_CountryID) = 101)) Or ((LOV_CountryID) = 106)) Or ((LOV_CountryID) = 109)) Or ((LOV_CountryID) = 122)) Or ((LOV_CountryID) = 127)) Or ((LOV_CountryID) = 128)) Or ((LOV_CountryID) = 129)) Or ((LOV_CountryID) = 137)) Or ((LOV_CountryID) = 156)) Or ((LOV_CountryID) = 166)) Or ((LOV_CountryID) = 177)) Or ((LOV_CountryID) = 178)) Or ((LOV_CountryID) = 182)) Or ((LOV_CountryID) = 201)) Or ((LOV_CountryID) = 202)) Or ((LOV_CountryID) = 207)) Or ((LOV_CountryID) = 213)) Or ((LOV_CountryID) = 214)) Or ((LOV_CountryID) = 234))) And ((((MediumCode = 'AIR') Or (MediumCode = 'LAND')) Or (MediumCode = 'WATER')) Or (MediumCode = 'WASTEWATER'))) And ((((WasteTypeCode = 'NON-HW') Or (WasteTypeCode = 'HWIC')) Or (WasteTypeCode = 'HWOC')) Or (WasteTypeCode = 'HW'))) And (((WasteTreatmentCode = 'R') Or (WasteTreatmentCode = 'D')) Or (WasteTreatmentCode = 'NULL')))";

			filter.MediumFilter = new MediumFilter();
			filter.MediumFilter.ReleasesToAir = true;
			filter.MediumFilter.ReleasesToSoil = true;
			filter.MediumFilter.ReleasesToWater = true;
			filter.MediumFilter.TransferToWasteWater = true;

			filter.PollutantFilter = new PollutantFilter();
			filter.PollutantFilter.PollutantGroupID = -1;
			filter.PollutantFilter.PollutantID = -1;

			filter.WasteReceiverFilter = new WasteReceiverFilter();
			filter.WasteReceiverFilter.CountryID = -1;

			filter.WasteTreatmentFilter = new WasteTreatmentFilter();
			filter.WasteTreatmentFilter.Disposal = true;
			filter.WasteTreatmentFilter.Recovery = true;
			filter.WasteTreatmentFilter.Unspecified = true;

			filter.WasteTypeFilter = new WasteTypeFilter();
			filter.WasteTypeFilter.HazardousWasteCountry = true;
			filter.WasteTypeFilter.HazardousWasteTransboundary = true;
			filter.WasteTypeFilter.NonHazardousWaste = true;

			filter.YearFilter = new YearFilter();
			filter.YearFilter.Year = 2007;

			string column = "FacilityName";
			bool descending = false;
			int startRowIndex = 0;
			int maxRows = 30;

			testStartTime = DateTime.Now;
			List<FacilityRow> actual = Facility.FacilityList(filter, column, descending, startRowIndex, maxRows);
			testEndTime = DateTime.Now;

			testDelta = testEndTime - testStartTime;

			return testDelta.TotalSeconds;
		}
	}
}