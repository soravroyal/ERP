using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using EPRTR.Utilities;
using EPRTR.Localization;
using QueryLayer.Filters;


public partial class MasterSearchPage : System.Web.UI.MasterPage
{
    public const string MAPID = "resultMapId"; //must correspond to the id of the div

    private const string SEARCHPAGE = "theSearchPage";
    private const string PAGELOADID = "Page_Load";
    private const string EXPAND_QUERY = "expandQuery";
    private const string EXPAND_SECTOR = "expandSector";
    private const string EXPAND_HEAD = "expandHead";
    private const string EXPAND_VISIBLE = "expandVisible";



   
    public string strYears = "";

    /// <summary>
    /// Page load, set expand script
    /// </summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        string searchPage = (ViewState[SEARCHPAGE] == null) ? String.Empty : ViewState[SEARCHPAGE].ToString();
        string query = (ViewState[EXPAND_QUERY] == null) ? String.Empty : ViewState[EXPAND_QUERY].ToString();
        string sector = (ViewState[EXPAND_SECTOR] == null) ? String.Empty : ViewState[EXPAND_SECTOR].ToString();
        string head = (ViewState[EXPAND_HEAD] == null) ? String.Empty : ViewState[EXPAND_HEAD].ToString();
        string visible = (ViewState[EXPAND_VISIBLE] == null) ? String.Empty : ViewState[EXPAND_VISIBLE].ToString();


        if (!Page.IsPostBack)
        {
            List<int>  yearList = QueryLayer.ReportinYear.GetReportingYearsPRTR();
          

            foreach (int p in yearList)
            {
                if (strYears != "")
                    strYears += "," + p.ToString();
                else
                    strYears = p.ToString();
            }
        }
        // Add click handler to expand button as client script
        // This requires a switch if postback or not (!!!)

      //  string jsFunction = MapUtils.GetExpandScript(searchPage, Headline, query, sector, head, MAPID, visible);
        //string script = MapUtils.GetButtonExpandScript(jsFunction, this.btnExpand.ClientID);
        string script = "";

        if (!Page.IsPostBack)
        {
            ScriptManager.RegisterStartupScript(Page, typeof(string), PAGELOADID, script, true);
        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(Page, typeof(string), PAGELOADID, script, true);
        }
    }

    /// <summary>
    /// Set headline for this search page
    /// </summary>
    public string Headline
    {
        get { return this.lbHeadline.Text; }
        set { this.lbHeadline.Text = value; }
    }

    public string ClientIDExpandButton
    {
        //get { return this.btnExpand.ClientID; }
        get { return ""; }
    }
       
    /// <summary>
    /// Toggle result area
    /// </summary>
    public void ShowResultArea()
    {
        this.resultArea.Visible = true;
    }

    
    public void HideSearchForm()
    {
        this.searchForm.Visible = false;
    }

    public void HideMap()
    {
        this.divMap.Visible = false;
    }

   
    /// <summary>
    /// Toggle Flash map
    /// </summary>
    public void ShowMapPanel(Global.MainSearchPages page)
    {
        ViewState[SEARCHPAGE] = page.ToString();
    }
    public void UpdateMode(bool always)
    {
        this.upResultArea.UpdateMode = always ? UpdatePanelUpdateMode.Always : UpdatePanelUpdateMode.Conditional;
    }
    
}