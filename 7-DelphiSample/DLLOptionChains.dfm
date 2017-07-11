object frmDLLOptionChains: TfrmDLLOptionChains
  Left = 597
  Top = 287
  Width = 636
  Height = 404
  Caption = 'Option Chains'
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
    Left = 8
    Top = 8
    Width = 37
    Height = 13
    Caption = 'Symbol:'
  end
  object dfSym: TEdit
    Left = 48
    Top = 5
    Width = 57
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 112
    Top = 4
    Width = 73
    Height = 25
    Caption = 'Get Chain'
    TabOrder = 1
    OnClick = Button1Click
  end
  object tbChains: TStringGrid
    Left = 0
    Top = 41
    Width = 628
    Height = 336
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 7
    DefaultRowHeight = 17
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    TabOrder = 2
    ColWidths = (
      58
      64
      41
      42
      53
      54
      30)
  end
end
