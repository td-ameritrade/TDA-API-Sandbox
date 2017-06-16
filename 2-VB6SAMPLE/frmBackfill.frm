VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "Msflxgrd.ocx"
Object = "{D40AA7D1-3B85-4ADA-97A9-8100A22F47AE}#1.0#0"; "tdaactx.ocx"
Begin VB.Form frmBackfill 
   Caption         =   "Backfill"
   ClientHeight    =   7335
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6525
   LinkTopic       =   "Form1"
   ScaleHeight     =   7335
   ScaleWidth      =   6525
   StartUpPosition =   3  'Windows Default
   Begin tdaactx.TDAAPIComm TDAC 
      Height          =   345
      Left            =   6060
      TabIndex        =   0
      Top             =   75
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
   Begin VB.ComboBox cmbFreq 
      Height          =   315
      Index           =   0
      ItemData        =   "frmBackfill.frx":0000
      Left            =   3180
      List            =   "frmBackfill.frx":0013
      Style           =   2  'Dropdown List
      TabIndex        =   14
      Top             =   60
      Width           =   960
   End
   Begin VB.TextBox dfTo 
      Height          =   285
      Left            =   3855
      MaxLength       =   10
      TabIndex        =   12
      Top             =   810
      Width           =   1110
   End
   Begin VB.TextBox dfFrom 
      Height          =   285
      Left            =   2340
      MaxLength       =   10
      TabIndex        =   10
      Top             =   810
      Width           =   1110
   End
   Begin VB.OptionButton Option1 
      Caption         =   "Range of Dates"
      Height          =   255
      Left            =   285
      TabIndex        =   8
      Top             =   840
      Width           =   1440
   End
   Begin VB.TextBox dfDays 
      Height          =   285
      Left            =   2985
      MaxLength       =   2
      TabIndex        =   7
      Text            =   "10"
      Top             =   435
      Width           =   480
   End
   Begin VB.OptionButton rbDays 
      Caption         =   "From Today"
      Height          =   255
      Left            =   285
      TabIndex        =   5
      Top             =   480
      Width           =   1305
   End
   Begin VB.TextBox dfSym 
      Height          =   300
      Left            =   825
      TabIndex        =   2
      Top             =   75
      Width           =   975
   End
   Begin VB.CommandButton pbSub 
      Caption         =   "Backfill"
      Height          =   330
      Left            =   4890
      TabIndex        =   1
      Top             =   90
      Width           =   1065
   End
   Begin MSFlexGridLib.MSFlexGrid TransGrid 
      CausesValidation=   0   'False
      Height          =   6045
      Left            =   45
      TabIndex        =   4
      Top             =   1230
      Width           =   6405
      _ExtentX        =   11298
      _ExtentY        =   10663
      _Version        =   393216
      Cols            =   7
      FixedCols       =   0
      ScrollTrack     =   -1  'True
      FocusRect       =   0
      AllowUserResizing=   1
      Appearance      =   0
   End
   Begin VB.Label Label5 
      Caption         =   "Frequency"
      Height          =   195
      Left            =   2310
      TabIndex        =   13
      Top             =   105
      Width           =   930
   End
   Begin VB.Label Label4 
      Caption         =   "To"
      Height          =   195
      Left            =   3585
      TabIndex        =   11
      Top             =   840
      Width           =   225
   End
   Begin VB.Label Label3 
      Caption         =   "From"
      Height          =   195
      Left            =   1905
      TabIndex        =   9
      Top             =   855
      Width           =   510
   End
   Begin VB.Label Label2 
      Caption         =   "# days back"
      Height          =   195
      Left            =   2010
      TabIndex        =   6
      Top             =   480
      Width           =   930
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Symbol"
      Height          =   195
      Index           =   0
      Left            =   165
      TabIndex        =   3
      Top             =   120
      Width           =   510
   End
End
Attribute VB_Name = "frmBackfill"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub dfDays_Validate(Cancel As Boolean)
  dfDays.Text = CInt(dfDays.Text)
  
  
End Sub

