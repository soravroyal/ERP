using System;
using EPRTR.Utilities;
using QueryLayer.Filters;

public partial class ucMediumSearchOptionEPER : System.Web.UI.UserControl
{

    private MediumFilter Filter{ get; set; }
        
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            Filter = LinkSearchBuilder.GetMediumFilter(Request);
            setSelectedMediums();

            chkAir.Attributes.Add("onclick", "PRTValidation()");
            chkSoil.Attributes.Add("onclick", "PRTValidation()");
            chkWater.Attributes.Add("onclick", "PRTValidation()");

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
