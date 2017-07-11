unit DLLOrder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,TDATypes,TDADLLHeaders,DLLTestGlobals, Grids, ExtCtrls;

type
  TfrmDLLOrder = class(TForm)
    Label1: TLabel;
    dfSymbol: TEdit;
    Label2: TLabel;
    cmbaction: TComboBox;
    cmbordtype: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    dfPrice: TEdit;
    Label5: TLabel;
    dfactprice: TEdit;
    Label6: TLabel;
    dfdisplaysize: TEdit;
    Label7: TLabel;
    cmbExpire: TComboBox;
    dfexdate: TEdit;
    Label8: TLabel;
    dfmakerid: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    dfquantity: TEdit;
    Label11: TLabel;
    cmbrouting: TComboBox;
    cmbspinstruction: TComboBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Button1: TButton;
    Label15: TLabel;
    Memo1: TMemo;
    Label16: TLabel;
    cmbWhich: TComboBox;
    Shape2: TShape;
    Shape3: TShape;
    Label18: TLabel;
    dfOrderIDs: TEdit;
    Button3: TButton;
    Shape4: TShape;
    Label19: TLabel;
    dfOrdNum: TEdit;
    pbMod: TButton;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    rbASync: TRadioButton;
    rbSync: TRadioButton;
    Shape5: TShape;
    Label27: TLabel;
    cmbSubType: TComboBox;
    Label28: TLabel;
    mOrderStr: TMemo;
    pbSubmitRaw: TButton;
    Label17: TLabel;
    cmbAcc: TComboBox;
    Button2: TButton;
    dfTSParam: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure pbModClick(Sender: TObject);
    procedure cmbWhichClick(Sender: TObject);
    procedure pbSubmitRawClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    SubID: integer;
  public
    { Public declarations }
  end;

var
  frmDLLOrder: TfrmDLLOrder;

implementation

{$R *.DFM}

Procedure GotOrderAck(CType,CPtr:integer;const AckType,AckStr:PChar);stdcall;
begin
  TfrmDLLOrder(CPtr).Memo1.Lines.Add('Message: '+AckType+' '+AckStr);
end;

procedure TfrmDLLOrder.FormCreate(Sender: TObject);
begin
 SubID:=-1;
 cmbSubType.ItemIndex:=0;
end;

procedure TfrmDLLOrder.FormShow(Sender: TObject);
begin
  if SubID=-1 then
  begin
    SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_OrderAck,@GotOrderAck);
  end;
  Button2Click(nil);
  cmbWhich.ItemIndex:=0;
  cmbWhichClick(cmbWhich);
  rbASync.Checked:=TRUE;
end;

procedure TfrmDLLOrder.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if SubID<>-1 then
    TDAUnRegisterSubscriber(MainTDAHandle,SubID);
end;

procedure TfrmDLLOrder.Button1Click(Sender: TObject);
Var S:string;
    A:string;
    P:integer;
    PC:PChar;
    AID:string;
    PP:integer;
