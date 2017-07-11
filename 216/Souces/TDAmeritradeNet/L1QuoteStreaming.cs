using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;

namespace TDAmeritradeNet
{
    public class L1QuoteStreaming
    {
        //private static ConcurrentDictionary<string, L1QuoteStreaming> l1quotes = new ConcurrentDictionary<string, L1QuoteStreaming>();
        private static Dictionary<string, L1QuoteStreaming> l1quotes = new Dictionary<string, L1QuoteStreaming>();
        private static DateTime fromDate = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);

        public string Symbol { get; set; } //Column: 0
        public float Bid { get; set; } //Column: 1
        public float Ask { get; set; } //Column: 2
        public float Last { get; set; } //Column: 3
        public Color LastColor { get; set; }
        public int LastColorCode { get; set; }
        public int BidSize { get; set; } //Column: 4
        public int AskSize { get; set; } //Column: 5
        public int BIDID { get; set; } //Column: 6
        public int ASKID { get; set; } //Column: 7
        public long Volume { get; set; } //Column: 8
        public int LastSize { get; set; } //Column: 9
        public DateTime TradeTime { get; set; } //Column: 10 & 23
        public DateTime QuoteTime { get; set; } //Column: 11 & 22
        public float High { get; set; } //Column: 12
        public float Low { get; set; } //Column: 13
        public string Tick { get; set; } //Column: 14
        public float Close { get; set; } //Column: 15
        public string Exchange { get; set; } //Column: 16
        public bool Marginable { get; set; } //Column: 17
        public bool Shortable { get; set; } //Column: 18
        public float Volatility { get; set; } //Column: 24
        public string Description { get; set; } //Column: 25
        public float Open { get; set; } //Column: 28
        public float Change { get; set; } //Column: 29
        public float YearHigh { get; set; } //Column: 30
        public float YearLow { get; set; } //Column: 31
        public float PERatio { get; set; } //Column: 32
        public float DividendAmt { get; set; } //Column: 33
        public float DividentYield { get; set; } //Column: 34
        public float NAV { get; set; } //Column: 37
        public float Fund { get; set; } //Column: 38
        public string ExchangeName { get; set; } //Column: 39
        public string DividendDate { get; set; } //Column: 40
        public bool IsFirstQuote = true;
        public bool IsTraded { get; set; } // New Volume > Old Volume
        public bool IsDayHigh { get; set; }
        public bool IsDayLow { get; set; }
        public bool IsYearHigh { get; set; }
        public bool IsYearLow { get; set; }
        public bool IsHigherBid { get; set; }
        public bool IsLowerAsk { get; set; }
        public int LastTradeSize { get; set; }
        public float ChangePercent { get; set; }

        public float OldHigh { get; set; }
        public float OldLow { get; set; }

        public static void RemoveQuote(List<string> symbols)
        {
            if (l1quotes != null)
            {
                foreach (var symbol in symbols)
                {
                    //L1QuoteStreaming l1quote = null;
                    //bool success = l1quotes.TryRemove(symbol, out l1quote);
                    //if (!success)
                    //{
                    //    Debug.Print("Error on removing l1quoteStreaming: {0}", symbol);
                    //}
                    
                    l1quotes.Remove(symbol);
                }
            }
        }

        public L1QuoteStreaming()
        {
            // Empty Constructor
            IsFirstQuote = true;
            LastColor = Color.Cyan;
            LastColorCode = 1;
        }

