using System.Configuration;
namespace QueryLayer
{
    partial class DataClassesNewsDataContext
    {
        public DataClassesNewsDataContext()
            : this(ConfigurationManager.ConnectionStrings["QueryLayer.Properties.Settings.EPRTRcmsConnectionString"].ConnectionString)
        {
            OnCreated();
        }

    }
}
