using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using QueryLayer;
using System.Linq;
using QueryLayer.Filters;


/// <summary>
/// Delegate prop
/// </summary>
public delegate void YearSelectedEventHandlerEPER(object sender, YearSelectedEventArgsEPER e);

public class YearSelectedEventArgsEPER : EventArgs
{
    public YearSelectedEventArgsEPER() { }
}	

/// <summary>
/// Compare years component
/// </summary>
public partial class ucYearCompareEPER : System.Web.UI.UserControl
{
    private bool showEPER = true;

    public bool ShowEPER
    {
        get { return showEPER; }
        set { showEPER = value; }
    }

    private YearFilter Filter { get; set; }


    public event YearSelectedEventHandlerEPER ItemSelected;

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// init list
    /// </summary>
    public void Initialize(IEnumerable<Facility.FacilityReportingYear> years, int currentYear)
    {
        List<int> ys = years.Select(y => y.ReportingYear).ToList();
        Initialize(ys, currentYear);
    }

    /// <summary>
    /// init list
    /// </summary>
    public void Initialize(bool includeEper, int? searchYear)
    {
        // get reporting years
        List<int> years = ListOfValues.ReportYears(ShowEPER).ToList();

        this.Visible = years.Count > 0;

        if (years.Count > 0)
        {
            int year = searchYear.HasValue ? searchYear.Value : years[years.Count - 1];
            Initialize(years, year);
        }
    }

    /// <summary>
    /// init list
    /// </summary>
    public void Initialize(List<int> years, int currentYear)
    {
        if (this.cbYear1.Items.Count == 0 || this.cbYear2.Items.Count == 0)
        {
            this.cbYear1.Items.Clear();
            foreach (int i in years)
            {
                if (i == 2001 || i == 2004)
                {
                    this.cbYear1.Items.Add(new ListItem(i.ToString()));
                }
            }
            this.cbYear2.Items.Clear();
            foreach (int i in years)
            {
                if (i == 2001 || i == 2004)
                {
                    this.cbYear2.Items.Add(new ListItem(i.ToString()));
                }
            }
        }
        SetYears(currentYear);
    }

    /// <summary>
    /// year 1 changed 
    /// </summary>
    protected void onYear1Changed(object sender, EventArgs e)
    {
        if (ItemSelected != null)
            ItemSelected(null, null);
    }

    /// <summary>
    /// year 2 changed 
    /// </summary>
    protected void onYear2Changed(object sender, EventArgs e)
    {
        if (ItemSelected != null)
            ItemSelected(null, null);
    }

    /// <summary>
    /// prop year 1
    /// </summary>
    public int Year1
    {
        get { return Convert.ToInt32(this.cbYear1.SelectedValue); }
    }

    /// <summary>
    /// prop year 1
    /// </summary>
    public int Year2
    {
        get { return Convert.ToInt32(this.cbYear2.SelectedValue); }
    }

    /// <summary>
    /// set years
    /// </summary>
    private void SetYears(int firstYear)
    {
        this.cbYear1.SelectedIndex = -1;
        this.cbYear2.SelectedIndex = -1;

        //set year of first dropdown
        ListItem item1 = this.cbYear1.Items.FindByValue(firstYear.ToString());

        if (item1 != null)
        {
            item1.Selected = true;
        }
        else
        {
            this.cbYear1.SelectedIndex = this.cbYear1.Items.Count - 1;
        }

        //set year of second dropdown to the year before the first one - except if the firtst year isselected in the first drop down.       
        if (this.cbYear1.SelectedIndex == 0)
        {
            this.cbYear2.SelectedIndex = this.cbYear2.Items.Count > 1 ? 1 : 0;
        }
        else
        {
            this.cbYear2.SelectedIndex = this.cbYear1.SelectedIndex-1;
        }
    }


}
