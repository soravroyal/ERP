using System;
using System.Web.UI;
using EPRTR.Utilities;
using QueryLayer.Filters;
using EPRTR.HeaderBuilders;


public partial class ucAreaOverviewSearch : System.Web.UI.UserControl
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
            AreaOverviewSearchFilter filter = PopulateFilter();

            
            // start the search       
            InvokeSearch.Invoke(filter, e);
        }
    }

    public AreaOverviewSearchFilter PopulateFilter()
    {
        AreaOverviewSearchFilter filter = new AreaOverviewSearchFilter();
        filter.AreaFilter = this.ucAreaSearchOption.PopulateFilter();
        filter.YearFilter = this.ucYearSearchOption.PopulateFilter();

        // store settings in cookies
        CookieStorage.SetFilter(Response, filter.AreaFilter);
        CookieStorage.SetFilter(Response, filter.YearFilter);

        return filter;
    }



}

