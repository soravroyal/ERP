<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucPollutantReleasesSummary.ascx.cs" Inherits="ucPollutantReleasesSummary" %>

<%-- Releases to radio buttons --%>
<%@ Register TagPrefix="nfp" TagName="NoFlashPlayer" Src="~/UserControls/Common/ucNoFlashPlayer.ascx" %>
<%@ Register TagPrefix="ndr" TagName="NoDataReturned" src="~/UserControls/Common/ucNoDataReturned.ascx" %>
<%@ Register Src="~/UserControls/Common/ucMediumSelector.ascx" TagName="ucMediumSelector" TagPrefix="eprtr" %>

<%-- Releases to radio buttons --%>
<eprtr:ucMediumSelector ID="ucMediumSelector"  OnItemSelected="OnSelectedMediumChanged" runat="server" />

<div class="clearBoth">
    <asp:Literal ID="litNoResultFound" Text="<%$ Resources:Common,NoResultsFound %>" runat="server" Visible="false"></asp:Literal>

    <%-- Flash tag --%>
    <asp:Panel ID="pieChartPanel" runat="server" Visible="true">
        <div id="piechart" visible="true">
        <%--<nfp:NoFlashPlayer runat="server" />--%>
        <ndr:NoDataReturned ID="NoDataReturned" runat="server" Visible="false" />
        </div>
    </asp:Panel>

</div>


