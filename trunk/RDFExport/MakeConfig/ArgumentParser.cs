using System;
using System.IO;
using NDesk.Options;
using System.Globalization;

namespace MakeProperties
{
    class ArgumentParser
    {
        public string Server;
        public string DbName;
        public string User;
        public string Password;
        public bool ShowHelp;
        public bool ZipOutput;

        private string[] Args;
        private OptionSet OptionSet;

        public ArgumentParser(string[] args)
        {
            this.Args = args;

            Server = "SDKCGA6332";
            DbName = "EPRTRMaster";
            User = "gis";
            Password = "tmggis";
            ShowHelp = false;

            OptionSet = new OptionSet() {
                { "h|help=",  "Vis help. Shows this output.", 
                   v => ShowHelp = v != null },
                { "s|server=", "Database server.",
                   v => Server = v },
                { "db=", "Database name.",
                   v => DbName = v },
                { "u|user=", "User name.",
                   v => User = v },
                { "p|password=", 
                   "Database password.",
                   v => Password = v },
                { "z|zip",  "Zip the output.", 
                   v => ZipOutput = v != null }};
        }

        public void Parse()
        {
            try
            {
                OptionSet.Parse(Args);
            }
            catch (OptionException)
            {
                ShowHelp = true;
            }
        }

        public string GetHelp()
        {
            TextWriter writer = new StringWriter();
            OptionSet.WriteOptionDescriptions(writer);
            return writer.ToString();
        }
    }
}
