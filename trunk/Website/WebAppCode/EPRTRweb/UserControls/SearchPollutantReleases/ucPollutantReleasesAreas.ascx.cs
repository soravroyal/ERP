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

public partial class ucPollutantReleasesAreas : System.Web.UI.UserControl
{
    private const string FILTER = "pollutantreleasesfilter";
    private const string RESULT = "base_releasesarea";
    public EventHandler ContentChanged;

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// search filter to be used by sub sheet
    /// </summary>
    public PollutantReleaseSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as PollutantReleaseSearchFilter; }
        set { ViewState[FILTER] = value; }
    }


    /// <summary>
    /// method to populate the listview
    /// </summary>
    public void Populate(PollutantReleaseSearchFilter filter)
    {
        SearchFilter = filter;

        List<PollutantReleases.AreaTreeListRow> data = QueryLayer.PollutantReleases.GetCountries(filter).ToList<PollutantReleases.AreaTreeListRow>();
        
        sortResult(data);
        ViewState[RESULT] = data;

        this.lvPollutantReleasesArea.DataSource = data;
        this.lvPollutantReleasesArea.DataBind();

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
        if (rowindex >= 0 && rowindex < this.lvPollutantReleasesArea.Items.Count)
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
        List<PollutantReleases.AreaTreeListRow> data = ViewState[RESULT] as List<PollutantReleases.AreaTreeListRow>;
        PollutantReleases.AreaTreeListRow row = data[rowindex];

        //toggle expansion
        row.IsExpanded = !row.IsExpanded;

        //get data from database, if not already loaded
        if (row.HasChildren && row.IsExpanded && !data.Any(r => r.Level == row.Level + 1 && r.ParentCode == row.Code))
        {
            if (row.Level == 0)
            {
                var subareas = PollutantReleases.GetSubAreas(SearchFilter, new List<string> { row.CountryCode });
                addToResult(subareas);
            }
        }

        this.lvPollutantReleasesArea.DataSource = data;
        this.lvPollutantReleasesArea.DataBind();

        // notify that content has changed (print)
        if (ContentChanged != null)
            ContentChanged.Invoke(null, EventArgs.Empty);
    }


    //add data to list. Sort and save new list in viewstate.
    private void addToResult(IEnumerable<PollutantReleases.AreaTreeListRow> rows)
    {
        List<PollutantReleases.AreaTreeListRow> data = ViewState[RESULT] as List<PollutantReleases.AreaTreeListRow>;
        data.AddRange(rows);
        sortResult(data);
        ViewState[RESULT] = data;


    }

    private void sortResult(List<PollutantReleases.AreaTreeListRow> data)
    {
        if (data != null && data.Count > 0)
        {
            PollutantReleasesAreaTreeListRowComparer c = new PollutantReleasesAreaTreeListRowComparer(SearchFilter.AreaFilter);
            data.Sort(c);
        }
    }


    private void toggleTimeseries(ListViewCommandEventArgs e, int rowindex)
    {
        ucTsPollutantReleasesSheet control = (ucTsPollutantReleasesSheet)this.lvPollutantReleasesArea.Items[rowindex].FindControl("ucTsPollutantReleasesSheet");
        closeAllSubSheets(); // only allow 1 sheet open

        control.Visible = !control.Visible;
        Control div = this.lvPollutantReleasesArea.Items[rowindex].FindControl("subsheet");
        div.Visible = !div.Visible;

        if (control.Visible)
        {
            // create search filter and change area filter
            PollutantReleasesTimeSeriesFilter filter = FilterConverter.ConvertToPollutantReleasesTimeSeriesFilter(SearchFilter);
            filter.AreaFilter = getAreaFilter(e);
            control.Populate(filter, SearchFilter.YearFilter.Year);
        }
    }


    /// <summary>
    /// Close sheets
    /// </summary>
    private void closeAllSubSheets()
    {
        for (int i = 0; i < this.lvPollutantReleasesArea.Items.Count; i++)
        {
            ucTsPollutantReleasesSheet control = (ucTsPollutantReleasesSheet)this.lvPollutantReleasesArea.Items[i].FindControl("ucTsPollutantReleasesSheet");
            if (control != null) control.Visible = false;
        }
    }

    private AreaFilter getAreaFilter(CommandEventArgs args)
    {
        string arg = args.CommandArgument.ToString();
        string[] codes = arg.Split('&');
        if (codes.Length < 2) return null; //safe check, must have min two value

        return LinkSearchBuilder.GetAreaFilter(SearchFilter.AreaFilter, codes[0], codes[1]);
    }

    /// <summary>
    /// new search on facility click
    /// </summary>
    protected void onNewSearchClick(object sender, CommandEventArgs e)
    {
        string code = e.CommandArgument.ToString().ToUpper();

        // create facility search filter from activity search criteria
        FacilitySearchFilter filter = FilterConverter.ConvertToFacilitySearchFilter(SearchFilter);

        // Search for country according to code
        filter.AreaFilter = getAreaFilter(e);                        
        // go to facility levels page
        LinkSearchRedirecter.ToFacilitySearch(Response, filter);
    }

    
    
    #region DataBinding methods

    //Hide headers dependend on filter selections.
    protected void OnDataBinding(object sender, EventArgs e)
    {
        Control headerAir = this.lvPollutantReleasesArea.FindControl("divHeaderAir");
        headerAir.Visible = ShowAir;

        Control headerWater = this.lvPollutantReleasesArea.FindControl("divHeaderWater");
        headerWater.Visible = ShowWater;

        Control headerSoil = this.lvPollutantReleasesArea.FindControl("divHeaderSoil");
        headerSoil.Visible = ShowSoil;

    }

    //Rows will only be shown if parent is expanded (grand-parents must be expanded too)
    protected void rows_OnItemDataBound(object sender, ListViewItemEventArgs e)
    {
        ListViewDataItem dataItem = e.Item as ListViewDataItem;
        if (dataItem == null) return; //safe check

        int rowindex = dataItem.DataItemIndex;

        PollutantReleases.AreaTreeListRow row = dataItem.DataItem as PollutantReleases.AreaTreeListRow;
        List<PollutantReleases.AreaTreeListRow> data = ViewState[RESULT] as List<PollutantReleases.AreaTreeListRow>;

        //Countries need not to be considered. Will always be visible
        bool collapsed = false;
        if (row.Level > 0)
        {
            //is country collapsed?
            collapsed = !data.Single(d => d.CountryCode == row.CountryCode && d.Level == 0).IsExpanded;
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
        return NumberFormat.Format(((PollutantReleases.PollutantReleaseRow)obj).Facilities);
    }

    protected string GetAccidentalFacilities(object obj)
    {
        return NumberFormat.Format(((PollutantReleases.PollutantReleaseRow)obj).AccidentalFacilities);
    }


    protected string GetTotalAir(object obj)
    {
        return ((PollutantReleases.PollutantReleaseRow)obj).FormatTotalAir();
    }
    protected string GetAccidentalAir(object obj)
    {
        return ((PollutantReleases.PollutantReleaseRow)obj).FormatAccidentalAir();
    }
    protected string GetToolTipAir(object obj)
    {
        return ((PollutantReleases.PollutantReleaseRow)obj).ToolTipAir();
    }

    protected string GetTotalSoil(object obj)
    {
        return ((PollutantReleases.PollutantReleaseRow)obj).FormatTotalSoil();
    }
    protected string GetAccidentalSoil(object obj)
    {
        return ((PollutantReleases.PollutantReleaseRow)obj).FormatAccidentalSoil();
    }
    protected string GetToolTipSoil(object obj)
    {
        return ((PollutantReleases.PollutantReleaseRow)obj).ToolTipSoil();
    }

    protected string GetTotalWater(object obj)
    {
        return ((PollutantReleases.PollutantReleaseRow)obj).FormatTotalWater();
    }
    protected string GetAccidentalWater(object obj)
    {
        return ((PollutantReleases.PollutantReleaseRow)obj).FormatAccidentalWater();
    }
    protected string GetToolTipWater(object obj)
    {
        return ((PollutantReleases.PollutantReleaseRow)obj).ToolTipWater();
    }
    protected string GetToolTipTimeSeries()
    {
        return Resources.GetGlobal("Common", "LinkTimeSeries");
    }

    protected bool ShowFacilityLink(object obj)
    {
        return ((PollutantReleases.AreaTreeListRow)obj).AllowFacilityLink();
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
            List<PollutantReleases.AreaTreeListRow> rows = PollutantReleases.GetAreaTree(filter).ToList();
            sortResult(rows);

            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string[] colHeaderRows = csvformat.GetPollutantReleaseAreaColHeaderRows(filter);

            Response.WriteUtf8FileHeader("EPRTR_Pollutant_Releases_Area_List");

            Response.Write(topheader + colHeaderRows[0] + colHeaderRows[1]);

            
            foreach (var item in rows)
            {
                string row = csvformat.GetPollutantReleaseAreaRow(item, filter);

                if (AreaTreeListRow.CODE_TOTAL.Equals(item.Code))
                {
                    Response.Write(Environment.NewLine);
                    Response.Write(colHeaderRows[0] + colHeaderRows[1]);
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
