using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.Localization;
using QueryLayer.Filters;
using QueryLayer;
using EPRTR.Formatters;
using EPRTR.Utilities;

public partial class ucWasteTransferHazardousRecievers : System.Web.UI.UserControl
{
    private const string FILTER = "wastesearchfilter";

    /// <summary>
    /// search filter to be used by sub sheet
    /// </summary>
    public WasteTransferSearchFilter SearchFilter
    {
        get { return ViewState[FILTER] as WasteTransferSearchFilter; }
        set { ViewState[FILTER] = value; }
    }



    protected void Page_Load(object sender, EventArgs e)
    {
    }

    /// <summary>
    /// Basic populate, order by facility as default
    /// </summary>
    public void Populate(WasteTransferSearchFilter filter)
    {
        Control prop = this.Parent;

        // assign current view states
        SearchFilter = filter;

        // fill listview
        populateList(filter);
    }

    /// <summary>
    /// On item command
    /// </summary>
    protected void OnItemCommand(object sender, ListViewCommandEventArgs e)
    {
        // get rowindex
        ListViewDataItem dataItem = e.Item as ListViewDataItem;
        if (dataItem == null) return; //safe check

        string source = e.CommandSource.ToString();
        string arg = e.CommandArgument.ToString();

        int rowindex = dataItem.DataItemIndex;

        if (rowindex >= 0 && rowindex < this._lvCountryResult.Items.Count)
        {
            ucWasteTransferRecieverSheet control = (ucWasteTransferRecieverSheet)this._lvCountryResult.Items[rowindex].FindControl("_ucWasteTransferHazRecieverSheet");

            if (arg.Equals("togglesheet"))
            {
                closeAllSheets(); // only allow one sheet open

                control.Visible = !control.Visible;
                Control div = this._lvCountryResult.Items[rowindex].FindControl("_subsheet");
                div.Visible = !div.Visible;

                if (control.Visible)
                {
                    string countryCode = e.CommandName; //name holds the coutry code 
                    control.Populate(SearchFilter, countryCode);
                }
            }
        }
    }
    
    /// <summary>
    /// populate
    /// </summary>
    private void populateList(WasteTransferSearchFilter filter)
    {
        // bind data to list
        this._lvCountryResult.Items.Clear();

        this._lvCountryResult.DataSource = QueryLayer.WasteTransfers.HazardousWasteRecieverList(filter);

        this._lvCountryResult.DataBind();
    }

    /// <summary>
    /// Sorting event, collapse all panels
    /// </summary>
    protected void OnSorting(object sender, ListViewSortEventArgs e)
    {
       
    }

    /// <summary>
    /// new search on facility click
    /// </summary>
    protected void onNewSearchClick(object sender, CommandEventArgs e)
    {
        string code = e.CommandArgument.ToString().ToUpper();

        // create facility search filter from activity search criteria
        FacilitySearchFilter filter = FilterConverter.ConvertToFacilitySearchFilter(SearchFilter);
                
        if (!code.Equals("TOTAL_KEY"))
        {
            // create new elements of waste filter
            filter.WasteReceiverFilter = new WasteReceiverFilter();
            filter.WasteReceiverFilter.CountryID = QueryLayer.ListOfValues.GetCountry(code).LOV_CountryID;
        }

        // go to facility search page with new filter
        LinkSearchRedirecter.ToFacilitySearch(Response, filter);
    }


    /// <summary>
    /// Close sheets
    /// </summary>
    private void closeAllSheets()
    {
        for (int i = 0; i < this._lvCountryResult.Items.Count; i++)
        {
            ucWasteTransferRecieverSheet control = (ucWasteTransferRecieverSheet)this._lvCountryResult.Items[i].FindControl("_ucWasteTransferHazRecieverSheet");
            if (control != null) control.Visible = false;
        }
    }


