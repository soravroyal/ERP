using System.Configuration;
namespace EPRTR.ResourceProviders
{
    partial class DBCMSTextDataContext
    {
        public DBCMSTextDataContext()
            : this(ConfigurationManager.ConnectionStrings["QueryLayer.Properties.Settings.EPRTRresourceConnectionString"].ConnectionString)
        {
            OnCreated();
        }

    }
}
