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
using System.Windows.Forms;

namespace SitemapConverter
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static int Main(string[] args)
        {
            int exitCode = 0;
            if (args.Length >= 3)
            {
                try
                {
                    string aspSitemap = args[0];
                    string domain = args[1];
                    string googleSitemap = args[2];

                    Converter converter = new Converter(domain);
                    converter.Process(aspSitemap, googleSitemap);

                }
                catch (Exception ex)
                {
                    bool silent = false;
                    if (args.Length >= 4)
                    {
                        bool.TryParse(args[3], out silent);
                    }

                    if (! silent)
                    {
                        MessageBox.Show(ex.ToString(), "Converter", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                    exitCode = 1;
                }                
            }
            else
            {
                AppDomain.CurrentDomain.UnhandledException += new UnhandledExceptionEventHandler(CurrentDomain_UnhandledException);
                
                Application.EnableVisualStyles();
                Application.SetCompatibleTextRenderingDefault(false);

                _form form = new _form();
                Application.Run(form);
            }

            return exitCode;
        }

        static void CurrentDomain_UnhandledException(object sender, UnhandledExceptionEventArgs e)
        {
            if (e.ExceptionObject.GetType().Equals(typeof(System.Configuration.ConfigurationErrorsException)))
            {
                MessageBox.Show("Make sure there is \'SitemapConverter.exe.config\' near the executable." + 
                                Environment.NewLine + Environment.NewLine + e.ExceptionObject.ToString());
            }
            else
            {
                MessageBox.Show(e.ExceptionObject.ToString());
            }
        }
    }
}