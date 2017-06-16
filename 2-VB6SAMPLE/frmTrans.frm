VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Object = "{D40AA7D1-3B85-4ADA-97A9-8100A22F47AE}#1.0#0"; "tdaactx.ocx"
Begin VB.Form frmTrans 
   Caption         =   "Transactions"
   ClientHeight    =   8370
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8895
   LinkTopic       =   "Form1"
   ScaleHeight     =   8370
   ScaleWidth      =   8895
   StartUpPosition =   3  'Windows Default
   Begin tdaactx.TDAAPIComm TDAC 
      Height          =   390
      Left            =   7005
      TabIndex        =   4
      Top             =   45
      Width           =   390
      Object.Visible         =   -1  'True
      Color           =   -2147483633
      Enabled         =   -1  'True
      LogLevel        =   100
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
   Begin VB.CommandButton Command3 
      Caption         =   "Liquidate"
      Height          =   315
      Left            =   7485
      TabIndex        =   13
      Top             =   465
      Width           =   1080
   End
   Begin VB.TextBox Text1 
      Height          =   1905
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   12
      Top             =   6225
      Width           =   8670
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Subscribe to MessageKey"
      Height          =   420
      Left            =   7500
      TabIndex        =   11
      Top             =   5670
      Width           =   1080
   End
   Begin VB.TextBox dfMsgKey 
      Height          =   345
      Left            =   1155
      TabIndex        =   10
      Text            =   "Text1"
      Top             =   5715
      Width           =   6240
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Get MessageKey"
      Height          =   495
      Left            =   45
      TabIndex        =   9
      Top             =   5670
      Width           =   1065
   End
   Begin VB.TextBox dfExtra 
      Height          =   285
      Left            =   720
      TabIndex        =   8
      Top             =   450
      Width           =   6240
   End
   Begin VB.ComboBox cmbAcc 
      Height          =   315
      Left            =   720
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   45
      Width           =   6255
   End
   Begin MSFlexGridLib.MSFlexGrid TransGrid 
      CausesValidation=   0   'False
      Height          =   2835
      Left            =   0
      TabIndex        =   1
      Top             =   840
      Width           =   8565
      _ExtentX        =   15108
      _ExtentY        =   5001
      _Version        =   393216
      Cols            =   43
      ScrollTrack     =   -1  'True
      FocusRect       =   0
      AllowUserResizing=   1
      Appearance      =   0
   End
   Begin VB.CommandButton pbSub 
      Caption         =   "Refresh"
      Height          =   330
      Left            =   7470
      TabIndex        =   0
      Top             =   45
      Width           =   1065
   End
   Begin MSFlexGridLib.MSFlexGrid FillGrid 
      CausesValidation=   0   'False
      Height          =   1590
      Left            =   15
      TabIndex        =   5
      Top             =   3990
      Width           =   8565
      _ExtentX        =   15108
      _ExtentY        =   2805
      _Version        =   393216
      Cols            =   6
      ScrollTrack     =   -1  'True
      FocusRect       =   0
      AllowUserResizing=   1
      Appearance      =   0
   End
   Begin VB.Label Label2 
      Caption         =   "Extra"
      Height          =   210
      Left            =   180
      TabIndex        =   7
      Top             =   480
      Width           =   405
   End
   Begin VB.Label lbFills 
      Caption         =   "List of Fills"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   0
      TabIndex        =   6
      Top             =   3750
      Width           =   2640
   End
   Begin VB.Label Label1 
      Caption         =   "Account"
      Height          =   210
      Left            =   45
      TabIndex        =   3
      Top             =   90
      Width           =   660
   End
End
Attribute VB_Name = "frmTrans"
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
   
  TDAC.RequestMessageKey S

End Sub

Private Sub Command2_Click()
  TDAC.Subscribe dfMsgKey.Text, TDAPI_SUB_ACCTMSGS
  
End Sub

Private Sub Command3_Click()
Dim S As String
Dim I As Integer

  If cmbAcc.ListCount > 0 Then
    S = cmbAcc.List(cmbAcc.ListIndex)
    I = InStr(S, " ")
    If I > 0 Then S = Left(S, I - 1)
  End If
   
  TDAC.Liquidate S, "E"
  
End Sub

