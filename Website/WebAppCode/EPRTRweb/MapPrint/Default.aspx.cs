using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class _Default : System.Web.UI.Page 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string method = Request.QueryString["method"];
            string name = Request.QueryString["name"];

            byte[] data = Request.BinaryRead(Request.TotalBytes);
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Length", data.Length.ToString());
            Response.AddHeader("Content-disposition", method + "; filename=" + name);
            Response.BinaryWrite(data);
            Response.End();
        }
        catch(Exception) { }
    }
}
