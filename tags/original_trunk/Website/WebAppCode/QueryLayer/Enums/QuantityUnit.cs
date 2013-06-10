using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using QueryLayer.Utilities;

namespace QueryLayer.Enums
{
    /// <summary>
    /// Defines possible units for reporting quantities (t and kg)
    /// </summary>
    public  enum  QuantityUnit
    {
        [StringValue("KGM")]
        Kilo = 0,
        [StringValue("TNE")]
        Tonnes, 
        [StringValue("UNKNOWN")]
        Unknown
    }
}
