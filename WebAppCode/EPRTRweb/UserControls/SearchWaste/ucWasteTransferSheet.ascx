<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucWasteTransferSheet.ascx.cs" Inherits="ucWasteTransferSheet" %>

<%@ Register src="~/UserControls/Common/ucSheetLinks.ascx" tagname="ucSheetLinks" tagprefix="eprtr" %>
<%@ Register src="ucWasteTransferSummary.ascx" tagname="ucWasteTransferSummary" tagprefix="eprtr" %>
<%@ Register src="ucWasteTransferActivities.ascx" tagname="ucWasteTransferActivities" tagprefix="eprtr" %>
<%@ Register src="ucWasteTransferAreas.ascx" tagname="ucWasteTransferAreas" tagprefix="eprtr" %>
<%@ Register src="ucWasteTransferComparison.ascx" tagname="ucWasteTransferComparison" tagprefix="eprtr" %>
<%@ Register src="ucWasteTransferFacilities.ascx" tagname="ucWasteTransferFacilities" tagprefix="eprtr" %>
<%@ Register src="ucWasteTransferTransboundaryHazardous.ascx" tagname="ucWasteTransferHazTransboundary" tagprefix="eprtr" %>
<%@ Register src="ucWasteTransferHazardousRecievers.ascx" tagname="ucWasteTransferHazRecievers" tagprefix="eprtr" %>
<%@ Register src="ucWasteTransferConfidentiality.ascx" tagname="ucWasteTransferConfidentiality" tagprefix="eprtr" %>
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
        <eprtr:SheetSubHeader ID="ucSheetSubHeader" runat="server"/>
    </div>
        
    <%-- sub info --%>
    <div class="layout_sheet_content">
        <eprtr:ucWasteTransferSummary ID="ucWasteTransferSummary" Visible="false" runat="server" />
        <eprtr:ucWasteTransferActivities ID="ucWasteTransferActivities" Visible="false" runat="server" />
        <eprtr:ucWasteTransferAreas ID="ucWasteTransferAreas" Visible="false" runat="server" />
        <eprtr:ucWasteTransferComparison ID="ucWasteTransferComparison" Visible="false" runat="server" />
        <eprtr:ucWasteTransferFacilities ID="ucWasteTransferFacilities" Visible="false" runat="server" />
        <eprtr:ucWasteTransferHazTransboundary ID="ucWasteTransferHazTransboundary" Visible="false" runat="server" />
        <eprtr:ucWasteTransferHazRecievers ID="ucWasteTransferHazReceivers" Visible="false" runat="server" />
        <eprtr:ucWasteTransferConfidentiality ID="ucWasteTransferConfidentiality" Visible="false" runat="server" />
    </div>
</div>