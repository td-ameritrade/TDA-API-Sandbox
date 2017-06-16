VERSION 5.00
Object = "{D40AA7D1-3B85-4ADA-97A9-8100A22F47AE}#1.0#0"; "tdaactx.ocx"
Begin VB.Form FrmMain 
   Caption         =   "VB6 TDAAX.OCX test app"
   ClientHeight    =   4920
   ClientLeft      =   6810
   ClientTop       =   2490
   ClientWidth     =   10005
   LinkTopic       =   "MainForm"
   ScaleHeight     =   4920
   ScaleWidth      =   10005
   Begin tdaactx.TDAAPIComm T1 
      Height          =   330
      Left            =   8835
      TabIndex        =   31
      Top             =   1395
      Width           =   375
      Object.Visible         =   -1  'True
      Color           =   -2147483633
      Enabled         =   -1  'True
      LogLevel        =   -1
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
   Begin tdaactx.TDAAPIComm TDAC 
      Height          =   330
      Left            =   165
      TabIndex        =   12
      Top             =   75
      Width           =   375
      Object.Visible         =   -1  'True
      Color           =   -2147483633
      Enabled         =   -1  'True
      LogLevel        =   -1
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
   Begin VB.CommandButton Command21 
      Caption         =   "Command21"
      Height          =   345
      Left            =   9330
      TabIndex        =   32
      Top             =   1425
      Width           =   495
   End
   Begin VB.CommandButton Command20 
      Caption         =   "Trade Ticket"
      Height          =   375
      Left            =   7065
      TabIndex        =   30
      Top             =   1425
      Width           =   1260
   End
   Begin VB.CommandButton Command19 
      Caption         =   "KA"
      Height          =   300
      Left            =   9285
      TabIndex        =   29
      Top             =   60
      Width           =   705
   End
   Begin VB.CommandButton Command18 
      Caption         =   "Transactions"
      Height          =   375
      Left            =   5685
      TabIndex        =   28
      Top             =   1425
      Width           =   1260
   End
   Begin VB.CommandButton pbVisPos 
      Caption         =   "Positions"
      Height          =   375
      Left            =   4260
      TabIndex        =   27
      Top             =   1425
      Width           =   1260
   End
   Begin VB.CommandButton Command17 
      Caption         =   "Balances"
      Height          =   375
      Left            =   2850
      TabIndex        =   26
      Top             =   1425
      Width           =   1260
   End
   Begin VB.CommandButton Command16 
      Caption         =   "NEWS"
      Height          =   375
      Left            =   8505
      TabIndex        =   24
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton Command15 
      Caption         =   "Account History"
      Height          =   375
      Left            =   8490
      TabIndex        =   23
      Top             =   495
      Width           =   1335
   End
   Begin VB.CommandButton Command14 
      Caption         =   "L2 Stream"
      Height          =   375
      Left            =   4260
      TabIndex        =   22
      Top             =   930
      Width           =   1215
   End
   Begin VB.TextBox dfSourceApp 
      Height          =   300
      Left            =   5430
      TabIndex        =   20
      Text            =   "ACTX"
      Top             =   90
      Width           =   735
   End
   Begin VB.CommandButton Command13 
      Caption         =   "Option Chain"
      Height          =   375
      Left            =   7080
      TabIndex        =   19
      Top             =   495
      Width           =   1335
   End
   Begin VB.CommandButton Command12 
      Caption         =   "Hist Backfill"
      Height          =   375
      Left            =   7080
      TabIndex        =   18
      Top             =   945
      Width           =   1335
   End
   Begin VB.CommandButton Command11 
      Caption         =   "Snapshot Quote"
      Height          =   375
      Left            =   5580
      TabIndex        =   17
      Top             =   480
      Width           =   1335
   End
   Begin VB.CommandButton Command10 
      Caption         =   "Backfill"
      Height          =   375
      Left            =   5745
      TabIndex        =   16
      Top             =   945
      Width           =   1215
   End
   Begin VB.CommandButton Command9 
      Caption         =   "Stop"
      Height          =   300
      Left            =   6840
      TabIndex        =   15
      Top             =   60
      Width           =   570
   End
   Begin VB.CommandButton Command8 
      Caption         =   "Start"
      Height          =   300
      Left            =   6240
      TabIndex        =   14
      Top             =   60
      Width           =   570
   End
   Begin VB.CommandButton Command7 
      Caption         =   "Accounts"
      Height          =   375
      Left            =   0
      TabIndex        =   13
      Top             =   480
      Width           =   1215
   End
   Begin VB.CommandButton Command6 
      Caption         =   "Fun with Orders"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   2700
      TabIndex        =   11
      Top             =   660
      Width           =   1470
   End
   Begin VB.CommandButton Command5 
      Caption         =   "Positions"
      Height          =   375
      Left            =   1320
      TabIndex        =   10
      Top             =   960
      Width           =   1215
   End
   Begin VB.CommandButton Command4 
      Caption         =   "Balances"
      Height          =   375
      Left            =   0
      TabIndex        =   9
      Top             =   960
      Width           =   1215
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Transactions"
      Height          =   375
      Left            =   1320
      TabIndex        =   8
      Top             =   480
      Width           =   1215
   End
   Begin VB.CommandButton pbL1 
      Caption         =   "L1 Stream"
      Height          =   375
      Left            =   4260
      TabIndex        =   7
      Top             =   480
      Width           =   1215
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Logout"
      Height          =   300
      Left            =   8415
      TabIndex        =   6
      Top             =   60
      Width           =   825
   End
   Begin VB.TextBox Text1 
      Height          =   2970
      Left            =   45
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   5
      Top             =   1920
      Width           =   9915
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Login"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Left            =   7500
      TabIndex        =   4
      Top             =   60
      Width           =   825
   End
   Begin VB.TextBox dfPass 
      Height          =   300
      IMEMode         =   3  'DISABLE
      Left            =   3555
      PasswordChar    =   "*"
      TabIndex        =   3
      Top             =   80
      Width           =   855
   End
   Begin VB.TextBox dfName 
      Height          =   300
      Left            =   1305
      TabIndex        =   1
      Top             =   90
      Width           =   1330
   End
   Begin VB.Label Label2 
      Caption         =   "VISUAL CONTROLS:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   165
      TabIndex        =   25
      Top             =   1470
      Width           =   2685
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "SourceApp"
      Height          =   195
      Index           =   2
      Left            =   4560
      TabIndex        =   21
      Top             =   150
      Width           =   795
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Password"
      Height          =   195
      Index           =   1
      Left            =   2745
      TabIndex        =   2
      Top             =   135
      Width           =   735
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Name"
      Height          =   195
      Index           =   0
      Left            =   735
      TabIndex        =   0
      Top             =   135
      Width           =   435
   End
