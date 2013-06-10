using System;
using System.Collections;
using System.Text;

namespace Altova.Mapforce
{
	public class MFElement : IMFNode
	{
		string localName;
		string namespaceURI;
		IEnumerable children;

		public MFElement(string localName, string namespaceURI, IEnumerable children)
		{
			this.localName = localName;
			this.namespaceURI = namespaceURI;
			this.children = children;
		}

		public string LocalName { get { return localName; } }
		public string NamespaceURI { get { return namespaceURI; } }
		public MFNodeKind NodeKind { get { return MFNodeKind.Element | MFNodeKind.Record; } }
		
		public IEnumerable Select(MFQueryKind kind, object query)
		{
			switch (kind)
			{
				case MFQueryKind.All:
					return new MFNodeByKindFilter(children, MFNodeKind.AllChildren);
				case MFQueryKind.AllChildren:
					return new MFNodeByKindFilter(children, MFNodeKind.Children);
				case MFQueryKind.AllAttributes:
					return new MFNodeByKindFilter(children, MFNodeKind.Attribute | MFNodeKind.Field);
				
				case MFQueryKind.AttributeByQName:
					return new MFNodeByKindAndQNameFilter(children, MFNodeKind.Attribute|MFNodeKind.Field,
						((System.Xml.XmlQualifiedName)query).Name,
						((System.Xml.XmlQualifiedName)query).Namespace);

				case MFQueryKind.ChildrenByQName:
					return new MFNodeByKindAndQNameFilter(children, MFNodeKind.Children,
						((System.Xml.XmlQualifiedName)query).Name,
						((System.Xml.XmlQualifiedName)query).Namespace);

				case MFQueryKind.SelfByQName:
					if (localName == ((System.Xml.XmlQualifiedName)query).Name &&
						namespaceURI == ((System.Xml.XmlQualifiedName)query).Namespace)
						return new MFSingletonSequence(this);
					else
						return MFEmptySequence.Instance;

				default:
					throw new InvalidOperationException("Unsupported query type.");
			}
		}

		public Altova.Types.QName GetQNameValue()
		{
			IEnumerable children = Select(MFQueryKind.AllChildren, null);

			IEnumerator en = children.GetEnumerator();
			if (!en.MoveNext())
				throw new Exception("Trying to convert NULL to QName.");

			Altova.Types.QName qn = (Altova.Types.QName)en.Current;

			if (en.MoveNext())
				throw new Exception("Trying to convert multiple values to QName.");

			return qn;
		}
	}
}
