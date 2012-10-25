using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer;
using EPRTR.Localization;

public partial class FacilityDetails : System.Web.UI.Page
{
    private Facility.FacilityBasic FacilityBasic
    {
        get { return (Facility.FacilityBasic)ViewState["FACILITYBASIC"]; }
        set { ViewState["FACILITYBASIC"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string facilityReportId = "361176"; // Request.Params["FacilityReportId"];
        string facilityId = Request.Params["FacilityId"];
        string reportingYear = Request.Params["ReportingYear"];

        if (!IsPostBack)
        {
            ucFacilitySheet.Visible = false;
            ucFacilitySheetEPER.Visible = false;

            if (!String.IsNullOrEmpty(facilityReportId))
            {
                int facRepId = Convert.ToInt32(facilityReportId);
                FacilityBasic = Facility.GetFacilityBasic(facRepId);

                populateSheet(facilityReportId);
            }
            else if (!String.IsNullOrEmpty(facilityId) && !String.IsNullOrEmpty(reportingYear))
            {
                int facId = Convert.ToInt32(facilityId);
                int year = Convert.ToInt32(reportingYear);
                FacilityBasic = Facility.GetFacilityBasic(facId, year);

                populateSheet(facilityId, reportingYear);
            }

            populateTitle();
        }
    }

    private void populateSheet(string facilityReportId)
    {
        try
        {
            bool eper = isEPER();
            if (eper)
            {
                this.ucFacilitySheetEPER.Populate(facilityReportId);
            }
            else
            {
                this.ucFacilitySheet.Populate(facilityReportId);
            }
            hideSheets(eper);
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

            populateTitle();

            bool eper = isEPER();
            if (eper)
            {
                this.ucFacilitySheetEPER.Populate(facilityId, reportingYear);
            }
            else
            {
                this.ucFacilitySheet.Populate(facilityId, reportingYear);
            }
            hideSheets(eper);
        }
        catch
        { //do nothing
        }
    }

    private void populateTitle()
    {
        if (FacilityBasic != null) lbHeadline.Text = FacilityBasic.FacilityName;

        this.Title = lbHeadline.Text;
    }


    private void hideSheets(bool isEPER)
    {
        ucFacilitySheet.Visible = !isEPER;
        ucFacilitySheetEPER.Visible = isEPER;
    }

    private bool isEPER()
    {
        return FacilityBasic!=null && FacilityBasic.ReportingYear < 2007;
    }
}
