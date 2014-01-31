using System;
using System.Web.UI;
using EPRTR.HeaderBuilders;
using EPRTR.Localization;
using EPRTR.Utilities;
using QueryLayer.Filters;

public partial class PollutantReleases : BasePage
{

    /// <summary>
    /// Page load and assign eventhandler
    /// </summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ((MasterSearchPage)this.Master).Headline = Resources.GetGlobal("Pollutant", "PollutantReleasesHeadline");
            ((MasterSearchPage)this.Master).ShowMapPanel(Global.MainSearchPages.PollutantReleases);
        }

     
        if (this.ucSearchOptions.InvokeSearch == null)
            this.ucSearchOptions.InvokeSearch = new EventHandler(doSearch);

        ((MasterSearchPage)this.Master).UpdateMode(false);
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
            if (LinkSearchBuilder.HasPollutantReleaseSearchFilter(Request))
            {
                PollutantReleaseSearchFilter filter = this.ucSearchOptions.PopulateFilter();
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
        ((MasterSearchPage)this.Master).UpdateMode(true);
        ((MasterSearchPage)this.Master).ShowResultArea();

        PollutantReleaseSearchFilter filter = sender as PollutantReleaseSearchFilter;
        if (filter != null)
        {
            // call javascript map_small
            updateJavaScriptMap(filter);
            this.ucPollutantReleasesSheet.Populate(filter);
           
        }
    }
 

    private void updateJavaScriptMap(PollutantReleaseSearchFilter filter)
    {
        MapFilter mapfilter = QueryLayer.PollutantReleases.GetMapJavascriptFilter(filter);


        MapJavaScriptUtils.UpdateJavaScriptMap(mapfilter, Page);
    }
}
