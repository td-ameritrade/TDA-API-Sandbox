unit TDATypes;

interface

//Uses TDAHTTPStream,TDAWinHTTP;

//------------------------------------------------------
// these constants are the subscription type for subscribing to symbols
//------------------------------------------------------
Const   TDAPI_L1        = 1;
        TDAPI_L2        = 2;
        TDAPI_ISLD      = 3;
        TDAPI_ARCA      = 4;
        TDAPI_News      = 5;
        TDAPI_Actives   = 6;
        TDAPI_LII       = 7;
        TDAPI_TV        = 8;

//------------------------------------------------------
// the type of order submit for the OrderCommand
//------------------------------------------------------
Const   TDAPI_SUBMIT_New           = 1;
        TDAPI_SUBMIT_Cancel        = 3;
        TDAPI_SUBMIT_Modify        = 5;

//------------------------------------------------------
// the callback function type
//------------------------------------------------------
Const  TDAPI_Callback_First             = 1;
       TDAPI_Callback_GotBackfill       = 1;
       TDAPI_Callback_GotBalances       = 2;
       TDAPI_Callback_GotMessage        = 3;
       TDAPI_Callback_GotNews           = 4;
       TDAPI_Callback_GotPositions      = 5;
       TDAPI_Callback_GotTransactions   = 6;
       TDAPI_Callback_L1Data            = 7;
       TDAPI_Callback_L2Data            = 8;
       TDAPI_Callback_OrderAck          = 9;
       TDAPI_Callback_StatusChange      = 10;
       TDAPI_Callback_Ping              = 11;
       TDAPI_Callback_ActivesData       = 12;
       TDAPI_Callback_L1DataPtr         = 13;
       TDAPI_Callback_GotBalancesPtr    = 14;
       TDAPI_Callback_GotLastOrderStatus= 15;
       TDAPI_Callback_GotSnapQuote      = 16;
       TDAPI_Callback_ActivesDataPtr    = 17;
       TDAPI_Callback_GotPandL          = 18;
       TDAPI_Callback_TVL2Data          = 19;
       TDAPI_Callback_OptionChain       = 20;
       TDAPI_Callback_GotHistBackfill   = 21;
       TDAPI_Callback_Last              = 21;

//------------------------------------------------------
// TAPI_Mask_XXX - the masks to see what changed in the TAPIStockQuote record
//------------------------------------------------------
Const   TAPI_MASK_Bid            = $000000000001;
        TAPI_MASK_Ask            = $000000000002;
        TAPI_MASK_Last           = $000000000004;
        TAPI_MASK_High           = $000000000008;
        TAPI_MASK_Low            = $000000000010;
        TAPI_MASK_PrevClose      = $000000000020;
        TAPI_MASK_Open           = $000000000040;
        TAPI_MASK_Change         = $000000000080;
        TAPI_MASK_High52         = $000000000100;
        TAPI_MASK_Low52          = $000000000200;

        TAPI_MASK_Tick           = $000000000400;

        TAPI_MASK_Volume         = $000000000800;
        TAPI_MASK_BidSize        = $000000001000;
        TAPI_MASK_AskSize        = $000000002000;
        TAPI_MASK_Lastsize       = $000000004000;

        TAPI_MASK_BidExch        = $000000008000;
        TAPI_MASK_AskExch        = $000000010000;
        TAPI_MASK_Exchange       = $000000020000;

        TAPI_MASK_TradeTime      = $000000040000;
        TAPI_MASK_QuoteTime      = $000000080000;
        TAPI_MASK_TradeDate      = $000000100000;
        TAPI_MASK_QuoteDate      = $000000200000;

        TAPI_MASK_IslandBid      = $000000400000;
        TAPI_MASK_IslandAsk      = $000000800000;
        TAPI_MASK_IslandVol      = $000001000000;
        TAPI_MASK_IslandBidSize  = $000002000000;
        TAPI_MASK_IslandAskSize  = $000004000000;

        TAPI_MASK_Name           = $000008000000;

        TAPI_MASK_Marginable     = $000010000000;
        TAPI_MASK_Shortable      = $000020000000;
        TAPI_MASK_Volatility     = $000040000000;
        TAPI_MASK_TradeID        = $000080000000;
        TAPI_MASK_Digits         = $000100000000;
        TAPI_MASK_PE             = $000200000000;

        TAPI_MASK_Dividend       = $000400000000;
        TAPI_MASK_Yield          = $000800000000;

        TAPI_MASK_NAV            = $001000000000;
        TAPI_MASK_Fund           = $002000000000;

        TAPI_MASK_ExchName       = $004000000000;
        TAPI_MASK_DivDate        = $008000000000;

        TAPI_MASK_OpenInt        = $010000000000;
        TAPI_MASK_TimeVal        = $020000000000;

        TAPI_MASK_Delta          = $080000000000;
        TAPI_MASK_Gamma          = $100000000000;
        TAPI_MASK_Theta          = $200000000000;
        TAPI_MASK_Vega           = $400000000000;
        TAPI_MASK_Rho            = $800000000000;

