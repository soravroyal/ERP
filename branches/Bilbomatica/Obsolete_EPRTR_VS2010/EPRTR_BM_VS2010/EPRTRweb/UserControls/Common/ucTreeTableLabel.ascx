<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucTreeTableLabel.ascx.cs" EnableViewState="true" Inherits="ucTreeTableLabel" %>

<div id="divTreeLabel" runat="server">

    <asp:ImageButton ID="Image" ImageUrl="~/images/minus.gif" Visible="false" runat="server" ToolTip="<%# ToolTipText %>"/>
    <asp:LinkButton ID="lnkButton" OnClientClick="ShowWaitIndicator();" visible="false" runat="server" ToolTip="<%# ToolTipText %>"/>
    <asp:Label ID="lbSub" visible="false" runat="server"></asp:Label>

</div>




