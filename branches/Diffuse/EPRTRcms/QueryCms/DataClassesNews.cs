namespace QueryCms
{
    using System.Configuration;
    partial class DataClassesNewsDataContext
    {
        public DataClassesNewsDataContext()
            : this(ConfigurationManager.ConnectionStrings["QueryCms.Properties.Settings.EPRTRcmsConnectionString"].ConnectionString)
        {
            OnCreated();
        }
    }
}
