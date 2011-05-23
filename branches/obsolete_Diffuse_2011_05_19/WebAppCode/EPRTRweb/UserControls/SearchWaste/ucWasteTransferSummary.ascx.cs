using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using EPRTR.Formatters;
using EPRTR.Localization;
using EPRTR.Utilities;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using QueryLayer;
using EPRTR.Charts;
using System.Web.UI;


public partial class ucWasteTransferSummary : System.Web.UI.UserControl
{

    private const string FILTER = "WasteTransferSummaryFilter";

    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void Page_Prerender(object sender, EventArgs e)
    {
        DisplayPieChart.Visible = ShowTotal;
        
        //if (ScriptManager.GetCurrent(Page).IsInAsyncPostBack)
        //{
        //    Populate(SearchFilter);
        //}
    }


    /// <summary>
    /// prop filter
    /// </summary>
    public WasteTransferSearchFilter SearchFilter
    {
        get { return (ViewState[FILTER] as WasteTransferSearchFilter); }
        set { ViewState[FILTER] = value; }
    }

    /// <summary>
    /// Populate the listview
    /// </summary>
    public void Populate(WasteTransferSearchFilter filter)
    {
        SearchFilter = filter;
        this.lvWasteTransferSummery.Items.Clear();

        // binding
        IEnumerable<Summary.WasteSummaryTreeListRow> data = QueryLayer.WasteTransfers.GetWasteTransfers(filter);
        this.lvWasteTransferSummery.DataSource = data;
        this.lvWasteTransferSummery.DataBind();

        ChartsUtils.ShowWastePieCharts(data, this.upWasteTransferPiePanel, this.UniqueID.ToString());
    }


    /// <summary>
    /// for revealing the subsheet
    /// </summary>
    protected void OnItemCommand(object sender, ListViewCommandEventArgs e)
    {
        // get rowindex
        ListViewDataItem dataItem = e.Item as ListViewDataItem;
        if (dataItem == null) return; //safe check

        int rowindex = dataItem.DataItemIndex;
        if (rowindex >= 0 && rowindex < this.lvWasteTransferSummery.Items.Count)
        {
            string command = e.CommandName;

            if (!String.IsNullOrEmpty(command))
            {
                if ("timeseries".Equals(command))
                {
                    toggleTimeseries(e, rowindex);
                }
            }
        }
    }

    private void toggleTimeseries(ListViewCommandEventArgs e, int rowindex)
    {
        ucTsWasteTransfersSheet control = (ucTsWasteTransfersSheet)this.lvWasteTransferSummery.Items[rowindex].FindControl("ucTsWasteTransfersSheet");
        closeAllSubSheets(); // only allow 1 sheet open

        control.Visible = !control.Visible;
        Control div = this.lvWasteTransferSummery.Items[rowindex].FindControl("subsheet");
        div.Visible = !div.Visible;

        if (control.Visible)
        {
            // create search filter and change activity filter
            WasteTransferTimeSeriesFilter filter = FilterConverter.ConvertToWasteTransferTimeSeriesFilter(SearchFilter);
            filter.WasteTypeFilter = getWasteTypeFilter(e);
            control.Populate(filter, SearchFilter.YearFilter.Year);
        }
    }

    /// <summary>
    /// Close sheets
    /// </summary>
    private void closeAllSubSheets()
    {
        for (int i = 0; i < this.lvWasteTransferSummery.Items.Count; i++)
        {
            ucTsWasteTransfersSheet control = (ucTsWasteTransfersSheet)this.lvWasteTransferSummery.Items[i].FindControl("ucTsWasteTransfersSheet");
            if (control != null) control.Visible = false;
        }
    }


    private WasteTypeFilter getWasteTypeFilter(CommandEventArgs args)
    {
        string code = args.CommandArgument.ToString();
        return LinkSearchBuilder.GetWasteTypeFilter(code);
    }

    /// <summary>
    /// new search on facility click
    /// </summary>
    protected void onNewSearchClick(object sender, CommandEventArgs e)
    {
        string code = e.CommandArgument.ToString();

        // create facility search filter from activity search criteria
        FacilitySearchFilter filter = FilterConverter.ConvertToFacilitySearchFilter(SearchFilter);

        // create waste type filter according to command argument
        filter.WasteTypeFilter = LinkSearchBuilder.GetWasteTypeFilter(code);

        // go to facility levels page
        LinkSearchRedirecter.ToFacilitySearch(Response, filter);
    }





#region databinding methods

    protected string GetRowCss(object obj)
    {
        return ((TreeListRow)obj).GetRowCssClass();
    }

    protected string GetName(object obj)
    {
        return LOVResources.WasteTypeName(((TreeListRow)obj).Code);
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
        return NumberFormat.Format(((Summary.WasteSummaryTreeListRow)obj).Facilities);
    }


    protected string GetTotal(object obj)
    {
        return ((Summary.WasteSummaryTreeListRow)obj).FormatTotal();
    }
    protected string GetRecovery(object obj)
    {
        return ((Summary.WasteSummaryTreeListRow)obj).FormatRecovery();
    }
    protected string GetDisposal(object obj)
    {
        return ((Summary.WasteSummaryTreeListRow)obj).FormatDisposal();
    }
    protected string GetUnspec(object obj)
    {
        return ((Summary.WasteSummaryTreeListRow)obj).FormatUnspec();
    }

    
    protected string GetRecoveryPercent(object obj)
    {
        return ((Summary.WasteSummaryTreeListRow)obj).FormatRecoveryPercent();
    }
    protected string GetDisposalPercent(object obj)
    {
        return ((Summary.WasteSummaryTreeListRow)obj).FormatDisposalPercent();
    }
    protected string GetUnspecPercent(object obj)
    {
        return ((Summary.WasteSummaryTreeListRow)obj).FormatUnspecPercent();
    }

    protected string GetCommand(object obj)
    {
        Summary.WasteSummaryTreeListRow row = (Summary.WasteSummaryTreeListRow)obj;
        return String.Format("level:{0} code:{1}", row.Level, row.Code);
    }

    protected string GetToolTipTimeSeries()
    {
        return Resources.GetGlobal("Common", "LinkTimeSeries");
    }


#endregion


    #region Column visibility 


    //Hide headers dependend on filter selections.
    protected void OnDataBinding(object sender, EventArgs e)
    {
        Control headerAir = this.lvWasteTransferSummery.FindControl("divHeaderRecovery");
        headerAir.Visible = ShowRecovery;

        Control headerWater = this.lvWasteTransferSummery.FindControl("divHeaderDisposal");
        headerWater.Visible = ShowDisposal;

        Control headerSoil = this.lvWasteTransferSummery.FindControl("divHeaderUnspecified");
        headerSoil.Visible = ShowUnspecified;

        Control headerTotal = this.lvWasteTransferSummery.FindControl("divHeaderTotal");
        headerTotal.Visible = ShowTotal;

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

    protected bool ShowTotal
    {
        get
        {
            return
                SearchFilter.WasteTreatmentFilter.Recovery
                && SearchFilter.WasteTreatmentFilter.Disposal
                && SearchFilter.WasteTreatmentFilter.Unspecified;
        }
    }
    #endregion

}