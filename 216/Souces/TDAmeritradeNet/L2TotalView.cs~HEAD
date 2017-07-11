using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TDAmeritradeNet
{
    public class L2TotalView
    {
        public string Symbol { get; set; }
        public DateTime TimeStamp { get; set; }
        public List<L2TotalViewItem> BidSide { get; set; } 
        public List<L2TotalViewItem> AskSide { get; set; }
        public int RowsCount { get; set; }

        public L2TotalView()
        {
            // EMPTY
        }

        public L2TotalView(byte[] b)
        {
            Symbol = string.Empty;
            TimeStamp = DateTime.MinValue;
            BidSide = new List<L2TotalViewItem>();
            AskSide = new List<L2TotalViewItem>();

            var byteLength = b.Length;
            var i = 0;
            try
            {
                var headerId = b.ConvertToByte(ref i);
                var msgLength = b.ConvertToShort(ref i);
                var sid = b.ConvertToShort(ref i);

                var colNum0 = b.ConvertToColumnNumber(ref i);
                var symbolLength = b.ConvertToShort(ref i);
                this.Symbol = b.ConvertToString(ref i, symbolLength);
                //Debug.Print("L2 Symbol: {0}", this.Symbol);

                var colNum1 = b.ConvertToColumnNumber(ref i);
                var time = b.ConvertToInt32(ref i);
                this.TimeStamp = DateTime.Today.AddMilliseconds(time);
                //Debug.Print("L2 TimeStamp: {0:HH:mm:ss    yyyy-MM-dd}", this.TimeStamp);

                if (i < 0) return; // return on empty data

                var colNum2 = b.ConvertToColumnNumber(ref i);
                var bidLength = b.ConvertToShort(ref i);
                var bidData = b.ConvertToString(ref i, bidLength);

                var colNum3 = b.ConvertToColumnNumber(ref i);
                var askLength = b.ConvertToShort(ref i);
                var askData = b.ConvertToString(ref i, askLength);

                if (i < 0) return; // return on incorrect format

                //if (!string.IsNullOrEmpty(bidData))
                //    Debug.Print("\tBid Data >> {0}", bidData);


                //if (!string.IsNullOrEmpty(askData))
                //    Debug.Print("\tAsk Data >> {0}", askData);

                if (Symbol.Contains(">AD"))
                {
                    /*
                * Parsing Bid Side
                */
                    List<string> bids = bidData.Split(';').ToList();
                    this.BidSide = new List<L2TotalViewItem>();
                    int k = 2;
                    int bidsCount = bids.Count;
                    while (k < bidsCount)
                    {
                        if (string.IsNullOrEmpty(bids[k]))
                            break;

                        if (IsNumeric(bids[k]))
                        {
                            var item = new L2TotalViewItem(true, bids[k], bids[k + 1], null);
                            BidSide.Add(item);
                            k = k + 3;
                        }
                        else
                        {
                            k = k + 3;
                        }
                    }

                    /*
                * Parsing Ask Side
                */
                    List<string> asks = askData.Split(';').ToList();
                    this.AskSide = new List<L2TotalViewItem>();
                    int l = 2;
                    int asksCount = asks.Count;
                    while (l < asksCount)
                    {
                        //Debug.Print("ask count: {0}    l: {1}   value: {2}", asksCount, l, asks[l]);
                        if (string.IsNullOrEmpty(asks[l]))
                            break;

                        if (IsNumeric(asks[l]))
                        {
                            var item = new L2TotalViewItem(false, asks[l], asks[l + 1], null);
                            AskSide.Add(item);
                            l = l + 3;
                        }
                        else
                        {
                            k = k + 3;
                        }
                    }
                }
                else
                {
                    #region Old Codes 5/20/2013

                    /*
                     * Parsing Bid Side
                     */
                    List<string> bids = bidData.Split(';').ToList();
                    this.BidSide = new List<L2TotalViewItem>();
                    int k = 2;
                    int bidsCount = bids.Count;
                    while (k < bidsCount)
                    {
                        //Debug.Print("bids count: {0}    k: {1}   value: {2}", bidsCount, k, bids[k]);
                        if (string.IsNullOrEmpty(bids[k]))
                            break;

                        if (IsNumeric(bids[k]))
                        {
                            var item = new L2TotalViewItem(true, bids[k], bids[k + 1], bids[k + 2], bids[k + 3], bids[k + 4], bids[k + 5]);
                            BidSide.Add(item);
                            k = k + 6;
                        }
                        else
                        {
                            k = k + 3;
                        }
                    }

                    /*
                     * Parsing Ask Side
                     */
                    List<string> asks = askData.Split(';').ToList();
                    this.AskSide = new List<L2TotalViewItem>();
                    int l = 2;
                    int asksCount = asks.Count;
                    while (l < asksCount)
                    {
                        //Debug.Print("ask count: {0}    l: {1}   value: {2}", asksCount, l, asks[l]);
                        if (string.IsNullOrEmpty(asks[l]))
                            break;

                        if (IsNumeric(asks[l]))
                        {
                            var item = new L2TotalViewItem(false, asks[l], asks[l + 1], asks[l + 2], asks[l + 3], asks[l + 4], asks[l + 5]);
                            AskSide.Add(item);
                            l = l + 6;
                        }
                        else
                        {
                            l = l + 3;
                        }
                    }

                    #endregion
                }
                
                int bidRows = BidSide.Count;
                int askRows = AskSide.Count;
                this.RowsCount = (bidRows >= askRows) ? bidRows : askRows;

            }
            catch (Exception)
            {
                throw new FormatException(string.Format("{0} - TotalView parsing failed. (content: {1})", this.Symbol, BitConverter.ToString(b)));
                throw;
            }
        }

        public static Boolean IsNumeric(string stringToTest)
        {
            double result;
            return double.TryParse(stringToTest, out result);
        }
    }


}