    //Hide headers dependend on filter selections.
    protected void OnDataBinding(object sender, EventArgs e)
    {
        this._lvCountryResult.FindControl("divHeaderWasteQT").Visible = ShowTreatmentTotal;
        this._lvCountryResult.FindControl("divHeaderWasteQR").Visible = ShowRecovery;
        this._lvCountryResult.FindControl("divHeaderWasteQD").Visible = ShowDisposal;
        this._lvCountryResult.FindControl("divHeaderWasteU").Visible = ShowUnspecified;
    }


    protected bool ShowRecovery
    {
        get { return SearchFilter.WasteTreatmentFilter.Recovery; }
    }

    protected bool ShowDisposal
    {
        get { return SearchFilter.WasteTreatmentFilter.Disposal; }
    }

    protected bool ShowUnspecified
    {
        get { return SearchFilter.WasteTreatmentFilter.Unspecified; }
    }

    protected bool ShowTreatmentTotal
    {
        get
        {
            return
                SearchFilter.WasteTreatmentFilter.Recovery
                && SearchFilter.WasteTreatmentFilter.Disposal
                && SearchFilter.WasteTreatmentFilter.Unspecified;
        }
    }


    #region Databinding methods

    protected bool ShowAsLink(object obj)
    {     
        WasteTransfers.ResultHazardousWasteRecievingCountry row = (WasteTransfers.ResultHazardousWasteRecievingCountry) obj;

        if (row.RecievingCountryCode == null
            || row.RecievingCountryCode.Equals("TOTAL_KEY"))
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    protected bool ShowFacilityLink(object obj)
    {
        WasteTransfers.ResultHazardousWasteRecievingCountry row = (WasteTransfers.ResultHazardousWasteRecievingCountry)obj;
        return row.ShowAsLink;
    }


    protected string GetCountryCommandArg(object obj)
    {
        return ((WasteTransfers.ResultHazardousWasteRecievingCountry)obj).RecievingCountryCode;
    }

    protected string GetCountryCode(object obj)
    {
        WasteTransfers.ResultHazardousWasteRecievingCountry row = (WasteTransfers.ResultHazardousWasteRecievingCountry)obj;
        return row.RecievingCountryCode;
    }

    protected string GetCountryName(object obj)
    {
        WasteTransfers.ResultHazardousWasteRecievingCountry row = (WasteTransfers.ResultHazardousWasteRecievingCountry)obj;
        return LOVResources.CountryName(row.RecievingCountryCode,Resources.GetGlobal("Common", "CONFIDENTIAL"));
    }

    protected string GetFacilities(object obj)
    {
        WasteTransfers.ResultHazardousWasteRecievingCountry row = (WasteTransfers.ResultHazardousWasteRecievingCountry)obj;
        return NumberFormat.Format(row.NumOfFacilities);
    }

    protected string GetQuantityTotal(object obj)
    {
        WasteTransfers.ResultHazardousWasteRecievingCountry row = (WasteTransfers.ResultHazardousWasteRecievingCountry)obj;
        return QuantityFormat.Format(row.QuantityTotal, row.QuantityCommonUnit);
    }

    protected string GetQuantityRecovery(object obj)
    {
        WasteTransfers.ResultHazardousWasteRecievingCountry row = (WasteTransfers.ResultHazardousWasteRecievingCountry)obj;
        return QuantityFormat.Format(row.QuantityRecovery, row.QuantityCommonUnit);
    }

    protected string GetQuantityDisposal(object obj)
    {
        WasteTransfers.ResultHazardousWasteRecievingCountry row = (WasteTransfers.ResultHazardousWasteRecievingCountry)obj;
        return QuantityFormat.Format(row.QuantityDisposal, row.QuantityCommonUnit);
    }

    protected string GetQuantityUnspecified(object obj)
    {
        WasteTransfers.ResultHazardousWasteRecievingCountry row = (WasteTransfers.ResultHazardousWasteRecievingCountry)obj;
        return QuantityFormat.Format(row.QuantityUnspecified, row.QuantityCommonUnit);
    }


    #endregion
}
