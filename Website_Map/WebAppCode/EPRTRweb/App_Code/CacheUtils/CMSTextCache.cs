using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer;
using EPRTR.ResourceProviders;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using Microsoft.Practices.EnterpriseLibrary.Common;
using System.Diagnostics;

/// <summary>
/// Summary description for CMSTextCache
/// </summary>
public static class CMSTextCache
{
    private const string STR_DEFAULT_LANG = "en-GB";
    //private static EPRTR.ResourceProviders.DBCMSTextDataContext db;


    /// <summary>
    /// CMSs the text.
    /// </summary>
    /// <param name="resource">The resource.</param>
    /// <param name="resourceType">Type of the resource.</param>
    /// <returns></returns>
    public static string CMSText(string resourceType, string resource)
    {
        EPRTR.ResourceProviders.DBCMSTextDataContext db = new DBCMSTextDataContext();
        string myText = string.Empty;
        
        
        string culture = System.Threading.Thread.CurrentThread.CurrentCulture.ToString();
  
        if (GetTextContent(db, resource, culture, resourceType).Count() == 0) //Using current thread culture, check to see if query returns a result
        {
            //If no result, then log
            LogEntry log = new LogEntry();
            
            log.EventId = 300;
            log.Message = String.Format("Text for {0} in language {1} is missing. ", resource, culture);
            log.Severity = TraceEventType.Information;
            log.Categories.Add("Text");
            log.Priority = 5;
            Logger.Write(log);

            //If query returns no results set the culture to default.
            if (GetTextContent(db, resource, STR_DEFAULT_LANG, resourceType).Count() == 0)
            {
                //Log that text is missing:
                LogEntry enlog = new LogEntry();
                enlog.EventId = 301;
                enlog.Message = String.Format("Text for {0} in language {1} (Default language) is missing. ", resource, culture);
                enlog.Severity = TraceEventType.Error;
                enlog.Categories.Add("Text");
                enlog.Priority = 1;
                Logger.Write(enlog);
                
            }
            else // default text returned.
            {
                myText = GetText(db, resource, STR_DEFAULT_LANG, resourceType);
            }
        }
        else // users currentthread culture returns a result
        {
            myText = GetText(db, resource, culture, resourceType);
        }


        return myText;
        
    
    }

    private static string GetText(EPRTR.ResourceProviders.DBCMSTextDataContext db, string resource, string culture, string resourceType)
    {
        string myString = string.Empty;
        //Should be only one result returned, but just in case, we loop thru
                
        foreach (var item in GetTextContent(db, resource, culture, resourceType).LinqCache(db, resource + resourceType + culture  ))
        {
            myString = item;
        }
        //
        if (GetTextContent(db, resource, culture, resourceType).Count() >= 2)
        {
            //Log that text is missing:
            LogEntry enlog = new LogEntry();
            enlog.EventId = 302;
            enlog.Message = String.Format("Text for {0} in language {1} returns more than one result. ", resource, culture);
            enlog.Severity = TraceEventType.Information;
            enlog.Categories.Add("Text");
            enlog.Priority = 1;
            Logger.Write(enlog);
        }
        return myString;
    }

    private static IQueryable<string> GetTextContent(EPRTR.ResourceProviders.DBCMSTextDataContext db, string resource, string culture, string resourceType)
    {
        try
        {
                    var qGetAboutPageContent = from c in db.ReviseResourceValues
                                           where c.CultureCode == culture
                                           join ce in db.ReviseResourceKeys on c.ResourceKeyID equals ce.ResourceKeyID
                                           where ce.ResourceKey == resource && ce.ResourceType == resourceType
                                           select c.ResourceValue;
                    return qGetAboutPageContent;
        }
        catch (Exception ex)
        {
            //Log err:
            LogEntry enlog = new LogEntry();
            enlog.EventId = 302;
            enlog.Categories.Add("Text");
            enlog.Message = "Error with LINQ query qGetAboutPageContent: " +ex.Message;
            enlog.Severity = TraceEventType.Error;
            enlog.Priority = 1;
            Logger.Write(enlog);
            
            throw;
        }
        

        
    }
}
