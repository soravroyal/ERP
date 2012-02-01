using System;

public partial class CommonUserControls_ucSheetTitleIcon : System.Web.UI.UserControl
{
    /// <value>
    /// Determines the type of icon to be presented
    /// </value>
    public IconType Type
    {
        get; set ; 
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    public string ImageURL
    {
        get
        {
            return imgSheetTitleIcon.ImageUrl;
        }

        set
        {
            imgSheetTitleIcon.ImageUrl = value;

            if (string.IsNullOrEmpty(value))
            {
                Visible = false;
            }
            else
            {
                Visible = true;
            }
        }
    }

    public string AlternateText
    {
        get { return imgSheetTitleIcon.AlternateText; }
        set { imgSheetTitleIcon.AlternateText = value; }
    }
}

/// <summary>
/// Defines possible types of icons
/// </summary>
public enum IconType
{
    Activity = 0,
    Pollutant,
    Waste
}

