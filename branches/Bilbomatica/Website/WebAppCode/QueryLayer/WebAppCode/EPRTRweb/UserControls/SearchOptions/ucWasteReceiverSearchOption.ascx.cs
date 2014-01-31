using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using EPRTR.Localization;
using EPRTR.Utilities;
using QueryLayer;
using QueryLayer.Filters;
using EPRTR.Comparers;

public partial class ucWasteReceiverSearchOption : System.Web.UI.UserControl
{
    private WasteReceiverFilter Filter{ get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Filter = LinkSearchBuilder.GetWasteReceiverFilter(Request);
            populateCountry();

        }
    }


    private void populateCountry()
    {
        this.cbReceivingCountry.Items.Clear();

        IEnumerable<RECEIVINGCOUNTRY> countries = QueryLayer.ListOfValues.ReceivingCountries();

        this.cbReceivingCountry.Items.Add(new ListItem(Resources.GetGlobal("Common", "AllReceivingCountries"), WasteReceiverFilter.AllCountriesID.ToString()));

        List<ListItem> items = new List<ListItem>();
        foreach (RECEIVINGCOUNTRY c in countries)
            items.Add(new ListItem(LOVResources.CountryName(c.Code), c.LOV_CountryID.ToString()));
        items.Sort(new ListItemComparer());

        this.cbReceivingCountry.Items.AddRange(items.ToArray());

        setSelectedCountry();

    }

    private void setSelectedCountry()
    {
        //default is first item. Set it first in case it cannot be set from filter
        this.cbReceivingCountry.SelectedIndex = 0;

        if (Filter != null)
        {
            ListItem item = cbReceivingCountry.Items.FindByValue(Filter.CountryID.ToString());

            if (item != null)
            {
                this.cbReceivingCountry.SelectedValue = item.Value;
            }
        }
    }

    public WasteReceiverFilter PopulateFilter()
    {
        WasteReceiverFilter filter = new WasteReceiverFilter();
        filter.CountryID = Convert.ToInt32(this.cbReceivingCountry.SelectedValue);
        return filter;
    }

}
