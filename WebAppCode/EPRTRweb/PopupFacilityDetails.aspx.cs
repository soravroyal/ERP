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
        this.Title = string.Format(Resources.GetGlobal("Common", "FacilityPopupTitle"), facilityReportId);
        
        if (!IsPostBack)
        {
            if (Facility.IsEPERReportingYear(int.Parse(facilityReportId)))
            {
                // show EPER sheet
                ucFacilitySheet.Visible = false;
                ucFacilitySheetEPER.Visible = true;
                this.ucFacilitySheetEPER.Populate(facilityReportId);
            }
            else
            {
                // show E-PRTR sheet
                ucFacilitySheet.Visible = true;
                ucFacilitySheetEPER.Visible = false;
                this.ucFacilitySheet.Populate(facilityReportId);
            }
        }
    }
}
