using System;
using System.Collections;
using System.Xml;

namespace Altova.Mapforce
{
	public class DOMNodeAsMFNodeAdapter : IMFNode
	{
		XmlNode node;

		public DOMNodeAsMFNodeAdapter(XmlNode node)
		{
			this.node = node;
		}
		
		public XmlNode Node { get { return node; } }

		public IEnumerable Select(MFQueryKind kind, object query)
		{
			switch (kind)
			{
				case MFQueryKind.All:
                    switch (node.NodeType)
                    {
                        case XmlNodeType.Element:
                            return new SequenceJoin(new DOMChildrenAsMFNodeSequenceAdapter(node), new DOMAttributesAsMFNodeSequenceAdapter(node));
							
                        case XmlNodeType.Document:
                            return new DOMChildrenAsMFNodeSequenceAdapter(node);

                        case XmlNodeType.Attribute:
                            return new MFSingletonSequence(node.Value);

                        case XmlNodeType.Text:
                        case XmlNodeType.SignificantWhitespace:
                        case XmlNodeType.CDATA:
                            return new MFSingletonSequence(node.Value);
                        default:
                            return MFEmptySequence.Instance;

                    }
					
				case MFQueryKind.AllChildren:
					switch (node.NodeType)
					{
						case XmlNodeType.Element:
						case XmlNodeType.Document:
							return new DOMChildrenAsMFNodeSequenceAdapter(node);

						case XmlNodeType.Attribute:
							return new MFSingletonSequence(node.Value);

						case XmlNodeType.Text:
						case XmlNodeType.SignificantWhitespace:
						case XmlNodeType.CDATA:
							return new MFSingletonSequence(node.Value);
						default:
							return MFEmptySequence.Instance;

					}

				case MFQueryKind.AllAttributes:
					switch (node.NodeType)
					{
						case XmlNodeType.Element:
						case XmlNodeType.Document:
							return new DOMAttributesAsMFNodeSequenceAdapter(node);

						default:
							return MFEmptySequence.Instance;

					}

				case MFQueryKind.ChildrenByQName:
					switch (node.NodeType)
					{
						case XmlNodeType.Element:
						case XmlNodeType.Document:
							return new MFNodeByKindAndQNameFilter(new DOMChildrenAsMFNodeSequenceAdapter(node), MFNodeKind.Children, ((XmlQualifiedName)query).Name, ((XmlQualifiedName)query).Namespace);

						default:
							return MFEmptySequence.Instance;

					}

				case MFQueryKind.SelfByQName:
					switch (node.NodeType)
					{
						case XmlNodeType.Element:
						case XmlNodeType.Attribute:
							if (node.LocalName == ((XmlQualifiedName)query).Name &&
								node.NamespaceURI == ((XmlQualifiedName)query).Namespace)
								return new MFSingletonSequence(this);
							else
								return MFEmptySequence.Instance;

						default:
							return MFEmptySequence.Instance;

					}

				case MFQueryKind.AttributeByQName:
					switch (node.NodeType)
					{
						case XmlNodeType.Element:
							{
								XmlAttribute att = node.Attributes[((XmlQualifiedName)query).Name, ((XmlQualifiedName)query).Namespace];
								if (att != null)
									return new MFSingletonSequence(new DOMNodeAsMFNodeAdapter(att));
								else
									return MFEmptySequence.Instance;
							}

						default:
							return MFEmptySequence.Instance;

					}


				default:
					throw new InvalidOperationException("Unsupported query type.");
			}
		}

		public MFNodeKind NodeKind
		{
			get
			{
				switch (node.NodeType)
				{
					case XmlNodeType.Attribute:
						return MFNodeKind.Attribute; // also field?
					case XmlNodeType.CDATA:
						return MFNodeKind.Text|MFNodeKind.CData;
					case XmlNodeType.Comment:
						return MFNodeKind.Comment;
					case XmlNodeType.Document:
						return MFNodeKind.Document;
					case XmlNodeType.Element:
						return MFNodeKind.Element;
					case XmlNodeType.Text:
					case XmlNodeType.SignificantWhitespace:
						return MFNodeKind.Text;
					case XmlNodeType.ProcessingInstruction:
						return MFNodeKind.ProcessingInstruction;
					default:
						return 0;
				}
			}
		}

