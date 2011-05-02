using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using QueryLayer;
using QueryLayer.Filters;
using EPRTR.Localization;
using EPRTR.HeaderBuilders;
using EPRTR.Utilities;
using EPRTR.Enums;




public partial class ucIndustrialActivitySheet : System.Web.UI.UserControl
{
    private const string FILTER = "IA_industrialactivityfilter";
    private const string PR_CONF_AFFECTED = "PR_confidentialityAffected";
    private const string PT_CONF_AFFECTED = "PT_confidentialityAffected";
    private const string WT_CONF_AFFECTED = "WT_confidentialityAffected";
    private const string CONTENTSTART = "ucIndustrialActivitySheetContentStart";
    private const string TOTAL = "IA_Total";
    private const string INDUSTRIAL_ACTVITY_SHEET = "IndustrialActivitySheet";

    #region ViewState properties

    /// <value>
    /// The searchfilter
    /// </value>
    protected IndustrialActivitySearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as IndustrialActivitySearchFilter; }
        set { ViewState[FILTER] = value; }
    }

    private string ContentStart 
    { 
        get { return (string)ViewState[CONTENTSTART]; }
        set { ViewState[CONTENTSTART] = value; }
    }

    private bool? PollutantReleaseConfidentialityAffected
    {
        get { return (bool?)ViewState[PR_CONF_AFFECTED]; }
        set { ViewState[PR_CONF_AFFECTED] = value; }
    }

    private bool? PollutantTransferConfidentialityAffected
    {
        get { return (bool?)ViewState[PT_CONF_AFFECTED]; }
        set { ViewState[PT_CONF_AFFECTED] = value; }
    }

    private bool? WasteTransferConfidentialityAffected
    {
        get { return (bool?)ViewState[WT_CONF_AFFECTED]; }
        set { ViewState[WT_CONF_AFFECTED] = value; }
    }

    protected Sheets.IndustrialActivity Sheet
    {
        get { return (Sheets.IndustrialActivity)ViewState[INDUSTRIAL_ACTVITY_SHEET]; }
        set { ViewState[INDUSTRIAL_ACTVITY_SHEET] = value; }
    }

    public int? TotalCount {
        get { return (int?)ViewState[TOTAL]; }
        set { ViewState[TOTAL] = value; }
    }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            this.ucSheetLinks.ResetContentLinks();
            this.ucSheetLinks.SetLink(Resources.GetGlobal("IndustrialActivity", "PollutantReleases"), Sheets.IndustrialActivity.PollutantReleases.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("IndustrialActivity", "PollutantTransfers"), Sheets.IndustrialActivity.PollutantTransfers.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("IndustrialActivity", "WasteTransfers"), Sheets.IndustrialActivity.WasteTransfers.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("IndustrialActivity", "Confidentiality"), Sheets.IndustrialActivity.Confidentiality.ToString());
        }

        if (this.ucSheetLinks.Linkclick == null)
            this.ucSheetLinks.Linkclick = new EventHandler(linkClick);

        if (this.ucSheetSubHeader.AlertClick == null)
            this.ucSheetSubHeader.AlertClick = new EventHandler(alertClick);

        this.ucDownloadPrint.DoSave = new EventHandler(DoSaveCSV);

        
    }
    
    /// <summary>
    /// Search, fill data into summery
    /// </summary>
    public void Populate(IndustrialActivitySearchFilter filter)
    {
        SearchFilter = filter;

        // clear confidentiality viewstate flags 
        PollutantReleaseConfidentialityAffected = null;
        PollutantTransferConfidentialityAffected = null;
        WasteTransferConfidentialityAffected = null;
        TotalCount = null;

        // default show pollutant releases
        showContent(getDefaultContent());
    }

    private string getDefaultContent()
    {
        if (String.IsNullOrEmpty(ContentStart))
        {
            string content = Request.Params["content"];
            if (!String.IsNullOrEmpty(content))
            {
                ContentStart = content;
                return content;
            }
        }
        return Sheets.IndustrialActivity.PollutantReleases.ToString();
    }
    
    /// <summary>
    /// returns confidential indicator for pollutant releases. If not calculated yet, it will be calculated and stored in viewstate
    /// </summary>
    /// <returns></returns>
    protected bool getPollutantReleaseConfidentialityAffected()
    {
        if (PollutantReleaseConfidentialityAffected == null)
        {
            PollutantReleaseConfidentialityAffected = IndustrialActivity.IsPollutantReleaseAffectedByConfidentiality(SearchFilter);
        }

        return (bool)PollutantReleaseConfidentialityAffected;
    }

    //returns confidential indicator for pollutant transfers. If not calculated yet, it will be calculated and stored in viewstate
    protected bool getPollutantTransferConfidentialityAffected()
    {
        if (PollutantTransferConfidentialityAffected == null)
        {
            PollutantTransferConfidentialityAffected = IndustrialActivity.IsPollutantTransferAffectedByConfidentiality(SearchFilter);
        }

        return (bool)PollutantTransferConfidentialityAffected;
    }

    //returns confidential indicator for waste transfers. If not calculated yet, it will be calculated and stored in viewstate
    protected bool getWasteTransferConfidentialityAffected()
    {
        if (WasteTransferConfidentialityAffected == null)
        {
            WasteTransferConfidentialityAffected = IndustrialActivity.IsWasteAffectedByConfidentiality(SearchFilter);
        }

        return (bool)WasteTransferConfidentialityAffected;
    }

    //returns true if confidentiality is affected for any of the three result types
    protected bool getAnyConfidentialityAffected()
    {
        return getPollutantReleaseConfidentialityAffected()
            || getPollutantTransferConfidentialityAffected()
            || getWasteTransferConfidentialityAffected();
    }

    //returns confidential indicator for waste trasnfers. If not calculated yet, it will be calculated and stored in viewstate
    protected int getTotalCount()
    {
        if (TotalCount == null)
        {
            TotalCount = IndustrialActivity.GetFacilityCount(SearchFilter);
        }

        return (int)TotalCount;
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


    private void showContent(string command)
    {
        hideSubControls();
        this.ucSheetLinks.HighLight(command);
        string txt = string.Empty;
        bool includeFacilityCount = true;
        IndustrialActivitySearchFilter filter = SearchFilter;
        string alert = string.Empty;
        int countTotal = getTotalCount();

        // activate print
        this.ucDownloadPrint.Visible = true;
        this.ucDownloadPrint.SetPrintControl(this);

        if (command.Equals(Sheets.IndustrialActivity.PollutantReleases.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("IndustrialActivity", "IndustrialActivityPollutantReleases");
            this.ucIndustrialActivityPollutantReleases.Visible = true;
            this.ucIndustrialActivityPollutantReleases.Populate(filter);
            txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyReleases");

            bool prConf = getPollutantReleaseConfidentialityAffected();
            alert = prConf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;

            this.ucDownloadPrint.Show(true, true);
            Sheet = Sheets.IndustrialActivity.PollutantReleases;
        }
        else if (command.Equals(Sheets.IndustrialActivity.PollutantTransfers.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("IndustrialActivity", "IndustrialActivityPollutantTransfers");
            this.ucIndustrialActivityPollutantTransfers.Visible = true;
            this.ucIndustrialActivityPollutantTransfers.Populate(filter);
            txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyTransfers");

            bool ptConf = getPollutantTransferConfidentialityAffected();
            alert = ptConf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;

            this.ucDownloadPrint.Show(true, true);
            Sheet = Sheets.IndustrialActivity.PollutantTransfers;
        }
        else if (command.Equals(Sheets.IndustrialActivity.WasteTransfers.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("IndustrialActivity", "IndustrialActivityWasteTransfers");
            this.ucIndustrialActivityWasteTransfer.Visible = true;
            this.ucIndustrialActivityWasteTransfer.Populate(filter);
            txt = Resources.GetGlobal("WasteTransfers", "AllValuesAreYearlyTransfers");

            bool wtConf = getWasteTransferConfidentialityAffected();
            alert = wtConf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;

            this.ucDownloadPrint.Show(true, true);
            Sheet = Sheets.IndustrialActivity.WasteTransfers;
        }
        else if (command.Equals(Sheets.IndustrialActivity.Confidentiality.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("IndustrialActivity", "IndustrialActivityConfidential");
            this.ucIndustrialActivityConfidentiality.Visible = true;
            includeFacilityCount = false;
            bool conf = getAnyConfidentialityAffected();
            alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlert") : string.Empty;
            this.ucIndustrialActivityConfidentiality.Populate(filter, conf);

            this.ucDownloadPrint.Show(false, true);
            Sheet = Sheets.IndustrialActivity.Confidentiality;
        }

        updateHeader(filter, countTotal, filter.Count, includeFacilityCount, txt);
        updateAlert(alert);

        
    }

    /// <summary>
    /// create header
    /// </summary>
    /// <param name="countTotal">The total number of facilities fullfilling the search critieria</param>
    /// <param name="countSheet">The number of facilites fullfilling the search criteria for the selected sheet (e.g. Pollutant releases)</param>
    private void updateHeader(IndustrialActivitySearchFilter filter, int countTotal, int countSheet, bool includeFacilityCount, string text)
    {
        Dictionary<string, string> header = SheetHeaderBuilder.GetIndustrialActivitySearchHeader(filter, countTotal, countSheet);
        this.ucSheetSubHeader.PopulateHeader(header);
        this.ucSheetSubHeader.Text = text;
    }

    private void updateAlert(string alert)
    {
        this.ucSheetSubHeader.AlertText = alert;
        this.ucSheetSubHeader.AlertCommandArgument = Sheets.IndustrialActivity.Confidentiality.ToString();
    }
    
    /// <summary>
    /// hide
    /// </summary>
    private void hideSubControls()
    {
        this.ucIndustrialActivityPollutantReleases.Visible = false;
        this.ucIndustrialActivityPollutantTransfers.Visible = false;
        this.ucIndustrialActivityWasteTransfer.Visible = false;
        this.ucIndustrialActivityConfidentiality.Visible = false;
    }


    public void DoSaveCSV(object sender, EventArgs e)
    {
        switch (Sheet)
        {
            case Sheets.IndustrialActivity.PollutantReleases:
                ucIndustrialActivityPollutantReleases.DoSaveCSV(this, EventArgs.Empty);
                break;
            case Sheets.IndustrialActivity.PollutantTransfers:
                ucIndustrialActivityPollutantTransfers.DoSaveCSV(this, EventArgs.Empty);
                break;
            case Sheets.IndustrialActivity.WasteTransfers:
                ucIndustrialActivityWasteTransfer.DoSaveCSV(this, EventArgs.Empty);
                break;
            default:
                break;
        }
    }

}
