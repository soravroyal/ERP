using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using IntegrationTest;
using System.Diagnostics;

namespace TestRunner
{
	class TestRunner
	{
		const int numberOfTests = 1;
		const bool saveAsReport = false;
		static int testsRemaining;

		static void Main(string[] args)
		{
			//RunPerformanceTest(1);

			int numberOfRuns;
			Console.WriteLine("The Performance Test consists of " + numberOfTests.ToString() + " individual test cases.");
			Console.WriteLine("");
			Console.Write("How many times do you wish to run each test case: ");
			Console.ForegroundColor = ConsoleColor.White;

			try
			{
				numberOfRuns = int.Parse(Console.ReadLine());
			}
			catch (Exception)
			{
				// If the user failed to enter an integer, end the application by returning from Main()
				return;
			}
			finally
			{
				Console.ForegroundColor = ConsoleColor.Gray;
			}

			if (numberOfRuns > 0)
			{
				RunPerformanceTest(numberOfRuns);
			}
		}

		private static void RunPerformanceTest(int numberOfRuns)
		{
			List<string> writeList = new List<string>();
			testsRemaining = numberOfRuns * numberOfTests;
			
			string outputFilePath = saveAsReport == true ? ("TestResults\\" + string.Format("{0:s}", DateTime.Now).Replace(":", "") + ".txt") : ("TestResults\\" + string.Format("{0:s}", DateTime.Now).Replace(":", "") + ".csv");

			if (!Directory.Exists("TestResults\\"))
			{
				Directory.CreateDirectory("TestResults\\");
			}

			if (!File.Exists(outputFilePath))
			{
				using (File.Create(outputFilePath)) { }
			}

			using (FileStream stream = File.Open(outputFilePath, FileMode.Truncate)) { }

			using (StreamWriter outputWriter = File.AppendText(outputFilePath))
			{
				Console.Clear();
				Console.ForegroundColor = ConsoleColor.White;
				Console.WriteLine(DateTime.Now.ToShortTimeString() + " - Performance Test Starting");
				Console.ForegroundColor = ConsoleColor.Gray;
				Console.WriteLine("");

				//// Facility Level
				//writeList = RunFacilityTestA(writeList, numberOfRuns); // 6.8 Seconds
				//writeList = RunFacilityTestB(writeList, numberOfRuns); // 2.2 Seconds
				//writeList = RunFacilityTestC(writeList, numberOfRuns); // 0.5 Seconds
				//writeList = RunFacilityTestD(writeList, numberOfRuns); // 0.3 Seconds
				writeList = RunFacilityTestE(writeList, numberOfRuns); // 11.2 Seconds

				//// Industrial Activity
				//writeList = RunIndustrialActivityTestA(writeList, numberOfRuns); // 13.6 Seconds
				//writeList = RunIndustrialActivityTestB(writeList, numberOfRuns); // 12.2 Seconds
				//writeList = RunIndustrialActivityTestC(writeList, numberOfRuns); // 12.2 Seconds
				//writeList = RunIndustrialActivityTestD(writeList, numberOfRuns); // 13.1 Seconds
				//writeList = RunIndustrialActivityTestE(writeList, numberOfRuns); // 7.5 Seconds

				//// Pollutant Releases
				//writeList = RunPollutantReleasesTestA(writeList, numberOfRuns); // 1.0 Seconds

				//// Pollutant Transfers
				//writeList = RunPollutantTransfersTestA(writeList, numberOfRuns); // ? Seconds

				//// Waste Transfers
				//writeList = RunWasteTransfersTestA(writeList, numberOfRuns); // 0.7 Seconds

				// Write to the file
				if (saveAsReport)
				{
					for (int i = 0; i < writeList.Count - 3; i++)
					{
						outputWriter.WriteLine(writeList[i]);
					}
				}
				else
				{
					for (int i = 0; i < writeList.Count - 1; i++)
					{
						outputWriter.WriteLine(writeList[i]);
					}
				}
				outputWriter.Flush();

				Console.WriteLine("");
				Console.ForegroundColor = ConsoleColor.White;
				Console.WriteLine(DateTime.Now.ToShortTimeString() + " - Performance Test Completed");
				Console.ForegroundColor = ConsoleColor.Gray;
				Console.WriteLine("");
			}
		}

