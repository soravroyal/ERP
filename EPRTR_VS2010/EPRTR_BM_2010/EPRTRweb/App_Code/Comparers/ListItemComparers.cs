using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using System.Web.UI.WebControls;
using System.Collections;

namespace EPRTR.Comparers
{
    /// <summary>
    /// Comparer used for sorting list items by text
    /// </summary>
    public class ListItemComparer : IComparer<ListItem>
    {

        int IComparer<ListItem>.Compare(ListItem x, ListItem y)
        {
            CaseInsensitiveComparer c = new CaseInsensitiveComparer();
            return c.Compare(x.Text, y.Text);
        }
    }
}
