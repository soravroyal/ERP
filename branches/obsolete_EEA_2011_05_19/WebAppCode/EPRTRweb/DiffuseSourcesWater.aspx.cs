using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer.Filters;
using EPRTR.Localization;
using EPRTR.DiffuseSources;
using EPRTR.Utilities;

public partial class DiffuseSourcesWater : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ((MasterDiffuseSourcesPage)this.Master).Headline = Resources.GetGlobal("DiffuseSources", "DiffuseSourcesWaterPageHeader");
            ((MasterDiffuseSourcesPage)this.Master).SubHeadline =  CMSTextCache.CMSText("DiffuseSources", "wSubheadline");

            ((MasterDiffuseSourcesPage)this.Master).SetMapList(MediumFilter.Medium.Water);

            ((MasterDiffuseSourcesPage)this.Master).ShowMapPanel(Global.MainSearchPages.DiffuseWater);
        }

        if (!ScriptManager.GetCurrent(Page).IsInAsyncPostBack)
        {
            // add swf object to page
            MapUtils.AddSmallMap(MasterDiffuseSourcesPage.MAPID, this, Global.MainSearchPages.DiffuseWater, Request.ApplicationPath);
        }
    }
}
