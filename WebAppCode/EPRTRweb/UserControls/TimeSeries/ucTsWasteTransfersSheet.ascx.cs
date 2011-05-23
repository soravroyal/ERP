using System;
using QueryLayer.Filters;
using EPRTR.Localization;
using EPRTR.Enums;
using QueryLayer;
using EPRTR.HeaderBuilders;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using EPRTR.Utilities;
using EPRTR.CsvUtilities;
using StylingHelper;
using System.Globalization;

public partial class ucTsWasteTransfersSheet : System.Web.UI.UserControl
{
    private const string FILTER = "tspollutanttransferfilter";
    private const string CONFAFFECTED = "tsconfidentialityaffected";
    private const string WASTETYPE = "tswastetype";
    private const string SHEETLEVEL = "tsSheetLevel";
    private const string SEARCHYEAR = "tsSearchYear";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (this.ucSheetLinks.Linkclick == null) this.ucSheetLinks.Linkclick = new EventHandler(linkClick);
        if (this.ucSheetSubHeader.AlertClick == null) this.ucSheetSubHeader.AlertClick = new EventHandler(alertClick);
        if (this.ucTsWasteTransfersSeries.OnWasteChange == null) this.ucTsWasteTransfersSeries.OnWasteChange = new EventHandler(wasteChange);
        if (this.ucTsWasteTransfersComparison.OnWasteChange == null) this.ucTsWasteTransfersComparison.OnWasteChange = new EventHandler(wasteChange);
        if (this.ucTsWasteTransfersConfidentiality.OnWasteChange == null) this.ucTsWasteTransfersConfidentiality.OnWasteChange = new EventHandler(wasteChange);

        if (this.ucDownloadPrint.DoSave == null)
        {
            this.ucDownloadPrint.DoSave = new EventHandler(doSave);
        }

