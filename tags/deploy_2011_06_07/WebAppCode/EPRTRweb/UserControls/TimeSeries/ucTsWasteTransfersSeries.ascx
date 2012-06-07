<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucTsWasteTransfersSeries.ascx.cs" Inherits="ucTsWasteTransfersSeries" %>
<%@ Register Src="~/UserControls/Common/ucStackColumn.ascx" TagName="ucStackColumn" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucYearCompare.ascx" TagName="ucYearCompare" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucWasteTypeSelector.ascx" TagName="ucWasteTypeSelector" TagPrefix="eprtr" %>

<%-- Releases to radio buttons --%>
<eprtr:ucWasteTypeSelector ID="ucWasteTypeSelector"  OnItemSelected="OnSelectedWasteTypeChanged" runat="server" />

<table id="compareTable" visible="true" cellspacing="5" runat="server">

  <%-- time series bars --%>
  <tr>
    <td>
        <eprtr:ucStackColumn ID="ucStackColumnTime" Visible="false" runat="server" Width="700" Height="250"/>
    </td>
  </tr>
    
  <%-- table result --%>          
  <tr>
    <td>
      <asp:ListView ID="lvTimeSeriesTable" runat="server">
        <LayoutTemplate>
         <table>
           <thead>
            <tr class="generalListStyle_headerRow">
              <th><div id="headerTimeSeriesYear"><asp:Label ID="lbYear" Text="<%$Resources:Common,Year%>" runat="server"></asp:Label></div></th>
              <th><div id="headerTimeSeriesCountries"><asp:Label ID="lbReportingCountries" Text="<%$Resources:Common,EPRTRCountries%>" runat="server"></asp:Label></div></th>
              <th><div id="headerTimeSeriesFacilities"><asp:Label ID="lbReportingFacilities" Text="<%$Resources:Common,Facilities%>" runat="server"></asp:Label></div></th>
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
            <td><div id="headerTimeSeriesYear"><asp:Label ID="lbYearRow" Text='<%# GetYear(Container.DataItem) %>' runat="server"></asp:Label></div></td>
            <td><div id="headerTimeSeriesCountries"><asp:Label ID="lbCountriesRow" Text='<%# GetReportingCountries(Container.DataItem) %>' runat="server"></asp:Label></div></td>
            <td><div id="headerTimeSeriesFacilities"><asp:Label ID="lbFacilitiesRow" Text='<%# GetReportingFacilities(Container.DataItem) %>' runat="server"></asp:Label></div></td>
          </tr>
        </ItemTemplate>
        <EmptyDataTemplate>
            <div class="noResult"><asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal></div>
        </EmptyDataTemplate>
      </asp:ListView>
    </td>
  </tr>
</table>      
      
<div class="noResult">
<asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server" Visible="false"></asp:Literal>
</div>      