using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer;
using System.Configuration;

public partial class UserControls_Common_ucLanguageSelector : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            LangListView.DataSource = QueryLayer.ListOfValues.GetAllCultures();
            LangListView.DataBind();
        }

        bool showLangSelector = bool.Parse(ConfigurationManager.AppSettings["EnableLanguageSelection"]);

        langSelector.Visible = (LangListView.Items.Count > 1) && showLangSelector;


        // Added code to show language selector onclick.
        // Is needed after the panel is styled with display:none in CSS, to avoid blinking onload
        System.Web.UI.ScriptManager
            .RegisterStartupScript(Page, typeof(string), "show_langselector",

            "$('.langSelector').click(function() { " +
                "$('.langDropPanelClass').show(); " +
                "});",
            
            true);
    }

    protected string GetCommandArgument(object obj)
    {
        LOV_Culture row = (LOV_Culture)obj;
        string cultureCode = row.Code;
        return cultureCode;
    }

    protected string GetDisplayText(object obj)
    {
        LOV_Culture row = (LOV_Culture)obj;
        string text = row.Name;
        return text;
    }

 
}
