using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using QueryLayer;
using QueryLayer.Filters;
using EPRTR.Localization;

public partial class ucPollutantTransfersAreaComparison : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    public void Populate(PollutantTransfersSearchFilter filter)
    {
        List<PollutantTransfers.AreaComparison> compareList = PollutantTransfers.GetAreaComparison(filter);
        string title = string.Empty;

        // Translate area codes
        translateArea(filter.AreaFilter, compareList);

        // update flash
        int compareListCount = compareList.Count;
        if (compareListCount != 0)
        {
            string swfFile = EPRTR.Charts.ChartsUtils.PolluntantTransferAreaComparisonChart;
            EPRTR.Charts.ChartsUtils.ChartClientScript(swfFile, title, compareList, this.compareChartPanel, this.UniqueID.ToString(), EPRTR.Charts.ChartsUtils.AreaType.Air, compareListCount);
        }
        else
        {
            //show no data control
            this.NoDataReturned.Visible = true;
        }

    }

    // Translate if specific country selected
    private void translateArea(AreaFilter filter, List<PollutantTransfers.AreaComparison> compareList)
    {
        //dont translate countries, only regions (NUTS or RBD)
        if (filter.SearchLevel() != AreaFilter.Level.AreaGroup)
        {
            foreach (PollutantTransfers.AreaComparison cl in compareList)
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
