<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucMsgWasteValidation.ascx.cs" Inherits="ucMsgWasteValidation" %>


<div id="msgWasteValidation" style="display:none; width:280px;" class="resultSheet_alert">
  <asp:Image ID="imgAlert" ImageUrl="~/images/alert.png" AlternateText="alert" Visible="true" runat="server" />
	<asp:Literal ID="chckboxWarningLbl" runat="server" Text="<%$ Resources:Common,chcknoValidate %>"></asp:Literal>
	<div class="spacer"></div>
</div>
