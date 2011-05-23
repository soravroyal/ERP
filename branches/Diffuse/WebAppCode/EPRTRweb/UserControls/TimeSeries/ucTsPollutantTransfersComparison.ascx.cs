using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer.Filters;
using QueryLayer;
using EPRTR.Utilities;
using QueryLayer.Utilities;
using EPRTR.Localization;
using EPRTR.Formatters;
using EPRTR.Charts;
using QueryLayer.Enums;
using Utilities;
using System.Drawing;
using StylingHelper;
using System.Web.UI.DataVisualization.Charting;

public partial class ucTsPollutantTransfersComparison : System.Web.UI.UserControl
{
    private string CODE_KG = EnumUtil.GetStringValue(QuantityUnit.Kilo);
    private string FILTER = "tspollutanttransfersseriesfilter";

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// prop
    /// </summary>
    protected PollutantTransferTimeSeriesFilter SearchFilter
    {
        get { return ViewState[FILTER] as PollutantTransferTimeSeriesFilter; }
        set { ViewState[FILTER] = value; }
    }
    
    /// <summary>
    /// Populate charts. Selected year in compare dropdown will be searchyear
    /// </summary>
    public void Populate(PollutantTransferTimeSeriesFilter filter, int? searchYear)
    {
        SearchFilter = filter;
        this.ucYearCompare.Initialize(false, searchYear);
        updateCompareChart(filter);
    }


    /// <summary>
    /// updateTimeSeries
    /// </summary>
    private void updateCompareChart(PollutantTransferTimeSeriesFilter filter)
    {
        dataFound(true);

        // init year combo boxes
        int year1 = this.ucYearCompare.Year1;
        int year2 = this.ucYearCompare.Year2;

        Color[] colors = new Color[] { Global.ColorWasteWater, Global.ColorWasteWater };
        string[] legendTexts = new string[] { Resources.GetGlobal("Common", "FacilitiesBothYears"), Resources.GetGlobal("Common", "AllFacilities") };
        ChartHatchStyle[] hatchStyles = new ChartHatchStyle[] { Global.HatchStyleBothYears, Global.HatchStyleTotal };

        // same unit for all data

        this.ucStackColumnCompare.Initialize(colors.Length, StackColumnType.Comparison, PollutantTransferTrend.CODE_KG, colors, hatchStyles , legendTexts);
                
        // from and to bar
        // get compare result compare char
        TimeSeriesClasses.ComparisonPollutant result = PollutantTransferTrend.GetComparisonTimeSeries(filter, year1, year2);
        bool foundData = (result.QuantityFrom != null || result.QuantityTo != null);
        if (foundData)
        {

            TimeSeriesUtils.BarData dataFrom = new TimeSeriesUtils.BarData
            {
                Year = result.YearFrom,
                Values = new double?[] { TimeSeriesUtils.RangeValue(result.BothQuantityFrom), TimeSeriesUtils.RangeValue(result.QuantityFrom) - TimeSeriesUtils.RangeValue(result.BothQuantityFrom) },
            };

            TimeSeriesUtils.BarData dataTo = new TimeSeriesUtils.BarData
            {
                Year = result.YearTo,
                Values = new double?[] { TimeSeriesUtils.RangeValue(result.BothQuantityTo), TimeSeriesUtils.RangeValue(result.QuantityTo) - TimeSeriesUtils.RangeValue(result.BothQuantityTo) },
            };

            // from and to bar
            this.ucStackColumnCompare.Add(new List<TimeSeriesUtils.BarData>() { dataFrom, dataTo });


            // update sinle table
            updateTable(result);
        }
        else
            dataFound(false);
    }


    /// <summary>
    /// YearSelectedChanged
    /// </summary>
    protected void YearSelectedChanged(object sender, EventArgs e)
    {
        if (SearchFilter != null)
            updateCompareChart(SearchFilter);
    }

    /// <summary>
    /// hide/show data
    /// </summary>
    private void dataFound(bool foundData)
    {
        this.lbNoDataFound.Visible = !foundData;
        this.litNoResult.Visible = !foundData;
        this.grdCompareDetailsAll.Visible = foundData;
        this.grdCompareDetailsBothYears.Visible = foundData;
        this.ucStackColumnCompare.Visible = foundData;
    }

    /// <summary>
    /// updateTableReportFacilities
    /// </summary>
    private void updateTable(TimeSeriesClasses.ComparisonPollutant data)
    {

        this.grdCompareDetailsAll.Visible = true;
        this.grdCompareDetailsBothYears.Visible = true;

        //all facilites
        List<CompareDetailElement> elementsAll = new List<CompareDetailElement>();

        elementsAll.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Quantity"),
                                      data != null ? QuantityFormat.Format(data.QuantityFrom, CODE_KG) : String.Empty,
                                      data != null ? QuantityFormat.Format(data.QuantityTo, CODE_KG) : String.Empty));

        elementsAll.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Facilities"),
                      data != null ? NumberFormat.Format(data.FacilitiesFrom) : String.Empty,
                      data != null ? NumberFormat.Format(data.FacilitiesTo) : String.Empty));

        //facilites in both years
        List<CompareDetailElement> elementsBothYears = new List<CompareDetailElement>();
        

        elementsBothYears.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Quantity"),
                                      data != null ? QuantityFormat.Format(data.BothQuantityFrom, CODE_KG) : String.Empty,
                                      data != null ? QuantityFormat.Format(data.BothQuantityTo, CODE_KG) : String.Empty));

        elementsBothYears.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Facilities"),
                              data != null ? NumberFormat.Format(data.BothFacilities) : String.Empty,
                              data != null ? NumberFormat.Format(data.BothFacilities) : String.Empty));

        // data binding 
        this.grdCompareDetailsAll.DataSource = elementsAll;
        grdCompareDetailsAll.DataBind();

        this.grdCompareDetailsBothYears.DataSource = elementsBothYears;
        grdCompareDetailsBothYears.DataBind();
    }

    #region DataBinding methods

    protected void grdCompareDetailsAll_OnDataBound(object obj, EventArgs e)
    {
        GridViewRow headerRow = this.grdCompareDetailsAll.HeaderRow;

        if (headerRow != null)
        {
            headerRow.Cells[0].Text = Resources.GetGlobal("Common", "AllFacilities");
            headerRow.Cells[1].Text = this.ucYearCompare.Year1.ToString();
            headerRow.Cells[2].Text = this.ucYearCompare.Year2.ToString();


            headerRow.Cells[0].CssClass = "CompColLabel";
            headerRow.Cells[1].CssClass = "CompColData";
            headerRow.Cells[2].CssClass = "CompColData";
        }
    }

    protected void grdCompareDetailsBothYears_OnDataBound(object obj, EventArgs e)
    {
        GridViewRow headerRow = this.grdCompareDetailsBothYears.HeaderRow;

        if (headerRow != null)
        {
            headerRow.Cells[0].Text = Resources.GetGlobal("Common", "FacilitiesBothYears");
            headerRow.Cells[1].Text = this.ucYearCompare.Year1.ToString();
            headerRow.Cells[2].Text = this.ucYearCompare.Year2.ToString();

            headerRow.Cells[0].CssClass = "CompColLabel";
            headerRow.Cells[1].CssClass = "CompColData";
            headerRow.Cells[2].CssClass = "CompColData";
        }
    }


    #endregion

    
}
