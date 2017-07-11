unit DLLSnap;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,TDATypes,TDADLLHeaders,DLLTestGlobals;

type
  TfrmDLLSnap = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    lBid: TLabel;
    lAsk: TLabel;
    Label4: TLabel;
    lLast: TLabel;
    Label6: TLabel;
    lHigh: TLabel;
    Label8: TLabel;
    lLow: TLabel;
    Label10: TLabel;
    lPrevClose: TLabel;
    Label12: TLabel;
    lOpen: TLabel;
    Label14: TLabel;
    lChange: TLabel;
    Label16: TLabel;
    lHigh52: TLabel;
    Label18: TLabel;
    lLow52: TLabel;
    Label20: TLabel;
    Label3: TLabel;
    lVolume: TLabel;
    lBidSize: TLabel;
    Label9: TLabel;
    lAskSize: TLabel;
    Label13: TLabel;
    lLastSize: TLabel;
    Label17: TLabel;
    lTradeTime: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    lTradeDate: TLabel;
    Label24: TLabel;
    lName: TLabel;
    Label39: TLabel;
    lVolatility: TLabel;
    lNAV: TLabel;
    Label30: TLabel;
    lExchName: TLabel;
    Label37: TLabel;
    dfSym: TEdit;
    Button1: TButton;
    rbSync: TRadioButton;
    rbASync: TRadioButton;
    Label15: TLabel;
    cmbAcc: TComboBox;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SubID: integer;
  end;

var
  frmDLLSnap: TfrmDLLSnap;

implementation

{$R *.DFM}

procedure GotSnapQuote(OType,OPtr:integer; Ptr: PAPIQuote); stdcall;
begin
 With TfrmDLLSnap(OPtr),Ptr^ do
 begin
   lBid.Caption:=FloatToStr(fBid);
   lAsk.Caption:=FloatToStr(fAsk);
   lLast.Caption:=FloatToStr(fLast);
   lHigh.Caption:=FloatToStr(fHigh);
   lLow.Caption:=FloatToStr(fLow);
   lPrevClose.Caption:=FloatToStr(fPrevClose);
   lOpen.Caption:=FloatToStr(fOpen);
   lChange.Caption:=FloatToStr(fChange);
   lHigh52.Caption:=FloatToStr(fHigh52);
   lLow52.Caption:=FloatToStr(fLow52);

   lVolume.Caption:=IntToStr(nVolume);
   lBidSize.Caption:=IntToStr(nBidSize);
   lAskSize.Caption:=IntToStr(nAskSize);
   lLastSize.Caption:=IntToStr(nLastSize);


   lTradeTime.Caption:=FormatDateTime('hh:mm:ss',tTradeTime/(24.0*60*60));
   lTradeDate.Caption:=FormatDateTime('mm/dd/yyyy',tTradeDate+EncodeDate(1970,1,1));

   lName.Caption:=sName;

   lVolatility.Caption:=FloatToStr(fVolatility);

   lNAV.Caption:=FloatToStr(fNAV);
 end;
end;

procedure TfrmDLLSnap.FormCreate(Sender: TObject);
begin
 SubID:=-1;
end;

procedure TfrmDLLSnap.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if SubID<>-1 then
    TDAUnRegisterSubscriber(MainTDAHandle,SubID);
end;

procedure TfrmDLLSnap.FormShow(Sender: TObject);
begin
  rbASync.Checked:=TRUE;
  if SubID=-1 then
  begin
    SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_GotSnapQuote,@GotSnapQuote);
  end;
  Button2Click(nil);
end;

procedure TfrmDLLSnap.Button2Click(Sender: TObject);
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

procedure TfrmDLLSnap.Button1Click(Sender: TObject);
Var S:string;
    PP:integer;
    Len:integer;
    I,lRetID:integer;
    P:PAPIQuoteArray;
begin
  S:=cmbAcc.Items[cmbAcc.ItemIndex];
  PP:=Pos(' ',S);if PP>0 then Delete(S,PP,$FFFF);

  S:=dfSym.Text;
  if rbASync.Checked then
  begin
     I:=TDARequestSnapshotQuotes(MainTDAHandle,SubID,PChar(S));
     lBid.Caption:=IntToStr(I);
  end
  else
  begin
    Len:=TDARequestSnapshotQuotesX(MainTDAHandle,PChar(S),lRetID);
    if Len>0 then
    begin
      GetMem(P,SizeOf(TAPIQuote)*Len);
      TDAGetSyncResult(MainTDAHandle,lRetID,P);
      S:='';
      for I:=0 to Len-1 do
        GotSnapQuote(0,Integer(Self),@(P^[I]));
      FreeMem(P);
    end;
  end;
end;

end.
