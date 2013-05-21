using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer.Filters;
using EPRTR.Localization;
using EPRTR.Enums;
using QueryLayer;
using EPRTR.HeaderBuilders;
using EPRTR.Utilities;
using EPRTR.CsvUtilities;
using StylingHelper;
using System.Globalization;

public partial class ucTsPollutantTransfersSheet : System.Web.UI.UserControl
{
    private const string FILTER = "tspollutanttransferfilter";
    private const string CONFAFFECTED = "tsconfidentialityaffected";
    private const string SHEETLEVEL = "tsSheetLevel";
    private const string SEARCHYEAR = "tsSearchYear";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
        }

        if (this.ucSheetLinks.Linkclick == null)
            this.ucSheetLinks.Linkclick = new EventHandler(linkClick);

        if (this.ucSheetSubHeader.AlertClick == null)
            this.ucSheetSubHeader.AlertClick = new EventHandler(alertClick);

        if (this.ucDownloadPrint.DoSave == null)
            this.ucDownloadPrint.DoSave = new EventHandler(doSave);
        this.ucDownloadPrint.Show(true, false);
    }


    protected PollutantTransferTimeSeriesFilter SearchFilter
    {
        get { return ViewState[FILTER] as PollutantTransferTimeSeriesFilter; }
        set { ViewState[FILTER] = value; }
    }
    protected bool ConfidentialityAffected
    {
        get { return (bool)ViewState[CONFAFFECTED]; }
        set { ViewState[CONFAFFECTED] = value; }
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
    public void Populate(PollutantTransferTimeSeriesFilter filter)
    {
        Populate(filter, null);
    }



    /// <summary>
    /// Populate charts. Selected year in compare dropdown will be searchyear
    /// </summary>
    public void Populate(PollutantTransferTimeSeriesFilter filter, int? searchYear)
    {
        SearchFilter = filter;
        SearchYear = searchYear;

        initializeContentLinks();

        //Only determine once and store in viewstate
        ConfidentialityAffected = PollutantTransferTrend.IsAffectedByConfidentiality(filter);
        // show timeseries as default
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
            this.litHeadline.Text = Resources.GetGlobal("Facility", "PollutantTransfersTimeSeries");
            this.ucTsPollutantTransfersSeries.Visible = true;
            this.ucTsPollutantTransfersSeries.Populate(SearchFilter);
            this.ucDownloadPrint.Show(true, false);
        }
        else if (command.Equals(Sheets.TimeSeries.Comparison.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "PollutantTransfersComparison");
            this.ucTsPollutantTransfersComparison.Visible = true;
            this.ucTsPollutantTransfersComparison.Populate(SearchFilter, SearchYear);
            this.ucDownloadPrint.Show(true, false);
        }
        else if (command.Equals(Sheets.TimeSeries.Confidentiality.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "PollutantTransfersConfidentiality");
            alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlert") : string.Empty;
            this.ucTsPollutantTransfersConfidentiality.Visible = true;
            this.ucTsPollutantTransfersConfidentiality.Populate(SearchFilter, conf);
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
        Dictionary<string, string> header = SheetHeaderBuilder.GetTimeSeriesPollutantTransferHeader(SearchFilter);
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
    /// hide all sheets
    /// </summary>
    private void hideSubControls()
    {
        this.ucTsPollutantTransfersSeries.Visible = false;
        this.ucTsPollutantTransfersComparison.Visible = false;
        this.ucTsPollutantTransfersConfidentiality.Visible = false;
    }

    /// <summary>
    /// Save transfers data
    /// </summary>
    protected void doSave(object sender, EventArgs e)
    {
        try
        {
            CultureInfo csvCulture = CultureResolver.ResolveCsvCulture(Request);
            CSVFormatter csvformat = new CSVFormatter(csvCulture);

            // Create Header
            var header = CsvHeaderBuilder.GetTsPollutantTransfersSearchHeader(SearchFilter, ConfidentialityAffected);

            var data = PollutantTransferTrend.GetTimeSeries(SearchFilter);

            var pollutant = ListOfValues.GetPollutant(SearchFilter.PollutantFilter.PollutantID);
            string pollutantName = LOVResources.PollutantName(pollutant.Code);

            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string rowheaders = csvformat.GetPollutantTransfersTimeSeriesHeader();

            Response.WriteUtf8FileHeader("EPRTR_Pollutant_Transfers_Time_Series");

            Response.Write(topheader + rowheaders);

            foreach (var v in data)
            {
                string row = csvformat.GetPollutantTransfersTimeSeriesRow(v, pollutantName);
                Response.Write(row);
            }
            Response.End();
        }
        catch
        {
        }
    }

}
