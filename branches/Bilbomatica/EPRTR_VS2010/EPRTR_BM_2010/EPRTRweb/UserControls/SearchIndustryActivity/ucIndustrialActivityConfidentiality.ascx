<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucIndustrialActivityConfidentiality.ascx.cs" Inherits="ucIndustrialActivityConfidentiality" %>

<%-- Releases to radio buttons --%>
<asp:RadioButtonList ID="rbReleaseGroup" RepeatDirection="Horizontal" CellSpacing="5" OnSelectedIndexChanged="onSelectedIndexChanged" AutoPostBack="true" runat="server" >
</asp:RadioButtonList>

<div runat="server" id="divNoConfidentialityInformation">
    <asp:Literal ID="noConfidentialityInformation" Text="<%$ Resources:Confidentiality, NoConfidentialityInformation %>" runat="server" />
</div>
<br />
<%-- -------------------------------------------------------------------------------------------------------------- --%>
<%-- PollutantReleasesFacility --%>
<%-- -------------------------------------------------------------------------------------------------------------- --%>
<div id="divPollutantReleases" runat="server">
<asp:Literal ID="lbReleasesConfDesc" Mode="Transform" runat="server" Text=""></asp:Literal>
<br />
<br />
<asp:ListView ID="lvPollutantReleasesFacility" runat="server">

      <LayoutTemplate>
       <table>
         <thead>
          <tr class="generalListStyle_headerRow">
            <th><asp:Label ID="lbPollutantGroup" Text="<%$ Resources:Common,PollutantGroup %>" runat="server"></asp:Label></th>
            <th><asp:Label ID="lbBlank" Text="" runat="server"></asp:Label></th>
            <th><asp:Label ID="lbFacilitiesAir" Text="<%$ Resources:Facility,FacilitiesAir %>" runat="server"></asp:Label></th>
            <th><asp:Label ID="lbFacilitiesWater" Text="<%$ Resources:Facility,FacilitiesWater %>" runat="server"></asp:Label></th>
            <th><asp:Label ID="lbFacilitiesSoil" Text="<%$ Resources:Facility,FacilitiesSoil %>" runat="server"></asp:Label></th>
          </tr>
         </thead>
         <tbody>
          <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
         </tbody>
       </table>
      </LayoutTemplate>
        
      <ItemTemplate>
        <tr class="generalListStyle_row">
          <td style="width:220px;"><%# GetPRPollutantGroup(Container.DataItem)%></td>
          <td style="width:220px;">
            <asp:Label ID="lbFacilitiesTotal" Text="<%$ Resources:Common,FacilitiesTotal %>" runat="server"></asp:Label><br />
            <asp:Label ID="lbFacilitiesConfidential" Text="<%$ Resources:Common,FacilitiesClaimingConfidentiality %>" runat="server"></asp:Label>
          </td>
          <td style="width:100px">
            <%# GetPRFacilitiesAir(Container.DataItem)%><br />
            <%# GetPRFacilitiesAirConf(Container.DataItem)%>
          </td>
          <td style="width:100px">
            <%# GetPRFacilitiesWater(Container.DataItem)%><br />
            <%# GetPRFacilitiesWaterConf(Container.DataItem)%>
          </td>
          <td style="width:100px">
            <%# GetPRFacilitiesSoil(Container.DataItem)%><br />
            <%# GetPRFacilitiesSoilConf(Container.DataItem)%>
           </td>
        </tr>
      </ItemTemplate>
      
      <EmptyDataTemplate>
        <div class="noResult">
          <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
        </div>
      </EmptyDataTemplate>
