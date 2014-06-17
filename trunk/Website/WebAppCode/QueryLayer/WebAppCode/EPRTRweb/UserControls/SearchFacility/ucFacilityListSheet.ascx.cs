using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using EPRTR.Enums;
using EPRTR.HeaderBuilders;
using EPRTR.Localization;
using QueryLayer;
using QueryLayer.Filters;

public partial class ucFacilityListSheet : System.Web.UI.UserControl
{
    private const string FILTER = "FacilityListSheetFilter";
    private const string CONF_AFFECTED = "FacilityListSheetConfAffected";
       

    #region ViewState properties

    /// <value>
    /// The searchfilter
    /// </value>
    protected FacilitySearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as FacilitySearchFilter; }
        set { ViewState[FILTER] = value; }
    }

    protected bool ConfidentialityAffected
    {
        get { return (bool)ViewState[CONF_AFFECTED]; }
        set { ViewState[CONF_AFFECTED] = value; }
    }

    protected Sheets.FacilitySearch Sheet
    {
        get { return (Sheets.FacilitySearch)ViewState["Sheet"]; }
        set { ViewState["Sheet"] = value; }
    }


    #endregion


    /// <summary>
    /// load, setup links
    /// </summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.ucSheetLinks.ResetContentLinks();
            this.ucSheetLinks.SetLink( Resources.GetGlobal("Facility","Facilities"), Sheets.FacilitySearch.Facilities.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("Facility", "Confidentiality"), Sheets.FacilitySearch.Confidentiality.ToString());
        }

        if (this.ucSheetLinks.Linkclick == null)
            this.ucSheetLinks.Linkclick = new EventHandler(linkClick);

        if (this.ucSheetSubHeader.AlertClick == null)
            this.ucSheetSubHeader.AlertClick = new EventHandler(alertClick);

        if (this.ucDownloadPrint.DoSave == null)
            this.ucDownloadPrint.DoSave = new EventHandler(DoSaveCSV);

        if (this.ucFacilityListResult.ContentChanged == null)
            this.ucFacilityListResult.ContentChanged = new EventHandler(contentChanged);
    }


    /// <summary>
    /// Search, fill data into summery
    /// </summary>
    public void Populate(FacilitySearchFilter filter)
    {
        SearchFilter = filter;

        ConfidentialityAffected = Facility.IsAffectedByConfidentiality(filter); //Only determine once and store in viewstate
        showContent(Sheets.FacilitySearch.Facilities.ToString());
    }
    

    /// <summary>
    /// Content link clicked
    /// </summary>
    protected void linkClick(object sender, EventArgs e)
    {
        LinkButton button = sender as LinkButton;
        if (button != null)
        {
            string link = button.CommandArgument;
            showContent(link);
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

    private void showContent(string command)
    {
        
        hideSubControls();
        this.ucSheetLinks.HighLight(command);
        string txt = string.Empty;
        string alert = string.Empty;

        FacilitySearchFilter filter = SearchFilter;
        bool conf = ConfidentialityAffected;

        if (command.Equals(Sheets.FacilitySearch.Facilities.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "FacilityListResult");
            this.ucFacilityListResult.Visible = true;
           this.ucFacilityListResult.Populate(filter);
            alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlertLink") : String.Empty;
            
            // activate download and print button
            this.ucDownloadPrint.Visible = true;
            this.ucDownloadPrint.Show(true, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.FacilitySearch.Facilities;
        }
        else if (command.Equals(Sheets.FacilitySearch.Confidentiality.ToString()))
        {
            this.litHeadline.Text = Resources.GetGlobal("Facility", "FacilityListConfidentiality");
            this.ucFacilityListConfidentiality.Visible = true;
            this.ucFacilityListConfidentiality.Populate(filter);
            alert = conf ? Resources.GetGlobal("Common", "ConfidentialityAlert")  : String.Empty;

            // allow print
            this.ucDownloadPrint.Visible = true;
            this.ucDownloadPrint.Show(false, true);
            this.ucDownloadPrint.SetPrintControl(this);

            Sheet = Sheets.FacilitySearch.Confidentiality;
           
        }

        updateHeader(txt);
        updateAlert(alert);

       
    }

    private void updateHeader(string text)
    {
        FacilitySearchFilter filter = SearchFilter;

        // populate header
        Dictionary<string, string> header = SheetHeaderBuilder.GetFacilitySearchHeader(filter, true);
        this.ucSheetSubHeader.PopulateHeader(header);
        this.ucSheetSubHeader.Text = text;
    }

    private void updateAlert(string alert)
    {
        this.ucSheetSubHeader.AlertText = alert;
        this.ucSheetSubHeader.AlertCommandArgument = Sheets.FacilitySearch.Confidentiality.ToString();
    }

    private void hideSubControls()
    {
        this.ucFacilityListResult.Visible = false;
        this.ucFacilityListConfidentiality.Visible = false;
    }

    public void DoSaveCSV(object sender, EventArgs e)
    {
        switch (Sheet)
        {
            case Sheets.FacilitySearch.Facilities:
                this.ucFacilityListResult.DoSaveCSV(this, EventArgs.Empty);
                break;
            default:
                break;
        }
    }
    
    /// <summary>
    /// update the printable control
    /// </summary>
    private void contentChanged(object sender, EventArgs e)
    {
        this.ucDownloadPrint.SetPrintControl(this);
    }
}
