using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.UI.WebControls;
using EPRTR.Localization;
using QueryLayer;
using StylingHelper;
using EPRTR.Formatters;

public partial class ucFacilityDetails : System.Web.UI.UserControl
{

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    ///  Applies different css styles to specific datacells in the table. (To match demo color coding)
    ///  for content rows, add indent on the first cell in the row
    /// </summary>
    protected void ActivityRowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            ActivityItem item = (ActivityItem)e.Row.DataItem;

            if (item.IsSubHeaderRow)
            {
                e.Row.CssClass = "activitySubHeader";
            }

        }
    }

    protected string GetIndentCss(object obj)
    {
        ActivityItem item = (ActivityItem)obj;

        return item.IsSubHeaderRow ? "indentLevel0" : "indentLevel1";
    }

    protected string GetActivityName(object obj)
    {
        ActivityItem item = (ActivityItem)obj;
        return item.Content;
    }

    protected string GetIPPC(object obj)
    {
        ActivityItem item = (ActivityItem)obj;
        return item.IppcCode;
    }


    /// <summary>
    /// Row binding. Applies different css styles to specific datacells in the table. (To match demo color coding)
    /// </summary>
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((FacilityDetailElement)e.Row.DataItem).IsHeader)
            {
                e.Row.Cells[0].CssClass = "detailsTitleColor";
                e.Row.Cells[1].CssClass = "detailsDataColor";
            }
            else
            {
                e.Row.Cells[0].CssClass = "detailsSubTitleColor";
                e.Row.Cells[1].CssClass = "detailsDataColor";
            }
        }
    }

    /// <summary>
    /// Manual insertion of all facility level details into List, which is in turn bound to GridView
    /// </summary>
    private void populateDetails(int facilityReportId)
    {
        FACILITYDETAIL_DETAIL fac = Facility.GetFacilityDetails(facilityReportId).First();
        FACILITYDETAIL_COMPETENTAUTHORITYPARTY authority = Facility.GetFacilityCompetentAuthority(facilityReportId).First();

        List<FacilityDetailElement> elements = new List<FacilityDetailElement>();

        elements.Add(new FacilityDetailElement(
                                       Resources.GetGlobal("Facility", "FacilityDetailsTitle"),
                                       String.Empty,
                                       true));

        

        elements.Add(new FacilityDetailElement(
                                       Resources.GetGlobal("Facility", "ParentCompanyName"),
                                       ConfidentialFormat.Format(fac.ParentCompanyName, fac.ConfidentialIndicator)));
        
        // Take "Valid" string from FACILITY_DETAIL_DETAIL
        elements.Add(new FacilityDetailElement(
                                       Resources.GetGlobal("Facility", "Coords"),
                                       CoordinateFormat.Format(fac.Coordinates, "VALID")));


        //NUTS is voluntary. Only add if reported. 
        if (!string.IsNullOrEmpty(fac.NUTSRegionSourceCode))
        {
            //Add both reported and geo-coded value - if they differ.
            if (fac.NUTSRegionSourceCode != fac.NUTSRegionLevel2Code)
            {
                elements.Add(new FacilityDetailElement(
                                       Resources.GetGlobal("Facility", "NUTSMap"),
                                       LOVResources.NutsRegionName(fac.NUTSRegionLevel2Code)));
                elements.Add(new FacilityDetailElement(
                                       Resources.GetGlobal("Facility", "NUTSReported"),
                                       LOVResources.NutsRegionName(fac.NUTSRegionSourceCode)));
            }
            else
            {
                elements.Add(new FacilityDetailElement(
                                       Resources.GetGlobal("Facility", "NUTS"),
                                       LOVResources.NutsRegionName(fac.NUTSRegionLevel2Code)));
            }
        }

        //Add both reported and geo-coded value - if they differ.
        if (fac.RiverBasinDistrictSourceCode != fac.RiverBasinDistrictCode)
        {
            elements.Add(new FacilityDetailElement(
                                           Resources.GetGlobal("Facility", "RBDMap"),
                                           LOVResources.RiverBasinDistrictName(fac.RiverBasinDistrictCode)));

            elements.Add(new FacilityDetailElement(
                                   Resources.GetGlobal("Facility", "RBDReported"),
                                   LOVResources.RiverBasinDistrictName(fac.RiverBasinDistrictSourceCode)));
        }
        else
        {
            elements.Add(new FacilityDetailElement(
                                           Resources.GetGlobal("Facility", "RBD"),
                                           LOVResources.RiverBasinDistrictName(fac.RiverBasinDistrictCode)));
        }

        //NACE code reported on sub-activity level, except for EPER where some is reported on Activity level
        string naceCode = !String.IsNullOrEmpty(fac.NACESubActivityCode) ? fac.NACESubActivityCode : fac.NACEActivityCode;
        elements.Add(new FacilityDetailElement(
                                       Resources.GetGlobal("Facility", "NACE"),
                                       LOVResources.NaceActivityName(naceCode)));
        
        //Production volume is voluntary. Only add if reported.
        if (fac.ProductionVolumeQuantity != null)
        {
            elements.Add(new FacilityDetailElement(
                                           Resources.GetGlobal("Facility", "ProductionV"),
                                           String.Format("{0} {1} {2}",
                                                         fac.ProductionVolumeProductName,
                                                         NumberFormat.Format(fac.ProductionVolumeQuantity),
                                                         LOVResources.UnitName(fac.ProductionVolumeUnitCode))));
        }

        //No. of IPPC installations is voluntary. Only add if reported.
        if (fac.TotalIPPCInstallationQuantity != null)
        {
            elements.Add(new FacilityDetailElement(
                                           Resources.GetGlobal("Facility", "IPPC"),
                                           NumberFormat.Format(fac.TotalIPPCInstallationQuantity)));
        }

        //No. of emplyees is voluntary. Only add if reported.
        if (fac.TotalEmployeeQuantity != null)
        {
            elements.Add(new FacilityDetailElement(
                                           Resources.GetGlobal("Facility", "Employ"),
                                           NumberFormat.Format(fac.TotalEmployeeQuantity)));
        }

        //Operating hours is voluntary. Only add if reported.
        if (fac.OperatingHours != null)
        {
            elements.Add(new FacilityDetailElement(
                                           Resources.GetGlobal("Facility", "OperationHours"),
                                           String.Format("{0}", fac.OperatingHours)));
        }

        //Website is voluntary. Only add if reported.
        if (!string.IsNullOrEmpty(fac.WebsiteCommunication))
        {
            elements.Add(new FacilityDetailElement(
                                           Resources.GetGlobal("Facility", "WebSite"),
                                           String.Format("{0}", fac.WebsiteCommunication)));
        }

        if (fac.ConfidentialIndicatorCode != null)
        {
            elements.Add(new FacilityDetailElement(
                Resources.GetGlobal("Pollutant", "ConfidentialityReason"),
                LOVResources.ConfidentialityReason(fac.ConfidentialIndicatorCode)));
        }


        elements.Add(new FacilityDetailElement(
                                       Resources.GetGlobal("Common", "NationalID") + ":",
                                       FacilityDetailsFormat.FormatNationalId(fac)));

        // This is not the most elegant way to obtain a spacing  spacing
        elements.Add(new FacilityDetailElement(String.Empty, String.Empty));
        
        string updatedDateString = authority.CALastUpdate == null
                                       ? Resources.GetGlobal("Facility", "LastUpdatedUnknown")
                                       : authority.CALastUpdate.Format();
        
        elements.Add(new FacilityDetailElement(
                                   Resources.GetGlobal("Facility", "CompetentA"),
                                   String.Format(Resources.GetGlobal("Facility", "LastUpdated"),updatedDateString),
                                   true));

        elements.Add(new FacilityDetailElement(
                                       Resources.GetGlobal("Facility", "Name"),
                                       String.Format(authority.CAName)));

        if (authority.CAAddress != null)
        {
            elements.Add(new FacilityDetailElement(
                                           Resources.GetGlobal("Facility", "Address"),
                                           AddressFormat.Format(authority.CAAddress, authority.CACity, authority.CAPostalCode, false)));
        }

        if (authority.CATelephoneCommunication != null)
        {
            elements.Add(new FacilityDetailElement(
                                           Resources.GetGlobal("Facility", "Phone"),
                                           String.Format(authority.CATelephoneCommunication)));
        }

        if (authority.CAFaxCommunication != null)
        {
            elements.Add(new FacilityDetailElement(
                Resources.GetGlobal("Facility", "Fax"), 
                String.Format(authority.CAFaxCommunication)));
        }

        elements.Add(new FacilityDetailElement(
                                       Resources.GetGlobal("Facility", "Email"),
                                       String.Format(authority.CAEmailCommunication)));

        if (authority.CAContactPersonName != null)
        {
            elements.Add(new FacilityDetailElement(
                                           Resources.GetGlobal("Facility", "CPerson"),
                                           String.Format(authority.CAContactPersonName)));
        }

        // data binding 
        facilityreportDetails.DataSource = elements;
        facilityreportDetails.DataBind();
    }

    /// <summary>
    /// populate the activity table for the details report page.
    /// </summary>
    public void Populate(int facilityReportId)
    {
        populateActivities(facilityReportId);

        populateDetails(facilityReportId);

        PopulatePublicInformation(facilityReportId);

        // create flash map
        this.ucFacilityDetailsMap.Initialize(facilityReportId, "-1");

        DetailMapUrlName = facilityReportId.ToString();
        this.detailmapprint.ImageUrl = "~/MapPrint/img/" + DetailMapUrlName + ".png";
    }
    
    public string DetailMapUniqueID 
    {
        get { return this.ucFacilityDetailsMap.MapUniqueID; }
    }

    public string DetailMapUrlName 
    {
        get { return (string)ViewState["DetailMapUrlId"]; }
        set 
        {
            Random rnd = new Random();
            ViewState["DetailMapUrlId"] = String.Format("{0}_{1}", value, rnd.Next(1000000)); 
        }
    }
    
    private void populateActivities(int facilityReportId)
    {
        IEnumerable<FACILITYDETAIL_ACTIVITY> data = QueryLayer.Facility.GetActivities(facilityReportId);
        List<ActivityItem> list = new List<ActivityItem>();

        int countAdditional = 0;

        foreach (FACILITYDETAIL_ACTIVITY fa in data)
        {
            if (fa.MainActivityIndicator)
            {
                list.Add(new ActivityItem(Resources.GetGlobal("Facility", "MainActivity")));
            }
            else if (countAdditional == 0)
            {
                countAdditional++;
                list.Add(new ActivityItem(Resources.GetGlobal("Facility", "AdditionalActivities")));

            }
            list.Add(new ActivityItem(fa.IAReportedActivityCode, fa.IPPCReportedActivityCode));
            
            //search and replace  ActivityCode with IAReportedActivityCode
        }

        this.gdwActivities.DataSource = list;
        this.gdwActivities.DataBind();

    }


    private void PopulatePublicInformation(int facilityReportId)
    {
        litPublicInfo.Visible = false;
        txPublicInfo.Visible = false;
        txPublicInfo.Text = string.Empty;

        IEnumerable<FACILITYDETAIL_DETAIL> d = QueryLayer.Facility.GetFacilityDetails(facilityReportId);
        if (d != null && d.Count() > 0 && d.First() != null)
        {
            string info = d.First().PublicInformation;
            if (!String.IsNullOrEmpty(info))
            {
                litPublicInfo.Visible = true;
                txPublicInfo.Visible = true;
                txPublicInfo.Text = info.Trim();
            }
        }
    }

}

public class ActivityItem
{
    private string content;
    private string ippcCode;
    private bool isSubHeaderRow;


    public ActivityItem(string activityCode, string ippcCode)
    {
        this.content = activityCode;
        this.ippcCode = ippcCode;
        this.isSubHeaderRow = false;
    }

    public ActivityItem(string subHeader)
    {
        this.content = subHeader;
        this.ippcCode = string.Empty;
        this.isSubHeaderRow = true;
    }

    public string IppcCode
    {
        get { return ippcCode; }
    }

    public string Content
    {
        get
        {
            if (isSubHeaderRow)
            {
                return content;
            }
            else
            {
                return LOVResources.AnnexIActivityName(this.content);
            }
        }
    }

    public bool IsSubHeaderRow
    {
        get { return isSubHeaderRow; }
    }

}