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

public partial class ucIndustrialActivityPollutantReleases : System.Web.UI.UserControl
{
    private const string FILTER = "IndustrialActivityPollutantReleasesFilter";
    
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
        this.lvIndustrialPollutantReleases.DataSource = QueryLayer.IndustrialActivity.GetPollutantReleases(filter);
        this.lvIndustrialPollutantReleases.DataBind();
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
        if (rowindex >= 0 && rowindex < this.lvIndustrialPollutantReleases.Items.Count)
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
        ucTsPollutantReleasesSheet control = (ucTsPollutantReleasesSheet)this.lvIndustrialPollutantReleases.Items[rowindex].FindControl("ucTsPollutantReleasesSheet");
        closeAllSubSheets(); // only allow 1 sheet open

        control.Visible = !control.Visible;
        Control div = this.lvIndustrialPollutantReleases.Items[rowindex].FindControl("subsheet");
        div.Visible = !div.Visible;

        if (control.Visible)
        {
            // create search filter and change activity filter
            PollutantReleasesTimeSeriesFilter filter = FilterConverter.ConvertToPollutantReleasesTimeSeriesFilter(SearchFilter);
            // create pollutant and medium filter
            filter.PollutantFilter = getPollutantFilter(e);
            filter.MediumFilter = getMediumFilter(e);

            control.Populate(filter, SearchFilter.YearFilter.Year);
        }
    }


    /// <summary>
    /// Close sheets
    /// </summary>
    private void closeAllSubSheets()
    {
        for (int i = 0; i < this.lvIndustrialPollutantReleases.Items.Count; i++)
        {
            ucTsPollutantReleasesSheet control = (ucTsPollutantReleasesSheet)this.lvIndustrialPollutantReleases.Items[i].FindControl("ucTsPollutantReleasesSheet");
            if (control != null) control.Visible = false;
        }
    }



    /// <summary>
    /// invoke facility search for this row
    /// </summary>
    protected void onFacilitySearchClick(object sender, CommandEventArgs e)
    {
        string arg = e.CommandArgument.ToString();
        string[] codeAndLevel = arg.Split('&');
        if (codeAndLevel.Length < 2) return; //safe check, must have min two value
                        
        // create facility search filter from activity search criteria
        FacilitySearchFilter filter = FilterConverter.ConvertToFacilitySearchFilter(SearchFilter);

        // create pollutant and medium filter
        filter.PollutantFilter = getPollutantFilter(e);
        filter.MediumFilter = getMediumFilter(e);
                
        // go to facility levels page
        LinkSearchRedirecter.ToFacilitySearch(Response, filter);
    }

    /// <summary>
    /// invoke pollutant search search for this row
    /// </summary>
    protected void onPollutantSearchClick(object sender, CommandEventArgs e)
    {
        // create pollutant search filter
        PollutantReleaseSearchFilter filter = FilterConverter.ConvertToPollutantReleaseSearchFilter(SearchFilter);
        
        // create pollutant filter
        filter.PollutantFilter = getPollutantFilter(e);
        // set medium filter
        filter.MediumFilter = getMediumFilter(e);
                
        // go to pollutant release
        LinkSearchRedirecter.ToPollutantReleases(Response, filter);
    }

    private static MediumFilter getMediumFilter(CommandEventArgs args)
    {
        return LinkSearchBuilder.GetMediumFilter(true, true, true, false);
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
        PollutantReleases.ReleasesTreeListRow row = (PollutantReleases.ReleasesTreeListRow)obj;
        
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

    protected bool IsChild(object obj)
    {
        int level = ((TreeListRow)obj).Level;
        return (level != 0);
    }


    protected string GetCode(object obj)
    {
        return ((TreeListRow)obj).Code;
    }

    protected string GetCodeAndLevel(object obj)
    {
        return ((TreeListRow)obj).Code + "&" + ((TreeListRow)obj).Level;
    }


    protected string GetGroupCount(object obj)
    {
        IndustrialActivity.IAReleasesTreeListRow row = (IndustrialActivity.IAReleasesTreeListRow)obj;

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

    private string groupCount(PollutantReleases.ReleasesTreeListRow row)
    {
        int total = ListOfValues.CountLeafPollutants(row.Code);
        int number = 0;
        return String.Format("({0}/{1})", number, total);
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
        PollutantReleases.ReleasesTreeListRow row = (PollutantReleases.ReleasesTreeListRow)obj;
        return row.HasChildren ? string.Empty : row.FormatTotalAir();
    }
    protected string GetAccidentalAir(object obj)
    {
        PollutantReleases.ReleasesTreeListRow row = (PollutantReleases.ReleasesTreeListRow)obj;
        return row.HasChildren ? string.Empty : row.FormatAccidentalAir();
    }
    protected string GetToolTipAir(object obj)
    {
        PollutantReleases.ReleasesTreeListRow row = (PollutantReleases.ReleasesTreeListRow)obj;
        return row.HasChildren ? string.Empty : row.ToolTipAir();
    }
    protected string GetToolTipPollutantReleaseSearch()
    {
        return Resources.GetGlobal("Common", "LinkSearchPollutantRelease");
    }
    protected string GetToolTipFacilitySearch()
    {
        return Resources.GetGlobal("Common", "LinkSearchFacility");
    }


    protected string GetTotalSoil(object obj)
    {
        PollutantReleases.ReleasesTreeListRow row = (PollutantReleases.ReleasesTreeListRow)obj;
        return row.HasChildren ? string.Empty : row.FormatTotalSoil();
    }
    protected string GetAccidentalSoil(object obj)
    {
        PollutantReleases.ReleasesTreeListRow row = (PollutantReleases.ReleasesTreeListRow)obj;
        return row.HasChildren ? string.Empty : row.FormatAccidentalSoil();
    }
    protected string GetToolTipSoil(object obj)
    {
        PollutantReleases.ReleasesTreeListRow row = (PollutantReleases.ReleasesTreeListRow)obj;
        return row.HasChildren ? string.Empty : row.ToolTipSoil();
    }

    protected string GetTotalWater(object obj)
    {
        PollutantReleases.ReleasesTreeListRow row = (PollutantReleases.ReleasesTreeListRow)obj;
        return row.HasChildren ? string.Empty : row.FormatTotalWater();
    }
    protected string GetAccidentalWater(object obj)
    {
        PollutantReleases.ReleasesTreeListRow row = (PollutantReleases.ReleasesTreeListRow)obj;
        return row.HasChildren ? string.Empty : row.FormatAccidentalWater();
    }
    protected string GetToolTipWater(object obj)
    {
        PollutantReleases.ReleasesTreeListRow row = (PollutantReleases.ReleasesTreeListRow)obj;
        return row.HasChildren ? string.Empty : row.ToolTipWater();
    }

    protected string GetToolTipTimeSeries()
    {
        return Resources.GetGlobal("Common", "LinkTimeSeries");
    }

    protected bool ShowTimeSeries(object obj)
    {
        //onlæy show time series icons for pollutants - not for groups
        PollutantTransfers.TransfersTreeListRow row = (PollutantTransfers.TransfersTreeListRow)obj;
        return row.Level == 1;
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

            bool isConfidentialityAffected = IndustrialActivity.IsPollutantReleaseAffectedByConfidentiality(filter);

            Dictionary<string, string> header = EPRTR.HeaderBuilders.CsvHeaderBuilder.GetIndustrialActivitySearchHeader(
                filter,
                isConfidentialityAffected);

            // Create Body
            var rows = IndustrialActivity.GetPollutantReleases(filter);

            // dump to file
            string topheader = csvformat.CreateHeader(header);
            string rowHeader = csvformat.GetIndustrialActivityPollutantReleasesHeader();

            Response.WriteUtf8FileHeader("EPRTR_Industrial_Activity_Pollutant_Releases_List");

            Response.Write(topheader + rowHeader);

            foreach (var item in rows)
            {
                string row = csvformat.GetIndustrialActivityPollutantReleasesRow(item);
                Response.Write(row);
            }

            Response.End();
        }
        catch
        {
        }
    }


}
