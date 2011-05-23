using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using EPRTR.Localization;
using EPRTR.Utilities;
using QueryLayer;
using QueryLayer.Filters;
using System.Collections.ObjectModel;
using System.Collections;

public partial class ucPollutantSearchOptionsEPER : System.Web.UI.UserControl
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

   

    private int getPollutantGroupID()
    {
        int pollutantGroupID = Convert.ToInt32(this.cbPollutantGroup.SelectedValue);
        return pollutantGroupID;
    }
    
    private void populatePollutantGroups()
    {
        this.cbPollutantGroup.Items.Clear();
        int startYearEPER = 2001;
      

        IEnumerable<LOV_POLLUTANT> groups = QueryLayer.ListOfValues.PollutantGroupsEPER().Where(x => x.StartYear == startYearEPER);
    
        List<string> lista1 = new List<string>();

        if (includeAll)
        {
           
            string text = Resources.GetGlobal("Common", "AllEmissionsGroups");
            string value = PollutantFilter.AllGroupsID.ToString();
            string n1 = text + "+" + value;
            lista1.Add(n1);
        }

        //Value of areas are prefixed to separate them from countries
        foreach (LOV_POLLUTANT g in groups)
        {
            string text = LOVResources.PollutantGroupName(g.CodeEper);
            string value = g.LOV_PollutantID.ToString();
            string n1 = text + "+" + value;
            lista1.Add(n1);
        }

    
        lista1.Sort();

        for (int i = 0; i < lista1.Count; i++)
        {

            string[] listvalue;
            string newList = lista1.ElementAt(i);
            listvalue = newList.Split('+');

            ListItem itemCbo = new ListItem();
            itemCbo.Text = listvalue[0];
            itemCbo.Value = listvalue[1];
            cbPollutantGroup.Items.Add(itemCbo);

        }


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

         int groupCHLORG = 5;
         int codCHLORGHEXA = 47;
         int groupOTHORG = 6;
         int codBENZENE = 89;

        int groupID = Convert.ToInt32(this.cbPollutantGroup.SelectedItem.Value);
        IEnumerable<LOV_POLLUTANT> pollutants = QueryLayer.ListOfValues.GetLeafPollutantsEPER(groupID);
   
        List<string> lista1=new List<string>();


        if (includeAll)
        {
            string text = Resources.GetGlobal("Common", "AllEmissions");
            string value = PollutantFilter.AllPollutantsInGroupID.ToString();
            string n1 = text + "+" + value;
            lista1.Add(n1);
        
        }

        foreach (LOV_POLLUTANT p in pollutants)
        {
           string text=LOVResources.PollutantNameEPER(p.Code, p.CodeEper);
           string value = p.LOV_PollutantID.ToString();
           string n1 = text + "+" + value;
            lista1.Add(n1);
                     
        }
    

        //add option HEXACHLOROCYCLOHEXANE(HCH) for group CHLORG
        if (groupID == groupCHLORG)
        {
            string text = Resources.GetGlobal("LOV_POLLUTANT", "HEXACHLOROCYCLOHEXANE(HCH)EPER");
            string value = codCHLORGHEXA.ToString();
            string n1 = text + "+" + value;
            lista1.Add(n1);
        }

        if (groupID == groupOTHORG)
        {
            string text = Resources.GetGlobal("LOV_POLLUTANT", "BENZENEEPER");
            string value = codBENZENE.ToString();
            string n1 = text + "+" + value;
           
            lista1.Add(n1);
        }

    
        lista1.Sort();
              
        for (int i = 0; i < lista1.Count; i++)
        {

            string[] listvalue;
            string newList = lista1.ElementAt(i);
            listvalue = newList.Split('+');
  
            ListItem itemCbo = new ListItem();
            itemCbo.Text =listvalue[0];
            itemCbo.Value = listvalue[1];
            cbPollutant.Items.Add(itemCbo);   
       
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