</asp:ListView>
<br />
<asp:label ID="lbPollutantReleasesConfidentialityClaimed" runat="server" Text="<%$ Resources:Common,ConfidentialityClaimed %>"></asp:label>
<br />
<br />
<%-- PollutantReleasesReason --%>
<asp:ListView ID="lvPollutantReleasesReason" runat="server">

      <LayoutTemplate>
       <table>
         <thead>
          <tr class="generalListStyle_headerRow">
            <th><asp:Label ID="lbPollutantGroup" Text="<%$ Resources:Common,PollutantGroup %>" runat="server"></asp:Label></th>
            <th><asp:Label ID="lbReason" Text="<%$ Resources:Common,Reason %>" runat="server"></asp:Label></th>
            <th><asp:Label ID="lbFacilitiesAir" Text="<%$ Resources:Facility,FacilitiesAir %>" runat="server"></asp:Label></th>
            <th><asp:Label ID="lbFacilitiesWater" Text="<%$ Resources:Facility,FacilitiesWater %>" runat="server"></asp:Label></th>
            <th><asp:Label ID="lbFacilitiesSoil" Text="<%$ Resources:Facility,FacilitiesSoil %>" runat="server"></asp:Label></th>
          </tr>
         </thead>
         <tbody>
          <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
         </tbody>
       </table>
      </LayoutTemplate>
        
      <ItemTemplate>
        <tr class="generalListStyle_row">
          <td style="width:220px;"><%# GetPRPollutantGroup(Container.DataItem)%></td>
          <td style="width:220px;"><%# GetPRReason(Container.DataItem)%></td>
          <td style="width:100px"><%# GetPRFacilitiesAir(Container.DataItem)%></td>
          <td style="width:100px"><%# GetPRFacilitiesWater(Container.DataItem)%></td>
          <td style="width:100px"><%# GetPRFacilitiesSoil(Container.DataItem)%></td>
        </tr>
      </ItemTemplate>
      
      <EmptyDataTemplate>
        <div class="noResult">
          <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
        </div>
      </EmptyDataTemplate>
</asp:ListView>
</div>
<%-- -------------------------------------------------------------------------------------------------------------- --%>
<%-- PollutantTransfersFacility --%>
<%-- -------------------------------------------------------------------------------------------------------------- --%>
<div id="divPollutantTransfers" runat="server">
<asp:Literal ID="lbTransferConfDesc" Mode="Transform" runat="server" Text=""></asp:Literal>
<br />
<br />
<asp:ListView ID="lvPollutantTransfersFacility" runat="server">

      <LayoutTemplate>
       <table>
         <thead>
          <tr class="generalListStyle_headerRow">
            <th><asp:Label ID="lbPollutantGroup" Text="<%$ Resources:Common,PollutantGroup %>" runat="server"></asp:Label></th>
            <th><asp:Label ID="lbBlank" Text="" runat="server"></asp:Label></th>
            <th><asp:Label ID="lbFacilities" Text="<%$ Resources:Facility,Facilities %>" runat="server"></asp:Label></th>
          </tr>
         </thead>
         <tbody>
          <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
         </tbody>
       </table>
      </LayoutTemplate>
        
      <ItemTemplate>
        <tr class="generalListStyle_row">
          <td style="width:220px;"><%#GetPTPollutantGroup(Container.DataItem)%></td>
          <td style="width:220px;">
            <asp:Label ID="lbFacilitiesTotal" Text="<%$ Resources:Common,FacilitiesTotal %>" runat="server"></asp:Label><br />
            <asp:Label ID="lbFacilitiesConfidential" Text="<%$ Resources:Common,FacilitiesClaimingConfidentiality %>" runat="server"></asp:Label>
          </td>
          <td style="width:100px">
            <%# GetPTFacilities(Container.DataItem)%><br />
            <%# GetPTFacilitiesConf(Container.DataItem)%>
          </td>
        </tr>
      </ItemTemplate>
      
      <EmptyDataTemplate>
        <div class="noResult">
          <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
        </div>
      </EmptyDataTemplate>
</asp:ListView>
<br />
<asp:label ID="lbPollutantTransfersConfidentialityClaimed" runat="server" Text="<%$ Resources:Common,ConfidentialityClaimed %>"></asp:label>
<br />
<br />
<%-- PollutantTransfersReason --%>
<asp:ListView ID="lvPollutantTransfersReason" runat="server">

      <LayoutTemplate>
       <table>
         <thead>
          <tr class="generalListStyle_headerRow">
            <th><asp:Label ID="lbPollutantGroup" Text="<%$ Resources:Common,PollutantGroup %>" runat="server"></asp:Label></th>
            <th><asp:Label ID="lbReason" Text="<%$ Resources:Common,Reason %>" runat="server"></asp:Label></th>
            <th><asp:Label ID="lbFacilities" Text="<%$ Resources:Facility,Facilities %>" runat="server"></asp:Label></th>
          </tr>
         </thead>
         <tbody>
          <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
         </tbody>
       </table>
      </LayoutTemplate>
        
      <ItemTemplate>
        <tr class="generalListStyle_row">
          <td style="width:220px;"><%# GetPTPollutantGroup(Container.DataItem)%></td>
          <td style="width:220px;"><%# GetPTReason(Container.DataItem)%></td>
          <td style="width:100px"><%# GetPTFacilities(Container.DataItem)%></td>
        </tr>
      </ItemTemplate>
      
      <EmptyDataTemplate>
        <div class="noResult">
          <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
        </div>
      </EmptyDataTemplate>