//------------------------------------------------------
// TAPI_FieldID_XXXX - the field IDs for L1
//------------------------------------------------------
Const TAPI_FieldID_Symbol	 = 0;
      TAPI_FieldID_Bid	         = 1;
      TAPI_FieldID_Ask           = 2;
      TAPI_FieldID_Last	         = 3;
      TAPI_FieldID_BidSize	 = 4;
      TAPI_FieldID_AskSize	 = 5;
      TAPI_FieldID_BidExch	 = 6;
      TAPI_FieldID_AskExch       = 7;
      TAPI_FieldID_Volume	 = 8;
      TAPI_FieldID_LastSize	 = 9;
      TAPI_FieldID_TradeTime	 = 10;
      TAPI_FieldID_QuoteTime	 = 11;
      TAPI_FieldID_High	         = 12;
      TAPI_FieldID_Low	         = 13;
      TAPI_FieldID_Tick	         = 14;
      TAPI_FieldID_PrevClose     = 15;
      TAPI_FieldID_Exchange	 = 16;
      TAPI_FieldID_Marginable	 = 17;
      TAPI_FieldID_Shortable	 = 18;
      TAPI_FieldID_IslandBid	 = 19;
      TAPI_FieldID_IslandAsk	 = 20;
      TAPI_FieldID_IslandVol	 = 21;
      TAPI_FieldID_QuoteDate	 = 22;
      TAPI_FieldID_TradeDate	 = 23;
      TAPI_FieldID_Volatility	 = 24;
      TAPI_FieldID_Name          = 25;
      TAPI_FieldID_TradeID	 = 26;
      TAPI_FieldID_Digits	 = 27;
      TAPI_FieldID_Open	         = 28;
      TAPI_FieldID_Change	 = 29;
      TAPI_FieldID_High52     	 = 30;
      TAPI_FieldID_Low52         = 31;
      TAPI_FieldID_PE	         = 32;
      TAPI_FieldID_Dividend      = 33;
      TAPI_FieldID_Yield         = 34;
      TAPI_FieldID_IslandBidSize = 35;
      TAPI_FieldID_IslandAskSize = 36;
      TAPI_FieldID_NAV	         = 37;
      TAPI_FieldID_FUND	         = 38;
      TAPI_FieldID_ExchName      = 39;
      TAPI_FieldID_DivDate       = 40;

Const TAPI_Opt_FieldID_Symbol	 = 0;
      TAPI_Opt_FieldID_Name      = 1;
      TAPI_Opt_FieldID_Bid       = 2;
      TAPI_Opt_FieldID_Ask       = 3;
      TAPI_Opt_FieldID_Last	 = 4;
      TAPI_Opt_FieldID_High	 = 5;
      TAPI_Opt_FieldID_Low	 = 6;
      TAPI_Opt_FieldID_PrevClose = 7;
      TAPI_Opt_FieldID_Volume	 = 8;
      TAPI_Opt_FieldID_OpenInt   = 9;
      TAPI_Opt_FieldID_Volatility= 10;
      TAPI_Opt_FieldID_QuoteTime = 12;
      TAPI_Opt_FieldID_Open      = 19;
      TAPI_Opt_FieldID_TimeVal   = 29;
      TAPI_Opt_FieldID_Delta     = 32;
      TAPI_Opt_FieldID_Gamma     = 33;
      TAPI_Opt_FieldID_Theta     = 34;
      TAPI_Opt_FieldID_Vega      = 35;
      TAPI_Opt_FieldID_Rho       = 36;
      
