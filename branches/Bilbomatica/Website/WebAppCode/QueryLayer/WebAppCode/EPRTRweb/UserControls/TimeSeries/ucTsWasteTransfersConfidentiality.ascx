<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucTsWasteTransfersConfidentiality.ascx.cs" Inherits="ucTsWasteTransfersConfidentiality" %>
<%@ Register Src="~/UserControls/Common/ucWasteTypeSelector.ascx" TagName="ucWasteTypeSelector" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucCMSText.ascx" TagName="CMStext" TagPrefix="eprtr" %>

<%-- Transfer to radio buttons --%>
<eprtr:ucWasteTypeSelector ID="ucWasteTypeSelector"  OnItemSelected="OnSelectedWasteTypeChanged" runat="server" />

<div runat="server" id="divNoConfidentialityInformation">
    <asp:Literal ID="noConfidentialityInformation" Text="<%$ Resources:Confidentiality, NoConfidentialityInformation %>" runat="server" />
</div>

<div runat="server" id="divConfidentialityInformation">
    <br />
    <eprtr:CMStext ID="cmsConfidentialityExplanation" runat="server" ResourceType="Timeseries" ResourceKey="ConfidentialityExplanationWT1"/>
    <br />

    <div>
    <asp:ListView ID="lvConfidentiality" runat="server" >

      <LayoutTemplate>
       <table>
         <thead>
          <tr class="generalListStyle_headerRow">
            <th scope="col"><div class="TSWTcolConfYear"><asp:Label ID="lbYear" Text="<%$ Resources:Common,Year %>" runat="server"></asp:Label></div></th>
            <th scope="col"><div class="TSWTcolConfCount" ><asp:Literal ID="litFacilitiesTot" Text="<%$ Resources:Facility,Facilities %>" runat="server"/><br /><asp:Label ID="lbTotal" Text="<%$ Resources:Common,Total %>" runat="server"></asp:Label></div></th>
            <th scope="col"><div class="TSWTcolConfCount" ><asp:Literal ID="litFacilitiesConf" Text="<%$ Resources:Facility,Facilities %>" runat="server"/><br /><asp:Label ID="lbConfTotal" Text="<%$ Resources:WasteTransfers,ConfidentialityWaste %>" runat="server"></asp:Label></div></th>
            <th scope="col"><div class="TSWTcolConfCount" ><asp:Literal ID="litFacilitiesQ" Text="<%$ Resources:Facility,Facilities %>" runat="server"/><br /><asp:Label ID="lbConfQuantity" Text="<%$ Resources:WasteTransfers,QuantityWithheld %>" runat="server"></asp:Label></div></th>
            <th scope="col"><div class="TSWTcolConfCount" ><asp:Literal ID="litFacilitiesTreat" Text="<%$ Resources:Facility,Facilities %>" runat="server"/><br /><asp:Label ID="lbConfTreatment" Text="<%$ Resources:WasteTransfers,TreatmentWithheld %>" runat="server"></asp:Label></div></th>
          </tr>
         </thead>
         <tbody>
          <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
         </tbody>
       </table>
      </LayoutTemplate>
        
      <ItemTemplate>
        <tr class="generalListStyle_row">
          <td><div class="TSWTcolConfYear" ><%# GetYear(Container.DataItem)  %></div></td>  
          <td><div class="TSWTcolConfCount"><%# GetCountTotal(Container.DataItem)%></div></td>
          <td><div class="TSWTcolConfCount"><%# GetCountConfTotal(Container.DataItem)%></div></td>
          <td><div class="TSWTcolConfCount"><%# GetCountConfQuantity(Container.DataItem)%></div></td>
          <td><div class="TSWTcolConfCount"><%# GetCountConfTreatment(Container.DataItem)%></div></td>
        </tr>
      </ItemTemplate>
      
      <EmptyDataTemplate>
        <div style="border-bottom:none;">
          <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
        </div>
      </EmptyDataTemplate>
          
    </asp:ListView>
    </div>
</div>
