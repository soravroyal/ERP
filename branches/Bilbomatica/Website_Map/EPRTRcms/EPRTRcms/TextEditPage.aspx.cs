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
        private const string BRITISH_CULTURE = "en-GB";
        private const string NEW_LANGUAGE = "__newLanguage";
        private const string NEW_NEWS_ENTRY = "__newNewsEntry";

        private DataClassesCmsDataContext db;
        private IEnumerable<LOV_Culture> cultures;
        private IEnumerable<ReviseResourceKey> textKeys;
        private IEnumerable<ReviseResourceValue> textValues;
        private IEnumerable<LOV_ContentsGroup> textGroups;

        protected void Page_Load(object sender, EventArgs e)
        {
            db = new DataClassesCmsDataContext();
            cultures = new DataClassesCultureDataContext().LOV_Cultures;
            textKeys = db.ReviseResourceKeys.OrderBy(x => x.KeyTitle);
            textValues = db.ReviseResourceValues;
            textGroups = db.LOV_ContentsGroups;

            if (!IsPostBack)
            {
                CreateTreeView();

                SubmitButtonStyle.Visible = false;

                editor.Visible = false;
                displayTitleDescription.Visible = false;
                IntroductionDisplay.Visible = true;

                SubmitButtonStyle.Visible = false;
            }
        }

        private void CreateTreeView()
        {
            selectionTree.Nodes.Clear();

            foreach (var group in textGroups)
            {
                TreeNode nodeGroup = new TreeNode(group.Name, "parentMenu");
                this.selectionTree.Nodes.Add(nodeGroup);
                nodeGroup.Expand();
                nodeGroup.SelectAction = TreeNodeSelectAction.Expand;

                foreach (var key in textKeys.Where(x => x.ContentsGroupID.Equals(group.LOV_ContentsGroupID)))
                {
                    // Display ResourceKey name if no real title is present
                    string nodeTitle = key.KeyTitle.Equals("") ? key.ResourceKey : key.KeyTitle;
                    string nodeValue = textKeys.Single(p => p.ResourceKeyID.Equals(key.ResourceKeyID)).ResourceKeyID.ToString();

                    TreeNode nodeTextEntry = new TreeNode(nodeTitle, nodeValue);
                    nodeTextEntry.SelectAction = TreeNodeSelectAction.Expand;

                    // add a child node for each available translation
                    foreach (var localizedTextItem in textValues.Where(x => x.ResourceKeyID == key.ResourceKeyID))
                    {
                        string language = cultures.Single(x => x.Code == localizedTextItem.CultureCode).EnglishName;
                        var nodeLanguage = new TreeNode(language, localizedTextItem.CultureCode);
                        nodeTextEntry.ChildNodes.Add(nodeLanguage);
                    }

                    // add a link to add a new translation
                    if (nodeTextEntry.ChildNodes.Count < cultures.Count())
                    {
                        var addLanugageNode = new TreeNode("Add new language", NEW_LANGUAGE);
                        nodeTextEntry.ChildNodes.Add(addLanugageNode);
                    }

                    nodeGroup.ChildNodes.Add(nodeTextEntry);
                }
            }

            selectionTree.CollapseAll();
        }

        protected void selectionChange(Object sender, EventArgs e)
        {
            // culture
            HiddenCultureCode.Value = selectionTree.SelectedNode.Value;

            // news key id
            HiddenSubmitID.Value = selectionTree.SelectedNode.Parent.Value;

            // load text entry
            LoadTextItem();
        }

        private void LoadTextItem()
        {
            if (HiddenCultureCode.Value == NEW_LANGUAGE)
            {
                ClearTextForm();

                // Language always English for new news items
                DataBindLanguageList();
                LanguageList.Visible = true;
                lbLanguageList.Visible = true;

                lbWorkingLanguage.Text =
                    String.Format("You are about to add a new translation for the chosen news story. Choose a language from the drop down list.");

            }
            else
            {
                var val = textValues.Single(v =>
                    v.CultureCode == HiddenCultureCode.Value &&
                    v.ResourceKeyID == int.Parse(HiddenSubmitID.Value));

                // set text boxes
                editor.Value = val.ResourceValue;
                simpleEditor.Text = val.ResourceValue;

                // set descriptive text labels
                lblTitle.Text = val.ReviseResourceKey.KeyTitle;
                lblDescription.Text = val.ReviseResourceKey.KeyDescription;

                lbWorkingLanguage.Text =
                    String.Format("Current working language is {0}", GetEnglishLanguageName(val.CultureCode));

                LanguageList.Visible = false;
                lbLanguageList.Visible = false;
            }

            // set visibility properties
            displayTitleDescription.Visible = true;
            IntroductionDisplay.Visible = false;
            descriptionLabel.Visible = (lblDescription.Text.Length > 0);

            bool allowHTML = textKeys.Single(x => x.ResourceKeyID.Equals(int.Parse(HiddenSubmitID.Value))).AllowHTML;

            if (allowHTML)
            {
                editor.Visible = true;
                simpleEditor.Visible = false;
                infoLabel.Visible = false;
            }
            else
            {
                editor.Visible = false;
                simpleEditor.Visible = true;
                infoLabel.Visible = true;
            }

            SubmitButtonStyle.Visible = true;
        }

        private void ClearTextForm()
        {
            editor.Value = String.Empty;
            simpleEditor.Text = String.Empty;
            lblTitle.Text = String.Empty;
            lblDescription.Text = String.Empty;

            LanguageList.Visible = false;
            lbLanguageList.Visible = false;
        }

        private void DataBindLanguageList()
        {
            // init language selector
            var cultureTable = new DataClassesCultureDataContext().LOV_Cultures;

            var culturesAlreadyUsed = from x in textValues
                                      where x.ResourceKeyID == int.Parse(HiddenSubmitID.Value)
                                      select x.CultureCode;

            var data = cultureTable.Where(n => !culturesAlreadyUsed.Contains(n.Code));

            LanguageList.DataSource = data;
            LanguageList.DataTextField = "EnglishName";
            LanguageList.DataValueField = "Code";
            LanguageList.DataBind();
        }

        protected void btnRefreshTreeView_OnClick(object sender, EventArgs e)
        {
            CreateTreeView();
        }

        protected void btnSubmit_OnClick(object sender, EventArgs e)
        {
            if (HiddenCultureCode.Value.Equals(NEW_LANGUAGE))
            {
                // insert new translation in new language
                InsertValue();
                
                // store chosen culture
                HiddenCultureCode.Value = LanguageList.SelectedValue;

                // reload entire page
                LoadTextItem();
            }
            else
            {

                ModifyKeyAndValue(); 
            }
        }

        /// <summary>
        ///  new language added to key
        /// </summary>
        private void InsertValue()
        {
            var db = new DataClassesCmsDataContext();
            
            // retrieving to key 
            var key = db.ReviseResourceKeys.Single(x => x.ResourceKeyID.Equals(HiddenSubmitID.Value));

            // creating text in new language
            var value = new ReviseResourceValue()
            {
                CultureCode = LanguageList.SelectedValue,
                ResourceKeyID = key.ResourceKeyID,
                ResourceValue = editor.Visible ? editor.Value : simpleEditor.Text
            };

            key.ReviseResourceValues.Add(value);

            db.SubmitChanges();
        }

        /// <summary>
        /// text item in existing language added to key
        /// </summary>
        private void ModifyKeyAndValue()
        { 
            var db = new DataClassesCmsDataContext();

            var val = db.ReviseResourceValues.
                Single(p => p.ResourceKeyID.Equals(HiddenSubmitID.Value) && p.CultureCode.Equals(HiddenCultureCode.Value));

            val.ResourceValue = editor.Visible ? editor.Value : simpleEditor.Text;
        
            db.SubmitChanges();
        }

        private string GetEnglishLanguageName(string cultureCode)
        {
            var cultures = new DataClassesCultureDataContext().LOV_Cultures;
            return cultures.Single(n => n.Code.Equals(cultureCode)).EnglishName;
        }

    }
}