        this.ucDownloadPrint.Show(true, false);
    }


    /// <summary>
    /// prop
    /// </summary>
    protected WasteTransferTimeSeriesFilter SearchFilter
    {
        get { return ViewState[FILTER] as WasteTransferTimeSeriesFilter; }
        set { ViewState[FILTER] = value; }
    }
    protected bool ConfidentialityAffected
    {
        get { return (bool)ViewState[CONFAFFECTED]; }
        set { ViewState[CONFAFFECTED] = value; }
    }
    private WasteTypeFilter.Type CurrentWasteType
    {
        get { return (ViewState[WASTETYPE] != null) ? (WasteTypeFilter.Type)ViewState[WASTETYPE] : WasteTypeFilter.Type.NonHazardous; }
        set { ViewState[WASTETYPE] = value; }
    }
    public int? SheetLevel
    {
        get { return (int?)ViewState[SHEETLEVEL]; }
        set { 
            ViewState[SHEETLEVEL] = value; 
            initializeCss();
        }
    }
    private int? SearchYear
    {
        get { return (int?)ViewState[SEARCHYEAR]; }
        set
        {
            ViewState[SEARCHYEAR] = value;
        }
    }


    /// <summary>
    /// populate. Selected year in compare dropdown will be the last report year
    /// </summary>
    public void Populate(WasteTransferTimeSeriesFilter filter)
    {
        Populate(filter, null);
    }


    /// <summary>
    /// Populate charts. Selected year in compare dropdown will be searchyear
    /// </summary>
    public void Populate(WasteTransferTimeSeriesFilter filter, int? searchYear)
    {
        SearchFilter = filter;
        SearchYear = searchYear;
        initializeContentLinks();

        //Only determine once and store in viewstate
        ConfidentialityAffected = WasteTransferTrend.IsAffectedByConfidentiality(filter);
        
        // Show timeseries as default
        showContent(Sheets.TimeSeries.TimeSeries.ToString());
    }

    private void initializeCss()
    {
        int? sheetLevel = SheetLevel;
        this.divSheet.Attributes["class"] = CssBuilder.SheetCss(sheetLevel);
    }


    private void initializeContentLinks()
    {
        this.ucSheetLinks.ResetContentLinks();
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "TimeSeries"), Sheets.TimeSeries.TimeSeries.ToString());
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "Comparison"), Sheets.TimeSeries.Comparison.ToString());
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "Confidentiality"), Sheets.TimeSeries.Confidentiality.ToString());
    }


    /// <summary>
    /// show content
    /// </summary>
    private void showContent(string command)
    {
        hideSubControls();
        
        this.ucDownloadPrint.Visible = true;
        
        // highlight current link
        this.ucSheetLinks.HighLight(command);

        bool conf = ConfidentialityAffected;
        string alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;

        if (command.Equals(Sheets.TimeSeries.TimeSeries.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "WasteTransfersTimeSeries");
            this.ucTsWasteTransfersSeries.Visible = true;
            this.ucTsWasteTransfersSeries.Populate(SearchFilter, CurrentWasteType);
            this.ucDownloadPrint.Show(true, false);
        }
        else if (command.Equals(Sheets.TimeSeries.Comparison.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "WasteTransfersComparison");
            this.ucTsWasteTransfersComparison.Visible = true;
            this.ucTsWasteTransfersComparison.Populate(SearchFilter, CurrentWasteType, SearchYear);
            this.ucDownloadPrint.Show(true, false);
        }
        else if (command.Equals(Sheets.TimeSeries.Confidentiality.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "WasteTransfersConfidentiality");
            alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlert") : string.Empty;
            this.ucTsWasteTransfersConfidentiality.Visible = true;
            this.ucTsWasteTransfersConfidentiality.Populate(SearchFilter, conf, CurrentWasteType);
            this.ucDownloadPrint.Show(false, false);
        }

        updateHeader();
        updateAlert(alert);
    }

    /// <summary>
    /// update header
    /// </summary>
    private void updateHeader()
    {
        Dictionary<string, string> header = SheetHeaderBuilder.GetTimeSeriesWasteTransferHeader(SearchFilter);
        this.ucSheetSubHeader.PopulateHeader(header);
        this.ucSheetSubHeader.Text = String.Empty;
    }

    /// <summary>
    /// update alert
    /// </summary>
    private void updateAlert(string alert)
    {
        this.ucSheetSubHeader.AlertText = alert;
        this.ucSheetSubHeader.AlertCommandArgument = Sheets.TimeSeries.Confidentiality.ToString();
    }

    /// <summary>
    /// Content link clicked
    /// </summary>
    protected void linkClick(object sender, EventArgs e)
    {
        LinkButton button = sender as LinkButton;
        if (button != null)
            showContent(button.CommandArgument);
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
    /// alert link clicked
    /// </summary>
    protected void wasteChange(object sender, EventArgs e)
    {
        if (this.ucTsWasteTransfersSeries.Visible)
            CurrentWasteType = this.ucTsWasteTransfersSeries.CurrentWasteType;
        else if (this.ucTsWasteTransfersComparison.Visible)
            CurrentWasteType = this.ucTsWasteTransfersComparison.CurrentWasteType;
        else if (this.ucTsWasteTransfersConfidentiality.Visible)
            CurrentWasteType = this.ucTsWasteTransfersConfidentiality.CurrentWasteType;
    }
           

    /// <summary>
    /// hide all sheets
    /// </summary>
    private void hideSubControls()
    {
        this.ucTsWasteTransfersSeries.Visible = false;
        this.ucTsWasteTransfersComparison.Visible = false;
        this.ucTsWasteTransfersConfidentiality.Visible = false;
    }

    /// <summary>
    /// Save waste transfers data
    /// </summary>
    protected void doSave(object sender, EventArgs e)
    {
        try
        {
            CultureInfo csvCulture = CultureResolver.ResolveCsvCulture(Request);
            CSVFormatter csvformat = new CSVFormatter(csvCulture);

            // TODO: Consider moving this value to ViewState
            bool isCurrentWasteTypeAffectedByConfidentiality = WasteTransferTrend.IsAffectedByConfidentiality(SearchFilter, CurrentWasteType);

            // Create Header
            var header = CsvHeaderBuilder.GetTsWasteTransfersSearchHeader(
                SearchFilter, 
                CurrentWasteType, 
                isCurrentWasteTypeAffectedByConfidentiality);

            var data = WasteTransferTrend.GetTimeSeries(SearchFilter, CurrentWasteType);

            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string rowheaders = csvformat.GetWasteTransfersTimeSeriesHeader();

            Response.WriteUtf8FileHeader("EPRTR_Waste_Transfers_Time_Series");

            Response.Write(topheader + rowheaders);

            foreach (var v in data)
            {
                string row = csvformat.GetWasteTransfersTimeSeriesRow(v);
                Response.Write(row);
            }
            Response.End();
        }
        catch
        {
        }
    }
}
