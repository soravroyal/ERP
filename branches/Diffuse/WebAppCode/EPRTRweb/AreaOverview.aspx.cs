﻿using System;
using System.Web.UI;
using EPRTR.Localization;
using QueryLayer.Filters;
using EPRTR.Utilities;
using EPRTR.HeaderBuilders;

public partial class AreaOverview : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ((MasterSearchPage)this.Master).Headline = Resources.GetGlobal("AreaOverview", "Headline");
            ((MasterSearchPage)this.Master).ShowMapPanel(Global.MainSearchPages.AreaOverview);
        }
        if (this.ucSearchOptions.InvokeSearch == null)
            this.ucSearchOptions.InvokeSearch = new EventHandler(doSearch);

        if (!ScriptManager.GetCurrent(Page).IsInAsyncPostBack)
        {
            // add swf object to page
            MapUtils.AddSmallMap(MasterSearchPage.MAPID, this, Global.MainSearchPages.AreaOverview, Request.ApplicationPath);
        }
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
            if (LinkSearchBuilder.HasAreaOverviewSearchFilter(Request))
            {
                AreaOverviewSearchFilter filter = this.ucSearchOptions.PopulateFilter();
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

        AreaOverviewSearchFilter filter = sender as AreaOverviewSearchFilter;
        if (filter != null)
        {
            this.ucAreaOverviewSheet.Populate(filter);
            updateFlashMap(filter);
        }
    }

    /// <summary>
    /// update flash map
    /// </summary>
    private void updateFlashMap(AreaOverviewSearchFilter filter)
    {
        MapFilter mapfilter = QueryLayer.AreaOverview.GetMapFilter(filter);
        string header = MapPrintDetails.Build(SheetHeaderBuilder.GetAreaOverviewSearchHeader(filter));
        MapUtils.UpdateSmallMap(MasterSearchPage.MAPID, this, this.ClientID, mapfilter, header, Request.ApplicationPath);
        ((MasterSearchPage)this.Master).UpdateExpandedScript(mapfilter, header);
    }

}
