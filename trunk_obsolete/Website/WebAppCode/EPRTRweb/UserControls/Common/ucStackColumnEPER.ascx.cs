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
public partial class ucStackColumnEPER : System.Web.UI.UserControl
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
    /// <param name="legendTexts">The texts to be shown in the legends. If null, no legends will be shown</paparam>
    /// <param name="unitCode">The unit code corresponding to the y-axis</param>
    public void Initialize(int series, StackColumnTypeEPER type,  string unitCode, Color[] barColors, string[] legendTexts)
    {

        if (series != barColors.Length)
        {
            throw (new ArgumentException("number of colors must correspond to the number of series"));
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
        this.stackcolumnEPER.Series.Clear();
        this.stackcolumnEPER.Legends[0].CustomItems.Clear();

        for (int i = 0; i < series; i++)
        {
            Series bar = this.stackcolumnEPER.Series.Add(i.ToString());
            bar.ChartType = SeriesChartType.StackedColumn;
            bar.Color = barColors[i];
            bar.IsVisibleInLegend = false; //use custom legends instead.

            if (legendTexts != null && !legendTexts[i].Equals(""))
            {
                LegendItem item = new LegendItem();
                item.Name = legendTexts[i];
                item.SeriesName = legendTexts[i];
                item.BorderColor = Color.Black;
                item.Color = bar.Color;
                item.ImageStyle = LegendImageStyle.Rectangle;

                this.stackcolumnEPER.Legends[0].CustomItems.Add(item);
            }
        }

        this.stackcolumnEPER.Legends[0].CustomItems.Reverse();
        
    }

    private void setFont()
    {
        //axis
        this.stackcolumnEPER.ChartAreas[0].AxisX.LabelStyle.Font = Global.FontTimeSeries;
        this.stackcolumnEPER.ChartAreas[0].AxisY.LabelStyle.Font = Global.FontTimeSeries;
        this.stackcolumnEPER.ChartAreas[0].AxisX.TitleFont = Global.FontTimeSeries;
        this.stackcolumnEPER.ChartAreas[0].AxisY.TitleFont = Global.FontTimeSeries;

        //legends
        this.stackcolumnEPER.Legends[0].Font = Global.FontTimeSeries;
    }

    private void setLegendStyle(StackColumnTypeEPER type)
    {
        if (type == StackColumnTypeEPER.Comparison)
        {
            this.stackcolumnEPER.Legends[0].LegendStyle = LegendStyle.Column;
        }
        else if (type == StackColumnTypeEPER.TimeSeries)
        {
            this.stackcolumnEPER.Legends[0].LegendStyle = LegendStyle.Row;
        }
    }


    /// <summary>
    /// Title on x/y
    /// </summary>
    private void setAxisYTitle(string title)
    {
        if (this.stackcolumnEPER.ChartAreas.Count > 0)
            this.stackcolumnEPER.ChartAreas[0].AxisY.Title = title;
    }
    private void setAxisXTitle(string title) // not used now
    {
        if (this.stackcolumnEPER.ChartAreas.Count > 0)
            this.stackcolumnEPER.ChartAreas[0].AxisX.Title = title;

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
                if (bar.Values != null && bar.Values.Length != this.stackcolumnEPER.Series.Count)
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
                        int index = this.stackcolumnEPER.Series[i].Points.AddXY(year, value);

                        if (!String.IsNullOrEmpty(bar.ToolTip))
                        {
                            this.stackcolumnEPER.Series[i].Points[index].ToolTip = bar.ToolTip;

                        }
                    }
                }
                else
                {
                    foreach (Series serie in this.stackcolumnEPER.Series)
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
        StackColumnTypeEPER type = Type;

        Axis axisX = this.stackcolumnEPER.ChartAreas[0].AxisX;

        int startYear = bars.Min(b => b.Year);
        int endYear = bars.Max(b => b.Year);

        double interval = 1; //default

        if (type == StackColumnTypeEPER.Comparison)
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
        set { this.stackcolumnEPER.Width = value; }
        get { return this.stackcolumnEPER.Width; }
    }
    public Unit Height
    {
        set { this.stackcolumnEPER.Height = value; }
        get { return this.stackcolumnEPER.Height; }
    }

    private StackColumnTypeEPER Type {
        get { return (StackColumnTypeEPER) ViewState["TimeserieChartType"]; }
        set { ViewState["TimeserieChartType"] = value; } 
    }

}

public enum StackColumnTypeEPER
{
    Comparison,
    TimeSeries = 0
    
}