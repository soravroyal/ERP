using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Formatters;
using EPRTR.Utilities;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using EPRTR.Localization;
using EPRTR.Comparers;
 
public partial class ucWasteTransferAreas : System.Web.UI.UserControl
{
    private const string FILTER = "wasteTransferAreaFilter";
    private const string TREE = "wasteTransferAreaTree";
    private const string BASERESULT = "wasteTransferAreaResult";
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
    /// Information on which part of tree structure is expanded/collapsed
    /// </summary>
    private Dictionary<string, bool> TreeStructure
    {
        get { return ViewState[TREE] as Dictionary<string, bool>; }
        set { ViewState[TREE] = value; }
    }


    /// <summary>
    /// method to populate the listview
    /// </summary>
    public void Populate(WasteTransferSearchFilter filter)
    {
        SearchFilter = filter;
        List<WasteTransfers.WasteTreeListRow> data = QueryLayer.WasteTransfers.GetArea(filter);

        WasteTransferAreaTreeListRowComparer c = new WasteTransferAreaTreeListRowComparer(filter.AreaFilter);
        data.Sort(c);

        ViewState[BASERESULT] = data;
        
        this.lvWasteTransferArea.DataSource = data;
        this.lvWasteTransferArea.DataBind();

        // reset tree structure
        TreeStructure = new Dictionary<string, bool>();
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
        if (rowindex >= 0 && rowindex < this.lvWasteTransferArea.Items.Count)
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
                    string code = command;
                    bool expanded = TreeListHelper.GetExpanded(TreeStructure, code);
                    TreeListHelper.SetExpanded(TreeStructure, code, !expanded);

                    List<WasteTransfers.WasteTreeListRow> baseResult = ViewState[BASERESULT] as List<WasteTransfers.WasteTreeListRow>;

                    List<WasteTransfers.WasteTreeListRow> data = QueryLayer.WasteTransfers.GetAreaTree(TreeStructure, SearchFilter, baseResult);
                    WasteTransferAreaTreeListRowComparer c = new WasteTransferAreaTreeListRowComparer(SearchFilter.AreaFilter);
                    data.Sort(c);

                    this.lvWasteTransferArea.DataSource = data;
                    this.lvWasteTransferArea.DataBind();

                    // notify that content has changed (print)
                    if (ContentChanged != null)
                        ContentChanged.Invoke(null, EventArgs.Empty);
                }
            }
        }
    }

    private void toggleTimeseries(ListViewCommandEventArgs e, int rowindex)
    {
        ucTsWasteTransfersSheet control = (ucTsWasteTransfersSheet)this.lvWasteTransferArea.Items[rowindex].FindControl("ucTsWasteTransfersSheet");
        closeAllSubSheets(); // only allow 1 sheet open

        control.Visible = !control.Visible;
        Control div = this.lvWasteTransferArea.Items[rowindex].FindControl("subsheet");
        div.Visible = !div.Visible;

        if (control.Visible)
        {
            // create search filter and change activity filter
            WasteTransferTimeSeriesFilter filter = FilterConverter.ConvertToWasteTransferTimeSeriesFilter(SearchFilter);
            filter.AreaFilter = getAreaFilter(e);
            control.Populate(filter, SearchFilter.YearFilter.Year);
        }
    }

    /// <summary>
    /// Close sheets
    /// </summary>
    private void closeAllSubSheets()
    {
        for (int i = 0; i < this.lvWasteTransferArea.Items.Count; i++)
        {
            ucTsWasteTransfersSheet control = (ucTsWasteTransfersSheet)this.lvWasteTransferArea.Items[i].FindControl("ucTsWasteTransfersSheet");
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
                
        // Search for country according to code
        filter.AreaFilter = getAreaFilter(e);

        // go to facility levels page
        LinkSearchRedirecter.ToFacilitySearch(Response, filter);
    }

    private AreaFilter getAreaFilter(CommandEventArgs args)
    {
        string arg = args.CommandArgument.ToString();
        string[] codes = arg.Split('&');
        if (codes.Length < 2) return null; //safe check, must have min two value

        return LinkSearchBuilder.GetAreaFilter(SearchFilter.AreaFilter, codes[0], codes[1]);
    }


    #region DataBinding methods

    //Hide headers dependend on filter selections.
    protected void OnDataBinding(object sender, EventArgs e)
    {
        this.lvWasteTransferArea.FindControl("divHeaderNonHW").Visible = ShowNonHW;
        this.lvWasteTransferArea.FindControl("divHeaderHWIC").Visible = ShowHWIC;
        this.lvWasteTransferArea.FindControl("divHeaderHWOC").Visible = ShowHWOC;
        this.lvWasteTransferArea.FindControl("divHeaderHWTotal").Visible = ShowHWTotal;
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
        get { return ShowHWIC && ShowHWOC ; }
    }

    protected string GetRowCss(object obj)
    {
        return ((TreeListRow)obj).GetRowCssClass();
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
        return NumberFormat.Format(((WasteTransfers.WasteTreeListRow)obj).Facilities);
    }

    protected string GetHWICTotal(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatHWICTotal();
    }
    protected string GetHWICRecovery(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatHWICRecovery();
    }
    protected string GetHWICDisposal(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatHWICDisposal();
    }
    protected string GetHWICUnspec(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatHWICUnspec();
    }
    protected string GetHWICToolTip(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).ToolTipHWIC();
    }

    protected string GetHWOCTotal(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatHWOCTotal();
    }
    protected string GetHWOCRecovery(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatHWOCRecovery();
    }
    protected string GetHWOCDisposal(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatHWOCDisposal();
    }
    protected string GetHWOCUnspec(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatHWOCUnspec();
    }
    protected string GetHWOCToolTip(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).ToolTipHWOC();
    }


    protected string GetHWTotal(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatHWTotal();
    }
    protected string GetHWRecovery(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatHWRecovery();
    }
    protected string GetHWDisposal(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatHWDisposal();
    }
    protected string GetHWUnspec(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatHWUnspec();
    }
    protected string GetHWToolTip(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).ToolTipHW();
    }

    protected string GetNONHWTotal(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatNONHWTotal();
    }
    protected string GetNONHWRecovery(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatNONHWRecovery();
    }
    protected string GetNONHWDisposal(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatNONHWDisposal();
    }
    protected string GetNONHWUnspec(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).FormatNONHWUnspec();
    }
    protected string GetNONHWToolTip(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow)obj).ToolTipNONHW();
    }
    protected string GetToolTipTimeSeries()
    {
        return Resources.GetGlobal("Common", "LinkTimeSeries");
    }

    protected bool ShowFacilityLink(object obj)
    {
        return ((WasteTransfers.WasteTreeListRow )obj).AllowFacilityLink();
    }
    #endregion
}
