unit DLLHistBackfill;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TDATypes,TDADLLHeaders,StdCtrls,DLLTestGlobals, Spin, ComCtrls;

type
  TfrmDLLHistBackfill = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    dfSym: TEdit;
    pbSub: TButton;
    Memo1: TMemo;
    rbASync: TRadioButton;
    rbSync: TRadioButton;
    dFrom: TDateTimePicker;
    dTo: TDateTimePicker;
    Label5: TLabel;
    dType: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure pbSubClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    SubID:integer;
    { Public declarations }
  end;

var
  frmDLLHistBackfill: TfrmDLLHistBackfill;

implementation

{$R *.DFM}
Function AdjustSingle(F:single):double;
begin
  if F<0.1 then Result:=round(F*10000000)/10000000 else
  if F<1 then Result:=round(F*1000000)/1000000 else
  if F<10 then Result:=round(F*100000)/100000 else
  if F<100 then Result:=round(F*10000)/10000 else
  if F<1000 then Result:=round(F*1000)/1000 else
  if F<10000 then Result:=round(F*100)/100 else
  if F<100000 then Result:=round(F*10)/10 else
  Result:=Round(F);
end;


Procedure GotBackfill(OType,OPtr:integer; const Sym:PChar; Tot:integer; Ptr: PAPIHistArray; const Err:PChar);stdcall;
Var I:integer;
    S:string;
    SD:integer;
begin
  With TfrmDLLHistBackfill(OPtr) do
  begin
    if Err<>nil then Memo1.Lines.Add(Err)
    else
    begin
      SD:=round(EncodeDate(1970,1,1));
      S:='';
      for I:=0 to Tot-1 do
      With Ptr^[I] do
      begin
        S:=S+FormatDateTime('mm/dd/yyyy',SD+Date)+'    '+
           FloatToStr(AdjustSingle(fOpen))+' '+FloatToStr(AdjustSingle(fHigh))+' '+FloatToStr(AdjustSingle(fLow))+' '+FloatToStr(AdjustSingle(fClose))+' '+
           IntToStr(nVolume)+#13#10;
      end;
      Memo1.Text:=S;
    end;
  end;
end;



procedure TfrmDLLHistBackfill.FormCreate(Sender: TObject);
begin
  SubID:=-1;
  dFrom.Date:=EncodeDate(1970,1,1);
  dTo.Date:=Now;
  dType.ItemINdex:=0;
end;

procedure TfrmDLLHistBackfill.pbSubClick(Sender: TObject);
Var lRetID:integer;
    I,Len:integer;
    P:PAPIHistArray;
    S:string;
    SD:integer;
begin
  if SubID=-1 then
  begin
    SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_GotHistBackfill,@GotBackfill);
  end;
  Memo1.Clear;
  if rbASync.Checked then
  begin
    TDARequestHistBackfill(MainTDAHandle,SubID,PChar(Trim(dfSym.Text)),PChar(FormatDateTime('yyyymmdd',dFrom.DateTime)),PChar(FormatDateTime('yyyymmdd',dTo.DateTime)),PChar(dType.Text))
  end
  else
  begin
    SD:=round(EncodeDate(1970,1,1));
    Len:=TDARequestHistBackfillX(MainTDAHandle,PChar(Trim(dfSym.Text)),PChar(FormatDateTime('yyyymmdd',dFrom.DateTime)),PChar(FormatDateTime('yyyymmdd',dTo.DateTime)),PChar(dType.Text),lRetID);
    if Len>0 then
    begin
      GetMem(P,SizeOf(TAPIHistItem)*Len);
      TDAGetSyncResult(MainTDAHandle,lRetID,P);
      S:='';
      for I:=0 to Len-1 do
      With P^[I] do
      begin
        S:=S+FormatDateTime('mm/dd/yyyy hh:nn:ss',SD+Date)+' '+
           FloatToStr(AdjustSingle(fOpen))+' '+FloatToStr(AdjustSingle(fHigh))+' '+FloatToStr(AdjustSingle(fLow))+' '+FloatToStr(AdjustSingle(fClose))+' '+
           IntToStr(nVolume)+#13#10;
      end;
      Memo1.Text:=S;
      FreeMem(P);
    end;
  end;

end;

procedure TfrmDLLHistBackfill.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if SubID<>-1 then
    TDAUnRegisterSubscriber(MainTDAHandle,SubID);
end;

procedure TfrmDLLHistBackfill.FormResize(Sender: TObject);
begin
  Memo1.Width:=ClientWidth;
  Memo1.Height:=ClientHeight-Memo1.Top-1;

end;

procedure TfrmDLLHistBackfill.FormShow(Sender: TObject);
begin
  rbASync.Checked:=TRUE;
end;

end.
