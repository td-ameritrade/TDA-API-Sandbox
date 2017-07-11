object frmDLLAccounts: TfrmDLLAccounts
  Left = 626
  Top = 160
  BorderStyle = bsDialog
  Caption = 'Accounts'
  ClientHeight = 274
  ClientWidth = 411
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
    Top = 8
    Width = 41
    Height = 14
    Caption = 'Account'
  end
  object cmbAcc: TComboBox
    Left = 55
    Top = 5
    Width = 282
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 0
    OnClick = cmbAccClick
  end
  object tbAccount: TStringGrid
    Left = 8
    Top = 32
    Width = 395
    Height = 237
    ColCount = 2
    DefaultRowHeight = 17
    FixedCols = 0
    RowCount = 13
    Options = [goFixedVertLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 1
    ColWidths = (
      239
      151)
  end
  object Button2: TButton
    Left = 344
    Top = 4
    Width = 62
    Height = 25
    Caption = 'Repop'
    TabOrder = 2
    OnClick = Button2Click
  end
end
