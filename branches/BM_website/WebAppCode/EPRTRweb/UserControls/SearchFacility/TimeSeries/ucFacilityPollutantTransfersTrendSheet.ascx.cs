using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Formatters;
using EPRTR.HeaderBuilders;
using EPRTR.Localization;
using EPRTR.Utilities;
using EPRTR.CsvUtilities;
using QueryLayer;
using QueryLayer.Utilities;
using EPRTR.Charts;
using Utilities;
using Formatters;
using StylingHelper;
using System.Globalization;
using System.Web.UI.DataVisualization.Charting;
using QueryLayer.Filters;


public partial class ucFacilityPollutantTransfersTrendSheet : System.Web.UI.UserControl
{
    private const string POLLUTANTCODE = "transfertrendPollutantcode";
    private const string CONTENT_TYPE = "transfertrendContenttype";
    private const string SEARCH_YEAR = "transferstrendSearchYear";
    private const string TIMESERIES = "transfertrendTimeseries";
    private const string FACILITY_BASIC = "facilityBasic";

    private bool showEPER = false;

    public bool ShowEPER
    {
        get { return showEPER; }
        set { showEPER = value; }
    }

    private YearFilter Filter { get; set; }

    private enum TrendTransferContent
    {
        TimeSeries = 0,
        Comparison,
        Confidentiality
    }

    private string PollutantCode
    {
        get { return (string)ViewState[POLLUTANTCODE]; }
        set { ViewState[POLLUTANTCODE] = value; }
    }

    private int SearchYear
    {
        get { return (int)ViewState[SEARCH_YEAR]; }
        set { ViewState[SEARCH_YEAR] = value; }
    }

