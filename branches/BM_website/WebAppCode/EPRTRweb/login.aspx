<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" Trace="false" TraceMode="SortByTime" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width: 649px;margin:0 auto;">
        <br />
        <div style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 0.8em;">
            <asp:Literal ID="LoginHeaderText" runat="server" Text="<%$ Resources:Common, LoginHeaderText%>" />
        </div>
        <br />
    
        <asp:Login ID="Login1" runat="server" BackColor="#F7F6F3" BorderColor="#E6E2D8" 
            BorderPadding="4" BorderStyle="Solid" BorderWidth="1px" 
            DestinationPageUrl="~/Home.aspx" FailureAction="RedirectToLoginPage" 
            Font-Names="Verdana" Font-Size="0.8em" ForeColor="#333333" 
            MembershipProvider="EEAMembershipProvider">
            <TextBoxStyle Font-Size="0.8em" />
            <LoginButtonStyle BackColor="#FFFBFF" BorderColor="#CCCCCC" BorderStyle="Solid" 
                BorderWidth="1px" Font-Names="Verdana" Font-Size="0.8em" ForeColor="#284775" />
            <InstructionTextStyle Font-Italic="True" ForeColor="Black" />
            <TitleTextStyle BackColor="#5D7B9D" Font-Bold="True" Font-Size="0.9em" 
                ForeColor="White" />
        </asp:Login>
        <br />
        <asp:LoginView ID="LoginView1" runat="server">
            <LoggedInTemplate>
            <div style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 0.8em;">
              Hi  <asp:LoginName ID="LoginName1" runat="server" />, you have successfully logged in.
              Click here to go the E-PRTR <a href="Home.aspx">homepage</a>. 
              </div>
              <asp:Button ID="btnLogout" runat="server" onclick="btnLogout_Click" Text="Logout" />
            </LoggedInTemplate>
            <AnonymousTemplate>
                
            </AnonymousTemplate>
        </asp:LoginView>
        <br/>
        <br/>
        <div style="font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 0.8em;">
        <asp:Label ID="disclaimer" runat="server" Text="<%$ Resources:Common, LoginDisclaimerText  %>" /><br/>
        <br/>
        <asp:Label ID="contact1" runat="server" Text="<%$ Resources:Common,Contact1  %>" /><br/>
        <asp:Label ID="contact2" runat="server" Text="<%$ Resources:Common,Contact2  %>" />
        </div>
    </div>
    </form>
</body>
</html>
