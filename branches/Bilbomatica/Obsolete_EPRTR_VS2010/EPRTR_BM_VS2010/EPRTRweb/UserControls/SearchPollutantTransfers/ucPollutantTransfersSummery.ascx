<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucPollutantTransfersSummery.ascx.cs"
    Inherits="ucPollutantTransfersSummery" %>
    <%@ Register TagPrefix="ndr" TagName="NoDataReturned" src="~/UserControls/Common/ucNoDataReturned.ascx" %>

<asp:Literal ID="litPollutantActivities" runat="server" Text="<%$ Resources:Pollutant,TransfersToWastePerIndustryActivity %>"></asp:Literal>
<asp:Panel ID="upPollutantTransferSummary" runat="server">
    <div id="piechart" visible="true">
    <ndr:NoDataReturned ID="NoDataReturned" runat="server" Visible="false" />
    </div>
</asp:Panel>
<br />
<br />
