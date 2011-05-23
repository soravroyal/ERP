using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using EPRTR.Localization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using System.Globalization;
//using EPRTRT.DataContracts;

namespace EPRTR.Charts
{
    /// <summary>
    /// Functions for display of Flex Charts
    /// </summary>
    /// 
    public static class ChartsUtils
    {

        public enum AreaType { Soil, Air, Water };
        private static string lang = CultureInfo.CurrentCulture.TwoLetterISOLanguageName;


        #region Chart File names
        private const string CHART_FOLDER = "Charts";
        public const string PollutantTransferPieChart = "PollutantTransferPieChart";
        public const string IndustrialActivityPieChart = "IndustrialActivityPieChart";
        public const string WasteTransferBubbleChart = "WasteTransferBubbleChart2";
        public const string WasteTransferAreaComparisonChart = "WasteTransferBarChart";
        public const string PolluntantReleaseAreaComparisonChart = "PollutantReleaseBarChart";
        public const string PolluntantTransferAreaComparisonChart = "PollutantTransferAreaComparison";
        #endregion

        #region Div names
        private const string WasteTransferTransboundHazardousDiv = "piechart";
        private const string PollutantTransferSummaryDiv = "piechart";
        private const string IndustrialWasteSummeryDiv = "piechart";
        #endregion


        #region Clientside script calls
        /// <summary>
        /// Waste Transfer Area Comparison
        /// </summary>
        /// <param name="swfFile"></param>
        /// <param name="data">WasteTransfers.WasteActivitiesAreaRow</param>
        /// <param name="panel"></param>
        /// <param name="uniqueId"></param>
        /// <param name="myHeight"></param>
        public static void ChartClientScript(string swfFile, List<WasteTransfers.AreaComparison> data, Panel panel, string uniqueId, string chartLabel, int myHeight)
        {
            //Dynamically set value of chart height.
            int legendHeight = 150;
            int height = legendHeight + (60 * myHeight);
            string Encoded = MakeJSONData(PopulateChartDataContract(data));
            
            string text = String.Empty;
            string EncodedText = MakeJSONText(PopulateWTChartText(text));
            string myCSS = string.Empty; //not used.
            string explanation = String.Empty;
            string script = String.Format("BarChart(\"{0}\",\"{1}\", \"{2}\", \"{3}\", \"{4}\", \"{5}\" , \"{6}\");", chartLabel, Encoded, SwfFileLocation(swfFile), "barchart", myCSS, height, EncodedText);
            ScriptManager.RegisterClientScriptBlock(panel, typeof(string), swfFile + uniqueId, script, true);
        }

