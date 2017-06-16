VERSION 5.00
Object = "{D40AA7D1-3B85-4ADA-97A9-8100A22F47AE}#1.0#0"; "tdaactx.ocx"
Begin VB.Form frmOrders 
   Caption         =   "Form1"
   ClientHeight    =   10560
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7140
   LinkTopic       =   "Form1"
   ScaleHeight     =   10560
   ScaleWidth      =   7140
   StartUpPosition =   3  'Windows Default
   Begin tdaactx.TDAAPIComm TDAC 
      Height          =   330
      Left            =   6765
      TabIndex        =   50
      Top             =   510
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
      LogFile         =   "TDALOG.LOG"
   End
   Begin VB.ComboBox cmbAcc 
      Height          =   315
      Left            =   825
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   1050
      Width           =   6255
   End
   Begin VB.TextBox Memo1 
      Height          =   3030
      Left            =   45
      MultiLine       =   -1  'True
      TabIndex        =   24
      Top             =   7485
      Width           =   6885
   End
   Begin VB.CommandButton Command6 
      Caption         =   "Cancel Order(s)"
      Height          =   345
      Left            =   4740
      TabIndex        =   23
      Top             =   6945
      Width           =   2010
   End
   Begin VB.TextBox dfOrderIDs 
      Height          =   315
      Left            =   1530
      TabIndex        =   22
      Top             =   6540
      Width           =   5265
   End
   Begin VB.TextBox dfOrdNum 
      Height          =   315
      Left            =   1500
      TabIndex        =   20
      Top             =   5895
      Width           =   1320
   End
   Begin VB.TextBox mOrderStr 
      Height          =   1020
      Left            =   1485
      MultiLine       =   -1  'True
      TabIndex        =   18
      Top             =   4665
      Width           =   5190
   End
   Begin VB.ComboBox cmbSubType 
      Height          =   315
      ItemData        =   "frmOrders.frx":0000
      Left            =   1470
      List            =   "frmOrders.frx":000D
      Style           =   2  'Dropdown List
      TabIndex        =   17
      Top             =   4245
      Width           =   3165
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Submit Raw"
      Height          =   345
      Left            =   5160
      TabIndex        =   19
      Top             =   4200
      Width           =   1575
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Submit New"
      Height          =   345
      Left            =   5160
      TabIndex        =   16
      Top             =   3735
      Width           =   1575
   End
   Begin VB.ComboBox cmbtsParam 
      Height          =   315
      ItemData        =   "frmOrders.frx":004D
      Left            =   5166
      List            =   "frmOrders.frx":005A
      Style           =   2  'Dropdown List
      TabIndex        =   15
      Top             =   3345
      Width           =   1560
   End
   Begin VB.ComboBox cmbspInstruction 
      Height          =   315
      ItemData        =   "frmOrders.frx":0071
      Left            =   5166
      List            =   "frmOrders.frx":0087
      Style           =   2  'Dropdown List
      TabIndex        =   14
      Top             =   2985
      Width           =   1560
   End
   Begin VB.ComboBox cmbRouting 
      Height          =   315
      ItemData        =   "frmOrders.frx":00B3
      Left            =   5166
      List            =   "frmOrders.frx":00C0
      Style           =   2  'Dropdown List
      TabIndex        =   12
      Top             =   2250
      Width           =   1560
   End
   Begin VB.ComboBox cmbExpire 
      Height          =   315
      ItemData        =   "frmOrders.frx":00DA
      Left            =   5166
      List            =   "frmOrders.frx":00F3
      Style           =   2  'Dropdown List
      TabIndex        =   10
      Top             =   1515
      Width           =   1560
   End
   Begin VB.ComboBox cmbOrdType 
      Height          =   315
      ItemData        =   "frmOrders.frx":0120
      Left            =   1410
      List            =   "frmOrders.frx":0136
      Style           =   2  'Dropdown List
      TabIndex        =   5
      Top             =   2265
      Width           =   1560
   End
   Begin VB.ComboBox cmbAction 
      Height          =   315
      ItemData        =   "frmOrders.frx":017D
      Left            =   1410
      List            =   "frmOrders.frx":018D
      Style           =   2  'Dropdown List
      TabIndex        =   4
      Top             =   1890
      Width           =   1560
   End
   Begin VB.TextBox dfMakerID 
      Height          =   315
      Left            =   5166
      TabIndex        =   13
      Top             =   2610
      Width           =   1320
   End
   Begin VB.TextBox dfExDate 
      Height          =   315
      Left            =   5166
      TabIndex        =   11
      Top             =   1875
      Width           =   1320
   End
   Begin VB.TextBox dfDisplaySize 
      Height          =   315
      Left            =   1410
      TabIndex        =   9
      Top             =   3735
      Width           =   1320
   End
   Begin VB.TextBox dfQuantity 
      Height          =   315
      Left            =   1410
      TabIndex        =   8
      Top             =   3360
      Width           =   1320
   End
   Begin VB.TextBox dfActPrice 
      Height          =   315
      Left            =   1410
      TabIndex        =   7
      Top             =   2985
      Width           =   1320
   End
   Begin VB.TextBox dfPrice 
      Height          =   315
      Left            =   1410
      TabIndex        =   6
      Top             =   2625
      Width           =   1320
   End
   Begin VB.TextBox dfSymbol 
      Height          =   315
      Left            =   1410
      TabIndex        =   3
      Top             =   1530
      Width           =   1320
   End
   Begin VB.ComboBox cmbWhich 
      Height          =   315
      ItemData        =   "frmOrders.frx":01B3
      Left            =   915
      List            =   "frmOrders.frx":01B5
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   480
      Width           =   2130
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Modify Order"
      Height          =   345
      Left            =   4755
      TabIndex        =   21
      Top             =   5865
      Width           =   2010
   End
   Begin VB.Label Label4 
      Caption         =   "ç"
      BeginProperty Font 
         Name            =   "Wingdings"
         Size            =   9.75
         Charset         =   2
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Index           =   6
      Left            =   6750
      TabIndex        =   53
      Top             =   1545
      Width           =   285
   End
   Begin VB.Label Label1 
      Caption         =   "Account"
      Height          =   210
      Index           =   1
      Left            =   150
      TabIndex        =   52
      Top             =   1095
      Width           =   660
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      Caption         =   "Note: there is no validation done on these fields in this form - they are sent out to the AMTD servers as they are entered."
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   450
      Index           =   0
      Left            =   75
      TabIndex        =   51
      Top             =   30
      Width           =   7065
   End
   Begin VB.Label Label3 
      Caption         =   "Log"
      Height          =   255
      Index           =   19
      Left            =   45
      TabIndex        =   49
      Top             =   7260
      Width           =   1095
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "OrderIDs"
      Height          =   255
      Index           =   18
      Left            =   390
      TabIndex        =   48
      Top             =   6570
      Width           =   1095
   End
   Begin VB.Line Line1 
      Index           =   4
      X1              =   60
      X2              =   7080
      Y1              =   6450
      Y2              =   6450
   End
   Begin VB.Label Label3 
      Caption         =   "- fields that can be modified"
      Height          =   510
      Index           =   16
      Left            =   3270
      TabIndex        =   47
      Top             =   5970
      Width           =   1095
   End
   Begin VB.Label Label4 
      Caption         =   "é"
      BeginProperty Font 
         Name            =   "Wingdings"
         Size            =   9.75
         Charset         =   2
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Index           =   5
      Left            =   3030
      TabIndex        =   46
      Top             =   5940
      Width           =   285
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "Order ID"
      Height          =   255
      Index           =   15
      Left            =   360
      TabIndex        =   45
      Top             =   5925
      Width           =   1095
   End
   Begin VB.Line Line1 
      Index           =   2
      X1              =   165
      X2              =   7185
      Y1              =   5775
      Y2              =   5775
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "OrderString"
      Height          =   255
      Index           =   14
      Left            =   285
      TabIndex        =   44
      Top             =   4665
      Width           =   1095
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "Submit Type"
      Height          =   255
      Index           =   13
      Left            =   270
      TabIndex        =   43
      Top             =   4260
      Width           =   1095
   End
   Begin VB.Line Line1 
      BorderColor     =   &H0000AA00&
      BorderWidth     =   3
      Index           =   1
      X1              =   165
      X2              =   7185
      Y1              =   4125
      Y2              =   4125
   End
   Begin VB.Label Label4 
      Caption         =   "ç"
      BeginProperty Font 
         Name            =   "Wingdings"
         Size            =   9.75
         Charset         =   2
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Index           =   4
      Left            =   6525
      TabIndex        =   42
      Top             =   1950
      Width           =   285
   End
   Begin VB.Label Label4 
      Caption         =   "ç"
      BeginProperty Font 
         Name            =   "Wingdings"
         Size            =   9.75
         Charset         =   2
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Index           =   3
      Left            =   2790
      TabIndex        =   41
      Top             =   3390
      Width           =   285
   End
   Begin VB.Label Label4 
      Caption         =   "ç"
      BeginProperty Font 
         Name            =   "Wingdings"
         Size            =   9.75
         Charset         =   2
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Index           =   2
      Left            =   2790
      TabIndex        =   40
      Top             =   3030
      Width           =   285
   End
   Begin VB.Label Label4 
      Caption         =   "ç"
      BeginProperty Font 
         Name            =   "Wingdings"
         Size            =   9.75
         Charset         =   2
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Index           =   1
      Left            =   3015
      TabIndex        =   39
      Top             =   2295
      Width           =   285
   End
   Begin VB.Label Label4 
      Caption         =   "ç"
      BeginProperty Font 
         Name            =   "Wingdings"
         Size            =   9.75
         Charset         =   2
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Index           =   0
      Left            =   2790
      TabIndex        =   38
      Top             =   2670
      Width           =   285
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "tsParam"
      Height          =   225
      Index           =   12
      Left            =   4080
      TabIndex        =   37
      Top             =   3390
      Width           =   1020
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "spInstruction"
      Height          =   225
      Index           =   11
      Left            =   4080
      TabIndex        =   36
      Top             =   3030
      Width           =   1020
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "makerID"
      Height          =   225
      Index           =   10
      Left            =   4080
      TabIndex        =   35
      Top             =   2655
      Width           =   1020
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "Routing"
      Height          =   225
      Index           =   9
      Left            =   4080
      TabIndex        =   34
      Top             =   2295
      Width           =   1020
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "ExDay/ExMonth/ExYear"
      Height          =   225
      Index           =   8
      Left            =   3285
      TabIndex        =   33
      Top             =   1920
      Width           =   1815
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "Expire"
      Height          =   225
      Index           =   7
      Left            =   4080
      TabIndex        =   32
      Top             =   1560
      Width           =   1020
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "DisplaySize"
      Height          =   255
      Index           =   6
      Left            =   270
      TabIndex        =   31
      Top             =   3735
      Width           =   1095
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "Quantity"
      Height          =   255
      Index           =   5
      Left            =   270
      TabIndex        =   30
      Top             =   3375
      Width           =   1095
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "ActPrice"
      Height          =   255
      Index           =   4
      Left            =   270
      TabIndex        =   29
      Top             =   3015
      Width           =   1095
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "Price"
      Height          =   255
      Index           =   3
      Left            =   270
      TabIndex        =   28
      Top             =   2655
      Width           =   1095
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "OrdType"
      Height          =   255
      Index           =   2
      Left            =   270
      TabIndex        =   27
      Top             =   2295
      Width           =   1095
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "Action"
      Height          =   255
      Index           =   1
      Left            =   270
      TabIndex        =   26
      Top             =   1935
      Width           =   1095
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "Symbol"
      Height          =   255
      Index           =   0
      Left            =   270
      TabIndex        =   25
      Top             =   1575
      Width           =   1095
   End
   Begin VB.Line Line1 
      Index           =   0
      X1              =   225
      X2              =   7245
      Y1              =   870
      Y2              =   870
   End
   Begin VB.Label Label2 
      Caption         =   "Order is for"
      Height          =   240
      Left            =   60
      TabIndex        =   0
      Top             =   540
      Width           =   945
   End
