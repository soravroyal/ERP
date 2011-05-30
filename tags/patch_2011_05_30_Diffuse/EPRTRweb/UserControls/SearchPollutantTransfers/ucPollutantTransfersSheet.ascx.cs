using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Localization;
using QueryLayer.Filters;
using EPRTR.HeaderBuilders;
using QueryLayer;
using EPRTR.Enums;

public partial class ucPollutantTransfersSheet : System.Web.UI.UserControl
{
    #region ViewState properties

    private const string FILTER = "PT_pollutanttransferfilter";
    private const string CONF_AFFECTED = "PT_confidentialityAffected";
    private const string POLLUTANT_TRANSFER_SHEET = "PollutantTransfersSheet";
    
    /// <summary>
    /// search filter to be used by sub sheets
    /// </summary>
    private PollutantTransfersSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as PollutantTransfersSearchFilter; }
        set { ViewState[FILTER] = value; }
    }

    protected bool ConfidentialityAffected
    {
        get { return (bool)ViewState[CONF_AFFECTED]; }
        set { ViewState[CONF_AFFECTED] = value; }
    }


    protected Sheets.PollutantTransfers Sheet
    {
        get { return (Sheets.PollutantTransfers)ViewState[POLLUTANT_TRANSFER_SHEET]; }
        set { ViewState[POLLUTANT_TRANSFER_SHEET] = value; }
    }
    #endregion


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.ucSheetLinks.ResetContentLinks();
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Pollutant","Summary"),  Sheets.PollutantTransfers.Summary.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Pollutant", "Activities"), Sheets.PollutantTransfers.Activities.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Pollutant", "Areas"), Sheets.PollutantTransfers.Areas.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Pollutant", "AreaComparison"), Sheets.PollutantTransfers.AreaComparison.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Pollutant", "Facilities"), Sheets.PollutantTransfers.Facilities.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Pollutant", "Confidentiality"), Sheets.PollutantTransfers.Confidentiality.ToString());
        }

        if (this.ucSheetLinks.Linkclick == null)
            this.ucSheetLinks.Linkclick = new EventHandler(linkClick);

        if (this.ucSheetSubHeader.AlertClick == null)
            this.ucSheetSubHeader.AlertClick = new EventHandler(alertClick);

          this.ucDownloadPrint.DoSave = new EventHandler(DoSaveCSV);

        if (this.ucPollutantTransfersActivities.ContentChanged == null)
            this.ucPollutantTransfersActivities.ContentChanged = new EventHandler(contentChanged);
        if (this.ucPollutantTransfersAreas.ContentChanged == null)
            this.ucPollutantTransfersAreas.ContentChanged = new EventHandler(contentChanged);
        if (this.ucPollutantTransfersFacilities.ContentChanged == null)
            this.ucPollutantTransfersFacilities.ContentChanged = new EventHandler(contentChanged);
    }




    /// <summary>
    /// Search, fill data into summery
    /// </summary>
    public void Populate(PollutantTransfersSearchFilter filter)
    {
        SearchFilter = filter;
        ConfidentialityAffected = PollutantTransfers.IsAffectedByConfidentiality(filter); //Only determine once and store in viewstate
        // always show summery
        showContent(Sheets.PollutantTransfers.Summary.ToString());
    }

    private void showContent(string command)
    {
        hideSubControls();
        this.ucSheetLinks.HighLight(command);
        string txt = string.Empty;
        bool includeFacilityCount = true;
        PollutantTransfersSearchFilter filter = SearchFilter;

        bool conf = ConfidentialityAffected;
        string alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;

        if (command.Equals(Sheets.PollutantTransfers.Summary.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Pollutant", "PollutantTransfersSummary");
            this.ucPollutantTransfersSummery.Visible = true;
            this.ucPollutantTransfersSummery.Populate(filter);
            txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyTransfers");
            this.ucDownloadPrint.Visible = false;

            Sheet = Sheets.PollutantTransfers.Summary;
        }
        else if (command.Equals(Sheets.PollutantTransfers.Activities.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Pollutant", "PollutantTransfersActivity");
            this.ucPollutantTransfersActivities.Visible = true;
            this.ucPollutantTransfersActivities.Populate(filter);
            txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyTransfers");
            this.ucDownloadPrint.Visible = true;
            this.ucDownloadPrint.Show(false, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.PollutantTransfers.Activities;
        }
        else if (command.Equals(Sheets.PollutantTransfers.Areas.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Pollutant", "PollutantTransAreas");
            this.ucPollutantTransfersAreas.Visible = true;
            this.ucPollutantTransfersAreas.Populate(filter);
            txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyTransfers");
            this.ucDownloadPrint.Visible = true;// activate print button only
            this.ucDownloadPrint.Show(false, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.PollutantTransfers.Areas;
        }
        else if (command.Equals(Sheets.PollutantTransfers.AreaComparison.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Pollutant", "PollutantTransAreaComparison");
            this.ucPollutantTransfersAreaComparison.Visible = true;
            this.ucPollutantTransfersAreaComparison.Populate(filter);
            txt = Resources.GetGlobal("Pollutant", "AllValuesArePercentOfEuroTotal");
            this.ucDownloadPrint.Visible = false;

            Sheet = Sheets.PollutantTransfers.AreaComparison;
        }
        else if (command.Equals(Sheets.PollutantTransfers.Facilities.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Pollutant", "PollutantTransFacilities");
            this.ucPollutantTransfersFacilities.Visible = true;
            this.ucPollutantTransfersFacilities.Populate(filter);
            txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyTransfers");
            this.ucDownloadPrint.Visible = true;
            this.ucDownloadPrint.Show(true, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.PollutantTransfers.Facilities;
        }
        else if (command.Equals(Sheets.PollutantTransfers.Confidentiality.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Pollutant", "PollutantTransConfidentiality");
            this.ucPollutantTransfersConfidentiality.Visible = true;
            this.ucPollutantTransfersConfidentiality.Populate(filter, conf);
            includeFacilityCount = false;
            alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlert") : string.Empty;
            this.ucDownloadPrint.Visible = true;// activate print button only
            this.ucDownloadPrint.Show(false, true);
            this.ucDownloadPrint.SetPrintControl(this);
        }

        updateHeader(filter, includeFacilityCount, txt);
        updateAlert(alert);
    }

    /// <summary>
    /// update header
    /// </summary>
    /// <param name="filter"></param>
    private void updateHeader(PollutantTransfersSearchFilter filter, bool includeFacilityCount, string text)
    {
        Dictionary<string, string> header = SheetHeaderBuilder.GetPollutantTransferSearchHeader(filter, includeFacilityCount);
        this.ucSheetSubHeader.PopulateHeader(header);
        this.ucSheetSubHeader.Text = text;

    }

    private void updateAlert(string alert)
    {
        this.ucSheetSubHeader.AlertText = alert;
        this.ucSheetSubHeader.AlertCommandArgument = Sheets.PollutantTransfers.Confidentiality.ToString();
    }

    /// <summary>
    /// Content link clicked
    /// </summary>
    protected void linkClick(object sender, EventArgs e)
    {
        LinkButton button = sender as LinkButton;
        if (button != null)
        {
            hideSubControls();
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
    /// 
    /// </summary>
    private void hideSubControls()
    {
        this.ucPollutantTransfersSummery.Visible = false;
        this.ucPollutantTransfersActivities.Visible = false;
        this.ucPollutantTransfersAreas.Visible = false;
        this.ucPollutantTransfersAreaComparison.Visible = false;
        this.ucPollutantTransfersFacilities.Visible = false;
        this.ucPollutantTransfersConfidentiality.Visible = false;
    }

    public void DoSaveCSV(object sender, EventArgs e)
    {
        switch (Sheet)
        {
            case Sheets.PollutantTransfers.Facilities:
                ucPollutantTransfersFacilities.DoSaveCSV(this, EventArgs.Empty);
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