		public string LocalName
		{
			get { return node.LocalName; }
		}

		public string NamespaceURI
		{
			get { return node.NamespaceURI; }
		}
		
		public Altova.Types.QName GetQNameValue() 
		{			
			return Altova.Xml.XmlTreeOperations.CastToQName(node, null);
		}
	}
	
	public class MFDomWriter
	{
		public static void Write(IEnumerable what, XmlNode where)
		{
            XmlDocument owner = (where.NodeType == XmlNodeType.Document) ? where as XmlDocument : where.OwnerDocument;
			foreach (object o in what)
			{
				if (o is Altova.Mapforce.IMFNode)
				{
					Altova.Mapforce.IMFNode el = (Altova.Mapforce.IMFNode)o;
					if ((el.NodeKind & Altova.Mapforce.MFNodeKind.Element) != 0)
					{
						string prefix = where.GetPrefixOfNamespace(el.NamespaceURI);
						XmlElement xel = owner.CreateElement(prefix, el.LocalName, el.NamespaceURI);
						where.AppendChild(xel);
						
						Write(el.Select(Altova.Mapforce.MFQueryKind.All, null), xel);
					}
					else if ((el.NodeKind & Altova.Mapforce.MFNodeKind.Attribute) != 0)
					{
						if (el.NamespaceURI == "http://www.w3.org/XML/1998/namespace")
                            ((XmlElement)where).SetAttribute("xml:" + el.LocalName, GetValue(el, where));
                        else
						    ((XmlElement)where).SetAttribute(el.LocalName, el.NamespaceURI, GetValue(el, where));
					}
					else if ((el.NodeKind & Altova.Mapforce.MFNodeKind.Comment) != 0)
					{
                        where.AppendChild(owner.CreateComment(GetValue(el)));
					}
					else if ((el.NodeKind & Altova.Mapforce.MFNodeKind.ProcessingInstruction) != 0)
					{
                        where.AppendChild(owner.CreateProcessingInstruction(el.LocalName, GetValue(el)));
					}
					else if ((el.NodeKind & Altova.Mapforce.MFNodeKind.CData) != 0)
					{
                        where.AppendChild(owner.CreateCDataSection(GetValue(el)));
					}
					else if ((el.NodeKind & Altova.Mapforce.MFNodeKind.Text) != 0)
					{
                        where.AppendChild(owner.CreateTextNode(GetValue(el)));
					}
				}
				else
				{
					string s = GetValue(o, where);
					if (s != "")
						where.AppendChild(owner.CreateTextNode(s));
				}
			}
		}


        public static string GetValue(object o)
        {
            return GetValue(o, null);
        }

		static string GetValue(object o, XmlNode n)
		{
            if (o is Altova.Types.QName)
            {
                Altova.Types.QName q = (Altova.Types.QName)o;
                if (q.Uri == null || q.Uri.Length == 0)
                    return q.LocalName;

                String prefix = n.GetPrefixOfNamespace(q.Uri);
                if (prefix == null || prefix.Length == 0)
                {
                    if (q.Prefix != null && n.GetNamespaceOfPrefix(q.Prefix) == q.Uri)
                        prefix = q.Prefix;
                    else
                    {
                        prefix = Altova.Xml.XmlTreeOperations.FindUnusedPrefix(n, q.Prefix);
                        ((XmlElement)n).SetAttribute("xmlns:" + prefix, q.Uri);
                    }
                }

                int i = q.LocalName.IndexOf(':');
                if (i == -1)
                    return prefix + ":" + q.LocalName;
                return prefix + ":" + q.LocalName.Substring(i+1);
            }
			if (o is Altova.Mapforce.IMFNode) 
			{
				Altova.Mapforce.IMFNode node = (Altova.Mapforce.IMFNode)o;
				string s = "";
				foreach (object v in node.Select(Altova.Mapforce.MFQueryKind.AllChildren, null))
				{
					s += GetValue(v, n);
				}
				return s;
			}
			return o.ToString();
		}
	}
}
