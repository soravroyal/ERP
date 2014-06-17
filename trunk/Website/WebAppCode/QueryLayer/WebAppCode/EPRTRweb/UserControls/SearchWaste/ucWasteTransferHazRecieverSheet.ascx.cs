using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using QueryLayer;
using QueryLayer.Filters;
using EPRTR.Localization;
using EPRTR.Formatters;
using EPRTR.HeaderBuilders;
using EPRTR.Enums;



public partial class ucWasteTransferRecieverSheet : System.Web.UI.UserControl
{
    private const string FILTER = "WTR_wastetransferfilter";
    private const string COUNTRY = "WTR_countryCode";
    private const string CONF_AFFECTED = "WTR_confidentialityAffected";

    #region ViewState properties
    /// <summary>
    /// Prop for country code
    /// </summary>
    protected string CountryCode
    {
        get { return ViewState[COUNTRY].ToString(); }
        set { ViewState[COUNTRY] = value; }
    }

    /// <summary>
    /// set search filter to be used by sub sheets
    /// </summary>
    protected WasteTransferSearchFilter WasteTransferSearchFilter
    {
        get { return ViewState[FILTER] as WasteTransferSearchFilter; }
        set { ViewState[FILTER] = value; }
    }

    protected bool ConfidentialityAffected
    {
        get { return (bool)ViewState[CONF_AFFECTED]; }
        set { ViewState[CONF_AFFECTED] = value; }
    }


    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        this.ucSheetLinks.ResetContentLinks();
        this.ucSheetLinks.SetLink(Resources.GetGlobal("WasteTransfers", "ContentHazRecieversTreatment"), Sheets.WasteReceiverDetails.Treaters.ToString());
        this.ucSheetLinks.SetLink(Resources.GetGlobal("Common", "ContentConfidientiality"), Sheets.WasteReceiverDetails.Confidentiality.ToString());

        if (this.ucSheetLinks.Linkclick == null)
            this.ucSheetLinks.Linkclick = new EventHandler(linkClick);

        if (this.ucSheetSubHeader.AlertClick == null)
            this.ucSheetSubHeader.AlertClick = new EventHandler(alertClick);
    }


        /// <summary>
    /// Search, fill data into summery
    /// </summary>
    public void Populate(WasteTransferSearchFilter filter, string countryCode)
    {
        WasteTransferSearchFilter = filter;
        CountryCode = countryCode;
        ConfidentialityAffected = WasteTransfers.IsHazardousWasteAffectedByConfidentiality(filter, CountryCode); //Only determine once and store in viewstate

        showContent(Sheets.WasteReceiverDetails.Treaters.ToString());
    }




    private void showContent(string command)
    {
        hideSubControls();
        this.ucSheetLinks.HighLight(command);
        string txt = string.Empty;
        WasteTransferSearchFilter filter = this.WasteTransferSearchFilter;

        bool conf = ConfidentialityAffected;
        string alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : string.Empty;

        if (command.Equals(Sheets.WasteReceiverDetails.Treaters.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("WasteTransfers", "HazWasteTreater");
            this.ucSheetTitleIcon.ImageURL = null;
            txt = Resources.GetGlobal("WasteTransfers", "AllValuesAreYearlyTransfersOnlyHW");
            this.ucHazRecieverTreatment.Populate(filter, this.CountryCode);
            this.ucHazRecieverTreatment.Visible = true;
        }
        else if (command.Equals(Sheets.WasteReceiverDetails.Confidentiality.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("WasteTransfers", "HazWasteConfidentiality");
            this.ucSheetTitleIcon.ImageURL = null;
            this.ucHazRecieverConfidentiality.Visible = true;
            this.ucHazRecieverConfidentiality.Populate(filter, conf, this.CountryCode);
        }
        else
        {
            this.litHeadline.Text = String.Empty;
            this.ucSheetTitleIcon.ImageURL = null;
        }

        updateHeader(filter, txt);
        updateAlert(alert);
    }

    /// <summary>
    /// Hide
    /// </summary>
    private void hideSubControls()
    {
        this.ucHazRecieverTreatment.Visible = false;
        this.ucHazRecieverConfidentiality.Visible = false;
    }


    /// <summary>
    /// update header
    /// </summary>
    private void updateHeader(WasteTransferSearchFilter filter, string text)
    {
        Dictionary<string, string> header = SheetHeaderBuilder.GetWasteTransferHazRecieverHeader(filter, false, CountryCode);
        this.ucSheetSubHeader.PopulateHeader(header);
        this.ucSheetSubHeader.Text = text;
    }


    private void updateAlert(string alert)
    {
        this.ucSheetSubHeader.AlertText = alert;
        this.ucSheetSubHeader.AlertCommandArgument = Sheets.WasteReceiverDetails.Confidentiality.ToString();
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

}
