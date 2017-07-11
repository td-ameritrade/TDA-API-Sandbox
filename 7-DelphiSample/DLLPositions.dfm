object frmDLLPositions: TfrmDLLPositions
  Left = 99
  Top = 372
  BorderStyle = bsToolWindow
  Caption = 'Account Positions'
  ClientHeight = 328
  ClientWidth = 556
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
    Top = 4
    Width = 41
    Height = 14
    Caption = 'Account'
  end
  object Button1: TButton
    Left = 3
    Top = 33
    Width = 126
    Height = 25
    Caption = 'Refresh Positions'
    TabOrder = 0
    OnClick = Button1Click
  end
  object tbPositions: TStringGrid
    Left = 0
    Top = 69
    Width = 556
    Height = 259
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 10
    DefaultRowHeight = 17
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 1
    ColWidths = (
      58
      64
      41
      42
      53
      54
      30
      63
      47
      90)
  end
  object rbASync: TRadioButton
    Left = 136
    Top = 37
    Width = 65
    Height = 17
    Caption = 'ASYNC'
    TabOrder = 2
  end
  object rbSync: TRadioButton
    Left = 202
    Top = 37
    Width = 65
    Height = 17
    Caption = 'SYNC'
    TabOrder = 3
  end
  object cmbAcc: TComboBox
    Left = 55
    Top = 2
    Width = 450
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 4
  end
  object Button2: TButton
    Left = 512
    Top = 1
    Width = 59
    Height = 20
    Caption = 'Repop'
    TabOrder = 5
    OnClick = Button2Click
  end
end
