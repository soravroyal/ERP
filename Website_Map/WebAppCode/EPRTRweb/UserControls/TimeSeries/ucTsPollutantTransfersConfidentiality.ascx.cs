using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer.Filters;
using QueryLayer;
using EPRTR.Localization;
using QueryLayer.Utilities;
using EPRTR.Formatters;

public partial class ucTsPollutantTransfersConfidentiality : System.Web.UI.UserControl
{
    private const string POLLUTANTCODE = "PRtsConfPollutantcode";
    private const string PARENTCODE = "PRtsConfParentCode";
    private string FILTER = "PRtsConfFilter";

    #region Viewstate properties

    protected PollutantTransferTimeSeriesFilter SearchFilter
    {
        get { return ViewState[FILTER] as PollutantTransferTimeSeriesFilter; }
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

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
    }


    public void Populate(PollutantTransferTimeSeriesFilter filter, bool hasConfidentialInformation)
    {
        SearchFilter = filter;

        LOV_POLLUTANT pollutant = ListOfValues.GetPollutant(filter.PollutantFilter.PollutantID);

        PollutantCode = pollutant != null ? pollutant.Code : null;

        //set parentcode
        ParentCode = null;
        if (pollutant != null && pollutant.ParentID != null)
        {
            LOV_POLLUTANT pollutantGroup = ListOfValues.GetPollutant(pollutant.ParentID.Value);
            ParentCode = pollutantGroup != null ? pollutantGroup.Code : null;
        }

        this.divConfidentialityInformation.Visible = hasConfidentialInformation;
        this.divNoConfidentialityInformation.Visible = !hasConfidentialInformation;

        showContent(filter);
    }


    protected void Page_PreRender(object sender, EventArgs e)
    {
        Control headerGroup = this.lvConfidentiality.FindControl("divPollutantGroupHeader");
        
        if (headerGroup != null)
        {
            headerGroup.Visible = ShowGroup;
        }

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

    private void showContent(PollutantTransferTimeSeriesFilter filter)
    {
        this.lvConfidentiality.DataSource = PollutantTransferTrend.GetConfidentialTimeSeries(filter);
        this.lvConfidentiality.DataBind();
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
