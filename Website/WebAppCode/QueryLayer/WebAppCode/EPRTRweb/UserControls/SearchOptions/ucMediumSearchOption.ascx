<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucMediumSearchOption.ascx.cs" Inherits="ucMediumSearchOption" %>

<asp:Literal ID="litReleasesTo" runat="server" Text="<%$ Resources:Common,ReleasesTo %>"></asp:Literal>
<asp:CheckBox ID="chkAir" Text="<%$ Resources:Common,Air %>" Checked="true" runat="server" />
<input type="hidden" id="clIDchkAir" value="<%=chkAir.ClientID %>" />
<asp:CheckBox ID="chkWater" Text="<%$ Resources:Common,Water %>" Checked="true" runat="server" />
<input type="hidden" id="clIDchkWater" value="<%=chkWater.ClientID %>" />
<asp:CheckBox ID="chkSoil" Text="<%$ Resources:Common,Soil %>"  Checked="true" runat="server" />
<input type="hidden" id="clIDchkSoil" value="<%=chkSoil.ClientID %>" />

<asp:Panel ID="plTransfers" runat="server">
	<asp:Literal ID="litTransfers" runat="server" Text="<%$ Resources:Common,TransfersTo %>"></asp:Literal>
	<asp:CheckBox ID="chkWasteWater" Text="<%$ Resources:Common,WasteWater %>" runat="server" Checked="true" />
	<input type="hidden" id="clIDchkWasteWater" value="<%=chkWasteWater.ClientID %>" />
</asp:Panel>






