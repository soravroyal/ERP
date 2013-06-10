using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EPRTR_Import_CMD
{

    class TraceTargetConsole : Altova.TraceTarget
    {
        public void WriteTrace(string info)
        {
            Console.Out.WriteLine(info);
        }
    }
}
