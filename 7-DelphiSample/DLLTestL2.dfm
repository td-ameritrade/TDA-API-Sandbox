object frmDLLL2: TfrmDLLL2
  Left = 555
  Top = 212
  BorderStyle = bsToolWindow
  Caption = 'Level II'
  ClientHeight = 444
  ClientWidth = 470
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
    Left = 22
    Top = 64
    Width = 73
    Height = 14
    Alignment = taRightJustify
    Caption = 'Total Bid Rows'
  end
  object lBidRows: TLabel
    Left = 104
    Top = 64
    Width = 33
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object lBids: TLabel
    Left = 104
    Top = 80
    Width = 33
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object Label4: TLabel
    Left = 48
    Top = 80
    Width = 47
    Height = 14
    Alignment = taRightJustify
    Caption = 'Total Bids'
  end
  object Label5: TLabel
    Left = 210
    Top = 64
    Width = 77
    Height = 14
    Alignment = taRightJustify
    Caption = 'Total Ask Rows'
  end
  object Label6: TLabel
    Left = 236
    Top = 80
    Width = 51
    Height = 14
    Alignment = taRightJustify
    Caption = 'Total Asks'
  end
  object lAsks: TLabel
    Left = 296
    Top = 80
    Width = 33
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object lAskRows: TLabel
    Left = 296
    Top = 64
    Width = 33
    Height = 13
    AutoSize = False
    Caption = '---'
  end
  object dfSym: TEdit
    Left = 48
    Top = 5
    Width = 57
    Height = 22
    TabOrder = 0
  end
  object pbSub: TButton
    Tag = 1
    Left = 320
    Top = 12
    Width = 137
    Height = 25
    Caption = 'Sub to old L2 (obsolete)'
    TabOrder = 5
    OnClick = pbSubClick
  end
  object mBids: TMemo
    Left = 0
    Top = 104
    Width = 231
    Height = 337
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object mAsks: TMemo
    Left = 234
    Top = 104
    Width = 231
    Height = 337
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object pbArca: TButton
    Tag = 2
    Left = 224
    Top = 30
    Width = 92
    Height = 25
    Caption = 'Sub to ARCA'
    TabOrder = 4
    OnClick = pbSubClick
  end
  object pbIsland: TButton
    Tag = 3
    Left = 224
    Top = 4
    Width = 92
    Height = 25
    Caption = 'Sub to ISLD'
    TabOrder = 3
    OnClick = pbSubClick
  end
  object Button1: TButton
    Tag = 4
    Left = 120
    Top = 5
    Width = 92
    Height = 25
    Caption = 'Sub to New L2'
    TabOrder = 1
    OnClick = pbSubClick
  end
  object Button2: TButton
    Tag = 5
    Left = 120
    Top = 31
    Width = 92
    Height = 25
    Caption = 'Sub to TotalView'
    TabOrder = 2
    OnClick = pbSubClick
  end
end
