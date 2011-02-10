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
    public class PollutantTransfersAreaTreeListRowComparer : IComparer<PollutantTransfers.AreaTreeListRow>
    {
        private AreaFilter areaFilter;

        public PollutantTransfersAreaTreeListRowComparer(AreaFilter areaFilter)
        {
            this.areaFilter = areaFilter;
        }

        int IComparer<PollutantTransfers.AreaTreeListRow>.Compare(PollutantTransfers.AreaTreeListRow x, PollutantTransfers.AreaTreeListRow y)
        {
            AreaTreeListRowComparer c1 = new AreaTreeListRowComparer(areaFilter);
            return c1.Compare(x, y);
        }
    }

    /// <summary>
    /// Comparer used for sorting pollutant releases tree list rows with area information by name (country - RBD/NUTS)
    /// </summary>
    public class PollutantReleasesAreaTreeListRowComparer : IComparer<PollutantReleases.AreaTreeListRow>
    {
        private AreaFilter areaFilter;

        public PollutantReleasesAreaTreeListRowComparer(AreaFilter areaFilter)
        {
            this.areaFilter = areaFilter;
        }

        int IComparer<PollutantReleases.AreaTreeListRow>.Compare(PollutantReleases.AreaTreeListRow x, PollutantReleases.AreaTreeListRow y)
        {
            AreaTreeListRowComparer c1 = new AreaTreeListRowComparer(areaFilter);
            return c1.Compare(x, y);
        }
    }

    /// <summary>
    /// Comparer used for sorting waste transfers tree list rows with area information by name (country - RBD/NUTS)
    /// </summary>
    public class WasteTransferAreaTreeListRowComparer : IComparer<WasteTransfers.AreaTreeListRow>
    {
        private AreaFilter areaFilter;

        public WasteTransferAreaTreeListRowComparer(AreaFilter areaFilter)
        {
            this.areaFilter = areaFilter;
        }

        int IComparer<WasteTransfers.AreaTreeListRow>.Compare(WasteTransfers.AreaTreeListRow x, WasteTransfers.AreaTreeListRow y)
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
            AreaTreeListRow row1 = x as AreaTreeListRow;
            AreaTreeListRow row2 = y as AreaTreeListRow;


            //if all codes are the same the rows are identical.
            if (row1.CountryCode == row2.CountryCode && row1.RegionCode == row2.RegionCode )
            {
                return 0;
            }

            //total row must always be last
            if (row1.Code.Equals(AreaTreeListRow.CODE_TOTAL)) return 1;
            if (row2.Code.Equals(AreaTreeListRow.CODE_TOTAL)) return -1;
            if (row1.Code.Equals(AreaTreeListRow.CODE_TOTAL) && row2.Code.Equals(AreaTreeListRow.CODE_TOTAL)) return 0;


            CaseInsensitiveComparer c = new CaseInsensitiveComparer();

            //compare country names
            int res = c.Compare(LOVResources.CountryName(row1.CountryCode), LOVResources.CountryName(row2.CountryCode));

            //if country names are the same, compare region names
            if(res == 0)
            {
                //country must always come first
                if (row1.RegionCode == null) return -1;
                if (row2.RegionCode == null) return 1;
                if (row1.RegionCode == null && row2.RegionCode == null) return 0;


                if(res == 0)
                {
                    //unknown region must always be last
                    if (row1.Code.Equals(AreaTreeListRow.CODE_UNKNOWN)) return 1;
                    if (row2.Code.Equals(AreaTreeListRow.CODE_UNKNOWN)) return -1;
                    if (row1.Code.Equals(AreaTreeListRow.CODE_UNKNOWN) && row2.Code.Equals(AreaTreeListRow.CODE_UNKNOWN)) return 0;

                    //compare names
                    res = c.Compare(row1.GetAreaName(this.areaFilter), row2.GetAreaName(this.areaFilter));
                }
            }


            return res;


        }

    }


}
