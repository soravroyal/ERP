using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Utilities;

public partial class ucFacilityDetailsMap : System.Web.UI.UserControl
{
    private const string FACILITY_REPORT_ID = "facilitydetailsreportid";
    private const string SECTORS = "facilitydetailssectors";
    private const string MAP_UNIQUEID = "mapuniqueid";

    
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        createMap();
        //base.OnPreRender(e);
    }


    /// <summary>
    /// Init, set report id
    /// </summary>
    public void Initialize(int facilityReportID, string sectors)
    {
        MapUniqueID = this.facilitydetailmap.ClientID;

        ViewState[FACILITY_REPORT_ID] = facilityReportID;
        ViewState[SECTORS] = sectors;
    }
    
    /// <summary>
    /// Map id
    /// </summary>
    public string MapUniqueID 
    {
        get { return (string)ViewState[MAP_UNIQUEID]; } 
        set { ViewState[MAP_UNIQUEID] = value; }
    }
        
    /// <summary>
    /// create map
    /// string script = String.Format("DetailsMap(\"{0}\", \"{1}\", \"{2}\", \"{3}\" );", this.facilitydetailmap.ClientID, facility, sectors, Request.ApplicationPath);
    /// ScriptManager.RegisterClientScriptBlock(this.detailmapPanel, this.detailmapPanel.GetType(), this.UniqueID, script, true);
    /// </summary>
    private void createMap()
    {
        if (ViewState[FACILITY_REPORT_ID]!=null)
        {
            int id = (int)ViewState[FACILITY_REPORT_ID];
            string sectors = (ViewState[SECTORS] == null) ? "-1" : (string)ViewState[SECTORS];
            
            // invoke script
            MapUtils.AddDetailsMap(this.detailmapPanel, this.UniqueID, MapUniqueID, id, sectors, Request.ApplicationPath);
        }
    }
}
