VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Object = "{D40AA7D1-3B85-4ADA-97A9-8100A22F47AE}#1.0#0"; "tdaactx.ocx"
Begin VB.Form frmHistBackfill 
   Caption         =   "Historical Backfill"
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
      Left            =   6120
      TabIndex        =   0
      Top             =   0
      Width           =   375
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
   Begin VB.CommandButton pbSub 
      Caption         =   "Backfill"
      Height          =   330
      Left            =   4965
      TabIndex        =   4
      Top             =   15
      Width           =   1065
   End
   Begin VB.TextBox dfSym 
      Height          =   300
      Left            =   780
      TabIndex        =   3
      Top             =   30
      Width           =   975
   End
   Begin VB.TextBox dfFrom 
      Height          =   285
      Left            =   2250
      MaxLength       =   10
      TabIndex        =   2
      Top             =   45
      Width           =   1110
   End
   Begin VB.TextBox dfTo 
      Height          =   285
      Left            =   3735
      MaxLength       =   10
      TabIndex        =   1
      Top             =   45
      Width           =   1110
   End
   Begin MSFlexGridLib.MSFlexGrid TransGrid 
      CausesValidation=   0   'False
      Height          =   6765
      Left            =   0
      TabIndex        =   5
      Top             =   435
      Width           =   6510
      _ExtentX        =   11483
      _ExtentY        =   11933
      _Version        =   393216
      Cols            =   6
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
      TabIndex        =   8
      Top             =   75
      Width           =   510
   End
   Begin VB.Label Label3 
      Caption         =   "From"
      Height          =   195
      Left            =   1845
      TabIndex        =   7
      Top             =   75
      Width           =   360
   End
   Begin VB.Label Label4 
      Caption         =   "To"
      Height          =   195
      Left            =   3465
      TabIndex        =   6
      Top             =   75
      Width           =   225
   End
End
Attribute VB_Name = "frmHistBackfill"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
  TransGrid.TextArray(0) = "Date"
  TransGrid.TextArray(1) = "Open"
  TransGrid.TextArray(2) = "High"
  TransGrid.TextArray(3) = "Low"
  TransGrid.TextArray(4) = "Close"
  TransGrid.TextArray(5) = "Volume"
  
  dfFrom.Text = "19950101"
  dfTo.Text = Format(Now(), "yyyymmdd")
  


End Sub

Private Sub Form_Resize()
  If Width - 110 > 0 Then TransGrid.Width = Width - 110
  If Height - TransGrid.Top - 440 > 0 Then TransGrid.Height = Height - TransGrid.Top - 440
  TransGrid.ColWidth(0) = (3 * Width) / 14
  TransGrid.ColWidth(1) = (2 * Width) / 14
  TransGrid.ColWidth(2) = (2 * Width) / 14
  TransGrid.ColWidth(3) = (2 * Width) / 14
  TransGrid.ColWidth(4) = (2 * Width) / 14
  If (3 * Width) / 14 - 440 > 0 Then TransGrid.ColWidth(5) = (3 * Width) / 14 - 440

End Sub

Private Sub pbSub_Click()
   TDAC.RequestHistBackfill dfSym.Text, dfFrom.Text, dfTo.Text, "DAILY"
   
   
End Sub


Private Sub TDAC_OnHistBackfill(ByVal Symbol As String, ByVal Error As String, ByVal Backfill As tdaactx.ITDAHistBackfillData)
Dim I As Integer
Dim DD As Date

  DD = CDate("1/1/1970")
  If Error = "" Then
    TransGrid.Rows = Backfill.Count + 1
    For I = 0 To Backfill.Count - 1
      TransGrid.TextMatrix(I + 1, 0) = Format(DD + Backfill.Date(I), "MM/dd/yyyy")
      TransGrid.TextMatrix(I + 1, 1) = Format(Backfill.Open(I), "#.###")
      TransGrid.TextMatrix(I + 1, 2) = Format(Backfill.High(I), "#.###")
      TransGrid.TextMatrix(I + 1, 3) = Format(Backfill.Low(I), "#.###")
      TransGrid.TextMatrix(I + 1, 4) = Format(Backfill.Close(I), "#.###")
      TransGrid.TextMatrix(I + 1, 5) = Backfill.Volume(I)

    Next I
    
  End If
  

End Sub
