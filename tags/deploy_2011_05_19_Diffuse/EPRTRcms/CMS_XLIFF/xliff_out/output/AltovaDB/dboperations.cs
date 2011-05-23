// dboperations.cs
// This file contains generated code and will be overwritten when you rerun code generation.

using System.Data;
using Altova.TypeInfo;

namespace Altova.Db
{
	public class DbTreeOperations
	{
		
		public class MemberIterator : System.Collections.IEnumerable, System.IDisposable
		{
			private IDataReader recordset;
						
			public MemberIterator(IDataReader rs)
			{
				recordset = rs;
			}
			
			public System.Collections.IEnumerator GetEnumerator() { return new Enumerator(recordset); }
			
			class Enumerator : System.Collections.IEnumerator
			{
				IDataReader recordset;
				public Enumerator(IDataReader recordset) { this.recordset = recordset; }
				public bool MoveNext() { return recordset.Read(); }
				public object Current { get { return (IDataRecord)recordset; } }
				public void Reset() { throw new System.InvalidOperationException("Reset not supported."); }
			}
			
			public void Dispose()
			{
				recordset.Close();
			}
			
			// foreach (IDataRecord x in y.GetElements(...)) 
		}
		
		public class ReadBack
		{
			string name;
			
			public ReadBack(string name)
			{
				this.name = name;
			}			
			
			public string Name { get { return name; } }
		}
				
		
		public class RecordBuffer
		{
			System.Collections.Hashtable values = new System.Collections.Hashtable();
			IDbConnection connection;			
			
			public RecordBuffer(IDbConnection connection) { this.connection = connection; }
			public void Set(string name, object value) { values[name] = value; }
			public object Get(string name)
			{
				return values[name];
			}
			
			static System.Data.DbType GetDbTypeFromObject(object o)
			{
				switch (System.Convert.GetTypeCode(o))
				{
					case System.TypeCode.Boolean:
						return System.Data.DbType.Boolean;
					
					case System.TypeCode.Byte:
						return System.Data.DbType.Byte;
					
					case System.TypeCode.Char:
						return System.Data.DbType.String;
					
					case System.TypeCode.DateTime:
						return System.Data.DbType.DateTime;
					
					case System.TypeCode.DBNull:
						return System.Data.DbType.String;
						
					case System.TypeCode.Decimal:
						return System.Data.DbType.Decimal;
						
					case System.TypeCode.Double:
						return System.Data.DbType.Double;
						
					case System.TypeCode.Empty:
						return System.Data.DbType.String;
						
					case System.TypeCode.Int16:
						return System.Data.DbType.Int16;
						
					case System.TypeCode.Int32:
						return System.Data.DbType.Int32;
						
					case System.TypeCode.Int64:
						return System.Data.DbType.Int64;
						
					case System.TypeCode.SByte:
						return System.Data.DbType.SByte;
						
					case System.TypeCode.Single:
						return System.Data.DbType.Single;
						
					case System.TypeCode.String:
						return System.Data.DbType.String;
						
					case System.TypeCode.UInt16:
						return System.Data.DbType.UInt16;
						
					case System.TypeCode.UInt32:
						return System.Data.DbType.UInt32;
						
					case System.TypeCode.UInt64:
						return System.Data.DbType.UInt64;
					
					default:
						if (o is byte[])
							return System.Data.DbType.Binary;
						return System.Data.DbType.Object;
				}
			}
			
