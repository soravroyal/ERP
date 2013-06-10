<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/MasterSearchPage.master" CodeFile="IndustialActivity.aspx.cs" Inherits="IndustryActivity" %>

<%@ Register src="~/UserControls/SearchIndustryActivity/ucIndustrialActivitySearch.ascx" tagname="ucIndustryActivity" tagprefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchIndustryActivity/ucIndustrialActivitySheet.ascx" TagName="ucIndustrialActivitySheet" tagPrefix="eprtr" %>


<asp:Content ID="cSubHeadlineActivity" ContentPlaceHolderID="ContentSubHeadline" runat="server">
    <asp:Literal ID="litHeaderActivity" Text="<%$ Resources:IndustrialActivity,SubHeadline %>" runat="server" />
</asp:Content>

<asp:Content ID="cSearchFormActivity" ContentPlaceHolderID="ContentSearchForm" Runat="Server">
    <eprtr:ucIndustryActivity ID="ucSearchOptions" runat="server" />
</asp:Content>

<asp:Content ID="cResultAreaActivity" ContentPlaceHolderID="ContentResultArea" Runat="Server" >
  <eprtr:ucIndustrialActivitySheet ID="ucIndustrialActivitySheet" runat="server" />
</asp:Content>

