<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucFacilityWasteTrendConfidentiality.ascx.cs" Inherits="ucFacilityWasteTrendConfidentiality" %>
<%@ Register Src="~/UserControls/Common/ucCMSText.ascx" TagName="CMStext" TagPrefix="eprtr" %>

<div >
    <div runat="server" id="divNoConfidentialityInformation">
        <asp:Literal ID="noConfidentialityInformation" Text="<%$ Resources:Confidentiality, NoConfidentialityInformation %>" runat="server" />
    </div>

    <div runat="server" id="divConfidentialityInformation">
        <eprtr:CMStext ID="cmsConfidentialityExplanation" runat="server" ResourceType="Facility" ResourceKey="ConfidentialityExplanationTrendWT1"/>
        <br />
        <br />

        <asp:ListView ID="lvConfidentiality" Visible="false" runat="server">

          <LayoutTemplate>
           <table>
             <thead>
              <tr class="thirdGeneralListStyle_headerRow">
                <th><div id="thirdYearHeader"><asp:Label ID="lbYear" Text="<%$ Resources:Common,Year %>" runat="server"></asp:Label></div></th>
                <th><div id="thirdConfHeader"><asp:Label ID="lbConf" Text="<%$ Resources:WasteTransfers,ConfidentialityWaste %>" runat="server"></asp:Label></div></th>
                <th><div id="thirdConfQHeader"><asp:Label ID="lbConfQ" Text="<%$ Resources:WasteTransfers,ConfidentialityQuantity %>" runat="server"></asp:Label></div></th>
              </tr>
             </thead>
             <tbody>
              <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
             </tbody>
           </table>
          </LayoutTemplate>
            
          <ItemTemplate>
            <tr class="thirdGeneralListStyle_headerRow">
              <td ><div id="thirdYear"><%# GetConfYear(Container.DataItem)%></div></td>
              <td ><div id="thirdConf"><%# GetConfidentiality(Container.DataItem)%></div></td>
              <td ><div id="thirdConfQ"><%# GetConfidentialityQuantity(Container.DataItem)%></div></td>
            </tr>
          </ItemTemplate>
          
          <EmptyDataTemplate>
            <div style="border-bottom:none;">
              <asp:Literal ID="litNoResult" Text="<%$ Resources:Common,NoResultsFound %>" runat="server"></asp:Literal>
            </div>
          </EmptyDataTemplate>
              
        </asp:ListView>
    </div>
</div>