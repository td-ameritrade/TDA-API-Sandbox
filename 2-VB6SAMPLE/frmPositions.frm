VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Object = "{D40AA7D1-3B85-4ADA-97A9-8100A22F47AE}#1.0#0"; "tdaactx.ocx"
Begin VB.Form frmPositions 
   Caption         =   "Account Positions"
   ClientHeight    =   6930
   ClientLeft      =   6780
   ClientTop       =   2355
   ClientWidth     =   8670
   LinkTopic       =   "Form1"
   ScaleHeight     =   6930
   ScaleWidth      =   8670
   Begin tdaactx.TDAAPIComm TDAC 
      Height          =   315
      Left            =   7095
      TabIndex        =   2
      Top             =   45
      Width           =   345
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
      Left            =   750
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   60
      Width           =   6255
   End
   Begin VB.CommandButton pbSub 
      Caption         =   "Refresh"
      Height          =   330
      Left            =   7500
      TabIndex        =   1
      Top             =   30
      Width           =   1065
   End
   Begin MSFlexGridLib.MSFlexGrid TransGrid 
      CausesValidation=   0   'False
      Height          =   6360
      Left            =   0
      TabIndex        =   0
      Top             =   465
      Width           =   8565
      _ExtentX        =   15108
      _ExtentY        =   11218
      _Version        =   393216
      Cols            =   43
      ScrollTrack     =   -1  'True
      FocusRect       =   0
      AllowUserResizing=   1
      Appearance      =   0
   End
   Begin VB.Label Label1 
      Caption         =   "Account"
      Height          =   210
      Left            =   15
      TabIndex        =   4
      Top             =   90
      Width           =   660
   End
End
Attribute VB_Name = "frmPositions"
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
  
    TransGrid.Cols = 10
    TransGrid.Rows = 2
    TransGrid.TextArray(0) = "Symbol"
    TransGrid.TextArray(1) = "SymWithPrefix"
    TransGrid.TextArray(2) = "Posit"
    TransGrid.TextArray(3) = "Qty"
    TransGrid.TextArray(4) = "Cl. Price"
    TransGrid.TextArray(5) = "Av. Price"
    TransGrid.TextArray(6) = "ATyp"
    TransGrid.TextArray(7) = "CUSIP"
    TransGrid.TextArray(8) = "AcType"
    TransGrid.TextArray(9) = "Name"
End Sub

Private Sub Form_Resize()
  If Width - 110 > 0 Then TransGrid.Width = Width - 110
  If Height - TransGrid.TopRow - 860 > 0 Then TransGrid.Height = Height - TransGrid.TopRow - 860
End Sub

Private Sub pbSub_Click()
Dim S As String
Dim I As Integer

  If cmbAcc.ListCount > 0 Then
    S = cmbAcc.List(cmbAcc.ListIndex)
    I = InStr(S, " ")
    If I > 0 Then S = Left(S, I - 1)
  End If
   
  TDAC.RequestBalancesAndPositions S
End Sub

Private Sub TDAC_OnPositionsChange(ByVal Positions As tdaactx.ITDAPositions)

Dim I As Integer

   TransGrid.Rows = Positions.Count + 1
 
 For I = 0 To Positions.Count - 1
      TransGrid.TextMatrix(I + 1, 0) = Positions.Symbol(I)
      TransGrid.TextMatrix(I + 1, 1) = Positions.SymbolWithPrefix(I)
      TransGrid.TextMatrix(I + 1, 9) = Positions.FullName(I)
      TransGrid.TextMatrix(I + 1, 6) = Chr(Positions.AssetType(I))
      TransGrid.TextMatrix(I + 1, 7) = Positions.CUSIP(I)
      TransGrid.TextMatrix(I + 1, 8) = Positions.AccountType(I)
      TransGrid.TextMatrix(I + 1, 4) = Positions.ClosePrice(I)
      TransGrid.TextMatrix(I + 1, 5) = Positions.AveragePrice(I)
      TransGrid.TextMatrix(I + 1, 2) = Positions.PositionType(I)
      TransGrid.TextMatrix(I + 1, 3) = Positions.Quantity(I)
 Next I
End Sub

