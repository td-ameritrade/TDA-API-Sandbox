using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms.DataVisualization.Charting;
using System.Drawing;
using TechTrader.Sources;

namespace TechTrader.Technicals
{
    public class Options_Volume:TechnicalTemplate
    {
        public override Technical defaultSettings {
            get {
                return new Technical(
                new string[]{"DollarValue", "%OptionVolume", "%EquityVolume"}, // Setting
                new double[]{1000000, 1000, 1}, // Value for Setting1
                null, // Show this on graphs
                true, // Use signals generated
                null, // Check trades from other signals against this
                "Buy when call volume above DollarValue and short when put volume above DollarVolume and % greater than average." // Notes about use, keep it short
            );
            }
        }

        // Create a profile in the drop down with settings already setup
        public override void CreateProfiles()
        {
            // Repeat this part of the code for each profile you want to add
            addProfile(
                "High Options Volume | Screener for high volume in calls and puts.", new Dictionary<string, Technical>
                {
                    // {<Indicator>, new Technical(new string[]{"<setting1>", ...}, new decimal[]{<value1>,...},
                    //  <show>, <signal>, <check>)}
                    {"Options_Volume", new Technical(null, new double[]{2000000, 2000, 1}, null, true, null)},
                    {"RSI", new Technical(null, new double[]{14, 50, 50, 50, 50}, true, null, null)}
                }
            );
        }

        private Dictionary<string, double> options;

        private IEnumerable<KeyValuePair<string, double>> buy, sell;
        public override void Initialize() {
            //setStartDate(getNow().AddDays(-30));
            //setHistoryDays(30);
            buy = sell = null;
            options = ((Sources.TDAmeritrade)source["TDAmeritrade"]).getOptionVolume(getSymbol());
            IEnumerable<KeyValuePair<string, double>> calls, puts;
            calls = options.Where(y => y.Key.Contains("Call"));
            puts = options.Where(y => y.Key.Contains("Put"));
            buy = calls.Where(x => x.Value >= thisTech.get("DollarValue") && x.Value >= Math.Max(last("Volume", 20, 1) * lastPrice(20, 1) * thisTech.get("%EquityVolume") / 100, calls.Average(y => y.Value) * thisTech.get("%OptionVolume") / 100));
            sell = puts.Where(x => x.Value >= thisTech.get("DollarValue") && x.Value >= Math.Max(last("Volume", 20, 1) * lastPrice(20, 1) * thisTech.get("%EquityVolume") / 100, puts.Average(y => y.Value) * thisTech.get("%OptionVolume") / 100));
        }

        public override void Signal() {
            if (getDate.Last().Date == getNow().Date)
            {
                int buys = buy.Count(), sells = sell.Count();
                if (buys>0 && sells==0)
                {
                    KeyValuePair<string, double> result = buy.OrderByDescending(x => x.Value).First();
                    if (last("RSI") <= technical["RSI"].get("BuyAt")) signal("buy", 0, result.Key + " with $" + result.Value.ToString("N1") + " volume");
                }
                else if (buys==0 && sells>0)
                {
                    KeyValuePair<string, double> result = sell.OrderByDescending(x => x.Value).First();
                    if (last("RSI") >= technical["RSI"].get("ShortAt")) signal("sell", 0, result.Key + " with $" + result.Value.ToString("N1") + " volume");
                }
            }
        }

    }
}
