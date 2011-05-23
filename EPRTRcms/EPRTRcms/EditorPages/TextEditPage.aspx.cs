using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using QueryCms;
using AjaxControlToolkit;

namespace EPRTRcms
{
    public partial class TextEditPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CreateLeftMenu();

                SubmitButtonStyle.Visible = false;
                
                editor.Visible = false;
                displayTitleDescription.Visible = false;
                IntroductionDisplay.Visible = true;

            }
        }

        private void CreateLeftMenu()
        {
            DataClassesCmsDataContext db = new DataClassesCmsDataContext();

            List<ReviseResourceValue> LRRV = db.ReviseResourceValues.ToList();
            List<LOV_ContentsGroup> LLCG = db.LOV_ContentsGroups.ToList();
            List<ReviseResourceKey> LRRK = db.ReviseResourceKeys.OrderBy(x => x.KeyTitle).ToList();

            foreach (LOV_ContentsGroup LCG in LLCG)
            {
                TreeNode TN = new TreeNode(LCG.Name, "parentMenu");
                this.selectionTree.Nodes.Add(TN);
                TN.Expand();
                TN.SelectAction = TreeNodeSelectAction.Expand;

                foreach (ReviseResourceKey RRK in LRRK)
                {
                    if (RRK.ContentsGroupID.Equals(LCG.LOV_ContentsGroupID))
                    {
                        string title = RRK.KeyTitle.Equals("") ? RRK.ResourceKey : RRK.KeyTitle;

                        TreeNode TNsub = new TreeNode(title, db.ReviseResourceKeys.Where(p => p.ResourceKeyID.Equals(RRK.ResourceKeyID)).First().ResourceKeyID.ToString());
                        TN.ChildNodes.Add(TNsub);
                    }
                }
            }

            selectionTree.CollapseAll();
        }

        protected void selectionChange(Object sender, EventArgs e)
		{
            if (!selectionTree.SelectedNode.Value.Equals("parentMenu"))
            {
                var db = new DataClassesCmsDataContext();
                List<ReviseResourceValue> LRRV = db.ReviseResourceValues.Where(p => p.ResourceKeyID.Equals(selectionTree.SelectedNode.Value)).ToList();
                List<ReviseResourceKey> LRRK = db.ReviseResourceKeys.Where(p => p.ResourceKeyID.Equals(selectionTree.SelectedNode.Value)).ToList();

                editor.Value = LRRV.First().ResourceValue;

                hiddenSubmitID.Value = selectionTree.SelectedNode.Value;

                lblTitle.Text = LRRK.First().KeyTitle;
                lblDescription.Text = LRRK.First().KeyDescription;
                displayTitleDescription.Visible = true;
                IntroductionDisplay.Visible = false;
                descriptionLabel.Visible = (lblDescription.Text.Length > 0);

                if (LRRK.First().AllowHTML)
                {
                    editor.Visible = true;
                    simpleEditor.Visible = false;
                    infoLabel.Visible = false;
                    editor.Value = LRRV.First().ResourceValue;
                }
                else
                {
                    simpleEditor.Visible = true;
                    infoLabel.Visible = true;
                    editor.Visible = false;
                    simpleEditor.Text = LRRV.First().ResourceValue;
                }

                SubmitButtonStyle.Visible = true;
            }
        }

        protected void submitContent(object sender, EventArgs e)
        {
            var db = new DataClassesCmsDataContext();
            List<ReviseResourceValue> LRRV = db.ReviseResourceValues.Where(p => p.ResourceKeyID.Equals(hiddenSubmitID.Value)).ToList();

            if (editor.Visible)
            {
                LRRV.First().ResourceValue = editor.Value;
            }

            if (simpleEditor.Visible)
            {
                LRRV.First().ResourceValue = simpleEditor.Text;
            }
            
            db.SubmitChanges();
            btnCancel.Enabled = false;
        }
    }
}
