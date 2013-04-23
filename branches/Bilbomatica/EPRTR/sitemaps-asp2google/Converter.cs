// Copyright (c) 2006, Eugene Rymski
// All rights reserved.
// Redistribution and use in source and binary forms, with or without modification, are permitted 
//  provided that the following conditions are met:
// * Redistributions of source code must retain the above copyright notice, this list of conditions 
//   and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice, this list of conditions 
//   and the following disclaimer in the documentation and/or other materials provided with the distribution.
// * Neither the name of the “sitemaps-asp2google” nor the names of its contributors may be used to endorse or 
//   promote products derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY 
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
// TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
// POSSIBILITY OF SUCH DAMAGE.

using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using QueryLayer;



namespace SitemapConverter
{

   /// <summary>
   /// Converts ASP.NET sitemap to google sitemap
   /// </summary>
    internal class Converter
    {
        #region Internal datatypes
        /// <summary>
        /// Class to hold information about the url.
        /// </summary>
        /// <remarks>Currently contains only the url itself.</remarks>
        public class Url
        {
            /// <summary>
            /// Initializes a new instance of the <see cref="Url"/> class.
            /// </summary>
            /// <param name="location">The url.</param>
            public Url(string location)
            {
                _location = location;
            }


            /// <summary>
            /// Gets or sets the url.
            /// </summary>
            /// <value>The URL.</value>
            public string Location
            {
                get { return _location; }
                set { _location = value; }
            }
            private string _location;
        }
       
       #endregion
       
        #region Private variables

        private List<Url> _urls = new List<Url>(50);
        private string _domain;
        private StringBuilder _builder = new StringBuilder(256);
       
        #endregion

        /// <summary>
        /// Initializes a new instance of the <see cref="Converter"/> class.
        /// </summary>
        /// <param name="domain">The domain name.</param>
        public Converter(string domain)
        {
            _domain = domain;
        }


        /// <summary>
        /// Processes the specified ASP.NET sitemap, and generates google's sitemap.
        /// </summary>
        /// <param name="aspNetSitemap">The ASP.NET sitemap.</param>
        /// <param name="googleSitemap">The google sitemap.</param>
        /// <returns>true on success</returns>
        public bool Process(string aspNetSitemap, string googleSitemap)
        {
            AspSitemapProcessor.Process(aspNetSitemap, OnAspUrl);
            SaveGoogleMap(googleSitemap);
            
            return true;
        }

        private void SaveGoogleMap(string googleSitemap)
        {
            XmlWriterSettings settings = new XmlWriterSettings();
            settings.Indent = true;
            settings.Encoding = Encoding.UTF8;
            settings.CloseOutput = true;

            using (XmlWriter writer = XmlWriter.Create(googleSitemap, settings))
            {
                writer.WriteStartDocument();
                writer.WriteStartElement("urlset", "http://www.sitemaps.org/schemas/sitemap/0.9");

                writer.WriteAttributeString("xmlns", "xsi", null, "http://www.w3.org/2001/XMLSchema-instance");
                writer.WriteAttributeString("xsi", "schemaLocation", null, "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd");

                var languageList = ListOfValues.GetAllCultureCodes();

                foreach (Url url in _urls)
                {
                    writer.WriteStartElement("url");
                    writer.WriteElementString("loc", url.Location);
                    writer.WriteEndElement();

                    if (languageList.Count() > 1)
                    {
                        foreach (var lang in languageList)
                        {
                            //RRP START 18-04-2013
                            //Original code (All cultures)
                            //writer.WriteStartElement("url");
                            //writer.WriteElementString("loc", url.Location + "?lang=" + lang);
                            //writer.WriteEndElement();

                            //Only for en-GB culture
                            
                            if (lang == "en-GB")
                            {
                                writer.WriteStartElement("url");
                                writer.WriteElementString("loc", url.Location + "?lang=" + lang);
                                writer.WriteEndElement();
                            }
                            //RRP END 18-04-2013
                        }
                    }
                }

                writer.WriteEndElement();
                writer.WriteEndDocument();
            }
        }

        private void OnAspUrl(string url)
        {
            string fullUrl = ProcessUrl(url);
            AddUrl(fullUrl);
        }

        private string ProcessUrl(string url)
        {
            // reset string builder
            _builder.Length = 0;
            _builder.Append(_domain);
            
            int startIndex = 0;
            int count = url.Length;
            switch(url[0])
            {
                case '~': // do not include the "root" character
                    startIndex++;
                    count--;
                    break;
                case '/': // do nothing if url starts with the slash
                    break;
                default: // in all other case - append slash
                    _builder.Append('/');
                    break;
            }
            _builder.Append(url, startIndex, count);

            return _builder.ToString();
        }

        private void AddUrl(string url)
        {
            _urls.Add(new Url(url));
        }
    }
}
