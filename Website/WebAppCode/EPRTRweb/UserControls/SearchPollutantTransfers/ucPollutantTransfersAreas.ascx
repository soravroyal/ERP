<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucPollutantTransfersAreas.ascx.cs" Inherits="ucPollutantTransfersAreas" %>

<%@ Register src="~/UserControls/TimeSeries/ucTsPollutantTransfersSheet.ascx" tagname="ucTsPollutantTransfersSheet" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/Common/ucTreeTableLabel.ascx" tagname="TreeLabel" tagprefix="eprtr" %>

<div>
<asp:ListView ID="lvPollutantTransfersAreas" runat="server"  OnItemDataBound="rows_OnItemDataBound"  OnItemCommand="OnItemCommand" >
  
  <LayoutTemplate>
   <table>
     <thead>
      <tr class="generalListStyle_headerRow">
        <th><div class="ColLink"></div></th>
        <th><div class="PTcolName"><asp:Label ID="lbName" Text="<%$ Resources:Pollutant,TransferPerCountry %>" runat="server"></asp:Label></div></th>
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
  
    <tr class='<%# GetRowCss(Container.DataItem)%>'>
    
      <%-- TimeSeries link --%>
      <td title='<%# GetToolTipTimeSeries()%>' >
        <div class="ColLink">
          <asp:ImageButton ID="showTimeSeries" ImageUrl="~/images/timeseries.png" CommandName='timeseries' CommandArgument='<%# GetAreaCommandArg(Container.DataItem) %>' runat="server" /> 
         </div>
      </td>
      
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
      
      <td title="">
        <div class="PTcolFacilities"><%# GetFacilities(Container.DataItem)%>
            <asp:ImageButton ID="newSearchImageButtone" Visible='<%# ShowFacilityLink(Container.DataItem) %>' ImageUrl="~/images/newsearch.gif" OnCommand="onNewSearchClick" CommandName='newsearch' CommandArgument='<%# GetAreaCommandArg(Container.DataItem)%>' runat="server" /> 
            <asp:Image id="InvisiblePlaceholder" runat="server" Visible='<%# ! ShowFacilityLink(Container.DataItem) %>' ImageUrl="~/images/newsearch-placeholder.png" />
        </div>
      </td>
      
      <td title='<%# GetToolTip(Container.DataItem)%>'>
        <div class="PTcolQuantity">
          <%# GetTotal(Container.DataItem)%><br />
        </div>
      </td>
    </tr>
    
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