</asp:ListView>
</div>

<%-- -------------------------------------------------------------------------------------------------------------- --%>
<%-- Waste Facilities --%>
<%-- -------------------------------------------------------------------------------------------------------------- --%>
<div id="divWasteTransfers" runat="server">
<asp:Literal ID="lbWasteConfDesc" Mode="Transform" runat="server" Text=""></asp:Literal>
<br />
<br />
<asp:ListView ID="lvWasteFacilities" runat="server">
  
    <LayoutTemplate>
     <table>
       <thead>
        <tr class="generalListStyle_headerRow">
          <th><div class="WTcolConfName"><asp:Label ID="lbEmpty" Text="" runat="server"></asp:Label></div></th>
          <th><div class="WTcolConfNonHW"><asp:Label ID="lbNonHazardous" Text="<%$ Resources:LOV_WASTETYPE, NON-HW %>" runat="server"></asp:Label><br/> <asp:Label ID="lbFacilities" Text="<%$ Resources:Facility,Facilities %>" runat="server"></asp:Label></div></th>
          <th><div class="WTcolConfHWIC"><asp:Label ID="lbHazardousIC" Text="<%$ Resources:LOV_WASTETYPE, HWIC %>" runat="server"></asp:Label><br/> <asp:Label ID="Label1" Text="<%$ Resources:Facility,Facilities %>" runat="server"></asp:Label></div></th>
          <th><div class="WTcolConfHWOC"><asp:Label ID="lbHazardousOC" Text="<%$ Resources:LOV_WASTETYPE, HWOC %>" runat="server"></asp:Label><br/> <asp:Label ID="Label2" Text="<%$ Resources:Facility,Facilities %>" runat="server"></asp:Label></div></th>
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
          <td><div class="WTcolConfName"><%# GetWFacilitiesDesc(Container.DataItem)%></div></td>
          <td><div class="WTcolConfNonHW" ><%# GetWFacilitiesNonHW(Container.DataItem)%></div></td>
          <td><div class="WTcolConfHWIC" ><%# GetWFacilitiesHWIC(Container.DataItem)%></div></td>
          <td><div class="WTcolConfHWOC" ><%# GetWFacilitiesHWOC(Container.DataItem)%></div></td>
        </tr>
      </ItemTemplate>

    <EmptyDataTemplate>
      <div class="noResult">
          <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
      </div>
    </EmptyDataTemplate>
    
</asp:ListView>

<br />
<asp:label ID="lbWasteConfidentialityClaimed" runat="server" Text="<%$ Resources:Common,ConfidentialityClaimed %>"></asp:label>
<br />
<br />
<%-- Waste Reason --%>
<div>
<asp:ListView ID="lvWasteReason" runat="server">
  
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
          <td><div class="WTcolConfWasteType" ><%# GetWReasonWasteType(Container.DataItem)%></div></td>
          <td><div class="WTcolConfReason" ><%# GetWReason(Container.DataItem)%></div></td>
          <td><div class="WTcolConfFacilities" ><%# GetWReasonFacilities(Container.DataItem)%></div></td>
        </tr>
    </ItemTemplate>

    <EmptyDataTemplate>
      <div class="noResult">
          <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
      </div>
    </EmptyDataTemplate>
</asp:ListView>
</div>
</div>
<%-- no data found information --%>
<asp:Literal ID="litNoDataFoundConfidentialityInfo" Text="<%$ Resources:Confidentiality, NoConfidentialityInformation %>" Visible="false" runat="server"  />
