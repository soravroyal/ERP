using System;
using EPRTR.Utilities;
using QueryLayer.Filters;

public partial class ucAccidentalSearchOption : System.Web.UI.UserControl
{
    private AccidentalFilter Filter{ get; set; }
        
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Filter = LinkSearchBuilder.GetAccidentalFilter(Request);
            setAccidental();
        }
    }

    private void setAccidental()
    {
        this.chkAccidental.Checked = Filter!=null ? Filter.AccidentalOnly: false;
    }

    
    /// <summary>
    /// PopulateFilter
    /// </summary>
    public AccidentalFilter PopulateFilter()
    {
        AccidentalFilter filter = new AccidentalFilter();

        filter.AccidentalOnly = this.chkAccidental.Checked;
        return filter;
    }


}
