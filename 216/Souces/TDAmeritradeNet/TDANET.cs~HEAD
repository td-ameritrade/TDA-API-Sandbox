using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;

namespace TDAmeritradeNet
{
    public class TDANET
    {
        private static string _appSource = string.Empty;
        private static string _appVersion = "1.0";

        public static Balances CurrentBalances { get; set; }
        public static Positions CurrentPositions { get; set; }
        public static List<OrderStatus> OrderStatuses { get; set; }
        public static List<OrderHistory> OrderHistories { get; set; } 

        public static string AppSource
        {
            get
            {
                if (string.IsNullOrEmpty(_appSource))
                {
                    throw new InvalidOperationException("Error: no AppSource is defined.");
                }

                return _appSource;
            }
            set { _appSource = value; }
        }
        public static string AppVersion
        {
            get { return _appVersion; }
            set { _appVersion = value; }
        }

        public static SynchronizationContext CurrentContext { get; set; }
        public static bool IsLoggedIn { get; set; }
        public static string LastCommand { get; set; }
        public static int LastCommandReturnCode { get; set; }

        private static RequestState currentRequestState = null;
        public static TDAClient client { get; set; }
        private static StreamerInfo _streamerInfo;
        private static string _messageKeyToken = string.Empty;
        private static DateTime fromDate = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
        private static CookieContainer _cookieContainer = new CookieContainer();

        private static bool waitForHeartBeat = false;

        private const int BUFFER_SIZE = 65535;
        //private static ConcurrentQueue<byte[]> msgBlockQueues = new ConcurrentQueue<byte[]>();
        private static BlockingCollection<byte[]> msgBlockQueues = new BlockingCollection<byte[]>(); 
        private static Task processingTask;
        private static CancellationTokenSource cancelTokenSource = null;
        private static bool _isStreamOpen = false;
        private static bool _isLoggingIn = false;
        private static int _streamingErrorCount = 0;

        private static byte[] bytesRemaining = null;
        //private static byte[] _endOfPriceData = new byte[] {255, 255};
        private static byte[] _endOfPriceData = new byte[] {0xFF, 0xFF};
        private static byte[] endDelim = new byte[] {0xFF, 0x0A};
        
        // this will track streaming symbols
        private static Dictionary<StreamingServiceType, List<string>> _streamingServices = new Dictionary<StreamingServiceType, List<string>>();

        public static EventHandler OnLoginStatusChanged;
        public static EventHandler<StreamingEventArgs> OnStreamingChanged;
        public static EventHandler OnL1QuoteStreamingReceived;
        public static EventHandler OnAccountActivityReceived;
        public static EventHandler OnStreamingBarReceived;
        public static EventHandler OnStreamerServerReceived;
        public static EventHandler OnTimeSalesReceived;
        public static EventHandler OnNyseBookReceived;
        public static EventHandler OnTotalViewReceived;
        public static EventHandler OnStreamingNewsReceived;


        #region STATIC CONSTRUCTOR

        static TDANET()
        {
            // sets the maximum number of concurrent connections allowed by a ServicePoint object. 10 should be fine.
            ServicePointManager.DefaultConnectionLimit = 10;
            LastCommandReturnCode = -1; // initialized
            CurrentContext = SynchronizationContext.Current;
        }

        private static void ReportStreamingStatus(object sender)
        {
            var e = sender as StreamingStatusEventArgs;

            Debug.Print("\tCode: {0}, Message: {1}", Enum.GetName(typeof (StreamingErrorCodes), e.Code), e.Message);

            if (e.Code == StreamingErrorCodes.StreamerNotFound)
            {
                if (_streamingErrorCount < 3)
                {
                    if (currentRequestState != null)
                    {
                        currentRequestState.Dispose();
                    }

                    RestartStreaming();
                    _streamingErrorCount++;
                }
                else
                {
                    LogOut();
                }

                return;
            }

            if (e.Code == StreamingErrorCodes.WebRequestError)
            {
                if (_streamingErrorCount < 3)
                {
                    RestartStreaming();
                    _streamingErrorCount++;
                }
                return;
            }

            if (e.Code == StreamingErrorCodes.NullResponse)
            {
                return;
            }

            if (e.Code == StreamingErrorCodes.ResponseException)
            {
                return;
            }

            if (e.Code == StreamingErrorCodes.Disconnected)
            {
                return;
            }
        }

        #endregion

        #region LOGIN & LOGOUT

        public static async Task<string> LogIn(string username, string password)
        {
            string loginMessage = string.Empty;

            if (_isLoggingIn)
            {
                loginMessage = "There is already another logging process. Please wait ...";
                return loginMessage;
            }

            _isLoggingIn = true; // set this to be true to prevent duplicate logging request


            string url = String.Format("https://apis.tdameritrade.com/apps/100/LogIn?source={0}&version={1}",
                                       AppSource, AppVersion);

            var request = new WebPostRequest(url);
            request.Add("userid", username);
            request.Add("password", password);
            Stream stream = await request.GetResponseStreamAsync();

            client = new TDAClient(stream);
            if (client != null && client.IsLoggedIn)
            {
                bool success = await GetStreamerInfo();
                if (success)
                {
                    success = await GetMessageKeyToken();
                    if (success)
                    {
                        success = StartStreaming();
                        if (success)
                        {
                            // Create a task that will process bytes queues
                            // if there is processTask running, kill it
                            KillStreamingTask();

                            cancelTokenSource = new CancellationTokenSource();
                            SynchronizationContext context = SynchronizationContext.Current;
                            processingTask = new Task(ProcessingQueue, context, cancelTokenSource.Token);
                            processingTask.Start();

                            IsLoggedIn = client.IsLoggedIn;

                            AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = "************************ logged in ************************" });

                            if (OnLoginStatusChanged != null)
                            {
                                OnLoginStatusChanged(IsLoggedIn, EventArgs.Empty);
                            }
                        }
                    }
                    else
                    {
                        client.Invalidate();
                        loginMessage = "Getting message key token is failed.";
                    }
                }
                else
                {
                    client.Invalidate();
                    loginMessage = "Getting streamer info is failed.";
                }
            }
            else
            {
                _isLoggingIn = false; // release the logging lock
                loginMessage = client.Error;
            }

            _isLoggingIn = false; // release the logging lock

