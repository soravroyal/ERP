using System;

public partial class pgLibraryGlossary : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.PageContent.Text = CMSTextCache.CMSText("Library", "GlossaryPageContent");
        }
    }
}