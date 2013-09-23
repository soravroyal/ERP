using System;
using System.Collections.Generic;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.CsvUtilities;
using EPRTR.Formatters;
using EPRTR.Localization;
using EPRTR.Utilities;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;

public partial class ucIndustrialActivityPollutantTransfers : System.Web.UI.UserControl
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
    public void Populate(IndustrialActivitySearchFilter filter)
    {
        SearchFilter = filter;
        this.lvIndustrialPollutantTransfers.DataSource = QueryLayer.IndustrialActivity.GetPollutantTransfers(filter);
        this.lvIndustrialPollutantTransfers.DataBind();
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
        if (rowindex >= 0 && rowindex < this.lvIndustrialPollutantTransfers.Items.Count)
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
        ucTsPollutantTransfersSheet control = (ucTsPollutantTransfersSheet)this.lvIndustrialPollutantTransfers.Items[rowindex].FindControl("ucTsPollutantTransfersSheet");
        closeAllSubSheets(); // only allow 1 sheet open

        control.Visible = !control.Visible;
        Control div = this.lvIndustrialPollutantTransfers.Items[rowindex].FindControl("subsheet");
        div.Visible = !div.Visible;

        if (control.Visible)
        {
            // create search filter and change activity filter
            PollutantTransferTimeSeriesFilter filter = FilterConverter.ConvertToPollutantTransferTimeSeriesFilter(SearchFilter);
            // create pollutant and medium filter
            filter.PollutantFilter = getPollutantFilter(e);

            control.Populate(filter, SearchFilter.YearFilter.Year);
        }
    }


    /// <summary>
    /// Close sheets
    /// </summary>
    private void closeAllSubSheets()
    {
        for (int i = 0; i < this.lvIndustrialPollutantTransfers.Items.Count; i++)
        {
            ucTsPollutantTransfersSheet control = (ucTsPollutantTransfersSheet)this.lvIndustrialPollutantTransfers.Items[i].FindControl("ucTsPollutantTransfersSheet");
            if (control != null) control.Visible = false;
        }
    }

    /// <summary>
    /// new search on facility click
    /// </summary>
    protected void onFacilitySearchClick(object sender, CommandEventArgs e)
    {
        // create facility search filter from activity search criteria
        FacilitySearchFilter filter = FilterConverter.ConvertToFacilitySearchFilter(SearchFilter);

        // create pollutant filter
        filter.PollutantFilter = getPollutantFilter(e);
        // set medium filter
        filter.MediumFilter = LinkSearchBuilder.GetMediumFilter(false,false,false, true);

        // go to facility levels page
        LinkSearchRedirecter.ToFacilitySearch(Response, filter);
    }

    /// <summary>
    /// invoke pollutant search search for this row
    /// </summary>
    protected void onPollutantSearchClick(object sender, CommandEventArgs e)
    {
        // create pollutant search filter
        PollutantTransfersSearchFilter filter = FilterConverter.ConvertToPollutantTransfersSearchFilter(SearchFilter);

        // create pollutant filter
        filter.PollutantFilter = getPollutantFilter(e);
        
        // go to pollutant release
        LinkSearchRedirecter.ToPollutantTransfers(Response, filter);
    }

    private PollutantFilter getPollutantFilter(CommandEventArgs e)
    {
        string arg = e.CommandArgument.ToString();
        string[] codeAndLevel = arg.Split('&');
        if (codeAndLevel.Length < 2) return null; //safe check, must have min two value

        return LinkSearchBuilder.GetPollutantFilter(codeAndLevel[0], Convert.ToInt32(codeAndLevel[1]));
    }


    #region DataBinding methods
    protected string GetRowCss(object obj)
    {
        return ((TreeListRow)obj).GetRowCssClass();
    }

    protected string GetName(object obj)
    {
        PollutantTransfers.TransfersTreeListRow row = (PollutantTransfers.TransfersTreeListRow)obj;

        if (row.HasChildren) //this is a pollutant group
        {
            return LOVResources.PollutantGroupName(row.Code) + " " + GetGroupCount(row);
        }
        else
        {
            return LOVResources.PollutantName(row.Code);
        }
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

    protected bool IsChild(object obj)
    {
        int level = ((TreeListRow)obj).Level;
        return (level != 0);
    }

    protected string GetCodeAndLevel(object obj)
    {
        return ((TreeListRow)obj).Code + "&" + ((TreeListRow)obj).Level;
    }

    protected string GetGroupCount(object obj)
    {
        IndustrialActivity.IATransfersTreeListRow row = (IndustrialActivity.IATransfersTreeListRow)obj;

        if (row.HasChildren)
        {
            int total = ListOfValues.CountLeafPollutants(row.Code);
            int number = row.CountChildPollutants;
            return String.Format("({0}/{1})", number, total);
        }
        else
        {
            return string.Empty;
        }
    }


    protected string GetFacilities(object obj)
    {
        return NumberFormat.Format(((PollutantTransfers.TransfersTreeListRow)obj).Facilities);
    }

    protected string GetTotal(object obj)
    {
        PollutantTransfers.TransfersTreeListRow row = (PollutantTransfers.TransfersTreeListRow)obj;
        return row.HasChildren ? string.Empty : row.FormatTotal();
    }

    protected string GetToolTip(object obj)
    {
        PollutantTransfers.TransfersTreeListRow row = (PollutantTransfers.TransfersTreeListRow)obj;
        return row.HasChildren ? string.Empty : row.ToolTip();
    }

    protected string GetToolTipPollutantTransferSearch()
    {
        return Resources.GetGlobal("Common", "LinkSearchPollutantTransfer");
    }
    protected string GetToolTipFacilitySearch()
    {
        return Resources.GetGlobal("Common", "LinkSearchFacility");
    }

    protected string GetCommand(object obj)
    {
        PollutantTransfers.TransfersTreeListRow row = (PollutantTransfers.TransfersTreeListRow)obj;
        return String.Format("level:{0} code:{1}",row.Level,row.Code);
    }

    protected string GetToolTipTimeSeries()
    {
        return Resources.GetGlobal("Common", "LinkTimeSeries");
    }

    #endregion

    public void DoSaveCSV(object sender, EventArgs e)
    {
        try
        {
            CultureInfo csvCulture = CultureResolver.ResolveCsvCulture(Request);
            CSVFormatter csvformat = new CSVFormatter(csvCulture);

            // Create Header
            IndustrialActivitySearchFilter filter = SearchFilter;

            bool isConfidentialityAffected = IndustrialActivity.IsPollutantTransferAffectedByConfidentiality(filter);

            Dictionary<string, string> header = EPRTR.HeaderBuilders.CsvHeaderBuilder.GetIndustrialActivitySearchHeader(
                filter,
                isConfidentialityAffected);

            // Create Body
            var rows = IndustrialActivity.GetPollutantTransfers(filter);

            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string rowHeader = csvformat.GetIndustrialActivityPollutantTransfersHeader();

            Response.WriteUtf8FileHeader("EPRTR_Industrial_Activity_Pollutant_Transfer_List");

            Response.Write(topheader + rowHeader);

            foreach (var item in rows)
            {
                string row = csvformat.GetIndustrialActivityPollutantTransfersRow(item);
                Response.Write(row);
            }

            Response.End();
        }
        catch
        {
        }
    }


}
