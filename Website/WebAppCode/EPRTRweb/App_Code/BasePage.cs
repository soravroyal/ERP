using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using EPRTR.Localization;
using System.Threading;

/// <summary>
/// Summary description for BasePage
/// </summary>
public class BasePage : System.Web.UI.Page
{
    protected override void InitializeCulture()
    {
        bool enableLanguage = bool.Parse(ConfigurationManager.AppSettings["EnableLanguageSelection"]);

        if (enableLanguage)
        {
            // retrieve cookie
            HttpCookie prevCulture = Request.Cookies["Culture"];

            string cultureCode = CultureResolver.Resolve(Request);

            // culture has changed write new cookie
            if (prevCulture == null || prevCulture.Value != cultureCode)
            {
                AddCultureCookie(cultureCode);
            }

            AddCsvCultureCookie(Thread.CurrentThread.CurrentCulture.ToString());

            this.UICulture = cultureCode;
            this.Culture = cultureCode;
            System.Globalization.CultureInfo culture = System.Globalization.CultureInfo.CreateSpecificCulture(cultureCode);
            Thread.CurrentThread.CurrentCulture = culture;
            Thread.CurrentThread.CurrentUICulture = culture;
        }
        base.InitializeCulture();
    }

    private void AddCultureCookie(string cultureCode)
    {
        var cookie = new HttpCookie("Culture", cultureCode);
        cookie.Expires = DateTime.Now.AddYears(1);
        Response.Cookies.Add(cookie);
    }

    private void AddCsvCultureCookie(string cultureCode)
    {
        var cookie = new HttpCookie("CsvCulture", cultureCode);
        Response.Cookies.Add(cookie);
    }

    protected override void OnPreLoad(EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            this.Page.Title = Resources.GetGlobal("Common", "Title");
        }
        base.OnPreLoad(e);
    }
}
