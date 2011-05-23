using System;
using System.Web.UI;
using EPRTR.Utilities;
using QueryLayer.Filters;
using EPRTR.HeaderBuilders;


public partial class ucTsWasteTransfersSearch : System.Web.UI.UserControl
{
    public EventHandler InvokeSearch;

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        this.btnSearch.Focus();
    }



    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (InvokeSearch != null)
        {
            WasteTransferTimeSeriesFilter filter = PopulateFilter();

            // start the search       
            InvokeSearch.Invoke(filter, e);
        }
    }

    public WasteTransferTimeSeriesFilter PopulateFilter()
    {
        WasteTransferTimeSeriesFilter filter = new WasteTransferTimeSeriesFilter();
        filter.AreaFilter = this.ucAreaSearchOption.PopulateFilter();
        filter.PeriodFilter = new PeriodFilter();
        filter.PeriodFilter.StartYear = 2007;

        filter.ActivityFilter = this.ucAdvancedActivitySearchOption.PopulateFilter();

        filter.WasteTypeFilter = this.ucWasteTypeSearchOption.PopulateFilter();

        // store settings in cookies
        CookieStorage.SetFilter(Response, filter.AreaFilter);

        return filter;
    }


}
