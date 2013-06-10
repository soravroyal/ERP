using System;
using EPRTR.Utilities;
using QueryLayer.Filters;

public partial class ucWasteTreatmentSearchOption : System.Web.UI.UserControl
{
    private WasteTreatmentFilter Filter{ get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Filter = LinkSearchBuilder.GetWasteTreatmentFilter(Request);

            setSelectedValues();

        }
    }

    private void setSelectedValues()
    {
        this.chkTreatmentRecovery.Checked = Filter != null ? Filter.Recovery : true;
        this.chkTreatmentDisposal.Checked = Filter != null ? Filter.Disposal : true;
        this.chkTreatmentUnspecified.Checked = Filter != null ? Filter.Unspecified : true;
    }


    public WasteTreatmentFilter PopulateFilter()
    {
        WasteTreatmentFilter filter = new WasteTreatmentFilter();
        filter.Recovery = this.chkTreatmentRecovery.Checked;
        filter.Disposal = this.chkTreatmentDisposal.Checked;
        filter.Unspecified = this.chkTreatmentUnspecified.Checked;
        return filter;
    }



}
