unit DLLActives;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,TDATypes,TDADLLHeaders,DLLTestGlobals, ExtCtrls;

type
  TfrmDLLAct = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    cmbVenue: TComboBox;
    Label2: TLabel;
    cmbDuration: TComboBox;
    rbNumTrades: TRadioButton;
    Label3: TLabel;
    rbNumShares: TRadioButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Shape1: TShape;
    rbBuyTrades: TRadioButton;
    rbBuyShares: TRadioButton;
    rbSellTrades: TRadioButton;
    rbSellShares: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmbVenueClick(Sender: TObject);
  private
    { Private declarations }
    SubID:integer;
  public
    { Public declarations }
  end;

var
  frmDLLAct: TfrmDLLAct;

implementation

{$R *.DFM}

Procedure GotActData(OType,OPtr:integer; const Sym:string;Act:TAPIActives);stdcall;
Var I:integer;
begin
  With TfrmDLLAct(OPtr),Act do
  begin
    for I:=0 to ControlCount-1 do
    if Controls[I] is TLabel then
    With TLabel(Controls[I]) do
    if Tag>0 then
    begin
       if Tag<=10 then
       begin
         if rbNumTrades.Checked then
           Caption:=Act.ActiveTrades[Tag].Sym
         else
         if rbNumShares.Checked then
           Caption:=Act.ActiveShares[Tag].Sym
         else
         if rbBuyShares.Checked then
           Caption:=Act.ActiveBuyShares[Tag].Sym
         else
         if rbSellShares.Checked then
           Caption:=Act.ActiveSellShares[Tag].Sym
         else
         if rbBuyTrades.Checked then
           Caption:=Act.ActiveBuyTrades[Tag].Sym
         else
         if rbSellTrades.Checked then
           Caption:=Act.ActiveSellTrades[Tag].Sym
       end
       else
       if (Tag>=101) and (Tag<=110) then
       begin
         if rbNumTrades.Checked then
           Caption:=IntToStr(Act.ActiveTrades[Tag-100].Num)
         else
         if rbNumShares.Checked then
           Caption:=IntToStr(Act.ActiveShares[Tag-100].Num)
         else
         if rbBuyShares.Checked then
           Caption:=IntToStr(Act.ActiveBuyShares[Tag-100].Num)
         else
         if rbSellShares.Checked then
           Caption:=IntToStr(Act.ActiveSellShares[Tag-100].Num)
         else
         if rbBuyTrades.Checked then
           Caption:=IntToStr(Act.ActiveBuyTrades[Tag-100].Num)
         else
         if rbSellTrades.Checked then
           Caption:=IntToStr(Act.ActiveSellTrades[Tag-100].Num)
       end
       else
       if (Tag>=201) and (Tag<=210) then
       begin
         if rbNumTrades.Checked then
           Caption:=FloatToStr(Act.ActiveTrades[Tag-200].Exe)
         else
         if rbNumShares.Checked then
           Caption:=FloatToStr(Act.ActiveShares[Tag-200].Exe)
         else
         if rbBuyShares.Checked then
           Caption:=FloatToStr(Act.ActiveBuyShares[Tag-200].Exe)
         else
         if rbSellShares.Checked then
           Caption:=FloatToStr(Act.ActiveSellShares[Tag-200].Exe)
         else
         if rbBuyTrades.Checked then
           Caption:=FloatToStr(Act.ActiveBuyTrades[Tag-200].Exe)
         else
         if rbSellTrades.Checked then
           Caption:=FloatToStr(Act.ActiveSellTrades[Tag-200].Exe)
       end
    end;
  end;
end;



procedure TfrmDLLAct.FormCreate(Sender: TObject);
begin
  cmbVenue.ItemIndex:=0;
  cmbDuration.ItemIndex:=0;
  rbNumTrades.Checked:=TRUE;
  SubID:=-1;
end;

procedure TfrmDLLAct.Button1Click(Sender: TObject);
Var I:integer;
    A:string;
begin
  if SubID=-1 then
  begin
    SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_ActivesData,@GotActData);
  end;
  TDAUnSubscribeAll(MainTDAHandle,SubID);
  for I:=0 to ControlCount-1 do
  if Controls[I] is TLabel then
  With TLabel(Controls[I]) do
  if Tag>0 then
  begin
     Caption:='---';
  end;
  A:=cmbVenue.Items[cmbVenue.ItemIndex]+'-'+cmbDuration.Items[cmbDuration.ItemIndex];
  TDASubscribe(MainTDAHandle,SubID,PChar(A),TDAPI_Actives);
end;

procedure TfrmDLLAct.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if SubID<>-1 then
    TDAUnRegisterSubscriber(MainTDAHandle,SubID);
end;

procedure TfrmDLLAct.cmbVenueClick(Sender: TObject);
begin
  if cmbVenue.Items[cmbVenue.ItemIndex]='ISLAND' then
  begin
    rbBuyShares.Visible:=TRUE;rbBuyTrades.Visible:=TRUE;
    rbSellShares.Visible:=TRUE;rbSellTrades.Visible:=TRUE;
  end
  else
  begin
    rbBuyShares.Visible:=FALSE;rbBuyTrades.Visible:=FALSE;
    rbSellShares.Visible:=FALSE;rbSellTrades.Visible:=FALSE;
    if (rbBuyShares.Checked or rbBuyTrades.Checked or
        rbSellShares.Checked or rbSellTrades.Checked) then
        rbNumTrades.Checked:=TRUE;
  end;
end;

end.
