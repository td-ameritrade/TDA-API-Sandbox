VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Object = "{D40AA7D1-3B85-4ADA-97A9-8100A22F47AE}#1.0#0"; "tdaactx.ocx"
Begin VB.Form frmAccHist 
   Caption         =   "Form1"
   ClientHeight    =   6870
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8775
   LinkTopic       =   "Form1"
   ScaleHeight     =   6870
   ScaleWidth      =   8775
   StartUpPosition =   3  'Windows Default
   Begin tdaactx.TDAAPIComm TDAC 
      Height          =   315
      Left            =   7110
      TabIndex        =   0
      Top             =   0
      Width           =   345
      Object.Visible         =   -1  'True
      Color           =   -2147483633
      Enabled         =   -1  'True
      LogLevel        =   0
      SourceApp       =   "ACTX"
      LoginSite       =   "apis.tdameritrade.com"
      StreamingSite   =   ""
      ProxyURL        =   ""
      ProxyURLSSL     =   ""
      ProxyLoginName  =   ""
      ProxyLoginPass  =   ""
      ProxyPort       =   80
      ProxyPortSSL    =   80
      ProxyUseSocks   =   0   'False
      LogFile         =   "c:\TDALOG.LOG"
   End
   Begin VB.ComboBox cmbType 
      Height          =   315
      ItemData        =   "frmAccHist.frx":0000
      Left            =   765
      List            =   "frmAccHist.frx":001F
      Style           =   2  'Dropdown List
      TabIndex        =   9
      Top             =   525
      Width           =   1470
   End
   Begin VB.TextBox dfFrom 
      Height          =   285
      Left            =   2865
      MaxLength       =   10
      TabIndex        =   6
      Top             =   525
      Width           =   1110
   End
   Begin VB.TextBox dfTo 
      Height          =   285
      Left            =   4380
      MaxLength       =   10
      TabIndex        =   5
      Top             =   525
      Width           =   1110
   End
   Begin VB.CommandButton pbSub 
      Caption         =   "Get History"
      Height          =   330
      Left            =   7500
      TabIndex        =   2
      Top             =   -30
      Width           =   1065
   End
   Begin VB.ComboBox cmbAcc 
      Height          =   315
      Left            =   750
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   30
      Width           =   6255
   End
   Begin MSFlexGridLib.MSFlexGrid TransGrid 
      CausesValidation=   0   'False
      Height          =   5760
      Left            =   0
      TabIndex        =   3
      Top             =   1035
      Width           =   8565
      _ExtentX        =   15108
      _ExtentY        =   10160
      _Version        =   393216
      Cols            =   43
      ScrollTrack     =   -1  'True
      FocusRect       =   0
      AllowUserResizing=   1
      Appearance      =   0
   End
   Begin VB.Label Label2 
      Caption         =   "(dates are in yyyymmdd format)"
      Height          =   195
      Left            =   5640
      TabIndex        =   11
      Top             =   585
      Width           =   2910
   End
   Begin VB.Label Label5 
      Caption         =   "Type"
      Height          =   195
      Left            =   210
      TabIndex        =   10
      Top             =   585
      Width           =   420
   End
   Begin VB.Label Label3 
      Caption         =   "From"
      Height          =   195
      Left            =   2430
      TabIndex        =   8
      Top             =   570
      Width           =   510
   End
   Begin VB.Label Label4 
      Caption         =   "To"
      Height          =   195
      Left            =   4110
      TabIndex        =   7
      Top             =   555
      Width           =   225
   End
   Begin VB.Label Label1 
      Caption         =   "Account"
      Height          =   210
      Left            =   15
      TabIndex        =   4
      Top             =   60
      Width           =   660
   End
End
Attribute VB_Name = "frmAccHist"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
Dim I As Integer

  TransGrid.TextArray(0) = "Property"
  TransGrid.TextArray(1) = "Value"
    
  For I = 0 To TDAC.NumAccounts - 1
    cmbAcc.AddItem TDAC.AccountID(I) + " " + TDAC.AccountDesc(I)
  Next I
  If TDAC.NumAccounts > 0 Then
     cmbAcc.ListIndex = 0
  End If
  
    TransGrid.Cols = 32
    TransGrid.Rows = 2
    TransGrid.TextArray(0) = "DateTime"
    TransGrid.TextArray(1) = "RecordType"
    TransGrid.TextArray(2) = "SubType"
    TransGrid.TextArray(3) = "BuySellCode"
    TransGrid.TextArray(4) = "AssetType"
    TransGrid.TextArray(5) = "Symbol"
    TransGrid.TextArray(6) = "Desc"
    TransGrid.TextArray(7) = "CUSIP"
    TransGrid.TextArray(8) = "Price"
    TransGrid.TextArray(9) = "Quantity"
    TransGrid.TextArray(10) = "TransValue"
    TransGrid.TextArray(11) = "Commission"
    TransGrid.TextArray(12) = "Fees"
    TransGrid.TextArray(13) = "AdtnlFees"
    TransGrid.TextArray(14) = "CashBalEff"
    TransGrid.TextArray(15) = "TransactionID"
    TransGrid.TextArray(16) = "OrderNumber"
    TransGrid.TextArray(17) = "OpenClose"
    TransGrid.TextArray(18) = "OptionExpiration"
    TransGrid.TextArray(19) = "OptionUnderlying"
    TransGrid.TextArray(20) = "OptionType"
    TransGrid.TextArray(21) = "OptionStrike"
    TransGrid.TextArray(22) = "AccruedInterest"
    TransGrid.TextArray(23) = "ParentChild"
    TransGrid.TextArray(24) = "SharesBefore"
    TransGrid.TextArray(25) = "SharesAfter"
    TransGrid.TextArray(26) = "OtherCharges"
    TransGrid.TextArray(27) = "RedemptionFee"
    TransGrid.TextArray(28) = "cdscFee"
    TransGrid.TextArray(29) = "BondInterestRate"
    TransGrid.TextArray(30) = "BondMaturityDate"
    TransGrid.TextArray(31) = "SplitRatio"

