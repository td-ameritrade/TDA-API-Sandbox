VERSION 5.00
Object = "{D40AA7D1-3B85-4ADA-97A9-8100A22F47AE}#1.0#0"; "tdaactx.ocx"
Begin VB.Form frmNews 
   Caption         =   "Streaming News"
   ClientHeight    =   6915
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7830
   LinkTopic       =   "Form1"
   ScaleHeight     =   6915
   ScaleWidth      =   7830
   StartUpPosition =   3  'Windows Default
   Begin tdaactx.TDAAPIComm TDAC 
      Height          =   345
      Left            =   3375
      TabIndex        =   0
      Top             =   60
      Width           =   375
      Object.Visible         =   -1  'True
      Color           =   -2147483633
      Enabled         =   -1  'True
      LogLevel        =   0
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
   Begin VB.TextBox Text1 
      Height          =   6360
      Left            =   45
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   4
      Top             =   510
      Width           =   7740
   End
   Begin VB.TextBox dfSym 
      Height          =   300
      Left            =   675
      TabIndex        =   2
      Top             =   75
      Width           =   1200
   End
   Begin VB.CommandButton pbSub 
      Caption         =   "Subscribe"
      Height          =   330
      Left            =   2085
      TabIndex        =   1
      Top             =   75
      Width           =   1065
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Symbol"
      Height          =   195
      Index           =   0
      Left            =   0
      TabIndex        =   3
      Top             =   120
      Width           =   510
   End
End
Attribute VB_Name = "frmNews"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Resize()
  If Width - 110 > 0 Then Text1.Width = Width - 110
  If Height - Text1.Top - 420 > 0 Then Text1.Height = Height - Text1.Top - 420

End Sub

Private Sub Form_Unload(Cancel As Integer)
 TDAC.UnsubscribeAll
End Sub

Private Sub pbSub_Click()
  TDAC.UnsubscribeAll
  '//Res = TDAC.Subscribe(dfSym.Text, TDAPI_SUB_NEWS)
  TDAC.RequestNewsHistory dfSym.Text
End Sub

Private Sub TDAC_OnNews(ByVal Symbol As String, ByVal NewsItem As tdaactx.ITDANewsItem)
 If NewsItem.TimeStamp = 0 Then
 Else
   Text1.Text = Text1.Text + NewsItem.Source + " " + NewsItem.Headline + " " + NewsItem.URL + Chr(13) + Chr(10)
 End If
 
 
 

End Sub

