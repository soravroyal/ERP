<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucFacilityPollutantTransfersTrendConfidentiality.ascx.cs" Inherits="ucFacilityPollutantTransfersTrendConfidentiality" %>
<%@ Register Src="~/UserControls/Common/ucCMSText.ascx" TagName="CMStext" TagPrefix="eprtr" %>
    
<div>
    <div runat="server" id="divNoConfidentialityInformation">
        <asp:Literal ID="noConfidentialityInformation" Text="<%$ Resources:Confidentiality, NoConfidentialityInformation %>" runat="server" />
    </div>

    <div runat="server" id="divConfidentialityInformation">
        <eprtr:CMStext ID="cmsConfidentialityExplanation" runat="server" ResourceType="Facility" ResourceKey="ConfidentialityExplanationTrendPT1"/>
        <br />
        <br />

        <asp:ListView ID="lvConfidentiality" Visible="false" runat="server" OnDataBinding="OnConfDatabinding">

          <LayoutTemplate>
           <table>
             <thead>
              <tr class="thirdGeneralListStyle_headerRow">
                <th><div class="TSPRcolConfYear"><asp:Label ID="lbYear" Text="<%$ Resources:Common,Year %>" runat="server"></asp:Label></div></th>
                <th><div class="TSPRcolConfQuantity"><asp:Label ID="lbPollutant" Text="" runat="server"></asp:Label></div></th>
                <th><div id="divPollutantGroupHeader" class="TSPRcolConfQuantity" runat="server"><asp:Label ID="lbPollutantGroup" Text="" runat="server"></asp:Label></div></th>
              </tr>
             </thead>
             <tbody>
              <asp:PlaceHolder id="itemPlaceholder" runat="server" ></asp:PlaceHolder>
             </tbody>
           </table>
          </LayoutTemplate>
            
          <ItemTemplate>
            <tr class="thirdGeneralListStyle_headerRow">
              <td><div class="TSPRcolConfYear"><%# GetYear(Container.DataItem) %> </div></td>
              <td><div class="TSPRcolConfQuantity"><%# GetQuantity(Container.DataItem)%></div></td>
              <td><div id="divPollutantGroup" class="TSPRcolConfQuantity" visible="<%#ShowGroup %>" runat="server"><%# GetQuantityGroup(Container.DataItem)%></div></td>
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