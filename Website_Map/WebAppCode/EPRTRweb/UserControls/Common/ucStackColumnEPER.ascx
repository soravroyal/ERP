<%@ Control Language="C#" AutoEventWireup="false" CodeFile="ucStackColumnEPER.ascx.cs" Inherits="ucStackColumnEPER" %>
<%-- Move the chart a small amount to the left, margin issue --%>
<div id="tschart" style="position:relative; left:-15px;">
  <%-- Timeseries are stackcolum types --%>
  <asp:CHART id="stackcolumnEPER" ImageStorageMode="UseImageLocation" BackColor="Transparent"  ImageLocation="~/Temp/stackcolumntmp_#SEQ(1000,5)" runat="server" AntiAliasing="Graphics" TextAntiAliasingQuality="High">
    <%-- No norder --%>
    <borderskin SkinStyle="None"></borderskin>
    <Legends >
        <asp:Legend Name="legend"  Alignment="Near" Docking="Bottom"  DockedToChartArea="stackchararea" IsDockedInsideChartArea="false" TextWrapThreshold="50"  BackColor="Transparent"></asp:Legend>
    </Legends>
    <%-- Area, transparent background --%>
    <chartareas>
      <asp:ChartArea  Area3DStyle-Enable3D="false" Name="stackchararea" BackColor="Transparent"  BackGradientStyle="None" >
	      <%-- Axis Y --%>
        <axisy LabelAutoFitMaxFontSize="8" IsMarginVisible="true" Minimum="0">
	        <LabelStyle  IntervalType="Number" Format="{G3}"/>
	        <%--<LabelStyle  Font="Verdana, 8.25pt, style=Regular" IntervalType="Number" Format="{G3}"/>--%>
	        <MajorGrid LineColor="LightGray" />
        </axisy>
	      <%-- Axis X --%>
        <axisx  IntervalAutoMode="VariableCount" IsMarginVisible="true">
            <LabelStyle TruncatedLabels="true" IsStaggered="false" />
	        <%--<LabelStyle Font="Verdana, 8.25pt, style=Regular" TruncatedLabels="true" IsStaggered="true" />--%>
	        <MajorGrid LineColor="LightGray" />
        </axisx>
      </asp:ChartArea>
    </chartareas>
  </asp:CHART>			
</div>
