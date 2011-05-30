using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using EPRTR.Localization;
using EPRTR.Utilities;
using QueryLayer;
using QueryLayer.Filters;
using System.Linq;

public partial class ucPollutantSearchOptions : System.Web.UI.UserControl
{
    private bool includeAll = false;

    /// <value>
    /// If true both pollutant group and pollutant will contain the search option "All". Default is false.
    /// </value>
    public bool IncludeAll
    {
        get { return includeAll; }
        set { includeAll = value; }
    }

    private PollutantFilter Filter{ get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Filter = LinkSearchBuilder.GetPollutantFilter(Request);

            populatePollutantGroups();

        }
    }

    
    private void populatePollutantGroups()
    {
        this.cbPollutantGroup.Items.Clear();
        int startYear = 2001;

        IEnumerable<LOV_POLLUTANT> groups = QueryLayer.ListOfValues.PollutantGroups().Where(x => x.StartYear >= startYear);

        if (includeAll)
        {
            this.cbPollutantGroup.Items.Add(new ListItem(Resources.GetGlobal("Common", "AllPollutantGroups"), PollutantFilter.AllGroupsID.ToString()));
        }

        //Value of areas are prefixed to separate them from countries
        foreach (LOV_POLLUTANT g in groups)
            this.cbPollutantGroup.Items.Add(new ListItem(LOVResources.PollutantGroupName(g.Code), g.LOV_PollutantID.ToString()));

        setSelectedPollutantGroup();
        
        populatePollutants();
    }

    private void setSelectedPollutantGroup()
    {
        //default is first item. Set it first in case it cannot be set from filter
        this.cbPollutantGroup.SelectedIndex = 0;

        if (Filter != null)
        {
            ListItem item = cbPollutantGroup.Items.FindByValue(Filter.PollutantGroupID.ToString());
            
            if (item != null)
            {
                this.cbPollutantGroup.SelectedValue = item.Value;
            }
        }
    }

    private void populatePollutants()
    {
        this.cbPollutant.Items.Clear();
        //int startYear = 2001;
        int endYear = 2004;

        int groupID = Convert.ToInt32(this.cbPollutantGroup.SelectedItem.Value);
        IEnumerable<LOV_POLLUTANT> pollutants = QueryLayer.ListOfValues.GetLeafPollutants(groupID).Where(x => x.EndYear != endYear);
            //.Where(x => x.StartYear >= startYear);

        if (includeAll)
        {
            this.cbPollutant.Items.Add(new ListItem(Resources.GetGlobal("Common", "AllPollutants"), PollutantFilter.AllPollutantsInGroupID.ToString()));
        }

        foreach (LOV_POLLUTANT p in pollutants)
            this.cbPollutant.Items.Add(new ListItem(LOVResources.PollutantName(p.Code), p.LOV_PollutantID.ToString()));

        //add option for confidential within group
        if (groupID != PollutantFilter.AllGroupsID)
        {
            this.cbPollutant.Items.Add(new ListItem(Resources.GetGlobal("Common", "ConfidentialInGroup"), groupID.ToString()));
        }

        setSelectedPollutant();

    }

    private void setSelectedPollutant()
    {
        //default is first item. Set it first in case it cannot be set from filter
        this.cbPollutant.SelectedIndex = 0;

        if (Filter != null)
        {
            ListItem item = cbPollutant.Items.FindByValue(Filter.PollutantID.ToString());

            if (item != null)
            {
                this.cbPollutant.SelectedValue = item.Value;
            }
        }
    }

    protected void onPollutantGroupChanged(object sender, EventArgs e)
    {
        populatePollutants();
    }

    protected void onPollutantChanged(object sender, EventArgs e)
    {
    }
    
    public PollutantFilter PopulateFilter()
    {
        PollutantFilter filter = new PollutantFilter();
        filter.PollutantGroupID = Convert.ToInt32(this.cbPollutantGroup.SelectedValue);
        filter.PollutantID = Convert.ToInt32(this.cbPollutant.SelectedValue);
        return filter;
    }


}
