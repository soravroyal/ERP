using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Localization;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using EPRTR.Formatters;
using System.Globalization;
using EPRTR.CsvUtilities;
using System.Linq;

public partial class ucPollutantTransfersFacilities : System.Web.UI.UserControl
{
    public EventHandler ContentChanged;
    private const string FILTER = "PollutantTransfersSearchFilter";
    private const string PAGEINDEX = "pageindex";

    /// <summary>
    /// prop
    /// </summary>
    private PollutantTransfersSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as PollutantTransfersSearchFilter; }
        set { ViewState[FILTER] = value; }
    }
    private int PageIndex
    {
        get { return (int)ViewState[PAGEINDEX]; }
        set { ViewState[PAGEINDEX] = value; }
    }
    

    /// <summary>
    /// Page load
    /// </summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
            this.datapager.SetPageProperties(0, getPageSize(), false);
    }

    /// <summary>
    /// Fill the table with data or provide no data.
    /// </summary>
    public void Populate(QueryLayer.Filters.PollutantTransfersSearchFilter filter)
    {
        // assign current view states
        SearchFilter = filter;
        PageIndex = 0;
        populateList(filter, "FacilityName");

        this.datapager.SetPageProperties(0, getPageSize(), false);
        this.datapager.Visible = (filter.Count > getPageSize());
    }

    /// <summary>
    /// Open sheet
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
                closeAllSheets(); // only allow 1 sheet open

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
        imgReset = (Image)c.FindControl("upQuantity"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downQuantity"); if (imgReset != null) imgReset.Visible = false;
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
            case "Quantity":
                imgUp = (Image)c.FindControl("upQuantity");
                imgDown = (Image)c.FindControl("downQuantity");
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
            bool descending = ViewState[header] != null && (bool)ViewState[header];
            imgUp.Visible = descending;
            imgDown.Visible = !descending;
        }
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
    private void populateList(PollutantTransfersSearchFilter filter, string sortColumn)
    {
        int startRowIndex = PageIndex;

        bool descending = ViewState[sortColumn] != null && (bool)ViewState[sortColumn];
        this.lvFacilityResult.DataSource = QueryLayer.PollutantTransfers.FacilityList(filter, sortColumn, descending, startRowIndex, getPageSize());
        this.lvFacilityResult.DataBind();

        // save current sort column (to be used in pageing)
        ViewState["sortcolumn"] = sortColumn;

        if (ContentChanged != null)
            ContentChanged.Invoke(null, EventArgs.Empty);
    }
    
    /// <summary>
    /// populate and sort
    /// </summary>
    private void sort(string sortColumn)
    {
        // when sorting according to column, jump to pageindex 0 (requirement)
        PageIndex = 0;
        this.datapager.SetPageProperties(0, getPageSize(), false);

        bool descending = ViewState[sortColumn] != null && (bool)ViewState[sortColumn];
        ViewState[sortColumn] = !descending;

        populateList(SearchFilter, sortColumn);
    }


    /// <summary>
    /// Paging
    /// </summary>
    protected void OnPageChanging(object sender, PagePropertiesChangingEventArgs e)
    {
        PageIndex = e.StartRowIndex;
        this.datapager.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
    
        // column to sort by
        string sortColumn = ViewState["sortcolumn"].ToString();
        populateList(SearchFilter, sortColumn);
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

    /// <summary>
    /// return pagesize
    /// </summary>
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
            PollutantTransfersSearchFilter filter = SearchFilter;

            bool isConfidentialityAffected = PollutantTransfers.IsAffectedByConfidentiality(filter);

            Dictionary<string, string> header = EPRTR.HeaderBuilders.CsvHeaderBuilder.GetPollutantTransferSearchHeader(
                filter,
                isConfidentialityAffected);

            // Create Body
            var facilities = PollutantTransfers.GetFacilityListCSV(filter);

            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string facilityHeader = csvformat.GetPollutantTranfersFacilityHeader();

            string url = Request.Url.AbsoluteUri;
            url = url.Substring(0, url.LastIndexOf("/") + 1);

            Response.WriteUtf8FileHeader("EPRTR_Pollutant_Transfers_Facility_List");

            Response.Write(topheader + facilityHeader);

            foreach (var item in facilities)
            {
                item.Url = String.Format("{0}/PopupFacilityDetails.aspx?FacilityReportId={1}", url, item.FacilityReportId);

                string row = csvformat.GetPollutantTransfersFacilityRow(item);
                Response.Write(row);
            }

            Response.End();
        }
        catch
        {
        }
    }

    /// <summary>
    /// binding
    /// </summary>
    protected string GetQuantity(object obj)
    {
        PollutantTransfers.ResultFacility row = (PollutantTransfers.ResultFacility) obj;
        return QuantityFormat.Format(row.Quantity, row.QuantityUnit);
    }

    protected string GetActivityCode(object obj)
    {
        return ((PollutantTransfers.ResultFacility)obj).ActivityCode;
    }

    protected string GetActivityName(object obj)
    {
        return LOVResources.AnnexIActivityName(GetActivityCode(obj));
    }

    protected string GetCountryCode(object obj)
    {
        return ((PollutantTransfers.ResultFacility)obj).CountryCode;
    }
    protected string GetCountryName(object obj)
    {
        return LOVResources.CountryName(GetCountryCode(obj));
    }

    protected bool GetConfidentialIndicatorFacility(object obj)
    {
        return ((PollutantTransfers.ResultFacility)obj).ConfidentialIndicatorFacility;
    }
    protected int GetFacilityReportId(object obj)
    {
        return ((PollutantTransfers.ResultFacility)obj).FacilityReportId;
    }
    protected string GetFacilityName(object obj)
    {
        PollutantTransfers.ResultFacility row = (PollutantTransfers.ResultFacility) obj;
        return ConfidentialFormat.Format(row.FacilityName, row.ConfidentialIndicatorFacility);
    }
}
