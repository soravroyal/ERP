<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/MasterSearchPage.master" CodeFile="WasteTransfer.aspx.cs" Inherits="WasteTransfer"  %>

<%@ Register src="~/UserControls/SearchWaste/ucWasteTransfersSearch.ascx" tagname="WasteTransfersSearch" tagprefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchWaste/ucWasteTransferSheet.ascx" TagName="WasteTransfersSheet"    TagPrefix="eprtr" %>



<asp:Content ID="cSubHeadline" ContentPlaceHolderID="ContentSubHeadline" runat="server">
    <asp:Literal ID="litHeader" Text="<%$ Resources:WasteTransfers,WasteTransferSubHeadline %>" runat="server" />
</asp:Content>

<asp:Content ID="cSearchForm" ContentPlaceHolderID="ContentSearchForm" Runat="Server">
    <eprtr:WasteTransfersSearch ID="ucSearchOptions" runat="server" />
</asp:Content>

<asp:Content ID="cResultArea" ContentPlaceHolderID="ContentResultArea" Runat="Server" >
    <eprtr:WasteTransfersSheet ID="ucWasteTransfersSheet" runat="server" />
</asp:Content>


