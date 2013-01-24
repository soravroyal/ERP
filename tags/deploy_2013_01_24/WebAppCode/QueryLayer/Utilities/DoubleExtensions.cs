using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer.Utilities
{
    static class DoubleExtensions
    {
        public static double? Add(this double? d, params double?[]values)
        {
            foreach (double? v in values)
            {
                    if (v.HasValue)
                    {
                        d = d.HasValue ? d += v : v;
                    }
            }
            return d;
        }
    }


}
