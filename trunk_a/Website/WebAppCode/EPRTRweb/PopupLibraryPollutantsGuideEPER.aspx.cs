using System;

public partial class PopupLibraryPollutantsGuideEPER : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.PageContent.Text = CMSTextCache.CMSText("Library", "PollutantPageContentEPER");
        }
    }
}