Private Sub Form_Load()
Dim I As Integer

  Text1.Text = ""
  
  For I = 0 To TDAC.NumAccounts - 1
    cmbAcc.AddItem TDAC.AccountID(I) + " " + TDAC.AccountDesc(I)
  Next I
  If TDAC.NumAccounts > 0 Then
     cmbAcc.ListIndex = 0
  End If
     
    For I = 0 To 42
      TransGrid.ColWidth(I) = 1200
    Next I
    TransGrid.TextArray(0) = "OrderNumber"
    TransGrid.TextArray(1) = "RootOrderNumber"
    TransGrid.TextArray(2) = "ParentOrderNumber"
    TransGrid.TextArray(3) = "Cancelable"
    TransGrid.TextArray(4) = "Editable"
    TransGrid.TextArray(5) = "ComplexOption"
    TransGrid.TextArray(6) = "Enhanced"
    TransGrid.TextArray(7) = "EnhancedOrderType"
    TransGrid.TextArray(8) = "Relationship"
    TransGrid.TextArray(9) = "OptionStrategy"
    TransGrid.TextArray(10) = "OrderType"
    TransGrid.TextArray(11) = "Symbol"
    TransGrid.TextArray(12) = "SymWithPrefix"
    TransGrid.TextArray(13) = "SecurityType"
    TransGrid.TextArray(14) = "AssetType"
    TransGrid.TextArray(15) = "Action"
    TransGrid.TextArray(16) = "TradeType"
    TransGrid.TextArray(17) = "InitialQuantity"
    TransGrid.TextArray(18) = "RemainingQuantity"
    TransGrid.TextArray(19) = "LimitPrice"
    TransGrid.TextArray(20) = "StopPrice"
    TransGrid.TextArray(21) = "SpecConditions"
    TransGrid.TextArray(22) = "TIFSession"
    TransGrid.TextArray(23) = "TIFExpiration"
    TransGrid.TextArray(24) = "DisplayStatus"
    TransGrid.TextArray(25) = "RoutingStatus"
    TransGrid.TextArray(26) = "ReceivedDateTime"
    TransGrid.TextArray(27) = "ReportedDateTime"
    TransGrid.TextArray(28) = "CancelDateTime"
    TransGrid.TextArray(29) = "DestRoutingMode"
    TransGrid.TextArray(30) = "DestOptionExchange"
    TransGrid.TextArray(31) = "DestResponseDescription"
    TransGrid.TextArray(32) = "ActDestRoutingMode"
    TransGrid.TextArray(33) = "ActDestOptionExchange"
    TransGrid.TextArray(34) = "ActDestResponseDescription"
    TransGrid.TextArray(35) = "RoutingDisplaySize"
    TransGrid.TextArray(36) = "NumFills"
    TransGrid.TextArray(37) = "AverageFillPrice"
    TransGrid.TextArray(38) = "TotalFillCommission"
    TransGrid.TextArray(39) = "LastExecutionDateTime"
    TransGrid.TextArray(40) = "PutCall"
    TransGrid.TextArray(41) = "OpenClose"
    TransGrid.TextArray(42) = "TrailingStopMethod"

    
    For I = 0 To 4
      FillGrid.ColWidth(I) = 1200
    Next I
    FillGrid.TextArray(0) = "OrderNumber"
    FillGrid.TextArray(1) = "FillID"
    FillGrid.TextArray(2) = "Quantity"
    FillGrid.TextArray(3) = "Price"
    FillGrid.TextArray(4) = "Commission"
    FillGrid.TextArray(5) = "TimeStamp"
    FillGrid.Rows = 1
    
  
End Sub

Private Sub Form_Resize()
  If Width - 110 > 0 Then TransGrid.Width = Width - 110
  If lbFills.Top - TransGrid.Top > 0 Then TransGrid.Height = lbFills.Top - TransGrid.Top
  FillGrid.Width = TransGrid.Width
  FillGrid.Left = TransGrid.Left
  
End Sub

Private Sub pbSub_Click()
Dim S As String
Dim I As Integer

  If cmbAcc.ListCount > 0 Then
    S = cmbAcc.List(cmbAcc.ListIndex)
    I = InStr(S, " ")
    If I > 0 Then S = Left(S, I - 1)
  End If
   
  TDAC.RequestTransactions S, Trim(dfExtra.Text)
End Sub


Private Sub vbalGrid1_ColumnClick(ByVal lCol As Long)

End Sub


Private Sub TDAC_OnAccountMessage(ByVal MessageKey As String, ByVal Message As tdaactx.ITDAAccountMessage)
  Text1.Text = Text1.Text + Chr(10) + Chr(13) + Message.MessageType + " " + MessageKey + " " + AccountID
End Sub

Private Sub TDAC_OnMessageKey(ByVal ReqAccount As String, ByVal MessageKey As String)
   dfMsgKey.Text = MessageKey
   
End Sub