End
Attribute VB_Name = "FrmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
  TDAC.Logout
End Sub

Private Sub Command10_Click()
  Dim fBF As New frmBackfill
  fBF.Visible = True
End Sub

Private Sub Command11_Click()
  Dim fSnap As New frmSnap
  fSnap.Visible = True
End Sub

Private Sub Command12_Click()
  Dim fFrm As New frmHistBackfill
  fFrm.Visible = True
End Sub

Private Sub Command13_Click()
  Dim fFrm As New frmOptionChains
  fFrm.Visible = True
End Sub

Private Sub Command14_Click()
Dim fL2 As New frmL2
  fL2.Visible = True

End Sub

Private Sub Command15_Click()
 Dim fAccHist As New frmAccHist
 fAccHist.Visible = True
 
End Sub

Private Sub Command16_Click()
  Dim fNews As New frmNews
  fNews.Visible = True
End Sub

Private Sub Command17_Click()
  Dim fBal As New frmVisBalances
  fBal.Visible = True
  
End Sub

Private Sub Command18_Click()
  Dim fTran As New frmVisTransactions
  fTran.VisTran.APIComm = TDAC
  fTran.Visible = True
  fTran.VisTran.RequestRefresh
End Sub

Private Sub Command19_Click()
  TDAC.KeepAlive
End Sub

Private Sub Command2_Click()
 TDAC.LoginName = dfName.Text
 TDAC.LoginPassword = dfPass.Text
 TDAC.LogFile = "TDALOG.LOG"
 TDAC.STARTIT
End Sub


Private Sub Command20_Click()
  Dim fTT As New frmTradeTicket
  fTT.Visible = True
 End Sub

Private Sub Command21_Click()
 T1.LoginName = "apiftest01"
 T1.LoginPassword = "apif01test"
 T1.LogLevel = 100
 T1.LogFile = "TDALOG.LOG"
 T1.STARTIT
