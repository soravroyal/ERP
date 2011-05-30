using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;

namespace EPRTR.Comparers
{
    /// <summary>
    /// Comparer used for sorting waste types
    /// </summary>
    public class WasteTypeComparer : IComparer<string>
    {

        int IComparer<string>.Compare(string x, string y)
        {
            if (String.IsNullOrEmpty(x))
                return -1;
            if (y == null)
                return 1;

            WasteTypeFilter.Type type1 = (WasteTypeFilter.Type)EnumUtil.Parse(typeof(WasteTypeFilter.Type), x);
            WasteTypeFilter.Type type2 = (WasteTypeFilter.Type)EnumUtil.Parse(typeof(WasteTypeFilter.Type), y);

            return type1.CompareTo(type2);

        }
    }
}
