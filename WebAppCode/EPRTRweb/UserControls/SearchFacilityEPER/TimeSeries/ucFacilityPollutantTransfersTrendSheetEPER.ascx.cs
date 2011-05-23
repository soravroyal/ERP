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
using QueryLayer.Filters;


public partial class ucFacilityPollutantTransfersTrendSheetEPER : System.Web.UI.UserControl
{
    private const string POLLUTANTCODE = "transfertrendPollutantcode";
    private const string CONTENT_TYPE = "transfertrendContenttype";
    private const string SEARCH_YEAR = "transferstrendSearchYear";
    private const string TIMESERIES = "transfertrendTimeseries";
    private const string FACILITY_BASIC = "facilityBasic";

    private bool showEPER = true;

    public bool ShowEPER
    {
        get { return showEPER; }
        set { showEPER = value; }
    }

    private YearFilter Filter { get; set; }

    private enum TrendTransferContent
    {
        Comparison,
        TimeSeries = 0
        //Confidentiality
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
          this.ucSheetLinks.SetLink(Resources.GetGlobal("Facility", "PollutantContentTimeSeries"), TrendTransferContent.Comparison.ToString());
       
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
    /// Search, fill data into summery - Time Series
    /// </summary>
    public void Populate(int facilityReportId, string pollutantCode, int searchYear)
    {
        FacilityBasic = Facility.GetFacilityBasic(facilityReportId);
        PollutantCode =  pollutantCode;
        SearchYear = searchYear;
        ViewState[TIMESERIES] = null;
        //ViewState[CONTENT_TYPE] = null;
        // first sheet is the time series sheet
        showContent(TrendTransferContent.TimeSeries.ToString());
  
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

    protected void showContent(string command)
    {
       

        this.ucSheetLinks.HighLight(command);
        string txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyEmissions");

        bool conf = PollutantTransferTrend.IsAffectedByConfidentiality(FacilityBasic.FacilityID, PollutantCode);
        string alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;
        
       // Time Series
         if (command.Equals(TrendTransferContent.Comparison.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "PollutantTransfersComparison");
            ViewState[CONTENT_TYPE] = TrendTransferContent.Comparison;
      
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
        //this.ucYearCompareEPER.Visible = false;
        this.compareTable.Visible = false;

        // Get time series data, used by all sub sheets
        List<TimeSeriesClasses.PollutantTransfers> data = getTimeSeriesData(facilityid, pollutantCode);

      

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
                
                // init year combo boxes
               // this.ucYearCompareEPER.Visible = true;
                int year1 = this.ucYearCompareEPER.Year1;
                int year2 = this.ucYearCompareEPER.Year2;
                // reset
                resetLabels();

                TimeSeriesClasses.PollutantTransfers data1 = data.Where(d => d.Year == year1).DefaultIfEmpty(new TimeSeriesClasses.PollutantTransfers(year1)).Single();
                TimeSeriesClasses.PollutantTransfers data2 = data.Where(d => d.Year == year2).DefaultIfEmpty(new TimeSeriesClasses.PollutantTransfers(year2)).Single();

                bool dataFound = data1 != null || data2 != null;

                if (data1.Quantity >= 100000)
                {
                    this.ucStackColumnCompare.Initialize(colors.Length, StackColumnTypeEPER.Comparison, "TNE", colors, null);
                }
                else
                {
                    this.ucStackColumnCompare.Initialize(colors.Length, StackColumnTypeEPER.Comparison, PollutantTransferTrend.CODE_KG, colors, null);
                }
               

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
    /// Label update
    /// </summary>
    private void updateTableLabels(TimeSeriesClasses.PollutantTransfers data1, TimeSeriesClasses.PollutantTransfers data2)
    {
        this.grdCompareDetails.Visible = true;

        List<CompareDetailElement> elements = new List<CompareDetailElement>();

        elements.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Year") + ":",
                                              data1 != null ? data1.Year.ToString() : String.Empty,
                                              data2 != null ? data2.Year.ToString() : String.Empty));

        elements.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Quantity") + ":",
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
            string codeEPER = PollutantCode + "EPER";
            string pollutantName = LOVResources.PollutantNameEPER(PollutantCode, codeEPER);
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

}
