<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucFacilityWasteTrendSheet.ascx.cs" Inherits="ucFacilityWasteTrendSheet" %>

<%@ Register src="~/UserControls/Common/ucSheetLinks.ascx" tagname="ucSheetLinks" tagprefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucSheetSubHeader.ascx" TagName="SheetSubHeader" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucStackColumn.ascx" TagName="ucStackColumn" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucYearCompareSeries.ascx" TagName="ucYearCompareSeries" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucDownloadPrint.ascx" TagName="ucDownloadPrint" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/SearchFacility/TimeSeries/ucFacilityWasteTrendConfidentiality.ascx" TagName="ucFacilityWasteTrendConfidentiality" TagPrefix="eprtr" %>

<div class="look_sheet_level2">

    <%-- headline --%>
    <div class="layout_sheet_header">
        <h2>
            <asp:Literal ID="litHeadline" Text="Header" runat="server" Visible="true"></asp:Literal>
        </h2>
    </div>
    
    <eprtr:ucSheetLinks ID="ucSheetLinks" runat="server" Visible="true" />
    
    <%-- download and print icons --%>
    <div class="layout_sheet_download_print">
      <eprtr:ucDownloadPrint ID="ucDownloadPrint" Visible="true" runat="server" />
    </div>

    <%-- Subheader --%>
    <div class="layout_sheet_subHeader">
        <eprtr:SheetSubHeader ID="ucSheetSubHeader" runat="server"/>
    </div>

    <div class="layout_sheet_content">
      <eprtr:ucStackColumn ID="ucStackColumnTime" Visible="false" Width="700" Height="250"  runat="server" />

      <table id="compareTable" visible="true" cellspacing="15" runat="server">
        <tr>
          <%-- Compare year --%>
          <td>
            <eprtr:ucYearCompareSeries ID="ucYearCompareSeries" Visible="false" runat="server" />
            <asp:Label ID="lbNoDataForSelectedYears" Text=" <%$ Resources:Common, TimeSeriesCompareNoData %>" runat="server" Visible="false"></asp:Label>
          </td>
        </tr>
        <tr>
          <%-- Compare chart --%>
          <td style="width:50%">
            <eprtr:ucStackColumn ID="ucStackColumnCompare" Visible="false" Width="300" Height="250"  runat="server" />
          </td>
          <%-- Compare result in table --%>
          <td style="width:50%; vertical-align:top;">
                   
            <asp:GridView ID="grdCompareDetails" 
                runat="server" ShowHeader="true" AutoGenerateColumns="false" GridLines="none" Width="100%"
                HeaderStyle-CssClass="thirdGeneralListStyle_headerRow"
                RowStyle-CssClass="generalListStyle_row"
                OnDataBound="grdCompareDetails_OnDataBound"
                EmptyDataRowStyle-Height="0px">
                <Columns>
                    <asp:BoundField DataField="Label"   ItemStyle-CssClass="CompColLabel"></asp:BoundField>
                    <asp:BoundField DataField="Value1" ItemStyle-CssClass="CompColData"></asp:BoundField>
                    <asp:BoundField DataField="Value2" ItemStyle-CssClass="CompColData"></asp:BoundField>
                </Columns>
            </asp:GridView>

          </td>
        </tr>
      </table>
      
      <eprtr:ucFacilityWasteTrendConfidentiality ID = "ucContentConfidentiality" runat="server" Visible = "false"/>
    </div>
    
</div>
