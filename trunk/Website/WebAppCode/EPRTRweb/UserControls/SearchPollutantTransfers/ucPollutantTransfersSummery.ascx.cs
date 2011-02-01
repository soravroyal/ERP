using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using EPRTR.Localization;


public partial class ucPollutantTransfersSummery : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }


    /// <summary>
    /// Populate summery, flash
    /// </summary>
    public void Populate(QueryLayer.Filters.PollutantTransfersSearchFilter filter)
    {
        List<Summary.Quantity> result = QueryLayer.PollutantTransfers.Summery(filter);
        
        // translation
        foreach (Summary.Quantity r in result)
            r.Name = LOVResources.AnnexIActivityName(r.Code);


        if (result.Count != 0)
        {
            //The name and path of the .swf file.
            string swfFile = EPRTR.Charts.ChartsUtils.PollutantTransferPieChart;
            EPRTR.Charts.ChartsUtils.ChartClientScript(swfFile, result, this.upPollutantTransferSummary, this.UniqueID.ToString());    
        }
        else
        {
            this.NoDataReturned.Visible = true;
        }
        

        
        
    }

   





}
