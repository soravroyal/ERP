using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer;
using EPRTR.Localization;
using EPRTR.Formatters;
using QueryLayer.Filters;
using QueryLayer.Utilities;

public partial class ucFacilityPollutantReleasesTrendConfidentiality : System.Web.UI.UserControl
{
    private const string POLLUTANTCODE = "releasetrendConfPollutantcode";
    private const string PARENTCODE = "releasetrendConfParentCode";

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public void Populate(int facilityid, string pollutantCode, MediumFilter.Medium medium)
    {
        PollutantCode = pollutantCode;
        //set parentcode
        LOV_POLLUTANT pollutant = ListOfValues.GetPollutant(pollutantCode);
        ParentCode = null;
        if (pollutant != null && pollutant.ParentID != null)
        {
            LOV_POLLUTANT pollutantGroup = ListOfValues.GetPollutant(pollutant.ParentID.Value);
            ParentCode = pollutantGroup != null ? pollutantGroup.Code : null;
        }

        List<TimeSeriesClasses.ConfidentialityPollutant> data = PollutantReleaseTrend.GetConfidentialTimeSeries(facilityid, pollutantCode, medium);
        bool hasConfidentialInformation = data.Any();

        this.divConfidentialityInformation.Visible = hasConfidentialInformation;
        this.divNoConfidentialityInformation.Visible = !hasConfidentialInformation;

        this.lvConfidentiality.Visible = true;
        this.lvConfidentiality.DataSource = data;
        this.lvConfidentiality.DataBind();
    }

    #region viewstate properties
    public string PollutantCode
    {
        get { return (string)ViewState[POLLUTANTCODE]; }
        set { ViewState[POLLUTANTCODE] = value; }
    }

    protected string ParentCode
    {
        get { return (string)ViewState[PARENTCODE]; }
        set { ViewState[PARENTCODE] = value; }
    }

    #endregion

    #region databinding methods

    protected void OnConfDatabinding(object sender, EventArgs args)
    {
        Control headerGroup = this.lvConfidentiality.FindControl("divPollutantGroupHeader");
        headerGroup.Visible = ShowGroup;

        string pollutantCode = PollutantCode;

        if (!String.IsNullOrEmpty(pollutantCode))
        {
            Label lbPollutant = this.lvConfidentiality.FindControl("lbPollutant") as Label;
            if (lbPollutant != null) lbPollutant.Text = LOVResources.PollutantName(pollutantCode);
        }

        if (ShowGroup)
        {
            Label lbPollutantGroup = this.lvConfidentiality.FindControl("lbPollutantGroup") as Label;
            if (lbPollutantGroup != null) lbPollutantGroup.Text = LOVResources.PollutantName(ParentCode);
        }
    }


    //only show group col if selected pollutant is not a group itsself
    protected bool ShowGroup
    {
        get { return !String.IsNullOrEmpty(ParentCode); }
    }

    protected int GetYear(object obj)
    {
        TimeSeriesClasses.ConfidentialityPollutant row = (TimeSeriesClasses.ConfidentialityPollutant)obj;
        return row.Year;
    }

    protected string GetQuantity(object obj)
    {
        TimeSeriesClasses.ConfidentialityPollutant row = (TimeSeriesClasses.ConfidentialityPollutant)obj;
        return QuantityFormat.Format(row.QuantityPollutant, row.UnitPollutant);
    }

    protected string GetQuantityGroup(object obj)
    {
        TimeSeriesClasses.ConfidentialityPollutant row = (TimeSeriesClasses.ConfidentialityPollutant)obj;
        return QuantityFormat.Format(row.QuantityConfidential, row.UnitConfidential);
    }


    #endregion
}
