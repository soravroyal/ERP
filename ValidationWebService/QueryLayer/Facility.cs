using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;


using QueryLayer.LinqFramework;
using QueryLayer.Utilities;

namespace QueryLayer
{
  
    
    /// <summary>
    /// Holds methods to collect data for the faacility search - includeing facility details
    /// </summary>
    public static class Facility
    {

          

        /// <summary>
        /// get facility ID and Facility name (is for the service of the Xquery)
        /// </summary>
        /// <param name="facilityReportId"></param>
        /// <param name="facilityName"></param>
        /// <returns></returns>
        public static IEnumerable<VALIDATION_FACILITY> GetFacilityID(string facilityNationalId, int Year, string countryCode)
        {
            DataClassesFacilityDataContext db = getDataContext();

            IEnumerable<VALIDATION_FACILITY> data = db.VALIDATION_FACILITYes.Where(p => p.NationalID == facilityNationalId && p.ReportingYear == Year && p.Code == countryCode);
            return data;
        }

       

        #region datacontext
        /// <summary>
        /// creates a new DataCotext and add logger
        /// </summary>
        private static DataClassesFacilityDataContext getDataContext()
        {
            DataClassesFacilityDataContext db = new DataClassesFacilityDataContext();
            db.Log = new DebuggerWriter();
            return db;
        }
        #endregion
    }
}