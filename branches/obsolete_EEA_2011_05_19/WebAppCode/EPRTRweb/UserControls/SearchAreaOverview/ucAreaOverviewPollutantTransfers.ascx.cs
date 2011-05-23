using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using QueryLayer.Filters;
using QueryLayer;
using System.Web.UI.HtmlControls;
using EPRTR.Localization;
using QueryLayer.Utilities;
using EPRTR.Formatters;
using EPRTR.Utilities;
using EPRTR.Enums;
using StylingHelper;
using System.Collections;
using EPRTR.Comparers;

public partial class ucAreaOverviewPollutantTransfers : System.Web.UI.UserControl
{
    private const string FILTER = "aopt_Filter";
    private const string DOWNLOADPRINT = "aopt_DownloadPrint";

    private const string COLHEADER = "aopt_header";
    private const string COLDATA = "aopt_data";

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

        bool noresult =  (AreaOverview.GetFacilityCountPollutantTransfer(filter) == 0);

        // no result, remove radio buttons
        this.divPollutantGroup.Visible = !noresult;

        populatePollutantGroups();
        loadData();
    }

    // Loads data. Resets paging and expansion of activity rows.
    private void loadData()
    {
        int pollutantGroupID = getPollutantGroupID();
        
        //prepare headers
        preparePollutantHeaders(SearchFilter, pollutantGroupID);

        //get data and save in viewstate
        List<string> pollutantCodes = getOrderedPollutantCodes();
        List<AreaOverview.AOPollutantTreeListRow> data = AreaOverview.GetPollutantTransferSectors(SearchFilter, pollutantGroupID, pollutantCodes);
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
    private void preparePollutantHeaders(AreaOverviewSearchFilter filter, int pollutantGroupID)
    {
        List<string> pollutantCodes = AreaOverview.GetPollutantTransferPollutantCodes(filter, pollutantGroupID);

        Dictionary<string, string> pollutantHeaders = new Dictionary<string, string>();

        //create dictionary with short pollutant names. Keep confidential in grpoup out until after sorting.
        string confCode = ListOfValues.GetPollutant(pollutantGroupID).Code;
        foreach (string code in pollutantCodes)
        {
            if (!confCode.Equals(code))
            {
                pollutantHeaders.Add(code, LOVResources.PollutantNameShort(code));
            }
        }

        //order by translated name
        pollutantHeaders = pollutantHeaders.OrderBy(h => h.Value).ToDictionary(k => k.Key, v => v.Value);
        
        //add confidential in group last.
        if(pollutantCodes.Contains(confCode))
        {
            pollutantHeaders.Add(confCode, LOVResources.PollutantNameShort(confCode));
        }

        ViewState[COLHEADER] = pollutantHeaders;
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
        DataPager pgColHeaders = (DataPager)this.lvPollutantTransfers.FindControl("pgColHeaders");
        if (refresh && pgColHeaders != null)
        {
            pgColHeaders.SetPageProperties(0, pgColHeaders.MaximumRows, false);
        }

        this.lvPollutantTransfers.DataSource = ViewState[COLDATA];
        this.lvPollutantTransfers.DataBind();

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
        ListView lvColHeaders = (ListView)this.lvPollutantTransfers.FindControl("lvColHeaders");
        lvColHeaders.DataSource = ViewState[COLHEADER];
        lvColHeaders.DataBind();

        //update paging text
        DataPager pg = (DataPager)sender;
        Label lbPagingtext = (Label)this.lvPollutantTransfers.FindControl("lbPagingtext");

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
        DataPager pgColHeaders = (DataPager)this.lvPollutantTransfers.FindControl("pgColHeaders");
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
        if (rowindex >= 0 && rowindex < this.lvPollutantTransfers.Items.Count)
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
            int pollutantGroupID = Convert.ToInt32(this.cbPollutantGroup.SelectedValue);

            if (row.Level == 0)
            {
                var activities = QueryLayer.AreaOverview.GetPollutantTransferActivities(SearchFilter, pollutantGroupID, new List<string> { row.SectorCode }, pollutantCodes);
                addToData(activities);
            }
            else if (row.Level == 1)
            {
                var subactivities = QueryLayer.AreaOverview.GetPollutantTransferSubActivities(SearchFilter, pollutantGroupID, new List<string> { row.ActivityCode }, pollutantCodes);
                addToData(subactivities);
            }
        }

        populateList(false); //do not restart paging

        // notify that content has changed (print)
        if (ContentChanged != null)
            ContentChanged.Invoke(null, EventArgs.Empty);
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


    protected void OnPollutantGroupChanged(object sender, EventArgs e)
    {
        loadData(); //reload data;
    }

    #region DataBinding methods


    protected void rows_OnItemCreated(object sender, ListViewItemEventArgs e)
    {
        //if no results at all - not just for selected pollutantgroup
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
            lbActivity.Text = String.Format(Resources.GetGlobal("AreaOverview", "TransfersOf"), LOVResources.PollutantGroupName(group.Code));
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

}

