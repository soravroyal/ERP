<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucLibraryWaste.ascx.cs" Inherits="ucLibraryWaste" %>

<%--Title and subtitle--%>
<div class="StaticPageStyle">
    <h1>
        <asp:Literal ID="PageHeader" Text="<%$ Resources:Library,WastePageHeader%>" runat="server" />
    </h1>
    <div>
        <asp:Literal ID="PageContent" Text="" Mode="Transform" runat="server"></asp:Literal>
    </div>
</div>