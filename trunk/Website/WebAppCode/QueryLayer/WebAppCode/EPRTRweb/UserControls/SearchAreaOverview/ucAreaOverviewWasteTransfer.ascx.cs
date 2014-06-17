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

public partial class ucAreaOverviewWasteTransfer : System.Web.UI.UserControl
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
    public AreaOverviewSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as AreaOverviewSearchFilter; }
        set { ViewState[FILTER] = value; }
    }

    
    /// <summary>
    /// method to populate the listview
    /// </summary>
    public void Populate(AreaOverviewSearchFilter filter)
    {
        SearchFilter = filter;
        List<AreaOverview.AOWasteTreeListRow> data = QueryLayer.AreaOverview.GetWasteTransferSectors(filter).ToList();

        sortResult(data);
        ViewState[RESULT] = data;
        this.lvWasteTransferActivity.DataSource = data;
        this.lvWasteTransferActivity.DataBind();

        // notify that content has changed (print)
        if (ContentChanged != null)
            ContentChanged.Invoke(null, EventArgs.Empty);
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
                toggleExpanded(rowindex);
            }
        }
    }

    private void toggleExpanded(int rowindex)
    {
        List<AreaOverview.AOWasteTreeListRow> data = ViewState[RESULT] as List<AreaOverview.AOWasteTreeListRow>;
        AreaOverview.AOWasteTreeListRow row = data[rowindex];

        //toggle expansion
        row.IsExpanded = !row.IsExpanded;

        //get data from database, if not already loaded
        if (row.HasChildren && row.IsExpanded && !data.Any(r => r.Level == row.Level + 1 && r.ParentCode == row.Code))
        {
            if (row.Level == 0)
            {
                var activities = AreaOverview.GetWasteTransferActivities(SearchFilter, new List<string> { row.SectorCode });
                addToResult(activities);
            }
            else if (row.Level == 1)
            {
                var subactivities = AreaOverview.GetWasteTransferSubActivities(SearchFilter, new List<string> { row.ActivityCode });
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
    private void addToResult(IEnumerable<AreaOverview.AOWasteTreeListRow> rows)
    {
        List<AreaOverview.AOWasteTreeListRow> data = ViewState[RESULT] as List<AreaOverview.AOWasteTreeListRow>;
        data.AddRange(rows);
        sortResult(data);
        ViewState[RESULT] = data;


    }

    private static void sortResult(List<AreaOverview.AOWasteTreeListRow> data)
    {
        if (data != null && data.Count > 0)
        {
            AOWasteTreeListRowComparer c = new AOWasteTreeListRowComparer();
            data.Sort(c);
        }
    }
    
    #region DataBinding methods

    //Rows will only be shown if parent is expanded (grand-parents must be expanded too)
    protected void rows_OnItemDataBound(object sender, ListViewItemEventArgs e)
    {
        ListViewDataItem dataItem = e.Item as ListViewDataItem;
        if (dataItem == null) return; //safe check

        int rowindex = dataItem.DataItemIndex;

        AreaOverview.AOWasteTreeListRow row = dataItem.DataItem as AreaOverview.AOWasteTreeListRow;
        List<AreaOverview.AOWasteTreeListRow> data = ViewState[RESULT] as List<AreaOverview.AOWasteTreeListRow>;

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


    protected string GetActivityCommandArg(object obj)
    {
        return ((ActivityTreeListRow)obj).GetCodeAndParent();
    }

    protected string GetHWICFacilities(object obj)
    {
        AreaOverview.AOWasteTreeListRow row = (AreaOverview.AOWasteTreeListRow)obj;
        return NumberFormat.Format(row.GetFacilities(AreaOverview.CODE_HWIC));
    }

    protected string GetHWICQuantity(object obj)
    {
        AreaOverview.AOWasteTreeListRow row = (AreaOverview.AOWasteTreeListRow)obj;
        return QuantityFormat.Format(row.GetQuantity(AreaOverview.CODE_HWIC), row.GetUnit(AreaOverview.CODE_HWIC)); 
    }


    protected string GetHWOCFacilities(object obj)
    {
        AreaOverview.AOWasteTreeListRow row = (AreaOverview.AOWasteTreeListRow)obj;
        return NumberFormat.Format(row.GetFacilities(AreaOverview.CODE_HWOC));
    }

    protected string GetHWOCQuantity(object obj)
    {
        AreaOverview.AOWasteTreeListRow row = (AreaOverview.AOWasteTreeListRow)obj;
        return QuantityFormat.Format(row.GetQuantity(AreaOverview.CODE_HWOC), row.GetUnit(AreaOverview.CODE_HWOC));
    }

    protected string GetHWFacilities(object obj)
    {
        AreaOverview.AOWasteTreeListRow row = (AreaOverview.AOWasteTreeListRow)obj;
        return NumberFormat.Format(row.GetFacilities(AreaOverview.CODE_HW));
    }

    protected string GetHWQuantity(object obj)
    {
        AreaOverview.AOWasteTreeListRow row = (AreaOverview.AOWasteTreeListRow)obj;
        return QuantityFormat.Format(row.GetQuantity(AreaOverview.CODE_HW), row.GetUnit(AreaOverview.CODE_HW));
    }

    protected string GetNONHWFacilities(object obj)
    {
        AreaOverview.AOWasteTreeListRow row = (AreaOverview.AOWasteTreeListRow)obj;
        return NumberFormat.Format(row.GetFacilities(AreaOverview.CODE_NONHW));
    }

    protected string GetNONHWQuantity(object obj)
    {
        AreaOverview.AOWasteTreeListRow row = (AreaOverview.AOWasteTreeListRow)obj;
        return QuantityFormat.Format(row.GetQuantity(AreaOverview.CODE_NONHW), row.GetUnit(AreaOverview.CODE_NONHW));
    }



    #endregion


    public void DoSaveCSV(object sender, EventArgs e)
    {
        CultureInfo csvCulture = CultureResolver.ResolveCsvCulture(Request);
        CSVFormatter csvformat = new CSVFormatter(csvCulture);

        // Create Header
        var filter = SearchFilter;

        bool isConfidentialityAffected = AreaOverview.IsWasteAffectedByConfidentiality(filter);

        Dictionary<string, string> header = EPRTR.HeaderBuilders.CsvHeaderBuilder.GetAreaoverviewWasteTransferSearchHeader(filter, isConfidentialityAffected);

        // Create Body
        List<AreaOverview.AOWasteTreeListRow> rows = AreaOverview.GetWasteTransferActivityTree(filter).ToList();
        sortResult(rows);

        // dump to file
        string topheader = csvformat.CreateHeader(header);
        string rowHeader = csvformat.GetAreaOverviewWasteTransferHeader();

        Response.WriteUtf8FileHeader("EPRTR_Areaoverview_WasteTransfers_List");

        Response.Write(topheader + rowHeader);


        foreach (var item in rows)
        {
            string row = csvformat.GetAreaOverviewWasteTransferRow(item);

            if (AreaOverview.AOWasteTreeListRow.CODE_TOTAL.Equals(item.Code))
            {
                Response.Write(Environment.NewLine);
                Response.Write(rowHeader);
            }
            Response.Write(row);
        }

        

        Response.End();

    }

}