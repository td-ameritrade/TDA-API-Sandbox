VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Object = "{D40AA7D1-3B85-4ADA-97A9-8100A22F47AE}#1.0#0"; "tdaactx.ocx"
Begin VB.Form frmAccounts 
   Caption         =   "Accounts"
   ClientHeight    =   3780
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   10215
   LinkTopic       =   "Form1"
   ScaleHeight     =   3780
   ScaleWidth      =   10215
   StartUpPosition =   3  'Windows Default
   Begin tdaactx.TDAAPIComm TDAC 
      Height          =   360
      Left            =   3150
      TabIndex        =   2
      Top             =   90
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
      LogFile         =   "TDALOG.LOG"
   End
   Begin VB.ListBox List1 
      Height          =   3570
      Left            =   75
      TabIndex        =   0
      Top             =   75
      Width           =   2925
   End
   Begin MSFlexGridLib.MSFlexGrid TransGrid 
      CausesValidation=   0   'False
      Height          =   3645
      Left            =   3570
      TabIndex        =   1
      Top             =   60
      Width           =   6600
      _ExtentX        =   11642
      _ExtentY        =   6429
      _Version        =   393216
      Rows            =   15
      ScrollTrack     =   -1  'True
      FocusRect       =   0
      AllowUserResizing=   1
      Appearance      =   0
   End
End
Attribute VB_Name = "frmAccounts"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
Dim I As Integer
  List1.Clear
  For I = 0 To TDAC.NumAccounts - 1
    List1.AddItem TDAC.AccountID(I)
  Next I
  If List1.ListCount > 0 Then
    List1.ListIndex = 0
    List1_Click
  End If
  
End Sub

Private Sub Form_Resize()
  TransGrid.ColWidth(0) = TransGrid.Width / 2
  TransGrid.ColWidth(1) = TransGrid.Width / 2
  TransGrid.Cols = 2

End Sub

Private Sub List1_Click()
Dim I As Integer
   I = List1.ListIndex
   TransGrid.TextMatrix(0, 0) = "Parameter"
   TransGrid.TextMatrix(0, 1) = "Value"
   TransGrid.TextMatrix(1, 0) = "Accounnt ID"
   TransGrid.TextMatrix(1, 1) = TDAC.AccountID(I)
   TransGrid.TextMatrix(2, 0) = "Description"
   TransGrid.TextMatrix(2, 1) = TDAC.AccountDesc(I)
   TransGrid.TextMatrix(3, 0) = "APEX"
   TransGrid.TextMatrix(3, 1) = TDAC.AccountFlag(I, afApex)
   TransGrid.TextMatrix(4, 0) = "Associated"
   TransGrid.TextMatrix(4, 1) = TDAC.AccountFlag(I, afAssociated)
   TransGrid.TextMatrix(5, 0) = "Express"
   TransGrid.TextMatrix(5, 1) = TDAC.AccountFlag(I, afExpress)
   TransGrid.TextMatrix(6, 0) = "Level1"
   TransGrid.TextMatrix(6, 1) = TDAC.AccountFlag(I, afLevel1)
   TransGrid.TextMatrix(7, 0) = "Level2"
   TransGrid.TextMatrix(7, 1) = TDAC.AccountFlag(I, afLevel2)
   TransGrid.TextMatrix(8, 0) = "MarginTrading"
   TransGrid.TextMatrix(8, 1) = TDAC.AccountFlag(I, afMarginTrading)
   TransGrid.TextMatrix(9, 0) = "OptionsDirect"
   TransGrid.TextMatrix(9, 1) = TDAC.AccountFlag(I, afOptionsDirect)
   TransGrid.TextMatrix(10, 0) = "OptionTrading"
   TransGrid.TextMatrix(10, 1) = TDAC.AccountFlag(I, afOptionTrading)
   TransGrid.TextMatrix(11, 0) = "StocksDirect"
   TransGrid.TextMatrix(11, 1) = TDAC.AccountFlag(I, afStocksDirect)
   TransGrid.TextMatrix(12, 0) = "StockTrading"
   TransGrid.TextMatrix(12, 1) = TDAC.AccountFlag(I, afStockTrading)
   TransGrid.TextMatrix(13, 0) = "StreamingNews"
   TransGrid.TextMatrix(13, 1) = TDAC.AccountFlag(I, afStreamingNews)
   TransGrid.TextMatrix(14, 0) = "Unified"
   TransGrid.TextMatrix(14, 1) = TDAC.AccountFlag(I, afUnified)
   
End Sub

