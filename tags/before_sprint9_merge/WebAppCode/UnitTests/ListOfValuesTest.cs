using System;
using QueryLayer;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;

using QueryLayer.Filters;
using QueryLayer.LinqFramework;

namespace UnitTests
{
    
    
    /// <summary>
    ///This is a test class for ListOfValuesTest and is intended
    ///to contain all ListOfValuesTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ListOfValuesTest
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
        ///A test for AreaGroups
        ///</summary>
        [TestMethod()]
        public void AreaGroupsTest()
        {
            //IEnumerable<LOV_AREAGROUP> expected = null; // TODO: Initialize to an appropriate value
			IEnumerable<LOV_AREAGROUP> actual;

            actual = ListOfValues.AreaGroups();

            // Test of the numer of entries in LOV
            Assert.AreEqual(5, actual.Count());

            Assert.Inconclusive("Verify the correctness of this test method.");
        }

		//[TestMethod()]
		//public void TestLinq()
		//{
		//    ParameterExpression param = Expression.Parameter(typeof(FACILITYSEARCH_ALL), "s");

		//    Expression expression = LinqExpressionBuilder.GetCombinedExpression(param, "Spain", "0113", 2004);
		//    DataClassesFacilityDataContext db = new DataClassesFacilityDataContext();
		//    IEnumerable<FACILITYSEARCH_ALL> filtered = db.FACILITYSEARCH_ALLs.Where(LinqExpressionBuilder.GetLambda(expression, param));

		//    int count = filtered.Count();

		//    List<FACILITYSEARCH_ALL> list = new List<FACILITYSEARCH_ALL>();
		//    list.AddRange(filtered);

		//}

		[TestMethod()]
		public void TestLinqA()
		{
			/*DataClassesFacilityDataContext db = new DataClassesFacilityDataContext();
			Expression<Func<FACILITYSEARCH_MAINACTIVITY, bool>> myLambda = Facility.GetFacilityReportingYearLambda("Aalborg Portland", 2004);
			//Expression<Func<WEB_FACILITYSEARCH, bool>> myLambda = Facility.GetWhereLambda("Ciments CALCIA", 2004);
			IEnumerable<FACILITYSEARCH_MAINACTIVITY> filtered = db.FACILITYSEARCH_MAINACTIVITies.Where(myLambda);

			int count = filtered.Count();

			List<FACILITYSEARCH_MAINACTIVITY> list = new List<FACILITYSEARCH_MAINACTIVITY>();
			list.AddRange(filtered);*/
		}

		[TestMethod()]
		public void TestLinqB()
		{
			/*DataClassesFacilityDataContext db = new DataClassesFacilityDataContext();
			Expression<Func<FACILITYSEARCH_MAINACTIVITY, bool>> myLambda = Facility.GetCountryReportingYearLambda("Denmark", 2004);
			IEnumerable<FACILITYSEARCH_MAINACTIVITY> filtered = db.FACILITYSEARCH_MAINACTIVITies.Where(myLambda);

			int count = filtered.Count();

			List<FACILITYSEARCH_MAINACTIVITY> list = new List<FACILITYSEARCH_MAINACTIVITY>();
			list.AddRange(filtered);*/
		}

		[TestMethod()]
		public void TestLinqC()
		{
			/*DataClassesFacilityDataContext db = new DataClassesFacilityDataContext();
			Expression<Func<FACILITYSEARCH_MAINACTIVITY, bool>> myLambda = Facility.GetPostalCodeReportingYearLambda("44486", 2001);
			IEnumerable<FACILITYSEARCH_MAINACTIVITY> filtered = db.FACILITYSEARCH_MAINACTIVITies.Where(myLambda);

			int count = filtered.Count();

			List<FACILITYSEARCH_MAINACTIVITY> list = new List<FACILITYSEARCH_MAINACTIVITY>();
			list.AddRange(filtered);*/
		}

		[TestMethod()]
		public void TestLinqD()
		{
			/*DataClassesFacilityDataContext db = new DataClassesFacilityDataContext();
			Expression<Func<FACILITYSEARCH_MAINACTIVITY, bool>> myLambda = Facility.GetCountryCodeReportingYearLambda("SE", 2004);
			IEnumerable<FACILITYSEARCH_MAINACTIVITY> filtered = db.FACILITYSEARCH_MAINACTIVITies.Where(myLambda);

			int count = filtered.Count();

			List<FACILITYSEARCH_MAINACTIVITY> list = new List<FACILITYSEARCH_MAINACTIVITY>();
			list.AddRange(filtered);*/
		}

		//[TestMethod()]
		//public void TestLinqBC()
		//{
		//    ParameterExpression param = Expression.Parameter(typeof(FACILITYSEARCH_MAINACTIVITY), "s");
		//    Expression expression = LinqExpressionBuilder.GetCombinedExpression(param, "Spain", "9000", 2004);
		//    DataClassesFacilityDataContext db = new DataClassesFacilityDataContext();
		//    //IEnumerable<WEB_FACILITYSEARCH> filtered = db.WEB_FACILITYSEARCHes.Where(myLambda);

		//    //int count = filtered.Count();

		//    //List<WEB_FACILITYSEARCH> list = new List<WEB_FACILITYSEARCH>();
		//    //list.AddRange(filtered);
		//}
    }
}