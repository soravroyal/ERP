using System;
namespace SPPerformanceTester
{
    interface ITestRunDataProvider
    {
        T_Jobs GetJobs();
        T_Thread GetThreadFromRefId(string id);
        int GetExectutionTime();
        int GetCommandTimeout();
    }
}
