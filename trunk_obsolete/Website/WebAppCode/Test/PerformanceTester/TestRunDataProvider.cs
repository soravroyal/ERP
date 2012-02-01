using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.IO;


namespace SPPerformanceTester
{
    public class TestRunDataProvider : SPPerformanceTester.ITestRunDataProvider
    {
        private T_Jobs jobs;

        public TestRunDataProvider(string path)
        {
            XmlSerializer serializer = new XmlSerializer(typeof(T_Jobs));
            XmlReader xmlreader = XmlReader.Create(path);
            this.jobs = (T_Jobs)serializer.Deserialize(xmlreader);
        }
        public T_Jobs GetJobs()
        {
            return jobs;
        }
        public T_Thread GetThreadFromRefId(string id)
        {
            foreach (T_Job job in jobs.Job)
            {
                if (job.Threads != null && job.Threads.Thread != null)
                {
                    foreach (T_Thread thread in job.Threads.Thread)
                    {
                        if (id == thread.Id)
                        {
                            return thread;
                        }
                    }
                }
            }
            return null;
        }

        public int GetExectutionTime()
        {
            return this.jobs.executionTime;
        }

        public int GetCommandTimeout()
        {
            return this.jobs.commandTimeout;
        }
    }
}
