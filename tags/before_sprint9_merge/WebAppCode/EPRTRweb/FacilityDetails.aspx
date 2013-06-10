<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="FacilityDetails.aspx.cs" Inherits="FacilityDetails" 
    %>

<%@ Register Src="~/UserControls/SearchFacility/ucFacilitySheet.ascx" TagName="FacilitySheet"   TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchFacilityEPER/ucFacilitySheetEPER.ascx" TagName="FacilitySheetEPER"    TagPrefix="eprtr" %>

<asp:Content ID="infoarea"  ContentPlaceHolderID="ContentInfoArea" runat="server">

<div id="facilityDetailsPage" class="info_box_search">
     <h1><asp:Literal ID="lbHeadline" runat="server" /></h1>

     <asp:UpdatePanel ID="upResultArea" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <%--Result area--%>
            <div id="resultArea" visible="true" runat="server">
                <eprtr:FacilitySheet ID="ucFacilitySheet" runat="server" />
                <eprtr:FacilitySheetEPER ID="ucFacilitySheetEPER" runat="server" />
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    
    </div>
</asp:Content>