End
Attribute VB_Name = "frmOrders"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Command1_Click()
Dim S, A As String
Dim I, P As Integer
Dim ET As TxTDAEquityType

  If cmbAcc.ListCount > 0 Then
    S = cmbAcc.List(cmbAcc.ListIndex)
    I = InStr(S, " ")
    If I > 0 Then S = Left(S, I - 1)
  End If
  
  ' construct the string
  S = "accountid=" + S + "~"
  S = S + "symbol=" + UCase(Trim(dfSymbol.Text)) + "~"
  S = S + "action=" + cmbAction.Text + "~"
  S = S + "ordtype=" + cmbOrdType.Text + "~"
  S = S + "price=" + dfPrice.Text + "~"
  S = S + "actprice=" + dfActPrice.Text + "~"
  S = S + "quantity=" + dfQuantity.Text + "~"
  If cmbWhich.ListIndex = 0 Then
    S = S + "displaysize=" + dfDisplaySize.Text + "~" + "makerid=" + dfMakerID.Text + "~" + "tsparam=" + cmbtsParam.Text + "~"
  End If
  
  S = S + "expire=" + cmbExpire.Text + "~"
  A = Trim(dfExDate.Text)
  P = InStr("/", A)
  If P = 0 Then P = Len(A) + 1
  If Len(A) = 1 Then
    A = "0" + A
  End If
  S = S + "exday=" + Left(A, P - 1) + "~"
  If P >= Len(A) Then A = "" Else A = Right(A, Len(A) - P)
  
  P = InStr("/", A)
  If P = 0 Then P = Len(A) + 1
  If Len(A) = 1 Then A = "0" + A
  S = S + "exmonth=" + Left(A, P - 1) + "~"
  If P >= Len(A) Then A = "" Else A = Right(A, Len(A) - P)
  
  P = InStr("/", A)
  If P = 0 Then P = Len(A) + 1
  If Len(A) = 1 Then A = "0" + A
  S = S + "exyear=" + Left(A, P - 1) + "~"
  If P >= Len(A) Then A = "" Else A = Right(A, Len(A) - P)
  
  S = S + "spinstructions=" + cmbspInstruction.Text + "~"
  S = S + "routing=" + cmbRouting.Text + "~"

  Memo1.Text = Memo1.Text + Chr(13) + Chr(10) + "OrderString: " + S + Chr(13) + Chr(10)
  
  If cmbWhich.ListIndex = 0 Then ET = etStock
  If cmbWhich.ListIndex = 1 Then ET = etOption
  

  TDAC.OrderCommand ET, otNew, S

