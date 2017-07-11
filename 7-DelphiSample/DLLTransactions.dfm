object frmDLLTransactions: TfrmDLLTransactions
  Left = 304
  Top = 367
  Width = 597
  Height = 360
  Anchors = [akLeft, akTop, akRight]
  BorderStyle = bsSizeToolWin
  Caption = 'Account Transactions'
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
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 9
    Width = 41
    Height = 14
    Caption = 'Account'
  end
  object Label2: TLabel
    Left = 359
    Top = 69
    Width = 89
    Height = 14
    Caption = 'Last Order Status:'
  end
  object lbLast: TLabel
    Left = 455
    Top = 69
    Width = 12
    Height = 14
    Caption = '---'
  end
  object Label3: TLabel
    Left = 24
    Top = 35
    Width = 25
    Height = 14
    Caption = 'Extra'
  end
  object Button1: TButton
    Left = 3
    Top = 61
    Width = 134
    Height = 25
    Caption = 'Get Transactions'
    TabOrder = 0
    OnClick = Button1Click
  end
  object tbTrans: TStringGrid
    Left = 0
    Top = 88
    Width = 589
    Height = 245
    ColCount = 42
    DefaultRowHeight = 17
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
    TabOrder = 1
    OnDrawCell = tbTransDrawCell
    ColWidths = (
      84
      73
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64)
  end
  object rbASync: TRadioButton
    Left = 147
    Top = 66
    Width = 65
    Height = 17
    Caption = 'ASYNC'
    TabOrder = 2
  end
  object rbSync: TRadioButton
    Left = 219
    Top = 66
    Width = 65
    Height = 17
    Caption = 'SYNC'
    TabOrder = 3
  end
  object cmbAcc: TComboBox
    Left = 55
    Top = 7
    Width = 466
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 4
  end
  object Button2: TButton
    Left = 528
    Top = 6
    Width = 59
    Height = 20
    Caption = 'Repop'
    TabOrder = 5
    OnClick = Button2Click
  end
  object pbGetLOS: TButton
    Left = 320
    Top = 61
    Width = 33
    Height = 25
    Caption = 'Get'
    TabOrder = 6
    OnClick = GetLastOrdStat
  end
  object dfExtra: TEdit
    Left = 56
    Top = 32
    Width = 449
    Height = 22
    TabOrder = 7
  end
end
