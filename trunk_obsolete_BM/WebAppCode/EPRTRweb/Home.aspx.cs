using System;
using System.Web.UI.WebControls;
using QueryLayer;
using System.Configuration;
using EPRTR.Formatters;

public partial class Home : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            this.litTextBody.Text = CMSTextCache.CMSText("Static", "HomeWelcomeText");
            int maxNumItems = Int32.Parse(ConfigurationManager.AppSettings["MaxNumberOfNewsItemsOnHomePage"]);
            string cultureCode = CultureResolver.Resolve(Request);
            repeaterNews.DataSource = News.GetNewsForHomePage(cultureCode, maxNumItems);
            repeaterNews.DataBind();
        }
        
        // add round corner to news icon on every page load
        //System.Web.UI.ScriptManager.RegisterStartupScript(Page, typeof(string), "news_cornering", "$('span#" + news_icon.ClientID + "').corner('5px');", true);

    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        // hide news feed if no top newas available
        repeaterNews.Visible = repeaterNews.Items.Count > 0;
        news_icon.Visible = repeaterNews.Items.Count > 0;
    }

    /// <summary>
    /// Handles the Click event of the lnkNewsItem control.
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.Web.UI.WebControls.CommandEventArgs"/> instance containing the event data.</param>
    protected void lnkNewsItem_Click(object sender, RepeaterCommandEventArgs e)
    {
        string[] newsElements = e.CommandArgument.ToString().Split('¤');

        if (newsElements.Length == 3)
        {
            // set news content and show literals 
            litHeader.Text = string.Format("{0}", newsElements[0]);

            // add parenthesis around the date
            litNewsDate.Text = String.Format("({0})", newsElements[1]);

            // add a line of space after the date
            litTextBody.Text = String.Format("<br />{0}", newsElements[2]);

            litNewsDate.Visible = true;
        }
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

    protected string GetCommandArgument(object obj)
    {
        News.NewsItem row = (News.NewsItem)obj;
        return String.Format("{0}¤{1}¤{2}",
            row.TitleText,
            String.Format("{0:D}", row.NewsDate),
            row.ContentText);
    }

    #endregion

}
