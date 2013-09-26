using System;
using System.Collections.Generic;
using System.Linq;
using QueryLayer;
using QueryLayer.Filters;
using EPRTR.Localization;
using EPRTR.Formatters;

public partial class ucFacilityWaste : System.Web.UI.UserControl
{
    private const string FACILITYREPORTID = "facilitywasteFacilityreportId";
    private const string SEARCH_YEAR = "facilitywasteSearchYear";
    
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// polulate
    /// </summary>
    public void Populate(int reportID, int searchYear)
    {
        ViewState[FACILITYREPORTID] = reportID;
        ViewState[SEARCH_YEAR] = searchYear;
        
        populateGridview1(reportID);
        populateGridview2(reportID);
        populateGridview3(reportID);
    }

    /// <summary>
    /// populate the waste tables (non hazardous waste)
    /// </summary>
    private void populateGridview1(int reportID)
    {
        IEnumerable<FACILITYDETAIL_WASTETRANSFER> list = methodPrep(Facility.GetWasteTransfers(reportID, WasteTypeFilter.Type.NonHazardous));
        this.GridView1.DataSource = list;
        this.GridView1.DataBind();
        this.btnNonhazardouswaste.Visible = (list.Count() > 0);
    }

    /// <summary>
    /// populate the waste tables (hazardous waste - country)
    /// </summary>
    private void populateGridview2(int reportID)
    {
        IEnumerable<FACILITYDETAIL_WASTETRANSFER> list = methodPrep(Facility.GetWasteTransfers(reportID, WasteTypeFilter.Type.HazardousCountry));
        this.GridView2.DataSource = list;
        this.GridView2.DataBind();
        this.btnHazardouswastewithincountry.Visible = (list.Count() > 0);
    }

    /// <summary>
    /// populate the waste tables (hazardous waste - border)
    /// </summary>
    private void populateGridview3(int reportID)
    {
        IEnumerable<FACILITYDETAIL_WASTETRANSFER> list = methodPrep(Facility.GetWasteTransfers(reportID, WasteTypeFilter.Type.HazardousTransboundary));
        this.GridView3.DataSource = list;
        this.GridView3.DataBind();
        this.btnHazardouswastetransboundary.Visible = (list.Count() > 0);
    }
    

