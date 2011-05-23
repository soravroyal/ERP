using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ucYearSlider : System.Web.UI.UserControl
{
    public EventHandler OnRefreshClick;

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// Init with years
    /// </summary>
    public void Initialize(int yearFrom, int yearTo)
    {
        this.SliderExtender1.Minimum = (double)yearFrom;
        this.SliderExtender1.Maximum = (double)yearTo;
        this.SliderExtender2.Minimum = (double)yearFrom;
        this.SliderExtender2.Maximum = (double)yearTo;
    }
    
    public int Year1 
    { 
        get { return Convert.ToInt32(this.Slider1.Text); }  
    }
    public int Year2
    {
        get { return Convert.ToInt32(this.Slider2.Text); }
    }
    
    /// <summary>
    /// Refresh
    /// </summary>
    protected void refresh(object sender, EventArgs e)
    {
        if (Year2 < Year1)
            this.Slider2.Text = this.Slider1.Text;

        if (OnRefreshClick != null)
            OnRefreshClick.Invoke(sender, EventArgs.Empty);
    }

   

}
