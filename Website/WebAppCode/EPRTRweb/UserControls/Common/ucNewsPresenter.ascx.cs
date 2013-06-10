using System;
using System.Collections.Generic;
using QueryLayer;
using EPRTR.Formatters;

public partial class ucNewsPresenter : System.Web.UI.UserControl
{
    public IEnumerable<News.NewsItem> DataSource
    {
        private get;
        set;
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        repNews.DataSource = this.DataSource;
        repNews.DataBind();
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