End Sub

Private Sub Command3_Click()
  Dim fTrans As New frmTrans
  fTrans.Visible = True

End Sub

Private Sub Command4_Click()
  Dim fBal As New frmBalances
  fBal.Visible = True
End Sub

Private Sub Command5_Click()
Dim fPos As New frmPositions
  fPos.Visible = True
  
End Sub

Private Sub Command6_Click()
  Dim fOrd As New frmOrders
  fOrd.Visible = True

End Sub

Private Sub Command7_Click()
  Dim fA As New frmAccounts
  fA.Visible = True
  
End Sub

Private Sub Command8_Click()
  TDAC.STARTIT
End Sub

Private Sub Command9_Click()
  TDAC.STOPIT
End Sub

Private Sub Form_Initialize()
  TDAC.SourceApp = dfSourceApp.Text
  TDAC.SetHTTPSimQueueSize 10
  T1.UniqueID = "SOMETHING"
  T1.SourceApp = "AX"
  
  
  
  
  
End Sub

Private Sub Form_Unload(Cancel As Integer)
  TDAC.STOPIT
End Sub

Private Sub pbL1_Click()
  Dim fL1 As New frmL1
  fL1.Visible = True
  
End Sub




Private Sub pbVisPos_Click()
  Dim fPos As New frmVisPositions
  fPos.VisPos.APIComm = TDAC
  fPos.Visible = True
  fPos.VisPos.RequestRefresh
End Sub

Private Sub T1_OnStatusChange(ByVal OldStatus As tdaactx.TxTDAStatus, ByVal NewStatus As tdaactx.TxTDAStatus)
Dim sStat1, sStat2 As String
        Select Case OldStatus
            Case tdaactx.TxTDAStatus.stIdle
                sStat1 = "Idle"
            Case tdaactx.TxTDAStatus.stLoggedIn
                sStat1 = "Logged In"
            Case tdaactx.TxTDAStatus.stChunkTimeOut
                sStat1 = "Chunk Timeout"
            Case tdaactx.TxTDAStatus.stConnectionDied
                sStat1 = "Connection Died"
            Case tdaactx.TxTDAStatus.stLoggingIn
                sStat1 = "Logging In"
            Case tdaactx.TxTDAStatus.stLoginFailed
                sStat1 = "Login Failed"
            Case tdaactx.TxTDAStatus.stRunning
                sStat1 = "Running"
            Case tdaactx.TxTDAStatus.stStartedMainRequest
                sStat1 = "Requested Streaming"
            Case tdaactx.TxTDAStatus.stSystemTemporarilyUnavailable
                sStat1 = "Temp Unavailable"
            Case tdaactx.TxTDAStatus.stKeepAliveInvalid
                sStat1 = "KeepAlive Invalid"
            Case tdaactx.TxTDAStatus.stKeepAliveValid
                sStat1 = "KeepAlive Valid"
            Case tdaactx.TxTDAStatus.stLoggedOut
                sStat1 = "LoggedOut"
            Case tdaactx.TxTDAStatus.stLogoutFailed
                sStat1 = "Logout Failed"
            
            Case Else
                sStat1 = "Unknown Status"
        End Select
        Select Case NewStatus
            Case tdaactx.TxTDAStatus.stIdle
                sStat2 = "Idle"
            Case tdaactx.TxTDAStatus.stLoggedIn
                sStat2 = "Logged In"
            Case tdaactx.TxTDAStatus.stChunkTimeOut
                sStat2 = "Chunk Timeout"
            Case tdaactx.TxTDAStatus.stConnectionDied
                sStat2 = "Connection Died"
            Case tdaactx.TxTDAStatus.stLoggingIn
                sStat2 = "Logging In"
            Case tdaactx.TxTDAStatus.stLoginFailed
                sStat2 = "Login Failed"
            Case tdaactx.TxTDAStatus.stRunning
                sStat2 = "Running"
            Case tdaactx.TxTDAStatus.stStartedMainRequest
                sStat2 = "Requested Streaming"
            Case tdaactx.TxTDAStatus.stSystemTemporarilyUnavailable
                sStat2 = "Temp Unavailable"
            Case tdaactx.TxTDAStatus.stKeepAliveInvalid
                sStat2 = "KeepAlive Invalid"
            Case tdaactx.TxTDAStatus.stKeepAliveValid
                sStat2 = "KeepAlive Valid"
            Case tdaactx.TxTDAStatus.stLoggedOut
                sStat2 = "LoggedOut"
            Case tdaactx.TxTDAStatus.stLogoutFailed
                sStat2 = "Logout Failed"
            
            Case Else
                sStat2 = "Unknown Status"
        End Select
