<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/MasterSearchPage.master" CodeFile="PollutantReleases.aspx.cs" Inherits="PollutantReleases" %>

<%@ Register Src="~/UserControls/SearchPollutantReleases/ucPollutantReleasesSearch.ascx" TagName="PollutantReleasesSearch" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchPollutantReleases/ucPollutantReleasesSheet.ascx" TagName="ucPollutantReleasesSheet" TagPrefix="eprtr" %>


<asp:Content ID="cSubHeadline" ContentPlaceHolderID="ContentSubHeadline" runat="server">
    <asp:Literal ID="litHeader" Text="<%$ Resources:Pollutant,PollutantReleasesSubHeadline %>" runat="server" />
</asp:Content>

<asp:Content ID="cSearchForm" ContentPlaceHolderID="ContentSearchForm" Runat="Server">
    <eprtr:PollutantReleasesSearch ID="ucSearchOptions" runat="server" />
</asp:Content>

<asp:Content ID="cResultArea" ContentPlaceHolderID="ContentResultArea" Runat="Server" >
  <eprtr:ucPollutantReleasesSheet ID="ucPollutantReleasesSheet" runat="server" />   
</asp:Content>

