using System.Configuration;
using QueryLayer.Properties;

namespace QueryLayer
{
    partial class DataClassesWasteTransferDataContext
    {
        public DataClassesWasteTransferDataContext()
            : this(ConfigurationManager.ConnectionStrings["QueryLayer.Properties.Settings.EPRTRwebConnectionString"].ConnectionString)
        {
            OnCreated();
        }

    }
}
