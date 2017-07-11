unit DLLTransactions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,TDATypes,TDADLLHeaders,DLLTestGlobals, Grids;

type
  TfrmDLLTransactions = class(TForm)
    Button1: TButton;
    tbTrans: TStringGrid;
    rbASync: TRadioButton;
    rbSync: TRadioButton;
    Label1: TLabel;
    cmbAcc: TComboBox;
    Button2: TButton;
    Label2: TLabel;
    lbLast: TLabel;
    pbGetLOS: TButton;
    Label3: TLabel;
    dfExtra: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GetLastOrdStat(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure tbTransDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Button1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    RowPref: array of string;
    RowEnd: array of char;
    MaxPref:integer;
    { Private declarations }
    Procedure ResizeTable;
  public
    { Public declarations }
    SubID: integer;
  end;

var
  frmDLLTransactions: TfrmDLLTransactions;

implementation

{$R *.DFM}

Procedure TfrmDLLTransactions.ResizeTable;
Var  C,R:integer;
     W,MaxW:integer;
begin
  for R:=1 to tbTrans.RowCount-1 do
    if Length(RowPref[R])>MaxPref then MaxPref:=Length(RowPref[R]);
  With tbTrans do
  begin
    for C:=0 to ColCount-1 do
    begin
      MaxW:=0;
      for R:=0 to RowCount-1 do
      begin
        W:=Canvas.TextWidth(Cells[C,R]);
        if W>MaxW then MaxW:=W;
      end;
      ColWidths[C]:=MaxW+10;
      if C=0 then ColWidths[C]:=MaxW+14*MaxPref+15;
    end;
  end;
end;

procedure GotLastOrderStatus(OType,OPtr:integer; const Acc:PChar; const LOS:PChar);stdcall;
begin
  With TfrmDLLTransactions(OPtr) do
    lbLast.Caption:=LOS;
end;


Procedure GotTransactions(OType,OPtr:integer; TotOrd:integer; Ptr: PAPITransactionArray;TotFills:integer; FillPtr: PAPIFillArray);stdcall;

Var   RowType:array of char;
      RowLev: array of integer;

Function TrueFalse(B:boolean):string;begin if B then Result:='true' else Result:='false'; end;
Procedure SetRow(Lev:integer;var R:integer;I:integer);
Var N:integer;
    S:string;
begin
  With TfrmDLLTransactions(OPtr).tbTrans do
  begin
    With Ptr^[I] do
    begin
       Cells[0,R]             := OrderNumber;
       RowType[R]  :='O';
       RowLev[R]   :=Lev+1;

       Cells[1,R]             := RootOrderNumber;
       Cells[2,R]             := ParentOrderNumber;

       Cells[3,R]             := TrueFalse(Cancelable);
       Cells[4,R]             := TrueFalse(Editable);
       Cells[5,R]             := TrueFalse(ComplexOption);
       Cells[6,R]             := TrueFalse(Enhanced);
       Cells[7,R]             := EnhancedOrderType;
       Cells[8,R]             := Relationship;
       Cells[9,R]             := OptionStrategy;

       Cells[10,R]             := OrderType;
       Cells[11,R]             := Symbol;
       Cells[12,R]             := SymWithPrefix;
       Cells[13,R]             := SecurityType;

       Cells[14,R]             := Chr(AssetType);
       Cells[15,R]             := Action;
       Cells[16,R]             := TradeType;
       Cells[17,R]             := FloatToStr(InitialQuantity);
       Cells[18,R]             := FloatToStr(RemainingQuantity);
       Cells[19,R]             := FloatToStr(LimitPrice);
       Cells[20,R]             := FloatToStr(StopPrice);

       Cells[21,R]             := SpecConditions;

       Cells[22,R]             := TIFSession;
       Cells[23,R]             := TIFExpiration;

       Cells[24,R]             := DisplayStatus;
       Cells[25,R]             := RoutingStatus;
       Cells[26,R]             := ReceivedDateTime;
       Cells[27,R]             := ReportedDateTime;
       Cells[28,R]             := CancelDateTime;

       Cells[29,R]             := DestRoutingMode;
       Cells[30,R]             := DestOptionExchange;
       Cells[31,R]             := DestResponseDescription;

       Cells[32,R]             := ActDestRoutingMode;
       Cells[33,R]             := ActDestOptionExchange;
       Cells[34,R]             := ActDestResponseDescription;

       Cells[35,R]             := IntToStr(RoutingDisplaySize);
       Cells[36,R]             := IntToStr(NumFills);
       Cells[37,R]             := FloatToStr(AverageFillPrice);
       Cells[38,R]             := FloatToStr(TotalFillCommission);

       Cells[39,R]             := LastExecutionDateTime;

       Cells[40,R]             := Chr(PutCall);
       Cells[41,R]             := Chr(OpenClose);
       Inc(R);
    end;
    // first, show the fills
    for N:=0 to TotFills-1 do
    begin
      if StrComp(FillPtr^[N].AccountID,Ptr^[I].AccountID)=0 then
      if StrComp(FillPtr^[N].OrderNumber,Ptr^[I].OrderNumber)=0 then
      begin
        RowType[R]  :='F';
        RowLev[R]   :=Lev+2;
        Cells[0,R]:='';
        With FillPtr^[N] do Cells[1,R]:='Fill ID#: '+ID+' '+FloatToStr(Qty)+'@'+FloatToStr(Price)+'+'+FloatToStr(Commission)+' at '+TimeStamp;
        R:=R+1;
      end;
    end;
    // now, show the suborders
    for N:=0 to TotOrd-1 do
    With Ptr^[N] do
    begin
     if RootOrderNumber[0]<>#0 then
      if StrComp(AccountID,Ptr^[I].AccountID)=0 then
      if StrComp(RootOrderNumber,Ptr^[I].OrderNumber)=0 then
      begin
        SetRow(Lev+1,R,N);
      end;
    end;
  end;  
end;

Var N,I,R,L:integer;
    S,A,Pre:string;
    sAcc:string;

    Cont:boolean;


Function ShowStr(S:string):string;overload;
Var I:integer;
    Res:string;
Const A:string='0123456789ABCDEF';
begin
  Res:='';
  for I:=1 to Length(S) do
    if S[I] in ['a'..'z','A'..'Z','0'..'9'] then
      Res:=Res+S[I]
    else
    if Pos(S[I],'|<>!@#$%^&*()_+=.,/?'':;"][')>0 then
      Res:=Res+S[I]
    else
      Res:=Res+'{'+System.Copy(A,Ord(S[I]) div 16+1,1)+System.Copy(A,Ord(S[I]) mod 16+1,1)+'}';
  Result:=Res;

end;

Var PP:integer;

begin
  SetLength(S,SizeOf(TAPITransaction)*TotOrd);
  Move(Ptr^[0],S[1],Length(S));
//  TfrmDLLTransactions(OPtr).dfExtra.Text:=ShowStr(S);
  With TfrmDLLTransactions(OPtr) do
  begin
    sAcc:=cmbAcc.Items[cmbAcc.ItemIndex];
    PP:=Pos(' ',sAcc);if PP>0 then Delete(sAcc,PP,$FFFF);
  end;  

  With TfrmDLLTransactions(OPtr).tbTrans do
  begin
    if TotOrd>0 then
     if Ptr^[0].AccountID<>sAcc then
      Exit;
    if TotOrd=0 then
    begin
      RowCount:=2;
      for I:=0 to 35 do Cells[I,1]:='';
    end
    else RowCount:=TotOrd+TotFills+1;
    With TfrmDLLTransactions(OPtr) do
    begin
      SetLength(RowType,RowCount);
      SetLength(RowLev,RowCount);
      SetLength(RowPref,RowCount);
      SetLength(RowEnd,RowCount);
    end;


    R:=1;I:=0;
    While I<=TotOrd-1 do
    With Ptr^[I] do
    begin
       if OrderNumber[0]<>#0 then
       begin
         if RootOrderNumber[0]=#0 then
         begin
           SetRow(0,R,I);
         end;
       end;
       Inc(I);
    end;
  end;
  // reformat rows
  With TfrmDLLTransactions(OPtr).tbTrans,TfrmDLLTransactions(OPtr) do
  begin
    for I:=1 to RowCount-1 do
    begin
      RowPref[I]:=Copy('-----------------------------',1,RowLev[I]);
      RowEnd[I]:='-';;
    end;  

    for I:=1 to RowCount-1 do
    begin
      if RowType[I]='O' then
      begin
          L:=RowLev[I];if L=0 then L:=L+1;
          if RowLev[I]>0 then RowPref[I][RowLev[I]]:='L';
          for N:=I-1 downto 1 do
          begin
            if RowType[N]='O' then Break;
            RowPref[N][RowLev[I]]:='|';
          end;

          N:=0;
          for R:=I+1 to RowCount-1 do
          begin
            if RowType[R]='O' then
              if RowLev[R]=L then Inc(N)
              else
              if RowLev[R]<L then Break;
          end;

          for R:=I+1 to RowCount-1 do
          begin
            if RowType[R]='O' then
            begin
              if RowLev[R]>=L then
              begin
                if N>0 then RowPref[R][L]:='|';
                if RowLev[I]>0 then
                  if N>0 then RowPref[I][RowLev[I]]:='+'
                         else RowPref[I][RowLev[I]]:='L';
                for N:=R-1 downto I+1 do
                 if RowType[N]='F' then
                   RowPref[N][L]:='|';
              end
              else Break;
            end;
          end;
      end
      else
      if RowType[I]='F' then
      begin
        RowEnd[I]:='L';
        if I<RowCount-1 then
         if RowType[I+1]='F' then RowEnd[I]:='+';
      end;
    end;
  end;
  TfrmDLLTransactions(OPtr).ResizeTable;

end;

procedure TfrmDLLTransactions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if SubID<>-1 then
    TDAUnRegisterSubscriber(MainTDAHandle,SubID);
end;

procedure TfrmDLLTransactions.FormCreate(Sender: TObject);
begin
 SubID:=-1;
 SetLength(RowPref,2);
 SetLength(RowEnd,2);
end;

procedure TfrmDLLTransactions.FormShow(Sender: TObject);
begin
  rbASync.Checked:=TRUE;
  if SubID=-1 then
  begin
    SubID:=TDARegisterSubscriber(MainTDAHandle,1,Integer(Self));
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_GotTransactions,@GotTransactions);
    TDASetCallback(MainTDAHandle,SubID,TDAPI_Callback_GotLastOrderStatus,@GotLastOrderStatus);
  end;

  Button2Click(nil);

  With tbTrans do
  begin
     Cells[0,0]         := 'OrderNumber';
     Cells[1,0]         := 'RootOrderNumber';
     Cells[2,0]         := 'ParentOrderNumber';
     Cells[3,0]         := 'Cancelable';
     Cells[4,0]         := 'Editable';
     Cells[5,0]         := 'ComplexOption';
     Cells[6,0]         := 'Enhanced';
     Cells[7,0]         := 'EnhancedOrdType';
     Cells[8,0]         := 'Relationship';
     Cells[9,0]         := 'OptionStrategy';
     Cells[10,0]         := 'OrderType';
     Cells[11,0]         := 'Symbol';
     Cells[12,0]         := 'SymWithPrefix';
     Cells[13,0]         := 'SecurityType';
     Cells[14,0]         := 'AssetType';
     Cells[15,0]         := 'Action';
     Cells[16,0]         := 'TradeType';
     Cells[17,0]         := 'InitialQuantity';
     Cells[18,0]         := 'RemainingQuantity';
     Cells[19,0]         := 'LimitPrice';
     Cells[20,0]         := 'StopPrice';
     Cells[21,0]         := 'SpecConditions';
     Cells[22,0]         := 'TIFSession';
     Cells[23,0]         := 'TIFExpiration';

     Cells[24,0]         := 'DisplayStatus';
     Cells[25,0]         := 'RoutingStatus';
     Cells[26,0]         := 'ReceivedDateTime';
     Cells[27,0]         := 'ReportedDateTime';
     Cells[28,0]         := 'CancelDateTime';
     Cells[29,0]         := 'DestRoutingMode';
     Cells[30,0]         := 'DestOptionExchange';
     Cells[31,0]         := 'DestResponseDescription';

     Cells[32,0]         := 'ActDestRoutingMode';
     Cells[33,0]         := 'ActDestOptionExchange';
     Cells[34,0]         := 'ActDestResponseDescription';
     Cells[35,0]         := 'RoutingDisplaySize';
     Cells[36,0]         := 'NumFills';
     Cells[37,0]         := 'AverageFillPrice';
     Cells[38,0]         := 'TotalFillCommission';
     Cells[39,0]         := 'LastExecutionDateTime';
     Cells[40,0]         := 'PutCall';
     Cells[41,0]         := 'OpenClose';

  end;
  ResizeTable;
