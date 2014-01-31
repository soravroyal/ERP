using System;
using System.Web.UI.WebControls;
using System.Configuration;
using EPRTR.Localization;
using System.Web.UI.HtmlControls;
using System.Linq;


public partial class MasterPage : System.Web.UI.MasterPage
{
    private const string PREFIX = "menutree_";

    protected void Page_Init(object sender, EventArgs e)
    {
        HtmlGenericControl jsVar = new HtmlGenericControl("script");
        jsVar.Attributes.Add("type", "text/javascript");
        jsVar.InnerHtml = String.Format("var Lang = \"{0}\" ;", System.Globalization.CultureInfo.CurrentCulture.Name);
        this.Page.Header.Controls.Add(jsVar);

        imgReview.Attributes.Add("alt", "");
        imgSoil.Attributes.Add("alt", "");
        imgNature.Attributes.Add("alt", "");
        imgAir.Attributes.Add("alt", "");
        imgWater.Attributes.Add("alt", "");
   }

    /// <summary>
    /// Master 
    /// </summary>
    protected void Page_Load(object sender, EventArgs e)
    {
        resetNode("SearchEPRTRData");
        //resetNode("EPRTRReview"); //Commented out until first review report is available in 2011
        resetNode("SearchEPERData");
        resetNode("Download");
        resetNode("Links");
        resetNode("Library");
        resetNode("DiffuseSources");
        resetNode("TimeSeries");

        // Turn on review-web icon
        string appIsReview = ConfigurationManager.AppSettings["IsReview"];
        this.imgReview.Visible = (!String.IsNullOrEmpty(appIsReview) && appIsReview.ToLower().Equals("true"));

        // Menu Tree
        CreateMenuTree();

        // Expand search menu the first time the page loads
        ExpandSearchMenu();

       
        if (BrowserCheck.IsBrowserSupported(Request.Browser.Browser, Request.Browser.Version))
        {
            BrowserNotSupported.Visible = false;
        }
        else
        {
            BrowserNotSupported.Visible = true;
            
            System.Diagnostics.Debug.WriteLine(string.Format("browser:{0}  -- version:{1}",
            Request.Browser.Browser,
            Request.Browser.Version));
        }
    }

    
    private void ExpandSearchMenu()
    {
        if (Request.Cookies["IsFirstPageLoad"] == null)
        {
            bool expandSearchMenuInitially = bool.Parse(ConfigurationManager.AppSettings["ExpandSearchMenuInitially"]);

            if (expandSearchMenuInitially)
            {
                Response.Cookies["IsFirstPageLoad"].Value = "NotFirstTime";

                var node = MenuTree.Nodes.OfType<TreeNode>().Single(x => x.ToolTip.Equals("SearchMenu"));

                node.Expand();
                node.ToolTip = "";
            }
        }
    }

    private void CreateMenuTree()
    {
        this.MenuTree.DataBind();
        foreach (TreeNode node in this.MenuTree.Nodes)
        {
            if (Request.Cookies[PREFIX + node.Text] != null)
            {
                if (toBool(Request.Cookies[PREFIX + node.Text].Value))
                {
                    node.Expand();
                }
                else
                {
                    node.Collapse();
                }
            }
        }

        // Makes tree nodes expandable by clicking the text labels
        foreach (TreeNode node in this.MenuTree.Nodes)
        {
            if (node.NavigateUrl == "" || node.NavigateUrl == "javascript:void(0)")
            {
                node.SelectAction = TreeNodeSelectAction.Expand;
            }
        }
    }

    protected void OnTreeNodeCollapsed(object sender, TreeNodeEventArgs e)
    {
        e.Node.SelectAction = TreeNodeSelectAction.Expand;
        if (Request.Cookies[PREFIX + e.Node.Text] != null)
        {
            Response.Cookies[PREFIX + e.Node.Text].Value = "false";
        }
    }

    protected void onTreeNodeExpanded(object sender, TreeNodeEventArgs e)
    {
        e.Node.SelectAction = TreeNodeSelectAction.Expand;
        if (Request.Cookies[PREFIX + e.Node.Text] != null)
        {
            Response.Cookies[PREFIX + e.Node.Text].Value = "true";
        }

    }

    private bool toBool(string value)
    {
        if (String.IsNullOrEmpty(value)) return false;
        return (value.ToLower().Equals("true")) ? true : false;
    }

    private void resetNode(string name)
    {
        if (Request.Cookies[PREFIX + Resources.GetGlobal("Web.sitemap", name)] == null)
        {
            Response.Cookies[PREFIX + Resources.GetGlobal("Web.sitemap", name)].Value = "false";
        }
    }
}
