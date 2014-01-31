using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MapJavascriptSearch : System.Web.UI.Page
{

    public string strYears = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            List<int> yearList = QueryLayer.ReportinYear.GetReportingYearsPRTR();


            foreach (int p in yearList)
            {
                if (strYears != "")
                    strYears += "," + p.ToString();
                else
                    strYears = p.ToString();
            }
        }
    }
}