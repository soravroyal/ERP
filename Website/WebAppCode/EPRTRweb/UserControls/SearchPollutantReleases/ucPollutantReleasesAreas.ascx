<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucPollutantReleasesAreas.ascx.cs" Inherits="ucPollutantReleasesAreas" %>

<%@ Register src="~/UserControls/TimeSeries/ucTsPollutantReleasesSheet.ascx" tagname="ucTsPollutantReleasesSheet" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/Common/ucTreeTableLabel.ascx" tagname="TreeLabel" tagprefix="eprtr" %>

<div>
<asp:ListView ID="lvPollutantReleasesArea" runat="server" OnItemCommand="OnItemCommand" OnItemDataBound="rows_OnItemDataBound"  OnDataBinding="OnDataBinding">

        <LayoutTemplate>
         <table>
           <thead>
            <tr class="generalListStyle_headerRow">
              <th scope="col"><div class="ColLink"></div></th>
              <th scope="col"><div class="PRcolName"><asp:Label ID="lbReleasesPerCountry" Text="<%$ Resources:Pollutant,ReleasesPerCountry %>" runat="server"></asp:Label></div></th>
              <th scope="col"><div class="PRcolTAccidental"><asp:Label ID="lnTotalAccidental" Text="" runat="server"></asp:Label></div></th>
              <th scope="col"><div class="PRcolFacilities"><asp:Label ID="lbFacilities" Text="<%$ Resources:Pollutant,Facilities %>" runat="server"></asp:Label></div></th>
              <th scope="col"><div id="divHeaderAir" class="PRcolAir" runat="server" ><asp:Label ID="lbAir" Text="<%$ Resources:Pollutant,Air %>" runat="server"></asp:Label></div></th>
              <th scope="col"><div id="divHeaderWater" class="PRcolWater" runat="server"><asp:Label ID="lbWater" Text="<%$ Resources:Pollutant,Water %>" runat="server"></asp:Label></div></th>
              <th scope="col"><div id="divHeaderSoil" class="PRcolSoil" runat="server"><asp:Label ID="lbSoil" Text="<%$ Resources:Pollutant,Soil %>" runat="server"></asp:Label></div></th>
            </tr>
           </thead>
           <tbody>
            <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
           </tbody>
         </table>
        </LayoutTemplate>
        
        <ItemTemplate>
        
        <tr id="row" class='<%# GetRowCss(Container.DataItem)%>'>
          
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
                CommandName='<%# GetCode(Container.DataItem)%>' CommandArgument='expand' 
                CssClass="PRcolName"
                runat="server" />
          </td>
            <td>
                <div class="PRcolTAccidental">
                    <asp:Literal ID="qtotal" runat="server" Text="<%$ Resources:Pollutant,ReleasesAccidentialTotal %>" /><br />
                    <asp:Literal ID="atotal" runat="server" Text="<%$ Resources:Pollutant,ReleasesAccidentalValue %>" />
                </div>
            </td>
          <td title="">
            <div class="PRcolFacilities"><%# GetFacilities(Container.DataItem)%>
            <asp:ImageButton ID="newSearchImageButtone" Visible='<%# ShowFacilityLink(Container.DataItem) %>' ImageUrl="~/images/newsearch.gif" OnCommand="onNewSearchClick" CommandName='newsearch' CommandArgument='<%# GetAreaCommandArg(Container.DataItem)%>' runat="server" /> 
            <asp:Image id="InvisiblePlaceholder" runat="server" Visible='<%# !ShowFacilityLink(Container.DataItem) %>' ImageUrl="~/images/newsearch-placeholder.png" />
            <br />
            <%# GetAccidentalFacilities(Container.DataItem)%>
            <asp:ImageButton Enabled="false" ID="newSearchFacilityAccidental" ImageUrl="~/images/newsearch-placeholder.png"   runat="server" /> 
            </div>
          </td>
            
       
          
          <td title='<%# GetToolTipAir(Container.DataItem)%>'>
            <div class="PRcolAir" visible="<%# ShowAir%>" runat="server">
              <%# GetTotalAir(Container.DataItem)%><br />
              <%# GetAccidentalAir(Container.DataItem)%>
            </div>
          </td>
          <td title="<%# GetToolTipWater(Container.DataItem)%>">
            <div class="PRcolWater" visible="<%# ShowWater%>" runat="server">
              <%# GetTotalWater(Container.DataItem)%><br />
              <%# GetAccidentalWater(Container.DataItem)%>
            </div>
          </td>
          <td title='<%# GetToolTipSoil(Container.DataItem)%>'>
            <div class="PRcolSoil" visible="<%# ShowSoil%>" runat="server">
              <%# GetTotalSoil(Container.DataItem)%><br />
              <%# GetAccidentalSoil(Container.DataItem)%>
            </div>
          </td>
          
        </tr>
        
        <tr>
          <td colspan="7">
            <div id="subsheet" class="layout_sheetIntable" visible="false" runat="server">
                <eprtr:ucTsPollutantReleasesSheet ID="ucTsPollutantReleasesSheet" SheetLevel="1" runat="server" Visible="false" />
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