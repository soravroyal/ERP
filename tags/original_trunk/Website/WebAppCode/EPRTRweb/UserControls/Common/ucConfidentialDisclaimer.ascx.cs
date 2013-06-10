using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.ComponentModel;
using QueryLayer.Utilities;
using System.Globalization;
using System.Diagnostics;
using EPRTR.Localization;

public partial class ucConfidentialDisclaimer : System.Web.UI.UserControl
{
    //Constant for viewstate
    //private static string VS_INITIALIZED = "Initialized";

    public EventHandler AlertClick;

    /// <value>
    /// Gets or sets the Cascading stylesheet (CSS)
    /// </value>
    public string CssClass
    {
        get { return this.divContent.Attributes["class"];  }
        set { this.divContent.Attributes["class"] = value; }
    }

    /// <summary>
    /// Set or get the text string
    /// </summary>
    public string Text{
        get { return this.lnbAlert.Text; }
        set { this.lnbAlert.Text = value; }
    }
    /// <summary>
    /// get or set the command arguement
    /// </summary>
    public string CommandArgument
    {
        get { return this.lnbAlert.CommandArgument; }
        set { this.lnbAlert.CommandArgument = value; }
    }

/*
    protected void Page_PreRender(object sender, EventArgs e)
    {
        initialize();
    }


    //initialize hyperlink unless it is already done.
    private void initialize()
    {
        bool init = ViewState[VS_INITIALIZED] != null && (bool) ViewState[VS_INITIALIZED];

        if (!init)
        {
            ViewState[VS_INITIALIZED] = true;
        }

    }
    */
    /// <summary>
    /// what to do on a click.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void onClick(object sender, EventArgs e)
    {
        if (AlertClick != null)
            AlertClick.Invoke(sender, e);
    }
    
}
