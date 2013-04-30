<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucLibraryActivities.ascx.cs" Inherits="ucLibraryActivities" %>

<%--Title and subtitle--%>
<div class="StaticPageStyle">
    <h1>
        <asp:Literal ID="PageHeader" Text="<%$ Resources:Library, ActivityPageHeader%>" runat="server" />
    </h1>
    <p>
        <asp:Literal ID="PageContent" Text="" Mode="Transform" runat="server"></asp:Literal>
    </p>
</div>
