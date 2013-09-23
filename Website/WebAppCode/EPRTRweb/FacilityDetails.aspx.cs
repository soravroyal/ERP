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
        string facilityReportId = Request.Params["FacilityReportId"];
        string facilityId = Request.Params["FacilityId"];
        string reportingYear = Request.Params["ReportingYear"];

        if (!IsPostBack)
        {
            ucFacilitySheet.Visible = false;
            ucFacilitySheetEPER.Visible = false;

            //load facility basics
            if (!String.IsNullOrEmpty(facilityReportId))
            {
                int facRepId = Convert.ToInt32(facilityReportId);
                FacilityBasic = Facility.GetFacilityBasic(facRepId);
            }
            else if (!String.IsNullOrEmpty(facilityId) && !String.IsNullOrEmpty(reportingYear))
            {
                int facId = Convert.ToInt32(facilityId);
                int year = Convert.ToInt32(reportingYear);
                FacilityBasic = Facility.GetFacilityBasic(facId, year);
            }
            //RRP START-18-04-2013
            //Code to create a bookmarkable link for the latest report for a facility without the year.
            //The problem with the year is that we can expect links to facilities from other websites to be unchanged effectively forever. 
            //Therefore they will link to pages that are become more and more obsolete.
            //With this link, all external applications can access to the 
            //Facility details without the year parameter. The URL access to the last documented year.
            else if (!String.IsNullOrEmpty(facilityId) && String.IsNullOrEmpty(reportingYear))
            {
                int facId = Convert.ToInt32(facilityId);
                //int year = Convert.ToInt32(reportingYear);
                int year = Facility.GetMaxYearFacilityId(facId);
                FacilityBasic = Facility.GetFacilityBasic(facId, year);
            }
            //RRP END-18-04-2013


            //pouplate
            populateTitle();
            populateSheet();
        }
        
    }

    private void populateSheet()
    {
        try
        {
            if (FacilityBasic != null)
            {
                bool eper = isEPER();
                if (eper)
                {
                    this.ucFacilitySheetEPER.Populate(FacilityBasic.FacilityID.ToString(), FacilityBasic.ReportingYear.ToString());
                }
                else
                {
                    this.ucFacilitySheet.Populate(FacilityBasic.FacilityID.ToString(), FacilityBasic.ReportingYear.ToString());
                }
                hideSheets(eper);
            }
        }
        catch
        {
            //do nothing
        }
    }


    private void populateTitle()
    {
        String name = FacilityBasic != null ? FacilityBasic.FacilityName : "";

        lbHeadline.Text = !String.IsNullOrEmpty(name) ? string.Format(Resources.GetGlobal("Common", "FacilityDetailTitle"), name) : Resources.GetGlobal("Common", "FacilityDetailTitleNotFound");

        this.Title = name;
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
