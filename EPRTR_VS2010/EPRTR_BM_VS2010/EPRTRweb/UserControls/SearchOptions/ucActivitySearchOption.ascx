<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucActivitySearchOption.ascx.cs"
    Inherits="ucActivitySearchOption" %>
<div>
    <asp:RadioButtonList ID="rblActivityType" RepeatDirection="Horizontal" RepeatLayout="Flow"
        runat="server" AutoPostBack="true" OnSelectedIndexChanged="rblActivityType_SelectedIndexChanged">
        <asp:ListItem Text="<%$ Resources:Common,IndustrialActivity%>" Value="0" Selected="True"></asp:ListItem>
        <asp:ListItem Text="<%$ Resources:Common,EconomicSector%>" Value="1" Selected="false"></asp:ListItem>
        <%--<asp:ListItem Text="<%$ Resources:Common,IPPC%>" Value="2" Selected="False" Enabled="false"></asp:ListItem>--%>
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
<asp:ListBox ID="lbActivities" runat="server" SelectionMode="Multiple" Rows="3" AutoPostBack="true"
    OnSelectedIndexChanged="onActivitiesChanged"></asp:ListBox>
<%--Sub-activities--%>
<asp:Literal ID="litSubActivity" runat="server" Text="<%$ Resources:Common,SubActivities %>"></asp:Literal>
<asp:Image ID="imgAlert" ImageUrl="~/images/alert.png" AlternateText="<%$ Resources:Common,DisclaimerSubActivity %>" Visible="true" runat="server" />
<br />
<asp:ListBox ID="lbSubActivities" runat="server" SelectionMode="Multiple" Rows="3"
    AutoPostBack="false" ></asp:ListBox>
    <%--OnSelectedIndexChanged="onSubActivitiesChanged"--%>
