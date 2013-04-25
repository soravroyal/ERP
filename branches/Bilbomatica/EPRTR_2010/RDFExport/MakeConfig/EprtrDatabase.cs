using System;
using System.Data.SqlClient;
using System.Text;
using System.Collections.Generic;
using System.Linq;

namespace MakeProperties
{
    class EprtrDatabase : IDisposable
    {
        static AliasColumn[] AliasColumns = new AliasColumn[] 
        {
            new AliasColumn
            {
                TableName = "RDF_MEDIUM",
                ColumnName = "Code",
                ForeignPropertyName = "id"
            },
            new AliasColumn
            {
                TableName = "RDF_RIVERBASINDISTRICT",
                ColumnName = "Code",
                ForeignPropertyName = "'owl:sameAs->http://rdfdata.eionet.europa.eu/wise/rbd'"
            }
        };

        SqlConnection conn;

        public EprtrDatabase(string server, string dbName, string user, string password)
        {
            conn = new SqlConnection(String.Format(@"
                Server={0}; Database={1}; User ID={2}; Password={3}; Trusted_Connection=False;",
                server, dbName, user, password));

            conn.Open();
        }

        public string GetTableListProperty(DatabaseTable[] tables)
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

        public string GetQueryListProperties(DatabaseTable[] tables)
        {
            StringBuilder sb = new StringBuilder();
            foreach (DatabaseTable table in tables)
            {
                string className = ToClassName(table.TableName);
                sb.Append(string.Format("{0}.class = {1}\n", className, TrimTablePrefix(table.TableName)));
                if (className.Equals("facility", StringComparison.InvariantCultureIgnoreCase))
                {
                    sb.Append(string.Format("{0}.query1 = {1}\n", className, GetTableQuery(table)));

                    sb.Append(string.Format(
                        "\n{0}.query2 = SELECT f.FacilityID, r.FacilityReportID AS hasReport \\\n " +
                        "FROM dbo.Facility f \\\n JOIN dbo.FacilityReport AS r \\\n   " +
                        "ON r.FacilityID = f.FacilityID\n", className, GetTableQuery(table)));
                }
                else
                {
                    sb.Append(string.Format("{0}.query = {1}\n", className, GetTableQuery(table)));
                }
                sb.Append("\n");
            }
            return sb.ToString();
        }

        public string GetTableQuery(DatabaseTable table)
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

                if (columnName.Contains(":"))
                {
                    columnName = String.Format("\"{0}\"", columnName);
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
                         */
                           )
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

        public static string TrimTablePrefix(string tableName)
        {
            return tableName.Replace("LOV_", string.Empty)
                            .Replace("PUBLISH_", string.Empty)
                            .Replace("RDF_", string.Empty);
        }

        public static string ToClassName(string tableName)
        {
            string className = TrimTablePrefix(tableName);

            if (string.IsNullOrEmpty(className))
            {
                return string.Empty;
            }

            return char.ToLower(className[0]) + className.Substring(1);
        }

        public virtual void Dispose()
        {
            if (conn != null)
            {
                conn.Close();
                conn.Dispose();
            }
        }
    }
}
