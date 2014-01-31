<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucIndustrialActivitySheet.ascx.cs" Inherits="ucIndustrialActivitySheet" %>

<%@ Register src="~/UserControls/Common/ucSheetLinks.ascx" tagname="ucSheetLinks" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/SearchIndustryActivity/ucIndustrialActivityPollutantReleases.ascx" tagname="ucIndustrialActivityPollutantReleases" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/SearchIndustryActivity/ucIndustrialActivityPollutantTransfers.ascx" tagname="ucIndustrialActivityPollutantTransfers" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/SearchIndustryActivity/ucIndustrialActivityWasteTransfer.ascx" tagname="ucIndustrialActivityWasteTransfer" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/SearchIndustryActivity/ucIndustrialActivityConfidentiality.ascx" tagname="ucIndustrialActivityConfidentiality" tagprefix="eprtr" %>
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

    <%-- sheets --%>
    <div class="layout_sheet_content">
        <eprtr:ucIndustrialActivityPollutantReleases ID="ucIndustrialActivityPollutantReleases" Visible="false" runat="server" />
        <eprtr:ucIndustrialActivityPollutantTransfers ID="ucIndustrialActivityPollutantTransfers" Visible="false" runat="server" />
        <eprtr:ucIndustrialActivityWasteTransfer ID="ucIndustrialActivityWasteTransfer" Visible="false" runat="server" />
        <eprtr:ucIndustrialActivityConfidentiality ID="ucIndustrialActivityConfidentiality" Visible="false" runat="server" />
    </div>
</div>