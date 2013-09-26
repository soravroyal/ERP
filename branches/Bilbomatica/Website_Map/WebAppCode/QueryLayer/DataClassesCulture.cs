
using System.Configuration;
namespace QueryLayer
{
    partial class DataClassesCultureDataContext
    {
        public DataClassesCultureDataContext()
            : this(ConfigurationManager.ConnectionStrings["QueryLayer.Properties.Settings.EPRTRcmsConnectionString"].ConnectionString)
        {
            OnCreated();
        }
    }
}
