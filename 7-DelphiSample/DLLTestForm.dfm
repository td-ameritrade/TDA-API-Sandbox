object frmTestDLL: TfrmTestDLL
  Left = 1829
  Top = 283
  BorderStyle = bsToolWindow
  Caption = 'TDA Delphi Sample App Using DLL'
  ClientHeight = 345
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 312
    Top = 48
    Width = 27
    Height = 14
    Caption = 'Name'
  end
  object Label2: TLabel
    Left = 425
    Top = 48
    Width = 50
    Height = 14
    Caption = 'Password'
  end
  object Label3: TLabel
    Left = 0
    Top = 133
    Width = 31
    Height = 14
    Caption = 'Status'
  end
  object Shape1: TShape
    Left = 192
    Top = 45
    Width = 17
    Height = 17
    Shape = stCircle
  end
  object Label4: TLabel
    Left = 8
    Top = 8
    Width = 93
    Height = 14
    Caption = 'Login/Trade Server'
  end
  object Label5: TLabel
    Left = 312
    Top = 8
    Width = 55
    Height = 14
    Caption = 'SourceApp'
  end
  object Memo1: TMemo
    Left = 0
    Top = 136
    Width = 626
    Height = 206
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
  object pbInit: TButton
    Left = 5
    Top = 42
    Width = 180
    Height = 25
    Caption = 'Initialize TDA Object'
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = pbInitClick
  end
  object pbLogin: TButton
    Left = 552
    Top = 42
    Width = 75
    Height = 25
    Caption = 'Login'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = pbLoginClick
  end
  object dfName: TEdit
    Left = 345
    Top = 44
    Width = 72
    Height = 22
    TabOrder = 3
  end
  object dfPass: TEdit
    Left = 481
    Top = 44
    Width = 64
    Height = 22
    PasswordChar = '*'
    TabOrder = 4
  end
  object pbL1: TButton
    Left = 7
    Top = 77
    Width = 75
    Height = 25
    Caption = 'L1 Quotes'
    TabOrder = 5
    OnClick = pbL1Click
  end
  object pbL2: TButton
    Left = 87
    Top = 77
    Width = 74
    Height = 25
    Caption = 'L2/Arca/Isld'
    TabOrder = 6
    OnClick = pbL2Click
  end
  object pbNews: TButton
    Left = 255
    Top = 77
    Width = 98
    Height = 25
    Caption = 'News Monitor'
    TabOrder = 7
    OnClick = pbNewsClick
  end
  object pbBalances: TButton
    Left = 360
    Top = 77
    Width = 65
    Height = 25
    Caption = 'Balances'
    TabOrder = 8
    OnClick = pbBalancesClick
  end
  object pbPositions: TButton
    Left = 431
    Top = 77
    Width = 82
    Height = 25
    Caption = 'Positions'
    TabOrder = 9
    OnClick = pbPositionsClick
  end
  object pbTrans: TButton
    Left = 521
    Top = 77
    Width = 106
    Height = 25
    Caption = 'Transactions'
    TabOrder = 10
    OnClick = pbTransClick
  end
  object pbSubmit: TButton
    Left = 434
    Top = 105
    Width = 193
    Height = 25
    Caption = 'Fun with Orders'
    TabOrder = 11
    OnClick = pbSubmitClick
  end
  object pbBackfill: TButton
    Left = 256
    Top = 105
    Width = 97
    Height = 25
    Caption = 'Intraday Backfill'
    TabOrder = 12
    OnClick = pbBackfillClick
  end
  object Button1: TButton
    Left = 216
    Top = 42
    Width = 33
    Height = 25
    Caption = 'GO'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 255
    Top = 42
    Width = 46
    Height = 25
    Caption = 'STOP'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 14
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 167
    Top = 77
    Width = 74
    Height = 25
    Caption = 'Actives'
    TabOrder = 15
    OnClick = Button4Click
  end
  object pbAccounts: TButton
    Left = 87
    Top = 106
    Width = 75
    Height = 25
    Caption = 'Accounts'
    TabOrder = 16
    OnClick = pbAccountsClick
  end
  object dfTradeServer: TEdit
    Left = 110
    Top = 4
    Width = 187
    Height = 22
    TabOrder = 17
    Text = 'apis.tdameritrade.com'
  end
  object Button2: TButton
    Left = 7
    Top = 109
    Width = 75
    Height = 25
    Caption = 'Snap Quotes'
    TabOrder = 18
    OnClick = Button2Click
  end
  object Button5: TButton
    Left = 472
    Top = 0
    Width = 75
    Height = 25
    Caption = 'Keep Alive'
    TabOrder = 19
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 552
    Top = 0
    Width = 75
    Height = 25
    Caption = 'Logout'
    TabOrder = 20
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 167
    Top = 106
    Width = 74
    Height = 25
    Caption = 'Option Chain'
    TabOrder = 21
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 360
    Top = 105
    Width = 65
    Height = 25
    Caption = 'Hist Backfill'
    TabOrder = 22
    OnClick = Button8Click
  end
  object dfSourceApp: TEdit
    Left = 374
    Top = 4
    Width = 51
    Height = 22
    TabOrder = 23
    Text = 'TSTDLL'
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 440
    Top = 65525
  end
end
