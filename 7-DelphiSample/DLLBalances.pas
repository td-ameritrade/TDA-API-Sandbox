unit DLLBalances;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,TDATypes,TDADLLHeaders,DLLTestGlobals, Grids;

type
  TfrmDLLBalances = class(TForm)
    tbBalances: TStringGrid;
    Button1: TButton;
    rbASync: TRadioButton;
    rbSync: TRadioButton;
    Label1: TLabel;
    cmbAcc: TComboBox;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lbPL: TLabel;
    lbRPL: TLabel;
    lbUPL: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    SubID: integer;
  public
    { Public declarations }
  end;

var
  frmDLLBalances: TfrmDLLBalances;

implementation

{$R *.DFM}

Procedure GotPandL(OType,OPtr:integer; const Acc:PChar; PandL,RealizedPandL,UnrealizedPandL:double);stdcall;
begin
  With TfrmDLLBalances(OPtr) do
  begin
    lbPL.Caption:=FloatToStr(PandL);
    lbRPL.Caption:=FloatToStr(RealizedPandL);
    lbUPL.Caption:=FloatToStr(UnrealizedPandL);
  end;  
end;

Procedure GotBalances(OType,OPtr:integer; B: PAPIBalances);stdcall;
Var R:integer;
begin
  With TfrmDLLBalances(OPtr).tbBalances,B^ do
  begin
    RowCount:=35;
    R:=0;
    Cells[0,R]:='Account ID';           Cells[1,R]:=AccountID;                                                  Inc(R);
    Cells[0,R]:='Daytrader';            if DayTrader then Cells[1,R]:='true' else Cells[1,R]:='false';          Inc(R);
    Cells[0,R]:='Closing Transactions Only'; if DayTrader then Cells[1,R]:='true' else Cells[1,R]:='false';     Inc(R);
    Cells[0,R]:='Round Trips';          Cells[1,R]:=IntToStr(RoundTrips);                                       Inc(R);
    Cells[0,R]:='In Call';              if InCall then Cells[1,R]:='true' else Cells[1,R]:='false';          Inc(R);
    Cells[0,R]:='In Potential Call';    if InPotentialCall then Cells[1,R]:='true' else Cells[1,R]:='false';          Inc(R);

    Cells[0,R]:='Cash Balance';                 Cells[1,R]:=FloatToStr(CashBalance)+' ('+FloatToStr(CashBalanceChange)+')';     Inc(R);
    Cells[0,R]:='Money Market Balance';         Cells[1,R]:=FloatToStr(MoneyMarketBalance)+' ('+FloatToStr(MoneyMarketBalanceChange)+')';       Inc(R);
    Cells[0,R]:='Long Stock Value';             Cells[1,R]:=FloatToStr(LongStockValue)+' ('+FloatToStr(LongStockValueChange)+')';       Inc(R);
    Cells[0,R]:='Long Option Value';            Cells[1,R]:=FloatToStr(LongOptionValue)+' ('+FloatToStr(LongOptionValueChange)+')';       Inc(R);
    Cells[0,R]:='Short Option Value';           Cells[1,R]:=FloatToStr(ShortOptionValue)+' ('+FloatToStr(ShortOptionValueChange)+')';       Inc(R);
    Cells[0,R]:='Mutual Fund Value';            Cells[1,R]:=FloatToStr(MutualFundValue)+' ('+FloatToStr(MutualFundValueChange)+')';       Inc(R);
    Cells[0,R]:='Bond Value';                   Cells[1,R]:=FloatToStr(BondValue)+' ('+FloatToStr(BondValueChange)+')';       Inc(R);
    Cells[0,R]:='Account Value';                Cells[1,R]:=FloatToStr(AccountValue)+' ('+FloatToStr(AccountValueChange)+')';       Inc(R);
    Cells[0,R]:='Pending Deposits';             Cells[1,R]:=FloatToStr(PendingDeposits)+' ('+FloatToStr(PendingDepositsChange)+')';       Inc(R);
    Cells[0,R]:='Short Balance';                Cells[1,R]:=FloatToStr(ShortBalance)+' ('+FloatToStr(ShortBalanceChange)+')';       Inc(R);
    Cells[0,R]:='Margin Balance';               Cells[1,R]:=FloatToStr(MarginBalance)+' ('+FloatToStr(MarginBalanceChange)+')';       Inc(R);
    Cells[0,R]:='Short StockValue';             Cells[1,R]:=FloatToStr(ShortStockValue)+' ('+FloatToStr(ShortStockValueChange)+')';       Inc(R);
    Cells[0,R]:='Long Marginable Value';        Cells[1,R]:=FloatToStr(LongMarginableValue)+' ('+FloatToStr(LongMarginableValueChange)+')';       Inc(R);
    Cells[0,R]:='Short Marginable Value';       Cells[1,R]:=FloatToStr(ShortMarginableValue)+' ('+FloatToStr(ShortMarginableValueChange)+')';       Inc(R);
    Cells[0,R]:='Margin Equity';                Cells[1,R]:=FloatToStr(MarginEquity)+' ('+FloatToStr(MarginEquityChange)+')';       Inc(R);
    Cells[0,R]:='Equity Percentage';            Cells[1,R]:=FloatToStr(EquityPercentage)+' ('+FloatToStr(EquityPercentageChange)+')';       Inc(R);
    Cells[0,R]:='Maintenance Requirement';      Cells[1,R]:=FloatToStr(MaintenanceRequirement)+' ('+FloatToStr(MaintenanceRequirementChange)+')';       Inc(R);
    Cells[0,R]:='Maintenance Call Value';       Cells[1,R]:=FloatToStr(MaintenanceCallValue)+' ('+FloatToStr(MaintenanceCallValueChange)+')';       Inc(R);
    Cells[0,R]:='Regulation T Call Value';      Cells[1,R]:=FloatToStr(RegulationTCallValue)+' ('+FloatToStr(RegulationTCallValueChange)+')';       Inc(R);
    Cells[0,R]:='Day Trading Call Value';       Cells[1,R]:=FloatToStr(DayTradingCallValue)+' ('+FloatToStr(DayTradingCallValueChange)+')';       Inc(R);
    Cells[0,R]:='Cash Debit Call Value';        Cells[1,R]:=FloatToStr(CashDebitCallValue)+' ('+FloatToStr(CashDebitCallValueChange)+')';       Inc(R);

    Cells[0,R]:='Cash For Withdrawal';          Cells[1,R]:=FloatToStr(CashForWithdrawal);
    Cells[0,R]:='Unsettled Cash';               Cells[1,R]:=FloatToStr(UnsettledCash);
    Cells[0,R]:='Non-Marginable Funds';         Cells[1,R]:=FloatToStr(NonMarginableFunds);

    Cells[0,R]:='DayEquityCallValue';       Cells[1,R]:=FloatToStr(DayEquityCallValue); Inc(R);
    Cells[0,R]:='OptionBuyingPower';       Cells[1,R]:=FloatToStr(OptionBuyingPower); Inc(R);
    Cells[0,R]:='StockBuyingPower';       Cells[1,R]:=FloatToStr(StockBuyingPower); Inc(R);
    Cells[0,R]:='DayTradingBuyingPower';       Cells[1,R]:=FloatToStr(DayTradingBuyingPower); Inc(R);
    Cells[0,R]:='AvailableFundsForTrading';       Cells[1,R]:=FloatToStr(AvailableFundsForTrading); Inc(R);

    RowCount:=R;

  end;
