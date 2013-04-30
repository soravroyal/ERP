using System;
using System.Collections.Generic;
using System.Linq;
using LinqUtilities;

namespace QueryLayer
{

    /// <summary>
    /// Holds methods to collect data for news
    /// </summary>
    public static class News
    {
        public class NewsItem
        {
            public int NewsId { get; set; }
            public DateTime NewsDate { get; set; }
            public bool TopNews { get; set; }
            public string TitleText { get; set; }
            public string ContentText { get; set; }
            public string CultureCode { get; set; }
        }

        public class NewItemComparer : IEqualityComparer<NewsItem>
        {
            public bool Equals(NewsItem n1, NewsItem n2)
            {
                return n1.NewsId == n2.NewsId;
            }

            public int GetHashCode(NewsItem n)
            {
                return n.NewsId.GetHashCode();
            }
        }

        /// <summary>
        /// Gets News, ordered by DateTime
        /// </summary>
        /// <returns></returns>
        private static IEnumerable<NewsItem> GetNewsHelper(string cultureCode, bool isTopNews)
        {
            DataClassesNewsDataContext db = getNewsDataContext();
            
            return from val in db.NewsValues
                   join key in db.NewsKeys on val.NewsKeyID equals key.NewsKeyID
                   
                   where val.CultureCode == cultureCode 
                       && key.TopNewsIndicator == isTopNews 
                       && key.Visible == true
                   
                   orderby key.NewsDate descending
                   select new NewsItem()
                   {
                       ContentText = val.BodyText,
                       CultureCode = val.CultureCode,
                       NewsDate = key.NewsDate,
                       NewsId = key.NewsKeyID,
                       TitleText = val.HeaderText,
                       TopNews = key.TopNewsIndicator
                   };
        }

    
        private static IEnumerable<NewsItem> GetNews(string cultureCode, bool isTopNews)
        {
            var nationalNews = GetNewsHelper(cultureCode, isTopNews);
            var englishNews = GetNewsHelper("en-GB", isTopNews);


            // Below could be optimized using linq "Except"
            var completeNews = new List<NewsItem>();

            foreach (var item in englishNews)
            {
                if (nationalNews.Contains(item, new NewItemComparer()))
                {
                    NewsItem n = nationalNews.Single(x => x.NewsId == item.NewsId);
                    completeNews.Add(n);
                }
                else
                {
                    completeNews.Add(item);
                }
            }

            return completeNews;
        }

        /// <summary>
        /// Gets top News itmes
        /// </summary>
        /// <returns></returns>
        public static IEnumerable<NewsItem> GetTopNews(string cultureCode)
        {
            // true -- get top news only
            return GetNews(cultureCode, true);
        }

        /// <summary>
        /// Gets Non-top News itmes
        /// </summary>
        public static IEnumerable<NewsItem> GetNonTopNews(string cultureCode)
        {
            // false -- get NON-top news only
            return GetNews(cultureCode, false);
        }

        /// <summary>
        /// Get News For Home Page
        /// </summary>
        public static IEnumerable<NewsItem> GetNewsForHomePage(string cultureCode, int numOfItems)
        {
            // false -- get NON-top news only
            return GetNews(cultureCode, true).Take(numOfItems);
        }

        /// <summary>
        /// return data context with attached debugger
        /// </summary>
        private static DataClassesNewsDataContext getNewsDataContext()
        {
            DataClassesNewsDataContext db = new DataClassesNewsDataContext();
            db.Log = new DebuggerWriter();
            return db;
        }
        

    }
}
