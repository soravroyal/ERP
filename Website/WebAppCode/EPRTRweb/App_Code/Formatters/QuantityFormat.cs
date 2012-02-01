using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Globalization;
using QueryLayer.Utilities;
using QueryLayer;
using EPRTR.Localization;
using QueryLayer.Enums;

namespace EPRTR.Formatters
{
    /// <summary>
    /// Formats quantities of releases/transfers according to Technical Specification Appendix A
    /// </summary>
    public class QuantityFormat
    {

        const string NOTHING_REPORTED = "-";


        /// <summary>
        /// Formats a quantity assuming it is given in kg.
        /// </summary>
        /// <param name="rawAmount">Quantity in kg</param>
        /// <param name="conf">if true a null value will be marked "CONFIDENTIAL"</param>
        private static string formatMethod(double? rawAmount, bool conf)
        {
            string result = string.Empty;

            if (rawAmount == null)
            {
                result = ConfidentialFormat.Format(result, conf);
            }
            else
            {
                double amount = (double)rawAmount;

                if (amount < 0)
                {
                    throw new ArgumentException("Negative Amount provided", "rawAmount");
                }

                else if (amount >= 100000)
                {
                    result = "" + Math.Round((amount / 1000), 0).ToString("n0") + " " + Resources.GetGlobal("LOV_UNIT", "TNE");
                }
                else if (amount >= 10000 && amount < 100000)
                {
                    result = "" + Math.Round((amount / 1000), 1).ToString("n1") + " " + Resources.GetGlobal("LOV_UNIT", "TNE");
                }
                else if (amount >= 1000 && amount < 10000)
                {
                    result = "" + Math.Round((amount / 1000), 2).ToString("n2") + " " + Resources.GetGlobal("LOV_UNIT", "TNE");
                }
                else if (amount >= 100 && amount < 1000)
                {
                    result = "" + Math.Round((amount), 0).ToString("n0") + " " + Resources.GetGlobal("LOV_UNIT", "KGM");
                }
                else if (amount >= 10 && amount < 100)
                {
                    result = "" + Math.Round((amount), 1).ToString("n1") + " " + Resources.GetGlobal("LOV_UNIT", "KGM");
                }
                else if (amount >= 1 && amount < 10)
                {
                    result = "" + Math.Round((amount), 2).ToString("n2") + " " + Resources.GetGlobal("LOV_UNIT", "KGM");
                }
                else if (amount == 0.00)
                {
                    result = "0";
                }
                else if (amount * 10 >= 1 && amount * 10 < 10)
                {
                    result = "" + Math.Round((amount * 1000), 0).ToString("n0") + " " + Resources.GetGlobal("LOV_UNIT", "GRM"); ;
                }
                else if (amount * 100 >= 1 && amount * 100 < 10)
                {
                    result = "" + Math.Round((amount * 1000), 1).ToString("n1") + " " + Resources.GetGlobal("LOV_UNIT", "GRM"); ;
                }
                else if (amount * 1000 < 10 && amount > 0)
                {
                    result = "" + Math.Round((amount * 1000), 3).ToString("n3") + " " + Resources.GetGlobal("LOV_UNIT", "GRM"); ;
                }
            }
            return result;
        }

        private static string formatMethod(double? rawAmount, QuantityUnit unit, bool conf)
        {
            if (rawAmount == null)
            {
                return ConfidentialFormat.Format(null, conf);
            }
            else
            {
                if (unit == QuantityUnit.Unknown)
                {
                    string result = ((double)rawAmount).ToString("#,0.#");
                    return ConfidentialFormat.Format(result, conf);
                }
                else if (unit == QuantityUnit.Tonnes)
                {
                    //tranfer to kilos
                    return formatMethod(rawAmount * 1000, conf);
                }
                else
                {
                    //kilo
                    return formatMethod(rawAmount, conf);
                }
            }
        }


        /// <summary>
        /// Formats a quantity. Null values will not be marked "CONFIDENTIAL".
        /// </summary>
        /// <param name="amount">The quantity</param>
        /// <param name="unit">The unit of the quantity></param>
        public static string Format(double? amount, QuantityUnit unit)
        {
            return Format(amount, unit, false);
        }

        /// <summary>
        /// Formats a quantity
        /// </summary>
        /// <param name="amount">The quantity</param>
        /// <param name="unit">The unit of the quantity></param>
        ///<param name="conf">if true a null value will be marked confidential</param>
        public static string Format(double? amount, QuantityUnit unit, bool conf)
        {
            return formatMethod(amount, unit, conf);
        }

        /// <summary>
        /// Formats a quantity. Null values will not be marked "CONFIDENTIAL".
        /// </summary>
        /// <param name="amount">The quantity</param>
        /// <param name="unitCode">The unit of the quantity></param>
        public static string Format(double? amount, string unitCode)
        {
            return Format(amount, unitCode, false);
        }

        /// <summary>
        /// Formats a quantity
        /// </summary>
        /// <param name="amount">The quantity</param>
        /// <param name="unitCode">The unit of the quantity></param>
        ///<param name="conf">if true a null value will be marked confidential</param>
        public static string Format(double? amount, string unitCode, bool conf)
        {
            return Format(amount, QuantityFormat.parseUnit(unitCode), conf);
        }

        private static QuantityUnit parseUnit(string unitCode)
        {
            if (String.IsNullOrEmpty(unitCode))
            {
                return QuantityUnit.Unknown;
            }
            else
            {
                return (QuantityUnit)EnumUtil.Parse(typeof(QuantityUnit), unitCode);
            }
        }

        /// <summary>
        /// Formats percentage value for display in data tables.
        /// </summary>
        /// <param name="value">A percentage value [0.0% --> 100.0% ]</param>
        /// <returns></returns>
        public static string FormatPercentage(double? value)
        {
            if (!value.HasValue)
            {
                return NOTHING_REPORTED;
            }

            double val = (double)value;

            if (val < 0)
            {
                return String.Empty;
            }

            // display "0%"
            if (val == 0)
            {
                return FormatPercentage(0.0, 0);
            }
            // display "< 0.01%"
            else if (val < 0.01)
            {
                string res = FormatPercentage(0.01, 2);
                return String.Format("< {0}", res);
            }
            else if (val < 10.0)
            {
                return FormatPercentage(val, 2); 
            }
            else
            {
                // display percentage with 1 decimals
                return FormatPercentage(val, 1);
            }

        }
    
        /// <summary>
        /// Formats a percentage with the no. of decimals given. Includes "%" in the string.
        /// </summary>
        public static string FormatPercentage(double? value, int decimals)
        {
            if (!value.HasValue)
            {
                return NOTHING_REPORTED;
            }

            if (value < 0)
            {
                return String.Empty;
            }

            string format = String.Format("F{0}", decimals);

            return String.Format("{0}%", Math.Round((double)value, decimals).ToString(format));

        }
    }
}
