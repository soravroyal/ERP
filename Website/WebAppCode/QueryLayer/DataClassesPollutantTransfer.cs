using System.Configuration;
using QueryLayer.Properties;

namespace QueryLayer
{
    partial class DataClassesPollutantTransferDataContext
    {
        public DataClassesPollutantTransferDataContext()
            : this(ConfigurationManager.ConnectionStrings["QueryLayer.Properties.Settings.EPRTRwebConnectionString"].ConnectionString)
        {
            OnCreated();
        }

    }
}
