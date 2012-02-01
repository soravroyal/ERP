using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using EPRTR.Localization;
using EPRTR.Utilities;
using QueryLayer;
using QueryLayer.Filters;
using EPRTR.Comparers;
using System.Linq;


public partial class ucAreaSearchOption : System.Web.UI.UserControl
{
    private AreaFilter Filter{ get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Look for filter from link search
            Filter = LinkSearchBuilder.GetAreaFilter(Request);

            // Only if we have nothing from the links search, look into the cookies
            if (Filter==null)
                Filter = CookieStorage.GetAreaFilter(Request);

            // Populate
            PopulateRegionType();
            populateAreaCountry();
        }
    }
            
    private void PopulateRegionType()
    {
        rblRegionType.Items.Clear();
        rblRegionType.Items.Add(new ListItem(Resources.GetGlobal("Common", "Region"), ((int)AreaFilter.RegionType.NUTSregion).ToString()/*, false*/));
        rblRegionType.Items.Add(new ListItem(Resources.GetGlobal("Common", "RiverBasinDistrict"), ((int)AreaFilter.RegionType.RiverBasinDistrict).ToString()));

        setSelectedRegionType();
    }

    private void setSelectedRegionType()
    {
        //default is RBD. Set it first in case it cannot be set from filter
        rblRegionType.SelectedValue = ((int)AreaFilter.RegionType.RiverBasinDistrict).ToString();

        if (Filter != null)
        {
            ListItem item = rblRegionType.Items.FindByValue(((int)Filter.TypeRegion).ToString());

            if(item != null)
            {
                rblRegionType.SelectedValue = item.Value;
            }
        }
    }
       
    private void populateAreaCountry()
    {
        this.cbFacilityCountry.Items.Clear();
        IEnumerable<LOV_AREAGROUP> groups = QueryLayer.ListOfValues.AreaGroups();
        IEnumerable<REPORTINGCOUNTRY> countries = QueryLayer.ListOfValues.ReportingCountries();

        //Value of areas are negative to separate them from countries
        foreach (LOV_AREAGROUP g in groups)
            this.cbFacilityCountry.Items.Add(new ListItem(LOVResources.AreaGroupName(g.Code), (-g.LOV_AreaGroupID).ToString()));
        foreach (REPORTINGCOUNTRY c in countries)
            this.cbFacilityCountry.Items.Add(new ListItem(LOVResources.CountryName(c.Code), c.LOV_CountryID.ToString()));

        setSelectedAreaCountry();

        populateRegion();
    }

    private void setSelectedAreaCountry()
    {
        //default is first item. Set it first in case it cannot be set from filter
        this.cbFacilityCountry.SelectedIndex = 0;

        if (Filter != null)
        {
            if (Filter.SearchLevel() == AreaFilter.Level.AreaGroup)
            {
                if (Filter.AreaGroupID.HasValue)
                {
                    ListItem item = this.cbFacilityCountry.Items.FindByValue((-Filter.AreaGroupID).ToString());
                    if (item != null)
                    {
                        this.cbFacilityCountry.SelectedValue = item.Value;
                    }
                }
            }
            else if(Filter.CountryID != null)
            {
                ListItem item = this.cbFacilityCountry.Items.FindByValue(Filter.CountryID.ToString());

                if (item != null)
                {
                    this.cbFacilityCountry.SelectedValue = item.Value;
                }
            }
        }
    }

    private void populateRegion()
    {
        this.cbRegion.Items.Clear();
        int countryID = SelectedCountryId();
        if (SelectedRegionType() == AreaFilter.RegionType.RiverBasinDistrict)
        {
            populateRiverBasinDistricts(countryID);
        }
        else
        {
            populateNUTSRegions(countryID);
        }
        
        this.cbRegion.Enabled = (this.cbRegion.Items.Count > 1);
    }


    private void populateRiverBasinDistricts(int countryID)
    {
        this.cbRegion.Items.Add(new ListItem(Resources.GetGlobal("Common","AllRBDs"), AreaFilter.AllRegionsInCountryID.ToString()));

        if (countryID > 0)
        {
            IEnumerable<LOV_RIVERBASINDISTRICT> rbds = ListOfValues.RiverBasinDistricts(countryID);

            List<ListItem> items = new List<ListItem>();
            foreach (LOV_RIVERBASINDISTRICT rbd in rbds)
                items.Add(new ListItem(LOVResources.RiverBasinDistrictName(rbd.Code), rbd.LOV_RiverBasinDistrictID.ToString()));
            items.Sort(new ListItemComparer());

            this.cbRegion.Items.AddRange(items.ToArray());
        }

        setSelectedRegion();

    }


    private void populateNUTSRegions(int countryId)
    {
        this.cbRegion.Items.Add(new ListItem(Resources.GetGlobal("Common","AllNUTRegions"), AreaFilter.AllRegionsInCountryID.ToString()));

        if (countryId > 0)
        {
            IEnumerable<LOV_NUTSREGION> regions = ListOfValues.NUTSRegions(countryId, 2); //only level 2 is shown
            regions.OrderBy(p => p.Code);

            List<ListItem> items = new List<ListItem>();
            foreach (LOV_NUTSREGION r in regions)
                items.Add(new ListItem(LOVResources.NutsRegionName(r.Code), r.LOV_NUTSRegionID.ToString()));
            items.Sort(new ListItemComparer());

            this.cbRegion.Items.AddRange(items.ToArray());

        }

        setSelectedRegion();
    }

    private void setSelectedRegion()
    {
        //default is first item.
        this.cbRegion.SelectedIndex = 0;

        if (Filter != null && Filter.SearchLevel() == AreaFilter.Level.Region && Filter.RegionID.HasValue)
        {
            ListItem item = this.cbRegion.Items.FindByValue(Filter.RegionID.ToString());

            if (item != null)
            {
                this.cbRegion.SelectedValue = item.Value;
            }
        }
    }

    protected void onFacilityCountryChanged(object sender, EventArgs e)
    {
        populateRegion();
    }


    protected void onRegionTypeChanged(object sender, EventArgs e)
    {
        populateRegion();
    }

    private int SelectedCountryId()
    {
        int areaId = Convert.ToInt32(this.cbFacilityCountry.SelectedValue);
        if (areaId > 0)
        {
            return areaId;
        }
        else
        {
            return AreaFilter.AllCountriesInAreaGroupID;
        }

    }

    private int? SelectedAreaGroupID()
    {
        int areaId = Convert.ToInt32(this.cbFacilityCountry.SelectedValue);

        if (areaId < 0)
        {
            return -areaId;
        }
        else
        {
            return null;
        }
    }
    
    private int SelectedRegionID()
    {
        return Convert.ToInt32(this.cbRegion.SelectedValue);
    }

    private AreaFilter.RegionType SelectedRegionType()
    {
        return (AreaFilter.RegionType)Convert.ToInt32(this.rblRegionType.SelectedValue);
    }
    

    public AreaFilter PopulateFilter()
    {
        AreaFilter filter = new AreaFilter();
        filter.AreaGroupID = SelectedAreaGroupID();
        filter.CountryID = SelectedCountryId();
        filter.RegionID = SelectedRegionID();
        filter.TypeRegion = SelectedRegionType();
        return filter;
    }

}
