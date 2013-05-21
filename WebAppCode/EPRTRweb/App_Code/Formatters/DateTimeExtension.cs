using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Globalization;
using System.Threading;

namespace EPRTR.Formatters
{
    /// <summary>
    /// Summary description for DateTimeExtension
    /// </summary>
    public static class DateTimeExtension
    {
        /// <summary>
        /// Formats Datatime into local culture format.
        /// </summary>
        /// <param name="date"></param>
        /// <returns></returns>
        public static string Format(this DateTime? date)
        {
            string res = string.Empty;
            
            if (date != null)
            {
                CultureInfo culture = Thread.CurrentThread.CurrentUICulture;
                
                res = string.Format(culture, "{0:D}", date);
            }
            return res;
        }

        public static string Format(this DateTime date)
        {
            DateTime? nullableDate = (DateTime?)date;
            return nullableDate.Format();
        }

    }
}
