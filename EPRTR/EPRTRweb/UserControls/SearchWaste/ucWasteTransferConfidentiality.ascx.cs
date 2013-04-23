using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using QueryLayer;
using QueryLayer.Filters;
using EPRTR.Formatters;
using EPRTR.Localization;
using EPRTR.Comparers;


public partial class ucWasteTransferConfidentiality : System.Web.UI.UserControl
{

    private const string FILTER = "conf_wasteTransferFilter";

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    #region viewstate properties

    /// <summary>
    /// search filter to be used by sub sheet
    /// </summary>
    public WasteTransferSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as WasteTransferSearchFilter; }
        set { ViewState[FILTER] = value; }
    }

    #endregion


    /// <summary>
    /// Fill tables with data
    /// </summary>
    public void Populate(WasteTransferSearchFilter filter,
        bool hasConfidentialInformation)
    {
        SearchFilter = filter;

        if (hasConfidentialInformation)
        {
            this.litConfidentialityExplanation1.Text = CMSTextCache.CMSText("Common", "ConfidentialityExplanationWT1");
            this.litConfidentialityExplanation2.Text = CMSTextCache.CMSText("Common", "ConfidentialityExplanationWT2");

            this.lvWasteConfidentialityFacilities.DataSource = WasteTransfers.GetCountConfidentialFacilities(filter); ;
            this.lvWasteConfidentialityFacilities.DataBind();

            this.lvWasteConfidentialityReason.DataSource = WasteTransfers.GetWasteConfidentialReason(filter).OrderBy(w => w.WasteTypeCode, new WasteTypeComparer()).ThenBy(w => w.ReasonCode);
            this.lvWasteConfidentialityReason.DataBind();
        }

        divConfidentialityInformation.Visible = hasConfidentialInformation;
        divNoConfidentialityInformation.Visible = !hasConfidentialInformation;
    }

    #region databinding methods
    //Hide headers dependend on filter selections.
    protected void OnDataBindingConf(object sender, EventArgs e)
    {
        Control headerAir = this.lvWasteConfidentialityFacilities.FindControl("divHeaderNonHW");
        headerAir.Visible = ShowNonHW;

        Control headerWater = this.lvWasteConfidentialityFacilities.FindControl("divHeaderHWIC");
        headerWater.Visible = ShowHWIC;

        Control headerSoil = this.lvWasteConfidentialityFacilities.FindControl("divHeaderHWOC");
        headerSoil.Visible = ShowHWOC;
    }


    //only show non-HW if selected in filter
    protected bool ShowNonHW
    {
        get { return SearchFilter.WasteTypeFilter.NonHazardousWaste; }
    }

    //only show HW inside country if selected in filter
    protected bool ShowHWIC
    {
        get { return SearchFilter.WasteTypeFilter.HazardousWasteCountry; }
    }

    //only show HW outside country if selected in filter
    protected bool ShowHWOC
    {
        get { return SearchFilter.WasteTypeFilter.HazardousWasteTransboundary; }
    }


    protected string GetFacilitiesDesc(object obj)
    {
        WasteTransfers.FacilityCountObject f = (WasteTransfers.FacilityCountObject)obj;
        return f.FormatFacilitiesDesc();
    }

    protected string GetFacilitiesNonHW(object obj)
    {
        WasteTransfers.FacilityCountObject f = (WasteTransfers.FacilityCountObject) obj;
        return f.FormatFacilitiesNonHW();
    }

    protected string GetFacilitiesHWIC(object obj)
    {
        WasteTransfers.FacilityCountObject f = (WasteTransfers.FacilityCountObject)obj;
        return f.FormatFacilitiesHWIC();
    }

    protected string GetFacilitiesHWOC(object obj)
    {
        WasteTransfers.FacilityCountObject f = (WasteTransfers.FacilityCountObject)obj;
        return f.FormatFacilitiesHWOC();
    }

    protected string GetFacilitiesTotal(object obj)
    {
        WasteTransfers.FacilityCountObject f = (WasteTransfers.FacilityCountObject)obj;
        return f.FormatFacilitiesTotal();
    }


    protected string GetReasonWasteType(object obj)
    {
        WasteTransfers.WasteConfidentialReason r = (WasteTransfers.WasteConfidentialReason)obj;
        return r.FormatReasonWasteType();
    }

    protected string GetReason(object obj)
    {
        WasteTransfers.WasteConfidentialReason r = (WasteTransfers.WasteConfidentialReason)obj;
        return r.FormatReason();
    }

    protected string GetReasonFacilities(object obj)
    {
        WasteTransfers.WasteConfidentialReason r = (WasteTransfers.WasteConfidentialReason)obj;
        return NumberFormat.Format( int.Parse(r.FormatReasonFacilities()));
    }

    #endregion
}