			public bool Execute(Command command, TransactionHelper transactionHelper) 
			{
				using (IDbCommand dbCommand = connection.CreateCommand())
				{
					dbCommand.CommandText = command.Statement;
					dbCommand.Transaction = transactionHelper.Transaction;

					// Add parameters
					foreach(object parameter in command.Parameters)
					{
						IDataParameter param = dbCommand.CreateParameter();
						ReadBack rb = parameter as ReadBack;
						if (rb != null)
						{
							param.DbType = GetDbTypeFromObject(values[rb.Name]);
							param.Value = values[rb.Name];
						}
						else
						{
							param.DbType = GetDbTypeFromObject(parameter);
							param.Value = parameter;							
						}
                        if (param.Value == null)
                            param.Value = System.DBNull.Value;
						dbCommand.Parameters.Add(param);
					}

					if (command.IsAutoReadFieldsIntoBuffer)	// we are interested in the result
					{
						using (IDataReader reader = dbCommand.ExecuteReader())
						{
							if (reader.Read())
							{
								for (int i = 0; i != reader.FieldCount; ++i)
								{
									string name = reader.GetName(i);
									object value = reader.GetValue(i);
									values[name] = value;
								}							
								return true;
							}
						}
					}
					else // or we are not.
					{
						try {
							return dbCommand.ExecuteNonQuery() != 0;
						}
						catch( System.Exception e )
						{	
							bool	bErrorHandled = false;
							string 	sDescription = e.Message;

							// IBM/DB2: with this database-kind when UPDATE, DELETE or FETCH doesnot affect rows an error is thrown by the ODBC-driver
							// In reality the statement succeeds --> act as if it is so and ignore this specific error
							if( sDescription.IndexOf( "[IBM]" ) == 0  &&
								sDescription.IndexOf( "[DB2" ) >= 0  &&  
								sDescription.IndexOf( "SQL0100W" ) >= 0
							)
								bErrorHandled = true;

							if( !bErrorHandled )
								throw new Altova.Types.TargetUpdateFailureException("DB Command Execution Failure: " + command.Statement, e);						
						}
					}
					return false;
				}
			}
			
			public IDbConnection Connection { get { return connection; } }
			
			public bool Execute(System.Collections.ArrayList commandList, TransactionHelper transactionHelper) 
			{ 
				bool b = false; 
				foreach(Command command in commandList) b = Execute(command, transactionHelper); 
				return b; 
			}
			
			public int GetRowsToDelete() { return System.Convert.ToInt32(values["MAPFORCE_DEL_ROWS"]); }
		}
		
		/*
				using (Transaction action = new Transaction()) {
					
					action.Commit();
				} 
			
				=>
				Transaction action = new Transaction();
				try {
					...
					action.Commit();
				} finally 
				{
					action.Dispose();
				}
			*/
		
		public class TransactionHelper
		{
			string beginTrans;
			string commitTrans;
			string rollbackTrans;
			string savepoint;
			string rollbackSavepoint;
			IDbConnection connection;
			IDbTransaction transaction;
			int depth;
			
			public IDbTransaction Transaction { get { return transaction; } }
			
			void ExecuteCommandString(string s)
			{
				IDbCommand comm = connection.CreateCommand();
				comm.CommandText = s;
				comm.Transaction = Transaction;
				comm.ExecuteNonQuery();
			}
			
			void ExecuteCommandString(string s, string replaceName)
			{
				ExecuteCommandString(s.Replace(" %%TRANSACTION_NAME%% ", replaceName));
			}
			
			public TransactionHelper(IDbConnection conne, string begin, string commit,	string rollback,
				string save, string rollbackSave)
			{
				connection = conne;
				beginTrans = begin;
				commitTrans = commit;
				rollbackTrans = rollback;
				savepoint = save;
				rollbackSavepoint = rollbackSave;
				depth = 0;
			}
			
			public void BeginTrans(string transName)
			{
				if (depth == 0)
				{
					if (beginTrans.Length == 0)
						transaction = connection.BeginTransaction();
					else
						ExecuteCommandString(beginTrans);
				}
				else
				{
					if (savepoint.Length != 0)
						ExecuteCommandString(savepoint, transName);
				}
				++depth;
			}
			
			public void CommitTrans()
			{
				--depth;
				if (depth == 0)
				{
					if (beginTrans.Length == 0)
						transaction.Commit();
					else
						ExecuteCommandString(commitTrans);
				}
			}
			
			public void RollbackTrans(string transName)
			{
				--depth;
				if (depth == 0)
				{
					if (beginTrans.Length == 0)
						transaction.Rollback();
					else
						ExecuteCommandString(rollbackTrans);
				}
				else
				{
					if (savepoint.Length != 0)
						ExecuteCommandString(rollbackSavepoint, transName);
				}
			}
		}
		
		public class TransactionSentinel : System.IDisposable
		{
			private TransactionHelper  tr;
			string name;
			