begin
  AID:=cmbAcc.Items[cmbAcc.ItemIndex];
  PP:=Pos(' ',AID);if PP>0 then Delete(AID,PP,$FFFF);
  // construct the string
  S:='accountid='+AID+'~';
  S:=S+'symbol='+UpperCase(Trim(dfSymbol.Text))+'~';
  S:=S+'action='+cmbAction.Text+'~';
  S:=S+'ordtype='+cmbOrdType.Text+'~';
  S:=S+'price='+dfPrice.Text+'~';
  S:=S+'actprice='+dfActPrice.Text+'~';
  S:=S+'quantity='+dfQuantity.Text+'~';
  S:=S+'expire='+cmbExpire.Text+'~';
  if cmbWhich.ItemIndex=1 then
   S:=S+'tabid=0~';
  if cmbWhich.ItemIndex=0 then
  begin
    S:=S+'displaysize='+dfDisplaySize.Text+'~';
    S:=S+'makerid='+dfmakerid.Text+'~';
    S:=S+'tsparam='+dftsparam.Text+'~';
  end;
  A:=Trim(dfexdate.Text);
  P:=Pos('/',A); if P=0 then P:=Length(A)+1; if Length(A)=1 then A:='0'+A;S:=S+'exday='+System.Copy(A,1,P-1)+'~';Delete(A,1,P);
  P:=Pos('/',A); if P=0 then P:=Length(A)+1; if Length(A)=1 then A:='0'+A;S:=S+'exmonth='+System.Copy(A,1,P-1)+'~';Delete(A,1,P);
  P:=Pos('/',A); if P=0 then P:=Length(A)+1; if Length(A)=1 then A:='0'+A;S:=S+'exyear='+System.Copy(A,1,P-1)+'~';Delete(A,1,P);
  S:=S+'spinstructions='+cmbspinstruction.Text+'~';
  S:=S+'routing='+cmbrouting.Text+'~';

  Memo1.Lines.Add('OrderString: '+S);
  Memo1.Lines.Add('');

  if rbASync.Checked then
    TDAOrderCommand(MainTDAHandle,SubID,'SOF'[cmbWhich.ItemIndex+1],TDAPI_SUBMIT_New,PChar(S))
  else
  begin
    GetMem(PC,1000);
    if TDAOrderCommandX(MainTDAHandle,'SOF'[cmbWhich.ItemIndex+1],TDAPI_SUBMIT_New,PChar(S),PC,1000)>=0 then
    begin
      S:='Sync: '+PC;
      Memo1.Lines.Add(S);
    end;
    FreeMem(PC);
  end;
end;


procedure TfrmDLLOrder.Button3Click(Sender: TObject);
Var AID,S:string;
    PC:PChar;
    PP:integer;
begin
  AID:=cmbAcc.Items[cmbAcc.ItemIndex];
  PP:=Pos(' ',AID);if PP>0 then Delete(AID,PP,$FFFF);
  S:=Trim(dfOrderIDs.Text);
  S:='accountid='+AID+'~'+S;


  Memo1.Lines.Add('OrderString: '+S);
  Memo1.Lines.Add('');

  if rbASync.Checked then
    TDAOrderCommand(MainTDAHandle,SubID,'SOF'[cmbWhich.ItemIndex+1],TDAPI_SUBMIT_Cancel,PChar(S))
  else
  begin
    GetMem(PC,1000);
    if TDAOrderCommandX(MainTDAHandle,'SOF'[cmbWhich.ItemIndex+1],TDAPI_SUBMIT_Cancel,PChar(S),PC,1000)>=0 then
    begin
      S:='Sync: '+PC;
      Memo1.Lines.Add(S);
    end;
    FreeMem(PC);
  end;
end;

procedure TfrmDLLOrder.pbModClick(Sender: TObject);
Var S,A:string;
    PP,P:integer;
    PC:PChar;
    AID:string;
begin
  // construct the string
  AID:=cmbAcc.Items[cmbAcc.ItemIndex];
  PP:=Pos(' ',AID);if PP>0 then Delete(AID,PP,$FFFF);
  // construct the string
  S:='accountid='+AID+'~';
  S:=S+'orderid='+UpperCase(Trim(dfOrdNum.Text))+'~';
  A:=cmbOrdType.Text;
  S:=S+'ordtype='+A+'~';
  S:=S+'price='+dfPrice.Text+'~';
  S:=S+'actprice='+dfActPrice.Text+'~';
  S:=S+'quantity='+dfQuantity.Text+'~';

  S:=S+'expire='+cmbExpire.Text+'~';
  A:=Trim(dfexdate.Text);
  if A<>'' then
  begin
    P:=Pos('/',A); if P=0 then P:=Length(A)+1; if Length(A)=1 then A:='0'+A;S:=S+'exday='+System.Copy(A,1,P-1)+'~';Delete(A,1,P);
    P:=Pos('/',A); if P=0 then P:=Length(A)+1; if Length(A)=1 then A:='0'+A;S:=S+'exmonth='+System.Copy(A,1,P-1)+'~';Delete(A,1,P);
    P:=Pos('/',A); if P=0 then P:=Length(A)+1; if Length(A)=1 then A:='0'+A;S:=S+'exyear='+System.Copy(A,1,P-1)+'~';Delete(A,1,P);
  end;  
{  if (dfExDate.Text='') or (Pos('/',dfExDate.Text)=0) then
  begin
    Memo1.Lines.Add('LOCAL VALIDATION: ExDay/ExMonth/ExYear are REQUIRED for Modify');
    Exit;
  end; }

  Memo1.Lines.Add('OrderString: '+S);
  Memo1.Lines.Add('');

  if rbASync.Checked then
    TDAOrderCommand(MainTDAHandle,SubID,'SOF'[cmbWhich.ItemIndex+1],TDAPI_SUBMIT_MODIFY,PChar(S))
  else
  begin
    GetMem(PC,1000);
    if TDAOrderCommandX(MainTDAHandle,'SOF'[cmbWhich.ItemIndex+1],TDAPI_SUBMIT_MODIFY,PChar(S),PC,1000)>=0 then
    begin
      S:='Sync: '+PC;
      Memo1.Lines.Add(S);
    end;
    FreeMem(PC);
  end;
