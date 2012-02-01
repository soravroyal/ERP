using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

public partial class ErrorPage : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        this.Title = "Error";

        bool showErrors = ConfigurationManager.AppSettings["ShowErrors"].ToString().ToLower().Equals("true");
        if (showErrors)
        {
            HttpContext ctx = HttpContext.Current;
            Exception exception = ctx.Server.GetLastError();
            if (exception != null)
            {
                this.litErrorMessage.Text = "Message: " + exception.Message;
                this.litStackTrace.Text = "Stack trace: " + exception.StackTrace;
            }
        }
        
    }
}
