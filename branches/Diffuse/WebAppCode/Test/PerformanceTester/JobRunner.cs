using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Threading;
using System.IO;

namespace SPPerformanceTester
{
    public class JobRunner
    {
        StreamWriter outputWriter;
        private readonly object writerLock = new object();

        private ITestRunDataProvider testRunDataProvider
        {
            get { return (ITestRunDataProvider)ServiceLocator.Instance.GetService(typeof(ITestRunDataProvider)); }
        }
        public JobRunner(StreamWriter outputWriter)
        {
            this.outputWriter = outputWriter;
        }
        public void RunJob(T_Job job)
        {
            TimeSpan runTime = TimeSpan.FromSeconds(testRunDataProvider.GetExectutionTime());
			Console.WriteLine(Environment.NewLine);
			Console.ForegroundColor = ConsoleColor.Green;
			Console.WriteLine("----- Starting Job: {0} -----", job.name);
			Console.WriteLine(DateTime.Now.ToLocalTime().ToString());
			Console.WriteLine(Environment.NewLine);
			Console.ForegroundColor = ConsoleColor.Gray;
            List<Thread> threads = new List<Thread>();
            if (job.Threads != null)
            {

                if (job.Threads.Thread != null)
                {
                    foreach (T_Thread thread in job.Threads.Thread)
                    {
                        int concurrentThreadCount = 1;
                        if (thread.ThreadCopiesSpecified && thread.ThreadCopies > 1)
                        {
                            concurrentThreadCount = thread.ThreadCopies;
                        }
                        threads.AddRange(StartThread(thread, job.name, runTime, concurrentThreadCount));
                    }
                }
                if (job.Threads.ThreadRef != null)
                {
                    foreach (T_ThreadRef threadref in job.Threads.ThreadRef)
                    {
                        T_Thread thread = testRunDataProvider.GetThreadFromRefId(threadref.Id);
                        int concurrentThreadCount = 1;
                        if (threadref.ThreadCopiesSpecified && threadref.ThreadCopies > 1)
                        {
                            concurrentThreadCount = threadref.ThreadCopies;
                        }
                        threads.AddRange(StartThread(thread, job.name, runTime, concurrentThreadCount));
                    }
                }
            }
            bool threadsFinished = false;
            while (!threadsFinished)
            {
                threadsFinished = true;
                foreach (Thread thread in threads)
                {
                    if (thread.ThreadState == ThreadState.Running)
                    {
                        threadsFinished = false;
                        Thread.Sleep(1000);
                        break;
                    }
                }
            }
			Console.WriteLine(Environment.NewLine);
			Console.ForegroundColor = ConsoleColor.Red;
			Console.WriteLine(System.DateTime.Now.ToLocalTime().ToString());
			Console.WriteLine("----- Finished Job: {0} -----", job.name);
			Console.ForegroundColor = ConsoleColor.Gray;
			Console.WriteLine(Environment.NewLine);
		}
        public IEnumerable<Thread> StartThread(T_Thread thread, string jobName, TimeSpan runTime, int concurrentThreadCount)
        {
            for (int i = 0; i < concurrentThreadCount; i++)
            {
                ThreadStart singleJob = delegate { DoThreadWork(thread, jobName, runTime); };
                Thread singleThread = new Thread(singleJob);
                singleThread.Start();
                yield return singleThread;
            }

        }
        public void DoThreadWork(T_Thread thread, string jobName, TimeSpan runTime)
        {
            string exceptions = "";
            DateTime start = DateTime.Now;
            DateTime endtime = start.Add(runTime);
            long i = 0;
            try
            {
                while (DateTime.Now < endtime)
                {
                    if (thread.Tasks.StoredProcedure != null)
                    {
                        foreach (DatabaseJob job in thread.Tasks.StoredProcedure)
                        {
                            ExectuteDatabaseJob(job);
                        }
                    }
                    if (thread.Tasks.Script != null)
                    {
                        foreach (DatabaseJob job in thread.Tasks.Script)
                        {
                            ExectuteDatabaseJob(job);
                        }
                    }
                    i++;
                }
            }
            catch (Exception e)
            {
                exceptions += e.Message.Replace(Environment.NewLine, " ");
            }
            TimeSpan executionTime = DateTime.Now - start;
            lock (writerLock)
            {
                outputWriter.WriteLine(string.Format("{0}; {1}; {2}; {3}; {4}", jobName, thread.name, i, executionTime, exceptions));
                outputWriter.Flush();
            }
        }
        public void ExectuteDatabaseJob(DatabaseJob job)
        {
            List<IDataParameter> parameters = new List<IDataParameter>();
            if (job.Parameters != null)
            {
                foreach (T_Parameter param in job.Parameters)
                {

                    parameters.Add(CreateParameter(param));
                }
            }

            RunSp(job.executionString.ToString(), parameters);
        }
        public void RunSp(string spMethodName, IEnumerable<IDataParameter> spParameters)
        {
            SpExecutor.ExecuteSP(spMethodName, spParameters);
        }
        public SqlParameter CreateParameter(T_Parameter inputParameter)
        {
            string name = inputParameter.name;
            object value;
            if (inputParameter.valueTypeSpecified)
            {
                switch (inputParameter.valueType)
                {
                    case T_ParameterValueType.datetime:
                        value = DateTime.Parse(inputParameter.value);
                        break;
                    case T_ParameterValueType.@decimal:
                        value = decimal.Parse(inputParameter.value);
                        break;
                    case T_ParameterValueType.@double:
                        value = double.Parse(inputParameter.value);
                        break;
                    case T_ParameterValueType.@int:
                        value = int.Parse(inputParameter.value);
                        break;
                    default:
                        value = inputParameter.value;
                        break;
                }
            }
            else
            {
                value = inputParameter.value;
            }
            return new SqlParameter(name, value);

        }
    }
}