		#region Worker Methods

		private static List<string> AddResults(List<string> writeList, List<double> resultList)
		{
			for (int i = 1; i <= resultList.Count; i++)
			{
				if (saveAsReport)
				{
					writeList.Add("Run " + i.ToString() + ": " + string.Format("{0:f}", resultList[i - 1]) + " seconds");
				}
				else
				{
					writeList.Add(string.Format("{0:f}", resultList[i - 1]));
				}
			}

			resultList.Sort();

			writeList = AddFooter(writeList, resultList);

			return writeList;
		}

		private static List<string> AddHeader(List<string> writeList, string testName)
		{
			writeList.Add(testName);
			writeList.Add("");

			return writeList;
		}

		private static List<string> AddFooter(List<string> writeList, List<double> resultList)
		{
			if (saveAsReport)
			{
				writeList.Add("");
				writeList.Add("Fastest run: " + GetFastest(resultList) + " seconds");
				writeList.Add("Slowest run: " + GetSlowest(resultList) + " seconds");
				writeList.Add("Average time per run: " + GetAverage(resultList) + " seconds");
				writeList.Add("Median time per run: " + GetMedian(resultList) + " seconds");
				writeList.Add("");
			}
			
			writeList.Add("");
			writeList.Add("");

			return writeList;
		}

		private static string GetFastest(List<double> resultList)
		{
			// Calculate Fastest Run
			return string.Format("{0:f}", resultList[0]);
		}

		private static string GetSlowest(List<double> resultList)
		{
			// Calculate Slowest Run
			return string.Format("{0:f}", resultList[resultList.Count - 1]);
		}

		private static string GetAverage(List<double> resultList)
		{
			// Calculate Average Run Time
			double averageTime = 0;

			for (int i = 0; i < resultList.Count; i++)
			{
				averageTime += resultList[i];
			}

			averageTime /= resultList.Count;
			return string.Format("{0:f}", averageTime);
		}

		private static string GetMedian(List<double> resultList)
		{
			int medianLocation = resultList.Count / 2;
			return string.Format("{0:f}", resultList[medianLocation]);
		}

		#endregion

		#region Test Cases

		#region Facility Level

		private static List<string> RunFacilityTestA(List<string> writeList, int numberOfRuns)
		{
			FacilityTest facilityTest = new FacilityTest();
			List<double> resultList = new List<double>();

			writeList = AddHeader(writeList, "FacilityTestA - Facility Level, EU25, Activity 1+3+4+8, Pollutant Expanded, Waste Transfer Expanded");

			for (int i = 0; i < numberOfRuns; i++)
			{
				Console.WriteLine("Tests remaining: " + testsRemaining.ToString());
				resultList.Add(facilityTest.FacilityTestA());
				testsRemaining--;
			}

			writeList = AddResults(writeList, resultList);

			return writeList;
		}

		private static List<string> RunFacilityTestB(List<string> writeList, int numberOfRuns)
		{
			FacilityTest facilityTest = new FacilityTest();
			List<double> resultList = new List<double>();

			writeList = AddHeader(writeList, "FacilityTestB - Facility Level, All Reporting Countries, Activity Collapsed, Pollutant Collapsed, Waste Transfer Collapsed");

			for (int i = 0; i < numberOfRuns; i++)
			{
				Console.WriteLine("Tests remaining: " + testsRemaining.ToString());
				resultList.Add(facilityTest.FacilityListTestB());
				testsRemaining--;
			}

			writeList = AddResults(writeList, resultList);

			return writeList;
		}

