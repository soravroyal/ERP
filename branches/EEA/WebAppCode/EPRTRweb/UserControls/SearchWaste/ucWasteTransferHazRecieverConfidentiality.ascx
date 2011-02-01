<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucWasteTransferHazRecieverConfidentiality.ascx.cs" Inherits="ucWasteTransferHazRecieverConfidentiality" %>

<div runat="server" id="divNoConfidentialityInformation">
    <br />
    <asp:Literal ID="noConfidentialityInformation" Text="<%$ Resources:Confidentiality, NoConfidentialityInformation %>" runat="server" />
    <br />
   <br />
</div>

<div runat="server" id="divConfidentialityInformation">
<br />
<asp:Literal ID="litConfidentialityExplanation1" runat="server" Mode="Transform" Text=""></asp:Literal>
<br />
<br />

<%-- Waste Transfers Haz Receivers Reporting --%>
<div>
<asp:ListView ID="lvWasteTransHazReceiversReporting" runat="server">
  
    <LayoutTemplate>
     <table>
       <thead>
        <tr class="generalListStyle_headerRow">
          <th><asp:Label ID="lbReason" Text="<%$ Resources:WasteTransfers,NoFacilitiesReporting %>" runat="server"></asp:Label></th>
          <th><asp:Label ID="lbFacilities" Text="<%$ Resources:Facility,Facilities %>" runat="server"></asp:Label></th>
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
          <td style="width:350px"><%# GetHeader(Container.DataItem)%></td>
          <td style="width:140px"><%# GetFacilities(Container.DataItem)%></td>
        </tr>
      </ItemTemplate>

    <EmptyDataTemplate>
      <div class="noResult">
          <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
      </div>
    </EmptyDataTemplate>
    
</asp:ListView>

<br />
<br />
<asp:Literal ID="litConfidentialityClaimed" runat="server" Text="<%$ Resources:Common,ConfidentialityClaimed %>"></asp:Literal>
<br />
<br />

<%-- Waste Transfers Haz Receivers Reason --%>
<asp:ListView ID="lvWasteTransHazReceiversReason" runat="server">
  
    <LayoutTemplate>
     <table>
       <thead>
        <tr class="generalListStyle_headerRow">
          <th><asp:Label ID="lbReason" Text="<%$ Resources:Common,Reason %>" runat="server"></asp:Label></th>
          <th><asp:Label ID="lbFacilities" Text="<%$ Resources:Facility,Facilities %>" runat="server"></asp:Label></th>
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
          <td style="width:350px"><%# GetReason(Container.DataItem)%></td>
          <td style="width:140px"><%# GetFacilities(Container.DataItem)%></td>
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
<asp:Literal ID="litConfidentialityExplanation2" runat="server" Mode="Transform" Text=""></asp:Literal>
<br />
<br />
</div>

