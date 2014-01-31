using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ucFacilityConfidentiality : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.lbConfidentialityText.Text = CMSTextCache.CMSText("Common", "ConfidentialityExplanationFacilityLevel");
        }
    }
}