'       If NewStatus = TDAACTX.TxTDAStatus.stLoggedIn Then
'            TDAC.RequestBalancesAndPositions
'        End If
        Text1.Text = "Status Change 2: " + TDADLLGetVer + " " + sStat1 + " --> " + sStat2 + Chr(13) + Chr(10) + Text1.Text
End Sub

Private Sub TDAC_OnMessage(ByVal Message As String)
 Text1.Text = "Message: " + Message + Chr(13) + Chr(10) + Text1.Text
 
End Sub

Private Sub TDAC_OnStatusChange(ByVal OldStatus As tdaactx.TxTDAStatus, ByVal NewStatus As tdaactx.TxTDAStatus)
Dim sStat1, sStat2 As String
        Select Case OldStatus
            Case tdaactx.TxTDAStatus.stIdle
                sStat1 = "Idle"
            Case tdaactx.TxTDAStatus.stLoggedIn
                sStat1 = "Logged In"
            Case tdaactx.TxTDAStatus.stChunkTimeOut
                sStat1 = "Chunk Timeout"
            Case tdaactx.TxTDAStatus.stConnectionDied
                sStat1 = "Connection Died"
            Case tdaactx.TxTDAStatus.stLoggingIn
                sStat1 = "Logging In"
            Case tdaactx.TxTDAStatus.stLoginFailed
                sStat1 = "Login Failed"
            Case tdaactx.TxTDAStatus.stRunning
                sStat1 = "Running"
            Case tdaactx.TxTDAStatus.stStartedMainRequest
                sStat1 = "Requested Streaming"
            Case tdaactx.TxTDAStatus.stSystemTemporarilyUnavailable
                sStat1 = "Temp Unavailable"
            Case tdaactx.TxTDAStatus.stKeepAliveInvalid
                sStat1 = "KeepAlive Invalid"
            Case tdaactx.TxTDAStatus.stKeepAliveValid
                sStat1 = "KeepAlive Valid"
            Case tdaactx.TxTDAStatus.stLoggedOut
                sStat1 = "LoggedOut"
            Case tdaactx.TxTDAStatus.stLogoutFailed
                sStat1 = "Logout Failed"
            
            Case Else
                sStat1 = "Unknown Status"
        End Select
        Select Case NewStatus
            Case tdaactx.TxTDAStatus.stIdle
                sStat2 = "Idle"
            Case tdaactx.TxTDAStatus.stLoggedIn
                sStat2 = "Logged In"
            Case tdaactx.TxTDAStatus.stChunkTimeOut
                sStat2 = "Chunk Timeout"
            Case tdaactx.TxTDAStatus.stConnectionDied
                sStat2 = "Connection Died"
            Case tdaactx.TxTDAStatus.stLoggingIn
                sStat2 = "Logging In"
            Case tdaactx.TxTDAStatus.stLoginFailed
                sStat2 = "Login Failed"
            Case tdaactx.TxTDAStatus.stRunning
                sStat2 = "Running"
            Case tdaactx.TxTDAStatus.stStartedMainRequest
                sStat2 = "Requested Streaming"
            Case tdaactx.TxTDAStatus.stSystemTemporarilyUnavailable
                sStat2 = "Temp Unavailable"
            Case tdaactx.TxTDAStatus.stKeepAliveInvalid
                sStat2 = "KeepAlive Invalid"
            Case tdaactx.TxTDAStatus.stKeepAliveValid
                sStat2 = "KeepAlive Valid"
            Case tdaactx.TxTDAStatus.stLoggedOut
                sStat2 = "LoggedOut"
            Case tdaactx.TxTDAStatus.stLogoutFailed
                sStat2 = "Logout Failed"
            
            Case Else
                sStat2 = "Unknown Status"
        End Select
'       If NewStatus = TDAACTX.TxTDAStatus.stLoggedIn Then
'            TDAC.RequestBalancesAndPositions
'        End If
        Text1.Text = "Status Change " + TDADLLGetVer + " " + sStat1 + " --> " + sStat2 + Chr(13) + Chr(10) + Text1.Text
End Sub

