using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using EPRTR.Enums;
using EPRTR.HeaderBuilders;
using EPRTR.Localization;
using EPRTR.Utilities;
using EPRTR.CsvUtilities;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using StylingHelper;
using System.Globalization;

public partial class ucTsPollutantReleasesSheet : System.Web.UI.UserControl
{
    private const string FILTER = "tspollutantreleasesfilter";
    private const string CONFAFFECTED = "tsconfidentialityaffected";
    private string MEDIUM = "tsmediumreleasesheet";
    private const string SHEETLEVEL = "tsSheetLevel";
    private const string SEARCHYEAR = "tsSearchYear";
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
        }

        if (this.ucSheetLinks.Linkclick == null) this.ucSheetLinks.Linkclick = new EventHandler(linkClick);
        if (this.ucSheetSubHeader.AlertClick == null) this.ucSheetSubHeader.AlertClick = new EventHandler(alertClick);
        if (this.ucTsPollutantReleasesSeries.OnMediumChanged == null) this.ucTsPollutantReleasesSeries.OnMediumChanged = new EventHandler(onMediumChanged);
        if (this.ucTsPollutantReleasesComparison.OnMediumChanged == null) this.ucTsPollutantReleasesComparison.OnMediumChanged = new EventHandler(onMediumChanged);
        if (this.ucTsPollutantReleasesConfidentiality.OnMediumChanged == null) this.ucTsPollutantReleasesConfidentiality.OnMediumChanged = new EventHandler(onMediumChanged);

        if (this.ucDownloadPrint.DoSave == null)
            this.ucDownloadPrint.DoSave = new EventHandler(doSave);
        this.ucDownloadPrint.Show(true, false);
    }


    protected PollutantReleasesTimeSeriesFilter SearchFilter
    {
        get { return ViewState[FILTER] as PollutantReleasesTimeSeriesFilter; }
        set { ViewState[FILTER] = value; }
    }
    protected bool ConfidentialityAffected
    {
        get { return (bool)ViewState[CONFAFFECTED]; }
        set { ViewState[CONFAFFECTED] = value; }
    }
    protected MediumFilter.Medium CurrentMedium
    {
        get { return (ViewState[MEDIUM]!=null) ? (MediumFilter.Medium)ViewState[MEDIUM] : MediumFilter.Medium.WasteWater; }
        set { ViewState[MEDIUM] = value; }
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
    public void Populate(PollutantReleasesTimeSeriesFilter filter)
    {
        Populate(filter, null);
    }


    /// <summary>
    /// Populate charts. Selected year in compare dropdown will be searchyear
    /// </summary>
    public void Populate(PollutantReleasesTimeSeriesFilter filter, int? searchYear)
    {
        SearchFilter = filter;
        SearchYear = searchYear;
        initializeContentLinks();
        //Only determine once and store in viewstate
        ConfidentialityAffected = PollutantReleaseTrend.IsAffectedByConfidentiality(filter); 
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
            this.litHeadline.Text = Resources.GetGlobal("Facility", "PollutantReleaseTimeSeries");
            this.ucTsPollutantReleasesSeries.Visible = true;
            this.ucTsPollutantReleasesSeries.Populate(SearchFilter, CurrentMedium);
            this.ucDownloadPrint.Show(true, false);
        }
        else if (command.Equals(Sheets.TimeSeries.Comparison.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "PollutantReleaseComparison");
            this.ucTsPollutantReleasesComparison.Visible = true;
            this.ucTsPollutantReleasesComparison.Populate(SearchFilter, CurrentMedium, SearchYear);
            this.ucDownloadPrint.Show(true, false);
        }
        else if (command.Equals(Sheets.TimeSeries.Confidentiality.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "PollutantReleaseConfidentiality");
            alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlert") : string.Empty;
            this.ucTsPollutantReleasesConfidentiality.Visible = true;
            this.ucTsPollutantReleasesConfidentiality.Populate(SearchFilter, conf, CurrentMedium);
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
        Dictionary<string, string> header = SheetHeaderBuilder.GetTimeSeriesPollutantReleaseHeader(SearchFilter);
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
    protected void onMediumChanged(object sender, EventArgs e)
    {
        if (this.ucTsPollutantReleasesSeries.Visible)
            CurrentMedium = this.ucTsPollutantReleasesSeries.CurrentMedium;
        else if (this.ucTsPollutantReleasesComparison.Visible)
            CurrentMedium = this.ucTsPollutantReleasesComparison.CurrentMedium;
        else if (this.ucTsPollutantReleasesConfidentiality.Visible)
            CurrentMedium = this.ucTsPollutantReleasesConfidentiality.CurrentMedium;
    }


    

    /// <summary>
    /// hide all sheets
    /// </summary>
    private void hideSubControls()
    {
        this.ucTsPollutantReleasesSeries.Visible = false;
        this.ucTsPollutantReleasesComparison.Visible = false;
        this.ucTsPollutantReleasesConfidentiality.Visible = false;
    }


    /// <summary>
    /// Save release data
    /// </summary>
    protected void doSave(object sender, EventArgs e)
    {
        try
        {
            CultureInfo csvCulture = CultureResolver.ResolveCsvCulture(Request);
            CSVFormatter csvformat = new CSVFormatter(csvCulture);

            // Check if current medium is affected confidentiality claims
            bool confidentialityAffected = PollutantReleaseTrend.IsAffectedByConfidentiality(
                SearchFilter, 
                CurrentMedium);

            // Create Header
            var header = CsvHeaderBuilder.GetTsPollutantReleasesSearchHeader(SearchFilter,
                CurrentMedium,
                confidentialityAffected);

            var data = PollutantReleaseTrend.GetTimeSeries(SearchFilter, CurrentMedium);

            string mediumName = LOVResources.MediumName(EnumUtil.GetStringValue(CurrentMedium));
            var pollutant = ListOfValues.GetPollutant(SearchFilter.PollutantFilter.PollutantID);
            string pollutantName = LOVResources.PollutantName(pollutant.Code);
            
            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string rowheaders = csvformat.GetPollutantReleasesTimeSeriesHeader();

            Response.WriteUtf8FileHeader("EPRTR_Pollutant_Releases_Time_Series");

            Response.Write(topheader + rowheaders);

            foreach (var v in data)
            {
                string row = csvformat.GetPollutantReleasesTimeSeriesRow(v, pollutantName, mediumName);
                Response.Write(row);
            }
            Response.End();
        }
        catch
        {
        }
    }

}
