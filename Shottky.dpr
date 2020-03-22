program Shottky;

uses
  Forms,
  Unit1new in 'Unit1new.pas' {Form1},
  OlegGraph in 'OlegGraph.pas',
  OlegType in 'OlegType.pas',
  OlegMath in 'OlegMath.pas',
  OlegFunction in 'OlegFunction.pas',
  FrameButtons in 'FrameButtons.pas' {FrBut: TFrame},
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
  OlegDigitalManipulation in 'OlegDigitalManipulation.pas',
  OApproxNew in 'OApproxNew.pas',
  FormSelectFitNew in 'FormSelectFitNew.pas' {FormSFNew},
  OApproxCaption in 'OApproxCaption.pas',
  OApproxShow in 'OApproxShow.pas',
  FitTransform in 'FitTransform.pas',
  FitVariable in 'FitVariable.pas',
  FitDigital in 'FitDigital.pas',
  FitVariableShow in 'FitVariableShow.pas',
  FitSimple in 'FitSimple.pas',
  FitGradient in 'FitGradient.pas',
  FitMaterial in 'FitMaterial.pas',
  FitIteration in 'FitIteration.pas',
  FitIterationShow in 'FitIterationShow.pas',
  HighResolutionTimer in 'HighResolutionTimer.pas',
  OApproxFunction in 'OApproxFunction.pas',
  FitHeuristic in 'FitHeuristic.pas',
  OApproxFunction2 in 'OApproxFunction2.pas',
  OApproxFunction3 in 'OApproxFunction3.pas',
  FitManyArguments in 'FitManyArguments.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormSFNew, FormSFNew);
  Application.Run;
end.
