// Copyright 2004-2006, IDesign
// www.idesign.net

using System;
using System.Collections.Generic;
using System.Text;

namespace EPRTR.ResourceProviders
{
    /// <summary>
    /// See http://msdn.microsoft.com/en-us/library/aa905797.aspx#exaspnet20rpm_topic5
    /// </summary>
    public class DisposableBaseType: IDisposable
    {
        private bool disposed;
        protected bool Disposed
        {
           get
           {
                lock(this)
                {
                    return disposed;
                }
            }
        }

    #region IDisposable Members

        public void Dispose()
        {
            lock (this)
            {
                if (disposed == false)
                {
                    Cleanup();
                    disposed = true;

                    GC.SuppressFinalize(this);
                }
            }
        }

        #endregion

        protected virtual void Cleanup()
        {
            // override to provide cleanup
        } 

        ~DisposableBaseType()   
        {
            Cleanup();
        } 

    }

}
