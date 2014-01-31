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
    /// Update Expand script
    /// </summary>
   /* public void UpdateExpandedScript(MapFilter mapfilter, string header)
    {
        string searchPage = (ViewState[SEARCHPAGE] == null) ? String.Empty : ViewState[SEARCHPAGE].ToString();

        ViewState[EXPAND_QUERY] = mapfilter.SqlWhere;
        ViewState[EXPAND_SECTOR] = mapfilter.Layers;
        ViewState[EXPAND_VISIBLE] = mapfilter.VisibleLayers;
        ViewState[EXPAND_HEAD] = header;

        // Safety storing of sql
        // Store the current sql in cookie. Only used as fallback if ViewState fails to store values
        CookieStorage.SaveExpandMap(Response, mapfilter.SqlWhere, mapfilter.Layers, header, mapfilter.VisibleLayers);

        string js = MapUtils.GetExpandScript(searchPage, Headline, mapfilter.SqlWhere, mapfilter.Layers, header, MAPID, mapfilter.VisibleLayers);
        //string script = MapUtils.GetButtonExpandScript(js, this.btnExpand.ClientID);
        string script = MapUtils.GetButtonExpandScript(js, "");
        ScriptManager.RegisterClientScriptBlock(Page, typeof(string), "UpdateExpandedScript", script, true);
    }*/

    /// <summary>
    /// retun javascript to add click handler to expand button as client script (!!!)
    /// </summary>
    /*private string getExpandScript(string jsFunction)
    {
        string script = String.Empty;
        script += "try{ var btnExpand = $get('" + this.btnExpand.ClientID + "'); ";
        script += "if (typeof(expandHandler) != 'undefined') { $removeHandler(btnExpand, 'click', expandHandler); } ";
        script += "expandHandler = function(evt) { " + jsFunction + " evt.preventDefault(); }; $addHandler(btnExpand, 'click', expandHandler); ";
        script += "} catch(err) {  } ";
        return script;
    }
    */

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