using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace QueryLayer
{
    public static class News
    {

        public static IEnumerable<NEWS_ITEM> GetNews()
        {
            DataClassesNewsDataContext db = new DataClassesNewsDataContext();
            IEnumerable<NEWS_ITEM> data = db.NEWS_ITEMs.OrderBy(e => e.TimeStamp);

            return data;
        }
        
    }
}
