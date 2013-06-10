using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Utilities;
using QueryLayer.Filters;

public partial class ucAdvancedWasteSearchOption : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            bool wasteInRequest = LinkSearchBuilder.HasWasteTypeFilter(Request) 
                                    || LinkSearchBuilder.HasWasteTreatmentFilter(Request)
                                    || LinkSearchBuilder.HasWasteReceiverFilter(Request);

            bool collapse = !wasteInRequest;
            this.cpeWaste.Collapsed = collapse;
            this.cpeWaste.ClientState = collapse.ToString();

            togglePanel(collapse);
        }
    }


    private void togglePanel(bool collapse)
    {
        this.lblWaste.Visible = collapse;
        this.lblWaste2.Visible = collapse;
        this.plWasteContent.Attributes["style"] = collapse ? "display:none" : "display:block";
    }

    /// <summary>
    /// Expand, content visible set to false as default, performance hack
    /// </summary>
    protected void expandWasteClick(object sender, EventArgs e)
    {
        togglePanel(isCollapsed());
    }


    public void PopulateFilters(out WasteTypeFilter wasteTypeFilter, out WasteTreatmentFilter wasteTreatmentFilter, out WasteReceiverFilter wasteReceiverFilter)
    {

        if (!isCollapsed())
        {
            wasteTypeFilter = this.ucWasteTypeSearchOption.PopulateFilter();
            wasteTreatmentFilter = this.ucWasteTreatmenSearchOption.PopulateFilter();
            wasteReceiverFilter = this.ucWasteReceiverSearchOption.PopulateFilter();
        }
        else
        {
            wasteTypeFilter = null;
            wasteTreatmentFilter = null;
            wasteReceiverFilter = null;
        }

    }

    //If ClientState is true, then the panel is collapsed; if the ClientState is false, then the panel is expanded
    private bool isCollapsed()
    {
        return Boolean.Parse(this.cpeWaste.ClientState);
    }

    
}
