using System;
using System.Collections.Generic;
using System.Linq;

namespace TDAmeritradeNet
{
    public class PriceHistoryUrl
    {
        private List<string> urls = null;

        public List<string> Urls
        {
            get { return urls; }
            set { urls = value; }
        }
        
        public PriceHistoryUrl()
        {
            urls = new List<string>();
        }

        public void AddRange(List<string> symbols, int period, bool isDaily, bool useSymbolGroup)
        {
            string postUrl = string.Empty;

            // check if the session id is available. if not, then don't include it to the url
            string sessionId = (TDANET.client != null && !string.IsNullOrEmpty(TDANET.client.SessionId))?";jsessionid=" + TDANET.client.SessionId : "";

            
            if (useSymbolGroup)
            {
                // Get best number of symbols per request.
                int maxSymbols = GetMaxSymbols(period, isDaily);

                IEnumerable<string> symbolBlocks = StringHelper.BuildSymbolBlocks(symbols, maxSymbols, ", ");

                foreach (var symbolBlock in symbolBlocks)
                {
                    if (isDaily)
                    {
                        postUrl = String.Format("https://apis.tdameritrade.com/apps/100/PriceHistory{0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=DAILY&intervalduration=1&periodtype=MONTH&period={3}&enddate={4}",
                                                sessionId, TDANET.AppSource, symbolBlock, period, DateTime.Today.ToString("yyyyMMdd"));
                    }
                    else
                    {
                        postUrl = String.Format("https://apis.tdameritrade.com/apps/100/PriceHistory{0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=MINUTE&intervalduration=1&periodtype=DAY&period={3}&enddate={4}&extended=true",
                                                sessionId, TDANET.AppSource, symbolBlock, period, DateTime.Today.ToString("yyyyMMdd"));
                    }

                    urls.Add(postUrl);
                }
            }
            else
            {
                foreach (var symbol in symbols)
                {
                    if (isDaily)
                    {
                        postUrl = String.Format("https://apis.tdameritrade.com/apps/100/PriceHistory{0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=DAILY&intervalduration=1&periodtype=MONTH&period={3}&enddate={4}",
                                                sessionId, TDANET.AppSource, symbol, period, DateTime.Today.ToString("yyyyMMdd"));
                    }
                    else
                    {
                        postUrl = String.Format("https://apis.tdameritrade.com/apps/100/PriceHistory{0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=MINUTE&intervalduration=1&periodtype=DAY&period={3}&enddate={4}&extended=true",
                                                sessionId, TDANET.AppSource, symbol, period, DateTime.Today.ToString("yyyyMMdd"));
                    }

                    urls.Add(postUrl);
                }
            }

        }

        #region Add Symbols #1- group symbols

        //public void AddRange2(List<string> symbols, DateTime startDate, DateTime endDate, bool isDaily)
        //{
        //    if (!symbols.Any()) return;

        //    string postUrl = String.Empty;

        //    startDate = (startDate > endDate) ? endDate : startDate;

        //    // check if the session id is available. if not, then don't include it to the url
        //    string sessionId = (TDANET.client != null && !string.IsNullOrEmpty(TDANET.client.SessionId)) ? ";jsessionid=" + TDANET.client.SessionId : "";

        //    // Get best number of symbols per request.
        //    int maxSymbols = GetMaxSymbols(startDate, endDate, isDaily);

        //    //IEnumerable<string> symbolBlocks = StringHelper.BuildSymbolBlocks(symbols, maxSymbols, ", ");
        //    IEnumerable<string> symbolsGroup = symbols.GroupSymbols(maxSymbols, ", ");

        //    foreach (var symbolBlock in symbolsGroup)
        //    {
        //        if (isDaily)
        //        {
        //            postUrl = String.Format("https://apis.tdameritrade.com/apps/100/PriceHistory{0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=DAILY&intervalduration=1&startdate={3}&enddate={4}",
        //                                    sessionId, TDANET.AppSource, symbolBlock, startDate.ToString("yyyyMMdd"), endDate.ToString("yyyyMMdd"));
        //        }
        //        else
        //        {
        //            postUrl = String.Format("https://apis.tdameritrade.com/apps/100/PriceHistory{0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=MINUTE&intervalduration=1&extended=true&startdate={3}&enddate={4}",
        //                                    sessionId, TDANET.AppSource, symbolBlock, startDate.ToString("yyyyMMdd"), endDate.ToString("yyyyMMdd"));
        //        }

        //        urls.Add(postUrl);
        //    }
        //}

        #endregion


        #region Add Symbols #2 

