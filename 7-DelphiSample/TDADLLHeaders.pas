unit TDADLLHeaders;

interface

uses Windows;

Var TDAInitSession:Function(LogLevel:integer):integer; stdcall;
    TDAGetDLLVer:Function:integer; stdcall;
    TDATerminateSession:Procedure(SessionHdl:integer); stdcall;
    TDAStart:Function(SessionHdl:integer):integer; stdcall;
    TDAStop:Function(SessionHdl:integer):integer; stdcall;
    TDASetLogFile:Procedure(LogFile:PChar); stdcall;
    TDASetLoginInfo:Function(SessionHdl:integer;Name,Pass:PChar):integer; stdcall;
    TDAIsLoggedIn:Function(SessionHdl:integer):integer;stdcall;
    TDARegisterSubscriber:Function(SessionHdl:integer;OType,OPtr:integer):integer;stdcall;
    TDAUnRegisterSubscriber:Function(SessionHdl:integer;SubID:integer):integer;stdcall;
    TDASubscribe:Function(SessionHdl:integer;SubID:integer;sList:PChar;SubType:integer):integer;stdcall;
    TDAUnSubscribe:Function(SessionHdl:integer; SubID:integer;sList:PChar;SubType:integer):integer;stdcall;
    TDAUnSubscribeAll:Function(SessionHdl:integer; SubID:integer):integer;stdcall;
    TDAGetStreamStatusStr:Procedure (Status:Integer;Str:PChar;StrLen:integer);stdcall;
    TDARequestBalancesAndPositions:Function(SessionHdl:integer;Const Acc:PChar):integer;stdcall;
    TDARequestBalancesAndPositionsX:Function(Hdl:integer;Const Acc:PChar;var ReturnID:integer;BPtr:pointer):integer;stdcall;
    TDARequestTransactions:Function(SessionHdl:integer;Const Acc:PChar;Const Extra: PChar):integer;stdcall;
    TDARequestTransactionsX:Function(SessionHdl:integer;Const Acc:PChar; Const Extra: PChar;var TransLen,TransID,FillLen,FillID:integer):integer; stdcall;
    TDARequestBackfill:Function(SessionHdl:integer;SubID:integer;Symbol:PChar;Days:integer;Freq:integer):integer;stdcall;
    TDARequestBackfillX:Function(SessionHdl:integer;Symbol:PChar;Days:integer;Freq:integer;var ReturnID:integer):integer;stdcall;
    TDARequestBackfillForDates:Function(SessionHdl:integer;SubID:integer;Symbol:PChar;FromD,ToD:PChar;Freq:integer):integer;stdcall;
    TDARequestBackfillForDatesX:Function(SessionHdl:integer;Symbol:PChar;FromD,ToD:PChar;Freq:integer;var ReturnID:integer):integer;stdcall;
    TDARequestHistBackfill:Function(SessionHdl:integer;SubID:integer;Symbol:PChar;FromD,ToD:PChar;FreqType:PChar):integer;stdcall;
    TDARequestHistBackfillX:Function(SessionHdl:integer;Symbol:PChar;FromD,ToD:PChar;FreqType:PChar;var ReturnID:integer):integer;stdcall;
    TDAGetSyncResult:function(SessionHdl:integer;ResultID:integer;P:pointer):integer;stdcall;
    TDARequestNewsHistory:Function(SessionHdl:integer;SubID:integer;Symbol:PChar):integer;stdcall;
    TDAOrderCommand:Function(SessionHdl:integer;SubID:integer;EType:char;SubmitType:integer;OrdStr:PChar):integer;stdcall;
    TDAOrderCommandX:function(SessionHdl:integer;EType:char;SubmitType:integer;OrderStr:PChar;RetStr:PChar;RetLen:integer):integer;stdcall;
    TDAGetSubscribedSymbols:Function(SessionHdl:integer;SubType:integer;SymbolList:PChar;MaxL:integer):integer;stdcall;

    TDAGetAccountIDs:Function(SessionHdl:integer;AccList:PChar;MaxL:integer):integer;stdcall;
    TDAGetAccountInfo:Function(Hdl:integer;const AccID:PChar;P:pointer):integer; stdcall;

    TDAGetStreamStatus:Function(SessionHdl:integer):integer;stdcall;
    TDAGetLastDataTime:Function(SessionHdl:integer):double;stdcall;
    TDASetCallback:Function(SessionHdl:integer;SubID:integer;EventID:integer;CallBackFunc:pointer):integer;stdcall;
    TDASetL1SubFields:Function(SessionHdl:integer;SubFields:PChar):integer;stdcall;

    TDASetLoginSite:Function(SessionHdl:integer;Site:PChar):integer; stdcall;
    TDASetStreamingSite:Function(SessionHdl:integer;Site:PChar):integer; stdcall;
    TDAGetStreamingSites:Function(Hdl:integer;Str:PChar;StrLen:integer):integer;stdcall;
    TDASetProxy:function(Hdl:integer; sProxyURL:PChar;nProxyPort:integer; sProxyURLSSL:PChar;nProxyPortSSL:integer; sProxyName,sProxyPass:PChar;bUseSocks:BOOL):integer; stdcall;

    TDASetSourceApp:function(Hdl:integer;const App:PChar):integer; stdcall;
    TDALogout:function(Hdl:integer):integer; stdcall;
    TDALogoutX:function(Hdl:integer):integer; stdcall;
    TDAKeepAlive:function(Hdl:integer):integer; stdcall;
    TDAKeepAliveX:function(Hdl:integer):integer; stdcall;
    TDARequestLastOrderStatus:function(Hdl:integer;const AccID:PChar):integer; stdcall;
    TDARequestLastOrderStatusX:function(Hdl:integer;const AccID:PChar;const LastStatus:PChar):integer; stdcall;
    TDARequestSnapshotQuotes:Function(SessionHdl:integer;SubID:integer;const Symbols:PChar):integer;stdcall;
    TDARequestSnapshotQuotesX:function(SessionHdl:integer;const Symbols:PChar;var ReturnID:integer):integer; stdcall;
    TDARequestPandL:function(Hdl:integer;const AccID:PChar):integer; stdcall;

    TDARequestOptionChain:function(SessionHdl:integer;SubID:integer;const Symbol:PChar;const Extra:PChar):integer; stdcall;
    TDARequestOptionChainX:function(SessionHdl:integer;const Symbol:PChar;const Extra:PChar;var ReturnID:integer):integer; stdcall;

    TDASetHTTPTimeout:function(Hdl:integer;const TimeOut:integer):integer; stdcall;


