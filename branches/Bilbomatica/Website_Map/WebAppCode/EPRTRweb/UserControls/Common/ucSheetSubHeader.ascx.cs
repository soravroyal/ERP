using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EPRTR.HeaderBuilders;
using System.Diagnostics;
using EPRTR.Formatters;
using StylingHelper;

public partial class ucSheetSubHeader : System.Web.UI.UserControl
{

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public void PopulateHeader(Dictionary<string, string> header)
    {
        this.subheadlineGridView.DataSource = null;

        //set headers
        //List<SubHeadlineData> lines = new List<SubHeadlineData>();
        //foreach (KeyValuePair<string, string> kvp in header)
        //{
        //   lines.Add(new SubHeadlineData(kvp.Key + ":", kvp.Value));
        //}
        //this.subheadlineGridView.DataSource = lines;
        //this.subheadlineGridView.DataBind();


        List<FacilityDetailElement> elements = new List<FacilityDetailElement>();

        foreach (KeyValuePair<string, string> kvp in header)
        {
            elements.Add(new FacilityDetailElement(kvp.Key + ":", kvp.Value));
        }


        this.subheadlineGridView.DataSource = elements;
        this.subheadlineGridView.DataBind();
    }

    public void PopulateHeaderEPER(Dictionary<string, string> header)
    {
        this.subheadlineGridView.DataSource = null;

        //set headers
        //List<SubHeadlineData> lines = new List<SubHeadlineData>();
        //foreach (KeyValuePair<string, string> kvp in header)
        //{
        //    lines.Add(new SubHeadlineData(kvp.Key + ":", kvp.Value.Replace("E-PRTR","EPER")));
        //}
        //this.subheadlineGridView.DataSource = lines;
        //this.subheadlineGridView.DataBind();

        List<FacilityDetailElement> elements = new List<FacilityDetailElement>();

        foreach (KeyValuePair<string, string> kvp in header)
        {
            elements.Add(new FacilityDetailElement(kvp.Key + ":", kvp.Value.Replace("E-PRTR", "EPER")));
        }


        this.subheadlineGridView.DataSource = elements;
        this.subheadlineGridView.DataBind();
    }

    /// <summary>
    /// Text to be presented for the confidentiality alert
    /// </summary>
    public string AlertText
    {
        get { return this.ucConfidentialDisclaimer.Text; }
        set { 
            this.ucConfidentialDisclaimer.Text = value;
            this.ucConfidentialDisclaimer.Visible = !string.IsNullOrEmpty(value);
        }
    }

    /// <summary>
    /// CommandArgument to be presented for the confidentiality alert
    /// </summary>
    public string AlertCommandArgument
    {
        get { return this.ucConfidentialDisclaimer.CommandArgument; }
        set { this.ucConfidentialDisclaimer.CommandArgument = value; }
    }

    

    /// <value>
    /// A short text to be shown on the sheet (e.g. All values are yearly releases)
    /// </value>
    public string Text
    {
        get { return this.lblText.Text; }
        set {
            this.lblText.Text = value;
            this.lblText.Visible = !string.IsNullOrEmpty(value);
        }
    }

    public EventHandler AlertClick {
        get { return this.ucConfidentialDisclaimer.AlertClick; }
        set { this.ucConfidentialDisclaimer.AlertClick = value; }
    }


    #region databinding methods
    protected string GetLabel(object obj)
    {
        return ((SubHeadlineData)obj).Data1;
    }

    protected string GetValue(object obj)
    {
        return ((SubHeadlineData)obj).Data2;
    }

    #endregion
    
}

/// <summary>
/// Custom class for binding grid view
/// </summary>
public class SubHeadlineData
{
    private string data1;
    private string data2;

    public SubHeadlineData(string s1, string s2)
    {
        this.data1 = s1;
        this.data2 = s2;
    }

    public string Data1
    {
        get { return data1; }
        set { data1 = value; }
    }
    
    public string Data2
    {
        get { return data2; }
        set { data2 = value; }
    }
    


}