        private static EPRTRT.DataContracts.LangCollection PopulateWTChartText(string text)
        {

            EPRTRT.DataContracts.LangCollection lang = new EPRTRT.DataContracts.LangCollection();

            var DOUBLE_COUNTING_TOTAL = new EPRTRT.DataContracts.Lang();
            var DISPOSAL_COUNTING_TOTAL = new EPRTRT.DataContracts.Lang();
            var RECOVERY_COUNTING_TOTAL = new EPRTRT.DataContracts.Lang();
            var UNSPECIFIED_COUNTING_TOTAL = new EPRTRT.DataContracts.Lang();

            var TOTAL = new EPRTRT.DataContracts.Lang();
            var DISPOSAL = new EPRTRT.DataContracts.Lang();
            var RECOVERY = new EPRTRT.DataContracts.Lang();
            var UNSPECIFIED = new EPRTRT.DataContracts.Lang();

            DOUBLE_COUNTING_TOTAL.Key = "DOUBLE_COUNTING_TOTAL";
            DOUBLE_COUNTING_TOTAL.Word = Resources.GetGlobal("ChartLabels", "DOUBLE_COUNTING_TOTAL");
            lang.Add(DOUBLE_COUNTING_TOTAL);

            TOTAL.Key = "TOTAL";
            TOTAL.Word = Resources.GetGlobal("ChartLabels", "TOTAL");
            lang.Add(TOTAL);

            DISPOSAL_COUNTING_TOTAL.key = "DISPOSAL_COUNTING_TOTAL";
            DISPOSAL_COUNTING_TOTAL.Word = Resources.GetGlobal("ChartLabels", "DISPOSAL_COUNTING_TOTAL");
            lang.Add(DISPOSAL_COUNTING_TOTAL);

            DISPOSAL.Key = "DISPOSAL";
            DISPOSAL.Word = Resources.GetGlobal("ChartLabels", "DISPOSAL");
            lang.Add(DISPOSAL);

            RECOVERY_COUNTING_TOTAL.Key = "RECOVERY_COUNTING_TOTAL";
            RECOVERY_COUNTING_TOTAL.Word = Resources.GetGlobal("ChartLabels", "RECOVERY_COUNTING_TOTAL");
            lang.Add(RECOVERY_COUNTING_TOTAL);

            RECOVERY.Key = "RECOVERY";
            RECOVERY.Word = Resources.GetGlobal("ChartLabels", "RECOVERY");
            lang.Add(RECOVERY);

            UNSPECIFIED_COUNTING_TOTAL.key = "UNSPECIFIED_COUNTING_TOTAL";
            UNSPECIFIED_COUNTING_TOTAL.Word = Resources.GetGlobal("ChartLabels", "UNSPECIFIED_COUNTING_TOTAL");
            lang.Add(UNSPECIFIED_COUNTING_TOTAL);

            UNSPECIFIED.Key = "UNSPECIFIED";
            UNSPECIFIED.Word = Resources.GetGlobal("ChartLabels", "UNSPECIFIED");
            lang.Add(UNSPECIFIED);

            return lang;
            
        }

        private static EPRTRT.DataContracts.LangCollection PopulateWTTHChartText()
        {

            EPRTRT.DataContracts.LangCollection lang = new EPRTRT.DataContracts.LangCollection();

            var FROM_COUNTRY = new EPRTRT.DataContracts.Lang();
            var TO_COUNTRY = new EPRTRT.DataContracts.Lang();

            FROM_COUNTRY.Key = "FROM_COUNTRY";
            FROM_COUNTRY.Word = Resources.GetGlobal("ChartLabels", "FROM_COUNTRY");
            lang.Add(FROM_COUNTRY);

            TO_COUNTRY.Key = "TO_COUNTRY";
            TO_COUNTRY.Word = Resources.GetGlobal("ChartLabels", "TO_COUNTRY");
            lang.Add(TO_COUNTRY);
            return lang;

        }

        /// <summary>
        /// Polluntant Transfer Comparision
        /// </summary>
        /// <param name="swfFile">Use the public CONST from this class</param>
        /// <param name="data">PollutantTransfers.AreaComparison</param>
        /// <param name="updatePanel"></param>
        /// <param name="uniqueId">Recommended use: this.UniqueId.ToString()</param>
        /// <param name="type">EPRTR.Charts.AreaType</param>
        ///         
        public static void ChartClientScript(string swfFile, string chartLabel, List<PollutantTransfers.AreaComparison> data, Panel updatePanel, string uniqueId, AreaType type, int count)
        {
            string Encoded = MakeJSONData(PopulateChartDataContract(data));
            int height = ChartHeight(count);
                        
            //function BarChart(myLabel, myData, swfFile, div, myCSS, myHeight) //6 params
            string script = String.Format("BarChart(\"{0}\",\"{1}\", \"{2}\", \"{3}\", \"{4}\", \"{5}\");", chartLabel, Encoded, SwfFileLocation(swfFile), "barchart", type.ToString().ToLower(), height);
            ScriptManager.RegisterClientScriptBlock(updatePanel, typeof(string), swfFile + uniqueId, script, true);
        }