Type      
      TApiAccountInfo = packed record
        ID          : array[0..31] of char;
        Desc        : array[0..63] of char;
        Associated  : LONGBOOL;
        Unified     : LONGBOOL;
        Express     : LONGBOOL;
        OptDirect   : LONGBOOL;
        StkDirect   : LONGBOOL;
        Apex        : LONGBOOL;
        Lev2        : LONGBOOL;
        StkTrading  : LONGBOOL;
        MarTrading  : LONGBOOL;
        OptTrading  : LONGBOOL;
        StrNews     : LONGBOOL;
        Lev1        : LONGBOOL;

        Timeout     : integer;
        NYSEDelayed : LONGBOOL;
        NASDAQDelayed: LONGBOOL;
        OPRADelayed : LONGBOOL;
        AMEXDelayed : LONGBOOL;
        Professional: array[0..3] of char;
        Reserved    : array[1..76] of char;
      end;


//------------------------------------------------------
// TAPIQuote - the record that holds current quote data for the symbol
//------------------------------------------------------
Type  TAPIQuote = packed record
        sSymbol          : array[0..31] of char;
        ChangeFieldMask  : int64;        // indicates which field changed - see TAPI_MASK_XXX constants
        ChangeFieldMask2 : int64;        // more fields - just in case

        fBid            : double;
        fAsk            : double;
        fLast           : double;
        fHigh           : double;
        fLow            : double;
        fPrevClose      : double;
        fOpen           : double;
        fChange         : double;
        fHigh52         : double;       // 52 week high
        fLow52          : double;       // 52 week low

        cTick           : integer;      // the bid tick - ASCII U or D

        nVolume         : int64;
        nBidSize        : integer;
        nAskSize        : integer;
        nLastsize       : integer;

        cBidExch        : integer;      // ASCII value
        cAskExch        : integer;      // ASCII value
        cExchange       : integer;      // ASCII value

        tTradeTime      : integer;
        tQuoteTime      : integer;
        tTradeDate      : integer;
        tQuoteDate      : integer;

        fIslandBid      : double;
        fIslandAsk      : double;
        nIslandVol      : int64;
        nIslandBidSize  : integer;
        nIslandAskSize  : integer;

        sName           : array[0..63] of char;

        bMarginable     : LONGBOOL;
        bShortable      : LONGBOOL;
        fVolatility     : double;
        cTradeID        : integer;      // ASCII value
        nDigits         : integer;
        fPE             : double;

        fDividend       : double;
        fYield          : double;

        fNAV            : double;
        fFund           : double;

        sExchName       : array[0..19] of char;
        sDivDate        : array[0..11] of char;

        nOpenInt        : integer;
        fTimeValue       : double;
        fDelta           : double;
        fGamma           : double;
        fTheta           : double;
        fVega            : double;
        fRho             : double;
        Reserved        : array[1..148] of byte;

      end;

      PAPIQuote = ^TAPIQuote;
      TAPIQuoteArray = array[0..1000] of TAPIQuote;
      PAPIQuoteArray= ^TAPIQuoteArray;
