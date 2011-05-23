using System;
using System.Web.UI;
using EPRTR.Utilities;
using QueryLayer.Filters;
using EPRTR.HeaderBuilders;


public partial class ucWasteTransfersSearch : System.Web.UI.UserControl
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
            WasteTransferSearchFilter filter = PopulateFilter();

            // start the search       
            InvokeSearch.Invoke(filter, e);
        }
    }

    public WasteTransferSearchFilter PopulateFilter()
    {
        WasteTransferSearchFilter filter = new WasteTransferSearchFilter();
        filter.AreaFilter = this.ucAreaSearchOption.PopulateFilter();
        filter.YearFilter = this.ucYearSearchOption.PopulateFilter();
        filter.ActivityFilter = this.ucAdvancedActivitySearchOption.PopulateFilter();
        filter.WasteTypeFilter = this.ucWasteTypeSearchOption.PopulateFilter();
        filter.WasteTreatmentFilter = this.ucWasteTreatmenSearchOption.PopulateFilter();
        

        return filter;
    }



}
