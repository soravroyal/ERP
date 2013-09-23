using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using QueryLayer;
using System.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace UnitTests
{
    /// <summary>
    /// Summary description for TestNumberFormatting
    /// </summary>
    [TestClass]
    public class TestNumberFormatting
    {
        public TestNumberFormatting()
        {
            //
            // TODO: Add constructor logic here
            //
        }

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
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        [TestMethod]
        public void NumberFormatTest1()
        {
            //
            // TODO: Add test logic	here
            //

            List<double> inputs = new List<double>();
            inputs.Add(0.0001);
            inputs.Add(0.001);
            inputs.Add(0.01);
            inputs.Add(0.1);
            inputs.Add(0);
            inputs.Add(1);
            inputs.Add(10);
            inputs.Add(100);
            inputs.Add(1000);
            inputs.Add(10000);
            inputs.Add(100000);
            inputs.Add(-1);
            inputs.Add(-2);

            List<string> ExpectedResults = new List<string>();
            ExpectedResults.Add("0,100 g");
            ExpectedResults.Add("1,000 g");
            ExpectedResults.Add("10,0 g");
            ExpectedResults.Add("100 g");
            ExpectedResults.Add("0 kg");
            
            ExpectedResults.Add("1,00 kg");
            ExpectedResults.Add("10,0 kg");
            ExpectedResults.Add("100 kg");
            ExpectedResults.Add("1,00 t");
            ExpectedResults.Add("10,0 t");
            
            ExpectedResults.Add("100 t");
            ExpectedResults.Add("ERROR - Negative Amount provided");
            ExpectedResults.Add("ERROR - Negative Amount provided");
            
            ExpectedResults.Add("0,100 g");
            ExpectedResults.Add("1,000 g");
            
            ExpectedResults.Add("10,0 g");
            ExpectedResults.Add("100 g");
            ExpectedResults.Add("0 kg");
            ExpectedResults.Add("1,00 kg");
            ExpectedResults.Add("10,0 kg");

            ExpectedResults.Add("100 kg");
            ExpectedResults.Add("1,00 t");
            ExpectedResults.Add("10,0 t");
            ExpectedResults.Add("100 t");
            ExpectedResults.Add("ERROR - Negative Amount provided");

            ExpectedResults.Add("ERROR - Negative Amount provided");
            

            List<string> ActualResults = new List<string>();

            foreach (double input in inputs)
            {
                ActualResults.Add(numberFormatting.FormattingNumbers(input, "kg", true));
            }

            foreach (double input in inputs)
            {
                ActualResults.Add(numberFormatting.FormattingNumbers((input / 1000), "t"));
            }

            Assert.AreEqual("CONFIDENTIAL" , numberFormatting.FormattingNumbers(null, "kg", true));
            Assert.AreEqual("-", numberFormatting.FormattingNumbers(null, "kg", false));

            for (int i = 0; i < ActualResults.Count-1; i++)
            {
                Assert.AreEqual(ExpectedResults[i], ActualResults[i]);
            }
        }
    }
}
