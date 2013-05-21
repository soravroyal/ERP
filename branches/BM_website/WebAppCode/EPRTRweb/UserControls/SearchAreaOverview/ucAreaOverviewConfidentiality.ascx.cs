using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer.Filters;

public partial class ucAreaOverviewConfidentiality : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.lbConfidentialityText.Text = CMSTextCache.CMSText("AreaOverview", "ConfidentialityExplanation");
        }
    }

    public void Populate(AreaOverviewSearchFilter filter)
    {
    }

}
