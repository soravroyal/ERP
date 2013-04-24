using System.Configuration;
namespace QueryLayer
{
    partial class DataClassesFacilityDataContext
    {
        public DataClassesFacilityDataContext()
            : this(ConfigurationManager.ConnectionStrings["QueryLayer.Properties.Settings.EPRTRwebConnectionString"].ConnectionString)
        {
            OnCreated();
        }
    }
}
