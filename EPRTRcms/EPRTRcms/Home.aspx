<%@ Page Language="C#" MasterPageFile="~/MasterPage/MasterPage.Master" AutoEventWireup="true"
    CodeBehind="Home.aspx.cs" Inherits="EPRTRcms.Home" %>

<asp:Content ID="HomepageContent" ContentPlaceHolderID="ContentDisplayArea" runat="server">
    <%--<div id="WelcomeAreaCss" title="CmsWebsiteTitle">--%>
    <div class="contentArea" runat="server">
        <h1>
            <asp:Literal ID="WelcomeHeaderText" runat="server" Text="<%$ Resources: TextStrings, WelcomeHeaderText %>"></asp:Literal>
        </h1>
        <asp:Literal ID="litWelcome" runat="server" Text="<%$ Resources: TextStrings, WelcomeText %>"></asp:Literal>
    </div>
</asp:Content>
