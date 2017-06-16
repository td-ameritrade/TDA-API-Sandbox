TDAmeritrade for Tech Trader
Data Source and Execution Plugin
by pftq

About:
  The TDAmeritrade plugin for Tech Trader adds the functionality to pull both live and historical price/volume data from TDAmeritrade on all time frequencies (daily, intraday, weekly, monthly).  The plugin also adds the option to execute automated trades on your TDAmeritrade account to match signals generated from Tech Trader.  The functionalities are mutually exclusive and can be enabled together or without the other.
  Pulling data and executing trades from TDAmeritrade requires that you have both an account and API access with TDAmeritrade.  Please contact them if you need assistance with this.

Instructions:
1. Tech Trader: Go to http://www.pftq.com/stocks/techtrader/ and click Start.
2. Click the Add button next to either the Data Sources or Execution.
3. Locate the TDAmeritrade.dll file
4. Check the data sources you wish to utilize now and the TDAmeritrade execution option if you want to route automated trades to your account.


Copyright:
  Tech Trader and related programs are all copyrighted and only to be distributed from www.pftq.com
  Modification and re-distribution is prohibited without consent of the author at www.pftq.com
  
  TDAmeritrade is not associated with Tech Trader or pftq.com.  The plugin is only an application of TDAmeritrade's API for TDAmeritrade users only.
  
Changelog:
20150930
	Disabled login prompt if being run in Batch Mode and past credentials exist.

20150826
	Reduced timeout on options data pulls to avoid hangups on certain names with large chains and go directly to creating shorter requests.

20150818
	Updated with fees customizable in the GUI.
	Added public getter method for account value.

20150812
	Updated to handle failed API calls better, particularly with account balances pull.

20150728
	Handle options descriptions being malformed by regenerating the proper description from the symbol.
	Added type parameter to options fetch methods.

20150723
	Removed references to marginable/non-marginable so that there is no dependency on account type.

20150722
	Added session/timeout return values to login and optional sourceid/session arguments to all methods for subclassing in use with multiple accounts.

20150709
	Fixed intraday queries pulling entire days without regards to intraday partial data existing.

20150707
	Disable halting on unavailable historical data due to holidays missing data and causing halts.

20150701
	Added extra filter for occasional pre or post market data from TDA (despite requesting market-hours only).

20150506
	Added fill reporting for orders.
	Removed deprecated getPortfolioSize calls.

20150410
	Updated for Tech Trader API improvements.

20150104
	Updated to use new Execution class.

20140622
	Fixed getOptionVolume excluding contracts farther out than a year.

20140616
	Fixed getOption* functions excluding contracts with missing fields (bid/ask/volume).

20140511
	Fixed getOption* functions only pulling ITM options.

20140126
	Added getOptionData function to pull all options data on a ticker.

20131231
	Updated Yahoo's CSV URL to ichart.finance.yahoo.com instead of ichart.yahoo.com

20130926:
	Fixed timing out of Yahoo not halting the data source process.

20130330:
	Added handling for portfolio size settings to restrict portion of portfolio tradable by Tech Trader.

20130126: 
	Added option to auto-close positions that Tech Trader doesn't recognize (for full automation of a portfolio).
	Unfilled Tech Trader orders automatically get cancelled after 5 seconds.
	Login settings are now remembered to make it easier to log back in after restart.