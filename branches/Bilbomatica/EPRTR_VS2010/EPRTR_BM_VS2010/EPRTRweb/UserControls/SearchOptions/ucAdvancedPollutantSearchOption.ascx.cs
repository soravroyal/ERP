using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Utilities;
using QueryLayer.Filters;
using CommonFunctions;

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
			else
			{
				//If previous search was with only Waste Water enabled we must disable Accidental
				CheckBox chkAir = (CheckBox)CommonFunctions.ControlTool.FindControlR(this, "chkAir");
				CheckBox chkWater = (CheckBox)CommonFunctions.ControlTool.FindControlR(this, "chkWater");
				CheckBox chkSoil = (CheckBox)CommonFunctions.ControlTool.FindControlR(this, "chkSoil");
				if (!chkAir.Checked && !chkWater.Checked && !chkSoil.Checked)
				{
					CheckBox chkAccidental = (CheckBox)CommonFunctions.ControlTool.FindControlR(this, "chkAccidental");
					chkAccidental.Checked = false;

					// for some reason .Net an't figure out how to make .Net enabled and JS .disabled work together, so we do it this way
					ScriptManager.RegisterStartupScript(chkAccidental, chkAccidental.GetType(), this.UniqueID, "PRTLoadValidation()", true);
				}
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


    public void PopulateFilters(out PollutantFilter pollutantFilter, out MediumFilter mediumFilter, out AccidentalFilter accidentalFilter)
    {

        if (!isCollapsed())
        {
            pollutantFilter = this.ucPollutantSearchOption.PopulateFilter();
            mediumFilter = this.ucMediumSearchOption.PopulateFilter();
            accidentalFilter = this.ucAccidentalSearchOption.PopulateFilter();
        }
        else
        {
            pollutantFilter = null;
            mediumFilter = null;
            accidentalFilter= null;
        }

    }

    //If ClientState is true, then the panel is collapsed; if the ClientState is false, then the panel is expanded
    private bool isCollapsed()
    {
        return Boolean.Parse(this.cpePollutant.ClientState);
    }

    
}