    /// <summary>
    /// This is a dirty hack - 
    /// done properly the interface from DB should be changed as to keep wastetransfers distinct
    /// compared to the method used field (waste transferid)
    /// </summary>
    private List<FACILITYDETAIL_WASTETRANSFER> methodPrep(IEnumerable<FACILITYDETAIL_WASTETRANSFER> data)
    {
        List<FACILITYDETAIL_WASTETRANSFER> fdptResult = new List<FACILITYDETAIL_WASTETRANSFER>();
    
        bool wasAdded = false;
        foreach (FACILITYDETAIL_WASTETRANSFER fdpt in data)
        {
            foreach (FACILITYDETAIL_WASTETRANSFER resultfdpt in fdptResult)
            {
                if (resultfdpt.WasteTransferID.Equals(fdpt.WasteTransferID))
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
    /// Toggle Nonhazardouswaste sheet
    /// </summary>
    protected void onClickNonhazardouswaste(object sender, EventArgs e)
    {
        this.nonHazardouswastePanel.Visible = !this.nonHazardouswastePanel.Visible;
        this.nonhazardousTimeSeries.Visible = this.nonHazardouswastePanel.Visible;
        // populate timeseries
        if (this.nonhazardousTimeSeries.Visible)
        {
            int facilityReportId = (int)ViewState[FACILITYREPORTID];
            int searchYear = (int)ViewState[SEARCH_YEAR];
            this.nonhazardousTimeSeries.Populate(facilityReportId, searchYear, WasteTypeFilter.Type.NonHazardous);
        }
    }

    /// <summary>
    /// Toggle Hazardouswastewithincountry sheet
    /// </summary>
    protected void onClickHazardouswastewithincountry(object sender, EventArgs e)
    {
        this.hazardouswasteCountryPanel.Visible = !this.hazardouswasteCountryPanel.Visible;
        this.hazardouswasteCountryTimeSeries.Visible = this.hazardouswasteCountryPanel.Visible;
        // populate timeseries
        if (this.hazardouswasteCountryTimeSeries.Visible)
        {
            int facilityReportId = (int)ViewState[FACILITYREPORTID];
            int searchYear = (int)ViewState[SEARCH_YEAR];
            this.hazardouswasteCountryTimeSeries.Populate(facilityReportId, searchYear, WasteTypeFilter.Type.HazardousCountry);
        }
    }


    /// <summary>
    /// Toggle Hazardouswastetransboundary sheet
    /// </summary>
    protected void onClickHazardouswastetransboundary(object sender, EventArgs e)
    {
        this.hazardousTransboundaryPanel.Visible = !this.hazardousTransboundaryPanel.Visible;
        this.hazardousTransboundaryTimeSeries.Visible = this.hazardousTransboundaryPanel.Visible;
        // populate timeseries
        if (this.hazardousTransboundaryTimeSeries.Visible)
        {
            int facilityReportId = (int)ViewState[FACILITYREPORTID];
            int searchYear = (int)ViewState[SEARCH_YEAR];
            this.hazardousTransboundaryTimeSeries.Populate(facilityReportId, searchYear, WasteTypeFilter.Type.HazardousTransboundary);
        }
    }

    #region databinding methods



    protected string GetQuantity(object obj)
    {
        FACILITYDETAIL_WASTETRANSFER row = (FACILITYDETAIL_WASTETRANSFER)obj;
        return QuantityFormat.Format(row.Quantity, row.UnitCode, row.ConfidentialIndicator);
    }

    protected string GetTreatment(object obj)
    {
        FACILITYDETAIL_WASTETRANSFER row = (FACILITYDETAIL_WASTETRANSFER)obj;
        return ConfidentialFormat.Format(LOVResources.WasteTreatmentName(row.WasteTreatmentCode), row.ConfidentialIndicator);
    }

    protected string GetMethodBasis(object obj)
    {
        FACILITYDETAIL_WASTETRANSFER row = (FACILITYDETAIL_WASTETRANSFER)obj;
        return LOVResources.MethodBasisName(row.MethodCode, row.ConfidentialIndicator);
    }

    protected string GetMethodUsed(object obj)
    {
        FACILITYDETAIL_WASTETRANSFER row = (FACILITYDETAIL_WASTETRANSFER)obj;
        return MethodUsedFormat.MethodFormat(row.MethodTypeCode, row.MethodDesignation, row.ConfidentialIndicator);
    }


    protected string GetReceivingCountry(object obj)
    {
        FACILITYDETAIL_WASTETRANSFER row = (FACILITYDETAIL_WASTETRANSFER)obj;
        return ConfidentialFormat.Format(LOVResources.CountryName(row.WHPCountryCode), row.ConfidentialIndicator);
    }

    protected string GetWHPName(object obj)
    {
        FACILITYDETAIL_WASTETRANSFER row = (FACILITYDETAIL_WASTETRANSFER)obj;
        return ConfidentialFormat.Format(row.WHPName, row.ConfidentialIndicator);
    }

    protected string GetWHPAddress(object obj)
    {
        FACILITYDETAIL_WASTETRANSFER row = (FACILITYDETAIL_WASTETRANSFER)obj;
        return AddressFormat.Format(row.WHPAddress, row.WHPCity, row.WHPPostalCode, row.ConfidentialIndicator);
    }

    protected string GetWHPNameAndAddress(object obj)
    {
        FACILITYDETAIL_WASTETRANSFER row = (FACILITYDETAIL_WASTETRANSFER)obj;
        return String.Format("{0}, {1}", GetWHPName(obj), GetWHPAddress(obj));
    }

    protected string GetWHPSiteAddress(object obj)
    {
        FACILITYDETAIL_WASTETRANSFER row = (FACILITYDETAIL_WASTETRANSFER)obj;
        return AddressFormat.Format(row.WHPSiteAddress, row.WHPSiteCity, row.WHPSitePostalCode, row.ConfidentialIndicator);
    }

    protected string GetConfidentialReason(object obj)
    {
        FACILITYDETAIL_WASTETRANSFER row = (FACILITYDETAIL_WASTETRANSFER)obj;
        return LOVResources.ConfidentialityReason(row.ConfidentialCode);
    }

    protected string GetConfidentialCode(object obj)
    {
        return ((FACILITYDETAIL_WASTETRANSFER)obj).ConfidentialCode;
    }

    




    #endregion

}