End Sub

Private Sub Form_Resize()
  If Width - 110 > 0 Then TransGrid.Width = Width - 110
  If Height - TransGrid.Top - 420 > 0 Then TransGrid.Height = Height - TransGrid.Top - 420
End Sub

Private Sub pbSub_Click()
Dim S As String
Dim S1 As String
Dim I As Integer

  If cmbAcc.ListCount > 0 Then
    S = cmbAcc.List(cmbAcc.ListIndex)
    I = InStr(S, " ")
    If I > 0 Then S = Left(S, I - 1)
  End If
  If cmbType.ListCount > 0 Then
    S1 = cmbType.List(cmbType.ListIndex)
    I = InStr(S1, " ")
    If I > 0 Then S1 = Left(S1, I - 1)
  End If
   
  TDAC.RequestAccountHistory S, S1, dfFrom.Text, dfTo.Text, ""
  
End Sub

Private Sub TDAC_OnAccountHistory(ByVal Error As String, ByVal History As tdaactx.ITDAAccountHistory)
  If Error = "" Then
    TransGrid.Rows = History.Count + 1
    For I = 0 To History.Count - 1
     TransGrid.TextMatrix(I + 1, 0) = History.DateTime(I)
     TransGrid.TextMatrix(I + 1, 1) = History.RecordType(I)
     TransGrid.TextMatrix(I + 1, 2) = History.SubType(I)
     TransGrid.TextMatrix(I + 1, 3) = History.BuySellCode(I)
     TransGrid.TextMatrix(I + 1, 4) = History.AssetType(I)
     TransGrid.TextMatrix(I + 1, 5) = History.Symbol(I)
     TransGrid.TextMatrix(I + 1, 6) = History.Description(I)
     TransGrid.TextMatrix(I + 1, 7) = History.CUSIP(I)
     TransGrid.TextMatrix(I + 1, 8) = History.Price(I)
     TransGrid.TextMatrix(I + 1, 9) = History.Quantity(I)
     TransGrid.TextMatrix(I + 1, 10) = History.TransactionValue(I)
     TransGrid.TextMatrix(I + 1, 11) = History.Commission(I)
     TransGrid.TextMatrix(I + 1, 12) = History.Fees(I)
     TransGrid.TextMatrix(I + 1, 13) = History.AdditionalFees(I)
     TransGrid.TextMatrix(I + 1, 14) = History.CashBalanceEffect(I)
     TransGrid.TextMatrix(I + 1, 15) = History.TransactionID(I)
     TransGrid.TextMatrix(I + 1, 16) = History.OrderNumber(I)
     TransGrid.TextMatrix(I + 1, 17) = History.OpenClose(I)
     TransGrid.TextMatrix(I + 1, 18) = History.OptionExpiration(I)
     TransGrid.TextMatrix(I + 1, 19) = History.OptionUnderlying(I)
     TransGrid.TextMatrix(I + 1, 20) = History.OptionType(I)
     TransGrid.TextMatrix(I + 1, 21) = History.OptionStrike(I)
     TransGrid.TextMatrix(I + 1, 22) = History.AccruedInterest(I)
     TransGrid.TextMatrix(I + 1, 23) = History.ParentChild(I)
     TransGrid.TextMatrix(I + 1, 24) = History.SharesBefore(I)
     TransGrid.TextMatrix(I + 1, 25) = History.SharesAfter(I)
     TransGrid.TextMatrix(I + 1, 26) = History.OtherCharges(I)
     TransGrid.TextMatrix(I + 1, 27) = History.RedemptionFee(I)
     TransGrid.TextMatrix(I + 1, 28) = History.cdscFee(I)
     TransGrid.TextMatrix(I + 1, 29) = History.BondInterestRate(I)
     TransGrid.TextMatrix(I + 1, 30) = History.BondMaturityDate(I)
     TransGrid.TextMatrix(I + 1, 31) = History.SplitRatio(I)


    Next I
    
  End If
End Sub

