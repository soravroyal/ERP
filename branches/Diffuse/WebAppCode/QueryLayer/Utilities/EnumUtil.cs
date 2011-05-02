using System;
using System.ComponentModel;
using System.Reflection;

namespace QueryLayer.Utilities
{
    #region Class EnumUtil
    /// <summary>
    /// Class for utility methods for enums
    /// </summary>
    public class EnumUtil
    {
        /// <summary>
        /// Gets description attributes for an enum
        /// </summary>
        /// <param name="value">The enum value to get description for</param>
        /// <returns>A string with the description</returns>
        public static string GetDescription(Enum value)
        {
            string retVal = string.Empty;
            
            if(value != null)
            {
                FieldInfo fieldInfo = value.GetType().GetField(value.ToString());
                DescriptionAttribute[] attributes = (DescriptionAttribute[])fieldInfo.GetCustomAttributes(typeof(DescriptionAttribute), false);
                retVal = ((attributes.Length > 0) ? attributes[0].Description : value.ToString());
            }
            
            return retVal;
        }


        /// <summary>
        /// Gets the string value associated with the given enum value.
        /// </summary>
        public static string GetStringValue(Enum value)
        {
            string retVal = string.Empty;

            if (value != null)
            {
                FieldInfo fieldInfo = value.GetType().GetField(value.ToString());
                StringValueAttribute[] attributes = (StringValueAttribute[])fieldInfo.GetCustomAttributes(typeof(StringValueAttribute), false);
                retVal = ((attributes.Length > 0) ? attributes[0].Value : value.ToString());
            }

            return retVal;
        }

        /// <summary>
        /// Parses the supplied enum and string value to find an associated enum value. Case-sensitive.
        /// </summary>
        /// <param name="type">Type.</param>
        /// <param name="stringValue">String value.</param>
        /// <returns>Enum value associated with the string value, or null if not found.</returns>
        public static object Parse(Type type, string stringValue)
        {
            return Parse(type, stringValue, false);
        }


        /// <summary>
        /// Parses the supplied enum and string value to find an associated enum value.
        /// </summary>
        /// <param name="type">Type, use typeof(...)</param>
        /// <param name="stringValue">String value.</param>
        /// <param name="ignoreCase">Denotes whether to conduct a case-insensitive match on the supplied string value</param>
        /// <returns>Enum value associated with the string value, or null if not found.</returns>
        public static object Parse(Type type, string stringValue, bool ignoreCase)
        {
            object output = null;
            string enumStringValue = null;

            if (!type.IsEnum)
                throw new ArgumentException(String.Format("Supplied type must be an Enum.  Type was {0}", type.ToString()));

            //Look for our string value associated with fields in this enum
            foreach (FieldInfo fi in type.GetFields())
            {
                //Check for our custom attribute
                StringValueAttribute[] attrs = fi.GetCustomAttributes(typeof(StringValueAttribute), false) as StringValueAttribute[];
                if (attrs.Length > 0)
                    enumStringValue = attrs[0].Value;

                //Check for equality then select actual enum value.
                if (string.Compare(enumStringValue, stringValue, ignoreCase) == 0)
                {
                    output = Enum.Parse(type, fi.Name);
                    break;
                }
            }

            return output;
        }

    }
    #endregion

    #region Class StringValueAttribute

    /// <summary>
    /// Simple attribute class for storing String Values
    /// </summary>
    public class StringValueAttribute : Attribute
    {
        private string value;

        public StringValueAttribute(string value)
        {
            this.value = value;
        }

        public string Value
        {
            get { return this.value; }
        }

    }

    #endregion
}
