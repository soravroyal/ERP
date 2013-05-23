using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using EPRTR.Localization;

public partial class ucTreeTableLabel : System.Web.UI.UserControl
{
    private string TOOLTIP_EXPANDED = Resources.GetGlobal("Common", "ExpandedToolTip");
    private string TOOLTIP_COLLAPSED = Resources.GetGlobal("Common", "CollapsedToolTip");

    private const string IMG_EXPANDED = "~/images/minus.gif";
    private const string IMG_COLLAPSED = "~/images/plus.gif";
    private int level;
    private string cssClass;

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    public string CssClass {
        get { return this.cssClass; }
        set { this.cssClass = value; } 
    }


    public string CommandName
    {
        get { return this.lnkButton.CommandName; }
        set
        {
            this.lnkButton.CommandName = value;
            this.Image.CommandName = value;
        }
    }

    public string CommandArgument
    {
        get { return this.lnkButton.CommandArgument; }
        set
        {
            this.lnkButton.CommandArgument = value;
            this.Image.CommandArgument = value;
        }
    }

    public int Level
    {
        get {return this.level;} 
        set {this.level = value;
            string css = "indentLevel" + level;
            this.divTreeLabel.Attributes["class"] = cssClass + " " + css;
        }
    }

    public bool HasChildren
    {
        get { return this.lnkButton.Visible; }
        set
        {
            this.lnkButton.Visible = value;
            this.Image.Visible = value;
            this.lbSub.Visible = !value;
        }
    }

    public string Text
    {
        get{return this.lnkButton.Text;}
        set 
        {
            this.lnkButton.Text = value;
            this.lbSub.Text = value;
        }
    }

    public string ToolTipText
    {
        get;
        set;
    }


    public bool Expanded
    {
        get {
            return this.Image.ImageUrl.Equals(IMG_EXPANDED);
        }
        set
        {
            string imgUrl = value ? IMG_EXPANDED : IMG_COLLAPSED;
            this.Image.ImageUrl = imgUrl;

            this.ToolTipText = value ? TOOLTIP_EXPANDED : TOOLTIP_COLLAPSED;
            
        }
    }

}
