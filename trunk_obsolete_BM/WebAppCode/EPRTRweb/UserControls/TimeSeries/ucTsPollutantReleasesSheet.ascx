<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucTsPollutantReleasesSheet.ascx.cs" Inherits="ucTsPollutantReleasesSheet" %>

<%@ Register src="~/UserControls/Common/ucSheetLinks.ascx" tagname="ucSheetLinks" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/TimeSeries/ucTsPollutantReleasesComparison.ascx" tagname="ucTsPollutantReleasesComparison" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/TimeSeries/ucTsPollutantReleasesConfidentiality.ascx" tagname="ucTsPollutantReleasesConfidentiality" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/TimeSeries/ucTsPollutantReleasesSeries.ascx" tagname="ucTsPollutantReleasesSeries" tagprefix="eprtr" %>
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
        <eprtr:SheetSubHeader ID="ucSheetSubHeader" runat="server" Text="<%$ Resources:Pollutant,AllValuesAreYearlyReleases %>"/>
    </div>

    <%-- sheets --%>
    <div class="layout_sheet_content">
        <eprtr:ucTsPollutantReleasesSeries ID="ucTsPollutantReleasesSeries" Visible="false" runat="server" />
        <eprtr:ucTsPollutantReleasesComparison ID="ucTsPollutantReleasesComparison" Visible="false" runat="server" />
        <eprtr:ucTsPollutantReleasesConfidentiality ID="ucTsPollutantReleasesConfidentiality" Visible="false" runat="server" />
    </div>
</div>