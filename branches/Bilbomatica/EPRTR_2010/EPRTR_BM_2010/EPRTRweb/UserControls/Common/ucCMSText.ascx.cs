using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ucCMSText : System.Web.UI.UserControl
{
    public string ResourceType{ get; set; }
    public string ResourceKey { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.litText.Text = CMSTextCache.CMSText(ResourceType, ResourceKey);
        }
    }
}
