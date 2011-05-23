using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer.Filters;
using EPRTR.Utilities;

public partial class ucFacilityLocationSearchOption : System.Web.UI.UserControl
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // Look for filter from link search
            FacilityLocationFilter filter = LinkSearchBuilder.GetFacilityLocationFilter(Request);
            
            // Only if we have nothing from the links search, look into the cookies
            if (filter != null)
            {
                this.txFacilityName.Text = filter.FacilityName;
                this.txFacilityTown.Text = filter.CityName;
            }
        }
    }

    /// <summary>
    /// PopulateFilter
    /// </summary>
    public FacilityLocationFilter PopulateFilter()
    {
        FacilityLocationFilter filter = new FacilityLocationFilter();
        filter.FacilityName = this.txFacilityName.Text;
        filter.CityName = this.txFacilityTown.Text;
        return filter;
    }
   
}
