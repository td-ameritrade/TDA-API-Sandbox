unit DLLTestNews;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TDATypes,TDADLLHeaders,StdCtrls,DLLTestGlobals;

type
  TfrmDLLNews = class(TForm)
    Label1: TLabel;
    dfSym: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    Label2: TLabel;
    dfSnapSym: TEdit;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SubID: integer;
  end;

var
  frmDLLNews: TfrmDLLNews;

implementation

{$R *.DFM}

procedure TfrmDLLNews.FormCreate(Sender: TObject);
begin
  SubID:=-1;
end;

procedure GotNews(OType,OPtr:integer; const Sym:PChar; Tot:integer; Ptr: PAPINewsArray; const Err:PChar);stdcall;
Var I:integer;
begin
  With TfrmDLLNews(OPtr) do
  begin
    for I:=0 to Tot-1 do
    With Ptr^[I] do
    begin
      Memo1.Lines.Add(Sym+' '+HeadlineID+' '+FormatDateTime('mm/dd/yyyy hh:mm',round(EncodeDate(1970,1,1))+TimeStamp/(24.0*60*60))+' '+Source);
      Memo1.Lines.Add(Headline);
      Memo1.Lines.Add(URL);
      Memo1.Lines.Add('');
    end;  

  end;
end;

procedure TfrmDLLNews.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if SubID<>-1 then
    TDAUnRegisterSubscriber(MainTDAHandle,SubID);
end;

procedure TfrmDLLNews.Button1Click(Sender: TObject);
begin
  if SubID=-1 then
  begin
    SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_GotNews,@GotNews);
  end;
  TDAUnSubscribeAll(MainTDAHandle,SubID);
  TDARequestNewsHistory(MainTDAHandle,SubID,PChar(Trim(dfSym.Text)));
  TDASubscribe(MainTDAHandle,SubID,PChar(Trim(dfSym.Text)),TDAPI_News);
end;

procedure TfrmDLLNews.Button2Click(Sender: TObject);
begin
  if SubID=-1 then
  begin
    SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_GotNews,@GotNews);
  end;
  TDARequestNewsHistory(MainTDAHandle,SubID,PChar(Trim(dfSnapSym.Text)));
end;

end.
