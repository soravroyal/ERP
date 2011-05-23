<%@ Page Language="C#" AutoEventWireup="true" ValidateRequest="false" CodeBehind="TextEditPage.aspx.cs"
    MasterPageFile="~/masterpage/MasterPage.Master" Inherits="EPRTRcms.TextEditPage" %>

<%@ Register Assembly="Moxiecode.TinyMCE" Namespace="Moxiecode.TinyMCE.Web" TagPrefix="tinymce" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor" TagPrefix="cc1" %>

<%@ Register Src="~/EditorHelpText.ascx" TagName="EditorHelpText" TagPrefix="cms" %>

<asp:Content ID="TextEditorContent" ContentPlaceHolderID="ContentDisplayArea" runat="server">
    <%--<div id="scriptArea" runat="server">--%>
    <div class="contentArea" runat="server">
        <div id="TreeViewDisplay">
            <asp:TreeView runat="server" ID="selectionTree" NodeIndent="10" OnSelectedNodeChanged="selectionChange">
            </asp:TreeView>
        </div>
        <div runat="server" id="IntroductionDisplay">
            <asp:Label runat="server">
            <h1>Static text editor</h1>
            <p>Expand one of the text groups in the left side tree view and click the text item you want to edit.</p>
            </asp:Label>
        </div>
        <div id="EditorStyle">
            <div runat="server" id="displayTitleDescription" style="margin-bottom:10px;">
                <h1>
                    <asp:Label ID="lblTitle" runat="server" />
                </h1>
                <div id="descriptionLabel" runat="server" visible="false">
                    <em>
                        <asp:Label ID="lblDescription" runat="server" />
                    </em>
                </div>
            </div>
            <tinymce:TextArea ID="editor" Width="480px" Height="500px" runat="server" theme="advanced"
                plugins="spellchecker,safari,pagebreak,style,layer,table,save,advhr,advlink,inlinepopups,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template"
                theme_advanced_buttons1="bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,|,formatselect,fontsizeselect,|,forecolor,backcolor"
                theme_advanced_buttons2="cut,copy,paste,pastetext,pasteword,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,cleanup,code"
                theme_advanced_buttons3="tablecontrols,|,hr,removeformat" theme_advanced_toolbar_location="top"
                theme_advanced_toolbar_align="left" theme_advanced_path_location="bottom" theme_advanced_resizing="false"              
                convert_urls="false" />
            <%-- re-insert into toolbar   |,image--%>
            <div id="SimpleEditorStyle">
                <asp:TextBox ID="simpleEditor" runat="server" Visible="false" Width="480px" />
                <br />
                <asp:Label runat="server" ID="infoLabel" Text="<%$ Resources:TextStrings, PlainTextWarning%>"
                    Visible="false" />
            </div>
            <div id="SubmitButtonStyle" runat="server">
                <asp:Button ID="btnCancel" runat="server" Text="cancel" Visible="false" Enabled="false" />
                <asp:Button ID="btnSubmit" OnClick="submitContent" runat="server" Text="submit" />
                <asp:Label runat="server" ID="Label1" Text="<%$ Resources:TextStrings, SubmitWarning%>"
                    Style="color: Red; vertical-align: middle;" />
                
                <div id="EditorHelpTextDisplay" runat="server">
                    <cms:EditorHelpText runat="server"></cms:EditorHelpText>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hiddenSubmitID" runat="server" Visible="false" />
</asp:Content>
