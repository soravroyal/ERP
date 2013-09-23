<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucInfo.ascx.cs" Inherits="ucInfo" %>

<div ID="divInfo" runat="server">
<asp:HyperLink ID="lnkInfo" ToolTip="" NavigateUrl="" Target="_blank" runat="server" >
    <asp:Image ID="imgInfo" runat="server" />
    <asp:Literal ID="litLinkText" runat="server" Text=""></asp:Literal>
</asp:HyperLink>
<asp:Literal ID="litText" runat="server" Mode="Transform" Text=""></asp:Literal>
    
</div>