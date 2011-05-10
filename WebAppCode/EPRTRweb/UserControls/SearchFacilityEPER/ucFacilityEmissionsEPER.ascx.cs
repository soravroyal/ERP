using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;

using QueryLayer;
using QueryLayer.Filters;
using EPRTR.Localization;
using EPRTR.Formatters;
using System.Web.UI;


public partial class ucFacilityEmissionsEPER : System.Web.UI.UserControl
{
    private const string FACILITYREPORTID = "pollutantreleases_facilityreportid";
    private const string SEARCH_YEAR = "pollutantreleases_searchyear";
        
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// Toggle time series for air
    /// </summary>
    protected void OnItemCommandAIR(object sender, ListViewCommandEventArgs e)
    {
        onItemCommand(sender, e, MediumFilter.Medium.Air);
    }


    /// <summary>
    /// Toggle time series for water
    /// </summary>
    protected void OnItemCommandWATER(object sender, ListViewCommandEventArgs e)
    {
        onItemCommand(sender, e, MediumFilter.Medium.Water);
    }


    /// <summary>
    /// Toggle time series for soil
    /// </summary>
    protected void OnItemCommandSOIL(object sender, ListViewCommandEventArgs e)
    {
        onItemCommand(sender, e, MediumFilter.Medium.Soil);
    }


    private void onItemCommand(object sender, ListViewCommandEventArgs e, MediumFilter.Medium medium)
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

                ucFacilityPollutantReleasesTrendSheetEPER timeseries = (ucFacilityPollutantReleasesTrendSheetEPER)listView.Items[rowindex].FindControl("timeSeries");
                timeseries.Visible = !timeseries.Visible;

                Control div = listView.Items[rowindex].FindControl("subsheet");
                div.Visible = !div.Visible;

