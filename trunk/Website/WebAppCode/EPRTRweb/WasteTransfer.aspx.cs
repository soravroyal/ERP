using System;
using System.Web.UI;
using EPRTR.Localization;
using QueryLayer.Filters;
using EPRTR.Utilities;
using EPRTR.HeaderBuilders;

public partial class WasteTransfer : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ((MasterSearchPage)this.Master).Headline = Resources.GetGlobal("WasteTransfers", "WasteTransferHeadline");
            ((MasterSearchPage)this.Master).ShowMapPanel(Global.MainSearchPages.WasteTransfers);

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
            if (LinkSearchBuilder.HasWasteTransferSearchFilter(Request))
            {
                WasteTransferSearchFilter filter = this.ucSearchOptions.PopulateFilter();
                doSearch(filter, EventArgs.Empty);
            }
        }

        // When load completed, perserve scroll position
        ScriptManager.RegisterStartupScript(Page, typeof(string), this.UniqueID, "Sys.WebForms.PageRequestManager.getInstance().add_endRequest(SetScroll);", true);    
    }


    private void doSearch(object sender, EventArgs e)
    {
        ((MasterSearchPage)this.Master).UpdateMode(true);
        ((MasterSearchPage)this.Master).ShowResultArea();

        WasteTransferSearchFilter filter = sender as WasteTransferSearchFilter;
        if (filter != null)
        {
            updateJavaScriptMap(filter);
            this.ucWasteTransfersSheet.Populate(filter);
           
        }
    }

  

    private void updateJavaScriptMap(WasteTransferSearchFilter filter)
    {
        MapFilter mapfilter = QueryLayer.WasteTransfers.GetMapJavascriptFilter(filter);

        MapJavaScriptUtils.UpdateJavaScriptMap(mapfilter, Page);
    }



}
