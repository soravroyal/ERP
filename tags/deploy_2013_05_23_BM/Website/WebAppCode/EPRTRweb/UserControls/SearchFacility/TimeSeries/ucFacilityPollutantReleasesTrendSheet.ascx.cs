using System;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using EPRTR.Formatters;
using EPRTR.HeaderBuilders;
using EPRTR.Localization;
using EPRTR.CsvUtilities;
using EPRTR.Utilities;
using Formatters;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using StylingHelper;
using Utilities;
using System.Web.UI.DataVisualization.Charting;


public partial class ucFacilityPollutantReleasesTrendSheet : System.Web.UI.UserControl
{
    private const string POLLUTANTCODE = "releasetrendPollutantcode";
    private const string CONTENT_TYPE = "releasetrendContenttype";
    private const string MEDIUM = "releasetrendMedium";
    private const string SEARCH_YEAR = "releasetrendSearchyear";
    private const string FACILITY_BASIC = "facilityBasic";
    private const string FACILITY_REPORTID = "facilityReportId";
    private const string TIMESERIES_AIR = "releasetrendTimeseriesAir";
    private const string TIMESERIES_WATER = "releasetrendTimeseriesWater";
    private const string TIMESERIES_SOIL = "releasetrendTimeseriesSoil";


    private bool showEPER = false;

    public bool ShowEPER
    {
        get { return showEPER; }
        set { showEPER = value; }
    }

