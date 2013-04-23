using System;
using EPRTR.Localization;

public partial class ucDisclaimerEPER : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        litDisclaimerHeader.Text = Resources.GetGlobal("Common","DisclaimerHeader");
    }

    public string CssClass {
        get { return this.disclaimerDiv.Attributes["class"];}
        set { this.disclaimerDiv.Attributes["class"] = value; } 
    }

    public string DisclaimerText
    {
        get { return litDisclaimerBody.Text; }
        set
        {
            litDisclaimerBody.Text = value;

            // hide user control if disclaimer text is empty
            Visible = (litDisclaimerBody.Text.Length != 0);
        }
    }

    public string DisclaimerHeader
    {
        get { return litDisclaimerHeader.Text; }
        set { litDisclaimerHeader.Text = value; }
    }
}
