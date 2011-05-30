<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/MasterSearchPage.master" CodeFile="TimeSeriesPollutantTransfers.aspx.cs" Inherits="TimeSeriesPollutantTransfers" %>

<%@ Register Src="~/UserControls/TimeSeries/ucTsPollutantTransfersSearch.ascx" TagName="ucTsPollutantTransfersSearch" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/TimeSeries/ucTsPollutantTransfersSheet.ascx" TagName="ucTsPollutantTransfersSheet" TagPrefix="eprtr" %>

<asp:Content ID="cSubHeadline" ContentPlaceHolderID="ContentSubHeadline" runat="server">
    <asp:Literal ID="litHeader" Text="<%$ Resources:Facility,PollutantTransfersTimeSeriesSubHeadline %>" runat="server" />
</asp:Content>

<asp:Content ID="cSearchForm" ContentPlaceHolderID="ContentSearchForm" Runat="Server">
    <eprtr:ucTsPollutantTransfersSearch ID="ucSearchOptions" runat="server" />
</asp:Content>

<asp:Content ID="cResultArea" ContentPlaceHolderID="ContentResultArea" Runat="Server" >
  <eprtr:ucTsPollutantTransfersSheet ID="ucTsPollutantTransfersSheet" runat="server" />   
  
</asp:Content>

