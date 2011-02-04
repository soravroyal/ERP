using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EPRTR.ResourceProviders;
using QueryLayer;
using EPRTR.Formatters;
using QueryLayer.Filters;

namespace EPRTR.Localization
{
    /// <summary>
    /// Helper class for localizations of LOV resources
    /// </summary>
    public static class LOVResources
    {

        #region LOVAnnexIActivity
        /// <summary>
        /// Gets the name of a AnnexIActivity (incl. code) based on the code
        /// </summary>
        public static string AnnexIActivityName(string code)
        {
            return GetResource("LOV_ANNEXIACTIVITY", code);
        }
        /// <summary>
        /// Gets the name of a AnnexIActivity (incl. code) based on the LOV_AnnexIId
        /// </summary>
        public static string AnnexIActivityName(int lov_id)
        {
            LOV_ANNEXIACTIVITY a = ListOfValues.GetAnnexIActicvity(lov_id);

            string code = a != null ? a.Code : String.Empty;
            return AnnexIActivityName(code);
        }

        #endregion

        #region LOVAreaGroup
        /// <summary>
        /// Gets the name of a AreaGroup based on the code
        /// </summary>
        public static string AreaGroupName(string code)
        {
            return GetResource("LOV_AREAGROUP", code);
        }
        #endregion

        #region LOVConfidentiality
        /// <summary>
        /// Gets the reason for confidentiality based on the confidentiality code
        /// </summary>
        public static string ConfidentialityReason(string code)
        {
            return GetResource("LOV_CONFIDENTIALITY", code);
        }
        #endregion

        #region LOVCountry
        /// <summary>
        /// Gets the name of a country a resource string for LOV_Country based on the code
        /// </summary>
        /// <param name="code">country code to be converted</param>
        public static string CountryName(string code)
        {
            return GetResource("LOV_COUNTRY", code);
        }

        /// <param name="nullText">This text is returned if the code is null or empty</param>
        public static string CountryName(string code, string nullText)
        {
            if (String.IsNullOrEmpty(code))
            {
                return nullText;
            }
            return CountryName(code);
        }
        #endregion

        #region LOVMedium
        /// <summary>
        /// Gets the name of a medium based on the code
        /// </summary>
        public static string MediumName(string code)
        {
            return GetResource("LOV_MEDIUM", code);
        }
        #endregion

        #region LOVMethodBasis
        /// <summary>
        /// Gets the name of a methodBasis (M/C/E) based on the code
        /// </summary>
        public static string MethodBasisName(string code)
        {
            return GetResource("LOV_METHODBASIS", code);
        }

        /// <param name="confidentialIndicator">Indicates if confidentiality has been claimed</param>
        public static string MethodBasisName(string code, bool confidentialIndicator)
        {
            if (String.IsNullOrEmpty(code))
            {
                return ConfidentialFormat.Format(code, confidentialIndicator);
            }

            return MethodBasisName(code);
        }
        #endregion

        #region LOVMethodType
        /// <summary>
        /// Gets the name of a methodType (ISO/CEN, NRB etc) based on the code
        /// </summary>
        public static string MethodTypeName(string code)
        {
            return GetResource("LOV_METHODTYPE", code);
        }

        /// <param name="confidentialIndicator">Indicates if confidentiality has been claimed</param>
        public static string MethodTypeName(string code, bool confidentialIndicator)
        {
            if (String.IsNullOrEmpty(code))
            {
                return ConfidentialFormat.Format(code, confidentialIndicator);
            }

            return MethodTypeName(code);
        }
        #endregion

        #region LOVNaceActivity
        /// <summary>
        /// Gets the name of a NaceActivity (incl. code) based on the code
        /// </summary>
        public static string NaceActivityName(string code)
        {
            if(String.IsNullOrEmpty(code))
                return String.Empty;

            string naceActivityName = GetResource("LOV_NACEACTIVITY", code);

            if (code.StartsWith("NACE_1.1"))
            {
                naceActivityName += " (rev. 1.1.)";
            }

            return naceActivityName;

        }