end;


procedure TfrmDLLBalances.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if SubID<>-1 then
    TDAUnRegisterSubscriber(MainTDAHandle,SubID);
end;

procedure TfrmDLLBalances.FormShow(Sender: TObject);
begin
  rbASync.Checked:=TRUE;
  if SubID=-1 then
  begin
    SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_GotBalancesPtr,@GotBalances);
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_GotPandL,@GotPandL);
  end;

  Button2Click(nil);
end;


procedure TfrmDLLBalances.Button1Click(Sender: TObject);
Var Len:integer;
    lRetID:integer;
    B:TAPIBalances;
    S:string;
    P:integer;
begin
  S:=cmbAcc.Items[cmbAcc.ItemIndex];
  P:=Pos(' ',S);if P>0 then Delete(S,P,$FFFF);

  if rbASync.Checked then
    TDARequestBalancesAndPositions(MainTDAHandle,PChar(S))
  else
  begin
    Len:=TDARequestBalancesAndPositionsX(MainTDAHandle,PChar(S),lRetID,@B);
    if Len>0 then
    begin
      TDAGetSyncResult(MainTDAHandle,lRetID,nil); // nil means just discard the result
    end;
    if Len>=0 then GotBalances(0,Integer(Self),@B);
  end;
end;

procedure TfrmDLLBalances.FormCreate(Sender: TObject);
begin
 SubID:=-1;
end;

procedure TfrmDLLBalances.Button2Click(Sender: TObject);
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

procedure TfrmDLLBalances.Button3Click(Sender: TObject);
Var S:string;
    P:integer;
begin
  S:=cmbAcc.Items[cmbAcc.ItemIndex];
  P:=Pos(' ',S);if P>0 then Delete(S,P,$FFFF);
  TDARequestPandL(MainTDAHandle,PChar(S));
end;

end.