		private static List<string> RunFacilityTestC(List<string> writeList, int numberOfRuns)
		{
			FacilityTest facilityTest = new FacilityTest();
			List<double> resultList = new List<double>();

			writeList = AddHeader(writeList, "FacilityTestC - Facility Level, France, Activity Collapsed, Pollutant Collapsed, Waste Transfer Collapsed");

			for (int i = 0; i < numberOfRuns; i++)
			{
				Console.WriteLine("Tests remaining: " + testsRemaining.ToString());
				resultList.Add(facilityTest.FacilityListTestC());
				testsRemaining--;
			}

			writeList = AddResults(writeList, resultList);

			return writeList;
		}

		private static List<string> RunFacilityTestD(List<string> writeList, int numberOfRuns)
		{
			FacilityTest facilityTest = new FacilityTest();
			List<double> resultList = new List<double>();

			writeList = AddHeader(writeList, "FacilityTestD - Facility Level, Denmark, Activity Collapsed, Pollutant Collapsed, Waste Transfer Collapsed");

			for (int i = 0; i < numberOfRuns; i++)
			{
				Console.WriteLine("Tests remaining: " + testsRemaining.ToString());
				resultList.Add(facilityTest.FacilityListTestD());
				testsRemaining--;
			}

			writeList = AddResults(writeList, resultList);

			return writeList;
		}

		private static List<string> RunFacilityTestE(List<string> writeList, int numberOfRuns)
		{
            List<double> resultList = new List<double>();
            try
            {
                FacilityTest facilityTest = new FacilityTest();
                writeList = AddHeader(writeList, "FacilityTestE - Facility Level, Default");

                Random rnd = new Random();
                for (int i = 0; i < numberOfRuns; i++)
                {
                    int wait = rnd.Next(100,500);
                    System.Threading.Thread.Sleep(wait);

                    Console.WriteLine("Tests remaining: " + testsRemaining.ToString());
                    resultList.Add(facilityTest.FacilityListTestE());
                    testsRemaining--;
                }
                writeList = AddResults(writeList, resultList);
            }
            catch (Exception ex)
            {
                writeList.Add("Error: " + ex.ToString());
            }

			return writeList;
		}

		#endregion

		#region Industrial Activity
		
		private static List<string> RunIndustrialActivityTestA(List<string> writeList, int numberOfRuns)
		{
			IndustrialActivityTest industrialActivityTest = new IndustrialActivityTest();
			List<double> resultList = new List<double>();

			writeList = AddHeader(writeList, "IndustrialActivityTestA - Industrial Activity, Default");

			for (int i = 0; i < numberOfRuns; i++)
			{
				Console.WriteLine("Tests remaining: " + testsRemaining.ToString());
				resultList.Add(industrialActivityTest.IndustrialActivityTestA());
				testsRemaining--;
			}

			// Since AddResults doesn't need specific info (like "IndustrialActivityTestA"), it can be moved to the top where the tests are called.
			// Return a list of doubles instead (the resultList) and work from there.
			writeList = AddResults(writeList, resultList);

			return writeList;
		}

		private static List<string> RunIndustrialActivityTestB(List<string> writeList, int numberOfRuns)
		{
			IndustrialActivityTest industrialActivityTest = new IndustrialActivityTest();
			List<double> resultList = new List<double>();

			writeList = AddHeader(writeList, "IndustrialActivityTestB - Industrial Activity, France, Activity Expanded");

			for (int i = 0; i < numberOfRuns; i++)
			{
				Console.WriteLine("Tests remaining: " + testsRemaining.ToString());
				resultList.Add(industrialActivityTest.IndustrialActivityTestB());
				testsRemaining--;
			}

			writeList = AddResults(writeList, resultList);

			return writeList;
		}

