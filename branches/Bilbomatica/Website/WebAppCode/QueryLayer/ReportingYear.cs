using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using LinqUtilities;

namespace QueryLayer
{
    /*  class ReportingYearList
      {
          private int[] years;


          public int[] Years
          {
              get { return this.years; }
              set { this.years = value; }
          }
      }*/

    public static class ReportinYear
    {

        public static List<int> GetReportingYears()
        {
            DataClassesLOVDataContext db = getDataContext();
            IEnumerable<int> res = from r in db.REPORTINGYEARs
                                   select r.Year;

            return res.ToList();
        }

        public static List<int> GetReportingYearsPRTR()
        {
            DataClassesLOVDataContext db = getDataContext();
            IEnumerable<int> res = from r in db.REPORTINGYEARs
                                   where r.Year > 2004
                                   select r.Year;

            return res.ToList();
        }

        public static List<int> GetReportingYearsEPER()
        {
            DataClassesLOVDataContext db = getDataContext();
            IEnumerable<int> res = from r in db.REPORTINGYEARs
                                   where r.Year < 2007
                                   select r.Year;

            return res.ToList();
        }

        private static DataClassesLOVDataContext getDataContext()
        {
            DataClassesLOVDataContext db = new DataClassesLOVDataContext();
            db.Log = new DebuggerWriter();
            return db;
        }
    }
}
