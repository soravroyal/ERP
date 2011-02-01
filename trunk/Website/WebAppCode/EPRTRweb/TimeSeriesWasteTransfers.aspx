<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/MasterSearchPage.master" CodeFile="TimeSeriesWasteTransfers.aspx.cs" Inherits="TimeSeriesWasteTransfers" %>

<%@ Register Src="~/UserControls/TimeSeries/ucTsWasteTransfersSearch.ascx" TagName="ucTsWasteTransfersSearch" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/TimeSeries/ucTsWasteTransfersSheet.ascx" TagName="ucTsWasteTransfersSheet" TagPrefix="eprtr" %>

<asp:Content ID="cSubHeadline" ContentPlaceHolderID="ContentSubHeadline" runat="server">
    <asp:Literal ID="litHeader" Text="<%$ Resources:Facility, WasteTransfersTimeSeriesSubHeadline %>" runat="server" />
</asp:Content>

<asp:Content ID="cSearchForm" ContentPlaceHolderID="ContentSearchForm" Runat="Server">
    <eprtr:ucTsWasteTransfersSearch ID="ucSearchOptions" runat="server" />
</asp:Content>

<asp:Content ID="cResultArea" ContentPlaceHolderID="ContentResultArea" Runat="Server" >
  <eprtr:ucTsWasteTransfersSheet ID="ucTsWasteTransfersSheet" runat="server" />   
  
</asp:Content>

