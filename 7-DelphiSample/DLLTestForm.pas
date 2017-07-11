unit DLLTestForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,TDATypes,TDADLLHeaders,DLLTestGlobals,DLLOrder,
  DLLTestL1, DLLTestL2,DLLTestNews, DLLBalances,DLLPositions,DLLTransactions,
  DLLHistBackfill,DLLBackfill,DLLActives,DLLOptionChains,DLLAccounts,ExtCtrls,DLLSnap;

type
  TfrmTestDLL = class(TForm)
    Memo1: TMemo;
    pbInit: TButton;
    pbLogin: TButton;
    Label1: TLabel;
    dfName: TEdit;
    dfPass: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    pbL1: TButton;
    Shape1: TShape;
    pbL2: TButton;
    Timer1: TTimer;
    pbNews: TButton;
    pbBalances: TButton;
    pbPositions: TButton;
    pbTrans: TButton;
    pbSubmit: TButton;
    pbBackfill: TButton;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    pbAccounts: TButton;
    Label4: TLabel;
    dfTradeServer: TEdit;
    Button2: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Label5: TLabel;
    dfSourceApp: TEdit;
    procedure pbInitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pbLoginClick(Sender: TObject);
    procedure pbL1Click(Sender: TObject);
    procedure pbL2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure pbNewsClick(Sender: TObject);
    procedure pbBalancesClick(Sender: TObject);
    procedure pbPositionsClick(Sender: TObject);
    procedure pbTransClick(Sender: TObject);
    procedure pbSubmitClick(Sender: TObject);
    procedure pbBackfillClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure pbAccountsClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
    Ping:char;
    GCtr:integer;
  public
    { Public declarations }
    SubID:integer;
  end;

var
  frmTestDLL: TfrmTestDLL;

implementation



{$R *.DFM}

Procedure StatusChange(CType,CPtr:integer;OldStatus,NewStatus:integer);stdcall;
Var L1,L2:PChar;
begin
  GetMem(L1,100);
  GetMem(L2,100);
  try
    TDAGetStreamStatusStr(OldStatus,L1,100);
    TDAGetStreamStatusStr(NewStatus,L2,100);
    TfrmTestDLL(Cptr).Memo1.Lines.Add(L1+' --> '+L2);
  finally
    FreeMem(L1);
    FreeMem(L2);
  end;
end;

Procedure GotPing(CType,CPtr:integer;H:char);stdcall;
Var L1,L2:PChar;
begin
  try
     TfrmTestDLL(Cptr).Ping:=H;
  finally
  end;
end;


Procedure GotData(CType,CPtr:integer;H:char;S:integer);stdcall;
begin
  frmTestDLL.Memo1.Lines.Add('Header: '+H+' '+IntToStr(S));
end;

Procedure GotMessage(CType,CPtr:integer;const M:PChar);stdcall;
begin
  frmTestDLL.Memo1.Lines.Add('Message: '+M);
end;

Procedure GotBackfill(CType,CPtr:integer; const Sym:PChar; Tot:integer; Ptr: PAPIBFArray; const Err:PChar);stdcall;
begin
  frmTestDLL.Memo1.Lines.Add('Got Backfill '+Err+' '+Sym+':'+IntToStr(Tot));
end;

Procedure GotBalances(CType,CPtr:integer;B:TAPIBalances);stdcall;
begin
  frmTestDLL.Memo1.Lines.Add('Got Balances');
end;

Procedure GotPositions(CType,CPtr:integer;TotP:integer;P:PAPIPositionArray);stdcall;
begin
  frmTestDLL.Memo1.Lines.Add('Got Positions: '+IntToStr(TotP));
end;

Procedure GotOrderStatus(CType,CPtr:integer;TotO:integer;P:PAPITransactionArray);stdcall;
begin
  frmTestDLL.Memo1.Lines.Add('Got Transactions: '+IntToStr(TotO));
end;


procedure TfrmTestDLL.pbInitClick(Sender: TObject);
Var Res:integer;
    S:string;
begin
  MainTDAHandle:=TDAInitSession(101);
  Res:=TDASetLoginSite(MainTDAHandle,PChar(trim(dfTradeServer.Text)));
  S:=IntToStr(TDASTop(MainTDAHandle));
  Memo1.Lines.Add(S);

  SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
//  TDASetProxy(MainTDAHandle,'127.0.0.1',8080,'127.0.0.1',8081,nil,nil,FALSE);
  TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_StatusChange,@StatusChange);
  TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_Ping,@GotPing);
  TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_GotMessage,@GotMessage);
  pbInit.Caption:='Initialized Handle='+IntToStr(MainTDAHandle);


end;

procedure TfrmTestDLL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 TDATerminateSession(MainTDAHandle)
end;

procedure TfrmTestDLL.pbLoginClick(Sender: TObject);
Var P:PChar;
    S:string;
    Res:integer;
