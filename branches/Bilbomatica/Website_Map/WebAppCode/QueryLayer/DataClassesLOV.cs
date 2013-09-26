using System.Configuration;
namespace QueryLayer
{
    partial class DataClassesLOVDataContext
    {
        public DataClassesLOVDataContext()
            : this(ConfigurationManager.ConnectionStrings["QueryLayer.Properties.Settings.EPRTRwebConnectionString"].ConnectionString)
        {
            OnCreated();
        }

    }
}
