using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Diagnostics;
using System.Xml;
using System.Xml.XPath;
using System.Net;
using System.Data.SqlClient;

namespace XMLDiagnosticsTool
{
    public partial class Form1 : Form
    {
        private string previousPath = "";
        private SqlConnection sqlCon;

        private int xmlProductionVolume;
        private int xmlfacilityReport;
        private int xmlActivity;
        private int xmlMethodUsed;
        private int xmlPollutantRelease = 0;
        private int xmlPollutantTransfer = 0;
        private int xmlWasteTransfer = 0;
        private int xmlWasteHandlerParty = 0;

        public Form1()
        {
            InitializeComponent();     
        }

        private void chooseXMLToolStripMenuItem_Click(object sender, EventArgs e)
        {
            openFileDialog1.ShowDialog();
        }

        private void supplyNamespace(XmlNamespaceManager xmlnsManager)
        {
            xmlnsManager.AddNamespace("rsm", "urn:eu:com:env:prtr:data:standard:2");
        }
        
        /*private void prepareXQuery(string query)
        {
            XmlDocument xDoc;
            XPathNavigator nav;
            XPathDocument docNav;

            try
            {
                this.Cursor = System.Windows.Forms.Cursors.WaitCursor;
                string strXMLFile = openFileDialog1.FileName;

                // Load the XML file.
                xDoc = new XmlDocument();
                xDoc.Load(@strXMLFile);
                docNav = new XPathDocument(@strXMLFile);
                previousPath = strXMLFile;
                nav = docNav.CreateNavigator();

                XmlNamespaceManager xmlnsManager = new XmlNamespaceManager(xDoc.NameTable);
                supplyNamespace(xmlnsManager);


                //This will hold the expressions resulting nodes.
                XmlNodeList resultList;

                //assign the query to the result nodelist
                if (!query.Equals(""))
                {
                    resultList = xDoc.SelectNodes(query, xmlnsManager);
                }
                else
                {
                    resultList = null;
                }

                if (resultList != null)
                {
                    if (resultList.Count == 0)
                    {
                        textBox1.Text = "No results found.";
                    }
                    else
                    {
                        textBox1.Text = "current results: \r\n";
                    }
                
                    foreach (XmlNode currentNode in resultList)
                    {
                        string s = "";
                        if (currentNode.Attributes.Count != 0)
                        {
                            foreach (XmlAttribute att in currentNode.Attributes)
                            {
                                s = "\tname: " + att.Name + " Value: " + att.Value + "\r\n";
                            }
                        }
                        textBox1.Text += currentNode.Name + " contains the attributes: \r\n " + s + "\tand contains the text: " + currentNode.InnerText.ToString() + "\r\n";
                    }
                }
                btnRerun.Enabled = true;
                button1.Enabled = true;
                this.Cursor = System.Windows.Forms.Cursors.Default;
            }

            catch (Exception ex)
            {
                this.Cursor = System.Windows.Forms.Cursors.Default;
                MessageBox.Show(ex.Message, "Error");
            }    
        } */

