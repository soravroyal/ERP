using System;
using System.Collections.Generic;
using System.Drawing;
using System.Web.UI.WebControls;
using EPRTR.Formatters;
using EPRTR.Localization;
using EPRTR.Utilities;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using StylingHelper;
using Utilities;
using QueryLayer.Enums;
using System.Web.UI.DataVisualization.Charting;

public partial class ucTsPollutantReleasesComparison : System.Web.UI.UserControl
{
    public EventHandler OnMediumChanged;

    private string CODE_KG = EnumUtil.GetStringValue(QuantityUnit.Kilo);
    private string FILTER = "tspollutantreleaseseriesfilter";
    private string MEDIUM = "tsmediumcompare";

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// prop
    /// </summary>
    protected PollutantReleasesTimeSeriesFilter SearchFilter
    {
        get { return ViewState[FILTER] as PollutantReleasesTimeSeriesFilter; }
        set { ViewState[FILTER] = value; }
    }
    public MediumFilter.Medium CurrentMedium
    {
        get { return (MediumFilter.Medium)ViewState[MEDIUM]; }
        set { ViewState[MEDIUM] = value; }
    }


    /// <summary>
    /// Populate charts. Selected year in compare dropdown will be searchyear
    /// </summary>
    public void Populate(PollutantReleasesTimeSeriesFilter filter, MediumFilter.Medium medium, int? searchYear)
    {
        SearchFilter = filter;

        // check that any relases are selected
        if (!filter.MediumFilter.ReleasesToAir &&
            !filter.MediumFilter.ReleasesToSoil &&
            !filter.MediumFilter.ReleasesToWater)
        {
            dataFound(false);
            return;
        }

        this.ucYearCompare.Initialize(false, searchYear);

        var counts = PollutantReleaseTrend.GetFacilityCounts(filter);
        this.ucMediumSelector.PopulateMediumRadioButtonList(filter.MediumFilter, medium, counts);
    }


    /// <summary>
    /// updateTimeSeries
    /// </summary>
    private void updateCompareChart(PollutantReleasesTimeSeriesFilter filter, MediumFilter.Medium medium)
    {
        CurrentMedium = medium;
        
        // view everything, user may select other years to compare
        dataFound(true);

         // init year combo boxes
        int year1 = this.ucYearCompare.Year1;
        int year2 = this.ucYearCompare.Year2;

        // get compare result compare char
        TimeSeriesClasses.ComparisonPollutant result = PollutantReleaseTrend.GetComparisonTimeSeries(filter, year1, year2, medium);
        bool foundData = (result.QuantityFrom!=null || result.QuantityTo!=null);
        if (foundData)
        {
            Color[] colors = new Color[] { };

            // create compare chart and table
            if (medium.Equals(MediumFilter.Medium.Air))
            {
                colors = new Color[] { Global.ColorAirTotal, Global.ColorAirTotal };
            }
            else if (medium.Equals(MediumFilter.Medium.Water))
            {
                // get report data
                colors = new Color[] { Global.ColorWaterTotal, Global.ColorWaterTotal };
            }
            else if (medium.Equals(MediumFilter.Medium.Soil))
            {
                colors = new Color[] { Global.ColorSoilTotal, Global.ColorSoilTotal };
            }

            ChartHatchStyle[] hatchStyles = new ChartHatchStyle[] { Global.HatchStyleBothYears, Global.HatchStyleTotal };
            string[] legendTexts = new string[] { Resources.GetGlobal("Common", "FacilitiesBothYears"), Resources.GetGlobal("Common", "AllFacilities") };
            this.ucStackColumnCompare.Initialize(colors.Length, StackColumnType.Comparison, PollutantReleaseTrend.CODE_KG, colors, hatchStyles, legendTexts);

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
    /// radio buttons selected
    /// </summary>
    protected void OnSelectedMediumChanged(object sender, MediumSelectedEventArgs e)
    {
        if (SearchFilter != null)
        {
            updateCompareChart(SearchFilter, e.Medium);
            if (OnMediumChanged != null)
                OnMediumChanged.Invoke(sender, EventArgs.Empty);
        }
    }

    /// <summary>
    /// YearSelectedChanged
    /// </summary>
    protected void YearSelectedChanged(object sender, EventArgs e)
    {
        if (SearchFilter != null)
            updateCompareChart(SearchFilter, CurrentMedium);
    }

    /// <summary>
    /// hide/show data
    /// </summary>
    private void dataFound(bool foundData)
    {
        this.lbNoDataFound.Visible = !foundData;
        this.litNoResult.Visible = !foundData;
        this.ucStackColumnCompare.Visible = foundData;
        this.grdCompareDetailsAll.Visible = foundData;
        this.grdCompareDetailsBothYears.Visible = foundData;
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


        elementsAll.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Total"),
                                      data != null ? QuantityFormat.Format(data.QuantityFrom, CODE_KG) : String.Empty,
                                      data != null ? QuantityFormat.Format(data.QuantityTo, CODE_KG) : String.Empty));

        elementsAll.Add(new CompareDetailElement(Resources.GetGlobal("Pollutant", "AccidentalQuantity"),
                              data != null ? QuantityFormat.Format(data.AccidentalFrom, CODE_KG) : String.Empty,
                              data != null ? QuantityFormat.Format(data.AccidentalTo, CODE_KG) : String.Empty));

        elementsAll.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Facilities"),
                              data != null ? NumberFormat.Format(data.FacilitiesFrom) : String.Empty,
                              data != null ? NumberFormat.Format(data.FacilitiesTo) : String.Empty));

        //facilites in both years
        List<CompareDetailElement> elementsBothYears= new List<CompareDetailElement>();

        elementsBothYears.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Total"),
                                      data != null ? QuantityFormat.Format(data.BothQuantityFrom, CODE_KG) : String.Empty,
                                      data != null ? QuantityFormat.Format(data.BothQuantityTo, CODE_KG) : String.Empty));

        elementsBothYears.Add(new CompareDetailElement(Resources.GetGlobal("Pollutant", "AccidentalQuantity"),
                              data != null ? QuantityFormat.Format(data.BothAccidentalFrom, CODE_KG) : String.Empty,
                              data != null ? QuantityFormat.Format(data.BothAccidentalTo, CODE_KG) : String.Empty));

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
