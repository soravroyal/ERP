using System.Configuration;
namespace EPRTR.ResourceProviders
{
    partial class DBResourceDataClassesDataContext
    {
        public DBResourceDataClassesDataContext()
            : this(ConfigurationManager.ConnectionStrings["QueryLayer.Properties.Settings.EPRTRresourceConnectionString"].ConnectionString)
        {
            OnCreated();
        }
 
    }
}
