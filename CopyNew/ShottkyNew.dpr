program ShottkyNew;

uses
  Forms,
  Unit1new in 'Unit1new.pas' {Form1},
  OlegGraphNew in 'OlegGraphNew.pas',
  OlegTypeNew in 'OlegTypeNew.pas',
  OlegMathNew in 'OlegMathNew.pas',
  OlegFunctionNew in 'OlegFunctionNew.pas',
  OlegApproxNew in 'OlegApproxNew.pas',
  FrApprPar in 'FrApprPar.pas' {FrApprP: TFrame},
  FrameButtons in 'FrameButtons.pas' {FrBut: TFrame},
  ApprWindows in 'ApprWindows.pas' {App},
  FrParam in 'FrParam.pas' {FrParamP: TFrame},
  FormSelectFit in 'FormSelectFit.pas' {FormSF},
  FrDiap in 'FrDiap.pas' {FrDp: TFrame},
  OlegMaterialSamplesNew in 'OlegMaterialSamplesNew.pas',
  OlegDefectsSiNew in 'OlegDefectsSiNew.pas',
  OlegShowTypesNew in 'OlegShowTypesNew.pas',
  OlegTypePart2New in 'OlegTypePart2New.pas',
  OlegVectorNew in 'OlegVectorNew.pas',
  OlegVectorOld in 'OlegVectorOld.pas',
  OlegVectorManipulation in 'OlegVectorManipulation.pas',
  OlegTests in 'OlegTests.pas',
  OlegMathShottky in 'OlegMathShottky.pas',
  OlegDigitalManipulation in 'OlegDigitalManipulation.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormSF, FormSF);
  Application.Run;
end.
