<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucMediumSearchOption.ascx.cs" Inherits="ucMediumSearchOption" %>

<asp:Literal ID="litReleasesTo" runat="server" Text="<%$ Resources:Common,ReleasesTo %>"></asp:Literal>
<asp:CheckBox ID="chkAir" Text="<%$ Resources:Common,Air %>" Checked="true" runat="server" />
<asp:CheckBox ID="chkWater" Text="<%$ Resources:Common,Water %>" Checked="true" runat="server" />
<asp:CheckBox ID="chkSoil" Text="<%$ Resources:Common,Soil %>"  Checked="true" runat="server" />

<asp:Panel ID="plTransfers" runat="server">
<asp:Literal ID="litTransfers" runat="server" Text="<%$ Resources:Common,TransfersTo %>"></asp:Literal>
<asp:CheckBox ID="chkWasteWater" Text="<%$ Resources:Common,WasteWater %>" runat="server" Checked="true" />
</asp:Panel>
