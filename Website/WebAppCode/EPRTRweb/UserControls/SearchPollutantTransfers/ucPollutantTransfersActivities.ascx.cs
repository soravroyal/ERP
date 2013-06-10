using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using System.Linq;

using QueryLayer.Filters;
using QueryLayer;
using EPRTR.Localization;
using QueryLayer.Utilities;
using EPRTR.Formatters;
using EPRTR.Utilities;
using EPRTR.Enums;
using System.Web.UI;
using EPRTR.Comparers;
using System.Globalization;
using EPRTR.CsvUtilities;

public partial class ucPollutantTransfersActivities : System.Web.UI.UserControl
{
    private const string FILTER = "pollutantTansfersActivityFilter";
    private const string RESULT = "pollutantTansfersActivityResult";
    public EventHandler ContentChanged;

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// search filter to be used by sub sheet
    /// </summary>
    public PollutantTransfersSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as PollutantTransfersSearchFilter; }
        set { ViewState[FILTER] = value; }
    }


    /// <summary>
    /// Fill table according to filter
    /// </summary>
    public void Populate(PollutantTransfersSearchFilter filter)
    {
        SearchFilter = filter;
        List<PollutantTransfers.ActivityTreeListRow> data = QueryLayer.PollutantTransfers.GetSectors(filter).ToList();

        sortResult(data);
        ViewState[RESULT] = data;

        this.lvPollutantTransfers.DataSource = data;
        this.lvPollutantTransfers.DataBind();
    }

    /// <summary>
    /// Item row click
    /// </summary>
    protected void OnItemCommand(object sender, ListViewCommandEventArgs e)
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
                if ("timeseries".Equals(command))
                {
                    toggleTimeseries(e, rowindex);
                }
                else
                {
                    toggleExpanded(rowindex);
                }
            }
        }
    }


    private void toggleExpanded(int rowindex)
    {
        List<PollutantTransfers.ActivityTreeListRow> data = ViewState[RESULT] as List<PollutantTransfers.ActivityTreeListRow>;
        PollutantTransfers.ActivityTreeListRow row = data[rowindex];

        //toggle expansion
        row.IsExpanded = !row.IsExpanded;

        //get data from database, if not already loaded
        if (row.HasChildren && row.IsExpanded && !data.Any(r => r.Level == row.Level + 1 && r.ParentCode == row.Code))
        {
            if (row.Level == 0)
            {
                var activities = PollutantTransfers.GetActivities(SearchFilter, new List<string> { row.SectorCode });
                addToResult(activities);
            }
            else if (row.Level == 1)
            {
                var subactivities = PollutantTransfers.GetSubActivities(SearchFilter, new List<string> { row.ActivityCode });
                addToResult(subactivities);
            }

        }

        this.lvPollutantTransfers.DataSource = data;
        this.lvPollutantTransfers.DataBind();


        // notify that content has changed (print)
        if (ContentChanged != null)
            ContentChanged.Invoke(null, EventArgs.Empty);
    }


    //add data to list. Sort and save new list in viewstate.
    private void addToResult(IEnumerable<PollutantTransfers.ActivityTreeListRow> rows)
    {
        List<PollutantTransfers.ActivityTreeListRow> data = ViewState[RESULT] as List<PollutantTransfers.ActivityTreeListRow>;
        data.AddRange(rows);
        sortResult(data);
        ViewState[RESULT] = data;


    }

    private static void sortResult(List<PollutantTransfers.ActivityTreeListRow> data)
    {
        if (data != null && data.Count > 0)
        {
            PollutantTransfersActivityTreeListRowComparer c = new PollutantTransfersActivityTreeListRowComparer();
            data.Sort(c);
        }
    }


    private void toggleTimeseries(ListViewCommandEventArgs e, int rowindex)
    {
        ucTsPollutantTransfersSheet control = (ucTsPollutantTransfersSheet)this.lvPollutantTransfers.Items[rowindex].FindControl("ucTsPollutantTransfersSheet");
        closeAllSubSheets(); // only allow 1 sheet open

        control.Visible = !control.Visible;
        Control div = this.lvPollutantTransfers.Items[rowindex].FindControl("subsheet");
        div.Visible = !div.Visible;

        if (control.Visible)
        {
            // create search filter and change activity filter
            PollutantTransferTimeSeriesFilter filter = FilterConverter.ConvertToPollutantTransferTimeSeriesFilter(SearchFilter);
            filter.ActivityFilter = getActivityFilter(e);
            control.Populate(filter, SearchFilter.YearFilter.Year);
        }
    }

    /// <summary>
    /// new search on facility click
    /// </summary>
    protected void onFacilitySearchClick(object sender, CommandEventArgs e)
    {
        // create facility search filter from activity search criteria
        FacilitySearchFilter filter = FilterConverter.ConvertToFacilitySearchFilter(SearchFilter);

        // create new activity filter
        filter.ActivityFilter = getActivityFilter(e);
        LinkSearchRedirecter.ToFacilitySearch(Response, filter);
    }

    /// <summary>
    /// invoke activity search
    /// </summary>
    protected void onActivitySearchClick(object sender, CommandEventArgs e)
    {
        // create activity filter
        IndustrialActivitySearchFilter filter = FilterConverter.ConvertToIndustrialActivitySearchFilter(SearchFilter);

        // Change activity filter
        filter.ActivityFilter = getActivityFilter(e);

        LinkSearchRedirecter.ToIndustrialActivity(Response, filter, Sheets.IndustrialActivity.PollutantTransfers);
    }


    private ActivityFilter getActivityFilter(CommandEventArgs args)
    {
        string arg = args.CommandArgument.ToString();
        string[] codes = arg.Split('&');
        if (codes.Length < 2) return null; //safe check, must have min two value

        return LinkSearchBuilder.GetActivityFilter(SearchFilter.ActivityFilter, codes[0], codes[1]);
    }


    /// <summary>
    /// Close sheets
    /// </summary>
    private void closeAllSubSheets()
    {
        for (int i = 0; i < this.lvPollutantTransfers.Items.Count; i++)
        {
            ucTsPollutantTransfersSheet control = (ucTsPollutantTransfersSheet)this.lvPollutantTransfers.Items[i].FindControl("ucTsPollutantTransfersSheet");
            if (control != null) control.Visible = false;
        }
    }


    #region DataBinding methods

    //Rows will only be shown if parent is expanded (grand-parents must be expanded too)
    protected void rows_OnItemDataBound(object sender, ListViewItemEventArgs e)
    {
        ListViewDataItem dataItem = e.Item as ListViewDataItem;
        if (dataItem == null) return; //safe check

        int rowindex = dataItem.DataItemIndex;

        PollutantTransfers.ActivityTreeListRow row = dataItem.DataItem as PollutantTransfers.ActivityTreeListRow;
        List<PollutantTransfers.ActivityTreeListRow> data = ViewState[RESULT] as List<PollutantTransfers.ActivityTreeListRow>;

        //Sectors need not to be considered. Will always be visible
        bool collapsed = false;
        if (row.Level > 0)
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

    protected string GetRowCss(object obj)
    {
        return ((TreeListRow)obj).GetRowCssClass();
    }

    protected string GetName(object obj)
    {
        return ((ActivityTreeListRow)obj).GetName();
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

    protected string GetFacilities(object obj)
    {
        return NumberFormat.Format(((PollutantTransfers.ActivityTreeListRow)obj).Facilities);
    }

    protected string GetActivityCommandArg(object obj)
    {
        return ((ActivityTreeListRow)obj).GetCodeAndParent();
    }

    protected string GetTotal(object obj)
    {
        return ((PollutantTransfers.ActivityTreeListRow)obj).FormatTotal();
    }

    protected string GetToolTip(object obj)
    {
        return ((PollutantTransfers.ActivityTreeListRow)obj).ToolTip();
    }

    protected string GetToolTipActivitySearch()
    {
        return Resources.GetGlobal("Common", "LinkSearchActivity");
    }
    protected string GetToolTipFacilitySearch()
    {
        return Resources.GetGlobal("Common", "LinkSearchFacility");
    }
    protected string GetToolTipTimeSeries()
    {
        return Resources.GetGlobal("Common", "LinkTimeSeries");
    }



    #endregion


    public void DoSaveCSV(object sender, EventArgs e)
    {
        CultureInfo csvCulture = CultureResolver.ResolveCsvCulture(Request);
        CSVFormatter csvformat = new CSVFormatter(csvCulture);

        // Create Header
        var filter = SearchFilter;

        bool isConfidentialityAffected = PollutantTransfers.IsAffectedByConfidentiality(filter);

        Dictionary<string, string> header = EPRTR.HeaderBuilders.CsvHeaderBuilder.GetPollutantTransferSearchHeader(
            filter,
            isConfidentialityAffected);

        // Create Body
        var rows = PollutantTransfers.GetActivityTree(filter);

        // dump to file
        string topheader = csvformat.CreateHeader(header);
        string[] colHeaderRows = csvformat.GetPollutantTransferActivityColHeaderRows();

        Response.WriteUtf8FileHeader("EPRTR_Pollutant_Transfers_Activity_List");

        Response.Write(topheader + colHeaderRows[0] + colHeaderRows[1]);

        foreach (var item in rows)
        {
            string row = csvformat.GetPollutantTransferActivityRow(item);

            if (ActivityTreeListRow.CODE_TOTAL.Equals(item.Code))
            {
                Response.Write(Environment.NewLine);
                Response.Write(colHeaderRows[0] + colHeaderRows[1]);
            }

            Response.Write(row);
        }

        Response.End();
    }

}
