using System;
using System.Web.UI;
using QueryLayer.Filters;
using EPRTR.Localization;
using EPRTR.Utilities;
using EPRTR.HeaderBuilders;

public partial class PollutantTransfers : BasePage
{
    

    /// <summary>
    /// Page load, add flash map and assign eventhandler
    /// </summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ((MasterSearchPage)this.Master).Headline = Resources.GetGlobal("Pollutant", "PollutantTransfersHeadline");
            ((MasterSearchPage)this.Master).ShowMapPanel(Global.MainSearchPages.PollutantTransfers);
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
            if (LinkSearchBuilder.HasPollutantTransferSearchFilter(Request))
            {
                PollutantTransfersSearchFilter filter = this.ucSearchOptions.PopulateFilter();
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
        
        PollutantTransfersSearchFilter filter = sender as PollutantTransfersSearchFilter;
        if (filter != null)
        {
            updateJavaScriptMap(filter);
            this.ucPollutantTransfersSheet.Populate(filter);
          //  updateFlashMap(filter);
        }
    }

    /// <summary>
    /// update flash map
    /// </summary>
  /*  private void updateFlashMap(PollutantTransfersSearchFilter filter)
    {
        MapFilter mapfilter = QueryLayer.PollutantTransfers.GetMapFilter(filter);
        string header = MapPrintDetails.Build(SheetHeaderBuilder.GetPollutantTransferSearchHeader(filter, false));
        MapUtils.UpdateSmallMap(MasterSearchPage.MAPID, this, this.ClientID, mapfilter, header, Request.ApplicationPath);
        ((MasterSearchPage)this.Master).UpdateExpandedScript(mapfilter, header);
    }*/

    private void updateJavaScriptMap(PollutantTransfersSearchFilter filter)
    {
        MapFilter mapfilter = QueryLayer.PollutantTransfers.GetMapJavascriptFilter(filter);
        MapJavaScriptUtils.UpdateJavaScriptMap(mapfilter, Page);
    }


}
