using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Localization;
using QueryLayer.Filters;
using EPRTR.HeaderBuilders;
using QueryLayer;
using EPRTR.Enums;

public partial class ucPollutantReleasesSheet : System.Web.UI.UserControl
{
    private const string FILTER = "PR_pollutantreleasesfilter";
    private const string CONF_AFFECTED = "PR_confidentialityAffected";
    
    private PollutantReleases.FacilityCountObject FacilityCounts = null;

    #region ViewState properties

    /// <value>
    /// The searchfilter
    /// </value>
    protected PollutantReleaseSearchFilter SearchFilter{
        get { return ViewState[FILTER] as PollutantReleaseSearchFilter; }
        set { ViewState[FILTER] = value; }
    }

    protected bool ConfidentialityAffected {
        get { return (bool)ViewState[CONF_AFFECTED]; }
        set { ViewState[CONF_AFFECTED] = value; }
    }

    protected Sheets.PollutantReleases Sheet
    {
        get { return (Sheets.PollutantReleases)ViewState["Sheet"]; }
        set { ViewState["Sheet"] = value; }
    }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.ucSheetLinks.ResetContentLinks();
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Pollutant","Summary"), Sheets.PollutantReleases.Summary.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Pollutant", "Activities"), Sheets.PollutantReleases.Activities.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Pollutant", "Areas"), Sheets.PollutantReleases.Areas.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Pollutant", "AreaComparison"), Sheets.PollutantReleases.AreaComparison.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Pollutant", "Facilities"), Sheets.PollutantReleases.Facilities.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Pollutant", "Confidentiality"), Sheets.PollutantReleases.Confidentiality.ToString());
        }

        if (this.ucSheetLinks.Linkclick == null)
            this.ucSheetLinks.Linkclick = new EventHandler(linkClick);

        if (this.ucSheetSubHeader.AlertClick == null)
            this.ucSheetSubHeader.AlertClick = new EventHandler(alertClick);

        if (this.ucDownloadPrint.DoSave == null)
        {
            this.ucDownloadPrint.DoSave = new EventHandler(DoSaveCSV);
        }


        if (this.ucPollutantReleasesActivities.ContentChanged == null)
            this.ucPollutantReleasesActivities.ContentChanged = new EventHandler(contentChanged);
        if (this.ucPollutantReleasesAreas.ContentChanged == null)
            this.ucPollutantReleasesAreas.ContentChanged = new EventHandler(contentChanged);
        if (this.ucPollutantReleasesFacilities.ContentChanged == null)
            this.ucPollutantReleasesFacilities.ContentChanged = new EventHandler(contentChanged);
    }


    /// <summary>
    /// Search, fill data into summery
    /// </summary>
    public void Populate(PollutantReleaseSearchFilter filter)
    {
        SearchFilter = filter;
        ConfidentialityAffected = PollutantReleases.IsAffectedByConfidentiality(filter); //Only determine once and store in viewstate

        // always show summery
        showContent(Sheets.PollutantReleases.Summary.ToString());
    }

    
    /// <summary>
    /// show content
    /// </summary>
    private void showContent(string command)
    {
        hideSubControls();
        this.ucSheetLinks.HighLight(command);
        string txt = string.Empty;
        bool includeFacilityCount = true;
        PollutantReleaseSearchFilter filter = SearchFilter;

        bool conf = ConfidentialityAffected;
        string alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;

        if (command.Equals(Sheets.PollutantReleases.Summary.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Pollutant", "PollutantReleasesSummary");
            this.ucPollutantReleasesSummary.Visible = true;
            this.ucPollutantReleasesSummary.Populate(filter, getFacilityCounts(filter));
            txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyReleases");
            this.ucDownloadPrint.Visible = false;

            Sheet = Sheets.PollutantReleases.Summary;
        }
        else if (command.Equals(Sheets.PollutantReleases.Activities.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Pollutant", "PollutantReleasesActivity");
            this.ucPollutantReleasesActivities.Visible = true;
            this.ucPollutantReleasesActivities.Populate(filter);
            txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyReleases");
            this.ucDownloadPrint.Visible = true;
            this.ucDownloadPrint.Show(true, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.PollutantReleases.Activities;
        }
        else if (command.Equals(Sheets.PollutantReleases.Areas.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Pollutant", "PollutantReleasesAreas");
            this.ucPollutantReleasesAreas.Visible = true;
            this.ucPollutantReleasesAreas.Populate(filter);
            txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyReleases");
            this.ucDownloadPrint.Visible = true; // activate print button only
            this.ucDownloadPrint.Show(false, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.PollutantReleases.Areas;
        }
        else if (command.Equals(Sheets.PollutantReleases.AreaComparison.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Pollutant", "PollutantReleasesAreaComparison");
            this.ucPollutantReleasesComparison.Visible = true;
            this.ucPollutantReleasesComparison.Populate(filter, getFacilityCounts(filter));
            txt = Resources.GetGlobal("Pollutant", "AllValuesArePercentOfEuroTotal");
            this.ucDownloadPrint.Visible = false;

            Sheet = Sheets.PollutantReleases.AreaComparison;
        }
        else if (command.Equals(Sheets.PollutantReleases.Facilities.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Pollutant", "PollutantReleasesFacilities");
            this.ucPollutantReleasesFacilities.Visible = true;
            this.ucPollutantReleasesFacilities.Populate(filter, getFacilityCounts(filter));
            txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyReleases");
            this.ucDownloadPrint.Visible = true; 
            this.ucDownloadPrint.Show(true, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.PollutantReleases.Facilities;
        }
        else if (command.Equals(Sheets.PollutantReleases.Confidentiality.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Pollutant", "PollutantReleasesConfidentiality");
            this.ucPollutantReleasesConfidentiality.Visible = true;
            this.ucPollutantReleasesConfidentiality.Populate(filter, conf);
            includeFacilityCount = false;
            alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlert") : string.Empty;
            this.ucDownloadPrint.Visible = true; // activate print button only
            this.ucDownloadPrint.Show(false, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.PollutantReleases.Confidentiality;
        }
        updateHeader(filter, includeFacilityCount, txt);
        updateAlert(alert);
    }

    /// <summary>
    /// create header
    /// </summary>
    private void updateHeader(PollutantReleaseSearchFilter filter, bool includeFacilityCount, string text)
    {
        Dictionary<string, string> header = SheetHeaderBuilder.GetPollutantReleaseSearchHeader(filter, includeFacilityCount);
        this.ucSheetSubHeader.PopulateHeader(header);
        this.ucSheetSubHeader.Text = text;
    }

    private void updateAlert(string alert)
    {
        this.ucSheetSubHeader.AlertText = alert;
        this.ucSheetSubHeader.AlertCommandArgument = Sheets.PollutantReleases.Confidentiality.ToString();
    }


    private PollutantReleases.FacilityCountObject getFacilityCounts(PollutantReleaseSearchFilter filter)
    {
        if (FacilityCounts == null)
        {
            FacilityCounts = PollutantReleases.GetFacilityCounts(filter);
        }

        return FacilityCounts;
    }
    

    /// <summary>
    /// Content link clicked
    /// </summary>
    protected void linkClick(object sender, EventArgs e)
    {
        LinkButton button = sender as LinkButton;
        if (button != null)
        {
            showContent(button.CommandArgument);
        }
    }

    /// <summary>
    /// alert link clicked
    /// </summary>
    protected void alertClick(object sender, EventArgs e)
    {
        LinkButton button = sender as LinkButton;
        if (button != null)
        {
            string link = button.CommandArgument;
            showContent(link);
        }
    }
    
    /// <summary>
    /// hide
    /// </summary> 
    private void hideSubControls()
    {
        this.ucPollutantReleasesSummary.Visible = false;
        this.ucPollutantReleasesActivities.Visible = false;
        this.ucPollutantReleasesAreas.Visible = false;
        this.ucPollutantReleasesComparison.Visible = false;
        this.ucPollutantReleasesFacilities.Visible = false;
        this.ucPollutantReleasesConfidentiality.Visible = false;
    }


    public void DoSaveCSV(object sender, EventArgs e)
    {
        switch (Sheet)
        {
            case Sheets.PollutantReleases.Facilities:
                this.ucPollutantReleasesFacilities.DoSaveCSV(this, EventArgs.Empty);
                break;
            case Sheets.PollutantReleases.Activities:
                this.ucPollutantReleasesActivities.DoSaveCSV(this, EventArgs.Empty);
                break;
            default:
                break;
        }
    }


    /// <summary>
    /// update the printable control
    /// </summary>
    private void contentChanged(object sender, EventArgs e)
    {
        this.ucDownloadPrint.SetPrintControl(this);
    }
    
}
