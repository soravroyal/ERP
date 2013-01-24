using System;
using System.Web.UI.WebControls;
using EPRTR.Utilities;
using QueryLayer.Filters;

public partial class ucYearSearchOption : System.Web.UI.UserControl
{
    private bool showEPER = false;

    /// <value>
    /// If true, EPER report years (2001+2004) will be shown in search option otherwise E-PRTR reprot years will be shown.
    /// Default is false.
    /// </value>
    public bool ShowEPER
    {
        get { return showEPER; }
        set { showEPER = value; }
    }

    private YearFilter Filter{ get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Look for filter from link search
            Filter = LinkSearchBuilder.GetYearFilter(Request);
            
            // Only if we have nothing from the links search, look into the cookies
            if (Filter == null) 
                Filter = CookieStorage.GetYearFilter(Request);

            // Populate
            populateYear();
        }
    }


    private void populateYear()
    {
        this.cbReportYear.Items.Clear();
        foreach (int year in QueryLayer.ListOfValues.ReportYears(showEPER))
            this.cbReportYear.Items.Add(new ListItem(year.ToString(), year.ToString()));

        setSelectedValue();
    }

    private void setSelectedValue()
    {
        //Set default first, in case value from filter cannot be set
        this.cbReportYear.SelectedIndex = this.cbReportYear.Items.Count - 1;

        //set value from filter if possible
        if (Filter != null)
        {
            string value = Filter.Year.ToString();
            ListItem item = this.cbReportYear.Items.FindByValue(value);

            if (item != null)
            {
                //item.Selected = true;
                this.cbReportYear.SelectedValue = item.Value;
            }
        }
    }

    public YearFilter PopulateFilter()
    {
        YearFilter yearfilter = new YearFilter();
        yearfilter.Year = Convert.ToInt32(this.cbReportYear.SelectedValue); 
        return yearfilter;
    }
    
}
