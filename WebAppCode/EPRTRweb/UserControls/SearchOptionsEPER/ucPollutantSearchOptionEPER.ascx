<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucPollutantSearchOptionEPER.ascx.cs"
    Inherits="ucPollutantSearchOptionsEPER" %>
    
    <asp:Literal ID="litPollutantGroup" runat="server" Text="<%$ Resources:Common,EmissionGroup %>"></asp:Literal><br />
    <asp:DropDownList ID="cbPollutantGroup" runat="server" 
        AutoPostBack="true" OnSelectedIndexChanged="onPollutantGroupChanged">
    </asp:DropDownList>

    <asp:Literal ID="litPollutant" runat="server" Text="<%$ Resources:Common,ContentEmissions %>"></asp:Literal><br />
    <asp:DropDownList ID="cbPollutant" runat="server" 
        OnSelectedIndexChanged="onPollutantChanged">
    </asp:DropDownList>
