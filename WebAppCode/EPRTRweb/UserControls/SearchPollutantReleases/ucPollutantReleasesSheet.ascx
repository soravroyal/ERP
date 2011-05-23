<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucPollutantReleasesSheet.ascx.cs" Inherits="ucPollutantReleasesSheet" %>

<%@ Register src="~/UserControls/Common/ucSheetLinks.ascx" tagname="ucSheetLinks" tagprefix="eprtr" %>
<%@ Register src="ucPollutantReleasesSummary.ascx" tagname="ucPollutantReleasesSummary" tagprefix="eprtr" %>
<%@ Register src="ucPollutantReleasesActivities.ascx" tagname="ucPollutantReleasesActivities" tagprefix="eprtr" %>
<%@ Register src="ucPollutantReleasesAreas.ascx" tagname="ucPollutantReleasesAreas" tagprefix="eprtr" %>
<%@ Register src="ucPollutantReleasesComparison.ascx" tagname="ucPollutantReleasesComparison" tagprefix="eprtr" %>
<%@ Register src="ucPollutantReleasesFacilities.ascx" tagname="ucPollutantReleasesFacilities" tagprefix="eprtr" %>
<%@ Register src="ucPollutantReleasesConfidentiality.ascx" tagname="ucPollutantReleasesConfidentiality" tagprefix="eprtr" %>
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
        <eprtr:SheetSubHeader ID="ucSheetSubHeader" runat="server" Text="<%$ Resources:Pollutant,AllValuesAreYearlyReleases %>"/>
    </div>

    <%-- sheets --%>
    <div class="layout_sheet_content">
        <eprtr:ucPollutantReleasesSummary ID="ucPollutantReleasesSummary" Visible="false" runat="server" />
        <eprtr:ucPollutantReleasesActivities ID="ucPollutantReleasesActivities" Visible="false" runat="server" />
        <eprtr:ucPollutantReleasesAreas ID="ucPollutantReleasesAreas" Visible="false" runat="server" />
        <eprtr:ucPollutantReleasesComparison ID="ucPollutantReleasesComparison" Visible="false" runat="server" />
        <eprtr:ucPollutantReleasesFacilities ID="ucPollutantReleasesFacilities" Visible="false" runat="server" />
        <eprtr:ucPollutantReleasesConfidentiality ID="ucPollutantReleasesConfidentiality" Visible="false" runat="server" />
    </div>
</div>