        private static int ChartHeight(int count)
        {
            int legendHeight = 20;
            int barHeight = 25;
            int generalPadding = 100;
            int height = (count * barHeight) + legendHeight + generalPadding;
            return height;
        }


        
        /// <summary>
        /// Polluntant Release Comparision
        /// </summary>
        /// <param name="swfFile">Use the public CONST from this class</param>
        /// <param name="data">AreaComparison</param>
        /// <param name="updatePanel"></param>
        /// <param name="uniqueId">Recommended use: this.UniqueId.ToString()</param>
        /// <param name="type">EPRTR.Charts.AreaType</param>
        ///         
        public static void ChartClientScript(string swfFile, string chartLabel, List<PollutantReleases.AreaComparison> data, Panel updatePanel, string uniqueId, AreaType type, int count)
        {
            string Encoded = MakeJSONData(PopulateChartDataContract(data));
            string script = String.Format("BarChart(\"{0}\",\"{1}\", \"{2}\", \"{3}\", \"{4}\", \"{5}\");", chartLabel, Encoded, SwfFileLocation(swfFile), "barchart", type.ToString().ToLower(), ChartHeight(count));
            ScriptManager.RegisterClientScriptBlock(updatePanel, typeof(string), swfFile + uniqueId, script, true);
        }
       


        /// <summary>
        /// Standard piechart: takes a single data input.
        /// </summary>
        /// <param name="swfFile">Use the public CONST from this class</param>
        /// <param name="data"></param>
        /// <param name="updatePanel"></param>
        /// <param name="uniqueId">Recommended use: this.UniqueId.ToString()</param>
        public static void ChartClientScript(string swfFile, List<Summary.WastePieChart> data, Panel updatePanel, string uniqueId)
        {
            string Encoded = MakeJSONData(PopulateChartDataContract(data));
            string script = String.Format("CreatePieChart(\"{0}\", \"{1}\", \"{2}\", \"{3}\");", Encoded, SwfFileLocation(swfFile), swfFile, data.Count);
            ScriptManager.RegisterClientScriptBlock(updatePanel, typeof(string), swfFile + uniqueId, script, true);
        }

        /// <summary>
        /// For Bubble chart
        /// </summary>
        /// <param name="swfFile">Use the public CONST from this class</param>
        /// <param name="data"></param>
        /// <param name="updatePanel"></param>
        /// <param name="uniqueId">Recommended use: this.UniqueId.ToString()</param>
        public static void ChartClientScript(string swfFile, IEnumerable<WasteTransfers.TransboundaryHazardousWasteData> data, Panel updatePanel, string uniqueId)
        {
            string Encoded = MakeJSONData(PopulateBubblechartDataContract(data));
            string EncodedText = MakeJSONText(PopulateWTTHChartText());
            string script = String.Format("CreatePieChart(\"{0}\",\"{1}\", \"{2}\", \"{3}\" , \"{4}\");", Encoded, SwfFileLocation(swfFile), swfFile, 0, EncodedText);
            ScriptManager.RegisterClientScriptBlock(updatePanel, typeof(string), swfFile + uniqueId, script, true);
        }

        /// <summary>
        /// Used for Pollutant Transfer Summary
        /// </summary>
        public static void ChartClientScript(string swfFile, List<Summary.Quantity> data, Panel updatePanel, string uniqueId)
        {
            string Encoded = MakeJSONData(PopulateChartDataContract(data));
            string script = String.Format("CreatePieChart(\"{0}\", \"{1}\", \"{2}\", \"{3}\");", Encoded, SwfFileLocation(swfFile), PollutantTransferSummaryDiv, data.Count);
            ScriptManager.RegisterClientScriptBlock(updatePanel, typeof(string), swfFile + uniqueId, script, true);
        }


        /// <summary>
        /// IndustrialActivityPieChart: Charts that take take two data inputs. 
        /// </summary>
        /// <param name="swfFile">Use the public CONST from this class</param>
        /// <param name="EncodedNonHazardous"></param>
        /// <param name="EncodedHazardous"></param>
        /// <param name="updatePanel"></param>
        /// <param name="uniqueId">Recommended use: this.UniqueId.ToString()</param>
        /// 
        
