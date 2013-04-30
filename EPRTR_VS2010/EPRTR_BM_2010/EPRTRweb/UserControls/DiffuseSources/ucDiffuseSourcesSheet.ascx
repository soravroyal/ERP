<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucDiffuseSourcesSheet.ascx.cs" Inherits="UserControls_DiffuseSources_ucDiffuseSourcesSheet" %>

<%@ Register src="~/UserControls/Common/ucSheetLinks.ascx" TagName="ucSheetLinks" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucSheetSubHeader.ascx" TagName="SheetSubHeader" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucDownloadPrint.ascx" TagName="DownloadPrint" TagPrefix="eprtr" %>

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
      <eprtr:DownloadPrint ID="ucDownloadPrint" Visible="true" runat="server" />
    </div>

    <div class="layout_sheet_subHeader">
        <eprtr:SheetSubHeader ID="ucSheetSubHeader" runat="server"/>
    </div>

    <%-- sheet panel --%>
      <div class="layout_sheet_content">
        <asp:Panel ID="diffuseSourcesContent"  class="diffuseContent" runat="server" Width="100%">
            <br />
            <asp:Literal ID="lbDiffuseContent" Text="" Mode="Transform" runat="server"></asp:Literal>
            <br /> 
        </asp:Panel>
      </div>
</div>