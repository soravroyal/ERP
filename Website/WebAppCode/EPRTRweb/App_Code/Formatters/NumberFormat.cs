using System;

namespace EPRTR.Formatters
{
    public class NumberFormat
    {
        private const string ZERO = "0";
        private const string NULL_VALUE_INDICATOR = "-";

        public static string Format(double number)
        {
            if (number == 0)
            {
                return ZERO;
            }

            return number.ToString("#,#");    

        }
        
        public static string Format(double? number)
        {
            return (number == null ? NULL_VALUE_INDICATOR : Format((double)number));
        }

        public static string Format(int number)
        {
            return Format((double) number);
        }

        public static string Format(int? number)
        {
            return (number == null ? NULL_VALUE_INDICATOR : Format((double)number));
        }
    }
}