    private Facility.FacilityBasic FacilityBasic
    {
        get { return (Facility.FacilityBasic)ViewState[FACILITY_BASIC]; }
        set { ViewState[FACILITY_BASIC] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        this.ucSheetLinks.ResetContentLinks();
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Facility","PollutantContentTimeSeries"), TrendTransferContent.TimeSeries.ToString());
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Facility","PollutantContentComparison"), TrendTransferContent.Comparison.ToString());
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Facility","PollutantContentConfidentiality"), TrendTransferContent.Confidentiality.ToString());

        if (this.ucSheetLinks.Linkclick == null)
            this.ucSheetLinks.Linkclick = new EventHandler(linkClick);
        if (this.ucSheetSubHeader.AlertClick == null)
            this.ucSheetSubHeader.AlertClick = new EventHandler(alertClick);
        
        if (this.ucDownloadPrint.DoSave == null)
            this.ucDownloadPrint.DoSave = new EventHandler(doSave);
        this.ucDownloadPrint.Show(true, false);
    }


    /// <summary>
    /// create trend sheet if needed
    /// </summary>
    protected void Page_PreRender(object sender, EventArgs e)
    {
        if (ViewState[CONTENT_TYPE] != null 
            && FacilityBasic != null 
            && ViewState[POLLUTANTCODE] != null 
            && ViewState[SEARCH_YEAR] != null)
        {
            createTrendSheet((TrendTransferContent)ViewState[CONTENT_TYPE],
                                FacilityBasic.FacilityID,
                               (string)ViewState[POLLUTANTCODE]);
        }
    }


    /// <summary>
    /// Search, fill data into summery
    /// </summary>
    public void Populate(int facilityReportId, string pollutantCode, int searchYear)
    {
        FacilityBasic = Facility.GetFacilityBasic(facilityReportId);
        PollutantCode =  pollutantCode;
        SearchYear = searchYear;
        ViewState[TIMESERIES] = null;

        // first sheet is the time series sheet
        showContent(TrendTransferContent.TimeSeries.ToString());

        // set the year according to search. Include EPER
        List<int> years = ListOfValues.ReportYearsSeries().ToList();
        this.ucYearCompareSeries.Initialize(years, searchYear);
        
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

    protected void showContent(string command)
    {
        hideSubControls();

        this.ucSheetLinks.HighLight(command);
        string txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyTransfers");

        bool conf = PollutantTransferTrend.IsAffectedByConfidentiality(FacilityBasic.FacilityID, PollutantCode);
        string alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;
        
        if (command.Equals(TrendTransferContent.TimeSeries.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "PollutantTransfersTimeSeries");
            ViewState[CONTENT_TYPE] = TrendTransferContent.TimeSeries;
        }
        else if (command.Equals(TrendTransferContent.Comparison.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "PollutantTransfersComparison");
            ViewState[CONTENT_TYPE] = TrendTransferContent.Comparison;
        }
        else if (command.Equals(TrendTransferContent.Confidentiality.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "PollutantTransfersConfidentiality");
            this.ucContentConfidentiality.Visible = true;
            this.ucContentConfidentiality.Populate(FacilityBasic.FacilityID,PollutantCode);
            ViewState[CONTENT_TYPE] = TrendTransferContent.Confidentiality;
            alert = String.Empty;
        }

        updateHeader(txt);
        updateAlert(alert);
    }


    /// <summary>
    /// 
    /// </summary>
    private void updateHeader(string text)
    {
        Dictionary<string, string> header = SheetHeaderBuilder.GetFacilityDetailPollutantTrendHeader(FacilityBasic, ViewState[POLLUTANTCODE] as string);
        this.ucSheetSubHeader.PopulateHeader(header);
        this.ucSheetSubHeader.Text = text;
    }

    private void updateAlert(string alert)
    {
        this.ucSheetSubHeader.AlertText = alert;
        this.ucSheetSubHeader.AlertCommandArgument = TrendTransferContent.Confidentiality.ToString();
    }


    /// <summary>
    /// getTimeSeriesData
    /// </summary>
    private List<TimeSeriesClasses.PollutantTransfers> getTimeSeriesData(int facilityid, string pollutantCode)
    {
        // look in viewstate first
        List<TimeSeriesClasses.PollutantTransfers> data = ViewState[TIMESERIES] as List<TimeSeriesClasses.PollutantTransfers>;
        // if no data in viewstate or id has changed, query db
        if ((data == null || data.Count() == 0))
        {
            data = PollutantTransferTrend.GetTimeSeries(facilityid, pollutantCode);
            ViewState[TIMESERIES] = data;
        }
        return data;
    }

    /// <summary>
    /// Create trend sheet
    /// </summary>
    private void createTrendSheet(TrendTransferContent type, int facilityid, string pollutantCode)
    {
        this.ucStackColumnTime.Visible = false;
        this.ucStackColumnCompare.Visible = false;
        this.ucYearCompareSeries.Visible = false;
        this.compareTable.Visible = false;

        // Get time series data, used by all sub sheets
        List<TimeSeriesClasses.PollutantTransfers> data = getTimeSeriesData(facilityid, pollutantCode);

        // Time series sheet
        if (type == TrendTransferContent.TimeSeries)
        {
            ViewState[CONTENT_TYPE] = TrendTransferContent.TimeSeries;
            if (data != null && data.Count > 0)
            {
                this.ucStackColumnTime.Visible = true;

                Color[] colors = new Color[] { Global.ColorWasteWater };
                ChartHatchStyle[] hatchStyles = new ChartHatchStyle[] { ChartHatchStyle.None};

                this.ucStackColumnTime.Initialize(colors.Length, StackColumnType.TimeSeries, PollutantTransferTrend.CODE_KG, colors, hatchStyles, null);
                //this.ucStackColumnTime.Initialize(colors.Length, StackColumnType.TimeSeries, PollutantTransferTrend.CODE_TNE, colors, null);

                List<TimeSeriesUtils.BarData> bars = new List<TimeSeriesUtils.BarData>();
                
                foreach (var v in data)
                {
                    string[] tip = new string[] {String.Format("{0}: {1}", Resources.GetGlobal("Common", "Year"), v.Year),
                                                 String.Format("{0}: {1}", Resources.GetGlobal("Common", "Quantity"), QuantityFormat.Format(v.Quantity, v.QuantityUnit))};

                    TimeSeriesUtils.BarData cd = new TimeSeriesUtils.BarData
                    {
                        Year = v.Year,
                        Values = new double?[] { v.Quantity},
                        ToolTip = ToolTipFormatter.FormatLines(tip)
                    };
                    bars.Add(cd);
                
                }
                this.ucStackColumnTime.Add(TimeSeriesUtils.InsertMissingYears(bars, showEPER));
            }
        }

        // comparison
        if (type == TrendTransferContent.Comparison)
        {
            ViewState[CONTENT_TYPE] = TrendTransferContent.Comparison;
            if (data != null && data.Count > 0)
            {
                this.compareTable.Visible = true;

                // Create chart
                this.ucStackColumnCompare.Visible = true;

                Color[] colors = new Color[] { Global.ColorWasteWater};
                ChartHatchStyle[] hatchStyles = new ChartHatchStyle[] { ChartHatchStyle.None };
                this.ucStackColumnCompare.Initialize(colors.Length, StackColumnType.Comparison, PollutantTransferTrend.CODE_KG, colors, hatchStyles,  null);
                //this.ucStackColumnCompare.Initialize(colors.Length, StackColumnType.Comparison, PollutantTransferTrend.CODE_TNE, colors, null);

                // init year combo boxes
                this.ucYearCompareSeries.Visible = true;
                int year1 = this.ucYearCompareSeries.Year1;
                int year2 = this.ucYearCompareSeries.Year2;
                // reset
                resetLabels();

                TimeSeriesClasses.PollutantTransfers data1 = data.Where(d => d.Year == year1).DefaultIfEmpty(new TimeSeriesClasses.PollutantTransfers(year1)).Single();
                TimeSeriesClasses.PollutantTransfers data2 = data.Where(d => d.Year == year2).DefaultIfEmpty(new TimeSeriesClasses.PollutantTransfers(year2)).Single();

                bool dataFound = data1 != null || data2 != null;


                if (dataFound)
                {
                    TimeSeriesUtils.BarData dataFrom = new TimeSeriesUtils.BarData { Year = year1 };
                    TimeSeriesUtils.BarData dataTo = new TimeSeriesUtils.BarData { Year = year2 }; 

                    if (data1 != null)
                    {
                        dataFrom.Values = new double?[] { data1.Quantity};
                    }

                    if (data2 != null)
                    {
                        dataTo.Values = new double?[] { data2.Quantity};
                    }

                    // from and to bar
                    this.ucStackColumnCompare.Add(new List<TimeSeriesUtils.BarData>() { dataFrom, dataTo });
                    updateTableLabels(data1, data2);
                }

                // display that no data found for the selected years
                this.lbNoDataForSelectedYears.Visible = !dataFound;
            }
        }

    }

    /// <summary>
    /// Hide
    /// </summary>
    private void hideSubControls()
    {
        this.ucContentConfidentiality.Visible = false;
    }

    /// <summary>
    /// Label update
    /// </summary>
    private void updateTableLabels(TimeSeriesClasses.PollutantTransfers data1, TimeSeriesClasses.PollutantTransfers data2)
    {
        this.grdCompareDetails.Visible = true;

        List<CompareDetailElement> elements = new List<CompareDetailElement>();

        elements.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Quantity"),
                                      data1 != null ? QuantityFormat.Format(data1.Quantity, data1.QuantityUnit) : String.Empty,
                                      data2 != null ? QuantityFormat.Format(data2.Quantity, data2.QuantityUnit) : String.Empty));


        // data binding 
        this.grdCompareDetails.DataSource = elements;
        grdCompareDetails.DataBind();

    }

