using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer.Filters;
using EPRTR.Utilities;

public partial class ucTsPollutantTransfersSearch : System.Web.UI.UserControl
{
    public EventHandler InvokeSearch;

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        this.btnSearch.Focus();
    }



    /// <summary>
    /// Search
    /// </summary>
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (InvokeSearch != null)
        {
            PollutantTransferTimeSeriesFilter filter = PopulateFilter();

            // start the search       
            InvokeSearch.Invoke(filter, e);
        }
    }

    public PollutantTransferTimeSeriesFilter PopulateFilter()
    {
        PollutantTransferTimeSeriesFilter filter = new PollutantTransferTimeSeriesFilter();
        filter.PeriodFilter = new PeriodFilter();
        filter.PeriodFilter.StartYear = 2007; //EPER years are not included.

        filter.AreaFilter = this.ucAreaSearchOption.PopulateFilter();
        filter.PollutantFilter = this.ucPollutantSearchOption.PopulateFilter();
        filter.ActivityFilter = this.ucAdvancedActivitySearchOption.PopulateFilter();

        // store settings in cookies
        CookieStorage.SetFilter(Response, filter.AreaFilter);

        return filter;
    }



}