//----------------------------------------------------------
// TAPIPosition - the record describing a single account position
//----------------------------------------------------------
Type  TAPIPosition = packed record
         AccountID      : array[0..31] of char;
         Symbol         : array[0..31] of char;
         SymWithPrefix  : array[0..31] of char;
         Name           : array[0..63] of char;
         AssetType      : integer;         // ASCII: E - Equity or ETF, F - Mutual Fund, I - Index, O - Option, B - Bond
         CUSIP          : array[0..11] of char;
         AccountType    : integer;      // 1 - Cash 2 - Margin 3 - Short 4 - Dividend/Interest
         ClosePrice     : double;
         PositionType   : array[0..11] of char;   // LONG or SHORT
         AveragePrice   : double;
         Quantity       : double;
         Reserved       : array[1..40] of char;
      end;

      TAPIPositionArray = array[0..0] of TAPIPosition;
      PAPIPositionArray = ^TAPIPositionArray;

      TAPIBalances = packed record
        AccountID                  : array[0..31] of char;
        DayTrader                  : LONGBOOL;
        RoundTrips                 : integer;
        ClosingTransactionsOnly    : LONGBOOL;

        InCall,
        InPotentialCall            : LONGBOOL;

        CashBalance,
        CashBalanceChange,
        MoneyMarketBalance,
        MoneyMarketBalanceChange,
        LongStockValue,
        LongStockValueChange,
        LongOptionValue,
        LongOptionValueChange,
        ShortOptionValue,
        ShortOptionValueChange,
        MutualFundValue,
        MutualFundValueChange,
        BondValue,
        BondValueChange,
        AccountValue,
        AccountValueChange,
        PendingDeposits,
        PendingDepositsChange,
        ShortBalance,
        ShortBalanceChange,
        MarginBalance,
        MarginBalanceChange,
        ShortStockValue,
        ShortStockValueChange,
        LongMarginableValue,
        LongMarginableValueChange,
        ShortMarginableValue,
        ShortMarginableValueChange,
        MarginEquity,
        MarginEquityChange,
        EquityPercentage,
        EquityPercentageChange,
        MaintenanceRequirement,
        MaintenanceRequirementChange,
        MaintenanceCallValue,
        MaintenanceCallValueChange,
        RegulationTCallValue,
        RegulationTCallValueChange,
        DayTradingCallValue,
        DayTradingCallValueChange,
        CashDebitCallValue,
        CashDebitCallValueChange,

        CashForWithdrawal,
        UnsettledCash,
        NonMarginableFunds,

        DayEquityCallValue,
        OptionBuyingPower,
        StockBuyingPower,
        DayTradingBuyingPower,
        AvailableFundsForTrading        : double;
        Reserved                        : array[1..40] of double; // just in case
      end;
      PAPIBalances = ^TAPIBalances;

      TAPIActiveRecord = packed record
        Sym                        : array[1..12] of char;
        Exe                        : double;
        Num                        : int64;
      end;                       

      TAPIActives = packed record
        ActivesType                : array[1..16] of char;
        SampleDuration             : integer;
        StartTime                  : array[1..12] of char;
        DisplayTime                : array[1..12] of char;

        ActiveBuyTrades            : array[1..10] of TAPIActiveRecord;
        ActiveSellTRades           : array[1..10] of TAPIActiveRecord;
        ActiveBuyShares            : array[1..10] of TAPIActiveRecord;
        ActiveSellShares           : array[1..10] of TAPIActiveRecord;
        ActiveTrades               : array[1..10] of TAPIActiveRecord;
        ActiveShares               : array[1..10] of TAPIActiveRecord;
      end;
      PAPIActives = ^TAPIActives;  

      TAPIFill = packed record
        AccountID      : array[0..31] of char;
        OrderNumber    : array[0..31] of char;
        ID             : array[0..31] of char;
        Symbol         : array[0..31] of char;
        Action         : array[0..3] of char;    // same as in TAPITransaction
        Qty            : double;
        Price          : double;
        Commission     : double;
        TimeStamp      : array[0..15] of char;  //YYYYMMDDHHMMSS
      end;

      TAPITransaction = packed record
        AccountID               : array[0..31] of char;
        OrderNumber             : array[0..31] of char;
        RootOrderNumber         : array[0..31] of char;
        ParentOrderNumber       : array[0..31] of char;

        Cancelable              : LONGBOOL;
        Editable                : LONGBOOL;
        ComplexOption           : LONGBOOL;
