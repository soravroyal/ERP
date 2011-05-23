using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;

using QueryLayer;
using EPRTR.Localization;
using EPRTR.Formatters;
using System.Web.UI;

public partial class ucFacilityPollutantTransfers : System.Web.UI.UserControl
{
    private string FACILITYREPORTID = "pollutanttransfers_facilityreportid";
    private string SEARCH_YEAR = "pollutanttransfers_searchyear";

    protected void Page_Load(object sender, EventArgs e)
    {
    }
    

    /// <summary>
    /// Create transfer trend sheet
    /// </summary>
    protected void OnItemCommand(object sender, ListViewCommandEventArgs e)
    {
        ListView listView = (ListView)sender;
        // get rowindex
        ListViewDataItem dataItem = e.Item as ListViewDataItem;
        if (dataItem == null) return; //safe check

        int rowindex = dataItem.DataItemIndex;
        if (rowindex >= 0 && rowindex < listView.Items.Count)
        {
            string command = e.CommandName;
            if (command.Equals("toggletimeseries"))
            {
                // get pollutant for db lookup
                string pollutantcode = e.CommandArgument.ToString();

                ucFacilityPollutantTransfersTrendSheet timeseries = (ucFacilityPollutantTransfersTrendSheet)listView.Items[rowindex].FindControl("transferTrend");
                timeseries.Visible = !timeseries.Visible;

                Control div = listView.Items[rowindex].FindControl("subsheet");
                div.Visible = !div.Visible;

                if (timeseries.Visible)
                {
                    // create time series
                    int facilityReportId = (int)ViewState[FACILITYREPORTID];
                    int searchYear = (int)ViewState[SEARCH_YEAR];
                    timeseries.Populate(facilityReportId, pollutantcode, searchYear);
                }
            }
        }


    }
    /// <summary>
    /// This is a dirty hack - 
    /// done properly the interface from DB should be changed as to keep pollutants distinct compared to the method used field
    /// </summary>
    /// <param name="data"></param>
    /// <returns></returns>
    private List<FACILITYDETAIL_POLLUTANTTRANSFER> methodPrep(IEnumerable<FACILITYDETAIL_POLLUTANTTRANSFER> data)
    {
        List<FACILITYDETAIL_POLLUTANTTRANSFER> fdptResult = new List<FACILITYDETAIL_POLLUTANTTRANSFER>();
        bool wasAdded = false;
        foreach (FACILITYDETAIL_POLLUTANTTRANSFER fdpt in data)
        {
            foreach (FACILITYDETAIL_POLLUTANTTRANSFER resultfdpt in fdptResult)
            {
                if (resultfdpt.PollutantCode.Equals(fdpt.PollutantCode))
                {
                    resultfdpt.MethodTypeCode = MethodUsedFormat.AddMethodType(resultfdpt.MethodTypeCode, fdpt.MethodTypeCode);
                    resultfdpt.MethodDesignation = MethodUsedFormat.AddMethodDesignation(resultfdpt.MethodDesignation, fdpt.MethodDesignation);
                    wasAdded = true;
                }
            }
            if (!wasAdded)
            {
                fdptResult.Add(fdpt);
            }
            wasAdded = false;
        }
        return fdptResult;
    }

    /// <summary>
    /// populate the table with information
    /// </summary>
    public void PopulateLists(int facilityReportID, int searchYear)
    {
        ViewState[FACILITYREPORTID] = facilityReportID;
        ViewState[SEARCH_YEAR] = searchYear;

        this.lvFacilityPollutantTransfers.DataSource = methodPrep(Facility.GetPollutantTransfers(facilityReportID));
        this.lvFacilityPollutantTransfers.DataBind();
    }

    #region databinding methods

    protected string GetPollutantCode(object obj)
    {
        FACILITYDETAIL_POLLUTANTTRANSFER row = (FACILITYDETAIL_POLLUTANTTRANSFER)obj;
        return row.PollutantCode;
    }

    protected string GetPollutantName(object obj)
    {
        FACILITYDETAIL_POLLUTANTTRANSFER row = (FACILITYDETAIL_POLLUTANTTRANSFER) obj;
        return LOVResources.PollutantName(row.PollutantCode);
    }

    protected string GetQuantity(object obj)
    {
        FACILITYDETAIL_POLLUTANTTRANSFER row = (FACILITYDETAIL_POLLUTANTTRANSFER)obj;
        return QuantityFormat.Format(row.Quantity, row.UnitCode);
    }

    protected string GetMethodBasisName(object obj)
    {
        FACILITYDETAIL_POLLUTANTTRANSFER row = (FACILITYDETAIL_POLLUTANTTRANSFER)obj;
        return LOVResources.MethodBasisName(row.MethodCode);
    }

    protected string GetMethodUsedTitle(object obj)
    {
        FACILITYDETAIL_POLLUTANTTRANSFER row = (FACILITYDETAIL_POLLUTANTTRANSFER)obj;
        return MethodUsedFormat.MethodFormatToolTip(row.MethodTypeCode, row.MethodDesignation, row.ConfidentialIndicator);
    }

    protected string GetMethodUsed(object obj)
    {
        FACILITYDETAIL_POLLUTANTTRANSFER row = (FACILITYDETAIL_POLLUTANTTRANSFER)obj;
        return MethodUsedFormat.MethodFormat(row.MethodTypeCode, row.MethodDesignation, row.ConfidentialIndicator);
    }

    protected string GetConfidentialityReason(object obj)
    {
        FACILITYDETAIL_POLLUTANTTRANSFER row = (FACILITYDETAIL_POLLUTANTTRANSFER)obj;
        return LOVResources.ConfidentialityReason(row.ConfidentialCode);
    }

    protected string GetConfidentialCode(object obj)
    {
        FACILITYDETAIL_POLLUTANTTRANSFER row = (FACILITYDETAIL_POLLUTANTTRANSFER)obj;
        return row.ConfidentialCode;
    }

    #endregion

}
