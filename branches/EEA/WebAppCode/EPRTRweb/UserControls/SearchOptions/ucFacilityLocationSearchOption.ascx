<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucFacilityLocationSearchOption.ascx.cs" Inherits="ucFacilityLocationSearchOption" %>

<%--Facility name and town--%>
<div id="searchOption_facilityname">
    <asp:Literal ID="litFacilityName" runat="server" Text="<%$ Resources:Common,FacilityName %>"></asp:Literal><br />
    <asp:TextBox ID="txFacilityName" runat="server"></asp:TextBox>
</div>
<div id="searchOption_town">
    <asp:Literal ID="litTown" runat="server" Text="<%$ Resources:Common,TownVillage %>"></asp:Literal><br />
    <asp:TextBox ID="txFacilityTown" runat="server"></asp:TextBox>
</div>
