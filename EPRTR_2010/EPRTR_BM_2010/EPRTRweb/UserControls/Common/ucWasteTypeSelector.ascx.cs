using System;
using System.Web.UI.WebControls;
using EPRTR.Formatters;
using EPRTR.Localization;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;


public delegate void WasteTypeSelectedEventHandler(object sender, WasteTypeSelectedEventArgs e);

public class WasteTypeSelectedEventArgs : EventArgs
{
    public WasteTypeSelectedEventArgs(string wasteType)
    {
        this.WasteType = (WasteTypeFilter.Type)EnumUtil.Parse(typeof(WasteTypeFilter.Type), wasteType);
    }

    public WasteTypeFilter.Type WasteType { get; private set; }
}	

public partial class ucWasteTypeSelector : System.Web.UI.UserControl
{
    public event WasteTypeSelectedEventHandler ItemSelected;
    public void OnWasteTypeSelected(WasteTypeSelectedEventArgs e)
    {
        if (ItemSelected != null)
        {
            ItemSelected(this, e);
        }
    }


    protected void Page_Load(object sender, EventArgs e)
    {
    }

    
    /// <summary>
    /// populate radiubutton list, select index 0 as default
    /// </summary>
    public void PopulateRadioButtonList(WasteTypeFilter filter, WasteTransfers.FacilityCountObject counts)
    {
        addButtons(filter, counts);
        
        if (this.rblWasteTypeSelector.Items.Count > 0)
        {
            rblWasteTypeSelector.SelectedIndex = 0;
            OnWasteTypeSelected(new WasteTypeSelectedEventArgs(rblWasteTypeSelector.SelectedValue));
        }
    }

    
    /// <summary>
    /// populate radiubutton list, select type
    /// </summary>
    public void PopulateRadioButtonList(
        WasteTypeFilter filter, 
        WasteTypeFilter.Type selected, 
        WasteTransfers.FacilityCountObject counts)
    {
        addButtons(filter, counts);

        string value = getRadioButtonValue(selected);
        if (filter.InludesWasteType(selected) && this.rblWasteTypeSelector.Items.FindByValue(value)!=null)
        {
            rblWasteTypeSelector.SelectedValue = value;
            OnWasteTypeSelected(new WasteTypeSelectedEventArgs(value));
        }
        else
        {
            // waste type not supported by this control, select default
            if (this.rblWasteTypeSelector.Items.Count > 0)
            {
                rblWasteTypeSelector.SelectedIndex = 0;
                OnWasteTypeSelected(new WasteTypeSelectedEventArgs(rblWasteTypeSelector.SelectedValue));
            }
        }
    }





    /// <summary>
    /// 
    /// </summary>
    private void addButtons(WasteTypeFilter filter, WasteTransfers.FacilityCountObject counts)
    {
        int count;
        string radioButtonValue = String.Empty;
        string facilities = Resources.GetGlobal("Common", "Facilities");
        
        rblWasteTypeSelector.Items.Clear();


        if (filter.NonHazardousWaste)
        {
            count = counts.NONHW != null ? (int)counts.NONHW : 0;

            radioButtonValue = getRadioButtonValue(WasteTypeFilter.Type.NonHazardous);
            string NonHazWaste = Resources.GetGlobal("Common", "NoHazardouswaste");
            string displayText = string.Format("{0}{1}({2} {3})", NonHazWaste, Environment.NewLine, NumberFormat.Format(count), facilities);
            var li = new ListItem(displayText, radioButtonValue);
            rblWasteTypeSelector.Items.Add(li);
        }
        if (filter.HazardousWasteCountry)
        {
            count = counts.HWIC != null ? (int)counts.HWIC : 0;

            radioButtonValue = getRadioButtonValue(WasteTypeFilter.Type.HazardousCountry);
            string HazDomestic = Resources.GetGlobal("Common", "HazardouswasteWithinCountry");
            string displayText = string.Format("{0}{1}({2} {3})", HazDomestic, Environment.NewLine, NumberFormat.Format(count), facilities);
            var li = new ListItem(displayText, radioButtonValue);
            rblWasteTypeSelector.Items.Add(li);
        }
        if (filter.HazardousWasteTransboundary)
        {
            count = counts.HWOC != null ? (int)counts.HWOC : 0;

            radioButtonValue = getRadioButtonValue(WasteTypeFilter.Type.HazardousTransboundary);
            string HazWasteTransboundary = Resources.GetGlobal("Common", "HazardouswasteTransboundary");
            string displayText = string.Format("{0}{1}({2} {3})", HazWasteTransboundary, Environment.NewLine, NumberFormat.Format(count), facilities);
            var li = new ListItem(displayText, radioButtonValue);

            rblWasteTypeSelector.Items.Add(li);
        }

        //only show radiobuttons if more than one is present
        ToggleTextVisibility(this.rblWasteTypeSelector.Items.Count > 1);
    }


    private string getRadioButtonValue(WasteTypeFilter.Type wasteType)
    {
        return EnumUtil.GetStringValue(wasteType);
    }

    /// <summary>
    /// 
    /// </summary>
    private void ToggleTextVisibility(bool visible)
    {
        rblWasteTypeSelector.Visible = visible;
        litTransferOfWasteType.Visible = visible;
    }


    /// <summary>
    /// radio buttons selected
    /// </summary>
    protected void onSelectedIndexChanged(object sender, EventArgs e)
    {
        WasteTypeSelectedEventArgs args = new WasteTypeSelectedEventArgs(this.rblWasteTypeSelector.SelectedValue);
        OnWasteTypeSelected(args);
    }

}
