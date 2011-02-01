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
using QueryLayer.Filters;
using QueryLayer.Utilities;
using EPRTR.Charts;
using Utilities;
using Formatters;
using StylingHelper;
using System.Globalization;
using System.Web.UI.DataVisualization.Charting;


public partial class ucFacilityWasteTrendSheet : System.Web.UI.UserControl
{
    private const string CONTENT_TYPE = "wasteContenttype";
    private const string WASTE_TYPE = "wasteType";
    private const string SEARCH_YEAR = "wasteSearchyear";
    private const string FACILITY_BASIC = "wasteFacilityBasic";
    private const string FACILITY_SPECIAL = "wasteFacilitySpecial";
    private const string TIMESERIES_DATA = "timeseriesData";
        
    private enum TrendWasteContent
    {
        TimeSeries = 0,
        Comparison,
        Confidentiality
    }
    
    /// <summary>
    /// page load, init links
    /// </summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        this.ucSheetLinks.ResetContentLinks();
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "TimeSeries"), TrendWasteContent.TimeSeries.ToString());
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "Comparison"), TrendWasteContent.Comparison.ToString());
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "Confidentiality"), TrendWasteContent.Confidentiality.ToString());

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
        if (ViewState[CONTENT_TYPE] != null && FacilityBasic != null && ViewState[SEARCH_YEAR] != null)
        {
            createTrendSheet((TrendWasteContent)ViewState[CONTENT_TYPE],
                               FacilityBasic.FacilityID,
                               (WasteTypeFilter.Type)ViewState[WASTE_TYPE]);
        }
    }

    /// <summary>
    /// FacilityBasic
    /// </summary>
    private Facility.FacilityBasic FacilityBasic
    {
        get { return (Facility.FacilityBasic)ViewState[FACILITY_BASIC]; }
        set { ViewState[FACILITY_BASIC] = value; }
    }

    private WasteTypeFilter.Type WasteType
    {
        get { return (WasteTypeFilter.Type)ViewState[WASTE_TYPE]; }
        set { ViewState[WASTE_TYPE] = value; }
    }

    private int SearchYear
    {
        get { return (int)ViewState[SEARCH_YEAR]; }
        set { ViewState[SEARCH_YEAR] = value; }
    }

    /// <summary>
    /// Search, fill data into summery
    /// </summary>
    public void Populate(int facilityReportId, int searchYear, WasteTypeFilter.Type waste)
    {
        FacilityBasic = Facility.GetFacilityBasic(facilityReportId);
        ViewState[FACILITY_SPECIAL] = facilityReportId;
        WasteType = waste;
        SearchYear = searchYear;
        
        // reset viewstate data
        ViewState[TIMESERIES_DATA] = null;
        showContent(TrendWasteContent.TimeSeries.ToString());

        // set the year according to search. Waste does not inclucde EPER
        List<int> years = years = ListOfValues.ReportYears(false).ToList();
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

    /// <summary>
    /// Show content
    /// </summary>
    private void showContent(string command)
    {
        hideSubControls();

        this.ucSheetLinks.HighLight(command);
        string txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyTransfers");

        bool conf = WasteTransferTrend.IsAffectedByConfidentiality(FacilityBasic.FacilityID, WasteType);
        string alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;
        
        if (command.Equals(TrendWasteContent.TimeSeries.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "WasteTransfersTimeSeries");
            ViewState[CONTENT_TYPE] = TrendWasteContent.TimeSeries;
        }
        else if (command.Equals(TrendWasteContent.Comparison.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "WasteTransfersComparison");
            ViewState[CONTENT_TYPE] = TrendWasteContent.Comparison;
        }
        else if (command.Equals(TrendWasteContent.Confidentiality.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "WasteTransfersConfidentiality");
            ViewState[CONTENT_TYPE] = TrendWasteContent.Confidentiality;
            this.ucContentConfidentiality.Visible = true;
            this.ucContentConfidentiality.Populate(FacilityBasic.FacilityID, WasteType, conf);

            alert = String.Empty;
        }

        updateHeader(txt);
        updateAlert(alert);
    }

    /// <summary>
    /// Update header 
    /// </summary>
    private void updateHeader(string text)
    {
        Dictionary<string, string> header = SheetHeaderBuilder.GetFacilityDetailWasteTrendHeader(FacilityBasic, WasteType);
        this.ucSheetSubHeader.PopulateHeader(header);
        this.ucSheetSubHeader.Text = text;
    }
    
    /// <summary>
    /// Alert
    /// </summary>
    private void updateAlert(string alert)
    {
        this.ucSheetSubHeader.AlertText = alert;
        this.ucSheetSubHeader.AlertCommandArgument = TrendWasteContent.Confidentiality.ToString();
    }
    
    /// <summary>
    /// getTimeSeriesData
    /// </summary>
    private List<TimeSeriesClasses.WasteTransfer> getTimeSeriesData(int facilityid, WasteTypeFilter.Type wasteType)
    {
        List<TimeSeriesClasses.WasteTransfer> data = null;

        // look in viewstate first
        data = ViewState[TIMESERIES_DATA] as List<TimeSeriesClasses.WasteTransfer>;
        
        // if no data in viewstate or id has changed, query db
        if ((data == null || data.Count() == 0))
        {
            data = WasteTransferTrend.GetTimeSeries(facilityid, wasteType);
            ViewState[TIMESERIES_DATA] = data;
        }
        return data;
    }

    
    /// <summary>
    /// Create trend sheet
    /// </summary>
    private void createTrendSheet(TrendWasteContent type, int facilityid, WasteTypeFilter.Type waste)
    {
        this.ucStackColumnTime.Visible = false;
        this.ucStackColumnCompare.Visible = false;
        this.ucYearCompareSeries.Visible = false;
        this.compareTable.Visible = false;

        // Get time series data, used by all sub sheets
        List<TimeSeriesClasses.WasteTransfer> data = getTimeSeriesData(facilityid, waste);

        // Time series sheet
        if (type == TrendWasteContent.TimeSeries)
        {
            ViewState[CONTENT_TYPE] = TrendWasteContent.TimeSeries;
            if (data != null && data.Count > 0)
            {
                this.ucStackColumnTime.Visible = true;

                Color[] colors = new Color[] { Global.ColorWasteRecovery, Global.ColorWasteDisposal, Global.ColorWasteUnspec };
                ChartHatchStyle[] hatchStyles = new ChartHatchStyle[] { ChartHatchStyle.None, ChartHatchStyle.None, ChartHatchStyle.None };
                string[] legendTexts = new string[]{Resources.GetGlobal("Common", "TreatmentDisposal"),
                                                    Resources.GetGlobal("Common", "TreatmentRecovery"),
                                                    Resources.GetGlobal("Common", "TreatmentUnspecified")};


                // initialize chart
                this.ucStackColumnTime.Initialize(colors.Length, StackColumnType.TimeSeries, WasteTransferTrend.CODE_TNE, colors, hatchStyles, legendTexts);

                List<TimeSeriesUtils.BarData> bars = new List<TimeSeriesUtils.BarData>();

                // add data to chart            
                foreach (var v in data)
                {
                    string[] tip = new string[] { String.Format("{0}: {1}", Resources.GetGlobal("Common", "Year"), v.Year),
                                                  String.Format("{0}: {1}", Resources.GetGlobal("Common", "Total"), QuantityFormat.Format(v.QuantityTotal, v.QuantityUnit)),
                                                  String.Format("{0}: {1}", Resources.GetGlobal("Common", "Recovery"), QuantityFormat.Format(v.QuantityRecovery, v.QuantityUnit)),
                                                  String.Format("{0}: {1}", Resources.GetGlobal("Common", "Disposal"), QuantityFormat.Format(v.QuantityDisposal, v.QuantityUnit)),
                                                  String.Format("{0}: {1}", Resources.GetGlobal("Common", "Unspec"), QuantityFormat.Format(v.QuantityUnspec, v.QuantityUnit))};

                    TimeSeriesUtils.BarData cd = new TimeSeriesUtils.BarData
                    {
                        Year = v.Year,
                        Values = new double?[] { TimeSeriesUtils.RangeValue(v.QuantityRecovery), TimeSeriesUtils.RangeValue(v.QuantityDisposal), TimeSeriesUtils.RangeValue(v.QuantityUnspec) },
                        ToolTip = ToolTipFormatter.FormatLines(tip)
                    };
                    bars.Add(cd);

                }

                //waste was not reported in EPER - hence do not include EPER years.
                this.ucStackColumnTime.Add(TimeSeriesUtils.InsertMissingYearsTimeSeries(bars, false));
            }
        }

        // comparison
        if (type == TrendWasteContent.Comparison)
        {
            ViewState[CONTENT_TYPE] = TrendWasteContent.Comparison;

            if (data != null && data.Count > 0)
            {
                this.compareTable.Visible = true;

                // Create chart
                this.ucStackColumnCompare.Visible = true;
                Color[] colors = new Color[] { Global.ColorWasteRecovery, Global.ColorWasteDisposal, Global.ColorWasteUnspec};
                ChartHatchStyle[] hatchStyles = new ChartHatchStyle[] { ChartHatchStyle.None, ChartHatchStyle.None, ChartHatchStyle.None };

                string[] legendTexts = new string[]{Resources.GetGlobal("Common", "TreatmentDisposal"),
                                                    Resources.GetGlobal("Common", "TreatmentRecovery"),
                                                    Resources.GetGlobal("Common", "TreatmentUnspecified")};

                this.ucStackColumnCompare.Initialize(colors.Length, StackColumnType.Comparison, WasteTransferTrend.CODE_TNE, colors, hatchStyles, legendTexts);
                
                // init year combo boxes
                this.ucYearCompareSeries.Visible = true;
                int year1 = this.ucYearCompareSeries.Year1;
                int year2 = this.ucYearCompareSeries.Year2;
                // reset
                resetLabels();

                TimeSeriesClasses.WasteTransfer data1 = data.Where(d => d.Year == year1).DefaultIfEmpty(new TimeSeriesClasses.WasteTransfer(year1, waste)).Single();
                TimeSeriesClasses.WasteTransfer data2 = data.Where(d => d.Year == year2).DefaultIfEmpty(new TimeSeriesClasses.WasteTransfer(year2, waste)).Single();

                bool dataFound = data1 != null || data2 != null;


                if (dataFound)
                {
                    TimeSeriesUtils.BarData dataFrom = new TimeSeriesUtils.BarData { Year = year1 };
                    TimeSeriesUtils.BarData dataTo = new TimeSeriesUtils.BarData { Year = year2 };


                    if (data1 != null)
                    {
                        dataFrom.Values = new double?[] { data1.QuantityRecovery, data1.QuantityDisposal, data1.QuantityUnspec};
                    }

                    if (data2 != null)
                    {
                        dataTo.Values = new double?[] { data2.QuantityRecovery, data2.QuantityDisposal, data2.QuantityUnspec };
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
    private void updateTableLabels(TimeSeriesClasses.WasteTransfer data1, TimeSeriesClasses.WasteTransfer data2)
    {
        this.grdCompareDetails.Visible = true;

        List<CompareDetailElement> elements = new List<CompareDetailElement>();


        elements.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Total"),
                                      data1 != null ? QuantityFormat.Format(data1.QuantityTotal, data1.QuantityUnit) : String.Empty,
                                      data2 != null ? QuantityFormat.Format(data2.QuantityTotal, data2.QuantityUnit) : String.Empty));

        elements.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Recovery"),
                              data1 != null ? QuantityFormat.Format(data1.QuantityRecovery, data1.QuantityUnit) : String.Empty,
                              data2 != null ? QuantityFormat.Format(data2.QuantityRecovery, data2.QuantityUnit) : String.Empty));

        elements.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Disposal"),
                              data1 != null ? QuantityFormat.Format(data1.QuantityDisposal, data1.QuantityUnit) : String.Empty,
                              data2 != null ? QuantityFormat.Format(data2.QuantityDisposal, data2.QuantityUnit) : String.Empty));

        elements.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Unspecified"),
                      data1 != null ? QuantityFormat.Format(data1.QuantityUnspec, data1.QuantityUnit) : String.Empty,
                      data2 != null ? QuantityFormat.Format(data2.QuantityUnspec, data2.QuantityUnit) : String.Empty));

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
            int facilityReportId = (int)ViewState[FACILITY_SPECIAL];
            Dictionary<string, string> header = CsvHeaderBuilder.GetFacilityTrendHeader(facilityReportId, true);

            // Create Body
            List<TimeSeriesClasses.WasteTransfer> data = getTimeSeriesData(FacilityBasic.FacilityID, WasteType);
            
            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string pollutantHeader = csvformat.GetWasteTransferTrendHeader();

            Response.WriteUtf8FileHeader("EPRTR_Waste_Transfers_Time_Series");

            Response.Write(topheader + pollutantHeader);
            foreach (var v in data)
            {
                string row = csvformat.GetWasteTransferTrendRow(v);
                Response.Write(row);
            }
            Response.End();
        }
        catch { /*ignore all errors */ }
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