            return loginMessage;
        }

        public static bool LogOut()
        {
            try
            {
                if (client != null && client.IsLoggedIn)
                {
                    // try to stop streaming
                    StopStreaming();

                    KillStreamingTask();

                    var post = new WebPostRequest(String.Format("https://apis.tdameritrade.com/apps/100/LogOut;jsessionid={0}?source={1}", client.SessionId, AppSource));

                    string result = post.GetResponseString();

                    if (result.Contains("LoggedOut"))
                    {
                        client.Invalidate();

                        IsLoggedIn = false;

                        if (OnLoginStatusChanged != null)
                        {
                            OnLoginStatusChanged(IsLoggedIn, EventArgs.Empty);
                        }

                        Debug.Print("************************ logged out ************************");
                        AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = "************************ logged out ************************" });

                        return true;
                    }
                }
            }
            catch (Exception e)
            {
                Debug.Print(String.Format("Logout Exception: {0}", e.Message));
            }
            return false;
        }

        #endregion

        #region STREAMER INFO & MESSAGE KEY TOKEN

        /// <summary>
        /// The streamer info is required before starting request streaming service.
        /// </summary>
        /// <returns></returns>
        public static async Task<bool> GetStreamerInfo()
        {
            if (client != null && client.IsLoggedIn)
            {
                string url = String.Format("https://apis.tdameritrade.com/apps/100/StreamerInfo;jsessionid={0}?source={1}", client.SessionId, AppSource);

                var request = new WebPostRequest(url);
                Stream stream = await request.GetResponseStreamAsync();
                _streamerInfo = new StreamerInfo(stream);
                return string.IsNullOrEmpty(_streamerInfo.ErrorMsg);
            }
            return false;
        }

        /// <summary>
        /// The message key token is required to subscribe account activity streaming
        /// </summary>
        /// <returns></returns>
        public static async Task<bool> GetMessageKeyToken()
        {
            if (client != null && client.IsLoggedIn)
            {
                _messageKeyToken = string.Empty;
                string url = String.Format("https://apis.tdameritrade.com/apps/100/MessageKey;jsessionid={0}?source={1}&accountid={2}", client.SessionId, AppSource, client.AssociatedAccount.AccountId);

                var request = new WebPostRequest(url);
                Stream stream = await request.GetResponseStreamAsync();
                if (stream.CanRead)
                {
                    XElement xml = XDocument.Load(stream).Root;
                    if (xml.Element("result").Value == "OK")
                    {
                        _messageKeyToken = xml.Element("message-key").Element("token").Value;
                        Debug.Print("\r\nMessage Key Token Received ===> {0}\r\n", _messageKeyToken);
                        AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = string.Format("\r\nMessage Key Token => {0}\r\n", _messageKeyToken) });
                        return !string.IsNullOrEmpty(_messageKeyToken);
                    }
                }
            }

            return false;
        }

        #endregion

        #region BALANCES & POSITIONS

        public static async Task<Balances> GetBalancesAsync()
        {
            if (IsLoggedIn)
            {
                string url = String.Format("https://apis.tdameritrade.com/apps/100/BalancesAndPositions;jsessionid={0}?source={1}&type=b", client.SessionId, client.AssociatedAccountId);

                var request = new WebPostRequest(url);
                Stream stream = await request.GetResponseStreamAsync();
                CurrentBalances = new Balances(stream);
                Debug.Print("Downloaded Balanaces...");
                return CurrentBalances;
            }
            return new Balances();
        }

        public static async Task<Positions> GetPositionsAsync()
        {
            if (IsLoggedIn)
            {
                string url = String.Format("https://apis.tdameritrade.com/apps/100/BalancesAndPositions;jsessionid={0}?source={1}&type=p", client.SessionId, client.AssociatedAccountId);

                var request = new WebPostRequest(url);
                Stream stream = await request.GetResponseStreamAsync();
                CurrentPositions = new Positions(stream);
                Debug.Print("Downloaded Positions...");
                return CurrentPositions;
            }
            return new Positions();
        }

        #endregion

        #region ORDER, TRANSACTION, HISTORY

        public static async Task<List<OrderStatus>> GetOrderStatusAsync()
        {
            if (client != null && client.IsLoggedIn)
            {
                string url = String.Format("https://apis.tdameritrade.com/apps/100/OrderStatus;jsessionid={0}?source={1}", client.SessionId, AppSource);
                Debug.Print(" Sending OrderStatus request ==> {0}", url);
                var request = new WebPostRequest(url);
                Stream stream = await request.GetResponseStreamAsync();
                OrderStatuses = OrderStatus.Parse(stream);
                Debug.Print("Downloaded Order Statuses...");
                return OrderStatuses;
            }

            return new List<OrderStatus>();
        }

        public static async Task<List<OrderStatus>> GetOrderStatusAsync(int days, string statusType)
        {
            if (client != null && client.IsLoggedIn)
            {
                string url = String.Format("https://apis.tdameritrade.com/apps/100/OrderStatus;jsessionid={0}?source={1}&accountid={2}&type={3}&days={4}", client.SessionId, AppSource, client.AssociatedAccountId ,statusType, days);
                Debug.Print(" Sending OrderStatus request ==> {0}", url);
                var request = new WebPostRequest(url);
                Stream stream = await request.GetResponseStreamAsync();
                OrderStatuses = OrderStatus.Parse(stream);
                Debug.Print("Downloaded Order Statuses...");
                return OrderStatuses;
            }

            return new List<OrderStatus>();
        }

        public static async Task<List<OrderStatus>> GetOrderStatusAsync(DateTime fromDate, DateTime toDate, string statusType)
        {
            if (client != null && client.IsLoggedIn)
            {
                string url = String.Format("https://apis.tdameritrade.com/apps/100/OrderStatus;jsessionid={0}?source={1}&accountid={2}&type={3}&fromdate={4}&todate={5}", client.SessionId, AppSource, client.AssociatedAccountId, statusType, fromDate.ToString("yyyyMMdd"), toDate.ToString("yyyyMMdd"));
                Debug.Print(" Sending OrderStatus request ==> {0}", url);
                var request = new WebPostRequest(url);
                Stream stream = await request.GetResponseStreamAsync();
                OrderStatuses = OrderStatus.Parse(stream);
                Debug.Print("Downloaded Order Statuses...");
                return OrderStatuses;
            }

            return new List<OrderStatus>();
        }

        public static async Task<EquityOrderResponse> SubmitOrder(string orderString)
        {
            if (client != null && client.IsLoggedIn)
            {
                string url = string.Empty;
                if (orderString.Contains("ordticket"))
                {
                    url = String.Format("https://apis.tdameritrade.com/apps/100/ConditionalEquityTrade;jsessionid={0}?source={1}&orderstring={2}", client.SessionId, AppSource, orderString);
                }
                else
                {
                    url = String.Format("https://apis.tdameritrade.com/apps/100/EquityTrade;jsessionid={0}?source={1}&orderstring={2}", client.SessionId, AppSource, orderString);
                }
                var request = new WebPostRequest(url);
                Stream stream = await request.GetResponseStreamAsync();
                var trade = new EquityOrderResponse();
                trade.Parse(stream);
                return trade;
            }
            return new EquityOrderResponse();
        }

        public static async Task<OrderCancel> CancelOrder(string orderId)
        {
            if (client != null && client.IsLoggedIn)
            {
                string url = String.Format("https://apis.tdameritrade.com/apps/100/OrderCancel;jsessionid={0}?source={1}&orderid={2}", client.SessionId, AppSource, orderId);

                var request = new WebPostRequest(url);
                Stream stream = await request.GetResponseStreamAsync();
                var cancel = new OrderCancel();
                cancel.Parse(stream);
                return cancel;
            }
            return new OrderCancel();
        }

        public static async Task<List<OrderHistory>> GetOrderHistoryAsync(int years)
        {
            string startDate = DateTime.Now.AddYears(years * -1).ToString("yyyyMMdd");
            string endDate = DateTime.Now.ToString("yyyyMMdd");

            if (client != null && client.IsLoggedIn)
            {
                string url = String.Format("https://apis.tdameritrade.com/apps/100/History;jsessionid={0}?source={1}&type=0&startdate={2}&enddate={3}", client.SessionId, AppSource, startDate, endDate);

                var request = new WebPostRequest(url);
                Stream stream = await request.GetResponseStreamAsync();
                var orderHistory = new OrderHistory();
                OrderHistories = orderHistory.Parse(stream);
                Debug.Print("Downloaded Order Histories...");
                return OrderHistories;
            }
            return new List<OrderHistory>();
        }

        public static async Task<List<OrderHistory>> GetOrderHistoryAsync(int days, int transactionType)
        {
            string startDate = DateTime.Now.AddDays(days * -1).ToString("yyyyMMdd");
            string endDate = DateTime.Now.ToString("yyyyMMdd");

            if (client != null && client.IsLoggedIn)
            {
                string url = String.Format("https://apis.tdameritrade.com/apps/100/History;jsessionid={0}?source={1}&type={2}&startdate={3}&enddate={4}", client.SessionId, AppSource, transactionType ,startDate, endDate);

                var request = new WebPostRequest(url);
                Stream stream = await request.GetResponseStreamAsync();
                var orderHistory = new OrderHistory();
                OrderHistories = orderHistory.Parse(stream);
                Debug.Print("Downloaded Order Histories...");
                return OrderHistories;
            }
            return new List<OrderHistory>();
        }

        #endregion

        #region SYMBOL LOOKUP

        public static async Task<List<SymbolLookup>> GetSymbolLookup(string keyword)
        {
            var items = new List<SymbolLookup>();

            if (client != null && client.IsLoggedIn)
            {
                string url = String.Format("https://apis.tdameritrade.com/apps/100/SymbolLookup;jsessionid={0}?source={1}&matchstring={2}", client.SessionId, AppSource, keyword);

                var request = new WebPostRequest(url);
                Stream stream = await request.GetResponseStreamAsync();
                XDocument doc = XDocument.Load(stream);

                foreach (var element in doc.Descendants("symbol-result"))
                {
                    string symbol = element.Elements("symbol").FirstOrDefault().Value;
                    string description = element.Elements("description").FirstOrDefault().Value;
                    items.Add(new SymbolLookup() {Symbol = symbol, Description = description});
                }
            }

            return items;
        }

        #endregion

        #region L1QUOTE SNAPSHOT

        public static async Task<SnapshotResultsArgs> GetSnapshotAsync(List<string> symbols, RequestSourceType source)
        {
            var l1quotes = new List<L1QuoteSnapshot>();

            if (client != null && client.IsLoggedIn)
            {

                IEnumerable<string> symbolBlocks = StringHelper.BuildSymbolBlocks(symbols, 300, ","); // max symbols per request is 300.

                IEnumerable<Task<Stream>> queries = from s in symbolBlocks
                                                    select RequestSnapshot(s);

                List<Task<Stream>> tasks = queries.ToList();

                while (tasks.Count > 0)
                {
                    Task<Stream> task = await Task.WhenAny(tasks);
                    tasks.Remove(task);

                    if (task.Status != TaskStatus.Canceled)
                    {
                        Stream s1 = await task;
                        l1quotes.AddRange(ProcessSnapshot(s1));
                    }
                }
            }

            return new SnapshotResultsArgs() {SourceType = source, Results = l1quotes};
        }

        /// <summary>
        /// Even snapshot download using different method
        /// </summary>
        /// <param name="symbols"></param>
        /// <returns></returns>
        public static async Task<SnapshotResultsArgs> GetSnapshotAsync2(List<string> symbols, RequestSourceType source)
        {
            var l1quotes = new List<L1QuoteSnapshot>();

            if (client != null && client.IsLoggedIn)
            {
                var tasks = new List<Task>();

                IEnumerable<string> symbolBlocks = StringHelper.BuildSymbolBlocks(symbols, 300, ","); // max symbols per request is 300.
                TaskScheduler ui = TaskScheduler.FromCurrentSynchronizationContext();
                foreach (string blockItem in symbolBlocks)
                {
                    string block = blockItem;

                    Task<List<L1QuoteSnapshot>> t1 = Task.Factory.StartNew(() =>
                                                                               {
                                                                                   string postUrl =
                                                                                       String.Format("https://apis.tdameritrade.com/apps/100/Quote;jsessionid={0}?source={1}&symbol={2}",
                                                                                                     client.SessionId, AppSource, block);

                                                                                   var myPost = new WebPostRequest(postUrl);
                                                                                   Debug.Print("requesting snapshot for {0}", block);

                                                                                   Stream stream = myPost.GetResponseStream();
                                                                                   List<L1QuoteSnapshot> items = ProcessSnapshot(stream);
                                                                                   return items;
                                                                               });

                    tasks.Add(t1);

                    Task t2 = t1.ContinueWith(resultTask =>
                                                  {
                                                      List<L1QuoteSnapshot> snapshots = resultTask.Result;
                                                      l1quotes.AddRange(snapshots);
                                                  }, ui);
                }

                Task<bool> t3 = Task.Factory.ContinueWhenAll(tasks.ToArray(), result => { return true; },
                                                             CancellationToken.None, TaskContinuationOptions.None, ui);

                bool result1 = await t3;
            }

            return new SnapshotResultsArgs() { SourceType = source, Results = l1quotes };
        }

        private static async Task<Stream> RequestSnapshot(string symbols)
        {
            // check if the session id is available. if not, then don't include it to the url
            // string sessionId = (client != null && !string.IsNullOrEmpty(client.SessionId)) ? "" + client.SessionId : "";
            string postUrl = String.Format("https://apis.tdameritrade.com/apps/100/Quote;jsessionid={0}?source={1}&symbol={2}",
                                           client.SessionId, AppSource, symbols);

            var myPost = new WebPostRequest(postUrl);
            return await myPost.GetResponseStreamAsync();
        }

        private static List<L1QuoteSnapshot> ProcessSnapshot(Stream stream)
        {
            var items = new List<L1QuoteSnapshot>();

            if (stream == null || !stream.CanRead) return items;

            var settings = new XmlReaderSettings();
            settings.IgnoreWhitespace = true;
            settings.IgnoreComments = true;

            using (XmlReader reader = XmlReader.Create(stream, settings))
            {
                /*
                 * Get result
                 */
                try
                {
                    reader.ReadToFollowing("result");
                    //Debug.Print("result: {0}", reader.ReadElementContentAsString());

                    while (reader.Read())
                    {
                        if (reader.NodeType == XmlNodeType.Element &&
                            reader.LocalName.Equals("quote"))
                        {
                            var quote = new L1QuoteSnapshot();
                            bool endQuote = false;

                            while (!endQuote && reader.Read())
                                // condition order is important because reader.Read() won't be executed if endQuote = true
                            {
                                if (reader.NodeType == XmlNodeType.Element &&
                                    reader.NodeType != XmlNodeType.EndElement)
                                {
                                    switch (reader.LocalName)
                                    {
                                        case "error":
                                            reader.Read();
                                            quote.Error = reader.Value;
                                            break;

                                        case "symbol":
                                            reader.Read();
                                            quote.Symbol = reader.Value;
                                            break;

                                        case "description":
                                            reader.Read();
                                            quote.Description = reader.Value.Trim();
                                            break;

                                        case "bid":
                                            reader.Read();
                                            quote.Bid = (!String.IsNullOrEmpty(reader.Value))
                                                            ? Convert.ToSingle(reader.Value)
                                                            : 0;
                                            break;

                                        case "ask":
                                            reader.Read();
                                            quote.Ask = (!String.IsNullOrEmpty(reader.Value))
                                                            ? Convert.ToSingle(reader.Value)
                                                            : 0;
                                            break;

                                        case "bid-ask-size":
                                            reader.Read();
                                            quote.BidAskSize = reader.Value;
                                            break;

                                        case "last":
                                            reader.Read();
                                            quote.Last = (!String.IsNullOrEmpty(reader.Value))
                                                             ? Convert.ToSingle(reader.Value)
                                                             : 0;
                                            break;

                                        case "last-trade-size":
                                            reader.Read();
                                            quote.LastTradeSize = (!String.IsNullOrEmpty(reader.Value))
                                                                      ? Convert.ToInt32(reader.Value)
                                                                      : 0;
                                            break;

                                        case "last-trade-date":
                                            reader.Read();
                                            if (!string.IsNullOrEmpty(reader.Value) && reader.Value.Contains("EDT"))
                                            {
                                                quote.LastTradeDate = DateTime.ParseExact(reader.Value, "yyyy-MM-dd HH:mm:ss EDT", CultureInfo.InvariantCulture).ToUniversalTime().ToLocalTime();
                                            }
                                            else if (!string.IsNullOrEmpty(reader.Value) && reader.Value.Contains("EST"))
                                            {
                                                quote.LastTradeDate = DateTime.ParseExact(reader.Value, "yyyy-MM-dd HH:mm:ss EST", CultureInfo.InvariantCulture).ToUniversalTime().ToLocalTime();
                                            }
                                            break;

                                        case "open":

                                            reader.Read();
                                            quote.Open = (!String.IsNullOrEmpty(reader.Value))
                                                             ? Convert.ToSingle(reader.Value)
                                                             : 0;
                                            break;

                                        case "high":
                                            reader.Read();
                                            quote.High = (!String.IsNullOrEmpty(reader.Value))
                                                             ? Convert.ToSingle(reader.Value)
                                                             : 0;
                                            break;

                                        case "low":
                                            reader.Read();
                                            quote.Low = (!String.IsNullOrEmpty(reader.Value))
                                                            ? Convert.ToSingle(reader.Value)
                                                            : 0;
                                            break;

                                        case "close":
                                            reader.Read();
                                            quote.Close = (!String.IsNullOrEmpty(reader.Value))
                                                              ? Convert.ToSingle(reader.Value)
                                                              : 0;
                                            break;

                                        case "volume":
                                            reader.Read();
                                            quote.Volume = (!String.IsNullOrEmpty(reader.Value))
                                                               ? Convert.ToSingle(reader.Value)
                                                               : 0;
                                            break;

                                        case "year-high":
                                            reader.Read();
                                            quote.YearHigh = (!String.IsNullOrEmpty(reader.Value))
                                                                 ? Convert.ToSingle(reader.Value)
                                                                 : 0;
                                            break;

                                        case "year-low":
                                            reader.Read();
                                            quote.YearLow = (!String.IsNullOrEmpty(reader.Value))
                                                                ? Convert.ToSingle(reader.Value)
                                                                : 0;
                                            break;

                                        case "real-time":
                                            reader.Read();
                                            quote.Realtime = Convert.ToBoolean(reader.Value);
                                            break;

                                        case "exchange":
                                            reader.Read();
                                            quote.Exchange = reader.Value;
                                            break;

                                        case "asset-type":
                                            reader.Read();
                                            quote.AssetType = reader.Value;
                                            break;

                                        case "change":
                                            reader.Read();
                                            quote.Change = (!String.IsNullOrEmpty(reader.Value))
                                                               ? Convert.ToSingle(reader.Value)
                                                               : 0;
                                            break;

                                        case "change-percent":
                                            reader.Read();
                                            quote.ChangePercent = (!String.IsNullOrEmpty(reader.Value))
                                                                      ? Convert.ToSingle(reader.Value.Replace("%", ""))/100
                                                                      : 0;

                                            break;
                                        default:
                                            Debug.Print("default reader localname: {0}", reader.LocalName);
                                            break;
                                    }
                                }
                                else if (reader.NodeType == XmlNodeType.EndElement &&
                                         reader.LocalName == "quote")
                                {
                                    //Debug.Print("Symbol: {0}, Last: {1}, Change: {2}, Change(%): {3:P2}", quote.Symbol, quote.Last, quote.Change, quote.ChangePercent);
                                    items.Add(quote);
                                    endQuote = true;
                                }
                            }
                        }
                    }
                }
                catch (Exception e)
                {
                    Debug.Print("TDANET Snapshot exception: {0}", e.Message);
                }
            }

            return items;
        }

        #endregion

        #region ADD/REMOVE SERVICE

        public static void Subscribe(List<string> symbols, StreamingServiceType serviceServiceType)
        {
            if (symbols == null || symbols.Count == 0) return;

            if (!IsLoggedIn)
            {
                return; // void on not logged in
            }

            symbols = symbols.Distinct().ToList();

            string cmd = string.Empty;
            
            var previousSymbols = new List<string>();
            if (_streamingServices.ContainsKey(serviceServiceType))
            {
                previousSymbols = _streamingServices[serviceServiceType].Distinct().ToList();
                symbols.RemoveAll(previousSymbols.Contains);
                _streamingServices[serviceServiceType].AddRange(symbols); // Update symbols list
            }
            else
            {
                _streamingServices.Add(serviceServiceType, symbols);
            }

            
            switch (serviceServiceType)
            {
                case StreamingServiceType.L1QuoteStreaming:
                    cmd = "S=QUOTE&C=ADD&P={0}&T=0+1+2+3+4+5+6+7+8+9+10+11+12+13+15+16+17+18+22+23+24+25+28+29+30+31+39";
                    break;

                case StreamingServiceType.L2NYSEBook:
                    cmd = "S=NYSE_BOOK&C=ADD&P={0}&T=0+1+2";
                    break;

                case StreamingServiceType.L2TotalViewL2:
                    cmd = "S=TOTAL_VIEW&C=ADD&P={0}&T=0+1+2+3";
                    break;

                case StreamingServiceType.L2TotalViewAD:
                    cmd = "S=TOTAL_VIEW&C=ADD&P={0}&T=0+1+2+3";
                    break;

                case StreamingServiceType.TimeSales:
                    cmd = "S=TIMESALE&C=ADD&P={0}&T=0+1+2+3+4";
                    break;

                case StreamingServiceType.News:
                    cmd = "S=NEWS&C=ADD&P={0}&T=0+1+2+3";
                    break;

                case StreamingServiceType.NASDAQ_Chart:
                    cmd = "S=NASDAQ_CHART&C=ADD&P={0}&T=0+1+2+3+4+5+6";
                    break;

                    //**************************************************
                    // Add more commands
                    //**************************************************
            }

            if (symbols.Count > 0 && !string.IsNullOrEmpty(cmd))
            {
                if (serviceServiceType == StreamingServiceType.L2TotalViewL2)
                {
                    cmd = String.Format(cmd, String.Join("+", symbols.Select(o => o + ">L2")));
                }
                else if (serviceServiceType == StreamingServiceType.L2TotalViewAD)
                {
                    cmd = String.Format(cmd, String.Join("+", symbols.Select(o => o + ">AD")));
                }
                else
                {
                    cmd = String.Format(cmd, String.Join("+", symbols));
                }

                if (LastCommand == cmd)
                {
                    Debug.Print("Submitted Even Command: {0}", cmd);
                    return;
                }

                LastCommand = cmd;

                // when running in seperate thread, the current context value will be null
                // so the value must be checked before proceeding below code
                if (SynchronizationContext.Current != null)
                {
                    var ui = TaskScheduler.FromCurrentSynchronizationContext();
                    Task<bool> task = Task.Factory.StartNew(() => SubmitCommand(cmd));
                    task.ContinueWith(r =>
                    {
                        bool success = r.Result;
                        if (success && OnStreamingChanged != null)
                        {
                            OnStreamingChanged(null, new StreamingEventArgs() { Symbols = symbols, StreamingServiceType = serviceServiceType, IsSubscription = true });
                        }

                    }, CancellationToken.None, TaskContinuationOptions.None, ui);
                }
                else
                {
                    bool success = SubmitCommand(cmd);
                    if (success && OnStreamingChanged != null)
                    {
                        OnStreamingChanged(null, new StreamingEventArgs() { Symbols = symbols, StreamingServiceType = serviceServiceType, IsSubscription = true });
                    }
                }

                Debug.Print("\r\n---> Sent Subscribed Command: {0} | Service: {1}", string.Join(",", symbols), Enum.GetName(typeof(StreamingServiceType), serviceServiceType));

                string message = string.Format("Sent Subscribed Command: {0} | Service: {1}", string.Join(",", symbols), Enum.GetName(typeof(StreamingServiceType), serviceServiceType));
                AppLog.Insert(new AppLog() { LogType = AppLogType.Info, Message = message });
            }
        }

        public static void Unsubscribe(List<string> symbols, StreamingServiceType streamingServiceType)
        {
            if (symbols == null || symbols.Count == 0) return;

            if (!IsLoggedIn)
            {
                return;
            }

            string cmd = string.Empty;
            //var previousSymbols = new List<string>();
            var symbolsToRemove = symbols.Distinct().ToList();
            if (_streamingServices.ContainsKey(streamingServiceType))
            {
                _streamingServices[streamingServiceType].RemoveAll(symbols.Contains); // Update the symbols list
            }
            else
            {
                Debug.Print("there is no symbols to remove");
                return;
            }

            switch (streamingServiceType)
            {
                case StreamingServiceType.L1QuoteStreaming:
                    cmd = "S=QUOTE&C=UNSUBS&P={0}";
                    break;

                case StreamingServiceType.L2TotalViewL2:
                    cmd = "S=TOTAL_VIEW&C=UNSUBS&P={0}";
                    break;

                case StreamingServiceType.TimeSales:
                    cmd = "S=TIMESALE&C=UNSUBS&P={0}";
                    break;

                case StreamingServiceType.News:
                    cmd = "S=NEWS&C=UNSUBS&P={0}";
                    break;

                case StreamingServiceType.NASDAQ_Chart:
                    cmd = "S=NASDAQ_CHART&C=UNSUBS&P={0}";
                    break;
            }

            if (symbolsToRemove.Count > 0 && !string.IsNullOrEmpty(cmd))
            {
                cmd = String.Format(cmd, String.Join("+", symbolsToRemove));

                // when running in seperate thread, the current context value will be null
                // so the value must be checked before proceeding below code
                if (SynchronizationContext.Current != null)
                {
                    var ui = TaskScheduler.FromCurrentSynchronizationContext();
                    Task<bool> task = Task.Factory.StartNew(() => SubmitCommand(cmd));
                    task.ContinueWith(r =>
                    {
                        bool success = r.Result;
                        if (success && OnStreamingChanged != null)
                        {
                            OnStreamingChanged(null, new StreamingEventArgs() { Symbols = symbolsToRemove, StreamingServiceType = streamingServiceType, IsSubscription = false });
                        }
                    }, CancellationToken.None, TaskContinuationOptions.None, ui);
                }
                else
                {
                    bool success = SubmitCommand(cmd);
                    if (success && OnStreamingChanged != null)
                    {
                        OnStreamingChanged(null, new StreamingEventArgs() { Symbols = symbolsToRemove, StreamingServiceType = streamingServiceType, IsSubscription = false });
                    }
                }

                Debug.Print("\r\n---> Sent Unsubscribed Command: {0} | Service: {1}", string.Join(",", symbolsToRemove), Enum.GetName(typeof(StreamingServiceType), streamingServiceType));

                string message = string.Format("Sent Unsubscribed Command: {0} | Service: {1}", string.Join(",", symbolsToRemove), Enum.GetName(typeof(StreamingServiceType), streamingServiceType));
                AppLog.Insert(new AppLog() { LogType = AppLogType.Info, Message = message });

            }
        }


        public static void UnsubscribeAll(StreamingServiceType serviceType)
        {
            if (_streamingServices.ContainsKey(serviceType))
            {
                Unsubscribe(_streamingServices[serviceType], serviceType);
            }
        }

        public static void UnsubscribeAll()
        {
            foreach (StreamingServiceType serviceType in Enum.GetValues(typeof (StreamingServiceType)))
            {
                if (_streamingServices.ContainsKey(serviceType))
                {
                    Unsubscribe(_streamingServices[serviceType], serviceType);
                    Thread.Sleep(100);
                }
            }
        }


        #endregion

        #region START/STOP STREAMING

        /// <summary>
        /// Submit first streaming request with account activity and monopolize. This stream connection will be used for further request.
        /// </summary>
        /// <returns></returns>
        public static bool StartStreaming()
        {
            try
            {
                if (string.IsNullOrEmpty(_messageKeyToken)) return false;

                _isStreamOpen = false;

                if (currentRequestState != null)
                {
                    currentRequestState.Dispose();
                    currentRequestState = null;
                }

                // clear old cached quotes on l1quoteStreaming class
                L1QuoteStreaming.RemoveAll();

                // clear old streaming services to prepare new one
                _streamingServices.Clear();

                // create command string
                string _streamerCommand = "S=ACCT_ACTIVITY&C=SUBS&P=" + _messageKeyToken + "&T=0+1+2+3|S=QUOTE&C=MONOPOLIZE";

                // submit the command
                return SubmitCommand(_streamerCommand);
            }
            catch (Exception e)
            {
                Debug.Print(e.Message);
            }

            return false;
        }

        public static void RestartStreaming()
        {
            try
            {
                if (_streamingErrorCount > 3)
                {
                    // Max continous restart is 3 to prevent infinite restart.
                    //throw new InvalidOperationException("Max continous streaming restart count reached. Stop restarting...");
                    return;
                }

                // Copy previous service symbols
                var services = new Dictionary<StreamingServiceType, List<string>>();
                foreach (var streamingService in _streamingServices)
                {
                    services.Add(streamingService.Key, new List<string>(streamingService.Value));
                }

                // start streaming
                bool success = StartStreaming();
                if (success)
                {
                    Thread.Sleep(250);
                    // re-subscribe the symbols
                    foreach (var service in services)
                    {
                        Subscribe(service.Value, service.Key);
                    }
                    Debug.Print("Streaming Restarted and streaming {0} services are restored...", services.Count);

                    string message = string.Format("Streaming Restarted and streaming {0} services are restored...", services.Count);
                    AppLog.Insert(new AppLog() { LogType = AppLogType.Info, Message = message });
                }
            }
            catch (Exception ex)
            {
                Debug.Print("Restart Streaming Error: {0}", ex.Message);
            }
        }

        public static bool StopStreaming()
        {
            try
            {
                if (currentRequestState != null)
                {
                    // Unsubscribe all symbols
                    UnsubscribeAll();
                    Thread.Sleep(1000);
                    currentRequestState.Dispose();
                }
                
                Debug.Print("!!! Streaming Stopped !!!");

                string message = "! Streaming Stopped !";
                AppLog.Insert(new AppLog() { LogType = AppLogType.Info, Message = message });

                return true;
            }
            catch (Exception e)
            {
                throw new InvalidOperationException(String.Format("There is an error on stopping streaming. (message: {0})", e.Message));
            }
        }

        #endregion

        #region STREAMING SECTION

        private static bool SubmitCommand(string streamerCommand)
        {
            // http://www.advancesharp.com/Questions/184/convert-a-synchronous-method-to-an-asynchronous-method
            // http://msdn.microsoft.com/en-us/library/86wf6409.aspx

            if (client != null && client.IsLoggedIn)
            {
                if (_isStreamOpen && !streamerCommand.Contains("GET"))
                {
                    streamerCommand = streamerCommand + "|control=true|source=" + _streamerInfo.AppId;
                }
            }
            else
            {
                return false;
            }

            string postUrl = "https://" + _streamerInfo.StreamerUrl;

            var cpostdata = new StringBuilder();

            cpostdata.Append("!U=" + client.AssociatedAccount.AccountId);
            cpostdata.Append("&W=" + _streamerInfo.Token);
            cpostdata.Append("&A=userid=" + client.AssociatedAccount.AccountId);
            cpostdata.Append("&token=" + _streamerInfo.Token);
            cpostdata.Append("&company=" + client.AssociatedAccount.Company);
            cpostdata.Append("&segment=" + client.AssociatedAccount.Segment);
            cpostdata.Append("&cddomain=" + _streamerInfo.CdDomainId);
            cpostdata.Append("&usergroup=" + _streamerInfo.UserGroup);
            cpostdata.Append("&accesslevel=" + _streamerInfo.AccessLevel);
            cpostdata.Append("&authorized=" + _streamerInfo.Authorized);
            cpostdata.Append("&acl=" + _streamerInfo.ACL);
            cpostdata.Append("&timestamp=" + _streamerInfo.TimeStamp);
            cpostdata.Append("&appid=" + _streamerInfo.AppId);
            // append streamer command here *** DO NOT REMOVE "\n\n" ***
            cpostdata.Append("|" + streamerCommand + "\n\n");


            string urlString = cpostdata.ToString();
            Debug.Print("\r\nRequest URL: {0}", urlString);
            string encodedString = Encode_URL(urlString);
            cpostdata = new StringBuilder();
            cpostdata.Append(encodedString);

            var httpWebRequest = (HttpWebRequest) WebRequest.Create(postUrl);
            httpWebRequest.ContentType = "application/x-www-form-urlencoded";
            //req.Accept =
            //    "Accept image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-powerpoint, application/vnd.ms-excel, application/msword, application/x-shockwave-flash, */*";
            //req.Method = "GET";
            httpWebRequest.Method = "POST";
            httpWebRequest.SendChunked = false;
            httpWebRequest.ServicePoint.Expect100Continue = false;
            httpWebRequest.MaximumResponseHeadersLength = 650000;
            httpWebRequest.Headers.Add(HttpRequestHeader.AcceptEncoding, "gzip,deflate");
            httpWebRequest.AutomaticDecompression = DecompressionMethods.GZip | DecompressionMethods.Deflate;
            httpWebRequest.Timeout = 5000;
            httpWebRequest.ReadWriteTimeout = 5000;
            httpWebRequest.ServicePoint.ConnectionLimit = 10; // 150;

            // Add Cookie
            httpWebRequest.CookieContainer = _cookieContainer;

            //currentRequestState = new RequestState();
            //currentRequestState.WebRequest = httpWebRequest;

            //for POST
            var objEncoding = new ASCIIEncoding();
            string s = cpostdata.ToString();
            //Debug.Print("post content: {0}", s);
            byte[] objBytes = objEncoding.GetBytes(s);
            httpWebRequest.ContentLength = objBytes.Length;

            try
            {
                using (Stream stream = httpWebRequest.GetRequestStream())
                {
                    stream.Write(objBytes, 0, objBytes.Length);
                }

                if (!_isStreamOpen)
                {
                    Debug.Print("===============>>> Creating new stream connection <<<================");

                    string message = string.Format(">>> Creating new stream connection <<<");
                    AppLog.Insert(new AppLog() { LogType = AppLogType.Info, Message = message });

                    currentRequestState = new RequestState();
                    currentRequestState.WebRequest = httpWebRequest;
                    var r = (IAsyncResult) httpWebRequest.BeginGetResponse(new AsyncCallback(ResponseCallback), currentRequestState);
                    _streamingErrorCount = 0;

                    return true;
                }
                else
                {
                    #region GETTING SERVER RESPONSE CODE

                    try
                    {
                        byte[] b;
                        using (WebResponse response = httpWebRequest.GetResponse())
                        {
                            using (Stream stream = response.GetResponseStream())
                            {
                                var buffer = new byte[1024];
                                using (var ms = new MemoryStream())
                                {
                                    while (true)
                                    {
                                        int read = stream.Read(buffer, 0, buffer.Length);
                                        if (read <= 0)
                                        {
                                            b = ms.ToArray();
                                            break;
                                        }
                                        ms.Write(buffer, 0, read);
                                    }
                                }
                            }
                        }

                        //Debug.Print("BYTE[]: {0}", BitConverter.ToString(b));
                    
                        var streamServer = new StreamServer(b);

                        Debug.Print("Request Response Status: Service ID: {0}, MessageCode: {1}, Message: {2}", streamServer.ServiceID, streamServer.ReturnCode, streamServer.Description);

                        string message = string.Format("Request Response Status: Service ID: {0}, MessageCode: {1}, Message: {2}", streamServer.ServiceID, streamServer.ReturnCode, streamServer.Description);
                        AppLog.Insert(new AppLog() { LogType = AppLogType.Info, Message = message });

                        LastCommandReturnCode = streamServer.ReturnCode;

                        if (OnStreamerServerReceived != null)
                        {
                            OnStreamerServerReceived(streamServer, EventArgs.Empty);
                        }

                        // if stream connection not found, try to restart again
                        if (streamServer.ReturnCode == 20)
                        {
                            CurrentContext.Post(ReportStreamingStatus, new StreamingStatusEventArgs() {Code = StreamingErrorCodes.StreamerNotFound});
                        }
                        else
                        {
                            _streamingErrorCount = 0;
                        }

                        if (streamServer.ReturnCode == 0)
                        {
                            return true;
                        }
                    }
                    catch (Exception e)
                    {
                        Debug.Print("Command: {0}\r\n\tException: {1}",streamerCommand, e.Message);
                    }

                    #endregion
                }
            }

            catch (WebException ex)
            {
                CurrentContext.Post(ReportStreamingStatus, new StreamingStatusEventArgs() {Code = StreamingErrorCodes.WebRequestError, Message = ex.Message});
            }

            return false;
        }

        private static void ResponseCallback(IAsyncResult ar)
        {
            Debug.Print("Entering ResponseCallBack...response thread id: {0}", Thread.CurrentThread.ManagedThreadId);

            //ar.AsyncWaitHandle.WaitOne(1000 * 60, true);
            // Get the RequestState object from the async result
            var rs = (RequestState) ar.AsyncState;

            try
            {
                //responseCount = responseCount + 1;
                // Get the HttpWebRequest from RequestState
                HttpWebRequest req = rs.WebRequest;

                // Calling EndGetResponse produces the HttpWebResponse object
                // which came from the request issued above
                var resp = (HttpWebResponse) req.EndGetResponse(ar);

                // Display Headers Information
                Debug.Print("\r\n============================[ HEADERS ]================================");
                int headersCount = resp.Headers.Count;
                for (int i = 0; i < headersCount; i++)
                {
                    Debug.Print(String.Format("Header name: {0},     value: {1}", resp.Headers.Keys[i], resp.Headers[i]));
                }
                Debug.Print("======================================================================\r\n");

                // Now that we have the response, it is time to start reading
                // data from the response stream
                Stream ResponseStream = resp.GetResponseStream();

                _isStreamOpen = true;

                Debug.Print("Cookies Count: {0}", _cookieContainer.Count);

                // The read is also done using async so we'll want
                // to store the stream in RequestState
                rs.ResponseStream = ResponseStream;

                // Note that currentRequestState.BufferRead is passed in to BeginRead.  This is
                // where the data will be read into.            
                if (rs.WebRequest.ServicePoint.CurrentConnections > 0)
                {
                    IAsyncResult iarRead = ResponseStream.BeginRead(rs.BufferRead, 0, BUFFER_SIZE,
                                                                    new AsyncCallback(ReadCallBack), rs);
                }
            }
            catch (Exception e)
            {
                Debug.Print("ResponseCallback Exception: {0}", e.Message);
            }
        }

        private static void ReadCallBack(IAsyncResult asyncResult)
        {
            //if (!_isStreamOpen) return;

            lock (asyncResult)
            {
                // Get the RequestState object from AsyncResult.
                var rs = (RequestState) asyncResult.AsyncState;

                // Retrieve the ResponseStream that was set in RespCallback. 
                Stream responseStream = rs.ResponseStream;

                // Read currentRequestState.BufferRead to verify that it contains data.
                int read = 0;

                try
                {
                    if (responseStream != null && responseStream.CanRead)
                    {
                        read = responseStream.EndRead(asyncResult);
                    }
                    else
                    {
                        CurrentContext.Post(ReportStreamingStatus, new StreamingStatusEventArgs() {Code = StreamingErrorCodes.NullResponse, Message = string.Format("RequestState Id: {0}", rs.Id)});
                        return;
                    }
                }
                catch (Exception ex)
                {
                    CurrentContext.Post(ReportStreamingStatus, new StreamingStatusEventArgs() {Code = StreamingErrorCodes.ResponseException, Message = string.Format("RequestState Id: {0}, Exception Message: {1}", rs.Id, ex.Message)});
                    return;
                }

                // Debug.Print("int read = {0}, read thread id: {1}", read, Thread.CurrentThread.ManagedThreadId);

                if (read > 0)
                {
                    /*
                     * Merging Previous Data if there is any
                     */
                    byte[] b = null;

                    if (bytesRemaining != null)
                    {
                        // if there is incomplete bytes in previous data, append to new bytes
                        b = bytesRemaining.Append(rs.BufferRead, read);
                    }
                    else
                    {
                        b = b.Append(rs.BufferRead, read);
                    }

                    // Debug.Print("Row Data: {0}", BitConverter.ToString(b));
                    
                    // Let's check the headerId at the first byte 
                    string headerId = Encoding.UTF8.GetString(new byte[] {b[0]});

                    #region  Detect Hearbeat

                    //New Heartbeat code
                    if (b.Length > 0 && headerId == "H" && !waitForHeartBeat)
                    {
                        int i = 0;
                        var msgBlock = new byte[1];
                        Buffer.BlockCopy(b, 0, msgBlock, 0, 1);
                        string sid1 = Encoding.UTF8.GetString(msgBlock);
                        i++;

                        // Check if the service id is Heart Beat
                        if (sid1 == "H")
                        {
                            msgBlock = new byte[1];
                            Buffer.BlockCopy(b, i, msgBlock, 0, 1);
                            string sid2 = Encoding.UTF8.GetString(msgBlock);
                            i++;

                            if (sid2 == "T" && b.Length == 2)
                            {
                                waitForHeartBeat = true;
                            }
                            else if (b.Length >= 8)
                            {
                                long timeStamp = b.ConvertToLong(ref i);
                                DateTime barTimeStamp = fromDate.AddMilliseconds(timeStamp);
                                //Debug.Print("Heart Beat: {0:hh:mm:ss yyyy-MM-dd}", barTimeStamp.ToLocalTime());
                                waitForHeartBeat = false;

                                // if there is more data other than heartbeat, strip off the frist 10 bytes
                                if (b.Length > 10)
                                {
                                    b = b.RemoveBeginning(10);
                                }
                            }
                        }
                    }
                    else if (waitForHeartBeat && b.Length >= 8)
                    {
                        // if there is more data other than heartbeat, create new bytes array
                        int i = 0;
                        long timeStamp = b.ConvertToLong(ref i);
                        DateTime heartBeat = fromDate.AddMilliseconds(timeStamp);
                        //Debug.Print("Heart Beat: {0:hh:mm:ss yyyy-MM-dd}", heartBeat.ToLocalTime());
                        waitForHeartBeat = false;

                        // if there is more data, create new bytes array
                        if (b.Length > 8)
                        {
                            //byte[] n = new byte[b.Length - 8];
                            //Buffer.BlockCopy(b, 8, n, 0, b.Length - 8);
                            //b = n;
                            b = b.RemoveBeginning(8);
                        }
                    }
                    // End of heartbeat process

                    #endregion

                    // Now let's take care of other data
                    if (b.Length > 10 && !waitForHeartBeat)
                    {
                        // **************************************************************
                        // Every quote bytes data are supposed to be ended with {FF 0A} bytes
                        // so split by FF 0A and add them to bytes queues to process in a seperate thread.
                        // the data not ending with FF 0A will be appended to the next streaming data.
                        // **************************************************************

                        //Debug.Print("Received raw bytes: {0}", BitConverter.ToString(b));

                        List<byte[]> msgBlocks = b.SplitBy(endDelim, ref bytesRemaining);
                        //List<byte[]> msgBlocks = b.SplitBy2(endDelim, ref bytesRemaining);

                        foreach (var msgBlock in msgBlocks)
                        {
                            // using ConcurrentQueue
                            //msgBlockQueues.Enqueue(msgBlock);

                            // using BlockingCollection
                            msgBlockQueues.Add(msgBlock);
                        }
                    }

                    //Debug.Print("-----------------------------------------------");
                    // Continue reading data until responseStream.EndRead returns –1.
                    IAsyncResult ar = responseStream.BeginRead(rs.BufferRead, 0, BUFFER_SIZE*10,
                                                               new AsyncCallback(ReadCallBack), rs);
                }
                else
                {
                    if (rs.RequestData.Length > 0)
                    {
                        //  Display data to the console.
                        string strContent;
                        strContent = rs.RequestData.ToString();
                        Debug.Print("Content: {0}", strContent);
                    }

                    // Close down the response stream.
                    responseStream.Flush();
                    responseStream.Close();
                    responseStream.Dispose();
                    Debug.Print("!!! Streaming Closed... !!!");

                    string message = string.Format("! Streaming Closed !");
                    AppLog.Insert(new AppLog() { LogType = AppLogType.Info, Message = message });
                }
            }
        }

        #endregion

        #region BYTE[] QUEUE PROCESSOR - THIS RUN ON DIFFERENT THREAD

        private static void KillStreamingTask()
        {
            if (processingTask != null && processingTask.Status == TaskStatus.Running)
            {
                if (cancelTokenSource != null && cancelTokenSource.IsCancellationRequested == false)
                {
                    cancelTokenSource.Cancel();
                }
            }
        }

        // This thread will run on seperate thread.
        public static void ProcessingQueue(object state)
        {
            #region Using BlockingCollection

            var context = (SynchronizationContext) state;
            var cancelToken = cancelTokenSource.Token;

            try
            {
                foreach (var b in msgBlockQueues.GetConsumingEnumerable(cancelToken))
                {
                    byte[] msgBlock = b;

                    // check if the streaming bytes block is complete
                    bool isCompleteBytes = IsCompleteBytes(msgBlock);

                    // if the bytes are not complete, try to add the next bytes block to see if it is valid
                    if (!isCompleteBytes)
                    {
                        // merge with next bytes
                        if (msgBlock.Length > 0)
                            msgBlock = msgBlock.Append(endDelim).Append(msgBlock);

                        // Check again if it is good
                        isCompleteBytes = IsCompleteBytes(msgBlock);
                    }

                    // proceed only if the streaming bytes or snapshot bytes is complete
                    if (isCompleteBytes)
                    {
                        // determin the service id
                        StreamingServiceType service = msgBlock.GetStreamingType();

                        try
                        {
                            switch (service)
                            {
                                case StreamingServiceType.L1QuoteStreaming:
                                    L1QuoteStreaming s = L1QuoteStreaming.AddOrUpdate(msgBlock);
                                    // Return to main thread
                                    if (s != null && s.Last > 0)
                                    {
                                        context.Post(ReturnToMain, new ReturnState() {ObjectServiceType = service, Content = s});
                                    }

                                    break;

                                case StreamingServiceType.AccountActivity:
                                    var acct = new AccountActivity(msgBlock);
                                    context.Post(ReturnToMain, new ReturnState() {ObjectServiceType = service, Content = acct});

                                    break;

                                case StreamingServiceType.News:
                                    var news = new StreamingNews(msgBlock);
                                    context.Post(ReturnToMain, new ReturnState() {ObjectServiceType = service, Content = news});

                                    break;

                                case StreamingServiceType.TimeSales:
                                    var timeSales = new TimeSales(msgBlock);
                                    context.Post(ReturnToMain, new ReturnState() {ObjectServiceType = service, Content = timeSales});

                                    break;

                                case StreamingServiceType.NYSE_Chart:
                                    var nyseChart = new StreamingChartBar(msgBlock);
                                    context.Post(ReturnToMain, new ReturnState() {ObjectServiceType = service, Content = nyseChart});

                                    break;

                                case StreamingServiceType.NASDAQ_Chart:
                                    var nasdaqChart = new StreamingChartBar(msgBlock);
                                    context.Post(ReturnToMain, new ReturnState() {ObjectServiceType = service, Content = nasdaqChart});

                                    break;

                                case StreamingServiceType.INDEX_Chart:
                                    var indexChart = new StreamingChartBar(msgBlock);
                                    context.Post(ReturnToMain, new ReturnState() {ObjectServiceType = service, Content = indexChart});

                                    break;

                                case StreamingServiceType.L2NYSEBook:
                                    var nyseBook = new L2NYSEBook(msgBlock);
                                    context.Post(ReturnToMain, new ReturnState() {ObjectServiceType = service, Content = nyseBook});

                                    break;

                                case StreamingServiceType.L2TotalViewL2:
                                    var l2TotalView = new L2TotalView(msgBlock);
                                    if (l2TotalView.RowsCount > 0)
                                        context.Post(ReturnToMain, new ReturnState() { ObjectServiceType = service, Content = l2TotalView });

                                    break;

                                case StreamingServiceType.L2TotalViewAD:
                                    var adTotalView = new L2TotalView(msgBlock);
                                    if (adTotalView.RowsCount > 0)
                                        context.Post(ReturnToMain, new ReturnState() { ObjectServiceType = service, Content = adTotalView });
                                    break;

                                case StreamingServiceType.StreamerServer:
                                    var streamerServer = new StreamServer(msgBlock);

                                    // Return to main thread
                                    context.Post(ReturnToMain, new ReturnState() {ObjectServiceType = service, Content = streamerServer});

                                    break;

                                default:
                                    Debug.Print("\t>>> [{0}] Service Id is not processed <<<", Enum.GetName(typeof (StreamingServiceType), service));
                                    break;
                            }

                        }
                        catch (Exception e)
                        {
                            Debug.Print("====> Couldn't process this message block: sid:{0} {1}\r\n\t{2}", Enum.GetName(typeof (StreamingServiceType), service), e.Message, BitConverter.ToString(msgBlock));

                            string message = string.Format("Couldn't process this message block: sid:{0} {1}\r\n{2}", Enum.GetName(typeof (StreamingServiceType), service), e.Message, BitConverter.ToString(msgBlock));
                            AppLog.Insert(new AppLog() {LogType = AppLogType.Info, Message = message});
                        }
                    }
                }
            }
            catch (OperationCanceledException e)
            {
                Debug.Print("!!! Queue Processing Task Stopped !!!");
                string message2 = string.Format("!!! Queue Processing Task Stopped !!!");
                AppLog.Insert(new AppLog() {LogType = AppLogType.Info, Message = message2});
            }
            catch (Exception e)
            {
                Debug.Print("Exception: {0}", e.Message);
            }

            #endregion
        }

        private static bool IsCompleteBytes(byte[] b)
        {
            // get the headerId
            int i = 0;
            string headerId = b.ConvertToByte(ref i);

            // and, check if the streaming data size is correct
            if (headerId == "S")
            {
                int msgSize = b.ConvertToShort(ref i);

                // the message size should be equal to the bytes length to determine it's complete
                return (b.Length - 3) == msgSize;
            }
            else if (headerId == "N")
            {
                // snapshot data doesn't specify the length of message
                return true;
            }

            return false;
        }

        /// <summary>
        /// All results will be forward into this main context.
        /// </summary>
        /// <param name="state"></param>
        public static void ReturnToMain(object state)
        {
            var rs = (ReturnState) state;

            switch (rs.ObjectServiceType)
            {
                case StreamingServiceType.L1QuoteStreaming:
                    var l1quote = (L1QuoteStreaming) rs.Content;

                    if (OnL1QuoteStreamingReceived != null)
                    {
                        OnL1QuoteStreamingReceived(l1quote, EventArgs.Empty);
                    }

                    break;

                case StreamingServiceType.AccountActivity:
                    var accountActivity = (AccountActivity) rs.Content;

                    Debug.Print("-------------- Account Activity Service Type ---------------");

                    var ui = TaskScheduler.FromCurrentSynchronizationContext();

                    var tasks = new List<Task>()
                                           {
                                                GetBalancesAsync(),
                                                GetPositionsAsync(),
                                                GetOrderStatusAsync(),
                                                GetOrderHistoryAsync(5)
                                           };
                    if (tasks.Count > 0)
                    {
                        Task.Factory.ContinueWhenAll(tasks.ToArray(), result =>
                        {
                            // wait until the tasks are finished
                            Debug.Print("Finished tasks: balances, positions, order statuses, order histories");

                            // and then, fire the event
                            if (OnAccountActivityReceived != null)
                            {
                                OnAccountActivityReceived(accountActivity, EventArgs.Empty);
                            }
                        }, CancellationToken.None, TaskContinuationOptions.None, ui);
                    }

                    break;

                case StreamingServiceType.News:
                    var news = (StreamingNews) rs.Content;
                    if (OnStreamingNewsReceived != null)
                    {
                        OnStreamingNewsReceived(news, EventArgs.Empty);
                    }
                    break;

                case StreamingServiceType.TimeSales:
                    var timeSales = (TimeSales) rs.Content;
                    if (OnTimeSalesReceived != null)
                    {
                        OnTimeSalesReceived(timeSales, EventArgs.Empty);
                    }
                    break;

                case StreamingServiceType.NYSE_Chart:
                    var nyseChart = (StreamingChartBar) rs.Content;
                    if (OnStreamingBarReceived != null)
                    {
                        OnStreamingBarReceived(nyseChart, EventArgs.Empty);
                    }
                    break;

                case StreamingServiceType.NASDAQ_Chart:
                    var nasdaqChart = (StreamingChartBar) rs.Content;
                    if (OnStreamingBarReceived != null)
                    {
                        OnStreamingBarReceived(nasdaqChart, EventArgs.Empty);
                    }
                    break;

                case StreamingServiceType.INDEX_Chart:
                    var indexChart = (StreamingChartBar) rs.Content;
                    if (OnStreamingBarReceived != null)
                    {
                        OnStreamingBarReceived(indexChart, EventArgs.Empty);
                    }
                    break;

                case StreamingServiceType.L2NYSEBook:
                    var l2nyse = (L2NYSEBook) rs.Content;
                    if (OnNyseBookReceived != null)
                    {
                        OnNyseBookReceived(l2nyse, EventArgs.Empty);
                    }
                    break;

                case StreamingServiceType.L2TotalViewL2:
                    var l2TotalView = (L2TotalView) rs.Content;
                    if (OnTotalViewReceived != null)
                    {
                        OnTotalViewReceived(l2TotalView, EventArgs.Empty);
                    }
                    break;

                case StreamingServiceType.L2TotalViewAD:
                    var adTotalView = (L2TotalView)rs.Content;
                    if (OnTotalViewReceived != null)
                    {
                        OnTotalViewReceived(adTotalView, EventArgs.Empty);
                    }
                    break;

                case StreamingServiceType.StreamerServer:
                    var streamServer = (StreamServer) rs.Content;
                    if (OnStreamerServerReceived != null)
                    {
                        OnStreamerServerReceived(streamServer, EventArgs.Empty);
                    }
                    break;

                default:

                    break;
            }
        }

        #endregion

        #region NEWS HISTORY

        public static async Task<List<StreamingNews>> GetNewsHistory(string symbol, int period)
        {
            // exit on not logged in
            if (IsLoggedIn == false) return new List<StreamingNews>();

            if (client != null && client.AssociatedAccount.AccountAuthorizations.StreamingNews == false) new List<StreamingNews>();
            
            var streamerCommand = string.Format("S=NEWS&C=GET&P={0};{1}", symbol, (DateTime.Today.AddDays(period * -1) - fromDate).TotalMilliseconds);
            string postUrl = "https://" + _streamerInfo.StreamerUrl;
            var cpostdata = new StringBuilder();

            cpostdata.Append("!U=" + client.AssociatedAccount.AccountId);
            cpostdata.Append("&W=" + _streamerInfo.Token);
            cpostdata.Append("&A=userid=" + client.AssociatedAccount.AccountId);
            cpostdata.Append("&token=" + _streamerInfo.Token);
            cpostdata.Append("&company=" + client.AssociatedAccount.Company);
            cpostdata.Append("&segment=" + client.AssociatedAccount.Segment);
            cpostdata.Append("&cddomain=" + _streamerInfo.CdDomainId);
            cpostdata.Append("&usergroup=" + _streamerInfo.UserGroup);
            cpostdata.Append("&accesslevel=" + _streamerInfo.AccessLevel);
            cpostdata.Append("&authorized=" + _streamerInfo.Authorized);
            cpostdata.Append("&acl=" + _streamerInfo.ACL);
            cpostdata.Append("&timestamp=" + _streamerInfo.TimeStamp);
            cpostdata.Append("&appid=" + _streamerInfo.AppId);
            // append streamer command here *** DO NOT REMOVE "\n\n" ***
            cpostdata.Append("|" + streamerCommand + "\n\n");


            string urlString = cpostdata.ToString();
            Debug.Print("\r\nRequest URL: {0}", urlString);
            string encodedString = Encode_URL(urlString);
            cpostdata = new StringBuilder();
            cpostdata.Append(encodedString);

            var httpWebRequest = (HttpWebRequest)WebRequest.Create(postUrl);
            httpWebRequest.ContentType = "application/x-www-form-urlencoded";
            //req.Accept =
            //    "Accept image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-powerpoint, application/vnd.ms-excel, application/msword, application/x-shockwave-flash, */*";
            //req.Method = "GET";
            httpWebRequest.Method = "POST";
            httpWebRequest.SendChunked = false;
            httpWebRequest.ServicePoint.Expect100Continue = false;
            httpWebRequest.MaximumResponseHeadersLength = 650000;
            httpWebRequest.Headers.Add(HttpRequestHeader.AcceptEncoding, "gzip,deflate");
            httpWebRequest.AutomaticDecompression = DecompressionMethods.GZip | DecompressionMethods.Deflate;
            httpWebRequest.Timeout = 5000;
            httpWebRequest.ReadWriteTimeout = 5000;
            httpWebRequest.ServicePoint.ConnectionLimit = 10; // 150;

            // Add Cookie
            httpWebRequest.CookieContainer = _cookieContainer;

            //for POST
            var objEncoding = new ASCIIEncoding();
            string s = cpostdata.ToString();

            byte[] objBytes = objEncoding.GetBytes(s);
            httpWebRequest.ContentLength = objBytes.Length;

            try
            {
                using (Stream stream = await httpWebRequest.GetRequestStreamAsync())
                {
                    stream.Write(objBytes, 0, objBytes.Length);
                }
            }
            catch (Exception e)
            {
                Debug.Print("TDANET.GetNewsHistory 1: {0}", e.Message);
                return new List<StreamingNews>();
            }
                
            byte[] b;

            try
            {
                //using (WebResponse response = httpWebRequest.GetResponse())
                using (HttpWebResponse response = (HttpWebResponse)await httpWebRequest.GetResponseAsync())
                {
                    using (Stream stream = response.GetResponseStream())
                    {
                        var buffer = new byte[1024];
                        using (var ms = new MemoryStream())
                        {
                            while (true)
                            {
                                int read = stream.Read(buffer, 0, buffer.Length);
                                if (read <= 0)
                                {
                                    b = ms.ToArray();
                                    break;
                                }
                                ms.Write(buffer, 0, read);
                            }
                        }
                    }
                }
            }
            catch (Exception e)
            {
                Debug.Print("TDANET.GetNewsHistory 2: {0}", e.Message);
                return new List<StreamingNews>();
            }

            //Debug.Print("BYTE[]: {0}", BitConverter.ToString(b));  // b is news history response

            var i = 0;
            var newsItems = new List<StreamingNews>();

            try
            {
                var headerId = b.ConvertToByte(ref i);
                var sidLength = b.ConvertToShort(ref i);
                var sidString = b.ConvertToString(ref i, sidLength);
                var payloadLength = b.ConvertToInt32(ref i);
                var sid = b.ConvertToShort(ref i);
                var symbolLength = b.ConvertToShort(ref i);
                var symbol2 = b.ConvertToString(ref i, symbolLength);
                var msgType = b.ConvertToShort(ref i); // 0 = successful retrieval

                // check if the message is valid
                if (i > 0 && msgType == 0)
                {
                    var dataLength = b.ConvertToShort(ref i); // Length of the DATA string
                    byte[] compressed = new byte[dataLength];
                    Buffer.BlockCopy(b, i, compressed, 0, dataLength);
                    var decompressedBytes = compressed.Decompress();
                    var items = decompressedBytes.SplitBy(new byte[] { 0x01 });
                    foreach (var bytes in items)
                    {
                        var newsItem = bytes.SplitBy(new byte[] { 0x02 });

                        var news = new StreamingNews();
                        news.Symbol = symbol2;
                        news.Headline = newsItem[1].ConvertToString();
                        news.NewsTimeStamp = fromDate.AddMilliseconds(Convert.ToInt64(newsItem[2].ConvertToString())).ToLocalTime();
                        news.Source = newsItem[3].ConvertToString();
                        news.NewsUrl = newsItem[4].ConvertToString();

                        newsItems.Add(news);
                    }

                    return newsItems;
                }

            }
            catch (Exception ex)
            {
                // catch exception here
            }

            return new List<StreamingNews>();
        }

        #endregion

        #region PRICE HISTORY

        #region Just for references

        public static PriceHistory GetPriceHistory(string symbol, int period, bool isDaily)
        {
            string postUrl = String.Empty;

            if (isDaily)
            {
                postUrl =
                    String.Format(
                        "https://apis.tdameritrade.com/apps/100/PriceHistory;jsessionid={0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=DAILY&intervalduration=1&periodtype=MONTH&period={3}&enddate={4}",
                        client.SessionId, AppSource, symbol, period, DateTime.Today.ToString("yyyyMMdd"));
            }
            else
            {
                postUrl =
                    String.Format(
                        "https://apis.tdameritrade.com/apps/100/PriceHistory;jsessionid={0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=MINUTE&intervalduration=1&periodtype=DAY&period={3}&enddate={4}&extended=true",
                        client.SessionId, AppSource, symbol, period, DateTime.Today.ToString("yyyyMMdd"));
            }

            Debug.Print("Requesting Price History ==> {0}, isDaily? {1}", postUrl, isDaily);

            string message = string.Format("Requesting Price History ==> {0}, isDaily? {1}", postUrl, isDaily);
            AppLog.Insert(new AppLog() {LogType = AppLogType.Debug, Message = message});

            var request = (HttpWebRequest) WebRequest.Create(postUrl);
            request.ContentType = "application/x-www-form-urlencoded";
            request.Method = "POST";
            request.Timeout = 5000;
            request.ReadWriteTimeout = 5000;
            ((HttpWebRequest) request).KeepAlive = false;
            request.ContentLength = 0;

            byte[] b = null;

            using (WebResponse response = request.GetResponse())
            {
                // Get the data stream that is associated with the specified URL.
                using (Stream stream = response.GetResponseStream())
                {
                    using (var ms = new MemoryStream())
                    {
                        stream.CopyTo(ms);
                        b = ms.ToArray();
                    }
                }
            }

            int i = 0;


            int symbolLength = b.ConvertToShort(ref i);
            string symbol1 = b.ConvertToString(ref i, symbolLength);

            var item = new PriceHistory() {IsDaily = isDaily};
            item.Symbol = symbol1;

            int errorCode = b.ConvertToErrorCode(ref i);
            if (errorCode == 1)
            {
                int errorLength = b.ConvertToShort(ref i);
                item.ErrorText = b.ConvertToString(ref i, errorLength);
            }

            int barCount = b.ConvertToInt32(ref i);

            item.TimeStamps = new double[barCount];
            item.Opens = new double[barCount];
            item.Highs = new double[barCount];
            item.Lows = new double[barCount];
            item.Closes = new double[barCount];
            item.Volumes = new double[barCount];

            if (errorCode == 0 && barCount > 0)
            {
                for (int k = 0; k < barCount; k++)
                {
                    item.Closes[k] = b.ConvertToFloat(ref i); // Close, 4 bytes
                    item.Highs[k] = b.ConvertToFloat(ref i); // High, 4 bytes
                    item.Lows[k] = b.ConvertToFloat(ref i); // Low, bytes
                    item.Opens[k] = b.ConvertToFloat(ref i); // Open, 4 bytes
                    item.Volumes[k] = b.ConvertToFloat(ref i)*100; // Volume, 8 bytes
                    item.TimeStamps[k] = fromDate.AddMilliseconds(b.ConvertToLong(ref i)).ToLocalTime().ToOADate(); // TimeStamp
                    // time in milliseconds from 1970, Jan, 1 UTC
                }
            }

            // Checking end of repeating price data
            byte[] endBytes = b.NextBytes(ref i, 2);
            if (endBytes.SequenceEqual(_endOfPriceData) != true)
            {
                throw new FormatException(String.Format("Invalid PriceHistory Format...Symbol: {0}", symbol1));
            }

            return item;
        }

        public static PriceHistory GetPriceHistory(string symbol, DateTime startDate, DateTime endDate, bool isDaily)
        {
            string postUrl = String.Empty;

            if (isDaily)
            {
                postUrl =
                    String.Format(
                        "https://apis.tdameritrade.com/apps/100/PriceHistory;jsessionid={0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=DAILY&intervalduration=1&startdate={3}&enddate={4}",
                        client.SessionId, AppSource, symbol, startDate.ToString("yyyyMMdd"), endDate.ToString("yyyyMMdd"));
            }
            else
            {
                postUrl =
                    String.Format(
                        "https://apis.tdameritrade.com/apps/100/PriceHistory;jsessionid={0}?source={1}&requestidentifiertype=SYMBOL&requestvalue={2}&intervaltype=MINUTE&intervalduration=1&extended=true&startdate={3}&enddate={4}",
                        client.SessionId, AppSource, symbol, startDate.ToString("yyyyMMdd"), endDate.ToString("yyyyMMdd"));
            }

            var request = (HttpWebRequest) WebRequest.Create(postUrl);
            request.ContentType = "application/x-www-form-urlencoded";
            request.Method = "POST";
            request.Timeout = 5000;
            request.ReadWriteTimeout = 5000;
            ((HttpWebRequest) request).KeepAlive = false;
            request.ContentLength = 0;

            byte[] b = null;

            Debug.Print("Requesting Price History ==> {0}, isDaily? {1}", postUrl, isDaily);

            string message = string.Format("Requesting Price History ==> {0}, isDaily? {1}", postUrl, isDaily);
            AppLog.Insert(new AppLog() {LogType = AppLogType.Debug, Message = message});

            using (WebResponse response = request.GetResponse())
            {
                // Get the data stream that is associated with the specified URL.
                using (Stream stream = response.GetResponseStream())
                {
                    using (var ms = new MemoryStream())
                    {
                        stream.CopyTo(ms);
                        b = ms.ToArray();
                    }
                }
            }

            int i = 0;


            int symbolLength = b.ConvertToShort(ref i);
            string symbol1 = b.ConvertToString(ref i, symbolLength);

            var item = new PriceHistory() {IsDaily = isDaily};
            item.Symbol = symbol1;

            int errorCode = b.ConvertToErrorCode(ref i);
            if (errorCode == 1)
            {
                int errorLength = b.ConvertToShort(ref i);
                item.ErrorText = b.ConvertToString(ref i, errorLength);
            }

            int barCount = b.ConvertToInt32(ref i);

            item.TimeStamps = new double[barCount];
            item.Opens = new double[barCount];
            item.Highs = new double[barCount];
            item.Lows = new double[barCount];
            item.Closes = new double[barCount];
            item.Volumes = new double[barCount];

            if (errorCode == 0 && barCount > 0)
            {
                for (int k = 0; k < barCount; k++)
                {
                    item.Closes[k] = b.ConvertToFloat(ref i); // Close, 4 bytes
                    item.Highs[k] = b.ConvertToFloat(ref i); // High, 4 bytes
                    item.Lows[k] = b.ConvertToFloat(ref i); // Low, bytes
                    item.Opens[k] = b.ConvertToFloat(ref i); // Open, 4 bytes
                    item.Volumes[k] = b.ConvertToFloat(ref i)*100; // Volume, 8 bytes
                    item.TimeStamps[k] = fromDate.AddMilliseconds(b.ConvertToLong(ref i)).ToLocalTime().ToOADate(); // TimeStamp
                    // time in milliseconds from 1970, Jan, 1 UTC
                }
            }

            // Checking end of repeating price data
            byte[] endBytes = b.NextBytes(ref i, 2);
            if (endBytes.SequenceEqual(_endOfPriceData) != true)
            {
                throw new FormatException(String.Format("Invalid PriceHistory Format...Symbol: {0}", symbol1));
            }

            return item;
        }

        public static async Task<List<PriceHistory>> GetPriceHistoryAsync(IEnumerable<string> symbols, int period, bool isDaily, bool useSymbolGroup)
        {
            var priceHistories = new List<PriceHistory>();
            var priceHistoryUrls = new PriceHistoryUrl();
            priceHistoryUrls.AddRange(symbols.ToList(), period, isDaily, useSymbolGroup);
            List<string> postUrls = priceHistoryUrls.Urls;

            IEnumerable<Task<List<PriceHistory>>> queries = from url in postUrls
                                                            select RequestPriceHistory(url);

            foreach (var bucket in queries.Interleaved())
            {
                var task = await bucket;
                try
                {
                    if (task.Status != TaskStatus.Canceled)
                    {
                        List<PriceHistory> result = await task;
                        priceHistories.AddRange(result);
                    }

                }
                catch (OperationCanceledException)
                {
                }
                catch (Exception exc)
                {
                }
            }
            return priceHistories;
        }

        #endregion
        
        public static async Task<List<PriceHistory>> GetPriceHistoryAsync(IEnumerable<string> symbols, DateTime lastDate, bool isDaily, bool useSymbolGroup)
        {
            var priceHistories = new List<PriceHistory>();
            var priceHistoryUrls = new PriceHistoryUrl();
            priceHistoryUrls.AddRange(symbols.ToList(), lastDate, DateTime.Today, isDaily, useSymbolGroup);
            List<string> postUrls = priceHistoryUrls.Urls;

            IEnumerable<Task<List<PriceHistory>>> queries = from url in postUrls
                                                            select RequestPriceHistory(url);

            foreach (var bucket in queries.Interleaved())
            {
                var task = await bucket;
                try
                {
                    if (task.Status != TaskStatus.Canceled)
                    {
                        List<PriceHistory> result = await task;
                        priceHistories.AddRange(result);
                    }

                }
                catch (OperationCanceledException) { }
                catch (Exception exc) { }
            }

            return priceHistories;
        }

        public static async Task<List<PriceHistory>> GetPriceHistoryAsync(IEnumerable<string> symbols, DateTime startDate,
                                                                          DateTime endDate, bool isDaily, bool useSymbolGroup)
        {
            var priceHistories = new List<PriceHistory>();
            var priceHistoryUrls = new PriceHistoryUrl();
            priceHistoryUrls.AddRange(symbols.ToList(), startDate, endDate, isDaily, useSymbolGroup);
            List<string> postUrls = priceHistoryUrls.Urls;

            IEnumerable<Task<List<PriceHistory>>> queries = from url in postUrls
                                                            select RequestPriceHistory(url);

            foreach (var bucket in queries.Interleaved())
            {
                var task = await bucket;
                try
                {
                    if (task.Status != TaskStatus.Canceled)
                    {
                        List<PriceHistory> result = await task;
                        priceHistories.AddRange(result);
                    }

                }
                catch (OperationCanceledException) { }
                catch (Exception exc) { }
            }

            return priceHistories;
        }

        public static async Task<List<PriceHistory>> GetPriceHistoryAsync(IEnumerable<string> priceHistoryUrls)
        {
            var priceHistories = new List<PriceHistory>();

            if (!priceHistoryUrls.Any()) return priceHistories; // return on empty value

            IEnumerable<Task<List<PriceHistory>>> queries = from url in priceHistoryUrls
                                                            select RequestPriceHistory(url);


            foreach (var bucket in queries.Interleaved())
            {
                var task = await bucket;
                try
                {
                    if (task.Status != TaskStatus.Canceled)
                    {
                        List<PriceHistory> result = await task;
                        priceHistories.AddRange(result);
                    }
                }
                catch (OperationCanceledException) { }
                catch (Exception exc) { }
            }

            return priceHistories;
        }

        public static async Task<List<PriceHistory>> RequestPriceHistory(string postUrl)
        {
            // http://msdn.microsoft.com/en-us/library/vstudio/hh300224.aspx

            var items = new List<PriceHistory>();
            bool isDaily = postUrl.Contains("DAILY");
            List<string> symbols = postUrl.Split('&').First(o => o.Contains("requestvalue=")).Replace("requestvalue=", string.Empty).Replace(", ", ",").Split(',').Select(o => o.Trim()).ToList();

            Debug.Print("Requesting Price History ==> {0}, isDaily? {1}\r\n\t{2}", string.Join(", ", symbols), isDaily, postUrl);

            string message = string.Format("Requesting Price History => {0}, isDaily? {1}", string.Join(", ", symbols), isDaily);
            AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = message });

            var request = (HttpWebRequest) WebRequest.Create(postUrl);
            request.ContentType = "application/x-www-form-urlencoded";
            request.Method = "POST";
            request.Timeout = 5000;
            request.ReadWriteTimeout = 5000;
            ((HttpWebRequest) request).KeepAlive = false;
            request.ContentLength = 0;

            byte[] b = null;

            try
            {
                using (WebResponse response = await request.GetResponseAsync())
                {
                    // Get the data stream that is associated with the specified URL.
                    using (Stream stream = response.GetResponseStream())
                    {
                        using (var ms = new MemoryStream())
                        {
                            await stream.CopyToAsync(ms);
                            b = ms.ToArray();
                        }
                    }
                }
            }
            catch (Exception e)
            {
                items.AddRange(symbols.Select(symbol => new PriceHistory() {Symbol = symbol, IsDaily = isDaily}));
                return items;
            }

            Debug.Print("PriceHistory Byte[] Received: {0} bytes", b.Length);

            if (b.Length > 0)
            {
                int i = 0;

                int symbolCount = b.ConvertToInt32(ref i);

                for (int j = 0; j < symbolCount; j++)
                {
                    int symbolLength = b.ConvertToShort(ref i);
                    string symbol = b.ConvertToString(ref i, symbolLength);

                    var item = new PriceHistory {Symbol = symbol, IsDaily = isDaily};

                    try
                    {
                        int errorCode = b.ConvertToErrorCode(ref i);
                        if (errorCode == 1)
                        {
                            int errorLength = b.ConvertToShort(ref i);
                            item.ErrorText = b.ConvertToString(ref i, errorLength);
                            throw new FormatException(string.Format("Price History Error Detected: {0}, {1}", symbol, item.ErrorText));
                        }

                        int barCount = b.ConvertToInt32(ref i);

                        item.TimeStamps = new double[barCount];
                        item.Opens = new double[barCount];
                        item.Highs = new double[barCount];
                        item.Lows = new double[barCount];
                        item.Closes = new double[barCount];
                        item.Volumes = new double[barCount];

                        if (errorCode == 0 && barCount > 0)
                        {
                            for (int k = 0; k < barCount; k++)
                            {
                                item.Closes[k] = b.ConvertToFloat(ref i); // Close, 4 bytes
                                item.Highs[k] = b.ConvertToFloat(ref i); // High, 4 bytes
                                item.Lows[k] = b.ConvertToFloat(ref i); // Low, bytes
                                item.Opens[k] = b.ConvertToFloat(ref i); // Open, 4 bytes
                                item.Volumes[k] = b.ConvertToFloat(ref i)*100; // Volume, 8 bytes
                                item.TimeStamps[k] = fromDate.AddMilliseconds(b.ConvertToLong(ref i)).ToLocalTime().ToOADate(); // TimeStamp
                                // time in milliseconds from 1970, Jan, 1 UTC
                            }
                        }

                        // Checking end of repeating price data
                        byte[] endBytes = b.NextBytes(ref i, 2);
                        if (endBytes.SequenceEqual(_endOfPriceData) != true)
                        {
                            throw new FormatException(String.Format("Invalid PriceHistory Format...Symbol: {0}", symbol));
                        }

                        items.Add(item);
                    }
                    catch (Exception e)
                    {
                        items.Add(item);
                    }
                }

                return items;
            }

            return new List<PriceHistory>();
        }

        public static async Task<List<PriceHistory>> RequestPriceHistory(string postUrl, CancellationToken token)
        {
            var items = new List<PriceHistory>();
            bool isDaily = postUrl.Contains("DAILY");
            List<string> symbols = postUrl.Split('&').First(o => o.Contains("requestvalue=")).Replace("requestvalue=", string.Empty).Replace(", ", ",").Split(',').Select(o => o.Trim()).ToList();

            // Check if cancel is requested.
            if (token.IsCancellationRequested)
            {
                items.AddRange(symbols.Select(symbol => new PriceHistory() {Symbol = symbol, IsDaily = isDaily}));
                return items;
            }

            // http://msdn.microsoft.com/en-us/library/vstudio/hh300224.aspx

            Debug.Print("Requesting Price History ==> {0}, isDaily? {1}\r\n\t{2}", string.Join(", ", symbols), isDaily, postUrl);

            string message = string.Format("Requesting Price History ==> {0}, isDaily? {1}", postUrl, isDaily);
            AppLog.Insert(new AppLog() { LogType = AppLogType.Debug, Message = message });

            var request = (HttpWebRequest) WebRequest.Create(postUrl);
            request.ContentType = "application/x-www-form-urlencoded";
            request.Method = "POST";
            request.Timeout = 5000;
            request.ReadWriteTimeout = 5000;
            ((HttpWebRequest) request).KeepAlive = false;
            request.ContentLength = 0;

            byte[] b = null;

            try
            {
                using (WebResponse response = await request.GetResponseAsync())
                {
                    // Get the data stream that is associated with the specified URL.
                    using (Stream stream = response.GetResponseStream())
                    {
                        using (var ms = new MemoryStream())
                        {
                            await stream.CopyToAsync(ms);
                            b = ms.ToArray();
                        }
                    }
                }
            }
            catch (Exception e)
            {
                items.AddRange(symbols.Select(symbol => new PriceHistory() {Symbol = symbol, IsDaily = isDaily}));
                return items;
            }

            Debug.Print("PriceHistory Byte[] Received: {0} bytes", b.Length);

            if (b.Length > 0)
            {
                int i = 0;

                int symbolCount = b.ConvertToInt32(ref i);

                for (int j = 0; j < symbolCount; j++)
                {
                    int symbolLength = b.ConvertToShort(ref i);
                    string symbol = b.ConvertToString(ref i, symbolLength);

                    var item = new PriceHistory {Symbol = symbol, IsDaily = isDaily};

                    try
                    {
                        int errorCode = b.ConvertToErrorCode(ref i);
                        if (errorCode == 1)
                        {
                            int errorLength = b.ConvertToShort(ref i);
                            item.ErrorText = b.ConvertToString(ref i, errorLength);
                            throw new FormatException(string.Format("Price History Error Detected: {0}, {1}", symbol, item.ErrorText));
                        }

                        int barCount = b.ConvertToInt32(ref i);

                        item.TimeStamps = new double[barCount];
                        item.Opens = new double[barCount];
                        item.Highs = new double[barCount];
                        item.Lows = new double[barCount];
                        item.Closes = new double[barCount];
                        item.Volumes = new double[barCount];

                        if (errorCode == 0 && barCount > 0)
                        {
                            for (int k = 0; k < barCount; k++)
                            {
                                item.Closes[k] = b.ConvertToFloat(ref i); // Close, 4 bytes
                                item.Highs[k] = b.ConvertToFloat(ref i); // High, 4 bytes
                                item.Lows[k] = b.ConvertToFloat(ref i); // Low, bytes
                                item.Opens[k] = b.ConvertToFloat(ref i); // Open, 4 bytes
                                item.Volumes[k] = b.ConvertToFloat(ref i)*100; // Volume, 8 bytes
                                item.TimeStamps[k] = fromDate.AddMilliseconds(b.ConvertToLong(ref i)).ToLocalTime().ToOADate(); // TimeStamp
                                // time in milliseconds from 1970, Jan, 1 UTC
                            }
                        }

                        // Checking end of repeating price data
                        byte[] endBytes = b.NextBytes(ref i, 2);
                        if (endBytes.SequenceEqual(_endOfPriceData) != true)
                        {
                            //throw new FormatException(String.Format("Invalid PriceHistory Format...Symbol: {0}", symbol));
                            item = new PriceHistory {Symbol = symbol, IsDaily = isDaily};
                            items.Add(item);
                        }

                        items.Add(item);
                    }
                    catch (Exception e)
                    {
                        items.Add(item);
                    }
                }

                return items;
            }

            return new List<PriceHistory>();
        }

        #endregion

        #region ENCODE URL HELPER

        public static string Encode_URL(string cUrlString)
        {
            var encodedString = new StringBuilder();
            char[] encBytes = cUrlString.ToCharArray();

            foreach (char cb in encBytes)
            {
                switch ((byte) cb)
                {
                    case 58:
                        encodedString.Append("%3A");
                        break;

                    case 32:
                        encodedString.Append("%20");
                        break;

                    case 40:
                        encodedString.Append("%28");
                        break;

                    case 41:
                        encodedString.Append("%29");
                        break;

                    case 43:

                        encodedString.Append("%2B");
                        break;

                    case 45:
                        encodedString.Append("%2D");
                        break;

                    case 61:
                        encodedString.Append("%3D");
                        break;

                    case 124:
                        encodedString.Append("%7C");
                        break;

                    case 38:
                        encodedString.Append("%26");
                        break;

                    case 44:
                        encodedString.Append("%2C");
                        break;

                    case 126:
                        encodedString.Append("%7E");
                        break;

                    default:
                        encodedString.Append(cb);
                        break;
                }
            }
            return encodedString.ToString();
        }

        #endregion
    }

    public class StreamingEventArgs : EventArgs
    {
        public List<string> Symbols { get; set; }
        public StreamingServiceType StreamingServiceType { get; set; }
        public bool IsSubscription { get; set; }
    }
}