end;

procedure TfrmDLLTransactions.GetLastOrdStat(Sender: TObject);
Var  Len1,Len2:integer;
     TransLen,TransID,FillLen,FillID:integer;
     P1,P2:pointer;
     A,S:string;
     PP:integer;
begin
  S:=cmbAcc.Items[cmbAcc.ItemIndex];
  PP:=Pos(' ',S);if PP>0 then Delete(S,PP,$FFFF);

  if rbASync.Checked then TDARequestLastOrderStatus(MainTDAHandle,PChar(S))
  else
  begin
    A:='                       ';
    TDARequestLastOrderStatusX(MainTDAHandle,PChar(S),@(A[1]));
    lbLast.Caption:=Trim(A);
  end;
end;

procedure TfrmDLLTransactions.Button2Click(Sender: TObject);
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

procedure TfrmDLLTransactions.tbTransDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
Var S:string;
    I,X,L:integer;
begin
  if (ARow=0) or (ACol<>0) then
  begin
    Inherited;
    Exit;
  end;
  //---------------------
  if ACol=0 then
  With TStringGrid(Sender) do
  begin
    S:=Cells[ACol,ARow];
    With Canvas do
    begin
       Brush.Color:=clWhite;
       FillRect(Rect);
       Font.Color:=clBlack;
       Pen.Color:=clBlack;
       Pen.Width:=2;
       X:=Rect.Left;
       if (ACol=0) and (ARow>0) then
       if Length(RowPref[ARow])>0 then
       begin
         X:=Rect.Left-7;
         L:=Length(RowPref[ARow]);
         for I:=2 to L do
         begin
           X:=X+14;
           Case RowPref[ARow][I] of
             '|':  begin MoveTo(X,Rect.Top);LineTo(X,Rect.Bottom+1); end;
             '+':  begin MoveTo(X,Rect.Top);LineTo(X,Rect.Bottom+1); MoveTo(X,(Rect.Top+Rect.Bottom) div 2);LineTo(Rect.Left+14*MaxPref,(Rect.Top+Rect.Bottom) div 2); end;
             'L':  begin MoveTo(X,Rect.Top);LineTo(X,(Rect.Top+Rect.Bottom) div 2);LineTo(Rect.Left+14*MaxPref,(Rect.Top+Rect.Bottom) div 2); end;
           end;
         end;
         X:=X+7;
         if S='' then
         begin
           X:=Rect.Right-7;
           Case RowEnd[ARow] of
             '|':  begin MoveTo(X,Rect.Top);LineTo(X,Rect.Bottom+1); end;
             '+':  begin MoveTo(X,Rect.Top);LineTo(X,Rect.Bottom+1); MoveTo(X,(Rect.Top+Rect.Bottom) div 2);LineTo(Rect.RIght,(Rect.Top+Rect.Bottom) div 2); end;
             'L':  begin MoveTo(X,Rect.Top);LineTo(X,(Rect.Top+Rect.Bottom) div 2);LineTo(Rect.RIght,(Rect.Top+Rect.Bottom) div 2); end;
           end;
         end;
       end;
       TextOut(X,(Rect.Top+Rect.Bottom-TextHeight('A')) div 2,S);

    end;
  end;
