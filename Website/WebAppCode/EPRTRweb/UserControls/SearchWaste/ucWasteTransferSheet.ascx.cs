using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Web.UI;
using System.Web.UI.WebControls;

using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;

using EPRTR.Localization;
using EPRTR.HeaderBuilders;
using EPRTR.Utilities;
using EPRTR.Enums;


public partial class ucWasteTransferSheet : System.Web.UI.UserControl
{
    
    #region ViewState properties
    
    private const string FILTER = "WT_wastetransferfilter";
    private const string CONF_AFFECTED = "WT_confidentialityAffected";
    private const string WASTE_SHEET = "WasteTransferSheet";
    
    /// <value>
    /// The searchfilter
    /// </value>
    protected WasteTransferSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as WasteTransferSearchFilter; }
        set { ViewState[FILTER] = value; }
    }

    protected bool ConfidentialityAffected
    {
        get { return (bool)ViewState[CONF_AFFECTED]; }
        set { ViewState[CONF_AFFECTED] = value; }
    }

    protected Sheets.WasteTransfers Sheet
    {
        get { return (Sheets.WasteTransfers)ViewState[WASTE_SHEET]; }
        set { ViewState[WASTE_SHEET] = value; }
    }
    #endregion

    private WasteTransfers.FacilityCountObject FacilityCounts = null;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.ucSheetLinks.ResetContentLinks();
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Common","Summary"),  Sheets.WasteTransfers.Summary.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "Activities"), Sheets.WasteTransfers.Activities.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "Areas"), Sheets.WasteTransfers.Areas.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Pollutant", "AreaComparison"), Sheets.WasteTransfers.AreaComparison.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "Facilities"), Sheets.WasteTransfers.Facilities.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("WasteTransfers", "HazTransboundary"), Sheets.WasteTransfers.HazTransboundary.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("WasteTransfers", "HazReceivers"), Sheets.WasteTransfers.HazReceivers.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "Confidentiality"), Sheets.WasteTransfers.Confidentiality.ToString());
        }

        if (this.ucSheetLinks.Linkclick == null)
            this.ucSheetLinks.Linkclick = new EventHandler(linkClick);

        if (this.ucSheetSubHeader.AlertClick == null)
            this.ucSheetSubHeader.AlertClick = new EventHandler(alertClick);

        this.ucDownloadPrint.DoSave = new EventHandler(DoSaveCSV);

        if (this.ucWasteTransferActivities.ContentChanged == null)
            this.ucWasteTransferActivities.ContentChanged = new EventHandler(contentChanged);
        if (this.ucWasteTransferAreas.ContentChanged == null)
            this.ucWasteTransferAreas.ContentChanged = new EventHandler(contentChanged);
        if (this.ucWasteTransferFacilities.ContentChanged==null)
            this.ucWasteTransferFacilities.ContentChanged = new EventHandler(contentChanged);
    }

    /// <summary>
    /// Search, fill data into summery
    /// </summary>
    public void Populate(WasteTransferSearchFilter filter)
    {
        SearchFilter = filter;
        ConfidentialityAffected = WasteTransfers.IsAffectedByConfidentiality(filter); //Only determine once and store in viewstate

        //default show summary
        showContent(Sheets.WasteTransfers.Summary.ToString());
        
        // remove these sheet links if Hazardous Transboundary waste is NOT selected by the user 
        bool linkVisibility = filter.WasteTypeFilter.HazardousWasteTransboundary;
        this.ucSheetLinks.ToggleLink(Sheets.WasteTransfers.HazReceivers.ToString(), linkVisibility);
        this.ucSheetLinks.ToggleLink(Sheets.WasteTransfers.HazTransboundary.ToString(), linkVisibility);
    }

    /// <summary>
    /// showcontent
    /// </summary>
    private void showContent(string command)
    {
        hideSubControls();
        this.ucSheetLinks.HighLight(command);
        string txt = string.Empty;
        bool includeFacilityCount = true;
        
        WasteTransferSearchFilter filter = SearchFilter;

        bool conf = ConfidentialityAffected;
        string alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;

        if (command.Equals(Sheets.WasteTransfers.Summary.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("WasteTransfers", "WasteTransferSummery");
            this.ucWasteTransferSummary.Visible = true;
            // Populate summery in pre_render (because of print)
            this.ucWasteTransferSummary.Populate(filter);
            txt = Resources.GetGlobal("WasteTransfers", "AllValuesAreYearlyTransfers");
            this.ucDownloadPrint.Show(false, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.WasteTransfers.Summary;
            
        }
        else if (command.Equals(Sheets.WasteTransfers.Activities.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("WasteTransfers", "WasteTransferActivities");
            this.ucWasteTransferActivities.Visible = true;
            this.ucWasteTransferActivities.Populate(filter);
            txt = Resources.GetGlobal("WasteTransfers", "AllValuesAreYearlyTransfers");
            this.ucDownloadPrint.Visible = true; // activate print button only
            this.ucDownloadPrint.Show(true, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.WasteTransfers.Activities;
        }
        else if (command.Equals(Sheets.WasteTransfers.Areas.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("WasteTransfers", "WasteTransferAreas");
            this.ucWasteTransferAreas.Visible = true;

            filter.Count = getFacilityCounts(filter).Total.GetValueOrDefault();

            this.ucWasteTransferAreas.Populate(filter);
            txt = Resources.GetGlobal("WasteTransfers", "AllValuesAreYearlyTransfers");
            this.ucDownloadPrint.Visible = true; // activate print button only
            this.ucDownloadPrint.Show(false, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.WasteTransfers.Areas;
        }
        else if (command.Equals(Sheets.WasteTransfers.AreaComparison.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("WasteTransfers", "WasteTransferAreaComparison");
            this.ucWasteTransferComparison.Visible = true;

            var counts = getFacilityCounts(filter);
            filter.Count = counts.Total.GetValueOrDefault();

            this.ucWasteTransferComparison.Populate(filter, counts);
            txt = Resources.GetGlobal("WasteTransfers", "AllValuesArePercentOfEuroTotal");
            this.ucDownloadPrint.Visible = false;

            Sheet = Sheets.WasteTransfers.AreaComparison;
        }
        else if (command.Equals(Sheets.WasteTransfers.Facilities.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("WasteTransfers", "WasteTransferFacilities");
            this.ucWasteTransferFacilities.Visible = true;
            this.ucWasteTransferFacilities.Populate(filter, getFacilityCounts(filter));
            txt = Resources.GetGlobal("WasteTransfers", "AllValuesAreYearlyTransfers");
            this.ucDownloadPrint.Visible = true;
            this.ucDownloadPrint.Show(true, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.WasteTransfers.Facilities;
        }
        else if (command.Equals(Sheets.WasteTransfers.HazTransboundary.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("WasteTransfers", "WasteTransferHazTransbound");
            this.ucWasteTransferHazTransboundary.Visible = true;

            var counts = getFacilityCounts(filter);
            filter.Count = counts.HWOC.GetValueOrDefault();

            this.ucWasteTransferHazTransboundary.Populate(filter);
            txt = Resources.GetGlobal("WasteTransfers", "AllValuesAreYearlyTransfers");
            this.ucDownloadPrint.Show(true, false);
            
            Sheet = Sheets.WasteTransfers.HazTransboundary;
        }
        else if (command.Equals(Sheets.WasteTransfers.HazReceivers.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("WasteTransfers", "WasteTransferHazReceivers");
            this.ucWasteTransferHazReceivers.Visible = true;
            this.ucWasteTransferHazReceivers.Populate(filter);
            txt = Resources.GetGlobal("WasteTransfers", "AllValuesAreYearlyTransfersOnlyHW");
            this.ucDownloadPrint.Visible = true; // activate print button only
            this.ucDownloadPrint.Show(false, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.WasteTransfers.HazReceivers;
        }
        else if (command.Equals(Sheets.WasteTransfers.Confidentiality.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("WasteTransfers", "WasteTransferConfidentiality");
            this.ucWasteTransferConfidentiality.Visible = true;
            this.ucWasteTransferConfidentiality.Populate(filter, conf);
            includeFacilityCount = false;
            alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlert") : string.Empty;
            this.ucDownloadPrint.Visible = true; // activate print button only
            this.ucDownloadPrint.Show(false, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.WasteTransfers.Confidentiality;
        }

        updateHeader(filter, includeFacilityCount, txt);
        updateAlert(alert);

    }

    /// <summary>
    /// update header
    /// </summary>
    private void updateHeader(WasteTransferSearchFilter filter, bool includeFacilityCount, string text)
    {
        Dictionary<string, string> header = SheetHeaderBuilder.GetWasteTransferSearchHeader(filter, includeFacilityCount);
        this.ucSheetSubHeader.PopulateHeader(header);
        this.ucSheetSubHeader.Text = text;
    }


    /// <summary>
    /// update alert
    /// </summary>
    private void updateAlert(string alert)
    {
        this.ucSheetSubHeader.AlertText = alert;
        this.ucSheetSubHeader.AlertCommandArgument = Sheets.WasteTransfers.Confidentiality.ToString();
    }


    private WasteTransfers.FacilityCountObject getFacilityCounts(WasteTransferSearchFilter filter)
    {
        if (FacilityCounts == null)
        {
            FacilityCounts = WasteTransfers.GetFacilityCounts(filter);
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
        this.ucWasteTransferSummary.Visible = false;
        this.ucWasteTransferActivities.Visible = false;
        this.ucWasteTransferAreas.Visible = false;
        this.ucWasteTransferComparison.Visible = false;
        this.ucWasteTransferFacilities.Visible = false;
        this.ucWasteTransferHazTransboundary.Visible = false;
        this.ucWasteTransferHazReceivers.Visible = false;
        this.ucWasteTransferConfidentiality.Visible = false;

        //this.ucDownloadPrint.DoSave = null;
    }
    
    /// <summary>
    /// update the printable control
    /// </summary>
    private void contentChanged(object sender, EventArgs e)
    {
        this.ucDownloadPrint.SetPrintControl(this);
    }

    public void DoSaveCSV(object sender, EventArgs e)
    {
        switch (Sheet)
        {
            case Sheets.WasteTransfers.Activities:
                ucWasteTransferActivities.DoSaveCSV(this, EventArgs.Empty);
                break;
            case Sheets.WasteTransfers.HazTransboundary:
                ucWasteTransferHazTransboundary.DoSaveCSV(this, EventArgs.Empty);
                break;
            case Sheets.WasteTransfers.Facilities:
                ucWasteTransferFacilities.DoSaveCSV(this, EventArgs.Empty);
                break;
            default:
                break;
        }
    }

    public bool ShowRecovery
    {
        get { return SearchFilter.WasteTreatmentFilter.Recovery; }
    }

    protected bool ShowDisposal
    {
        get { return SearchFilter.WasteTreatmentFilter.Disposal; }
    }

    protected bool ShowUnspecified
    {
        get { return SearchFilter.WasteTreatmentFilter.Unspecified; }
    }

    protected bool ShowTotal
    {
        get
        {
            return
                SearchFilter.WasteTreatmentFilter.Recovery
                && SearchFilter.WasteTreatmentFilter.Disposal
                && SearchFilter.WasteTreatmentFilter.Unspecified;
        }
    }

}