End Sub

Private Sub Command2_Click()
Dim S As String
Dim OT As TxTDAOrderSubmitType
Dim ET As TxTDAEquityType

  
  S = mOrderStr.Text
  
  If cmbSubType.ListIndex = 0 Then OT = otNew
  If cmbSubType.ListIndex = 1 Then OT = otCancel
  If cmbSubType.ListIndex = 2 Then OT = otModify
  

  Memo1.Text = Memo1.Text + Chr(13) + Chr(10) + "OrderString: " + S + Chr(13) + Chr(10)

  If cmbWhich.ListIndex = 0 Then ET = etStock
  If cmbWhich.ListIndex = 1 Then ET = etOption

  TDAC.OrderCommand ET, OT, S
End Sub

Private Sub Command3_Click()
Dim S, A As String
Dim P As Integer
Dim ET As TxTDAEquityType
  
  If cmbAcc.ListCount > 0 Then
    S = cmbAcc.List(cmbAcc.ListIndex)
    I = InStr(S, " ")
    If I > 0 Then S = Left(S, I - 1)
  End If
  
  ' construct the string
  S = "accountid=" + S + "~"
  
  S = "orderid=" + UCase(Trim(dfOrdNum.Text)) + ","
  A = cmbOrdType.Text
  S = S + "ordtype=" + A + ","
  S = S + "price=" + dfPrice.Text + ","
  S = S + "actprice=" + dfActPrice.Text + ","
  S = S + "quantity=" + dfQuantity.Text + ","

  S = S + "expire=" + cmbExpire.Text + "~"
  A = Trim(dfExDate.Text)
  P = InStr("/", A)
  If P = 0 Then P = Len(A) + 1
  If Len(A) = 1 Then
    A = "0" + A
  End If
  S = S + "exday=" + Left(A, P - 1) + "~"
  If P >= Len(A) Then A = "" Else A = Right(A, Len(A) - P)
  
  P = InStr("/", A)
  If P = 0 Then P = Len(A) + 1
  If Len(A) = 1 Then A = "0" + A
  S = S + "exmonth=" + Left(A, P - 1) + "~"
  If P >= Len(A) Then A = "" Else A = Right(A, Len(A) - P)
  
  P = InStr("/", A)
  If P = 0 Then P = Len(A) + 1
  If Len(A) = 1 Then A = "0" + A
  S = S + "exyear=" + Left(A, P - 1) + "~"
  If P >= Len(A) Then A = "" Else A = Right(A, Len(A) - P)
  
  
    
  If cmbWhich.ListIndex = 0 Then ET = etStock
  If cmbWhich.ListIndex = 1 Then ET = etOption
  

  TDAC.OrderCommand ET, otModify, S
 