        public static void ChartClientScript(string swfFile, List<Summary.WastePieChart> nonHazardous, List<Summary.WastePieChart> hazardous, Panel updatePanel, string uniqueId, string[] labels)
        {
            //If the respective list is empty then set its label to an empty string
            if (nonHazardous.Count == 0)
            {
                labels[0] = string.Empty;
            }
            if (hazardous.Count == 0)
            {
                labels[1] = string.Empty;
            }
            //string div = "wasteTransferSummeryPiechart";
            string EncodedNonHazardous = MakeJSONData(PopulateChartDataContract(nonHazardous));
            string EncodedHazardous = MakeJSONData(EPRTR.Charts.ChartsUtils.PopulateChartDataContract(hazardous));
            string soilScript = String.Format("IndustrialActivityPieChart(\"{0}\",\"{1}\", \"{2}\", \"{3}\",  \"{4}\",  \"{5}\");", EncodedHazardous, EncodedNonHazardous, SwfFileLocation(swfFile), IndustrialWasteSummeryDiv, labels[0], labels[1]);
            ScriptManager.RegisterClientScriptBlock(updatePanel, typeof(string), swfFile + uniqueId, soilScript, true);
        }
        
        
        
        #endregion

        #region JSONize

        /// <summary>
        /// Waste Transfer Area Comparison.  Chart data is formated into JSON then encoded into Base64
        /// </summary>
        private static string MakeJSONText(EPRTRT.DataContracts.LangCollection languageCollection)
        {
            string output = JsonConvert.SerializeObject(languageCollection);
           
            byte[] encData_byte = new byte[output.Length];
            encData_byte = System.Text.Encoding.UTF8.GetBytes(output);
            string encodedData = Convert.ToBase64String(encData_byte);
            return encodedData;
        }


        /// <summary>
        /// Waste Transfer Area Comparison.  Chart data is formated into JSON then encoded into Base64
        /// </summary>
        private static string MakeJSONData(EPRTRT.DataContracts.WasteTransferAreaCollection myWasteTransfer)
        {
            string output = JsonConvert.SerializeObject(myWasteTransfer);

            byte[] encData_byte = new byte[output.Length];
            encData_byte = System.Text.Encoding.UTF8.GetBytes(output);
            string encodedData = Convert.ToBase64String(encData_byte);
            return encodedData;
        }

