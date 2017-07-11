program TestDLL;

uses
  Forms,
  DLLTestForm in 'DLLTestForm.pas' {frmTestDLL},
  TDATypes in 'TDATypes.pas',
  TDADLLHeaders in 'TDADLLHeaders.pas',
  DLLTestGlobals in 'DLLTestGlobals.pas',
  DLLTestL1 in 'DLLTestL1.pas' {frmDLLL1},
  DLLTestL2 in 'DLLTestL2.pas' {frmDLLL2},
  DLLTestNews in 'DLLTestNews.pas' {frmDLLNews},
  DLLBalances in 'DLLBalances.pas' {frmDLLBalances},
  DLLPositions in 'DLLPositions.pas' {frmDLLPositions},
  DLLTransactions in 'DLLTransactions.pas' {frmDLLTransactions},
  DLLOrder in 'DLLOrder.pas' {frmDLLOrder},
  DLLBackfill in 'DLLBackfill.pas' {frmDLLBackfill},
  DLLActives in 'DLLActives.pas' {frmDLLAct},
  Spin in 'spin.pas',
  DLLAccounts in 'DLLAccounts.pas' {frmDLLAccounts},
  DLLSnap in 'DLLSnap.pas' {frmDLLSnap},
  DLLOptionChains in 'DLLOptionChains.pas' {frmDLLOptionChains},
  DLLHistBackfill in 'DLLHistBackfill.pas' {frmDLLHistBackfill};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTestDLL, frmTestDLL);
  Application.CreateForm(TfrmDLLOptionChains, frmDLLOptionChains);
  Application.CreateForm(TfrmDLLHistBackfill, frmDLLHistBackfill);
  Application.Run;
end.
