using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
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

				string[] actBrowserVersion = strVersion.Split('.');
				bool isSupported = true;

				for (int i = 0; i < actBrowserVersion.Length; i++)
				{ 
					// if actbrowser has more parts than appbrowser there's no worries 
					if (i >= browser.BrowserVersion.Count)
						break;

					// Check on the current section			
					if (int.Parse(actBrowserVersion[i]) < browser.BrowserVersion[i])
						isSupported = false;
					else if (int.Parse(actBrowserVersion[i]) > browser.BrowserVersion[i])
						break;
				}
        return isSupported;
    }



}
