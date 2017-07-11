unit DLLPositions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,TDATypes,TDADLLHeaders,DLLTestGlobals, Grids;

type
  TfrmDLLPositions = class(TForm)
    Button1: TButton;
    tbPositions: TStringGrid;
    rbASync: TRadioButton;
    rbSync: TRadioButton;
    Label1: TLabel;
    cmbAcc: TComboBox;
    Button2: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    SubID: integer;
  public
    { Public declarations }
  end;

var
  frmDLLPositions: TfrmDLLPositions;

implementation

{$R *.DFM}

Procedure GotPositions(OType,OPtr:integer; Tot:integer; Ptr: PAPIPositionArray);stdcall;
Var I:integer;
begin
  With TfrmDLLPositions(OPtr).tbPositions do
  begin
    if Tot=0 then
    begin
      RowCount:=2;
      Cells[0,1]:='';
      Cells[1,1]:='';
      Cells[9,1]:='';
      Cells[6,1]:='';
      Cells[7,1]:='';
      Cells[8,1]:='';
      Cells[4,1]:='';
      Cells[5,1]:='';
      Cells[2,1]:='';
      Cells[3,1]:='';
    end
    else RowCount:=Tot+1;
    for I:=0 to Tot-1 do
    With Ptr^[I] do
    begin
      Cells[0,I+1]:=Symbol;
      Cells[1,I+1]:=SymWithPrefix;
      Cells[9,I+1]:=Name;
      Cells[6,I+1]:=Chr(AssetType);
      Cells[7,I+1]:=CUSIP;
      Cells[8,I+1]:=IntToStr(AccountType);
      Cells[4,I+1]:=FloatToStr(ClosePrice);
      Cells[5,I+1]:=FloatToStr(AveragePrice);
      Cells[2,I+1]:=PositionType;
      Cells[3,I+1]:=FLoatToStr(Quantity);
    end;
  end;
end;


procedure TfrmDLLPositions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if SubID<>-1 then
    TDAUnRegisterSubscriber(MainTDAHandle,SubID);
end;

procedure TfrmDLLPositions.FormCreate(Sender: TObject);
begin
 SubID:=-1;
end;

procedure TfrmDLLPositions.FormShow(Sender: TObject);
begin
  rbASync.Checked:=TRUE;
  if SubID=-1 then
  begin
    SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_GotPositions,@GotPositions);
  end;
  Button2Click(nil);

  With tbPositions do
  begin
    Cells[0,0]:='Symbol';
    Cells[1,0]:='SymWithPrefix';
    Cells[2,0]:='Posit';
    Cells[3,0]:='Qty';
    Cells[4,0]:='Cl. Price';
    Cells[5,0]:='Av. Price';
    Cells[6,0]:='ATyp';
    Cells[7,0]:='CUSIP';
    Cells[8,0]:='AcType';
    Cells[9,0]:='Name';
  end;
end;

procedure TfrmDLLPositions.Button1Click(Sender: TObject);
Var Len:integer;
    lRetID:integer;
    P:pointer;
    S:string;
    PP:integer;
begin
  S:=cmbAcc.Items[cmbAcc.ItemIndex];
  PP:=Pos(' ',S);if PP>0 then Delete(S,PP,$FFFF);

  if rbASync.Checked then
     TDARequestBalancesAndPositions(MainTDAHandle,PChar(S))
  else
  begin
    Len:=TDARequestBalancesAndPositionsX(MainTDAHandle,PChar(S),lRetID,nil);
    P:=nil;
    if Len>0 then
    begin
      GetMem(P,Len*SizeOf(TAPIPosition));
      TDAGetSyncResult(MainTDAHandle,lRetID,P); // nil means just discard the result
      GotPositions(0,Integer(Self),Len,P);
      FreeMem(P);
    end;  
  end;
end;


procedure TfrmDLLPositions.Button2Click(Sender: TObject);
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