        public static L1QuoteStreaming AddOrUpdate(byte[] b)
        {
            bool exist = false;
            L1QuoteStreaming obj = null;

            int byteLength = b.Length;
            int tradeTime = 0;
            int tradeDate = 0;
            int quoteTime = 0;
            int quoteDate = 0;
            int i = 0;

            string headerId = b.ConvertToByte(ref i);
            int msgLength = b.ConvertToShort(ref i);
            int sid = b.ConvertToShort(ref i);
            int colNum = b.ConvertToColumnNumber(ref i);
            int symbolLength = b.ConvertToShort(ref i);
            string symbol = b.ConvertToString(ref i, symbolLength);

            if (l1quotes.ContainsKey(symbol))
            {
                obj = l1quotes[symbol];

                obj.OldHigh = obj.High;
                obj.OldLow = obj.Low;

                obj.IsDayHigh = false;
                obj.IsDayLow = false;
                obj.IsYearHigh = false;
                obj.IsYearLow = false;
                obj.IsTraded = false;

                exist = true;
            }
            else
            {
                obj = new L1QuoteStreaming() { Symbol = symbol };
            }

            int col = 0;

            while (i < byteLength)
            {
                col = b.ConvertToColumnNumber(ref i);

                switch (col)
                {
                    case 1:
                        float newBid = b.ConvertToFloat(ref i);
                        obj.Bid = (newBid > 0) ? newBid : 0;
                        break;

                    case 2:
                        float newAsk = b.ConvertToFloat(ref i);
                        obj.Ask = (newAsk > 0) ? newAsk : 0;
                        break;

                    case 3:
                        float newLast = b.ConvertToFloat(ref i);
                        obj.Last = (newLast > 0) ? newLast : 0;
                        break;

                    case 4:
                        int newBidSize = b.ConvertToInt32(ref i);
                        obj.BidSize = (newBidSize > 0) ? newBidSize * 100 : 0;
                        break;

                    case 5:
                        int newAskSize = b.ConvertToInt32(ref i);
                        obj.AskSize = (newAskSize > 0) ? newAskSize * 100 : 0;
                        break;

                    case 6:
                        int newBidId = b.ConvertToShort(ref i);
                        obj.BIDID = (newBidId > 0) ? newBidId : 0;
                        break;

                    case 7:
                        int newAskId = b.ConvertToShort(ref i);
                        obj.ASKID = (newAskId > 0) ? newAskId : 0;
                        break;

                    case 8:
                        long newVolume = b.ConvertToLong(ref i);
                        long oldVolume = obj.Volume;
                        obj.LastTradeSize = (oldVolume > 0) ? Convert.ToInt32(newVolume - oldVolume) : 0;
                        obj.IsTraded = (oldVolume > 0 && obj.LastTradeSize > 0);
                        obj.Volume = (newVolume > 0) ? newVolume : 0;

                        // if there is no previous volume, assusme this is first quote.
                        obj.IsFirstQuote = (oldVolume == 0);

                        break;

                    case 9:
                        int newLastSize = b.ConvertToInt32(ref i);
                        obj.LastSize = (newLastSize > 0) ? newLastSize : 0;
                        break;

                    case 10:
                        tradeTime = b.ConvertToInt32(ref i); // Seconds from midnight
                        break;

                    case 11:
                        quoteTime = b.ConvertToInt32(ref i);
                        break;

                    case 12:
                        float high = b.ConvertToFloat(ref i);

                        if (obj.High == 0)
                        {
                            obj.High = high;
                        }

                        //else if (high > obj.High)
                        //{
                        //    obj.High = high;
                        //    if (high > obj.YearHigh)
                        //    {
                        //        obj.YearHigh = high;
                        //    }
                        //}
                        break;

                    case 13:
                        float low = b.ConvertToFloat(ref i);

                        if (obj.Low == 0)
                        {
                            obj.Low = low;
                        }

                        //else if (low < obj.Low)
                        //{
                        //    obj.Low = low;
                        //    if (low < obj.YearLow)
                        //    {
                        //        obj.YearLow = low;
                        //    }
                        //}
                        break;

                    case 14:
                        obj.Tick = b.ConvertToByte(ref i);
                        break;

                    case 15:
                        obj.Close = b.ConvertToFloat(ref i);
                        break;

                    case 16:
                        obj.Exchange = b.ConvertToChar(ref i);
                        break;

                    case 17:
                        obj.Marginable = b.ConvertToBoolean(ref i);
                        break;

                    case 18:
                        obj.Shortable = b.ConvertToBoolean(ref i);
                        break;

                    case 22:
                        quoteDate = b.ConvertToInt32(ref i); // Days from midnight 1970,1,1
                        break;

                    case 23:
                        tradeDate = b.ConvertToInt32(ref i); // Days from midnight 1970,1,1
                        break;

                    case 24:
                        obj.Volatility = b.ConvertToFloat(ref i);
                        break;

                    case 25:
                        int descLength = b.ConvertToShort(ref i);
                        obj.Description = b.ConvertToString(ref i, descLength).Trim();
                        break;

                    case 28:
                        obj.Open = b.ConvertToFloat(ref i);
                        break;

                    case 29:
                        obj.Change = b.ConvertToFloat(ref i);
                        break;

                    case 30:
                        obj.YearHigh = b.ConvertToFloat(ref i);
                        break;

                    case 31:
                        obj.YearLow = b.ConvertToFloat(ref i);
                        break;

                    case 32:
                        obj.PERatio = b.ConvertToFloat(ref i);
                        break;

                    case 33:
                        obj.DividendAmt = b.ConvertToFloat(ref i);
                        break;

                    case 34:
                        obj.DividentYield = b.ConvertToFloat(ref i);
                        break;

                    case 37:
                        obj.NAV = b.ConvertToFloat(ref i);
                        break;

                    case 38:
                        obj.Fund = b.ConvertToFloat(ref i);
                        break;

                    case 39:
                        int exchLength = b.ConvertToShort(ref i);
                        obj.ExchangeName = b.ConvertToString(ref i, exchLength).Trim();
                        break;

                    case 40:
                        int dividendDateLength = b.ConvertToShort(ref i);
                        obj.DividendDate = b.ConvertToString(ref i, dividendDateLength);
                        break;

                    default:
                        throw new FormatException(string.Format("{0} - L1QuoteStreaming streaming parsing failed. (content: {1})", obj.Symbol, BitConverter.ToString(b)));
                        break;
                }

                if (tradeTime > 0)
                {
                    obj.TradeTime = (tradeDate > 0) ? fromDate.AddDays(tradeDate).AddSeconds(tradeTime) : obj.TradeTime.Date.AddSeconds(tradeTime);
                }

                if (quoteTime > 0)
                {
                    obj.QuoteTime = (quoteDate > 0) ? fromDate.AddDays(quoteDate).AddSeconds(quoteTime) : obj.TradeTime.Date.AddSeconds(quoteTime);
                }
            }

            if (obj.IsTraded)
            {
                obj.SetLastColorCode();
            }

            obj.IsHigherBid = obj.Bid > obj.Last;
            obj.IsLowerAsk = obj.Ask < obj.Last;
            
            /*
             * Update Data
             */
            obj.ChangePercent = (obj.Close > 0) ? (obj.Last - obj.Close)/obj.Close : 0;
            
            #region Update the l1streaming object

            //l1quotes.AddOrUpdate(obj.Symbol, obj, (k, v) => obj);

            if (exist)
            {
                l1quotes[obj.Symbol] = obj;
            }
            else
            {
                l1quotes.Add(obj.Symbol, obj);
            }

            #endregion

            return obj;
        }

        private void SetLastColorCode()
        {
            LastColor = Color.Cyan;
            LastColorCode = 1;

            if (Last == Ask)
            {
                LastColor = Color.Lime;
                LastColorCode = 4;
            }
            else if (Last == Bid)
            {
                LastColor = Color.Orange;
                LastColorCode = 3;
            }

            if (Last > OldHigh && OldHigh > 0)
            {
                LastColor = Color.Yellow; // Day High Color
                LastColorCode = 5;
                High = Last;
                IsDayHigh = true;

                if (Last > YearHigh)
                {
                    YearHigh = Last;
                    IsYearHigh = true;
                }
            }
            else if (Last < OldLow && OldLow > 0)
            {
                LastColor = Color.Red; // Day Low Color
                LastColorCode = 2;
                Low = Last;
                IsDayLow = true;

                if (Last < YearLow)
                {
                    YearLow = Last;
                    IsYearLow = true;
                }
            }
        }

        public static void RemoveAll()
        {
            if (l1quotes != null)
                l1quotes.Clear();
        }
    }

}