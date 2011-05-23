using System;
using System.Web.UI;
using EPRTR.Localization;
using QueryLayer.Filters;
using EPRTR.Utilities;
using EPRTR.HeaderBuilders;

public partial class FacilityLevels : BasePage
{

    /// <summary>
    /// Page load, add flash map and assign eventhandler
    /// </summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ((MasterSearchPage)this.Master).Headline = Resources.GetGlobal("Facility", "Headline");
            ((MasterSearchPage)this.Master).ShowMapPanel(Global.MainSearchPages.FacilityLevels);
        }

        if (!ScriptManager.GetCurrent(Page).IsInAsyncPostBack)
        {
            // add swf object to page
            MapUtils.AddSmallMap(MasterSearchPage.MAPID, this, Global.MainSearchPages.FacilityLevels, Request.ApplicationPath);
        }

        if (this.ucSearchOptions.InvokeSearch == null)
            this.ucSearchOptions.InvokeSearch = new EventHandler(doSearch);

    }

    /// <summary>
    /// load completed, perserve scroll
    /// </summary>
    protected override void OnLoadComplete(EventArgs e)
    {
        base.OnLoadComplete(e);

        if (!IsPostBack)
        {
            //if filter is in request, search will be invoked from the start
            if (LinkSearchBuilder.HasFacilitySearchFilter(Request))
            {
                FacilitySearchFilter filter = this.ucSearchOptions.PopulateFilter();
                doSearch(filter, EventArgs.Empty);
            }
        }

        // When load completed, perserve scroll position
        ScriptManager.RegisterStartupScript(Page, typeof(string), this.UniqueID, "Sys.WebForms.PageRequestManager.getInstance().add_endRequest(SetScroll);", true);    
    }

    

    /// <summary>
    /// query data to be displayed in the facility resul listview
    /// </summary>
    private void doSearch(object sender, EventArgs e)
    {
        ((MasterSearchPage)this.Master).ShowResultArea();

        FacilitySearchFilter filter = sender as FacilitySearchFilter;
        if (filter != null)
        {
            // update expanded map first
            this.ucFacilityListSheet.Populate(filter);
            updateFlashMap(filter);
        }
    }

    private void updateFlashMap(FacilitySearchFilter filter)
    {
        // update flash map
        MapFilter mapfilter = QueryLayer.Facility.GetMapFilter(filter);
        string header = MapPrintDetails.Build(SheetHeaderBuilder.GetFacilitySearchHeader(filter, false));
        //MapUtils.UpdateSmallMap(MasterSearchPage.MAPID,this, this.ClientID, mapfilter, header, Request.ApplicationPath);
        MapUtils.UpdateSmallMap(MasterSearchPage.MAPID, Page, this.UniqueID, mapfilter, header, Request.ApplicationPath);
        ((MasterSearchPage)this.Master).UpdateExpandedScript(mapfilter, header);
    }

}
