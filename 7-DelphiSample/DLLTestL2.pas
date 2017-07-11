unit DLLTestL2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TDATypes,TDADLLHeaders,StdCtrls,DLLTestGlobals;

type
  TfrmDLLL2 = class(TForm)
    Label1: TLabel;
    dfSym: TEdit;
    pbSub: TButton;
    mBids: TMemo;                                                          
    mAsks: TMemo;
    Label2: TLabel;
    lBidRows: TLabel;
    lBids: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lAsks: TLabel;
    lAskRows: TLabel;
    pbArca: TButton;
    pbIsland: TButton;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure pbSubClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    SubID:integer;
  public
    { Public declarations }
  end;


var
  frmDLLL2: TfrmDLLL2;

implementation

{$R *.DFM}

Procedure GotL2Data(OType,OPtr:integer; const Sym:PChar;NumBidRows,NumBids,NumAskRows,NumAsks:integer;Bids,Asks:PAPIL2Array);stdcall;
Var Str:string;
    I:integer;
    S:string;
begin
  With TfrmDLLL2(OPtr) do
  begin
   lBids.Caption:=IntToStr(NumBids);
   lBidRows.Caption:=IntToStr(NumBidRows);
   lAsks.Caption:=IntToStr(NumAsks);
   lAskRows.Caption:=IntToStr(NumAskRows);
    Str:='';
    for I:=0 to NumBidRows-1 do
    With Bids^[I] do
    begin
      S:='    ';Move(MMID[0],S[1],4);
      Str:=Str+Trim(S)+' '+IntToStr(Size)+' '+FloatToStr(Price)+#13#10;
    end;
    mBids.Lines.Text:=Str;

    Str:='';
    for I:=0 to NumAskRows-1 do
    With Asks^[I] do
    begin
      S:='    ';Move(MMID[0],S[1],4);
      Str:=Str+Trim(S)+' '+IntToStr(Size)+' '+FloatToStr(Price)+#13#10;
    end;
    mAsks.Lines.Text:=Str;
  end;
end;

Procedure GotTVL2Data(OType,OPtr:integer; const Sym:PChar;NumBids,NumAsks:integer;Bids,Asks:PAPILIIArray;NOII:PAPINOIIData);stdcall;
Var Str:string;
    I:integer;
    S:string;
begin
  With TfrmDLLL2(OPtr) do
  begin
   if NumBids<>-1 then
   begin
    lBids.Caption:=IntToStr(NumBids);
    lBidRows.Caption:='';
    Str:='';
    for I:=0 to NumBids-1 do
    With Bids^[I] do
    begin
      S:='    ';Move(MMID[0],S[1],4);
      Str:=Str+Trim(S)+' '+IntToStr(Size)+' '+FloatToStr(Price)+#13#10;
    end;
    mBids.Lines.Text:=Str;
   end;  
   if NumAsks<>-1 then
   begin
     lAsks.Caption:=IntToStr(NumAsks);
     lAskRows.Caption:='';
     Str:='';
     for I:=0 to NumAsks-1 do
     With Asks^[I] do
     begin
      S:='    ';Move(MMID[0],S[1],4);
      Str:=Str+Trim(S)+' '+IntToStr(Size)+' '+FloatToStr(Price)+#13#10;
     end;
     mAsks.Lines.Text:=Str;
   end;  
  end;
end;

procedure TfrmDLLL2.FormCreate(Sender: TObject);
begin
  SubID:=-1;
end;

procedure TfrmDLLL2.pbSubClick(Sender: TObject);
begin
  if SubID=-1 then
  begin
    SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_L2Data,@GotL2Data);
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_TVL2Data,@GotTVL2Data);
  end;
  TDAUnSubscribeAll(MainTDAHandle,SubID);
  lBidRows.Caption:='---';
  lBids.Caption:='---';
  lAskRows.Caption:='---';
  lasks.Caption:='---';
  mBids.Lines.Clear;
  mAsks.Lines.Clear;
  Case TButton(Sender).Tag of
    1: TDASubscribe(MainTDAHandle,SubID,PChar(Trim(dfSym.Text)),TDAPI_L2);
    2: TDASubscribe(MainTDAHandle,SubID,PChar(Trim(dfSym.Text)),TDAPI_ARCA);
    3: TDASubscribe(MainTDAHandle,SubID,PChar(Trim(dfSym.Text)),TDAPI_ISLD);
    4: TDASubscribe(MainTDAHandle,SubID,PChar(Trim(dfSym.Text)),TDAPI_LII);
    5: TDASubscribe(MainTDAHandle,SubID,PChar(Trim(dfSym.Text)),TDAPI_TV);
  end;
end;

procedure TfrmDLLL2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if SubID<>-1 then
    TDAUnRegisterSubscriber(MainTDAHandle,SubID);
end;



end.
