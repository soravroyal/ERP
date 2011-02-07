using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq;
using EPRTR.Formatters;
using EPRTR.Utilities;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using EPRTR.Localization;
using EPRTR.Enums;
using EPRTR.HeaderBuilders;
using EPRTR.Comparers;
using System.Globalization;
using EPRTR.CsvUtilities;

public partial class ucWasteTransferActivities : System.Web.UI.UserControl
{
    private const string FILTER = "wasteTransferActivityFilter";
    private const string RESULT = "wasteTransferActivityResult";
    public EventHandler ContentChanged;
 
    protected void Page_Load(object sender, EventArgs e)
    {
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
    /// method to populate the listview
    /// </summary>
    public void Populate(WasteTransferSearchFilter filter)
    {
        SearchFilter = filter;
        List<WasteTransfers.ActivityTreeListRow> data = QueryLayer.WasteTransfers.GetSectors(filter).ToList();

        sortResult(data);
        ViewState[RESULT] = data;
        this.lvWasteTransferActivity.DataSource = data;
        this.lvWasteTransferActivity.DataBind();
    }


    /// <summary>
    /// for revealing the subsheet
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void OnItemCommand(object sender, ListViewCommandEventArgs e)
    {
        // get rowindex
        ListViewDataItem dataItem = e.Item as ListViewDataItem;
        if (dataItem == null) return; //safe check

        int rowindex = dataItem.DataItemIndex;
        if (rowindex >= 0 && rowindex < this.lvWasteTransferActivity.Items.Count)
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
        List<WasteTransfers.ActivityTreeListRow> data = ViewState[RESULT] as List<WasteTransfers.ActivityTreeListRow>;
        WasteTransfers.ActivityTreeListRow row = data[rowindex];

        //toggle expansion
        row.IsExpanded = !row.IsExpanded;

        //get data from database, if not already loaded
        if (row.HasChildren && row.IsExpanded && !data.Any(r => r.Level == row.Level + 1 && r.ParentCode == row.Code))
        {
            if (row.Level == 0)
            {
                var activities = WasteTransfers.GetActivities(SearchFilter, new List<string> { row.SectorCode });
                addToResult(activities);
            }
            else if (row.Level == 1)
            {
                var subactivities = WasteTransfers.GetSubActivities(SearchFilter, new List<string> { row.ActivityCode });
                addToResult(subactivities);
            }

        }

        this.lvWasteTransferActivity.DataSource = data;
        this.lvWasteTransferActivity.DataBind();


        // notify that content has changed (print)
        if (ContentChanged != null)
            ContentChanged.Invoke(null, EventArgs.Empty);
    }


    //add data to list. Sort and save new list in viewstate.
    private void addToResult(IEnumerable<WasteTransfers.ActivityTreeListRow> rows)
    {
        List<WasteTransfers.ActivityTreeListRow> data = ViewState[RESULT] as List<WasteTransfers.ActivityTreeListRow>;
        data.AddRange(rows);
        sortResult(data);
        ViewState[RESULT] = data;
    }

    private static void sortResult(List<WasteTransfers.ActivityTreeListRow> data)
    {
        if (data != null && data.Count > 0)
        {
            WasteTransfersActivityTreeListRowComparer c = new WasteTransfersActivityTreeListRowComparer();
            data.Sort(c);
        }
    }



    private void toggleTimeseries(ListViewCommandEventArgs e, int rowindex)
    {
        ucTsWasteTransfersSheet control = (ucTsWasteTransfersSheet)this.lvWasteTransferActivity.Items[rowindex].FindControl("ucTsWasteTransfersSheet");
        closeAllSubSheets(); // only allow 1 sheet open

        control.Visible = !control.Visible;
        Control div = this.lvWasteTransferActivity.Items[rowindex].FindControl("subsheet");
        div.Visible = !div.Visible;

        if (control.Visible)
        {
            // create search filter and change activity filter
            WasteTransferTimeSeriesFilter filter = FilterConverter.ConvertToWasteTransferTimeSeriesFilter(SearchFilter);
            filter.ActivityFilter = getActivityFilter(e);
            control.Populate(filter, SearchFilter.YearFilter.Year);
        }
    }

    /// <summary>
    /// Close sheets
    /// </summary>
    private void closeAllSubSheets()
    {
        for (int i = 0; i < this.lvWasteTransferActivity.Items.Count; i++)
        {
            ucTsWasteTransfersSheet control = (ucTsWasteTransfersSheet)this.lvWasteTransferActivity.Items[i].FindControl("ucTsWasteTransfersSheet");
            if (control != null) control.Visible = false;
        }
    }


    /// <summary>
    /// new search on facility click
    /// </summary>
    protected void onNewSearchClick(object sender, CommandEventArgs e)
    {
        // create facility search filter from activity search criteria
        FacilitySearchFilter filter = FilterConverter.ConvertToFacilitySearchFilter(SearchFilter);
        
        // activity from code
        filter.ActivityFilter = getActivityFilter(e);

        // go to facility levels page
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

        //go to industrial activty search
        LinkSearchRedirecter.ToIndustrialActivity(Response, filter, Sheets.IndustrialActivity.WasteTransfers);
    }


    private ActivityFilter getActivityFilter(CommandEventArgs args)
    {
        string arg = args.CommandArgument.ToString();
        string[] codes = arg.Split('&');
        if (codes.Length < 2) return null; //safe check, must have min two value

        return LinkSearchBuilder.GetActivityFilter(SearchFilter.ActivityFilter, codes[0], codes[1]);
    }
    
    #region DataBinding methods

    //Hide headers dependend on filter selections.
    protected void OnDataBinding(object sender, EventArgs e)
    {
        Control headerNonHW = this.lvWasteTransferActivity.FindControl("divHeaderNonHW");
        headerNonHW.Visible = ShowNonHW;

        Control headerHWIC = this.lvWasteTransferActivity.FindControl("divHeaderHWIC");
        headerHWIC.Visible = ShowHWIC;

        Control headerHWOC = this.lvWasteTransferActivity.FindControl("divHeaderHWOC");
        headerHWOC.Visible = ShowHWOC;

        Control headerHW = this.lvWasteTransferActivity.FindControl("divHeaderHWTotal");
        headerHW.Visible = ShowHWTotal;

    }

    //Rows will only be shown if parent is expanded (grand-parents must be expanded too)
    protected void rows_OnItemDataBound(object sender, ListViewItemEventArgs e)
    {
        ListViewDataItem dataItem = e.Item as ListViewDataItem;
        if (dataItem == null) return; //safe check

        int rowindex = dataItem.DataItemIndex;

        WasteTransfers.ActivityTreeListRow row = dataItem.DataItem as WasteTransfers.ActivityTreeListRow;
        List<WasteTransfers.ActivityTreeListRow> data = ViewState[RESULT] as List<WasteTransfers.ActivityTreeListRow>;

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


    //only show non-HW if selected in filter
    protected bool ShowNonHW
    {
        get { return SearchFilter.WasteTypeFilter.NonHazardousWaste; }
    }

    //only show HW inside country if selected in filter
    protected bool ShowHWIC
    {
        get { return SearchFilter.WasteTypeFilter.HazardousWasteCountry; }
    }

    //only show HW outside country if selected in filter
    protected bool ShowHWOC
    {
        get { return SearchFilter.WasteTypeFilter.HazardousWasteTransboundary; }
    }

    //only show HW total if selected in filter
    protected bool ShowHWTotal
    {
        get { return ShowHWIC && ShowHWOC; }
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
        return NumberFormat.Format(((WasteTransfers.ActivityTreeListRow)obj).Facilities);
    }

    protected string GetActivityCommandArg(object obj)
    {
        return ((ActivityTreeListRow)obj).GetCodeAndParent();
    }

    protected string GetHWICTotal(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatHWICTotal();
    }
    protected string GetHWICRecovery(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatHWICRecovery();
    }
    protected string GetHWICDisposal(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatHWICDisposal();
    }
    protected string GetHWICUnspec(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatHWICUnspec();
    }
    protected string GetHWICToolTip(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).ToolTipHWIC();
    }

    protected string GetHWOCTotal(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatHWOCTotal();
    }
    protected string GetHWOCRecovery(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatHWOCRecovery();
    }
    protected string GetHWOCDisposal(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatHWOCDisposal();
    }
    protected string GetHWOCUnspec(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatHWOCUnspec();
    }
    protected string GetHWOCToolTip(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).ToolTipHWOC();
    }


