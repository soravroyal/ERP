using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Utilities;
using QueryLayer.Filters;

public partial class ucAdvancedActivitySearchOptionEPER : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bool activityInRequest = LinkSearchBuilder.HasActivityFilter(Request);

            bool collapse = !activityInRequest;
            this.cpeActivity.Collapsed = collapse;
            this.cpeActivity.ClientState = collapse.ToString();

            togglePanel(collapse);

        }
    }

    /// <summary>
    /// Expand, content visible set to false as default, performance hack
    /// </summary>
    protected void expandActivityClick(object sender, EventArgs e)
    {
        togglePanel(isCollapsed());
    }

    private void togglePanel(bool collapse)
    {
        this.lblActivity.Visible = collapse;
        this.plActivityContent.Attributes["style"] = collapse ? "display:none" : "display:block";
    }

    public ActivityFilter PopulateFilter()
    {
        
        if (!isCollapsed())
        {
            return this.ucActivitySearchOption.PopulateFilter();
        }
        else
        {
            return null;
        }
    }

    //If ClientState is true, then the panel is collapsed; if the ClientState is false, then the panel is expanded
    private bool isCollapsed()
    {
        return Boolean.Parse(this.cpeActivity.ClientState);
    }
}
