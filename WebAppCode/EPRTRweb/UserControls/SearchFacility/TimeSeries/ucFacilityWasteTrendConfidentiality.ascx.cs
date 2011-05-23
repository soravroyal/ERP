using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer;
using EPRTR.Localization;
using QueryLayer.Filters;
using QueryLayer.Utilities;

public partial class ucFacilityWasteTrendConfidentiality : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public void Populate(int facilityid, WasteTypeFilter.Type wasteType, bool hasConfidentialInformation)
    {
        this.divConfidentialityInformation.Visible = hasConfidentialInformation;
        this.divNoConfidentialityInformation.Visible = !hasConfidentialInformation;

        this.lvConfidentiality.Visible = true;
        this.lvConfidentiality.DataSource = WasteTransferTrend.GetConfidentiality(facilityid, wasteType);
        this.lvConfidentiality.DataBind();
    }

    #region databinding methods

    protected int GetConfYear(object obj)
    {
        TimeSeriesClasses.ConfidentialityWaste row = (TimeSeriesClasses.ConfidentialityWaste)obj;
        return row.Year;
    }

    protected string GetConfidentiality(object obj)
    {
        TimeSeriesClasses.ConfidentialityWaste row = (TimeSeriesClasses.ConfidentialityWaste)obj;
        return row.CountConfTotal>0 ? Resources.GetGlobal("Common", "Yes") : Resources.GetGlobal("Common", "No");
    }

    protected string GetConfidentialityQuantity(object obj)
    {
        TimeSeriesClasses.ConfidentialityWaste row = (TimeSeriesClasses.ConfidentialityWaste)obj;
        return row.CountConfQuantity > 0 ? Resources.GetGlobal("Common", "Yes") : Resources.GetGlobal("Common", "No");
    }


    #endregion

}
