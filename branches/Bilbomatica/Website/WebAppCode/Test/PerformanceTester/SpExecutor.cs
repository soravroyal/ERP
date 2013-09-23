using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Data;
using System.Configuration;


namespace SPPerformanceTester
{
	public class SpExecutor
	{
		private static ITestRunDataProvider testRunDataProvider
		{
			get { return (ITestRunDataProvider)ServiceLocator.Instance.GetService(typeof(ITestRunDataProvider)); }
		}
		public static int ExecuteSP(string spName, IEnumerable<IDataParameter> parameters)
		{
			using (SqlConnection connection 
                = new SqlConnection(ConfigurationManager.ConnectionStrings["sorConnectionString"].ConnectionString))
			{
				int nrRows = 0;
				connection.Open();
				SqlCommand cmdActiveStations = new SqlCommand(spName, connection);
				cmdActiveStations.CommandTimeout = testRunDataProvider.GetCommandTimeout();
				foreach (SqlParameter param in parameters)
				{
					cmdActiveStations.Parameters.Add(new SqlParameter(param.ParameterName, param.Value));
				}
				using (SqlDataReader rdr = cmdActiveStations.ExecuteReader())
				{
					nrRows = rdr.RecordsAffected;
				}
				return nrRows;
			}
		}
		//public static void TestExecuteSP()
		//{
		//    int nrRows = 0;
		//    List<IDataParameter> parameters = new List<IDataParameter>();
		//    //nrRows = ExecuteSP("exec giseditor.XCP_CREATE_SNAPSHOT_XML", parameters); //7:12
		//    //nrRows = ExecuteSP("exec giseditor.XCP_PrepareExplorerSemiValidatedXML", parameters);//20:11
		//    //nrRows = ExecuteSP("exec giseditor.XCP_PrepareExplorerPreliminaryXML", parameters);//8:08
		//    //nrRows = ExecuteSP("exec giseditor.XCP_CREATE_ADMINISTRATION_XML", parameters);//1:22:18
		//    //nrRows = ExecuteSP("exec giseditor.XCP_POPULATE_XC_MEASUREMENT_LTO", parameters);//0:17
		//    nrRows = ExecuteSP("exec giseditor.XCP_POPULATE_XC_STATION_EXCEEDANCES_SEASON", parameters);//0:1
		//    //nrRows = ExecuteSP("exec giseditor.XCP_CREATE_STATIC_MAP", parameters); //0:57
		//    nrRows = ExecuteSP("exec giseditor.XCP_CREATE_EXPLORER_OUTPUT_XML", parameters); //0:7
		//}


		//public static int TestExecuteSP2()
		//{
		//    List<IDataParameter> parameters = new List<IDataParameter>();
		//    Guid test_provider = new Guid(); new Guid("79662EAE-1247-4F03-B10B-4A2A014B09F1"); // --pName ='fr_ademe'
		//    parameters.Add(new SqlParameter("pGuid", test_provider));
		//    return ExecuteSP("exec giseditor.[XCP_GET_PROVIDER_TRUST_XML] @pGuid", parameters);
		//}


		//public static int TestExecuteSP3()
		//{
		//    int nrRows = 0;
		//    List<IDataParameter> parameters = new List<IDataParameter>();
		//    parameters.Add(new SqlParameter("@country", "AT"));
		//    nrRows = ExecuteSP("exec giseditor.[XCP_ACTIVE_STATIONS] @country", parameters);

		//    parameters.Clear();
		//    parameters.Add(new SqlParameter("@country", "AT"));
		//    nrRows = ExecuteSP("exec giseditor.XCP_GET_EXPLORER_INTERPOLATE_STATION @country", parameters);

		//    parameters.Clear();
		//    parameters.Add(new SqlParameter("@country", "AT"));
		//    nrRows = ExecuteSP("exec giseditor.XCP_GET_EXPLORER_MAX_MONTH_XML @country", parameters);

		//    parameters.Clear();
		//    nrRows = ExecuteSP("exec [giseditor].[XCP_GET_SNAPSHOT_XML] ", parameters);
		//    //-- test of prepared XMLs
		//    //exec [giseditor].[XCP_GET_EXPLORER_MONTHLY_XML] 0 -- preliminary
		//    //exec [giseditor].[XCP_GET_EXPLORER_MONTHLY_XML] 1 -- semivalidated / approved

		//    return nrRows;
		//}

		//exec giseditor.XCP_GET_ADMINISTRATION @provider_id
		//exec giseditor.XCP_GET_PROVIDER_XML 'dk_dmu'
		//exec giseditor.XCP_GET_STATION_DATA_XML 1,@sEoI_Code


	}
}
