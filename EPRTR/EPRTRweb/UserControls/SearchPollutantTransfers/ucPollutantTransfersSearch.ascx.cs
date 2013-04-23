using System;
using System.Web.UI;
using EPRTR.Utilities;
using QueryLayer.Filters;
using EPRTR.HeaderBuilders;


public partial class ucPollutantTransfersSearch : System.Web.UI.UserControl
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
            PollutantTransfersSearchFilter filter = PopulateFilter();

            // start the search       
            InvokeSearch.Invoke(filter, e);
        }
    }

    public PollutantTransfersSearchFilter PopulateFilter()
    {
        PollutantTransfersSearchFilter filter = new PollutantTransfersSearchFilter();
        filter.YearFilter = this.ucYearSearchOption.PopulateFilter();
        filter.AreaFilter = this.ucAreaSearchOption.PopulateFilter();
        filter.PollutantFilter = this.ucPollutantSearchOption.PopulateFilter();
        filter.ActivityFilter = this.ucAdvancedActivitySearchOption.PopulateFilter();

        // store settings in cookies
        CookieStorage.SetFilter(Response, filter.AreaFilter);
        CookieStorage.SetFilter(Response, filter.YearFilter);

        return filter;
    }



}
