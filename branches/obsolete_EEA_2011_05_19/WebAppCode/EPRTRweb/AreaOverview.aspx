<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/MasterSearchPage.master" CodeFile="AreaOverview.aspx.cs" Inherits="AreaOverview" %>

<%@ Register src="~/UserControls/SearchAreaOverview/ucAreaOverviewSearch.ascx" tagname="ucAreaOverviewSearch" tagprefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchAreaOverview/ucAreaOverviewSheet.ascx" TagName="ucAreaOverviewSheet" tagPrefix="eprtr" %>


<asp:Content ID="cSubHeadline" ContentPlaceHolderID="ContentSubHeadline" runat="server">
    <asp:Literal ID="litHeaderArea" Text="<%$ Resources:AreaOverview,SubHeadline %>" runat="server" />
</asp:Content>

<asp:Content ID="cSearchForm" ContentPlaceHolderID="ContentSearchForm" Runat="Server">
    <eprtr:ucAreaOverviewSearch ID="ucSearchOptions" runat="server" />
</asp:Content>

<asp:Content ID="cResultArea" ContentPlaceHolderID="ContentResultArea" Runat="Server" >
  <eprtr:ucAreaOverviewSheet ID="ucAreaOverviewSheet" runat="server" />
</asp:Content>

