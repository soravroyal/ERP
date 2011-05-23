<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucTsWasteTransfersSheet.ascx.cs" Inherits="ucTsWasteTransfersSheet" %>

<%@ Register src="~/UserControls/Common/ucSheetLinks.ascx" tagname="ucSheetLinks" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/TimeSeries/ucTsWasteTransfersSeries.ascx" tagname="ucTsWasteTransfersSeries" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/TimeSeries/ucTsWasteTransfersComparison.ascx" tagname="ucTsWasteTransfersComparison" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/TimeSeries/ucTsWasteTransfersConfidentiality.ascx" tagname="ucTsWasteTransfersConfidentiality" tagprefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucSheetSubHeader.ascx" TagName="SheetSubHeader" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucDownloadPrint.ascx" TagName="ucDownloadPrint" TagPrefix="eprtr" %>

<div id="divSheet" class="look_sheet_level0" runat="server">
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
        <eprtr:ucTsWasteTransfersSeries ID="ucTsWasteTransfersSeries" Visible="false" runat="server" />
        <eprtr:ucTsWasteTransfersComparison ID="ucTsWasteTransfersComparison" Visible="false" runat="server" />
        <eprtr:ucTsWasteTransfersConfidentiality ID="ucTsWasteTransfersConfidentiality" Visible="false" runat="server" />
    </div>
</div>