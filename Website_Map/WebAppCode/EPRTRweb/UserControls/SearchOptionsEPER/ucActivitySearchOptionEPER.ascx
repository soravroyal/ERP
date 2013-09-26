<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucActivitySearchOptionEPER.ascx.cs"
    Inherits="ucActivitySearchOptionEPER" %>
<div>
    <asp:RadioButtonList ID="rblActivityType" RepeatDirection="Horizontal" RepeatLayout="Flow"
        runat="server" AutoPostBack="true" OnSelectedIndexChanged="rblActivityType_SelectedIndexChanged">
        <asp:ListItem Text="<%$ Resources:Common,IndustrialActivity%>" Value="0" Selected="True"></asp:ListItem>
        <asp:ListItem Text="<%$ Resources:Common,EconomicSector%>" Value="1" Selected="false"></asp:ListItem>
    </asp:RadioButtonList>
</div>
<%--sector--%>
<asp:Literal ID="litSector" runat="server" Text="<%$ Resources:Common,Sector %>"></asp:Literal>
<br />
<asp:ListBox ID="lbActivitySector" runat="server" SelectionMode="Multiple" Rows="3"
    AutoPostBack="true" OnSelectedIndexChanged="onActivitySectorChanged"></asp:ListBox>
<%--Activities--%>
<asp:Literal ID="litActivities" runat="server" Text="<%$ Resources:Common,Activities %>"></asp:Literal>
<br />
<asp:ListBox ID="lbActivities" runat="server" SelectionMode="Multiple" Rows="3" AutoPostBack="false"></asp:ListBox>