End Sub

Private Sub Command4_Click()
Dim S As String
Dim ET As TxTDAEquityType

  S = Trim(dfOrdNum.Text) + "|"

  Memo1.Text = Memo1.Text + "OrderString: " + S + Chr(13) + Chr(10)
  
  If cmbWhich.ListIndex = 0 Then ET = etStock
  If cmbWhich.ListIndex = 1 Then ET = etOption

  TDAC.OrderCommand ET, otModifyConfirm, S

End Sub

Private Sub Command5_Click()
Dim ET As TxTDAEquityType
  
  If cmbWhich.ListIndex = 0 Then ET = etStock
  If cmbWhich.ListIndex = 1 Then ET = etOption
  S = Trim(dfOrderAgent.Text)
  Memo1.Text = Memo1.Text + "OrderString: " + S + Chr(13) + Chr(10)

  TDAC.OrderCommand ET, otNewConfirm, S
End Sub

Private Sub Command6_Click()
Dim ET As TxTDAEquityType
Dim S As String

  
  If cmbAcc.ListCount > 0 Then
    S = cmbAcc.List(cmbAcc.ListIndex)
    I = InStr(S, " ")
    If I > 0 Then S = Left(S, I - 1)
  End If
  
  ' construct the string
  S = "accountid=" + S + "~"
  
  If cmbWhich.ListIndex = 0 Then ET = etStock
  If cmbWhich.ListIndex = 1 Then ET = etOption
  S = S + Trim(dfOrderIDs.Text)

  Memo1.Text = Memo1.Text + "OrderString: " + S + Chr(13) + Chr(10)

  TDAC.OrderCommand ET, otCancel, S

