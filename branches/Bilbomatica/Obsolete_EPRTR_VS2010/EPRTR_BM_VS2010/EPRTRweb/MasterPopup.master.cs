using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

public partial class MasterPopup : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (ConfigurationManager.AppSettings["IsReview"].Equals("true"))
        {
            imgReview.Visible = true;
        }
        else
        {
            imgReview.Visible = false;
        }
    }
}
