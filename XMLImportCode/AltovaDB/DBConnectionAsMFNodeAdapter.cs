using System;
using System.Collections;
using System.Data;

namespace Altova.Mapforce
{
	public class Db
	{	
		public static IEnumerable Select(string query, IMFNode connection, params DbParam[] args)
		{
			return new DBConnectionAsMFNodeAdapter.QueryResultSequence(connection, query, args);
		}

		public class DbParam
		{
			object o;
			DbType type;
			int size;

			public DbParam(object o, DbType type, int size)
			{
				this.o = o;
				this.type = type;
				this.size = size;
			}

			internal object Obj { get { return o; } }
			internal DbType Type { get { return type; } }
			internal int Size { get { return size; } }
		}

		public static DbParam ToDBType(object o, DbType type)
		{
			if (!(o is IConvertible))
				throw new InvalidOperationException("'" + o.ToString() + "' is not convertible.");
			return new DbParam(o, type, 0);
		}

		public static DbParam ToDBType(string s, DbType type) { return new DbParam(s, type, s.Length); }
		public static DbParam ToDBType(Altova.Types.DateTime dt, DbType type) { return new DbParam(dt.Value, type, 0); }
		public static DbParam ToDBType(byte[] b, DbType type) { return new DbParam(b, type, b.Length); }

		public static DbParam ToDBType(IEnumerable x, DbType type)
		{
			IEnumerator y = x.GetEnumerator();
			if (y.MoveNext())
			{
				object o = y.Current;
				if (o is string) return ToDBType((string)o, type);
				if (o is Altova.Types.DateTime) return ToDBType((Altova.Types.DateTime)o, type);
				if (o is byte[]) return ToDBType((byte[])o, type);
				return ToDBType(o, type);
			}
			else
			{
				return new DbParam(DBNull.Value, type, 0);
			}
		}
	}

	public class DBConnectionAsMFNodeAdapter : IMFNode
	{
		IDbConnection conn;

		internal IDbConnection Connection { get { return conn; } }

		public DBConnectionAsMFNodeAdapter(IDbConnection conn)
		{
			this.conn = conn;
		}

		public IEnumerable Select(MFQueryKind kind, object query)
		{
			throw new InvalidOperationException("Unsupported selection.");
		}

		public string LocalName
		{
			get { return ""; }
		}

		public string NamespaceURI
		{
			get { return ""; }
		}

		public MFNodeKind NodeKind
		{
			get { return MFNodeKind.Connection; }
		}
		
		public Altova.Types.QName GetQNameValue() {return null;}
		
		internal class RecordAsMFNodeAdapter : IMFNode
		{
			SortedList dictionary = new SortedList();

			public RecordAsMFNodeAdapter(IDataReader reader)
			{
				for (int i = 0; i != reader.FieldCount; ++i)
				{
                    if (reader.GetDataTypeName(i).ToLower() == "xml")
                    {
                        long l = reader.GetBytes(i, 0, null, 0, 0);
                        byte[] b = new byte[l];
                        try
                        {
                            reader.GetBytes(i, 0, b, 0, (int)l);
                        }
                        catch (System.InvalidCastException x)
                        {
                            // Workaround for DB2 NULL values in XML.
                            continue;
                        }

                        dictionary.Add(reader.GetName(i), b);
                    }
                    else
                    {
                        if (!reader.IsDBNull(i))
                        {
                            object value = reader.GetValue(i);

                            // promote datetimes
                            if (value is DateTime)
                                value = new Altova.Types.DateTime((DateTime)value);

                            dictionary.Add(reader.GetName(i), value);
                        }
					}
				}
			}

			public string LocalName
			{
				get { return ""; } // TODO: should be something more useful really.
			}

			public string NamespaceURI
			{
				get { return ""; }
			}

			public IEnumerable Select(MFQueryKind kind, object query)
			{
				switch (kind)
				{
					case MFQueryKind.All:
					case MFQueryKind.AllChildren:
					case MFQueryKind.ChildrenByQName:
					case MFQueryKind.SelfByQName:
						return MFEmptySequence.Instance;

					case MFQueryKind.AttributeByQName:
						if (dictionary.ContainsKey(((System.Xml.XmlQualifiedName)query).Name))
							return new MFSingletonSequence(dictionary[((System.Xml.XmlQualifiedName)query).Name]);
						return MFEmptySequence.Instance;

					default:
						throw new InvalidOperationException("Unsupported query type.");

				}
			}

			public MFNodeKind NodeKind
			{
				get { return MFNodeKind.Record; }
			}
			
			public Altova.Types.QName GetQNameValue() {return null;}
		}

		internal class QueryResultSequence : IEnumerable
		{
			IMFNode connection;
            string query;
            Db.DbParam[] args;

			public QueryResultSequence(IMFNode connection, string query, params Db.DbParam[] args)
			{
				this.connection = connection;
                this.query = query;
                this.args = args;
			}

			public IEnumerator GetEnumerator()
			{
				DBConnectionAsMFNodeAdapter conn = connection as DBConnectionAsMFNodeAdapter;
				if (conn == null)
					throw new InvalidOperationException("Need to use connection with Db.Select");

				ICloneable cloneable = conn.Connection as ICloneable;
				if (cloneable == null)
					throw new InvalidOperationException("Need to use a cloneable connection with Db.Select");

				IDbConnection use = (IDbConnection) cloneable.Clone();
								
                return new Enumerator(use, query, args);
			}

			class Enumerator : IMFEnumerator
			{
				IDbConnection conn;
				IDataReader reader;
                IDbCommand command;
				object current;
				int pos = 0;

				public Enumerator(IDbConnection conn, String query, Db.DbParam[] args)
				{
					this.conn = conn;
										
					conn.Open();

                    command = conn.CreateCommand();
                    command.CommandText = query;
                    command.CommandType = CommandType.Text;
                    foreach (Db.DbParam o in args)
                    {
                        IDbDataParameter param = command.CreateParameter();
                        param.Value = o.Obj;
                        if (o.Size != 0)
                            param.Size = o.Size;
                        param.DbType = o.Type;

                        command.Parameters.Add(param);
                    }

                    reader = command.ExecuteReader();
				}

				public void Dispose()
                {
					reader.Close();
                    reader.Dispose();
					
                    command.Dispose();
					
					conn.Close();              
                    conn.Dispose();
                }

				public object Current
				{
					get { return current;  }
				}
				
				public int Position { get { return pos; } }

				public bool MoveNext()
				{
					if (reader.Read())
					{
						// fetch all the fields into the buffer
						current = new RecordAsMFNodeAdapter(reader);
						pos++;
						return true;
					}
					return false;
				}

				public void Reset()
				{
					throw new InvalidOperationException("Cannot reset DB iterators.");
				}
			}
		}
	}
}
