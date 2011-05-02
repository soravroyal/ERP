using System;
using System.Globalization;
using EPRTR.Localization;
using QueryLayer;
using System.Linq;

public partial class PopupFacilityDetails : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string facilityReportId = Request.Params["FacilityReportId"];
        string facilityId = Request.Params["FacilityId"];
        string reportingYear = Request.Params["ReportingYear"];

        ucFacilitySheet.Visible = false;
        ucFacilitySheetEPER.Visible = false;

        if (!String.IsNullOrEmpty(facilityReportId))
        {
            this.Title = string.Format(Resources.GetGlobal("Common", "FacilityPopupTitle"), "FacilityReportId="+facilityReportId);
            if (!IsPostBack)
            {
                populateSheet(facilityReportId);
            }
        }
        else if (!String.IsNullOrEmpty(facilityId) && !String.IsNullOrEmpty(reportingYear))
        {
            this.Title = string.Format(Resources.GetGlobal("Common", "FacilityPopupTitle"), "FacilityId=" + facilityId+"&ReportingYear="+reportingYear);
            if (!IsPostBack)
            {
                populateSheet(facilityId,reportingYear);
            }
        }
        
    }

    private void populateSheet(string facilityReportId)
    {
        try
        {
            bool isEPER = Facility.IsEPERReportingYear(int.Parse(facilityReportId));
            if (isEPER)
            {
                this.ucFacilitySheetEPER.Populate(facilityReportId);
            }
            else
            {
                this.ucFacilitySheet.Populate(facilityReportId);
            }
            hideSheets(isEPER);
        }
        catch
        {
            //do nothing
        }
    }

    private void populateSheet(string facilityId, string reportingYear)
    {
        try
        {
            bool isEPER = int.Parse(reportingYear) < 2007;
            if (isEPER)
            {
                this.ucFacilitySheetEPER.Populate(facilityId, reportingYear);
            }
            else
            {
                this.ucFacilitySheet.Populate(facilityId, reportingYear);
            }
            hideSheets(isEPER);
        }
        catch
        { //do nothing
        }
    }

    private void hideSheets(bool isEPER)
    {
        ucFacilitySheet.Visible = !isEPER;
        ucFacilitySheetEPER.Visible = isEPER;
    }
}
