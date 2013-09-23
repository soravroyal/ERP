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
using System.Globalization;

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

                // Create an instance of StreamWriter to write text to a file.
                // The using statement also closes the StreamWriter.
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
                wXML.WriteStartElement("rss");
                wXML.WriteAttributeString("version", "2.0");
                wXML.WriteAttributeString("xmlns", "atom",null,"http://www.w3.org/2005/Atom");
                    wXML.WriteStartElement("channel");
                    wXML.WriteElementString("title", "E-PRTR news");
                    //RRP INI 05/06/2013
                    wXML.WriteElementString("link", siteurl);
                    //RRP END 05/06/2013
                    wXML.WriteStartElement("atom", "link", null);
                    wXML.WriteAttributeString("href", siteurl + "news.rss");
                    wXML.WriteAttributeString("rel", "self");
                    wXML.WriteAttributeString("type", "application/rss+xml");
                    wXML.WriteEndElement();
                    wXML.WriteElementString("description", "Top news for E-PRTR");
                    wXML.WriteElementString("language", cultureCode);
                    foreach (News.NewsItem item in listItems)
                    { 
                        wXML.WriteStartElement("item");
                            wXML.WriteElementString("title",item.TitleText);
                            string url = siteurl + "pgnews.aspx?newsID=" + item.NewsId;
                            wXML.WriteElementString("link", url);
                            wXML.WriteElementString("description", item.ContentText);
                            // Unique url for item
                            wXML.WriteElementString("guid", url);
                            //RRP INI 05/06/2013
                            // Wed, 27 Jun 2012 10:05:00 +0200
                            //string format = "ddd, dd MMM yyyy HH:mm:ss zzz";
                            string format = "ddd, dd MMM yyyy HH:mm:ss zz'00'";
                            //RRP END 05/06/2013    
                            wXML.WriteElementString("pubDate", item.NewsDate.ToString(format, CultureInfo.CreateSpecificCulture("en-US")));
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
            }catch(Exception e) 
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
