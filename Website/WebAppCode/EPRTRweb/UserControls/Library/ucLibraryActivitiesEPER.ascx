<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucLibraryActivitiesEPER.ascx.cs" Inherits="ucLibraryActivitiesEPER" %>

<%--Title and subtitle--%>
<div class="StaticPageStyle">
    <h1>
        <asp:Literal ID="PageHeader" Text="<%$ Resources:Library, ActivityPageHeader%>" runat="server" />
    </h1>
    <div>
        <asp:Literal ID="PageContent" Text="" Mode="Transform" runat="server"></asp:Literal>
    </div>
</div>
