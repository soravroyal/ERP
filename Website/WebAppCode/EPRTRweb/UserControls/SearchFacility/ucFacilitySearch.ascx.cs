using System;
using System.Web.UI;
using EPRTR.Utilities;
using QueryLayer.Filters;
using EPRTR.HeaderBuilders;

public partial class ucFacilitySearch : System.Web.UI.UserControl
{
    public EventHandler InvokeSearch;
    
    /// <summary>
    /// Load search form
    /// </summary>
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    

    protected void Page_PreRender(object sender, EventArgs e)
    {
        this.btnSearch.Focus();
    }


    /// <summary>
    /// Facility search button
    /// </summary>
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        if (InvokeSearch != null)
        {
            FacilitySearchFilter filter = PopulateFilter();
                                    
            // Give filter to facility-result usercontrol component
            // This will invoke the search
            InvokeSearch.Invoke(filter, e);
        }
    }

    public FacilitySearchFilter PopulateFilter()
    {
        // Assign search parameters to filter (avoid use of session, request from EPRTR)
        // create new filter instance
        FacilitySearchFilter filter = new FacilitySearchFilter();
        filter.AreaFilter = this.ucAreaSearchOption.PopulateFilter();
        filter.YearFilter = this.ucYearSearchOption.PopulateFilter();
        filter.FacilityLocationFilter = this.ucFacilityLocationSearchOption.PopulateFilter();
        filter.ActivityFilter = this.ucAdvancedActivitySearchOption.PopulateFilter();

        //pollutant filters
        PollutantFilter pollutantFilter;
        MediumFilter mediumFilter;
        AccidentalFilter accidentalFilter;
        this.ucAdvancedPollutantSearchOption.PopulateFilters(out pollutantFilter, out mediumFilter, out accidentalFilter);
        filter.PollutantFilter = pollutantFilter;
        filter.MediumFilter = mediumFilter;
        filter.AccidentalFilter = accidentalFilter;

        WasteTypeFilter wasteTypeFilter;
        WasteTreatmentFilter wasteTreatmentFilter;
        WasteReceiverFilter wasteReceiverFilter;
        this.ucAdvancedWasteSearchOption.PopulateFilters(out wasteTypeFilter, out wasteTreatmentFilter, out wasteReceiverFilter);
        filter.WasteTypeFilter = wasteTypeFilter;
        filter.WasteTreatmentFilter = wasteTreatmentFilter;
        filter.WasteReceiverFilter = wasteReceiverFilter;

        // store settings in cookies
        CookieStorage.SetFilter(Response, filter.AreaFilter);
        CookieStorage.SetFilter(Response, filter.YearFilter);

        return filter;
    }

}