End Sub

Private Sub Command7_Click()
Dim ET As TxTDAEquityType
  
  If cmbWhich.ListIndex = 0 Then ET = etStock
  If cmbWhich.ListIndex = 1 Then ET = etOption
  S = Trim(dfOrderIDs.Text)

  Memo1.Text = Memo1.Text + "OrderString: " + S + Chr(13) + Chr(10)

  TDAC.OrderCommand ET, otCancelConfirm, S
  
End Sub

Private Sub Form_Load()
Dim I As Integer
   cmbWhich.AddItem ("Stock")
   cmbWhich.AddItem ("Option")
   cmbWhich.AddItem ("Mutual Fund")
   cmbWhich.ListIndex = 0

    
  For I = 0 To TDAC.NumAccounts - 1
    cmbAcc.AddItem TDAC.AccountID(I) + " " + TDAC.AccountDesc(I)
  Next I
  If TDAC.NumAccounts > 0 Then
     cmbAcc.ListIndex = 0
  End If
   
End Sub

Private Sub Text1_Change()

End Sub

Private Sub Text4_Change()

End Sub

Private Sub TDAC_OnOrderAck(ByVal AckType As String, ByVal AckStr As String)
   Memo1.Text = Memo1.Text + "ACK: " + AckType + " / " + AckStr + Chr(13) + Chr(10)
End Sub

Private Sub TDAC_OnPandL(ByVal Account As String, ByVal PandL As Double, ByVal RealizedPandL As Double, ByVal UnrealizedPandL As Double)
  TotalPL.Caption = PandL
  RealizedPL.Caption = RealizedPandL
  UnrealizedPL.Caption = UnrealizedPandL
  
End Sub
