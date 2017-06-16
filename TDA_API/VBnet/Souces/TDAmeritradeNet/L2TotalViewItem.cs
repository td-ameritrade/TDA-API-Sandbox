using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public class L2TotalViewItem
    {
        public bool IsBid { get; set; }
        public double Price { get; set; }
        public int AggregateSize { get; set; }
        public int MPIDCount { get; set; }
        public string MPID { get; set; }
        public int QuoteSize { get; set; }
        public DateTime TimeStamp { get; set; }

        public L2TotalViewItem()
        {
            // EMPTY
        }

        public L2TotalViewItem(bool isBid, string price, string size, string mpidCount)
        {
            this.IsBid = isBid;
            this.Price = (!string.IsNullOrEmpty(price)) ? Convert.ToDouble(price) : 0;
            this.AggregateSize = (!string.IsNullOrEmpty(size)) ? Convert.ToInt32(size) : 0;
            this.MPIDCount = (!string.IsNullOrEmpty(mpidCount)) ? Convert.ToInt32(mpidCount) : 0;
        }

        public L2TotalViewItem(bool isBid, string price, string size, string mpidCount, string mpid, string quoteSize, string time)
        {
            this.IsBid = isBid;
            this.Price = Convert.ToDouble(price);
            this.AggregateSize = Convert.ToInt32(size);
            this.MPIDCount = Convert.ToInt32(mpidCount);
            this.MPID = mpid;
            this.QuoteSize = Convert.ToInt32(quoteSize);
            this.TimeStamp = DateTime.Today.AddMilliseconds(Convert.ToDouble(time));
        }
    }
}