        /// <summary>
        /// Gets the name of a NaceActivity (incl. code) based on the LOV_Id
        /// </summary>
        public static string NaceActivityName(int lov_id)
        {
            LOV_NACEACTIVITY a = ListOfValues.GetNaceActicvity(lov_id);
            string code = a != null ? a.Code : String.Empty;
            return NaceActivityName(code);
        }

        #endregion

        #region LOVNutsRegion
        /// <summary>
        /// Gets the name of a NUTS region based on the code
        /// </summary>
        public static string NutsRegionName(string code)
        {
            if (String.IsNullOrEmpty(code))
            {
                return GetResource("LOV_NUTSREGION", "UNKNOWN");
            }
            return GetResource("LOV_NUTSREGION", code);
        }
        #endregion

        #region LOVPollutant
        /// <summary>
        /// Gets the name of a Pollutant based on the code. 
        /// If the code corresponds to a pollutant group, the name for confidnetiality within the group is returned
        /// </summary>
        public static string PollutantName(string code)
        {
            if (ListOfValues.IsPollutantGroup(code))
            {
                return GetResource("LOV_POLLUTANT", code + ".Confidential");
            }
            else
            {
                return GetResource("LOV_POLLUTANT", code);
            }
        }

        public static string PollutantNameEPER(string code, string codeEPER)
        {
            if (ListOfValues.IsPollutantGroupEPER(code,codeEPER))
            {
                return GetResource("LOV_POLLUTANT", codeEPER + ".Confidential");
            }
            else
            {
                return GetResource("LOV_POLLUTANT", codeEPER);
            }
        }

        /// <summary>
        /// Gets the name of a Pollutant group based on the code
        /// </summary>
        public static string PollutantGroupName(string code)
        {
            return GetResource("LOV_POLLUTANT", code);
        }


        /// <summary>
        /// Gets the short name of a Pollutant based on the code. 
        /// If the code corresponds to a pollutant group, the name for confidnetiality within the group is returned
        /// </summary>
        public static string PollutantNameShort(string code)
        {
            string shortCode = code + ".short";

            if (ListOfValues.IsPollutantGroup(code))
            {
                return GetResource("LOV_POLLUTANT", shortCode + ".Confidential");
            }
            else
            {
                return GetResource("LOV_POLLUTANT", shortCode);
            }
        }

        #endregion

        #region LOVRiverBasinDistrict
        /// <summary>
        /// Gets the name of a River Basin District based on the code
        /// </summary>
        public static string RiverBasinDistrictName(string code)
        {
            return GetResource("LOV_RiverBasinDistrict", code);
        }
        #endregion

        #region LOVUnit
        /// <summary>
        /// Gets the name of a unit based on the code
        /// </summary>
        public static string UnitName(string code)
        {
            return GetResource("LOV_UNIT", code);
        }
        #endregion

        #region LOVWaste
        /// <summary>
        /// Gets the name of a waste treatment based on the code
        /// </summary>
        public static string WasteTreatmentName(string code)
        {
            return GetResource("LOV_WASTETREATMENT", code);
        }
        /// <summary>
        /// Gets the name of a wastetype based on the code
        /// </summary>
        public static string WasteTypeName(string code)
        {
            return GetResource("LOV_WASTETYPE", code);
        }
        #endregion

        #region LOVRegulation
        /// <summary>
        /// Gets the name of a Regulation based on the code
        /// </summary>
        public static string RegulationName(string code)
        {
            return GetResource("LOV_REGULATION", code);
        }
        #endregion

       #region Private methods
        /// <summary>
        /// Gets an global resource object based on the specified ClassKey and Code properties.
        /// </summary>
        private static string GetResource(string classKey, string code)
        {
            if (string.IsNullOrEmpty(code))
            {
                return null;
            }
            else
            {
                string txt = HttpContext.GetGlobalResourceObject(classKey, code) as string;

                if (txt == null)
                {
                    txt = code;
                }

                return txt;
            }
        }
        #endregion

    }

}