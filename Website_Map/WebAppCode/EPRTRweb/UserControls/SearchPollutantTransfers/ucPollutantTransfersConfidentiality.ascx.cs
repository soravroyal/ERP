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

public partial class ucPollutantTransfersConfidentiality : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    public void Populate(QueryLayer.Filters.PollutantTransfersSearchFilter filter, bool hasConfidentialInformation)
    {
        if (hasConfidentialInformation)
        {
            this.litConfidentialityExplanation1.Text = CMSTextCache.CMSText("Common", "ConfidentialityExplanationPT1");
            this.litConfidentialityExplanation2.Text = CMSTextCache.CMSText("Common", "ConfidentialityExplanationPT2");

            // fill pollutant data
            this.lvPollutantTransfersPollutant.DataSource = QueryLayer.PollutantTransfers.GetConfidentialPollutant(filter);
            this.lvPollutantTransfersPollutant.DataBind();

            // fill reson data
            this.lvPollutantTransfersReason.DataSource = QueryLayer.PollutantTransfers.GetConfidentialReason(filter);
            this.lvPollutantTransfersReason.DataBind();
            this.litReasonDesc.Visible = (this.lvPollutantTransfersReason.Items.Count > 0);
        }

        divConfidentialityInformation.Visible = hasConfidentialInformation;
        divNoConfidentialityInformation.Visible = !hasConfidentialInformation;

    }

    #region databinding methods
    protected string GetPollutantName(object obj)
    {
        PollutantTransfers.TransfersConfidentialRow row = (PollutantTransfers.TransfersConfidentialRow)obj;
        return LOVResources.PollutantName(row.Code);
    }

    protected string GetReason(object obj)
    {
        PollutantTransfers.TransfersConfidentialRow row = (PollutantTransfers.TransfersConfidentialRow)obj;
        return LOVResources.ConfidentialityReason(row.Code);
    }

    protected string GetFacilities(object obj)
    {
        PollutantTransfers.TransfersConfidentialRow row = (PollutantTransfers.TransfersConfidentialRow)obj;
        return NumberFormat.Format(row.Facilities);
    }

    #endregion
}
