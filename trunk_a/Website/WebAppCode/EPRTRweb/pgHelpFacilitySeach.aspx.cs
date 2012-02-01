using System;
using System.Web.UI;
using System.Text;
using System.IO;

public partial class pgLibraryWaste : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.PageHeader.Text = CMSTextCache.CMSText("Help", "SearchHelpFacilityHeader");
            this.PageContent.Text = CMSTextCache.CMSText("Help", "SearchHelpFacility");
        }
    }
}
