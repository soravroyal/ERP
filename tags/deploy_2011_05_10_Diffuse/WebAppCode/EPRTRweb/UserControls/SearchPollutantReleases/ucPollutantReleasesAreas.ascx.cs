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

public partial class ucPollutantReleasesAreas : System.Web.UI.UserControl
{
    private const string FILTER = "pollutantreleasesfilter";
    private const string TREE = "pollutantreleasestree";
    private const string BASERESULT = "base_releasesarea";
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
    public void Populate(PollutantReleaseSearchFilter filter)
    {
        SearchFilter = filter;

        List<PollutantReleases.ReleasesTreeListRow> data = QueryLayer.PollutantReleases.GetArea(filter);
        PollutantReleasesAreaTreeListRowComparer c = new PollutantReleasesAreaTreeListRowComparer(filter.AreaFilter);
        data.Sort(c);

        ViewState[BASERESULT] = data;
        this.lvPollutantReleasesArea.DataSource = data;
        this.lvPollutantReleasesArea.DataBind();

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
                    string code = e.CommandName.ToString();
                    bool expanded = TreeListHelper.GetExpanded(TreeStructure, code);
                    TreeListHelper.SetExpanded(TreeStructure, code, !expanded);

                    List<PollutantReleases.ReleasesTreeListRow> baseResult = ViewState[BASERESULT] as List<PollutantReleases.ReleasesTreeListRow>;

                    List<PollutantReleases.ReleasesTreeListRow> data = QueryLayer.PollutantReleases.GetAreaTree(TreeStructure, SearchFilter, baseResult);
                    PollutantReleasesAreaTreeListRowComparer c = new PollutantReleasesAreaTreeListRowComparer(SearchFilter.AreaFilter);
                    data.Sort(c);

                    this.lvPollutantReleasesArea.DataSource = data;
                    this.lvPollutantReleasesArea.DataBind();

                    // notify that content has changed (print)
                    if (ContentChanged != null)
                        ContentChanged.Invoke(null, EventArgs.Empty);
                }
            }
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
        return NumberFormat.Format(((PollutantReleases.ReleasesTreeListRow)obj).Facilities);
    }

    protected string GetAccidentalFacilities(object obj)
    {
        return NumberFormat.Format(((PollutantReleases.ReleasesTreeListRow)obj).AccidentalFacilities);
    }


    protected string GetTotalAir(object obj)
    {
        return ((PollutantReleases.ReleasesTreeListRow)obj).FormatTotalAir();
    }
    protected string GetAccidentalAir(object obj)
    {
        return ((PollutantReleases.ReleasesTreeListRow)obj).FormatAccidentalAir();
    }
    protected string GetToolTipAir(object obj)
    {
        return ((PollutantReleases.ReleasesTreeListRow)obj).ToolTipAir();
    }

    protected string GetTotalSoil(object obj)
    {
        return ((PollutantReleases.ReleasesTreeListRow)obj).FormatTotalSoil();
    }
    protected string GetAccidentalSoil(object obj)
    {
        return ((PollutantReleases.ReleasesTreeListRow)obj).FormatAccidentalSoil();
    }
    protected string GetToolTipSoil(object obj)
    {
        return ((PollutantReleases.ReleasesTreeListRow)obj).ToolTipSoil();
    }

    protected string GetTotalWater(object obj)
    {
        return ((PollutantReleases.ReleasesTreeListRow)obj).FormatTotalWater();
    }
    protected string GetAccidentalWater(object obj)
    {
        return ((PollutantReleases.ReleasesTreeListRow)obj).FormatAccidentalWater();
    }
    protected string GetToolTipWater(object obj)
    {
        return ((PollutantReleases.ReleasesTreeListRow)obj).ToolTipWater();
    }
    protected string GetToolTipTimeSeries()
    {
        return Resources.GetGlobal("Common", "LinkTimeSeries");
    }

    protected bool ShowFacilityLink(object obj)
    {
        return ((PollutantReleases.ReleasesTreeListRow)obj).AllowFacilityLink();
    }
    #endregion



}
