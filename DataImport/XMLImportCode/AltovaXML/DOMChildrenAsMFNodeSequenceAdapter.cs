using System;
using System.Collections;
using System.Xml;

namespace Altova.Mapforce
{
	internal class DOMChildrenAsMFNodeSequenceAdapter : IEnumerable
	{
		XmlNode from;

		public DOMChildrenAsMFNodeSequenceAdapter(XmlNode from)
		{
			this.from = from;
		}

		public IEnumerator GetEnumerator()
		{
			return new Enumerator(from);
		}

		class Enumerator : IMFEnumerator
		{
			XmlNode current = null;
			XmlNode from;
			int pos = 0;

			public Enumerator(XmlNode from)
			{
				this.from = from;
			}

			public object Current
			{
				get
				{
					if (current == null) throw new InvalidOperationException("No current.");
					return new DOMNodeAsMFNodeAdapter(current);
				}
			}
			
			public int Position { get { return pos; } }

			public bool MoveNext()
			{
				if (current == null)
					current = from.FirstChild;
				else
					current = current.NextSibling;
				if (current != null)
				{
					pos++;
					return true;
				}
				return false;
			}

			public void Reset()
			{
				current = null;
				pos = 0;
			}
			
			public void Dispose() {}
		}
	}

	internal class DOMAttributesAsMFNodeSequenceAdapter : IEnumerable
	{
		XmlNode from;

		public DOMAttributesAsMFNodeSequenceAdapter(XmlNode from)
		{
			this.from = from;
		}

		public IEnumerator GetEnumerator()
		{
			return new Enumerator(from);
		}

		class Enumerator : IMFEnumerator
		{
			int current = -1;
			XmlNode from;
			int pos = 0;

			public Enumerator(XmlNode from)
			{
				this.from = from;
			}

			public object Current
			{
				get
				{
					if (current == -1) throw new InvalidOperationException("No current.");
					return new DOMNodeAsMFNodeAdapter(from.Attributes[current]);
				}
			}

			public int Position { get { return pos; } }

			public bool MoveNext()
			{
				++current;
				if(current < from.Attributes.Count)
				{
					pos++;
					return true;
				}
				return false;
			}

			public void Reset()
			{
				current = 0;
				pos = 0;
			}
			
			public void Dispose() {}
		}
	}
}
