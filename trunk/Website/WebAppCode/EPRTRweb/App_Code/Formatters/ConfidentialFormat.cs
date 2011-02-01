using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EPRTR.Localization;

namespace EPRTR.Formatters
{
    /// <summary>
    /// Summary description for ConfidentialFormat
    /// </summary>
    public static class ConfidentialFormat
    {

        public static string Format(string txt, bool confidential)
        {
            string result = string.Empty;

            if (!string.IsNullOrEmpty(txt))
            {
                result = txt;
            }
            else if (confidential)
            {
                result = Resources.GetGlobal("Common", "CONFIDENTIAL");
            }
            else
            {
                result = "-"; 
            }

            return result;
        }
    }
}
