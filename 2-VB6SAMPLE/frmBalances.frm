VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Object = "{D40AA7D1-3B85-4ADA-97A9-8100A22F47AE}#1.0#0"; "tdaactx.ocx"
Begin VB.Form frmBalances 
   Caption         =   "Balances"
   ClientHeight    =   7380
   ClientLeft      =   6915
   ClientTop       =   5805
   ClientWidth     =   5010
   LinkTopic       =   "Form1"
   ScaleHeight     =   7380
   ScaleWidth      =   5010
   Begin tdaactx.TDAAPIComm TDAC 
      Height          =   345
      Left            =   4650
      TabIndex        =   3
      Top             =   390
      Width           =   315
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
      LogFile         =   "c:\TDALOG.LOG"
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Refresh P&&L"
      Height          =   330
      Left            =   30
      TabIndex        =   12
      Top             =   450
      Width           =   1740
   End
   Begin VB.Frame Frame1 
      Caption         =   "P&&L"
      Height          =   975
      Left            =   1860
      TabIndex        =   5
      Top             =   360
      Width           =   2700
      Begin VB.Label UnrealizedPL 
         Caption         =   "-"
         Height          =   165
         Left            =   1035
         TabIndex        =   11
         Top             =   705
         Width           =   1350
      End
      Begin VB.Label RealizedPL 
         Caption         =   "-"
         Height          =   165
         Left            =   1035
         TabIndex        =   10
         Top             =   435
         Width           =   1350
      End
      Begin VB.Label TotalPL 
         Caption         =   "-"
         Height          =   165
         Left            =   1035
         TabIndex        =   9
         Top             =   165
         Width           =   1350
      End
      Begin VB.Label Label2 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Unrealized"
         Height          =   195
         Index           =   2
         Left            =   135
         TabIndex        =   8
         Top             =   705
         Width           =   750
      End
      Begin VB.Label Label2 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Realized"
         Height          =   195
         Index           =   1
         Left            =   270
         TabIndex        =   7
         Top             =   435
         Width           =   615
      End
      Begin VB.Label Label2 
         Alignment       =   1  'Right Justify
         AutoSize        =   -1  'True
         Caption         =   "Total"
         Height          =   195
         Index           =   0
         Left            =   525
         TabIndex        =   6
         Top             =   165
         Width           =   360
      End
   End
   Begin VB.ComboBox cmbAcc 
      Height          =   315
      Left            =   855
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   30
      Width           =   4110
   End
   Begin VB.CommandButton pbSub 
      Caption         =   "Refresh Balances"
      Height          =   330
      Left            =   30
      TabIndex        =   2
      Top             =   825
      Width           =   1740
   End
   Begin MSFlexGridLib.MSFlexGrid TransGrid 
      CausesValidation=   0   'False
      Height          =   5985
      Left            =   30
      TabIndex        =   1
      Top             =   1380
      Width           =   4965
      _ExtentX        =   8758
      _ExtentY        =   10557
      _Version        =   393216
      ScrollTrack     =   -1  'True
      FocusRect       =   0
      AllowUserResizing=   1
      Appearance      =   0
   End
   Begin VB.Label Label1 
      Caption         =   "Account"
      Height          =   210
      Left            =   120
      TabIndex        =   4
      Top             =   60
      Width           =   660
   End
End
Attribute VB_Name = "frmBalances"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Dim S As String
Dim I As Integer

  If cmbAcc.ListCount > 0 Then
    S = cmbAcc.List(cmbAcc.ListIndex)
    I = InStr(S, " ")
    If I > 0 Then S = Left(S, I - 1)
  End If
   
  TDAC.RequestPandL (S)

End Sub

Private Sub Form_Resize()
 
  If Width - 110 > 0 Then TransGrid.Width = Width - 110
  If Height - TransGrid.Top - 420 > 0 Then TransGrid.Height = Height - TransGrid.Top - 420
  TransGrid.ColWidth(0) = Width / 2
  If Width / 2 - 380 > 0 Then TransGrid.ColWidth(1) = Width / 2 - 380
  TransGrid.Cols = 2
  
End Sub


Private Sub Form_Load()
Dim I As Integer

  TransGrid.TextArray(0) = "Date/Time"
  TransGrid.TextArray(1) = "Value"
    
  For I = 0 To TDAC.NumAccounts - 1
    cmbAcc.AddItem TDAC.AccountID(I) + " " + TDAC.AccountDesc(I)
  Next I
  If TDAC.NumAccounts > 0 Then
     cmbAcc.ListIndex = 0
  End If
  
End Sub

Private Sub pbSub_Click()
Dim S As String
Dim I As Integer

  If cmbAcc.ListCount > 0 Then
    S = cmbAcc.List(cmbAcc.ListIndex)
    I = InStr(S, " ")
    If I > 0 Then S = Left(S, I - 1)
  End If
   
  TDAC.RequestBalancesAndPositions (S)