end;

procedure TfrmDLLTransactions.Button1Click(Sender: TObject);
Var  Len1,Len2:integer;
     TransLen,TransID,FillLen,FillID:integer;
     P1,P2:pointer;
     S,A:string;
     PP:integer;
begin
  S:=cmbAcc.Items[cmbAcc.ItemIndex];
  A:=trim(dfExtra.Text);
  PP:=Pos(' ',S);if PP>0 then Delete(S,PP,$FFFF);


  if rbASync.Checked then TDARequestTransactions(MainTDAHandle,PChar(S),PChar(A))
  else
  begin
    if TDARequestTransactionsX(MainTDAHandle,PChar(S),PChar(A),TransLen,TransID,FillLen,FillID)=0 then
    begin
      GetMem(P1,TransLen*SizeOf(TAPITransaction));
      TDAGetSyncResult(MainTDAHandle,TransID,P1); // nil means just discard the result
      GetMem(P2,FillLen*SizeOf(TAPIFill));
      TDAGetSyncResult(MainTDAHandle,FillID,P2); // nil means just discard the result
      GotTransactions(0,Integer(Self),TransLen,P1,FillLen,P2);
    end;  
  end;
end;

procedure TfrmDLLTransactions.FormResize(Sender: TObject);
begin
  tbTrans.Width:=ClientWidth;
  tbTrans.Height:=ClientHeight-tbTrans.Top;
end;

end.
