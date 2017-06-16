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
    public class TDAwithYahoo : SourceTemplate
    {

        public override void getData(DateTime earliestDate) // Including learning periods (startDate + learn)
        {
            if(isIntraday) {
                ((TDAmeritrade)source["TDAmeritrade"]).getData(earliestDate);
                return;
            }
            string url="", csv = "";
            string[] TDAQuote = ((TDAmeritrade)source["TDAmeritrade"]).getToday();
            DateTime today = getNow();
            if (today.Date != earliestDate.Date)
            {
                DateTime yesterday;
                if (getPeriodType() == "Daily" && getEndDate().Date > earliestDate.Date && getNow().TimeOfDay <= marketClose + TimeSpan.FromMinutes(15)) yesterday = getEndDate().AddDays(-1);
                else yesterday = getEndDate();
                url = "http://ichart.finance.yahoo.com/table.csv?s=" + getSymbol()
                    + "&a=" + (earliestDate.Month - 1)
                    + "&b=" + (earliestDate.Day)
                    + "&c=" + (earliestDate.Year)
                    + "&d=" + (yesterday.Month - 1)
                    + "&e=" + (yesterday.Day)
                    + "&f=" + (yesterday.Year)
                    + "&g=" + getPeriodType().ToLower()[0]
                    + "&ignore=.csv"
                    ;
                try
                {
                    csv = new System.Net.WebClient().DownloadString(url);
                }
                catch
                {
                    WriteOutput("Timeout on loading URL: " + url, true);
                    //return;
                }
                WriteOutput("Loading " + url, true);
            }
            bool foundToday = false;
            if (today.Date == getEndDate().Date && getNow().TimeOfDay <= marketClose + TimeSpan.FromMinutes(15) && !csv.Contains(today.ToString("yyyy-MM-dd")))
            {
                if (getPeriodType() == "Daily")
                {
                    // Get today's quote from Ameritrade
                    string[] cell = TDAQuote;
                    if (cell[0] == today.ToString("yyyy-MM-dd"))
                    {
                        csv = string.Join(",", cell) + "\r\n" + csv;
                        foundToday = true;
                    }
                    else
                    {
                        WriteOutput("No data available yet for today.", true);
                    }
                }
            }
            if (!foundToday && today.Date == getEndDate().Date && !csv.Contains(today.ToString("yyyy-MM-dd")))
            {
                if (getPeriodType() == "Daily")
                {
                    // Get today's quote if not included in historical
                    string todayurl = "http://finance.yahoo.com/d/quotes.csv?s=" + getSymbol() + "&f=d1ohgl1vl1";
                    try
                    {
                        string[] cell = new System.Net.WebClient().DownloadString(todayurl).Trim().Split(',');
                        cell[0] = DateTime.Parse(cell[0].Replace("\"", "")).ToString("yyyy-MM-dd");
                        WriteOutput("Also loading " + todayurl, true);
                        if (cell[0] == today.ToString("yyyy-MM-dd"))
                            csv = string.Join(",", cell) + "\r\n" + csv;
                        else WriteOutput("Warning: No data available yet for today.", true);
                    }
                    catch
                    {
                        WriteOutput("Timeout on loading URL: " + todayurl, true);
                    }
                }
                else
                {
                    WriteOutput("Note: Yahoo weekly/monthly historical data does not include today until market close.");
                }
            }
            ((YahooCSV)source["YahooCSV"]).setCSV(csv);
            source["YahooCSV"].getData(earliestDate);
        }
    }       
}
