using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Utilities;

public partial class ucDetailPrint : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// Store control to be printed in seseion
    /// </summary>
    public void SetPrintControl(Control control)
    {
        if (control != null)
            Session[Global.DETAIL_CONTROL] = control;
    }

    /// <summary>
    /// SetClientClick
    /// </summary>
    public void SetClientClick()
    {
        this.btnPrint.OnClientClick = getWindowPrintCall();
    }

    /// <summary>
    /// SetClientClick
    /// </summary>
    public void SetClientClick(string detailMapId, string urlId)
    {
        // if detail map has to be generate make call to createMapPng first
        // then call window.open with print page
        if (!String.IsNullOrEmpty(detailMapId) && !String.IsNullOrEmpty(urlId))
        {
            string func = String.Format("createMapPng('{0}','{1}'); ", detailMapId, urlId);
            func += getWindowPrintCall();
            this.btnPrint.OnClientClick = func;
        }
        else
        {
            // defailt (no detail print)
            this.btnPrint.OnClientClick = getWindowPrintCall();
        }
        
    }
    
    /// <summary>
    /// window open java call
    /// </summary>
    private string getWindowPrintCall()
    {
        string url = Request.Url.AbsoluteUri;
        url = url.ToLower();
        
        string printAspx = "Print.aspx";
        if (url != null && url.LastIndexOf("eprtrweb") > 0) //lower case
        {
            url = url.Substring(0, url.LastIndexOf("eprtrweb"));
            printAspx = url + "eprtrweb/print.aspx";
        }
        string str = Global.GetPrintScript(printAspx, "details", Global.PRINT_WIDTH, Global.PRINT_HEIGHT) + "; return false;";
        return str;
            
    }

}
