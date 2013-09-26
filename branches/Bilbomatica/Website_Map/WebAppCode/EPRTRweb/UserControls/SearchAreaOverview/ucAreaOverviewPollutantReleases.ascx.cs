using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using EPRTR.Comparers;
using EPRTR.Formatters;
using EPRTR.Localization;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using EPRTR.CsvUtilities;

public partial class ucAreaOverviewPollutantReleases : System.Web.UI.UserControl
{
    private const string FILTER = "aopr_Filter";
    private const string DOWNLOADPRINT = "aopr_DownloadPrint";

    private const string COLHEADER = "aopr_header";
    private const string COLDATA = "aopr_data";

    public EventHandler ContentChanged;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
        }
    }


    #region View state properties
    /// <summary>
    /// search filter to be used by sub sheet
    /// </summary>
    public AreaOverviewSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as AreaOverviewSearchFilter; }
        set { ViewState[FILTER] = value; }
    }

    #endregion


    /// <summary>
    /// method to populate the listview
    /// </summary>
    public void Populate(AreaOverviewSearchFilter filter)
    {
        SearchFilter =  filter;

        bool noresult = (AreaOverview.GetFacilityCountPollutantRelease(filter) == 0);

        // no result, remove radio buttons
        this.ucMediumSelector.Visible = !noresult;
        this.divPollutantGroup.Visible = !noresult;

        populatePollutantGroups();
        populateMediumSelector(); //will cause an OmMediumChanged event which will load data.


    }

    // Loads data. Resets paging and expansion of activity rows.
    private void loadData()
    {
        MediumFilter.Medium medium = this.ucMediumSelector.SelectedMedium;
        int pollutantGroupID = getPollutantGroupID();
        
        //prepare headers
        preparePollutantHeaders(SearchFilter, medium, pollutantGroupID);

        //get data and save in viewstate
        List<string> pollutantCodes = getOrderedPollutantCodes();
        List<AreaOverview.AOPollutantTreeListRow> data = AreaOverview.GetPollutantReleaseSectors(SearchFilter, medium, pollutantGroupID, pollutantCodes);
        sortData(data);
        ViewState[COLDATA] = data;

        //fill list and restart paging
        populateList(true);
    }

    private int getPollutantGroupID()
    {
        int pollutantGroupID = Convert.ToInt32(this.cbPollutantGroup.SelectedValue);
        return pollutantGroupID;
    }

    //create pollutant headers, order by name and save in view state
    private void preparePollutantHeaders(AreaOverviewSearchFilter filter, MediumFilter.Medium medium, int pollutantGroupID)
    {
        List<LOV_POLLUTANT> orderedPollutants = getOrderedPollutants(filter, medium, pollutantGroupID);

        Dictionary<string, string> pollutantHeaders = new Dictionary<string, string>();

        foreach (LOV_POLLUTANT p in orderedPollutants)
        {
            pollutantHeaders.Add(p.Code, LOVResources.PollutantNameShort(p.Code));
        }

        ViewState[COLHEADER] = pollutantHeaders;
    }

    private List<LOV_POLLUTANT> getOrderedPollutants(AreaOverviewSearchFilter filter, MediumFilter.Medium medium, int pollutantGroupID)
    {
        List<string> pollutantCodes = AreaOverview.GetPollutantReleasePollutantCodes(filter, medium, pollutantGroupID);

        IEnumerable<LOV_POLLUTANT> pollutants = ListOfValues.Pollutants(pollutantGroupID).Where(p => pollutantCodes.Contains(p.Code));

        //sort by short name
        List<LOV_POLLUTANT> orderedPollutants = pollutants.OrderBy(p => LOVResources.PollutantNameShort(p.Code)).ToList();

        //Add confidential in group to the end of the list.
        LOV_POLLUTANT confPollutant = ListOfValues.GetPollutant(pollutantGroupID);
        if (pollutantCodes.Contains(confPollutant.Code))
        {
            orderedPollutants.Add(confPollutant);
        }

        return orderedPollutants;
    }


    private void populateMediumSelector()
    {
        MediumFilter mf = new MediumFilter();
        mf.ReleasesToAir = true;
        mf.ReleasesToSoil = true;
        mf.ReleasesToWater = true;

        var filter = FilterConverter.ConvertToPollutantReleaseSearchFilter(SearchFilter);
        var counts = PollutantReleases.GetFacilityCounts(filter);
        this.ucMediumSelector.PopulateMediumRadioButtonList(mf, counts);
    }

    private void populatePollutantGroups()
    {
        this.cbPollutantGroup.Items.Clear();

        IEnumerable<LOV_POLLUTANT> groups = QueryLayer.ListOfValues.PollutantGroups();

        //Value of areas are prefixed to separate them from countries
        foreach (LOV_POLLUTANT g in groups)
            this.cbPollutantGroup.Items.Add(new ListItem(LOVResources.PollutantGroupName(g.Code), g.LOV_PollutantID.ToString()));

        this.cbPollutantGroup.SelectedIndex = 0;
    }


    private static void sortData(List<AreaOverview.AOPollutantTreeListRow> data)
    {
        if (data != null && data.Count > 0)
        {
            AOPollutantTreeListRowComparer c = new AOPollutantTreeListRowComparer();
            data.Sort(c);
        }
    }

    private void populateList(bool refresh)
    {
        DataPager pgColHeaders = (DataPager)this.lvPollutantReleases.FindControl("pgColHeaders");
        if (refresh && pgColHeaders != null)
        {
            pgColHeaders.SetPageProperties(0, pgColHeaders.MaximumRows, false);
        }

        this.lvPollutantReleases.DataSource = ViewState[COLDATA]; 
        this.lvPollutantReleases.DataBind();

        // notify that content has changed (print)
        if (ContentChanged != null)
            ContentChanged.Invoke(null, EventArgs.Empty);
    }

    //hide paging fields if not needed. Keep pager itself.
    protected void lv_OnPreRender(object sender, EventArgs e)
    {

        DataPager pg = ((ListView)sender).FindControl("pgColHeaders") as DataPager; ;

        if (pg != null)
        {
            Dictionary<string, string> pollutantHeaders = ViewState[COLHEADER] as Dictionary<string, string>;
            bool showFields = pollutantHeaders.Count > pg.PageSize;

            foreach (DataPagerField f in pg.Fields)
            {
                f.Visible = showFields;
            }
        }

    }


    protected void pgHeader_PreRender(object sender, EventArgs e)
    {
        //bind headers
        ListView lvColHeaders = (ListView)this.lvPollutantReleases.FindControl("lvColHeaders");
        lvColHeaders.DataSource = ViewState[COLHEADER];
        lvColHeaders.DataBind();

        //update paging text
        DataPager pg = (DataPager)sender;
        Label lbPagingtext = (Label)this.lvPollutantReleases.FindControl("lbPagingtext");

        int start = pg.StartRowIndex + 1;
        int end = Math.Min(pg.StartRowIndex + pg.PageSize, pg.TotalRowCount);
        int total = pg.TotalRowCount;
        lbPagingtext.Text = String.Format(Resources.GetGlobal("AreaOverview", "PagingText"), start, end, total);


    }

    /// <summary>
    /// Paging changed
    /// </summary>
    protected void OnPageChanging(object sender, PagePropertiesChangingEventArgs e)
    {
        //do not restart paging
        populateList(false);
    }

    //Make sure paging of header and data is syncronized by setting page properties of row-pager to the same as header pager
    protected void pgColData_OnLoad(object sender, EventArgs e)
    {
        DataPager pgColHeaders = (DataPager)this.lvPollutantReleases.FindControl("pgColHeaders");
        DataPager pgData = (DataPager)sender;

        pgData.SetPageProperties(pgColHeaders.StartRowIndex, pgColHeaders.MaximumRows, false);
    }


    /// <summary>
    /// Expand/Collapse rows in tree
    /// </summary>
    protected void rows_OnItemCommand(object sender, ListViewCommandEventArgs e)
    {
        // get rowindex
        ListViewDataItem dataItem = e.Item as ListViewDataItem;
        if (dataItem == null) return; //safe check

        int rowindex = dataItem.DataItemIndex;
        if (rowindex >= 0 && rowindex < this.lvPollutantReleases.Items.Count)
        {
            string command = e.CommandName;

            if (!String.IsNullOrEmpty(command))
            {
                toggleExpanded(rowindex);
            }
        }
    }

    private void toggleExpanded(int rowindex)
    {
        List<AreaOverview.AOPollutantTreeListRow> data = ViewState[COLDATA] as List<AreaOverview.AOPollutantTreeListRow>;
        AreaOverview.AOPollutantTreeListRow row = data[rowindex];

        //toggle expansion
        row.IsExpanded = !row.IsExpanded;

        //Load data from database, if not already loaded
        if (row.HasChildren && row.IsExpanded && !data.Any(r => r.Level == row.Level + 1 && r.ParentCode == row.Code))
        {
            List<string> pollutantCodes = getOrderedPollutantCodes();
            MediumFilter.Medium medium = this.ucMediumSelector.SelectedMedium;
            int pollutantGroupID = Convert.ToInt32(this.cbPollutantGroup.SelectedValue);

            if (row.Level == 0)
            {
                var activities = QueryLayer.AreaOverview.GetPollutantReleaseActivities(SearchFilter, medium, pollutantGroupID, new List<string> { row.SectorCode }, pollutantCodes);
                addToData(activities);
            }
            else if (row.Level == 1)
            {
                var subactivities = QueryLayer.AreaOverview.GetPollutantReleaseSubActivities(SearchFilter, medium, pollutantGroupID, new List<string> { row.ActivityCode }, pollutantCodes);
                addToData(subactivities);
            }
        }

        populateList(false); //do not restart paging

    }

    //Add data to list. Sort and save new list in viewstate.
    private void addToData(IEnumerable<AreaOverview.AOPollutantTreeListRow> rows)
    {
        List<AreaOverview.AOPollutantTreeListRow> data = ViewState[COLDATA] as List<AreaOverview.AOPollutantTreeListRow>;
        data.AddRange(rows);
        sortData(data);
        ViewState[COLDATA] = data;
    }

    //Returns a list of pollutant codes ordered by the (translated) short name of the pollutant
    private List<string> getOrderedPollutantCodes()
    {
        Dictionary<string, string> pollutantHeaders = ViewState[COLHEADER] as Dictionary<string, string>;
        List<string> pollutantCodes = pollutantHeaders.Select(h => h.Key).ToList();
        return pollutantCodes;
    }

    //Rows will only be shown if parent is expanded (grand-parents must be expanded too)
    protected void rows_OnItemDataBound(object sender, ListViewItemEventArgs e)
    {
        ListViewDataItem dataItem = e.Item as ListViewDataItem;
        if (dataItem == null) return; //safe check

        int rowindex = dataItem.DataItemIndex;
        List<AreaOverview.AOPollutantTreeListRow> data = ViewState[COLDATA] as List<AreaOverview.AOPollutantTreeListRow>;
        AreaOverview.AOPollutantTreeListRow row = data[rowindex];

        //Sectors need not to be considered. Will always be visible
        bool collapsed = false;
        if(row.Level > 0)
        {
            //is sector collapsed?
            collapsed = !data.Single(d => d.SectorCode == row.SectorCode && d.Level == 0).IsExpanded;

            if (row.Level > 1 && !collapsed)
            {
                //is activity collapsed?
                collapsed = !data.Single(d => d.ActivityCode == row.ActivityCode && d.Level == 1).IsExpanded;
            }
        }

        dataItem.Visible = !collapsed;
    }



    protected void OnMediumChanged(object sender, MediumSelectedEventArgs e)
    {
        loadData(); //reload data;
    }

    protected void OnPollutantGroupChanged(object sender, EventArgs e)
    {
        loadData(); //reload data;
    }

    #region DataBinding methods


    protected void rows_OnItemCreated(object sender, ListViewItemEventArgs e)
    {
        //if no results at all - not just for selected pollutantgroup/medium
        if (e.Item.ItemType == ListViewItemType.EmptyItem && !this.divPollutantGroup.Visible)
        {
            Literal lit = (Literal)e.Item.FindControl("litNoResult") as Literal;
            lit.Text = Resources.GetGlobal("Common", "NoResultsFound");
        }
    }

    protected void lvColHeaders_OnDataBinding(object sender, EventArgs e)
    {
        Label lbActivity = ((ListView)sender).FindControl("lbActivity") as Label;

        int pollutantGroupID = getPollutantGroupID();
        LOV_POLLUTANT group = ListOfValues.GetPollutant(pollutantGroupID);

        if (lbActivity != null && group != null)
        {
            lbActivity.Text = String.Format(Resources.GetGlobal("AreaOverview", "ReleasesOf"), LOVResources.PollutantGroupName(group.Code));
        }
    }


    /// <summary>
    /// Header name for pollutant
    /// </summary>
    protected string GetColName(object obj)
    {
        KeyValuePair<string, string> row = (KeyValuePair<string, string>)obj;
        return row.Value;
    }

    /// <summary>
    /// Header tooltip for pollutant
    /// </summary>
    protected string GetColNameToolTip(object obj)
    {
        KeyValuePair<string, string> row = (KeyValuePair<string, string>)obj;
        return LOVResources.PollutantName(row.Key);
    }


    protected string GetRowCss(object obj)
    {
        TreeListRow row = (TreeListRow)obj;
        return row.GetRowCssClass();
    }

    protected string GetName(object obj)
    {
        ActivityTreeListRow row = (ActivityTreeListRow)obj;
        return row.GetName();
    }

    protected bool IsExpanded(object obj)
    {
        return ((TreeListRow)obj).IsExpanded;
    }

    protected bool HasChildren(object obj)
    {
        return ((TreeListRow)obj).HasChildren;
    }

    protected int GetLevel(object obj)
    {
        return ((TreeListRow)obj).Level;
    }

    protected string GetCode(object obj)
    {
        return ((TreeListRow)obj).Code;
    }


    protected string GetActivityCommandArg(object obj)
    {
        ActivityTreeListRow row = (ActivityTreeListRow)obj;
        return row.Code;
    }

    protected List<AreaOverview.PollutantData> GetPollutantList(object obj)
    {
        return ((AreaOverview.AOPollutantTreeListRow)obj).PollutantList;
    }

    protected string GetFacilities(object obj)
    {
        AreaOverview.PollutantData row = (AreaOverview.PollutantData)obj;
        return NumberFormat.Format(row.Facilities);
    }

    protected string GetTotal(object obj)
    {
        AreaOverview.PollutantData row = (AreaOverview.PollutantData)obj;
        return QuantityFormat.Format(row.Quantity, row.Unit);
    }


    #endregion


    public void DoSaveCSV(object sender, EventArgs e)
    {
        CultureInfo csvCulture = CultureResolver.ResolveCsvCulture(Request);
        CSVFormatter csvformat = new CSVFormatter(csvCulture);

        // Create Header
        var filter = SearchFilter;
        int pollutantGroupID = getPollutantGroupID();
        List<string> pollutantCodes = getOrderedPollutantCodes();
        MediumFilter.Medium medium = this.ucMediumSelector.SelectedMedium;

        bool isConfidentialityAffected = AreaOverview.IsPollutantReleaseAffectedByConfidentiality(filter,medium, pollutantGroupID);

        Dictionary<string, string> header = EPRTR.HeaderBuilders.CsvHeaderBuilder.GetAreaoverviewPollutantReleaseSearchHeader(filter, pollutantGroupID, medium, isConfidentialityAffected);

        // Create Body
        List<AreaOverview.AOPollutantTreeListRow> rows = AreaOverview.GetPollutantReleaseActivityTree(filter, medium, pollutantGroupID, pollutantCodes).ToList();
        sortData(rows);

        // dump to file
        string topheader = csvformat.CreateHeader(header);
        string pollutantinfoHeader = csvformat.GetAreaOverviewPollutantInfoHeader(getOrderedPollutants(filter, medium, pollutantGroupID));
        string rowHeader = csvformat.GetAreaOverviewPollutantDataHeader(getOrderedPollutants(filter, medium, pollutantGroupID));

        Response.WriteUtf8FileHeader("EPRTR_Areaoverview_PollutantReleases_List");

        Response.Write(topheader + pollutantinfoHeader + rowHeader);


        foreach (var item in rows)
        {
            string row = csvformat.GetAreaOverviewPollutantsRow(item);

            if (AreaOverview.AOPollutantTreeListRow.CODE_TOTAL.Equals(item.Code))
            {
                Response.Write(rowHeader);
            }

            Response.Write(row);
        }


        Response.End();
    }

}

