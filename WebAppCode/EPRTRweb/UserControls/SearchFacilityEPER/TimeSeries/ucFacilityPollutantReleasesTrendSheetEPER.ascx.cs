
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


public partial class ucFacilityPollutantReleasesTrendSheetEPER : System.Web.UI.UserControl
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

    private bool showEPER = true;

    public bool ShowEPER
    {
        get { return showEPER; }
        set { showEPER = value; }
    }

    private YearFilter Filter { get; set; }
        
    private enum TrendReleaseContent
    {
        Comparison,
        TimeSeries = 0,
        Confidentiality
    }
    
    /// <summary>
    /// page load, init links
    /// </summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        this.ucSheetLinks.ResetContentLinks();
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Facility", "PollutantContentTimeSeries"), TrendReleaseContent.Comparison.ToString());
     

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
      
                
        showContent(TrendReleaseContent.TimeSeries.ToString());

        // set the year according to search. Include EPER
        List<int> years = ListOfValues.ReportYears(showEPER).ToList();
        this.ucYearCompareEPER.Initialize(years, searchYear);
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
     
        
        this.ucSheetLinks.HighLight(command);
        string txt = Resources.GetGlobal("Pollutant","AllValuesAreYearlyTransferEPER");

        bool conf = PollutantReleaseTrend.IsAffectedByConfidentiality(FacilityBasic.FacilityID, PollutantCode, CurrentMedium);

        string alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;
        
       if (command.Equals(TrendReleaseContent.Comparison.ToString()))
        {
           
            this.litHeadline.Text = Resources.GetGlobal("Facility", "EmissionReleaseTimeSeries");
            ViewState[CONTENT_TYPE] = TrendReleaseContent.Comparison;
        }

        updateHeader(txt);
        updateAlert(alert);

    }

    private void updateHeader(string text)
    {
        string PollutantCodeEPER = PollutantCode + "EPER";
        Dictionary<string, string> header = SheetHeaderBuilder.GetFacilityDetailPollutantTrendHeaderEPER(FacilityBasic, PollutantCodeEPER, PollutantCode /* ViewState[POLLUTANTCODE] as string*/);
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
        
       
        if ((data == null || data.Count() == 0))
        {
            data = PollutantReleaseTrend.GetTimeSeries(facilityid, PollutantCode, medium);
            if (medium == MediumFilter.Medium.Air) ViewState[TIMESERIES_AIR] = data;
            else if (medium == MediumFilter.Medium.Water) ViewState[TIMESERIES_WATER] = data;
         
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
        this.ucYearCompareEPER.Visible = false;
        this.compareTable.Visible = false;

        // Get time series data, used by all sub sheets
        List<TimeSeriesClasses.PollutantReleases> data = getTimeSeriesData(facilityid, medium);

      

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
                string[] labelTexts = new string[] { "", Resources.GetGlobal("Common", "ControlledEPER") }; //, Resources.GetGlobal("Common", "Accidental") };
                
                // init year combo boxes
               // this.ucYearCompareEPER.Visible = true;
                int year1 = this.ucYearCompareEPER.Year1;
                int year2 = this.ucYearCompareEPER.Year2;
                // reset
                resetLabels();

                TimeSeriesClasses.PollutantReleases data1 = data.Where(d => d.Year == year1).DefaultIfEmpty(new TimeSeriesClasses.PollutantReleases(year1)).Single();
                TimeSeriesClasses.PollutantReleases data2 = data.Where(d => d.Year == year2).DefaultIfEmpty(new TimeSeriesClasses.PollutantReleases(year2)).Single();

                bool dataFound = data1 != null || data2 != null;

                if (data1.Quantity >= 100000)
                {
                    this.ucStackColumnCompare.Initialize(colors.Length, StackColumnTypeEPER.Comparison, "TNE", colors, labelTexts);
                }
                else
                {
                    this.ucStackColumnCompare.Initialize(colors.Length, StackColumnTypeEPER.Comparison, PollutantReleaseTrend.CODE_KG, colors, labelTexts);
                }
                

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
    /// Label update
    /// </summary>
    private void updateTableLabels(TimeSeriesClasses.PollutantReleases data1, TimeSeriesClasses.PollutantReleases data2)
    {
        this.grdCompareDetails.Visible = true;

        List<CompareDetailElement> elements = new List<CompareDetailElement>();

        elements.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Year") + ":",
                                              data1 != null ? data1.Year.ToString() : String.Empty,
                                              data2 != null ? data2.Year.ToString() : String.Empty));

        elements.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Total") + ":",
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
            int facilityReportId = (int)ViewState[FACILITY_REPORTID];
            string pollutantCode = PollutantCode;
            
            bool confidentialityAffected = PollutantReleaseTrend.IsAffectedByConfidentiality(FacilityBasic.FacilityID, PollutantCode, CurrentMedium);
            Dictionary<string, string> header = CsvHeaderBuilder.GetFacilityTrendHeader(facilityReportId, confidentialityAffected);

            // Create Body
            string mediumName = LOVResources.MediumName(EnumUtil.GetStringValue(CurrentMedium));
            string codeEPER = pollutantCode + "EPER";
            string pollutantName = LOVResources.PollutantNameEPER(pollutantCode,codeEPER);
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

}