End Sub

Private Sub TDAC_OnBalancesChange(ByVal Bal As tdaactx.ITDABalances)
   TransGrid.Rows = 57
   TransGrid.TextMatrix(1, 0) = "AccountID"
   TransGrid.TextMatrix(1, 1) = Bal.AccountID
   TransGrid.TextMatrix(2, 0) = "DayTrader"
   TransGrid.TextMatrix(2, 1) = Bal.DayTrader
   TransGrid.TextMatrix(3, 0) = "RoundTrips"
   TransGrid.TextMatrix(3, 1) = Bal.RoundTrips
   TransGrid.TextMatrix(4, 0) = "ClosingTransactionsOnly"
   TransGrid.TextMatrix(4, 1) = Bal.ClosingTransactionsOnly
   TransGrid.TextMatrix(5, 0) = "InCall"
   TransGrid.TextMatrix(5, 1) = Bal.InCall
   TransGrid.TextMatrix(6, 0) = "InPotentialCall"
   TransGrid.TextMatrix(6, 1) = Bal.InPotentialCall
   TransGrid.TextMatrix(7, 0) = "CashBalance"
   TransGrid.TextMatrix(7, 1) = Bal.CashBalance
   TransGrid.TextMatrix(8, 0) = "CashBalanceChange"
   TransGrid.TextMatrix(8, 1) = Bal.CashBalanceChange
   TransGrid.TextMatrix(9, 0) = "MoneyMarketBalance"
   TransGrid.TextMatrix(9, 1) = MoneyMarketBalance
   TransGrid.TextMatrix(10, 0) = "MoneyMarketBalanceChange"
   TransGrid.TextMatrix(10, 1) = Bal.MoneyMarketBalanceChange
   TransGrid.TextMatrix(11, 0) = "LongStockValue"
   TransGrid.TextMatrix(11, 1) = Bal.LongStockValue
   TransGrid.TextMatrix(12, 0) = "LongStockValueChange"
   TransGrid.TextMatrix(12, 1) = Bal.LongStockValueChange
   TransGrid.TextMatrix(13, 0) = "LongOptionValue"
   TransGrid.TextMatrix(13, 1) = Bal.LongOptionValue
   TransGrid.TextMatrix(14, 0) = "LongOptionValueChange"
   TransGrid.TextMatrix(14, 1) = Bal.LongOptionValueChange
   TransGrid.TextMatrix(15, 0) = "ShortOptionValue"
   TransGrid.TextMatrix(15, 1) = Bal.ShortOptionValue
   TransGrid.TextMatrix(16, 0) = "ShortOptionValueChange"
   TransGrid.TextMatrix(16, 1) = Bal.ShortOptionValueChange
   TransGrid.TextMatrix(17, 0) = "MutualFundValue"
   TransGrid.TextMatrix(17, 1) = Bal.MutualFundValue
   TransGrid.TextMatrix(18, 0) = "MutualFundValueChange"
   TransGrid.TextMatrix(18, 1) = Bal.MutualFundValueChange
   TransGrid.TextMatrix(19, 0) = "BondValue"
   TransGrid.TextMatrix(19, 1) = Bal.BondValue
   TransGrid.TextMatrix(20, 0) = "BondValueChange"
   TransGrid.TextMatrix(20, 1) = Bal.BondValueChange
   TransGrid.TextMatrix(21, 0) = "AccountValue"
   TransGrid.TextMatrix(21, 1) = Bal.AccountValue
   TransGrid.TextMatrix(22, 0) = "AccountValueChange"
   TransGrid.TextMatrix(22, 1) = Bal.AccountValueChange
   TransGrid.TextMatrix(23, 0) = "PendingDeposits"
   TransGrid.TextMatrix(23, 1) = Bal.PendingDeposits
   TransGrid.TextMatrix(24, 0) = "PendingDepositsChange"
   TransGrid.TextMatrix(24, 1) = Bal.PendingDepositsChange
   TransGrid.TextMatrix(25, 0) = "ShortBalance"
   TransGrid.TextMatrix(25, 1) = Bal.ShortBalance
   TransGrid.TextMatrix(26, 0) = "ShortBalanceChange"
   TransGrid.TextMatrix(26, 1) = Bal.ShortBalanceChange
   TransGrid.TextMatrix(27, 0) = "MarginBalance"
   TransGrid.TextMatrix(27, 1) = Bal.MarginBalance
   TransGrid.TextMatrix(28, 0) = "MarginBalanceChange"
   TransGrid.TextMatrix(28, 1) = Bal.MarginBalanceChange
   TransGrid.TextMatrix(29, 0) = "ShortStockValue"
   TransGrid.TextMatrix(29, 1) = Bal.ShortStockValue
   TransGrid.TextMatrix(30, 0) = "ShortStockValueChange"
   TransGrid.TextMatrix(30, 1) = Bal.ShortStockValueChange
   TransGrid.TextMatrix(31, 0) = "LongMarginableValue"
   TransGrid.TextMatrix(31, 1) = Bal.LongMarginableValue
   TransGrid.TextMatrix(32, 0) = "LongMarginableValueChange"
   TransGrid.TextMatrix(32, 1) = Bal.LongMarginableValueChange
   TransGrid.TextMatrix(33, 0) = "ShortMarginableValue"
   TransGrid.TextMatrix(33, 1) = Bal.ShortMarginableValue
   TransGrid.TextMatrix(34, 0) = "ShortMarginableValueChange"
   TransGrid.TextMatrix(34, 1) = Bal.ShortMarginableValueChange
   TransGrid.TextMatrix(35, 0) = "MarginEquity"
   TransGrid.TextMatrix(35, 1) = Bal.MarginEquity
   TransGrid.TextMatrix(36, 0) = "MarginEquityChange"
   TransGrid.TextMatrix(36, 1) = Bal.MarginEquityChange
   TransGrid.TextMatrix(37, 0) = "EquityPercentage"
   TransGrid.TextMatrix(37, 1) = Bal.EquityPercentage
   TransGrid.TextMatrix(38, 0) = "EquityPercentageChange"
   TransGrid.TextMatrix(38, 1) = Bal.EquityPercentageChange
   TransGrid.TextMatrix(39, 0) = "MaintenanceRequirement"
   TransGrid.TextMatrix(39, 1) = Bal.MaintenanceRequirement
   TransGrid.TextMatrix(40, 0) = "MaintenanceRequirementChange"
   TransGrid.TextMatrix(40, 1) = Bal.MaintenanceRequirementChange
   TransGrid.TextMatrix(41, 0) = "MaintenanceCallValue"
   TransGrid.TextMatrix(41, 1) = Bal.MaintenanceCallValue
   TransGrid.TextMatrix(42, 0) = "MaintenanceCallValueChange"
   TransGrid.TextMatrix(42, 1) = Bal.MaintenanceCallValueChange
   TransGrid.TextMatrix(43, 0) = "RegulationTCallValue"
   TransGrid.TextMatrix(43, 1) = Bal.RegulationTCallValue
   TransGrid.TextMatrix(44, 0) = "RegulationTCallValueChange"
   TransGrid.TextMatrix(44, 1) = Bal.RegulationTCallValueChange
   TransGrid.TextMatrix(45, 0) = "DayTradingCallValue"
   TransGrid.TextMatrix(45, 1) = Bal.DayTradingCallValue
   TransGrid.TextMatrix(46, 0) = "DayTradingCallValueChange"
   TransGrid.TextMatrix(46, 1) = Bal.DayTradingCallValueChange
   TransGrid.TextMatrix(47, 0) = "CashDebitCallValue"
   TransGrid.TextMatrix(47, 1) = Bal.CashDebitCallValue
   TransGrid.TextMatrix(48, 0) = "CashDebitCallValueChange"
   TransGrid.TextMatrix(48, 1) = Bal.CashDebitCallValueChange
   TransGrid.TextMatrix(49, 0) = "CashForWithdrawal"
   TransGrid.TextMatrix(49, 1) = Bal.CashForWithdrawal
   TransGrid.TextMatrix(50, 0) = "UnsettledCash"
   TransGrid.TextMatrix(50, 1) = Bal.UnsettledCash
   TransGrid.TextMatrix(51, 0) = "NonMarginableFunds"
   TransGrid.TextMatrix(51, 1) = Bal.NonMarginableFunds
   TransGrid.TextMatrix(52, 0) = "DayEquityCallValue"
   TransGrid.TextMatrix(52, 1) = Bal.DayEquityCallValue
   TransGrid.TextMatrix(53, 0) = "OptionBuyingPower"
   TransGrid.TextMatrix(53, 1) = Bal.OptionBuyingPower
   TransGrid.TextMatrix(54, 0) = "StockBuyingPower"
   TransGrid.TextMatrix(54, 1) = Bal.StockBuyingPower
   TransGrid.TextMatrix(55, 0) = "DayTradingBuyingPower"
   TransGrid.TextMatrix(55, 1) = Bal.DayTradingBuyingPower
   TransGrid.TextMatrix(56, 0) = "AvailableFundsForTrading"
   TransGrid.TextMatrix(56, 1) = Bal.AvailableFundsForTrading
  

End Sub

Private Sub TDAC_OnPandL(ByVal Account As String, ByVal PandL As Double, ByVal RealizedPandL As Double, ByVal UnrealizedPandL As Double)
   TotalPL.Caption = PandL
   RealizedPL.Caption = RealizedPandL
   UnrealizedPL.Caption = UnrealizedPandL
   
End Sub

