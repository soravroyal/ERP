using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryCms;


namespace EPRTRcms
{
    public partial class NewsEditPage : System.Web.UI.Page
    {
        private const string BRITISH_CULTURE = "en-GB";
        private const string NEW_LANGUAGE = "__newLanguage";
        private const string NEW_NEWS_ENTRY = "__newNewsEntry";

        private DataClassesNewsDataContext db;
        private IEnumerable<NewsKey> newsKeys;
        private IEnumerable<NewsValue> newsValues;
        private IEnumerable<LOV_Culture> cultures;

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (HiddenCultureCode.Value.Equals(NEW_LANGUAGE)
                || HiddenSubmitID.Value.Equals(NEW_NEWS_ENTRY)
                || !Page.IsPostBack)
            {
                CreateNewsList();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            db = getNewsDataContext();
            newsKeys = db.NewsKeys;
            newsValues = db.NewsValues;
            cultures = new DataClassesCultureDataContext().LOV_Cultures;

            if (!Page.IsPostBack)
            {
                //HiddenUnsubmittedData.Value = false;
                NewsEditorFuncDisplay.Visible = false;
                IntroductionDisplay.Visible = true;
            }
        }


        private void DataBindLanguageList()
        {
            // init language selector
            var cultureTable = new DataClassesCultureDataContext().LOV_Cultures;
            
            var culturesAlreadyUsed = from n in newsValues
                                      where n.NewsKeyID == int.Parse(HiddenSubmitID.Value)
                                      select n.CultureCode;

            var data = cultureTable.Where(n => !culturesAlreadyUsed.Contains(n.Code));
            
            LanguageList.DataSource = data;
            LanguageList.DataTextField = "Name";
            LanguageList.DataValueField = "Code";
            LanguageList.DataBind();
        }

        protected void CreateNewsList()
        {
            NewsOverviewTree.Nodes.Clear();

            var newsEnglish = from n in newsValues
                              where n.CultureCode == BRITISH_CULTURE
                              orderby n.NewsKey.NewsDate descending
                              select n;

            var numOfCultures = cultures.Count();

            // Node header
            string header;

            foreach (var n in newsEnglish)
            {
                TreeNode node = new TreeNode(n.HeaderText, n.NewsKeyID.ToString());
                node.ToolTip = String.Format("{0:D}", n.NewsKey.NewsDate);
                node.SelectAction = TreeNodeSelectAction.Expand;
                
                NewsOverviewTree.Nodes.Add(node);

                foreach (var localizedNewsItem in newsValues.Where(x => x.NewsKeyID == n.NewsKeyID))
                {
                    string language = cultures.Single(x => x.Code == localizedNewsItem.CultureCode).Name;
                    var languageNode = new TreeNode(language, localizedNewsItem.CultureCode);
                    node.ChildNodes.Add(languageNode);
                }

                if (node.ChildNodes.Count < numOfCultures)
                {
                    var addLanugageNode = new TreeNode("Add new language", NEW_LANGUAGE);
                    node.ChildNodes.Add(addLanugageNode);
                }
            }

            NewsOverviewTree.CollapseAll();

        }

        protected void NewsOverviewTree_SelectedNodeChanged(object sender, EventArgs e)
        {
            var node = ((TreeView)sender).SelectedNode;

            // culture
            HiddenCultureCode.Value = node.Value;

            // news key id
            HiddenSubmitID.Value = node.Parent.Value;

            LoadNewsItem();

            IntroductionDisplay.Visible = false;
        }
     
        private void LoadNewsItem()
        {
            if (HiddenCultureCode.Value == NEW_LANGUAGE)
            {
                ClearNewsForm();
                
                //HiddenUnsubmittedData.Value = true;

                // Language always English for new news items
                DataBindLanguageList();
                LanguageList.Visible = true;
                lbLanguageList.Visible = true;
                
                var key = newsKeys.Single(x => x.NewsKeyID == int.Parse(HiddenSubmitID.Value));

                NewsCalender.SelectedDate = key.NewsDate;
                NewsCalender.VisibleDate = key.NewsDate;

                cbTopNews.Checked = key.TopNewsIndicator;

                lbEnglishTitle.Visible = true;
                tbEnglishTitle.Visible = true;
                tbEnglishTitle.Text = GetEnglishNewsTitle(key.NewsKeyID);

                lbWorkingLanguage.Text =
                    String.Format("You are about to add a new translation for the chosen news story. Choose a language from the drop down list.");

            }
            else
            {
                var newsItems = from val in newsValues
                                join key in newsKeys on val.NewsKeyID equals key.NewsKeyID
                                where
                                    val.CultureCode == HiddenCultureCode.Value &&
                                    key.NewsKeyID == int.Parse(HiddenSubmitID.Value)

                                select new
                                {
                                    NewsId = key.NewsKeyID,
                                    NewsDate = key.NewsDate,
                                    TopNews = key.TopNewsIndicator,
                                    TitleText = val.HeaderText,
                                    ContentText = val.BodyText,
                                    CultureCode = val.CultureCode

                                };

                var item = newsItems.First();

                // set text boxes
                TextEditorNews.Value = item.ContentText;
                tbNewsTitleEditor.Text = item.TitleText;

                if (item.CultureCode.Equals(BRITISH_CULTURE))
                {
                    tbEnglishTitle.Visible = false;
                    lbEnglishTitle.Visible = false;
                }
                else
                {
                    lbEnglishTitle.Visible = true;
                    tbEnglishTitle.Visible = true;

                    tbEnglishTitle.Text = GetEnglishNewsTitle(item.NewsId);
                }

                // set top news
                cbTopNews.Checked = item.TopNews;

                // set calendar
                NewsCalender.SelectedDate = item.NewsDate;
                NewsCalender.VisibleDate = item.NewsDate;

                lbWorkingLanguage.Text = 
                    String.Format("Current working language is {0}", GetLanguageName(item.CultureCode));

                LanguageList.Visible = false;
                lbLanguageList.Visible = false;
            }

            NewsEditorFuncDisplay.Visible = true;
        }

