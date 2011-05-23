using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;

namespace EPRTR.HeaderBuilders
{
    /// <summary>
    /// Creates detail information of search options to be presented in map print
    /// </summary>
    public class MapPrintDetails
    {

        public static string Build(Dictionary<string, string> header)
        {
            StringBuilder sb = new StringBuilder();

            if (header != null)
            {
                foreach (KeyValuePair<string, string> h in header)
                {
                    if (sb.Length != 0)
                    {
                        sb.Append(", ");
                    }
                        sb.AppendFormat("{0}: {1}", h.Key, h.Value);
                    
                }
            }

            return sb.ToString();
        }
    }
}
