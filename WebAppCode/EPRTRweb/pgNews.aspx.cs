using System;
using QueryLayer;
using System.Threading;

public partial class pgNews : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string cultureCode = Thread.CurrentThread.CurrentCulture.Name;

            newsPresenter.DataSource = News.GetTopNews(cultureCode);
            newsPresenter.DataBind();

            newsArchivePresenter.DataSource = News.GetNonTopNews(cultureCode);
            newsArchivePresenter.DataBind();

            // Dummy text not needed
            //this.PageContent.Text = CMSTextCache.CMSText("Static", "NewsPageContent");
        }
    }

}
