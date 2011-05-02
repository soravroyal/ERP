using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using QueryLayer.Filters;
using QueryLayer;
using QueryLayer.Utilities;
using EPRTR.Formatters;

public partial class ucTsWasteTransfersConfidentiality : System.Web.UI.UserControl
{
    public EventHandler OnWasteChange;

    private string FILTER = "tswastetransconfidentiality";
    private string WASTETYPE = "tswastetypeconf";

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// prop
    /// </summary>
    protected WasteTransferTimeSeriesFilter SearchFilter
    {
        get { return ViewState[FILTER] as WasteTransferTimeSeriesFilter; }
        set { ViewState[FILTER] = value; }
    }
    public WasteTypeFilter.Type CurrentWasteType
    {
        get { return (WasteTypeFilter.Type)ViewState[WASTETYPE]; }
        set { ViewState[WASTETYPE] = value; }
    }

    /// <summary>
    /// 
    /// </summary>
    public void Populate(WasteTransferTimeSeriesFilter filter, bool hasConfidentialInformation, WasteTypeFilter.Type wasteType)
    {
        SearchFilter = filter;

        //examine if there exists any confidential data independed of the wastetype
        this.ucWasteTypeSelector.Visible = hasConfidentialInformation;

        if (hasConfidentialInformation)
        {
            var counts = WasteTransferTrend.GetCountFacilities(filter);
            this.ucWasteTypeSelector.PopulateRadioButtonList(filter.WasteTypeFilter, wasteType, counts);
        }

    }


    private void showContent(WasteTransferTimeSeriesFilter filter, WasteTypeFilter.Type wasteType)
    {
        CurrentWasteType = wasteType;

        //examine if there exists any confidential data for the waste type given
        bool hasConfidentialInformationType = WasteTransferTrend.IsAffectedByConfidentiality(filter, wasteType);
        this.divConfidentialityInformation.Visible = hasConfidentialInformationType;
        this.divNoConfidentialityInformation.Visible = !hasConfidentialInformationType;

        if (hasConfidentialInformationType)
        {
            this.lvConfidentiality.DataSource = WasteTransferTrend.GetCountConfidentialFacilities(filter, wasteType);
            this.lvConfidentiality.DataBind();
        }
    }


    /// <summary>
    /// radio buttons selected
    /// </summary>
    protected void OnSelectedWasteTypeChanged(object sender, WasteTypeSelectedEventArgs e)
    {
        if (SearchFilter != null)
        {
            showContent(SearchFilter, e.WasteType);
            if (OnWasteChange != null)
                OnWasteChange.Invoke(sender, EventArgs.Empty);
        }
    }


    #region Databinding methods

    protected int GetYear(object obj)
    {
        return ((TimeSeriesClasses.ConfidentialityWaste)obj).Year;
    }

    protected string GetCountTotal(object obj)
    {
        TimeSeriesClasses.ConfidentialityWaste row = (TimeSeriesClasses.ConfidentialityWaste)obj;
        return NumberFormat.Format(row.CountTotal);
    }

    protected string GetCountConfTotal(object obj)
    {
        TimeSeriesClasses.ConfidentialityWaste row = (TimeSeriesClasses.ConfidentialityWaste)obj;
        return NumberFormat.Format(row.CountConfTotal);
    }

    protected string GetCountConfQuantity(object obj)
    {
        TimeSeriesClasses.ConfidentialityWaste row = (TimeSeriesClasses.ConfidentialityWaste)obj;
        return NumberFormat.Format(row.CountConfQuantity);
    }

    protected string GetCountConfTreatment(object obj)
    {
        TimeSeriesClasses.ConfidentialityWaste row = (TimeSeriesClasses.ConfidentialityWaste)obj;
        return NumberFormat.Format(row.CountConfTreatment);
    }

    #endregion
}
