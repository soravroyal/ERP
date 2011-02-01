using System;
using System.Collections.Generic;
using EPRTR.Localization;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;

public partial class ucPollutantReleasesComparison : System.Web.UI.UserControl
{
    private const string FILTER = "pollutantReleasesComparisonFilter";

    private const string DATA_AIR = "pollutantReleasesComparisonAirData";
    private const string DATA_WATER = "pollutantReleasesComparisonWaterData";
    private const string DATA_SOIL = "pollutantReleasesComparisonSoilData";
    
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// populate
    /// </summary>
    public void Populate(
        PollutantReleaseSearchFilter filter,
        PollutantReleases.FacilityCountObject counts)
    {
        // check that any relases are selected
        if (!filter.MediumFilter.ReleasesToAir &&
            !filter.MediumFilter.ReleasesToWater &&
            !filter.MediumFilter.ReleasesToSoil)
        {
            this.compareChartPanel.Visible = false;
            this.litNoResultFound.Visible = true;
            this.ucMediumSelector.Visible = false;
            return;
        }

        // let flex chart be visible
        this.compareChartPanel.Visible = true;
        this.litNoResultFound.Visible = false;

        ViewState[FILTER] = filter;
        ViewState[DATA_AIR] = null;
        ViewState[DATA_WATER] = null;
        ViewState[DATA_SOIL] = null;

        this.ucMediumSelector.PopulateMediumRadioButtonList(filter.MediumFilter, counts);
    }


    /// <summary>
    /// radio buttons selected
    /// </summary>
    protected void OnSelectedMediumChanged(object sender, MediumSelectedEventArgs e)
    {
        PollutantReleaseSearchFilter filter = ViewState[FILTER] as PollutantReleaseSearchFilter;
        updateGraph(filter, e.Medium);
    }


    /// <summary>
    /// Update flash graph
    /// foreach (PollutantReleases.AreaComparison item in list)
    //  Debug.WriteLine(String.Format("Area:{0}   Quantity:{1}   Percent:{2}", item.Area, item.Quantity, item.Percent));
    /// </summary>
    private void updateGraph(PollutantReleaseSearchFilter filter,  MediumFilter.Medium medium)
    {
        string title = LOVResources.MediumName(EnumUtil.GetStringValue(medium));
        string swfFile = EPRTR.Charts.ChartsUtils.PolluntantReleaseAreaComparisonChart;
        EPRTR.Charts.ChartsUtils.AreaType? chartType = null;

        List<PollutantReleases.AreaComparison> list = null;

        if (medium.Equals(MediumFilter.Medium.Air))
        {
            if (ViewState[DATA_AIR] != null)
            {
                list = ViewState[DATA_AIR] as List<PollutantReleases.AreaComparison>;
            }
            else
            {
                list = PollutantReleases.GetAreaComparison(filter, MediumFilter.Medium.Air);
                translateArea(filter.AreaFilter, list);
                ViewState[DATA_AIR] = list;
            }

            chartType = EPRTR.Charts.ChartsUtils.AreaType.Air;
        }

        else if (medium.Equals(MediumFilter.Medium.Water))
        {
            if (ViewState[DATA_WATER] != null)
            {
                list = ViewState[DATA_WATER] as List<PollutantReleases.AreaComparison>;
            }
            else
            {
                list = PollutantReleases.GetAreaComparison(filter, MediumFilter.Medium.Water);
                translateArea(filter.AreaFilter, list);
                ViewState[DATA_WATER] = list;
            }
            chartType = EPRTR.Charts.ChartsUtils.AreaType.Water;
        }

        else if (medium.Equals(MediumFilter.Medium.Soil))
        {
            if (ViewState[DATA_SOIL] != null)
            {
                list = ViewState[DATA_SOIL] as List<PollutantReleases.AreaComparison>;
            }
            else
            {
                list = PollutantReleases.GetAreaComparison(filter, MediumFilter.Medium.Soil);
                translateArea(filter.AreaFilter, list);
                ViewState[DATA_SOIL] = list;
            }
            chartType = EPRTR.Charts.ChartsUtils.AreaType.Soil;
        }

        bool hasData = list != null && list.Count != 0;

        this.NoDataReturned.Visible = !hasData;
        if (hasData)
            DisplayChart(title, swfFile, list, chartType.Value);

    }


    private void DisplayChart(string title, string swfFile, List<PollutantReleases.AreaComparison> list, EPRTR.Charts.ChartsUtils.AreaType type)
    {
        if (list.Count != 0)
        {
            EPRTR.Charts.ChartsUtils.ChartClientScript(swfFile, title, list, this.compareChartPanel, this.UniqueID.ToString(), type, list.Count);
        }
        else
        {
            this.NoDataReturned.Visible = true;   
        }
        
    }

    private void translateArea(AreaFilter filter, List<PollutantReleases.AreaComparison> compareList)
    {
        //dont translate countries, only regions (NUTS or RBD)
        if (filter.SearchLevel() != AreaFilter.Level.AreaGroup)
        {
            foreach (PollutantReleases.AreaComparison cl in compareList)
            {
                if (filter.TypeRegion == AreaFilter.RegionType.RiverBasinDistrict)
                {
                    cl.Area = LOVResources.RiverBasinDistrictName(cl.Area); //RiverBasinDistrictCode
                }
                else if (filter.TypeRegion == AreaFilter.RegionType.NUTSregion)
                {
                    cl.Area = LOVResources.NutsRegionName(cl.Area); //NUTS code
                }

            }
        }
    }



}
