using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer;
using System.Globalization;
using System;

/// <summary>
/// Summary description for CultureResolver
/// </summary>
public static class CultureResolver
{
    public static string Resolve(HttpRequest request)
    {
        // get list of currently allowed cultures from CMS database
        IEnumerable<string> allowedCultures = ListOfValues.GetAllCultureCodes();
        // retrieve cookie
        HttpCookie cultureCookie = request.Cookies["Culture"];

        // retrieve url parameter
        string cultureUrlParameter = request.QueryString["lang"];

        string cultureDefault = "en-GB";
        
        // set to default 
        string cultureCode = cultureDefault;

        // apply url based culture
        if (allowedCultures.Contains(cultureUrlParameter))
        {
            cultureCode = cultureUrlParameter;
        }
        // apply cookie based culture from dropdown
        else if (cultureCookie != null 
            && !string.IsNullOrEmpty(cultureCookie.Value)
            && allowedCultures.Contains(cultureCookie.Value))
        {
            cultureCode = cultureCookie.Value;
        }

        return cultureCode;
    }

    public static CultureInfo ResolveCsvCulture(HttpRequest request)
    {
        HttpCookie csvCultureCookie = request.Cookies["CsvCulture"];
        CultureInfo csvCulture = null;

        if (csvCultureCookie != null
            && !String.IsNullOrEmpty(csvCultureCookie.Value))
        {
            csvCulture = CultureInfo.CreateSpecificCulture(csvCultureCookie.Value);
        }

        return csvCulture;
    }
}
