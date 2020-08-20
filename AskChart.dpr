program AskChart;

uses
  Forms,
  SysUtils,
  Dialogs,
  uMain in 'uMain.pas' {Form1},
  AskChart_TLB in 'AskChart_TLB.pas',
  mSQAprox in 'mSQAprox.pas',
  uTikFm in 'uTikFm.pas' {TikFm};

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
try
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TTikFm, TikFm);
  Application.Run;
except
  on E: Exception do MessageDlg(E.Message, mtError, [mbOk], 0);

end;
end.
