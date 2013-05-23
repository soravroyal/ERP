<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucIndustrialActivityWasteTransfer.ascx.cs" Inherits="ucIndustrialActivityWasteTransfer" %>

<%@ Register src="~/UserControls/TimeSeries/ucTsWasteTransfersSheet.ascx" tagname="ucTsWasteTransfersSheet" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/Common/ucTreeTableLabel.ascx" tagname="TreeLabel" tagprefix="eprtr" %>
<%@ Register TagPrefix="nfp" TagName="NoFlashPlayer" Src="~/UserControls/Common/ucNoFlashPlayer.ascx" %>

<%-- piechart --%>
<asp:Panel runat="server" ID="upindustrialWasteSummeryPanel">
  <div id="piechart" visible="true"></div>
</asp:Panel>

<div style="margin-top:5px;">
<asp:ListView ID="lvIndustrialWasteTransfers" runat="server" OnItemCommand="OnItemCommand">

        <LayoutTemplate>
         <table>
           <thead>
            <tr class="generalListStyle_headerRow">
              <th><div class="WTcolWasteType"><asp:Label ID="lbWasteTransfers" Text="<%$ Resources:Common,WasteTransfers %>" runat="server"></asp:Label></div></th>
              <th><div class="WTcolFacilities"><asp:Label ID="lbFacilities" Text="<%$ Resources:Pollutant,Facilities %>" runat="server"></asp:Label></div></th>
              <th><div class="WTcolQ"><asp:Label ID="lnRecovery" Text="<%$ Resources:Common,Recovery %>" runat="server"></asp:Label></div></th>
              <th><div class="WTcolQ"><asp:Label ID="lbDisposal" Text="<%$ Resources:Common,Disposal %>" runat="server"></asp:Label></div></th>
              <th><div class="WTcolQ"><asp:Label ID="lbUnspec" Text="<%$ Resources:Common,Unspecified %>" runat="server"></asp:Label></div></th>
              <th><div class="WTcolQ"><asp:Label ID="lbTotal" Text="<%$ Resources:Common,TotalQuantity %>" runat="server"></asp:Label></div></th>
            </tr>
           </thead>
           <tbody>
            <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
           </tbody>
         </table>
        
        </LayoutTemplate>
        
        <ItemTemplate>
        
        <tr id="row" class='<%#GetRowCss(Container.DataItem)%>'>

          <%-- Waste transfers --%>
         <td  title='<%# GetName(Container.DataItem)%>' >
            <div class="WTcolWasteType">
                
                <%-- TimeSeries link --%>
                <asp:ImageButton ID="ImageButton1" 
                    ImageUrl="~/images/timeseries.png" 
                    CommandName='timeseries' 
                    CommandArgument='<%# GetCode(Container.DataItem) %>' 
                    ToolTip="<%# GetToolTipTimeSeries()%>"
                    runat="server" 
                    CssClass="TSLink"/> 

                <%--Link to waste search--%>                
                <asp:ImageButton ID="newSearchPollButton" 
                    ImageUrl="~/images/newsearch.gif" 
                    OnCommand="onWasteSearchClick" 
                    CommandName='searchwaste' 
                    CommandArgument='<%# GetCode(Container.DataItem) %>' 
                    ToolTip='<%# GetToolTipWasteTransferSearch()%>'
                    CssClass="searchLink"
                    runat="server" /> 

                <eprtr:TreeLabel ID="ucTreeLabel" 
                    Expanded='<%#IsExpanded(Container.DataItem)%>' 
                    Text='<%# GetName(Container.DataItem)%>' 
                    HasChildren='false' 
                    Level='<%# GetLevel(Container.DataItem) %>'   
                    CommandName='<%# GetCode(Container.DataItem)%>' CommandArgument='<%# GetLevel(Container.DataItem)%>' 
                    runat="server" />
                    
            </div>
          </td>
          
          
          <%-- Number of facilities --%>
          <td title='<%# GetToolTipFacilitySearch()%>' >
            <div class="WTcolFacilities"><%# GetFacilities(Container.DataItem)%>
            <asp:ImageButton ID="newSearchImageButtone" ImageUrl="~/images/newsearch.gif" OnCommand="onFacilitySearchClick" CommandName='searchfacility' CommandArgument='<%# GetCode(Container.DataItem)%>' runat="server" /> 
            </div>
          </td>
          
          <%-- Quantity --%>
            <td title='<%# GetRecovery(Container.DataItem)%>'><div class="WTcolQ"><%# GetRecovery(Container.DataItem)%><br /><%# GetRecoveryPercent(Container.DataItem)%></div></td>
            <td title='<%# GetDisposal(Container.DataItem)%>'><div class="WTcolQ"><%# GetDisposal(Container.DataItem)%><br /><%# GetDisposalPercent(Container.DataItem)%></div></td>
            <td title='<%# GetUnspec(Container.DataItem)%>'><div class="WTcolQ"><%# GetUnspec(Container.DataItem)%><br /><%# GetUnspecPercent(Container.DataItem)%></div></td>
            <td title='<%# GetTotal(Container.DataItem)%>'><div class="WTcolQ"><%# GetTotal(Container.DataItem)%></div></td>
        </tr>
        
        <tr>
          <td colspan="100" >  <%--spann "all"--%>
            <div id="subsheet" class="layout_sheetIntable" visible="false" runat="server">
                <eprtr:ucTsWasteTransfersSheet ID="ucTsWasteTransfersSheet" SheetLevel="1" runat="server" Visible="false" />
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
