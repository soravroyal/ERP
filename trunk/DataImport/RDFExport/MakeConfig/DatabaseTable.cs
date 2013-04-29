using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MakeProperties
{
    struct DatabaseTable
    {
        public string TableName;
        public string IdentifierColumnName;
        public bool IsLookupTable;

        public DatabaseTable(string tableName)
            : this(tableName, null, false)
        {
        }

        public DatabaseTable(
            string tableName,
            string identifierColumnName)
            : this(tableName, identifierColumnName, false)
        {
        }

        public DatabaseTable(
            string tableName, 
            string identifierColumnName, 
            bool isLookupTable)
        {
            this.TableName = tableName;
            this.IdentifierColumnName = identifierColumnName;
            this.IsLookupTable = isLookupTable;
        }
    }
}
