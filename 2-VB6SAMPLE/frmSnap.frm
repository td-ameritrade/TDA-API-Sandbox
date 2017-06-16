VERSION 5.00
Object = "{D40AA7D1-3B85-4ADA-97A9-8100A22F47AE}#1.0#0"; "tdaactx.ocx"
Begin VB.Form frmSnap 
   Caption         =   "Snap Quote"
   ClientHeight    =   5070
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5895
   LinkTopic       =   "Form1"
   ScaleHeight     =   5070
   ScaleWidth      =   5895
   StartUpPosition =   3  'Windows Default
   Begin tdaactx.TDAAPIComm TDAC 
      Height          =   345
      Left            =   3975
      TabIndex        =   0
      Top             =   45
      Width           =   375
      Object.Visible         =   -1  'True
      Color           =   -2147483633
      Enabled         =   -1  'True
      LogLevel        =   0
      SourceApp       =   "ACTX"
      LoginSite       =   "apis.tdameritrade.com"
      StreamingSite   =   "204.58.27.34"
      ProxyURL        =   ""
      ProxyURLSSL     =   ""
      ProxyLoginName  =   ""
      ProxyLoginPass  =   ""
      ProxyPort       =   80
      ProxyPortSSL    =   80
      ProxyUseSocks   =   0   'False
      LogFile         =   "TDALOG.LOG"
   End
   Begin VB.TextBox dfSym 
      Height          =   300
      Left            =   1290
      TabIndex        =   2
      Top             =   60
      Width           =   1200
   End
   Begin VB.CommandButton pbSub 
      Caption         =   "Get Quote"
      Height          =   330
      Left            =   2700
      TabIndex        =   1
      Top             =   60
      Width           =   1065
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Symbol"
      Height          =   195
      Index           =   0
      Left            =   615
      TabIndex        =   39
      Top             =   105
      Width           =   510
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      Caption         =   "Bid"
      Height          =   255
      Left            =   885
      TabIndex        =   38
      Top             =   645
      Width           =   255
   End
   Begin VB.Label lBid 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1230
      TabIndex        =   37
      Top             =   615
      Width           =   135
   End
   Begin VB.Label Label4 
      AutoSize        =   -1  'True
      Caption         =   "Ask"
      Height          =   195
      Left            =   870
      TabIndex        =   36
      Top             =   930
      Width           =   270
   End
   Begin VB.Label lAsk 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1230
      TabIndex        =   35
      Top             =   930
      Width           =   135
   End
   Begin VB.Label Label6 
      AutoSize        =   -1  'True
      Caption         =   "Last"
      Height          =   195
      Left            =   840
      TabIndex        =   34
      Top             =   1200
      Width           =   300
   End
   Begin VB.Label lLast 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1230
      TabIndex        =   33
      Top             =   1200
      Width           =   135
   End
   Begin VB.Label Label8 
      AutoSize        =   -1  'True
      Caption         =   "High"
      Height          =   195
      Left            =   810
      TabIndex        =   32
      Top             =   1485
      Width           =   330
   End
   Begin VB.Label lHigh 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1230
      TabIndex        =   31
      Top             =   1485
      Width           =   135
   End
   Begin VB.Label Label10 
      AutoSize        =   -1  'True
      Caption         =   "Low"
      Height          =   195
      Left            =   840
      TabIndex        =   30
      Top             =   1770
      Width           =   300
   End
   Begin VB.Label lLow 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1230
      TabIndex        =   29
      Top             =   1770
      Width           =   135
   End
   Begin VB.Label Label12 
      AutoSize        =   -1  'True
      Caption         =   "Prev. Close"
      Height          =   195
      Left            =   330
      TabIndex        =   28
      Top             =   2055
      Width           =   810
   End
   Begin VB.Label lPrevClose 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1230
      TabIndex        =   27
      Top             =   2055
      Width           =   135
   End
   Begin VB.Label Label14 
      AutoSize        =   -1  'True
      Caption         =   "Open"
      Height          =   195
      Left            =   750
      TabIndex        =   26
      Top             =   2325
      Width           =   390
   End
   Begin VB.Label lOpen 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1230
      TabIndex        =   25
      Top             =   2325
      Width           =   135
   End
   Begin VB.Label Label16 
      AutoSize        =   -1  'True
      Caption         =   "Change"
      Height          =   195
      Left            =   585
      TabIndex        =   24
      Top             =   2610
      Width           =   555
   End
   Begin VB.Label lChange 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1230
      TabIndex        =   23
      Top             =   2610
      Width           =   135
   End
   Begin VB.Label Label18 
      AutoSize        =   -1  'True
      Caption         =   "52 Week High"
      Height          =   195
      Left            =   105
      TabIndex        =   22
      Top             =   2895
      Width           =   1035
   End
   Begin VB.Label l52High 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1230
      TabIndex        =   21
      Top             =   2895
      Width           =   135
   End
   Begin VB.Label Label20 
      AutoSize        =   -1  'True
      Caption         =   "52 Week Low"
      Height          =   195
      Left            =   135
      TabIndex        =   20
      Top             =   3180
      Width           =   1005
   End
   Begin VB.Label l52Low 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1230
      TabIndex        =   19
      Top             =   3180
      Width           =   135
   End
   Begin VB.Label Label22 
      AutoSize        =   -1  'True
      Caption         =   "Volume"
      Height          =   195
      Left            =   615
      TabIndex        =   18
      Top             =   3600
      Width           =   525
   End
   Begin VB.Label lVolume 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1215
      TabIndex        =   17
      Top             =   3600
      Width           =   135
   End
   Begin VB.Label Label24 
      AutoSize        =   -1  'True
      Caption         =   "Bid Size"
      Height          =   195
      Left            =   570
      TabIndex        =   16
      Top             =   3885
      Width           =   570
   End
   Begin VB.Label lBidSize 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1230
      TabIndex        =   15
      Top             =   3885
      Width           =   135
   End
   Begin VB.Label Label26 
      AutoSize        =   -1  'True
      Caption         =   "Ask Size"
      Height          =   195
      Left            =   525
      TabIndex        =   14
      Top             =   4170
      Width           =   615
   End
   Begin VB.Label lAskSize 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1230
      TabIndex        =   13
      Top             =   4170
      Width           =   135
   End
   Begin VB.Label Label28 
      AutoSize        =   -1  'True
      Caption         =   "Last Size"
      Height          =   195
      Left            =   495
      TabIndex        =   12
      Top             =   4455
      Width           =   645
   End
   Begin VB.Label lLastSize 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   1230
      TabIndex        =   11
      Top             =   4455
      Width           =   135
   End
   Begin VB.Label lTradeDate 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3255
      TabIndex        =   10
      Top             =   2505
      Width           =   135
   End
   Begin VB.Label Label45 
      AutoSize        =   -1  'True
      Caption         =   "Trade Date"
      Height          =   195
      Left            =   2340
      TabIndex        =   9
      Top             =   2505
      Width           =   810
   End
   Begin VB.Label lTradeTime 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3255
      TabIndex        =   8
      Top             =   2235
      Width           =   135
   End
   Begin VB.Label Label47 
      AutoSize        =   -1  'True
      Caption         =   "Trade Time"
      Height          =   195
      Left            =   2340
      TabIndex        =   7
      Top             =   2235
      Width           =   810
   End
   Begin VB.Label lName 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   3255
      TabIndex        =   6
      Top             =   615
      Width           =   135
   End
   Begin VB.Label Label57 
      AutoSize        =   -1  'True
      Caption         =   "Name"
      Height          =   195
      Left            =   2730
      TabIndex        =   5
      Top             =   645
      Width           =   420
   End
   Begin VB.Label lNAV 
      AutoSize        =   -1  'True
      Caption         =   "---"
      Height          =   195
      Left            =   5445
      TabIndex        =   4
      Top             =   3285
      Width           =   135
   End
   Begin VB.Label Label67 
      AutoSize        =   -1  'True
      Caption         =   "NAV"
      Height          =   195
      Left            =   4965
      TabIndex        =   3
      Top             =   3285
      Width           =   330
   End
End
Attribute VB_Name = "frmSnap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub pbSub_Click()
   TDAC.RequestSnapshotQuotes (dfSym.Text)
   
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

            L = Quote.TradeTime
            lTradeTime.Caption = Format(L / (24 * 60 * 60#), "hh:mm:ss")

            L = Quote.TradeDate + CDate("1/1/1970")
            lTradeDate.Caption = Format(L, "MM/dd/yyyy")

        
        lNAV.Caption = Quote.NAV

End Sub
