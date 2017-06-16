VERSION 5.00
Object = "{D40AA7D1-3B85-4ADA-97A9-8100A22F47AE}#1.0#0"; "tdaactx.ocx"
Begin VB.Form frmL1 
   Caption         =   "Level 1 Stream"
   ClientHeight    =   5070
   ClientLeft      =   11700
   ClientTop       =   1950
   ClientWidth     =   6300
   LinkTopic       =   "Form1"
   ScaleHeight     =   5070
   ScaleWidth      =   6300
   Begin tdaactx.TDAAPIComm TDAC 
      Height          =   345
      Left            =   3960
      TabIndex        =   83
      Top             =   105
      Width           =   375
      Object.Visible         =   -1  'True
      Color           =   -2147483633
      Enabled         =   -1  'True
      LogLevel        =   -1
      SourceApp       =   "ACTX"
      LoginSite       =   "apis.tdameritrade.com"
      StreamingSite   =   "newtoy.streamer.com"
      ProxyURL        =   ""
      ProxyURLSSL     =   ""
      ProxyLoginName  =   ""
      ProxyLoginPass  =   "80"
      ProxyPort       =   80
      ProxyPortSSL    =   80
      ProxyUseSocks   =   0   'False
      LogFile         =   "TDALOG.LOG"
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Snapshot Quote"
      Height          =   330
      Left            =   4635
      TabIndex        =   84
      Top             =   105
      Width           =   1470
   End
   Begin VB.CommandButton pbSub 
      Caption         =   "Subscribe"
      Height          =   330
      Left            =   2670
      TabIndex        =   2
      Top             =   120
      Width           =   1065
   End
   Begin VB.TextBox dfSym 
      Height          =   300
      Left            =   1260
      TabIndex        =   0
      Top             =   120
      Width           =   1200
   End
   Begin VB.Label Label83 
      AutoSize        =   -1  'True
      Caption         =   "Marginable"
      Height          =   195
      Left            =   4485
      TabIndex        =   82
      Top             =   1095
      Width           =   780
   End
   Begin VB.Label lMarginable 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   5415
      TabIndex        =   81
      Top             =   1095
      Width           =   135
   End
   Begin VB.Label Label81 
      AutoSize        =   -1  'True
      Caption         =   "Shortable"
      Height          =   195
      Left            =   4590
      TabIndex        =   80
      Top             =   1365
      Width           =   675
   End
   Begin VB.Label lShortable 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   5415
      TabIndex        =   79
      Top             =   1365
      Width           =   135
   End
   Begin VB.Label Label79 
      AutoSize        =   -1  'True
      Caption         =   "Volatility"
      Height          =   195
      Left            =   4695
      TabIndex        =   78
      Top             =   1650
      Width           =   570
   End
   Begin VB.Label lVolatility 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   5415
      TabIndex        =   77
      Top             =   1650
      Width           =   135
   End
   Begin VB.Label Label77 
      AutoSize        =   -1  'True
      Caption         =   "Trade ID"
      Height          =   195
      Left            =   4635
      TabIndex        =   76
      Top             =   1935
      Width           =   630
   End
   Begin VB.Label lTradeID 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   5415
      TabIndex        =   75
      Top             =   1935
      Width           =   135
   End
   Begin VB.Label Label75 
      AutoSize        =   -1  'True
      Caption         =   "Digits"
      Height          =   195
      Left            =   4875
      TabIndex        =   74
      Top             =   2220
      Width           =   390
   End
   Begin VB.Label lDigits 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   5415
      TabIndex        =   73
      Top             =   2220
      Width           =   135
   End
   Begin VB.Label Label73 
      AutoSize        =   -1  'True
      Caption         =   "PE"
      Height          =   195
      Left            =   5055
      TabIndex        =   72
      Top             =   2490
      Width           =   210
   End
   Begin VB.Label lPE 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   5415
      TabIndex        =   71
      Top             =   2490
      Width           =   135
   End
   Begin VB.Label Label71 
      AutoSize        =   -1  'True
      Caption         =   "Dividend"
      Height          =   195
      Left            =   4635
      TabIndex        =   70
      Top             =   2775
      Width           =   630
   End
   Begin VB.Label lDividend 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   5415
      TabIndex        =   69
      Top             =   2775
      Width           =   135
   End
   Begin VB.Label Label69 
      AutoSize        =   -1  'True
      Caption         =   "Yield"
      Height          =   195
      Left            =   4920
      TabIndex        =   68
      Top             =   3060
      Width           =   345
   End
   Begin VB.Label lYield 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   5415
      TabIndex        =   67
      Top             =   3060
      Width           =   135
   End
   Begin VB.Label Label67 
      AutoSize        =   -1  'True
      Caption         =   "NAV"
      Height          =   195
      Left            =   4935
      TabIndex        =   66
      Top             =   3345
      Width           =   330
   End
   Begin VB.Label lNAV 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   5415
      TabIndex        =   65
      Top             =   3345
      Width           =   135
   End
   Begin VB.Label Label65 
      AutoSize        =   -1  'True
      Caption         =   "Fund"
      Height          =   195
      Left            =   4905
      TabIndex        =   64
      Top             =   3615
      Width           =   360
   End
   Begin VB.Label lFund 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   5415
      TabIndex        =   63
      Top             =   3615
      Width           =   135
   End
   Begin VB.Label Label63 
      AutoSize        =   -1  'True
      Caption         =   "Exchange Name"
      Height          =   195
      Left            =   4080
      TabIndex        =   62
      Top             =   3900
      Width           =   1185
   End
   Begin VB.Label lExchName 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   5415
      TabIndex        =   61
      Top             =   3900
      Width           =   135
   End
   Begin VB.Label Label61 
      AutoSize        =   -1  'True
      Caption         =   "Dividend Date"
      Height          =   195
      Left            =   4245
      TabIndex        =   60
      Top             =   4185
      Width           =   1020
   End
   Begin VB.Label lDivDate 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   5415
      TabIndex        =   59
      Top             =   4185
      Width           =   135
   End
   Begin VB.Label Label57 
      AutoSize        =   -1  'True
      Caption         =   "Name"
      Height          =   195
      Left            =   2700
      TabIndex        =   58
      Top             =   705
      Width           =   420
   End
   Begin VB.Label lName 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3225
      TabIndex        =   57
      Top             =   675
      Width           =   135
   End
   Begin VB.Label Label55 
      AutoSize        =   -1  'True
      Caption         =   "Tick"
      Height          =   195
      Left            =   2805
      TabIndex        =   56
      Top             =   990
      Width           =   315
   End
   Begin VB.Label lTick 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3225
      TabIndex        =   55
      Top             =   990
      Width           =   135
   End
   Begin VB.Label Label53 
      AutoSize        =   -1  'True
      Caption         =   "Bid Exchange"
      Height          =   195
      Left            =   2130
      TabIndex        =   54
      Top             =   1260
      Width           =   990
   End
   Begin VB.Label lBidExch 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3225
      TabIndex        =   53
      Top             =   1260
      Width           =   135
   End
   Begin VB.Label Label51 
      AutoSize        =   -1  'True
      Caption         =   "Ask Exchange"
      Height          =   195
      Left            =   2085
      TabIndex        =   52
      Top             =   1545
      Width           =   1035
   End
   Begin VB.Label lAskExch 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3225
      TabIndex        =   51
      Top             =   1545
      Width           =   135
   End
   Begin VB.Label Label49 
      AutoSize        =   -1  'True
      Caption         =   "Exchange"
      Height          =   195
      Left            =   2400
      TabIndex        =   50
      Top             =   1830
      Width           =   720
   End
   Begin VB.Label lExch 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3225
      TabIndex        =   49
      Top             =   1830
      Width           =   135
   End
   Begin VB.Label Label47 
      AutoSize        =   -1  'True
      Caption         =   "Trade Time"
      Height          =   195
      Left            =   2310
      TabIndex        =   48
      Top             =   2295
      Width           =   810
   End
   Begin VB.Label lTradeTime 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3225
      TabIndex        =   47
      Top             =   2295
      Width           =   135
   End
   Begin VB.Label Label45 
      AutoSize        =   -1  'True
      Caption         =   "Trade Date"
      Height          =   195
      Left            =   2310
      TabIndex        =   46
      Top             =   2565
      Width           =   810
   End
   Begin VB.Label lTradeDate 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3225
      TabIndex        =   45
      Top             =   2565
      Width           =   135
   End
   Begin VB.Label Label43 
      AutoSize        =   -1  'True
      Caption         =   "Quote Time"
      Height          =   195
      Left            =   2295
      TabIndex        =   44
      Top             =   2850
      Width           =   825
   End
   Begin VB.Label lQuoteTime 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3225
      TabIndex        =   43
      Top             =   2850
      Width           =   135
   End
   Begin VB.Label Label41 
      AutoSize        =   -1  'True
      Caption         =   "Quote Date"
      Height          =   195
      Left            =   2295
      TabIndex        =   42
      Top             =   3135
      Width           =   825
   End
   Begin VB.Label lQuoteDate 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3225
      TabIndex        =   41
      Top             =   3135
      Width           =   135
   End
   Begin VB.Label Label39 
      AutoSize        =   -1  'True
      Caption         =   "Island Bid"
      Height          =   195
      Left            =   2430
      TabIndex        =   40
      Top             =   3615
      Width           =   690
   End
   Begin VB.Label lIslandBid 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3225
      TabIndex        =   39
      Top             =   3615
      Width           =   135
   End
   Begin VB.Label Label37 
      AutoSize        =   -1  'True
      Caption         =   "Island Ask"
      Height          =   195
      Left            =   2385
      TabIndex        =   38
      Top             =   3885
      Width           =   735
   End
   Begin VB.Label lIslandAsk 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3225
      TabIndex        =   37
      Top             =   3885
      Width           =   135
   End
   Begin VB.Label Label35 
      AutoSize        =   -1  'True
      Caption         =   "Island Vol"
      Height          =   195
      Left            =   2430
      TabIndex        =   36
      Top             =   4170
      Width           =   690
   End
   Begin VB.Label lIslandVol 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3225
      TabIndex        =   35
      Top             =   4170
      Width           =   135
   End
   Begin VB.Label Label33 
      AutoSize        =   -1  'True
      Caption         =   "Island Bid Size"
      Height          =   195
      Left            =   2085
      TabIndex        =   34
      Top             =   4455
      Width           =   1035
   End
   Begin VB.Label lIslandBidSize 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3225
      TabIndex        =   33
      Top             =   4455
      Width           =   135
   End
   Begin VB.Label Label31 
      AutoSize        =   -1  'True
      Caption         =   "Island Ask Size"
      Height          =   195
      Left            =   2040
      TabIndex        =   32
      Top             =   4740
      Width           =   1080
   End
   Begin VB.Label lIslandAskSize 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3225
      TabIndex        =   31
      Top             =   4740
      Width           =   135
   End
   Begin VB.Label lLastSize 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1200
      TabIndex        =   30
      Top             =   4515
      Width           =   135
   End
   Begin VB.Label Label28 
      AutoSize        =   -1  'True
      Caption         =   "Last Size"
      Height          =   195
      Left            =   465
      TabIndex        =   29
      Top             =   4515
      Width           =   645
   End
   Begin VB.Label lAskSize 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1200
      TabIndex        =   28
      Top             =   4230
      Width           =   135
   End
   Begin VB.Label Label26 
      AutoSize        =   -1  'True
      Caption         =   "Ask Size"
      Height          =   195
      Left            =   495
      TabIndex        =   27
      Top             =   4230
      Width           =   615
   End
   Begin VB.Label lBidSize 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1200
      TabIndex        =   26
      Top             =   3945
      Width           =   135
   End
   Begin VB.Label Label24 
      AutoSize        =   -1  'True
      Caption         =   "Bid Size"
      Height          =   195
      Left            =   540
      TabIndex        =   25
      Top             =   3945
      Width           =   570
   End
   Begin VB.Label lVolume 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1185
      TabIndex        =   24
      Top             =   3660
      Width           =   135
   End
   Begin VB.Label Label22 
      AutoSize        =   -1  'True
      Caption         =   "Volume"
      Height          =   195
      Left            =   585
      TabIndex        =   23
      Top             =   3660
      Width           =   525
   End
   Begin VB.Label l52Low 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1200
      TabIndex        =   22
      Top             =   3240
      Width           =   135
   End
   Begin VB.Label Label20 
      AutoSize        =   -1  'True
      Caption         =   "52 Week Low"
      Height          =   195
      Left            =   105
      TabIndex        =   21
      Top             =   3240
      Width           =   1005
   End
   Begin VB.Label l52High 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1200
      TabIndex        =   20
      Top             =   2955
      Width           =   135
   End
   Begin VB.Label Label18 
      AutoSize        =   -1  'True
      Caption         =   "52 Week High"
      Height          =   195
      Left            =   75
      TabIndex        =   19
      Top             =   2955
      Width           =   1035
   End
   Begin VB.Label lChange 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1200
      TabIndex        =   18
      Top             =   2670
      Width           =   135
   End
   Begin VB.Label Label16 
      AutoSize        =   -1  'True
      Caption         =   "Change"
      Height          =   195
      Left            =   555
      TabIndex        =   17
      Top             =   2670
      Width           =   555
   End
   Begin VB.Label lOpen 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1200
      TabIndex        =   16
      Top             =   2385
      Width           =   135
   End
   Begin VB.Label Label14 
      AutoSize        =   -1  'True
      Caption         =   "Open"
      Height          =   195
      Left            =   720
      TabIndex        =   15
      Top             =   2385
      Width           =   390
   End
   Begin VB.Label lPrevClose 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1200
      TabIndex        =   14
      Top             =   2115
      Width           =   135
   End
   Begin VB.Label Label12 
      AutoSize        =   -1  'True
      Caption         =   "Prev. Close"
      Height          =   195
      Left            =   300
      TabIndex        =   13
      Top             =   2115
      Width           =   810
   End
   Begin VB.Label lLow 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1200
      TabIndex        =   12
      Top             =   1830
      Width           =   135
   End
   Begin VB.Label Label10 
      AutoSize        =   -1  'True
      Caption         =   "Low"
      Height          =   195
      Left            =   810
      TabIndex        =   11
      Top             =   1830
      Width           =   300
   End
   Begin VB.Label lHigh 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1200
      TabIndex        =   10
      Top             =   1545
      Width           =   135
   End
   Begin VB.Label Label8 
      AutoSize        =   -1  'True
      Caption         =   "High"
      Height          =   195
      Left            =   780
      TabIndex        =   9
      Top             =   1545
      Width           =   330
   End
   Begin VB.Label lLast 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1200
      TabIndex        =   8
      Top             =   1260
      Width           =   135
   End
   Begin VB.Label Label6 
      AutoSize        =   -1  'True
      Caption         =   "Last"
      Height          =   195
      Left            =   810
      TabIndex        =   7
      Top             =   1260
      Width           =   300
   End
   Begin VB.Label lAsk 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1200
      TabIndex        =   6
      Top             =   990
      Width           =   135
   End
   Begin VB.Label Label4 
      AutoSize        =   -1  'True
      Caption         =   "Ask"
      Height          =   195
      Left            =   840
      TabIndex        =   5
      Top             =   990
      Width           =   270
   End
   Begin VB.Label lBid 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1200
      TabIndex        =   4
      Top             =   675
      Width           =   135
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "Bid"
      Height          =   255
      Left            =   855
      TabIndex        =   3
      Top             =   705
      Width           =   255
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Symbol"
      Height          =   195
      Index           =   0
      Left            =   585
      TabIndex        =   1
      Top             =   165
      Width           =   510
   End
