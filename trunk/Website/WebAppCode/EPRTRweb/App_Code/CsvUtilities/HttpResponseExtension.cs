using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


namespace EPRTR.CsvUtilities
{
/// <summary>
/// Summary description for HttpResponseExtension
/// </summary>
    public static class HttpResponseExtension
    {
        public static void WriteUtf8FileHeader(this HttpResponse response, string filename)
        {
            response.Clear();
            response.ContentEncoding = System.Text.Encoding.UTF8;

            if (String.IsNullOrEmpty(filename))
            {
                filename = "EPRTR_data";
            }

            DateTime date = DateTime.Today;

            filename = String.Format("{0}__{1}_{2}_{3}.csv", filename,  date.Year, date.Month, date.Day);

            response.AppendHeader("Content-Disposition", String.Format("attachment; filename={0}", filename));

            // Binary Order Mark
            char BOM = '\uFEFF';
            response.Write(BOM);
         }
    }
}