using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Specialized;
using System.Globalization;
using System.Threading;
using System.Data;
using System.Runtime.Remoting.Contexts;
using System.Runtime.CompilerServices;
using System.Linq;
using EPRTR.ResourceProviders.Properties;
using System.Diagnostics;
using LinqUtilities;
using System.Collections;

namespace EPRTR.ResourceProviders
{
    /// <summary>
    /// Data access component for the StringResources table. 
    /// This type is thread safe.
    /// See http://msdn.microsoft.com/en-us/library/aa905797.aspx#exaspnet20rpm_topic5
    /// </summary>
    public class StringResourcesLinq: IDisposable
    {
        private string resourceType = "";

        /// <summary>
        /// Constructs this instance of the data access 
        /// component supplying a resource type for the instance. 
        /// </summary>
        /// <param name="resourceType">The resource type.</param>
        public StringResourcesLinq(string resourceType)
        {
            // save the resource type for this instance
            this.resourceType = resourceType;
        }


        /// <summary>
        /// Returns a dictionary type containing all resources for a particular resource type and culture.
        /// The resource type is based on this instance as passed to the constructor.
        /// </summary>
        /// <param name="culture">The culture to search for.</param>
        /// <param name="resourceKey">The resource key to 
        /// search for.</param>
        /// <returns>If found, the dictionary contains key/value pairs for each resource for the specified culture.</returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public ListDictionary GetResourcesByCulture(string cultureName)
        {
            Debug.WriteLine(String.Format("StringResourcesLinq.GetResourceByCulture(culture:{0}) for resourceType:{1}", cultureName, this.resourceType));

            if (cultureName == null)
            {
                cultureName = "";
            }

            // create the dictionary
            ListDictionary resourceDictionary = new ListDictionary();

            // set up LINQ expression and get resource from database
            DBResourceDataClassesDataContext db = getDataContext();
            IEnumerable<StringResource> res = db.StringResources.Where(m => m.CultureCode.Equals(cultureName) && m.ResourceType.Equals(this.resourceType));

            foreach (StringResource r in res)
            {
                string k = r.ResourceKey;
                string v = r.ResourceValue;

                if (!resourceDictionary.Contains(k))
                {
                    resourceDictionary.Add(k, v);
                }
            }

            return resourceDictionary;
        }


        /// <summary>
        /// Returns a dictionary type containing dictionaries for each culture with all resources for a particular resource type.
        /// The resource type is based on this instance as passed to the constructor.
        /// </summary>
        /// <param name="resourceKey">The resource key to search for.</param>
        /// <returns>If found, the dictionary contains dictibnalties with key/value pairs for each resource for each culture.</returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public ListDictionary GetResources()
        {
            Debug.WriteLine(String.Format("StringResourcesLinq.GetResources() for resourceType:{0}", this.resourceType));

            // create the dictionary
            ListDictionary resourceDictionary = new ListDictionary();

            // set up LINQ expression and get resource from database
            DBResourceDataClassesDataContext db = getDataContext();
            IEnumerable<StringResource> res = db.StringResources.Where(m => m.ResourceType.Equals(this.resourceType));

            foreach (StringResource r in res)
            {
                string culture = r.CultureCode;
                string k = r.ResourceKey;
                string v = r.ResourceValue;

                IDictionary resources = resourceDictionary[culture] as IDictionary;
                if (resources == null)
                {
                    resources = new ListDictionary();
                    resourceDictionary[culture] = resources;
                }

                if (!resources.Contains(k))
                {
                    resources.Add(k, v);
                }
            }

            return resourceDictionary;

        }



        private static DBResourceDataClassesDataContext getDataContext()
        {
            DBResourceDataClassesDataContext db = new DBResourceDataClassesDataContext();
            //db.Log = new DebuggerWriter();
            return db;
        }


        #region IDisposable Members

            public void  Dispose()
            {
            }

        #endregion
    }

    public class ResourceRecord
    {
        public string ResourceType {get; set;}

        public string CultureCode {get; set;}

        public string ResourceKey{get; set;}

        public string ResourceValue{get; set;}
    }
}