implementation

Var  DLLLoaded: boolean;

Procedure LoadDLL;
Var  DLLHandle: integer;
begin
  DLLHandle := LoadLibrary('TDADLL.DLL');
  if DLLHandle >= 32 then
  begin
    DLLLoaded := True;

    TDAInitSession:=GetProcAddress(DLLHandle,'TDAInitSession@4');
    if not Assigned(TDAInitSession) then begin DLLLoaded:=FALSE;end;

    TDAGetDLLVer:=GetProcAddress(DLLHandle,'TDAGetDLLVer@0');
    if not Assigned(TDAGetDLLVer) then begin DLLLoaded:=FALSE;end;

    TDATerminateSession:=GetProcAddress(DLLHandle,'TDATerminateSession@4');
    if not Assigned(TDATerminateSession) then begin DLLLoaded:=FALSE;end;

    TDAStart:=GetProcAddress(DLLHandle,'TDAStart@4');
    if not Assigned(TDAStart) then begin DLLLoaded:=FALSE;end;

    TDAStop:=GetProcAddress(DLLHandle,'TDAStop@4');
    if not Assigned(TDAStop) then begin DLLLoaded:=FALSE;end;

    TDASetLogFile:=GetProcAddress(DLLHandle,'TDASetLogFile@4');
    if not Assigned(TDASetLogFile) then begin DLLLoaded:=FALSE;end;

    TDASetLoginInfo:=GetProcAddress(DLLHandle,'TDASetLoginInfo@12');
    if not Assigned(TDASetLoginInfo) then begin DLLLoaded:=FALSE;end;

    TDAIsLoggedIn:=GetProcAddress(DLLHandle,'TDAIsLoggedIn@4');
    if not Assigned(TDAIsLoggedIn) then begin DLLLoaded:=FALSE;end;

    TDARegisterSubscriber:=GetProcAddress(DLLHandle,'TDARegisterSubscriber@12');
    if not Assigned(TDARegisterSubscriber) then begin DLLLoaded:=FALSE;end;

    TDAUnregisterSubscriber:=GetProcAddress(DLLHandle,'TDAUnregisterSubscriber@8');
    if not Assigned(TDAUnRegisterSubscriber) then begin DLLLoaded:=FALSE;end;

    TDASubscribe:=GetProcAddress(DLLHandle,'TDASubscribe@16');
    if not Assigned(TDASubscribe) then begin DLLLoaded:=FALSE;end;

    TDAUnSubscribe:=GetProcAddress(DLLHandle,'TDAUnsubscribe@16');
    if not Assigned(TDAUnsubscribe) then begin DLLLoaded:=FALSE;end;

    TDAUnsubscribeALL:=GetProcAddress(DLLHandle,'TDAUnsubscribeAll@8');
    if not Assigned(TDAUnsubscribeAll) then begin DLLLoaded:=FALSE;end;

    TDAGetStreamStatusStr:=GetProcAddress(DLLHandle,'TDAGetStreamStatusStr@12');
    if not Assigned(TDAGetStreamStatusStr) then begin DLLLoaded:=FALSE;end;

    TDARequestBalancesAndPositions:=GetProcAddress(DLLHandle,'TDARequestBalancesAndPositions@8');
    if not Assigned(TDARequestBalancesAndPositions) then begin DLLLoaded:=FALSE;end;

    TDARequestBalancesAndPositionsX:=GetProcAddress(DLLHandle,'TDARequestBalancesAndPositionsX@16');
    if not Assigned(TDARequestBalancesAndPositionsX) then begin DLLLoaded:=FALSE;end;

    TDARequestTransactions:=GetProcAddress(DLLHandle,'TDARequestTransactions@12');
    if not Assigned(TDARequestTransactions) then begin DLLLoaded:=FALSE;end;

    TDARequestTransactionsX:=GetProcAddress(DLLHandle,'TDARequestTransactionsX@28');
    if not Assigned(TDARequestTransactionsX) then begin DLLLoaded:=FALSE;end;

    TDARequestBackfill:=GetProcAddress(DLLHandle,'TDARequestBackfill@20');
    if not Assigned(TDARequestBackfill) then begin DLLLoaded:=FALSE;end;

    TDARequestBackfillX:=GetProcAddress(DLLHandle,'TDARequestBackfillX@20');
    if not Assigned(TDARequestBackfillX) then begin DLLLoaded:=FALSE;end;

    TDARequestBackfillForDates:=GetProcAddress(DLLHandle,'TDARequestBackfillForDates@24');
    if not Assigned(TDARequestBackfillForDates) then begin DLLLoaded:=FALSE;end;

    TDARequestBackfillForDatesX:=GetProcAddress(DLLHandle,'TDARequestBackfillForDatesX@24');
    if not Assigned(TDARequestBackfillForDatesX) then begin DLLLoaded:=FALSE;end;

    TDARequestHistBackfill:=GetProcAddress(DLLHandle,'TDARequestHistBackfill@24');
    if not Assigned(TDARequestHistBackfill) then begin DLLLoaded:=FALSE;end;

    TDARequestHistBackfillX:=GetProcAddress(DLLHandle,'TDARequestHistBackfillX@24');
    if not Assigned(TDARequestHistBackfillX) then begin DLLLoaded:=FALSE;end;

    TDAGetSyncResult:=GetProcAddress(DLLHandle,'TDAGetSyncResult@12');
    if not Assigned(TDAGetSyncResult) then begin DLLLoaded:=FALSE;end;

    TDARequestNewsHistory:=GetProcAddress(DLLHandle,'TDARequestNewsHistory@12');
    if not Assigned(TDARequestNewsHistory) then begin DLLLoaded:=FALSE;end;

    TDAOrderCommand:=GetProcAddress(DLLHandle,'TDAOrderCommand@20');
    if not Assigned(TDAOrderCommand) then begin DLLLoaded:=FALSE;end;

    TDAOrderCommandX:=GetProcAddress(DLLHandle,'TDAOrderCommandX@24');
    if not Assigned(TDAOrderCommandX) then begin DLLLoaded:=FALSE;end;

    TDAGetSubscribedSymbols:=GetProcAddress(DLLHandle,'TDAGetSubscribedSymbols@16');
    if not Assigned(TDAGetSubscribedSymbols) then begin DLLLoaded:=FALSE;end;

    TDAGetAccountIDs:=GetProcAddress(DLLHandle,'TDAGetAccountIDs@12');
    if not Assigned(TDAGetAccountIDs) then begin DLLLoaded:=FALSE;end;

    TDAGetAccountInfo:=GetProcAddress(DLLHandle,'TDAGetAccountInfo@12');
    if not Assigned(TDAGetAccountInfo) then begin DLLLoaded:=FALSE;end;


    TDAGetStreamStatus:=GetProcAddress(DLLHandle,'TDAGetStreamStatus@4');
    if not Assigned(TDAGetStreamStatus) then begin DLLLoaded:=FALSE;end;

    TDAGetLastDataTime:=GetProcAddress(DLLHandle,'TDAGetLastDataTime@4');
    if not Assigned(TDAGetLastDataTime) then begin DLLLoaded:=FALSE;end;

    TDASetCallback:=GetProcAddress(DLLHandle,'TDASetCallback@16');
    if not Assigned(TDASetCallback) then begin DLLLoaded:=FALSE;end;

    TDAStart:=GetProcAddress(DLLHandle,'TDAStart@4');
    if not Assigned(TDAStart) then begin DLLLoaded:=FALSE;end;

    TDASetL1SubFields:=GetProcAddress(DLLHandle,'TDASetL1SubFields@8');
    if not Assigned(TDASetL1SubFields) then begin DLLLoaded:=FALSE;end;

    TDASetLoginSite:=GetProcAddress(DLLHandle,'TDASetLoginSite@8');
    if not Assigned(TDASetLoginSite) then begin DLLLoaded:=FALSE;end;

    TDASetStreamingSite:=GetProcAddress(DLLHandle,'TDASetStreamingSite@8');
    if not Assigned(TDASetStreamingSite) then begin DLLLoaded:=FALSE;end;

    TDASetProxy:=GetProcAddress(DLLHandle,'TDASetProxy@32');
    if not Assigned(TDASetProxy) then begin DLLLoaded:=FALSE;end;

    TDAGetStreamingSites:=GetProcAddress(DLLHandle,'TDAGetStreamingSites@12');
    if not Assigned(TDAGetStreamingSites) then begin DLLLoaded:=FALSE;end;

    TDALogout:=GetProcAddress(DLLHandle,'TDALogout@4');
    if not Assigned(TDALogout) then begin DLLLoaded:=FALSE;end;

    TDALogoutX:=GetProcAddress(DLLHandle,'TDALogoutX@4');
    if not Assigned(TDALogoutX) then begin DLLLoaded:=FALSE;end;

    TDAKeepAlive:=GetProcAddress(DLLHandle,'TDAKeepAlive@4');
    if not Assigned(TDAKeepAlive) then begin DLLLoaded:=FALSE;end;

    TDAKeepAliveX:=GetProcAddress(DLLHandle,'TDAKeepAliveX@4');
    if not Assigned(TDAKeepAliveX) then begin DLLLoaded:=FALSE;end;

    TDARequestLastOrderStatus:=GetProcAddress(DLLHandle,'TDARequestLastOrderStatus@8');
    if not Assigned(TDARequestLastOrderStatus) then begin DLLLoaded:=FALSE;end;

    TDASetSourceApp:=GetProcAddress(DLLHandle,'TDASetSourceApp@8');
    if not Assigned(TDASetSourceApp) then begin DLLLoaded:=FALSE;end;

    TDARequestLastOrderStatusX:=GetProcAddress(DLLHandle,'TDARequestLastOrderStatusX@12');
    if not Assigned(TDARequestLastOrderStatusX) then begin DLLLoaded:=FALSE;end;

    TDARequestSnapshotQuotes:=GetProcAddress(DLLHandle,'TDARequestSnapshotQuotes@12');
    if not Assigned(TDARequestSnapshotQuotes) then begin DLLLoaded:=FALSE;end;

    TDARequestSnapshotQuotesX:=GetProcAddress(DLLHandle,'TDARequestSnapshotQuotesX@12');
    if not Assigned(TDARequestSnapshotQuotesX) then begin DLLLoaded:=FALSE;end;

    TDARequestPandL:=GetProcAddress(DLLHandle,'TDARequestPandL@8');
    if not Assigned(TDARequestPandL) then begin DLLLoaded:=FALSE;end;

    TDARequestOptionChain:=GetProcAddress(DLLHandle,'TDARequestOptionChain@16');
    if not Assigned(TDARequestOptionChain) then begin DLLLoaded:=FALSE;end;

    TDARequestOptionChainX:=GetProcAddress(DLLHandle,'TDARequestOptionChainX@16');
    if not Assigned(TDARequestOptionChainX) then begin DLLLoaded:=FALSE;end;

    TDASetHTTPTimeout:=GetProcAddress(DLLHandle,'TDASetHTTPTimeout@8');
    if not Assigned(TDASetHTTPTimeout) then begin DLLLoaded:=FALSE;end;

  end;
end;

initialization
  DLLLoaded:=FALSE;
  LoadDLL;
end.
