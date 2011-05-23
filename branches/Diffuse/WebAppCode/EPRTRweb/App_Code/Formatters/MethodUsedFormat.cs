using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using EPRTR.Localization;


namespace EPRTR.Formatters
{
    /// <summary>
    /// Formats methods used by concatenating method type and designation
    /// </summary>
    public static class MethodUsedFormat
    {
        private static string[] DELIMITER = { "#!" };
        /// <summary>
        /// Formats the methods used for a given pollutant or waste. Notice that each of these can have multiple methods reported
        /// Each method will be seperated by linebreaks (br)
        /// </summary>
        /// <param name="typeCode">Hold the method types reported, separated by #!</param>
        /// <param name="designation">Hold the method designations reported, separated by #!</param>
        /// <param name="confidential">Indicates if confidentiality has been claimed</param>
        /// <returns></returns>
        public static string MethodFormat(string typeCodes, string designations, bool confidential)
        {
            return format(typeCodes, designations, confidential, "<br />");
        }

        /// <summary>
        /// Formats the methods used for a given pollutant or waste. Notice that each of these can have multiple methods reported
        /// Each method will be seperated by linebreaks to be uused in tooltips (&#13;)
        public static string MethodFormatToolTip(string typeCodes, string designations, bool confidential)
        {
            return format(typeCodes, designations, confidential, "&#13;");
        }


        /// <summary>
        /// formats the methods used
        /// </summary>
        private static string format(string typeCodes, string designations, bool confidential, string delimiter)
        {
            string result = string.Empty;
            string[] designationSplit = null;
            string[] typecodeSplit = null;


            //designations will never be given without type codes.
            if (String.IsNullOrEmpty(typeCodes))
            {
                return ConfidentialFormat.Format(null, confidential);
            }
            else
            {
                typecodeSplit = typeCodes.Split(DELIMITER, StringSplitOptions.None);

                if (!String.IsNullOrEmpty(designations))
                {
                    designationSplit = designations.Split(DELIMITER, StringSplitOptions.None);
                }

                for (int i = 0; i < typecodeSplit.Length; i++)
                {
                    string typeCode = typecodeSplit[i];
                    string designation = designationSplit != null ? designationSplit[i] : null;

                    if (!String.IsNullOrEmpty(typeCode))
                    {
                        //CEN/ISO is removed as this is also part of the designation
                        if (!typeCode.ToUpper().Equals("CEN/ISO"))
                        {
                            result += typeCode;
                        }

                        if (!String.IsNullOrEmpty(designation))
                        {
                            result += " " + designation;
                        }

                        result += delimiter;
                    }
                }
            }

            return result;

        }

        /// <summary>
        /// Adds a method type to a string holding all methodTypes for a given pollutant etc.
        /// </summary>
        public static string AddMethodType(string methodTypes, string type)
        {
            methodTypes += DELIMITER[0] + type;
            return methodTypes;
        }

        /// <summary>
        /// Adds a method designation to a string holding all method designations for a given pollutant etc.
        /// </summary>
        public static string AddMethodDesignation(string designations, string designation)
        {
            designations += DELIMITER[0] + designation;
            return designations;
        }
    }
}
