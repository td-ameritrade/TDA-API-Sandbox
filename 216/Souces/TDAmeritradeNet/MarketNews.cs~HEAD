using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Xml.Linq;
using TDAmeritradeNet;

namespace TDAmeritradeNet
{
    public class MarketNews 
    {
        #region Class Object Session

        private List<MarketNewsItem> _marketNewsItems; 

        public string Symbol { get; set; }
        public int Count { get; set; }
        public DateTime LastUpdated { get; set; }

        public int TodayNewsCount
        {
            get { return MarketNewsItems.Count(o => o.IsToday); }
        }

        public int TodayHotNewsCount
        {
            get { return MarketNewsItems.Count(o => o.IsToday && o.IsHot); }
        }

        public List<MarketNewsItem> MarketNewsItems
        {
            get
            {
                return _marketNewsItems ?? (_marketNewsItems = new List<MarketNewsItem>());
            }

            set
            {
                _marketNewsItems = value;
                Count = _marketNewsItems.Count;
                LastUpdated = DateTime.Now;
            }
        }

        public MarketNews(string symbol)
        {
            Symbol = symbol;
        }

        public void AddMarketNewsItem(MarketNewsItem item)
        {
            if (_marketNewsItems == null)
                _marketNewsItems = new List<MarketNewsItem>();

            _marketNewsItems.Add(item);

            LastUpdated = DateTime.Now;
        }

        public void RemoveMarketNewsItem(MarketNewsItem item)
        {
            if (_marketNewsItems != null)
            {
                _marketNewsItems.Remove(item);
            }
        }

        #endregion
        
        #region Class Static Session

        private static readonly string _newsCachePath = Environment.CurrentDirectory + "\\NewsCache\\";

        // manage request queues here
        private static List<string> _requestQueues = new List<string>();  

        // these keywords are used to filter important news and skipped news
        public static List<string> HotKeywords { get; set; }
        public static List<string> BadKeywords { get; set; }
        
        // container for news sources
        public static List<string> NewsSources { get; set; }

        static MarketNews()
        {
            HotKeywords = new List<string>();
            BadKeywords = new List<string>();

            // check if NewsCache folder exsits
            if (Directory.Exists(_newsCachePath))
            {
                Directory.CreateDirectory(_newsCachePath);
            }
        }

        public static bool CheckHotNews(string words)
        {
            try
            {
                if (!string.IsNullOrEmpty(words))
                {
                    bool isHot = HotKeywords.Any(words.ToLower().Contains);
                    return isHot;
                }
                return false;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public static bool CheckBadNews(string words)
        {
            try
            {
                if (!string.IsNullOrEmpty(words))
                {
                    bool isBad = BadKeywords.Any(words.ToLower().Contains);
                    return isBad;
                }
                return false;
            }
            catch (Exception)
            {
                return false;
            }
        }

        private static string GetSource(string s)
        {
            if (s.ToLower().Contains("yahoo"))
            {
                return "Yahoo";
            }
            if (s.ToLower().Contains("google"))
            {
                return "Google";
            }

            return "n/a";
        }

        public class RssChannel
        {
            public string Title { get; set; }
            public string Link { get; set; }
            public string Description { get; set; }
            public IEnumerable<MarketNewsItem> Items { get; set; }
        }

        #endregion
    }
}