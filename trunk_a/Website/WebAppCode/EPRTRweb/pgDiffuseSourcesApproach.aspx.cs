using System;

public partial class pgDiffuseSourcesApproach : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.PageContent.Text = CMSTextCache.CMSText("DiffuseSources", "Approach");
        }
    }
}