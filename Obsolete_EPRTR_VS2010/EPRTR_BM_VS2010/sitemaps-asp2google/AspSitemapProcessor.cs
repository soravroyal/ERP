using System;
using System.Xml;
using System.Collections;

namespace SitemapConverter
{
    /// <summary>
    ///  
    /// </summary>
    /// <param name="url"></param>
    public delegate void ExtractedUrlDelegate(string url);
   

    /// <summary>
    /// 
    /// </summary>
    public static class AspSitemapProcessor
    {
        /// <summary>
        /// Starts the specified filename.
        /// </summary>
        /// <param name="filename">The filename.</param>
        /// <param name="receiver">The receiver of extracted urls.</param>
        public static void Process(string filename, ExtractedUrlDelegate receiver, IEnumerable listIDs )
        {
            if (null == receiver)
                throw new ArgumentNullException("receiver");
            
            XmlReaderSettings settings = new XmlReaderSettings();
            settings.ConformanceLevel = ConformanceLevel.Fragment;
            settings.IgnoreWhitespace = true;
            settings.IgnoreComments = true;

            using (XmlReader reader = XmlReader.Create(filename, settings))
            {
                while (reader.Read())
                {
                    if (reader.NodeType == XmlNodeType.Element)
                    {
                        if (reader.Name == "siteMapNode")
                        {
                            string url = reader.GetAttribute("url");
                            
                            if (! string.IsNullOrEmpty(url))
                            {                               
                                receiver(url);
                                //RRP START 18-04-2013
                                //The Google sitemap.xml shall be updated to include URLs for all facility factsheets
                                //We cant use the Web.sitemap file from the web site because this file creates the web site menu. 
                                //So we cant add a new tag for the facility details.
                                if (url == "~/FacilityLevels.aspx")
                                {
                                    // D30 START 16/05/2013
                                    // add all facilityIDs urls
                                    foreach (int id in listIDs)
                                    {
                                        url = "~/FacilityDetails.aspx?FacilityId=" + id;
                                        receiver(url);
                                    }
                                    // D30 END 16/05/2013
                                }
                                //RRP END 18-04-2013
                            }
                        }
                    }
                }
            }
            
        }
    }
}
