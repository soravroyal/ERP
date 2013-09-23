<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucWasteReceiverSearchOption.ascx.cs" Inherits="ucWasteReceiverSearchOption" %>

<%--Waste receivers--%>
<div id="searchOption_wasteReceiver">
<asp:Literal ID="litCountry" runat="server" Text="<%$ Resources:Common,ReceivingCountry%>" /><br />
<asp:DropDownList ID="cbReceivingCountry" runat="server" AutoPostBack="false">
</asp:DropDownList>
</div>
