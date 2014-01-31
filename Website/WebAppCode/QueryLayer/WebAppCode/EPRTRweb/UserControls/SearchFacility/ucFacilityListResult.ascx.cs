using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using QueryLayer;
using QueryLayer.Filters;
using EPRTR.Localization;
using QueryLayer.Utilities;
using EPRTR.Formatters;
using EPRTR.CsvUtilities;
using EPRTR.HeaderBuilders;
using System.Globalization;

public partial class ucFacilityListResult : System.Web.UI.UserControl
{
    private const string FILTER = "facilitysearchfilter";
    private const string PAGEINDEX = "pageindex";
    private const string SORTCOLUMN = "sortcolumn";
    public EventHandler ContentChanged;

    protected FacilitySearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as FacilitySearchFilter; }
        set { ViewState[FILTER] = value; }
    }

    /// <summary>
    /// Page load, init pageing
    /// </summary>
    /// <param name="sender"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
            this.datapager.SetPageProperties(0, getPageSize(), false);
    }


    /// <summary>
    /// Basic populate, order by facility as default
    /// </summary>
    public void Populate(FacilitySearchFilter filter)
    {
       
        Control prop = this.Parent;

        // assign current view states
        SearchFilter = filter;
        ViewState[PAGEINDEX] = 0;

        // always start on page 1 when populate
        this.datapager.SetPageProperties(0, getPageSize(), false);
        this.datapager.Visible = (filter.Count > getPageSize());

        // fill listview
        populateList(filter, "FacilityName");
        this.datapager.Visible = (filter.Count > getPageSize());
       
    }


    /// <summary>
    /// set arrows
    /// </summary>
    private void setArrows(string header)
    {
        Control c = FindControl("lvFacilityResult");
        if (c == null) return; // safe check
        Image imgReset = null, imgUp = null, imgDown = null;

        imgReset = (Image)c.FindControl("upFacility"); if (imgReset!=null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downFacility"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("upPostalCode"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downPostalCode"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("upAddress"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downAddress"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("upTownVillage"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downTownVillage"); if (imgReset != null) imgReset.Visible = false;
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
            case "PostalCode":
                imgUp = (Image)c.FindControl("upPostalCode");
                imgDown = (Image)c.FindControl("downPostalCode");
                break;
            case "Address":
                imgUp = (Image)c.FindControl("upAddress");
                imgDown = (Image)c.FindControl("downAddress");
                break;
            case "City":
                imgUp = (Image)c.FindControl("upTownVillage");
                imgDown = (Image)c.FindControl("downTownVillage");
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
    /// On item command
    /// </summary>
    protected void OnItemCommand(object sender, ListViewCommandEventArgs e)
    {
        // sorting
        if (e.CommandName == "Sort")
        {
            // set arrows
            setArrows(e.CommandArgument.ToString());
            // apply sort
            sort(e.CommandArgument.ToString());
            return;
        }

        // get rowindex
        ListViewDataItem dataItem = e.Item as ListViewDataItem;
        if (dataItem == null) return; //safe check
        
        int pageindex = (int)ViewState[PAGEINDEX];
        int rowindex = dataItem.DataItemIndex - pageindex;
        if (rowindex >= 0 && rowindex < this.lvFacilityResult.Items.Count)
        {
            string arg = e.CommandArgument.ToString();
            ucFacilitySheet control = (ucFacilitySheet)this.lvFacilityResult.Items[rowindex].FindControl("ucFacilitySheet");
            if (control!=null && arg.Equals("togglesheet"))
            {
                // only allow one sheet to be open
                closeAllSheets();

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
    /// populate and sort
    /// </summary>
    private void populateList(FacilitySearchFilter filter, string sortColumn)
    {
        int startRowIndex = (int)ViewState[PAGEINDEX];
        bool descending = ViewState[sortColumn] != null && (bool)ViewState[sortColumn];
        
        // bind data to list
        this.lvFacilityResult.Items.Clear();

        this.lvFacilityResult.DataSource = QueryLayer.Facility.FacilityList(filter, sortColumn, descending, startRowIndex, getPageSize());
        this.lvFacilityResult.DataBind();
        
        // hide help text if no data found
        this.lbHelpText.Visible = (this.lvFacilityResult.Items.Count != 0);

        // save current sort column (to be used in pageing)
        ViewState[SORTCOLUMN] = sortColumn;

        // notify change of content (for printing)
        if (ContentChanged != null)
            ContentChanged.Invoke(null, EventArgs.Empty);

        
    }


    /// <summary>
    /// populate and sort
    /// </summary>
    private void sort(string sortColumn)
    {
       
        // when sorting according to column, jump to pageindex 0 (requirement)
        ViewState[PAGEINDEX] = 0;
        this.datapager.SetPageProperties(0, getPageSize(), false);
                
        // set descending state
        bool descending = ViewState[sortColumn] != null && (bool)ViewState[sortColumn];
        ViewState[sortColumn] = !descending;
        
        // get filter
        FacilitySearchFilter currentfilter = SearchFilter;

        // redo the populate according to the sorting
         populateList(currentfilter, sortColumn);
    }
    

    /// <summary>
    /// Paging changed
    /// </summary>
    protected void OnPageChanging(object sender, PagePropertiesChangingEventArgs e)
    {
       
        ViewState[PAGEINDEX] = e.StartRowIndex;
        this.datapager.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
    
        // column to sort by
        string sortColumn = ViewState[SORTCOLUMN].ToString();
        FacilitySearchFilter currentfilter = SearchFilter;

        // redo the populate
        populateList(currentfilter, sortColumn);
    }


    /// <summary>
    /// Sorting event, collapse all panels
    /// </summary>
    protected void OnSorting(object sender, ListViewSortEventArgs e)
    {
        closeAllSheets();
    }

    /// <summary>
    /// close all sheets
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

    /// <summary>
    /// Save
    /// </summary>
    /// 
    public void DoSaveCSV(object sender, EventArgs e)
    {
        try
        {
            CultureInfo csvCulture = CultureResolver.ResolveCsvCulture(Request);
            CSVFormatter csvformat = new CSVFormatter(csvCulture);

            // Create Header
            FacilitySearchFilter filter = SearchFilter;
            bool isConfidentialityAffected = Facility.IsAffectedByConfidentiality(filter);

            Dictionary<string, string> header = CsvHeaderBuilder.GetFacilitySearchHeader(
                filter,
                isConfidentialityAffected);

            // Create Body
            List<Facility.FacilityCSV> facilities = Facility.GetFacilityListCSV(filter);

            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string facilityHeader = csvformat.GetFacilityHeader();

            string url = Request.Url.AbsoluteUri;
            url = url.Substring(0, url.LastIndexOf("/") + 1);

            Response.WriteUtf8FileHeader("EPRTR_Facility_List");

            Response.Write(topheader + facilityHeader);

            foreach (var v in facilities)
            {
                // translate codes
                v.ActivityName = LOVResources.AnnexIActivityName(v.ActivityCode);
                v.CountryName = LOVResources.CountryName(v.CountryCode);
                v.NutsRegionName = LOVResources.NutsRegionName(v.NutsRegionCode);
                v.RiverBasinName = LOVResources.RiverBasinDistrictName(v.RiverBasinCode);

                v.FacilityName = ConfidentialFormat.Format(v.FacilityName, v.Confidential);
                v.PostalCode = ConfidentialFormat.Format(v.PostalCode, v.Confidential);
                v.Address = ConfidentialFormat.Format(v.Address, v.Confidential);
                v.City = ConfidentialFormat.Format(v.City, v.Confidential);
                v.URL = String.Format("{0}/PopupFacilityDetails.aspx?FacilityReportId={1}", url, v.FacilityReportID);

                string row = csvformat.GetFacilityRow(v);

                Response.Write(row);
            }

            Response.End();
        }
        catch
        {
        }
    }



    #region Populate data fields
    /// <summary>
    /// Return fields
    /// </summary>
    protected string GetFacilityReportId(object obj)
    {
        return ((FacilityRow)obj).FacilityReportId.ToString();
    }
    protected string GetFacilityId(object obj)
    {
        return ((FacilityRow)obj).FacilityId.ToString();
    }
    protected string GetCountryCode(object obj)
    {
        return ((FacilityRow)obj).CountryCode;
    }

    protected string GetCountryName(object obj)
    {
        FacilityRow row = (FacilityRow)obj;
        return LOVResources.CountryName(row.CountryCode);
    }

    protected string GetActivityCode(object obj)
    {
        return ((FacilityRow)obj).ActivityCode;
    }

    protected string GetActivityName(object obj)
    {
        FacilityRow row = (FacilityRow)obj;
        return LOVResources.AnnexIActivityName(row.ActivityCode);
    }

    protected string GetFacilityName(object obj)
    {
        FacilityRow row = (FacilityRow) obj;
        return ConfidentialFormat.Format(row.FacilityName, row.ConfidentialIndicator);
    }

    protected string GetPostalCode(object obj)
    {
        FacilityRow row = (FacilityRow)obj;
        return ConfidentialFormat.Format(row.PostalCode, row.ConfidentialIndicator);  
    }
    protected string GetAddress(object obj)
    {
        FacilityRow row = (FacilityRow)obj;
        return ConfidentialFormat.Format(row.Address, row.ConfidentialIndicator);
    }
    protected string GetCity(object obj)
    {
        FacilityRow row = (FacilityRow)obj;
        return ConfidentialFormat.Format(row.City, row.ConfidentialIndicator); 
    }
    protected bool GetConfidentialIndicator(object obj)
    {
        return ((FacilityRow)obj).ConfidentialIndicator;
    }
    protected int GetReportingYear(object obj)
    {
        return ((FacilityRow)obj).ReportingYear;
    }

    #endregion


}
