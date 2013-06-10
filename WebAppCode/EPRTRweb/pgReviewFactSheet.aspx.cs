using System;

public partial class pgReviewFactSheet : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.PageContent.Text = CMSTextCache.CMSText("Static", "ReviewFactSheetPageContent");
        }
    }
}