program Shottky;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  OlegGraph in 'OlegGraph.pas',
  OlegType in 'OlegType.pas',
  OlegMath in 'OlegMath.pas',
  LambUnit in 'LambUnit.pas' {LambForm},
  OlegFunction in 'OlegFunction.pas',
  DEUnit in 'DEUnit.pas' {DEForm},
  ExpUnit in 'ExpUnit.pas' {ExpForm},
  OlegApprox in 'OlegApprox.pas',
  FrApprPar in 'FrApprPar.pas' {FrApprP: TFrame},
  FrameButtons in 'FrameButtons.pas' {FrBut: TFrame},
  ApprWindows in 'ApprWindows.pas' {App},
  FrParam in 'FrParam.pas' {FrParamP: TFrame},
  FormSelectFit in 'FormSelectFit.pas' {FormSF},
  FrDiap in 'FrDiap.pas' {FrDp: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TLambForm, LambForm);
  Application.CreateForm(TApp, App);
  Application.CreateForm(TDEForm, DEForm);
  Application.CreateForm(TExpForm, ExpForm);
  Application.CreateForm(TFormSF, FormSF);
  Application.Run;
end.
