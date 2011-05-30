<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucWasteTransferConfidentiality.ascx.cs" Inherits="ucWasteTransferConfidentiality" %>

<div runat="server" id="divNoConfidentialityInformation">
    <asp:Literal ID="noConfidentialityInformation" Text="<%$ Resources:Confidentiality, NoConfidentialityInformation %>" runat="server" />
</div>

<div runat="server" id="divConfidentialityInformation">
<br />
<asp:Literal ID="litConfidentialityExplanation1" runat="server" Mode="Transform" Text=""></asp:Literal>
<br />
<br />
<div>
<%-- Confidentiality Facilities --%>
<asp:ListView ID="lvWasteConfidentialityFacilities" OnDataBinding="OnDataBindingConf" runat="server">
  
    <LayoutTemplate>
     <table>
       <thead>
        <tr class="generalListStyle_headerRow">
          <th><div class="WTcolConfName"><asp:Label ID="lbEmpty" Text="" runat="server"></asp:Label></div></th>
          <th><div id="divHeaderNonHW" class="WTcolConfNonHW" runat="server"><asp:Label ID="lbNonHazardous" Text="<%$ Resources:LOV_WASTETYPE, NON-HW %>" runat="server"></asp:Label> <br/> <asp:Label ID="lbFacilities" Text="<%$ Resources:Facility,Facilities %>" runat="server"></asp:Label></div></th>
          <th><div id="divHeaderHWIC" class="WTcolConfHWIC" runat="server"><asp:Label ID="lbHazardousIC" Text="<%$ Resources:LOV_WASTETYPE, HWIC %>" runat="server"></asp:Label> <br/> <asp:Label ID="lbFacilities2" Text="<%$ Resources:Facility,Facilities %>" runat="server"></asp:Label></div></th>
          <th><div id="divHeaderHWOC" class="WTcolConfHWOC" runat="server"><asp:Label ID="lbHazardousOC" Text="<%$ Resources:LOV_WASTETYPE, HWOC %>" runat="server"></asp:Label> <br/> <asp:Label ID="lbFacilities3" Text="<%$ Resources:Facility,Facilities %>" runat="server"></asp:Label></div></th>
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
          <td><div class="WTcolConfName"><%# GetFacilitiesDesc(Container.DataItem)%></div></td>
          <td><div class="WTcolConfNonHW" visible="<%# ShowNonHW%>" runat="server"><%# GetFacilitiesNonHW(Container.DataItem)%></div></td>
          <td><div class="WTcolConfHWIC" visible="<%# ShowHWIC%>" runat="server"><%# GetFacilitiesHWIC(Container.DataItem)%></div></td>
          <td><div class="WTcolConfHWOC" visible="<%# ShowHWOC%>" runat="server"><%# GetFacilitiesHWOC(Container.DataItem)%></div></td>
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
<asp:Literal ID="litReasonDesc" runat="server" Text="<%$ Resources:Common,ConfidentialityClaimed %>"></asp:Literal>
<br />
<br />

<%-- Confidentiality Reason --%>
<div>
<asp:ListView ID="lvWasteConfidentialityReason" runat="server">
  
    <LayoutTemplate>
     <table>
       <thead>
        <tr class="generalListStyle_headerRow">
          <th><div class="WTcolConfWasteType"><asp:Label ID="lbWasteType" Text="<%$ Resources:Common,WasteType %>" runat="server"></asp:Label></div></th>
          <th><div class="WTcolConfReason"><asp:Label ID="lbReason" Text="<%$ Resources:Common,Reason %>" runat="server"></asp:Label></div></th>
          <th><div class="WTcolConfFacilities" ><asp:Label ID="lbFacilities" Text="<%$ Resources:Facility,Facilities %>" runat="server"></asp:Label></div></th>
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
          <td><div class="WTcolConfWasteType" ><%# GetReasonWasteType(Container.DataItem)%></div></td>
          <td><div class="WTcolConfReason" ><%# GetReason(Container.DataItem)%></div></td>
          <td><div class="WTcolConfFacilities" ><%# GetReasonFacilities(Container.DataItem)%></div></td>
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


