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

        const String QUERY_TABLE_LIST = @"
            SELECT NAME FROM sys.objects
            WHERE TYPE_DESC='VIEW' AND
                  NAME LIKE 'PUBLISH_%'
                  OR
                  TYPE_DESC='USER_TABLE' AND
                  NAME LIKE 'LOV_%'
            ORDER BY NAME";

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

                List<String> exportableTables = GetExporableTables(conn);
                StringBuilder propertiesContents = new StringBuilder();
                propertiesContents.Append(CreateTableListProperty(exportableTables));
                propertiesContents.Append("\n\n");
                propertiesContents.Append(CreateQueryListProperties(conn, exportableTables));
                WritePropertiesFile(propertiesContents.ToString());

                conn.Close();
            }
        }

        static List<String> GetExporableTables(SqlConnection conn)
        {
            SqlCommand cmd = new SqlCommand(QUERY_TABLE_LIST, conn);
            SqlDataReader reader = cmd.ExecuteReader();
            
            List<string> exportableTables = new List<string>();
            while (reader.Read())
            {
                exportableTables.Add(reader.GetString(0));
            }

            reader.Close();
            return exportableTables;
        }

        static string CreateTableListProperty(List<string> tables)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("tables = ");
            for (int i = 0; i < tables.Count; i++)
            {
                sb.Append(ToClassName(tables[i]));
                if (i < tables.Count - 1)
                {
                    sb.Append(" \\\n\t\t");
                }
            }
            return sb.ToString();
        }

        static string CreateQueryListProperties(SqlConnection conn, List<string> tables)
        {
            StringBuilder sb = new StringBuilder();
            foreach (string table in tables)
            {
                string className = ToClassName(table);
                sb.Append(string.Format("{0}.class = {0}\n", className));
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
                columnNames.Add(reader.GetString(0));
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

        static string ToClassName(string tableName)
        {
            string className = tableName.Replace("LOV_", string.Empty)
                                        .Replace("PUBLISH_", string.Empty);
            if (string.IsNullOrEmpty(className))
            {
                return string.Empty;
            }

            return char.ToUpper(className[0]) + className.Substring(1).ToLower();
        }
    }
}
