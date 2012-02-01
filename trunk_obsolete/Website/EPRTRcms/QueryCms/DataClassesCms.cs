namespace QueryCms
{
    using System.Configuration;
    partial class DataClassesCmsDataContext
    {
        public DataClassesCmsDataContext()
            : this(ConfigurationManager.ConnectionStrings["QueryCms.Properties.Settings.EPRTRcmsConnectionString"].ConnectionString)
        {
            OnCreated();
        }
    }
}
