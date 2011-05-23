using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Localization;
using QueryLayer.Filters;
using EPRTR.Utilities;

public partial class DiffuseSourcesAir : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ((MasterDiffuseSourcesPage)this.Master).Headline = Resources.GetGlobal("DiffuseSources", "DiffuseSourcesAirPageHeader");
            ((MasterDiffuseSourcesPage)this.Master).SubHeadline = CMSTextCache.CMSText("DiffuseSources", "aSubheadline");

            ((MasterDiffuseSourcesPage)this.Master).SetMapList(MediumFilter.Medium.Air);

            ((MasterDiffuseSourcesPage)this.Master).ShowMapPanel(Global.MainSearchPages.DiffuseAir);
        }

        if (!ScriptManager.GetCurrent(Page).IsInAsyncPostBack)
        {
            // add swf object to page
            MapUtils.AddSmallMap(MasterDiffuseSourcesPage.MAPID, this, Global.MainSearchPages.DiffuseAir, Request.ApplicationPath);
        }


    }
}
