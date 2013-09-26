<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucPollutantSearchOption.ascx.cs"
    Inherits="ucPollutantSearchOptions" %>
    
    <asp:Literal ID="litPollutantGroup" runat="server" Text="<%$ Resources:Common,PollutantGroup %>"></asp:Literal><br />
    <asp:DropDownList ID="cbPollutantGroup" runat="server" 
        AutoPostBack="true" OnSelectedIndexChanged="onPollutantGroupChanged">
    </asp:DropDownList>

    <asp:Literal ID="litPollutant" runat="server" Text="<%$ Resources:Common,Pollutant %>"></asp:Literal><br />
    <asp:DropDownList ID="cbPollutant" runat="server" 
        OnSelectedIndexChanged="onPollutantChanged">
    </asp:DropDownList>
