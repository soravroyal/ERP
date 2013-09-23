<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" MasterPageFile="~/MasterSearchPage.master" CodeFile="FacilityLevels.aspx.cs" Inherits="FacilityLevels" %>

<%@ Register src="~/UserControls/SearchFacility/ucFacilitySearch.ascx" tagname="ucFacilitySearch" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/SearchFacility/ucFacilityListSheet.ascx" tagname="ucFacilityListSheet" tagprefix="eprtr" %>


<asp:Content ID="cSubHeadlineFacility" ContentPlaceHolderID="ContentSubHeadline" runat="server">
    <asp:Literal ID="litHeaderFacility" Text="<%$ Resources:Facility,SubHeadline %>" runat="server" />
</asp:Content>
 
<asp:Content ID="cSearchFormFacility" ContentPlaceHolderID="ContentSearchForm" Runat="Server">
    <eprtr:ucFacilitySearch ID="ucSearchOptions" runat="server" />
</asp:Content>

<asp:Content ID="cResultAreaFacility" ContentPlaceHolderID="ContentResultArea" Runat="Server" >
    <eprtr:ucFacilityListSheet ID="ucFacilityListSheet" runat="server" />
</asp:Content>