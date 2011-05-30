<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucWasteTypeSearchOption.ascx.cs" Inherits="ucWasteTypeSearchOption" %>

<%--Waste type search options--%>
<div class="searchOption_wasteLegend">
    <asp:Literal ID="litTransferOf" runat="server" Text="<%$ Resources:Common,TransferOf %>"></asp:Literal>
</div>

<div class="searchOption_wasteCriteria">
    <asp:CheckBox ID="chkWasteNonHazardous" Text="<%$ Resources:Common,NoHazardousWaste %>"
        runat="server" Checked="true" /><br />
    <asp:CheckBox ID="chkWasteHazardousCountry" Text="<%$ Resources:Common,HazardouswasteWithinCountry %>"
        runat="server" Checked="true" /><br />
    <asp:CheckBox ID="chkWasteHazardousTransboundary" Text="<%$ Resources:Common,HazardouswasteTransboundary %>"
        runat="server" Checked="true" /><br />
</div>