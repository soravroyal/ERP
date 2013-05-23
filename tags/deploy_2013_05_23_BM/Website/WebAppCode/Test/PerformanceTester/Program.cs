using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.IO;



namespace SPPerformanceTester
{
	class Program
	{
		static object lockObj = new object();

		static ITestRunDataProvider testRunDataProvider
		{
			get { return (ITestRunDataProvider)ServiceLocator.Instance.GetService(typeof(ITestRunDataProvider)); }
		}

		static void Main(string[] args)
		{
			if (args.Length == 2)
			{
				string outputFilePath = args[1];
				string configXmlFilePath = args[0];
				ServiceLocator.Instance.AddService(typeof(ITestRunDataProvider), new TestRunDataProvider(configXmlFilePath));

				if (!File.Exists(outputFilePath))
				{
					using (File.Create(outputFilePath)) { }
				}
				using (FileStream stream = File.Open(outputFilePath, FileMode.Truncate))
				{ }
				using (StreamWriter outputWriter = File.AppendText(outputFilePath))
				{
					JobRunner jobRunner = new JobRunner(outputWriter);
					outputWriter.WriteLine("Jobname; ThreadName; Runcount; Time; Exceptions");
					outputWriter.Flush();
					foreach (T_Job job1 in testRunDataProvider.GetJobs().Job)
					{

						//if (job1.speedCategory == T_JobSpeedCategory.FAST)// || job1.speedCategory == T_JobSpeedCategory.NORMAL)
						//{
						jobRunner.RunJob(job1);
						//}
					}
				}
			}
			else
			{
				Console.WriteLine("Wrong number of arguments. Usage:");
				Console.WriteLine("SPPerformanceTester configuration.xml outputfile.txt");
			}
			//for (int i = 0; i < 10; i++)
			//{
			//    List<IDataParameter> parameters = new List<IDataParameter>();
			//    Guid test_provider = new Guid("79662EAE-1247-4F03-B10B-4A2A014B09F1"); // --pName ='fr_ademe'
			//    parameters.Add(new SqlParameter("pGuid", test_provider));
			//    ThreadRunner.RunSpInThread(TimeSpan.FromSeconds(5)
			//        , "exec giseditor.[XCP_GET_PROVIDER_TRUST_XML] @pGuid", parameters);
			//}

			//DateTime start = DateTime.Now;

			//int i = 0;
			//while (DateTime.Now < start.AddSeconds(10))
			//{
			//    SpExecutor.TestExecuteSP2();
			//    i++;
			//}
			//Console.WriteLine(i);
			//Console.ReadLine();
			//Console.WriteLine("Thread\tNo.\tDelay\tExecution time");

			//ThreadStart singleJob = new ThreadStart(singleThreadJob);
			//Thread[] singleThread = new Thread[1];
			//singleThread[0] = new Thread(singleJob);
			//singleThread[0].Start();

			//ThreadStart job = new ThreadStart(ThreadJob);
			//Thread[] thread = new Thread[numberOfThreads];

			//for (int j = 0; j < numberOfThreads; j++)
			//{
			//    thread[j] = new Thread(job);
			//    thread[j].Start();
			//}

			//Console.ReadLine();
		}

		//static void singleThreadJob()
		//{
		//    DateTime before;
		//    DateTime after;
		//    TimeSpan executionTime;
		//    before = DateTime.Now;
		//    Console.WriteLine("nightly run started");
		//    SpExecutor.TestExecuteSP();
		//    after = DateTime.Now;
		//    executionTime = after.Subtract(before);
		//    Console.WriteLine("nightly run start at: {0}", before);
		//    Console.WriteLine("nightly run finished at: {0}", after);
		//    Console.WriteLine("execution time:\t{0}", executionTime);
		//}

		//static void ThreadJob()
		//{
		//    int currentThread, waitMS, nrRow1, nrRow2;
		//    lock (lockObj)
		//    {
		//        currentThread = threadId;
		//        threadId++;
		//    }
		//    Random r = new Random();
		//    DateTime before;
		//    TimeSpan executionTime;
		//    for (int i = 0; i < numberOfRuns; i++)
		//    {
		//        // random delay
		//        waitMS = r.Next(999) + 1;
		//        Thread.Sleep(waitMS);

		//        // execute stored procedures

		//        before = DateTime.Now;

		//        // ............... Wolfgangs code start ...................
		//        nrRow1 = SpExecutor.TestExecuteSP2();

		//        Thread.Sleep(200);

		//        // ............... Wolfgangs code end ...................
		//        nrRow2 = SpExecutor.TestExecuteSP3();

		//        executionTime = DateTime.Now.Subtract(before);

		//        if (i < numberOfRuns-1)
		//            Console.WriteLine("{0}\t{1}\t{2}\t{3}", currentThread, i, waitMS, executionTime);
		//        else
		//            Console.WriteLine("{0}\t{1}\t{2}\t{3}   thread {4} ended", currentThread, i, waitMS, executionTime, currentThread);
		//    }
		//}


