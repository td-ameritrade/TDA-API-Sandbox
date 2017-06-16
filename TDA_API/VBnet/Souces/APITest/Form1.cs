using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using TDAmeritradeNet;

namespace APITest
{
    public partial class Form1 : Form
    {        
        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            TDANET.LogOut();
        }

        public Form1()
        {
            InitializeComponent();
            AppLog.OnAppLogAdded += OnAppLogAdded;
            TDANET.OnAccountActivityReceived += OnAccountActivityReceived;
            TDANET.OnLoginStatusChanged += OnLoginStatusChanged;
            TDANET.OnL1QuoteStreamingReceived += OnL1QuoteStreamingReceived;
            TDANET.OnStreamingBarReceived += OnStreamingBarReceived;
            TDANET.OnStreamingNewsReceived += OnStreamingNewsReceived;
            TDANET.OnTimeSalesReceived += OnTimeSalesReceived;
        }

        private void OnTimeSalesReceived(object sender, EventArgs eventArgs)
        {
            var ts = sender as TimeSales;
            txtTimeSales.Text += string.Format("{0,10}{1,25:yyyy/MM/dd HH:mm:ss}{2,10:N0}\r\n", ts.Symbol, ts.TimeStamp, ts.Volume);
        }

        private async void OnAccountActivityReceived(object sender, EventArgs eventArgs)
        {
            var accountActivity = sender as AccountActivity;
            txtMsgBox.Text += string.Format("\r\n>>>>>>>>>>>>>> Account Activity <<<<<<<<<<<<<<<<\r\n Data: {0}\r\n", accountActivity.MessageData);
            txtMsgBox.SelectionStart = txtMsgBox.Text.Length;
            txtMsgBox.ScrollToCaret();


            // refresh order status
            await refreshOrderStatus();
        }

        private void OnLoginStatusChanged(object sender, EventArgs eventArgs)
        {
            bool isLoggedIn = (bool) sender;
            if (isLoggedIn)
            {
                button1.ForeColor = Color.OrangeRed;
                button1.Text = "Log Out";
                tabControl1.Enabled = true;
            }
            else
            {
                button1.ForeColor = Color.Blue;
                button1.Text = "Log In";
                tabControl1.Enabled = false;
            }
        }

        private void OnStreamingNewsReceived(object sender, EventArgs eventArgs)
        {
            StreamingNews news = (StreamingNews) sender;
            textBox6.Text += string.Format("[{0}]   [{1}]   {2}\r\n", news.Symbol, news.NewsTimeStamp, news.Headline);

        }

        private void OnStreamingBarReceived(object sender, EventArgs eventArgs)
        {
            var bar = (StreamingChartBar) sender;
            textBox3.Text += string.Format("{0,10}{1,10}{2,10}{3,10}{4,10}{5,20:N0}{6,25:hh:mm:ss}\r\n", bar.Symbol, bar.Open, bar.High, bar.Low, bar.Close, bar.Volume, bar.TimeStamp);
        }

        private void OnAppLogAdded(object sender, AppLog appLog)
        {
            if (InvokeRequired)
            {
                BeginInvoke(new MethodInvoker(delegate
                    {
                        txtMsgBox.Text += appLog.Message + Environment.NewLine;
                        txtMsgBox.SelectionStart = txtMsgBox.Text.Length;
                        txtMsgBox.ScrollToCaret();
                    }));
            }
            else
            {
                txtMsgBox.Text += appLog.Message + Environment.NewLine;
                txtMsgBox.SelectionStart = txtMsgBox.Text.Length;
                txtMsgBox.ScrollToCaret();
            }
        }


        #region Log in/out

        private async void button1_Click(object sender, EventArgs e)
        {
            if (TDANET.IsLoggedIn == false)
            {
                TDANET.AppSource = txtAppSource.Text;
                var result = await TDANET.LogIn(txtUsername.Text, txtPassword.Text);
            }
            else
            {
                TDANET.LogOut();
            }
        }

        #endregion

        #region L1 Streaming Quote

