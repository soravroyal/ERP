<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucTsPollutantReleasesComparison.ascx.cs" Inherits="ucTsPollutantReleasesComparison" %>
<%@ Register Src="~/UserControls/Common/ucYearCompare.ascx" TagName="ucYearCompare" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucDownloadPrint.ascx" TagName="ucDownloadPrint" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucStackColumn.ascx" TagName="ucStackColumn" TagPrefix="eprtr" %>
<%@ Register Src="~/UserControls/Common/ucMediumSelector.ascx" TagName="ucMediumSelector" TagPrefix="eprtr" %>

<%-- Releases to radio buttons --%>
<eprtr:ucMediumSelector ID="ucMediumSelector"  OnItemSelected="OnSelectedMediumChanged" runat="server" />

<div class="clearBoth">
    <table id="compareTable" visible="true" cellspacing="10" runat="server">
          
      <tr>
        <%-- Year slider --%>
        <td>
          <eprtr:ucYearCompare ID="ucYearCompare" Visible="true" OnItemSelected="YearSelectedChanged" runat="server" />
          <asp:Label ID="lbNoDataFound" Text="<%$ Resources:Common, TimeSeriesCompareNoData %>" Visible="false" runat="server"></asp:Label>
        </td>
      </tr>
      
      <tr>
        <%-- Compare Chart --%>
        <td style="width:40%">
          <eprtr:ucStackColumn ID="ucStackColumnCompare" Width="300" Height="250" Visible="false" runat="server" />
        </td>
        
        <%-- Compare Tables --%>
        <td style="width:60%; vertical-align:top;">
        
            <div>
            <%--all facilites--%>
            <asp:GridView ID="grdCompareDetailsAll" 
                runat="server" ShowHeader="true" AutoGenerateColumns="false" GridLines="none" Width = "100%"
                EmptyDataRowStyle-Height="0px"
                HeaderStyle-CssClass="generalListStyle_headerRow"
                RowStyle-CssClass="generalListStyle_row"
                OnDataBound = "grdCompareDetailsAll_OnDataBound"
                >
                <Columns>
                    <asp:BoundField DataField="Label"  ItemStyle-CssClass="CompColLabel>"></asp:BoundField>
                    <asp:BoundField DataField="Value1" ItemStyle-CssClass="CompColData"></asp:BoundField>
                    <asp:BoundField DataField="Value2" ItemStyle-CssClass="CompColData"></asp:BoundField>
                </Columns>
            </asp:GridView>
            <br />
            <%--Facilites reporting both years--%>
            <asp:GridView ID="grdCompareDetailsBothYears" 
                runat="server" ShowHeader="true" AutoGenerateColumns="false" GridLines="none" Width = "100%"
                EmptyDataRowStyle-Height="0px"
                HeaderStyle-CssClass="generalListStyle_headerRow"
                RowStyle-CssClass="generalListStyle_row"
                OnDataBound = "grdCompareDetailsBothYears_OnDataBound"
                >
                <Columns>
                    <asp:BoundField DataField="Label"  ItemStyle-CssClass="CompColLabel>"></asp:BoundField>
                    <asp:BoundField DataField="Value1" ItemStyle-CssClass="CompColData"></asp:BoundField>
                    <asp:BoundField DataField="Value2" ItemStyle-CssClass="CompColData"></asp:BoundField>
                </Columns>
            </asp:GridView>
              
            </div>              
        </td>
      </tr>
            
              
    </table>      



    <div class="noResult">
    <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server" Visible="false"></asp:Literal>
    </div>      
</div>