Private Sub Form_Load()
  rbDays = True
  cmbFreq(0).ListIndex = 0
  
  TransGrid.TextArray(0) = "Date"
  TransGrid.TextArray(1) = "Time"
  TransGrid.TextArray(2) = "Open"
  TransGrid.TextArray(3) = "High"
  TransGrid.TextArray(4) = "Low"
  TransGrid.TextArray(5) = "Close"
  TransGrid.TextArray(6) = "Volume"
  
  dfFrom.Text = Format(Now() - 10, "YYYYMMDD")
  dfTo.Text = Format(Now(), "yyyymmdd")
  

End Sub

Private Sub Form_Resize()
  If Width - 110 > 0 Then TransGrid.Width = Width - 110
  If Height - TransGrid.Top - 440 > 0 Then TransGrid.Height = Height - TransGrid.Top - 440
  TransGrid.ColWidth(0) = Width / 7
  TransGrid.ColWidth(1) = Width / 7
  TransGrid.ColWidth(2) = Width / 7
  TransGrid.ColWidth(3) = Width / 7
  TransGrid.ColWidth(4) = Width / 7
  TransGrid.ColWidth(5) = Width / 7
  If Width / 7 - 400 > 0 Then TransGrid.ColWidth(6) = Width / 7 - 400
End Sub

Private Sub Form_Unload(Cancel As Integer)
  TDAC.UnsubscribeAll
End Sub

Private Sub Option1_Click()
  dfDays.Enabled = False
  dfFrom.Enabled = True
  dfTo.Enabled = True

End Sub

Private Sub pbSub_Click()
  TDAC.LogLevel = 100
'  TDAC.UnsubscribeAll
  If rbDays Then
    TDAC.RequestBackfill dfSym.Text, CInt(dfDays), CInt(cmbFreq(0).Text)
    'TDAC.Subscribe dfSym.Text, TDAPI_SUB_BARS
  Else
    TDAC.RequestBackfillForDates dfSym.Text, dfFrom.Text, dfTo.Text, CInt(cmbFreq(0).Text)
  End If
End Sub

Private Sub rbDays_Click()
  dfDays.Enabled = True
  dfFrom.Enabled = False
  dfTo.Enabled = False
  
End Sub

Private Sub TDAC_OnBackfill(ByVal Symbol As String, ByVal Error As String, ByVal Backfill As tdaactx.ITDABackfillData)
Dim I As Integer
Dim DD As Date

  DD = CDate("1/1/1970")
  If Error = "" Then
    TransGrid.Rows = Backfill.Count + 1
    For I = 0 To Backfill.Count - 1
      TransGrid.TextMatrix(I + 1, 0) = Format(DD + Backfill.Date(I), "MM/dd/yyyy")
      TransGrid.TextMatrix(I + 1, 1) = Format(Backfill.Time(I) / (24 * 60 * 60#), "hh:mm:ss")
      TransGrid.TextMatrix(I + 1, 2) = Format(Backfill.Open(I), "#.######")
      TransGrid.TextMatrix(I + 1, 3) = Format(Backfill.High(I), "#.######")
      TransGrid.TextMatrix(I + 1, 4) = Format(Backfill.Low(I), "#.######")
      TransGrid.TextMatrix(I + 1, 5) = Format(Backfill.Close(I), "#.######")
      TransGrid.TextMatrix(I + 1, 6) = Backfill.Volume(I)

    Next I
    
  End If
  
End Sub

Private Sub TDAC_OnOHLCBar(ByVal Bar As tdaactx.ITDAOHLCBar)
Dim I As Integer
Dim DD As Date

  DD = CDate("1/1/1970")
  TransGrid.Rows = TransGrid.Rows + 1
  I = TransGrid.Rows - 1
  TransGrid.TextMatrix(I, 0) = Format(DD + Bar.Date, "MM/dd/yyyy")
  TransGrid.TextMatrix(I, 1) = Format(Bar.Time / (24 * 60 * 60#), "hh:mm:ss")
  TransGrid.TextMatrix(I, 2) = Format(Bar.Open, "#.######")
  TransGrid.TextMatrix(I, 3) = Format(Bar.High, "#.######")
  TransGrid.TextMatrix(I, 4) = Format(Bar.Low, "#.######")
  TransGrid.TextMatrix(I, 5) = Format(Bar.Close, "#.######")
  TransGrid.TextMatrix(I, 6) = Bar.Volume


End Sub