        public void AddRange(List<string> symbols, DateTime startDate, DateTime endDate, bool isDaily, bool useSymbolGroup)
        {
            if (!symbols.Any()) return;

            string postUrl = String.Empty;

            startDate = (startDate > endDate) ? endDate : startDate;

            // check if the session id is available. if not, then don't include it to the url
            string sessionId = (TDANET.client != null && !string.IsNullOrEmpty(TDANET.client.SessionId)) ? ";jsessionid=" + TDANET.client.SessionId : "";

            if (!useSymbolGroup)
            {
                foreach (var symbol in symbols)
                {
                    if (isDaily)
                    {
                        postUrl = String.Format("https://apis.tdameritrade.com/apps/100/PriceHistory{0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=DAILY&intervalduration=1&startdate={3}&enddate={4}",
                                                sessionId, TDANET.AppSource, symbol, startDate.ToString("yyyyMMdd"), endDate.ToString("yyyyMMdd"));
                    }
                    else
                    {
                        postUrl = String.Format("https://apis.tdameritrade.com/apps/100/PriceHistory{0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=MINUTE&intervalduration=1&extended=true&startdate={3}&enddate={4}",
                                                sessionId, TDANET.AppSource, symbol, startDate.ToString("yyyyMMdd"), endDate.ToString("yyyyMMdd"));
                    }

                    urls.Add(postUrl);
                }
            }
            else
            {
                // Get best number of symbols per request.
                int maxSymbols = GetMaxSymbols(startDate, endDate, isDaily);

                //IEnumerable<string> symbolBlocks = StringHelper.BuildSymbolBlocks(symbols, maxSymbols, ", ");
                IEnumerable<string> symbolsGroup = symbols.GroupSymbols(maxSymbols, ", ");

                foreach (var symbolBlock in symbolsGroup)
                {
                    if (isDaily)
                    {
                        postUrl = String.Format("https://apis.tdameritrade.com/apps/100/PriceHistory{0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=DAILY&intervalduration=1&startdate={3}&enddate={4}",
                                                sessionId, TDANET.AppSource, symbolBlock, startDate.ToString("yyyyMMdd"), endDate.ToString("yyyyMMdd"));
                    }
                    else
                    {
                        postUrl = String.Format("https://apis.tdameritrade.com/apps/100/PriceHistory{0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=MINUTE&intervalduration=1&extended=true&startdate={3}&enddate={4}",
                                                sessionId, TDANET.AppSource, symbolBlock, startDate.ToString("yyyyMMdd"), endDate.ToString("yyyyMMdd"));
                    }

                    urls.Add(postUrl);
                }
            }
        }

        #endregion

        public void Add(string symbol, DateTime startDate, DateTime endDate, bool isDaily)
        {
            if (string.IsNullOrEmpty(symbol)) return;

            string postUrl = String.Empty;

            startDate = (startDate > endDate) ? endDate : startDate;

            // check if the session id is available. if not, then don't include it to the url
            string sessionId = (TDANET.client != null && !string.IsNullOrEmpty(TDANET.client.SessionId)) ? ";jsessionid=" + TDANET.client.SessionId : "";
            
            if (isDaily)
            {
                postUrl = String.Format("https://apis.tdameritrade.com/apps/100/PriceHistory{0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=DAILY&intervalduration=1&startdate={3}&enddate={4}",
                                        sessionId, TDANET.AppSource, symbol, startDate.ToString("yyyyMMdd"), endDate.ToString("yyyyMMdd"));
            }
            else
            {
                postUrl = String.Format("https://apis.tdameritrade.com/apps/100/PriceHistory{0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=MINUTE&intervalduration=1&extended=true&startdate={3}&enddate={4}",
                                        sessionId, TDANET.AppSource, symbol, startDate.ToString("yyyyMMdd"), endDate.ToString("yyyyMMdd"));
            }

            urls.Add(postUrl);
     
        }

        /// <summary>
        /// This is to calculate the optimized request number of symbols
        /// </summary>
        /// <param name="period"></param>
        /// <param name="isDaily"></param>
        /// <returns></returns>
        private static int GetMaxSymbols(int period, bool isDaily)
        {
            period = (period > 0) ? period : 1;
            int maxSymbols = (isDaily) ? 1000000 / (period * 3000) : 1000000 / (period * 15000);
            //maxSymbols = (maxSymbols > 5) ? maxSymbols : 5;
            maxSymbols = (maxSymbols > 0) ? maxSymbols : 1;
            maxSymbols = (maxSymbols < 60) ? maxSymbols : 60;
            return maxSymbols;
        }

        /// <summary>
        /// This is to calculate the optimized request number of symbols
        /// </summary>
        /// <param name="period"></param>
        /// <param name="isDaily"></param>
        /// <returns></returns>
        private static int GetMaxSymbols(DateTime startDate, DateTime endDate, bool isDaily)
        {
            int days = DaysIgnoreWeekends(startDate, endDate);
            days = (days > 0) ? days : 1;
            int maxSymbols = (isDaily) ? 1000000 / (days * 100) : 1000000 / (days * 12000);
            //maxSymbols = (maxSymbols > 5) ? maxSymbols : 5;
            maxSymbols = (maxSymbols > 0) ? maxSymbols : 1;
            maxSymbols = (maxSymbols < 60) ? maxSymbols : 60;
            return maxSymbols;
        }

        private static int DaysIgnoreWeekends(DateTime dtst, DateTime dtend)
        {
            TimeSpan days = dtend.Subtract(dtst);
            int count = 0;
            for (int a = 0; a < days.Days + 1; a++)
            {
                if (dtst.DayOfWeek != DayOfWeek.Saturday && dtst.DayOfWeek != DayOfWeek.Sunday)
                {
                    count++;
                }
                dtst = dtst.AddDays(1.0);
            }
            return count;
        }
    }
}