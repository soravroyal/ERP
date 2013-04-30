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

public partial class ucPollutantReleasesFacilities : System.Web.UI.UserControl
{
    public EventHandler ContentChanged;
    private const string FILTER = "PollutantReleaseSearchFilter";
    private const string PAGEINDEX = "pageindex";
    private const string MEDIUM = "medium";
    private const string SORTCOLUMN = "sortcolumn";

    #region View state properties
    /// <summary>
    /// prop
    /// </summary>
    private PollutantReleaseSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as PollutantReleaseSearchFilter; }
        set { ViewState[FILTER] = value; }
    }
    private int PageIndex
    {
        get { return (int)ViewState[PAGEINDEX]; }
        set { ViewState[PAGEINDEX] = value; }
    }

    private MediumFilter.Medium SelectedMedium
    {
        get { return (MediumFilter.Medium)ViewState[MEDIUM]; }
        set { ViewState[MEDIUM] = value; }
    }

    private string SortColumn
    {
        get { return (string)ViewState[SORTCOLUMN]; }
        set { ViewState[SORTCOLUMN] = value; }
    }

    #endregion

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
    public void Populate(
        PollutantReleaseSearchFilter filter,
        PollutantReleases.FacilityCountObject counts)
    {
        // assign current view states
        SearchFilter = filter;
        PageIndex = 0;

        //default sortorder
        SortColumn = "FacilityName";

        // add radio button items to list if empty
        this.ucMediumSelector.PopulateMediumRadioButtonList(filter.MediumFilter, counts);

        this.datapager.SetPageProperties(0, getPageSize(), false);
        this.datapager.Visible = (filter.Count > getPageSize());
    }

   

    protected void OnSelectedMediumChanged(object sender, MediumSelectedEventArgs e)
    {
        SelectedMedium = e.Medium;
        UpdateSortColumnNames(e.Medium);
        PopulateList(SearchFilter, SortColumn);
    }

    /// <summary>
    /// open sheet
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
        imgReset = (Image)c.FindControl("upAccidental"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downAccidental"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("upPercentageAccidental"); if (imgReset != null) imgReset.Visible = false;
        imgReset = (Image)c.FindControl("downPercentageAccidental"); if (imgReset != null) imgReset.Visible = false;
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
            case "QuantityTotal":
                imgUp = (Image)c.FindControl("upQuantity");
                imgDown = (Image)c.FindControl("downQuantity");
                break;
            case "QuantityAccidental":
                imgUp = (Image)c.FindControl("upAccidental");
                imgDown = (Image)c.FindControl("downAccidental");
                break;
            case "PercentAccidental":
                imgUp = (Image)c.FindControl("upPercentageAccidental");
                imgDown = (Image)c.FindControl("downPercentageAccidental");
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

            if (header.Contains("Quantity") ||
                header.Contains("Percent"))
            {
                ViewState[header] = !descending;
            }
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
    private void PopulateList(PollutantReleaseSearchFilter filter, string sortColumn)
    {
        int startRowIndex = PageIndex;

        bool descending = ViewState[sortColumn] != null && (bool)ViewState[sortColumn];
        this.lvFacilityResult.DataSource = QueryLayer.PollutantReleases.FacilityList(
            filter,
            sortColumn,
            descending,
            startRowIndex,
            getPageSize(),
            SelectedMedium);

        this.lvFacilityResult.DataBind();
        
        // save current sort column (to be used in paging)
        SortColumn = sortColumn;

        // notify the change of content (print)
        if (ContentChanged != null)
            ContentChanged.Invoke(null, EventArgs.Empty);

        // no result, remove radio buttons
        this.ucMediumSelector.Visible = (filter.Count != 0);
    }


    /// <summary>
    /// populate and sort
    /// </summary>
    private void sort(string sortColumn)
    {
        // when sorting according to column, jump to pageindex 0 (requirement)
        PageIndex = 0;

        // Change sort column name to match the selected medium
        if (sortColumn == "QuantityTotal")
        {
            sortColumn = (string)ViewState["QuantityTotalColumnName"];
        }
        else if (sortColumn == "QuantityAccidental")
        {
            sortColumn = (string)ViewState["QuantityAccidentalColumnName"];
        }
        else if (sortColumn == "PercentAccidental")
        {
            sortColumn = (string)ViewState["PercentageAccidentalColumnName"];
        }

        SortColumn = sortColumn;

        this.datapager.SetPageProperties(0, getPageSize(), false);
        bool descending = ViewState[sortColumn] != null && (bool)ViewState[sortColumn];
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

        // column to sort by
        string sortColumn = SortColumn;
        PopulateList(SearchFilter, sortColumn);
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

    protected void UpdateSortColumnNames(MediumFilter.Medium selectedMedium)
    {
            switch (selectedMedium)
            {
                case MediumFilter.Medium.Air:
                    {
                        ViewState["QuantityTotalColumnName"] = "QuantityAir";
                        ViewState["QuantityAccidentalColumnName"] = "QuantityAccidentalAir";
                        ViewState["PercentageAccidentalColumnName"] = "PercentAccidentalAir";
                        break;
                    }
                case MediumFilter.Medium.Water:
                    {
                        ViewState["QuantityTotalColumnName"] = "QuantityWater";
                        ViewState["QuantityAccidentalColumnName"] = "QuantityAccidentalWater";
                        ViewState["PercentageAccidentalColumnName"] = "PercentAccidentalWater";
                        break;
                    }
                case MediumFilter.Medium.Soil:
                    {
                        ViewState["QuantityTotalColumnName"] = "QuantitySoil";
                        ViewState["QuantityAccidentalColumnName"] = "QuantityAccidentalSoil";
                        ViewState["PercentageAccidentalColumnName"] = "PercentAccidentalSoil";
                        break;
                    }
            }

       
    }


    public void DoSaveCSV(object sender, EventArgs e)
    {
        try
        {
            CultureInfo csvCulture = CultureResolver.ResolveCsvCulture(Request);
            CSVFormatter csvformat = new CSVFormatter(csvCulture);

            // Create Header
            PollutantReleaseSearchFilter filter = SearchFilter;

            bool isConfidentialityAffected = PollutantReleases.IsAffectedByConfidentiality(filter);

            Dictionary<string, string> header = EPRTR.HeaderBuilders.CsvHeaderBuilder.GetPollutantReleaseSearchHeader(
                filter,
                SelectedMedium,
                isConfidentialityAffected);

            // Create Body
            var facilities = PollutantReleases.GetFacilityListCSV(filter, SelectedMedium);

            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string facilityHeader = csvformat.GetPollutantReleaseFacilityHeader();

            string url = Request.Url.AbsoluteUri;
            url = url.Substring(0, url.LastIndexOf("/") + 1);

            Response.WriteUtf8FileHeader("EPRTR_Pollutant_Releases_Facility_List");

            Response.Write(topheader + facilityHeader);

            foreach (var item in facilities)
            {
                item.Url = String.Format("{0}/PopupFacilityDetails.aspx?FacilityReportId={1}", url, item.FacilityReportId);

                string row = csvformat.GetPollutantReleaseFacilityRow(item);
                Response.Write(row);
            }

            Response.End();
        }
        catch
        {
        }
    }


    #region Databinding methods

    public string GetFacilityName(object obj)
    {
        PollutantReleases.ResultFacility row = (PollutantReleases.ResultFacility)obj;
        return ConfidentialFormat.Format(row.FacilityName, row.ConfidentialIndicatorFacility);
    }

    public string GetFacilityReportId(object obj)
    {
        PollutantReleases.ResultFacility row = (PollutantReleases.ResultFacility)obj;
        return row.FacilityReportId.ToString();
    }

    public string GetQuantityTotal(object obj)
    {
        PollutantReleases.ResultFacility row = (PollutantReleases.ResultFacility)obj;
        return QuantityFormat.Format(row.QuantityTotal, row.Unit, row.ConfidentialIndicator);
    }

    public string GetQuantityAccidental(object obj)
    {
        PollutantReleases.ResultFacility row = (PollutantReleases.ResultFacility)obj;
        return QuantityFormat.Format(row.QuantityAccidental, row.Unit, row.ConfidentialIndicator);
    }

    public string GetPercentage(object obj)
    {
        PollutantReleases.ResultFacility row = (PollutantReleases.ResultFacility)obj;
        return QuantityFormat.FormatPercentage(row.PercentageAccidental);
    }

    public string GetActivity(object obj)
    {
        PollutantReleases.ResultFacility row = (PollutantReleases.ResultFacility)obj;
        return row.ActivityCode;
    }

    public string GetActivityToolTip(object obj)
    {
        PollutantReleases.ResultFacility row = (PollutantReleases.ResultFacility)obj;
        return LOVResources.AnnexIActivityName(row.ActivityCode);
    }
    public string GetCountry(object obj)
    {
        PollutantReleases.ResultFacility row = (PollutantReleases.ResultFacility)obj;
        return row.CountryCode;
    }

    public string GetCountryToolTip(object obj)
    {
        PollutantReleases.ResultFacility row = (PollutantReleases.ResultFacility)obj;
        return LOVResources.CountryName(row.CountryCode);
    }

    #endregion
}
