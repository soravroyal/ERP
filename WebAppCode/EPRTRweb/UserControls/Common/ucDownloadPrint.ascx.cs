using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Utilities;

public partial class ucDownloadPrint : System.Web.UI.UserControl
{
    public EventHandler DoSave;
    
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// Hide buttons
    /// </summary>
    public void Hide()
    {
        this.btndownload.Visible = false;
        this.btnPrint.Visible = false;
    }

    /// <summary>
    /// Toggle Visiblity
    /// </summary>
    public void Show(bool download, bool print)
    {
        this.btndownload.Visible = download;
        this.btnPrint.Visible = print;
        this.btnPrint.OnClientClick = Global.GetPrintScript("print.aspx", "global", Global.PRINT_WIDTH, Global.PRINT_HEIGHT);
    }
    
    /// <summary>
    /// Save
    /// </summary>
    protected void OnSave(object sender, ImageClickEventArgs e)
    {
        if (DoSave != null)
            DoSave.Invoke(sender, EventArgs.Empty);
    }
    
    /// <summary>
    /// Set print control
    /// </summary>
    public void SetPrintControl(Control control)
    {
        if (control != null)
            Session[Global.GLOBAL_CONTROL] = control;
    }
    
}