    protected string GetHWTotal(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatHWTotal();
    }
    protected string GetHWRecovery(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatHWRecovery();
    }
    protected string GetHWDisposal(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatHWDisposal();
    }
    protected string GetHWUnspec(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatHWUnspec();
    }
    protected string GetHWToolTip(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).ToolTipHW();
    }

    protected string GetNONHWTotal(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatNONHWTotal();
    }
    protected string GetNONHWRecovery(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatNONHWRecovery();
    }
    protected string GetNONHWDisposal(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatNONHWDisposal();
    }
    protected string GetNONHWUnspec(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).FormatNONHWUnspec();
    }
    protected string GetNONHWToolTip(object obj)
    {
        return ((WasteTransfers.WasteTransferRow)obj).ToolTipNONHW();
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

    /// <summary>
    /// Save transfers data
    /// </summary>
    public void DoSaveCSV(object sender, EventArgs e)
    {
        try
        {
            CultureInfo csvCulture = CultureResolver.ResolveCsvCulture(Request);
            CSVFormatter csvformat = new CSVFormatter(csvCulture);

            // Create Header
            var filter = SearchFilter;

            bool isConfidentialityAffected = WasteTransfers.IsAffectedByConfidentiality(filter);

            Dictionary<string, string> header = EPRTR.HeaderBuilders.CsvHeaderBuilder.GetWasteTransfersSearchHeader(
                filter,
                isConfidentialityAffected);

            // Create Body
            var rows = WasteTransfers.GetActivityTree(filter);

            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string rowHeader = csvformat.GetWasteTransferActivityHeader();

            Response.WriteUtf8FileHeader("EPRTR_Waste_Transfers_Activity_List");

            Response.Write(topheader + rowHeader);

            //foreach (var item in rows)
            //{
            //    string row = csvformat.GetPollutantTransferActivityRow(item);
            //    Response.Write(row);
            //}

            Response.End();
        }
        catch (Exception exception)
        {

        }
    }

}