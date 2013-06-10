using System;
using System.Globalization;

public partial class pgDownloadDataSet : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.PageContent.Text = CMSTextCache.CMSText("Static", "DownloadDataSetPageContent");
        }
    }
}