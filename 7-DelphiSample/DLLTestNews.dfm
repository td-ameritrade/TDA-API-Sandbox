object frmDLLNews: TfrmDLLNews
  Left = 360
  Top = 371
  BorderStyle = bsToolWindow
  Caption = 'News'
  ClientHeight = 326
  ClientWidth = 653
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
    Top = 11
    Width = 41
    Height = 14
    Caption = 'Symbols'
  end
  object Label2: TLabel
    Left = 56
    Top = 40
    Width = 158
    Height = 14
    Caption = 'Snapshot News Stories Request'
  end
  object dfSym: TEdit
    Left = 53
    Top = 7
    Width = 516
    Height = 22
    TabOrder = 0
  end
  object Button1: TButton
    Left = 576
    Top = 4
    Width = 73
    Height = 25
    Caption = 'Subscribe'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 64
    Width = 641
    Height = 257
    Lines.Strings = (
      '')
    TabOrder = 2
  end
  object dfSnapSym: TEdit
    Left = 224
    Top = 35
    Width = 121
    Height = 22
    TabOrder = 3
  end
  object Button2: TButton
    Left = 354
    Top = 34
    Width = 73
    Height = 25
    Caption = 'Request'
    TabOrder = 4
    OnClick = Button2Click
  end
end