        private void openFileDialog1_FileOk(object sender, CancelEventArgs e)
        {
            tbChosen.Text = openFileDialog1.FileName;
            XmlDocument xDoc;
            XPathNavigator nav;
            XPathDocument docNav;

            try
            {
                this.Cursor = System.Windows.Forms.Cursors.WaitCursor;
                string strXMLFile = openFileDialog1.FileName;

                // Load the XML file.
                xDoc = new XmlDocument();
                xDoc.Load(@strXMLFile);
                docNav = new XPathDocument(@strXMLFile);
                previousPath = strXMLFile;
                nav = docNav.CreateNavigator();

                XmlNamespaceManager xmlnsManager = new XmlNamespaceManager(xDoc.NameTable);
                supplyNamespace(xmlnsManager);


                //This will hold the expressions resulting nodes.
                System.Xml.XmlNodeList resultList;

                textBox1.Text = "";

                //run queries
                resultList = xDoc.SelectNodes("//rsm:FacilityReport", xmlnsManager);
                textBox1.Text += resultList.Count + " count of Facility Rerports found. \r\n\r\n";
                xmlfacilityReport = resultList.Count;

                resultList = xDoc.SelectNodes("//rsm:ProductionVolume", xmlnsManager);
                textBox1.Text += "\t" + resultList.Count + " count of Production Volume entries found. \r\n";
                xmlProductionVolume = resultList.Count;

                resultList = xDoc.SelectNodes("//rsm:FacilityReport/rsm:PollutantRelease", xmlnsManager);
                textBox1.Text += "\t" + resultList.Count + " counts of pollutant releases found. \r\n";
                xmlPollutantRelease = resultList.Count;

                resultList = xDoc.SelectNodes("//rsm:FacilityReport/rsm:PollutantTransfer", xmlnsManager);
                textBox1.Text += "\t" + resultList.Count + " counts of pollutant transfers found. \r\n";
                xmlPollutantTransfer = resultList.Count;

                resultList = xDoc.SelectNodes("//rsm:FacilityReport/rsm:WasteTransfer", xmlnsManager);
                textBox1.Text += "\t" + resultList.Count + " counts of Waste transfers found. \r\n";
                xmlWasteTransfer = resultList.Count;

                resultList = xDoc.SelectNodes("//rsm:MethodUsed", xmlnsManager);
                textBox1.Text += "\t" + resultList.Count + " method used found. \r\n";
                xmlMethodUsed = resultList.Count;

                /*resultList = xDoc.SelectNodes("//rsm:Address", xmlnsManager);
                textBox1.Text += "\t" + resultList.Count + " Address found. \r\n";*/

                resultList = xDoc.SelectNodes("//rsm:WasteHandlerParty", xmlnsManager);
                textBox1.Text += "\t" + resultList.Count + " Waste Handler Party. \r\n";
                xmlWasteHandlerParty = resultList.Count;

                /*resultList = xDoc.SelectNodes("//rsm:CompetentAuthorityParty", xmlnsManager);
                textBox1.Text += "\t" + resultList.Count + " Competent Authority. \r\n";*/

                resultList = xDoc.SelectNodes("//rsm:Activity", xmlnsManager);
                textBox1.Text += "\t" + resultList.Count + " Activity count. \r\n";
                xmlActivity = resultList.Count;

                this.Cursor = System.Windows.Forms.Cursors.Default;
            }

            catch (Exception ex)
            {
                this.Cursor = System.Windows.Forms.Cursors.Default;
                MessageBox.Show(ex.Message, "Error");
            }    
        }

        private bool dbConnection(string securityString)
        {
            bool succes = false;
            if (securityString.Equals(""))
            {
                securityString = @"Data Source=SDKCGA6306;Initial Catalog=EPRTRmaster;" + "User ID=sa;Password=tmggis";
            }
            if (sqlCon == null)
            {
                try
                {
                    sqlCon = new SqlConnection(securityString);//Should be serverConnection instead of securityString
                    sqlCon.Open();
                    errorTextBox.Text = "connection opened";
                    succes = true;
                }
                catch (SqlException sqle)
                {
                    Debug.WriteLine("SQL ERROR: " + sqle.ToString());
                    errorTextBox.Text = ("SQL ERROR: " + sqle.ToString());
                }
            }
            else
            {
                Debug.WriteLine("\nConnection already established\n");
                errorTextBox.Text = ("SQL ERROR: Connection already established ");
            }
            return succes;
        }

        private SqlDataReader dbCommand(string sqlCommand)
        {
            if (!sqlCommand.Equals(""))
            {
                try
                {
                    SqlCommand sqlCom = new SqlCommand();

                    if (sqlCon.State.ToString().Equals("Closed"))
                    {
                        sqlCon.Open();
                    }
                    sqlCom.Connection = sqlCon;
                    sqlCom.CommandText = (sqlCommand);
                    SqlDataReader reader = sqlCom.ExecuteReader();
                    return reader;
                }
                catch (SqlException sqe)
                {
                    errorTextBox.Text = "SQL Command error: " + sqe.ToString();
                    return null;
                }
            }
            else
            {
                return null;
            }
        }

        private int singleCount(SqlDataReader reader)
        {
            int result = 0;
            while (reader.Read())
            {
                result = int.Parse(reader[0].ToString());
                
            }
            sqlCon.Close();
            reader.Close();
            return result;
        }

