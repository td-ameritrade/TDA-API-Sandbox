object frmDLLOrder: TfrmDLLOrder
  Left = 585
  Top = 145
  BorderStyle = bsToolWindow
  Caption = 'Order Services'
  ClientHeight = 722
  ClientWidth = 416
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
    Left = 29
    Top = 101
    Width = 35
    Height = 14
    Alignment = taRightJustify
    Caption = 'Symbol'
  end
  object Label2: TLabel
    Left = 33
    Top = 126
    Width = 31
    Height = 14
    Alignment = taRightJustify
    Caption = 'Action'
  end
  object Label3: TLabel
    Left = 25
    Top = 151
    Width = 39
    Height = 14
    Alignment = taRightJustify
    Caption = 'Ordtype'
  end
  object Label4: TLabel
    Left = 40
    Top = 176
    Width = 24
    Height = 14
    Alignment = taRightJustify
    Caption = 'Price'
  end
  object Label5: TLabel
    Left = 23
    Top = 201
    Width = 41
    Height = 14
    Alignment = taRightJustify
    Caption = 'ActPrice'
  end
  object Label6: TLabel
    Left = 8
    Top = 251
    Width = 56
    Height = 14
    Alignment = taRightJustify
    Caption = 'DisplaySize'
  end
  object Label7: TLabel
    Left = 261
    Top = 101
    Width = 30
    Height = 14
    Alignment = taRightJustify
    Caption = 'Expire'
  end
  object Label8: TLabel
    Left = 177
    Top = 126
    Width = 114
    Height = 14
    Alignment = taRightJustify
    Caption = 'ExDay/ExMonth/ExYear'
  end
  object Label9: TLabel
    Left = 254
    Top = 176
    Width = 37
    Height = 14
    Alignment = taRightJustify
    Caption = 'makerid'
  end
  object Label10: TLabel
    Left = 26
    Top = 226
    Width = 38
    Height = 14
    Alignment = taRightJustify
    Caption = 'quantity'
  end
  object Label11: TLabel
    Left = 255
    Top = 151
    Width = 36
    Height = 14
    Alignment = taRightJustify
    Caption = 'Routing'
  end
  object Label12: TLabel
    Left = 229
    Top = 201
    Width = 62
    Height = 14
    Alignment = taRightJustify
    Caption = 'spinstruction'
  end
  object Label13: TLabel
    Left = 252
    Top = 226
    Width = 39
    Height = 14
    Alignment = taRightJustify
    Caption = 'tsparam'
  end
  object Label14: TLabel
    Left = 8
    Top = 29
    Width = 393
    Height = 33
    AutoSize = False
    Caption = 
      'Note: there is no validation done on these fields in this form -' +
      ' they are sent out to the AMTD servers as they are entered.'
    WordWrap = True
  end
  object Label15: TLabel
    Left = 8
    Top = 485
    Width = 18
    Height = 14
    Caption = 'Log'
  end
  object Label16: TLabel
    Left = 200
    Top = 69
    Width = 64
    Height = 14
    Caption = 'Order is for'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Shape2: TShape
    Left = 1
    Top = 91
    Width = 409
    Height = 3
    Brush.Color = clRed
  end
  object Shape3: TShape
    Left = -6
    Top = 430
    Width = 409
    Height = 3
    Brush.Color = clRed
  end
  object Label18: TLabel
    Left = 13
    Top = 444
    Width = 51
    Height = 14
    Alignment = taRightJustify
    Caption = 'OrderID(s)'
  end
  object Shape4: TShape
    Left = 2
    Top = 277
    Width = 409
    Height = 3
    Brush.Color = clLime
  end
  object Label19: TLabel
    Left = 24
    Top = 405
    Width = 40
    Height = 14
    Alignment = taRightJustify
    Caption = 'Order ID'
  end
  object Label20: TLabel
    Left = 168
    Top = 203
    Width = 13
    Height = 12
    Caption = 'ç'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Wingdings'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label21: TLabel
    Left = 397
    Top = 72
    Width = 13
    Height = 12
    Caption = 'ç'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Wingdings'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label22: TLabel
    Left = 168
    Top = 151
    Width = 13
    Height = 12
    Caption = 'ç'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Wingdings'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label23: TLabel
    Left = 168
    Top = 179
    Width = 13
    Height = 12
    Caption = 'ç'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Wingdings'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label24: TLabel
    Left = 168
    Top = 228
    Width = 13
    Height = 12
    Caption = 'ç'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Wingdings'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label25: TLabel
    Left = 176
    Top = 397
    Width = 11
    Height = 12
    Caption = 'é'
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Wingdings'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label26: TLabel
    Left = 192
    Top = 397
    Width = 78
    Height = 28
    Caption = '- fields that can be modified'
    WordWrap = True
  end
  object Shape5: TShape
    Left = 2
    Top = 382
    Width = 409
    Height = 3
    Brush.Color = clRed
  end
  object Label27: TLabel
    Left = 6
    Top = 289
    Width = 59
    Height = 14
    Caption = 'Submit Type'
  end
  object Label28: TLabel
    Left = 6
    Top = 313
    Width = 56
    Height = 14
    Caption = 'OrderString'
  end
  object Label17: TLabel
    Left = 8
    Top = 4
    Width = 41
    Height = 14
    Caption = 'Account'
  end
  object dfSymbol: TEdit
    Left = 69
    Top = 97
    Width = 97
    Height = 22
    TabOrder = 1
  end
  object cmbaction: TComboBox
    Left = 69
    Top = 122
    Width = 97
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 2
    Items.Strings = (
      'buy'
      'sell'
      'sellshort'
      'buytocover')
  end
  object cmbordtype: TComboBox
    Left = 69
    Top = 147
    Width = 97
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 3
    Items.Strings = (
      'market'
      'limit'
      'stop_market'
      'stop_limit'
      'tstoppercent'
      'tstopdollar')
  end
  object dfPrice: TEdit
    Left = 69
    Top = 172
    Width = 97
    Height = 22
    TabOrder = 4
  end
  object dfactprice: TEdit
    Left = 69
    Top = 197
    Width = 97
    Height = 22
    TabOrder = 5
  end
  object dfdisplaysize: TEdit
    Left = 69
    Top = 247
    Width = 97
    Height = 22
    TabOrder = 7
  end
  object cmbExpire: TComboBox
    Left = 296
    Top = 97
    Width = 97
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 8
    Items.Strings = (
      'day'
      'day_ext'
      'am'
      'pm'
      'gtc'
      'gtc_ext'
      'moc')
  end
  object dfexdate: TEdit
    Left = 296
    Top = 122
    Width = 97
    Height = 22
    TabOrder = 9
  end
  object dfmakerid: TEdit
    Left = 296
    Top = 172
    Width = 97
    Height = 22
    TabOrder = 11
  end
  object dfquantity: TEdit
    Left = 69
    Top = 222
    Width = 97
    Height = 22
    TabOrder = 6
  end
  object cmbrouting: TComboBox
    Left = 296
    Top = 147
    Width = 97
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 10
    Items.Strings = (
      'auto'
      'inet'
      'ecn_arca')
  end
  object cmbspinstruction: TComboBox
    Left = 296
    Top = 197
    Width = 97
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 12
    Items.Strings = (
      'none'
      'fok'
      'aon'
      'dnr'
      'aon_dnr'
      'not_held')
  end
  object Button1: TButton
    Left = 296
    Top = 248
    Width = 97
    Height = 25
    Caption = 'Submit New'
    TabOrder = 13
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 5
    Top = 501
    Width = 403
    Height = 209
    TabOrder = 21
  end
  object cmbWhich: TComboBox
    Left = 268
    Top = 66
    Width = 125
    Height = 22
    Style = csDropDownList
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
    OnClick = cmbWhichClick
    Items.Strings = (
      'Stock'
      'Option'
      'Mutual Fund')
  end
  object dfOrderIDs: TEdit
    Left = 69
    Top = 440
    Width = 324
    Height = 22
    TabOrder = 19
  end
  object Button3: TButton
    Left = 296
    Top = 470
    Width = 97
    Height = 25
    Caption = 'Cancel Order(s)'
    TabOrder = 20
    OnClick = Button3Click
  end
  object dfOrdNum: TEdit
    Left = 69
    Top = 401
    Width = 97
    Height = 22
    TabOrder = 17
  end
  object pbMod: TButton
    Left = 272
    Top = 397
    Width = 122
    Height = 25
    Caption = 'Modify Order'
    TabOrder = 18
    OnClick = pbModClick
  end
  object rbASync: TRadioButton
    Left = 8
    Top = 67
    Width = 65
    Height = 17
    Caption = 'ASYNC'
    TabOrder = 22
  end
  object rbSync: TRadioButton
    Left = 80
    Top = 67
    Width = 65
    Height = 17
    Caption = 'SYNC'
    TabOrder = 23
  end
  object cmbSubType: TComboBox
    Left = 69
    Top = 287
    Width = 164
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 14
    Items.Strings = (
      'TDAPI_SUBMIT_New'
      'TDAPI_SUBMIT_NewConfirm'
      'TDAPI_SUBMIT_Cancel'
      'TDAPI_SUBMIT_CancelConfirm'
      'TDAPI_SUBMIT_Modify'
      'TDAPI_SUBMIT_ModifyConfirm')
  end
  object mOrderStr: TMemo
    Left = 70
    Top = 313
    Width = 323
    Height = 65
    TabOrder = 15
  end
  object pbSubmitRaw: TButton
    Left = 296
    Top = 284
    Width = 97
    Height = 25
    Caption = 'Submit Raw'
    TabOrder = 16
    OnClick = pbSubmitRawClick
  end
  object cmbAcc: TComboBox
    Left = 57
    Top = 2
    Width = 272
    Height = 22
    Style = csDropDownList
    ItemHeight = 14
    TabOrder = 24
  end
  object Button2: TButton
    Left = 328
    Top = 1
    Width = 59
    Height = 20
    Caption = 'Repop'
    TabOrder = 25
    OnClick = Button2Click
  end
  object dfTSParam: TEdit
    Left = 296
    Top = 220
    Width = 97
    Height = 22
    TabOrder = 26
  end
end
