object frmDLLHistBackfill: TfrmDLLHistBackfill
  Left = 182
  Top = 120
  Width = 407
  Height = 544
  Caption = 'Historical Backfill'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 8
    Width = 37
    Height = 13
    Caption = 'Symbol:'
  end
  object Label3: TLabel
    Left = 16
    Top = 45
    Width = 23
    Height = 13
    Caption = 'From'
  end
  object Label4: TLabel
    Left = 136
    Top = 45
    Width = 13
    Height = 13
    Caption = 'To'
  end
  object Label5: TLabel
    Left = 176
    Top = 8
    Width = 24
    Height = 13
    Caption = 'Type'
  end
  object dfSym: TEdit
    Left = 44
    Top = 5
    Width = 57
    Height = 21
    TabOrder = 0
  end
  object pbSub: TButton
    Tag = 1
    Left = 304
    Top = 40
    Width = 81
    Height = 25
    Caption = 'Get Backfill'
    TabOrder = 1
    OnClick = pbSubClick
  end
  object Memo1: TMemo
    Left = 0
    Top = 72
    Width = 392
    Height = 436
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
  end
  object rbASync: TRadioButton
    Left = 112
    Top = 0
    Width = 65
    Height = 17
    Caption = 'ASYNC'
    TabOrder = 3
  end
  object rbSync: TRadioButton
    Left = 112
    Top = 16
    Width = 49
    Height = 17
    Caption = 'SYNC'
    TabOrder = 4
  end
  object dFrom: TDateTimePicker
    Left = 44
    Top = 42
    Width = 81
    Height = 22
    CalAlignment = dtaLeft
    Date = 25569.6179137731
    Time = 25569.6179137731
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 5
  end
  object dTo: TDateTimePicker
    Left = 153
    Top = 42
    Width = 81
    Height = 22
    CalAlignment = dtaLeft
    Date = 39397.6179137731
    Time = 39397.6179137731
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 6
  end
  object dType: TComboBox
    Left = 208
    Top = 4
    Width = 75
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
    Items.Strings = (
      'DAILY'
      'WEEKLY'
      'MONTHLY')
  end
end
