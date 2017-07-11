object frmDLLSnap: TfrmDLLSnap
  Left = 249
  Top = 266
  Width = 530
  Height = 353
  Caption = 'SNAPSHOT Quotes'
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 38
    Height = 14
    Caption = 'Symbol:'
  end
  object Label2: TLabel
    Left = 64
    Top = 72
    Width = 15
    Height = 14
    Alignment = taRightJustify
    Caption = 'Bid'
  end
  object lBid: TLabel
    Left = 88
    Top = 72
    Width = 85
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object lAsk: TLabel
    Left = 88
    Top = 88
    Width = 85
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label4: TLabel
    Left = 60
    Top = 88
    Width = 19
    Height = 14
    Alignment = taRightJustify
    Caption = 'Ask'
  end
  object lLast: TLabel
    Left = 88
    Top = 104
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label6: TLabel
    Left = 58
    Top = 104
    Width = 21
    Height = 14
    Alignment = taRightJustify
    Caption = 'Last'
  end
  object lHigh: TLabel
    Left = 88
    Top = 120
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label8: TLabel
    Left = 58
    Top = 120
    Width = 21
    Height = 14
    Alignment = taRightJustify
    Caption = 'High'
  end
  object lLow: TLabel
    Left = 88
    Top = 136
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label10: TLabel
    Left = 57
    Top = 136
    Width = 22
    Height = 14
    Alignment = taRightJustify
    Caption = 'Low'
  end
  object lPrevClose: TLabel
    Left = 88
    Top = 152
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label12: TLabel
    Left = 24
    Top = 152
    Width = 55
    Height = 14
    Alignment = taRightJustify
    Caption = 'Prev. Close'
  end
  object lOpen: TLabel
    Left = 88
    Top = 168
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label14: TLabel
    Left = 53
    Top = 168
    Width = 26
    Height = 14
    Alignment = taRightJustify
    Caption = 'Open'
  end
  object lChange: TLabel
    Left = 88
    Top = 184
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label16: TLabel
    Left = 42
    Top = 184
    Width = 37
    Height = 14
    Alignment = taRightJustify
    Caption = 'Change'
  end
  object lHigh52: TLabel
    Left = 88
    Top = 200
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label18: TLabel
    Left = 13
    Top = 200
    Width = 66
    Height = 14
    Alignment = taRightJustify
    Caption = '52 Week High'
  end
  object lLow52: TLabel
    Left = 88
    Top = 216
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label20: TLabel
    Left = 12
    Top = 216
    Width = 67
    Height = 14
    Alignment = taRightJustify
    Caption = '52 Week Low'
  end
  object Label3: TLabel
    Left = 43
    Top = 240
    Width = 36
    Height = 14
    Alignment = taRightJustify
    Caption = 'Volume'
  end
  object lVolume: TLabel
    Left = 88
    Top = 240
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object lBidSize: TLabel
    Left = 88
    Top = 256
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label9: TLabel
    Left = 40
    Top = 256
    Width = 39
    Height = 14
    Alignment = taRightJustify
    Caption = 'Bid Size'
  end
  object lAskSize: TLabel
    Left = 88
    Top = 272
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label13: TLabel
    Left = 36
    Top = 272
    Width = 43
    Height = 14
    Alignment = taRightJustify
    Caption = 'Ask Size'
  end
  object lLastSize: TLabel
    Left = 88
    Top = 288
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label17: TLabel
    Left = 34
    Top = 288
    Width = 45
    Height = 14
    Alignment = taRightJustify
    Caption = 'Last Size'
  end
  object lTradeTime: TLabel
    Left = 254
    Top = 168
    Width = 92
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label7: TLabel
    Left = 194
    Top = 168
    Width = 53
    Height = 14
    Alignment = taRightJustify
    Caption = 'Trade Time'
  end
  object Label11: TLabel
    Left = 194
    Top = 184
    Width = 53
    Height = 14
    Alignment = taRightJustify
    Caption = 'Trade Date'
  end
  object lTradeDate: TLabel
    Left = 254
    Top = 184
    Width = 92
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label24: TLabel
    Left = 220
    Top = 72
    Width = 27
    Height = 14
    Alignment = taRightJustify
    Caption = 'Name'
  end
  object lName: TLabel
    Left = 254
    Top = 72
    Width = 229
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label39: TLabel
    Left = 375
    Top = 128
    Width = 40
    Height = 14
    Alignment = taRightJustify
    Caption = 'Volatility'
  end
  object lVolatility: TLabel
    Left = 422
    Top = 128
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object lNAV: TLabel
    Left = 422
    Top = 232
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label30: TLabel
    Left = 392
    Top = 232
    Width = 23
    Height = 14
    Alignment = taRightJustify
    Caption = 'NAV'
  end
  object lExchName: TLabel
    Left = 422
    Top = 272
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label37: TLabel
    Left = 340
    Top = 272
    Width = 75
    Height = 14
    Alignment = taRightJustify
    Caption = 'ExchangeName'
  end
  object Label15: TLabel
    Left = 8
    Top = 4
    Width = 41
    Height = 14
    Caption = 'Account'
  end
  object dfSym: TEdit
    Left = 48
    Top = 37
    Width = 57
    Height = 22
    TabOrder = 0
  end
  object Button1: TButton
    Left = 112
    Top = 36
    Width = 105
    Height = 25
    Caption = 'Get Snap Quote'
    TabOrder = 1
    OnClick = Button1Click
  end
  object rbSync: TRadioButton
    Left = 362
    Top = 37
    Width = 65
    Height = 17
    Caption = 'SYNC'
    TabOrder = 2
  end
  object rbASync: TRadioButton
    Left = 296
    Top = 37
    Width = 65
    Height = 17
    Caption = 'ASYNC'
    TabOrder = 3
  end
  object cmbAcc: TComboBox
    Left = 55
    Top = 2
    Width = 290
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 4
  end
  object Button2: TButton
    Left = 366
    Top = 1
    Width = 59
    Height = 20
    Caption = 'Repop'
    TabOrder = 5
    OnClick = Button2Click
  end
end
