<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucFacilityEmissionsTransfersEPER.ascx.cs" Inherits="ucFacilityEmissionsTransfersEPER" %>


<%@ Register Src="~/UserControls/SearchFacilityEPER/TimeSeries/ucFacilityPollutantTransfersTrendSheetEPER.ascx" TagName="TransferTrendEPER" TagPrefix="eprtr" %>


<asp:Panel ID="facilityPollutantTransfers" runat="server" Width="100%" Height="100%">

<div>
<h3> <asp:Label ID="lbTransToWasteWater" Text="<%$Resources:Pollutant, TransferToWasteWater%>" runat="server" CssClass="Special"></asp:Label> </h3>
<asp:ListView ID="lvFacilityEmissionsTransfers" runat="server" OnItemCommand="OnItemCommand" >

        <LayoutTemplate>
         <table cellpadding="1px;" width="100%">
           <thead>
            <tr class="generalListStyle_headerRow">
              <th><asp:Label ID="lbTitle" Text="" runat="server"></asp:Label></th>
              <th width="55%"><div id="headerPollutantName"><asp:Label ID="lbTransToWasteWater" Text="<%$Resources:Pollutant, PollutantName%>" runat="server"></asp:Label></div></th>
              <th><div id="headerQuantityTotal"><asp:Label ID="lbQuantity" Text="<%$Resources:Pollutant, Emissions%>" runat="server"></asp:Label> </div></th>
              <th><div id="headerPollutantMethod"><asp:Label ID="lbMethod" Text="<%$Resources:Pollutant, Method%>" runat="server"></asp:Label></div></th>
             
            </tr>
           </thead>
           <tbody>
            <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
           </tbody>
         </table>
        
        </LayoutTemplate>
        
        <ItemTemplate>
        
          <tr class="generalListStyle_row">
            <td><asp:ImageButton ID="ImageButton" ImageUrl="~/images/timeseries.png" CommandName='toggletimeseries' CommandArgument='<%# GetPollutantCode(Container.DataItem)%>'  runat="server"></asp:ImageButton> </td>
            <td width="55%" title="<%# GetPollutantName(Container.DataItem)%>"><div id="PollutantName" style="width:100%"><%# GetPollutantName(Container.DataItem)%></div></td>
            <td title="<%# GetQuantity(Container.DataItem)%>"><div id="QuantityTotal"><%# GetQuantity(Container.DataItem)%></div></td>
            <td title="<%# GetMethodBasisName(Container.DataItem)%>"><div id="PollutantMethod"><%# GetMethodBasisName(Container.DataItem)%></div></td>
            
          </tr>
          
          <tr>
            <td colspan="100"> <%--span all--%>
                <div id="subsheet" class="layout_sheetIntable" visible="false" runat="server">
                    <eprtr:TransferTrendEPER ID="transferTrendEPER" Visible="false" runat="server"  />
                </div>
            </td>
          </tr>
          
        </ItemTemplate>
        
        <EmptyDataTemplate>
            <div class="noResult">
              <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFoundWasteWater %>" runat="server"></asp:Literal>
            </div>
        </EmptyDataTemplate>
            
  </asp:ListView>
  <br />  
</div>

</asp:Panel>