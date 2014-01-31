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
     

        if (this.ucSearchOptions.InvokeSearch == null)
            this.ucSearchOptions.InvokeSearch = new EventHandler(doSearch);

        //ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "loadMap", "mapLoad();", true);
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
            // call javascript map_small
            updateJavaScriptMap(filter);
          
            this.ucFacilityListSheet.Populate(filter);
          
           
        }
    }
   
    private void updateJavaScriptMap(FacilitySearchFilter filter)
    {
        MapFilter mapfilter = QueryLayer.Facility.GetMapJavascriptFilter(filter);       
    
        MapJavaScriptUtils.UpdateJavaScriptMap(mapfilter, Page);

    }

}
