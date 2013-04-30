using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Utilities;
using EPRTR.Localization;

public partial class MapSearch : BasePage
{
    private const string PAGELOADID = "Page_Load";

    private const string MAPID = "mapSearch"; //Must correspond to the id of the div

    protected void Page_Load(object sender, EventArgs e)
    {
        // add map to page
        MapUtils.AddMapSearchMap(MAPID,this.mapSearchPanel, this.ClientID, Request.ApplicationPath);
        
        // init expandmap
        string searchPage = Global.MainSearchPages.MapSearch.ToString();
        string headline = Resources.GetGlobal("MapSearch", "MapSearchPageHeader");

        string jsFunction = MapUtils.GetExpandScript(searchPage, headline, String.Empty, String.Empty, String.Empty, MAPID, String.Empty);
        string script = MapUtils.GetButtonExpandScript(jsFunction, this.btnExpand.ClientID);

        if (!Page.IsPostBack)
            ScriptManager.RegisterStartupScript(Page, typeof(string), PAGELOADID, script, true);
        else
            ScriptManager.RegisterClientScriptBlock(Page, typeof(string), PAGELOADID, script, true);

    }

    
}
