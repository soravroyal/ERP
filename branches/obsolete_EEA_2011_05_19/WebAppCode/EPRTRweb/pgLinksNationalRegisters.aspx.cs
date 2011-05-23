using System;

public partial class pgLinksNationalRegisters : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.PageContent.Text = CMSTextCache.CMSText("Static", "LinksNationalRegistersPageContent");
        }
    }
}