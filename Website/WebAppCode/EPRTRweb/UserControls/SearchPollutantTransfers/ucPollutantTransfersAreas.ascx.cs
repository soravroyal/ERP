using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Comparers;
using EPRTR.CsvUtilities;
using EPRTR.Formatters;
using EPRTR.Localization;
using EPRTR.Utilities;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;

public partial class ucPollutantTransfersAreas : System.Web.UI.UserControl
{
    private const string FILTER = "pollutantTransferAreaFilter";
    private const string RESULT = "pollutantTransfersAreaResult";
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
        List<PollutantTransfers.AreaTreeListRow> data = QueryLayer.PollutantTransfers.GetCountries(filter).ToList();

        sortResult(data);
        ViewState[RESULT] = data;

        this.lvPollutantTransfersAreas.DataSource = data;
        this.lvPollutantTransfersAreas.DataBind();
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
        if (rowindex >= 0 && rowindex < this.lvPollutantTransfersAreas.Items.Count)
        {
            string command = e.CommandName;

            if (!String.IsNullOrEmpty(command))
            {
                string code = command;

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
        List<PollutantTransfers.AreaTreeListRow> data = ViewState[RESULT] as List<PollutantTransfers.AreaTreeListRow>;
        PollutantTransfers.AreaTreeListRow row = data[rowindex];

        //toggle expansion
        row.IsExpanded = !row.IsExpanded;

        //get data from database, if not already loaded
        if (row.HasChildren && row.IsExpanded && !data.Any(r => r.Level == row.Level + 1 && r.ParentCode == row.Code))
        {
            if (row.Level == 0)
            {
                var subareas = PollutantTransfers.GetSubAreas(SearchFilter, new List<string> { row.CountryCode });
                addToResult(subareas);
            }

        }

        this.lvPollutantTransfersAreas.DataSource = data;
        this.lvPollutantTransfersAreas.DataBind();


        // notify that content has changed (print)
        if (ContentChanged != null)
            ContentChanged.Invoke(null, EventArgs.Empty);
    }

    //add data to list. Sort and save new list in viewstate.
    private void addToResult(IEnumerable<PollutantTransfers.AreaTreeListRow> rows)
    {
        List<PollutantTransfers.AreaTreeListRow> data = ViewState[RESULT] as List<PollutantTransfers.AreaTreeListRow>;
        data.AddRange(rows);
        sortResult(data);
        ViewState[RESULT] = data;


    }

    private void sortResult(List<PollutantTransfers.AreaTreeListRow> data)
    {
        if (data != null && data.Count > 0)
        {
            PollutantTransfersAreaTreeListRowComparer c = new PollutantTransfersAreaTreeListRowComparer(SearchFilter.AreaFilter);
            data.Sort(c);
        }
    }


    private void toggleTimeseries(ListViewCommandEventArgs e, int rowindex)
    {
        ucTsPollutantTransfersSheet control = (ucTsPollutantTransfersSheet)this.lvPollutantTransfersAreas.Items[rowindex].FindControl("ucTsPollutantTransfersSheet");
        closeAllSubSheets(); // only allow 1 sheet open

        control.Visible = !control.Visible;
        Control div = this.lvPollutantTransfersAreas.Items[rowindex].FindControl("subsheet");
        div.Visible = !div.Visible;

        if (control.Visible)
        {
            string facilityReportID = e.CommandName; //name holds the unique facility report ID

            // create search filter and change activity filter
            PollutantTransferTimeSeriesFilter filter = FilterConverter.ConvertToPollutantTransferTimeSeriesFilter(SearchFilter);
            filter.AreaFilter = getAreaFilter(e);
            control.Populate(filter, SearchFilter.YearFilter.Year);
        }
    }

    /// <summary>
    /// new search on facility click
    /// alternative Server.Transfer("FacilityLevels.aspx");
    /// </summary>
    protected void onNewSearchClick(object sender, CommandEventArgs e)
    {
        string code = e.CommandArgument.ToString().ToUpper();

        // create facility search filter from activity search criteria
        FacilitySearchFilter filter = FilterConverter.ConvertToFacilitySearchFilter(SearchFilter);
        // create new area filter
        filter.AreaFilter = getAreaFilter(e);

        // go to facility search page with new filter
        LinkSearchRedirecter.ToFacilitySearch(Response, filter);
    }


    private AreaFilter getAreaFilter(CommandEventArgs args)
    {
        string arg = args.CommandArgument.ToString();
        string[] codes = arg.Split('&');
        if (codes.Length < 2) return null; //safe check, must have min two value

        return LinkSearchBuilder.GetAreaFilter(SearchFilter.AreaFilter, codes[0], codes[1]);
    }

    /// <summary>
    /// Close sheets
    /// </summary>
    private void closeAllSubSheets()
    {
        for (int i = 0; i < this.lvPollutantTransfersAreas.Items.Count; i++)
        {
            ucTsPollutantTransfersSheet control = (ucTsPollutantTransfersSheet)this.lvPollutantTransfersAreas.Items[i].FindControl("ucTsPollutantTransfersSheet");
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

        PollutantTransfers.AreaTreeListRow row = dataItem.DataItem as PollutantTransfers.AreaTreeListRow;
        List<PollutantTransfers.AreaTreeListRow> data = ViewState[RESULT] as List<PollutantTransfers.AreaTreeListRow>;

        //Countries need not to be considered. Will always be visible
        bool collapsed = false;
        if (row.Level > 0)
        {
            //is country collapsed?
            collapsed = !data.Single(d => d.CountryCode == row.CountryCode && d.Level == 0).IsExpanded;
        }

        dataItem.Visible = !collapsed;
    }

    protected string GetRowCss(object obj)
    {
        return ((TreeListRow)obj).GetRowCssClass();
    }

    protected string GetName(object obj)
    {
        return ((TreeListRow)obj).GetAreaName(SearchFilter.AreaFilter);
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

    protected string GetAreaCommandArg(object obj)
    {
        return ((TreeListRow)obj).GetCodeAndParent();
    }


    protected string GetFacilities(object obj)
    {
        return NumberFormat.Format(((PollutantTransfers.PollutantTransferRow)obj).Facilities);
    }

    protected string GetTotal(object obj)
    {
        return ((PollutantTransfers.PollutantTransferRow)obj).FormatTotal();
    }

    protected string GetToolTip(object obj)
    {
        return ((PollutantTransfers.PollutantTransferRow)obj).ToolTip();
    }
    protected string GetToolTipTimeSeries()
    {
        return Resources.GetGlobal("Common", "LinkTimeSeries");
    }

    protected bool ShowFacilityLink(object obj)
    {
        return ((PollutantTransfers.AreaTreeListRow)obj).AllowFacilityLink();
    }
    #endregion


    public void DoSaveCSV(object sender, EventArgs e)
    {
        try
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
            List<PollutantTransfers.AreaTreeListRow> rows = PollutantTransfers.GetAreaTree(filter).ToList();
            sortResult(rows);

            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string rowHeader = csvformat.GetPollutantTransferAreaHeader(filter);

            Response.WriteUtf8FileHeader("EPRTR_Pollutant_Transfers_Area_List");

            Response.Write(topheader + rowHeader);

            foreach (var item in rows)
            {
                string row = csvformat.GetPollutantTransferAreaRow(item, filter);

                if (AreaTreeListRow.CODE_TOTAL.Equals(item.Code))
                {
                    Response.Write(Environment.NewLine);
                    Response.Write(rowHeader);
                }

                Response.Write(row);
            }

            Response.End();
        }
        catch (Exception)
        {

        }
    }




}
