using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using QueryLayer;
using QueryLayer.Filters;
using EPRTR.Localization;
using EPRTR.Formatters;
using EPRTR.HeaderBuilders;
using EPRTR.Enums;



    
public partial class ucFacilitySheet : System.Web.UI.UserControl
{

    #region ViewStateProperties
    private Facility.FacilityBasic FacilityBasic
    {
        get { return (Facility.FacilityBasic)ViewState["FACILITYBASIC"]; }
        set { ViewState["FACILITYBASIC"] = value; }
    }

    private Facility.FacilityReportingYear PreviousYear
    {
        get { return (Facility.FacilityReportingYear)ViewState["PREV_YEAR"]; }
        set { ViewState["PREV_YEAR"] = value; }
    }
    private Facility.FacilityReportingYear NextYear
    {
        get { return (Facility.FacilityReportingYear)ViewState["NEXT_YEAR"]; }
        set { ViewState["NEXT_YEAR"] = value; }
    }

    private string Content
    {
        get { return (string)ViewState["FACILITY_CONTENT"]; }
        set { ViewState["FACILITY_CONTENT"] = value; }
    }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        this.ucSheetLinks.ResetContentLinks();
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "ContentDetails"), Sheets.FacilityDetails.Details.ToString());
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "ContentPollutantReleases"), Sheets.FacilityDetails.PollutantReleases.ToString());
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "ContentPollutantTransfers"), Sheets.FacilityDetails.PollutantTransfers.ToString());
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "ContentWastetransfers"), Sheets.FacilityDetails.Waste.ToString());
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "ContentConfidientiality"), Sheets.FacilityDetails.Confidentiality.ToString());

        if (this.ucSheetLinks.Linkclick == null)
            this.ucSheetLinks.Linkclick = new EventHandler(linkClick);

        if (this.ucSheetSubHeader.AlertClick == null)
            this.ucSheetSubHeader.AlertClick = new EventHandler(alertClick);

    }

    /// <summary>
    /// Present content for the facility report given
    /// </summary>
    public void Populate(string facilityReportID)
    {
        if (String.IsNullOrEmpty(facilityReportID))
        {
            FacilityBasic = null;
        }
        else
        {
            int facRepId = Convert.ToInt32(facilityReportID);
            FacilityBasic = Facility.GetFacilityBasic(facRepId);
        }

        populateDefaultContent();
    }

    /// <summary>
    /// Present content for the facility given by facilityID and ReportingYear
    /// </summary>
    public void Populate(string facilityID, string reportingYear)
    {
        if (String.IsNullOrEmpty(facilityID) || String.IsNullOrEmpty(reportingYear))
        {
            FacilityBasic = null;
        }
        else
        {
            int facId = Convert.ToInt32(facilityID);
            int year = Convert.ToInt32(reportingYear);
            FacilityBasic = Facility.GetFacilityBasic(facId, year);

        }

        populateDefaultContent();
    }


    /// <summary>
    /// Present default content for the facility report saved in FacilityBasic
    /// </summary>
    private void populateDefaultContent()
    {
        populateContent(Sheets.FacilityDetails.Details.ToString());
    }

    /// <summary>
    /// Present content for the facility report saved in FacilityBasic with the content chosen
    /// </summary>
    private void populateContent(string content)
    {
        setYears();
        showContent(content);
    }

    //set prevoius/next year
    private void setYears()
    {
        Facility.FacilityBasic basic = FacilityBasic;

        if (basic != null)
        {

            List<Facility.FacilityReportingYear> fys = Facility.GetReportingYears(basic.FacilityID).ToList();

            this.divYearLinks.Visible = fys.Count() > 1;

            if (fys.Count() > 1)
            {
                int currentYear = basic.ReportingYear;

                this.litYear.Text = currentYear.ToString();

                //find previous year
                List<Facility.FacilityReportingYear> fysPrevious = fys.Where(y => y.ReportingYear < currentYear).ToList();
                if (fysPrevious != null && fysPrevious.Count() > 0)
                {
                    PreviousYear = fysPrevious.OrderBy(y => y.ReportingYear).Last();
                }
                else
                {
                    PreviousYear = null;
                }

                //find next year
                List<Facility.FacilityReportingYear> fysNext = fys.Where(y => y.ReportingYear > currentYear).ToList();
                if (fysNext != null && fysNext.Count() > 0)
                {
                    NextYear = fysNext.OrderBy(y => y.ReportingYear).First();
                }
                else
                {
                    NextYear = null;
                }

                //hide or show links
                this.lnbPrevious.Visible = (PreviousYear != null);
                this.lnbNext.Visible = (NextYear != null);
            }
        }

    }

    private void showContent(string command)
    {
        Content = command;
        hideSubControls();
        this.ucSheetLinks.HighLight(command);
        string txt = string.Empty;
        string alert = string.Empty;
        string disclaimer = string.Empty;
        InfoType? info = null;
        string headline = string.Empty;
        this.ucSheetTitleIcon.ImageURL = null;

        Facility.FacilityBasic basic = FacilityBasic;

        if (basic != null)
        {

            int facilityReportID = basic.FacilityReportId;
            int year = basic.ReportingYear;

            if (command == Sheets.FacilityDetails.Details.ToString())
            {
                headline = Resources.GetGlobal("Facility", "FacilitylevelDetails");
                this.ucSheetTitleIcon.ImageURL = null;
                info = null;
                this.ucFacilityDetails.Populate(facilityReportID);
                this.ucFacilityDetails.Visible = true;
                disclaimer = CMSTextCache.CMSText("Facility", "DisclaimerTextFacilityDetails");
                alert = basic.Confidential ? Resources.GetGlobal("Facility", "ConfidentialityAlertLink") : string.Empty;

                this.ucDetailPrint.SetClientClick(this.ucFacilityDetails.DetailMapUniqueID, this.ucFacilityDetails.DetailMapUrlName);
                this.ucDetailPrint.SetPrintControl(this);
            }
            else if (command == Sheets.FacilityDetails.PollutantReleases.ToString())
            {
                headline = Resources.GetGlobal("Facility", "FacilitylevelPollutantreleases");
                this.ucSheetTitleIcon.ImageURL = "~/images/SheetTitleIcon_PollutantRelease.png";
                info = InfoType.Pollutant;
                this.ucFacilityPollutantReleases.Visible = true;
                this.ucFacilityPollutantReleases.PopulateLists(facilityReportID, year);
                disclaimer = CMSTextCache.CMSText("Facility", "DisclaimerTextPollutantReleases");
                txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyReleases");
                alert = basic.PollutantReleaseConfidential ? Resources.GetGlobal("Facility", "ConfidentialityAlertLink") : string.Empty;
                this.ucDetailPrint.SetClientClick();
                this.ucDetailPrint.SetPrintControl(this);
            }
            else if (command == Sheets.FacilityDetails.PollutantTransfers.ToString())
            {
                headline = Resources.GetGlobal("Facility", "FacilitylevelPollutanttransfers");
                this.ucSheetTitleIcon.ImageURL = "~/images/SheetTitleIcon_PollutantTransfer.png";
                info = InfoType.Pollutant;
                this.ucFacilityPollutantTransfers.Visible = true;
                this.ucFacilityPollutantTransfers.PopulateLists(facilityReportID, year);
                disclaimer = CMSTextCache.CMSText("Facility", "DisclaimerTextPollutantTransfers");
                txt = Resources.GetGlobal("Pollutant", "AllValuesAreYearlyTransfers");
                alert = basic.PollutantTransferConfidential ? Resources.GetGlobal("Facility", "ConfidentialityAlertLink") : string.Empty;
                this.ucDetailPrint.SetClientClick();
                this.ucDetailPrint.SetPrintControl(this);
            }
            else if (command == Sheets.FacilityDetails.Waste.ToString())
            {
                headline = Resources.GetGlobal("Facility", "FacilitylevelWaste");
                this.ucSheetTitleIcon.ImageURL = "~/images/SheetTitleIcon_WasteTransfer.png";
                info = null;
                this.ucFacilityWaste.Visible = true;
                this.ucFacilityWaste.Populate(facilityReportID, year);
                disclaimer = CMSTextCache.CMSText("Facility", "DisclaimerTextWaste");
                txt = Resources.GetGlobal("WasteTransfers", "AllValuesAreYearlyTransfers");
                alert = basic.WasteConfidential ? Resources.GetGlobal("Facility", "ConfidentialityAlertLink") : string.Empty;
                this.ucDetailPrint.SetClientClick();
                this.ucDetailPrint.SetPrintControl(this);
            }
            else if (command == Sheets.FacilityDetails.Confidentiality.ToString())
            {
                headline = Resources.GetGlobal("Facility", "FacilitylevelConfidentiality");
                this.ucSheetTitleIcon.ImageURL = null;
                info = null;
                this.ucFacilityConfidentiality.Visible = true;
                disclaimer = CMSTextCache.CMSText("Facility", "DisclaimerTextConfidentiality");
                alert = string.Empty;
                this.ucDetailPrint.SetClientClick();
                this.ucDetailPrint.SetPrintControl(this);
            }
            else
            {
                headline = Resources.GetGlobal("Facility", "FacilitylevelDetails");
            }

        }
        else
        {
            headline = Resources.GetGlobal("Facility", "FacilitylevelNotFound");
        }

        this.litHeadline.Text = headline;
        this.ucDisclaimer.DisclaimerText = disclaimer;
        setInfoIcon(info);
        updateHeader(txt);
        updateAlert(alert);

    }

    private void updateHeader(string text)
    {
        Dictionary<string, string> header = SheetHeaderBuilder.GetFacilityDetailHeader(FacilityBasic);
        this.ucSheetSubHeader.PopulateHeader(header);
        this.ucSheetSubHeader.Text = text;
    }


    private void updateAlert(string alert)
    {
        this.ucSheetSubHeader.AlertText = alert;
        this.ucSheetSubHeader.AlertCommandArgument = Sheets.FacilityDetails.Confidentiality.ToString();
    }


    private void setInfoIcon(InfoType? type)
    {
        this.ucInfo.Visible = type != null;

        if (this.ucInfo.Visible)
        {
            this.ucInfo.Type = (InfoType)type;

            string txt = string.Empty;

            switch (type)
            {
                case InfoType.Pollutant:
                    txt = Resources.GetGlobal("Facility", "FacilityInfoPollutant");
                    break;
                default:
                    txt = string.Empty;
                    break;
            }

            this.ucInfo.LinkText = txt;
        }
        
    }

    /// <summary>
    /// Hide
    /// </summary>
    private void hideSubControls()
    {
        this.ucFacilityDetails.Visible = false;
        this.ucFacilityPollutantReleases.Visible = false;
        this.ucFacilityPollutantTransfers.Visible = false;
        this.ucFacilityWaste.Visible = false;
        this.ucFacilityConfidentiality.Visible = false;
    }


    /// <summary>
    /// Content link clicked
    /// </summary>
    protected void linkClick(object sender, EventArgs e)
    {
        LinkButton button = sender as LinkButton;
        if (button != null)
        {
            showContent(button.CommandArgument);
        }
    }

    /// <summary>
    /// alert link clicked
    /// </summary>
    protected void alertClick(object sender, EventArgs e)
    {
        LinkButton button = sender as LinkButton;
        if (button != null)
        {
            string link = button.CommandArgument;
            showContent(link);
        }
    }

    protected void OnClickPrevious(object sender, EventArgs e)
    {
        switchYear(PreviousYear);
    }

    protected void OnClickNext(object sender, EventArgs e)
    {
        switchYear(NextYear);
    }

    private void switchYear(Facility.FacilityReportingYear fy)
    {
        if (fy != null)
        {
            this.Populate(fy.FacilityReportId.ToString(), Content);
        }

    }

}