		private static List<string> RunIndustrialActivityTestC(List<string> writeList, int numberOfRuns)
		{
			IndustrialActivityTest industrialActivityTest = new IndustrialActivityTest();
			List<double> resultList = new List<double>();

			writeList = AddHeader(writeList, "IndustrialActivityTestC - Industrial Activity, Denmark, Activity Expanded");

			for (int i = 0; i < numberOfRuns; i++)
			{
				Console.WriteLine("Tests remaining: " + testsRemaining.ToString());
				resultList.Add(industrialActivityTest.IndustrialActivityTestC());
				testsRemaining--;
			}

			writeList = AddResults(writeList, resultList);

			return writeList;
		}

		private static List<string> RunIndustrialActivityTestD(List<string> writeList, int numberOfRuns)
		{
			IndustrialActivityTest industrialActivityTest = new IndustrialActivityTest();
			List<double> resultList = new List<double>();

			writeList = AddHeader(writeList, "IndustrialActivityTestD - Industrial Activity, Denmark, 1+3+4+8");

			for (int i = 0; i < numberOfRuns; i++)
			{
				Console.WriteLine("Tests remaining: " + testsRemaining.ToString());
				resultList.Add(industrialActivityTest.IndustrialActivityTestD());
				testsRemaining--;
			}

			writeList = AddResults(writeList, resultList);

			return writeList;
		}

		private static List<string> RunIndustrialActivityTestE(List<string> writeList, int numberOfRuns)
		{
			IndustrialActivityTest industrialActivityTest = new IndustrialActivityTest();
			List<double> resultList = new List<double>();

			writeList = AddHeader(writeList, "IndustrialActivityTestE - Industrial Activity, France, 3.(e)");

			for (int i = 0; i < numberOfRuns; i++)
			{
				Console.WriteLine("Tests remaining: " + testsRemaining.ToString());
				resultList.Add(industrialActivityTest.IndustrialActivityTestE());
				testsRemaining--;
			}

			writeList = AddResults(writeList, resultList);

			return writeList;
		}

		#endregion

		#region Pollutant Releases

		private static List<string> RunPollutantReleasesTestA(List<string> writeList, int numberOfRuns)
		{
			PollutantReleasesTest pollutantReleasesTest = new PollutantReleasesTest();
			List<double> resultList = new List<double>();

			writeList = AddHeader(writeList, "PollutantReleasesTestA - Pollutant Releases, Default");

			for (int i = 0; i < numberOfRuns; i++)
			{
				Console.WriteLine("Tests remaining: " + testsRemaining.ToString());
				resultList.Add(pollutantReleasesTest.PollutantReleasesTestA());
				testsRemaining--;
			}

			writeList = AddResults(writeList, resultList);

			return writeList;
		}

		#endregion

		#region Pollutant Transfers

		private static List<string> RunPollutantTransfersTestA(List<string> writeList, int numberOfRuns)
		{
			PollutantTransfersTest pollutantTransfersTest = new PollutantTransfersTest();
			List<double> resultList = new List<double>();

			writeList = AddHeader(writeList, "PollutantTransfersTestA - Pollutant Transfers, Default");

			for (int i = 0; i < numberOfRuns; i++)
			{
				Console.WriteLine("Tests remaining: " + testsRemaining.ToString());
				resultList.Add(pollutantTransfersTest.PollutantTransfersTestA());
				testsRemaining--;
			}

			writeList = AddResults(writeList, resultList);

			return writeList;
		}

		#endregion

		#region Waste Transfers

		private static List<string> RunWasteTransfersTestA(List<string> writeList, int numberOfRuns)
		{
			WasteTransfersTest wasteTransfersTest = new WasteTransfersTest();
			List<double> resultList = new List<double>();

			writeList = AddHeader(writeList, "WasteTransfersTestA - Waste Transfers, Default");

			for (int i = 0; i < numberOfRuns; i++)
			{
				Console.WriteLine("Tests remaining: " + testsRemaining.ToString());
				resultList.Add(wasteTransfersTest.WasteTransfersTestA());
				testsRemaining--;
			}

			writeList = AddResults(writeList, resultList);

			return writeList;
		}

		#endregion

		#endregion
	}
}