using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using EPRTR.Formatters;
using EPRTR.Utilities;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using EPRTR.Localization;
using EPRTR.Comparers;
using System.Web.UI;

public partial class ucPollutantTransfersAreas : System.Web.UI.UserControl
{
    private const string TREE = "pollutantTransferAreaTree";
    private const string FILTER = "pollutantTransferAreaFilter";
    private const string BASERESULT = "pollutantTransfersAreaResult";
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
    /// Information on which part of tree structure is expanded/collapsed
    /// </summary>
    private Dictionary<string, bool> TreeStructure
    {
        get { return ViewState[TREE] as Dictionary<string, bool>; }
        set { ViewState[TREE] = value; }
    }

    /// <summary>
    /// Fill table according to filter
    /// </summary>
    public void Populate(PollutantTransfersSearchFilter filter)
    {
        SearchFilter = filter;
        List<PollutantTransfers.TransfersTreeListRow> data = QueryLayer.PollutantTransfers.GetArea(filter);

        PollutantTransfersAreaTreeListRowComparer c = new PollutantTransfersAreaTreeListRowComparer(filter.AreaFilter);
        data.Sort(c);
        ViewState[BASERESULT] = data;

        this.lvPollutantTransfersAreas.DataSource = data;
        this.lvPollutantTransfersAreas.DataBind();

        // reset tree structure
        TreeStructure = new Dictionary<string, bool>();
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

                    bool expanded = TreeListHelper.GetExpanded(TreeStructure, code);
                    TreeListHelper.SetExpanded(TreeStructure, code, !expanded);

                    List<PollutantTransfers.TransfersTreeListRow> baseResult = ViewState[BASERESULT] as List<PollutantTransfers.TransfersTreeListRow>;

                    List<PollutantTransfers.TransfersTreeListRow> data = QueryLayer.PollutantTransfers.GetAreaTree(TreeStructure, SearchFilter, baseResult);
                    PollutantTransfersAreaTreeListRowComparer c = new PollutantTransfersAreaTreeListRowComparer(SearchFilter.AreaFilter);
                    data.Sort(c);

                    this.lvPollutantTransfersAreas.DataSource = data;
                    this.lvPollutantTransfersAreas.DataBind();

                    // notify that content has changed (print)
                    if (ContentChanged != null)
                        ContentChanged.Invoke(null, EventArgs.Empty);
                }
            }
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
        return NumberFormat.Format(((PollutantTransfers.TransfersTreeListRow)obj).Facilities);
    }

    protected string GetTotal(object obj)
    {
        return ((PollutantTransfers.TransfersTreeListRow)obj).FormatTotal();
    }

    protected string GetToolTip(object obj)
    {
        return ((PollutantTransfers.TransfersTreeListRow)obj).ToolTip();
    }
    protected string GetToolTipTimeSeries()
    {
        return Resources.GetGlobal("Common", "LinkTimeSeries");
    }

    protected bool ShowFacilityLink(object obj)
    {
        return ((PollutantTransfers.TransfersTreeListRow)obj).AllowFacilityLink();
    }
    #endregion





}
