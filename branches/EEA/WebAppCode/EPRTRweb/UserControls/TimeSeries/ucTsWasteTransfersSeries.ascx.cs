using System;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using QueryLayer;
using System.Collections.Generic;
using EPRTR.Utilities;
using EPRTR.Localization;
using EPRTR.Formatters;
using EPRTR.Charts;
using Utilities;
using System.Drawing;
using Formatters;
using System.Web.UI.DataVisualization.Charting;

public partial class ucTsWasteTransfersSeries : System.Web.UI.UserControl
{
    public EventHandler OnWasteChange;

    private string FILTER = "tswastetransfersseriesfilter";
    private string WASTETYPE = "tswastetypeseries";
    
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
    /// 
    /// </summary>
    public void Populate(WasteTransferTimeSeriesFilter filter, WasteTypeFilter.Type wasteType)
    {
        SearchFilter = filter;

        var counts = WasteTransferTrend.GetCountFacilities(filter);

        this.ucWasteTypeSelector.PopulateRadioButtonList(filter.WasteTypeFilter, wasteType, counts);

        // check that any relases are selected
        if (!filter.WasteTypeFilter.HazardousWasteCountry &&
            !filter.WasteTypeFilter.HazardousWasteTransboundary &&
            !filter.WasteTypeFilter.NonHazardousWaste)
        {
            dataFound(false);
            return;
        }
    }

    
    /// <summary>
    /// updateTimeSeries
    /// </summary>
    private void updateTimeSeries(WasteTransferTimeSeriesFilter filter, WasteTypeFilter.Type wastetype)
    {
        CurrentWasteType = wastetype;

        // assume data is found
        dataFound(true);

        // result from qyerylayer
        List<TimeSeriesClasses.WasteTransfer> data = WasteTransferTrend.GetTimeSeries(filter, wastetype);
        // no data found, hide controls and leave
        if (data == null || data.Count == 0) { dataFound(false); return; }

        

        // set report data to table
        this.lvTimeSeriesTable.DataSource = data;
        this.lvTimeSeriesTable.DataBind();

        // init stack column, 3 ranges 
        var _colors = new List<Color>();
        var _legendTexts = new List<string>();
        var _hatchStyles = new List<ChartHatchStyle>();
        var _tips = new List<string>();
        var _values = new List<double?>();

        _tips.Add(Resources.GetGlobal("Common", "Year") + ": {0}");
        _tips.Add(Resources.GetGlobal("Common", "Facilities") + ": {0}");


        // When called from the Time Series menu, the treatment filter will be null
        // Then all treatments are displayed
        bool showAll = (filter.WasteTreatmentFilter == null);

        if (showAll || filter.WasteTreatmentFilter.Recovery)
        {
            _colors.Add(Global.ColorWasteRecovery);
            _legendTexts.Add(Resources.GetGlobal("Common", "TreatmentRecovery"));
            _hatchStyles.Add(ChartHatchStyle.None);
        }

        if (showAll || filter.WasteTreatmentFilter.Disposal)
        {
            _colors.Add(Global.ColorWasteDisposal);
            _legendTexts.Add(Resources.GetGlobal("Common", "TreatmentDisposal"));
            _hatchStyles.Add(ChartHatchStyle.None);
        }

        if (showAll || filter.WasteTreatmentFilter.Unspecified)
        {
            _colors.Add(Global.ColorWasteUnspec);
            _legendTexts.Add(Resources.GetGlobal("Common", "TreatmentUnspecified"));
            _hatchStyles.Add(ChartHatchStyle.None);
        }

        Color[] colors = _colors.ToArray();
        string[] legendTexts = _legendTexts.ToArray();
        ChartHatchStyle[] hatchStyles = _hatchStyles.ToArray();

        this.ucStackColumnTime.Initialize(colors.Length, StackColumnType.TimeSeries, WasteTransferTrend.CODE_TNE, colors, hatchStyles, legendTexts);

        List<TimeSeriesUtils.BarData> bardata = new List<TimeSeriesUtils.BarData>();


        // loop through data and create tooltip
        foreach (var v in data)
        {
            _values.Clear();
            _tips.Clear();
            _tips.Add(String.Format("{0}: {1}", Resources.GetGlobal("Common", "Year"), v.Year));
            _tips.Add(String.Format("{0}: {1}", Resources.GetGlobal("Common", "Facilities"), v.Facilities));

            if (showAll || filter.WasteTreatmentFilter.Recovery)
            {
                _values.Add(TimeSeriesUtils.RangeValue(v.QuantityRecovery));
                _tips.Add(String.Format("{0}: {1}", Resources.GetGlobal("Common", "Recovery"), QuantityFormat.Format(v.QuantityRecovery, v.QuantityUnit)));
            }
            if (showAll || filter.WasteTreatmentFilter.Disposal)
            {
                _values.Add(TimeSeriesUtils.RangeValue(v.QuantityDisposal));
                _tips.Add(String.Format("{0}: {1}", Resources.GetGlobal("Common", "Disposal"), QuantityFormat.Format(v.QuantityDisposal, v.QuantityUnit)));
            }
            if (showAll || filter.WasteTreatmentFilter.Unspecified)
            {
                _values.Add(TimeSeriesUtils.RangeValue(v.QuantityUnspec));
                _tips.Add(String.Format("{0}: {1}", Resources.GetGlobal("Common", "Unspecified"), QuantityFormat.Format(v.QuantityUnspec, v.QuantityUnit)));
            }
                
            TimeSeriesUtils.BarData cd = new TimeSeriesUtils.BarData
            {
                Year = v.Year,
                Values = _values.ToArray(),
                ToolTip = ToolTipFormatter.FormatLines(_tips.ToArray())
            };
            bardata.Add(cd);
        }

        this.ucStackColumnTime.Add(TimeSeriesUtils.InsertMissingYears(bardata, false));

    }


    /// <summary>
    /// radio buttons selected
    /// </summary>
    protected void OnSelectedWasteTypeChanged(object sender, WasteTypeSelectedEventArgs e)
    {
        if (SearchFilter != null)
        {
            updateTimeSeries(SearchFilter, e.WasteType);
            if (OnWasteChange != null)
                OnWasteChange.Invoke(sender, EventArgs.Empty);
        }
    }

    /// <summary>
    /// hide/show data
    /// </summary>
    private void dataFound(bool foundData)
    {
        this.litNoResult.Visible = !foundData;
        this.ucStackColumnTime.Visible = foundData;
        this.ucStackColumnTime.Visible = foundData;
        this.lvTimeSeriesTable.Visible = foundData;
    }


    /// <summary>
    /// Data binding
    /// </summary>
    protected int GetYear(object obj)
    {
        TimeSeriesClasses.WasteTransfer row = (TimeSeriesClasses.WasteTransfer)obj;
        return row.Year;
    }
    protected string GetReportingCountries(object obj)
    {
        TimeSeriesClasses.WasteTransfer row = (TimeSeriesClasses.WasteTransfer)obj;
        return NumberFormat.Format(row.Countries);
    }
    protected string GetReportingFacilities(object obj)
    {
        TimeSeriesClasses.WasteTransfer row = (TimeSeriesClasses.WasteTransfer)obj;
        return NumberFormat.Format(row.Facilities);
    }

}
