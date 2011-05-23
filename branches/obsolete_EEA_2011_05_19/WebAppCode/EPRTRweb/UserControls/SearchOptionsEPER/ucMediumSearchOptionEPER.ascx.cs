using System;
using EPRTR.Utilities;
using QueryLayer.Filters;

public partial class ucMediumSearchOptionEPER : System.Web.UI.UserControl
{
    private bool includeTransfers = false;

    private MediumFilter Filter{ get; set; }
        
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           // this.plTransfers.Visible = includeTransfers;

            Filter = LinkSearchBuilder.GetMediumFilter(Request);
            setSelectedMediums();
        }
    }

    private void setSelectedMediums()
    {
        this.chkAir.Checked = Filter!=null ? Filter.ReleasesToAir : true;
        this.chkSoil.Checked = Filter != null ? Filter.TransferToWasteWater : true;
        this.chkWater.Checked = Filter!=null ? Filter.ReleasesToWater : true;
       
    }
 
       
    /// <summary>
    /// PopulateFilter
    /// </summary>
    public MediumFilter PopulateFilter()
    {
        MediumFilter filter = new MediumFilter();

        filter.ReleasesToAir = this.chkAir.Checked;
        filter.TransferToWasteWater = this.chkSoil.Checked;
        filter.ReleasesToWater = this.chkWater.Checked;
       
        return filter;
    }


}
