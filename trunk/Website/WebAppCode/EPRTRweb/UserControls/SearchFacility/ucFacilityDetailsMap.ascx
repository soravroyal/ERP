<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucFacilityDetailsMap.ascx.cs" Inherits="ucFacilityDetailsMap" %>
<%@ Register TagPrefix="nfp" TagName="NoFlashPlayer" Src="~/UserControls/Common/ucNoFlashPlayer.ascx" %>

<%-- detail map --%>
<asp:Panel ID="detailmapPanel" runat="server"  CssClass="facilityMap">
  <div id="facilitydetailmap" runat="server" visible="true">
     <nfp:NoFlashPlayer ID="NoFlashPlayer" runat="server" />
  </div>
  
</asp:Panel>