//        SecondaryLeg            : LONGBOOL;
        Enhanced                : LONGBOOL;

        EnhancedOrderType       : array[0..31] of char;
        Relationship            : array[0..31] of char;
        OptionStrategy          : array[0..31] of char;

        OrderType               : array[0..3] of char;    // M - Market L - Limit S - Stop X - Stop Limit D - Debit C - Credit T - Trailing Stop EX - Exercise Option
        Symbol                  : array[0..31] of char;
        SymWithPrefix           : array[0..31] of char;
        SecurityType            : array[0..63] of char; // desrip\tion of security type
                                                        // Common
                                                        // Preferred
                                                        // Convertible Preferred
                                                        // Rights
                                                        // Warrant
                                                        // Units
                                                        // Mutual Fund
                                                        // Limited Partnership
                                                        // Call Option
                                                        // Put Option
                                                        // Bank Call Option
                                                        // Escrow
                                                        // Corporate Bond
                                                        // Convertible Bond
                                                        // Municipal Bond
                                                        // Short Term Paper
                                                        // Bond Unit
                                                        // Municipal Assessment District
                                                        // US Treasury Bill
                                                        // US Treasury Note
                                                        // US Treasury Bond
                                                        // Other Government
                                                        // US Treasury Zero Coupon
                                                        // Government Mortgage
        AssetType               : integer;                // ASCII - E- Equity or ETF,  F - Mutual FUnd, O - Option
        Action                  : array[0..3] of char;    // B - Buy S - Sell SS - Short Sell BC - Buy to Cover E - Exchange EX - Exercise Option
        TradeType               : array[0..3] of char;    // 1 — Normal Market 2 — External Hour Market 4 — German Market 8 — AM Session 16 — Seamless Session
        InitialQuantity         : double;
        RemainingQuantity       : double;
        LimitPrice              : double;
        StopPrice               : double;
        SpecConditions          : array[0..3] of char;    // AON, DNR, FOK

        TIFSession              : array[0..11] of char;   //  GX=GTC+Ext D=Day DX=Day+Ext GTD=GTC
        TIFExpiration           : array[0..11] of char;   // expiration date for YYYYMMDD
        DisplayStatus           : array[0..15] of char;
        RoutingStatus           : array[0..15] of char;
        ReceivedDateTime        : array[0..15] of char;  //YYYYMMDDHHMMSS

        ReportedDateTime        : array[0..15] of char;  //YYYYMMDDHHMMSS
        CancelDateTime          : array[0..15] of char;  //YYYYMMDDHHMMSS