    /// <summary>
    /// reset labels
    /// </summary>
    private void resetLabels()
    {
        this.grdCompareDetails.Visible = false;
        this.lbNoDataForSelectedYears.Visible = false;
    }
    
    /// <summary>
    /// Save
    /// </summary>
    protected void doSave(object sender, EventArgs e)
    {
        try
        {
            CultureInfo csvCulture = CultureResolver.ResolveCsvCulture(Request);
            CSVFormatter csvformat = new CSVFormatter(csvCulture);

            // Create Header
            bool confidentialityAffected = PollutantTransferTrend.IsAffectedByConfidentiality(FacilityBasic.FacilityID, PollutantCode);
            Dictionary<string, string> header = CsvHeaderBuilder.GetFacilityTrendHeader(FacilityBasic.FacilityReportId, true);

            // Create Body
            string pollutantName = LOVResources.PollutantName(PollutantCode);
            List<TimeSeriesClasses.PollutantTransfers> data = getTimeSeriesData(FacilityBasic.FacilityID, PollutantCode);

            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string pollutantHeader = csvformat.GetPollutantTransfersTrendHeader();

            Response.WriteUtf8FileHeader("EPRTR_Pollutant_Transfers_Time_Series");

            Response.Write(topheader + pollutantHeader);
            foreach (var v in data)
            {
                string row = csvformat.GetPollutantTransfersTrendRow(v, pollutantName);
                Response.Write(row);
            }
            Response.End();
        }
        catch
        {
        }
    }

    protected void grdCompareDetails_OnDataBound(object obj, EventArgs e)
    {
        GridViewRow headerRow = this.grdCompareDetails.HeaderRow;

        if (headerRow != null)
        {
            headerRow.Cells[1].Text = this.ucYearCompareSeries.Year1.ToString();
            headerRow.Cells[2].Text = this.ucYearCompareSeries.Year2.ToString();

            headerRow.Cells[0].CssClass = "CompColLabel";
            headerRow.Cells[1].CssClass = "CompColData";
            headerRow.Cells[2].CssClass = "CompColData";
        }
    }


}
