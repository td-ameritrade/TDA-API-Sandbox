using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Net;
using System.Threading;
using System.IO.Compression;
using System.Text.RegularExpressions;
using MSXML2;
using System.IO;
using System.Xml;
using TechTrader.TDA;

namespace TechTrader.Sources
{
    public class TDAmeritrade : SourceTemplate
    {
        public static double perStockTradeFee=10, perOptionTradeFee=10, perOptionContractFee=.75;
        private const int fillWait = 5;
        private static string user = "";
        private static string pass = "";
        private static string sid = "";
        private static string session = "";
        private static int minExpiration = 30, maxSpread=10;
        private static bool tradeEquities=false, tradeOptions=false, autoClose=false;
        private static bool cancelledLogin = false;
        private static long lastLogin;
        private static int timeout;
        private Dictionary<string, string> balanceData;
        private Dictionary<string, Dictionary<string, string>> equityPositions;
        private Dictionary<string, Dictionary<string, string>> optionPositions;
        private Dictionary<string, Dictionary<string, string>> equityOrders;
        private Dictionary<string, Dictionary<string, string>> optionOrders;

        private static Dictionary<string, string> equityActions = new Dictionary<string,string>{{"buy", "B"},{"sell", "S"},{"short", "SS"}, {"cover", "BC"}};
        private static Dictionary<string, string> openType = new Dictionary<string, string> { { "buy", "buy" }, { "sell", "sell" }, { "short", "sellshort" }, { "cover", "buytocover" } };
        private static Dictionary<string, string> closeType = new Dictionary<string, string> { { "cover", "SHORT" }, { "sell", "LONG" } };
        private static Dictionary<string, string> optionAction = new Dictionary<string, string> { { "buy", "buytoopen" }, { "short", "buytoopen" }, { "cover", "selltoclose" }, { "sell", "selltoclose" } };
        private static Dictionary<string, string> optionRequestType = new Dictionary<string, string> { { "buy", "C" }, { "short", "P" }, { "cover", "P" }, { "sell", "C" } };

        public static void setLogin(string name, string password, string sourceid, bool tradeEquity, bool tradeOption, int maxSpreadPercent, int maxExpiryDays, bool autoCloseUnknownPositions, double stockTradeFee, double optionTradeFee, double optionContractFee)
        {
            user = name;
            pass = password;
            sid = sourceid;
            tradeEquities = tradeEquity;
            tradeOptions = tradeOption;
            maxSpread = maxSpreadPercent;
            minExpiration = maxExpiryDays;
            autoClose = autoCloseUnknownPositions;
            perStockTradeFee = stockTradeFee;
            perOptionTradeFee = optionTradeFee;
            perOptionContractFee = optionContractFee;
        }

        public void checkLogin()
        {
            while (user == "" && !cancelledLogin)
            {
                WriteOutput("Login required...", true);
                if (isBackgroundTask && get("TDA_Username") != "" && get("TDA_Password")!="")
                {
                    TDAmeritrade.setLogin(get("TDA_Username"), get("TDA_Password"), get("TDA_SourceID"), get("TDA_Equities?") == "true", get("TDA_Options?") == "true", get("TDA_Spread") != "" ? (int)Convert.ToDecimal(get("TDA_Spread")) : 0, get("TDA_Expiration") != "" ? (int)Convert.ToDecimal(get("TDA_Expiration")) : 0, get("TDA_AutoClose?") == "true", get("TDA_FeePerStockTrade") == "" ? 0 : Convert.ToDouble(get("TDA_FeePerStockTrade")), get("TDA_FeePerOptionTrade") == "" ? 0 : Convert.ToDouble(get("TDA_FeePerOptionTrade")), get("TDA_FeePerOptionContract")==""? 0:Convert.ToDouble(get("TDA_FeePerOptionContract")));
                }
                else
                {
                    Login l = new Login(this);
                    cancelledLogin = l.ShowDialog() == DialogResult.Cancel;
                    if (cancelledLogin) return;
                }
                Login();
            }
            long i = Interlocked.Read(ref lastLogin);
            if (user != "")
            {
                double loggedIn = (DateTime.Now - new DateTime(i)).TotalMinutes;
                double maxLog = Math.Max(1, timeout - 5);
                if (loggedIn >= maxLog)
                    Login();
                WriteOutput("Logged in as " + user + " for "+loggedIn.ToString("N0")+" min (max="+timeout+").", true);
            }
        }

        public string get(string setting) { return getSetting(setting); }
        public void set(string setting, string value) { saveSetting(setting, value); }

        public void Login()
        {
            Interlocked.Exchange(ref lastLogin, DateTime.Now.Ticks);
            Tuple<string, string> result = Login(user, pass, sid);
            if (result == null)
            {
                user = pass = sid = "";
            }
            else
            {
                session = result.Item1;
                timeout = Convert.ToInt32(result.Item2);
            }
        }

        public Tuple<string, string> Login(string u, string p, string sou)
        {
            WriteOutput("Logging in as " + u + "...", true);
            string vers = "1.0";
            XMLHTTP xmlHttp_ = new XMLHTTP();
            StringBuilder cpostdata = new StringBuilder();
            string lcPostUrl = string.Empty;

            cpostdata.Append("userid=" + Encode_URL(u));
            cpostdata.Append("&password=" + Encode_URL(p));
            cpostdata.Append("&source=" + Encode_URL(sou));
            cpostdata.Append("&version=" + Encode_URL(vers));

            WriteOutput("Connecting to TDAmeritrade as " + u + "...", true);

            lcPostUrl = "https://apis.tdameritrade.com/apps/100/LogIn?source=" + Encode_URL(sou) + "&version=" + Encode_URL(vers);

            xmlHttp_.open("POST", lcPostUrl, false, u, p);
            xmlHttp_.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xmlHttp_.setRequestHeader("Accept", "Accept	image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-powerpoint, application/vnd.ms-excel, application/msword, application/x-shockwave-flash, */*");

            xmlHttp_.send(cpostdata.ToString());
            string xmlData = xmlHttp_.responseText.ToString();
            try
            {
                Dictionary<string, string> accountData = new Dictionary<string, string>();
                bool connected = false;
                if (null != xmlData && "" != xmlData)
                {
                    WriteOutput("Loading account: " + lcPostUrl, true);
                    StringReader reader = new StringReader(xmlData);
                    XmlTextReader xml = new XmlTextReader(reader);
                    while (xml.Read())
                    {
                        if (xml.NodeType == XmlNodeType.Element)
                        {
                            string field = xml.Name;
                            xml.Read();
                            if (xml.Value.ToString() == "")
                            {
                                field = xml.Name;
                                xml.Read();
                            }
                            if (field == "result" && xml.Value.ToString() == "OK")
                                connected = true;
                            if (!accountData.ContainsKey(field))
                                accountData.Add(field, xml.Value.ToString());
                            //WriteOutput(field + ": " + xml.Value.ToString(), true);
                        }
                    }
                }
                if (!connected)
                {
                    WriteOutput("Cannot login to TDAmeritrade.  Check login or account access.", true);
                    return null;
                }
                else
                {
                    return new Tuple<string, string>(accountData["session-id"], accountData["timeout"]);
                }
            }
            catch (Exception ex)
            {
                WriteOutput("Error logging into TDA:" +ex+"\n"+xmlData, true);
            }
            return null;
        }

