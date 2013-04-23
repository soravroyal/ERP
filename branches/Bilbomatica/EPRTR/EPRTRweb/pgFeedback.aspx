<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="pgFeedback.aspx.cs" Inherits="pgFeedback" %>


<asp:Content ID="infoarea" ContentPlaceHolderID="ContentInfoArea" runat="server">

    <%--Title and subtitle--%>
    <div class="StaticPageStyle">
        <h1>
            <asp:Literal ID="PageHeader" Text="<%$ Resources:Static, FeedbackPageHeader%>" runat="server" />
        </h1>
        <p>
            <asp:Literal ID="PageContent" Text="" Mode="Transform" runat="server"></asp:Literal>
        </p>
    </div>
</asp:Content>
