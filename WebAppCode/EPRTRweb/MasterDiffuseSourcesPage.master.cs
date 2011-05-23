using System;
using System.Web.UI.WebControls;
using EPRTR.DiffuseSources;
using QueryLayer.Filters;
using EPRTR.Utilities;

public partial class MasterDiffuseSourcesPage : System.Web.UI.MasterPage
{

    public const string MAPID = MasterSearchPage.MAPID; //must correspond to the id of the div

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //Clicking the enlarge button just clicks the expand button.
            string client = ((MasterSearchPage)this.Master).ClientIDExpandButton;

            string script = "try{ var btnExpand = $get('" + client + "'); ";
            script += "btnExpand.click();";
            script += "} catch(err) {  } ";

            this.btnEnlarge.OnClientClick = script;

            this.ddlSelectSector.SelectedIndex = 0;
        }
    }

    /// <summary>
    /// Set headline for this search page
    /// </summary>
    public string SubHeadline
    {
        get { return this.litHeader.Text; }
        set { this.litHeader.Text = value; }
    }

    public string Headline 
    { 
        get{return ((MasterSearchPage)this.Master).Headline;} 
        set {((MasterSearchPage)this.Master).Headline = value;} 
    }

    /// <summary>
    /// Toggle Flash map
    /// </summary>
    public void ShowMapPanel(Global.MainSearchPages page)
    {
        ((MasterSearchPage)this.Master).ShowMapPanel(page);
    }


    public void SetMapList(MediumFilter.Medium medium)
    {
        string sectorId = "";

        if (MediumFilter.Medium.Air == medium)
        {
            //ddlSelectSector.Visible = true;
            litSector.Visible = true;
            
            sectorId = this.ddlSelectSector.SelectedValue;
        }
        else
        {
            //ddlSelectSector.Visible = false;
            litSector.Visible = false;
        }

        DiffuseSources.Map[] maps = DiffuseSources.GetMaps(medium, sectorId);

        
        if (maps.Length > 0)
        {
            divAvailableLayers.Visible = true;
            rblMaps.Items.Clear();
            foreach (DiffuseSources.Map map in maps)
            {
                rblMaps.Items.Add(new ListItem(map.GetTitleShort(), map.LayerId));
            }
        }
        else if (MediumFilter.Medium.Water == medium)
        {
            //if no maps hide radiobuttons and map
            ((MasterSearchPage)this.Master).HideSearchForm();
            ((MasterSearchPage)this.Master).HideMap();
            this.divEnlarge.Visible = false;
        }
        else
        {
            divAvailableLayers.Visible = false;
        }

    }

    protected void OnSelectedMapChanged(object sender, EventArgs args)
    {
        ((MasterSearchPage)this.Master).ShowResultArea();
        
        string layerId = this.rblMaps.SelectedValue;

        this.ucDiffuseSourcesSheet.Visible = true;
        this.ucDiffuseSourcesSheet.Populate(layerId);
        this.divEnlarge.Visible = true;
        updateFlashMap(layerId);
    }



    // update flash map
    private void updateFlashMap(string layerID)
    {
        MapFilter mapFilterSmall;
        MapFilter mapFilterExpanded;
        String header;

        if (String.IsNullOrEmpty(layerID)) //clear map
        {
            mapFilterSmall = new MapFilter();
            mapFilterSmall.Layers = layerID;

            mapFilterExpanded = mapFilterSmall;
            header = "";
        }
        else
        {
            DiffuseSources.Map map = DiffuseSources.GetMap(layerID);
            mapFilterSmall = map.MapFilterSmall;
            mapFilterExpanded = map.MapFilterExpanded;
            header = map.GetTitleFull();
        }

        MapUtils.UpdateDiffuseMap(MAPID, Page, Page.ClientID, mapFilterSmall, "", Request.ApplicationPath);
        ((MasterSearchPage)this.Master).UpdateExpandedScript(mapFilterExpanded, header);
    }

    protected void OnSelectedIndexChanged_Sector(object sender, EventArgs args)
    {
        var sectorId = this.ddlSelectSector.SelectedValue;

        SetMapList(MediumFilter.Medium.Air);
        //hide sheet and clear map
        this.ucDiffuseSourcesSheet.Visible = false;
        updateFlashMap("");
            
    }


}
