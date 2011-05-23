using System;
using System.Collections.Generic;
using System.Drawing;
using EPRTR.Formatters;
using EPRTR.Localization;
using EPRTR.Utilities;
using Formatters;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using Utilities;
using System.Web.UI.DataVisualization.Charting;    

public partial class ucTsPollutantReleasesSeries : System.Web.UI.UserControl
{
    public EventHandler OnMediumChanged;

    private string FILTER = "tspollutantreleaseseriesfilter";
    private string MEDIUM = "tsmediumrelease";
    
    protected void Page_Load(object sender, EventArgs e)
    {
    }

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

    public void Populate(PollutantReleasesTimeSeriesFilter filter, MediumFilter.Medium medium)
    {
        SearchFilter = filter;
        var counts = PollutantReleaseTrend.GetFacilityCounts(filter);
        this.ucMediumSelector.PopulateMediumRadioButtonList(filter.MediumFilter, medium, counts);
        
        // check that any relases are selected
        if (!filter.MediumFilter.ReleasesToAir &&
            !filter.MediumFilter.ReleasesToSoil &&
            !filter.MediumFilter.ReleasesToWater)
        {
            dataFound(false);
            return;
        }
    }


    /// <summary>
    /// updateTimeSeries
    /// </summary>
    private void updateTimeSeries(PollutantReleasesTimeSeriesFilter filter, MediumFilter.Medium medium)
    {
        CurrentMedium = medium;

        // assume data is found
        dataFound(true);
        
        // result from qyerylayer
        List<TimeSeriesClasses.PollutantReleases> data = PollutantReleaseTrend.GetTimeSeries(filter, medium); ;
        if (data == null || data.Count == 0) { dataFound(false); return; }

        // set report data to table
        this.lvTimeSeriesTable.DataSource = data;
        this.lvTimeSeriesTable.DataBind();


        Color[] colors = new Color[]{};
        string[] legendTexts = new string[] { Resources.GetGlobal("Common", "Accidental"), Resources.GetGlobal("Common", "Controlled") };

        // init chart. Must be done after table databinding, because missing years are added.
        if (medium.Equals(MediumFilter.Medium.Air)) 
        {
            colors = new Color[] { Global.ColorAirAccidental, Global.ColorAirTotal };
        }
        else if (medium.Equals(MediumFilter.Medium.Water))
        {
            colors = new Color[] { Global.ColorWaterAccidental, Global.ColorWaterTotal };
        }
        else if (medium.Equals(MediumFilter.Medium.Soil)) 
        {
            colors = new Color[] { Global.ColorSoilAccidental, Global.ColorSoilTotal};
        }
        
        ChartHatchStyle[] hatchStyles = new ChartHatchStyle[] { ChartHatchStyle.None, ChartHatchStyle.None };

        this.ucStackColumnTime.Initialize(colors.Length, StackColumnType.TimeSeries, PollutantReleaseTrend.CODE_KG, colors, hatchStyles, legendTexts);
        //this.ucStackColumnTime.Initialize(colors.Length, StackColumnType.TimeSeries, PollutantReleaseTrend.CODE_TNE, colors, legendTexts);

        List<TimeSeriesUtils.BarData> bars = new List<TimeSeriesUtils.BarData>();
        
        foreach (var v in data)
        {

            string[] tip = new string[] { String.Format("{0}: {1}", Resources.GetGlobal("Common", "Year"), v.Year),
                                          String.Format("{0}: {1}", Resources.GetGlobal("Common", "Facilities"), v.Facilities),
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

        this.ucStackColumnTime.Add(TimeSeriesUtils.InsertMissingYearsTimeSeries(bars, false));

    }

        
    /// <summary>
    /// radio buttons selected
    /// </summary>
    protected void OnSelectedMediumChanged(object sender, MediumSelectedEventArgs e)
    {
        if (SearchFilter != null)
        {
            updateTimeSeries(SearchFilter, e.Medium);
            if (OnMediumChanged != null)
                OnMediumChanged.Invoke(sender, EventArgs.Empty);
        }
    }

    /// <summary>
    /// hide/show data
    /// </summary>
    private void dataFound(bool foundData)
    {
        this.litNoResult.Visible = !foundData;
        this.ucStackColumnTime.Visible = foundData;
        this.lvTimeSeriesTable.Visible = foundData;
    }
    

    /// <summary>
    /// Data binding
    /// </summary>
    protected int GetYear(object obj)
    {
        TimeSeriesClasses.PollutantReleases row = (TimeSeriesClasses.PollutantReleases)obj;
        return row.Year;
    }
    protected string GetReportingCountries(object obj)
    {
        TimeSeriesClasses.PollutantReleases row = (TimeSeriesClasses.PollutantReleases)obj;
        return NumberFormat.Format(row.Countries);
    }
    protected string GetReportingFacilities(object obj)
    {
        TimeSeriesClasses.PollutantReleases row = (TimeSeriesClasses.PollutantReleases)obj;
        return NumberFormat.Format(row.Facilities);
    }

}