End
Attribute VB_Name = "frmL1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Command1_Click()
  TDAC.RequestSnapshotQuotes (dfSym.Text)
End Sub

Private Sub Form_Unload(Cancel As Integer)
  TDAC.UnsubscribeAll

  
End Sub


Private Sub pbSub_Click()
  TDAC.UnsubscribeAll
  Res = TDAC.Subscribe(dfSym.Text, TDAPI_SUB_L1)

End Sub


Private Sub TDAC_OnL1Quote(ByVal Quote As tdaactx.ITDAL1Quote)
            lBid.Caption = Quote.Bid

            lAsk.Caption = Quote.Ask

            lLast.Caption = Quote.Last

            lHigh.Caption = Quote.High

            lLow.Caption = Quote.Low

            lPrevClose.Caption = Quote.PrevClose

            lOpen.Caption = Quote.Open

            lChange.Caption = Quote.Change

            l52High.Caption = Quote.High52

            l52Low.Caption = Quote.Low52

            lVolume.Caption = Quote.Volume

            lBidSize.Caption = Quote.BidSize

            lAskSize.Caption = Quote.AskSize

            lLastSize.Caption = Quote.LastSize

            lName.Caption = Quote.FullName

            lTick.Caption = Chr(Quote.Tick)

            lBidExch.Caption = Chr(Quote.BidExchange)

            lAskExch.Caption = Chr(Quote.AskExchange)

            lExch.Caption = Chr(Quote.Exchange)

            L = Quote.TradeTime
            lTradeTime.Caption = Format(L / (24 * 60 * 60#), "hh:mm:ss")

            L = Quote.QuoteTime
            lQuoteTime.Caption = Format(L / (24 * 60 * 60#), "hh:mm:ss")

            L = Quote.TradeDate + CDate("1/1/1970")
            lTradeDate.Caption = Format(L, "MM/dd/yyyy")

            L = Quote.QuoteDate + CDate("1/1/1970")
            lTradeDate.Caption = Format(L, "MM/dd/yyyy")

            lIslandBid.Caption = Quote.IslandBid

            lIslandAsk.Caption = Quote.IslandAsk
            lIslandBidSize.Caption = Quote.IslandBidSize
            lIslandAskSize.Caption = Quote.IslandAskSize

            lIslandVol.Caption = Quote.IslandVolume

            If Quote.Marginable Then lMarginable.Caption = "Y" Else lMarginable.Caption = "N"
            If Quote.Shortable Then lShortable.Caption = "Y" Else lShortable.Caption = "N"

            lVolatility.Caption = Quote.Volatility
            lTradeID.Caption = Chr(Quote.TradeID)
        
        lDigits.Caption = Quote.Digits
        
        lPE.Caption = Quote.PE
        
        lDividend.Caption = Quote.Dividend
        
        lYield.Caption = Quote.Yield
        
        lNAV.Caption = Quote.NAV
        
        lFund.Caption = Quote.Fund
              
        lExchName.Caption = Quote.ExchangeName
                
        lDivDate.Caption = Quote.DividendDate
End Sub

Private Sub TDAC_OnSnapQuote(ByVal Quote As tdaactx.ITDAL1Quote)
            lBid.Caption = Quote.Bid

            lAsk.Caption = Quote.Ask

            lLast.Caption = Quote.Last

            lHigh.Caption = Quote.High

            lLow.Caption = Quote.Low

            lPrevClose.Caption = Quote.PrevClose

            lOpen.Caption = Quote.Open

            lChange.Caption = Quote.Change

            l52High.Caption = Quote.High52

            l52Low.Caption = Quote.Low52

            lVolume.Caption = Quote.Volume

            lBidSize.Caption = Quote.BidSize

            lAskSize.Caption = Quote.AskSize

            lLastSize.Caption = Quote.LastSize

            lName.Caption = Quote.FullName

            lTick.Caption = Chr(Quote.Tick)

            lBidExch.Caption = Chr(Quote.BidExchange)

            lAskExch.Caption = Chr(Quote.AskExchange)

            lExch.Caption = Chr(Quote.Exchange)

            L = Quote.TradeTime
            lTradeTime.Caption = Format(L / (24 * 60 * 60#), "hh:mm:ss")

            L = Quote.QuoteTime
            lQuoteTime.Caption = Format(L / (24 * 60 * 60#), "hh:mm:ss")

            L = Quote.TradeDate + CDate("1/1/1970")
            lTradeDate.Caption = Format(L, "MM/dd/yyyy")

            L = Quote.QuoteDate + CDate("1/1/1970")
            lTradeDate.Caption = Format(L, "MM/dd/yyyy")

            lIslandBid.Caption = Quote.IslandBid

            lIslandAsk.Caption = Quote.IslandAsk
            lIslandBidSize.Caption = Quote.IslandBidSize
            lIslandAskSize.Caption = Quote.IslandAskSize

            lIslandVol.Caption = Quote.IslandVolume

            If Quote.Marginable Then lMarginable.Caption = "Y" Else lMarginable.Caption = "N"
            If Quote.Shortable Then lShortable.Caption = "Y" Else lShortable.Caption = "N"

            lVolatility.Caption = Quote.Volatility
            lTradeID.Caption = Chr(Quote.TradeID)
        
        lDigits.Caption = Quote.Digits
        
        lPE.Caption = Quote.PE
        
        lDividend.Caption = Quote.Dividend
        
        lYield.Caption = Quote.Yield
        
        lNAV.Caption = Quote.NAV
        
        lFund.Caption = Quote.Fund
              
        lExchName.Caption = Quote.ExchangeName
                
        lDivDate.Caption = Quote.DividendDate
End Sub
