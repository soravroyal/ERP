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
        const String CONN_STRING = @"
            Server=SDKCGA6332;
            Database=EPRTRMaster;
            User ID=gis;
            Password=tmggis;
            Trusted_Connection=False;";

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

        static AliasColumn[] AliasColumns = new AliasColumn[] 
        {
            new AliasColumn
            {
                TableName = "PUBLISH_Activity",
                ColumnName = "FacilityReportID",
                ForeignPropertyName = "facilityReport"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_Activity",
                ColumnName = "AnnexIActivityCode",
                ForeignPropertyName = "annexIActivity"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_FACILITYREPORT",
                ColumnName = "RBDSourceCode",
                ForeignPropertyName = "forRBD"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_FACILITYREPORT",
                ColumnName = "NUTSRegionSourceCode",
                ForeignPropertyName = "forNUTS"
            },
            new AliasColumn
            {
                TableName = "LOV_MEDIUM",
                ColumnName = "Code",
                ForeignPropertyName = "id"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_FACILITYID_CHANGES",
                ColumnName = "CountryCode",
                ForeignPropertyName = "inCountry"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_FACILITYREPORT",
                ColumnName = "CountryCode",
                ForeignPropertyName = "inCountry"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_POLLUTANTRELEASEANDTRANSFERREPORT",
                ColumnName = "CountryCode",
                ForeignPropertyName = "inCountry"
            },
            new AliasColumn
            {
                TableName = "LOV_RIVERBASINDISTRICT",
                ColumnName = "Code",
                ForeignPropertyName = "'owl:sameAs->http://rdfdata.eionet.europa.eu/wise/rbd'"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_POLLUTANTRELEASE",
                ColumnName = "ReleaseMediumCode",
                ForeignPropertyName = "forMedium"
            },
            new AliasColumn
            {
                TableName = "LOV_POLLUTANT",
                ColumnName = "ParentID",
                ForeignPropertyName = "parentGroup"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_POLLUTANTRELEASE",
                ColumnName = "PollutantCode",
                ForeignPropertyName = "forPollutant"
            },
            new AliasColumn
            {
                TableName = "LOV_POLLUTANTTHRESHOLD",
                ColumnName = "LOV_PollutantID",
                ForeignPropertyName = "forPollutant"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_POLLUTANTTRANSFER",
                ColumnName = "PollutantCode",
                ForeignPropertyName = "forPollutant"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_POLLUTANTRELEASE",
                ColumnName = "FacilityReportID",
                ForeignPropertyName = "facilityReport"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_POLLUTANTTRANSFER",
                ColumnName = "FacilityReportID",
                ForeignPropertyName = "facilityReport"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_POLLUTANTTRANSFER",
                ColumnName = "MethodBasisCode",
                ForeignPropertyName = "methodBasis"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_POLLUTANTTRANSFER",
                ColumnName = "QuantityUnitCode",
                ForeignPropertyName = "unit"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_WASTETRANSFER",
                ColumnName = "FacilityReportID",
                ForeignPropertyName = "facilityReport"
            }, 
            new AliasColumn
            {
                TableName = "PUBLISH_WASTETRANSFERMETHODUSED",
                ColumnName = "MethodTypeCode",
                ForeignPropertyName = "methodType"
            }, 
            new AliasColumn
            {
                TableName = "PUBLISH_FACILITYREPORT",
                ColumnName = "FacilityID",
                ForeignPropertyName = "forFacility"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_POLLUTANTRELEASE",
                ColumnName = "FacilityID",
                ForeignPropertyName = "forFacility"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_POLLUTANTTRANSFER",
                ColumnName = "FacilityID",
                ForeignPropertyName = "forFacility"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_WASTETRANSFER",
                ColumnName = "FacilityID",
                ForeignPropertyName = "forFacility"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_WASTETRANSFER",
                ColumnName = "WasteTypeCode",
                ForeignPropertyName = "forWasteType"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_WASTETRANSFER",
                ColumnName = "WasteTreatment",
                ForeignPropertyName = "forWasteTreatment"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_WASTETRANSFER",
                ColumnName = "MethodBasisCode",
                ForeignPropertyName = "forMethod"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_WASTETRANSFER",
                ColumnName = "QuantityUnitCode",
                ForeignPropertyName = "unit"
            },
            new AliasColumn
            {
                TableName = "LOV_WASTETYPE",
                ColumnName = "ParentID",
                ForeignPropertyName = "parentType"
            },
            new AliasColumn
            {
                TableName = "LOV_WASTETHRESHOLD",
                ColumnName = "LOV_WasteTypeID",
                ForeignPropertyName = "forWasteType"
            },
            new AliasColumn
            {
                TableName = "PUBLISH_POLLUTANTRELEASE",
                ColumnName = "MethodBasisCode",
                ForeignPropertyName = "forMethod"
            }
        };

        static void Main(string[] args)
        {
            // Generate rdfexport.properties
            using (SqlConnection conn = new SqlConnection(CONN_STRING))
            {
                conn.Open();

                StringBuilder propertiesContents = new StringBuilder();
                propertiesContents.Append(CreateTableListProperty(ExportableTables));
                propertiesContents.Append("\n\n");
                propertiesContents.Append(CreateQueryListProperties(conn, ExportableTables));
                WritePropertiesFile(propertiesContents.ToString());

                conn.Close();
            }

            // Generate Makefile
            WriteMakeFile(ExportableTables);
        }

        static string CreateTableListProperty(DatabaseTable[] tables)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("tables = ");
            for (int i = 0; i < tables.Length; i++)
            {
                sb.Append(TrimTablePrefix(tables[i].TableName));
                if (i < tables.Length - 1)
                {
                    sb.Append(" \\\n\t\t");
                }
            }
            return sb.ToString();
        }

        static string CreateQueryListProperties(SqlConnection conn, DatabaseTable[] tables)
        {
            StringBuilder sb = new StringBuilder();
            foreach (DatabaseTable table in tables)
            {
                string className = ToClassName(table.TableName);
                sb.Append(string.Format("{0}.class = {1}\n", className, TrimTablePrefix(table.TableName)));
                sb.Append(string.Format("{0}.query = {1}\n", className, CreateTableQuery(conn, table)));
                sb.Append("\n");
            }
            return sb.ToString();
        }

        static string CreateTableQuery(SqlConnection conn, DatabaseTable table)
        {
            SqlCommand cmd = new SqlCommand(string.Format(@"
                                                SELECT NAME FROM sys.columns 
                                                WHERE object_id = OBJECT_ID('{0}')",
                                            table.TableName), conn);
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT ");

            List<string> columnNames = new List<string>();
            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                string columnName = reader.GetString(0);
                if (columnName.ToUpper().StartsWith("LOV_"))
                {
                    columnName = string.Format("{0} as {1}",
                        columnName, char.ToLower(columnName[4]) + columnName.Substring(5));
                }
                else
                {
                    columnName = char.ToLower(columnName[0]) + columnName.Substring(1);
                }
                columnNames.Add(columnName);
            }
            reader.Close();

            if (table.IdentifierColumnName != null)
            {
                foreach (string col in columnNames.ToList())
                {
                    if (col.Equals(table.IdentifierColumnName, 
                        StringComparison.InvariantCultureIgnoreCase) 
                        /*
                         ||
                        col.StartsWith("LOV_", StringComparison.InvariantCultureIgnoreCase) &&
                        col.EndsWith("ID", StringComparison.InvariantCultureIgnoreCase)
                         */)
                    {
                        columnNames.RemoveAt(columnNames.IndexOf(col));
                    }
                }

                columnNames.Insert(0, table.IdentifierColumnName);
            }

            string separator = "";
            foreach (string columnName in columnNames)
            {
                sb.Append(separator);
                separator = " \\\n ,";

                sb.Append(columnName);

                if (AliasColumns.Count(c =>
                    c.TableName.Equals(table.TableName, StringComparison.InvariantCultureIgnoreCase)
                    &&
                    c.ColumnName.Equals(columnName, StringComparison.InvariantCultureIgnoreCase)
                    ) == 1)
                {
                    AliasColumn foreignColumn = AliasColumns.Single(c =>
                    c.TableName.Equals(table.TableName, StringComparison.InvariantCultureIgnoreCase)
                    &&
                    c.ColumnName.Equals(columnName, StringComparison.InvariantCultureIgnoreCase)
                    );

                    sb.Append(separator);
                    sb.Append(String.Format("{0} as {1}", columnName, foreignColumn.ForeignPropertyName));
                }
            } 

            if (table.TableName.ToUpper().StartsWith("LOV_") && 
                columnNames.Contains("Code") &&
                columnNames.Contains("Name"))
            {
                sb.Append(separator);
                sb.Append("Code + ' - ' + Name AS 'rdfs:label'");
            }

            sb.Append(" \\\n FROM " + table.TableName);
            return sb.ToString();
        }

        static void WritePropertiesFile(string contents)
        {
            TextReader tr = new StreamReader("rdfexport.properties.template");
            string templateFileContents = tr.ReadToEnd();

            using (StreamWriter propertiesFile = new StreamWriter(@"rdfexport.properties"))
            {
                propertiesFile.WriteLine(templateFileContents);
                propertiesFile.WriteLine(contents);
                propertiesFile.Flush();
            }
        }

        static string TrimTablePrefix(string tableName)
        {
            return tableName.Replace("LOV_", string.Empty)
                            .Replace("PUBLISH_", string.Empty);
        }

        static string ToClassName(string tableName)
        {
            string className = TrimTablePrefix(tableName);

            if (string.IsNullOrEmpty(className))
            {
                return string.Empty;
            }

            return char.ToLower(className[0]) + className.Substring(1);
        }

        static void WriteMakeFile(DatabaseTable[] databaseTables)
        {
            TextReader tr = new StreamReader("Makefile.template");
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
                    lookupTables.Append(ToClassName(databaseTable.TableName));
                }
                else
                {
                    rdfExportTables.Append(rdfExportTablesSeparator);
                    rdfExportTablesSeparator = "\n\t";
                    rdfExportTables.Append(String.Format("java -cp $(CLASSPATH) GenerateRDF {0} > {1}.rdf",
                        ToClassName(databaseTable.TableName),
                        TrimTablePrefix(databaseTable.TableName)));
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
    }
}
