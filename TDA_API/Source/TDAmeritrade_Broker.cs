using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace TechTrader.Execution
{
    public class TDAmeritrade:ExecutionTemplate
    {
        /* Broker class Structure
         * This file contains the general structure for adding new brokers to execute trades.
         * 
         * To get started, rename this file and change the class declaration from 'public abstract class...' to 'public class <yourSource>:BrokerTemplate'.  Rename the "virtual" flag on the trade function to "override".
         * 
         * There is only one required function that the program will use to pull data and that is trade(...).
         * The trade function will be called on each run whenever there is a trade done by Tech Trader today on two conditions:
         * 1. The manualPrice of the signal is not set; then the trade function will only be called within 10 minutes of close.
         * 2. The manualPrice of the signal is set; then the trade function will be called as soon as a trade is done on Tech Trader.
         * It is the Broker class's job to check whether the position already exists, how many shares, whether to limit or market order, etc, but you can reference the actual trade done by Tech Trader via the arguments to trade(...), as well as the utility functions given at the bottom.
         * 
         * When you are done coding, "Build" the solution in Visual Studio.  Your finished dll file will be in the bin/Release file.  You can now load this as a Broker when running Tech Trader and clicking Add near the Brokers section.
        */

        // Main function for trades
        public override void trade(string symbol, double price, string type, int shares, string description, string custom) // ticker, buy/sell/short/cover, # shares > 0, description from signal
        {
            ((Sources.TDAmeritrade)source["TDAmeritrade"]).trade(symbol.Replace("-", ".").ToUpper(), price, type, shares);
        }

        // Useful for checking portfolio over once at the beginning of the loop (only happens after >1 batch loop because you need results to check against)
        public override void initialize()
        {
            if (!batchResultsReady) return; // No batch results to compare against yet (first pass over the list)
            else
            { // Check actual portfolio against what strategy says we should have
                ((Sources.TDAmeritrade)source["TDAmeritrade"]).checkPositions(this);
            }
        }

        public BatchResult getResult(string b) { return getBatchResult(b); }

        public double getPortfolioSize() { return portfolioCapped ? portfolioSize : float.MaxValue; }

        /////////////////////////////////////////////////////////////
        /* Utility functions you can use, but don't redefine in your plugin

        // Properties describing current position and settings
        protected double positionPrice { get { return m.getPrice(); } }
        protected int positionShares { get { return m.getShares(); } }
        protected double positionStrength { get { return m.getPositionStrength(); } }
        protected double initialCash { get { return m.initialCash; } }
        protected double getCash() { return m.getCash(); }
        protected double getLong() { return m.getLong(); }
        protected double getShort() { return m.getShort(); }
        protected int reinvestType { get { return m.reinvestType; } }
        protected double maxLong { get { return m.maxLong; } }
        protected double maxShort { get { return m.maxShort; } }
        protected int period { get { return m.period; } } // List index of the period type
        protected int aggressive { get { return m.aggressive; } }
        protected double NAV { get { return m.NAV; } }
        protected double SharpePerTrade { get { return m.SharpePerTrade; } }
        protected double AnnSharpe { get { return m.AnnSharpe; } }
        protected double HitRatio { get { return m.HitRatio; } }
        protected int totalTrades { get { return m.totalTrades; } }
        protected string todaySignal { get { return m.lastTrade; } } // What signal went off today? buy/sell/short/cover
        protected int lastSignal { get { return m.lastSignal; } } // bars from last signal

        protected string getSymbol() { return m.getSymbol(); }
        protected DateTime getStartDate() { return m.getStartDate(); } // Use earliestDate instead, this is given just incase
        protected DateTime getEndDate() { return m.getEndDate(); }
        protected string getPeriodType() { return m.getPeriodType(); }

        // Get current datetime in EST
        protected DateTime getNow()
        {
            return m.getNow();
        }

        // Get the most recent trading day starting from the day d
        protected DateTime getTradingDay(DateTime d) { return m.getTradingDay(d); }

        // Get number of bars per day, for the period type set on the UI.
        protected double barsPerDay { get { return m.barsPerDay; } }

        // Timespan objects contains open and close times of the market in EST
        protected TimeSpan marketOpen { get { return m.marketOpen; } }
        protected TimeSpan marketClose { get { return m.marketClose; } }

        // Returns true if we're on intraday settings
        protected bool isIntraday { get { return m.isIntraday; } }

        // Get the date of a trading day using thisPointId, example getDate[0] is the first trading date.
        protected List<DateTime> getDate { get { return m.getDate; } }

        // ID of current Datapoint on chart, corresponds to # days since start.
        protected int thisPointId { get { return m.thisPointId; } }

        // Write to output box on Explain mode; set nonDebug to true for global use
        protected void WriteOutput(string text, bool nonDebug = false)
        {
            m.WriteOutput(text, nonDebug);
        }

        // Below are alert functions for pausing or displaying values.
        protected void forcePause() { m.forcePause(); }
        protected void popup(string s) { m.popup(s); }

        // Make sure to check against this to stop the program if the user aborts
        protected bool isRunning { get { return m.isRunning; } }

        // Flag for if this is batch mode (check before showing dialogs, for example)
        protected bool isBackgroundTask { get { return m.isBackgroundTask; } }

        /////////////////////////////////////////////////////////////////////////
        // Implementation stuff for the template, don't include in your plugin //
        private TechTrader m;
        public void setMainForm(TechTrader mainForm) { 
            m = mainForm;
        }
        /* */
    }
}
