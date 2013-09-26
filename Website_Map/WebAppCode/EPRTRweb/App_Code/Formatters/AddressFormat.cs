using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EPRTR.Localization;

namespace EPRTR.Formatters
{
    /// <summary>
    /// Creates a combined address string.
    /// </summary>
    public static class AddressFormat
    {

        /// <summary>
        /// Returnes a combined address string. The country will be translated.
        /// </summary>
        /// <param name="address">adress, i.e. steetname incl. buildingnumber</param>
        /// <param name="city"></param>
        /// <param name="postalCode"></param>
        /// <param name="countryCode">The LOV code for the country</param>
        /// <param name="confidential">True if confidentality is claimed</param>
        public static string Format(string address, string city, string postalCode, string countryCode, bool confidential)
        {
            string result = address;

            result = addString(result, postalCode);
            result = addString(result, city);
            result = addString(result, LOVResources.CountryName(countryCode));

            return ConfidentialFormat.Format(result, confidential);
        }
        public static string Format(object address, object city, object postalCode, object countryCode, object confidential)
        {
            return Format(address as string, city as string, postalCode as string, countryCode as string, confidential == null ? false : (bool)confidential);

        }


        /// <summary>
        /// Returnes a combined address string witrhout country
        /// </summary>
        /// <param name="address">adress, i.e. steetname incl. buildingnumber</param>
        /// <param name="city"></param>
        /// <param name="postalCode"></param>
        /// <param name="confidential">True if confidentality is claimed</param>
        public static string Format(string address, string city, string postalCode, bool confidential)
        {
            return Format(address, city, postalCode, null, confidential);
        }
        public static string Format(object address, object city, object postalCode, object confidential)
        {
            return Format(address as string, city as string, postalCode as string, confidential==null ? false : (bool)confidential);

        }


        /// <summary>
        /// combines to strings with a comma, taken into account if any of them are null or empty.
        /// </summary>
        private static string addString(string str1, string str2)
        {
            string res = string.Empty;

            if (string.IsNullOrEmpty(str1))
            {
                res = str2;
            }
            else if (string.IsNullOrEmpty(str2))
            {
                res = str1;
            }
            else
            {
                res = str1 + ", " + str2;
            }

            return res;

        }
    }
}
