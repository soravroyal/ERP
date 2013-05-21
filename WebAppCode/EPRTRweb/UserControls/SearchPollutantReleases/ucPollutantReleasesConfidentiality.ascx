<%@ Control Language="C#" AutoEventWireup="true"  EnableViewState="true" CodeFile="ucPollutantReleasesConfidentiality.ascx.cs" Inherits="ucPollutantReleasesConfidentiality" %>

<div runat="server" id="divNoConfidentialityInformation">
    <asp:Literal ID="noConfidentialityInformation" Text="<%$ Resources:Confidentiality, NoConfidentialityInformation %>" runat="server" />
</div>

<div runat="server" id="divConfidentialityInformation">
<br />
<asp:Literal ID="litConfidentialityExplanation1" runat="server" Mode="Transform" Text=""></asp:Literal>
<br />
<br />
<div>
<asp:ListView ID="lvPollutantReleasesConfidentialPollutant" OnDataBinding="OnDataBindingConf" runat="server">

      <LayoutTemplate>
       <table>
         <thead>
          <tr class="generalListStyle_headerRow">
            <th><div class="PRcolConfName"><asp:Label ID="lbPollutant" Text="<%$ Resources:Common,Pollutant %>" runat="server"></asp:Label></div></th>
            <th><div id="divHeaderAir" class="PRcolConfAir" runat="server"><asp:Label ID="lbFacilitiesAir" Text="<%$ Resources:Facility,FacilitiesAir %>" runat="server"></asp:Label></div></th>
            <th><div id="divHeaderWater" class="PRcolConfWater" runat="server"><asp:Label ID="lbFacilitiesWater" Text="<%$ Resources:Facility,FacilitiesWater %>" runat="server"></asp:Label></div></th>
            <th><div id="divHeaderSoil" class="PRcolConfSoil" runat="server"><asp:Label ID="lbFacilitiesSoil" Text="<%$ Resources:Facility,FacilitiesSoil %>" runat="server"></asp:Label></div></th>
          </tr>
         </thead>
         <tbody>
          <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
         </tbody>
       </table>
      </LayoutTemplate>
        
      <ItemTemplate>
        <tr class="generalListStyle_row">
          <td title="<%# GetPollutantName(Container.DataItem)%>">           <div class="PRcolConfName"><%# GetPollutantName(Container.DataItem)%> </div></td>                                                       
          <td title="<%# GetFacilitiesAir(Container.DataItem)%>">  <div class="PRcolConfAir" visible="<%# ShowAir%>" runat="server"><%# GetFacilitiesAir(Container.DataItem)%></div></td>
          <td title="<%# GetFacilitiesWater(Container.DataItem)%>"><div class="PRcolConfWater" visible="<%# ShowWater%>" runat="server"><%# GetFacilitiesWater(Container.DataItem)%></div></td>
          <td title="<%# GetFacilitiesSoil(Container.DataItem)%>"> <div class="PRcolConfSoil" visible="<%# ShowSoil%>" runat="server"><%# GetFacilitiesSoil(Container.DataItem)%></div></td>
        </tr>
      </ItemTemplate>
      
      <EmptyDataTemplate>
        <div style="border-bottom:none;">
          <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
        </div>
      </EmptyDataTemplate>
      
</asp:ListView>
</div>
<br />
<br />
<asp:Literal ID="litReasonDesc" runat="server" Text="<%$ Resources:Pollutant,ConfidentialityReason %>"></asp:Literal>
<br />
<br />
<div>
<asp:ListView ID="lvPollutantReleasesConfidentialReason" OnDataBinding="OnDataBindingReason" runat="server">

      <LayoutTemplate>
       <table>
         <thead>
          <tr class="generalListStyle_headerRow">
            <%-- <th><asp:Label ID="lbImage" Text="" runat="server"></asp:Label></th> --%>
            <th><div class="PRcolConfName"><asp:Label ID="lbReason" Text="<%$ Resources:Common,Reason %>" runat="server"></asp:Label></div></th>
            <th><div id="divReasonHeaderAir" class="PRcolConfAir" runat="server"><asp:Label ID="lbFacilitiesAir" Text="<%$ Resources:Facility,FacilitiesAir %>" runat="server"></asp:Label></div></th>
            <th><div id="divReasonHeaderWater" class="PRcolConfWater" runat="server"><asp:Label ID="lbFacilitiesWater" Text="<%$ Resources:Facility,FacilitiesWater %>" runat="server"></asp:Label></div></th>
            <th><div id="divReasonHeaderSoil" class="PRcolConfSoil" runat="server"><asp:Label ID="lbFacilitiesSoil" Text="<%$ Resources:Facility,FacilitiesSoil %>" runat="server"></asp:Label></div></th>
          </tr>
         </thead>
         <tbody>
          <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
         </tbody>
       </table>
      </LayoutTemplate>
        
      <ItemTemplate>
        <tr class="generalListStyle_row">
          <td title="<%# GetReason(Container.DataItem)%>"><div class="PRcolConfName"><%# GetReason(Container.DataItem)%></div></td>
          <td title="<%# GetFacilitiesAir(Container.DataItem)%>"><div class="PRcolConfAir" visible="<%# ShowAir%>" runat="server"><%# GetFacilitiesAir(Container.DataItem)%></div></td>
          <td title="<%# GetFacilitiesWater(Container.DataItem)%>"><div class="PRcolConfWater" visible="<%# ShowWater%>" runat="server"><%# GetFacilitiesWater(Container.DataItem)%></div></td>
          <td title="<%# GetFacilitiesSoil(Container.DataItem)%>"><div class="PRcolConfSoil" visible="<%# ShowSoil%>" runat="server"><%# GetFacilitiesSoil(Container.DataItem)%></div></td>
        </tr>
      </ItemTemplate>
      
      <EmptyDataTemplate>
        <div style="border-bottom:none;">
          <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
        </div>
      </EmptyDataTemplate>
      
</asp:ListView>
<br />
<asp:Literal ID="litConfidentialityExplanation2" runat="server" Mode="Transform" Text=""></asp:Literal>

</div>
</div>