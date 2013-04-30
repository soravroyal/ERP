using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.IO;
using EPRTR.Utilities;
using EPRTR.Localization;

public partial class Print : BasePage
{
    /// <summary>
    /// Print page load
    /// </summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        // to postback check needed here
        // print in popup new window
        invokePrint();
    }

    /// <summary>
    /// create the print page
    /// </summary>
    private void invokePrint()
    {
        string param = Request.Params["page"];
        if (String.IsNullOrEmpty(param)) return;

        // facility details, wait 1000 ms for generation of png map
        if (param.ToLower().Equals("details"))
            printWebControl(Session[Global.DETAIL_CONTROL] as Control, true, 1000);
        
        // default print, no wait
        else if (param.ToLower().Equals("global"))
            printWebControl(Session[Global.GLOBAL_CONTROL] as Control, true, 0);
    }

    /// <summary>
    /// printWebControl
    /// set attribute: htmlform.Attributes.Add("runat", "server");
    /// Webcontrol: if (control is WebControl) { Unit w = new Unit(100, UnitType.Percentage); ((WebControl)control).Width = w; }
    /// </summary>
    private void printWebControl(Control control, bool twoRuns, int msecToWait)
    {
        if (control == null) return;
        try
        {
            // sleep at first run
            if (msecToWait > 0) 
                System.Threading.Thread.Sleep(msecToWait);

            string html = getPrintHTML(control);
            
            // replace all html on page
            Response.Clear();
            Response.Write(html);
            Response.Flush();
            return; // reach here, done
        }
        catch
        {
            // Reach here somtimes, but not always!
            // Flush call seems to have fixed this, however try again 
            // one more time before skip.
            if (twoRuns) 
              printWebControl(control,false,0);
        }
    }
    
    /// <summary>
    /// GetPrintHTML
    /// return html code for argument control
    /// </summary>
    private string getPrintHTML(Control control)
    {
        // create new page
        StringWriter sw = new StringWriter();
        HtmlTextWriter htmlWrite = new HtmlTextWriter(sw);
        Page page = new Page();
        HtmlForm htmlform = new HtmlForm();

        // add form to page
        page.EnableEventValidation = false;
        page.EnableViewState = false;

        page.Controls.Clear();
        page.Controls.Add(htmlform);

        htmlform.Controls.Clear();
        htmlform.Controls.Add(control);

        page.DesignerInitialize();
        page.RenderControl(htmlWrite);

        // create html
        string html = sw.ToString();
        html = formatHtml(html);
        return html;
    }


    /// <summary>
    /// format html
    /// </summary>
    private string formatHtml(string html)
    {
        // format, remove external links and special script calls
        html = html.Replace("ShowWaitIndicator();", String.Empty); // remove call to indicator
        html = html.Replace("PopupWindowButtonClicked", String.Empty); // remove calls to popupwindow
        html = html.Replace("href=", String.Empty); //remove all links
        html = html.Replace("type=\"image\"", "type=\"hidden\""); //remove time series icon and linksearch icon
        html = html.Replace("type=\"radio\"", "type=\"radio\" disabled=\"disabled\""); //disable radio buttons
        html = html.Replace("<select", "<select disabled=\"disabled\""); //disable dropdown buttons

        // add top part, head, title and styling
        string top = "<html><head><title>" + Resources.GetGlobal("Common", "Title") + "</title>" + Environment.NewLine;
        top += "<link href='css/reset.css' rel='stylesheet' type='text/css' />" + Environment.NewLine;
        top += "<link href='css/cssPrint/typography.css' rel='stylesheet' type='text/css' />" + Environment.NewLine;
        top += "<link href='css/forms.css' rel='stylesheet' type='text/css' />" + Environment.NewLine;
        top += "<link href='css/masterStyles.css' rel='stylesheet' type='text/css' />" + Environment.NewLine;
        top += "<link href='css/commonStyles.css' rel='stylesheet' type='text/css' />" + Environment.NewLine;
        top += "<link href='css/sheetStyles.css' rel='stylesheet' type='text/css' />" + Environment.NewLine;
        top += "<link href='css/cssPrint/sheetStyles.css' rel='stylesheet' type='text/css' />" + Environment.NewLine;
        top += "<link href='css/searchOptionStyles.css' rel='stylesheet' type='text/css' />" + Environment.NewLine;
        top += "<link href='css/cssPrint/facilityDetailsSpecifics.css' rel='stylesheet' type='text/css' />" + Environment.NewLine;
        top += "<link href='css/columnStyles.css' rel='stylesheet' type='text/css' />" + Environment.NewLine;
        top += "<link href='css/columnHeaderStyles.css' rel='stylesheet' type='text/css' />" + Environment.NewLine;
				top += "</head><body style='overflow:hidden'>";
        top += Environment.NewLine;

        // print tag
        string print = "<script language='JavaScript' defer='defer'>" + Environment.NewLine;
        print += "if (!document.all || (document.all && document.getElementById))" + Environment.NewLine;
        print += "{" + Environment.NewLine;
        print += " if (window.print)" + Environment.NewLine;
        print += " {" + Environment.NewLine;
        print += "  window.print(); " + Environment.NewLine;
        print += " }" + Environment.NewLine;
        print += " else " + Environment.NewLine;
        print += " {" + Environment.NewLine;
        print += "  window.close();" + Environment.NewLine;
        print += " }" + Environment.NewLine;
        print += "}" + Environment.NewLine;
        print += "</script>" + Environment.NewLine;

        // add endtags
        string buttom = "</body>" + Environment.NewLine;
        buttom += "</html>" + Environment.NewLine;

        return (top + html + print + buttom);
    }
   

}
