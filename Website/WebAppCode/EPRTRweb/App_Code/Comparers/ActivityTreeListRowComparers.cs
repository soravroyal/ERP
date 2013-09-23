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
    /// Comparer used for sorting pollutant releases activity tree list rows by name 
    /// </summary>
    public class PollutantReleasesActivityTreeListRowComparer : IComparer<PollutantReleases.ActivityTreeListRow>
    {
        int IComparer<PollutantReleases.ActivityTreeListRow>.Compare(PollutantReleases.ActivityTreeListRow x, PollutantReleases.ActivityTreeListRow y)
        {
            ActivityTreeListRowComparer c1 = new ActivityTreeListRowComparer(null);
            return c1.Compare(x, y);
        }
    }

    /// <summary>
    /// Comparer used for sorting pollutant transfer activity tree list rows by name 
    /// </summary>
    public class PollutantTransfersActivityTreeListRowComparer : IComparer<PollutantTransfers.ActivityTreeListRow>
    {
        int IComparer<PollutantTransfers.ActivityTreeListRow>.Compare(PollutantTransfers.ActivityTreeListRow x, PollutantTransfers.ActivityTreeListRow y)
        {
            ActivityTreeListRowComparer c1 = new ActivityTreeListRowComparer(null);
            return c1.Compare(x, y);
        }
    }

    /// <summary>
    /// Comparer used for sorting pollutant transfer activity tree list rows by name 
    /// </summary>
    public class WasteTransfersActivityTreeListRowComparer : IComparer<WasteTransfers.ActivityTreeListRow>
    {
        int IComparer<WasteTransfers.ActivityTreeListRow>.Compare(WasteTransfers.ActivityTreeListRow x, WasteTransfers.ActivityTreeListRow y)
        {
            ActivityTreeListRowComparer c1 = new ActivityTreeListRowComparer(null);
            return c1.Compare(x, y);
        }
    }

    /// <summary>
    /// Comparer used for sorting area overvoes pollutant releases activity tree list rows by name
    /// </summary>
    public class AOPollutantTreeListRowComparer : IComparer<AreaOverview.AOPollutantTreeListRow>
    {
        public AOPollutantTreeListRowComparer()
        {
        }

        int IComparer<AreaOverview.AOPollutantTreeListRow>.Compare(AreaOverview.AOPollutantTreeListRow x, AreaOverview.AOPollutantTreeListRow y)
        {
            ActivityTreeListRowComparer c1 = new ActivityTreeListRowComparer(null);
            return c1.Compare(x, y);
        }
    }

    /// <summary>
    /// Comparer used for sorting pollutant transfer activity tree list rows by name 
    /// </summary>
    public class AOWasteTreeListRowComparer : IComparer<AreaOverview.AOWasteTreeListRow>
    {
        int IComparer<AreaOverview.AOWasteTreeListRow>.Compare(AreaOverview.AOWasteTreeListRow x, AreaOverview.AOWasteTreeListRow y)
        {
            ActivityTreeListRowComparer c1 = new ActivityTreeListRowComparer(null);
            return c1.Compare(x, y);
        }
    }


    /// <summary>
    /// Comparer used for sorting list tree list rows with area information by name (country - RBD/NUTS)
    /// </summary>
    public class ActivityTreeListRowComparer : IComparer
    {
        private ActivityFilter activityFilter;

        public ActivityTreeListRowComparer(ActivityFilter activityFilter)
        {
            this.activityFilter = activityFilter;
        }

        public int Compare(object x, object y)
        {
            ActivityTreeListRow row1 = x as ActivityTreeListRow;
            ActivityTreeListRow row2 = y as ActivityTreeListRow;

            //if all codes are the same the rows are identical.
            if (row1.SectorCode == row2.SectorCode && row1.ActivityCode == row2.ActivityCode && row1.SubactivityCode == row2.SubactivityCode)
            {
                return 0;
            }

            //total row must always be last
            if (row1.Code.Equals(ActivityTreeListRow.CODE_TOTAL)) return 1;
            if (row2.Code.Equals(ActivityTreeListRow.CODE_TOTAL)) return -1;
            if (row1.Code.Equals(ActivityTreeListRow.CODE_TOTAL) && row2.Code.Equals(ActivityTreeListRow.CODE_TOTAL)) return 0;

            CaseInsensitiveComparer c = new CaseInsensitiveComparer();

            //compare sectors
            int res = row1.SectorCode.CompareTo(row2.SectorCode);

            //if sectors are the same, compare activities
            if(res == 0)
            {
                //sector must always come first
                if (row1.ActivityCode == null) return -1;
                if (row2.ActivityCode == null) return 1;
                if (row1.ActivityCode == null && row2.ActivityCode == null) return 0;

                //compare level to keep country before regions within the country
                res = row1.ActivityCode.CompareTo(row2.ActivityCode);

                if(res == 0)
                {
                    //activity must always come first
                    if (row1.SubactivityCode == null) return -1;
                    if (row2.SubactivityCode == null) return 1;
                    if (row1.SubactivityCode == null && row2.SubactivityCode == null) return 0;


                    //unknown region must always be last
                    //if (row1.Code.Equals(TreeListRow.CODE_UNKNOWN)) return 1;
                    //if (row2.Code.Equals(TreeListRow.CODE_UNKNOWN)) return -1;
                    //if (row1.Code.Equals(TreeListRow.CODE_UNKNOWN) && row2.Code.Equals(TreeListRow.CODE_UNKNOWN)) return 0;

                    //compare subactivities
                    res = row1.SubactivityCode.CompareTo(row2.SubactivityCode);

                    //res = c.Compare(row1.GetAreaName(this.areaFilter), row2.GetAreaName(this.areaFilter));
                }
            }


            return res;


        }

    }

}