{        CommissionOverride      : double;               // 0 if no override
        AdditionalFee           : double;
        Solicited               : integer;         // ASCII Y or N
        Discretionary           : integer;         // ASCII Y or N }

        DestRoutingMode         : array[0..15] of char;
        DestOptionExchange      : array[0..15] of char;
        DestResponseDescription : array[0..15] of char;

        ActDestRoutingMode      : array[0..15] of char;
        ActDestOptionExchange   : array[0..15] of char;
        ActDestResponseDescription : array[0..15] of char;

        RoutingDisplaySize      : integer;

        NumFills                : integer;
        AverageFillPrice        : double;
        TotalFillCommission     : double;
        LastExecutionDateTime   : array[0..15] of char;  //YYYYMMDDHHMMSS

{        DividendReinvest        : integer;      // ASCII Y - Yes, N - No, O - None
        CapGainsReinvest        : integer;      // ASCII Y - Yes, N - No, O - None
        FundTransactionType     : integer;      // ASCII 3 - Nav }

        PutCall                 : integer;
        OpenClose               : integer;
        TrailingStopMethod      : array[0..7] of char;   // PERCENT or POINTS
        Reserved                : array[1..92] of char;
      end;


      TAPITransactionArray = array[0..0] of TAPITransaction;
      PAPITransactionArray = ^TAPITransactionArray;

      TAPIFillArray = array[0..0] of TAPIFill;
      PAPIFillArray = ^TAPIFillArray;
//------------------------------------------------------
// TAPIBFItem - one backfill item
//------------------------------------------------------
Type  TAPIBFItem = packed record
        Sequence        : integer;      // minutes since 8am Eastern
        fOpen,fHigh,
        fLow,fClose     : double;       // the OHLC values
        nVolume         : integer;      // volume
        Time            : integer;      // # of seconds since midnight
        Date            : integer;      // # of days since 1/1/1970
      end;
      TAPIBFArray = array[0..1000] of TAPIBFItem;
      PAPIBFArray = ^TAPIBFArray;

Type  TAPIHistItem = packed record
        fOpen,fHigh,
        fLow,fClose     : double;       // the OHLC values
        nVolume         : int64;        // volume
        Date            : integer;      // # of days since 1/1/1970
      end;
      TAPIHistArray = array[0..1000] of TAPIHistItem;
      PAPIHistArray = ^TAPIHistArray;

//------------------------------------------------------
// TAPINOIIData
//------------------------------------------------------
Type  TAPINOIIDATA = record
        Typ              : integer;  // ASCII  O Regular Opening Cross
                                     //        I Intra-day Opening for IPO Securities
                                     //        H Intra-day Opening for Halted Securities
                                     //        C Regular Closing Cross
        PairedShares     : integer;
        ImbalanceShares  : integer;
        ImbalanceSide    : integer; // ASCII  B Buy Side Imbalance
                                    //        S Sell Side Imbalance
                                    //        N No Imbalance
                                    //        O No marketable On Open/Close Orders in NASDAQ
        CurrentRefPrice  : double;
        FarIndicative    : double;
        NearIndicative   : double;
        PriceVariance    : integer; //  ASCII L Less than 1%
                                    //        1 1%
                                    //        2 2%
                                    //        3 3%
                                    //        4 4%
                                    //        5 5%
                                    //        6 6%
                                    //        7 7%
                                    //        8 8%
                                    //        9 9%
                                    //        A 10% to 19.99%
                                    //        B 20% to 29.99%
                                    //        C 30% or Greater
                                    //        Space Price Variation Indicator cannot be calculated
      end;
      PAPINOIIData = ^TAPINOIIData;

//------------------------------------------------------
// TAPIL2Record
//------------------------------------------------------

Type  TAPIL2Record = packed record
        MMID   : array[0..3] of char;
        Price  : double;
        Size   : integer;
      end;
      TAPIL2Array = array[0..0] of TAPIL2Record;
      PAPIL2Array = ^TAPIl2Array;

Type  TAPILIIRecord = packed record
        MMID     : array[0..3] of char;
        Price    : double;
        Size     : integer;
        TimeStamp: integer;
      end;
      TAPILIIArray = array[0..0] of TAPILIIRecord;
      PAPILIIArray = ^TAPILIIArray;


//------------------------------------------------------
// TAPIOptionRecord - the option record
//------------------------------------------------------
Type  TAPIOptionRecord = packed record
        Symbol          : array[0..7] of char;
        CallPut         : array[0..3] of char;  // C or P
        ExpDate         : array[0..11] of char;
        ExpDays         : integer;
        ExpType         : array[0..3] of char;  // L or R
        Strike          : double;
        OptType         : array[0..3] of char;  // ST or NS
      end;
      TAPIOptionArray = array[0..0] of TAPIOptionRecord;
      PAPIOptionArray = ^TAPIOptionArray;

//------------------------------------------------------
//------------------------------------------------------
// TAPINewsHistItem - the news history item
//------------------------------------------------------
Type  TAPINewsItem = packed record
        HeadlineID      : array[0..23] of char;
        Headline        : array[0..255] of char;
        Timestamp       : integer; // # of seconds since 1/1/1970 in GMT
        Source          : array[0..31] of char;
        URL             : array[0..511] of char;
      end;
      TAPINewsArray = array[0..0] of TAPINewsItem;
      PAPINewsArray = ^TAPINewsArray;
//------------------------------------------------------
// TDAAPIStreamStatus - the status of the TDAAPI thread
//------------------------------------------------------
Const   API_STREAMSTATUS_Idle                           = 1;
        API_STREAMSTATUS_LoggingIn                      = 2;
        API_STREAMSTATUS_LoginFailed                    = 3;
        API_STREAMSTATUS_LoggedIn                       = 4;
        API_STREAMSTATUS_StartedMainRequest             = 5;
        API_STREAMSTATUS_Running                        = 6;
        API_STREAMSTATUS_ConnectionDied                 = 7;
        API_STREAMSTATUS_ChunkTimeOut                   = 8;
        API_STREAMSTATUS_SystemTemporarilyUnavailable   = 9;
        API_STREAMSTATUS_LogoutFailed                   = 10;
        API_STREAMSTATUS_LoggedOut                      = 11;
        API_STREAMSTATUS_KeepAliveValid                 = 12;
        API_STREAMSTATUS_KeepAliveInvalid               = 13;

Const  TDAAPIErrorStatus: Set of byte = [API_STREAMSTATUS_LoginFailed,
                                         API_STREAMSTATUS_ConnectionDied,
                                         API_STREAMSTATUS_ChunkTimeOut,
                                         API_STREAMSTATUS_SystemTemporarilyUnavailable];

//=======================================================================================
// the set of callback events that the TTDAAPI control calls. These callbacks
// will always be called in the context of the main thread (wrapped in Synchronize).
//=======================================================================================
Type
     // the event that is called when control's status changes
     TAPIStatusChangeEvent = procedure(OType,OPtr:integer; OldStatus,NewStatus:integer);stdcall;

     // the event that is called every time some data is received - H is "G" for valid data, 'Y' for intermediate stage and 'R' for errors
     TAPIPingEvent         = procedure(OType,OPtr:integer; H:char);stdcall;

     // the event that is called every time some message is received - M is the message
     TAPIGotMessageEvent   = procedure(OType,OPtr:integer; const M:PChar);stdcall;

     // the event that is called every time Last Order Status is received - LOS is the Last Order Status
     TAPIGotLastOrderStatusEvent   = procedure(OType,OPtr:integer; const Acc:PChar; const LOS:PChar);stdcall;

     // the event that is called every time PandL is figured out
     TAPIGotPandL = procedure(OType,OPtr:integer; const Acc:PChar; PandL,RealizedPandL,UnrealizedPandL:double);stdcall;

     // the event that is called when order ack received from Ameritrade
     TAPIOrderAckEvent   = procedure(OType,OPtr:integer; const AckType:PChar; const AckStr:PChar);stdcall;

     // the event that is called every time an L1 quote is received - Sym is the symbol for which the quote
     // is and Quote is the quote record - with ChangeFieldMask containing the flags for fields that changed
     TAPIL1DataEvent       = procedure(OType,OPtr:integer; Quote:TAPIQuote);stdcall;

     // the event that is called every time an L1 quote is received - Sym is the symbol for which the quote
     // is and Quote is the pointer to quote record - with ChangeFieldMask containing the flags for fields that changed
     TAPIL1PtrDataEvent    = procedure(OType,OPtr:integer; Quote:PAPIQuote);stdcall;

     // the event that is called every time an actives array is received - Sym is the symbol for which the actives
     // record and Act is the record
     TAPIActivesDataEvent  = procedure(OType,OPtr:integer; const Sym:PChar;Act:TAPIActives);stdcall;

     // the event that is called every time an actives array is received - Sym is the symbol for which the actives
     // record and Act is the record
     TAPIActivesDataPtrEvent  = procedure(OType,OPtr:integer; const Sym:PChar;Act:PAPIActives);stdcall;

     // the event that is called every time new L2 book is received - Sym is the symbol for which the quote
     // is
     TAPIL2DataEvent       = procedure(OType,OPtr:integer; const Sym:PChar;NumBidRows,NumBids,NumAskRows,NumAsks:integer;Bids,Asks:PAPIL2Array);stdcall;

     // the event that is called every time new L2 book is received - Sym is the symbol for which the quote
     // is
     TAPITVL2DataEvent     = procedure(OType,OPtr:integer; const Sym:PChar;NumBids,NumAsks:integer;Bids,Asks:PAPILIIArray;NOII:PAPINOIIData);stdcall;

     // the event that is called every time position data is received
     TAPIGotPositionsEvent = procedure(OType,OPtr:integer; Tot:integer; Ptr: PAPIPositionArray);stdcall;

     // the event that is called every time order status data is received
     TAPIGotTransactionEvent = procedure(OType,OPtr:integer; TotOrders:integer; OrdersPtr: PAPITransactionArray; TotFills:integer; FillsPtr: PAPIFillArray);stdcall;

     // the event that is called every time position data is received
     TAPIGotBalancesEvent  = procedure(OType,OPtr:integer; B: TAPIBalances);stdcall;

     // the event that is called every time position data is received
     TAPIGotBalancesPtrEvent  = procedure(OType,OPtr:integer; B: PAPIBalances);stdcall;

     // the event that is called every time backfill is received and parsed
     TAPIGotBackfillEvent = procedure(OType,OPtr:integer; const Sym:PChar; Tot:integer; Ptr: PAPIBFArray; const Err:PChar);stdcall;

     // the event that is called every time historical backfill is received and parsed
     TAPIGotHistBackfillEvent = procedure(OType,OPtr:integer; const Sym:PChar; Tot:integer; Ptr: PAPIHistArray; const Err:PChar);stdcall;

     TAPIGotSnapQuoteEvent = procedure(OType,OPtr:integer; Ptr: PAPIQuote); stdcall;

     // the event that is called every time news history is received and parsed
     TAPIGotNewsEvent = procedure(OType,OPtr:integer; const Sym:PChar; Tot:integer; Ptr: PAPINewsArray; const Err:PChar);stdcall;

     TAPIGotChainEvent = procedure(OType,OPtr:integer; const Sym: PChar; Tot:integer; Ptr: PAPIOptionArray); stdcall;



implementation

initialization
end.
