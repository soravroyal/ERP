using System;
using EPRTR.Utilities;
using QueryLayer.Filters;

public partial class ucMediumSearchOption : System.Web.UI.UserControl
{
    private bool includeTransfers = false;
    private bool includeAccidental = false;

    private MediumFilter Filter{ get; set; }
        
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.plTransfers.Visible = includeTransfers;
            this.plAccidental.Visible = includeAccidental;

            Filter = LinkSearchBuilder.GetMediumFilter(Request);
            setSelectedMediums();
        }
    }

    private void setSelectedMediums()
    {
        this.chkAir.Checked = Filter!=null ? Filter.ReleasesToAir : true;
        this.chkSoil.Checked = Filter!=null ? Filter.ReleasesToSoil : true;
        this.chkWater.Checked = Filter!=null ? Filter.ReleasesToWater : true;
        if (includeTransfers)
            this.chkWasteWater.Checked = Filter!=null ? Filter.TransferToWasteWater : true;
    }


    /// <value>
    /// If true transfers (i.e. waste water) will be included in the search options. 
    /// Default is false.
    /// </value>
    public bool IncludeTransfers
    {
        get { return includeTransfers; }
        set { includeTransfers = value; }
    }


    /// <value>
    /// If true accidental releases will be included in the search options. 
    /// Default is false.
    /// </value>
    public bool IncludeAccidental
    {
        get { return includeAccidental; }
        set { includeAccidental = value; }
    }
    
    /// <summary>
    /// PopulateFilter
    /// </summary>
    public MediumFilter PopulateFilter()
    {
        MediumFilter filter = new MediumFilter();

        filter.ReleasesToAir = this.chkAir.Checked;
        filter.ReleasesToSoil = this.chkSoil.Checked;
        filter.ReleasesToWater = this.chkWater.Checked;
        if (includeTransfers)
            filter.TransferToWasteWater = this.chkWasteWater.Checked;
        return filter;
    }


}
