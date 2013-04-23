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
using EPRTR.CsvUtilities;
using System.Globalization;


public partial class ucIndustrialActivityWasteTransfer : System.Web.UI.UserControl
{
    private const string FILTER = "IndustrialActivityPollutantTransfersFilter";

    protected void Page_Load(object sender, EventArgs e)
    {
    }


    /// <summary>
    /// prop filter
    /// </summary>
    public IndustrialActivitySearchFilter SearchFilter
    {
        get { return (ViewState[FILTER] as IndustrialActivitySearchFilter); }
        set { ViewState[FILTER] = value; }
    }

    /// <summary>
    /// method to populate the listview
    /// </summary>
    /// <param name="filter">The filter.</param>
    public void Populate(IndustrialActivitySearchFilter filter)
    {
        SearchFilter = filter;

        this.lvIndustrialWasteTransfers.Items.Clear();

        IEnumerable<Summary.WasteSummaryTreeListRow> data = IndustrialActivity.GetWasteTransfers(filter);
        this.lvIndustrialWasteTransfers.DataSource = data;
        this.lvIndustrialWasteTransfers.DataBind();

        ChartsUtils.ShowWastePieCharts(data, this.upindustrialWasteSummeryPanel, this.UniqueID.ToString());
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
        if (rowindex >= 0 && rowindex < this.lvIndustrialWasteTransfers.Items.Count)
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
        ucTsWasteTransfersSheet control = (ucTsWasteTransfersSheet)this.lvIndustrialWasteTransfers.Items[rowindex].FindControl("ucTsWasteTransfersSheet");
        closeAllSubSheets(); // only allow 1 sheet open

        control.Visible = !control.Visible;
        Control div = this.lvIndustrialWasteTransfers.Items[rowindex].FindControl("subsheet");
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
        for (int i = 0; i < this.lvIndustrialWasteTransfers.Items.Count; i++)
        {
            ucTsWasteTransfersSheet control = (ucTsWasteTransfersSheet)this.lvIndustrialWasteTransfers.Items[i].FindControl("ucTsWasteTransfersSheet");
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
    protected void onFacilitySearchClick(object sender, CommandEventArgs e)
    {
        string code = e.CommandArgument.ToString();

        // create facility search filter from activity search criteria
        FacilitySearchFilter filter = FilterConverter.ConvertToFacilitySearchFilter(SearchFilter);
                
        // create waste type filter according to command argument
        filter.WasteTypeFilter = LinkSearchBuilder.GetWasteTypeFilter(code);
        
        // go to facility levels page
        LinkSearchRedirecter.ToFacilitySearch(Response, filter);
    }


    /// <summary>
    /// invoke pollutant search search for this row
    /// </summary>
    protected void onWasteSearchClick(object sender, CommandEventArgs e)
    {
        string code = e.CommandArgument.ToString();

        // create pollutant search filter
        WasteTransferSearchFilter filter = FilterConverter.ConvertToWasteTransferSearchFilter(SearchFilter);

        // create waste type filter according to command argument
        filter.WasteTypeFilter = LinkSearchBuilder.GetWasteTypeFilter(code);
        
        // go to waste search
        LinkSearchRedirecter.ToWasteTransfers(Response, filter);
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


    protected string GetToolTipWasteTransferSearch()
    {
        return Resources.GetGlobal("Common", "LinkSearchWasteTransfer");
    }
    protected string GetToolTipFacilitySearch()
    {
        return Resources.GetGlobal("Common", "LinkSearchFacility");
    }

    protected string GetCommand(object obj)
    {
        Summary.WasteSummaryTreeListRow row = (Summary.WasteSummaryTreeListRow) obj;
        return String.Format("level:{0} code:{1}", row.Level, row.Code);
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
        IndustrialActivitySearchFilter filter = SearchFilter;

        bool isConfidentialityAffected = IndustrialActivity.IsWasteAffectedByConfidentiality(filter);

        Dictionary<string, string> header = EPRTR.HeaderBuilders.CsvHeaderBuilder.GetIndustrialActivitySearchHeader(
            filter,
            isConfidentialityAffected);

        // Create Body
        var rows = IndustrialActivity.GetWasteTransfers(filter);

        // dump to file
        string topheader = csvformat.CreateHeader(header);
        string rowHeader = csvformat.GetIndustrialActivityWasteTransfersHeader();

        Response.WriteUtf8FileHeader("EPRTR_Industrial_Activity_Waste_Transfer_List");

        Response.Write(topheader + rowHeader);

        foreach (var item in rows)
        {
            string row = csvformat.GetIndustrialActivityWasteTransfersRow(item);
            Response.Write(row);
        }

        Response.End();
    }
    
}
