unit DLLTestL1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,TDATypes,TDADLLHeaders,DLLTestGlobals;

type
  TfrmDLLL1 = class(TForm)
    Label1: TLabel;
    dfSym: TEdit;
    Button1: TButton;
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
    lTick: TLabel;
    L1: TLabel;
    L2: TLabel;
    lBidExch: TLabel;
    L3: TLabel;
    lAskExch: TLabel;
    L4: TLabel;
    lExchange: TLabel;
    lTradeTime: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    lTradeDate: TLabel;
    Label19: TLabel;
    lQuoteTime: TLabel;
    Label22: TLabel;
    lQuoteDate: TLabel;
    Label24: TLabel;
    lName: TLabel;
    lIslandBid: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    lIslandAsk: TLabel;
    Label29: TLabel;
    lIslandVol: TLabel;
    Label31: TLabel;
    lIslandBidSize: TLabel;
    Label33: TLabel;
    lIslandAskSize: TLabel;
    lMarginable: TLabel;
    Label36: TLabel;
    Label100: TLabel;
    lShortable: TLabel;
    Label39: TLabel;
    lVolatility: TLabel;
    Label41: TLabel;
    lTradeID: TLabel;
    Label43: TLabel;
    lDigits: TLabel;
    Label5: TLabel;
    lPE: TLabel;
    lDividend: TLabel;
    Label21: TLabel;
    lYield: TLabel;
    Label25: TLabel;
    lNAV: TLabel;
    Label30: TLabel;
    lFund: TLabel;
    Label34: TLabel;
    lExchName: TLabel;
    Label37: TLabel;
    lDivDate: TLabel;
    Label40: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    SubID:integer;
  public
    { Public declarations }
  end;

var
  frmDLLL1: TfrmDLLL1;

implementation

{$R *.DFM}

Procedure GotL1Data(OType,OPtr:integer; Quote:PAPIQuote);stdcall;
begin
  With TfrmDLLL1(OPtr),Quote^ do
  begin
   if (ChangeFieldMask and TAPI_MASK_Bid)<>0 then lBid.Caption:=FloatToStr(fBid);
   if (ChangeFieldMask and TAPI_MASK_Ask)<>0 then lAsk.Caption:=FloatToStr(fAsk);
   if (ChangeFieldMask and TAPI_MASK_Last)<>0 then lLast.Caption:=FloatToStr(fLast);
   if (ChangeFieldMask and TAPI_MASK_High)<>0 then lHigh.Caption:=FloatToStr(fHigh);
   if (ChangeFieldMask and TAPI_MASK_Low)<>0 then lLow.Caption:=FloatToStr(fLow);
   if (ChangeFieldMask and TAPI_MASK_PrevClose)<>0 then lPrevClose.Caption:=FloatToStr(fPrevClose);
   if (ChangeFieldMask and TAPI_MASK_Open)<>0 then lOpen.Caption:=FloatToStr(fOpen);
   if (ChangeFieldMask and TAPI_MASK_Change)<>0 then lChange.Caption:=FloatToStr(fChange);
   if (ChangeFieldMask and TAPI_MASK_High52)<>0 then lHigh52.Caption:=FloatToStr(fHigh52);
   if (ChangeFieldMask and TAPI_MASK_Low52)<>0 then lLow52.Caption:=FloatToStr(fLow52);

   if (ChangeFieldMask and TAPI_MASK_Tick)<>0 then lTick.Caption:=Chr(cTick);

   if (ChangeFieldMask and TAPI_MASK_Volume)<>0 then lVolume.Caption:=IntToStr(nVolume);
   if (ChangeFieldMask and TAPI_MASK_BidSize)<>0 then lBidSize.Caption:=IntToStr(nBidSize);
   if (ChangeFieldMask and TAPI_MASK_AskSize)<>0 then lAskSize.Caption:=IntToStr(nAskSize);
   if (ChangeFieldMask and TAPI_MASK_LastSize)<>0 then lLastSize.Caption:=IntToStr(nLastSize);

   if (ChangeFieldMask and TAPI_MASK_BidExch)<>0 then lBidExch.Caption:=Chr(cBidExch);
   if (ChangeFieldMask and TAPI_MASK_AskExch)<>0 then lAskExch.Caption:=Chr(cAskExch);
   if (ChangeFieldMask and TAPI_MASK_Exchange)<>0 then lExchange.Caption:=Chr(cExchange);

   if (ChangeFieldMask and TAPI_MASK_TradeTime)<>0 then lTradeTime.Caption:=FormatDateTime('hh:mm:ss',tTradeTime/(24.0*60*60));
   if (ChangeFieldMask and TAPI_MASK_QuoteTime)<>0 then lQuoteTime.Caption:=FormatDateTime('hh:mm:ss',tQuoteTime/(24.0*60*60));
   if (ChangeFieldMask and TAPI_MASK_TradeDate)<>0 then lTradeDate.Caption:=FormatDateTime('mm/dd/yyyy',tTradeDate+EncodeDate(1970,1,1));
   if (ChangeFieldMask and TAPI_MASK_QuoteDate)<>0 then lQuoteDate.Caption:=FormatDateTime('mm/dd/yyyy',tQuoteDate+EncodeDate(1970,1,1));

   if (ChangeFieldMask and TAPI_MASK_IslandBid)<>0 then lIslandBid.Caption:=FloatToStr(fIslandBid);
   if (ChangeFieldMask and TAPI_MASK_IslandAsk)<>0 then lIslandAsk.Caption:=FloatToStr(fIslandAsk);
   if (ChangeFieldMask and TAPI_MASK_IslandVol)<>0 then lIslandVol.Caption:=IntToStr(nIslandVol);
   if (ChangeFieldMask and TAPI_MASK_IslandBidSize)<>0 then lIslandBidSize.Caption:=IntToStr(nIslandBidSize);
   if (ChangeFieldMask and TAPI_MASK_IslandAskSize)<>0 then lIslandAskSize.Caption:=IntToStr(nIslandAskSize);

   if (ChangeFieldMask and TAPI_MASK_Name)<>0 then lName.Caption:=sName;

   if (ChangeFieldMask and TAPI_MASK_Marginable)<>0 then if bMarginable then lMarginable.Caption:='YES' else lMarginable.Caption:='NO';
   if (ChangeFieldMask and TAPI_MASK_Shortable)<>0 then if bShortable then lShortable.Caption:='YES' else lShortable.Caption:='NO';

   if (ChangeFieldMask and TAPI_MASK_Volatility)<>0 then lVolatility.Caption:=FloatToStr(fVolatility);
   if (ChangeFieldMask and TAPI_MASK_TradeID)<>0 then lTradeID.Caption:=Chr(cTradeID);
   if (ChangeFieldMask and TAPI_MASK_Digits)<>0 then lDigits.Caption:=IntToStr(nDigits);

   if (ChangeFieldMask and TAPI_MASK_PE)<>0 then lPE.Caption:=FloatToStr(fPE);
   if (ChangeFieldMask and TAPI_MASK_Dividend)<>0 then lDividend.Caption:=FloatToStr(fDividend);
   if (ChangeFieldMask and TAPI_MASK_Yield)<>0 then lYield.Caption:=FloatToStr(fYield);
   if (ChangeFieldMask and TAPI_MASK_NAV)<>0 then lNAV.Caption:=FloatToStr(fNAV);
   if (ChangeFieldMask and TAPI_MASK_Fund)<>0 then lFund.Caption:=FloatToStr(fFund);

   if (ChangeFieldMask and TAPI_MASK_ExchName)<>0 then lExchName.Caption:=sExchName;
   if (ChangeFieldMask and TAPI_MASK_DivDate)<>0 then lDivDate.Caption:=sDivDate;
  end;