        public override void getData(DateTime earliestDate) // Including learning periods (startDate + learn)
        {
            try
            {
                checkLogin();

                if (user != "")
                {

                    string intervalType = "DAILY";
                    int intervalDuration = 1;
                    if (getPeriodType() == "Daily") { }
                    else if (getPeriodType() == "Weekly")
                    { intervalType = "WEEKLY"; }
                    else if (getPeriodType() == "Monthly")
                    { intervalType = "MONTHLY"; }
                    else if (getPeriodType() == "120 Minute")
                    { intervalType = "MINUTE"; intervalDuration = 30; }
                    else if (getPeriodType() == "60 Minute")
                    { intervalType = "MINUTE"; intervalDuration = 30; }
                    else if (getPeriodType() == "30 Minute")
                    { intervalType = "MINUTE"; intervalDuration = 30; }
                    else if (getPeriodType() == "15 Minute")
                    { intervalType = "MINUTE"; intervalDuration = 15; }
                    else if (getPeriodType() == "5 Minute")
                    { intervalType = "MINUTE"; intervalDuration = 5; }
                    else if (getPeriodType() == "1 Minute")
                    { intervalType = "MINUTE"; intervalDuration = 1; }

                    string url = "https://apis.tdameritrade.com/apps/100/" +
                    "PriceHistory" +
                    ";jsessionid=" + Encode_URL(session) +
                    "?source=" + Encode_URL(sid) +
                    "&requestidentifiertype=SYMBOL" +
                    "&requestvalue=" + Encode_URL(getSymbol().Replace("-", "/")) + "," +
                    "&intervaltype=" + intervalType +
                    "&intervalduration=" + intervalDuration +
                        //"&periodtype=DAY" +
                        //"&period=10"+
                    "&startdate=" + Encode_URL(earliestDate.ToString("yyyyMMdd")) +
                    "&enddate=" + Encode_URL(getEndDate().ToString("yyyyMMdd")) +
                    "&extended=false";

                    WriteOutput("Reading " + url, true);
                    using (WebClient wc = new WebClient())
                    {
                        byte[] data = wc.DownloadData(url);
                        int i = 0; uint symbLength = 0; uint datapoints = 0;

                        // Number of symbols
                        byte[] line = reverseEndian(data, i);
                        // Check that we only have 1 symbol
                        if (BitConverter.ToUInt32(line, 0) != 1)
                        {
                            WriteOutput("Too many symbols {" + BitConverter.ToUInt32(line, 0) + "} in response...", true);
                            return;
                        }
                        i += 4;

                        // Symbols field length
                        line = reverseEndian(data, i, 2);
                        symbLength = BitConverter.ToUInt16(line, 0);
                        i += 2 + (int)symbLength;

                        // Error codes
                        int error = data[i];
                        i++;
                        if (error != 0)
                        {
                            line = reverseEndian(data, i, 2);
                            int errLength = BitConverter.ToUInt16(line, 0);
                            i += 2;
                            line = reverseEndian(data, i, errLength);
                            WriteOutput("Error: " + BitConverter.ToString(line), true);
                            return;
                        }

                        // Num datapoints
                        line = reverseEndian(data, i, 4);
                        datapoints = BitConverter.ToUInt32(line, 0);
                        WriteOutput("Parsing " + datapoints + " datapoint(s)...", true);
                        i += 4;

                        double close = 0, high = float.NegativeInfinity, low = float.PositiveInfinity, open = 0, volume = 0;
                        ulong timestamp = 0;
                        int combinedBars = 0;
                        for (int j = 0; j < datapoints; j++)
                        {
                            combinedBars++;
                            if (data[i] == 255 && data[i + 1] == 255) break; // Terminator xff xff
                            close = Math.Round(BitConverter.ToSingle(reverseEndian(data, i, 4), 0), 4);
                            i += 4;
                            high = Math.Max(high, Math.Round(BitConverter.ToSingle(reverseEndian(data, i, 4), 0), 4));
                            i += 4;
                            low = Math.Min(low, Math.Round(BitConverter.ToSingle(reverseEndian(data, i, 4), 0), 4));
                            i += 4;
                            if (combinedBars == 1)
                                open = Math.Round(BitConverter.ToSingle(reverseEndian(data, i, 4), 0), 4);
                            i += 4;
                            volume += Math.Round(BitConverter.ToSingle(reverseEndian(data, i, 4), 0), 4) * 100;
                            i += 4;
                            if (combinedBars == 1)
                            {
                                timestamp = BitConverter.ToUInt64(reverseEndian(data, i, 8), 0);
                            }
                            i += 8;

                            DateTime dateTime = TimeZoneInfo.ConvertTimeFromUtc(new System.DateTime(1970, 1, 1, 0, 0, 0, 0).AddMilliseconds(timestamp), TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time"));

                            if ((getPeriodType() != "60 Minute" && getPeriodType() != "120 Minute")
                                || (getPeriodType() == "60 Minute" && (combinedBars == 2 || dateTime.TimeOfDay + TimeSpan.FromMinutes(30) >= marketClose))
                                || (getPeriodType() == "120 Minute" && (combinedBars == 4 || dateTime.TimeOfDay + TimeSpan.FromMinutes(30) >= marketClose))
                                || j == datapoints - 1
                                )
                            {
                                if (!(isIntraday && (dateTime.TimeOfDay < marketOpen || dateTime.TimeOfDay > marketClose)))
                                {
                                    if (dateTime >= earliestDate)
                                        addDataPoint(dateTime, high, low, open, close, volume);
                                    open = close = volume = combinedBars = 0;
                                    high = float.NegativeInfinity;
                                    low = float.PositiveInfinity;
                                }
                            }
                            if (!isRunning) return;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                WriteOutput("Error getting data from TDA: " + ex, true);
            }
        }

        public string[] getToday()
        {
            try
            {
                checkLogin();

                if (user != "")
                {
                    string intervalType = "DAILY";
                    int intervalDuration = 1;

                    string url = "https://apis.tdameritrade.com/apps/100/" +
                    "PriceHistory" +
                    ";jsessionid=" + Encode_URL(session) +
                    "?source=" + Encode_URL(sid) +
                    "&requestidentifiertype=SYMBOL" +
                    "&requestvalue=" + Encode_URL(getSymbol().Replace("-", "/")) + "," +
                    "&intervaltype=" + intervalType +
                    "&intervalduration=" + intervalDuration +
                        //"&periodtype=DAY" +
                        //"&period=10"+
                    "&startdate=" + Encode_URL(getEndDate().ToString("yyyyMMdd")) +
                    "&enddate=" + Encode_URL(getEndDate().ToString("yyyyMMdd")) +
                    "&extended=false";

                    WriteOutput("Reading " + url, true);
                    using (WebClient wc = new WebClient())
                    {
                        byte[] data = wc.DownloadData(url);
                        int i = 0; uint symbLength = 0; uint datapoints = 0;

                        // Number of symbols
                        byte[] line = reverseEndian(data, i);
                        // Check that we only have 1 symbol
                        if (BitConverter.ToUInt32(line, 0) != 1)
                        {
                            WriteOutput("Too many symbols {" + BitConverter.ToUInt32(line, 0) + "} in response...", true);
                            return new string[] { "" };
                        }
                        i += 4;

                        // Symbols field length
                        line = reverseEndian(data, i, 2);
                        symbLength = BitConverter.ToUInt16(line, 0);
                        i += 2 + (int)symbLength;

                        // Error codes
                        int error = data[i];
                        i++;
                        if (error != 0)
                        {
                            line = reverseEndian(data, i, 2);
                            int errLength = BitConverter.ToUInt16(line, 0);
                            i += 2;
                            line = reverseEndian(data, i, errLength);
                            WriteOutput("Error: " + BitConverter.ToString(line), true);
                            return new string[] { "" };
                        }

                        // Num datapoints
                        line = reverseEndian(data, i, 4);
                        datapoints = BitConverter.ToUInt32(line, 0);
                        WriteOutput("Parsing " + datapoints + " datapoint(s)...", true);
                        if (datapoints > 1)
                        {
                            WriteOutput("Too many datapoints, expected only today from TDAmeritrade.", true);
                            return new string[] { "" };
                        }
                        i += 4;

                        if (data[i] == 255 && data[i + 1] == 255)
                        {
                            WriteOutput("Abrupt end of data from TDAmeritrade.", true);
                            return new string[] { "" }; // Terminator xff xff
                        }
                        double close = Math.Round(BitConverter.ToSingle(reverseEndian(data, i, 4), 0), 4);
                        i += 4;
                        double high = Math.Round(BitConverter.ToSingle(reverseEndian(data, i, 4), 0), 4);
                        i += 4;
                        double low = Math.Round(BitConverter.ToSingle(reverseEndian(data, i, 4), 0), 4);
                        i += 4;
                        double open = Math.Round(BitConverter.ToSingle(reverseEndian(data, i, 4), 0), 4);
                        i += 4;
                        double volume = Math.Round(BitConverter.ToSingle(reverseEndian(data, i, 4), 0), 4) * 100;
                        i += 4;
                        ulong timestamp = BitConverter.ToUInt64(reverseEndian(data, i, 8), 0);
                        i += 8;
                        DateTime dateTime = TimeZoneInfo.ConvertTimeFromUtc(new System.DateTime(1970, 1, 1, 0, 0, 0, 0).AddMilliseconds(timestamp),
                                            TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time"));
                        return new string[] { dateTime.ToString("yyyy-MM-dd"), "" + open, "" + high, "" + low, "" + close, "" + volume, "" + close };
                    }
                }
            }
            catch (Exception ex)
            {
                WriteOutput("Error getting today's data from TDA: " + ex, true);
            }
            return new string[] { "" };
        }

        public void trade(string symbol, double price, string type, int shares, bool checkBalances=true)
        {
            if(checkBalances) checkLogin();
            if (user != "")
            {
                if (checkBalances) getBalances();
                if (tradeEquities)
                {
                    if (type == "buy" || type == "short")
                    {
                        string ordKey = equityOrders.Where(x => x.Value["underlying-symbol"] == symbol).Select(x => x.Key).DefaultIfEmpty("").First();
                        if (!(equityPositions.ContainsKey(symbol) && equityPositions[symbol]["position-type"] == "LONG")
                            && !(ordKey != "" && equityOrders[ordKey]["action"] == equityActions[type]))
                        {
                            Tuple<int, double> filled = getEquityFills(tradeEquity(symbol, type, price, shares));
                            WriteOutput("Filled " + filled.Item1 + " shares @ $"+filled.Item2+".", true);
                        }
                        else
                            WriteOutput("Position or order already exists.", true);
                    }
                    else
                    {
                        string ordKey = equityOrders.Where(x => x.Value["underlying-symbol"] == symbol).Select(x => x.Key).DefaultIfEmpty("").First();
                        if (equityPositions.ContainsKey(symbol) && equityPositions[symbol]["position-type"] == closeType[type]
                            && !(ordKey!=""&& equityOrders[ordKey]["action"] == equityActions[type]))
                        {
                            Tuple<int, double> filled = getEquityFills(tradeEquity(symbol, type, price, Convert.ToInt32(equityPositions[symbol]["quantity"])));
                            WriteOutput("Filled " + filled.Item1 + " shares @ $" + filled.Item2 + ".", true);
                        }
                        else
                            WriteOutput("No position to close or order already exists.", true);
                    }
                }
                if (tradeOptions)
                {
                    if (type == "buy" || type == "short")
                    {
                        string posKey = optionPositions.Keys.Where(x => x.Split(' ').First() == symbol).DefaultIfEmpty("").First();
                        string ordKey = optionOrders.Where(x => x.Value["underlying-symbol"] == symbol).Select(x => x.Key).DefaultIfEmpty("").First();
                        if (!(posKey!="" && optionPositions[posKey]["position-type"] == "LONG"
                            && !(ordKey!="" && optionOrders[ordKey]["action"] == "B")))
                        {
                            Tuple<int, double> filled = getOptionFills(tradeOption(symbol, price, type, shares));
                            WriteOutput("Filled " + filled.Item1 + " shares @ $" + filled.Item2 + ".", true);
                        }
                        else
                            WriteOutput("Position or another order for it exists.", true);
                    }
                    else
                    {
                        string posKey = optionPositions.Keys.Where(x => x.Split(' ').First() == symbol).DefaultIfEmpty("").First();
                        string ordKey = optionOrders.Where(x => x.Value["underlying-symbol"] == symbol).Select(x=>x.Key).DefaultIfEmpty("").First();
                        if (posKey!="" && optionPositions[posKey]["position-type"] == "LONG"
                            && !(ordKey!="" && optionOrders[ordKey]["action"] == "S"))
                        {
                            Tuple<int, double> filled = getOptionFills(tradeOption(symbol, price, type, Convert.ToInt32(optionPositions[symbol]["quantity"])));
                            WriteOutput("Filled " + filled.Item1 + " shares @ $" + filled.Item2 + ".", true);
                        }
                        else
                            WriteOutput("No position to close or another order for it exists.", true);
                    }
                }
            }
        }

        public void checkPositions(Execution.TDAmeritrade a)
        {
            if (!autoClose) return;
            WriteOutput("Checking positions in TDA account...", true);
            checkLogin();
            if (user != "")
            {
                getBalances();
                if (tradeEquities)
                {
                    WriteOutput("Existing equity positions: " + string.Join(", ", equityPositions.Keys, true));
                    foreach (string symbol in equityPositions.Keys)
                    {
                        string s = symbol.Replace(".", "-");
                        // See what the batch list says about this symbol
                        BatchResult b = a.getResult(s);

                        // Close it if Batch doesn't say it should be open and we're not in the middle of trading it today
                        // Don't close if opened today, to avoid last minute fluctuations in signals causing repeat buy/sells.
                        if (b.action != "Long" && b.action != "Short" && b.when > 0 && b.action.Contains("Closed"))
                        {
                            WriteOutput("Closing unmatched position " + s, true);
                            trade(symbol, b.lastPrice, (equityPositions[symbol]["position-type"] == "LONG" ? "sell" : "cover"), Convert.ToInt32(equityPositions[symbol]["quantity"]), false);
                        }
                    }
                }
                if (tradeOptions)
                {
                    string[] options = optionPositions.Keys.Where(x=>optionPositions[x]["position-type"]=="LONG").ToArray();
                    WriteOutput("Existing option positions: " + string.Join(", ", options, true));
                    foreach (string opSymbol in options)
                    {
                        string s = opSymbol.Split(' ').First().Replace(".", "-");

                        // See what the batch list says about this symbol
                        BatchResult b = a.getResult(s);

                        // Close it if Batch doesn't say it should be open and we're not in the middle of trading it today
                        // Don't close if opened today, to avoid last minute fluctuations in signals causing repeat buy/sells.
                        if (b.action != "Long" && b.action != "Short" && b.when > 0 && b.action.Contains("Closed"))
                        {
                            WriteOutput("Closing unmatched position " + s, true);
                            trade(s, b.lastPrice, (optionPositions[opSymbol]["put-call"] == "C" ? "sell" : "cover"), Convert.ToInt32(optionPositions[opSymbol]["quantity"]), false);
                        }
                    }
                }
            }
        }

        public string tradeEquity(string symbol, string type, double price, int shares, string customSourceID = "", string customSession = "")
        {
            if (type == "buy" || type == "short")
            {
                WriteOutput("TDA buy/short opening trade...", true);
                double cost = price * shares + perStockTradeFee;
                if (Convert.ToDouble(balanceData["available-funds-for-trading"]) < cost)
                {
                    WriteOutput("Not enough funds to execute trade.", true);
                    return "";
                }
                else WriteOutput("Funds available: $" + balanceData["available-funds-for-trading"], true);
                /*if (total + cost >= ((Execution.TDAmeritrade)execution["TDAmeritrade"]).getPortfolioSize())
                {
                    WriteOutput("Current positions total $"+total+"/"+((Execution.TDAmeritrade)execution["TDAmeritrade"]).getPortfolioSize()+", cannot add positions without exceeding portfolio cap.", true);
                    return "";
                }*/
            }
            string orderstring = "accountid="+balanceData["account-id"]+"~action="+openType[type]+"~expire=day~ordtype=limit~price="+price+"~quantity="+shares+"~symbol="+symbol;

            string ses = session; string sou = sid;
            if (customSourceID != "") sou = customSourceID;
            if (customSession != "") ses = customSession;
            string url = "https://apis.tdameritrade.com/apps/100/" +
                "EquityTrade" +
                ";jsessionid=" + Encode_URL(ses) +
                "?source=" + Encode_URL(sou)+
                "&orderstring=" + Encode_URL(orderstring);
            using (WebClient wc = new WebClient())
            {
                WriteOutput("Sending trade to " + url, true);
                string xmlData = Encoding.ASCII.GetString(wc.DownloadData(url));
                Dictionary<string, string> temp = new Dictionary<string, string>();
                if (null != xmlData && "" != xmlData)
                {
                    StringReader reader = new StringReader(xmlData);
                    XmlTextReader xml = new XmlTextReader(reader);
                    string field = "";
                    while (xml.Read())
                    {
                        switch (xml.NodeType)
                        {
                            case XmlNodeType.Element:
                                field = xml.Name;
                                break;
                            case XmlNodeType.EndElement:
                                field = "";
                                break;
                            case XmlNodeType.Text:
                                //WriteOutput(field + ": " + xml.Value);
                                temp[field] = xml.Value;
                                break;
                        }
                    }
                    if (temp["result"] == "OK" && (!temp.ContainsKey("error") || temp["error"] == ""))
                    {
                        WriteOutput("TDAmeritrade order created: " + temp["order-id"], true);
                        return temp["order-id"];
                    }
                    else
                        WriteOutput("TDAmeritrade order failed: " + temp["error"], true);
                }
            }
            return "";
        }

        public Tuple<int, double> getEquityFills(string orderid, string customSourceID = "", string customSession = "")
        {
            DateTime start = DateTime.Now;
            WriteOutput("Waiting for order to fill...", true);

            Thread.Sleep(3000);
            getOpenOrders(orderid, customSourceID, customSession);
            while (equityOrders.ContainsKey(orderid))
            {
                WriteOutput("Order still pending...", true);
                Application.DoEvents();
                if ((DateTime.Now - start).Minutes > fillWait)
                {
                    string ses = session; string sou = sid;
                    if (customSession != "") ses = customSession;
                    if (customSourceID != "") sou = customSourceID;
                    string cancel = ("https://apis.tdameritrade.com/apps/100/" +
                    "OrderCancel" +
                    ";jsessionid=" + Encode_URL(ses) +
                    "?source=" + Encode_URL(sou) +
                    "&orderid=" + Encode_URL(orderid));
                    WriteOutput("No fill, cancelling order: " + cancel, true);
                    using (WebClient wc = new WebClient())
                    {
                        string result = Encoding.ASCII.GetString(wc.DownloadData(cancel));
                    }
                    break;
                }
                for (int i = 0; i < 60; i++)
                {
                    Application.DoEvents();
                    Thread.Sleep(1000);
                }
                getOpenOrders(orderid, customSourceID, customSession);
            }
            return getOrderFill(orderid, customSourceID, customSession);
        }

        public Dictionary<string, Dictionary<string, string>> getOptionData(string symbol, string type = "", double strikeRequest = 0)
        {
            checkLogin();

            string url = "https://apis.tdameritrade.com/apps/200/" +
                "OptionChain" +
                ";jsessionid=" + Encode_URL(session) +
                "?source=" + Encode_URL(sid) +
                "&symbol=" + Encode_URL(symbol) +
                (strikeRequest > 0 ? "&strike=" + strikeRequest : "") +
                (type==""? "":"&type="+type)+
                "&range=ALL&quotes=true"; // Range=I (in-the-money), O (out), N (near), ALL (all)
            using (CustomWebClient wc = new CustomWebClient())
            {
                WriteOutput("Downloading options data from " + url, true);
                string xmlData = "";
                try {
                    xmlData = Encoding.ASCII.GetString(wc.DownloadData(url));
                    return queryOptionsData(xmlData);
                }
                catch (Exception ex) {
                    WriteOutput("Error: "+ex.ToString(), true);
                    try
                    {
                        Dictionary<string, Dictionary<string, string>> results = new Dictionary<string, Dictionary<string, string>>();
                        url = url.Replace("range=ALL", "range=O");
                        WriteOutput("Downloading options data in pieces due to timeout: " + url, true);
                        xmlData = Encoding.ASCII.GetString(wc.DownloadData(url));
                        foreach (KeyValuePair<string, Dictionary<string, string>> kv in queryOptionsData(xmlData))
                            results[kv.Key] = kv.Value;

                        url = url.Replace("range=O", "range=I");
                        WriteOutput("Downloading options data in pieces due to timeout: " + url, true);
                        xmlData = Encoding.ASCII.GetString(wc.DownloadData(url));
                        foreach (KeyValuePair<string, Dictionary<string, string>> kv in queryOptionsData(xmlData))
                            results[kv.Key] = kv.Value;

                        return results;
                    }
                    catch (Exception ex2)
                    {
                        WriteOutput("2nd Error: " + ex2.ToString(), true);
                        return null;
                    }
                }
                
            }
            return null;
        }

        private Dictionary<string, Dictionary<string, string>> queryOptionsData(string xmlData)
        {
            Dictionary<string, Dictionary<string, string>> output = new Dictionary<string, Dictionary<string, string>>();
            Dictionary<string, string> temp = new Dictionary<string, string>();
            if (null != xmlData && "" != xmlData)
            {
                StringReader reader = new StringReader(xmlData);
                XmlTextReader xml = new XmlTextReader(reader);
                string field = ""; double strike = 0; int expire = 0; string expirationDate = "";
                bool isOption = false;
                while (xml.Read())
                {
                    switch (xml.NodeType)
                    {
                        case XmlNodeType.Element:
                            field = xml.Name;
                            if (field == "put" || field == "call")
                            {
                                isOption = true;
                                temp = new Dictionary<string, string>();
                            }
                            break;
                        case XmlNodeType.EndElement:
                            field = "";
                            if (xml.Name == "put" || xml.Name == "call")
                            {
                                isOption = false;
                                if (!temp.ContainsKey("ask")) temp["ask"] = "0";
                                if (!temp.ContainsKey("bid")) temp["bid"] = "0";
                                if (!temp.ContainsKey("volume")) temp["volume"] = "0";
                                if (!temp.ContainsKey("last")) temp["last"] = "0";
                                if (temp.ContainsKey("ask") && temp.ContainsKey("bid") && temp.ContainsKey("description") && temp.ContainsKey("option-symbol") && temp.ContainsKey("volume") && temp.ContainsKey("last"))
                                {
                                    temp["strike"] = "" + strike;
                                    temp["expire"] = "" + expire;
                                    temp["date"] = expirationDate;
                                    temp["description"] = convertOptionSymbolToDescription(temp["option-symbol"], temp["description"]);
                                    output.Add(convertOptionSymbolToDescription(temp["option-symbol"], temp["description"]), temp);
                                }
                            }
                            break;
                        case XmlNodeType.Text:
                            //WriteOutput(field + ": " + xml.Value);
                            if (isOption) temp[field] = xml.Value;
                            else if (field == "days-to-expiration")
                                expire = Convert.ToInt32(xml.Value);
                            else if (field == "date")
                                expirationDate = xml.Value;
                            else if (field == "strike-price")
                                strike = Convert.ToDouble(xml.Value);
                            break;
                    }
                }
                return output;
            }
            return null;
        }

        public Dictionary<string, double> getOptionVolume(string symbol)
        {
            checkLogin();

            string url = "https://apis.tdameritrade.com/apps/200/" +
                "OptionChain" +
                ";jsessionid=" + Encode_URL(session) +
                "?source=" + Encode_URL(sid) +
                "&symbol=" + Encode_URL(symbol) +
                "&range=ALL&quotes=true"; // Range=I (in-the-money), O (out), N (near), ALL (all)
            using (CustomWebClient wc = new CustomWebClient())
            {
                WriteOutput("Downloading options volume data from " + url, true);
                string xmlData = Encoding.ASCII.GetString(wc.DownloadData(url));
                Dictionary<string, double> output = new Dictionary<string, double>();
                Dictionary<string, string> temp = new Dictionary<string, string>();
                if (null != xmlData && "" != xmlData)
                {
                    StringReader reader = new StringReader(xmlData);
                    XmlTextReader xml = new XmlTextReader(reader);
                    string field = ""; double strike = 0; int expire = 0; string expirationDate = "";
                    bool isOption = false;
                    while (xml.Read())
                    {
                        switch (xml.NodeType)
                        {
                            case XmlNodeType.Element:
                                field = xml.Name;
                                if (field == "put" || field == "call")
                                {
                                    isOption = true;
                                    temp = new Dictionary<string, string>();
                                }
                                break;
                            case XmlNodeType.EndElement:
                                field = "";
                                if (xml.Name == "put" || xml.Name == "call")
                                {
                                    isOption = false;
                                    if (!temp.ContainsKey("ask")) temp["ask"] = "0";
                                    if (!temp.ContainsKey("bid")) temp["bid"] = "0";
                                    if (!temp.ContainsKey("volume")) temp["volume"] = "0";
                                    if (!temp.ContainsKey("last")) temp["last"] = "0";
                                    if (temp.ContainsKey("ask") && temp.ContainsKey("bid") && temp.ContainsKey("description") && temp.ContainsKey("option-symbol") && temp.ContainsKey("volume") && temp.ContainsKey("last"))
                                    {
                                        double val =  Convert.ToDouble(temp["volume"]) * Convert.ToDouble(temp["last"]);
                                        if(temp["description"].Contains("Mini")) val*=10;
                                        else val*=100;
                                        temp["description"] = convertOptionSymbolToDescription(temp["option-symbol"], temp["description"]);
                                        output.Add(convertOptionSymbolToDescription(temp["option-symbol"], temp["description"]), val);
                                        //WriteOutput(output.Last().Key + ": $" + output.Last().Value, true);
                                    }
                                }
                                break;
                            case XmlNodeType.Text:
                                //WriteOutput(field + ": " + xml.Value);
                                if (isOption) temp[field] = xml.Value;
                                else if (field == "days-to-expiration")
                                    expire = Convert.ToInt32(xml.Value);
                                else if (field == "date")
                                    expirationDate = xml.Value;
                                else if (field == "strike-price")
                                    strike = Convert.ToDouble(xml.Value);
                                break;
                        }
                    }
                    return output;
                }
            }
            return null;
        }

        public Dictionary<string, string> getOption(string symbol, double price, string type, string date)
        {
            string url = "https://apis.tdameritrade.com/apps/200/" +
                "OptionChain" +
                ";jsessionid=" + Encode_URL(session) +
                "?source=" + Encode_URL(sid) +
                "&symbol=" + Encode_URL(symbol)+
                "&type="+optionRequestType[type]+
                "&range=N&quotes=true&expire="+date;
            using (CustomWebClient wc = new CustomWebClient())
            {
                WriteOutput("Downloading options data from " + url);
                string xmlData = Encoding.ASCII.GetString(wc.DownloadData(url));
                Dictionary<string, string> output = null;
                Dictionary<string, string> temp = new Dictionary<string, string>();
                if (null != xmlData && "" != xmlData)
                {
                    StringReader reader = new StringReader(xmlData);
                    XmlTextReader xml = new XmlTextReader(reader);
                    string field = ""; double strike = 0; int expire = 0; string expirationDate="";
                    bool isOption = false;
                    while (xml.Read())
                    {
                        switch (xml.NodeType)
                        {
                            case XmlNodeType.Element:
                                field = xml.Name;
                                if (field == "put" || field=="call") {
                                    isOption = true;
                                    temp = new Dictionary<string, string>();
                                }
                                break;
                            case XmlNodeType.EndElement:
                                field = "";
                                if (xml.Name == "put" || xml.Name == "call")
                                {
                                    isOption = false;
                                    if (temp.ContainsKey("ask") && temp.ContainsKey("bid"))
                                    {
                                        if (expire >= minExpiration &&
                                            (Convert.ToDouble(temp["ask"]) - Convert.ToDouble(temp["bid"])) / Convert.ToDouble(temp["bid"]) < 1.0 * maxSpread / 100.0)
                                        {
                                            if (output == null || Math.Abs(strike - price) < Math.Abs(Convert.ToDouble(output["strike"]) - price))
                                            {
                                                output = temp;
                                                output["strike"] = "" + strike;
                                                output["expire"] = "" + expire;
                                                output["date"] = expirationDate;
                                            }
                                            else return output;
                                        }
                                    }
                                }
                                break;
                            case XmlNodeType.Text:
                                //WriteOutput(field + ": " + xml.Value);
                                if (isOption) temp[field] = xml.Value;
                                else if (field == "days-to-expiration")
                                    expire = Convert.ToInt32(xml.Value);
                                else if (field == "date")
                                    expirationDate = xml.Value;
                                else if (field == "strike-price")
                                    strike = Convert.ToDouble(xml.Value);
                                break;
                        }
                    }
                    return output;
                }
            }
            return null;
        }

        public Dictionary<string, string> getOption(string symbol)
        {
            Dictionary<string, string> output = new Dictionary<string, string>();
            string opKey = optionPositions.Keys.Where(x => x.Split(' ').First() == symbol).DefaultIfEmpty("").First();
            if (opKey != "")
            {
                output["bid"] = "" + Convert.ToDouble(optionPositions[opKey]["current-value"]) / (100 * Convert.ToDouble(optionPositions[opKey]["quantity"]));
                output["description"] = convertOptionSymbolToDescription(optionPositions[opKey]["symbol"], optionPositions[opKey]["description"]);
                output["option-symbol"] = optionPositions[opKey]["symbol"];
            }
            return output;
        }

        public string tradeOption(string symbol, double price, string type, int shares, string customSourceID = "", string customSession = "")
        {
            Dictionary<string, string> option; string action = "buy";
            if (type == "buy" || type == "short")
            {
                DateTime expir = getNow().AddDays(minExpiration);
                Dictionary<string, string> option1 = getOption(symbol, price, type, expir.ToString("yyyyMM"));
                Dictionary<string, string> option2 = getOption(symbol, price, type, expir.AddMonths(1).ToString("yyyyMM"));
                if (option1 != null && Convert.ToInt32(option1["expire"]) >= minExpiration)
                {
                    option = option1;
                    option2 = null;
                }
                else
                {
                    option = option2;
                    option1 = null;
                }
                if (option == null)
                {
                    WriteOutput("No options available to trade.", true);
                    return "";
                }
            }
            else
            {
                option = getOption(symbol);
                action = "sell";
                if (option.Count == 0)
                {
                    WriteOutput("No options position found for " + symbol + ".", true);
                    return "";
                }
            }
            double opPrice = (optionAction[type] == "buytoopen" ? Convert.ToDouble(option["ask"]) : Convert.ToDouble(option["bid"]));
            int opShares = (optionAction[type] == "buytoopen" ? (int)Math.Floor(price * shares / (opPrice * 100)) : shares);
            return tradeOptionContract(symbol, option["option-symbol"], action, opPrice, opShares, customSourceID, customSession);
        }

        public string tradeOptionContract(string underlying_symbol, string option_symbol, string action, double price, int qty, string customSourceID = "", string customSession = "")
        {
            double opPrice = price;
            int opShares = qty;
            if (action == "buy")
            {
                double cost = opPrice * opShares + perOptionContractFee + opShares * perOptionContractFee;
                if (Convert.ToDouble(balanceData.ContainsKey("option-buying-power") ? balanceData["option-buying-power"] : balanceData.ContainsKey("non-marginable-funds") ? balanceData["non-marginable-funds"] : balanceData["available-funds-for-trading"]) < cost)
                {
                    WriteOutput("Not enough funds to execute trade.", true);
                    return "";
                }
                else WriteOutput("Funds available: $" + balanceData["available-funds-for-trading"], true);
            }
            else if (action != "sell")
            {
                WriteOutput("Unrecognized option trade: Only buy or sell allowed", true);
                return "";
            }
            string orderstring = "accountid=" + balanceData["account-id"] + "~action=" + optionAction[action] + "~expire=day~ordtype=limit~price=" + opPrice + "~quantity=" + opShares + "~symbol=" + option_symbol;

            string ses = session; string sou = sid;
            if (customSourceID != "") sou = customSourceID;
            if (customSession != "") ses = customSession;
            string url = "https://apis.tdameritrade.com/apps/100/" +
                "OptionTrade" +
                ";jsessionid=" + Encode_URL(ses) +
                "?source=" + Encode_URL(sou) +
                "&orderstring=" + Encode_URL(orderstring);
            WriteOutput("Sending trade to " + url, true);
            WriteOutput("Option: " + option_symbol + ", " + opShares + " at $" + opPrice, true);
            using (WebClient wc = new WebClient())
            {
                string xmlData = Encoding.ASCII.GetString(wc.DownloadData(url));
                Dictionary<string, string> temp = new Dictionary<string, string>();
                if (null != xmlData && "" != xmlData)
                {
                    StringReader reader = new StringReader(xmlData);
                    XmlTextReader xml = new XmlTextReader(reader);
                    string field = "";
                    while (xml.Read())
                    {
                        switch (xml.NodeType)
                        {
                            case XmlNodeType.Element:
                                field = xml.Name;
                                break;
                            case XmlNodeType.EndElement:
                                field = "";
                                break;
                            case XmlNodeType.Text:
                                //WriteOutput(field + ": " + xml.Value);
                                temp[field] = xml.Value;
                                break;
                        }
                    }
                    if (temp["result"] == "OK" && (!temp.ContainsKey("error") || temp["error"] == ""))
                    {
                        WriteOutput("TDAmeritrade order created: " + temp["order-id"], true);
                        return temp["order-id"];
                    }
                    else
                        WriteOutput("TDAmeritrade order failed: " + temp["error"], true);
                }
            }
            return "";
        }

        public Tuple<int, double> getOptionFills(string orderid, string customSourceID = "", string customSession = "")
        {
            DateTime start = DateTime.Now;
            WriteOutput("Waiting for order to fill...", true);

            Thread.Sleep(3000);
            getOpenOrders(orderid, customSourceID, customSession);
            while (optionOrders.ContainsKey(orderid))
            {
                WriteOutput("Order still pending...", true);
                Application.DoEvents();
                if ((DateTime.Now - start).Minutes > fillWait)
                {
                    string ses = session; string sou = sid;
                    if (customSession != "") ses = customSession;
                    if (customSourceID != "") sou = customSourceID;
                    string cancel = ("https://apis.tdameritrade.com/apps/100/" +
                    "OrderCancel" +
                    ";jsessionid=" + Encode_URL(ses) +
                    "?source=" + Encode_URL(sou) +
                    "&orderid=" + Encode_URL(orderid));
                    WriteOutput("No fill, cancelling order: " + cancel, true);
                    using (WebClient wc = new WebClient())
                    {
                        string result = Encoding.ASCII.GetString(wc.DownloadData(cancel));
                    }
                    break;
                }
                for (int i = 0; i < 60; i++)
                {
                    Application.DoEvents();
                    Thread.Sleep(1000);
                }
                getOpenOrders(orderid);
            }
            return getOrderFill(orderid);
        }

        public void getBalancesIfEmpty(string customSourceID = "", string customSession = "")
        {
            if (equityPositions == null) getBalances(customSourceID, customSession);
        }

        public void getBalances(string customSourceID = "", string customSession = "")
        {
            if (user != "")
            {
                balanceData = new Dictionary<string, string>();
                equityPositions = new Dictionary<string, Dictionary<string, string>>();
                optionPositions = new Dictionary<string, Dictionary<string, string>>();
                Dictionary<string, string> temp = new Dictionary<string, string>();

                string ses = session; string sou = sid;
                if (customSession != "") ses = customSession;
                if (customSourceID != "") sou = customSourceID;

                string url = "https://apis.tdameritrade.com/apps/100/" +
                "BalancesAndPositions" +
                ";jsessionid=" + Encode_URL(ses) +
                "?source=" + Encode_URL(sou) +
                "&suppressquotes=true";
                using (WebClient wc = new WebClient())
                {
                    WriteOutput("Checking account balances at " + url, true);
                    string xmlData = Encoding.ASCII.GetString(wc.DownloadData(url));
                    if (null != xmlData && "" != xmlData)
                    {
                        StringReader reader = new StringReader(xmlData);
                        XmlTextReader xml = new XmlTextReader(reader);
                        string field = "";
                        bool position = false, value = false, success = false;
                        while (xml.Read())
                        {
                            switch (xml.NodeType)
                            {
                                case XmlNodeType.Element:
                                    if (xml.Name == "position")
                                    {
                                        //WriteOutput("--Position--", true);
                                        position = true;
                                        temp = new Dictionary<string, string>();
                                    }
                                    else if (xml.Name == "account-value")
                                    {
                                        //WriteOutput("--Account Value--", true);
                                        value = true;
                                    }
                                    else
                                        field = xml.Name;
                                    break;
                                case XmlNodeType.EndElement:
                                    field = "";
                                    if (xml.Name == "position")
                                    {
                                        if (temp["asset-type"] == "E")
                                            equityPositions.Add(temp["symbol"], temp);
                                        else if (temp["asset-type"] == "O")
                                        {
                                            temp["description"] = convertOptionSymbolToDescription(temp["symbol"], temp["description"]);
                                            optionPositions.Add(convertOptionSymbolToDescription(temp["symbol"], temp["description"]), temp);
                                        }
                                        position = false;
                                        //WriteOutput("--End of " + temp["symbol"] + "--", true);
                                    }
                                    else if (xml.Name == "account-value")
                                    {
                                        //WriteOutput("--End of Account Value--", true);
                                        value = false;
                                    }
                                    break;
                                case XmlNodeType.Text:
                                    //WriteOutput(field + ": " + xml.Value, true);
                                    if (field == "result" && xml.Value == "OK") success = true;
                                    if (position)
                                    {
                                        temp[field] = xml.Value;
                                    }
                                    else if (value)
                                    {
                                        if (field == "current")
                                            balanceData["account-value"] = xml.Value;
                                    }
                                    else
                                        balanceData[field] = xml.Value;
                                    break;
                            }
                        }
                        if (!success)
                        {
                            WriteOutput("Balance request failed.", true);
                            equityPositions = null;
                            optionPositions = null;
                        }
                        else
                        {
                            WriteOutput("Existing equity positions: " + string.Join(", ", equityPositions.Keys), true);
                            WriteOutput("Existing option positions: " + string.Join(", ", optionPositions.Keys), true);
                        }
                    }
                    else
                    {
                        WriteOutput("No balance results.", true);
                        equityPositions = null;
                        optionPositions = null;
                    }
                }

                getOpenOrders("", customSourceID, customSession);
            }
        }

        public double GetAccountValue(string customSourceID = "", string customSession = "")
        {
            getBalancesIfEmpty(customSourceID, customSession);
            if (balanceData.ContainsKey("account-value"))
            {
                WriteOutput("Fetching account value from TDA: $" + balanceData["account-value"], true);
                return Convert.ToDouble(balanceData["account-value"]);
            }
            else return 0;
        }

        public List<TDPosition> getPositions(string customSourceID="", string customSession="")
        {
            getBalances(customSourceID, customSession);
            List<TDPosition> positions = new List<TDPosition>();
            if (equityPositions == null) return null;
            foreach (Dictionary<string, string> kv in equityPositions.Values)
                positions.Add(new TDPosition() { ticker = kv["symbol"], qty = (kv["position-type"] == "LONG" ? 1 : -1) * Math.Abs(Convert.ToInt32(Convert.ToDouble(kv["quantity"]))), averagePrice = Convert.ToDouble(kv["average-price"])});
            if (optionPositions == null) return null;
            foreach (Dictionary<string, string> kv in optionPositions.Values)
                positions.Add(new TDPosition() { ticker = cleanOptionsDescription(kv["description"]), qty = (kv["position-type"] == "LONG" ? 1 : -1) * Math.Abs(Convert.ToInt32(Convert.ToDouble(kv["quantity"]))), averagePrice = Convert.ToDouble(kv["average-price"]) });
            WriteOutput("Fetching positions from TDA: " + string.Join(", ", positions.Select(x => x.qty + " " + x.ticker)), true);
            return positions;
        }

        public string convertOptionSymbolToDescription(string s, string d)
        {
            if (d.Contains(" Call") || d.Contains(" Put")) return cleanOptionsDescription(d);

            string[] parts = s.Split('_');
            StringBuilder desc = new StringBuilder();
            desc.Append(parts[0]);
            desc.Append(" ");
            desc.Append(DateTime.ParseExact(parts[1].Substring(0, 6), "MMddyy", System.Globalization.CultureInfo.InvariantCulture).ToString("MMM d yyyy"));
            desc.Append(" ");
            desc.Append(parts[1].Substring(7));
            desc.Append(" ");
            if (parts[1].Contains("C")) desc.Append("Call");
            else desc.Append("Put");

            return cleanOptionsDescription(desc.ToString());
        }

        public string cleanOptionsDescription(string s)
        {
            return s.Replace(".0 ", " ").Replace(" 0", " ");
        }
        public void getOpenOrders(string id = "", string customSourceID = "", string customSession = "")
        {
            equityOrders = new Dictionary<string, Dictionary<string, string>>();
            optionOrders = new Dictionary<string, Dictionary<string, string>>();
            string ses = session; string sou = sid;
            if (customSourceID != "") sou = customSourceID;
            if (customSession != "") ses = customSession;
            string url = "https://apis.tdameritrade.com/apps/100/" +
                "OrderStatus" +
                ";jsessionid=" + Encode_URL(ses) +
                "?source=" + Encode_URL(sou) +
                "&type=open&underlying=TRUE"
                +(id!=""? "&orderid="+id:"");
            using (WebClient wc = new WebClient())
            {
                WriteOutput("Checking existing orders at " + url, true);
                string xmlData = Encoding.ASCII.GetString(wc.DownloadData(url));
                Dictionary<string, string> temp = new Dictionary<string, string>();
                if (null != xmlData && "" != xmlData)
                {
                    StringReader reader = new StringReader(xmlData);
                    XmlTextReader xml = new XmlTextReader(reader);
                    string field = "";
                    bool order = false;
                    while (xml.Read())
                    {
                        switch (xml.NodeType)
                        {
                            case XmlNodeType.Element:
                                if (xml.Name == "order")
                                {
                                    //WriteOutput("--Order--");
                                    order = true;
                                    temp = new Dictionary<string, string>();
                                }
                                else
                                    field = xml.Name;
                                break;
                            case XmlNodeType.EndElement:
                                field = "";
                                if (xml.Name == "order")
                                {
                                    if (temp["asset-type"] == "E")
                                        equityOrders.Add(temp["order-id"], temp);
                                    else if (temp["asset-type"] == "O")
                                    {
                                        if (!temp.ContainsKey("underlying-symbol")) temp["underlying-symbol"] = temp["symbol"].Split('_').First();
                                        optionOrders.Add(temp["order-id"], temp);
                                    }
                                    order = false;
                                    //WriteOutput("--End of " + temp["symbol"] + "--");
                                }
                                break;
                            case XmlNodeType.Text:
                                //WriteOutput(field + ": " + xml.Value);
                                if (order)
                                {
                                    temp[field] = xml.Value;
                                }
                                break;
                        }
                    }
                    if(id=="") WriteOutput("Existing orders: " + string.Join(", ", equityOrders.Keys.Concat(optionOrders.Keys)), true);
                }
            }
        }

        public Tuple<int, double> getOrderFill(string id, string customSourceID = "", string customSession = "")
        {
            if (id == "") return new Tuple<int, double>(0, 0);
            string ses = session; string sou = sid;
            if (customSourceID != "") sou = customSourceID;
            if (customSession != "") ses = customSession;
            string url = "https://apis.tdameritrade.com/apps/100/" +
                "OrderStatus" +
                ";jsessionid=" + Encode_URL(ses) +
                "?source=" + Encode_URL(sou) +
                "&type=all&underlying=TRUE" +
                "&orderid=" + id;
            int totalShares = 0; double totalPrice = 0;
            using (WebClient wc = new WebClient())
            {
                WriteOutput("Checking order fill for "+id+" at " + url, true);
                string xmlData = Encoding.ASCII.GetString(wc.DownloadData(url));
                if (null != xmlData && "" != xmlData)
                {
                    StringReader reader = new StringReader(xmlData);
                    XmlTextReader xml = new XmlTextReader(reader);
                    string field = "";
                    bool fill = false;

                    double tempPrice = 0;
                    int tempShares = 0;
                    while (xml.Read())
                    {
                        switch (xml.NodeType)
                        {
                            case XmlNodeType.Element:
                                field = xml.Name;
                                if (xml.Name == "fills")
                                {
                                    tempShares = 0;
                                    tempPrice = 0;
                                    fill = true;
                                }
                                    
                                break;
                            case XmlNodeType.EndElement:
                                field = "";
                                if (xml.Name == "fills")
                                {
                                    fill = false;
                                    totalPrice = (totalPrice * totalShares + tempPrice * tempShares) / (totalShares + tempShares);
                                    totalShares += tempShares;
                                    WriteOutput("Fill total: " + totalShares + " @$" + totalPrice, true);
                                }
                                break;
                            case XmlNodeType.Text:
                                //WriteOutput(field + ": " + xml.Value, true);
                                if (fill)
                                {
                                    if (field == "fill-quantity")
                                    {
                                        tempShares = Convert.ToInt32(Convert.ToDouble(xml.Value));
                                    }
                                    else if (field == "fill-price")
                                    {
                                        tempPrice = Convert.ToDouble(xml.Value);
                                    }
                                }
                                break;
                        }
                    }
                }
            }
            return new Tuple<int, double>(totalShares, totalPrice);
        }

        private byte[] reverseEndian(byte[] input, int pos, int length=4)
        {
            byte[] newBytes = new byte[length];
            for (int i = pos; i < input.Length && i < pos + length; i++)
                newBytes[pos + length - i - 1] = input[i];
            return newBytes;
        }


        private string Encode_URL(string cUrlString)
        {

            StringBuilder encodedString = new StringBuilder();
            char[] encBytes = cUrlString.ToCharArray();

            foreach (char cb in encBytes)
            {
                switch ((byte)cb)
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

        public class TDPosition {
            public string ticker;
            public int qty;
            public double averagePrice;
        }

        internal static void setLogin(string p, string p_2, string p_3, bool p_4, bool p_5, int p_6, int p_7, bool p_8, double p_9, decimal p_10, double p_11)
        {
            throw new NotImplementedException();
        }

        public class CustomWebClient : WebClient
        {
            protected override WebRequest GetWebRequest(Uri uri)
            {
                WebRequest w = base.GetWebRequest(uri);
                int timeout = 10 * 1000;
                w.Timeout = timeout;
                ((HttpWebRequest)w).ReadWriteTimeout = timeout;
                return w;
            }
        }
    }       
}
