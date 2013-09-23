<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucTsPollutantTransfersSheet.ascx.cs" Inherits="ucTsPollutantTransfersSheet" %>

<%@ Register src="~/UserControls/Common/ucSheetLinks.ascx" tagname="ucSheetLinks" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/TimeSeries/ucTsPollutantTransfersSeries.ascx" tagname="ucTsPollutantTransfersSeries" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/TimeSeries/ucTsPollutantTransfersComparison.ascx" tagname="ucTsPollutantTransfersComparison" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/TimeSeries/ucTsPollutantTransfersConfidentiality.ascx" tagname="ucTsPollutantTransfersConfidentiality" tagprefix="eprtr" %>
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
        <eprtr:ucTsPollutantTransfersSeries ID="ucTsPollutantTransfersSeries" Visible="false" runat="server" />
        <eprtr:ucTsPollutantTransfersComparison ID="ucTsPollutantTransfersComparison" Visible="false" runat="server" />
        <eprtr:ucTsPollutantTransfersConfidentiality ID="ucTsPollutantTransfersConfidentiality" Visible="false" runat="server" />
    </div>
</div>                