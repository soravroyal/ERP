using System;

public partial class ucLibraryActivitiesEPER : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.PageContent.Text = CMSTextCache.CMSText("Library", "ActivityPageContentEPER");
        }
    }
}