using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Config;
using System.Configuration;

/// <summary>
/// Summary description for BrowserCheck
/// </summary>
public class BrowserCheck
{
    public static bool IsBrowserSupported(string actualName, string strVersion)
    {
        const string prefix = "Browser_";

        
        List<int> actualVersion = strVersion.Split('.').Select(x => int.Parse(x)).ToList();

        var settings = System.Web.Configuration.WebConfigurationManager.AppSettings;

        var browsers = from string r in settings.Keys
                       where r.StartsWith(prefix) && r.ToLower().EndsWith(actualName.ToLower())
                       select new
                           {
                               BrowserName = r.Replace(prefix, string.Empty),
                               BrowserVersion = settings[r].Split('.').Select(x => int.Parse(x)).ToList()
                           };


        // if browser name is not in the list, it is not supported
        var browser = browsers.FirstOrDefault();
        if (browser == null)
        {
            return false;
        }
        
     
        // step through each <section> of the version number
        // <section>.<section>.<section>, i.e. "3.6.3"
        // compare Actual to Minimum requirement
        int maxCount = Math.Max(browser.BrowserVersion.Count(), actualVersion.Count());
        bool isSupported = true;

        for (int i = 0; i < maxCount; i++)
        {
            int limit = browser.BrowserVersion.ElementAtOrDefault(i);
            int actual = actualVersion.ElementAtOrDefault(i);

            if (actual < limit)
            {
                isSupported = false;
                break;
            }
        }

        return isSupported;
    }



}
