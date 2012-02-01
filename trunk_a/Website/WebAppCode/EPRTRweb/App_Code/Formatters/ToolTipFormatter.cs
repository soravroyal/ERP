using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;


namespace Formatters
{
/// <summary>
/// Formats tootips
/// </summary>
    public static class ToolTipFormatter
    {
        private static string NEWLINE = Environment.NewLine;

        /// <summary>
        /// Formats the lines with linebreaks
        /// </summary>
        /// <param name="lines"></param>
        /// <returns></returns>
        public static string FormatLines(params string[] lines)
        {
            if (lines.Length == 0)
            {
                return String.Empty;
            }

            StringBuilder sb = new StringBuilder();

            for (int i = 0; i < lines.Length - 1; i++)
            {
                if (lines[i] != null)
                {
                    sb.AppendFormat("{0}{1}", lines[i], NEWLINE);
                }
            }
            sb.Append(lines[lines.Length-1]);

            return sb.ToString();
        }
    }
}
