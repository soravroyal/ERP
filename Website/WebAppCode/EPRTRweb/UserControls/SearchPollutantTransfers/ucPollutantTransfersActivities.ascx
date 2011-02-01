<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucPollutantTransfersActivities.ascx.cs" Inherits="ucPollutantTransfersActivities" %>
<%@ Register src="~/UserControls/Common/ucTreeTableLabel.ascx" tagname="TreeLabel" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/TimeSeries/ucTsPollutantTransfersSheet.ascx" tagname="ucTsPollutantTransfersSheet" tagprefix="eprtr" %>

<div>
<asp:ListView ID="lvPollutantTransfers" runat="server" OnItemCommand="OnItemCommand" OnItemDataBound="rows_OnItemDataBound">
  
    <LayoutTemplate>
     <table>
       <thead>
        <tr class="generalListStyle_headerRow">
          <th><div class="ColLink"></div></th> 
          <th><div class="PTcolName"><asp:Label ID="lbName" Text="<%$ Resources:Pollutant,TransferPerIndustrialActivities %>" runat="server"></asp:Label></div></th>
          <th><div class="ColLink"></div></th>
          <th><div class="PTcolFacilities"><asp:Label ID="lbFacilities" Text="<%$ Resources:Pollutant,Facilities %>" runat="server"></asp:Label></div></th>
          <th><div class="PTcolQuantity"><asp:Label ID="lbQuantity" Text="<%$ Resources:Pollutant,Quantity %>" runat="server"></asp:Label></div></th>
        </tr>
       </thead>
       <tbody>
        <asp:PlaceHolder id="itemPlaceholder" runat="server" >
        </asp:PlaceHolder>
       </tbody>
     </table>
    </LayoutTemplate>
    
    <ItemTemplate>
    
      <tr id="row" class='<%#GetRowCss(Container.DataItem)%>'>

      <%-- TimeSeries link --%>
      <td title='<%# GetToolTipTimeSeries()%>' >
        <div class="ColLink">
          <asp:ImageButton ID="showTimeSeries" ImageUrl="~/images/timeseries.png" CommandName='timeseries' CommandArgument='<%# GetActivityCommandArg(Container.DataItem) %>' OnClientClick="ShowWaitIndicator();" runat="server" /> 
         </div>
      </td>

      <%-- Tree --%>                           
      <td title="<%# GetName(Container.DataItem)%>">
          <eprtr:TreeLabel ID="ucTreeLabel" 
            Expanded='<%#IsExpanded(Container.DataItem)%>' 
            Text='<%# GetName(Container.DataItem)%>' 
            HasChildren='<%# HasChildren(Container.DataItem)%>' 
            Level='<%# GetLevel(Container.DataItem) %>'   
            CommandName='<%# GetCode(Container.DataItem)%>' CommandArgument='<%# GetLevel(Container.DataItem)%>' 
            CssClass="PTcolName"
            runat="server" />
      </td>
      
      <%-- Link to Activity --%>
      <td title='<%# GetToolTipActivitySearch()%>' >
        <div class="ColLink">
        <asp:ImageButton ID="newSearchActivity" ImageUrl="~/images/newsearch.gif" OnCommand="onActivitySearchClick" CommandName='searchActivity' CommandArgument='<%# GetActivityCommandArg(Container.DataItem) %>' runat="server" /> 
        </div>
      </td>

      <%-- Number of facilities --%>        
      <td title='<%# GetToolTipFacilitySearch()%>' >
        <div class="PTcolFacilities"><%# GetFacilities(Container.DataItem)%>
        <asp:ImageButton ID="newSearchFacility" ImageUrl="~/images/newsearch.gif" OnCommand="onFacilitySearchClick" CommandName='searchFacility' CommandArgument='<%# GetActivityCommandArg(Container.DataItem)%>' runat="server" /> 
        </div>
      </td>
        
      <td title='<%# GetToolTip(Container.DataItem)%>'>
        <div class="PTcolQuantity">
          <%# GetTotal(Container.DataItem)%>
        </div>
      </td>
      
      <tr>
        <td colspan="5">
            <div id="subsheet" class="layout_sheetIntable" visible="false" runat="server">
                <eprtr:ucTsPollutantTransfersSheet ID="ucTsPollutantTransfersSheet" SheetLevel="1" runat="server" Visible="false" />
            </div>
        </td>
      </tr>
      
    </ItemTemplate>

  <EmptyDataTemplate>
    <div class="noResult">
        <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
    </div>
  </EmptyDataTemplate>
  
  </asp:ListView>
</div>

