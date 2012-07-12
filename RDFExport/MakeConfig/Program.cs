using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.IO;

namespace MakeProperties
{
    class Program
    {
        static DatabaseTable[] ExportableTables = new DatabaseTable[]
        {
            new DatabaseTable("LOV_AnnexIActivity", "Code", true),
		    new DatabaseTable("LOV_AreaGroup", "Code", true), 
		    new DatabaseTable("LOV_Confidentiality", "Code", true),
		    new DatabaseTable("LOV_CoordinateSystem", "Code", true),
		    new DatabaseTable("LOV_Country", "Code", true),
		    // TODO: new DatabaseTable("LOV_CountryAreaGroup", ??),
		    new DatabaseTable("LOV_Medium", "Code", true),
		    new DatabaseTable("LOV_MethodBasis", "Code", true),
		    new DatabaseTable("LOV_MethodType", "Code", true),
		    new DatabaseTable("LOV_NACEActivity", "Code", true),
		    new DatabaseTable("LOV_NUTSRegion", "Code", true),
		    new DatabaseTable("LOV_Pollutant", "Code", true),
		    // TODO: new DatabaseTable("LOV_PollutantThreshold", ??),
		    new DatabaseTable("LOV_RiverBasinDistrict", "Code", true),
		    new DatabaseTable("LOV_Status", "Code", true),
		    new DatabaseTable("LOV_Unit", "Code", true),
		    // TODO: new DatabaseTable("LOV_WasteThreshold", ??),
		    new DatabaseTable("LOV_WasteTreatment", "Code", true),
		    new DatabaseTable("LOV_WasteType", "Code", true),
            new DatabaseTable("Facility", "FacilityID", true),
		    new DatabaseTable("PUBLISH_Activity"),
		    new DatabaseTable("PUBLISH_Eper2EPRTR_AnnexIActivity"),
		    new DatabaseTable("PUBLISH_Eper2EPRTR_NACEActivity"),
		    new DatabaseTable("PUBLISH_FacilityID_Changes"),
		    new DatabaseTable("PUBLISH_FacilityReport"),
		    new DatabaseTable("PUBLISH_PollutantRelease"),
		    new DatabaseTable("PUBLISH_PollutantReleaseAndTransferReport"),
		    new DatabaseTable("PUBLISH_PollutantReleaseMethodUsed"),
		    new DatabaseTable("PUBLISH_PollutantTransfer"),
		    new DatabaseTable("PUBLISH_PollutantTransferMethodUsed"),
		    new DatabaseTable("PUBLISH_UploadedReports"),
		    new DatabaseTable("PUBLISH_WasteTransfer"),
		    new DatabaseTable("PUBLISH_WasteTransferMethodUsed")
        };

        static void Main(string[] args)
        {
            ArgumentParser argsParser = new ArgumentParser(args);
            argsParser.Parse();

            if (argsParser.ShowHelp)
            {
                Console.WriteLine(argsParser.GetHelp());
                return;
            }

            // Generate rdfexport.properties
            using (EprtrDatabase db = new EprtrDatabase(
                argsParser.Server, argsParser.DbName,
                argsParser.User, argsParser.Password))
            {
                StringBuilder propertiesContents = new StringBuilder();
                propertiesContents.Append(db.GetTableListProperty(ExportableTables));
                propertiesContents.Append("\n\n");
                propertiesContents.Append(db.GetQueryListProperties(ExportableTables));

                WritePropertiesFile(propertiesContents.ToString());
            }

            // Generate Makefile
            WriteMakeFile(ExportableTables);

            // Generate Database properties file
            WriteDbPropertiesFile(argsParser.Server, argsParser.DbName,
                argsParser.User, argsParser.Password);
        }

        static void WritePropertiesFile(string contents)
        {
            TextReader tr = new StreamReader(@"templates\rdfexport.properties.template");
            string templateFileContents = tr.ReadToEnd();

            using (StreamWriter propertiesFile = new StreamWriter(@"rdfexport.properties"))
            {
                propertiesFile.WriteLine(templateFileContents);
                propertiesFile.WriteLine(contents);
                propertiesFile.Flush();
            }
        }

        static void WriteMakeFile(DatabaseTable[] databaseTables)
        {
            TextReader tr = new StreamReader(@"templates\Makefile.template");
            string templateFileContents = tr.ReadToEnd();

            StringBuilder lookupTables = new StringBuilder();
            string lookupTablesSeparator = "";

            StringBuilder rdfExportTables = new StringBuilder();
            string rdfExportTablesSeparator = "";

            foreach (DatabaseTable databaseTable in databaseTables)
            {
                if (databaseTable.IsLookupTable)
                {
                    lookupTables.Append(lookupTablesSeparator);
                    lookupTablesSeparator = " ";
                    lookupTables.Append(EprtrDatabase.ToClassName(databaseTable.TableName));
                }
                else
                {
                    rdfExportTables.Append(rdfExportTablesSeparator);
                    rdfExportTablesSeparator = "\n\t";
                    rdfExportTables.Append(String.Format("java -cp $(CLASSPATH) GenerateRDF {0} > {1}.rdf",
                        EprtrDatabase.ToClassName(databaseTable.TableName),
                        EprtrDatabase.TrimTablePrefix(databaseTable.TableName)));
                }
            }

            templateFileContents = templateFileContents.Replace(
                "{LookupTables}", lookupTables.ToString());
            templateFileContents = templateFileContents.Replace(
                "{rdfExportTables}", rdfExportTables.ToString());

            using (StreamWriter propertiesFile = new StreamWriter(@"Makefile"))
            {
                propertiesFile.WriteLine(templateFileContents);
                propertiesFile.Flush();
            }
        }

        static void WriteDbPropertiesFile(string server, string dbName, string user, string password)
        {
            TextReader tr = new StreamReader(@"templates\database.properties.template");
            string templateFileContents = tr.ReadToEnd();

            templateFileContents = templateFileContents
                .Replace("{server}", server)
                .Replace("{dbName}", dbName)
                .Replace("{user}", user)
                .Replace("{password}", password);

            using (StreamWriter propertiesFile = new StreamWriter(@"database.properties"))
            {
                propertiesFile.WriteLine(templateFileContents);
                propertiesFile.Flush();
            }
        }
    }
}