        protected void btnSubmit_OnClick(object sender, EventArgs e)
        {
            if (HiddenSubmitID.Value.Equals(NEW_NEWS_ENTRY))
            {
                InsertKeyAndValue();
            }
            else if (HiddenCultureCode.Value.Equals(NEW_LANGUAGE))
            {
                LanguageList.Visible = false;
                lbLanguageList.Visible = false;
                InsertValue(); // new language added to key
            }
            else
            {
                ModifyKeyAndValue(); // news item in existing language added to key
            }

            //HiddenUnsubmittedData.Value = false;
        }
        /// <summary>
        /// Insert a new news item in both NewsKey and NewsValue tables
        /// </summary>
        private void InsertKeyAndValue()
        {
            NewsKey key = new NewsKey
            {
                NewsDate = NewsCalender.SelectedDate,
                TopNewsIndicator = cbTopNews.Checked,
            };

            NewsValue value = new NewsValue
            {
                BodyText = TextEditorNews.Value,
                CreateDate = DateTime.Today,
                CultureCode = BRITISH_CULTURE, // always english for new items
                HeaderText = tbNewsTitleEditor.Text
            };

            key.NewsValues.Add(value);

            db.NewsKeys.InsertOnSubmit(key);

            db.SubmitChanges();
        }


        private void InsertValue()
        {
            // retrieving to key 
            var key = db.NewsKeys.Single(x => x.NewsKeyID.Equals(HiddenSubmitID.Value));

            // applying changes to value table
            var value = new NewsValue()
            {
                NewsKeyID = key.NewsKeyID,
                BodyText = TextEditorNews.Value,
                HeaderText = tbNewsTitleEditor.Text,
                CultureCode = LanguageList.SelectedValue,
                CreateDate = DateTime.Today
            };

            key.NewsValues.Add(value);

            db.SubmitChanges();
        }


        private void ModifyKeyAndValue()
        {
            // applying changes to key table
            var key = db.NewsKeys.Single(x => x.NewsKeyID.Equals(HiddenSubmitID.Value));

            key.TopNewsIndicator = cbTopNews.Checked;
            key.NewsDate = NewsCalender.SelectedDate;

            // applying changes to value table
            var value = db.NewsValues.Single(x => x.NewsKeyID.Equals(HiddenSubmitID.Value) && x.CultureCode.Equals(HiddenCultureCode.Value));

            value.BodyText = TextEditorNews.Value;
            value.HeaderText = tbNewsTitleEditor.Text;

            db.SubmitChanges();
        }
        
        protected void btnAddNewsItem_OnClick(object sender, EventArgs e)
        {
            HiddenSubmitID.Value = NEW_NEWS_ENTRY;
            HiddenCultureCode.Value = BRITISH_CULTURE;
            //HiddenUnsubmittedData.Value = true;
            LanguageList.Visible = false;
            lbLanguageList.Visible = false;
            lbEnglishTitle.Visible = false;
            tbEnglishTitle.Visible = false;

            ClearNewsForm();
        }

        /// <summary>
        /// Reloads news item into editor
        /// </summary>
        protected void btnCancel_OnClick(object sender, EventArgs e)
        {
            LoadNewsItem();
        }

        private void ClearNewsForm()
        {
            NewsCalender.SelectedDate = DateTime.Today;
            NewsCalender.VisibleDate = DateTime.Today;
                
            cbTopNews.Checked = false;

            tbEnglishTitle.Text = string.Empty;
            tbNewsTitleEditor.Text = string.Empty;
            TextEditorNews.Value = string.Empty;

            NewsEditorFuncDisplay.Visible = true;
        }

        private string GetEnglishNewsTitle(int newsId)
        {
            var title = newsValues.Single(
                n => n.CultureCode.Equals(BRITISH_CULTURE) && n.NewsKeyID.Equals(newsId)).HeaderText;

            return title;
        }

        private string GetLanguageName(string cultureCode)
        {
            return cultures.Single(n => n.Code.Equals(cultureCode)).Name;
        }

        #region Data context
        private static DataClassesNewsDataContext getNewsDataContext()
        {
            DataClassesNewsDataContext db = new DataClassesNewsDataContext();
            db.Log = new DebuggerWriter();
            return db;
        }
        #endregion
    }
}
