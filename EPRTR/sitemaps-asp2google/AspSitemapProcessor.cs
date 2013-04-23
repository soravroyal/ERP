using System;
using System.Xml;

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
        public static void Process(string filename, ExtractedUrlDelegate receiver)
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
                                if (url == "~/FacilityLevels.aspx")
                                {
                                    url = "~/FacilityDetails.aspx";
                                    receiver(url);
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
