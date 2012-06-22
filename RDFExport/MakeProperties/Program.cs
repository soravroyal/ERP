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

        static string[] ExportableTables = new string[]
        {
            "LOV_AnnexIActivity",
		    "LOV_AreaGroup", 
		    "LOV_Confidentiality",
		    "LOV_CoordinateSystem",
		    "LOV_Country",
		    "LOV_CountryAreaGroup",
		    "LOV_Medium",
		    "LOV_MethodBasis",
		    "LOV_MethodType",
		    "LOV_NACEActivity",
		    "LOV_NUTSRegion",
		    "LOV_Pollutant",
		    "LOV_PollutantThreshold",
		    "LOV_RiverBasinDistrict",
		    "LOV_Status",
		    "LOV_Unit",
		    "LOV_WasteThreshold",
		    "LOV_WasteTreatment",
		    "LOV_WasteType",
		    "PUBLISH_Activity",
		    "PUBLISH_Eper2EPRTR_AnnexIActivity",
		    "PUBLISH_Eper2EPRTR_NACEActivity",
		    "PUBLISH_FacilityID_Changes",
		    "PUBLISH_FacilityReport",
		    "PUBLISH_PollutantRelease",
		    "PUBLISH_PollutantReleaseAndTransferReport",
		    "PUBLISH_PollutantReleaseMethodUsed",
		    "PUBLISH_PollutantTransfer",
		    "PUBLISH_PollutantTransferMethodUsed",
		    "PUBLISH_UploadedReports",
		    "PUBLISH_WasteTransfer",
		    "PUBLISH_WasteTransferMethodUsed"
        };

        static AliasColumn[] AliasColumns = new AliasColumn[] 
        {
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
                TableName = "PUBLISH_WASTETRANSFER",
                ColumnName = "FacilityReportID",
                ForeignPropertyName = "facilityReport"
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
        }

        static string CreateTableListProperty(string[] tables)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("tables = ");
            for (int i = 0; i < tables.Length; i++)
            {
                sb.Append(TrimTablePrefix(tables[i]));
                if (i < tables.Length - 1)
                {
                    sb.Append(" \\\n\t\t");
                }
            }
            return sb.ToString();
        }

        static string CreateQueryListProperties(SqlConnection conn, string[] tables)
        {
            StringBuilder sb = new StringBuilder();
            foreach (string table in tables)
            {
                string className = ToClassName(table);
                sb.Append(string.Format("{0}.class = {1}\n", className, TrimTablePrefix(table)));
                sb.Append(string.Format("{0}.query = {1}\n", className, CreateTableQuery(conn, table)));
                sb.Append("\n");
            }
            return sb.ToString();
        }

        static string CreateTableQuery(SqlConnection conn, string table)
        {
            SqlCommand cmd = new SqlCommand(string.Format(@"
                                                SELECT NAME FROM sys.columns 
                                                WHERE object_id = OBJECT_ID('{0}')",
                                            table), conn);
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

            string separator = "";
            foreach (string columnName in columnNames)
            {
                sb.Append(separator);
                separator = " \\\n ,";

                sb.Append(columnName);

                if (AliasColumns.Count(c =>
                    c.TableName.Equals(table, StringComparison.InvariantCultureIgnoreCase)
                    &&
                    c.ColumnName.Equals(columnName, StringComparison.InvariantCultureIgnoreCase)
                    ) == 1)
                {
                    AliasColumn foreignColumn = AliasColumns.Single(c =>
                    c.TableName.Equals(table, StringComparison.InvariantCultureIgnoreCase)
                    &&
                    c.ColumnName.Equals(columnName, StringComparison.InvariantCultureIgnoreCase)
                    );

                    sb.Append(separator);
                    sb.Append(String.Format("{0} as {1}", columnName, foreignColumn.ForeignPropertyName));
                }
            } 

            if (table.ToUpper().StartsWith("LOV_") && 
                columnNames.Contains("Code") &&
                columnNames.Contains("Name"))
            {
                sb.Append(separator);
                sb.Append("Code + ' - ' + Name AS 'rdfs:label'");
            }

            sb.Append(" \\\n FROM " + table);
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
    }
}
