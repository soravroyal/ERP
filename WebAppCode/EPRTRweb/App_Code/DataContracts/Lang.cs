using System;
using WcfSerialization = global::System.Runtime.Serialization;

namespace EPRTRT.DataContracts
{
    /// <summary>
    /// Summary description for LangDictionary
    /// </summary>
    public partial class Lang
    {
        public string key;
        public string word;

        [WcfSerialization::DataMember(Name = "Key", IsRequired = false, Order = 0)]
        public string Key
        {
            get { return key; }
            set { key = value; }
        }

        [WcfSerialization::DataMember(Name = "World", IsRequired = false, Order = 1)]
        public string Word
        {
            get { return word; }
            set { word = value; }
        }
        public Lang()
        {
            //
            // TODO: Add constructor logic here
            //
        }
    } 
}
