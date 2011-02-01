using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer.Filters;
using EPRTR.Utilities;
using EPRTR.Localization;
using EPRTR.Formatters;
using QueryLayer;
using QueryLayer.Utilities;
using System.Drawing;
using Utilities;
using Formatters;
using System.Web.UI.DataVisualization.Charting;

public partial class ucTsPollutantTransfersSeries : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
        
    /// <summary>
    /// populate
    /// </summary>
    public void Populate(PollutantTransferTimeSeriesFilter filter)
    {
        // result from qyerylayer
        List<TimeSeriesClasses.PollutantTransfers> data = PollutantTransferTrend.GetTimeSeries(filter);

        // set data to table. 
        this.lvTimeSeriesTable.DataSource = data; 
        this.lvTimeSeriesTable.DataBind();

        // init time series. Must be done after table databinding, because missing years are added.
        this.ucStackColumnTime.Visible = (data != null && data.Count > 0);
        if (this.ucStackColumnTime.Visible)
        {

            Color[] colors = new Color[] { Global.ColorWasteWater};
            ChartHatchStyle[] hatchStyles = new ChartHatchStyle[] { ChartHatchStyle.None};
            // init time series
            this.ucStackColumnTime.Initialize(colors.Length, StackColumnType.TimeSeries, PollutantTransferTrend.CODE_KG, colors, hatchStyles, null);
            //this.ucStackColumnTime.Initialize(colors.Length, StackColumnType.TimeSeries, PollutantTransferTrend.CODE_TNE, colors, null);
            this.ucStackColumnTime.Width = 700;

            List<TimeSeriesUtils.BarData> bars = new List<TimeSeriesUtils.BarData>();

            // loop through data and create tooltip
            foreach (var v in data)
            {
                string[] tip = new string[] { String.Format("{0}: {1}", Resources.GetGlobal("Common", "Year"), v.Year),
                                              String.Format("{0}: {1}", Resources.GetGlobal("Common", "Quantity"), QuantityFormat.Format(v.Quantity, v.QuantityUnit)),
                                              String.Format("{0}: {1}", Resources.GetGlobal("Common", "Facilities"), v.Facilities)};

                TimeSeriesUtils.BarData cd = new TimeSeriesUtils.BarData
                {
                    Year = v.Year,
                    Values = new double?[] { TimeSeriesUtils.RangeValue(v.Quantity)},
                    ToolTip = ToolTipFormatter.FormatLines(tip)
                };
                bars.Add(cd);

            }
            this.ucStackColumnTime.Add(TimeSeriesUtils.InsertMissingYears(bars, false));
        }

    }


    /// <summary>
    /// Data binding
    /// </summary>
    protected int GetYear(object obj)
    {
        TimeSeriesClasses.PollutantTransfers row = (TimeSeriesClasses.PollutantTransfers)obj;
        return row.Year;
    }
    protected string GetReportingCountries(object obj)
    {
        TimeSeriesClasses.PollutantTransfers row = (TimeSeriesClasses.PollutantTransfers)obj;
        return NumberFormat.Format(row.Countries);
    }
    protected string GetReportingFacilities(object obj)
    {
        TimeSeriesClasses.PollutantTransfers row = (TimeSeriesClasses.PollutantTransfers)obj;
        return NumberFormat.Format(row.Facilities);
    }


}
