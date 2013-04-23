using System;
using System.Collections;
using System.Text;
using System.Configuration;
using System.Xml;


/// Defines structures used in web.config
namespace Config
{
    // Define a custom section named BrowserSection containing a
    // BrowsersCollection collection of BrowserConfigElement elements.
    // The collection is wrapped in an element named "browser" in the
    // web.config file.
    // BrowsersCollection and BrowsersConfigElement classes are defined below.
    public class BrowserSection : ConfigurationSection
    {
        // Declare the browsers collection property.
        // Note: the "IsDefaultCollection = false" instructs 
        // .NET Framework to build a nested section of 
        // the kind <browsers>...</browsers>.
        [ConfigurationProperty("browsers", IsDefaultCollection = false)]
        [ConfigurationCollection(typeof(BrowserCollection),
            AddItemName = "add",
            ClearItemsName = "clear",
            RemoveItemName = "remove")]
        public BrowserCollection Browsers
        {
            get
            {
                BrowserCollection browserCollection = (BrowserCollection)base["browsers"];
                return browserCollection;
            }
        }
    }



    // Define the BrowsersCollection that will contain the BrowsersConfigElement
    // elements.
    public class BrowserCollection : ConfigurationElementCollection
    {
        public BrowserCollection()
        {
            // When the collection is created, always add one element 
            // with the default values. (This is not necessary; it is
            // here only to illustrate what can be done; you could 
            // also create additional elements with other hard-coded 
            // values here.)
            BrowserConfigElement browser = (BrowserConfigElement)CreateNewElement();
            Add(browser);
        }

        public override ConfigurationElementCollectionType CollectionType
        {
            get
            {
                return ConfigurationElementCollectionType.AddRemoveClearMap;
            }
        }

        protected override ConfigurationElement CreateNewElement()
        {
            return new BrowserConfigElement();
        }

        protected override Object GetElementKey(ConfigurationElement element)
        {
            return ((BrowserConfigElement)element).Uid;
        }

        public BrowserConfigElement this[int index]
        {
            get
            {
                return (BrowserConfigElement)BaseGet(index);
            }
            set
            {
                if (BaseGet(index) != null)
                {
                    BaseRemoveAt(index);
                }
                BaseAdd(index, value);
            }
        }

        new public BrowserConfigElement this[string Uid]
        {
            get
            {
                return (BrowserConfigElement)BaseGet(Uid);
            }
        }

        public int IndexOf(BrowserConfigElement browser)
        {
            return BaseIndexOf(browser);
        }

        public void Add(BrowserConfigElement browser)
        {
            BaseAdd(browser);
        }
        protected override void BaseAdd(ConfigurationElement element)
        {
            BaseAdd(element, false);
        }

        public void Remove(BrowserConfigElement browser)
        {
            if (BaseIndexOf(browser) >= 0)
                BaseRemove(browser.Uid);
        }

        public void RemoveAt(int index)
        {
            BaseRemoveAt(index);
        }

        public void Remove(string uid)
        {
            BaseRemove(uid);
        }

        public void Clear()
        {
            BaseClear();
        }
    }



    // Define the element type contained by the BrowserCollection
    // collection.
    public class BrowserConfigElement : ConfigurationElement
    {
        public BrowserConfigElement(String uid, String name, String version)
        {
            this.Uid = uid;
            this.Name = name;
            this.Version = version;
        }

        public BrowserConfigElement()
        {
            // Attributes on the properties provide default values.
        }

        [ConfigurationProperty("uid", IsRequired = true, IsKey = true)]
        public string Uid
        {
            get
            {
                return (string)this["uid"];
            }
            set
            {
                this["uid"] = value;
            }
        }
        [ConfigurationProperty("name", IsRequired = true)]
        public string Name
        {
            get
            {
                return (string)this["name"];
            }
            set
            {
                this["name"] = value;
            }
        }

        [ConfigurationProperty("version")]
        public string Version
        {
            get
            {
                return (string)this["version"];
            }
            set
            {
                this["version"] = value;
            }
        }
    }
}
