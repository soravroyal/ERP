﻿using System;
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
            new DatabaseTable("RDF_AnnexIActivity", null, true),
		    new DatabaseTable("RDF_AreaGroup", null, true), 
		    new DatabaseTable("RDF_Confidentiality", null, true),
		    new DatabaseTable("RDF_CoordinateSystem", null, true),
		    new DatabaseTable("RDF_Country", null, true),
		    // TODO: new DatabaseTable("LOV_CountryAreaGroup", ??),
		    new DatabaseTable("RDF_Medium", null, true),
		    new DatabaseTable("RDF_MethodBasis", null, true),
		    new DatabaseTable("RDF_MethodType", null, true),
		    new DatabaseTable("RDF_NACEActivity", null, true),
		    new DatabaseTable("RDF_NUTSRegion", null, true),
		    new DatabaseTable("RDF_Pollutant", null, true),
		    // TODO: new DatabaseTable("LOV_PollutantThreshold", ??),
		    new DatabaseTable("RDF_RiverBasinDistrict", null, true),
		    new DatabaseTable("RDF_Status", "Code", true),
		    new DatabaseTable("RDF_Unit", null, true),
		    // TODO: new DatabaseTable("LOV_WasteThreshold", ??),
		    new DatabaseTable("RDF_WasteTreatment", null, true),
		    new DatabaseTable("RDF_WasteType", "Code", true),
            new DatabaseTable("RDF_Facility"),
		    new DatabaseTable("RDF_Activity"),
            new DatabaseTable("RDF_CompetentAuthority"),
		    //new DatabaseTable("RDF_Eper2EPRTR_AnnexIActivity"),
		    //new DatabaseTable("RDF_Eper2EPRTR_NACEActivity", "EPER_Code"),
		    new DatabaseTable("RDF_FacilityID_Changes"),
		    new DatabaseTable("RDF_FacilityReport"),
		    new DatabaseTable("RDF_PollutantRelease"),
		    new DatabaseTable("RDF_PollutantReleaseMethodUsed"),
		    new DatabaseTable("RDF_PollutantTransfer"),
		    new DatabaseTable("RDF_PollutantTransferMethodUsed"),
		    new DatabaseTable("RDF_UploadedReports"),
		    new DatabaseTable("RDF_WasteTransfer"),
		    new DatabaseTable("RDF_WasteTransferMethodUsed")
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
            WriteMakeFile(ExportableTables, argsParser.ZipOutput);

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

        static void WriteMakeFile(DatabaseTable[] databaseTables, Boolean zipOutput)
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
                    rdfExportTables.Append(String.Format("java -cp $(CLASSPATH) GenerateRDF -o{0}.rdf {1}{2}",
                        EprtrDatabase.TrimTablePrefix(databaseTable.TableName),
                        EprtrDatabase.ToClassName(databaseTable.TableName),
                        zipOutput ? " -z" : string.Empty));
                }
            }

            StringBuilder lookupTablesStr = new StringBuilder();
            lookupTablesStr.Append(lookupTables.ToString());
            if (zipOutput)
            {
                lookupTablesStr.Append(" -z");
            }
            templateFileContents = templateFileContents.Replace(
                "{LookupTables}", lookupTablesStr.ToString());
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