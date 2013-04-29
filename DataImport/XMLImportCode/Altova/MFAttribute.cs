using System;
using System.Collections;
using System.Text;

namespace Altova.Mapforce
{
	public class MFAttribute : IMFNode
	{
		string localName;
		string namespaceURI;
		IEnumerable children;

		public MFAttribute(string localName, string namespaceURI, IEnumerable children)
		{
			this.localName = localName;
			this.namespaceURI = namespaceURI;
			this.children = children;
		}

		public string LocalName { get { return localName; } }
		public string NamespaceURI { get { return namespaceURI; } }
		public MFNodeKind NodeKind { get { return MFNodeKind.Attribute | MFNodeKind.Field; } }
		
		public IEnumerable Select(MFQueryKind kind, object query)
		{
			switch (kind)
			{
				case MFQueryKind.All:
				case MFQueryKind.AllChildren:
					return new MFNodeByKindFilter(children, MFNodeKind.Text);
				
				case MFQueryKind.AllAttributes:
				case MFQueryKind.AttributeByQName:
					return MFEmptySequence.Instance;

				case MFQueryKind.ChildrenByQName:
					return MFEmptySequence.Instance;

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

		public Altova.Types.QName GetQNameValue() {return null;}
	}
}
