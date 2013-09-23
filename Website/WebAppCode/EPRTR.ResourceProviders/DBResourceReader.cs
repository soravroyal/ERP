using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Resources;
using System.Reflection;
using System.Globalization;
using System.Threading;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Collections;
using System.Collections.Specialized;
using System.Diagnostics;

namespace EPRTR.ResourceProviders
{

   /// <summary>
   /// Implementation of IResourceReader required to retrieve a dictionary
   /// of resource values for implicit localization. 
    /// See http://msdn.microsoft.com/en-us/library/aa905797.aspx#exaspnet20rpm_topic5
   /// </summary>
   public class DBResourceReader : DisposableBaseType, IResourceReader, IEnumerable<KeyValuePair<string, object>> 
   {

       private IDictionary resourceDictionary;

       public DBResourceReader(IDictionary resourceDictionary)
       {
           Debug.WriteLine("DBResourceReader()");

           this.resourceDictionary = resourceDictionary;
       }

       protected override void Cleanup()
       {
           try
           {
               this.resourceDictionary = null;
           }
           finally
           {
               base.Cleanup();
           }
       }

       #region IResourceReader Members

       public void Close()
       {
           this.Dispose();
       }

       public IDictionaryEnumerator GetEnumerator()
       {
           Debug.WriteLine("DBResourceReader.GetEnumerator()");
           
           // NOTE: this is the only enumerator called by the runtime for implicit expressions

           if (Disposed)
           {
               throw new ObjectDisposedException("DBResourceReader object is already disposed.");
           }

           return this.resourceDictionary.GetEnumerator();
       }

       #endregion

       #region IEnumerable Members

       IEnumerator IEnumerable.GetEnumerator()
       {
           if (Disposed)
           {
               throw new ObjectDisposedException("DBResourceReader object is already disposed.");
           }

           return this.resourceDictionary.GetEnumerator();
       }

       #endregion




       #region IEnumerable<KeyValuePair<string,object>> Members

       IEnumerator<KeyValuePair<string, object>> IEnumerable<KeyValuePair<string, object>>.GetEnumerator()
       {
           if (Disposed)
           {
               throw new ObjectDisposedException("DBResourceReader object is already disposed.");
           }

           return this.resourceDictionary.GetEnumerator() as IEnumerator<KeyValuePair<string, object>>;
       }

       #endregion
   }

}