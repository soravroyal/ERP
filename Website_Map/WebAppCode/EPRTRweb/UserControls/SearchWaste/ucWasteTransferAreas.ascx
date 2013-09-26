<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucWasteTransferAreas.ascx.cs" Inherits="ucWasteTransferAreas" %>

<%@ Register src="~/UserControls/TimeSeries/ucTsWasteTransfersSheet.ascx" tagname="ucTsWasteTransfersSheet" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/Common/ucTreeTableLabel.ascx" tagname="TreeLabel" tagprefix="eprtr" %>

<asp:Panel ID="upWasteTransferArea" runat="server">
    <div id="barchart" visible="true"></div>
</asp:Panel>

<div> 
<asp:ListView ID="lvWasteTransferArea" runat="server" OnItemCommand="OnItemCommand" OnItemDataBound="rows_OnItemDataBound" OnDataBinding="OnDataBinding">

      <LayoutTemplate>
       <table>
         <thead>
          <tr class="generalListStyle_headerRow">
            <th scope="col"><div class="ColLink"></div></th>                                                    
            <th scope="col"><div class="WTcolName"><asp:Label ID="lbTransfers" Text="<%$ Resources:WasteTransfers,TransferPerCountry%>" runat="server"></asp:Label></div></th>
            <th scope="col"><div class="WTcolFacilities"><asp:Label ID="lbFacilities" Text="<%$ Resources:Pollutant,Facilities %>" runat="server"></asp:Label></div></th>
            <th scope="col"><div class="WTcolTotal"><asp:Label ID="lnTotal" Text="" runat="server"></asp:Label></div></th>
            <th scope="col"><div id="divHeaderHWIC" class="WTcolHWICheader" runat="server"><asp:Label ID="lbHazWithinCountry" Text="<%$ Resources:Common,HazardousDomestic %>" runat="server"></asp:Label></div></th>
            <th scope="col"><div id="divHeaderHWOC" class="WTcolHWOCheader" runat="server"><asp:Label ID="lbHazTransboundary" Text="<%$ Resources:Common,HazardousTransboundary %>" runat="server"></asp:Label></div></th>
            <th scope="col"><div id="divHeaderHWTotal" class="WTcolHWTotalheader" runat="server"><asp:Label ID="lbHazTotal" Text="<%$ Resources:Common,HazardousTotal %>" runat="server"></asp:Label></div></th>
            <th scope="col"><div id="divHeaderNonHW" class="WTcolNONHWheader" runat="server"><asp:Label ID="lbNonHazTotal" Text="<%$ Resources:Common, NonHazardousTotal %>" runat="server"></asp:Label></div></th>
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
              <asp:ImageButton ID="showTimeSeries" ImageUrl="~/images/timeseries.png" CommandName='timeseries' CommandArgument='<%# GetAreaCommandArg(Container.DataItem) %>' runat="server" /> 
             </div>
          </td>
      
          <td  title='<%# GetName(Container.DataItem)%>' >
            <eprtr:TreeLabel ID="ucTreeLabel" 
                Expanded='<%#IsExpanded(Container.DataItem)%>' 
                Text='<%# GetName(Container.DataItem)%>' 
                HasChildren='<%# HasChildren(Container.DataItem)%>' 
                Level='<%# GetLevel(Container.DataItem) %>'   
                CommandName='<%# GetCode(Container.DataItem)%>' CommandArgument='<%# GetLevel(Container.DataItem)%>' 
                CssClass="WTcolName"
                runat="server" />
          </td>
          
          <td title="">
            <div class="WTcolFacilities"><%# GetFacilities(Container.DataItem)%>
            <asp:ImageButton ID="newSearchImageButtone" Visible='<%# ShowFacilityLink(Container.DataItem) %>' ImageUrl="~/images/newsearch.gif" OnCommand="onNewSearchClick" CommandName='newsearch' CommandArgument='<%# GetAreaCommandArg(Container.DataItem)%>' runat="server" /> 
            <asp:Image id="InvisiblePlaceholder" runat="server" Visible='<%# !ShowFacilityLink(Container.DataItem) %>' ImageUrl="~/images/newsearch-placeholder.png" />
            </div>
          </td>
          
          <td>
              <div class="WTcolTotal">
                 <div id="Div0" Visible="<%# ShowTreatmentTotal %>" runat="server"><asp:Literal ID="litTotal" runat="server" Text="<%$ Resources:Common,Total %>" /><br /></div>
                 <div id="Div1" Visible="<%# ShowRecovery %>" runat="server"><asp:Literal ID="litRecovery" runat="server" Text="<%$ Resources:Common,Recovery %>" /><br /></div>
                 <div id="Div2" Visible="<%# ShowDisposal %>" runat="server"><asp:Literal ID="litDisposal" runat="server" Text="<%$ Resources:Common,Disposal %>" /><br /></div>
                  <div id="Div3" Visible="<%# ShowUnspecified %>" runat="server"> <asp:Literal ID="litUnspec" runat="server" Text="<%$ Resources:Common,Unspec %>" /></div>
              </div>
          </td>
          
         <td title='<%# GetHWICToolTip(Container.DataItem)%>'>
            <div class="WTcolHWIC" visible="<%# ShowHWIC%>" runat="server">
              <div id="Div4" runat="server" Visible="<%# ShowTreatmentTotal %>"><%# GetHWICTotal(Container.DataItem)%><br /></div>
              <div id="Div5" runat="server" Visible="<%# ShowRecovery %>"><%# GetHWICRecovery(Container.DataItem)%><br /></div>
              <div id="Div6" runat="server" Visible="<%# ShowDisposal %>"><%# GetHWICDisposal(Container.DataItem)%><br /></div>
              <div id="Div7" runat="server" Visible="<%# ShowUnspecified %>"><%# GetHWICUnspec(Container.DataItem)%></div>
            </div>
          </td>


         <td title='<%# GetHWOCToolTip(Container.DataItem)%>'>
            <div class="WTcolHWOC" visible="<%# ShowHWOC%>" runat="server">
              <div id="Div8" runat="server" Visible="<%# ShowTreatmentTotal %>"><%# GetHWOCTotal(Container.DataItem)%><br /></div>
              <div id="Div9" runat="server" Visible="<%# ShowRecovery %>"><%# GetHWOCRecovery(Container.DataItem)%><br /></div>
              <div id="Div10" runat="server" Visible="<%# ShowDisposal %>"><%# GetHWOCDisposal(Container.DataItem)%><br /></div>
              <div id="Div11" runat="server" Visible="<%# ShowUnspecified %>"><%# GetHWOCUnspec(Container.DataItem)%></div>
            </div>
          </td>

         <td title='<%# GetHWToolTip(Container.DataItem)%>'>
            <div class="WTcolHWTotal" visible="<%# ShowHWTotal%>" runat="server">
              <div id="Div12" runat="server" Visible="<%# ShowTreatmentTotal %>"><%# GetHWTotal(Container.DataItem)%><br /></div>
              <div id="Div13" runat="server" Visible="<%# ShowRecovery %>"><%# GetHWRecovery(Container.DataItem)%><br /></div>
              <div id="Div14" runat="server" Visible="<%# ShowDisposal %>"><%# GetHWDisposal(Container.DataItem)%><br /></div>
              <div id="Div15" runat="server" Visible="<%# ShowUnspecified %>"><%# GetHWUnspec(Container.DataItem)%></div>
            </div>
          </td>

         <td title='<%# GetNONHWToolTip(Container.DataItem)%>'>
            <div class="WTcolNONHW" visible="<%# ShowNonHW%>" runat="server">
              <div id="Div16" runat="server" Visible="<%# ShowTreatmentTotal %>"><%# GetNONHWTotal(Container.DataItem)%><br /></div>
              <div id="Div17" runat="server" Visible="<%# ShowRecovery %>"><%# GetNONHWRecovery(Container.DataItem)%><br /></div>
              <div id="Div18" runat="server" Visible="<%# ShowDisposal %>"><%# GetNONHWDisposal(Container.DataItem)%><br /></div>
              <div id="Div19" runat="server" Visible="<%# ShowUnspecified %>"><%# GetNONHWUnspec(Container.DataItem)%></div>
            </div>
          </td>

        </tr>
        
        <tr>
          <td colspan="8" >
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