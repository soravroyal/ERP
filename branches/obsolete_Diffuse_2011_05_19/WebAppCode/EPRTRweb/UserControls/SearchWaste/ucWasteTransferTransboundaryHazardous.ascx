<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucWasteTransferTransboundaryHazardous.ascx.cs" Inherits="ucWasteTransferTransboundaryHazardous" %>
<%@ Register src="~/UserControls/Common/ucNoDataReturned.ascx" TagName="NoDataReturned"
    TagPrefix="EPRT" %>
<asp:Panel ID="wasteTransferTransboundHazardousPanel" runat="server">
  <div id="WasteTransferBubbleChart2" visible="true"><EPRT:NoDataReturned ID="NoDataReturned" runat="server" Visible="false" /></div>
</asp:Panel>
