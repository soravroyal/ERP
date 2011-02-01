<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucWasteTransferComparison.ascx.cs" Inherits="ucWasteTransferComparison" %>
<%@ Register TagPrefix="nfp" TagName="NoFlashPlayer" Src="~/UserControls/Common/ucNoFlashPlayer.ascx" %>
<%@ Register TagPrefix="ndr" TagName="NoDataReturned" src="~/UserControls/Common/ucNoDataReturned.ascx" %>
<%@ Register Src="~/UserControls/Common/ucWasteTypeSelector.ascx" TagName="ucWasteTypeSelector" TagPrefix="eprtr" %>

<%-- Transfer to radio buttons --%>
<eprtr:ucWasteTypeSelector ID="ucWasteTypeSelector"  OnItemSelected="OnSelectedWasteTypeChanged" runat="server" />

<div id="EnableDisable" runat="server">
  <asp:Label ID="lbDoubleCounting" runat="server" Text="<%$ Resources:WasteTransfers,DoubleCounting %>"></asp:Label>
</div>

<%-- Flash tag --%>
<asp:Panel ID="compareChartPanel" runat="server" Visible="true">
  <div id="barchart" visible="true">
  <ndr:NoDataReturned ID="NoDataReturned" Visible="false" runat="server" />
  </div>
</asp:Panel>

<div class="noResult">
<asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server" Visible="false"></asp:Literal>
</div>