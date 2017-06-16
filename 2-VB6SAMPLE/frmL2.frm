VERSION 5.00
Object = "{D40AA7D1-3B85-4ADA-97A9-8100A22F47AE}#1.0#0"; "tdaactx.ocx"
Begin VB.Form frmL2 
   Caption         =   "Level II"
   ClientHeight    =   6465
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7410
   LinkTopic       =   "Form1"
   ScaleHeight     =   6465
   ScaleWidth      =   7410
   StartUpPosition =   3  'Windows Default
   Begin tdaactx.TDAAPIComm TDAC 
      Height          =   345
      Left            =   3375
      TabIndex        =   0
      Top             =   0
      Width           =   375
      Object.Visible         =   -1  'True
      Color           =   -2147483633
      Enabled         =   -1  'True
      LogLevel        =   10
      SourceApp       =   ""
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
   Begin VB.ListBox List2 
      Height          =   5715
      Left            =   3750
      TabIndex        =   5
      Top             =   615
      Width           =   3570
   End
   Begin VB.ListBox List1 
      Height          =   5715
      Left            =   60
      TabIndex        =   4
      Top             =   615
      Width           =   3570
   End
   Begin VB.TextBox dfSym 
      Height          =   300
      Left            =   675
      TabIndex        =   2
      Top             =   15
      Width           =   1200
   End
   Begin VB.CommandButton pbSub 
      Caption         =   "Subscribe"
      Height          =   330
      Left            =   2085
      TabIndex        =   1
      Top             =   15
      Width           =   1065
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Symbol"
      Height          =   195
      Index           =   0
      Left            =   0
      TabIndex        =   3
      Top             =   60
      Width           =   510
   End
End
Attribute VB_Name = "frmL2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Unload(Cancel As Integer)
  TDAC.UnsubscribeAll
End Sub

Private Sub pbSub_Click()
  TDAC.UnsubscribeAll
  Res = TDAC.Subscribe(dfSym.Text, TDAPI_SUB_L2)
End Sub

Private Sub TDAC_OnL2Quote(ByVal Symbol As String, ByVal NumBids As Long, ByVal NumAsks As Long, ByVal NOII As tdaactx.ITDANOII, ByVal Bids As tdaactx.ITDAL2Array, ByVal Asks As tdaactx.ITDAL2Array)
 Dim I As Integer
 Dim F As Double
 Dim S As String
 Dim A As String
 Dim B As String
 
 
 
 
  List1.Clear
  For I = 0 To NumBids - 1
    F = (Bids.TimeStamp(I) / (24 * 60 * 60#) / 1000#)
    S = Format(F, "hh:mm:ss") + " " + Bids.MMID(I)
    A = Bids.Price(I)
    B = Bids.Size(I)
    S = S + " " + A + " " + B
    List1.AddItem S

  Next I
  List2.Clear
  For I = 0 To NumAsks - 1
    F = (Asks.TimeStamp(I) / (24 * 60 * 60#) / 1000#)
    S = Format(F, "hh:mm:ss") + " " + Asks.MMID(I)
    A = Asks.Price(I)
    B = Asks.Size(I)
    S = S + " " + A + " " + B
    List2.AddItem S
  Next I
End Sub