        private void OnL1QuoteStreamingReceived(object sender, EventArgs eventArgs)
        {
            L1QuoteStreaming l1quote = (L1QuoteStreaming) sender;
            textBox5.Text += string.Format("Symbol: {0}\tLast: {1}\tChange(%): {2:+0.00%;-0.00%;0.00%}\t Volume: {3}\t TimeStamp: {4:H:mm:ss M/dd/yyyy}\r\n", l1quote.Symbol, l1quote.Last, l1quote.ChangePercent, l1quote.Volume, l1quote.TradeTime);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            // subscribe l1quote streaming here
            List<string> symbols = txtSymbols.Text.Split(new char[] {',', ' ', ';', '+'}).ToList();
            TDANET.Subscribe(symbols, StreamingServiceType.L1QuoteStreaming);
        }

        private void button3_Click(object sender, EventArgs e)
        {
            List<string> symbols = txtSymbols.Text.Split(new char[] {',', ' ', ';', '+'}).ToList();
            TDANET.Unsubscribe(symbols, StreamingServiceType.L1QuoteStreaming);
        }

        #endregion

        #region L1Quote Snapshot Quotes

        private async void button5_Click(object sender, EventArgs e)
        {
            List<string> symbols = textBox4.Text.Split(new char[] {',', ' ', ';', '+'}).ToList();
            var result = await TDANET.GetSnapshotAsync(symbols, RequestSourceType.Manual);
            var sb = new StringBuilder();
            foreach (var l1quote in result.Results)
            {
                sb.Append(string.Format("Symbol: {0}\tLast: {1}\tChange(%): {2:+0.00%;-0.00%;0.00%}\t Volume: {3:N0}\t LastTrade: {4,25:yyyy/MM/dd HH:mm:ss}\r\n", l1quote.Symbol, l1quote.Last, l1quote.ChangePercent, l1quote.Volume, l1quote.LastTradeDate));
            }
            textBox1.Text = sb.ToString();
        }

        #endregion

        #region Price History

        private async void button4_Click(object sender, EventArgs e)
        {
            textBox2.Text = string.Empty;
            StringBuilder sb = new StringBuilder();
            List<string> symbols = txtSymbols2.Text.Split(new char[] {',', ' ', ';', '+'}).ToList();
            List<PriceHistory> result = await TDANET.GetPriceHistoryAsync(symbols, DateTime.Today.AddDays(-5), DateTime.Today, false, false);
            foreach (PriceHistory history in result)
            {
                sb.AppendLine("\r\n===============================================");
                sb.AppendLine(history.Symbol);
                sb.AppendLine("-----------------------------------------------");
                int i = history.Count;
                for (int j = 0; j < i; j++)
                {
                    sb.AppendLine(string.Format("{0:M/dd/yyyy  H:mm:ss}   {1:0.00##}   {2:0.00##}   {3:0.00##}   {4:0.00##}   {5:N0}", DateTime.FromOADate(history.TimeStamps[j]), history.Opens[j], history.Highs[j], history.Lows[j], history.Closes[j], history.Volumes[j]));
                }
            }

            textBox2.Text = sb.ToString();
        }

        private async void button6_Click(object sender, EventArgs e)
        {
            textBox2.Text = string.Empty;
            StringBuilder sb = new StringBuilder();
            List<string> symbols = txtSymbols2.Text.Split(new char[] {',', ' ', ';', '+'}).ToList();
            List<PriceHistory> result = await TDANET.GetPriceHistoryAsync(symbols, DateTime.Today.AddYears(-1), DateTime.Today, true, false);
            foreach (PriceHistory history in result)
            {
                sb.AppendLine("\r\n===============================================");
                sb.AppendLine(history.Symbol);
                sb.AppendLine("-----------------------------------------------");
                int i = history.Count;
                for (int j = 0; j < i; j++)
                {
                    sb.AppendLine(string.Format("{0:M/dd/yyyy  H:mm:ss}   {1:0.00##}   {2:0.00##}   {3:0.00##}   {4:0.00##}   {5:N0}", DateTime.FromOADate(history.TimeStamps[j]), history.Opens[j], history.Highs[j], history.Lows[j], history.Closes[j], history.Volumes[j]));
                }
            }

            textBox2.Text = sb.ToString();
        }

        #endregion

        #region Streaming Chart Bar

        private async void button7_Click(object sender, EventArgs e)
        {
            List<string> symbols = txtSymbols3.Text.Split(new char[] {',', ' ', ';', '+'}).ToList();
            TDANET.Subscribe(symbols, StreamingServiceType.NASDAQ_Chart);
        }

