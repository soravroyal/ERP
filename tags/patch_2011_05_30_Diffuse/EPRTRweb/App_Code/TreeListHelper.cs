using System;
using System.Collections.Generic;
using System.Drawing;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


/// <summary>
/// Summary description for TreeListHelper
/// </summary>
public class TreeListHelper
{


    /// <summary>
    /// turn expanded on/off for each id (pollutant transfer code value)
    /// </summary>
    public static void SetExpanded(Dictionary<string, bool> tree, string id, bool expand)
    {
        if (tree!=null)
            tree[id] = expand;
    }


    /// <summary>
    /// return true if expanded
    /// </summary>
    public static bool GetExpanded(Dictionary<string, bool> tree, string id)
    {
        if (tree != null && tree.ContainsKey(id))
        {
            if (tree.ContainsKey(id))
                return tree[id];
        }
        return false;
    }

}
