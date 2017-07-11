unit DLLOptionChains;

interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,TDATypes,TDADLLHeaders,DLLTestGlobals, Grids;

type
  TfrmDLLOptionChains = class(TForm)
    Label1: TLabel;
    dfSym: TEdit;
    Button1: TButton;
    tbChains: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    SubID:integer;
  public
    { Public declarations }
  end;

var
  frmDLLOptionChains: TfrmDLLOptionChains;

implementation

{$R *.DFM}

Procedure GotChain(OType,OPtr:integer; const Sym: PChar; Tot:integer; Ptr: PAPIOptionArray); stdcall;
Var I:integer;
    D:string[8];
begin
 With TfrmDLLOptionChains(OPtr) do
 begin
   tbChains.RowCount:=Tot+1;
   for I:=0 to Tot do
   With Ptr^[I] do
   begin
     tbChains.Cells[0,I+1]:=Symbol;
     tbChains.Cells[1,I+1]:=CallPut;
     D:='        ';
     Move(ExpDate[0],D[1],8);
     tbChains.Cells[2,I+1]:=D;
     tbChains.Cells[3,I+1]:=IntToStr(ExpDays);

     tbChains.Cells[4,I+1]:=ExpType;
     tbChains.Cells[5,I+1]:=FloatToStr(Strike);
     tbChains.Cells[6,I+1]:=OptType;
   end;
 end;
end;

procedure TfrmDLLOptionChains.FormCreate(Sender: TObject);
begin
 SubID:=-1;
end;

procedure TfrmDLLOptionChains.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if SubID<>-1 then
    TDAUnRegisterSubscriber(MainTDAHandle,SubID);
end;

procedure TfrmDLLOptionChains.FormShow(Sender: TObject);
begin
  if SubID=-1 then
  begin
    SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_OptionChain,@GotChain);
  end;

  With tbChains do
  begin
    Cells[0,0]:='Symbol';
    Cells[1,0]:='CallPut';
    Cells[2,0]:='ExpDate';
    Cells[3,0]:='ExpDays';
    Cells[4,0]:='ExpType';
    Cells[5,0]:='Strike';
    Cells[6,0]:='OptType';
  end;
end;

procedure TfrmDLLOptionChains.Button1Click(Sender: TObject);
Var S:string;
    lRetID:integer;
begin
  S:=dfSym.Text;
  TDARequestOptionChain(MainTDAHandle,SubID,PChar(S),nil);
end;

procedure TfrmDLLOptionChains.FormResize(Sender: TObject);
Var W,CW:integer;
begin
  With tbChains do
  begin
    W:=ClientWidth-16;
    CW:=W div 7;
    ColWidths[0]:=CW;
    ColWidths[1]:=CW;
    ColWidths[2]:=CW;
    ColWidths[3]:=CW;
    ColWidths[4]:=CW;
    ColWidths[5]:=CW;
    ColWidths[6]:=W-CW*6;
  end;
end;

end.