		//        private static void TestExecuteSP()
		//        {
		//            int nrRows = 0;
		//            List<SqlParameter> parameters = new List<SqlParameter>();
		//            //nrRows = ExecuteSP("exec giseditor.XCP_CREATE_SNAPSHOT_XML", parameters); //7:12
		//            //nrRows = ExecuteSP("exec giseditor.XCP_PrepareExplorerSemiValidatedXML", parameters);//20:11
		//            //nrRows = ExecuteSP("exec giseditor.XCP_PrepareExplorerPreliminaryXML", parameters);//8:08
		//            //nrRows = ExecuteSP("exec giseditor.XCP_CREATE_ADMINISTRATION_XML", parameters);//1:22:18
		//            //nrRows = ExecuteSP("exec giseditor.XCP_POPULATE_XC_MEASUREMENT_LTO", parameters);//0:17
		//            nrRows = ExecuteSP("exec giseditor.XCP_POPULATE_XC_STATION_EXCEEDANCES_SEASON", parameters);//0:1
		//            //nrRows = ExecuteSP("exec giseditor.XCP_CREATE_STATIC_MAP", parameters); //0:57
		//            nrRows = ExecuteSP("exec giseditor.XCP_CREATE_EXPLORER_OUTPUT_XML", parameters); //0:7
		//        }


		//        private static int TestExecuteSP2()
		//        {
		//            List<SqlParameter> parameters = new List<SqlParameter>();
		//            Guid test_provider = new Guid(); new Guid("79662EAE-1247-4F03-B10B-4A2A014B09F1"); // --pName ='fr_ademe'
		//            parameters.Add(new SqlParameter("pGuid", test_provider));
		//            return ExecuteSP("exec giseditor.[XCP_GET_PROVIDER_TRUST_XML] @pGuid", parameters);
		//        }


		//        private static int TestExecuteSP3()
		//        {
		//            int nrRows = 0;
		//            List<SqlParameter> parameters = new List<SqlParameter>();
		//            parameters.Add(new SqlParameter("@country", "AT"));
		//            nrRows = ExecuteSP("exec giseditor.[XCP_ACTIVE_STATIONS] @country", parameters);

		//            parameters.Clear();
		//            parameters.Add(new SqlParameter("@country", "AT"));
		//            nrRows = ExecuteSP("exec giseditor.XCP_GET_EXPLORER_INTERPOLATE_STATION @country", parameters);

		//            parameters.Clear();
		//            parameters.Add(new SqlParameter("@country", "AT"));
		//            nrRows = ExecuteSP("exec giseditor.XCP_GET_EXPLORER_MAX_MONTH_XML @country", parameters);

		//            parameters.Clear();
		//            nrRows = ExecuteSP("exec [giseditor].[XCP_GET_SNAPSHOT_XML] ", parameters);
		//            //-- test of prepared XMLs
		//            //exec [giseditor].[XCP_GET_EXPLORER_MONTHLY_XML] 0 -- preliminary
		//            //exec [giseditor].[XCP_GET_EXPLORER_MONTHLY_XML] 1 -- semivalidated / approved

		//            return nrRows;
		//        }

		////exec giseditor.XCP_GET_ADMINISTRATION @provider_id
		////exec giseditor.XCP_GET_PROVIDER_XML 'dk_dmu'
		////exec giseditor.XCP_GET_STATION_DATA_XML 1,@sEoI_Code

		//        private static int ExecuteSP(string spName, IEnumerable<SqlParameter> parameters)
		//        {
		//            using (SqlConnection connection = new SqlConnection(@"Data Source=SDKCGA6047\MAIN;Initial Catalog=sor;User ID=gis;password=tmggis"))
		//            {
		//                int nrRows = 0;
		//                connection.Open();
		//                SqlCommand cmdActiveStations = new SqlCommand(spName, connection);
		//                cmdActiveStations.CommandTimeout = 100000000;
		//                foreach (SqlParameter param in parameters)
		//                {
		//                    cmdActiveStations.Parameters.Add(param);
		//                }
		//                using (SqlDataReader rdr = cmdActiveStations.ExecuteReader())
		//                {
		//                    nrRows = rdr.RecordsAffected;
		//                    //if (rdr.RecordsAffected)
		//                    //{
		//                    //    throw new Exception();
		//                    //}
		//                }
		//                return nrRows;
		//            }
		//        }

		//private static void SP1()
		//{
		//    using (SqlConnection connection = new SqlConnection(@"Data Source=SDKCGA6047\MAIN;Initial Catalog=sor;User ID=gis;password=tmggis"))
		//    {
		//        connection.Open();
		//        SqlCommand cmdActiveStations = new SqlCommand(
		//            "exec giseditor.[XCP_ACTIVE_STATIONS] @country", connection);

		//        cmdActiveStations.Parameters.Add(new SqlParameter("@country", "AT"));

		//        int nrActiveStations = 0;
		//        using (SqlDataReader rdr = cmdActiveStations.ExecuteReader())
		//        {
		//            if (rdr.Read())
		//            {
		//                if (!rdr.IsDBNull(0))
		//                {
		//                    nrActiveStations = rdr.GetInt32(0);
		//                }
		//            }
		//        }
		//        Console.WriteLine("you are here");
		//    }

		//}


	}
}
