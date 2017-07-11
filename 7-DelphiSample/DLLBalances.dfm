object frmDLLBalances: TfrmDLLBalances
  Left = 685
  Top = 133
  BorderStyle = bsToolWindow
  Caption = 'Account Balances'
  ClientHeight = 728
  ClientWidth = 282
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
  object Label2: TLabel
    Left = 99
    Top = 88
    Width = 45
    Height = 14
    Alignment = taRightJustify
    Caption = 'Total P&&L'
  end
  object Label3: TLabel
    Left = 81
    Top = 104
    Width = 63
    Height = 14
    Alignment = taRightJustify
    Caption = 'Realized P&&L'
  end
  object Label4: TLabel
    Left = 71
    Top = 120
    Width = 73
    Height = 14
    Alignment = taRightJustify
    Caption = 'Unrealized P&&L'
  end
  object lbPL: TLabel
    Left = 152
    Top = 88
    Width = 12
    Height = 14
    Caption = '---'
  end
  object lbRPL: TLabel
    Left = 152
    Top = 104
    Width = 12
    Height = 14
    Caption = '---'
  end
  object lbUPL: TLabel
    Left = 152
    Top = 120
    Width = 12
    Height = 14
    Caption = '---'
  end
  object tbBalances: TStringGrid
    Left = 0
    Top = 144
    Width = 282
    Height = 584
    Align = alBottom
    ColCount = 2
    Constraints.MaxWidth = 282
    Constraints.MinWidth = 282
    DefaultRowHeight = 17
    FixedCols = 0
    RowCount = 39
    FixedRows = 0
    Options = [goFixedVertLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    ScrollBars = ssNone
    TabOrder = 0
    ColWidths = (
      148
      129)
  end
  object Button1: TButton
    Left = 3
    Top = 53
    Width = 126
    Height = 25
    Caption = 'Refresh Balances'
    TabOrder = 1
    OnClick = Button1Click
  end
  object rbASync: TRadioButton
    Left = 139
    Top = 57
    Width = 65
    Height = 17
    Caption = 'ASYNC'
    TabOrder = 2
  end
  object rbSync: TRadioButton
    Left = 205
    Top = 57
    Width = 65
    Height = 17
    Caption = 'SYNC'
    TabOrder = 3
  end
  object cmbAcc: TComboBox
    Left = 7
    Top = 23
    Width = 290
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 4
  end
  object Button2: TButton
    Left = 56
    Top = 1
    Width = 59
    Height = 20
    Caption = 'Repop'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 3
    Top = 85
    Width = 70
    Height = 25
    Caption = 'Get P&&L'
    TabOrder = 6
    OnClick = Button3Click
  end
end
