using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.CsvUtilities;
using EPRTR.Formatters;
using EPRTR.Localization;
using QueryLayer;
using QueryLayer.Filters;

public partial class ucWasteTransferFacilities : System.Web.UI.UserControl
{
    public EventHandler ContentChanged;
    private const string FILTER = "WasteTransferSearchFilter";
    private const string SORTCOLUMN = "SortColumn";
    private const string PAGEINDEX = "pageindex";
    private const string WASTETYPE = "wasteType"; 

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            this.datapager.SetPageProperties(0, getPageSize(), false);
        }
    }


    /// <summary>
    /// prop
    /// </summary>
    public WasteTransferSearchFilter SearchFilter 
    { 
        get { return (WasteTransferSearchFilter)ViewState[FILTER]; }
        set { ViewState[FILTER] = value; }
    }
    public string SortColumn 
    {
        get { return (string)ViewState[SORTCOLUMN]; }
        set { ViewState[SORTCOLUMN] = value; }
    }
    public int PageIndex 
    { 
        get { return (int)ViewState[PAGEINDEX]; } 
        set { ViewState[PAGEINDEX]=value; } 
    }

    public WasteTypeFilter.Type SelectedWasteType
    {
        get { return (WasteTypeFilter.Type)ViewState[WASTETYPE]; }
        set { ViewState[WASTETYPE] = value; }
    }

    /// <summary>
    /// Fill the table with data or provide no data.
    /// </summary>
    /// <param name="filter"></param>
    public void Populate(
        WasteTransferSearchFilter filter, 
        WasteTransfers.FacilityCountObject counts)
    {
        // assign current view states
        SearchFilter = filter;
        PageIndex = 0;

        SortColumn = "FacilityName";

        // add radio button items to list if empty
        this.ucWasteTypeSelector.PopulateRadioButtonList(filter.WasteTypeFilter, counts);

        this.datapager.SetPageProperties(0, getPageSize(), false);
        this.datapager.Visible = (filter.Count > getPageSize());
    }


    protected void OnSelectedWasteTypeChanged(object sender, WasteTypeSelectedEventArgs e)
    {
        SelectedWasteType = e.WasteType;
        PopulateList(SearchFilter, SortColumn);
    }

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

        // get rowindex
        ListViewDataItem dataItem = e.Item as ListViewDataItem;
        if (dataItem == null) return; //safe check

        string source = e.CommandSource.ToString();
        string arg = e.CommandArgument.ToString();

        int rowindex = dataItem.DataItemIndex - PageIndex;
        if (rowindex >= 0 && rowindex < this.lvFacilityResult.Items.Count)
        {
            ucFacilitySheet control = (ucFacilitySheet)this.lvFacilityResult.Items[rowindex].FindControl("ucFacilitySheet");

            if (arg.Equals("togglesheet"))
            {
                closeAllSheets(); // only allow one sheet to be open

                control.Visible = !control.Visible;
                Control div = this.lvFacilityResult.Items[rowindex].FindControl("subsheet");
                div.Visible = !div.Visible;
                
                if (control.Visible)
                {
                    string facilityReportID = e.CommandName; //name holds the unique facility report ID
                    control.Populate(facilityReportID);
                }
            }
        }
    }


    /// <summary>
    /// set arrows
    /// </summary>
    private void setArrows(string header)
    {
        Control c = FindControl("lvFacilityResult");
        if (c == null) return; // safe check
        Image imgReset = null, imgUp = null, imgDown = null;

        imgReset = (Image)c.FindControl("upFacility"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downFacility"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("upRecovery"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downRecovery"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("upDisposal"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downDisposal"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("upUnspecified"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downUnspecified"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("upTotal"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downTotal"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("upActivity"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downActivity"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("upCountry"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downCountry"); if (imgReset != null) imgReset.Visible = false;

        switch (header)
        {
            case "FacilityName":
                imgUp = (Image)c.FindControl("upFacility");
                imgDown = (Image)c.FindControl("downFacility");
                break;
            case "QuantityRecovery":
                imgUp = (Image)c.FindControl("upRecovery");
                imgDown = (Image)c.FindControl("downRecovery");
                break;
            case "QuantityDisposal":
                imgUp = (Image)c.FindControl("upDisposal");
                imgDown = (Image)c.FindControl("downDisposal");
                break;
            case "QuantityUnspec":
                imgUp = (Image)c.FindControl("upUnspecified");
                imgDown = (Image)c.FindControl("downUnspecified");
                break;
            case "QuantityTotal":
                imgUp = (Image)c.FindControl("upTotal");
                imgDown = (Image)c.FindControl("downTotal");
                break;
            case "IAActivityCode":
                imgUp = (Image)c.FindControl("upActivity");
                imgDown = (Image)c.FindControl("downActivity");
                break;
            case "CountryCode":
                imgUp = (Image)c.FindControl("upCountry");
                imgDown = (Image)c.FindControl("downCountry");
                break;
            default:
                break;
        }

        if (imgUp != null && imgDown != null)
        {
            bool descending = sortDescending(header);
            imgUp.Visible = descending;
            imgDown.Visible = !descending;
        }
    }

    /// <summary>
    /// sort
    /// </summary>
    private bool sortDescending(string header)
    {
        return ViewState[header] != null && (bool)ViewState[header];
    }

    /// <summary>
    /// Sorting event, collapse all panels
    /// </summary>
    protected void OnSorting(object sender, ListViewSortEventArgs e)
    {
        closeAllSheets();
    }
    
    /// <summary>
    /// populate and sort
    /// </summary>
    private void PopulateList(WasteTransferSearchFilter filter, string sortColumn)
    {
        SortColumn = sortColumn;
        int startRowIndex = PageIndex;

        bool descending = sortDescending(sortColumn);
        
        this.lvFacilityResult.DataSource = QueryLayer.WasteTransfers.FacilityList(
            filter,
            sortColumn,
            descending,
            startRowIndex,
            getPageSize(),
            SelectedWasteType);
             
        this.lvFacilityResult.DataBind();

        if (ContentChanged != null)
            ContentChanged.Invoke(null, EventArgs.Empty);

        if (filter.Count == 0)
        {
            this.ucWasteTypeSelector.Visible = false;
        }

        HideTreatmentColumns();
    }


    /// <summary>
    /// populate and sort
    /// </summary>
    private void sort(string sortColumn)
    {
        // when sorting according to column, jump to pageindex 0 (requirement)
        PageIndex = 0;
        SortColumn = sortColumn;

        this.datapager.SetPageProperties(0, getPageSize(), false);
        
        bool descending = sortDescending(sortColumn);
        ViewState[sortColumn] = !descending;

        PopulateList(SearchFilter, sortColumn);
    }


    /// <summary>
    /// Paging
    /// </summary>
    protected void OnPageChanging(object sender, PagePropertiesChangingEventArgs e)
    {
        PageIndex = e.StartRowIndex;
        this.datapager.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
        PopulateList(SearchFilter, SortColumn);
    }
    
    /// <summary>
    /// Close sheets
    /// </summary>
    private void closeAllSheets()
    {
        for (int i = 0; i < this.lvFacilityResult.Items.Count; i++)
        {
            ucFacilitySheet control = (ucFacilitySheet)this.lvFacilityResult.Items[i].FindControl("ucFacilitySheet");
            if (control != null) control.Visible = false;
        }
    }

    private int getPageSize()
    {
        return Int32.Parse(ConfigurationManager.AppSettings["FacilityListPageSize"]);
    }



    public void DoSaveCSV(object sender, EventArgs e)
    {
        try
        {
            CultureInfo csvCulture = CultureResolver.ResolveCsvCulture(Request);
            CSVFormatter csvformat = new CSVFormatter(csvCulture);

            // Create Header
            var filter = SearchFilter;

            bool isConfidentialityAffected = WasteTransfers.IsAffectedByConfidentiality(filter);

            var tempFilter = filter.Clone() as WasteTransferSearchFilter;
            tempFilter.WasteTypeFilter = new WasteTypeFilter(SelectedWasteType);

            Dictionary<string, string> header = EPRTR.HeaderBuilders.CsvHeaderBuilder.GetWasteTransfersSearchHeader(
                tempFilter,
                isConfidentialityAffected);

            // Create Body
            var facilities = WasteTransfers.GetFacilityListCSV(tempFilter);

            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string facilityHeader = csvformat.GetWasteTransfersFacilityHeader();

            string url = Request.Url.AbsoluteUri;
            url = url.Substring(0, url.LastIndexOf("/") + 1);

            Response.WriteUtf8FileHeader("EPRTR_Waste_Transfers_Facility_List");

            Response.Write(topheader + facilityHeader);

            foreach (var item in facilities)
            {
                item.Url = String.Format("{0}/PopupFacilityDetails.aspx?FacilityReportId={1}", url, item.FacilityReportId);

                string row = csvformat.GetWasteTransfersFacilityRow(item);
                Response.Write(row);
            }

            Response.End();
        }
        catch
        {
        }
    }


    #region databinding methods

    //Hide headers dependend on filter selections.
    protected void HideTreatmentColumns()
    {
        Control header;
        
        header = (Control)this.lvFacilityResult.FindControl("headerQuantityTotal");
        if (header != null)
        {
            header.Visible = ShowTreatmentTotal;
        }
        header = (Control)this.lvFacilityResult.FindControl("headerQuantityRecovery");
        if (header != null)
        {
            header.Visible = ShowRecovery;
        }
        header = (Control)this.lvFacilityResult.FindControl("headerQuantityDisposal");
        if (header != null)
        {
            header.Visible = ShowDisposal;
        }
        header = (Control)this.lvFacilityResult.FindControl("headerQuantityUnspecified");
        if (header != null)
        {
            header.Visible = ShowUnspecified;
        }

    }


    protected bool ShowRecovery
    {
        get { return SearchFilter.WasteTreatmentFilter.Recovery; }
    }

    protected bool ShowDisposal
    {
        get { return SearchFilter.WasteTreatmentFilter.Disposal; }
    }

    protected bool ShowUnspecified
    {
        get { return SearchFilter.WasteTreatmentFilter.Unspecified; }
    }

    protected bool ShowTreatmentTotal
    {
        get
        {
            return
                SearchFilter.WasteTreatmentFilter.Recovery
                && SearchFilter.WasteTreatmentFilter.Disposal
                && SearchFilter.WasteTreatmentFilter.Unspecified;
        }
    }


    protected int GetFacilityReportId(object obj)
    {
        return ((WasteTransfers.ResultFacility)obj).FacilityReportId;
    }
    protected string GetFacilityName(object obj)
    {
        WasteTransfers.ResultFacility row = (WasteTransfers.ResultFacility)obj;
        return ConfidentialFormat.Format(row.FacilityName, row.ConfidentialIndicatorFacility);
    }
    protected string GetTotal(object obj)
    {
        WasteTransfers.ResultFacility row = (WasteTransfers.ResultFacility)obj;
        bool conf = row.ConfidentialIndicatorRecovery || row.ConfidentialIndicatorDisposal || row.ConfidentialIndicatorUnspecified;
        return QuantityFormat.Format(row.QuantityTotal, row.QuantityCommonUnit, conf);
    }
    protected string GetRecovery(object obj)
    {
        WasteTransfers.ResultFacility row = (WasteTransfers.ResultFacility)obj;
        return QuantityFormat.Format(row.QuantityRecovery, row.QuantityCommonUnit, row.ConfidentialIndicatorRecovery);
    }
    protected string GetDisposal(object obj)
    {
        WasteTransfers.ResultFacility row = (WasteTransfers.ResultFacility)obj;
        return QuantityFormat.Format(row.QuantityDisposal, row.QuantityCommonUnit, row.ConfidentialIndicatorDisposal);
    }
    protected string GetUnspec(object obj)
    {
        WasteTransfers.ResultFacility row = (WasteTransfers.ResultFacility)obj;
        return QuantityFormat.Format(row.QuantityUnspecified, row.QuantityCommonUnit, row.ConfidentialIndicatorUnspecified);
    }
    protected string GetActivity(object obj)
    {
        return ((WasteTransfers.ResultFacility)obj).ActivityCode;
    }
    protected string GetActivityToolTip(object obj)
    {
        return LOVResources.AnnexIActivityName(((WasteTransfers.ResultFacility)obj).ActivityCode);
    }
    protected string GetCountry(object obj)
    {
        return ((WasteTransfers.ResultFacility)obj).CountryCode;
    }
    protected string GetCountryToolTip(object obj)
    {
        return LOVResources.CountryName(((WasteTransfers.ResultFacility)obj).CountryCode);
    }

    #endregion

}
