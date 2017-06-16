VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Object = "{D40AA7D1-3B85-4ADA-97A9-8100A22F47AE}#1.0#0"; "tdaactx.ocx"
Begin VB.Form frmOptionChains 
   Caption         =   "Option Chain"
   ClientHeight    =   7245
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6570
   LinkTopic       =   "Form1"
   ScaleHeight     =   7245
   ScaleWidth      =   6570
   StartUpPosition =   3  'Windows Default
   Begin tdaactx.TDAAPIComm TDAC 
      Height          =   345
      Left            =   5895
      TabIndex        =   0
      Top             =   0
      Width           =   375
      Object.Visible         =   -1  'True
      Color           =   -2147483633
      Enabled         =   -1  'True
      LogLevel        =   0
      SourceApp       =   "TDAACTX"
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
      Left            =   780
      TabIndex        =   2
      Top             =   30
      Width           =   975
   End
   Begin VB.CommandButton pbSub 
      Caption         =   "Get Chain"
      Height          =   330
      Left            =   4755
      TabIndex        =   1
      Top             =   15
      Width           =   1065
   End
   Begin MSFlexGridLib.MSFlexGrid TransGrid 
      CausesValidation=   0   'False
      Height          =   6765
      Left            =   0
      TabIndex        =   3
      Top             =   435
      Width           =   6510
      _ExtentX        =   11483
      _ExtentY        =   11933
      _Version        =   393216
      Cols            =   7
      FixedCols       =   0
      ScrollTrack     =   -1  'True
      FocusRect       =   0
      AllowUserResizing=   1
      Appearance      =   0
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Symbol"
      Height          =   195
      Index           =   0
      Left            =   120
      TabIndex        =   4
      Top             =   75
      Width           =   510
   End
End
Attribute VB_Name = "frmOptionChains"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
  TransGrid.TextArray(0) = "Symbol"
  TransGrid.TextArray(1) = "C/P"
  TransGrid.TextArray(2) = "ExpDate"
  TransGrid.TextArray(3) = "Strike"
  TransGrid.TextArray(4) = "Days"
  TransGrid.TextArray(5) = "ExpType"
  TransGrid.TextArray(6) = "OptType"
  
End Sub

Private Sub Form_Resize()
Dim W As Integer

  If Width - 110 > 0 Then TransGrid.Width = Width - 110
  If Height - TransGrid.Top - 440 > 0 Then TransGrid.Height = Height - TransGrid.Top - 440
  W = (TransGrid.Width - 360 - 500 - 700 - 700 - 700) / 3
  TransGrid.ColWidth(0) = W
  TransGrid.ColWidth(1) = 500
  TransGrid.ColWidth(2) = W
  TransGrid.ColWidth(3) = W
  TransGrid.ColWidth(4) = 700
  TransGrid.ColWidth(5) = 700
  TransGrid.ColWidth(6) = 700

End Sub

Private Sub pbSub_Click()
   TDAC.RequestOptionChain dfSym.Text, "quotes=true"
End Sub


Private Sub TDAC_OnOptionChain(ByVal Symbol As String, ByVal Chain As tdaactx.ITDAOptionChain)
Dim I As Integer
Dim DD As Date

  DD = CDate("1/1/1970")
  TransGrid.Rows = Chain.Count + 1
    For I = 0 To Chain.Count - 1
      TransGrid.TextMatrix(I + 1, 0) = Chain.Symbol(I)
      TransGrid.TextMatrix(I + 1, 1) = Chain.CallPut(I)
      TransGrid.TextMatrix(I + 1, 2) = Format(DD + Chain.ExpDate(I), "MM/dd/yyyy")
      TransGrid.TextMatrix(I + 1, 3) = Format(Chain.Strike(I), "#.###")
      TransGrid.TextMatrix(I + 1, 4) = Chain.DaysToExp(I)
      TransGrid.TextMatrix(I + 1, 5) = Chain.ExpType(I)
      TransGrid.TextMatrix(I + 1, 6) = Chain.OptType(I)
    Next I
    
  

End Sub

Private Sub TDAC_OnOptionChainWithQuotes(ByVal Symbol As String, ByVal Chain As tdaactx.ITDAOptionChainWithQuotes)
  DD = CDate("1/1/1970")
  TransGrid.Rows = Chain.Count + 1
    For I = 0 To Chain.Count - 1
      TransGrid.TextMatrix(I + 1, 0) = Chain.Symbol(I)
      TransGrid.TextMatrix(I + 1, 1) = Chain.CallPut(I)
      TransGrid.TextMatrix(I + 1, 2) = Format(DD + Chain.ExpDate(I), "MM/dd/yyyy")
      TransGrid.TextMatrix(I + 1, 3) = Format(Chain.Strike(I), "#.###")
      TransGrid.TextMatrix(I + 1, 4) = Chain.DaysToExp(I)
      TransGrid.TextMatrix(I + 1, 5) = Chain.ExpType(I)
      TransGrid.TextMatrix(I + 1, 6) = Chain.OptType(I)
    Next I
    

End Sub
