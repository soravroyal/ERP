using System;
using EPRTR.Utilities;
using QueryLayer.Filters;

public partial class ucWasteTypeSearchOption : System.Web.UI.UserControl
{
    public WasteTypeFilter Filter{ get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Filter = LinkSearchBuilder.GetWasteTypeFilter(Request);
            setSelectedValues();
        }
    }

    private void setSelectedValues()
    {
        this.chkWasteHazardousCountry.Checked = Filter != null ? Filter.HazardousWasteCountry : true;
        this.chkWasteHazardousTransboundary.Checked = Filter != null ? Filter.HazardousWasteTransboundary : true;
        this.chkWasteNonHazardous.Checked = Filter != null ? Filter.NonHazardousWaste : true;
    }


    public WasteTypeFilter PopulateFilter()
    {
        WasteTypeFilter filter = new WasteTypeFilter();
        filter.HazardousWasteCountry = this.chkWasteHazardousCountry.Checked;
        filter.HazardousWasteTransboundary = this.chkWasteHazardousTransboundary.Checked;
        filter.NonHazardousWaste = this.chkWasteNonHazardous.Checked;
        return filter;
    }


}
