using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using EPRTR.Comparers;
using EPRTR.Formatters;
using EPRTR.Localization;
using QueryLayer;
using QueryLayer.Filters;

public partial class ucIndustrialActivityConfidentiality : System.Web.UI.UserControl
{
    private const string FILTER = "IndustrialActivityConfidentialityFilter";
    private const string RELEASES_FACILITIES = "IndustrialActivityReleasesFacilities";
    private const string TRANSFER_FACILITIES = "IndustrialActivityTransfersFacilities";

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// search filter to be used by sub sheet
    /// </summary>
    private IndustrialActivitySearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as IndustrialActivitySearchFilter; }
        set { ViewState[FILTER] = value; }
    }

    /// <summary>
    /// Populate the listview with confidential data
    /// </summary>
    public void Populate(IndustrialActivitySearchFilter filter, bool hasConfidentialInformation)
    {
        if (hasConfidentialInformation)
        {
            this.lbReleasesConfDesc.Text = CMSTextCache.CMSText("Pollutant", "ConfReleaseDesc");
            this.lbTransferConfDesc.Text = CMSTextCache.CMSText("Pollutant", "ConfTransfersDesc");
            this.lbWasteConfDesc.Text = CMSTextCache.CMSText("WasteTransfers", "ConfWasteDesc");

            // Check one radio button
            this.rbReleaseGroup.Items.Clear();
            this.rbReleaseGroup.Items.Add(new ListItem(Resources.GetGlobal("Common", "ContentPollutantReleases"), "releases"));
            this.rbReleaseGroup.Items.Add(new ListItem(Resources.GetGlobal("Common", "ContentPollutantTransfers"), "transfers"));
            this.rbReleaseGroup.Items.Add(new ListItem(Resources.GetGlobal("Common", "ContentWastetransfers"), "waste"));

            // Select first element
            this.rbReleaseGroup.Items[0].Selected = true;
            string value = this.rbReleaseGroup.SelectedValue;

            ViewState[RELEASES_FACILITIES] = null;
            ViewState[TRANSFER_FACILITIES] = null;

            SearchFilter = filter;
            updateSheet(value);
        }
        else
        {
            hideAllControls();
        }

        rbReleaseGroup.Visible = hasConfidentialInformation;
        divNoConfidentialityInformation.Visible = !hasConfidentialInformation;
    }

    /// <summary>
    /// radio buttons selected
    /// </summary>
    protected void onSelectedIndexChanged(object sender, EventArgs e)
    {
        string value = this.rbReleaseGroup.SelectedValue;
        updateSheet(value.ToLower());
    }

    /// <summary>
    /// hide all controls for this sheet
    /// </summary>
    private void hideAllControls()
    {
        this.divPollutantReleases.Visible = false;
        this.divPollutantTransfers.Visible = false;
        this.divWasteTransfers.Visible = false;
        this.litNoDataFoundConfidentialityInfo.Visible = false;
    }

    /// <summary>
    /// update sheet
    /// </summary>
    /// <param name="value"></param>
    private void updateSheet(string value)
    {
        hideAllControls();
        // pollutant releases 
        if (value.Equals("releases"))
        {
            this.lvPollutantReleasesFacility.DataSource = GetConfidentialReleasesFacilityData();
            this.lvPollutantReleasesFacility.DataBind();
            this.lvPollutantReleasesReason.DataSource = IndustrialActivity.GetConfidentialReleasesReason(SearchFilter);
            this.lvPollutantReleasesReason.DataBind();
            // hide or show data
            bool noDataFound = this.lvPollutantReleasesReason.Items.Count == 0 && this.lvPollutantReleasesFacility.Items.Count == 0;
            this.divPollutantReleases.Visible = !noDataFound;
            this.litNoDataFoundConfidentialityInfo.Visible = noDataFound;
        }
        // pollutant transfers
        else if (value.Equals("transfers"))
        {
            this.lvPollutantTransfersFacility.DataSource = GetConfidentialTransfersFacilityData();
            this.lvPollutantTransfersFacility.DataBind();
            this.lvPollutantTransfersReason.DataSource = QueryLayer.IndustrialActivity.GetConfidentialTransfersReason(SearchFilter);
            this.lvPollutantTransfersReason.DataBind();
            // hide or show data
            bool noDataFound = this.lvPollutantTransfersFacility.Items.Count == 0 && this.lvPollutantTransfersReason.Items.Count == 0;
            this.divPollutantTransfers.Visible = !noDataFound;
            this.litNoDataFoundConfidentialityInfo.Visible = noDataFound;
        }
        // waste transfers
        else if (value.Equals("waste"))
        {
            this.lvWasteFacilities.DataSource = QueryLayer.IndustrialActivity.GetWasteConfidentialFacilities(SearchFilter);
            this.lvWasteFacilities.DataBind();
            this.lvWasteReason.DataSource = QueryLayer.IndustrialActivity.GetWasteConfidentialReason(SearchFilter).OrderBy(w => w.WasteTypeCode, new WasteTypeComparer()).ThenBy(w => w.ReasonCode);
            this.lvWasteReason.DataBind();
            // hide or show data
            bool noDataFound = this.lvWasteFacilities.Items.Count == 0 && this.lvWasteReason.Items.Count == 0;
            this.divWasteTransfers.Visible = !noDataFound;
            this.litNoDataFoundConfidentialityInfo.Visible = noDataFound;
        }
    }

    /// <summary>
    /// Get Confidential Releases Data
    /// </summary>
    private IEnumerable<IndustrialActivity.ConfidentialReleasesRow> GetConfidentialReleasesFacilityData()
    {
        IEnumerable<IndustrialActivity.ConfidentialReleasesRow> data = null;
        if (ViewState[RELEASES_FACILITIES] == null)
        {
            data = IndustrialActivity.GetConfidentialReleasesFacility(SearchFilter);
            ViewState[RELEASES_FACILITIES] = data;
        }
        else
            data = ViewState[RELEASES_FACILITIES] as IEnumerable<IndustrialActivity.ConfidentialReleasesRow>;
        return data;
    }

    /// <summary>
    /// return Transfers Facility Data
    /// </summary>
    private IEnumerable<IndustrialActivity.ConfidentialTransfersRow> GetConfidentialTransfersFacilityData()
    {
        IEnumerable<IndustrialActivity.ConfidentialTransfersRow> data = null;
        if (ViewState[TRANSFER_FACILITIES] == null)
        {
            data = IndustrialActivity.GetConfidentialTransfersFacility(SearchFilter);
            ViewState[TRANSFER_FACILITIES] = data;
        }
        else
            data = ViewState[TRANSFER_FACILITIES] as IEnumerable<IndustrialActivity.ConfidentialTransfersRow>;
        return data;
    }

    #region DataBinding Methods

    #region Pollutant releases
    protected string GetPRPollutantName(object obj)
    {
        IndustrialActivity.ConfidentialReleasesRow row = (IndustrialActivity.ConfidentialReleasesRow)obj;
        return LOVResources.PollutantName(row.PollutantCode);
    }

    protected string GetPRPollutantGroup(object obj)
    {
        IndustrialActivity.ConfidentialReleasesRow row = (IndustrialActivity.ConfidentialReleasesRow)obj;
        return LOVResources.PollutantGroupName(row.PollutantCode);
    }

    protected string GetPRReason(object obj)
    {
        IndustrialActivity.ConfidentialReleasesRow row = (IndustrialActivity.ConfidentialReleasesRow)obj;
        return LOVResources.ConfidentialityReason(row.ReasonCode);
    }

    protected string GetPRFacilitiesAir(object obj)
    {
        IndustrialActivity.ConfidentialReleasesRow row = (IndustrialActivity.ConfidentialReleasesRow)obj;
        return NumberFormat.Format(row.FacilitiesAir);
    }

    protected string GetPRFacilitiesAirConf(object obj)
    {
        IndustrialActivity.ConfidentialReleasesRow row = (IndustrialActivity.ConfidentialReleasesRow)obj;
        return NumberFormat.Format(row.FacilitiesAirConfidential);
    }

    protected string GetPRFacilitiesWater(object obj)
    {
        IndustrialActivity.ConfidentialReleasesRow row = (IndustrialActivity.ConfidentialReleasesRow)obj;
        return NumberFormat.Format(row.FacilitiesWater);
    }

    protected string GetPRFacilitiesWaterConf(object obj)
    {
        IndustrialActivity.ConfidentialReleasesRow row = (IndustrialActivity.ConfidentialReleasesRow)obj;
        return NumberFormat.Format(row.FacilitiesWaterConfidential);
    }

    protected string GetPRFacilitiesSoil(object obj)
    {
        IndustrialActivity.ConfidentialReleasesRow row = (IndustrialActivity.ConfidentialReleasesRow)obj;
        return NumberFormat.Format(row.FacilitiesSoil);
    }

    protected string GetPRFacilitiesSoilConf(object obj)
    {
        IndustrialActivity.ConfidentialReleasesRow row = (IndustrialActivity.ConfidentialReleasesRow)obj;
        return NumberFormat.Format(row.FacilitiesSoilConfidential);
    }


    #endregion

    #region pollutant transfers
    protected string GetPTPollutantName(object obj)
    {
        IndustrialActivity.ConfidentialTransfersRow row = (IndustrialActivity.ConfidentialTransfersRow)obj;
        return LOVResources.PollutantName(row.PollutantCode);
    }

    protected string GetPTPollutantGroup(object obj)
    {
        IndustrialActivity.ConfidentialTransfersRow row = (IndustrialActivity.ConfidentialTransfersRow)obj;
        return LOVResources.PollutantGroupName(row.PollutantCode);
    }

    protected string GetPTReason(object obj)
    {
        IndustrialActivity.ConfidentialTransfersRow row = (IndustrialActivity.ConfidentialTransfersRow)obj;
        return LOVResources.ConfidentialityReason(row.ReasonCode);
    }

    protected string GetPTFacilities(object obj)
    {
        IndustrialActivity.ConfidentialTransfersRow row = (IndustrialActivity.ConfidentialTransfersRow)obj;
        return NumberFormat.Format(row.Facilities);
    }

    protected string GetPTFacilitiesConf(object obj)
    {
        IndustrialActivity.ConfidentialTransfersRow row = (IndustrialActivity.ConfidentialTransfersRow)obj;
        return NumberFormat.Format(row.FacilitiesConfidential);
    }


    #endregion

    #region Waste
    protected string GetWFacilitiesDesc(object obj)
    {
        WasteTransfers.FacilityCountObject f = (WasteTransfers.FacilityCountObject)obj;
        return f.FormatFacilitiesDesc();
    }

    protected string GetWFacilitiesNonHW(object obj)
    {
        WasteTransfers.FacilityCountObject f = (WasteTransfers.FacilityCountObject)obj;
        return f.FormatFacilitiesNonHW();
    }

    protected string GetWFacilitiesHWIC(object obj)
    {
        WasteTransfers.FacilityCountObject f = (WasteTransfers.FacilityCountObject)obj;
        return f.FormatFacilitiesHWIC();
    }

    protected string GetWFacilitiesHWOC(object obj)
    {
        WasteTransfers.FacilityCountObject f = (WasteTransfers.FacilityCountObject)obj;
        return f.FormatFacilitiesHWOC();
    }

    protected string GetWFacilitiesTotal(object obj)
    {
        WasteTransfers.FacilityCountObject f = (WasteTransfers.FacilityCountObject)obj;
        return f.FormatFacilitiesTotal();
    }

    protected string GetWReasonWasteType(object obj)
    {
        WasteTransfers.WasteConfidentialReason r = (WasteTransfers.WasteConfidentialReason)obj;
        return r.FormatReasonWasteType();
    }

    protected string GetWReason(object obj)
    {
        WasteTransfers.WasteConfidentialReason r = (WasteTransfers.WasteConfidentialReason)obj;
        return r.FormatReason();
    }

    protected string GetWReasonFacilities(object obj)
    {
        WasteTransfers.WasteConfidentialReason r = (WasteTransfers.WasteConfidentialReason)obj;
        return r.FormatReasonFacilities();
    }

    #endregion

    #endregion


}

