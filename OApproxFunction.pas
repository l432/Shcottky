unit OApproxFunction;

interface

uses
  FitGradient;

type

TFFDiod=class (TFFDiodLSM)
 protected
  procedure FittingAgentCreate;override;
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
//  function RealFinalFunc(X:double):double;override;
//  procedure AdditionalParamDetermination;override;
end; // TFFDiodLSM=class (TFFIterationLSMSchottky)

implementation

uses
  FitIteration;

{ TFFTDiod }

procedure TFFDiod.FittingAgentCreate;
begin

end;

procedure TFFDiod.NamesDefine;
begin
 SetNameCaption('Dioda',
      'One-diode model, meta heuristic fitting');
end;

procedure TFFDiod.ParamArrayCreate;
begin
  fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['n','Rs','Io','Rsh'],
                 ['Fb']);
end;

procedure TFFDiod.TuningBeforeAccessorialDataCreate;
begin
  inherited;
  FPictureName:='DiodFig';
end;

end.
