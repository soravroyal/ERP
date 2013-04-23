using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;

public partial class ucSheetLinks : System.Web.UI.UserControl
{
    public EventHandler Linkclick;

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    public void ResetContentLinks()
    {
        for (int i = 0; i < 10; i++)
        {
            LinkButton lbtn = FindControl("LinkButton" + i) as LinkButton;
            if (lbtn != null)
            {
                lbtn.Visible = false;
                lbtn.Text = String.Empty;
            }
        }
    }

    public void SetLink(string text, string commandArgument)
    {
        for (int i = 0; i < 10; i++)
        {
            LinkButton lbtn = FindControl("LinkButton" + i) as LinkButton;
            if (lbtn != null)
            {
                if (String.IsNullOrEmpty(lbtn.Text))
                {
                    lbtn.Visible = true;
                    lbtn.Text = text;
                    lbtn.CommandArgument = commandArgument.ToString();
                    break;
                }
            }
        }
    }

    public void HighLight(string commandArgument)
    {
        for (int i = 0; i < 10; i++)
        {
            
            LinkButton lbtn = FindControl("LinkButton" + i) as LinkButton;
            if (lbtn != null)
                lbtn.CssClass = lbtn.CommandArgument.Equals(commandArgument) ? "contentsBox_item contentsBox_item_selected" : "contentsBox_item";
        }
    }


    protected void onClick(object sender, EventArgs e)
    {
        if (Linkclick != null)
            Linkclick.Invoke(sender, e);
    }

    /// <summary>
    /// Used to hide and show a link with a specified command argument
    /// </summary>
    public void ToggleLink(string CommandArgument, bool isVisible)
    {
        for (int i = 0; i < 10; i++)
        {
            LinkButton lbtn = FindControl("LinkButton" + i) as LinkButton;
            if (lbtn != null)
            {
                if (lbtn.CommandArgument == CommandArgument)
                {
                    lbtn.Visible = isVisible;
                    break;
                }
            }
        }
     }
    
}
