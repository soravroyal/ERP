using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace QueryLayer.Utilities
{
    public static class AccidentalPercent
    {
        public static string DeterminePercent(object total, object accidental)
        {
            string result = "0 %";
            double totalConverted = 0;
            double accidentalConverted = 0;
            if (total != null)
            {
                totalConverted = (double)total;
                total.ToString().Split()[0].ToString();
            }
            if (accidental != null)
            {
                accidentalConverted = (double)accidental;
            }

            if (accidental != null && total != null)
            {
                result = "" + Math.Round(((accidentalConverted / totalConverted) * 100), 2) + " %";
            }
            
            return result;
        }
    }
}
