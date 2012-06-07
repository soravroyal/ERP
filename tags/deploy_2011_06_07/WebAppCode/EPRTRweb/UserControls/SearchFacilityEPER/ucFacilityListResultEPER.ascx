<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucFacilityListResultEPER.ascx.cs" Inherits="ucFacilityListResultEPER" %>

<%@ Register src="~/UserControls/SearchFacilityEPER/ucFacilitySheetEPER.ascx" tagname="ucFacilitySheetEPER" tagprefix="uc1" %>
  
  <asp:Label ID="lbHelpText" CssClass="listHelp" runat="server" Text="<%$ Resources:Facility,ResultHelpText %>" Visible="true"></asp:Label><br /><br />
  <asp:ListView ID="lvFacilityResultEPER" runat="server" OnSorting="OnSorting" OnItemCommand="OnItemCommand" OnPagePropertiesChanging="OnPageChanging">
    <LayoutTemplate>
     <table>
       <thead>
        <tr class="generalListStyle_headerRow">
          <th><div id="headerFacility"> <asp:LinkButton ID="lnkFacility" Text="<%$ Resources:Facility,FacilityName %>" CommandName="Sort" CommandArgument="FacilityName" runat="server"></asp:LinkButton>     <asp:Image ID="upFacilityEPER" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="true"/>   <asp:Image ID="downFacilityEPER" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false"/>   </div></th>
          <th><div id="headerPostalCode"> <asp:LinkButton ID="lnkPostalCode" Text="<%$ Resources:Facility,PostalCode %>" CommandName="Sort" CommandArgument="PostalCode" runat="server"></asp:LinkButton>     <asp:Image ID="upPostalCodeEPER" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false"/> <asp:Image ID="downPostalCodeEPER" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false"/> </div></th>
          <th><div id="headerAddress"> <asp:LinkButton ID="lnkAddress" Text="<%$ Resources:Facility,FacilityAddress %>" CommandName="Sort" CommandArgument="Address" runat="server"></asp:LinkButton>         <asp:Image ID="upAddressEPER" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false"/>    <asp:Image ID="downAddressEPER" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false"/>    </div></th>
          <th><div id="headerTownVillage"> <asp:LinkButton ID="lnkTownVillage" Text="<%$ Resources:Facility,TownVillage %>" CommandName="Sort" CommandArgument="City" runat="server"></asp:LinkButton>        <asp:Image ID="upTownVillageEPER" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false"/><asp:Image ID="downTownVillageEPER" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false"/></div></th>
          <th><div id="headerActivity"> <asp:LinkButton ID="lnkActivity" Text="<%$ Resources:Facility,Activity %>" CommandName="Sort" CommandArgument="IAActivityCode" runat="server"></asp:LinkButton>       <asp:Image ID="upActivityEPER" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false"/>   <asp:Image ID="downActivityEPER" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false"/>   </div></th>
          <th><div id="headerCountry"> <asp:LinkButton ID="lnkCountry" Text="<%$ Resources:Facility,Country %>" CommandName="Sort" CommandArgument="CountryCode" runat="server"></asp:LinkButton>                 <asp:Image ID="upCountryEPER" runat="server" ImageUrl="~/images/arrow_up.gif" Visible="false"/>    <asp:Image ID="downCountryEPER" runat="server" ImageUrl="~/images/arrow_down.gif" Visible="false"/>    </div></th>
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
        <td title="<%# GetFacilityName(Container.DataItem)%>"><div id="Facility"><asp:LinkButton ID="lnkFacilityClick" Text='<%# GetFacilityName(Container.DataItem)%>' CommandArgument="togglesheet" CommandName="<%#GetFacilityReportId(Container.DataItem)%>" OnClientClick="ShowWaitIndicator();" runat="server"></asp:LinkButton></div></td>
        <td title=""><div id="PostalCode"><%# GetPostalCode(Container.DataItem)%></div></td>
        <td title=""><div id="Address"><%# GetAddress(Container.DataItem)%></div></td>
        <td title=""><div id="TownVillage"><%# GetCity(Container.DataItem)%></div></td>
        <td title="<%# GetActivityCode(Container.DataItem) %>"><div id="Activity"><asp:Label Text='<%# GetActivityCode2(Container.DataItem) %>' ToolTip='<%# GetActivityName(Container.DataItem)%>' runat="server"></asp:Label></div></td>
        <td title="<%# GetCountryCode(Container.DataItem) %>"><div id="Country"><asp:Label Text='<%# GetCountryCode(Container.DataItem) %>' ToolTip='<%# GetCountryName(Container.DataItem) %>' runat="server"></asp:Label></div></td>
      </tr>
      <tr>
        <td colspan="6" >
            <div id="subsheet" class="layout_sheetIntable" visible="false" runat="server">
                <uc1:ucFacilitySheetEPER ID="ucFacilitySheetEPER"  runat="server" Visible="false" />
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
  <div id="resultSizeDefine">
     <asp:DataPager ID="datapager" PagedControlID="lvFacilityResultEPER" runat="server" > 
      <Fields>
        <asp:NumericPagerField />
      </Fields>
     </asp:DataPager>
  </div>