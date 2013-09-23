<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/MasterSearchPage.master" CodeFile="TimeSeriesPollutantReleases.aspx.cs" Inherits="TimeSeriesPollutantReleases" %>

<%@ Register Src="~/UserControls/TimeSeries/ucTsPollutantReleasesSearch.ascx" TagName="ucTsPollutantReleasesSearch" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/TimeSeries/ucTsPollutantReleasesSheet.ascx" TagName="ucTsPollutantReleasesSheet" TagPrefix="eprtr" %>

<asp:Content ID="cSubHeadline" ContentPlaceHolderID="ContentSubHeadline" runat="server">
    <asp:Literal ID="litHeader" Text="<%$ Resources:Facility,PollutantReleaseTimeSeriesSubHeadline %>" runat="server" />
</asp:Content>

<asp:Content ID="cSearchForm" ContentPlaceHolderID="ContentSearchForm" Runat="Server">
    <eprtr:ucTsPollutantReleasesSearch ID="ucSearchOptions" runat="server" />
</asp:Content>

<asp:Content ID="cResultArea" ContentPlaceHolderID="ContentResultArea" Runat="Server" >
  <eprtr:ucTsPollutantReleasesSheet ID="ucTsPollutantReleasesSheet" runat="server" />   
</asp:Content>

