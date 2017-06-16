/*
	 The AmeritradeBrokerAPI Class Library
 	    
    Copyright (c) 2008 by Cedric L. Harris and ATrade Investment Technologies, LLC All rights reserved.
    Contact Info. CHarris@Gr8Alerts.COM
                  http://WWW.FindMyNextTrade.COM
 
    
    The AmeritradeBrokerAPI Class Library is a C# implementation of interface specification defined by
    TD Amertirade Securities, INC
 
 
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions
	are met:
	1. Redistributions of source code must retain the above copyright
	notice, this list of conditions and the following disclaimer.
	2. Redistributions in binary form must reproduce the above copyright
	notice, this list of conditions and the following disclaimer in the
	documentation and/or other materials provided with the distribution.

	THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
	OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
	HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
	OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
	SUCH DAMAGE.
*/




using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Collections;

using ZedGraph;



namespace AMTD_Test_API
{
    public partial class Form1 : Form
    {

        //public enum ChartUpdateType
        //{
        //    INITIALIZE                  = 1,
        //    CHARTSTREAM_UPDATE          = 2,
        //    LEVELONESTREAM_UPDATE       = 3
        //}

        public AmeritradeBrokerAPI  oBroker                      = new AmeritradeBrokerAPI();        
        private IComparer           iSorting                     = new AmeritradeBrokerAPI.ListItemSorter(-1);
        private string              DataRequestSymbol            = string.Empty;
        private List<string>        oTempChartDisplayCol         = new List<string>();
        private List<string>        oChartDisplayCol             = new List<string>();
        private List<List<string>>  oChartDisplayCol2            = new List<List<string>>();
        private List<string>        oChartDataList               = new List<string>();
        private List<List<string>>  oChartDataList2              = new List<List<string>>();
        private Object              oLock                        = new object();
       

        public Form1()
        {
            InitializeComponent();
           
            this.StatuscomboBox.SelectedIndex           = 0;
            this.listView2.ListViewItemSorter           = this.iSorting;
            ((AmeritradeBrokerAPI.ListItemSorter)iSorting).setSortcol(7);
            ((AmeritradeBrokerAPI.ListItemSorter)iSorting).setSortDirection("ASC");
            this.listView2.Sort();

            this.TradeTypecomboBox.SelectedIndex        = 0;
            this.OrderTypecomboBox.SelectedIndex        = 0;
            this.OrderRoutingcomboBox.SelectedIndex     = 0;
            this.TimeInForcecomboBox.SelectedIndex      = 0;
                     
        }



        public void processEvent(DateTime time, AmeritradeBrokerAPI.ATradeArgument args)
        {

            // Create a local event to update and pass arguments to inorder to avoid crossing thread boundaries.           

            try
            {

                AmeritradeBrokerAPI.EventHandlerWithArgs oDisplayEvent = new AmeritradeBrokerAPI.EventHandlerWithArgs(this.DisplayEvent);
                this.Invoke(oDisplayEvent, new object[] { time, args });

            }
            catch (Exception exc){ }

        }

        
        private void DisplayEvent(DateTime time, AmeritradeBrokerAPI.ATradeArgument args)
        {

            // Update the user interface. //

            List<List<string>> oChartStream;
            ListViewItem oStreamData;


            switch(args.FunctionType)
            {
                


                case AmeritradeBrokerAPI.RequestState.AsyncType.None :

                    oStreamData = new ListViewItem(args.DisplayMssg);
                    this.StreamingChartDatalistView.Items.Add(oStreamData);                    

                    break;


                case AmeritradeBrokerAPI.RequestState.AsyncType.LevelTwoStreaming :
                   
                    Color[] nColors = new Color[10];
                    nColors[0] = Color.Green;
                    nColors[1] = Color.GreenYellow;
                    nColors[2] = Color.Blue;
                    nColors[3] = Color.Olive;
                    nColors[4] = Color.Red;
                    nColors[5] = Color.Orange;
                    nColors[6] = Color.Yellow;
                    nColors[7] = Color.LightSteelBlue;
                    nColors[8] = Color.Gray;
                    nColors[9] = Color.WhiteSmoke;


                    ListViewItem oItems;

                    int nColorNDX           = 0;
                    decimal nLastPrice      = 0.00M;
                    decimal nCurrentPrice   = 0.00M;
                    string cCharString = "abcdefghijklmnopqrstuvwxyz";
                    bool lSkipEntry = false;


                    if (args.oLevel2BidData.Count > 0)
                    {
                        this.BidListView.Items.Clear();

                        this.BuyOrdersDisplayButton.Text = "Buy Orders (BID) " + args.oLevel2BidData.Count.ToString();

                        foreach (string cs in args.oLevel2BidData)
                        {

                            lSkipEntry = false;

                            string[] cLineData = cs.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

                            for (int chrNDX = 0; chrNDX < cLineData[1].Length; chrNDX++)
                            {
                                if (cCharString.Contains(cLineData[1].ToLower().Substring(chrNDX, 1)) == true)
                                {
                                    lSkipEntry = true;
                                    break;
                                }

                            }

                            if (lSkipEntry == false)
                            {

                                nCurrentPrice = decimal.Round(decimal.Parse(cLineData[1], System.Globalization.NumberStyles.AllowDecimalPoint), 2);

                                if (nLastPrice > 0)
                                {
                                    if (nLastPrice != nCurrentPrice)
                                    {
                                        if (nColorNDX < 9)
                                        {
                                            nColorNDX = nColorNDX + 1;
                                        }
                                    }
                                }



                                oItems = new ListViewItem(cLineData[0]);
                                oItems.SubItems.Add(Convert.ToString(Convert.ToInt32(cLineData[2]) * 1));
                                oItems.SubItems.Add(cLineData[1]);


                                oItems.BackColor = nColors[nColorNDX];

                                this.BidListView.Items.Add(oItems);

                                nLastPrice = nCurrentPrice;

                            }
                        }
                    }



                    nColorNDX       = 0;
                    nLastPrice      = 0.00M;
                    nCurrentPrice   = 0.00M;


                    if (args.oLevel2AskData.Count > 0)
                    {
                        this.AskListView.Items.Clear();
                        
                        this.SellOrdersDisplayButton.Text = "Sell Orders (ASK) " + args.oLevel2AskData.Count.ToString();

                        foreach (string cs in args.oLevel2AskData)
                        {


                            lSkipEntry = false;

                            string[] cLineData = cs.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);


                            for (int chrNDX = 0; chrNDX < cLineData[1].Length; chrNDX++)
                            {
                                if (cCharString.Contains(cLineData[1].ToLower().Substring(chrNDX, 1)) == true)
                                {
                                    lSkipEntry = true;
                                    break;
                                }

                            }


                            if (lSkipEntry == false)
                            {

                                nCurrentPrice = decimal.Round(decimal.Parse(cLineData[1], System.Globalization.NumberStyles.AllowDecimalPoint), 2);

                                if (nLastPrice > 0)
                                {
                                    if (nLastPrice != nCurrentPrice)
                                    {
                                        if (nColorNDX < 9)
                                        {
                                            nColorNDX = nColorNDX + 1;
                                        }
                                    }
                                }

                                oItems = new ListViewItem(cLineData[0]);
                                oItems.SubItems.Add(Convert.ToString(Convert.ToInt32(cLineData[2]) * 1));
                                oItems.SubItems.Add(cLineData[1]);


                                oItems.BackColor = nColors[nColorNDX];
                                this.AskListView.Items.Add(oItems);

                                oItems.BackColor = nColors[nColorNDX];

                                nLastPrice = nCurrentPrice;

                            }
                        }
                    }
                                       

                    break;


                case AmeritradeBrokerAPI.RequestState.AsyncType.ChartSnapshot :


                    /*/
                     * Display the chart snapshot data.
                    /*/

                    this.DisplayAsyncChartDataRecords_Snapshot(args.oHistoricalData, AmeritradeBrokerAPI.ChartUpdateType.INITIALIZE, true);


                    /*/
                     * Make a request for streaming chart data.
                    /*/

                                                         
                    this.Request_AsyncChartHistoryData_Streaming(args.stocksymbol.ToUpper(), args.ServiceName);

                    this.Request_AsyncLevel2DataStreaming(args.stocksymbol.ToUpper(), (AmeritradeBrokerAPI.Level2DataSource)this.oBroker.MarketCol.IndexOf(args.ServiceName.Substring(0, args.ServiceName.IndexOf("_"))));
                                                                                                  
                    break;



                case AmeritradeBrokerAPI.RequestState.AsyncType.ChartStreaming:


                    /*/
                     * Display the streaming chart data response.
                    /*/

                    this.oChartDataList.Clear();

                    oStreamData = new ListViewItem(args.DisplayMssg);
                    this.StreamingChartDatalistView.Items.Add(oStreamData);
                    

                    this.oChartDataList.Add(args.DisplayMssg.ToString());

                    oChartStream = new List<List<string>>();

                    oChartStream.Add(this.oChartDataList);


                    /*/
                     * Display the chart snapshot data with upated Level I data that reflects the last executed
                    /*/

                    this.DisplayAsyncChartDataRecords_Snapshot(oChartStream, AmeritradeBrokerAPI.ChartUpdateType.CHARTSTREAM_UPDATE, false);

                   
                    break;


                case AmeritradeBrokerAPI.RequestState.AsyncType.LevelOneSnapshot :

                    string ServiceName  = args.oLevelOneData[0].exchange;
                    string stock        = args.oLevelOneData[0].stock;

                    /*/
                     * Display the Level One snapshot data requested.
                    /*/

                    this.DisplayAsync_Level1DataSnapshot(args);


                    /*/
                     * Enable the timer used to make the request for streaming Level One data.                     
                    /*/

                    this.DataRequestSymbol          = stock;


                    this.Request_AsyncLevel1DataStreaming(stock, ServiceName);

                   

                    /*/
                     * If we have made either a NYSE, NADAQ or INDEX Level One request,
                     * then, make a chart request.
                    /*/

                    string OriginalSerivceName = ServiceName;

                    ServiceName = oBroker.GetChartServiceString(ServiceName);

                    
                    if (ServiceName.Length > 0 && ServiceName.IndexOf("NYSE") == 0 || ServiceName.IndexOf("NASDAQ") == 0 || ServiceName.IndexOf("INDEX") == 0)
                    {
                        
                        this.LevelIIQuoteServerStatustextBox.Text = "Chart available.";
                        this.Request_HistoricalData_Snapshot(stock, ServiceName + "_CHART");
                                                                       
                    }
                    else
                    {
                        this.LevelIIQuoteServerStatustextBox.Text = "Chart Not available.";
                        this.RecordsCNTtextBox.Text = "0";
                        this.Level2listView.Clear();

                        GraphPane myPane = this.chartGraph.GraphPane;
                        myPane.CurveList.Clear();

                        myPane.Title.Text = "  " + this.StockSymboltextBox.Text;

                        this.chartGraph.AxisChange();
                        this.chartGraph.Invalidate();


                    }

                    break;


                case AmeritradeBrokerAPI.RequestState.AsyncType.LevelOneStreaming :

                    /*/
                     * Display the Level One streaming data requested.
                    /*/

                    this.oChartDataList.Clear();


                    this.DisplayAsync_Level1DataSnapshot(args);

                    if (this.oChartDataList2.Count > 0)
                    {

                        int nlastPosition = this.oChartDataList2[this.oChartDataList2.Count - 1].Count;

                        string[] cLineData = this.oChartDataList2[this.oChartDataList2.Count - 1][nlastPosition - 1].Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        
                        string _stock       = cLineData[0];
                        string _interval    = cLineData[1];
                        double nOpen        = Convert.ToDouble (cLineData[2]);
                        double nHigh        = Convert.ToDouble (cLineData[3]);
                        double nLow         = Convert.ToDouble (cLineData[4]);
                        double nClose       = Convert.ToDouble (cLineData[5]);
                        double nVol         = Convert.ToDouble(cLineData[6]);
                        string _time        = cLineData[7];
                        string _date        = cLineData[8];

                        if (args.oLevelOneData[0].last != null)
                        {
                             bool lUpdateLastBar = false;


                             if (Convert.ToDouble(args.oLevelOneData[0].last) > Math.Round(nHigh, 3))
                            {
                                lUpdateLastBar = true;
                                nHigh = Convert.ToDouble(args.oLevelOneData[0].last);
                            }

                            if (Convert.ToDouble(args.oLevelOneData[0].last) < Math.Round(nLow, 3))
                            {
                                lUpdateLastBar = true;
                                nLow = Convert.ToDouble(args.oLevelOneData[0].last);
                            }


                            if (lUpdateLastBar == true)
                            {
                                StringBuilder cUpdatedBar = new StringBuilder();
                                cUpdatedBar.Append(_stock.ToString());
                                cUpdatedBar.Append(",");
                                cUpdatedBar.Append(_interval.ToString());
                                cUpdatedBar.Append(",");
                                cUpdatedBar.Append(nOpen.ToString());
                                cUpdatedBar.Append(",");
                                cUpdatedBar.Append(nHigh.ToString());
                                cUpdatedBar.Append(",");
                                cUpdatedBar.Append(nLow.ToString());
                                cUpdatedBar.Append(",");
                                cUpdatedBar.Append(nClose.ToString());
                                cUpdatedBar.Append(",");
                                cUpdatedBar.Append(nVol.ToString());
                                cUpdatedBar.Append(",");
                                cUpdatedBar.Append(_time.ToString());
                                cUpdatedBar.Append(",");
                                cUpdatedBar.Append(_date.ToString());


                                this.oChartDataList2[this.oChartDataList2.Count - 1].RemoveAt(nlastPosition - 1);                                
                                this.oChartDataList2[this.oChartDataList2.Count - 1].Add(cUpdatedBar.ToString());
                                this.oChartDataList.Add(cUpdatedBar.ToString());

                                /*/
                                 * Display the chart snapshot data with upated Level I data that reflects the last executed
                                /*/

                                oChartStream = new List<List<string>>();

                                oChartStream.Add(this.oChartDataList);


                                /*/
                                 * Display the chart snapshot data with upated Level I data that reflects the last executed
                                /*/


                                this.DisplayAsyncChartDataRecords_Snapshot(oChartStream, AmeritradeBrokerAPI.ChartUpdateType.LEVELONESTREAM_UPDATE, false);


                            }
                        }                        
                    }

                   
                    break;



            }

        }




