<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucWasteTransferHazRecieverSheet.ascx.cs" Inherits="ucWasteTransferRecieverSheet" %>

<%@ Register src="~/UserControls/Common/ucSheetLinks.ascx" tagname="ucSheetLinks" tagprefix="eprtr" %>
<%@ Register src="ucWasteTransferHazRecieverConfidentiality.ascx" tagname="ucWasteTransferHazRecieverConfidentiality" tagprefix="eprtr" %>
<%@ Register src="ucWasteTransferHazRecieverTreatment.ascx" tagname="ucWasteTransferHazRecieverTreatment" tagprefix="eprtr" %>

<%@ Register src="~/UserControls/Common/ucDisclaimer.ascx" tagname="ucDisclaimer" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/Common/ucSheetTitleIcon.ascx" tagname="ucSheetTitleIcon" tagprefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucSheetSubHeader.ascx" TagName="SheetSubHeader" TagPrefix="eprtr" %>

<div class="look_sheet_level1">

    <div class="layout_sheet_header">
        <h2>
            <eprtr:ucSheetTitleIcon id="ucSheetTitleIcon" runat="server"></eprtr:ucSheetTitleIcon>
            <asp:Literal ID="litHeadline" Text="Header" runat="server" Visible="true"></asp:Literal>
        </h2>
    </div>

    <eprtr:ucSheetLinks ID="ucSheetLinks" runat="server" Visible="true" />

    <%-- sub info --%> 
    <div class="layout_sheet_subHeader">
        <eprtr:SheetSubHeader ID="ucSheetSubHeader" runat="server"/>
    </div>
    
    <div class="layout_sheet_content">
      <eprtr:ucWasteTransferHazRecieverTreatment ID="ucHazRecieverTreatment" Visible="false" runat="server" />      
      <eprtr:ucWasteTransferHazRecieverConfidentiality ID="ucHazRecieverConfidentiality" Visible="false" runat="server" />
    </div>
</div>

















