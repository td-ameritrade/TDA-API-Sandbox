unit DLLAccounts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TDATypes,TDADLLHeaders,DLLTestGlobals, Grids, StdCtrls;

type
  TfrmDLLAccounts = class(TForm)
    Label1: TLabel;
    cmbAcc: TComboBox;
    tbAccount: TStringGrid;
    Button2: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmbAccClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    SubID: integer;
  public
    { Public declarations }
  end;

var
  frmDLLAccounts: TfrmDLLAccounts;

implementation

{$R *.DFM}

procedure TfrmDLLAccounts.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if SubID<>-1 then
    TDAUnRegisterSubscriber(MainTDAHandle,SubID);
end;

procedure TfrmDLLAccounts.FormCreate(Sender: TObject);
begin
  SubID:=-1;
end;

procedure TfrmDLLAccounts.FormShow(Sender: TObject);
Var S,A:string;
    L:integer;
    Info:TAPIAccountInfo;
begin
  if SubID=-1 then
  begin
    SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
  end;
  Button2Click(nil);
end;

procedure TfrmDLLAccounts.cmbAccClick(Sender: TObject);
Var     Info:TAPIAccountInfo;
        S,A:string;
        P:integer;
Function YesNo(B:boolean):string;begin if B then Result:='true' else Result:='false'; end;
begin
   S:=cmbAcc.Items[cmbAcc.ItemIndex];
   P:=Pos(' ',S);if P>0 then Delete(S,P,$FFFF);
   TDAGetAccountInfo(MainTDAHandle,PChar(S),@(Info));
   tbAccount.Cells[0,1]:='Associated';  tbAccount.Cells[1,1]:=YesNo(Info.Associated);
   tbAccount.Cells[0,2]:='Unified';     tbAccount.Cells[1,2]:=YesNo(Info.Unified);
   tbAccount.Cells[0,3]:='Express';     tbAccount.Cells[1,3]:=YesNo(Info.Express);
   tbAccount.Cells[0,4]:='OptDirect';   tbAccount.Cells[1,4]:=YesNo(Info.OptDirect);
   tbAccount.Cells[0,5]:='StkDirect';   tbAccount.Cells[1,5]:=YesNo(Info.StkDirect);
   tbAccount.Cells[0,6]:='StkTrading';  tbAccount.Cells[1,6]:=YesNo(Info.StkTrading);
   tbAccount.Cells[0,7]:='MarTrading';  tbAccount.Cells[1,7]:=YesNo(Info.MarTrading);
   tbAccount.Cells[0,8]:='OptTrading';  tbAccount.Cells[1,8]:=YesNo(Info.OptTrading);
   tbAccount.Cells[0,9]:='Apex';        tbAccount.Cells[1,9]:=YesNo(Info.Apex);
   tbAccount.Cells[0,10]:='Lev1';       tbAccount.Cells[1,10]:=YesNo(Info.Lev1);
   tbAccount.Cells[0,11]:='Lev2';       tbAccount.Cells[1,11]:=YesNo(Info.Lev2);
   tbAccount.Cells[0,12]:='StrNews';    tbAccount.Cells[1,12]:=YesNo(Info.StrNews);

   SetLength(A,100);
end;


procedure TfrmDLLAccounts.Button2Click(Sender: TObject);
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
  cmbAccClick(Self);
end;

end.
