using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using QueryLayer;
using QueryLayer.Filters;
using EPRTR.Localization;

public partial class ucWasteTransferComparison : System.Web.UI.UserControl
{
    
    private const string FILTER = "wasteTransferComparisonFilter";
    private const string DATA_NONHW = "wasteTransferComparisonData_NONHW";
    private const string DATA_HWIC = "wasteTransferComparisonData_HWIO";
    private const string DATA_HWOC = "wasteTransferComparisonData_HWOC";


    protected void Page_Load(object sender, EventArgs e)
    {
    }


    /// <summary>
    /// SearchFilter
    /// </summary>
    private WasteTransferSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as WasteTransferSearchFilter; }
        set { ViewState[FILTER] = value; }
    }
    
    /// <summary>
    /// populate
    /// </summary>
    public void Populate(
        WasteTransferSearchFilter filter, 
        WasteTransfers.FacilityCountObject counts)
    {
        // check that any relases are selected
        //this.rbHazardousGroup.Items.Clear();

        if (!filter.WasteTypeFilter.NonHazardousWaste &&
            !filter.WasteTypeFilter.HazardousWasteCountry &&
            !filter.WasteTypeFilter.HazardousWasteTransboundary)
        {
            this.compareChartPanel.Visible = false;
            this.litNoResult.Visible = true;
            EnableDisable.Visible = false;
            this.ucWasteTypeSelector.Visible = false;
            return;
        }

        // let flex chart be visible
        this.litNoResult.Visible = false;
        this.NoDataReturned.Visible = false; //flex (not asp)
        this.compareChartPanel.Visible = true;
        
        // update viewstate
        SearchFilter = filter;
        ViewState[DATA_NONHW] = null;
        ViewState[DATA_HWIC] = null;
        ViewState[DATA_HWOC] = null;

        this.ucWasteTypeSelector.PopulateRadioButtonList(filter.WasteTypeFilter, counts);
    }


    /// <summary>
    /// radio buttons selected
    /// </summary>
    protected void OnSelectedWasteTypeChanged(object sender, WasteTypeSelectedEventArgs e)
    {
        WasteTransferSearchFilter filter = ViewState[FILTER] as WasteTransferSearchFilter;
        if (filter!=null)
            updateGraph(filter,e.WasteType);
    }


    /// <summary>
    /// Update flash graph
    /// </summary>
    /// <param name="filter"></param>
    /// <param name="value">Chart data</param>
    /// <param name="chartLabel">Passed to flash charts.</param>
    private void updateGraph(WasteTransferSearchFilter filter, WasteTypeFilter.Type wasteType)
    {
        List<WasteTransfers.AreaComparison> result = null;

        string chartLabel = String.Empty;

        if (wasteType.Equals(WasteTypeFilter.Type.NonHazardous)) // Non Hazardous waste
        {
            if (ViewState[DATA_NONHW] != null)
            {
                result = ViewState[DATA_NONHW] as List<WasteTransfers.AreaComparison>;
            }
            else
            {
                result = WasteTransfers.GetAreaComparison(filter, WasteTypeFilter.Type.NonHazardous);
                translateArea(filter.AreaFilter, result);
                ViewState[DATA_NONHW] = result;
            }
            chartLabel = Resources.GetGlobal("Common", "NoHazardouswaste");
        }
        else if (wasteType.Equals(WasteTypeFilter.Type.HazardousCountry)) // hazardous within country (Hazardous waste, domestic)
        {
            if (ViewState[DATA_HWIC] != null)
            {
                result = ViewState[DATA_HWIC] as List<WasteTransfers.AreaComparison>;
            }
            else
            {
                result = WasteTransfers.GetAreaComparison(filter, WasteTypeFilter.Type.HazardousCountry);
                translateArea(filter.AreaFilter, result);
                ViewState[DATA_HWIC] = result;
            }
            chartLabel = Resources.GetGlobal("Common", "HazardouswasteWithinCountry");
        }
        else if (wasteType.Equals(WasteTypeFilter.Type.HazardousTransboundary)) // Hazardous waste, transboundary
        {
            if (ViewState[DATA_HWOC] != null)
            {
                result = ViewState[DATA_HWOC] as List<WasteTransfers.AreaComparison>;
            }
            else
            {
                result = WasteTransfers.GetAreaComparison(filter, WasteTypeFilter.Type.HazardousTransboundary);
                translateArea(filter.AreaFilter, result);
                ViewState[DATA_HWOC] = result;
            }
            chartLabel = Resources.GetGlobal("Common", "HazardouswasteTransboundary");
        }

        //add flash
        AddFlashCharts(result, chartLabel);
    }

    /// <summary>
    /// Translate if specific country selected
    /// </summary>
    private void translateArea(AreaFilter filter, List<WasteTransfers.AreaComparison> compareList)
    {
        //dont translate countries, only regions (NUTS or RBD)
        if (filter.SearchLevel() != AreaFilter.Level.AreaGroup)
        {
            foreach (WasteTransfers.AreaComparison cl in compareList)
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


    /// <summary>
    /// Add flash comparison chart
    /// </summary>
    private void AddFlashCharts(List<WasteTransfers.AreaComparison> result, string chartLabel)
    {
        bool hasValues = result.Any(x => !x.Total.Equals(null) && x.Total > 0.0);

        if (result.Count != 0 && hasValues)
        {
            this.NoDataReturned.Visible = false;
            this.lbDoubleCounting.Visible = true;
            
            // create the chart
            string swfFile = EPRTR.Charts.ChartsUtils.WasteTransferAreaComparisonChart;
            EPRTR.Charts.ChartsUtils.ChartClientScript(swfFile, result, this.compareChartPanel, this.UniqueID.ToString(), chartLabel, result.Count);    
        }
        else
        {
            // show no data returned
            this.NoDataReturned.Visible = true;
            this.lbDoubleCounting.Visible = false;
        }
    }

}
