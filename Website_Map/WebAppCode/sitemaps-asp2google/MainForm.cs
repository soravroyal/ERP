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

using System;
using System.IO;
using System.Windows.Forms;
using SitemapConverter.Properties;

namespace SitemapConverter
{
    /// <summary>
    /// Main form
    /// </summary>
    public partial class _form : Form
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public _form()
        {
            InitializeComponent();
        }
        
        private void _btnStart_Click(object sender, EventArgs e)
        {
            string domain = _boxDomainName.Text; // "http://www.digizzle.com";
            string googleSitemap = _boxGoogleSitemap.Text;
            string aspSitemap = _boxAspSitemap.Text;
            
            StartProcessing(aspSitemap, domain, googleSitemap);
        }

        /// <summary>
        /// Starts the processing.
        /// </summary>
        /// <param name="aspSitemap">The ASP sitemap.</param>
        /// <param name="domain">The domain.</param>
        /// <param name="googleSitemap">The google sitemap.</param>
        internal void StartProcessing(string aspSitemap, string domain, string googleSitemap)
        {
            while (true)
            {
                if (!File.Exists(aspSitemap))
                {
                    MessageBox.Show("Cannot find the specified ASP.NET sitemap.", this.Text);
                    break;
                }

                if (File.Exists(googleSitemap))
                {
                    DialogResult res = MessageBox.Show(string.Format("File \'{0}\' already exists.{1}Do you want to overwrite it?",
                                                                     googleSitemap, Environment.NewLine),
                                                       "Warning", MessageBoxButtons.YesNo,
                                                       MessageBoxIcon.Warning,
                                                       MessageBoxDefaultButton.Button2);

                    if (DialogResult.Yes != res) break;
                }

                Converter converter = new Converter(domain);
                converter.Process(aspSitemap, googleSitemap);
                MessageBox.Show("Processing completed.", this.Text);
                break;
            }
        }

        private void _btnAspSitemap_Click(object sender, EventArgs e)
        {
            DialogResult res = _dlgOpenFile.ShowDialog();
            if (DialogResult.OK == res)
            {
                _boxAspSitemap.Text = _dlgOpenFile.FileName;
            }
        }

        private void _btnGoogleSitemap_Click(object sender, EventArgs e)
        {
            DialogResult res = _dlgSaveFile.ShowDialog();
            if (DialogResult.OK == res)
            {
                _boxGoogleSitemap.Text = _dlgSaveFile.FileName;
            }
        }

        private void _form_FormClosing(object sender, FormClosingEventArgs e)
        {
            Settings.Default.Save();
        }

        private void _linkDigizzle_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process.Start("http://www.digizzle.com?from=converter");
        }

        private void _form_Load(object sender, EventArgs e)
        {

        }
    }
}