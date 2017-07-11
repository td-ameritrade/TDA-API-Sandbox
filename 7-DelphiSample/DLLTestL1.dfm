object frmDLLL1: TfrmDLLL1
  Left = 0
  Top = 168
  BorderStyle = bsToolWindow
  Caption = 'Level 1'
  ClientHeight = 294
  ClientWidth = 508
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 38
    Height = 14
    Caption = 'Symbol:'
  end
  object Label2: TLabel
    Left = 64
    Top = 40
    Width = 15
    Height = 14
    Alignment = taRightJustify
    Caption = 'Bid'
  end
  object lBid: TLabel
    Left = 88
    Top = 40
    Width = 85
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object lAsk: TLabel
    Left = 88
    Top = 56
    Width = 85
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label4: TLabel
    Left = 60
    Top = 56
    Width = 19
    Height = 14
    Alignment = taRightJustify
    Caption = 'Ask'
  end
  object lLast: TLabel
    Left = 88
    Top = 72
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label6: TLabel
    Left = 58
    Top = 72
    Width = 21
    Height = 14
    Alignment = taRightJustify
    Caption = 'Last'
  end
  object lHigh: TLabel
    Left = 88
    Top = 88
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label8: TLabel
    Left = 58
    Top = 88
    Width = 21
    Height = 14
    Alignment = taRightJustify
    Caption = 'High'
  end
  object lLow: TLabel
    Left = 88
    Top = 104
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label10: TLabel
    Left = 57
    Top = 104
    Width = 22
    Height = 14
    Alignment = taRightJustify
    Caption = 'Low'
  end
  object lPrevClose: TLabel
    Left = 88
    Top = 120
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label12: TLabel
    Left = 24
    Top = 120
    Width = 55
    Height = 14
    Alignment = taRightJustify
    Caption = 'Prev. Close'
  end
  object lOpen: TLabel
    Left = 88
    Top = 136
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label14: TLabel
    Left = 53
    Top = 136
    Width = 26
    Height = 14
    Alignment = taRightJustify
    Caption = 'Open'
  end
  object lChange: TLabel
    Left = 88
    Top = 152
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label16: TLabel
    Left = 42
    Top = 152
    Width = 37
    Height = 14
    Alignment = taRightJustify
    Caption = 'Change'
  end
  object lHigh52: TLabel
    Left = 88
    Top = 168
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label18: TLabel
    Left = 13
    Top = 168
    Width = 66
    Height = 14
    Alignment = taRightJustify
    Caption = '52 Week High'
  end
  object lLow52: TLabel
    Left = 88
    Top = 184
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label20: TLabel
    Left = 12
    Top = 184
    Width = 67
    Height = 14
    Alignment = taRightJustify
    Caption = '52 Week Low'
  end
  object Label3: TLabel
    Left = 43
    Top = 208
    Width = 36
    Height = 14
    Alignment = taRightJustify
    Caption = 'Volume'
  end
  object lVolume: TLabel
    Left = 88
    Top = 208
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object lBidSize: TLabel
    Left = 88
    Top = 224
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label9: TLabel
    Left = 40
    Top = 224
    Width = 39
    Height = 14
    Alignment = taRightJustify
    Caption = 'Bid Size'
  end
  object lAskSize: TLabel
    Left = 88
    Top = 240
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label13: TLabel
    Left = 36
    Top = 240
    Width = 43
    Height = 14
    Alignment = taRightJustify
    Caption = 'Ask Size'
  end
  object lLastSize: TLabel
    Left = 88
    Top = 256
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label17: TLabel
    Left = 34
    Top = 256
    Width = 45
    Height = 14
    Alignment = taRightJustify
    Caption = 'Last Size'
  end
  object lTick: TLabel
    Left = 254
    Top = 56
    Width = 92
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object L1: TLabel
    Left = 228
    Top = 56
    Width = 19
    Height = 14
    Alignment = taRightJustify
    Caption = 'Tick'
  end
  object L2: TLabel
    Left = 181
    Top = 72
    Width = 66
    Height = 14
    Alignment = taRightJustify
    Caption = 'Bid Exchange'
  end
  object lBidExch: TLabel
    Left = 254
    Top = 72
    Width = 92
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object L3: TLabel
    Left = 177
    Top = 88
    Width = 70
    Height = 14
    Alignment = taRightJustify
    Caption = 'Ask Exchange'
  end
  object lAskExch: TLabel
    Left = 254
    Top = 88
    Width = 92
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object L4: TLabel
    Left = 199
    Top = 104
    Width = 48
    Height = 14
    Alignment = taRightJustify
    Caption = 'Exchange'
  end
  object lExchange: TLabel
    Left = 254
    Top = 104
    Width = 92
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object lTradeTime: TLabel
    Left = 254
    Top = 136
    Width = 92
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label7: TLabel
    Left = 194
    Top = 136
    Width = 53
    Height = 14
    Alignment = taRightJustify
    Caption = 'Trade Time'
  end
  object Label11: TLabel
    Left = 194
    Top = 152
    Width = 53
    Height = 14
    Alignment = taRightJustify
    Caption = 'Trade Date'
  end
  object lTradeDate: TLabel
    Left = 254
    Top = 152
    Width = 92
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label19: TLabel
    Left = 193
    Top = 168
    Width = 54
    Height = 14
    Alignment = taRightJustify
    Caption = 'Quote Time'
  end
  object lQuoteTime: TLabel
    Left = 254
    Top = 168
    Width = 92
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label22: TLabel
    Left = 193
    Top = 184
    Width = 54
    Height = 14
    Alignment = taRightJustify
    Caption = 'Quote Date'
  end
  object lQuoteDate: TLabel
    Left = 254
    Top = 184
    Width = 92
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label24: TLabel
    Left = 220
    Top = 40
    Width = 27
    Height = 14
    Alignment = taRightJustify
    Caption = 'Name'
  end
  object lName: TLabel
    Left = 254
    Top = 40
    Width = 229
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object lIslandBid: TLabel
    Left = 254
    Top = 208
    Width = 92
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label26: TLabel
    Left = 201
    Top = 208
    Width = 46
    Height = 14
    Alignment = taRightJustify
    Caption = 'Island Bid'
  end
  object Label27: TLabel
    Left = 197
    Top = 224
    Width = 50
    Height = 14
    Alignment = taRightJustify
    Caption = 'Island Ask'
  end
  object lIslandAsk: TLabel
    Left = 254
    Top = 224
    Width = 92
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label29: TLabel
    Left = 200
    Top = 240
    Width = 47
    Height = 14
    Alignment = taRightJustify
    Caption = 'Island Vol'
  end
  object lIslandVol: TLabel
    Left = 254
    Top = 240
    Width = 73
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label31: TLabel
    Left = 177
    Top = 256
    Width = 70
    Height = 14
    Alignment = taRightJustify
    Caption = 'Island Bid Size'
  end
  object lIslandBidSize: TLabel
    Left = 254
    Top = 256
    Width = 73
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label33: TLabel
    Left = 173
    Top = 272
    Width = 74
    Height = 14
    Alignment = taRightJustify
    Caption = 'Island Ask Size'
  end
  object lIslandAskSize: TLabel
    Left = 254
    Top = 272
    Width = 73
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object lMarginable: TLabel
    Left = 422
    Top = 64
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label36: TLabel
    Left = 363
    Top = 64
    Width = 52
    Height = 14
    Alignment = taRightJustify
    Caption = 'Marginable'
  end
  object Label100: TLabel
    Left = 369
    Top = 80
    Width = 46
    Height = 14
    Alignment = taRightJustify
    Caption = 'Shortable'
  end
  object lShortable: TLabel
    Left = 422
    Top = 80
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label39: TLabel
    Left = 375
    Top = 96
    Width = 40
    Height = 14
    Alignment = taRightJustify
    Caption = 'Volatility'
  end
  object lVolatility: TLabel
    Left = 422
    Top = 96
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label41: TLabel
    Left = 378
    Top = 112
    Width = 37
    Height = 14
    Alignment = taRightJustify
    Caption = 'TradeID'
  end
  object lTradeID: TLabel
    Left = 422
    Top = 112
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label43: TLabel
    Left = 389
    Top = 128
    Width = 26
    Height = 14
    Alignment = taRightJustify
    Caption = 'Digits'
  end
  object lDigits: TLabel
    Left = 422
    Top = 128
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label5: TLabel
    Left = 403
    Top = 152
    Width = 12
    Height = 14
    Alignment = taRightJustify
    Caption = 'PE'
  end
  object lPE: TLabel
    Left = 422
    Top = 152
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object lDividend: TLabel
    Left = 422
    Top = 168
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label21: TLabel
    Left = 374
    Top = 168
    Width = 41
    Height = 14
    Alignment = taRightJustify
    Caption = 'Dividend'
  end
  object lYield: TLabel
    Left = 422
    Top = 184
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label25: TLabel
    Left = 391
    Top = 184
    Width = 24
    Height = 14
    Alignment = taRightJustify
    Caption = 'Yield'
  end
  object lNAV: TLabel
    Left = 422
    Top = 200
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label30: TLabel
    Left = 392
    Top = 200
    Width = 23
    Height = 14
    Alignment = taRightJustify
    Caption = 'NAV'
  end
  object lFund: TLabel
    Left = 422
    Top = 216
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label34: TLabel
    Left = 391
    Top = 216
    Width = 24
    Height = 14
    Alignment = taRightJustify
    Caption = 'Fund'
  end
  object lExchName: TLabel
    Left = 422
    Top = 240
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label37: TLabel
    Left = 340
    Top = 240
    Width = 75
    Height = 14
    Alignment = taRightJustify
    Caption = 'ExchangeName'
  end
  object lDivDate: TLabel
    Left = 422
    Top = 256
    Width = 75
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label40: TLabel
    Left = 349
    Top = 256
    Width = 66
    Height = 14
    Alignment = taRightJustify
    Caption = 'Dividend Date'
  end
  object dfSym: TEdit
    Left = 48
    Top = 5
    Width = 57
    Height = 22
    TabOrder = 0
  end
  object Button1: TButton
    Left = 112
    Top = 4
    Width = 73
    Height = 25
    Caption = 'Subscribe'
    TabOrder = 1
    OnClick = Button1Click
  end
end
