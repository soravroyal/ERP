using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Altova.Types;
using eprtr;

namespace EPRTR_Import_CMD
{
    class Program
    {
        private static string localfile;
        private static string server;
        private static string username;
        private static string pw;
        private static string outputstring;

        static void Main(string[] args)
        {
            if (args.Length != 4) { return;}

            localfile = args[0];
            server = args[1];
            username = args[2];
            pw = args[3];

            //outputstring = "Provider=SQLOLEDB.1; Data Source=sdkcga6306; User ID=sa;Password=tmggis;Initial Catalog=EPRTRxml;Persist Security Info=true;Auto Translate=false;Tag with column collation=false;Use Encryption for Data=false;Mars_Connection=no;";
            outputstring = "Provider=SQLOLEDB.1; Data Source=" + server + "; User ID="+username+";Password="+pw+";Initial Catalog=EPRTRxml;Persist Security Info=true;Auto Translate=false;Tag with column collation=false;Use Encryption for Data=false;Mars_Connection=no;";


            ImportXml(localfile,outputstring);
        }

        public static void ImportXml(string xmlFileName,string outputstring)
        {
            try
            {
                TraceTargetConsole ttc = new TraceTargetConsole();
                eprtrMapToEPRTRxml1 eprtrMapToEPRTRxml1Object = new eprtrMapToEPRTRxml1();
                eprtrMapToEPRTRxml1Object.RegisterTraceTarget(ttc);

                Altova.IO.Input PollutantReleaseAndTransferReport2Source = new Altova.IO.FileInput(xmlFileName);

                eprtrMapToEPRTRxml1Object.Run(
                PollutantReleaseAndTransferReport2Source,
                outputstring);
                //"Provider=SQLOLEDB.1; Data Source=sdkcga6306; User ID=sa;Password=tmggis;Initial Catalog=EPRTRxml;Persist Security Info=true;Auto Translate=false;Tag with column collation=false;Use Encryption for Data=false;Mars_Connection=no;");
            }
            catch (Exception e)
            {
                throw e;
            }
        }
    }
}
