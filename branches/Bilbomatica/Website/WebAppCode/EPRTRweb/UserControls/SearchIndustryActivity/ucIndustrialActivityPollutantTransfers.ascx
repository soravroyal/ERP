<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucIndustrialActivityPollutantTransfers.ascx.cs" Inherits="ucIndustrialActivityPollutantTransfers" %>

<%@ Register src="~/UserControls/Common/ucTreeTableLabel.ascx" tagname="TreeLabel" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/TimeSeries/ucTsPollutantTransfersSheet.ascx" tagname="ucTsPollutantTransfersSheet" tagprefix="eprtr" %>

<asp:ListView ID="lvIndustrialPollutantTransfers" runat="server" OnItemCommand="OnItemCommand">

        <LayoutTemplate>
         <table>
           <thead>
            <tr class="generalListStyle_headerRow">
              <th scope="col"><div class="ColLink"></div></th> 
              <th scope="col"><div class="PTcolName"><asp:Label ID="lbTransfersPerPollutant" Text="<%$ Resources:Pollutant,TransferPerCountry %>" runat="server"></div></asp:Label></th>
              <th scope="col"><div class="ColLink"></div></th>
              <th scope="col"><div class="PTcolFacilities"><asp:Label ID="lbFacilities" Text="<%$ Resources:Pollutant,Facilities %>" runat="server"></asp:Label></div></th>
              <th scope="col"><div class="PTcolQuantity"><asp:Label ID="lbQuantity" Text="<%$ Resources:Pollutant,Quantity   %>" runat="server"></asp:Label></div></th>
            </tr>
           </thead>
           <tbody>
            <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
           </tbody>
         </table>
        
        </LayoutTemplate>
        
        <ItemTemplate>

        <tr id="row" class='<%#GetRowCss(Container.DataItem)%>'>
          
          <%-- TimeSeries link --%>
          <td title='<%# GetToolTipTimeSeries()%>' >
            <div class="ColLink">
              <asp:ImageButton ID="showTimeSeries" 
                 ImageUrl="~/images/timeseries.png" 
                 CommandName='timeseries' 
                 CommandArgument='<%# GetCodeAndLevel(Container.DataItem) %>' 
                 OnClientClick="ShowWaitIndicator();" 
                 Visible="<%# IsChild(Container.DataItem) %>"
                 runat="server" /> 
             </div>
          </td>

        <%-- Pollutants --%>
        <%-- <asp:ImageButton ID="imgTimeSeries" ImageUrl="~/images/timeseries.png" CommandName='<%#GetCommand(Container.DataItem) %>' CommandArgument="toggletimeseries" OnDataBinding="OnRowBindingTimeseries" Visible="false" runat="server"></asp:ImageButton>  --%>          
        <td title="<%# GetName(Container.DataItem)%>">
            <eprtr:TreeLabel ID="ucTreeLabel" 
              Expanded='<%#IsExpanded(Container.DataItem)%>' 
              Text='<%# GetName(Container.DataItem)%>' 
              HasChildren='false' 
              Level='<%# GetLevel(Container.DataItem) %>'   
              CommandName='<%# GetCode(Container.DataItem)%>' CommandArgument='<%# GetLevel(Container.DataItem)%>' 
              CssClass="PTcolName"
              runat="server" />
        </td>
          
        <%-- Link to Pollutant transfers --%>
        <td title='<%# GetToolTipPollutantTransferSearch()%>' >
          <div class="ColLink">
            <asp:ImageButton ID="newSearchPollButton" Visible="<%# IsChild(Container.DataItem) %>" ImageUrl="~/images/newsearch.gif" OnCommand="onPollutantSearchClick" CommandName='searchpollutant' CommandArgument='<%# GetCodeAndLevel(Container.DataItem) %>' runat="server" /> 
          </div>
        </td>
          
          
        <%-- Number of facilities --%>
        <td title='<%# GetToolTipFacilitySearch()%>' >
          <div class="PTcolFacilities" >
            <%# GetFacilities(Container.DataItem)%>
            <asp:ImageButton ID="newSearchImageButtone" ImageUrl="~/images/newsearch.gif" OnCommand="onFacilitySearchClick" CommandName='searchfacility' CommandArgument='<%# GetCodeAndLevel(Container.DataItem) %>' runat="server" /> 
          </div>
        </td>
            
            <%-- values --%>
        <td title='<%# GetToolTip(Container.DataItem)%>'>
          <div class="PTcolQuantity">
            <%# GetTotal(Container.DataItem)%><br />
          </div>
        </td>
          
        </tr>
        
        <tr>
          <td colspan="5" >
            <div id="subsheet" class="layout_sheetIntable" visible="false" runat="server">
                <eprtr:ucTsPollutantTransfersSheet ID="ucTsPollutantTransfersSheet" SheetLevel="1" runat="server" Visible="false" />
            </div>
           <td>
        </tr>
        
      </ItemTemplate>
      
      <EmptyDataTemplate>
        <div class="noResult">
          <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
        </div>
      </EmptyDataTemplate>
      
  </asp:ListView>

