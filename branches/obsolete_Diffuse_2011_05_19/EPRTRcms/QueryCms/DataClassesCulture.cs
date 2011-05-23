using System.Configuration;
namespace QueryCms
{
    partial class DataClassesCultureDataContext
    {
        public DataClassesCultureDataContext()
            : this(ConfigurationManager.ConnectionStrings["QueryCms.Properties.Settings.EPRTRcmsConnectionString"].ConnectionString)
        {
            OnCreated();
        }
    }
}
