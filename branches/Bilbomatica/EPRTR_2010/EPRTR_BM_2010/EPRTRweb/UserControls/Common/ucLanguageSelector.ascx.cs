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
        bool showLangSelector = bool.Parse(ConfigurationManager.AppSettings["EnableLanguageSelection"]);

        if (!Page.IsPostBack)
        {
            if (showLangSelector)
            {
                //D30 START 22-04-2013
                //LangListView.DataSource = QueryLayer.ListOfValues.GetAllCultures();
                LangListView.DataSource = QueryLayer.ListOfValues.GetAllCultures().OrderBy(x => x.Name);
                //D30 END 22-04-2013
                LangListView.DataBind();
            }
        }

        langSelector.Visible = showLangSelector && (LangListView.Items.Count > 1);


        if (showLangSelector)
        {
            // Added code to show language selector onclick.
            // Is needed after the panel is styled with display:none in CSS, to avoid blinking onload
            System.Web.UI.ScriptManager
                .RegisterStartupScript(Page, typeof(string), "show_langselector",

                "$('.langSelector').click(function() { " +
                    "$('.langDropPanelClass').show(); " +
                    "});",

                true);
        }
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
