using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public class MarketNewsItem : IComparable<MarketNewsItem>
    {
        private DateTime _pubDate = DateTime.MinValue;
        private string _title = string.Empty;

        public int HashKey { get; set; }
        public string Symbol { get; set; }
        public string Source { get; set; }
        public string Title
        {
            get { return _title; }
            set
            {
                _title = value;
                IsHot = value != null && MarketNews.CheckHotNews(value);
                IsBad = value != null && MarketNews.CheckBadNews(value);
            }
        }
        public string Link { get; set; }
        public string Description { get; set; }
        public bool IsHot { get; set; }
        public bool IsBad { get; set; }
        public bool IsToday { get; set; }

        public DateTime PubDate
        {
            get { return _pubDate; }
            set
            {
                _pubDate = value;
                IsToday = _pubDate >= DateTime.Today.AddHours(-8);
            }
        }
        
        public int CompareTo(MarketNewsItem other)
        {
            return other.PubDate.CompareTo(PubDate);
        }
    }
}
