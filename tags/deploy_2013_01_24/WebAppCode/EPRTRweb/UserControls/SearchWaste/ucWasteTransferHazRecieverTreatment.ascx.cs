using System;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer.Filters;
using EPRTR.Utilities;
using EPRTR.Localization;
using QueryLayer.Utilities;
using QueryLayer;
using EPRTR.Formatters;

public partial class ucWasteTransferHazRecieverTreatment : System.Web.UI.UserControl
{
    private const string FILTER = "WasteTransferHazRecieverTreatmentFilter";
    private const string COUNTRYCODE = "WasteTransferCountryCode";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            this.datapager.SetPageProperties(0, getPageSize(), false);
        }
    }

    /// <summary>
    /// Fill the table with data or provide no data.
    /// </summary>
    public void Populate(WasteTransferSearchFilter filter, string countryCode)
    {
        // assign current view states
        SearchFilter = filter;
        CountryCode = countryCode;

        ViewState["pageindex"] = 0;

        // reversed order of commands compared to other pages
        this.datapager.SetPageProperties(0, getPageSize(), false);
        PopulateList(filter, "FacilityName", countryCode);
        setArrows("FacilityName", true);

        this.datapager.Visible = (filter.Count > getPageSize());
    }
    
    /// <summary>
    /// search filter to be used by sub sheet
    /// </summary>
    public WasteTransferSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as WasteTransferSearchFilter; }
        set { ViewState[FILTER] = value; }
    }

    /// <summary>
    /// country code
    /// </summary>
    public string CountryCode
    {
        get { return (string)ViewState[COUNTRYCODE]; }
        set { ViewState[COUNTRYCODE] = value; }
    }

    /// <summary>
    /// Sorting
    /// </summary>
    protected void OnItemCommand(object sender, ListViewCommandEventArgs e)
    {
        // sorting
        if (e.CommandName == "Sort")
        {
            // set arrows
            setArrows(e.CommandArgument.ToString());
            sort(e.CommandArgument.ToString());
            return;
        }
    }


    /// <summary>
    /// new search on facility click
    /// </summary>
    protected void onFacilitySearchClick(object sender, CommandEventArgs e)
    {
        string[] args = e.CommandArgument.ToString().Split('¤');
        if (args == null || args.Length != 2) return; // safe check
        string facilityName = args[0];
        string treatment = args[1].ToUpper().Trim();
                        
        // create facility search filter
        FacilitySearchFilter filter = FilterConverter.ConvertToFacilitySearchFilter(SearchFilter);

        // wastetype
        filter.WasteTypeFilter = new WasteTypeFilter();
        filter.WasteTypeFilter.NonHazardousWaste = false;
        filter.WasteTypeFilter.HazardousWasteCountry = false;
        filter.WasteTypeFilter.HazardousWasteTransboundary = true;
        
        // receiver
        filter.WasteReceiverFilter = new WasteReceiverFilter();
        filter.WasteReceiverFilter.CountryID = QueryLayer.ListOfValues.GetCountry(CountryCode).LOV_CountryID;

        // location        
        filter.FacilityLocationFilter = new FacilityLocationFilter();
        filter.FacilityLocationFilter.FacilityName = facilityName;
        filter.FacilityLocationFilter.CityName = String.Empty;

        // treatmentSafe check, make sure a treatment is present in order to get result
        bool unspec = treatment.Equals("U"), rec = treatment.Equals("R"), disp = treatment.Equals("D");
        if (!disp && !rec && !unspec)
        {
            // safe check, make sure a treatment is present in order to get result
            filter.WasteTreatmentFilter = LinkSearchBuilder.GetWasteTreatmentFilter(true, true, true);
        }
        else
            filter.WasteTreatmentFilter = LinkSearchBuilder.GetWasteTreatmentFilter(unspec, rec, disp);
        

        // create new facility search
        LinkSearchRedirecter.ToFacilitySearch(Response, filter);
    }

    protected string GetToolTipFacilitySearch()
    {
        return Resources.GetGlobal("Common", "LinkSearchFacility");
    }
        
    protected void OnSorting(object sender, ListViewSortEventArgs e)
    {
        // Nothing to do here. Method be present.
    }
        
    
    /// <summary>
    /// set arrows
    /// </summary>
    private void setArrows(string header)
    {
        setArrows(header, false);
    }
    private void setArrows(string header, bool initialSort)
    {
        Control c = FindControl("_lvTreaterResult");
        if (c == null) return; // safe check
        Image imgReset = null, imgUp = null, imgDown = null;

        imgReset = (Image)c.FindControl("upFacility"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downFacility"); if (imgReset != null) imgReset.Visible = false;

        imgReset = (Image)c.FindControl("upTreatment"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downTreatment"); if (imgReset != null) imgReset.Visible = false;

        imgReset = (Image)c.FindControl("upTreaterName"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downTreaterName"); if (imgReset != null) imgReset.Visible = false;
        
        imgReset = (Image)c.FindControl("upQuantity"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downQuantity"); if (imgReset != null) imgReset.Visible = false;
        
        switch (header)
        {
            case "FacilityName":
                imgUp = (Image)c.FindControl("upFacility");
                imgDown = (Image)c.FindControl("downFacility");
                break;
            case "WasteTreatmentCode":
                imgUp = (Image)c.FindControl("upTreatment");
                imgDown = (Image)c.FindControl("downTreatment");
                break;
            case "WHPName":
                imgUp = (Image)c.FindControl("upTreaterName");
                imgDown = (Image)c.FindControl("downTreaterName");
                break;
            case "Quantity":
                imgUp = (Image)c.FindControl("upQuantity");
                imgDown = (Image)c.FindControl("downQuantity");
                break;
            default:
                break;
        }

        if (imgUp != null && imgDown != null)
        {
            bool descending = ViewState[header] != null && (bool)ViewState[header];
            imgUp.Visible = descending;
            imgDown.Visible = !descending;

            // override if initial sort
            if (initialSort)
            {
                imgUp.Visible = true;
                imgDown.Visible = false;
            }

        }
    }


    /// <summary>
    /// populate and sort
    /// </summary>
    private void PopulateList(WasteTransferSearchFilter filter, string sortColumn, string countryCode)
    {
        int startRowIndex = (int)ViewState["pageindex"];
        
        bool descending = ViewState[sortColumn] != null && (bool)ViewState[sortColumn];
        
        this._lvTreaterResult.DataSource = QueryLayer.WasteTransfers.HazardousWasteTreaterList(
            filter,
            sortColumn,
            descending,
            startRowIndex,
            getPageSize(),
            countryCode);

        this._lvTreaterResult.DataBind();

        // save current sort column (to be used in pageing)
        ViewState["sortcolumn"] = sortColumn;
        CountryCode = countryCode;
    }


    /// <summary>
    /// populate and sort
    /// </summary>
    private void sort(string sortColumn)
    {
        // when sorting according to column, jump to pageindex 0 (requirement)
        ViewState["pageindex"] = 0;
        
        ViewState["sortcolumn"] = sortColumn;

        this.datapager.SetPageProperties(0, getPageSize(), false);

        bool descending = ViewState[sortColumn] != null && (bool)ViewState[sortColumn];
        ViewState[sortColumn] = !descending;

        WasteTransferSearchFilter currentFilter = ViewState[FILTER] as WasteTransferSearchFilter;

        PopulateList(currentFilter, sortColumn, CountryCode);
    }


    /// <summary>
    /// Paging
    /// </summary>
    protected void OnPageChanging(object sender, PagePropertiesChangingEventArgs e)
    {
        ViewState["pageindex"] = e.StartRowIndex;

        this.datapager.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);

        // column to sort by
        string sortColumn = ViewState["sortcolumn"].ToString();
        
        PopulateList(SearchFilter, sortColumn, CountryCode);
    }

    
    private int getPageSize()
    {
        return Int32.Parse(ConfigurationManager.AppSettings["FacilityListPageSize"]);
    }


    protected bool ShowFacilityLink(object obj)
    {
        WasteTransfers.ResultHazardousWasteTreater row = (WasteTransfers.ResultHazardousWasteTreater)obj;

        return row.FromFacilityName != null;
    }


    protected string GetFromFacilityName(object obj)
    {
        WasteTransfers.ResultHazardousWasteTreater row = (WasteTransfers.ResultHazardousWasteTreater)obj;
        return ConfidentialFormat.Format(row.FromFacilityName, row.FacilityConfidentialIndicator);
    }

    protected string GetFacilityCommand(object obj)
    {
        WasteTransfers.ResultHazardousWasteTreater row = (WasteTransfers.ResultHazardousWasteTreater)obj;

        string treatmentCode = row.Treatment == null ? "U" : row.Treatment;

        return row.FromFacilityName + "¤" + treatmentCode;
    }

    protected string GetTreatment(object obj)
    {
        WasteTransfers.ResultHazardousWasteTreater row = (WasteTransfers.ResultHazardousWasteTreater)obj;
        
        string treatmentCode = row.Treatment == null ? "U" : row.Treatment;

        return LOVResources.WasteTreatmentName(treatmentCode);
    }

    protected string GetTreaterName(object obj)
    {
        WasteTransfers.ResultHazardousWasteTreater row = (WasteTransfers.ResultHazardousWasteTreater)obj;
        return ConfidentialFormat.Format(row.TreaterName, row.ConfidentialIndicator);
    }

    protected string GetTreaterAddress(object obj)
    {
        WasteTransfers.ResultHazardousWasteTreater row = (WasteTransfers.ResultHazardousWasteTreater)obj;
        return AddressFormat.Format(row.TreaterAddress, row.TreaterCity, row.TreaterPostalCode, row.TreaterCountryCode, row.ConfidentialIndicator);
    }

    //protected string GetTreaterCountryCode(object obj)
    //{
    //    return ((QueryLayer.WasteTransfers.ResultHazardousWasteTreater)obj).TreaterCountryCode;
    //}


    protected string GetTreaterSiteAddress(object obj)
    {
        WasteTransfers.ResultHazardousWasteTreater row = (WasteTransfers.ResultHazardousWasteTreater)obj;
        return AddressFormat.Format(row.TreaterSiteAddress, row.TreaterSiteCity, row.TreaterSitePostalCode, row.TreaterSiteCountryCode, row.ConfidentialIndicator);
    }
    //protected string GetTreaterSiteCountryCode(object obj)
    //{
    //    return ((QueryLayer.WasteTransfers.ResultHazardousWasteTreater)obj).TreaterSiteCountryCode;
    //}
    protected string GetQuantity(object obj)
    {
        WasteTransfers.ResultHazardousWasteTreater row = (WasteTransfers.ResultHazardousWasteTreater)obj;
        return QuantityFormat.Format(row.Quantity, row.Unit, row.ConfidentialIndicator);
    }

}


