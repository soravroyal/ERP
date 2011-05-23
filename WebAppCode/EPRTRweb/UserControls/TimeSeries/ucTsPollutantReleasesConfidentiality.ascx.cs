using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Formatters;
using EPRTR.Localization;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;

public partial class ucTsPollutantReleasesConfidentiality : System.Web.UI.UserControl
{
    public EventHandler OnMediumChanged;

    private const string POLLUTANTCODE = "PRtsConfPollutantcode";
    private const string PARENTCODE = "PRtsConfParentCode";
    private string FILTER = "PRtsConfFilter";
    private string MEDIUM = "tsmediumcompare";

    #region Viewstate properties

    protected PollutantReleasesTimeSeriesFilter SearchFilter
    {
        get { return ViewState[FILTER] as PollutantReleasesTimeSeriesFilter; }
        set { ViewState[FILTER] = value; }
    }

    protected string PollutantCode
    {
        get { return (string)ViewState[POLLUTANTCODE]; }
        set { ViewState[POLLUTANTCODE] = value; }
    }

    protected string ParentCode
    {
        get { return (string)ViewState[PARENTCODE]; }
        set { ViewState[PARENTCODE] = value; }
    }

    public MediumFilter.Medium CurrentMedium
    {
        get { return (MediumFilter.Medium)ViewState[MEDIUM]; }
        set { ViewState[MEDIUM] = value; }
    }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
    }


    public void Populate(PollutantReleasesTimeSeriesFilter filter, bool hasConfidentialInformation, MediumFilter.Medium medium)
    {
        SearchFilter = filter;

        LOV_POLLUTANT pollutant = ListOfValues.GetPollutant(filter.PollutantFilter.PollutantID);

        PollutantCode = pollutant != null ? pollutant.Code : null;
        
        //set parentcode
        ParentCode = null; 
        if (pollutant!= null && pollutant.ParentID != null)
        {
            LOV_POLLUTANT pollutantGroup = ListOfValues.GetPollutant(pollutant.ParentID.Value);
            ParentCode = pollutantGroup != null ? pollutantGroup.Code : null;
        }

        this.ucMediumSelector.Visible = hasConfidentialInformation;

        if (hasConfidentialInformation)
        {
            var count = PollutantReleaseTrend.GetFacilityCounts(filter);
            this.ucMediumSelector.PopulateMediumRadioButtonList(filter.MediumFilter, medium, count);
        }

    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        Control headerGroup = this.lvConfidentiality.FindControl("divPollutantGroupHeader");

        if(headerGroup != null)
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

    private void showContent(PollutantReleasesTimeSeriesFilter filter, MediumFilter.Medium medium)
    {
        CurrentMedium = medium;

        //examine if there exists any confidential data for the medium given
        bool hasConfidentialInformationMedium = PollutantReleaseTrend.IsAffectedByConfidentiality(filter, medium);
        this.divConfidentialityInformation.Visible = hasConfidentialInformationMedium;
        this.divNoConfidentialityInformation.Visible = !hasConfidentialInformationMedium;

        if (hasConfidentialInformationMedium)
        {
            this.lvConfidentiality.DataSource = PollutantReleaseTrend.GetConfidentialTimeSeries(filter, medium);
            this.lvConfidentiality.DataBind();
        }

    }
    

    /// <summary>
    /// radio buttons selected
    /// </summary>
    protected void OnMediumSelected(object sender, MediumSelectedEventArgs e)
    {
        if (SearchFilter != null)
        {
            showContent(SearchFilter, e.Medium);
            if (OnMediumChanged != null)
                OnMediumChanged.Invoke(sender, EventArgs.Empty);
        }
    }

    #region Databinding methods

    //only show group col if selected pollutant is not a group itsself
    protected bool ShowGroup
    {
        get { return !String.IsNullOrEmpty(ParentCode); }
    }

    protected int GetYear(object obj)
    {
        return ((TimeSeriesClasses.ConfidentialityPollutant)obj).Year;
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
