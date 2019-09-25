program Shottky;

uses
  Forms,
  Unit1new in 'Unit1new.pas' {Form1},
  OlegGraph in 'OlegGraph.pas',
  OlegType in 'OlegType.pas',
  OlegMath in 'OlegMath.pas',
  OlegFunction in 'OlegFunction.pas',
  OlegApprox in 'OlegApprox.pas',
  FrApprPar in 'FrApprPar.pas' {FrApprP: TFrame},
  FrameButtons in 'FrameButtons.pas' {FrBut: TFrame},
  ApprWindows in 'ApprWindows.pas' {App},
  FrParam in 'FrParam.pas' {FrParamP: TFrame},
  FormSelectFit in 'FormSelectFit.pas' {FormSF},
  FrDiap in 'FrDiap.pas' {FrDp: TFrame},
  OlegMaterialSamples in 'OlegMaterialSamples.pas',
  OlegDefectsSi in 'OlegDefectsSi.pas',
  OlegShowTypes in 'OlegShowTypes.pas',
  OlegTypePart2 in 'OlegTypePart2.pas',
  OlegVector in 'OlegVector.pas',
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
