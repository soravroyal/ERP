<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucConfidentialDisclaimer.ascx.cs" Inherits="ucConfidentialDisclaimer" %>

<div ID="divContent" runat="server" >
    <asp:Image ID="imgAlert" ImageUrl="~/images/alert.png" AlternateText="alert" Visible="true" runat="server" />
    <asp:LinkButton ID="lnbAlert" runat="server" OnClientClick="ShowWaitIndicator();" OnClick="onClick" Visible="true" ></asp:LinkButton>
</div>