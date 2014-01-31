<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeFile="ucWasteTreatmentSearchOption.ascx.cs" Inherits="ucWasteTreatmentSearchOption" %>

<%--Waste treatment search options--%>
<div class="searchOption_wasteLegend">
<asp:Literal ID="litTreatment" runat="server" Text="<%$ Resources:Common,Treatment %>"></asp:Literal>
</div>

<%-- If changing the default checked state, also update the javascript array (called searchFilter) in MasterPage.master --%>
<div class="searchOption_wasteCriteria">
<asp:CheckBox ID="chkTreatmentRecovery"  onclick="SetSearchFilter('Recovery')"   Text="<%$ Resources:Common,TreatmentRecovery %>"
    runat="server" Checked="true" />
<input type="hidden" id="clIDchkTreatmentRecovery" value="<%=chkTreatmentRecovery.ClientID %>" />
    
<asp:CheckBox ID="chkTreatmentDisposal"  onclick="SetSearchFilter('Disposal')" Text="<%$ Resources:Common,TreatmentDisposal %>"
    runat="server" Checked="true" />
<input type="hidden" id="clIDchkTreatmentDisposal" value="<%=chkTreatmentDisposal.ClientID %>" />

<asp:CheckBox ID="chkTreatmentUnspecified" onclick="SetSearchFilter('Unspecified')"  Text="<%$ Resources:Common,TreatmentUnspecified %>"
    runat="server" Checked="true" />
<input type="hidden" id="clIDchkTreatmentUnspecified" value="<%=chkTreatmentUnspecified.ClientID %>" />
    
</div>