        #endregion

        private void button8_Click(object sender, EventArgs e)
        {
            if (TDANET.client.AssociatedAccount.AccountAuthorizations.StreamingNews)
            {
                List<string> symbols = textBox7.Text.Split(new char[] { ',', ' ', ';', '+' }).ToList();
                TDANET.Subscribe(symbols, StreamingServiceType.News);
            }
            else
            {
                textBox6.Text = "You don't have streaming news subscription";
            }
            
        }

        private async void button9_Click(object sender, EventArgs e)
        {
            if (TDANET.client.AssociatedAccount.AccountAuthorizations.StreamingNews)
            {
                StringBuilder sb = new StringBuilder();
                List<string> symbols = textBox7.Text.Split(new char[] { ',', ' ', ';', '+' }).ToList();
                foreach (var symbol in symbols)
                {
                    List<StreamingNews> newsCollection = await TDANET.GetNewsHistory(symbol, 7);
                    foreach (StreamingNews news in newsCollection)
                    {
                        sb.AppendLine(string.Format("[{0}]   [{1}]   {2}", news.Symbol, news.NewsTimeStamp, news.Headline));
                    }
                }

                textBox6.Text = sb.ToString();
            }
            else
            {
                textBox6.Text = "You don't have streaming news subscription";
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private async void button10_Click(object sender, EventArgs e)
        {
            var orderHistories = await TDANET.GetOrderHistoryAsync(1);
            var sb = new StringBuilder();
            foreach (var oh in orderHistories)
            {
                if (!string.IsNullOrEmpty(oh.OrderNumber))
                {
                    sb.AppendFormat("[{0,15:yyyy/MM/dd HH:mm tt}] {1,10} {2,15} {3,15:N0} {4,15} {5,15}\r\n", oh.OrderDateTime, oh.Symbol, oh.Price, oh.Quantity, oh.OrderNumber, oh.BuySellCode);
                }
            }
            txtOrderHistory.Text = sb.ToString();
        }

        private async void button11_Click(object sender, EventArgs e)
        {
            Balances balance = await TDANET.GetBalancesAsync();
            var sb = new StringBuilder();
            var results = balance.GetProperties();
            foreach (var result in results)
            {
                sb.AppendFormat("{0,30}{1,20}\r\n", result.Key, result.Value);
            }
            txtBalance.Text = sb.ToString();
        }

        private async void button12_Click(object sender, EventArgs e)
        {
            var positions = await TDANET.GetPositionsAsync();
            var sb = new StringBuilder();
            foreach (var stock in positions.Stocks)
            {
                if (!string.IsNullOrEmpty(stock.Symbol))
                {
                    sb.AppendFormat("{0,10}{1,15}{2,15}{3,15}\r\n", stock.Symbol, stock.Quantity, stock.AveragePrice, stock.PositionType);
                }
            }
            txtPositions.Text = sb.ToString();
        }

        private void button13_Click(object sender, EventArgs e)
        {
            List<string> symbols = textBox9.Text.Split(new char[] { ',', ' ', ';', '+' }).ToList();
            TDANET.Subscribe(symbols, StreamingServiceType.TimeSales);
        }

        private async void button14_Click(object sender, EventArgs e)
        {
            await refreshOrderStatus();
        }

        private async Task refreshOrderStatus()
        {
            int days = !string.IsNullOrEmpty(txtLastDays.Text) ? Convert.ToInt32(txtLastDays.Text) : 5;
            var statuses = await TDANET.GetOrderStatusAsync(days, "all");
            var sb = new StringBuilder();
            foreach (var status in statuses)
            {
                if (!string.IsNullOrEmpty(status.Symbol))
                {
                    sb.AppendFormat("[{0,25:yyyy/MM/dd HH:mm:ss}]{1,10}{2,15}{3,15}{4,10}\tOrder#: {5,10}\r\n", status.OrderReceivedDateTime, status.Symbol, status.Quantity, status.DisplayStatus, status.OrderType, status.OrderNumber);
                }
            }
            txtOrderStatus.Text = sb.ToString();
        }

        private async void button15_Click(object sender, EventArgs e)
        {
            var result = await TDANET.CancelOrder(txtOrderNumber.Text);
            MessageBox.Show(result.OrderId + ": " + result.Message);
        }
        
    }
}
