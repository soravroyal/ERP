using QueryLayer;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Collections.Generic;
using QueryLayer.Filters;
using System;
using System.Linq.Expressions;

namespace IntegrationTest
{
	/// <summary>
	///This is a test class for PollutantReleasesTest and is intended
	///to contain all PollutantReleasesTest Unit Tests
	///</summary>
	[TestClass()]
	public class PollutantReleasesTest
	{
		private TestContext testContextInstance;

		/// <summary>
		///Gets or sets the test context which provides
		///information about and functionality for the current test run.
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
		///Pollutant Releases, Default
		///</summary>
		[TestMethod()]
		public double PollutantReleasesTestA()
		{
			DateTime testStartTime;
			DateTime testEndTime;
			TimeSpan testDelta;

			PollutantReleaseSearchFilter filter = new PollutantReleaseSearchFilter();
			
			filter.ActivityFilter = new ActivityFilter();
			filter.ActivityFilter.SectorIds.Add(-1);
			filter.ActivityFilter.ActivityIds.Add(-1);
			filter.ActivityFilter.SubActivityIds.Add(-1);

			filter.AreaFilter = new AreaFilter();
			filter.AreaFilter.AreaGroupID = 1;
			filter.AreaFilter.CountryID = -1;
			filter.AreaFilter.RegionID = -1;

			filter.MapFilter = new MapFilter();
			filter.MapFilter.SqlWhere = "(((((ReportingYear) = 2007) And ((((((((((((((((((((((((((((((((LOV_CountryID) = 15) Or ((LOV_CountryID) = 22)) Or ((LOV_CountryID) = 34)) Or ((LOV_CountryID) = 57)) Or ((LOV_CountryID) = 58)) Or ((LOV_CountryID) = 59)) Or ((LOV_CountryID) = 68)) Or ((LOV_CountryID) = 73)) Or ((LOV_CountryID) = 74)) Or ((LOV_CountryID) = 81)) Or ((LOV_CountryID) = 85)) Or ((LOV_CountryID) = 100)) Or ((LOV_CountryID) = 101)) Or ((LOV_CountryID) = 106)) Or ((LOV_CountryID) = 109)) Or ((LOV_CountryID) = 122)) Or ((LOV_CountryID) = 127)) Or ((LOV_CountryID) = 128)) Or ((LOV_CountryID) = 129)) Or ((LOV_CountryID) = 137)) Or ((LOV_CountryID) = 156)) Or ((LOV_CountryID) = 166)) Or ((LOV_CountryID) = 177)) Or ((LOV_CountryID) = 178)) Or ((LOV_CountryID) = 182)) Or ((LOV_CountryID) = 201)) Or ((LOV_CountryID) = 202)) Or ((LOV_CountryID) = 207)) Or ((LOV_CountryID) = 213)) Or ((LOV_CountryID) = 214)) Or ((LOV_CountryID) = 234))) And ((LOV_PollutantID) = 9)) And (((QuantityAir IS NOT NULL) Or (QuantitySoil IS NOT NULL)) Or (QuantityWater IS NOT NULL)))";

			filter.MediumFilter = new MediumFilter();
			filter.MediumFilter.ReleasesToAir = true;
			filter.MediumFilter.ReleasesToSoil = true;
			filter.MediumFilter.ReleasesToWater = true;

			filter.PollutantFilter = new PollutantFilter();
			filter.PollutantFilter.PollutantGroupID = 1;
			filter.PollutantFilter.PollutantID = 9;

			filter.YearFilter = new YearFilter();
			filter.YearFilter.Year = 2007;

			testStartTime = DateTime.Now;
			PollutantReleases.Summery(filter);
			testEndTime = DateTime.Now;

			testDelta = testEndTime - testStartTime;
	
			return testDelta.TotalSeconds;
		}
	}
}