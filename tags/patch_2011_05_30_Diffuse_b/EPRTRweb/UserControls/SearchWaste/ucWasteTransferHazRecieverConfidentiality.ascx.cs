using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using QueryLayer;
using QueryLayer.Filters;
using EPRTR.Localization;
using EPRTR.Formatters;

public partial class ucWasteTransferHazRecieverConfidentiality : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    public void Populate(WasteTransferSearchFilter filter, 
        bool hasConfidentialInformation, 
        string countryCode)
    {
        if (hasConfidentialInformation)
        {
            this.litConfidentialityExplanation1.Text = CMSTextCache.CMSText("Common", "ConfidentialityExplanationWTRecievers1");
            this.litConfidentialityExplanation2.Text = CMSTextCache.CMSText("Common", "ConfidentialityExplanationWTRecievers2");
            
            // Bind reporting data (first translate)
            List<WasteTransfers.HazardousWasteConfidential> dataReporting = WasteTransfers.GetHazardousWasteConfidentialReporting(filter, countryCode);
            this.lvWasteTransHazReceiversReporting.DataSource = dataReporting;
            this.lvWasteTransHazReceiversReporting.DataBind();

            // Bind reason data
            this.lvWasteTransHazReceiversReason.DataSource = WasteTransfers.GetHazardousWasteConfidentialReason(filter, countryCode);
            this.lvWasteTransHazReceiversReason.DataBind();
        }

        divConfidentialityInformation.Visible = hasConfidentialInformation;
        divNoConfidentialityInformation.Visible = !hasConfidentialInformation;
    }

    #region databinding methods
    
    protected string GetHeader(object obj)
    {
        WasteTransfers.HazardousWasteConfidential row = (WasteTransfers.HazardousWasteConfidential)obj;
        return Resources.GetGlobal("Common", row.Code);
    }

    protected string GetReason(object obj)
    {
        WasteTransfers.HazardousWasteConfidential row = (WasteTransfers.HazardousWasteConfidential)obj;
        return LOVResources.ConfidentialityReason(row.Code);
    }

    protected string GetFacilities(object obj)
    {
        WasteTransfers.HazardousWasteConfidential row = (WasteTransfers.HazardousWasteConfidential)obj;
        return NumberFormat.Format(row.Facilities);
    }


    #endregion

}
