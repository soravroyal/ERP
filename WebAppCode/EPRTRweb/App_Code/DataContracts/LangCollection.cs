using System;
using WcfSerialization = global::System.Runtime.Serialization;

namespace EPRTRT.DataContracts
{
    /// <summary>
    /// Data Contract Class - WasteTransferAreaCollection. Used to populate charts.
    /// </summary>
    [WcfSerialization::CollectionDataContract(Namespace = "http://atkins.com", ItemName = "LangCollection")]
    public partial class LangCollection : System.Collections.ObjectModel.Collection<Lang>
    {
    }
}
