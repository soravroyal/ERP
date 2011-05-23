<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/MasterSearchPage.master"
    CodeFile="PollutantTransfers.aspx.cs" Inherits="PollutantTransfers" %>

<%@ Register Src="~/UserControls/SearchPollutantTransfers/ucPollutantTransfersSearch.ascx" TagName="PollutantTransfersSearch"
    TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchPollutantTransfers/ucPollutantTransfersSheet.ascx" TagName="PollutantTransfersSheet"
    TagPrefix="eprtr" %>

  
<asp:Content ID="cSubHeadline" ContentPlaceHolderID="ContentSubHeadline" runat="server">
    <asp:Literal ID="litHeader" Text="<%$ Resources:Pollutant,AggregatedTransfersToWasteWater %>" runat="server" />
</asp:Content>

<asp:Content ID="cSearchForm" ContentPlaceHolderID="ContentSearchForm" Runat="Server">
    <eprtr:PollutantTransfersSearch ID="ucSearchOptions" runat="server" />
</asp:Content>

<asp:Content ID="cResultArea" ContentPlaceHolderID="ContentResultArea" Runat="Server" >
    <eprtr:PollutantTransfersSheet ID="ucPollutantTransfersSheet" runat="server" />
</asp:Content>