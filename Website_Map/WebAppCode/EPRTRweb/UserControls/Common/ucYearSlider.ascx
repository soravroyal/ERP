<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucYearSlider.ascx.cs" Inherits="ucYearSlider" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>


<table id="yeartable" border="0" cellspacing="5">
  <tr>
  
    <%-- Year 1 --%>
    <td>
      
      <asp:TextBox ID="Slider1_BoundControl" runat="server" Width="30" BorderWidth="0" BorderStyle="None" Enabled="false"></asp:TextBox>
      <%-- Alternative to refresh button, add to Slider1: AutoPostBack="true" OnTextChanged="textchanged1" to Slider2 --%>
      <asp:TextBox ID="Slider1" runat="server"></asp:TextBox><br /> 
      <ajaxToolkit:SliderExtender ID="SliderExtender1" runat="server"  
                                  BehaviorID="Slider1"
                                  TargetControlID="Slider1"
                                  BoundControlID="Slider1_BoundControl"
                                  Orientation="Horizontal" Minimum="2004" Maximum="2007" Length="100"
                                  EnableHandleAnimation="true" />
    </td>

    <%-- Year 2 --%>
    <td>
      
      <asp:TextBox ID="Slider2_BoundControl" runat="server" Width="30" BorderWidth="0" BorderStyle="None" Enabled="false"></asp:TextBox>
      <%-- Alternative to refresh button, add to Slider2: AutoPostBack="true" OnTextChanged="textchanged2" to Slider2 --%>
      <asp:TextBox ID="Slider2" runat="server"></asp:TextBox><br /> 
      <ajaxToolkit:SliderExtender ID="SliderExtender2" runat="server"  
                                  BehaviorID="Slider2"
                                  TargetControlID="Slider2"
                                  BoundControlID="Slider2_BoundControl"
                                  Orientation="Horizontal" Minimum="2004" Maximum="2007" Length="100"
                                  EnableHandleAnimation="true" />

    </td>
    
    <td>
      <%-- Refresh button, logic to make sure year1 < year2 --%>
      <asp:Button ID="btnRefresh" OnClick="refresh" runat="server" Text="Refresh" />
    </td>

  </tr>
</table>