                if (timeseries.Visible)
                {
                    // create time series
                    int facilityReportId = (int)ViewState[FACILITYREPORTID];
                    int searchYear = (int)ViewState[SEARCH_YEAR];
                    timeseries.Populate(facilityReportId, searchYear, pollutantcode, medium);
                }
            }
        }

    }


    /// <summary>
    /// populate the three tables.
    /// </summary>
    public void PopulateLists(int facilityReportID, int searchYear)
    {
        ViewState[FACILITYREPORTID] = facilityReportID;
        ViewState[SEARCH_YEAR] = searchYear;
        
        // Releases AIR
        this.lvFacilityPollutantReleasesAIR.DataSource = methodPrep(Facility.GetPollutantReleases(facilityReportID, MediumFilter.Medium.Air));
        this.lvFacilityPollutantReleasesAIR.DataBind();
                
        // Releases WATER
        this.lvFacilityPollutantReleasesWATER.DataSource = methodPrep(Facility.GetPollutantReleases(facilityReportID, MediumFilter.Medium.Water));
        this.lvFacilityPollutantReleasesWATER.DataBind();

        // Releases SOIL
        //this.lvFacilityPollutantReleasesSOIL.DataSource = methodPrep(Facility.GetPollutantReleases(facilityReportID, MediumFilter.Medium.Soil));
        //this.lvFacilityPollutantReleasesSOIL.DataBind();
    }
    /// <summary>
    /// This method handles the conversion from multiple lines with method used to single pollutants with multiple rows of method used.
    /// </summary>
    /// <param name="data"></param>
    /// <returns></returns>
    private List<FACILITYDETAIL_POLLUTANTRELEASE> methodPrep(IEnumerable<FACILITYDETAIL_POLLUTANTRELEASE> data)
    {
        List<FACILITYDETAIL_POLLUTANTRELEASE> fdprResult = new List<FACILITYDETAIL_POLLUTANTRELEASE>();
        bool wasAdded = false;
        foreach (FACILITYDETAIL_POLLUTANTRELEASE fdpr in data)
        {
            foreach (FACILITYDETAIL_POLLUTANTRELEASE resultfdpr in fdprResult)
            {
                if (resultfdpr.PollutantCode.Equals(fdpr.PollutantCode))
                {
                    resultfdpr.MethodTypeCode = MethodUsedFormat.AddMethodType(resultfdpr.MethodTypeCode, fdpr.MethodTypeCode);
                    resultfdpr.MethodDesignation = MethodUsedFormat.AddMethodDesignation(resultfdpr.MethodDesignation, fdpr.MethodDesignation);
                    wasAdded = true;
                }
            }
            if (!wasAdded)
            {
                fdprResult.Add(fdpr);
            }
            wasAdded = false;
        }
        return fdprResult;
    }


    /// <summary>
    #region Databinding methods

    protected string GetPollutantCode(object obj)
    {
        FACILITYDETAIL_POLLUTANTRELEASE row = (FACILITYDETAIL_POLLUTANTRELEASE)obj;
        return row.PollutantCode;
    }

    protected string GetPollutantName(object obj)
    {
        FACILITYDETAIL_POLLUTANTRELEASE row = (FACILITYDETAIL_POLLUTANTRELEASE)obj;
        string codeEPER = row.PollutantCode;
        if(!codeEPER.EndsWith("EPER")){
            codeEPER = codeEPER + "EPER";
        }

        //return LOVResources.PollutantName(row.PollutantCode);
        return LOVResources.PollutantNameEPER(row.PollutantCode, codeEPER);
    }

    protected string GetTotalQuantity(object obj)
    {
        FACILITYDETAIL_POLLUTANTRELEASE row = (FACILITYDETAIL_POLLUTANTRELEASE)obj;
        return QuantityFormat.Format(row.TotalQuantity, row.TotalQuantityUnitCode);
       // return QuantityFormat.Format(row.TotalQuantity, "TNE");
    }

    protected string GetAccidentalQuantity(object obj)
    {
        FACILITYDETAIL_POLLUTANTRELEASE row = (FACILITYDETAIL_POLLUTANTRELEASE)obj;
        return QuantityFormat.Format(row.AccidentalQuantity, row.AccidentalQuantityUnitCode);
        //return QuantityFormat.Format(row.AccidentalQuantity, "TNE");
    }

    protected string GetAccidentalPercent(object obj)
    {
        FACILITYDETAIL_POLLUTANTRELEASE row = (FACILITYDETAIL_POLLUTANTRELEASE)obj;
        return QueryLayer.Utilities.AccidentalPercent.DeterminePercent(row.TotalQuantity, row.AccidentalQuantity);
    }

    protected string GetMethodBasisName(object obj)
    {
        FACILITYDETAIL_POLLUTANTRELEASE row = (FACILITYDETAIL_POLLUTANTRELEASE)obj;
        return LOVResources.MethodBasisName(row.MethodCode);
    }

    protected string GetMethodUsedTitle(object obj)
    {
        FACILITYDETAIL_POLLUTANTRELEASE row = (FACILITYDETAIL_POLLUTANTRELEASE)obj;
        return MethodUsedFormat.MethodFormatToolTip(row.MethodTypeCode, row.MethodDesignation, row.ConfidentialIndicator);
    }

    protected string GetMethodUsed(object obj)
    {
        FACILITYDETAIL_POLLUTANTRELEASE row = (FACILITYDETAIL_POLLUTANTRELEASE)obj;
        return MethodUsedFormat.MethodFormat(row.MethodTypeCode, row.MethodDesignation, row.ConfidentialIndicator);
    }

    protected string GetConfidentialityReason(object obj)
    {
        FACILITYDETAIL_POLLUTANTRELEASE row = (FACILITYDETAIL_POLLUTANTRELEASE)obj;
        return LOVResources.ConfidentialityReason(row.ConfidentialCode);
    }

    protected string GetConfidentialCode(object obj)
    {
        FACILITYDETAIL_POLLUTANTRELEASE row = (FACILITYDETAIL_POLLUTANTRELEASE)obj;
        return row.ConfidentialCode;
    }



    #endregion
}
