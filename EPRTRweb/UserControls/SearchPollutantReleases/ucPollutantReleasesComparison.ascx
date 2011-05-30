<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucPollutantReleasesComparison.ascx.cs" Inherits="ucPollutantReleasesComparison" %>

<%@ Register Src="~/UserControls/Common/ucMediumSelector.ascx" TagName="ucMediumSelector" TagPrefix="eprtr" %>

<%-- Releases to radio buttons --%>
<eprtr:ucMediumSelector ID="ucMediumSelector"  OnItemSelected="OnSelectedMediumChanged" runat="server" />

<div class="clearBoth">
    <asp:Literal ID="litNoResultFound" Text="<%$ Resources:Common,NoResultsFound %>" runat="server" Visible="false"></asp:Literal>

    <%-- Flash tag --%>
    <%@ Register TagPrefix="nfp" TagName="NoFlashPlayer" Src="~/UserControls/Common/ucNoFlashPlayer.ascx" %>
    <%@ Register TagPrefix="ndr" TagName="NoDataReturned" src="~/UserControls/Common/ucNoDataReturned.ascx" %>

    <asp:Panel ID="compareChartPanel" runat="server" Visible="true">
      <div id="barchart" visible="true">
      <ndr:NoDataReturned id="NoDataReturned" Visible="false" runat="server" /></div>
    </asp:Panel>

</div>



