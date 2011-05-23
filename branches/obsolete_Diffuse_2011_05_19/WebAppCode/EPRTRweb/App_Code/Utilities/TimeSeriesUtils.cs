using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer;

namespace Utilities
{
/// <summary>
/// Summary description for StackedColumnUtils
/// </summary>
    public static class TimeSeriesUtils
    {
        public class BarData
        {

            public int Year { get; set; }
            public double?[] Values { get; set; }
            public string ToolTip { get; set; }
        }

               

        public static double RangeValue(double? value)
        {
            return (value.HasValue) ? value.Value : 0.0;
        }
        public static int RangeValue(int? value)
        {
            return (value.HasValue) ? value.Value : 0;
        }


        /// <summary>
        /// Fills in missing reporting years.
        /// </summary>
        public static IEnumerable<TimeSeriesUtils.BarData> InsertMissingYears(IEnumerable<TimeSeriesUtils.BarData> data, bool includeEPER)
        {
          
           IEnumerable<REPORTINGYEAR> years = ListOfValues.ReportingYears(includeEPER);
           
            IEnumerable<TimeSeriesUtils.BarData> bars = from y in years
                                                        join c in data on y.Year equals c.Year into g
                                                        from c in g.DefaultIfEmpty()
                                                        orderby y.Year
                                                        select new TimeSeriesUtils.BarData
                                                        {
                                                            Year = y.Year,
                                                            Values = c != null ? c.Values : null,
                                                            ToolTip = c != null ? c.ToolTip : null
                                                        };

            return bars;
        }

        public static IEnumerable<TimeSeriesUtils.BarData> InsertMissingYearsTimeSeries(IEnumerable<TimeSeriesUtils.BarData> data, bool includeEPER)
        {
            IEnumerable<REPORTINGYEAR> years = ListOfValues.ReportingYearsTimeSeries();

            IEnumerable<TimeSeriesUtils.BarData> bars = from y in years
                                                        join c in data on y.Year equals c.Year into g
                                                        from c in g.DefaultIfEmpty()
                                                        orderby y.Year
                                                        select new TimeSeriesUtils.BarData
                                                        {
                                                            Year = y.Year,
                                                            Values = c != null ? c.Values : null,
                                                            ToolTip = c != null ? c.ToolTip : null
                                                        };

            return bars;
        }

    }
}
