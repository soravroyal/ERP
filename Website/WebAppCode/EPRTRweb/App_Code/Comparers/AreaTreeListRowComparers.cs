using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QueryLayer;
using QueryLayer.Filters;
using QueryLayer.Utilities;
using System.Web.UI.WebControls;
using System.Collections;
using EPRTR.Formatters;
using System.Globalization;
using EPRTR.Localization;

namespace EPRTR.Comparers
{
    /// <summary>
    /// Comparer used for sorting pollutant transfer tree list rows with area information by name (country - RBD/NUTS)
    /// </summary>
    public class PollutantTransfersAreaTreeListRowComparer : IComparer<PollutantTransfers.TransfersTreeListRow>
    {
        private AreaFilter areaFilter;

        public PollutantTransfersAreaTreeListRowComparer(AreaFilter areaFilter)
        {
            this.areaFilter = areaFilter;
        }

        int IComparer<PollutantTransfers.TransfersTreeListRow>.Compare(PollutantTransfers.TransfersTreeListRow x, PollutantTransfers.TransfersTreeListRow y)
        {
            AreaTreeListRowComparer c1 = new AreaTreeListRowComparer(areaFilter);
            return c1.Compare(x, y);
        }
    }

    /// <summary>
    /// Comparer used for sorting pollutant releases tree list rows with area information by name (country - RBD/NUTS)
    /// </summary>
    public class PollutantReleasesAreaTreeListRowComparer : IComparer<PollutantReleases.ReleasesTreeListRow>
    {
        private AreaFilter areaFilter;

        public PollutantReleasesAreaTreeListRowComparer(AreaFilter areaFilter)
        {
            this.areaFilter = areaFilter;
        }

        int IComparer<PollutantReleases.ReleasesTreeListRow>.Compare(PollutantReleases.ReleasesTreeListRow x, PollutantReleases.ReleasesTreeListRow y)
        {
            AreaTreeListRowComparer c1 = new AreaTreeListRowComparer(areaFilter);
            return c1.Compare(x, y);
        }
    }

    /// <summary>
    /// Comparer used for sorting waste transfers tree list rows with area information by name (country - RBD/NUTS)
    /// </summary>
    public class WasteTransferAreaTreeListRowComparer : IComparer<WasteTransfers.WasteTreeListRow>
    {
        private AreaFilter areaFilter;

        public WasteTransferAreaTreeListRowComparer(AreaFilter areaFilter)
        {
            this.areaFilter = areaFilter;
        }

        int IComparer<WasteTransfers.WasteTreeListRow>.Compare(WasteTransfers.WasteTreeListRow x, WasteTransfers.WasteTreeListRow y)
        {
            AreaTreeListRowComparer c1 = new AreaTreeListRowComparer(areaFilter);
            return c1.Compare(x, y);
        }
    }


    /// <summary>
    /// Comparer used for sorting list tree list rows with area information by name (country - RBD/NUTS)
    /// </summary>
    public class AreaTreeListRowComparer : IComparer
    {
        private AreaFilter areaFilter;

        public AreaTreeListRowComparer(AreaFilter areaFilter)
        {
            this.areaFilter = areaFilter;
        }

        public int Compare(object x, object y)
        {
            TreeListRow row1 = x as TreeListRow;
            TreeListRow row2 = y as TreeListRow;

            //total row must always be last
            if (row1.Code.Equals(TreeListRow.CODE_TOTAL)) return 1;
            if (row2.Code.Equals(TreeListRow.CODE_TOTAL)) return -1;
            if (row1.Code.Equals(TreeListRow.CODE_TOTAL) && row2.Code.Equals(TreeListRow.CODE_TOTAL) ) return 0;


            CaseInsensitiveComparer c = new CaseInsensitiveComparer();

            //compare country names
            int res = c.Compare(LOVResources.CountryName(row1.ParentCode), LOVResources.CountryName(row2.ParentCode));

            //if country names are the same, compare region names
            if(res == 0)
            {
                //compare level to keep country before regions within the country
                res = row1.Level.CompareTo(row2.Level);

                if(res == 0)
                {
                    //unknown region must always be last
                    if (row1.Code.Equals(TreeListRow.CODE_UNKNOWN)) return 1;
                    if (row2.Code.Equals(TreeListRow.CODE_UNKNOWN)) return -1;
                    if (row1.Code.Equals(TreeListRow.CODE_UNKNOWN) && row2.Code.Equals(TreeListRow.CODE_UNKNOWN)) return 0;

                    //compare names
                    res = c.Compare(row1.GetAreaName(this.areaFilter), row2.GetAreaName(this.areaFilter));
                }
            }


            return res;


        }

    }

}
