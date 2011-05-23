<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucAreaOverviewSheet.ascx.cs" Inherits="ucAreaOverviewSheet" %>

<%@ Register src="~/UserControls/Common/ucSheetLinks.ascx" tagname="ucSheetLinks" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/SearchAreaOverview/ucAreaOverviewPollutantReleases.ascx" tagname="ucAreaOverviewPollutantReleases" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/SearchAreaOverview/ucAreaOverviewPollutantTransfers.ascx" tagname="ucAreaOverviewPollutantTransfers" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/SearchAreaOverview/ucAreaOverviewWasteTransfer.ascx" tagname="ucAreaOverviewWasteTransfer" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/SearchAreaOverview/ucAreaOverviewConfidentiality.ascx" tagname="ucAreaOverviewConfidentiality" tagprefix="eprtr" %>
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
      <eprtr:ucDownloadPrint ID="ucDownloadPrint" Visible="false" runat="server" />
    </div>

    <div class="layout_sheet_subHeader">
        <eprtr:SheetSubHeader ID="ucSheetSubHeader" runat="server"/>
    </div>

    <%-- sheets --%>
    <div class="layout_sheet_content">
        <eprtr:ucAreaOverviewPollutantReleases ID="ucAreaOverviewPollutantReleases" Visible="false" runat="server" />
        <eprtr:ucAreaOverviewPollutantTransfers ID="ucAreaOverviewPollutantTransfers" Visible="false" runat="server" />
        <eprtr:ucAreaOverviewWasteTransfer ID="ucAreaOverviewWasteTransfer" Visible="false" runat="server" />
        <eprtr:ucAreaOverviewConfidentiality ID="ucAreaOverviewConfidentiality" Visible="false" runat="server" />
    </div>
</div>