<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucAreaOverviewWasteTransfer.ascx.cs" Inherits="ucAreaOverviewWasteTransfer" %>

<%@ Register src="~/UserControls/Common/ucTreeTableLabel.ascx" tagname="TreeLabel" tagprefix="eprtr" %>

<div>
<asp:ListView ID="lvWasteTransferActivity" runat="server" OnItemCommand="OnItemCommand" OnItemDataBound="rows_OnItemDataBound">

      <LayoutTemplate>
       <table width="100%">
         <thead>
          <tr class="generalListStyle_headerRow">
            <th scope="col"><div class="AOcolNameExpanding"><asp:Label ID="lbTransfers" Text="<%$ Resources:WasteTransfers,TransferPerIndustrialActivity %>" runat="server"></asp:Label></div></th>
            <th scope="col"><div class="AOcolLegend"><asp:Label ID="lnTotal" Text="" runat="server"></asp:Label></div></th>
            <th scope="col"><div id="divHeaderHWIC" class="AOcolWasteHeader" runat="server"><asp:Label ID="lbHazWithinCountry" Text="<%$ Resources:Common,HazardousDomestic %>" runat="server"></asp:Label></div></th>
            <th scope="col"><div id="divHeaderHWOC" class="AOcolWasteHeader" runat="server"><asp:Label ID="lbHazTransboundary" Text="<%$ Resources:Common,HazardousTransboundary %>" runat="server"></asp:Label></div></th>
            <th scope="col"><div id="divHeaderHWTotal" class="AOcolWasteHeader" runat="server"><asp:Label ID="lbHazTotal" Text="<%$ Resources:Common,HazardousTotal %>" runat="server"></asp:Label></div></th>
            <th scope="col"><div id="divHeaderNonHW" class="AOcolWasteHeader" runat="server"><asp:Label ID="lbNonHazTotal" Text="<%$ Resources:Common, NonHazardousTotal %>" runat="server"></asp:Label></div></th>
          </tr>
         </thead>
         <tbody>
          <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
         </tbody>
       </table>
      
      </LayoutTemplate>
      
      <ItemTemplate>
        
        <tr id="row" class='<%#GetRowCss(Container.DataItem)%>'>

          <td  title='<%# GetName(Container.DataItem)%>' >
            <eprtr:TreeLabel ID="ucTreeLabel" 
                Expanded='<%#IsExpanded(Container.DataItem)%>' 
                Text='<%# GetName(Container.DataItem)%>' 
                HasChildren='<%# HasChildren(Container.DataItem)%>' 
                Level='<%# GetLevel(Container.DataItem) %>'   
                CommandName='<%# GetCode(Container.DataItem)%>' CommandArgument='<%# GetLevel(Container.DataItem)%>' 
                CssClass="AOcolNameExpanding"
                runat="server" />
          </td>
          
          <td>
              <div class="AOcolLegend">
                <asp:Literal ID="qtotal" runat="server" Text="<%$ Resources:AreaOverview,Quantity %>" /><br />
                <asp:Literal ID="atotal" runat="server" Text="<%$ Resources:AreaOverview,Facilities %>" />
              </div>
          </td>
          
         <td >
            <div class="AOcolWaste" runat="server">
              <%# GetHWICQuantity(Container.DataItem)%><br />
              <%# GetHWICFacilities(Container.DataItem)%><br />
            </div>
          </td>


         <td >
            <div class="AOcolWaste" runat="server">
              <%# GetHWOCQuantity(Container.DataItem)%><br />
              <%# GetHWOCFacilities(Container.DataItem)%><br />
            </div>
          </td>

         <td >
            <div class="AOcolWaste" runat="server">
              <%# GetHWQuantity(Container.DataItem)%><br />
              <%# GetHWFacilities(Container.DataItem)%><br />
            </div>
          </td>

         <td >
            <div class="AOcolWaste" runat="server">
              <%# GetNONHWQuantity(Container.DataItem)%><br />
              <%# GetNONHWFacilities(Container.DataItem)%><br />
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