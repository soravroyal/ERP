using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Localization;
using EPRTR.Enums;
using EPRTR.DiffuseSources;

public partial class UserControls_DiffuseSources_ucDiffuseSourcesSheet : System.Web.UI.UserControl
{
    #region ViewState properties
    
    protected string LayerId
    {
        get { return (string)ViewState["LayerId"]; }
        set { ViewState["LayerId"] = value; }
    }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.ucSheetLinks.ResetContentLinks();
            this.ucSheetLinks.SetLink(Resources.GetGlobal("DiffuseSources", "GeneralInfo"), Sheets.DiffuseSources.GeneralInfo.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("DiffuseSources", "Methodology"), Sheets.DiffuseSources.Methodology.ToString());
            this.ucSheetLinks.SetLink(Resources.GetGlobal("DiffuseSources", "SourceData"), Sheets.DiffuseSources.SourceData.ToString());
        }

        if (this.ucSheetLinks.Linkclick == null)
            this.ucSheetLinks.Linkclick = new EventHandler(linkClick);

        
    }

    public void Populate(string layerId)
    {
        LayerId = layerId;
        showContent(Sheets.DiffuseSources.GeneralInfo.ToString());
    }

    /// <summary>
    /// Content link clicked
    /// </summary>
    protected void linkClick(object sender, EventArgs e)
    {
        LinkButton button = sender as LinkButton;
        if (button != null)
        {
            string link = button.CommandArgument;
            showContent(link);
        }
    }

    private void showContent(string command)
    {
        this.ucSheetLinks.HighLight(command);

        //allow print of all sheets
        this.ucDownloadPrint.Show(false, true);
        this.ucDownloadPrint.SetPrintControl(this);

        //get id from viewstate
        DiffuseSources.Map map = DiffuseSources.GetMap(LayerId);
        string headline = String.Empty;
        string content = String.Empty;

        if (command.Equals(Sheets.DiffuseSources.GeneralInfo.ToString()))
        {
            headline = Resources.GetGlobal("DiffuseSources", "GeneralInfo");
            content = map.GetGeneralInformation();
        }
        else if (command.Equals(Sheets.DiffuseSources.Methodology.ToString()))
        {
            headline = Resources.GetGlobal("DiffuseSources", "Methodology");
            content = map.GetMethodology();
        }
        else if (command.Equals(Sheets.DiffuseSources.SourceData.ToString()))
        {
            headline = Resources.GetGlobal("DiffuseSources", "SourceData");
            content = map.GetSourceData();
        }

        this.litHeadline.Text = String.Format("{0} / {1}", Resources.GetGlobal("DiffuseSources", "DiffuseSources"), headline);
        this.lbDiffuseContent.Text = content;
        updateSubHeader(map);
    }


    private void updateSubHeader(DiffuseSources.Map map)
    {
        // populate header
        Dictionary<string, string> header = new Dictionary<string, string>();
        header.Add(Resources.GetGlobal("DiffuseSources", "Map"), map.GetTitleFull());
        this.ucSheetSubHeader.PopulateHeader(header);
    }




}
