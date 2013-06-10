using System;
using System.Collections;
using System.Text;

namespace Altova.Mapforce
{
	public enum MFQueryKind
	{
		All,
		AllChildren,
		AllAttributes,
        AttributeByQName,
		ChildrenByQName,
		SelfByQName,
		ChildrenByDbCommand,
	}

	public enum MFNodeKind
	{
		Attribute = 1 << 0,
		Field = 1 << 1,
		Element = 1 << 2,
		Record = 1 << 3,
		Text = 1 << 4,
		CData = 1 << 5,
		Comment = 1 << 6,
		ProcessingInstruction = 1 << 7,
		Document = 1 << 8,
		Connection = 1 << 9,

		Children = Element|Text|CData|Comment|ProcessingInstruction,
		AllChildren = Children|Attribute
	}

	public interface IMFEnumerator : IEnumerator, IDisposable
    {
        int Position { get; }
    }
	
	public class MFEnumerator
    {
        public static void Dispose(IEnumerator e)
        {
			if (e == null)
				return;
            IDisposable i = e as IDisposable;
            if (i != null)
                i.Dispose();
        }
    }

	public interface IMFNode
	{
		MFNodeKind NodeKind { get; }
		string LocalName { get; }
		string NamespaceURI { get; }
		IEnumerable Select(MFQueryKind kind, object query);
		Altova.Types.QName GetQNameValue();
	}
	
	public class MFNode
	{
		public static string GetValue(object o)
		{
			if (o is Altova.Mapforce.IMFNode) 
			{
				Altova.Mapforce.IMFNode node = (Altova.Mapforce.IMFNode)o;
				string s = "";
				foreach (object v in node.Select(Altova.Mapforce.MFQueryKind.AllChildren, null))
				{
					s += GetValue(v);
				}
				return s;
					
			}
			return o.ToString();
		}
	}
	
	public class Group
	{
		private object key;
		private IEnumerable items;
		
		public Group (object k, IEnumerable i) 
		{
			key = k;
			items = i;
		}

		public object Key { get { return key; } }
		public IEnumerable Items { get { return items; } }
	}
	
	public delegate IEnumerable MFInvoke(object o);
}
