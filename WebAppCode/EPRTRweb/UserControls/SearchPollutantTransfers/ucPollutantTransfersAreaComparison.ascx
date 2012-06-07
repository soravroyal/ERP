<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucPollutantTransfersAreaComparison.ascx.cs" Inherits="ucPollutantTransfersAreaComparison" %>
<%@ Register TagPrefix="nfp" TagName="NoFlashPlayer" Src="~/UserControls/Common/ucNoFlashPlayer.ascx" %>
<%@ Register TagPrefix="ndr" TagName="NoDataReturned" src="~/UserControls/Common/ucNoDataReturned.ascx" %>

<%-- Flash tag --%>

<asp:Panel ID="compareChartPanel" runat="server" Visible="true">
  <div id="barchart" visible="true">
  <ndr:NoDataReturned ID="NoDataReturned" runat="server" Visible="false" />
  <%--<nfp:NoFlashPlayer ID="NoFlashPlayer100" runat="server" />--%>
  </div>
</asp:Panel>


