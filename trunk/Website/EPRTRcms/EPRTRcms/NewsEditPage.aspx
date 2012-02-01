<%@ Page Language="C#" AutoEventWireup="true" ValidateRequest="false" CodeBehind="NewsEditPage.aspx.cs"
    MasterPageFile="~/MasterPage/MasterPage.Master" Inherits="EPRTRcms.NewsEditPage" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="Moxiecode.TinyMCE" Namespace="Moxiecode.TinyMCE.Web" TagPrefix="tinymce" %>
<%@ Register Src="~/EditorHelpText.ascx" TagName="EditorHelpText" TagPrefix="cms" %>
<asp:Content ID="NewsEditorContent" ContentPlaceHolderID="ContentDisplayArea" runat="server">
    <div id="Div1" class="contentArea" runat="server">
        <div id="NewsListDisplay" >
            <asp:Button ID="btnAddNewsItem" Font-Size="8" runat="server" Text="Add news story" OnClick="btnAddNewsItem_OnClick" />
            <br />
            <asp:Button ID="btnRefreshTreeView"  Font-Size="8" runat="server" Text="Refresh tree view" OnClick="btnRefreshTreeView_OnClick" />
            <asp:Label ID="lblStatus" Text="" runat="server" />
            <br />
            <br />
            <asp:TreeView ID="NewsOverviewTree" SelectedNodeStyle-BackColor="#BDEBF7" runat="server"
                NodeWrap="true" OnSelectedNodeChanged="NewsOverviewTree_SelectedNodeChanged">
            </asp:TreeView>
            <br />
            <br /><br />
           
            <br />
        </div>
        <div runat="server" id="IntroductionDisplay">
            <asp:Label ID="Label2" runat="server">
                <h1>News editor</h1>
                <p>To edit an existing news story, expand a news items in the left side tree view and choose a language. The list contains the language of all existing translations.</p>
                <p>Adding a new story is done by clicking the 'Add news story' button. A new story is always added in English first.</p>
                <p>Subsequently, you can add a translation of a news story by selecting the 'Add language' feature in the tree view below the news story you want to translate.</p>
            </asp:Label>
        </div>
        <div id="NewsEditorFuncDisplay" class="NewsEditorFuncDisplay" runat="server">
            <div id="TitleDisplay" style="float: left; clear: none;">
                <table>
                    <tr>
                        <td colspan="2">
                            <asp:Label ID="lbWorkingLanguage" Text="" runat="server" />
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lbEnglishTitle" Text="English title" runat="server" />
                        </td>
                        <td>
                            <asp:TextBox ID="tbEnglishTitle" runat="server" Enabled="false" Text="" Width="255px"
                                Font-Size="8"></asp:TextBox>
                                
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lbTitle" Text="Title" runat="server" />
                        </td>
                        <td>
                            <asp:TextBox ID="tbNewsTitleEditor" runat="server" Wrap="false" Width="255px" Font-Size="8"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lbLanguageList" Text="New language" runat="server" />
                        </td>
                        <td>
                            <asp:DropDownList Font-Size="8" ID="LanguageList" runat="server" AutoPostBack="false" Visible="false" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lbTopNews" runat="server" ToolTip="<%$ Resources: TextStrings, TopNewsToolTip %>" Text="Top news" />
                        </td>
                        <td>
                            <asp:CheckBox ID="cbTopNews" runat="server" ToolTip="<%$ Resources: TextStrings, TopNewsToolTip %>" Checked="false" />
                        </td>
                    </tr>
                    
                    <tr>
                        <td>
                       
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="Label3" ToolTip="<%$ Resources: TextStrings, CalendarToolTip %>"  runat="server" Text="Date"/>
                        </td>
                        <td>
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <asp:Calendar ID="NewsCalender" runat="server"  ToolTip="<%$ Resources: TextStrings, CalendarToolTip %>" ></asp:Calendar>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                             <asp:Label ID="lbDateExplain" runat="server" Visible="true"/>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="NewsEditorDisplay">
                <tinymce:TextArea ID="TextEditorNews" Width="480px" Height="500px" runat="server"
                    theme="advanced" plugins="spellchecker,safari,pagebreak,style,layer,table,save,advhr,advlink,inlinepopups,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template"
                    theme_advanced_buttons1="bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,|,formatselect,fontsizeselect,|,forecolor,backcolor"
                    theme_advanced_buttons2="cut,copy,paste,pastetext,pasteword,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,cleanup,code"
                    theme_advanced_buttons3="tablecontrols,|,hr,removeformat" theme_advanced_toolbar_location="top"
                    theme_advanced_toolbar_align="left" theme_advanced_path_location="bottom" theme_advanced_resizing="false"
                    convert_urls="false" />
                <asp:Button ID="btnCancel" runat="server" OnClick="btnCancel_OnClick" Text="Reset"
                    Enabled="true" Visible="false" Font-Size="8"/>
                <asp:Button ID="btnSubmit" OnClick="btnSubmit_OnClick" runat="server" Text="Submit" Font-Size="8"/>
                <asp:Label runat="server" ID="Label1" Text="<%$ Resources:TextStrings, SubmitWarning%>"
                    Style="color: Red; " />
                <asp:Label ID="lbHiddenNews" CssClass="floatRight" runat="server" ToolTip="<%$ Resources: TextStrings, HideNewsToolTip %>" Text="Hide news story" />
                <asp:CheckBox ID="cbHideNews" CssClass="floatRight" runat="server" ToolTip="<%$ Resources: TextStrings, HideNewsToolTip %>" Checked="false" />
                <br />    
                <br />
                <asp:RequiredFieldValidator ID="validateTitle" Display="Dynamic" ControlToValidate="tbNewsTitleEditor" ErrorMessage="<strong>Please enter a title for the news story</strong>" EnableClientScript="true" runat="server" /> 
                <br />    
                <br />
                <cms:EditorHelpText runat="server"></cms:EditorHelpText>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="HiddenCultureCode" runat="server" Visible="false" />
    <asp:HiddenField ID="HiddenSubmitID" runat="server" Visible="false" />
    <asp:HiddenField ID="HiddenUnsubmittedData" runat="server" Visible="false" />
</asp:Content>
