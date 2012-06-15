using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;
using System.Collections;
using System.IO;
using System.Data;
using System.Net;
using QueryLayer;
using EPRTR.Formatters;
using System.Configuration;

namespace Feed.Rss
{
    /// <summary>
    /// Summary description for RssFeedHandler
    /// </summary>
    public class RssFeedHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            try
            {
                string siteurl = context.Request.Url.AbsoluteUri;
                siteurl = siteurl.Substring(0, siteurl.LastIndexOf("/") + 1);
                string cachedRssFeed = "";
                RssChannel chan = new RssChannel();
                // TODO get culturinfo from parameter
                int maxNumItems = Int32.Parse(ConfigurationManager.AppSettings["MaxNumberOfNewsItemsOnHomePage"]);
                cachedRssFeed = chan.getNewsFeed("en-GB", maxNumItems,siteurl);
                context.Response.ContentType = "text/xml";
                context.Response.Write(cachedRssFeed);
            }
            catch (Exception)
            {
                context.Response.StatusCode = 404;
                context.Response.End();
            }
        }

        public bool IsReusable
        {
            get
            {
                return true;
            }
        }
    }

    internal class RssChannel
    {
        private string _title;
        private string _link;
        private string _description;
        private string _language;
        private string _profilePath;
        private string _linkFormat;
        private string _guidFormat;
        private string _guidIsPermanent;
        private ArrayList _items;

        public RssChannel()
        {
        }

        public string getNewsFeed(string cultureCode,int maxNumItems,string siteurl)
        {
            var news = News.GetNewsForHomePage(cultureCode, maxNumItems);
            List<News.NewsItem> listItems = news.ToList();
            string xml = "";
            XmlWriterSettings settings = new XmlWriterSettings();
            settings.Indent = true;
            settings.NewLineOnAttributes = true;
            XmlWriter wXML = null;
            MemoryStream xmlstream = null;
            try
            {
                System.Globalization.DateTimeFormatInfo mfi = new  System.Globalization.DateTimeFormatInfo(); 
                xmlstream = new MemoryStream();
                wXML = XmlWriter.Create(xmlstream, settings);
                wXML.WriteStartDocument();
                // C:\Projekter\Petr\Code\Website\WebAppCode\EPRTRweb\UserControls\SearchFacility\ucFacilityListResult.ascx.cs
                wXML.WriteStartElement("rss");
                wXML.WriteAttributeString("version", "2.0");
                    wXML.WriteStartElement("channel");
                    wXML.WriteElementString("title", "E-PRTR news");
                    wXML.WriteElementString("link", siteurl);
                    wXML.WriteElementString("description", "Top news for E-PRTR");
                    wXML.WriteElementString("language", cultureCode);
                    //wXML.WriteElementString("pubDate", "Thu, 27 Apr 2006");
                    foreach (News.NewsItem item in listItems)
                    {
                        wXML.WriteStartElement("item");
                            wXML.WriteElementString("title",item.TitleText);
                            wXML.WriteElementString("link", siteurl+"pgnews.aspx?newsID=" + item.NewsId);
                            wXML.WriteElementString("description", item.ContentText);
                            wXML.WriteElementString("pubDate", item.NewsDate.ToString("o"));//  item.NewsDate.Year +"/"+item.NewsDate.Month + "/" + item.NewsDate.Day+" "+item.NewsDate.Hour+":"+item.NewsDate.Minute+":"+item.NewsDate.Second);
                            //wXML.WriteElementString("pubDate", item.NewsDate.Day +" "+ mfi.GetMonthName(item.NewsDate.Month) + " " + item.NewsDate.Year);
                        wXML.WriteEndElement();
                    }
                    wXML.WriteEndElement();
                wXML.WriteEndElement();
                wXML.WriteEndDocument();
                wXML.Flush();
                wXML.Close();
                
                xmlstream.Position = 0;
                using (StreamReader reader = new StreamReader(xmlstream))
                {
                    xml = reader.ReadToEnd();
                }
                return xml;
            }catch(Exception)
            {
                return null;
            }
        }

        public string Title
        {
            get { return (_title); }
            set { _title = value; }
        }

        public string Link
        {
            get { return (_link); }
            set { _link = value; }
        }

        public string Description
        {
            get { return (_description); }
            set { _description = value; }
        }

    

        public RssItem this[int index]
        {
            get
            {
                if (index < _items.Count)
                    return ((RssItem)_items[index]);
                return (null);
            }
        }

        internal class RssItem
        {
            private string _title;
            private string _subCat;
            private string _description;
            private string _link;
            private string _pubDate;
            private string _guid;

            /*internal RssItem(Facility fac, string linkFormat, string guidFormat)
            {
          
                string itemId;
                itemId = fac.Id.ToString();
                _title = fac.Name;
                _subCat = fac.LongDescription;
                _description = fac.ShortDescription;
                _pubDate = fac.LastEdited.ToShortDateString();
                // The linkFormat argument provides the URL of the 
                // item's document.
                _link = string.Format(linkFormat, itemId);
                // The guidFormat argument provides the string that uniquely identifies
                // the item for RSS readers.
                _guid = string.Format(guidFormat, itemId);
              
            }*/

     

            public string Title
            {
                get { return (_title); }
                set { _title = value; }
            }

            public string Description
            {
                get { return (_description); }
                set { _description = value; }
            }

            public string Link
            {
                get { return (_link); }
                set { _link = value; }
            }

            public string PubDate
            {
                get { return (_pubDate); }
                set { _pubDate = value; }
            }

            public string GUID
            {
                get { return (_guid); }
                set { _guid = value; }
            }

        }

    }
}
