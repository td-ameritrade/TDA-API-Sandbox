unit DLLBackfill;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TDATypes,TDADLLHeaders,StdCtrls,DLLTestGlobals, Spin, ComCtrls;

type
  TfrmDLLBackfill = class(TForm)
    Label1: TLabel;
    dfSym: TEdit;
    pbSub: TButton;
    Memo1: TMemo;
    rbASync: TRadioButton;
    rbSync: TRadioButton;
    Label2: TLabel;
    spDays: TSpinEdit;
    cbFrom: TCheckBox;
    cbTo: TCheckBox;
    dFrom: TDateTimePicker;
    Label3: TLabel;
    Label4: TLabel;
    dTo: TDateTimePicker;
    Label5: TLabel;
    dFreq: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pbSubClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbFromClick(Sender: TObject);
    procedure cbToClick(Sender: TObject);
  private
    { Private declarations }
    SubID:integer;
  public
    { Public declarations }
  end;

var
  frmDLLBackfill: TfrmDLLBackfill;

Var Loading:boolean;

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

Procedure GotBackfill(OType,OPtr:integer; const Sym:PChar; Tot:integer; Ptr: PAPIBFArray; const Err:PChar);stdcall;
Var I:integer;
    S,A:string;
    P:integer;
    SD:integer;
begin
  With TfrmDLLBackfill(OPtr) do
  begin

    if Err<>nil then Memo1.Lines.Add(Err)
    else
    begin
      SD:=round(EncodeDate(1970,1,1));
      S:='';
      SetLength(S,100000);P:=1;
      for I:=0 to Tot-1 do
      With Ptr^[I] do
      begin
        A:=FormatDateTime('mm/dd/yyyy hh:nn:ss',SD+Date+(8.0/24+Sequence/(24.0*60)))+' '+
//        S:=S+FormatDateTime('mm/dd/yyyy hh:nn:ss',SD+Date+Time/(24*3600.0))+' '+
           FloatToStr(fOpen)+' '+FloatToStr(fHigh)+' '+FloatToStr(fLow)+' '+FloatToStr(fClose)+' '+
           IntToStr(nVolume)+#13#10;
        if P-1+Length(A)>Length(S) then SetLength(S,Length(S)+100000);
        Move(A[1],S[P],Length(A));
        P:=P+Length(A);
      end;
      SetLength(S,P-1);
      Memo1.Text:=S;
    end;
  end;
end;


procedure TfrmDLLBackfill.FormCreate(Sender: TObject);
begin
  SubID:=-1;
  dFrom.Date:=Now-20;
  dTo.Date:=Now;
  dFreq.ItemIndex:=0;
end;

procedure TfrmDLLBackfill.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if SubID<>-1 then
    TDAUnRegisterSubscriber(MainTDAHandle,SubID);
end;

procedure TfrmDLLBackfill.pbSubClick(Sender: TObject);
Var lRetID:integer;
    I,Len:integer;
    P:PAPIBFArray;
    S:string;
    SD:integer;
begin
  if SubID=-1 then
  begin
    SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_GotBackfill,@GotBackfill);
  end;
  Memo1.Clear;
  if rbASync.Checked then
  begin
    if cbFrom.Checked then
      TDARequestBackfill(MainTDAHandle,SubID,PChar(Trim(dfSym.Text)),spDays.Value,StrToInt(dFreq.Text))
    else
      TDARequestBackfillForDates(MainTDAHandle,SubID,PChar(Trim(dfSym.Text)),PChar(FormatDateTime('yyyymmdd',dFrom.DateTime)),PChar(FormatDateTime('yyyymmdd',dTo.DateTime)),StrToInt(dFreq.Text))
  end
  else
  begin
    SD:=round(EncodeDate(1970,1,1));
    if cbFrom.Checked then
      Len:=TDARequestBackfillX(MainTDAHandle,PChar(Trim(dfSym.Text)),spDays.Value,StrToInt(dFreq.Text),lRetID)
    else
      Len:=TDARequestBackfillForDatesX(MainTDAHandle,PChar(Trim(dfSym.Text)),PChar(FormatDateTime('yyyymmdd',dFrom.DateTime)),PChar(FormatDateTime('yyyymmdd',dTo.DateTime)),StrToInt(dFreq.Text),lRetID);
    if Len>0 then
    begin
      GetMem(P,SizeOf(TAPIBFItem)*Len);
      TDAGetSyncResult(MainTDAHandle,lRetID,P);
      S:='';
      for I:=0 to Len-1 do
      With P^[I] do
      begin
        S:=S+FormatDateTime('mm/dd/yyyy hh:nn:ss',SD+Date+(8.0/24+Sequence/(24.0*60)))+' '+
           FloatToStr(fOpen)+' '+FloatToStr(fHigh)+' '+FloatToStr(fLow)+' '+FloatToStr(fClose)+' '+
           IntToStr(nVolume)+#13#10;
      end;
      Memo1.Text:=S;
      FreeMem(P);
    end;  
  end;  

end;

procedure TfrmDLLBackfill.FormResize(Sender: TObject);
begin
  Memo1.Width:=ClientWidth;
  Memo1.Height:=ClientHeight-Memo1.Top-1;
end;

procedure TfrmDLLBackfill.FormShow(Sender: TObject);
begin
  rbASync.Checked:=TRUE;
end;

procedure TfrmDLLBackfill.cbFromClick(Sender: TObject);
begin
 if cbTo.Checked then begin cbTo.OnClick:=nil;cbTo.Checked:=FALSE;cbTo.OnClick:=cbToClick; end;
 if not cbFrom.Checked then begin cbFrom.OnClick:=nil;cbFrom.Checked:=TRUE;cbFrom.OnClick:=cbFromClick; end;
 spDays.Enabled:=TRUE;
 dFrom.Enabled:=FALSE;
 dTo.Enabled:=FALSE;
end;

procedure TfrmDLLBackfill.cbToClick(Sender: TObject);
begin
 if cbFrom.Checked then begin cbFrom.OnClick:=nil;cbFrom.Checked:=FALSE;cbFrom.OnClick:=cbFromClick; end;
 if not cbTo.Checked then begin cbTo.OnClick:=nil;cbTo.Checked:=TRUE;cbTo.OnClick:=cbToClick; end;
 spDays.Enabled:=FALSE;
 dFrom.Enabled:=TRUE;
 dTo.Enabled:=TRUE;
end;

initialization
  Loading:=FALSE;

end.