Private Sub TDAC_OnTransactionsChange(ByVal Transactions As tdaactx.ITDATransactions, ByVal Fills As tdaactx.ITDAFills)
Dim I As Integer
Dim J As Integer
Dim S As String
 
 TransGrid.Rows = Transactions.Count + 1
 FillGrid.Rows = 1
 
 For I = 0 To Transactions.Count - 1
   S = Transactions.Action(I)
   If S = "S" Then S = "Sell" Else
   If S = "B" Then S = "Buy" Else
   If S = "SS" Then S = "Short" Else
   If S = "BC" Then S = "Buy to Cover" Else
   If S = "E" Then S = "Exchange" Else
   If S = "EX" Then S = "Exercise"

   For J = 0 To Fills.Count(Transactions.OrderNumber(I)) - 1
     FillGrid.Rows = FillGrid.Rows + 1
     FillGrid.TextMatrix(FillGrid.Rows - 1, 0) = Transactions.OrderNumber(I)
     FillGrid.TextMatrix(FillGrid.Rows - 1, 1) = Fills.FillID(Transactions.OrderNumber(I), J)
     FillGrid.TextMatrix(FillGrid.Rows - 1, 2) = Fills.Quantity(Transactions.OrderNumber(I), J)
     FillGrid.TextMatrix(FillGrid.Rows - 1, 3) = Fills.Price(Transactions.OrderNumber(I), J)
     FillGrid.TextMatrix(FillGrid.Rows - 1, 4) = Fills.Commission(Transactions.OrderNumber(I), J)
     FillGrid.TextMatrix(FillGrid.Rows - 1, 5) = Fills.TimeStamp(Transactions.OrderNumber(I), J)
   Next J

       TransGrid.TextMatrix(I + 1, 0) = Transactions.OrderNumber(I)
       TransGrid.TextMatrix(I + 1, 1) = Transactions.RootOrderNumber(I)
       TransGrid.TextMatrix(I + 1, 2) = Transactions.ParentOrderNumber(I)
       TransGrid.TextMatrix(I + 1, 3) = Transactions.Cancelable(I)
       TransGrid.TextMatrix(I + 1, 4) = Transactions.Editable(I)
       TransGrid.TextMatrix(I + 1, 5) = Transactions.ComplexOption(I)
       TransGrid.TextMatrix(I + 1, 6) = Transactions.Enhanced(I)
       TransGrid.TextMatrix(I + 1, 7) = Transactions.EnhancedOrderType(I)
       TransGrid.TextMatrix(I + 1, 8) = Transactions.Relationship(I)
       TransGrid.TextMatrix(I + 1, 9) = Transactions.OptionStrategy(I)
       TransGrid.TextMatrix(I + 1, 10) = Transactions.OrderType(I)
       TransGrid.TextMatrix(I + 1, 11) = Transactions.Symbol(I)
       TransGrid.TextMatrix(I + 1, 12) = Transactions.SymbolWithPrefix(I)
       TransGrid.TextMatrix(I + 1, 13) = Transactions.SecurityType(I)
       TransGrid.TextMatrix(I + 1, 14) = Transactions.AssetType(I)
       TransGrid.TextMatrix(I + 1, 15) = S
       TransGrid.TextMatrix(I + 1, 16) = Transactions.TradeType(I)
       TransGrid.TextMatrix(I + 1, 17) = Transactions.InitialQuantity(I)
       TransGrid.TextMatrix(I + 1, 18) = Transactions.RemainingQuantity(I)
       TransGrid.TextMatrix(I + 1, 19) = Transactions.LimitPrice(I)
       TransGrid.TextMatrix(I + 1, 20) = Transactions.StopPrice(I)
       TransGrid.TextMatrix(I + 1, 21) = Transactions.SpecialConditions(I)
       TransGrid.TextMatrix(I + 1, 22) = Transactions.TIFSession(I)
       TransGrid.TextMatrix(I + 1, 23) = Transactions.TIFExpiration(I)
       TransGrid.TextMatrix(I + 1, 24) = Transactions.DisplayStatus(I)
       TransGrid.TextMatrix(I + 1, 25) = Transactions.RoutingStatus(I)
       TransGrid.TextMatrix(I + 1, 26) = Transactions.ReceivedDateTime(I)
       TransGrid.TextMatrix(I + 1, 27) = Transactions.ReportedDateTime(I)
       TransGrid.TextMatrix(I + 1, 28) = Transactions.CancelDateTime(I)
       TransGrid.TextMatrix(I + 1, 29) = Transactions.DestRoutingMode(I)
       TransGrid.TextMatrix(I + 1, 30) = Transactions.DestOptionExchange(I)
       TransGrid.TextMatrix(I + 1, 31) = Transactions.DestResponseDescription(I)
       TransGrid.TextMatrix(I + 1, 32) = Transactions.ActDestRoutingMode(I)
       TransGrid.TextMatrix(I + 1, 33) = Transactions.ActDestOptionExchange(I)
       TransGrid.TextMatrix(I + 1, 34) = Transactions.ActDestResponseDescription(I)
       TransGrid.TextMatrix(I + 1, 35) = Transactions.RoutingDisplaySize(I)
       TransGrid.TextMatrix(I + 1, 36) = Transactions.NumberFills(I)
       TransGrid.TextMatrix(I + 1, 37) = Transactions.AverageFillPrice(I)
       TransGrid.TextMatrix(I + 1, 38) = Transactions.TotalFillCommission(I)
       TransGrid.TextMatrix(I + 1, 39) = Transactions.LastExecutionDateTime(I)
       TransGrid.TextMatrix(I + 1, 40) = Transactions.PutCall(I)
       TransGrid.TextMatrix(I + 1, 41) = Transactions.OpenClose(I)
       TransGrid.TextMatrix(I + 1, 42) = Transactions.TrailingStopMethod(I)
       
 Next I
  
   
 TransGrid.ScrollBars = flexScrollBarBoth
  
  
  

End Sub

Private Sub TransGrid_Click()
Dim R As Integer

   R = TransGrid.Row
   If R = 0 Then
     FillGrid.Rows = 1
   Else
     
   End If

End Sub
