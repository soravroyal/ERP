<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucMediumSearchOption.ascx.cs" Inherits="ucMediumSearchOption" %>

<div class="searchOption_mediumLegend">
    <asp:Literal ID="litReleasesTo"  runat="server" Text="<%$ Resources:Common,ReleasesTo %>"></asp:Literal>
</div>

<div class="searchOption_mediumCriteria">
    <asp:CheckBox ID="chkAir" Text="<%$ Resources:Common,Air %>" Checked="true" runat="server" />
    <asp:CheckBox ID="chkWater" Text="<%$ Resources:Common,Water %>" Checked="true" runat="server" />
    <asp:CheckBox ID="chkSoil" Text="<%$ Resources:Common,Soil %>"  Checked="true" runat="server" />
    <asp:Panel ID="plAccidental" runat="server">
        <asp:CheckBox ID="chkAccidental" Text="<%$ Resources:Common,AccidentalOnly %>"  Checked="false" runat="server" />
    </asp:Panel>
</div>


<asp:Panel ID="plTransfers" runat="server">
<div class="searchOption_mediumLegend">
    <asp:Literal ID="litTransfers"  runat="server" Text="<%$ Resources:Common,TransfersTo %>"></asp:Literal>
</div>
<div class="searchOption_mediumCriteria">
    <asp:CheckBox ID="chkWasteWater" Text="<%$ Resources:Common,WasteWater %>" runat="server" Checked="true" />
</div>
</asp:Panel>

<div class="spacer"></div>
