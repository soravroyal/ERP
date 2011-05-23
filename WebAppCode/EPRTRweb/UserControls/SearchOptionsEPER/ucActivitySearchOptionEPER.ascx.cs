using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using EPRTR.Localization;
using EPRTR.Utilities;
using QueryLayer;
using QueryLayer.Filters;

public partial class ucActivitySearchOptionEPER : System.Web.UI.UserControl
{
    private ActivityFilter Filter { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Filter = LinkSearchBuilder.GetActivityFilter(Request);

            if (Filter == null)
            {
                populateSectors(SelectedActivityType());
            }
            else
            {
                populateSectors(Filter.ActivityType);
                populateActivityType(Filter.ActivityType);
            }

        }

        // Only show warning image if activity type is Annex I
        //imgAlert.Visible = (SelectedActivityType() == ActivityFilter.Type.AnnexI);
    }

    protected void rblActivityType_SelectedIndexChanged(object sender, EventArgs e)
    {
        populateSectors(SelectedActivityType());
    }

	/// <summary>
    /// Polulate Activity type selection (Annex I or NACE)
	/// This method assumes that the radio button list rblActivityType always 
	/// contains the options [0:Annex I] and [1:NACE] in that exact order.
	///
	/// Future activity types (e.g. IPPC) must be added here.
    /// </summary>
    private void populateActivityType(ActivityFilter.Type activityType)
    {
        rblActivityType.SelectedIndex = activityType == ActivityFilter.Type.AnnexI ? 0 : 1;
    }

    /// <summary>
    /// Polulate sectors
    /// handle activity selection
    /// </summary>
    private void populateSectors(ActivityFilter.Type activityType)
    {
        this.lbActivitySector.Items.Clear();

        // add all to list as first element
        this.lbActivitySector.Items.Add(new ListItem(Resources.GetGlobal("Common", "AllSectors"), ActivityFilter.AllSectorsID.ToString()));
        int startYearEPER = 2001;
        int endYearEPER = 2004;

        if (activityType == ActivityFilter.Type.AnnexI)
        {
            // get all sectors
            IEnumerable<LOV_ANNEXIACTIVITY> sectors = QueryLayer.ListOfValues.AnnexISectors().Where(x => x.StartYear == startYearEPER && x.EndYear == endYearEPER); 

            // add others, select first element as default
            foreach (LOV_ANNEXIACTIVITY s in sectors)
            {
                this.lbActivitySector.Items.Add(createListItem(s));
            }
        }

        else if (activityType == ActivityFilter.Type.NACE)
        {
            // get all sectors
            IEnumerable<LOV_NACEACTIVITY> sectors = QueryLayer.ListOfValues.NaceSectors().Where(y => y.StartYear == startYearEPER && y.EndYear == endYearEPER); 

            // add others, select first element as default
            foreach (LOV_NACEACTIVITY s in sectors)
            {
                this.lbActivitySector.Items.Add(createListItem(s));
            }
        }

        setSelectedSectors();

        // next list
        populateActivites(activityType);
    }

    private void setSelectedSectors()
    {
        this.lbActivitySector.SelectedIndex = 0;

        //set selected elements - default is first element 
        if (Filter != null && Filter.SectorIds != null && Filter.SectorIds.Count() > 0)
        {
            applyList(Filter.SectorIds, this.lbActivitySector);
        }

    }

    /// <summary>
    /// select items in list
    /// </summary>
    private bool applyList(List<int> selectedValues, ListBox destination)
    {
        if (selectedValues == null) return false;
        for (int i = 0; i < destination.Items.Count; i++)
        {
            destination.Items[i].Selected = false;
            for (int j = 0; j < selectedValues.Count; j++)
            {
                if (destination.Items[i].Value == selectedValues[j].ToString())
                    destination.Items[i].Selected = true;
            }
        }
        return true;
    }


    /// <summary>
    /// populateActivites
    /// handle activity type selection.
    /// </summary>
    private void populateActivites(ActivityFilter.Type activityType)
    {
        this.lbActivities.Items.Clear();
        this.lbActivities.Items.Add(new ListItem(Resources.GetGlobal("Common", "AllActivities"), ActivityFilter.AllActivitiesInSectorID.ToString()));

        int[] indexes = this.lbActivitySector.GetSelectedIndices();

        int startYearEPER = 2001;
        int endYearEPER = 2004;

        if (indexes.Count() == 1)
        {
            int sectorId = Convert.ToInt32(this.lbActivitySector.SelectedItem.Value);

            // ANNEX I
            if (activityType == ActivityFilter.Type.AnnexI)
            {
                IEnumerable<LOV_ANNEXIACTIVITY> activites = QueryLayer.ListOfValues.AnnexIActivites(sectorId).Where(x => x.StartYear == startYearEPER && x.EndYear == endYearEPER); 

                foreach (LOV_ANNEXIACTIVITY a in activites)
                    this.lbActivities.Items.Add(createListItem(a));
            }
            // NACE
            else if (activityType == ActivityFilter.Type.NACE)
            {

                IEnumerable<LOV_NACEACTIVITY> activites = QueryLayer.ListOfValues.NaceActivites(sectorId).Where(y => y.StartYear == startYearEPER && y.EndYear == endYearEPER); 

                foreach (LOV_NACEACTIVITY a in activites)
                    this.lbActivities.Items.Add(createListItem(a));
            }
        }

        setSelectedActivities();

       
        
    }


    private void setSelectedActivities()
    {
        this.lbActivities.SelectedIndex = 0;

        //set selected elements - default is first element 
        if (Filter != null && Filter.ActivityIds != null && Filter.ActivityIds.Count() > 0)
        {
            applyList(Filter.ActivityIds, this.lbActivities);
        }

    }

 

    private ListItem createListItem(LOV_ANNEXIACTIVITY s)
    {
        return new ListItem(LOVResources.AnnexIActivityName(s.Code), s.LOV_AnnexIActivityID.ToString());
    }

    private ListItem createListItem(LOV_NACEACTIVITY s)
    {
        return new ListItem(LOVResources.NaceActivityName(s.Code), s.LOV_NACEActivityID.ToString());
    }

    protected void onActivitySectorChanged(object sender, EventArgs e)
    {
        populateActivites(SelectedActivityType());
    }
   
    protected void onSubActivitiesChanged(object sender, EventArgs e)
    {
    }

    private ActivityFilter.Type SelectedActivityType()
    {
        return (ActivityFilter.Type)Convert.ToInt32(this.rblActivityType.SelectedValue);
    }

    private List<int> SelectedValues(ListBox lb)
    {
        List<int> values = new List<int>();
        foreach (int i in lb.GetSelectedIndices())
            values.Add(Convert.ToInt32(lb.Items[i].Value));
        return values;
    }

    /// <summary>
    /// Populate Filter
    /// </summary>
    public ActivityFilter PopulateFilter()
    {
        ActivityFilter filter = new ActivityFilter();
        filter.ActivityType = SelectedActivityType();
        filter.SectorIds = SelectedValues(this.lbActivitySector);
        filter.ActivityIds = SelectedValues(this.lbActivities);
        return filter;
    }


}
