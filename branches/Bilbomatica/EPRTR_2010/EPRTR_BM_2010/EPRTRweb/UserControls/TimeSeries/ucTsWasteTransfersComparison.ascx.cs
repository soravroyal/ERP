using System;
using System.Collections.Generic;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using QueryLayer;
using EPRTR.Utilities;
using EPRTR.Localization;
using EPRTR.Formatters;
using QueryLayer.Enums;
using EPRTR.Charts;
using Utilities;
using System.Drawing;
using System.Linq;
using StylingHelper;
using System.Web.UI.WebControls;
using System.Web.UI.DataVisualization.Charting;

public partial class ucTsWasteTransfersComparison : System.Web.UI.UserControl
{
    public EventHandler OnWasteChange;

    private string CODE_TNE = WasteTransferTrend.CODE_TNE;
    private string FILTER = "tswastetransfercomparison";
    private string WASTETYPE = "tswastetypecompare";

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// prop
    /// </summary>
    protected WasteTransferTimeSeriesFilter SearchFilter
    {
        get { return ViewState[FILTER] as WasteTransferTimeSeriesFilter; }
        set { ViewState[FILTER] = value; }
    }
    public WasteTypeFilter.Type CurrentWasteType
    {
        get { return (WasteTypeFilter.Type)ViewState[WASTETYPE]; }
        set { ViewState[WASTETYPE] = value; }
    }
    
    /// <summary>
    /// populate. Selected year in compare dropdown will be searchyear
    /// </summary>
    public void Populate(WasteTransferTimeSeriesFilter filter, WasteTypeFilter.Type wasteType, int? searchYear)
    {
        SearchFilter = filter;

        // check that any relases are selected
        if (!filter.WasteTypeFilter.HazardousWasteCountry &&
            !filter.WasteTypeFilter.HazardousWasteTransboundary &&
            !filter.WasteTypeFilter.NonHazardousWaste)
        {
            dataFound(false);
            return;
        }

        this.ucYearCompare.Initialize(false, searchYear);

        var counts = WasteTransferTrend.GetCountFacilities(filter);

        this.ucWasteTypeSelector.PopulateRadioButtonList(filter.WasteTypeFilter, wasteType, counts);
    }

    /// <summary>
    /// updateTimeSeries
    /// </summary>
    private void updateCompareChart(WasteTransferTimeSeriesFilter filter, WasteTypeFilter.Type wasteType)
    {
        CurrentWasteType = wasteType;

        // view everything, user may select other years to compare
        dataFound(true);

        // init year combo boxes
        int year1 = this.ucYearCompare.Year1;
        int year2 = this.ucYearCompare.Year2;

        // get compare result compare char
        TimeSeriesClasses.ComparisonWasteTransfer result = WasteTransferTrend.GetComparisonTimeSeries(filter, year1, year2, wasteType);
        bool foundData = (result.TotalFrom != null || result.TotalTo != null);
        if (foundData)
        {
            dataFound(true);

            Color[] colors = new Color[] { Global.ColorWasteTotal, Global.ColorWasteTotal };
            ChartHatchStyle[] hatchStyles = new ChartHatchStyle[] { Global.HatchStyleBothYears, Global.HatchStyleTotal };
            string[] legendTexts = new string[] { Resources.GetGlobal("Common", "FacilitiesBothYears"), Resources.GetGlobal("Common", "AllFacilities") };
            this.ucStackColumnCompare.Initialize(colors.Length, StackColumnType.Comparison, CODE_TNE, colors, hatchStyles, legendTexts);


            // from and to bar
            TimeSeriesUtils.BarData dataFrom = new TimeSeriesUtils.BarData
            {
                Year = result.YearFrom,
                Values = new double?[] { TimeSeriesUtils.RangeValue(result.BothTotalFrom), TimeSeriesUtils.RangeValue(result.TotalFrom) - TimeSeriesUtils.RangeValue(result.BothTotalFrom) },
            };

            TimeSeriesUtils.BarData dataTo = new TimeSeriesUtils.BarData
            {
                Year = result.YearTo,
                Values = new double?[] { TimeSeriesUtils.RangeValue(result.BothTotalTo), TimeSeriesUtils.RangeValue(result.TotalTo) - TimeSeriesUtils.RangeValue(result.BothTotalTo) },
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
    protected void OnSelectedWasteTypeChanged(object sender, WasteTypeSelectedEventArgs e)
    {
        if (SearchFilter != null)
        {
            updateCompareChart(SearchFilter, e.WasteType);
            if (OnWasteChange != null)
                OnWasteChange.Invoke(sender, EventArgs.Empty);
        }
    }

    /// <summary>
    /// YearSelectedChanged
    /// </summary>
    protected void YearSelectedChanged(object sender, EventArgs e)
    {
        if (SearchFilter != null)
            updateCompareChart(SearchFilter, CurrentWasteType);
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
    private void updateTable(TimeSeriesClasses.ComparisonWasteTransfer data)
    {

        this.grdCompareDetailsAll.Visible = true;
        this.grdCompareDetailsBothYears.Visible = true;


        //all facilities
        List<CompareDetailElement> elementsAll = new List<CompareDetailElement>();


        elementsAll.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Total"),
                                      data != null ? QuantityFormat.Format(data.TotalFrom, CODE_TNE) : String.Empty,
                                      data != null ? QuantityFormat.Format(data.TotalTo, CODE_TNE) : String.Empty));

        elementsAll.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Recovery"),
                              data != null ? QuantityFormat.Format(data.RecoveryFrom, CODE_TNE) : String.Empty,
                              data != null ? QuantityFormat.Format(data.RecoveryTo, CODE_TNE) : String.Empty));

        elementsAll.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Disposal"),
                              data != null ? QuantityFormat.Format(data.DisposalFrom, CODE_TNE) : String.Empty,
                              data != null ? QuantityFormat.Format(data.DisposalTo, CODE_TNE) : String.Empty));

        elementsAll.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Unspecified"),
                      data != null ? QuantityFormat.Format(data.UnspecFrom, CODE_TNE) : String.Empty,
                      data != null ? QuantityFormat.Format(data.UnspecTo, CODE_TNE) : String.Empty));

        elementsAll.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Facilities"),
        data != null ? NumberFormat.Format(data.FacilitiesFrom) : String.Empty,
        data != null ? NumberFormat.Format(data.FacilitiesTo) : String.Empty));


        //facilites in both years
        List<CompareDetailElement> elementsBothYears = new List<CompareDetailElement>();


        elementsBothYears.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Total"),
                              data != null ? QuantityFormat.Format(data.BothTotalFrom, CODE_TNE) : String.Empty,
                              data != null ? QuantityFormat.Format(data.BothTotalTo, CODE_TNE) : String.Empty));

        elementsBothYears.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Recovery"),
                              data != null ? QuantityFormat.Format(data.BothRecoveryFrom, CODE_TNE) : String.Empty,
                              data != null ? QuantityFormat.Format(data.BothRecoveryTo, CODE_TNE) : String.Empty));

        elementsBothYears.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Disposal"),
                              data != null ? QuantityFormat.Format(data.BothDisposalFrom, CODE_TNE) : String.Empty,
                              data != null ? QuantityFormat.Format(data.BothDisposalTo, CODE_TNE) : String.Empty));

        elementsBothYears.Add(new CompareDetailElement(Resources.GetGlobal("Common", "Unspecified"),
                      data != null ? QuantityFormat.Format(data.BothUnspecFrom, CODE_TNE) : String.Empty,
                      data != null ? QuantityFormat.Format(data.BothUnspecTo, CODE_TNE) : String.Empty));

        
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
