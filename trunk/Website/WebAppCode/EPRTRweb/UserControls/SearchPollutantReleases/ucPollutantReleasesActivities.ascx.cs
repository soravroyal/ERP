using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Comparers;
using EPRTR.CsvUtilities;
using EPRTR.Enums;
using EPRTR.Formatters;
using EPRTR.Localization;
using EPRTR.Utilities;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;

public partial class ucPollutantReleasesActivities : System.Web.UI.UserControl
{
    private const string FILTER = "pollutantReleasesActivityFilter";
    private const string RESULT = "pollutantReleasesActivityResult";
    public EventHandler ContentChanged;

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    #region view state properties
    /// <summary>
    /// search filter to be used by sub sheet
    /// </summary>
    public PollutantReleaseSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as PollutantReleaseSearchFilter; }
        set { ViewState[FILTER] = value; }
    }

    #endregion

    /// <summary>
    /// method to populate the listview
    /// </summary>
    public void Populate(PollutantReleaseSearchFilter filter)
    {
        SearchFilter = filter;
        List<PollutantReleases.ActivityTreeListRow> data = QueryLayer.PollutantReleases.GetSectors(filter).ToList();

        sortResult(data);
        ViewState[RESULT] = data;

        this.lvPollutantReleases.DataSource = data;
        this.lvPollutantReleases.DataBind();
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
        if (rowindex >= 0 && rowindex < this.lvPollutantReleases.Items.Count)
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
        List<PollutantReleases.ActivityTreeListRow> data = ViewState[RESULT] as List<PollutantReleases.ActivityTreeListRow>;
        PollutantReleases.ActivityTreeListRow row = data[rowindex];

        //toggle expansion
        row.IsExpanded = !row.IsExpanded;

        //get data from database, if not already loaded
        if (row.HasChildren && row.IsExpanded && !data.Any(r => r.Level == row.Level + 1 && r.ParentCode == row.Code))
        {
            if (row.Level == 0)
            {
                var activities = PollutantReleases.GetActivities(SearchFilter, new List<string> { row.SectorCode });
                addToResult(activities);
            }
            else if (row.Level == 1)
            {
                var subactivities = PollutantReleases.GetSubActivities(SearchFilter, new List<string> { row.ActivityCode });
                addToResult(subactivities);
            }

        }

        this.lvPollutantReleases.DataSource = data;
        this.lvPollutantReleases.DataBind();

        // notify that content has changed (print)
        if (ContentChanged != null)
            ContentChanged.Invoke(null, EventArgs.Empty);
    }


    //add data to list. Sort and save new list in viewstate.
    private void addToResult(IEnumerable<PollutantReleases.ActivityTreeListRow> rows)
    {
        List<PollutantReleases.ActivityTreeListRow> data = ViewState[RESULT] as List<PollutantReleases.ActivityTreeListRow>;
        data.AddRange(rows);
        sortResult(data);
        ViewState[RESULT] = data;


    }

    private static void sortResult(List<PollutantReleases.ActivityTreeListRow> data)
    {
        if (data != null && data.Count > 0)
        {
            PollutantReleasesActivityTreeListRowComparer c = new PollutantReleasesActivityTreeListRowComparer();
            data.Sort(c);
        }
    }



    //toggle subsheet with timeseries
    private void toggleTimeseries(ListViewCommandEventArgs e, int rowindex)
    {
        ucTsPollutantReleasesSheet control = (ucTsPollutantReleasesSheet)this.lvPollutantReleases.Items[rowindex].FindControl("ucTsPollutantReleasesSheet");
        closeAllSubSheets(); // only allow 1 sheet open

        control.Visible = !control.Visible;
        Control div = this.lvPollutantReleases.Items[rowindex].FindControl("subsheet");
        div.Visible = !div.Visible;

        if (control.Visible)
        {
            // create search filter and change activity filter
            PollutantReleasesTimeSeriesFilter filter = FilterConverter.ConvertToPollutantReleasesTimeSeriesFilter(SearchFilter);
            filter.ActivityFilter = getActivityFilter(e);
            control.Populate(filter, SearchFilter.YearFilter.Year);
        }
    }


    /// <summary>
    /// Close sheets
    /// </summary>
    private void closeAllSubSheets()
    {
        for (int i = 0; i < this.lvPollutantReleases.Items.Count; i++)
        {
            ucTsPollutantReleasesSheet control = (ucTsPollutantReleasesSheet)this.lvPollutantReleases.Items[i].FindControl("ucTsPollutantReleasesSheet");
            if (control != null) control.Visible = false;
        }
    }


    /// <summary>
    /// new search on facility click
    /// </summary>
    protected void onFacilitySearchClick(object sender, CommandEventArgs e)
    {
        string code = e.CommandArgument.ToString().ToUpper();

        // create facility search filter from activity search criteria
        FacilitySearchFilter filter = FilterConverter.ConvertToFacilitySearchFilter(SearchFilter);
                        
        // Change activity filter
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

        LinkSearchRedirecter.ToIndustrialActivity(Response, filter, Sheets.IndustrialActivity.PollutantReleases);
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
        Control headerAir = this.lvPollutantReleases.FindControl("divHeaderAir");
        headerAir.Visible = ShowAir;

        Control headerWater = this.lvPollutantReleases.FindControl("divHeaderWater");
        headerWater.Visible = ShowWater;

        Control headerSoil = this.lvPollutantReleases.FindControl("divHeaderSoil");
        headerSoil.Visible = ShowSoil;

    }

    //Rows will only be shown if parent is expanded (grand-parents must be expanded too)
    protected void rows_OnItemDataBound(object sender, ListViewItemEventArgs e)
    {
        ListViewDataItem dataItem = e.Item as ListViewDataItem;
        if (dataItem == null) return; //safe check

        int rowindex = dataItem.DataItemIndex;

        PollutantReleases.ActivityTreeListRow row = dataItem.DataItem as PollutantReleases.ActivityTreeListRow;
        List<PollutantReleases.ActivityTreeListRow> data = ViewState[RESULT] as List<PollutantReleases.ActivityTreeListRow>;

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


    //only show air if selected in filter
    protected bool ShowAir
    {
        get { return SearchFilter.MediumFilter.ReleasesToAir; }
    }

    //only show water if selected in filter
    protected bool ShowWater
    {
        get { return SearchFilter.MediumFilter.ReleasesToWater; }
    }

    //only show soil if selected in filter
    protected bool ShowSoil
    {
        get { return SearchFilter.MediumFilter.ReleasesToSoil; }
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
        return NumberFormat.Format(((PollutantReleases.ActivityTreeListRow)obj).Facilities);
    }

    protected string GetAccidentalFacilities(object obj)
    {
        return NumberFormat.Format(((PollutantReleases.ActivityTreeListRow)obj).AccidentalFacilities);
    }


    protected string GetActivityCommandArg(object obj)
    {
        return ((ActivityTreeListRow)obj).GetCodeAndParent(); 
    }


    protected string GetTotalAir(object obj)
    {
        return ((PollutantReleases.ActivityTreeListRow)obj).FormatTotalAir();
    }
    protected string GetAccidentalAir(object obj)
    {
        return ((PollutantReleases.ActivityTreeListRow)obj).FormatAccidentalAir();
    }
    protected string GetToolTipAir(object obj)
    {
        return ((PollutantReleases.ActivityTreeListRow)obj).ToolTipAir();
    }

    protected string GetTotalSoil(object obj)
    {
        return ((PollutantReleases.ActivityTreeListRow)obj).FormatTotalSoil();
    }
    protected string GetAccidentalSoil(object obj)
    {
        return ((PollutantReleases.ActivityTreeListRow)obj).FormatAccidentalSoil();
    }
    protected string GetToolTipSoil(object obj)
    {
        return ((PollutantReleases.ActivityTreeListRow)obj).ToolTipSoil();
    }

    protected string GetTotalWater(object obj)
    {
        return ((PollutantReleases.ActivityTreeListRow)obj).FormatTotalWater();
    }
    protected string GetAccidentalWater(object obj)
    {
        return ((PollutantReleases.ActivityTreeListRow)obj).FormatAccidentalWater();
    }
    protected string GetToolTipWater(object obj)
    {
        return ((PollutantReleases.ActivityTreeListRow)obj).ToolTipWater();
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
        try
        {
            CultureInfo csvCulture = CultureResolver.ResolveCsvCulture(Request);
            CSVFormatter csvformat = new CSVFormatter(csvCulture);

            // Create Header
            var filter = SearchFilter;

            bool isConfidentialityAffected = PollutantReleases.IsAffectedByConfidentiality(filter);

            Dictionary<string, string> header = EPRTR.HeaderBuilders.CsvHeaderBuilder.GetPollutantReleaseSearchHeader(
                filter,
                isConfidentialityAffected);

            // Create Body
            var rows = PollutantReleases.GetActivityTree(filter);

            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string rowHeader = csvformat.GetPollutantReleaseActivityHeader(filter);

            Response.WriteUtf8FileHeader("EPRTR_Pollutant_Releases_Activity_List");

            Response.Write(topheader + rowHeader);

            foreach (var item in rows)
            {
                string row = csvformat.GetPollutantReleaseActivityRow(item, filter);
                Response.Write(row);
            }

            Response.End();
        }
        catch (Exception exception)
        {

        }
    }

}
