//
// xliff_outConsole.cs
//
// This file was generated by MapForce 2008r2sp1.
//
// YOU SHOULD NOT MODIFY THIS FILE, BECAUSE IT WILL BE
// OVERWRITTEN WHEN YOU RE-RUN CODE GENERATION.
//
// Refer to the MapForce Documentation for further details.
// http://www.altova.com/mapforce
//

using System;
using System.Collections;
using System.Data;
using Altova.Types;
//using Altova.Functions;

namespace xliff_out
{
	public class xliff_outConsole 
	{

		public static void Main(string[] args) 
		{
			Console.Out.WriteLine("xliff_out Application");
			
			try 
			{
				TraceTargetConsole ttc = new TraceTargetConsole();
				xliff_outMapToxliff_core_1_2_transitional xliff_outMapToxliff_core_1_2_transitionalObject = new xliff_outMapToxliff_core_1_2_transitional();
				xliff_outMapToxliff_core_1_2_transitionalObject.RegisterTraceTarget(ttc);
	

				// run mapping
				//
				// you have different options to provide mapping input and output:
				//
				// files using file names (available for XML, text, and Excel):
				//   Altova.IO.FileInput(string filename)
				//   Altova.IO.FileOutput(string filename)
				//
				// streams (available for XML, text, and Excel):
				//   Altova.IO.StreamInput(System.IO.Stream stream)
				//   Altova.IO.StreamOutput(System.IO.Stream stream)
				//
				// strings (available for XML and text):
				//   Altova.IO.StringInput(string content)
				//   Altova.IO.StringOutput(StringBuilder content)
				//
				// Java IO reader/writer (available for XML and text):
				//   Altova.IO.ReaderInput(System.IO.TextReader reader)
				//   Altova.IO.WriterOutput(System.IO.TextWriter writer)
				//
				// DOM documents (for XML only):
				//   Altova.IO.DocumentInput(System.Xml.XmlDocument document)
				//   Altova.IO.DocumentOutput(System.Xml.XmlDocument document)
				// 
				// By default, Run will close all inputs and outputs. If you do not want this,
				// set the following property:
				// xliff_outMapToxliff_core_1_2_transitionalObject.CloseObjectsAfterRun = false;
				
				{
					Altova.IO.Output xliff_core_1_2_transitional2Target = new Altova.IO.FileOutput("C:/EIONET/CMS_XLIFF/xliff_out/testatkins_utf8.xlf");

					xliff_outMapToxliff_core_1_2_transitionalObject.Run(
					"Provider=SQLOLEDB.1; Data Source=sdkcga6306; User ID=gis;Password=tmggis;Initial Catalog=EPRTRcms;Persist Security Info=true;Auto Translate=false;Tag with column collation=false;Use Encryption for Data=false;Mars_Connection=no;",
					xliff_core_1_2_transitional2Target);
				}




				Console.Out.WriteLine("Finished");
			} 
			catch (Altova.UserException ue)
			{
				Console.Out.Write("USER EXCEPTION: ");
				Console.Out.WriteLine( ue.Message );
				System.Environment.Exit(1);
			}
			catch (Exception e) 
			{
				Console.Out.Write("ERROR: ");
				Console.Out.WriteLine( e.Message );
				Console.Out.WriteLine( e.StackTrace );
				System.Environment.Exit(1);
			}
		}
	}


	class TraceTargetConsole : Altova.TraceTarget {
		public void WriteTrace(string info) {
			Console.Out.WriteLine(info);
		}
	}
}
