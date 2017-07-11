object frmDLLBackfill: TfrmDLLBackfill
  Left = 365
  Top = 263
  Width = 403
  Height = 542
  BorderStyle = bsSizeToolWin
  Caption = 'Intraday Backfill'
  Color = clBtnFace
  Constraints.MaxWidth = 2000
  Constraints.MinWidth = 380
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
  OnResize = FormResize
  OnShow = FormShow
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
    Left = 129
    Top = 40
    Width = 59
    Height = 14
    Caption = '# days back'
  end
  object Label3: TLabel
    Left = 128
    Top = 64
    Width = 24
    Height = 14
    Caption = 'From'
  end
  object Label4: TLabel
    Left = 248
    Top = 64
    Width = 12
    Height = 14
    Caption = 'To'
  end
  object Label5: TLabel
    Left = 184
    Top = 8
    Width = 49
    Height = 14
    Caption = 'Freq (min)'
  end
  object dfSym: TEdit
    Left = 48
    Top = 4
    Width = 57
    Height = 22
    TabOrder = 0
  end
  object pbSub: TButton
    Tag = 1
    Left = 312
    Top = 4
    Width = 81
    Height = 25
    Caption = 'Get Backfill'
    TabOrder = 9
    OnClick = pbSubClick
  end
  object Memo1: TMemo
    Left = 0
    Top = 88
    Width = 392
    Height = 425
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 10
    WordWrap = False
  end
  object rbASync: TRadioButton
    Left = 112
    Top = 0
    Width = 57
    Height = 17
    Caption = 'ASYNC'
    TabOrder = 1
  end
  object rbSync: TRadioButton
    Left = 112
    Top = 16
    Width = 49
    Height = 17
    Caption = 'SYNC'
    TabOrder = 2
  end
  object spDays: TSpinEdit
    Left = 194
    Top = 36
    Width = 41
    Height = 23
    MaxLength = 1
    MaxValue = 30
    MinValue = 1
    TabOrder = 5
    Value = 5
  end
  object cbFrom: TCheckBox
    Left = 12
    Top = 39
    Width = 81
    Height = 17
    Caption = 'From Today'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = cbFromClick
  end
  object cbTo: TCheckBox
    Left = 12
    Top = 63
    Width = 109
    Height = 17
    Caption = 'Range of Dates'
    TabOrder = 6
    OnClick = cbToClick
  end
  object dFrom: TDateTimePicker
    Left = 156
    Top = 61
    Width = 81
    Height = 22
    CalAlignment = dtaLeft
    Date = 39397.6179137731
    Time = 39397.6179137731
    DateFormat = dfShort
    DateMode = dmComboBox
    Enabled = False
    Kind = dtkDate
    ParseInput = False
    TabOrder = 7
  end
  object dTo: TDateTimePicker
    Left = 265
    Top = 61
    Width = 81
    Height = 22
    CalAlignment = dtaLeft
    Date = 39397.6179137731
    Time = 39397.6179137731
    DateFormat = dfShort
    DateMode = dmComboBox
    Enabled = False
    Kind = dtkDate
    ParseInput = False
    TabOrder = 8
  end
  object dFreq: TComboBox
    Left = 236
    Top = 4
    Width = 55
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 3
    Items.Strings = (
      '1'
      '5'
      '10'
      '15'
      '30')
  end
end
