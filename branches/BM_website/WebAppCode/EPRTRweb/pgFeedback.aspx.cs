using System;

public partial class pgFeedback : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.PageContent.Text = CMSTextCache.CMSText("Static", "FeedbackPageContent");
        }
    }

}