			public TransactionSentinel (TransactionHelper t, string name)
			{
				tr = t;
				this.name = name;
				tr.BeginTrans(name);
			}
			
			public void Commit()
			{
				tr.CommitTrans();
				tr = null;
			}
			
			public void Rollback()
			{
				if (tr != null)
					tr.RollbackTrans(name);
			}
			
			public void Dispose()
			{
				Rollback();
			}
		}
		
		public static RecordBuffer AddElement(IDbConnection conn, MemberInfo member)
		{
			return new RecordBuffer(conn);
		}

		public static RecordBuffer AddElement(RecordBuffer parent, MemberInfo member)
		{
			return new RecordBuffer(parent.Connection);
		}

		public static bool Exists(object v) 
		{
			return v != null && !System.Convert.IsDBNull(v);
		}

		public static MemberIterator GetElements(IDataRecord node, MemberInfo member)
		{
			throw new System.InvalidOperationException("GetElements: not supported");
		}

		public static MemberIterator GetElements(IDataRecord node, MemberInfo member, IDbCommand command)
		{			
			command.Connection.Open();
			return new MemberIterator(command.ExecuteReader(CommandBehavior.CloseConnection));
		}

		public static MemberIterator GetElements(IDbConnection node, MemberInfo member)
		{
			throw new System.InvalidOperationException("GetElements: not supported");
		}

		public static MemberIterator GetElements(IDbConnection node, MemberInfo member,IDbCommand command)
		{
			command.Connection.Open();
			return new MemberIterator(command.ExecuteReader(CommandBehavior.CloseConnection));
		}

		public static object FindAttribute(IDataRecord recordSet, MemberInfo member)
		{
			int i = recordSet.GetOrdinal(member.LocalName);
            if (recordSet.GetDataTypeName(i) == "XML")
            {
                try
                {
                    long l = recordSet.GetBytes(i, 0, null, 0, 0);
                    byte[] b = new byte[l];
                    recordSet.GetBytes(i, 0, b, 0, (int)l);
                    return b;
                }
                catch (System.InvalidCastException x)
                {                    
                    // Workaround for DB2 NULL values in XML.
                    return null;
                }
            }
			return recordSet[i];
		}

		public static object FindAttribute(RecordBuffer recordSet, MemberInfo member)
		{
			
			return recordSet.Get(member.LocalName);
		}

		public static int CastToInt(object v, MemberInfo member)
		{
			if (!Exists(v))
				return 0;
			return System.Convert.ToInt32(v, System.Globalization.CultureInfo.InvariantCulture);
		}

		public static uint CastToUInt(object v, MemberInfo member)
		{
			if (!Exists(v))
				return 0;
			return System.Convert.ToUInt32(v, System.Globalization.CultureInfo.InvariantCulture);
		}

		public static string CastToString(object v, MemberInfo member)
		{
			if (!Exists(v))
				return null;

			if (v is byte[])
				return System.Convert.ToBase64String((byte[])v);

			if (v is System.DateTime)
				return Altova.CoreTypes.CastToString(CastToDateTime(v, member));

			if (v is bool)
				return Altova.CoreTypes.CastToString((bool) v);

			return System.Convert.ToString(v, System.Globalization.CultureInfo.InvariantCulture);
		}

		public static double CastToDouble(object v, MemberInfo member)
		{
			if (!Exists(v))
				return 0;
			return System.Convert.ToDouble(v, System.Globalization.CultureInfo.InvariantCulture);
		}

		public static long CastToInt64(object v, MemberInfo member)
		{
			if (!Exists(v))
				return 0;
			return System.Convert.ToInt64(v, System.Globalization.CultureInfo.InvariantCulture);
		}

		public static ulong CastToUInt64(object v, MemberInfo member)
		{
			if (!Exists(v))
				return 0;
			return System.Convert.ToUInt64(v, System.Globalization.CultureInfo.InvariantCulture);
		}

		public static bool CastToBool(object v, MemberInfo member)
		{
			if (!Exists(v))
				return false;
			return System.Convert.ToBoolean(v, System.Globalization.CultureInfo.InvariantCulture);
		}