        private void button1_Click(object sender, EventArgs e)
        {
            /*/
             * Safely close any open connections and logout, if alreadly logged in.
            /*/
            //this.Close_Connections(false);

            string SourceID         = string.Empty;
            string BrokerUserName   = string.Empty;
            string BrokerPassword   = string.Empty;
            string EquitySymbol     = string.Empty;

            SourceID = this.SourceIDtextBox.Text.ToUpper();
            BrokerUserName = this.UserNametextBox.Text;
            BrokerPassword = this.PasswordtextBox.Text;
            EquitySymbol = this.StockSymboltextBox.Text.ToUpper();
            this.EncryptcheckBox.Checked = false;

            if (SourceID.Length > 0)
            {
                if (BrokerUserName.Length > 0 && BrokerPassword.Length > 0)
                {
                    if (oBroker.TD_loginStatus == false)
                    {
                        this.EncryptcheckBox.Checked = true;

                        bool bRet = oBroker.TD_brokerLogin(BrokerUserName, BrokerPassword, SourceID, "1");
                        oBroker.TD_GetStreamerInfo(BrokerUserName, BrokerPassword, SourceID, "1");
                        oBroker.TD_KeepAlive(BrokerUserName, BrokerPassword, SourceID, "1");

                        if (oBroker.TD_loginStatus == true)
                        {
                            this.Loginbutton.Enabled            = false;
                            this.GetDatabutton.Enabled          = true;
                            this.buttonLogoutButton.Enabled     = true;
                            

                            this.groupBox2.Enabled              = true;
                            this.groupBox5.Enabled              = true;
                            this.groupBox6.Enabled              = true;
                            this.tabControl2.Enabled            = true;

                            this.BuyOrdersDisplayButton.Text    = "Buy Orders (BID)";
                            this.SellOrdersDisplayButton.Text   = "Sell Orders (ASK)";

                        }
                    }
                    else
                    {
                        this.BuyOrdersDisplayButton.Text = "Buy Orders (BID)";
                        this.SellOrdersDisplayButton.Text = "Sell Orders (ASK)";
                    }

                    if (EquitySymbol.Length > 0)
                    {
                        if (oBroker.TD_loginStatus == true)
                        {
                            this.EncryptcheckBox.Checked = true;
                            this.BidListView.Items.Clear();
                            this.AskListView.Items.Clear();
                            this.Display_AccountInfo(SourceID, BrokerUserName, BrokerPassword);
                            this.Display_TradeHistory(SourceID, BrokerUserName, BrokerPassword, string.Empty);
                            this.GetStockData();
                           
                        }
                        else
                        {
                            this.EncryptcheckBox.Checked = false;
                            oBroker = new AmeritradeBrokerAPI();
                            MessageBox.Show("Login Not Successful...Please check your account information and try again.", "Ameritrade API", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        }
                    }
                }
                else
                {
                    this.EncryptcheckBox.Checked = false;
                    MessageBox.Show("Please enter your broker username and password, then try again.", "ATrade - Ameritrade Demo", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                }

            }
            else
            {
                this.EncryptcheckBox.Checked = false;
                MessageBox.Show("Please enter your broker provided Source ID, then try again.", "ATrade - Ameritrade Demo", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }

        }

                                    

        private void button2_Click(object sender, EventArgs e)
        {
            this.Close_Connections(true);
            this.Loginbutton.Enabled        = true;
            this.GetDatabutton.Enabled      = false;
            this.buttonLogoutButton.Enabled = false;
            

            this.StreamingChartDatalistView.Items.Clear();

        }



        private void Close_Connections(bool lRecreateBrokerConnection)
        {
            try
            {
                if (oBroker != null)
                {
                    if (this.oBroker.TD_loginStatus == true)
                    {


                        /*/
                         * Close the Level Two Streaming Response Stream
                        /*/

                        if (oBroker.rs_LevelTwoStreaming != null)
                        {
                            if (oBroker.rs_LevelTwoStreaming.Request != null)
                            {
                                if (oBroker.rs_LevelTwoStreaming.Request.ServicePoint.CurrentConnections > 0)
                                {                                    
                                    oBroker.rs_LevelTwoStreaming.CloseStream(oBroker.rs_LevelTwoStreaming);
                                }
                            }
                        }


                        /*/
                         * Close the Level One Snapshot Response Stream
                        /*/

                        if (oBroker.rs_LevelOneSnapshot != null)
                        {
                            if (oBroker.rs_LevelOneSnapshot.Request != null)
                            {
                                if (oBroker.rs_LevelOneSnapshot.Request.ServicePoint.CurrentConnections > 0)
                                {
                                    oBroker.rs_LevelOneSnapshot.CloseStream(oBroker.rs_LevelOneSnapshot);                                    
                                }
                            }
                        }


                        /*/
                         * Close the Level One Streaming Response Stream
                        /*/

                        if (oBroker.rs_LevelOneStreaming != null)
                        {
                            if (oBroker.rs_LevelOneStreaming.Request != null)
                            {
                                if (oBroker.rs_LevelOneStreaming.Request.ServicePoint.CurrentConnections > 0)
                                {
                                    oBroker.rs_LevelOneStreaming.CloseStream(oBroker.rs_LevelOneStreaming);                                    
                                }
                            }
                        }



                        /*/
                         * Close the Historical Chart Snapshot Response Stream
                        /*/

                        if (oBroker.rs_ChartSnapShot != null)
                        {
                            if (oBroker.rs_ChartSnapShot.Request != null)
                            {
                                if (oBroker.rs_ChartSnapShot.Request.ServicePoint.CurrentConnections > 0)
                                {
                                    oBroker.rs_ChartSnapShot.CloseStream(oBroker.rs_ChartSnapShot);                                   
                                }
                            }
                        }


                        /*/
                         * Close the Historical Chart Streaming Response Stream
                        /*/

                        if (oBroker.rs_ChartStreaming != null)
                        {
                            if (oBroker.rs_ChartStreaming.Request != null)
                            {
                                if (oBroker.rs_ChartStreaming.Request.ServicePoint.CurrentConnections > 0)
                                {
                                    oBroker.rs_ChartStreaming.CloseStream(oBroker.rs_ChartStreaming);                                    
                                }
                            }
                        }

                        
                        if (lRecreateBrokerConnection == true)
                        {
                            oBroker = new AmeritradeBrokerAPI();
                        }

                    }
                }
            }
            catch (Exception exc){}

        }



        private void Display_TradeHistory(string SourceID, string BrokerUserName, string BrokerPassword, string OrderID)
        {

            if (oBroker.TD_loginStatus == true)
            {

                AmeritradeBrokerAPI.ATradeArgument brokerTradeHistoryArgs = new AmeritradeBrokerAPI.ATradeArgument();

                brokerTradeHistoryArgs.oTradeHistory = new List<AmeritradeBrokerAPI.ATradeArgument.tradeReplyDetails>();


                if (this.StatuscomboBox.Text.CompareTo("All") < 0)
                {
                    // Get whether this order ID is in the Filled status
                    oBroker.TD_geOrderStatusAndHistory(BrokerUserName, BrokerPassword, SourceID, "1", OrderID, AmeritradeBrokerAPI.orderHistoryType.FILLED, ref brokerTradeHistoryArgs.oTradeHistory);


                    // Get whether this order ID is in the Open status
                    if (brokerTradeHistoryArgs.oTradeHistory.Count == 0)
                    {
                        oBroker.TD_geOrderStatusAndHistory(BrokerUserName, BrokerPassword, SourceID, "1", OrderID, AmeritradeBrokerAPI.orderHistoryType.OPEN_ORDERS, ref brokerTradeHistoryArgs.oTradeHistory);
                    }

                    // Get whether this order ID is in the Pending status
                    if (brokerTradeHistoryArgs.oTradeHistory.Count == 0)
                    {
                        oBroker.TD_geOrderStatusAndHistory(BrokerUserName, BrokerPassword, SourceID, "1", OrderID, AmeritradeBrokerAPI.orderHistoryType.PENDING_ORDERS, ref brokerTradeHistoryArgs.oTradeHistory);
                    }

                    if (brokerTradeHistoryArgs.oTradeHistory.Count == 0)
                    {
                        // Get whether this order ID is in the Cancelled status
                        oBroker.TD_geOrderStatusAndHistory(BrokerUserName, BrokerPassword, SourceID, "1", OrderID, AmeritradeBrokerAPI.orderHistoryType.CANCELLED_ORDERS, ref brokerTradeHistoryArgs.oTradeHistory);
                    }
                }
                else
                {
                    // Otherwise, get the statuses for all orders
                    oBroker.TD_geOrderStatusAndHistory(BrokerUserName, BrokerPassword, SourceID, "1", OrderID, AmeritradeBrokerAPI.orderHistoryType.ALL_ORDERS, ref brokerTradeHistoryArgs.oTradeHistory);

                }


                /*/
                 * Display the Trade History data in the listview baed on the sorting selected
                 * 
                /*/

                if (brokerTradeHistoryArgs.oTradeHistory.Count > 0)
                {

                    this.listView2.Items.Clear();

                    foreach (AmeritradeBrokerAPI.ATradeArgument.tradeReplyDetails oTradeHistory in brokerTradeHistoryArgs.oTradeHistory)
                    {

                        ListViewItem oTradeHistoryItems;

                        oTradeHistoryItems = new ListViewItem(oTradeHistory.OrderNumber.Trim());

                        oTradeHistoryItems.SubItems.Add(oTradeHistory.cStockSymbol.Trim());
                        oTradeHistoryItems.SubItems.Add(oTradeHistory.OrderShares.Trim());
                        oTradeHistoryItems.SubItems.Add(oTradeHistory.OrderPrice.Trim());
                        oTradeHistoryItems.SubItems.Add(oTradeHistory.DisplayStatus.Trim());
                        oTradeHistoryItems.SubItems.Add(oTradeHistory.OrderSharesRemianing.Trim().Substring(0, oTradeHistory.OrderSharesRemianing.Trim().IndexOf(".")));
                        oTradeHistoryItems.SubItems.Add(oTradeHistory.Action.Trim());

                        switch (oTradeHistory.DisplayStatus.Trim())
                        {
                            case "Open":
                                oTradeHistoryItems.SubItems.Add("0");
                                break;

                            case "Filled":
                                oTradeHistoryItems.SubItems.Add("1");
                                break;

                            case "Canceled":
                                oTradeHistoryItems.SubItems.Add("2");
                                break;

                            case "Pending Cancel":
                                oTradeHistoryItems.SubItems.Add("3");
                                break;

                            case "Expired":
                                oTradeHistoryItems.SubItems.Add("4");
                                break;

                            default:
                                oTradeHistoryItems.SubItems.Add("4");
                                break;
                        }


                        if (this.StatuscomboBox.SelectedItem.ToString().CompareTo("ALL") == 0 ||
                            this.StatuscomboBox.SelectedItem.ToString().CompareTo(oTradeHistory.DisplayStatus.Trim()) == 0)
                        {
                            this.listView2.Items.Add(oTradeHistoryItems);

                        }                                              
                    }

                    this.listView2.Sort();
                }
            }
        }


       
        private void Display_AccountInfo(string SourceID, string BrokerUserName, string BrokerPassword)
        {
            if (oBroker.TD_loginStatus == true)
            {

                AmeritradeBrokerAPI.ATradeArgument brokerAcctPosArgs = new AmeritradeBrokerAPI.ATradeArgument();
                brokerAcctPosArgs.oCashBalances = new List<AmeritradeBrokerAPI.CashBalances>();
                brokerAcctPosArgs.oPositions = new List<AmeritradeBrokerAPI.Positions>();

                oBroker.TD_getAcctBalancesAndPositions(BrokerUserName, BrokerPassword, SourceID, "1", ref brokerAcctPosArgs.oCashBalances, ref brokerAcctPosArgs.oPositions);

                decimal nPctChange;

                if (brokerAcctPosArgs.oCashBalances.Count > 0)
                {
                    this.CurrentCashBalancetextBox.Text = string.Format("{0:C2}", decimal.Parse(brokerAcctPosArgs.oCashBalances[0].CurrentCashBalance));
                    this.InitialCashBalancetextBox.Text = string.Format("{0:C2}", decimal.Parse(brokerAcctPosArgs.oCashBalances[0].InitialCashBalance));
                    this.DolChangeInCashBalancetextBox.Text = string.Format("{0:C2}", decimal.Parse(brokerAcctPosArgs.oCashBalances[0].ChangeInCashBalance));
                    if (decimal.Parse(brokerAcctPosArgs.oCashBalances[0].InitialCashBalance) != 0)
                    {
                        nPctChange = 100 * (decimal.Parse(brokerAcctPosArgs.oCashBalances[0].ChangeInCashBalance) / decimal.Parse(brokerAcctPosArgs.oCashBalances[0].InitialCashBalance));
                        this.PctChangeInCashBalancetextBox.Text = string.Format("{0:F2}%", nPctChange);
                    }
                    else
                        this.PctChangeInCashBalancetextBox.Text = string.Format("{0:F2}%", 0.00);


                    this.DolChangeInCashBalancetextBox.Font = new System.Drawing.Font("Arial", 10F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
                    if (decimal.Parse(brokerAcctPosArgs.oCashBalances[0].ChangeInCashBalance) < 0)
                    {
                        this.DolChangeInCashBalancetextBox.ForeColor = Color.Red;
                        this.PctChangeInCashBalancetextBox.ForeColor = Color.Red;
                    }
                    else
                    {
                        this.DolChangeInCashBalancetextBox.ForeColor = System.Drawing.Color.DarkGreen;
                        this.PctChangeInCashBalancetextBox.ForeColor = System.Drawing.Color.DarkGreen;
                    }


                    this.StockBuyingPowertextBox.Text = string.Format("{0:C2}", decimal.Parse(brokerAcctPosArgs.oCashBalances[0].StockBuyingPower));
                    this.DayTradingBuyingPowertextBox.Text = string.Format("{0:C2}", decimal.Parse(brokerAcctPosArgs.oCashBalances[0].DayTradingBuyingPower));
                    this.AvailableFundsForTradingtextBox.Text = string.Format("{0:C2}", decimal.Parse(brokerAcctPosArgs.oCashBalances[0].AvailableFundsForTrading));
                    this.DayTradingRoundTripstextBox.Text = brokerAcctPosArgs.oCashBalances[0].DayTradingRoundTrips;
                }


                if (brokerAcctPosArgs.oPositions.Count > 0)
                {

                    foreach (AmeritradeBrokerAPI.Positions oPosition in brokerAcctPosArgs.oPositions)
                    {

                        ListViewItem oPositionItems;

                        if (oPosition.StockSymbol.Length > 0)
                            oPositionItems = new ListViewItem(oPosition.StockSymbol);
                        else
                            oPositionItems = new ListViewItem((oPosition.AssetType.CompareTo("B") == 0 ? "BONDS" : "Unknown"));

                        oPositionItems.SubItems.Add(oPosition.Quantity.Trim());
                        oPositionItems.SubItems.Add(oPosition.CurrentValue.Trim());
                        oPositionItems.SubItems.Add(oPosition.PositionType.Trim());
                        oPositionItems.Tag = oPosition.StockSymbol.Trim();



                        if (this.listView1.Items.Count == 0)
                        {
                            this.listView1.Items.Add(oPositionItems);

                        }
                        else
                        {
                            bool lFoundRecord = false;

                            foreach (ListViewItem lvi in this.listView1.Items)
                            {

                                if (lvi.SubItems[0].Text.CompareTo(oPosition.StockSymbol) == 0)
                                {

                                    lFoundRecord = true;
                                    int PositionnDX = lvi.Index;
                                    bool lSelected = lvi.Selected;

                                    this.listView1.Items.Remove(lvi);
                                    this.listView1.Items.Insert(PositionnDX, oPositionItems);

                                    if (lSelected == true)
                                    {
                                        oPositionItems.Selected = true;
                                    }

                                }

                            }

                            if (lFoundRecord == false)
                            {
                                this.listView1.Items.Add(oPositionItems);
                            }
                        }
                    }
                }
            }
        }













        private void Request_AsyncLevel2DataStreaming(string EquitySymbol , AmeritradeBrokerAPI.Level2DataSource Level2Source)
        {
            if (oBroker.TD_loginStatus == true)
            {
                // Create the state object for the Snapshot chart. //
                oBroker.rs_LevelTwoStreaming = new AmeritradeBrokerAPI.RequestState();

                // Assign the callback method to invoke and update the user interface.
                oBroker.rs_LevelTwoStreaming.TickWithArgs += new AmeritradeBrokerAPI.EventHandlerWithArgs(processEvent);

                oBroker.TD_RequestAsyncLevel2Streaming(EquitySymbol, Level2Source , this);

            }
        }



        private void Request_AsyncLevel1DataSnapshot(string EquitySymbol)
        {
            if (oBroker.TD_loginStatus == true)
            {                                   
                // Create the state object for the Snapshot chart. //
                oBroker.rs_LevelOneSnapshot = new AmeritradeBrokerAPI.RequestState();

                // Assign the callback method to invoke and update the user interface.
                oBroker.rs_LevelOneSnapshot.TickWithArgs += new AmeritradeBrokerAPI.EventHandlerWithArgs(processEvent);

                oBroker.TD_RequestAsyncLevel1QuoteSnapshot(EquitySymbol , this);
                
            }
        }


        private void Request_AsyncLevel1DataStreaming(string EquitySymbol, string ServiceName)
        {
            if (oBroker.TD_loginStatus == true)
            {
                // Create the state object for the Snapshot chart. //
                oBroker.rs_LevelOneStreaming = new AmeritradeBrokerAPI.RequestState();

                // Assign the callback method to invoke and update the user interface.
                oBroker.rs_LevelOneStreaming.TickWithArgs += new AmeritradeBrokerAPI.EventHandlerWithArgs(processEvent);

                oBroker.TD_RequestAsyncLevel1QuoteStreaming(EquitySymbol, ServiceName, this);

            }
        }



        private void DisplayAsync_Level1DataSnapshot(AmeritradeBrokerAPI.ATradeArgument args)
        {

            List<AmeritradeBrokerAPI.L1quotes> oL1Quote = new List<AmeritradeBrokerAPI.L1quotes>();
            oL1Quote = args.oLevelOneData;            

            if (oL1Quote[0].stock != null)
            {
                if (oL1Quote[0].stock.Length > 0)
                {

                    if (oL1Quote[0].shortable != null)
                    {
                        this.ShortabletextBox.Text = (oL1Quote[0].shortable.CompareTo("True") == 0 ? "Shortable" : "Not Shortable");
                    }


                    if (oL1Quote[0].description != null)
                    {
                        this.CompanyNametextBox.Text = oL1Quote[0].description;
                    }

                    if (oL1Quote[0].last != null)
                    {
                        this.LastExecutedPricetextBox.Text      = Convert.ToString(Decimal.Round(Convert.ToDecimal(oL1Quote[0].last), 2));
                        this.LastExecutedChartPricetextBox.Text = Convert.ToString(Decimal.Round(Convert.ToDecimal(oL1Quote[0].last), 2));

                    }

                    if (oL1Quote[0].exchange != null)
                    {
                        this.ExchangetextBox.Text = oL1Quote[0].exchange;
                    }


                    if (oL1Quote[0].volume != null)
                    {
                        this.VolumeTodaytextBox.Text = Convert.ToString(Decimal.Round(Convert.ToDecimal(oL1Quote[0].volume), 2));
                    }


                    if (oL1Quote[0].last != null && oL1Quote[0].close != null)
                    {
                        if (Convert.ToDecimal(oL1Quote[0].last) > 0)
                        {
                            this.PercentChangedextBox.Text = Convert.ToString(Decimal.Round(Convert.ToDecimal(100 * ((Convert.ToDecimal(oL1Quote[0].last) - Convert.ToDecimal(oL1Quote[0].close)) / Convert.ToDecimal(oL1Quote[0].last))), 2));
                        }
                        else
                            this.PercentChangedextBox.Text = "0.00";

                    }


                    if (oL1Quote[0].change != null)
                    {
                        this.PriceChangedtextBox.Text = Convert.ToString(Decimal.Round(Convert.ToDecimal(Convert.ToDouble(oL1Quote[0].change)), 8));
                    }


                    if (oL1Quote[0].low != null)
                    {
                        this.LowTodaytextBox.Text = Convert.ToString(Decimal.Round(Convert.ToDecimal(oL1Quote[0].low), 2));
                    }

                    if (oL1Quote[0].high != null)
                    {
                        this.HighTodaytextBox.Text = Convert.ToString(Decimal.Round(Convert.ToDecimal(oL1Quote[0].high), 2));
                    }

                    if (oL1Quote[0].bid != null)
                    {
                        this.BidtextBox.Text = Convert.ToString(Decimal.Round(Convert.ToDecimal(oL1Quote[0].bid), 2));
                    }

                    if (oL1Quote[0].ask != null)
                    {
                        this.AsktextBox.Text = Convert.ToString(Decimal.Round(Convert.ToDecimal(oL1Quote[0].ask), 2));
                    }

                }

            } 
                                        
        }




        private string Display_Level1Data(string EquitySymbol)
        {

            string cExchange = string.Empty;

            if (oBroker.TD_loginStatus == true)
            {
                
                AmeritradeBrokerAPI.L1quotes oL1Quote = oBroker.TD_GetLevel1Quote(EquitySymbol , 0);

                cExchange = oL1Quote.exchange + "_CHART";


                if (oL1Quote.description != null)
                {
                    this.ShortabletextBox.Text          = (oL1Quote.shortable.CompareTo("True") == 0 ? "Shortable" : "Not Shortable");
                    this.CompanyNametextBox.Text        = oL1Quote.description;
                    this.LastExecutedPricetextBox.Text  = Convert.ToString (Decimal.Round(Convert.ToDecimal(oL1Quote.last),2));
                    this.ExchangetextBox.Text           = oL1Quote.exchange;
                    this.VolumeTodaytextBox.Text        = Convert.ToString (Decimal.Round(Convert.ToDecimal(oL1Quote.volume),2));

                    if (Convert.ToDecimal(oL1Quote.last) > 0)
                    {
                        this.PercentChangedextBox.Text = Convert.ToString(Decimal.Round(Convert.ToDecimal(100 * ((Convert.ToDecimal(oL1Quote.last) - Convert.ToDecimal(oL1Quote.close)) / Convert.ToDecimal(oL1Quote.last))), 2));
                    }
                    else
                        this.PercentChangedextBox.Text = "0.00";


                    this.PriceChangedtextBox.Text       = Convert.ToString (Decimal.Round(Convert.ToDecimal(Convert.ToDouble(oL1Quote.change)), 8));
                    this.LowTodaytextBox.Text           = Convert.ToString (Decimal.Round(Convert.ToDecimal(oL1Quote.low),2));
                    this.HighTodaytextBox.Text          = Convert.ToString (Decimal.Round(Convert.ToDecimal(oL1Quote.high),2));
                    this.BidtextBox.Text                = Convert.ToString (Decimal.Round(Convert.ToDecimal(oL1Quote.bid),2));
                    this.AsktextBox.Text                = Convert.ToString (Decimal.Round(Convert.ToDecimal(oL1Quote.ask),2));

                   
  
                } 
                               
            }

            if (cExchange.Length > 0)
            {
                if (cExchange.IndexOf("NASDAQ") == -1 && cExchange.IndexOf("NYSE") == -1 && cExchange.IndexOf("INDEX") == -1)
                {                    
                    cExchange = string.Empty;
                }
            }

            return cExchange;

        }



        private void Request_AsyncChartHistoryData_Streaming(string EquitySymbol, string cServiceName)
        {

            if (cServiceName.Length > 0)
            {
                //if (oBroker.rs_ChartStreaming == null)
                //{
                    // Create the state object. //
                    oBroker.rs_ChartStreaming = new AmeritradeBrokerAPI.RequestState();

                    // Assign the callback method to invoke and update the user interface.
                    oBroker.rs_ChartStreaming.TickWithArgs += new AmeritradeBrokerAPI.EventHandlerWithArgs(processEvent);

                    oBroker.TD_RequestAsyncChart_Streaming(EquitySymbol, cServiceName, this);

                //}
            }            
        }




        private void Request_HistoricalData_Snapshot(string EquitySymbol)
        {

            if (oBroker.TD_loginStatus == true)
            {
                
                List<string> StringList = new List<string>();

                string ServiceName      = string.Empty;

                // Always request at least two days of data.
                int nDays = 2;
                
               
                // Make sure we have the correct exchange for this chart.
                ServiceName = this.Display_Level1Data(EquitySymbol);

                if (ServiceName.Length > 0)
                {

                    this.LevelIIQuoteServerStatustextBox.Text = "Chart available.";

                    // Create the state object for the Snapshot chart. //
                    oBroker.rs_ChartSnapShot = new AmeritradeBrokerAPI.RequestState();

                    // Assign the callback method to invoke and update the user interface.
                    oBroker.rs_ChartSnapShot.TickWithArgs += new AmeritradeBrokerAPI.EventHandlerWithArgs(processEvent);

                    oBroker.TD_RequestAsyncChart_Snapshot(EquitySymbol, ServiceName, nDays, this);

                }
                else
                    this.LevelIIQuoteServerStatustextBox.Text = "Chart not available.";
                                               
            }
        }



        private void Request_HistoricalData_Snapshot(string EquitySymbol, string ServiceName)
        {

            if (oBroker.TD_loginStatus == true)
            {

                List<string> StringList = new List<string>();

               
                // Always request at least two days of data.
                int nDays = 2;


                if (ServiceName.Length > 0 && ServiceName.IndexOf("NYSE_CHART") == 0 || ServiceName.IndexOf("NASDAQ_CHART") == 0 || ServiceName.IndexOf("INDEX_CHART") == 0)
                {

                    this.LevelIIQuoteServerStatustextBox.Text = "Chart available.";

                    // Create the state object for the Snapshot chart. //
                    oBroker.rs_ChartSnapShot = new AmeritradeBrokerAPI.RequestState();

                    // Assign the callback method to invoke and update the user interface.
                    oBroker.rs_ChartSnapShot.TickWithArgs += new AmeritradeBrokerAPI.EventHandlerWithArgs(processEvent);

                    oBroker.TD_RequestAsyncChart_Snapshot(EquitySymbol, ServiceName, nDays, this);

                }
                else
                    this.LevelIIQuoteServerStatustextBox.Text = "Chart not available.";

            }
        }



        public void DisplayAsyncChartDataRecords_Snapshot(List<List<string>> oChartBars, AmeritradeBrokerAPI.ChartUpdateType UpdateType, bool clearExistingChartData)
        {

            lock (oLock)
            {

                if (UpdateType == AmeritradeBrokerAPI.ChartUpdateType.INITIALIZE)
                {
                    this.oChartDisplayCol.Clear();
                    this.oChartDisplayCol2.Clear();
                   
                    if (clearExistingChartData == true)
                    {
                        oChartDataList2.Clear();
                        
                    }

                    oChartDataList2 = oChartBars;                    
                }

                string[] cLineData;
                string cPointTime = string.Empty;
                string cHours = string.Empty;
                string cMinutes = string.Empty;


                // First day is jan 1st

                XDate xDate;
                DateTime ctime;
                TimeSpan nTime;

                string stringtime                   = string.Empty;
                double nstringtime                  = 0;
                double nNewTime                     = 0;
                double xTime                        = 0;
                double LastXTime                    = 0;
                double hi                           = 0;
                double low                          = 0;
                double open                         = 0;
                double close                        = 0;
                double vol                          = 0;
                double nTradeTime                   = 0;
                double nTradeDay                    = 0;
                double nLastTradeDay                = 0;

                bool lZeroValueFound                = false;
                bool lStartStoringData              = false;
                bool lOk2UpdateChart                = false;

                int nStartPos                       = 0;
                int nDays                           = Convert.ToInt32 (this.ChartDaysnumericUpDown.Value);
                nDays                               = (nDays > oChartDataList2.Count ? oChartDataList2.Count : nDays);
                nDays                               = (nDays < 1 ? 1 : nDays);
                int nNumberOfDays                   = nDays;
                this.ChartDaysnumericUpDown.Value   = nDays;


                try
                {

                    if (UpdateType == AmeritradeBrokerAPI.ChartUpdateType.INITIALIZE)
                    {
                        this.Level2listView.Items.Clear();
                    }

                    for (int nTotalDays = 0; nTotalDays < nDays; nTotalDays++)
                    {
                                               
                        List<string> oChartDayData  = new List<string>();
                        lZeroValueFound             = false;


                        if (UpdateType == AmeritradeBrokerAPI.ChartUpdateType.INITIALIZE)
                        {
                            oChartDayData = oChartDataList2[oChartDataList2.Count - nNumberOfDays];
                        }
                        else
                            oChartDayData = oChartBars[0];


                        nNumberOfDays = nNumberOfDays - 1;


                        for (int nRow = 0; nRow < oChartDayData.Count; nRow++)
                        {

                            cLineData = oChartDayData[nRow].Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

                            /*/
                             * Find the most recent day for historical stock data
                            /*/
                            

                            if (lZeroValueFound == false && Convert.ToInt32(cLineData[1]) >= 90)
                            {
                                if (Convert.ToInt32(cLineData[1]) == 0)
                                {
                                    lZeroValueFound = true;
                                }

                                nStartPos = nRow;

                                break;
                            }
                        }


                        if (oChartDayData.Count > 0)
                        {
                           
                           oChartDayData.Reverse();

                           cLineData        = oChartDayData[nStartPos].Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                           
                           string cDataNDX  = cLineData[8];
                            
                           oChartDayData.Reverse();
                           

                            this.chartGraph.Visible = true;

                            for (int nRow = nStartPos; nRow < oChartDayData.Count ; nRow++)
                            {
                                
                                cLineData   = oChartDayData[nRow].Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                                            
                                TimeSpan cTimeString;

                                cTimeString = DateTime.Today.Subtract(Convert.ToDateTime("01/01/1970"));

                                if (Convert.ToInt32(cLineData[1]) >= 0)
                                {
                                    if (cDataNDX.IndexOf(cLineData[8]) == 0)
                                    {
                                        lStartStoringData = true;

                                    }
                                    else
                                        lStartStoringData = false;

                                }

                                if (lStartStoringData == true)
                                {
                                    // First day is jan 1st

                                    xDate           = new XDate(DateTime.Today.Year, DateTime.Today.Month, DateTime.Today.Day);
                                    ctime           = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 8, 0, 0);
                                    ctime           = ctime.AddMinutes(Convert.ToDouble(cLineData[1]));

                                    nTime           = ctime.TimeOfDay;
                                    xDate.DateTime  = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, nTime.Hours, nTime.Minutes, 0);


                                    stringtime      = nTime.Hours.ToString() + ":" + nTime.Minutes.ToString();
                                    nstringtime     = nTime.Hours + nTime.Minutes;
                                    nNewTime        = double.Parse(nTime.ToString().Substring(0, nTime.ToString().LastIndexOf(":")).Replace(":", ""));

                                    xTime           = nNewTime;
                                    hi              = Convert.ToDouble(decimal.Round(decimal.Parse(cLineData[3]), 2));
                                    low             = Convert.ToDouble(decimal.Round(decimal.Parse(cLineData[4]), 2));
                                    open            = Convert.ToDouble(decimal.Round(decimal.Parse(cLineData[2]), 2));
                                    close           = Convert.ToDouble(decimal.Round(decimal.Parse(cLineData[5]), 2));
                                    vol             = Convert.ToDouble(decimal.Round(decimal.Parse(cLineData[6]), 2));
                                    nTradeTime      = Convert.ToDouble(decimal.Round(decimal.Parse(cLineData[7]), 2));
                                    nTradeDay       = Convert.ToDouble(decimal.Round(decimal.Parse(cLineData[8]), 2));

                                    ListViewItem oItems = new ListViewItem(xTime.ToString());
                                    oItems.SubItems.Add(hi.ToString());
                                    oItems.SubItems.Add(low.ToString());
                                    oItems.SubItems.Add(open.ToString());
                                    oItems.SubItems.Add(close.ToString());
                                    oItems.SubItems.Add(vol.ToString());
                                    oItems.SubItems.Add(nTradeTime.ToString());


                                    StringBuilder cUpdatedBar = new StringBuilder();
                                    cUpdatedBar.Append(xTime.ToString());
                                    cUpdatedBar.Append(",");
                                    cUpdatedBar.Append(hi.ToString());
                                    cUpdatedBar.Append(",");
                                    cUpdatedBar.Append(low.ToString());
                                    cUpdatedBar.Append(",");
                                    cUpdatedBar.Append(open.ToString());
                                    cUpdatedBar.Append(",");
                                    cUpdatedBar.Append(close.ToString());
                                    cUpdatedBar.Append(",");                                    
                                    cUpdatedBar.Append(vol.ToString());
                                    cUpdatedBar.Append(",");
                                    cUpdatedBar.Append(nTradeTime.ToString());
                                                                       
                                    switch (UpdateType)
                                    {
                                        case AmeritradeBrokerAPI.ChartUpdateType.INITIALIZE:

                                            lock (this.Level2listView.Items)
                                            {
                                                
                                                this.oChartDisplayCol.Add(cUpdatedBar.ToString());                                                
                                                this.Level2listView.Items.Add(oItems);

                                                if (xTime < LastXTime)
                                                {

                                                    this.oChartDisplayCol2.Add(this.oTempChartDisplayCol);
                                                    this.oTempChartDisplayCol = new List<string>();

                                                }

                                                this.oTempChartDisplayCol.Add(cUpdatedBar.ToString());

                                                if (Convert.ToDouble(cTimeString.Days) == nTradeDay && this.oTempChartDisplayCol.Count == oChartDayData.Count)
                                                {                                                    
                                                    this.oChartDisplayCol2.Add(this.oTempChartDisplayCol);
                                                    this.oTempChartDisplayCol = new List<string>();
                                                }

                                                LastXTime = xTime;
                                                nLastTradeDay = nTradeDay;

                                            }

                                            lOk2UpdateChart = true;

                                            break;


                                        case AmeritradeBrokerAPI.ChartUpdateType.CHARTSTREAM_UPDATE:

                                            //double lasttime1 = Convert.ToDouble(this.Level2listView.Items[this.Level2listView.Items.Count - 1].SubItems[0].Text.ToString());

                                            string[] tmplasttime1 = this.oChartDisplayCol[this.oChartDisplayCol.Count - 1].Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                                            double lasttime1 = Convert.ToDouble(tmplasttime1[0].ToString());

                                            if (xTime > lasttime1)
                                            {
                                                lock (this.Level2listView.Items)
                                                {
                                                    this.oChartDisplayCol.Insert(this.oChartDisplayCol.Count , cUpdatedBar.ToString());
                                                    this.Level2listView.Items.Insert(this.Level2listView.Items.Count, oItems);
                                                }

                                                lOk2UpdateChart = true;

                                            }

                                            break;


                                        case AmeritradeBrokerAPI.ChartUpdateType.LEVELONESTREAM_UPDATE:
                                           
                                            lock (this.Level2listView.Items)
                                            {
                                                //this.oChartDisplayCol.RemoveAt(this.oChartDisplayCol.Count - 1);
                                                //this.oChartDisplayCol.Insert(this.oChartDisplayCol.Count, cUpdatedBar.ToString());


                                                this.oChartDisplayCol.RemoveAt(this.oChartDisplayCol.Count - 1);
                                                this.oChartDisplayCol.Insert(this.oChartDisplayCol.Count, cUpdatedBar.ToString());
                                            

                                                this.Level2listView.Items.RemoveAt(this.Level2listView.Items.Count - 1);
                                                this.Level2listView.Items.Insert(this.Level2listView.Items.Count, oItems);
                                                lOk2UpdateChart = true;
                                            }

                                            break;

                                    }
                                         
                                }
                            }
                        }                    
                    }

                    if (lOk2UpdateChart == true)
                    {
                        this.RecordsCNTtextBox.Text = this.Level2listView.Items.Count.ToString();

                        if (this.CandleStickradioButton.Checked == true)
                        {
                            this.Display_CandleStick_Chart();
                        }
                        else
                            this.Display_OHLC_Chart();


                        this.Level2listView.TopItem = this.Level2listView.Items[this.Level2listView.Items.Count - 1];
                    }

                }
                catch (Exception exc) { }
               
            }
        }


       


        private void Display_CandleStick_Chart()
        {

            if (this.oChartDisplayCol.Count > 0)
            {

                GraphPane myPane = this.chartGraph.GraphPane;
                myPane.CurveList.Clear();


                double ntheMaxValue = 0F;
                bool lskip          = false;


                /*/
                 * Japanese CandleStick Graph Page
                 * 
                /*/

                myPane.Title.Text                       = " CandleStick Chart : " + this.StockSymboltextBox.Text;
                myPane.XAxis.Title.Text                 = "Time (EST)";
                myPane.YAxis.Title.Text                 = "Share Price, $US";
                myPane.YAxis.MinorTic.IsOpposite        = false;
                myPane.YAxis.MajorTic.IsOpposite        = false;

                myPane.Y2Axis.Title.Text                = "Stock Chart Volume";
                myPane.Y2Axis.IsVisible                 = true;
                myPane.Y2Axis.MinorTic.IsOpposite       = false;
                myPane.Y2Axis.MajorTic.IsOpposite       = false;
                myPane.Y2Axis.Scale.FontSpec.FontColor  = Color.DarkGreen;


                StockPointList spl  = new StockPointList();
                double[] splVolY = new double[this.oChartDisplayCol.Count];
                int volNDx          = 0;


                

                 foreach (string cLineData in this.oChartDisplayCol)
                 {
                   
                    string[] lvi = cLineData.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

                    double xTime = double.Parse(lvi[0]);
                    double open = double.Parse(lvi[3]);
                    double close = double.Parse(lvi[4]);
                    double hi = double.Parse(lvi[1]);
                    double low = double.Parse(lvi[2]);
                    double nvol = double.Parse(lvi[5]);
                    splVolY[volNDx] = nvol;

                    StockPt pt = new StockPt(xTime, hi, low, open, close, nvol);
                    spl.Add(pt);
                    ntheMaxValue = (nvol > ntheMaxValue ? nvol : ntheMaxValue);

                    volNDx = volNDx + 1;

                 }


                    myPane.Y2Axis.Scale.Max = ntheMaxValue * 3;

                    JapaneseCandleStickItem myCurve = null;
                    LineItem curve = null;


                    if (lskip == false)
                    {
                        myCurve = myPane.AddJapaneseCandleStick(null, spl);
                        curve = myPane.AddCurve(null, null, splVolY, Color.Green, SymbolType.None);
                        curve.Line.Fill = new Fill(Color.Green, Color.White, Color.Green);
                        curve.Line.IsSmooth = true;
                        curve.Line.SmoothTension = 0.6F;
                        curve.IsY2Axis = true;

                    }


                    myCurve.Stick.IsAutoSize = true;
                    myCurve.Stick.Color = Color.Blue;

                    // Use DateAsOrdinal to skip weekend gaps
                    myPane.XAxis.Type = AxisType.LinearAsOrdinal;


                    // pretty it up a little
                    if (lskip == false)
                    {

                        myPane.Chart.Fill = new Fill(Color.White, Color.LightGoldenrodYellow, 45.0f);
                        myPane.Fill = new Fill(Color.White, Color.FromArgb(220, 220, 255), 45.0f);

                    }
              

                this.chartGraph.AxisChange();
                this.chartGraph.Invalidate();

                lskip = true;                

            }
        }



        private void Display_OHLC_Chart()
        {

            if (this.oChartDisplayCol.Count > 0)
            {

                GraphPane myPane = this.chartGraph.GraphPane;
                myPane.CurveList.Clear();

               
                double ntheMaxValue = 0F;
                bool lskip          = false;


                /*/
                 * Line Bar Graph Page
                 * 
                /*/

                myPane.Title.Text                       = " OHLC Chart : " + this.StockSymboltextBox.Text;
                myPane.XAxis.Title.Text                 = "Time (EST)";
                myPane.YAxis.Title.Text                 = "Share Price, $US";
                myPane.YAxis.MinorTic.IsOpposite        = false;
                myPane.YAxis.MajorTic.IsOpposite        = false;

                myPane.Y2Axis.Title.Text                = "Stock Chart Volume";
                myPane.Y2Axis.IsVisible                 = true;
                myPane.Y2Axis.MinorTic.IsOpposite       = false;
                myPane.Y2Axis.MajorTic.IsOpposite       = false;
                myPane.Y2Axis.Scale.FontSpec.FontColor  = Color.DarkGreen;
                

                StockPointList spl  = new StockPointList();
                double[] splVolY    = new double[this.oChartDisplayCol.Count];
                int volNDx          = 0;
                              
             
               foreach (string cLineData in this.oChartDisplayCol)                   
               {

                    string[] lvi = cLineData.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

                    double xTime = double.Parse(lvi[0]);
                    double open = double.Parse(lvi[3]);
                    double close = double.Parse(lvi[4]);
                    double hi = double.Parse(lvi[1]);
                    double low = double.Parse(lvi[2]);
                    double nvol = double.Parse(lvi[5]);
                    splVolY[volNDx] = nvol;

                    StockPt pt = new StockPt(xTime, hi, low, open, close, nvol);
                    spl.Add(pt);

                    ntheMaxValue = (nvol > ntheMaxValue ? nvol : ntheMaxValue);
                    volNDx = volNDx + 1;

                }

                myPane.Y2Axis.Scale.Max = ntheMaxValue * 3;

                OHLCBarItem myCurve = null;
                LineItem curve = null;


                if (lskip == false)
                {
                    myCurve = myPane.AddOHLCBar(null, spl, Color.Black);
                    curve = myPane.AddCurve(null, null, splVolY, Color.Green, SymbolType.None);
                    curve.Line.Fill = new Fill(Color.Green, Color.White, Color.Green);
                    curve.Line.IsSmooth = true;
                    curve.Line.SmoothTension = 0.6F;
                    curve.IsY2Axis = true;

                }


                myCurve.Bar.IsAutoSize = true;
                myCurve.Bar.Color = Color.Black;


                // Use DateAsOrdinal to skip weekend gaps
                myPane.XAxis.Type = AxisType.LinearAsOrdinal;


                // pretty it up a little
                if (lskip == false)
                {

                   
                    myPane.Chart.Fill = new Fill(Color.White, Color.LightGoldenrodYellow, 45.0f);
                    myPane.Fill = new Fill(Color.White, Color.FromArgb(220, 220, 255), 45.0f);
               
                                           
                }
               
                this.chartGraph.AxisChange();
                this.chartGraph.Invalidate();

                lskip = true;
               

            }
        }



        private void Display_OHLC_Chart_backup()
        {

            if (this.oChartDisplayCol.Count > 0)
            {

                GraphPane myPane = this.chartGraph.GraphPane;
                myPane.CurveList.Clear();


                double ntheMaxValue = 0F;
                bool lskip = false;


                /*/
                 * Line Bar Graph Page
                 * 
                /*/

                myPane.Title.Text = " OHLC Chart : " + this.StockSymboltextBox.Text;
                myPane.XAxis.Title.Text = "Time (EST)";
                myPane.YAxis.Title.Text = "Share Price, $US";
                myPane.YAxis.MinorTic.IsOpposite = false;
                myPane.YAxis.MajorTic.IsOpposite = false;

                myPane.Y2Axis.Title.Text = "Stock Chart Volume";
                myPane.Y2Axis.IsVisible = true;
                myPane.Y2Axis.MinorTic.IsOpposite = false;
                myPane.Y2Axis.MajorTic.IsOpposite = false;
                myPane.Y2Axis.Scale.FontSpec.FontColor = Color.DarkGreen;


                StockPointList spl = new StockPointList();
                double[] splVolY = new double[this.oChartDisplayCol2[Convert.ToInt32 (this.ChartDaysnumericUpDown.Value) - 1].Count];
                int volNDx = 0;

                

                foreach (List<string> cd in this.oChartDisplayCol2)
                {

                    foreach (string cLineData in cd)
                    {

                        string[] lvi = cLineData.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

                        double xTime = double.Parse(lvi[0]);
                        double open = double.Parse(lvi[3]);
                        double close = double.Parse(lvi[4]);
                        double hi = double.Parse(lvi[1]);
                        double low = double.Parse(lvi[2]);
                        double nvol = double.Parse(lvi[5]);
                        splVolY[volNDx] = nvol;

                        StockPt pt = new StockPt(xTime, hi, low, open, close, nvol);
                        spl.Add(pt);

                        ntheMaxValue = (nvol > ntheMaxValue ? nvol : ntheMaxValue);
                        volNDx = volNDx + 1;

                    }

                    myPane.Y2Axis.Scale.Max = ntheMaxValue * 3;

                    OHLCBarItem myCurve = null;
                    LineItem curve = null;


                    if (lskip == false)
                    {
                        myCurve = myPane.AddOHLCBar(null, spl, Color.Black);
                        curve = myPane.AddCurve(null, null, splVolY, Color.Green, SymbolType.None);
                        curve.Line.Fill = new Fill(Color.Green, Color.White, Color.Green);
                        curve.Line.IsSmooth = true;
                        curve.Line.SmoothTension = 0.6F;
                        curve.IsY2Axis = true;

                    }


                    myCurve.Bar.IsAutoSize = true;
                    myCurve.Bar.Color = Color.Black;


                    // Use DateAsOrdinal to skip weekend gaps
                    myPane.XAxis.Type = AxisType.LinearAsOrdinal;


                    // pretty it up a little
                    if (lskip == false)
                    {

                        myPane.Chart.Fill = new Fill(Color.White, Color.LightGoldenrodYellow, 45.0f);
                        myPane.Fill = new Fill(Color.White, Color.FromArgb(220, 220, 255), 45.0f);

                    }

                }

                this.chartGraph.AxisChange();
                this.chartGraph.Invalidate();

                lskip = true;

            }
        }



        private void EnterOrder()
        {

            AmeritradeBrokerAPI.ATradeArgument brokerReplyargs  = new AmeritradeBrokerAPI.ATradeArgument();
            string cResultMessage                               = string.Empty;
            string cEnteredOrderID                              = string.Empty;
            StringBuilder cOrderString                          = new StringBuilder();

            cOrderString.Append("action="           + oBroker.Encode_URL(this.TradeTypecomboBox.Text)); 
            cOrderString.Append("~clientorderid="   + oBroker.Encode_URL(string.Empty));
            cOrderString.Append("~accountid="       + oBroker.Encode_URL(oBroker._accountid));
            cOrderString.Append("~actprice="        + oBroker.Encode_URL(string.Empty));
            cOrderString.Append("~expire="          + oBroker.Encode_URL(this.TimeInForcecomboBox.Text)); 
            cOrderString.Append("~ordtype="         + oBroker.Encode_URL(this.OrderTypecomboBox.Text));
            cOrderString.Append("~price="           + oBroker.Encode_URL(this.OrderPricetextBox.Text));
            cOrderString.Append("~quantity="        + oBroker.Encode_URL(this.OrderSharestextBox.Text));
            cOrderString.Append("~spinstructions="  + oBroker.Encode_URL("none"));
            cOrderString.Append("~symbol="          + oBroker.Encode_URL(this.OrderSymboltextBox.Text));
            cOrderString.Append("~routing="         + oBroker.Encode_URL(this.OrderRoutingcomboBox.Text));

            cOrderString.Append("~tsparam="         + oBroker.Encode_URL(string.Empty));
            cOrderString.Append("~exmonth="         + oBroker.Encode_URL(string.Empty));
            cOrderString.Append("~exday="           + oBroker.Encode_URL(string.Empty));
            cOrderString.Append("~exyear="          + oBroker.Encode_URL(string.Empty));
            cOrderString.Append("~displaysize="     + oBroker.Encode_URL(string.Empty));


            brokerReplyargs.ResultsCode = oBroker.TD_sendOrder(this.UserNametextBox.Text, this.PasswordtextBox.Text , this.SourceIDtextBox.Text, "1", cOrderString.ToString(), ref cResultMessage, ref cEnteredOrderID);

            this.Display_AccountInfo(this.SourceIDtextBox.Text, this.UserNametextBox.Text, this.PasswordtextBox.Text);
            this.Display_TradeHistory(this.SourceIDtextBox.Text, this.UserNametextBox.Text, this.PasswordtextBox.Text, string.Empty);


        }


        private void ModifyOrder()
        {

            AmeritradeBrokerAPI.ATradeArgument brokerReplyargs  = new AmeritradeBrokerAPI.ATradeArgument();
            string cResultMessage                               = string.Empty;
            string cEnteredOrderID                              = string.Empty;
            StringBuilder cOrderString                          = new StringBuilder();

            cOrderString.Append("orderid="      + oBroker.Encode_URL(this.OrderIdtextBox.Text));
            cOrderString.Append("~accountid="   + oBroker.Encode_URL(oBroker._accountid));
            cOrderString.Append("~actprice="    + oBroker.Encode_URL(string.Empty));
            cOrderString.Append("~expire="      + oBroker.Encode_URL(this.TimeInForcecomboBox.Text));
            cOrderString.Append("~ordtype="     + oBroker.Encode_URL(this.OrderTypecomboBox.Text));
            cOrderString.Append("~price="       + oBroker.Encode_URL(this.OrderPricetextBox.Text));
            cOrderString.Append("~quantity="    + oBroker.Encode_URL(this.OrderSharestextBox.Text));
            cOrderString.Append("~symbol="      + oBroker.Encode_URL(this.OrderSymboltextBox.Text));
            cOrderString.Append("~exmonth="     + oBroker.Encode_URL(string.Empty));
            cOrderString.Append("~exday="       + oBroker.Encode_URL(string.Empty));
            cOrderString.Append("~exyear="      + oBroker.Encode_URL(string.Empty));

            brokerReplyargs.ResultsCode = oBroker.TD_ModifyOrder(this.UserNametextBox.Text, this.PasswordtextBox.Text, this.SourceIDtextBox.Text, "1", cOrderString.ToString(), ref cResultMessage, ref cEnteredOrderID);

            this.Display_AccountInfo(this.SourceIDtextBox.Text, this.UserNametextBox.Text, this.PasswordtextBox.Text);
            this.Display_TradeHistory(this.SourceIDtextBox.Text, this.UserNametextBox.Text, this.PasswordtextBox.Text, string.Empty);


        }


        private void CancelOrder()
        {

            AmeritradeBrokerAPI.ATradeArgument brokerReplyargs  = new AmeritradeBrokerAPI.ATradeArgument();
            string cResultMessage                               = string.Empty;
            
            brokerReplyargs.ResultsCode = oBroker.TD_CancelOrder(oBroker._accountid, this.OrderIdtextBox.Text, this.UserNametextBox.Text, this.PasswordtextBox.Text, this.SourceIDtextBox.Text, "1", ref cResultMessage);

            this.Display_AccountInfo(this.SourceIDtextBox.Text, this.UserNametextBox.Text, this.PasswordtextBox.Text);
            this.Display_TradeHistory(this.SourceIDtextBox.Text, this.UserNametextBox.Text, this.PasswordtextBox.Text, string.Empty);


        }





        private void listView2_SelectedIndexChanged(object sender, EventArgs e)
        {
            foreach (ListViewItem lvi in this.listView2.Items)
            {
                if (lvi.Selected == true)
                {
                    this.OrderIdtextBox.Text        = lvi.SubItems[0].Text;
                    this.OrderSymboltextBox.Text    = lvi.SubItems[1].Text;
                    this.OrderSharestextBox.Text    = lvi.SubItems[2].Text;
                    this.OrderPricetextBox.Text     = lvi.SubItems[3].Text;
                }
            }                        
        }




        #region Order Entry/Modificaton Click Events

        private void EnterOrderbutton_Click(object sender, EventArgs e)
        {
            this.EnterOrder();
            this.listView2.Sort();
        }

        
        private void ModifyOrderbutton_Click(object sender, EventArgs e)
        {
            this.ModifyOrder();
            this.listView2.Sort();
        }

        private void CancelOrderbutton_Click(object sender, EventArgs e)
        {
            this.CancelOrder();
            this.listView2.Sort();
        }


        #endregion



        private void StatuscomboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            this.Display_TradeHistory(this.SourceIDtextBox.Text, this.UserNametextBox.Text, this.PasswordtextBox.Text, string.Empty);
        }


        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.Close_Connections(true);
        }