        /// <summary>
        /// Chart data is formated into JSON then encoded into Base64
        /// </summary>
        private static string MakeJSONData(EPRTRT.DataContracts.WasteTransfers myWasteTransfer)
        {
            string output = JsonConvert.SerializeObject(myWasteTransfer);

            byte[] encData_byte = new byte[output.Length];
            encData_byte = System.Text.Encoding.UTF8.GetBytes(output);
            string encodedData = Convert.ToBase64String(encData_byte);
            return encodedData;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="myWasteTransfer"></param>
        /// <returns></returns>
        private static string MakeJSONData(EPRTRT.DataContracts.WasteTransferBoundaries myWasteTransfer)
        {
            string output = JsonConvert.SerializeObject(myWasteTransfer);
            
            byte[] encData_byte = new byte[output.Length];
            encData_byte = System.Text.Encoding.UTF8.GetBytes(output);
            string encodedData = Convert.ToBase64String(encData_byte);
            return encodedData;
        }
        

        #endregion

        #region Populate Datacontracts


        private static double? GetPercent(double? total, double? totalCount) 
        {
            if (!totalCount.HasValue || totalCount == 0.0)
            {
                return null;
            }

            return (total / totalCount) * 100;
        }
        /// <summary>
        /// Waste Transfer Area Comparison
        /// </summary>
        private static EPRTRT.DataContracts.WasteTransferAreaCollection PopulateChartDataContract(List<QueryLayer.WasteTransfers.AreaComparison> waste)
        {
            EPRTRT.DataContracts.WasteTransferAreaCollection myWTAC = new EPRTRT.DataContracts.WasteTransferAreaCollection();

            foreach (var item in waste)
            {
                EPRTRT.DataContracts.WasteTransferAreaComparison myWTA = new EPRTRT.DataContracts.WasteTransferAreaComparison();
                myWTA.Area = item.Area;
                myWTA.Facilities = item.Facilities.ToString();
                myWTA.TotalCount = convertToString(item.TotalCount); 

                myWTA.Disposal = convertToString(item.Disposal);
                myWTA.Recovery = convertToString(item.Recovery);
                myWTA.Total = convertToString(item.Total);
                myWTA.Unspecified = convertToString(item.Unspecified);

                //Double counting
                myWTA.DisposalAnnexI = convertToString(item.DisposalAnnexI);
                myWTA.RecoveryAnnexI = convertToString(item.RecoveryAnnexI);
                myWTA.UnspecifiedAnnexI = convertToString(item.UnspecifiedAnnexI);
                myWTA.TotalAnnexI = convertToString(item.TotalAnnexI);
                
                //Get Percentages - normal and Double count. Normal is reduced with double counting parts sincebars will be stacked.
                double? reducedDisposal = removeDoubleCounting(item.Disposal, item.DisposalAnnexI);
                double? reducedRecovery = removeDoubleCounting(item.Recovery, item.RecoveryAnnexI);
                double? reducedUnspec = removeDoubleCounting(item.Unspecified, item.UnspecifiedAnnexI);
                double? reducedTotal = removeDoubleCounting(item.Total, item.TotalAnnexI);
                
                myWTA.DisposalPercentage = convertToString(GetPercent(reducedDisposal, item.TotalCount));
                myWTA.DisposalAnnexIPercentage = convertToString(GetPercent(item.DisposalAnnexI, item.TotalCount));
                    //Recovery
                myWTA.RecoveryPercentage = convertToString(GetPercent(reducedRecovery, item.TotalCount));
                myWTA.RecoveryAnnexIPercentage = convertToString(GetPercent(item.RecoveryAnnexI, item.TotalCount));
                    //Total
                myWTA.TotalPercentage = convertToString(GetPercent(reducedTotal, item.TotalCount));
                myWTA.TotalAnnexIPercentage = convertToString(GetPercent(item.TotalAnnexI, item.TotalCount));
                    //Unspecified
                myWTA.UnspecifiedPercentage = convertToString(GetPercent(reducedUnspec, item.TotalCount));
                myWTA.UnspecifiedAnnexIPercentage = convertToString(GetPercent(item.UnspecifiedAnnexI, item.TotalCount));

                myWTAC.Add(myWTA);
            }
            return myWTAC;
        }

        private static double? removeDoubleCounting(double? value, double? doubleCounting)
        {
            if (!value.HasValue)
            {
                return value;
            }

            if (!doubleCounting.HasValue)
            {
                return value;
            }

            return value.Value - doubleCounting.Value;

        }

        /// <summary>
        /// Poluntant Release Area Comparison
        /// </summary>
        private static EPRTRT.DataContracts.WasteTransfers PopulateChartDataContract(List<PollutantTransfers.AreaComparison> waste)
        {
            EPRTRT.DataContracts.WasteTransfers myWasteTransfer = new EPRTRT.DataContracts.WasteTransfers();
            foreach (var myWaste in waste)
            {
                EPRTRT.DataContracts.WasteTransfer wt = new EPRTRT.DataContracts.WasteTransfer();
                //wt.Total = myWaste.Percent.ToString().Replace(",", ".");
                wt.Total = myWaste.Quantity.ToString().Replace(",", ".");
                wt.DoubleCounting = myWaste.Quantity.ToString().Replace(",", ".");
                wt.Facilities = myWaste.Facilities.ToString().Replace(",", ".");
                wt.PercentEUTotal = myWaste.Percent.ToString().Replace(",", ".");
                wt.FromCountry = myWaste.Area;
                myWasteTransfer.Add(wt);
            }
            return myWasteTransfer;
        }



        /// <summary>
        /// Poluntant Release Area Comparison
        /// </summary>
        private static EPRTRT.DataContracts.WasteTransfers PopulateChartDataContract(List<PollutantReleases.AreaComparison> waste)
        {
            EPRTRT.DataContracts.WasteTransfers myWasteTransfer = new EPRTRT.DataContracts.WasteTransfers();
            foreach (var myWaste in waste)
            {
                EPRTRT.DataContracts.WasteTransfer wt = new EPRTRT.DataContracts.WasteTransfer();
                //wt.Total = myWaste.Percent.ToString().Replace(",", ".");
                wt.Total = myWaste.Percent.ToString().Replace(",",".");
                wt.DoubleCounting = myWaste.Quantity.ToString().Replace(",", ".");
                wt.Facilities = myWaste.Facilities.ToString().Replace(",", ".");
                wt.FromCountry = myWaste.Area;
                myWasteTransfer.Add(wt);
            }
            return myWasteTransfer;
        }



        /// <summary>
        /// PopulateChartDataContract
        /// </summary>
        private static EPRTRT.DataContracts.WasteTransfers PopulateChartDataContract(List<Summary.WastePieChart> waste)
        {
            EPRTRT.DataContracts.WasteTransfers myWasteTransfer = new EPRTRT.DataContracts.WasteTransfers();
            foreach (var myWaste in waste)
            {
                EPRTRT.DataContracts.WasteTransfer wt = new EPRTRT.DataContracts.WasteTransfer();
                wt.Total = myWaste.Percent.ToString().Replace(",", ".");
                wt.FromCountry = myWaste.Text;
                wt.Id = myWaste.Id;
                

                
                myWasteTransfer.Add(wt);
            }
            return myWasteTransfer;
        }

        /// <summary>
        /// Used for Pollantant Transfer Summary
        /// </summary>
        /// <param name="air"></param>
        /// <returns></returns>
        private static EPRTRT.DataContracts.WasteTransfers PopulateChartDataContract(List<Summary.Quantity> air)
        {
            EPRTRT.DataContracts.WasteTransfers myWasteTransfer = new EPRTRT.DataContracts.WasteTransfers();
            myWasteTransfer = new EPRTRT.DataContracts.WasteTransfers();
            foreach (var myAir in air)
            {
                EPRTRT.DataContracts.WasteTransfer wt = new EPRTRT.DataContracts.WasteTransfer();
                wt.Total = myAir.QuantityValue.ToString().Replace(",",".");
                wt.FromCountry = myAir.Name;
                myWasteTransfer.Add(wt);
            }
            return myWasteTransfer;
        }

        
        

        /// <summary>
        /// Used on the Bubblechart
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        private static EPRTRT.DataContracts.WasteTransferBoundaries PopulateBubblechartDataContract(IEnumerable<WasteTransfers.TransboundaryHazardousWasteData> data)
        {
            IEnumerable<WasteTransfers.TransboundaryHazardousWasteData> bubbleData = prepareBubblechartData(data);

            EPRTRT.DataContracts.WasteTransferBoundaries myWasteTransferBoundaries = new EPRTRT.DataContracts.WasteTransferBoundaries();
            foreach (var item in bubbleData)
            {
                //translate toCountry name for "other"
                string toCountry = item.TransferTo;
                if (WasteTransfers.TransboundaryHazardousWasteData.OTHER.Equals(toCountry))
                {
                    toCountry = LOVResources.CountryName(toCountry);
                }

                EPRTRT.DataContracts.WasteTransferBoundary myWasteTB = new EPRTRT.DataContracts.WasteTransferBoundary()
                {
                    FromCountry = item.TransferFrom,
                    ToCountry = toCountry,
                    DoubleCounting = item.TransferTo, //doubleCounting is used to hold the code of the receiving country
                    Total = convertToString(item.Total),
                    Facilities = item.Facilities.ToString(),
                    Recovery = convertToString (item.Recovery),
                    Disposal = convertToString (item.Disposal),
                    Name = LOVResources.CountryName(item.TransferTo),
                    PercentEUTotal = convertToString(item.UnSpecified) //PercentEUTotal is used for transferring the unspecified
                    
                };



                myWasteTransferBoundaries.Add(myWasteTB);
            }

            return myWasteTransferBoundaries;
        }

        private static List<WasteTransfers.TransboundaryHazardousWasteData> prepareBubblechartData(IEnumerable<WasteTransfers.TransboundaryHazardousWasteData> data)
        {
            List<WasteTransfers.TransboundaryHazardousWasteData> result = new List<WasteTransfers.TransboundaryHazardousWasteData>();

            result.AddRange(data);

            //Add one dummy row for each E-PRTR country - to make sure all reporting countries are always represented in the grid
            IEnumerable<WasteTransfers.TransboundaryHazardousWasteData> dummies = ListOfValues.ReportingCountries()
                                                                   .OrderBy(x => x.Code)
                                                                   .Select(v => new WasteTransfers.TransboundaryHazardousWasteData()
                                                                   {
                                                                       TransferTo = v.Code,
                                                                   });
            result.AddRange(dummies);

            //Add dummy row for other countries (i.e. countries outside E-PRTR)
            WasteTransfers.TransboundaryHazardousWasteData other = new WasteTransfers.TransboundaryHazardousWasteData();
            other.TransferTo = WasteTransfers.TransboundaryHazardousWasteData.OTHER;

            
            result.Add(other);

            return result;

        }

        private static string convertToString(double? number)
        {
            if (!number.HasValue)
            {
                return "-";
            }
            else
            {
                double n = (double)number;

                CultureInfo culture = CultureInfo.CreateSpecificCulture("EN");
                return n.ToString(culture);
            }
            //item.Total.ToString().Replace(",", "."),
        }
        #endregion


        #region show piecharts
        public static void ShowWastePieCharts(IEnumerable<Summary.WasteSummaryTreeListRow> data, Panel chartPanel, string uniqueId)
        {
            List<Summary.WastePieChart> nonhazardous = WasteTransfers.GetPieChartNonHazardous(data);
            List<Summary.WastePieChart> hazardous = WasteTransfers.GetPieChartHazardous(data);

            // update chart if data is present
            bool hasCount = nonhazardous.Count != 0 || hazardous.Count != 0;
            bool hasValues = hazardous.Sum(x => x.Percent) > 0.0 || nonhazardous.Sum(x => x.Percent) > 0.0;

            if (hasCount && hasValues)
            {
                // translate data for first (left) piechart
                foreach (var v in nonhazardous)
                {
                    v.Id = v.Text;
                    v.Text = Resources.GetGlobal("WasteTransfers", v.Text);
                    
                }

                // translate data for second (right) piechart
                foreach (var v in hazardous)
                {
                    v.Id = v.Text;
                    v.Text = Resources.GetGlobal("WasteTransfers", v.Text);
                    
                }

                string sNoHazardouswaste = Resources.GetGlobal("Common", "NoHazardouswaste");
                string sHazardousWwaste = Resources.GetGlobal("Common", "HazardousWwaste");
                string[] labels = { sNoHazardouswaste, sHazardousWwaste };

                // add piechart if we have any data
                chartPanel.Visible = true;
                string swfFile = EPRTR.Charts.ChartsUtils.IndustrialActivityPieChart;
                EPRTR.Charts.ChartsUtils.ChartClientScript(swfFile, nonhazardous, hazardous, chartPanel, uniqueId, labels);
            }
            else
            {
                chartPanel.Visible = false;
            }
        }


        #endregion

        /// <summary>
        /// Location of .swf file
        /// </summary>
        /// <param name="swfFile"></param>
        /// <returns></returns>
        private static string SwfFileLocation(string swfFile)
        {
            return CHART_FOLDER + "/" + swfFile + ".swf";
        }
    } 
}