		public static Altova.Types.DateTime CastToDateTime(object v, MemberInfo member)
		{
			if (!Exists(v))
				return new Altova.Types.DateTime(1,1,1,0,0,0);
			
			if (v is System.TimeSpan)
                return new Altova.Types.DateTime(new System.DateTime(1, 1, 1, 0, 0, 0) + (System.TimeSpan)v);
			
			return new Altova.Types.DateTime(System.Convert.ToDateTime(v, System.Globalization.CultureInfo.InvariantCulture));
		}

		public static decimal CastToDecimal(object v, MemberInfo member)
		{
			if (!Exists(v))
				return 0;
			return System.Convert.ToDecimal(v, System.Globalization.CultureInfo.InvariantCulture);
		}

		public static byte[] CastToBinary(object v, MemberInfo member)
		{
			if (!Exists(v))
				return null;
			
			if (v is byte[])
				return (byte[]) v;
			
			if (v is string)
                return System.Text.Encoding.UTF8.GetBytes((string) v);

            return null;		
		}

		public static void SetValue(RecordBuffer buffer, MemberInfo member, object value)
		{
			buffer.Set(member.LocalName, value);
		}

		public static void SetValue(RecordBuffer buffer, MemberInfo member, string value)
		{
			buffer.Set(member.LocalName, value);
		}

		public static void SetValue(RecordBuffer buffer, MemberInfo member, int value)
		{
			buffer.Set(member.LocalName, value);
		}

		public static void SetValue(RecordBuffer buffer, MemberInfo member, uint value)
		{
			buffer.Set(member.LocalName, value);
		}

		public static void SetValue(RecordBuffer buffer, MemberInfo member, bool value)
		{
			buffer.Set(member.LocalName, value);
		}

		public static void SetValue(RecordBuffer buffer, MemberInfo member, double value)
		{
			buffer.Set(member.LocalName, value);
		}

		public static void SetValue(RecordBuffer buffer, MemberInfo member, long value)
		{
			buffer.Set(member.LocalName, value);
		}

		public static void SetValue(RecordBuffer buffer, MemberInfo member, ulong value)
		{
			buffer.Set(member.LocalName, value);
		}

		public static void SetValue(RecordBuffer buffer, MemberInfo member, Altova.Types.DateTime value)
		{
			buffer.Set(member.LocalName, value.Value);
		}

		public static void SetValue(RecordBuffer buffer, MemberInfo member, byte[] value)
		{
			buffer.Set(member.LocalName, value);
		}

		public static void SetValue(RecordBuffer buffer, MemberInfo member, decimal d)
		{
			buffer.Set(member.LocalName, d);
		}

		public static void SetParameter(IDataParameter target, object value)
		{
			target.Value = value;
		}

		public static void SetParameter(IDataParameter target, string value)
		{
			target.Value = value;
		}

		public static void SetParameter(IDataParameter target, int value)
		{
			target.Value = value;
		}

		public static void SetParameter(IDataParameter target, uint value)
		{
			target.Value = value;
		}

		public static void SetParameter(IDataParameter target, long value)
		{
			target.Value = value;
		}

		public static void SetParameter(IDataParameter target, ulong value)
		{
			target.Value = value;
		}

		public static void SetParameter(IDataParameter target, bool value)
		{
			target.Value = value;
		}

		public static void SetParameter(IDataParameter target, double value)
		{
			target.Value = value;
		}

		public static void SetParameter(IDataParameter target, Altova.Types.DateTime value)
		{
			target.Value = value.Value;
		}

		public static void SetParameter(IDataParameter target, decimal value)
		{
			target.Value = value;
		}

		public static IDbCommand CreateCommand(IDbConnection connection, string commandText, params DbType[] parameterTypes)
		{
			System.ICloneable cloneable = connection as System.ICloneable;
			if (cloneable != null) 
				connection = (IDbConnection)cloneable.Clone();

			IDbCommand command = connection.CreateCommand();
			command.CommandText = commandText;
			int index = 0;
			foreach(DbType paramType in parameterTypes)
			{
				IDataParameter param = command.CreateParameter();
				param.DbType = paramType;
				param.ParameterName = index.ToString(System.Globalization.CultureInfo.InvariantCulture);
				command.Parameters.Add(param);
				++index;
			}
			return command;
		}
	}		
}