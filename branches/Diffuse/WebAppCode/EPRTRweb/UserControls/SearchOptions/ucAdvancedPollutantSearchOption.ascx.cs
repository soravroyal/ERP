using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Utilities;
using QueryLayer.Filters;

public partial class ucAdvancedPollutantSearchOption : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            bool pollutantInRequest = LinkSearchBuilder.HasPollutantFilter(Request) || LinkSearchBuilder.HasMediumFilter(Request);
            
            bool collapse = !pollutantInRequest;
            this.cpePollutant.Collapsed = collapse;
            this.cpePollutant.ClientState = collapse.ToString();

            togglePanel(collapse);
        }
    }


    private void togglePanel(bool collapse)
    {
        this.lblPollutant.Visible = collapse;
        this.lblPollutant2.Visible = collapse;
        this.plPollutantContent.Attributes["style"] = collapse ? "display:none" : "display:block";
    }

    /// <summary>
    /// Expand, content visible set to false as default, performance hack
    /// </summary>
    protected void expandPollutantClick(object sender, EventArgs e)
    {
        togglePanel(isCollapsed());
    }


    public void PopulateFilters(out PollutantFilter pollutantFilter, out MediumFilter mediumFilter)
    {

        if (!isCollapsed())
        {
            pollutantFilter = this.ucPollutantSearchOption.PopulateFilter();
            mediumFilter = this.ucMediumSearchOption.PopulateFilter();
        }
        else
        {
            pollutantFilter = null;
            mediumFilter = null;
        }

    }

    //If ClientState is true, then the panel is collapsed; if the ClientState is false, then the panel is expanded
    private bool isCollapsed()
    {
        return Boolean.Parse(this.cpePollutant.ClientState);
    }

    
}