    private YearFilter Filter { get; set; }

        
    private enum TrendReleaseContent
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
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Facility", "PollutantContentTimeSeries"), TrendReleaseContent.TimeSeries.ToString());
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Facility", "PollutantContentComparison"), TrendReleaseContent.Comparison.ToString());
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Facility", "PollutantContentConfidentiality"), TrendReleaseContent.Confidentiality.ToString());

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
        if (ViewState[CONTENT_TYPE] != null && FacilityBasic != null && PollutantCode != null && ViewState[SEARCH_YEAR] != null)
        {
            createTrendSheet((TrendReleaseContent)ViewState[CONTENT_TYPE],
                               FacilityBasic.FacilityID,
                               (MediumFilter.Medium)ViewState[MEDIUM]);
        }
    }


    private Facility.FacilityBasic FacilityBasic
    {
        get { return (Facility.FacilityBasic)ViewState[FACILITY_BASIC]; }
        set { ViewState[FACILITY_BASIC] = value; }
    }

    public string PollutantCode {
        get { return (string)ViewState[POLLUTANTCODE]; }
        set { ViewState[POLLUTANTCODE] = value; }
    }

    public MediumFilter.Medium CurrentMedium
    {
        get { return (MediumFilter.Medium)ViewState[MEDIUM]; }
        set { ViewState[MEDIUM] = value; }
    }

    /// <summary>
    /// Search, fill data into summery
    /// </summary>
    public void Populate(int facilityReportId, int searchYear, string pollutantCode, MediumFilter.Medium medium)
    {
        FacilityBasic = Facility.GetFacilityBasic(facilityReportId);
        PollutantCode = pollutantCode;

        ViewState[FACILITY_REPORTID] = facilityReportId;
        CurrentMedium = medium;
        ViewState[SEARCH_YEAR] = searchYear;
        
        // reset viewstate data
        ViewState[TIMESERIES_AIR] = null;
        ViewState[TIMESERIES_WATER] = null;
        ViewState[TIMESERIES_SOIL] = null;
                
        showContent(TrendReleaseContent.TimeSeries.ToString());

        // set the year according to search. Include EPER

        List<int> years = ListOfValues.ReportYearsSeries().ToList();

        if (medium == MediumFilter.Medium.Soil)
        {
            years = ListOfValues.ReportYears(showEPER).ToList();
        }
      
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

    private void showContent(string command)
    {
        hideSubControls();
        
        this.ucSheetLinks.HighLight(command);
        string txt = Resources.GetGlobal("Pollutant","AllValuesAreYearlyReleases");

        bool conf = PollutantReleaseTrend.IsAffectedByConfidentiality(FacilityBasic.FacilityID, PollutantCode, CurrentMedium);

        string alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;
        
        if (command.Equals(TrendReleaseContent.TimeSeries.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "PollutantReleaseTimeSeries");
            ViewState[CONTENT_TYPE] = TrendReleaseContent.TimeSeries;
        }
        else if (command.Equals(TrendReleaseContent.Comparison.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "PollutantReleaseComparison");
            ViewState[CONTENT_TYPE] = TrendReleaseContent.Comparison;
        }
        else if (command.Equals(TrendReleaseContent.Confidentiality.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "PollutantReleaseConfidentiality");
            this.ucContentConfidentiality.Visible = true;
            this.ucContentConfidentiality.Populate(FacilityBasic.FacilityID, PollutantCode, CurrentMedium);
            
            ViewState[CONTENT_TYPE] = TrendReleaseContent.Confidentiality;
            alert = string.Empty;
        }

        updateHeader(txt);
        updateAlert(alert);

    }

    private void updateHeader(string text)
    {
        Dictionary<string, string> header = SheetHeaderBuilder.GetFacilityDetailPollutantTrendHeader(FacilityBasic, PollutantCode /* ViewState[POLLUTANTCODE] as string*/);
        this.ucSheetSubHeader.PopulateHeader(header);
        this.ucSheetSubHeader.Text = text;
    }

    private void updateAlert(string alert)
    {
        this.ucSheetSubHeader.AlertText = alert;
        this.ucSheetSubHeader.AlertCommandArgument = TrendReleaseContent.Confidentiality.ToString();
    }


    /// <summary>
    /// getTimeSeriesData
    /// </summary>
    private List<TimeSeriesClasses.PollutantReleases> getTimeSeriesData(int facilityid, MediumFilter.Medium medium)
    {
        List<TimeSeriesClasses.PollutantReleases> data = null;

        // look in viewstate first
        if (medium == MediumFilter.Medium.Air) data = ViewState[TIMESERIES_AIR] as List<TimeSeriesClasses.PollutantReleases>;
        else if (medium == MediumFilter.Medium.Water) data = ViewState[TIMESERIES_WATER] as List<TimeSeriesClasses.PollutantReleases>;
        else if (medium == MediumFilter.Medium.Soil) data = ViewState[TIMESERIES_SOIL] as List<TimeSeriesClasses.PollutantReleases>;
        
        // if no data in viewstate or id has changed, query db
        if ((data == null || data.Count() == 0))
        {
            data = PollutantReleaseTrend.GetTimeSeries(facilityid, PollutantCode, medium);
            if (medium == MediumFilter.Medium.Air) ViewState[TIMESERIES_AIR] = data;
            else if (medium == MediumFilter.Medium.Water) ViewState[TIMESERIES_WATER] = data;
            else if (medium == MediumFilter.Medium.Soil) ViewState[TIMESERIES_SOIL] = data;
        }
        return data;
    }

    
    /// <summary>
    /// Create trend sheet
    /// </summary>
    private void createTrendSheet(TrendReleaseContent type, int facilityid, MediumFilter.Medium medium)
    {
        this.ucStackColumnTime.Visible = false;
        this.ucStackColumnCompare.Visible = false;
        this.ucYearCompareSeries.Visible = false;
        this.compareTable.Visible = false;

        // Get time series data, used by all sub sheets
        List<TimeSeriesClasses.PollutantReleases> data = getTimeSeriesData(facilityid, medium);

        // Time series sheet
        if (type == TrendReleaseContent.TimeSeries)
        {
            ViewState[CONTENT_TYPE] = TrendReleaseContent.TimeSeries;
            if (data != null && data.Count > 0)
            {
                this.ucStackColumnTime.Visible = true;

                // initialize chart

                Color[] colors = getColors(medium);
                string[] labelTexts = new string[] { Resources.GetGlobal("Common", "Accidental"), Resources.GetGlobal("Common", "Controlled") };
                ChartHatchStyle[] hatchStyles = new ChartHatchStyle[] { ChartHatchStyle.None, ChartHatchStyle.None };
                this.ucStackColumnTime.Initialize(colors.Length, StackColumnType.TimeSeries, PollutantReleaseTrend.CODE_KG, colors, hatchStyles, labelTexts);

                List<TimeSeriesUtils.BarData> bars = new List<TimeSeriesUtils.BarData>();

                foreach (var v in data)
                {
                    string[] tip = new string[] {String.Format("{0}: {1}", Resources.GetGlobal("Common", "Year"), v.Year),
                                                 String.Format("{0}: {1}", Resources.GetGlobal("Pollutant", "ReleasesTotal"), QuantityFormat.Format(v.Quantity, v.QuantityUnit)),
                                                 String.Format("{0}: {1}", Resources.GetGlobal("Pollutant", "ReleasesAccidentalReleases"), QuantityFormat.Format(v.QuantityAccidental, v.QuantityAccidentalUnit)),
                                                (v.AccidentalPercent > 0.0) ? String.Format("{0}: {1:F5}%", Resources.GetGlobal("Pollutant", "ReleasesAccidentalPercentValue"), v.AccidentalPercent) : String.Format("{0}: 0%", Resources.GetGlobal("Pollutant", "ReleasesAccidentalPercentValue"))};


                    TimeSeriesUtils.BarData cd = new TimeSeriesUtils.BarData
                    {
                        Year = v.Year,
                        Values = new double?[] { TimeSeriesUtils.RangeValue(v.QuantityAccidental), TimeSeriesUtils.RangeValue(v.Quantity) - TimeSeriesUtils.RangeValue(v.QuantityAccidental) },
                        ToolTip = ToolTipFormatter.FormatLines(tip)
                    };
                    bars.Add(cd);

                }

                 if ((medium == MediumFilter.Medium.Air) || (medium == MediumFilter.Medium.Water)){
                        this.ucStackColumnTime.Add(TimeSeriesUtils.InsertMissingYears(bars, showEPER));
                 }       
                 if (medium == MediumFilter.Medium.Soil){
                     this.ucStackColumnTime.Add(TimeSeriesUtils.InsertMissingYearsTimeSeries(bars, showEPER));
                }


                
            }
        }

        // comparison
        if (type == TrendReleaseContent.Comparison)
        {
            ViewState[CONTENT_TYPE] = TrendReleaseContent.Comparison;

            if (data != null && data.Count > 0)
            {
                this.compareTable.Visible = true;

                // Create chart
                this.ucStackColumnCompare.Visible = true;

                Color[] colors = getColors(medium);
                ChartHatchStyle[] hatchStyles = new ChartHatchStyle[] { ChartHatchStyle.None, ChartHatchStyle.None};
                string[] labelTexts = new string[] { Resources.GetGlobal("Common", "Accidental"), Resources.GetGlobal("Common", "Controlled") };

                this.ucStackColumnCompare.Initialize(colors.Length, StackColumnType.Comparison, PollutantReleaseTrend.CODE_KG, colors, hatchStyles, labelTexts);
                //this.ucStackColumnCompare.Initialize(colors.Length, StackColumnType.Comparison, PollutantReleaseTrend.CODE_TNE, colors, labelTexts);
                
                // init year combo boxes
                this.ucYearCompareSeries.Visible = true;
                int year1 = this.ucYearCompareSeries.Year1;
                int year2 = this.ucYearCompareSeries.Year2;
                // reset
                resetLabels();

                TimeSeriesClasses.PollutantReleases data1 = data.Where(d => d.Year == year1).DefaultIfEmpty(new TimeSeriesClasses.PollutantReleases(year1)).Single();
                TimeSeriesClasses.PollutantReleases data2 = data.Where(d => d.Year == year2).DefaultIfEmpty(new TimeSeriesClasses.PollutantReleases(year2)).Single();

                bool dataFound = data1 != null || data2 != null;


                if (dataFound)
                {
                    TimeSeriesUtils.BarData dataFrom = new TimeSeriesUtils.BarData { Year = year1 };
                    TimeSeriesUtils.BarData dataTo = new TimeSeriesUtils.BarData { Year = year2 }; 

                    if (data1 != null)
                    {
                        dataFrom.Values = new double?[] { data1.QuantityAccidental, data1.Quantity - data1.QuantityAccidental };
                    }

                    if (data2 != null)
                    {
                        dataTo.Values = new double?[] { data2.QuantityAccidental, data2.Quantity - data2.QuantityAccidental };
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

    private Color[] getColors(MediumFilter.Medium medium)
    {
        Color[] colors = null;

        switch (medium)
        {
            case MediumFilter.Medium.Air:
                colors = new Color[] { Global.ColorAirAccidental, Global.ColorAirTotal };
                break;
            case MediumFilter.Medium.Soil:
                colors = new Color[] { Global.ColorSoilAccidental, Global.ColorSoilTotal };
                break;
            case MediumFilter.Medium.Water:
                colors = new Color[] { Global.ColorWaterAccidental, Global.ColorWaterTotal };
                break;
        }

        return colors;
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
    private void updateTableLabels(TimeSeriesClasses.PollutantReleases data1, TimeSeriesClasses.PollutantReleases data2)
    {
        this.grdCompareDetails.Visible = true;

        List<CompareDetailElement> elements = new List<CompareDetailElement>();

        elements.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Total"),
                                      data1 != null ? QuantityFormat.Format(data1.Quantity, data1.QuantityUnit) : String.Empty,
                                      data2 != null ? QuantityFormat.Format(data2.Quantity, data2.QuantityUnit) : String.Empty));

        elements.Add(new CompareDetailElement(Resources.GetGlobal("Pollutant", "AccidentalQuantity"),
                              data1 != null ? QuantityFormat.Format(data1.QuantityAccidental, data1.QuantityAccidentalUnit) : String.Empty,
                              data2 != null ? QuantityFormat.Format(data2.QuantityAccidental, data2.QuantityAccidentalUnit) : String.Empty));

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
            int facilityReportId = (int)ViewState[FACILITY_REPORTID];
            string pollutantCode = PollutantCode;
            
            bool confidentialityAffected = PollutantReleaseTrend.IsAffectedByConfidentiality(FacilityBasic.FacilityID, PollutantCode, CurrentMedium);
            Dictionary<string, string> header = CsvHeaderBuilder.GetFacilityTrendHeader(facilityReportId, confidentialityAffected);

            // Create Body
            string mediumName = LOVResources.MediumName(EnumUtil.GetStringValue(CurrentMedium));
            string pollutantName = LOVResources.PollutantName(pollutantCode);
            List<TimeSeriesClasses.PollutantReleases> data = getTimeSeriesData(FacilityBasic.FacilityID, CurrentMedium);
                        
            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string pollutantHeader = csvformat.GetPollutantReleaseTrendHeader();

            Response.WriteUtf8FileHeader("EPRTR_Pollutant_Releases_Time_Series");

            Response.Write(topheader + pollutantHeader);
            
            foreach (var v in data)
            {
                string row = csvformat.GetPollutantReleaseTrendRow(v, pollutantName, mediumName);
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
