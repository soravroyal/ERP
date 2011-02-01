using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using System.Web.UI.DataVisualization.Charting;
using System.Drawing;
using System.Linq;
using EPRTR.Utilities;
using EPRTR.Localization;
using Utilities;
using QueryLayer;

/// <summary>
/// StackColumn - Time series bar chart
/// </summary>
public partial class ucStackColumn : System.Web.UI.UserControl
{

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// Initialize the bars. 
    /// </summary>
    /// <param name="series">The number of series to include in the bar chart</param>
    /// <param name="type">The type of time series chart</param>
    /// <param name="barcolors">The colors to use for the series. The number of colors given must corresponds to the number of series</param>
    /// <param name="barHatchStyles">The hatchstyles to use for the series. The number of styles given must corresponds to the number of series</param>
    /// <param name="legendTexts">The texts to be shown in the legends. If null, no legends will be shown</paparam>
    /// <param name="unitCode">The unit code corresponding to the y-axis</param>
    public void Initialize(int series, StackColumnType type, string unitCode, Color[] barColors, ChartHatchStyle[] barHatchStyles, string[] legendTexts)
    {

        if (series != barColors.Length)
        {
            throw (new ArgumentException("number of colors must correspond to the number of series"));
        }

        if (series != barHatchStyles.Length)
        {
            throw (new ArgumentException("number of hatch styles must correspond to the number of series"));
        }

        if (legendTexts != null && series != legendTexts.Length)
        {
            throw (new ArgumentException("number of legend tetxs must correspond to the number of series"));
        }

        //set in view state
        this.Type = type;

        setAxisYTitle(LOVResources.UnitName(unitCode));
        setFont();
        setLegendStyle(type);

        //add series and legends
        this.stackcolumn.Series.Clear();
        this.stackcolumn.Legends[0].CustomItems.Clear();

        for (int i = 0; i < series; i++)
        {
            Series bar = this.stackcolumn.Series.Add(i.ToString());
            bar.ChartType = SeriesChartType.StackedColumn;
            bar.Color = barColors[i];
            bar.IsVisibleInLegend = false; //use custom legends instead.
            bar.BackHatchStyle = barHatchStyles[i];

            if (legendTexts != null)
            {
                LegendItem item = new LegendItem();
                item.Name = legendTexts[i];
                item.SeriesName = legendTexts[i];
                item.BorderColor = Color.Black;
                item.Color = bar.Color;
                item.BackHatchStyle = bar.BackHatchStyle;
                item.ImageStyle = LegendImageStyle.Rectangle;

                this.stackcolumn.Legends[0].CustomItems.Add(item);
            }
        }

        this.stackcolumn.Legends[0].CustomItems.Reverse();
        
    }

    private void setFont()
    {
        //axis
        this.stackcolumn.ChartAreas[0].AxisX.LabelStyle.Font = Global.FontTimeSeries;
        this.stackcolumn.ChartAreas[0].AxisY.LabelStyle.Font = Global.FontTimeSeries;
        this.stackcolumn.ChartAreas[0].AxisX.TitleFont = Global.FontTimeSeries;
        this.stackcolumn.ChartAreas[0].AxisY.TitleFont = Global.FontTimeSeries;

        //legends
        this.stackcolumn.Legends[0].Font = Global.FontTimeSeries;
    }

    private void setLegendStyle(StackColumnType type)
    {
        if (type == StackColumnType.Comparison)
        {
            this.stackcolumn.Legends[0].LegendStyle = LegendStyle.Column;
        }
        else if (type == StackColumnType.TimeSeries)
        {
            this.stackcolumn.Legends[0].LegendStyle = LegendStyle.Row;
        }
    }


    /// <summary>
    /// Title on x/y
    /// </summary>
    private void setAxisYTitle(string title)
    {
        if (this.stackcolumn.ChartAreas.Count > 0)
            this.stackcolumn.ChartAreas[0].AxisY.Title = title;
    }
    private void setAxisXTitle(string title) // not used now
    {
        if (this.stackcolumn.ChartAreas.Count > 0)
            this.stackcolumn.ChartAreas[0].AxisX.Title = title;

    }

    /// <summary>
    /// Adds data in BarData values to the series. 
    /// The number of values must correspond to the no. of series defiend for the chart.
    /// </summary>
    public void Add(IEnumerable<TimeSeriesUtils.BarData> bars)
    {
        foreach (var bar in bars)
        {
            if (bar != null)
            {
                if (bar.Values != null && bar.Values.Length != this.stackcolumn.Series.Count)
                {
                    throw (new ArgumentException("Number of values must correspond to the number of series"));
                }

                string name = bar.Year.ToString();
                int year = bar.Year;

                if (bar.Values != null)
                {
                    for (int i = 0; i < bar.Values.Length; i++)
                    {
                        double value = bar.Values[i].HasValue ? bar.Values[i].Value : 0.0;
                        int index = this.stackcolumn.Series[i].Points.AddXY(year, value);

                        if (!String.IsNullOrEmpty(bar.ToolTip))
                        {
                            this.stackcolumn.Series[i].Points[index].ToolTip = bar.ToolTip;

                        }
                    }
                }
                else
                {
                    foreach (Series serie in this.stackcolumn.Series)
                    {
                        int index = serie.Points.AddXY(year, 0.0);
                    }
                }
            }


        }

        setXaxis(bars);

    }

    private void setXaxis(IEnumerable<TimeSeriesUtils.BarData> bars)
    {
        StackColumnType type = Type;

        Axis axisX = this.stackcolumn.ChartAreas[0].AxisX;

        int startYear = bars.Min(b => b.Year);
        int endYear = bars.Max(b => b.Year);

        double interval = 1; //default

        if (type == StackColumnType.Comparison)
        {
            if (startYear != endYear)
            {
                interval = endYear - startYear;
            }
        }

        double offset = endYear != startYear ? interval / 2 : interval-0.001;
        axisX.Interval = interval;
        axisX.Minimum = startYear - offset;
        axisX.Maximum = endYear + offset;

        axisX.IntervalOffset = offset;

        foreach (var bar in bars)
        {
            int year = bar.Year;

            CustomLabel label = new CustomLabel();
            label.FromPosition = year-offset; //avoid precision problems
            label.ToPosition = year+offset; //avoid precision problems
            label.Text = year.ToString();

            axisX.CustomLabels.Add(label);
        }
    }


    /// <summary>
    /// return width/height
    /// </summary>
    public Unit Width
    {
        set { this.stackcolumn.Width = value; }
        get { return this.stackcolumn.Width; }
    }
    public Unit Height
    {
        set { this.stackcolumn.Height = value; }
        get { return this.stackcolumn.Height; }
    }

    private StackColumnType Type {
        get { return (StackColumnType) ViewState["TimeserieChartType"]; }
        set { ViewState["TimeserieChartType"] = value; } 
    }

}

public enum StackColumnType
{
    TimeSeries = 0,
    Comparison
}