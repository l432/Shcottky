unit OApproxFunction;

interface

uses
  FitGradient, FitHeuristic, FitMaterial, OlegType, OlegMath;

type

TFFDiod=class (TFFHeuristic)
  private
    fSchottky: TDSchottkyFit;
 protected
//  procedure FittingAgentCreate;override;
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
  procedure AdditionalParamDetermination;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
 published
  property Schottky:TDSchottkyFit read fSchottky;
end; // TFFDiod=class (TFFHeuristic)

implementation

uses
  FitIteration, FitVariable;

{ TFFTDiod }

//procedure TFFDiod.FittingAgentCreate;
//begin
//
//end;

procedure TFFDiod.AdditionalParamDetermination;
begin
 fDParamArray.ParametrByName['Fb'].Value:=fSchottky.Fb((DoubVars.ParametrByName['T'] as TVarDouble).Value,
                                                        fDParamArray.ParametrByName['Io'].Value);
 inherited AdditionalParamDetermination;
end;

function TFFDiod.FuncForFitness(Point:TPointDouble; Data: TArrSingle): double;
begin
 Result:=IV_Diod(Point[cX],[Data[0],Data[1],Data[2],
                (DoubVars.Parametr[0] as TVarDouble).Value],Point[cY])
         +(Point[cX]-Point[cY]*Data[1])/Data[3];

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

function TFFDiod.RealFinalFunc(X: double): double;
begin
 Result:=Full_IV(IV_Diod,X,[fDParamArray.OutputData[0]*Kb*(DoubVars.Parametr[0] as TVarDouble).Value,
                 fDParamArray.OutputData[1],fDParamArray.OutputData[2]],fDParamArray.OutputData[3]);
end;

procedure TFFDiod.TuningBeforeAccessorialDataCreate;
begin
  inherited;
  FPictureName:='DiodFig';
end;

end.
