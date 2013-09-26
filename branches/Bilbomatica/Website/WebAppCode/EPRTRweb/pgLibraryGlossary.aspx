<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="pgLibraryGlossary.aspx.cs" Inherits="pgLibraryGlossary" %>


<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">

    <%--Title and subtitle--%>
    <div class="StaticPageStyle">
        <h1>
            <asp:Literal ID="PageHeader" Text="<%$ Resources:Library, GlossaryPageHeader%>" runat="server" />
        </h1>
        <div>
            <asp:Literal ID="PageContent" Text="" runat="server"></asp:Literal>
        </div>
    </div>
</asp:Content>
