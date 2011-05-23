using System;
using System.Collections.Generic;
using EPRTR.Localization;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;

public partial class ucPollutantReleasesSummary : System.Web.UI.UserControl
{
    private const string DATA_AIR = "pollutantReleasesSummeryAir";
    private const string DATA_WATER = "pollutantReleasesSummeryWater";
    private const string DATA_SOIL = "pollutantReleasesSummerySoil";

    
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    /// <summary>
    /// Popolate summery, flash
    /// </summary>
    public void Populate(
        PollutantReleaseSearchFilter filter,
        PollutantReleases.FacilityCountObject counts)
    {
        // remove all radios
        //this.rbReleaseGroup.Items.Clear();

        // check that any relases are selected
        if (!filter.MediumFilter.ReleasesToAir &&
            !filter.MediumFilter.ReleasesToWater &&
            !filter.MediumFilter.ReleasesToSoil)
        {
            this.ucMediumSelector.Visible = false;
            this.litNoResultFound.Visible = true;
            this.pieChartPanel.Visible = false;
            return;
        }

        // let flex chart be visible
        this.pieChartPanel.Visible = true;
        this.litNoResultFound.Visible = false;

        // Get ALL data once for air,water,soil
        List<Summary.Quantity> air, water, soil;
        QueryLayer.PollutantReleases.Summery(filter, out air, out water, out soil);
        

        // Translate
        foreach (Summary.Quantity a in air) a.Name = LOVResources.AnnexIActivityName(a.Code);
        foreach (Summary.Quantity w in water) w.Name = LOVResources.AnnexIActivityName(w.Code);
        foreach (Summary.Quantity s in soil) s.Name = LOVResources.AnnexIActivityName(s.Code);

        // Store result in viewstate (small result)
        ViewState[DATA_AIR] = air;
        ViewState[DATA_WATER] = water;
        ViewState[DATA_SOIL] = soil;

        this.ucMediumSelector.PopulateMediumRadioButtonList(filter.MediumFilter, counts);
    }

    /// <summary>
    /// radio buttons selected
    /// </summary>
    protected void OnSelectedMediumChanged(object sender, MediumSelectedEventArgs e)
    {
        //string value = this.rbReleaseGroup.SelectedValue;
        updatePieChart(e.Medium);
    }

    /// <summary>
    /// update piechat
    /// </summary>
    /// <param name="value"></param>
    private void updatePieChart(MediumFilter.Medium medium)
    {
        //The name and path of the .swf file.
        string swfFile = EPRTR.Charts.ChartsUtils.PollutantTransferPieChart;


        if (medium.Equals(MediumFilter.Medium.Air))
        {
            List<Summary.Quantity> air = ViewState[DATA_AIR] as List<Summary.Quantity>;
            DisplayChart(swfFile, air);
        }
        else if (medium.Equals(MediumFilter.Medium.Water))
        {
            List<Summary.Quantity> water = ViewState[DATA_WATER] as List<Summary.Quantity>;
            DisplayChart(swfFile, water);
        }
        else if (medium.Equals(MediumFilter.Medium.Soil))
        {
            List<Summary.Quantity> soil = ViewState[DATA_SOIL] as List<Summary.Quantity>;
            DisplayChart(swfFile, soil);
        }
    }

    private void DisplayChart(string swfFile, List<Summary.Quantity> list)
    {
        if (list.Count != 0)
        {
            EPRTR.Charts.ChartsUtils.ChartClientScript(swfFile, list, this.pieChartPanel, this.UniqueID.ToString());
        }
        else
        {
            //display no data control
            this.NoDataReturned.Visible = true;
        }
        
    }
    
}
