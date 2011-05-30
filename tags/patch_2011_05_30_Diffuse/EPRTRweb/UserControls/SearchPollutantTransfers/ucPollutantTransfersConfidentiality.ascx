<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucPollutantTransfersConfidentiality.ascx.cs" Inherits="ucPollutantTransfersConfidentiality" %>

<div runat="server" id="divNoConfidentialityInformation">
    <asp:Literal ID="noConfidentialityInformation" Text="<%$ Resources:Confidentiality, NoConfidentialityInformation %>" runat="server" />
</div>

<div runat="server" id="divConfidentialityInformation">
<br />
<asp:Literal ID="litConfidentialityExplanation1" runat="server" Mode="Transform" Text=""></asp:Literal>
<br />
<br />
<div>
<asp:ListView ID="lvPollutantTransfersPollutant" runat="server">
  
    <LayoutTemplate>
     <table>
       <thead>
        <tr class="generalListStyle_headerRow">
          <th><div class="PTcolConfName"><asp:Label ID="lbDescription" Text="<%$ Resources:Common, Pollutant %>" runat="server"></asp:Label></div></th>
          <th><div class="PTcolConfFacilities"><asp:Label ID="lbFacilities" Text="<%$ Resources:Pollutant, Facilities %>" runat="server"></asp:Label></div></th>
        </tr>
       </thead>
       
       <tbody>
        <asp:PlaceHolder id="itemPlaceholder" runat="server" >
        </asp:PlaceHolder>
       </tbody>
     </table>
    
    </LayoutTemplate>
    
    <ItemTemplate>
        <tr class="generalListStyle_row">
        
          <td><div class="PTcolConfName"><%# GetPollutantName(Container.DataItem)%></div></td>
          <td><div class="PTcolConfFacilities"><%# GetFacilities(Container.DataItem)%></div></td>
        </tr>
      </ItemTemplate>

    <EmptyDataTemplate>
      <div class="noResult">
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
<asp:ListView ID="lvPollutantTransfersReason" runat="server">
  
    <LayoutTemplate>
     <table>
       <thead>
        <tr class="generalListStyle_headerRow">
          <th><div class="PTcolConfName"><asp:Label ID="lbDescription" Text="<%$ Resources:Common,Reason %>" runat="server"></asp:Label></div></th>
          <th><div class="PTcolConfFacilities"><asp:Label ID="lbFacilities" Text="<%$ Resources:Pollutant,Facilities %>" runat="server"></asp:Label></div></th>
        </tr>
       </thead>
       
       <tbody>
        <asp:PlaceHolder id="itemPlaceholder" runat="server" >
        </asp:PlaceHolder>
       </tbody>
     </table>
    
    </LayoutTemplate>
    
    <ItemTemplate>
        <tr class="generalListStyle_row">
          <td><div class="PTcolConfName"><%# GetReason(Container.DataItem)%></div></td>
          <td><div class="PTcolConfFacilities"><%# GetFacilities(Container.DataItem)%></div></td>
        </tr>
      </ItemTemplate>

    <EmptyDataTemplate>
      <div class="noResult">
          <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
      </div>
    </EmptyDataTemplate>
    
</asp:ListView>
<br />
<asp:Literal ID="litConfidentialityExplanation2" runat="server" Mode="Transform" Text=""></asp:Literal>

</div>
</div>
