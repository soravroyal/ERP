using System;
using WcfSerialization = global::System.Runtime.Serialization;

namespace EPRTRT.DataContracts
{
    /// <summary>
    /// Data Contract Class - WasteTransferBoundaries. Used to populate charts.
    /// </summary>
    [WcfSerialization::CollectionDataContract(Namespace = "http://atkins.com", ItemName = "WasteTransferBoundaries")]
    public partial class WasteTransferBoundaries : System.Collections.ObjectModel.Collection<WasteTransferBoundary>
    {
    }
}
