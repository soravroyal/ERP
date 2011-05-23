using System;

public partial class pgLinksResearchProjects : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.PageContent.Text = CMSTextCache.CMSText("Static", "LinksResearchProjectsPageContent");
        }
    }
}