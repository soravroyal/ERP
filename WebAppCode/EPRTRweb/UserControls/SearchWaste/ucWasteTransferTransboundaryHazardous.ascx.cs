using System;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json;
using QueryLayer;
using QueryLayer.Filters;
using EPRTR.Utilities;
using EPRTR.CsvUtilities;
using EPRTR.HeaderBuilders;
using System.Globalization;
using System.Web;

public partial class ucWasteTransferTransboundaryHazardous : System.Web.UI.UserControl
{
   

    #region ViewState properties

    private const string FILTER = "WT_wastetransferfilter";
    //private const string CONF_AFFECTED = "WT_confidentialityAffected";

        /// <value>
    /// The searchfilter
    /// </value>
    protected WasteTransferSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as WasteTransferSearchFilter; }
        set { ViewState[FILTER] = value; }
    }


    #endregion 



    protected void Page_Load(object sender, EventArgs e)
    {
    }

    public void Populate(WasteTransferSearchFilter filter)
    {
        SearchFilter = filter;

        List<WasteTransfers.TransboundaryHazardousWasteData> data = WasteTransfers.GetTransboundaryHazardousWasteData(filter, true).ToList();

        if (data.Count() != 0)
        {
            //add flex control
            string swfFile = EPRTR.Charts.ChartsUtils.WasteTransferBubbleChart;
            EPRTR.Charts.ChartsUtils.ChartClientScript(swfFile, data, this.wasteTransferTransboundHazardousPanel, this.UniqueID.ToString());    
        }
        else
        {
            this.NoDataReturned.Visible = true;
        }
    }


    /// <summary>
    /// Chart data is formated into JSON then encoded into Base64
    /// </summary>
    /// <param name="myWasteTransfer"></param>
    /// <returns>string</returns>
    private string MakeJSONData(EPRTRT.DataContracts.WasteTransferBoundaries myWasteTransfer)
    {
        string output = JsonConvert.SerializeObject(myWasteTransfer);
        //convert Chart data to JSON
        //return Server.HtmlEncode(output);
        byte[] encData_byte = new byte[output.Length];
        encData_byte = System.Text.Encoding.UTF8.GetBytes(output);
        string encodedData = Convert.ToBase64String(encData_byte);
        return encodedData;
    }


    /// <summary>
    /// Save transfers data
    /// </summary>
    public void DoSaveCSV(object sender, EventArgs e)
    {
        CultureInfo csvCulture = CultureResolver.ResolveCsvCulture(Request);
        CSVFormatter csvformat = new CSVFormatter(csvCulture);

        bool ConfidentialityAffected = WasteTransfers.IsAffectedByConfidentiality(SearchFilter);

        // Create Header
        Dictionary<string, string> header = CsvHeaderBuilder.GetWasteTransfersSearchHeader(
            SearchFilter,
            ConfidentialityAffected);

        IEnumerable<WasteTransfers.TransboundaryHazardousWasteData> wastedata =
            WasteTransfers.GetTransboundaryHazardousWasteData(
            SearchFilter,
            ConfidentialityAffected);

        Response.WriteUtf8FileHeader("EPRTR_Waste_Transfers_Transboundary_Hazardous");

        // dump to file
        string topheader = csvformat.CreateHeader(header);
        string wasteHeader = csvformat.GetWasteHeader();

        Response.Write(topheader + wasteHeader);
        foreach (var v in wastedata)
        {
            string row = csvformat.GetWasteRow(v);
            Response.Write(row);
        }
        Response.End();
    }


}
