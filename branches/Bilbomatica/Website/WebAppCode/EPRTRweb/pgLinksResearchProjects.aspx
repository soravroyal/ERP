<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="pgLinksResearchProjects.aspx.cs" Inherits="pgLinksResearchProjects" %>


<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">

    <%--Title and subtitle--%>
    <div class="StaticPageStyle" style="padding-left:40px;">
        <h1>
            <asp:Literal ID="PageHeader" Text="<%$ Resources:Static, LinksResearchProjectsPageHeader%>" runat="server" />
        </h1>
        <div>
            <asp:Literal ID="PageContent" Text="" Mode="Transform" runat="server" />
        </div>
    </div>
</asp:Content>
