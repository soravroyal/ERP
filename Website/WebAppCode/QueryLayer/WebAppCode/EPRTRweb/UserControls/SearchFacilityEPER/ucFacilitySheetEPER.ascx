<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucFacilitySheetEPER.ascx.cs" Inherits="ucFacilitySheetEPER" %>

<%@ Register src="~/UserControls/Common/ucSheetLinks.ascx" tagname="ucSheetLinks" tagprefix="eprtr" %>
<%@ Register src="ucFacilityDetailsEPER.ascx" tagname="ucFacilityDetailsEPER" tagprefix="eprtr" %>
<%@ Register src="ucFacilityEmissionsEPER.ascx" tagname="ucFacilityEmissionsEPER" tagprefix="eprtr" %>
<%@ Register src="ucFacilityEmissionsTransfersEPER.ascx" tagname="ucFacilityEmissionsTransfersEPER" tagprefix="eprtr" %>

<%@ Register src="~/UserControls/Common/ucDisclaimerEPER.ascx" tagname="ucDisclaimerEPER" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/Common/ucSheetTitleIcon.ascx" tagname="ucSheetTitleIcon" tagprefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucInfoEPER.ascx" TagName="Info" TagPrefix="eprtr" %>
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
        <eprtr:Info ID="ucInfoEPER" CssClass="resultSheet_info" Visible="false" runat="server" />
    </div>
    

    <%-- sub sheets --%>
    <div class="layout_sheet_content">
 
      <eprtr:ucFacilityDetailsEPER ID="ucFacilityDetailsEPER" Visible="false" runat="server" />  
      <eprtr:ucFacilityEmissionsEPER ID="ucFacilityEmissionsEPER" Visible="false" runat="server" />      
      <eprtr:ucFacilityEmissionsTransfersEPER ID="ucFacilityEmissionsTransfersEPER" Visible="false" runat="server" />      
      <eprtr:ucDisclaimerEPER id="ucDisclaimerEPER" Visible="true" runat="server" /> 
   
         
   
    </div>
    
     <input ID="TextBox1" runat="server" style="visibility:hidden; height:0px;"/>
</div>

















