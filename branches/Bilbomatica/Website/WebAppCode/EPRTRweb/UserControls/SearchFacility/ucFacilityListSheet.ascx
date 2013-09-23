<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucFacilityListSheet.ascx.cs" Inherits="ucFacilityListSheet" %>

<%@ Register src="~/UserControls/Common/ucSheetLinks.ascx" TagName="ucSheetLinks" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchFacility/ucFacilityListConfidentiality.ascx" TagName="ucFacilityListConfidentiality" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchFacility/ucFacilityListResult.ascx" TagName="ucFacilityListResult" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucSheetSubHeader.ascx" TagName="SheetSubHeader" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucDownloadPrint.ascx" TagName="ucDownloadPrint" TagPrefix="eprtr" %>

<div class="look_sheet_level0">
    <%-- Headline --%>
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

    <%-- sheet panel --%>
      <div class="layout_sheet_content">
        <eprtr:ucFacilityListResult ID="ucFacilityListResult" Visible="false" runat="server" />
        <eprtr:ucFacilityListConfidentiality ID="ucFacilityListConfidentiality" Visible="false" runat="server" />      
      </div>
</div>