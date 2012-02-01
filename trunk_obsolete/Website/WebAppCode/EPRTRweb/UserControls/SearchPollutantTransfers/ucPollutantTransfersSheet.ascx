<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucPollutantTransfersSheet.ascx.cs" Inherits="ucPollutantTransfersSheet" %>

<%@ Register src="~/UserControls/Common/ucSheetLinks.ascx" tagname="ucSheetLinks" tagprefix="eprtr" %>
<%@ Register src="ucPollutantTransfersSummery.ascx" tagname="ucPollutantTransfersSummery" tagprefix="eprtr" %>
<%@ Register src="ucPollutantTransfersActivities.ascx" tagname="ucPollutantTransfersActivities" tagprefix="eprtr" %>
<%@ Register src="ucPollutantTransfersAreas.ascx" tagname="ucPollutantTransfersAreas" tagprefix="eprtr" %>
<%@ Register src="ucPollutantTransfersAreaComparison.ascx" tagname="ucPollutantTransfersAreaComparison" tagprefix="eprtr" %>
<%@ Register src="ucPollutantTransfersFacilities.ascx" tagname="ucPollutantTransfersFacilities" tagprefix="eprtr" %>
<%@ Register src="ucPollutantTransfersConfidentiality.ascx" tagname="ucPollutantTransfersConfidentiality" tagprefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucSheetSubHeader.ascx" TagName="SheetSubHeader" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucDownloadPrint.ascx" TagName="ucDownloadPrint" TagPrefix="eprtr" %>

<div class="look_sheet_level0">
    <div class="layout_sheet_header">
        <h2>
            <asp:Literal ID="litHeadline" Text="Header" runat="server" Visible="true"></asp:Literal>
        </h2>
    </div>

    <eprtr:ucSheetLinks ID="ucSheetLinks" runat="server" Visible="true" />

    <%-- download and print icons --%>
    <div class="layout_sheet_download_print">
      <eprtr:ucDownloadPrint ID="ucDownloadPrint" Visible="true" runat="server" />
    </div>

    <div class="layout_sheet_subHeader">
        <eprtr:SheetSubHeader ID="ucSheetSubHeader"  runat="server"/>
    </div>

    <%-- sheets --%>
    <div class="layout_sheet_content">
        <eprtr:ucPollutantTransfersSummery ID="ucPollutantTransfersSummery" Visible="false" runat="server" />
        <eprtr:ucPollutantTransfersActivities ID="ucPollutantTransfersActivities" Visible="false" runat="server" />
        <eprtr:ucPollutantTransfersAreas ID="ucPollutantTransfersAreas" Visible="false" runat="server" />
        <eprtr:ucPollutantTransfersAreaComparison ID="ucPollutantTransfersAreaComparison" Visible="false" runat="server" />
        <eprtr:ucPollutantTransfersFacilities ID="ucPollutantTransfersFacilities" Visible="false" runat="server" />
        <eprtr:ucPollutantTransfersConfidentiality ID="ucPollutantTransfersConfidentiality" Visible="false" runat="server" />
    </div>
</div>