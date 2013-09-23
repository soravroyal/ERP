using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using EPRTR.Formatters;
using EPRTR.Localization;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;


public delegate void MediumSelectedEventHandler(object sender, MediumSelectedEventArgs e);

public class MediumSelectedEventArgs : EventArgs
{
    public MediumSelectedEventArgs(string medium)
    {
        this.Medium = (MediumFilter.Medium)EnumUtil.Parse(typeof(MediumFilter.Medium), medium);
    }

    public MediumFilter.Medium Medium { get; private set; }
}	


public partial class ucMediumSelector : System.Web.UI.UserControl
{
    public event MediumSelectedEventHandler ItemSelected;
    public void  OnMediumSelected(MediumSelectedEventArgs e)
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
    /// PopulateMediumRadioButtonList
    /// </summary>
    public void PopulateMediumRadioButtonList(MediumFilter filter, PollutantReleases.FacilityCountObject counts)
    {
        List<string> items = addButtons(filter, counts);
        if (this.rblMediumSelector.Items.Count > 0)
        {
            rblMediumSelector.SelectedIndex = 0;
            OnMediumSelected(new MediumSelectedEventArgs(rblMediumSelector.SelectedValue));
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public void PopulateMediumRadioButtonList(
        MediumFilter filter, 
        MediumFilter.Medium selected, 
        PollutantReleases.FacilityCountObject counts)
    {
        List<string> items = addButtons(filter, counts);

        if (selected == MediumFilter.Medium.Air && filter.ReleasesToAir && items.Contains(getRadioButtonValue(MediumFilter.Medium.Air)))
        {
            rblMediumSelector.SelectedValue = getRadioButtonValue(MediumFilter.Medium.Air);
            OnMediumSelected(new MediumSelectedEventArgs(rblMediumSelector.SelectedValue));
        }
        else if (selected == MediumFilter.Medium.Water && filter.ReleasesToWater && items.Contains(getRadioButtonValue(MediumFilter.Medium.Water)))
        {
            rblMediumSelector.SelectedValue = getRadioButtonValue(MediumFilter.Medium.Water);
            OnMediumSelected(new MediumSelectedEventArgs(rblMediumSelector.SelectedValue));
        }
        else if (selected == MediumFilter.Medium.Soil && filter.ReleasesToSoil && items.Contains(getRadioButtonValue(MediumFilter.Medium.Soil)))
        {
            rblMediumSelector.SelectedValue = getRadioButtonValue(MediumFilter.Medium.Soil);
            OnMediumSelected(new MediumSelectedEventArgs(rblMediumSelector.SelectedValue));
        }
        else
        {
            // medium not supported by this control, select default
            if (this.rblMediumSelector.Items.Count > 0)
            {
                rblMediumSelector.SelectedIndex = 0;
                OnMediumSelected(new MediumSelectedEventArgs(rblMediumSelector.SelectedValue));
            }
        }    
    }

    /// <summary>
    /// 
    /// </summary>
    private List<string> addButtons(MediumFilter filter, PollutantReleases.FacilityCountObject counts)
    {
        int count;
        string radioButtonValue = String.Empty;
        string facilities = Resources.GetGlobal("Common", "Facilities");
        
        List<string> items = new List<string>();

        rblMediumSelector.Items.Clear();
        if (filter.ReleasesToAir)
        {
            count = counts.Air != null ? (int)counts.Air : 0;

            radioButtonValue = getRadioButtonValue(MediumFilter.Medium.Air);
            string mediumText = Resources.GetGlobal("Common", "Air");
            string displayText = string.Format("{0}{1}({2} {3})", mediumText, " ", NumberFormat.Format(count), facilities);
            var li = new ListItem(displayText, radioButtonValue);
            rblMediumSelector.Items.Add(li);

            items.Add(radioButtonValue);
        }
        if (filter.ReleasesToWater)
        {
            count = counts.Water != null ? (int)counts.Water : 0;

            radioButtonValue = getRadioButtonValue(MediumFilter.Medium.Water);
            string mediumText = Resources.GetGlobal("Common", "Water");
            string displayText = string.Format("{0}{1}({2} {3})", mediumText, " ", NumberFormat.Format(count), facilities);
            var li = new ListItem(displayText, radioButtonValue);
            rblMediumSelector.Items.Add(li);
            
            items.Add(radioButtonValue);
        }
        if (filter.ReleasesToSoil)
        {
            count = counts.Soil != null ? (int)counts.Soil : 0;

            radioButtonValue = getRadioButtonValue(MediumFilter.Medium.Soil);
            string mediumText = Resources.GetGlobal("Common", "Soil");
            string displayText = string.Format("{0}{1}({2} {3})", mediumText, " ", NumberFormat.Format(count), facilities);
            var li = new ListItem(displayText, radioButtonValue);
            rblMediumSelector.Items.Add(li);

            items.Add(radioButtonValue);
        }

        //only show radiobuttons if more than one is present
        ToggleTextVisibility(this.rblMediumSelector.Items.Count > 1);
        return items;
    }


    private string getRadioButtonValue(MediumFilter.Medium medium)
    {
        return EnumUtil.GetStringValue(medium);
    }

    /// <summary>
    /// 
    /// </summary>
    private void ToggleTextVisibility(bool visible)
    {
        rblMediumSelector.Visible = visible;
        litReleasingToMedium.Visible = visible;
    }

    /// <summary>
    /// radio buttons selected
    /// </summary>
    protected void onSelectedIndexChanged(object sender, EventArgs e)
    {
        MediumSelectedEventArgs args = new MediumSelectedEventArgs(this.rblMediumSelector.SelectedValue);
        OnMediumSelected(args);
    }

    public MediumFilter.Medium SelectedMedium
    {
        get { return (MediumFilter.Medium)EnumUtil.Parse(typeof(MediumFilter.Medium), this.rblMediumSelector.SelectedValue); }
    }
}
