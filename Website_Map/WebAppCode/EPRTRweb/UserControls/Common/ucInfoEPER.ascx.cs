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

public partial class ucInfoEPER : System.Web.UI.UserControl
{
    //Constant for viewstate
    private static string VS_INITIALIZED = "Initialized";

    private InfoTypeEPER type;

    /// <value>
    /// Determines the type of information to be presented
    /// </value>
    public InfoTypeEPER Type
    {
        get { return type; }
        set { type = value; }
    }

    /// <value>
    /// Gets or sets the Cascading stylesheet (CSS)
    /// </value>
    public string CssClass
    {
        get { return this.divInfo.Attributes["class"];  }
        set { this.divInfo.Attributes["class"] = value; }
    }

    /// <value>
    /// Gets or sets a text to be shown as part of the link (next to the info icon).
    /// </value>
    public string LinkText
    {
        get { return this.litLinkText.Text; }
        set { this.litLinkText.Text = value; }
    }

    /// <value>
    /// Gets or sets a text to be shown next to the info icon (will not be part of the link).
    /// </value>
    public string Text
    {
        get { return this.litText.Text; }
        set { this.litText.Text = value; }
    }

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
            switch (type)
            {
                case InfoTypeEPER.Activity:
                    setInfoPage(Resources.GetGlobal("Common", "InfoActivity"), "PopupLibraryActivitiesEPER.aspx"); //popup activities is placed in root folder
                    break;

                case InfoTypeEPER.Pollutant:
                    setInfoPage(Resources.GetGlobal("Common", "InfoEmissions"), "PopupLibraryEmissionsEPER.aspx?mpage=pop"); //popup pollutant is placed in root folder
                    break;

                case InfoTypeEPER.Waste:
                    setInfoPage(Resources.GetGlobal("Common", "InfoWaste"), "PopupLibraryWasteEPER.aspx"); //popup waste is placed in root folder
                    break;

              /*  case InfoTypeEPER.Emissions:
                    setInfoPage(Resources.GetGlobal("Common", "InfoEmisions"), "PopupLibraryEmissionsEPER.aspx"); //popup emissions is placed in root folder
                    break;*/
                              }
            ViewState[VS_INITIALIZED] = true;
        }
    }

    private void setInfoPage(string toolTip, string navigateUrl)
    {
        this.lnkInfo.NavigateUrl = navigateUrl;
        this.imgInfo.ToolTip = toolTip;
		
		// Client-side onclick event for entire DIV
        this.divInfo.Attributes["onclick"] = "PopupWindowButtonClicked('" + navigateUrl + "' ); return false;";
    }


    
}

/// <summary>
/// Defines possible types of info pages
/// </summary>
public enum InfoTypeEPER{
    Activity = 0,
    Pollutant,
    Waste,
    Emissions
}

