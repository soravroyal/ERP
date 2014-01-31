using System;
using System.Web.UI;
using EPRTR.Localization;
using QueryLayer.Filters;
using EPRTR.Utilities;
using EPRTR.HeaderBuilders;

public partial class FacilityLevelsEPER : BasePage
{

    /// <summary>
    /// Page load, add flash map and assign eventhandler
    /// </summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ((MasterSearchPageEPER)this.Master).Headline = Resources.GetGlobal("Facility", "Headline");
            ((MasterSearchPageEPER)this.Master).ShowMapPanel(Global.MainSearchPages.FacilityLevelsEPER);
        }
       

        if (this.ucSearchOptionsEPER.InvokeSearch == null)
            this.ucSearchOptionsEPER.InvokeSearch = new EventHandler(doSearch);

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
                FacilitySearchFilter filter = this.ucSearchOptionsEPER.PopulateFilter();
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
        ((MasterSearchPageEPER)this.Master).ShowResultArea();

        FacilitySearchFilter filter = sender as FacilitySearchFilter;
        if (filter != null)
        {

            updateJavaScriptMap(filter);
            // update expanded map first
            this.ucFacilityListSheetEPER.Populate(filter);
            //updateFlashMap(filter);
        }
    }

    private void updateFlashMap(FacilitySearchFilter filter)
    {
        // update flash map
        MapFilter mapfilter = QueryLayer.Facility.GetMapFilter(filter);
        string header = MapPrintDetails.Build(SheetHeaderBuilder.GetFacilitySearchHeader(filter, false));
       
        MapUtils.UpdateSmallMap(MasterSearchPageEPER.MAPID, Page, this.UniqueID, mapfilter, header, Request.ApplicationPath);
        ((MasterSearchPageEPER)this.Master).UpdateExpandedScript(mapfilter, header);
    }

    private void updateJavaScriptMap(FacilitySearchFilter filter)
    {
        MapFilter mapfilter = QueryLayer.Facility.GetMapJavascriptFilter(filter);
        MapJavaScriptUtils.UpdateJavaScriptMap(mapfilter, Page);
    }



}