begin
  Res:=TDASetSourceApp(MainTDAHandle,PChar(Trim(dfSourceApp.Text)));
  TDASetLoginInfo(MainTDAHandle,PChar(Trim(dfName.Text)),PChar(Trim(dfPass.Text)));
  TDAStart(MainTDAHandle);
//  TDASetLoginSite(MainTDAHandle,'betas.ameritrade.com');
{  TDAStop(MainTDAHandle);
  TDATerminateSession(MainTDAHandle); }
  SetLength(S,255);
  if Assigned(TDAGetStreamingSites) then
    Res:=TDAGetStreamingSites(MainTDAHandle,PChar(S),255);
  S:=Trim(S)+IntToStr(Res);
end;

procedure TfrmTestDLL.pbL1Click(Sender: TObject);
begin
  With TfrmDLLL1.Create(Self) do Show;
end;



procedure TfrmTestDLL.pbL2Click(Sender: TObject);
begin
  With TfrmDLLL2.Create(Self) do Show;
end;

procedure TfrmTestDLL.FormCreate(Sender: TObject);
begin
  Ping:=#0;
end;

Function GetMidColor(CFrom,CTo:TColor;Cnt,Tot:integer):TColor;
Var R1,G1,B1:integer;
    R2,G2,B2:integer;
begin
  CFrom:=ColorToRGB(CFrom);CTo:=ColorToRGB(CTo);
  R1:=CFrom and $FF;
  G1:=CFrom and $FF00 shr 8;
  B1:=CFrom and $FF0000 shr 16;
  R2:=CTo and $FF;
  G2:=CTo and $FF00 shr 8;
  B2:=CTo and $FF0000 shr 16;
  R1:=(R1*Cnt+R2*(Tot-Cnt)) div Tot;
  G1:=(G1*Cnt+G2*(Tot-Cnt)) div Tot;
  B1:=(B1*Cnt+B2*(Tot-Cnt)) div Tot;
  Result:=RGB(R1,G1,B1);
end;


procedure TfrmTestDLL.Timer1Timer(Sender: TObject);
begin
  if Ping='Y' then Shape1.Brush.Color:=clYellow
  else
  if Ping='R' then Shape1.Brush.Color:=clRed
  else
  if Ping='G' then
  begin
    GCtr:=5;Shape1.Brush.Color:=clLime;
    Ping:='g';
  end
  else
  if (Ping='g') and (GCtr>0) then
  begin
    Dec(GCtr);Shape1.Brush.Color:=GetMidColor(clLime,clGreen,GCtr,5);
  end;
end;

procedure TfrmTestDLL.pbNewsClick(Sender: TObject);
begin
  With TfrmDLLNews.Create(Self) do Show;
end;

procedure TfrmTestDLL.pbBalancesClick(Sender: TObject);
begin
  With TfrmDLLBalances.Create(Self) do Show;
end;

procedure TfrmTestDLL.pbPositionsClick(Sender: TObject);
begin
  With TfrmDLLPositions.Create(Self) do Show;
end;

procedure TfrmTestDLL.pbTransClick(Sender: TObject);
begin
  With TfrmDLLTransactions.Create(Self) do Show;
end;

procedure TfrmTestDLL.pbSubmitClick(Sender: TObject);
begin
  With TfrmDLLOrder.Create(Self) do Show;
end;

procedure TfrmTestDLL.pbBackfillClick(Sender: TObject);
begin
  With TfrmDLLBackfill.Create(Self) do Show;
end;

procedure TfrmTestDLL.Button1Click(Sender: TObject);
begin
  TDAStart(MainTDAHandle);
end;


procedure TfrmTestDLL.Button3Click(Sender: TObject);
begin
  TDAStop(MainTDAHandle);
end;

procedure TfrmTestDLL.Button4Click(Sender: TObject);
begin
  With TfrmDLLAct.Create(Self) do Show;
end;

procedure TfrmTestDLL.pbAccountsClick(Sender: TObject);
begin
  With TfrmDLLAccounts.Create(Self) do Show;
end;


procedure TfrmTestDLL.Button2Click(Sender: TObject);
begin
  With TfrmDLLSnap.Create(Self) do Show;
end;

procedure TfrmTestDLL.Button5Click(Sender: TObject);
begin
  TDAKeepAlive(MainTDAHandle);
end;

procedure TfrmTestDLL.Button6Click(Sender: TObject);
begin
  TDALogout(MainTDAHandle);
end;

procedure TfrmTestDLL.Button7Click(Sender: TObject);
begin
  With TfrmDLLOptionChains.Create(Self) do Show;
end;

procedure TfrmTestDLL.Button8Click(Sender: TObject);
begin
  With TfrmDLLHistBackfill.Create(Self) do Show;
end;

end.
