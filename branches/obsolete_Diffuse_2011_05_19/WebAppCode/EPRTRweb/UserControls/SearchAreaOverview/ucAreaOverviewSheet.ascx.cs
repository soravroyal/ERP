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




public partial class ucAreaOverviewSheet : System.Web.UI.UserControl
{
    private const string FILTER = "AreaOverviewFilter";
    private const string PR_CONF_AFFECTED = "PR_confidentialityAffected";
    private const string PT_CONF_AFFECTED = "PT_confidentialityAffected";
    private const string WT_CONF_AFFECTED = "WT_confidentialityAffected";
    private const string CONTENTSTART = "ucAreaSearchSheetContentStart";
    private const string TOTAL = "AO_Total";

    #region ViewState properties

    /// <value>
    /// The searchfilter
    /// </value>
    protected AreaOverviewSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as AreaOverviewSearchFilter; }
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
            this.ucSheetLinks.SetLink(Resources.GetGlobal("AreaOverview", "PollutantReleases"), Sheets.AreaOverview.PollutantReleases.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("AreaOverview", "PollutantTransfers"), Sheets.AreaOverview.PollutantTransfers.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("AreaOverview", "WasteTransfers"), Sheets.AreaOverview.WasteTransfers.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("AreaOverview", "Confidentiality"), Sheets.AreaOverview.Confidentiality.ToString());
        }

        if (this.ucSheetLinks.Linkclick == null)
            this.ucSheetLinks.Linkclick = new EventHandler(linkClick);

        if (this.ucSheetSubHeader.AlertClick == null)
            this.ucSheetSubHeader.AlertClick = new EventHandler(alertClick);

        if (this.ucAreaOverviewPollutantReleases.ContentChanged == null)
            this.ucAreaOverviewPollutantReleases.ContentChanged = new EventHandler(contentChanged);
        if (this.ucAreaOverviewPollutantTransfers.ContentChanged == null)
            this.ucAreaOverviewPollutantTransfers.ContentChanged = new EventHandler(contentChanged);
        if (this.ucAreaOverviewWasteTransfer.ContentChanged == null)
            this.ucAreaOverviewWasteTransfer.ContentChanged = new EventHandler(contentChanged);
    }
    
    /// <summary>
    /// Search, fill data into summery
    /// </summary>
    public void Populate(AreaOverviewSearchFilter filter)
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
        return Sheets.AreaOverview.PollutantReleases.ToString();
    }
    
    /// <summary>
    /// returns confidential indicator for pollutant releases. If not calculated yet, it will be calculated and stored in viewstate
    /// </summary>
    /// <returns></returns>
    protected bool getPollutantReleaseConfidentialityAffected()
    {
        if (PollutantReleaseConfidentialityAffected == null)
        {
            PollutantReleaseConfidentialityAffected = AreaOverview.IsPollutantReleaseAffectedByConfidentiality(SearchFilter);
        }

        return (bool)PollutantReleaseConfidentialityAffected;
    }

    //returns confidential indicator for pollutant trasnfers. If not calculated yet, it will be calculated and stored in viewstate
    protected bool getPollutantTransferConfidentialityAffected()
    {
        if (PollutantTransferConfidentialityAffected == null)
        {
            PollutantTransferConfidentialityAffected = AreaOverview.IsPollutantTransferAffectedByConfidentiality(SearchFilter);
        }

        return (bool)PollutantTransferConfidentialityAffected;
    }

    //returns confidential indicator for waste trasnfers. If not calculated yet, it will be calculated and stored in viewstate
    protected bool getWasteTransferConfidentialityAffected()
    {
        if (WasteTransferConfidentialityAffected == null)
        {
            WasteTransferConfidentialityAffected = AreaOverview.IsWasteAffectedByConfidentiality(SearchFilter);
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
        AreaOverviewSearchFilter filter = SearchFilter;
        string alert = string.Empty;

        if (command.Equals(Sheets.IndustrialActivity.PollutantReleases.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("AreaOverview", "AreaOverviewPollutantReleases");
            this.ucAreaOverviewPollutantReleases.Visible = true;
            this.ucAreaOverviewPollutantReleases.Populate(filter);
            txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyReleases");

            bool prConf = getPollutantReleaseConfidentialityAffected();
            alert = prConf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;
        }
        else if (command.Equals(Sheets.IndustrialActivity.PollutantTransfers.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("AreaOverview", "AreaOverviewPollutantTransfers");
            this.ucAreaOverviewPollutantTransfers.Visible = true;
            this.ucAreaOverviewPollutantTransfers.Populate(filter);
            txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyTransfers");

            bool ptConf = getPollutantTransferConfidentialityAffected();
            alert = ptConf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;
        }
        else if (command.Equals(Sheets.IndustrialActivity.WasteTransfers.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("AreaOverview", "AreaOverviewWasteTransfers");
            this.ucAreaOverviewWasteTransfer.Visible = true;
            this.ucAreaOverviewWasteTransfer.Populate(filter);
            txt = Resources.GetGlobal("WasteTransfers", "AllValuesAreYearlyTransfers");

            bool wtConf = getWasteTransferConfidentialityAffected();
            alert = wtConf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;
        }
        else if (command.Equals(Sheets.IndustrialActivity.Confidentiality.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("AreaOverview", "AreaOverviewConfidential");
            this.ucAreaOverviewConfidentiality.Visible = true;
            bool conf = getAnyConfidentialityAffected();
            alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlert") : string.Empty;
            this.ucAreaOverviewConfidentiality.Populate(filter);
            
        }

        updateHeader(filter, txt);
        updateAlert(alert);

        // activate print
        this.ucDownloadPrint.Visible = true; 
        this.ucDownloadPrint.Show(false, true);
        this.ucDownloadPrint.SetPrintControl(this);
    }

    /// <summary>
    /// create header
    /// </summary>
    private void updateHeader(AreaOverviewSearchFilter filter, string text)
    {
        Dictionary<string, string> header = SheetHeaderBuilder.GetAreaOverviewSearchHeader(filter);
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
        this.ucAreaOverviewPollutantReleases.Visible = false;
        this.ucAreaOverviewPollutantTransfers.Visible = false;
        this.ucAreaOverviewWasteTransfer.Visible = false;
        this.ucAreaOverviewConfidentiality.Visible = false;
    }

    /// <summary>
    /// update the printable control
    /// </summary>
    private void contentChanged(object sender, EventArgs e)
    {
        this.ucDownloadPrint.SetPrintControl(this);
    }

   
}
