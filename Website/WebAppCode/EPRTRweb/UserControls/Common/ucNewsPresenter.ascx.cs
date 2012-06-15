using System;
using System.Collections.Generic;
using QueryLayer;
using EPRTR.Formatters;
using System.Web;
using System.Web.UI;

public partial class ucNewsPresenter : System.Web.UI.UserControl
{
    public IEnumerable<News.NewsItem> DataSource
    {
        private get;
        set;
    }
    
   /* public void FocusControlOnPageLoad(string ClientID)
    {
        //var el = document.getElementById('" + ClientID + @"') if (el != null){ el.scrollIntoView();el.focus();
        //string script = " var el = document.getElementById(" + ClientID + ") alert('d') if (el != null){ alert('ff') el.scrollIntoView() el.focus()}; ";
        ScriptManager.RegisterStartupScript(this.Page, typeof(string), "newsscript", script, true);
        
    }*/


    public static Control FindControlR(Control root, string id)
    {
        List<Control> controls = new List<Control>(); 
        if (root.ID == id)
            return root;

        foreach (Control Ctl in root.Controls)
        {
            Control FoundCtl = FindControlR(Ctl, id);

            if (FoundCtl != null)
                return FoundCtl;
        }

        return null;
    }
   
    protected void Page_Load(object sender, EventArgs e)
    {
        repNews.DataSource = this.DataSource;
        repNews.DataBind();
        if (!Page.IsPostBack)
        {   
            // Activate news if active
            if(!string.IsNullOrEmpty(Request.QueryString["newsID"]))
            { 
                int newsID = -1;
                int.TryParse(Request.QueryString["newsID"].ToString(),out newsID);
                bool found = false;
                int index = -1;
                IEnumerable<News.NewsItem> list = this.DataSource;
                foreach (QueryLayer.News.NewsItem item in list)
                {
                    index++;
                    if (item.NewsId == newsID)
                    {
                        found = true;
                        break;
                    }
                }
                
                if(found)
                {
                    Control con = FindControlR(repNews.Items[index], "cpeNews");
                    if (con != null)
                    {
                        AjaxControlToolkit.CollapsiblePanelExtender extender = (AjaxControlToolkit.CollapsiblePanelExtender)con;
                        if (extender != null)
                        {
                            extender.Focus();
          
                            extender.Collapsed = false;
                            //FocusControlOnPageLoad(extender.ClientID);
                        }
                    }
                }
            }
        }
    }

    protected void Page_Prerender(object sender, EventArgs e)
    {
        // News repeater if empty
        repNews.Visible = repNews.Items.Count > 0;
        
        lbNoNews.Visible = repNews.Items.Count <= 0;
    }

    #region Databinding methods

    protected string GetTimeStamp(object obj)
    {
        News.NewsItem row = (News.NewsItem)obj;
  
        return row.NewsDate.Format();
    }

    protected string GetHeaderText(object obj)
    {
        News.NewsItem row = (News.NewsItem)obj;
        return row.TitleText;
    }

    protected string GetBodyText(object obj)
    {
        News.NewsItem row = (News.NewsItem)obj;
        return row.ContentText;
    }

    #endregion
}
