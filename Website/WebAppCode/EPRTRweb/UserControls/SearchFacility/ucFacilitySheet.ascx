

<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucFacilitySheet.ascx.cs" Inherits="ucFacilitySheet" %>

<%@ Register src="~/UserControls/Common/ucSheetLinks.ascx" tagname="ucSheetLinks" tagprefix="eprtr" %>
<%@ Register src="ucFacilityDetails.ascx" tagname="ucFacilityDetails" tagprefix="eprtr" %>
<%@ Register src="ucFacilityPollutantReleases.ascx" tagname="ucFacilityPollutantReleases" tagprefix="eprtr" %>
<%@ Register src="ucFacilityPollutantTransfers.ascx" tagname="ucFacilityPollutantTransfers" tagprefix="eprtr" %>
<%@ Register src="ucFacilityWaste.ascx" tagname="ucFacilityWaste" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/SearchFacility/ucFacilityConfidentiality.ascx" tagname="ucFacilityConfidentiality" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/Common/ucDisclaimer.ascx" tagname="ucDisclaimer" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/Common/ucSheetTitleIcon.ascx" tagname="ucSheetTitleIcon" tagprefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucInfo.ascx" TagName="Info" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucSheetSubHeader.ascx" TagName="SheetSubHeader" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucDetailPrint.ascx" TagName="ucDetailPrint" TagPrefix="eprtr" %>

<div class="look_sheet_level1">

    <div class="layout_sheet_header">
        <h2>
            <eprtr:ucSheetTitleIcon id="ucSheetTitleIcon" runat="server"></eprtr:ucSheetTitleIcon>
            <asp:Literal ID="litHeadline" Text="Header" runat="server" Visible="true"></asp:Literal>
        </h2>
        
        <div id="divYearLinks" class="facilitySheet_Years" Visible="false" runat="server">
            <asp:LinkButton ID="lnbPrevious" Text="<%$ Resources:Facility,PreviousYear %>" Visible="false" OnClick="OnClickPrevious" OnClientClick="ShowWaitIndicator();"  runat="server"></asp:LinkButton>
            <asp:Literal ID="litYear" Visible="true" runat="server" ></asp:Literal>
            <asp:LinkButton ID="lnbNext" Text="<%$ Resources:Facility,NextYear %>" Visible="false" OnClick="OnClickNext" OnClientClick="ShowWaitIndicator();" runat="server"></asp:LinkButton>
        </div>

    </div>

    <eprtr:ucSheetLinks ID="ucSheetLinks" runat="server" Visible="true" />
    
    <%-- download and print icons --%>
    <div class="layout_sheet_download_print">
      <eprtr:ucDetailPrint ID="ucDetailPrint" Visible="true" runat="server" />
    </div>

    <div class="layout_sheet_subHeader">
        <eprtr:SheetSubHeader ID="ucSheetSubHeader" runat="server"/>
        <eprtr:Info ID="ucInfo" CssClass="resultSheet_info" Visible="false" runat="server" />
    </div>
    
    <%-- sub sheets --%>
    <div class="layout_sheet_content">
      <eprtr:ucFacilityPollutantReleases ID="ucFacilityPollutantReleases" Visible="false" runat="server" />      
      <eprtr:ucFacilityPollutantTransfers ID="ucFacilityPollutantTransfers" Visible="false" runat="server" />      
      <eprtr:ucFacilityWaste ID="ucFacilityWaste" Visible="false" runat="server" />      
      <eprtr:ucFacilityConfidentiality ID="ucFacilityConfidentiality" Visible="false" runat="server" />
      <eprtr:ucFacilityDetails ID="ucFacilityDetails" Visible="false" runat="server" />     
      <eprtr:ucDisclaimer id="ucDisclaimer" Visible="true" runat="server" />      
    </div>
</div>

