        private void DataRequesttimer_Tick(object sender, EventArgs e)
        {

        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            if (this.EncryptcheckBox.Checked == true)
            {
                this.UserNametextBox.PasswordChar = '*';
                this.PasswordtextBox.PasswordChar = '*';
                this.UserNametextBox.UseSystemPasswordChar = true;
                this.PasswordtextBox.UseSystemPasswordChar = true;
            }
            else
            {
                this.UserNametextBox.PasswordChar = '\0';
                this.PasswordtextBox.PasswordChar = '\0';
                this.UserNametextBox.UseSystemPasswordChar = false;
                this.PasswordtextBox.UseSystemPasswordChar = false;
            }

        }



        private void LineradioButton_CheckedChanged(object sender, EventArgs e)
        {
            if (this.LineradioButton.Checked == true)
            {
                this.Display_OHLC_Chart();
            }
        }



        private void CandleStickradioButton_CheckedChanged(object sender, EventArgs e)
        {
            if (this.CandleStickradioButton.Checked == true)
            {
                this.Display_CandleStick_Chart();
            }
        }



        private void GetDatabutton_Click(object sender, EventArgs e)
        {
            
            this.GetStockData();
        }



        private void GetStockData()
        {

            string SourceID         = string.Empty;
            string BrokerUserName   = string.Empty;
            string BrokerPassword   = string.Empty;
            string EquitySymbol     = string.Empty;

            SourceID                = this.SourceIDtextBox.Text.ToUpper();
            BrokerUserName          = this.UserNametextBox.Text;
            BrokerPassword          = this.PasswordtextBox.Text;
            EquitySymbol            = this.StockSymboltextBox.Text.ToUpper();


            this.BuyOrdersDisplayButton.Text  = "Buy Orders (BID)";
            this.SellOrdersDisplayButton.Text = "Sell Orders (ASK)";


            if (EquitySymbol.Length > 0)
            {
                if (oBroker.TD_loginStatus == true)
                {

                    /*/
                     * Safely close any open connections and logout, if alreadly logged in.
                    /*/

                    this.Close_Connections(false);


                    this.EncryptcheckBox.Checked = true;
                    this.BidListView.Items.Clear();
                    this.AskListView.Items.Clear();

                    //this.Display_AccountInfo(SourceID, BrokerUserName, BrokerPassword);
                    //this.Display_TradeHistory(SourceID, BrokerUserName, BrokerPassword, string.Empty);

                    
                    if (oBroker.TD_IsStockSymbolValid(EquitySymbol) == true)
                    {
                        this.Request_AsyncLevel1DataSnapshot(EquitySymbol);
                    }
                    else
                    {
                        MessageBox.Show("The stock symbol you have entered is invalid. Please try again.", "ATrade - Ameritrade Demo", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    }


                }

            }
        }

        private void ChartDaysnumericUpDown_ValueChanged(object sender, EventArgs e)
        {

            this.DisplayAsyncChartDataRecords_Snapshot(oChartDataList2, AmeritradeBrokerAPI.ChartUpdateType.INITIALIZE, false);
        }
        
   

    }
}