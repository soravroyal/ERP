using System;

public partial class PopupLibraryActivitiesGuideEPER : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.PageContent.Text = CMSTextCache.CMSText("Library", "ActivityPageContentEPER");
        }
    }
}