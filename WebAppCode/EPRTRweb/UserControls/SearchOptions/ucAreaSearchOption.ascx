<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucAreaSearchOption.ascx.cs"
    Inherits="ucAreaSearchOption" %>



<%--Country--%>
<asp:Literal ID="litCountry" runat="server" Text="<%$ Resources:Common,Country %>" /><br />
<asp:DropDownList ID="cbFacilityCountry" runat="server" AutoPostBack="true" OnSelectedIndexChanged="onFacilityCountryChanged">
</asp:DropDownList>

<%--Region/River basin districy--%>
<div>
    <asp:RadioButtonList ID="rblRegionType" 
    RepeatDirection="Horizontal" 
    RepeatLayout="Flow" 
    OnSelectedIndexChanged = "onRegionTypeChanged"
    AutoPostBack="true"
    runat="server"/>
</div>

<asp:DropDownList ID="cbRegion" runat="server">
</asp:DropDownList>