end;

procedure TfrmDLLOrder.cmbWhichClick(Sender: TObject);
begin
  //---------------
  Case cmbWhich.ItemIndex of
    0: begin
         cmbAction.Items.Text:='buy'#13#10'sell'#13#10'sellshort'#13#10'buytocover';
         cmbRouting.Items.Text:='auto'#13#10'inet'#13#10'ecn_arca';
         cmbExpire.Items.Text:='day'#13#10'day_ext'#13#10'am'#13#10'pm'#13#10'gtc'#13#10'gtc_ext'#13#10'moc';
       end;
    1: begin
         cmbAction.Items.Text:='buytoopen'#13#10'buytoclose'#13#10'selltoopen'#13#10'selltoclose';
         cmbRouting.Items.Text:='auto'#13#10'bosx'#13#10'cboe'#13#10'amex'#13#10'phlx'#13#10'pacx'#13#10'isex';
         cmbExpire.Items.Text:='day'#13#10'gtc';
       end;
    2: begin
         cmbAction.Items.Text:='buy'#13#10'sell'#13#10'sellshort'#13#10'buytocover';
         cmbRouting.Items.Text:='auto'#13#10'inet'#13#10'ecn_arca';
         cmbExpire.Items.Text:='day'#13#10'day_ext'#13#10'am'#13#10'pm'#13#10'gtc'#13#10'gtc_ext'#13#10'moc';
       end;
  end;
end;

procedure TfrmDLLOrder.pbSubmitRawClick(Sender: TObject);
Var S:string;
    PC:PChar;
begin
  S:=mOrderStr.Text;

  Memo1.Lines.Add('OrderString: '+S);
  Memo1.Lines.Add('');

  if rbASync.Checked then
    TDAOrderCommand(MainTDAHandle,SubID,'SOF'[cmbWhich.ItemIndex+1],cmbSubType.ItemIndex+1,PChar(S))
  else
  begin
    GetMem(PC,1000);
    if TDAOrderCommandX(MainTDAHandle,'SOF'[cmbWhich.ItemIndex+1],cmbSubType.ItemIndex+1,PChar(S),PC,1000)>=0 then
    begin
      S:='Sync: '+PC;
      Memo1.Lines.Add(S);
    end;
    FreeMem(PC);
  end;
end;

procedure TfrmDLLOrder.Button2Click(Sender: TObject);
Var S,A:string;
    L:integer;
    Info:TAPIAccountInfo;
begin
  cmbAcc.Items.Clear;
  SetLength(S,1000);
  L:=TDAGetAccountIDs(MainTDAHandle,@(S[1]),1000);
  if L<0 then Exit;
  SetLength(S,L);
  While S<>'' do
  begin
    L:=Pos(',',S);if L=0 then L:=Length(S)+1;
    A:=Copy(S,1,L-1);Delete(S,1,L);
    TDAGetAccountInfo(MainTDAHandle,PChar(A),@(Info));
    cmbAcc.Items.Add(A+' '+PChar(@(Info.Desc)));
  end;
  cmbAcc.ItemIndex:=0;
end;

end.
