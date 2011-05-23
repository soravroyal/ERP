using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer.Filters;
using QueryLayer;
using EPRTR.Localization;
using EPRTR.Formatters;

public partial class ucPollutantReleasesConfidentiality : System.Web.UI.UserControl
{
    private const string FILTER = "conf_pollutantReleasesFilter";

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    #region viewstate properties

    /// <summary>
    /// search filter to be used by sub sheet
    /// </summary>
    public PollutantReleaseSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as PollutantReleaseSearchFilter; }
        set { ViewState[FILTER] = value; }
    }

    #endregion

    /// <summary>
    /// method to populate the listview
    /// </summary>
    public void Populate(PollutantReleaseSearchFilter filter, bool hasConfidentialInformation)
    {
        SearchFilter = filter;

        if (hasConfidentialInformation)
        {
            litConfidentialityExplanation1.Text = CMSTextCache.CMSText("Common", "ConfidentialityExplanationPR1");
            litConfidentialityExplanation2.Text = CMSTextCache.CMSText("Common", "ConfidentialityExplanationPR2");

            // fill pollutant data
            this.lvPollutantReleasesConfidentialPollutant.DataSource = QueryLayer.PollutantReleases.GetConfidentialPollutant(filter);
            this.lvPollutantReleasesConfidentialPollutant.DataBind();

            // fill reson data
            this.lvPollutantReleasesConfidentialReason.DataSource = QueryLayer.PollutantReleases.GetConfidentialReason(filter);
            this.lvPollutantReleasesConfidentialReason.DataBind();
            this.litReasonDesc.Visible = (this.lvPollutantReleasesConfidentialReason.Items.Count > 0);
        }

        divConfidentialityInformation.Visible = hasConfidentialInformation;
        divNoConfidentialityInformation.Visible = !hasConfidentialInformation;
    }

    #region databinding methods
    //Hide headers dependend on filter selections.
    protected void OnDataBindingConf(object sender, EventArgs e)
    {
        Control headerAir = this.lvPollutantReleasesConfidentialPollutant.FindControl("divHeaderAir");
        headerAir.Visible = ShowAir;

        Control headerWater = this.lvPollutantReleasesConfidentialPollutant.FindControl("divHeaderWater");
        headerWater.Visible = ShowWater;

        Control headerSoil = this.lvPollutantReleasesConfidentialPollutant.FindControl("divHeaderSoil");
        headerSoil.Visible = ShowSoil;
    }

    //Hide headers dependend on filter selections.
    protected void OnDataBindingReason(object sender, EventArgs e)
    {
        Control headerAir = this.lvPollutantReleasesConfidentialReason.FindControl("divReasonHeaderAir");
        headerAir.Visible = ShowAir;

        Control headerWater = this.lvPollutantReleasesConfidentialReason.FindControl("divReasonHeaderWater");
        headerWater.Visible = ShowWater;

        Control headerSoil = this.lvPollutantReleasesConfidentialReason.FindControl("divReasonHeaderSoil");
        headerSoil.Visible = ShowSoil;
    }

    //only show air if selected in filter
    protected bool ShowAir
    {
        get { return SearchFilter.MediumFilter.ReleasesToAir; }
    }

    //only show water if selected in filter
    protected bool ShowWater
    {
        get { return SearchFilter.MediumFilter.ReleasesToWater; }
    }

    //only show soil if selected in filter
    protected bool ShowSoil
    {
        get { return SearchFilter.MediumFilter.ReleasesToSoil; }
    }


    protected string GetPollutantName(object obj)
    {
        PollutantReleases.ConfidentialTotal row = (PollutantReleases.ConfidentialTotal)obj;
        return LOVResources.PollutantName(row.Code);
    }

    protected string GetReason(object obj)
    {
        PollutantReleases.ConfidentialTotal row = (PollutantReleases.ConfidentialTotal)obj;
        return LOVResources.ConfidentialityReason(row.Code);
    }

    protected string GetFacilitiesAir(object obj)
    {
        PollutantReleases.ConfidentialTotal row = (PollutantReleases.ConfidentialTotal)obj;
        return NumberFormat.Format(row.FacilitiesAir);
    }
    protected string GetFacilitiesWater(object obj)
    {
        PollutantReleases.ConfidentialTotal row = (PollutantReleases.ConfidentialTotal)obj;
        return NumberFormat.Format(row.FacilitiesWater);
    }
    protected string GetFacilitiesSoil(object obj)
    {
        PollutantReleases.ConfidentialTotal row = (PollutantReleases.ConfidentialTotal)obj;
        return NumberFormat.Format(row.FacilitiesSoil);
    }



    #endregion
}
