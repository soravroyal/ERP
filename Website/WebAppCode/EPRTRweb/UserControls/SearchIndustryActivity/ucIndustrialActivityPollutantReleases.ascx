<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucIndustrialActivityPollutantReleases.ascx.cs" Inherits="ucIndustrialActivityPollutantReleases" %>

<%@ Register src="~/UserControls/Common/ucTreeTableLabel.ascx" tagname="TreeLabel" tagprefix="eprtr" %>
<%@ Register src="~/UserControls/TimeSeries/ucTsPollutantReleasesSheet.ascx" tagname="ucTsPollutantReleasesSheet" tagprefix="eprtr" %>

<asp:ListView ID="lvIndustrialPollutantReleases" runat="server" OnItemCommand="OnItemCommand">

        <LayoutTemplate>
         <table>
           <thead>
            <tr class="generalListStyle_headerRow">
              <th scope="col"><div class="ColLink"></div></th> 
              <th scope="col"><div class="PRcolName"><asp:Label ID="lbReleasesPerPollutant" Text="<%$ Resources:Pollutant,ReleasesPerCountry %>"  runat="server"></asp:Label></div></th>
              <th scope="col"><div class="ColLink"></div></th>
              <th scope="col"><div class="PRcolTAccidental"><asp:Label ID="lnTotalAccidental" Text="" runat="server"></asp:Label></div></th>
              <th scope="col"><div class="PRcolFacilities"><asp:Label ID="lbFacilities" Text="<%$ Resources:Pollutant,Facilities %>" runat="server"></asp:Label></div></th>
              <th scope="col"><div class="PRcolAir"><asp:Label ID="lbAir" Text="<%$ Resources:Pollutant,Air %>" runat="server"></asp:Label></div></th>
              <th scope="col"><div class="PRcolWater"><asp:Label ID="lbWater" Text="<%$ Resources:Pollutant,Water %>" runat="server"></asp:Label></div></th>
              <th scope="col"><div class="PRcolSoil"><asp:Label ID="lbSoil" Text="<%$ Resources:Pollutant,Soil %>" runat="server"></asp:Label></div></th>
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
                    Visible="<%# IsChild(Container.DataItem) %>"
                    runat="server" /> 
             </div>
          </td>

          <%-- Pollutants --%>
          <td  title='<%# GetName(Container.DataItem)%>' >
            <eprtr:TreeLabel ID="ucTreeLabel" 
                Expanded='<%#IsExpanded(Container.DataItem)%>' 
                Text='<%# GetName(Container.DataItem)%>'
                HasChildren='false' 
                Level='<%# GetLevel(Container.DataItem) %>'   
                CommandName='<%# GetCode(Container.DataItem)%>' CommandArgument='<%# GetLevel(Container.DataItem)%>' 
                CssClass="PRcolName" 
                runat="server" />
          </td>

          <%-- Link to Pollutant releases --%>
          <td title='<%# GetToolTipPollutantReleaseSearch()%>' >
            <div class="ColLink">
              <asp:ImageButton ID="newSearchPollButton" Visible="<%# IsChild(Container.DataItem) %>" ImageUrl="~/images/newsearch.gif" OnCommand="onPollutantSearchClick" CommandName='searchPollutant' CommandArgument='<%# GetCodeAndLevel(Container.DataItem) %>' runat="server" /> 
            </div>
          </td>
      
          <%-- Total Accidental header --%>
          <td >
            <div class="PRcolTAccidental" visible='<%# !HasChildren(Container.DataItem)%>' runat="server">
                <asp:Literal ID="qtotal" runat="server" Text="<%$ Resources:Pollutant,ReleasesAccidentialTotal %>" /><br />
                <asp:Literal ID="atotal" runat="server" Text="<%$ Resources:Pollutant,ReleasesAccidentalValue %>" />
            </div>
          </td>
      
          <%-- Number of facilities --%>
          <td title='<%# GetToolTipFacilitySearch()%>' >
            <div class="PRcolFacilities">
              <%# GetFacilities(Container.DataItem)%>
              <asp:ImageButton ID="newSearchImageButtone" ImageUrl="~/images/newsearch.gif" OnCommand="onFacilitySearchClick" CommandName='newsearch' CommandArgument='<%# GetCodeAndLevel(Container.DataItem) %>' runat="server" /> 
                <div id="AccidentalFacilityCount" runat="server" visible='<%# !HasChildren(Container.DataItem)%>' >
                    <%# GetAccidentalFacilities(Container.DataItem)%>
                    <asp:ImageButton Enabled="false" ID="newSearchFacilityAccidental" ImageUrl="~/images/newsearch-placeholder.png" runat="server" />
                </div>
            </div>
          </td>
      
          
          <%-- values --%>
          <td title='<%# GetToolTipAir(Container.DataItem)%>'>
            <div class="PRcolAir">
              <%# GetTotalAir(Container.DataItem)%><br />
              <%# GetAccidentalAir(Container.DataItem)%>
            </div>
          </td>
          <td title="<%# GetToolTipWater(Container.DataItem)%>">
            <div class="PRcolWater">
              <%# GetTotalWater(Container.DataItem)%><br />
              <%# GetAccidentalWater(Container.DataItem)%>
            </div>
          </td>
          <td title='<%# GetToolTipSoil(Container.DataItem)%>'>
            <div class="PRcolSoil">
              <%# GetTotalSoil(Container.DataItem)%><br />
              <%# GetAccidentalSoil(Container.DataItem)%>
            </div>
          </td>
        </tr>
        
        <tr>
          <td colspan="8">
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