        private void btnSqlRun_Click(object sender, EventArgs e)
        {
            int dbProductionVolume = 0;
            int dbFacilityReport = 0;
            int dbActivity = 0;
            int dbMethodUsed = 0;
            int dbPollutantRelease = 0;
            int dbPollutantTransfer = 0;
            int dbWasteTransfer = 0;
            int dbWasteHandlerParty = 0;

            if (sqlCon == null)
            {
                dbConnection("");
            }

            

            /*----------------------------------------------------------*/
            /*-- Facility count compared to the latest imported data: --*/
            /*----------------------------------------------------------*/
            dbFacilityReport = singleCount(dbCommand("select count(*) from EPRTRmaster.dbo.FACILITYREPORT where PollutantReleaseAndTransferReportID = (select PollutantReleaseAndTransferReportID from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT where xmlReportID is not null)"));

            if (dbFacilityReport == xmlfacilityReport)
            {
                errorTextBox.Text = "Facility Report: OK \r\n\t Xml value: " + xmlfacilityReport + " \r\n\t database value: " + dbFacilityReport + "\r\n";
            }
            else
            {
                errorTextBox.Text = "Facility Report: FAILED!, \r\n\t Xml value: " + xmlfacilityReport + " \r\n\t database value: " + dbFacilityReport + "\r\n";
            }

            /*-------------------------------------------------------------*/
            /*-- Production Volume compared to the latest imported data: --*/
            /*-------------------------------------------------------------*/
            dbProductionVolume = singleCount(dbCommand("select count(*) from EPRTRmaster.dbo.PRODUCTIONVOLUME where xmlFacilityReportID is not null"));

            if (dbProductionVolume == xmlProductionVolume)
            {
                errorTextBox.Text += "Production Volume: OK \r\n\t Xml value: " + xmlProductionVolume + " \r\n\t database value: " + dbProductionVolume + "\r\n";
            }
            else
            {
                errorTextBox.Text += "Production Volume: FAILED! \r\n\t Xml value: " + xmlProductionVolume + " \r\n\t database value: " + dbProductionVolume + "\r\n";
            }

            /*-------------------------------------------------------------------*/
            /*-- Pollutant Release count compared to the latest imported data: --*/
            /*-------------------------------------------------------------------*/
            dbPollutantRelease = singleCount(dbCommand("select count(*) from EPRTRmaster.dbo.POLLUTANTRELEASE where FacilityReportID in (select facilityreportid from EPRTRmaster.dbo.FACILITYREPORT where PollutantReleaseAndTransferReportID = (select PollutantReleaseAndTransferReportID from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT where xmlReportID is not null))"));
            if (dbPollutantRelease == xmlPollutantRelease)
            {
                errorTextBox.Text += "Pollutant Release: OK \r\n\t Xml value: " + xmlPollutantRelease + " \r\n\t database value: " + dbPollutantRelease + "\r\n";
            }
            else
            {
                errorTextBox.Text += "Pollutant Release: FAILED!, \r\n\t Xml value: " + xmlPollutantRelease + " \r\n\t database value: " + dbPollutantRelease + "\r\n";
            }

            /*--------------------------------------------------------------------*/
            /*-- Pollutant Transfer count compared to the latest imported data: --*/
            /*--------------------------------------------------------------------*/
            dbPollutantTransfer = singleCount(dbCommand("select count(*) from EPRTRmaster.dbo.POLLUTANTTRANSFER where FacilityReportID in (select facilityreportid from EPRTRmaster.dbo.FACILITYREPORT where PollutantReleaseAndTransferReportID = (select PollutantReleaseAndTransferReportID from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT where xmlReportID is not null))"));
            if (dbPollutantTransfer == xmlPollutantTransfer)
            {
                errorTextBox.Text += "Pollutant Transfer: OK \r\n\t Xml value: " + xmlPollutantTransfer + " \r\n\t database value: " + dbPollutantTransfer + "\r\n";
            }
            else
            {
                errorTextBox.Text += "Pollutant Transfer: FAILED!, \r\n\t Xml value: " + xmlPollutantTransfer + " \r\n\t database value: " + dbPollutantTransfer + "\r\n";
            }

            /*----------------------------------------------------------------*/
            /*-- Waste Transfer count compared to the latest imported data: --*/
            /*----------------------------------------------------------------*/
            dbWasteTransfer = singleCount(dbCommand("select count(*) from EPRTRmaster.dbo.WASTETRANSFER where FacilityReportID in (select facilityreportid from EPRTRmaster.dbo.FACILITYREPORT where PollutantReleaseAndTransferReportID = (select PollutantReleaseAndTransferReportID from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT where xmlReportID is not null))"));
            if (dbWasteTransfer == xmlWasteTransfer)
            {
                errorTextBox.Text += "Waste Transfer: OK \r\n\t Xml value: " + xmlWasteTransfer + " \r\n\t database value: " + dbWasteTransfer + "\r\n";
            }
            else
            {
                errorTextBox.Text += "Waste Transfer: FAILED!, \r\n\t Xml value: " + xmlWasteTransfer + " \r\n\t database value: " + dbWasteTransfer + "\r\n";
            }

            

            /*------------------------------------------------------------*/
            /*-- MethodUsed count compared to the latest imported data: --*/
            /*------------------------------------------------------------*/
            dbMethodUsed = singleCount(dbCommand("select count(*) from EPRTRmaster.dbo.METHODUSED where MethodListID in (select MethodListID from EPRTRmaster.dbo.POLLUTANTTRANSFER where FacilityReportID in (select facilityreportid from EPRTRmaster.dbo.FACILITYREPORT where PollutantReleaseAndTransferReportID = (select PollutantReleaseAndTransferReportID from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT where xmlReportID is not null))) or MethodListID in (select MethodListID from EPRTRmaster.dbo.POLLUTANTRELEASE where FacilityReportID in (select facilityreportid from EPRTRmaster.dbo.FACILITYREPORT where PollutantReleaseAndTransferReportID = (select PollutantReleaseAndTransferReportID from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT where xmlReportID is not null))) or MethodListID in (select MethodListID from EPRTRmaster.dbo.WASTETRANSFER where FacilityReportID in (select facilityreportid from EPRTRmaster.dbo.FACILITYREPORT where PollutantReleaseAndTransferReportID = (select PollutantReleaseAndTransferReportID from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT where xmlReportID is not null)))"));
            if (dbMethodUsed == xmlMethodUsed)
            {
                errorTextBox.Text += "MethodUsed: OK \r\n\t Xml value: " + xmlMethodUsed + " \r\n\t database value: " + dbMethodUsed + "\r\n";
            }
            else
            {
                errorTextBox.Text += "MethodUsed: FAILED!, \r\n\t Xml value: " + xmlMethodUsed + " \r\n\t database value: " + dbMethodUsed + "\r\n";
            }

            /*---------------------------------------------------------------------*/
            /*-- Waste Handler Party count compared to the latest imported data: --*/
            /*---------------------------------------------------------------------*/
            dbWasteHandlerParty = singleCount(dbCommand("select count(*) from EPRTRmaster.dbo.WASTEHANDLERPARTY where xmlWasteTransferID is not null"));
            if (dbWasteHandlerParty == xmlWasteHandlerParty)
            {
                errorTextBox.Text += "Waste Handler Party: OK \r\n\t Xml value: " + xmlWasteHandlerParty + " \r\n\t database value: " + dbWasteHandlerParty + "\r\n";
            }
            else
            {
                errorTextBox.Text += "Waste Handler Party: FAILED!, \r\n\t Xml value: " + xmlWasteHandlerParty + " \r\n\t database value: " + dbWasteHandlerParty + "\r\n";
            }

            /*----------------------------------------------------------*/
            /*-- Activity count compared to the latest imported data: --*/
            /*----------------------------------------------------------*/
            dbActivity = singleCount(dbCommand("select count(*) from EPRTRmaster.dbo.ACTIVITY where FacilityReportID in (select facilityreportid from EPRTRmaster.dbo.FACILITYREPORT where PollutantReleaseAndTransferReportID = (select PollutantReleaseAndTransferReportID from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT where xmlReportID is not null))"));
            if (dbActivity == xmlActivity)
            {
                errorTextBox.Text += "Activity: OK \r\n\t Xml value: " + xmlActivity + " \r\n\t database value: " + dbActivity + "\r\n";
            }
            else
            {
                errorTextBox.Text += "Activity: FAILED!, \r\n\t Xml value: " + xmlActivity + " \r\n\t database value: " + dbActivity + "\r\n";
            }
             
        }

        private void tbChosen_TextChanged(object sender, EventArgs e)
        {
            btnSqlRun.Enabled = true;
        }

    }
}