end;


procedure TfrmDLLL1.Button1Click(Sender: TObject);
begin
  if SubID=-1 then
  begin
    SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_L1DataPTR,@GotL1Data);
  end;
  TDAUnSubscribeAll(MainTDAHandle,SubID);
  lBid.Caption:='---';
  lAsk.Caption:='---';
  lLast.Caption:='---';
  lHigh.Caption:='---';
  lLow.Caption:='---';
  lPrevClose.Caption:='---';
  lOpen.Caption:='---';
  lChange.Caption:='---';
  lHigh52.Caption:='---';
  lLow52.Caption:='---';

  lTick.Caption:='---';

  lVolume.Caption:='---';
  lBidSize.Caption:='---';
  lAskSize.Caption:='---';
  lLastSize.Caption:='---';

  lBidExch.Caption:='---';
  lAskExch.Caption:='---';
  lExchange.Caption:='---';

  lTradeTime.Caption:='---';
  lQuoteTime.Caption:='---';
  lTradeDate.Caption:='---';
  lQuoteDate.Caption:='---';

  lIslandBid.Caption:='---';
  lIslandAsk.Caption:='---';
  lIslandVol.Caption:='---';
  lIslandBidSize.Caption:='---';
  lIslandAskSize.Caption:='---';

  lName.Caption:='---';

  lMarginable.Caption:='---';
  lShortable.Caption:='---';

  lVolatility.Caption:='---';
  lTradeID.Caption:='---';
  lDigits.Caption:='---';

  lPE.Caption:='---';
  lDividend.Caption:='---';
  lYield.Caption:='---';
  lNAV.Caption:='---';
  lFund.Caption:='---';

  lExchName.Caption:='---';
  lDivDate.Caption:='---';

  TDASubscribe(MainTDAHandle,SubID,PChar(Trim(dfSym.Text)),TDAPI_L1);
end;

procedure TfrmDLLL1.FormCreate(Sender: TObject);
begin
  SubID:=-1;
end;

procedure TfrmDLLL1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if SubID<>-1 then
    TDAUnRegisterSubscriber(MainTDAHandle,SubID);
end;

end.
