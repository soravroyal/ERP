using System;
using WcfSerialization = global::System.Runtime.Serialization;

namespace EPRTRT.DataContracts
{
    /// <summary>
    /// Data Contract Class - WasteTransferAreaCollection. Used to populate charts.
    /// </summary>
    [WcfSerialization::CollectionDataContract(Namespace = "http://atkins.com", ItemName = "WasteTransferAreaCollection")]
    public partial class WasteTransferAreaCollection : System.Collections.ObjectModel.Collection<WasteTransferAreaComparison>
    {
    }
}