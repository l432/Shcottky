unit OlegParametricFitting;

interface

uses
  FitHeuristic, OlegType;

type

TFF_IS_RRCPE=class (TFFHeuristicParametric)
{(Rs​)−(Rp​∥ CPE(P,n))}
 protected
  function Omega(Zr:double):double;
  function A(Omega:double; Data: TArrSingle):double;
  function B(Omega:double; Data: TArrSingle):double;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure TuningBeforeAccessorialDataCreate;override;
//  function RealFinalFunc(X:double):double;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
  function FuncForFitnessX(Point:TPointDouble;Data:TArrSingle):double;override;
end; //TFF_IS_RRCPE=class (TFFHeuristicParametric)

implementation

uses
  FitIteration, System.Math, Vcl.Dialogs, System.SysUtils;

{ TFF_IS_RRCPE }

function TFF_IS_RRCPE.A(Omega: double;Data: TArrSingle): double;
begin
 Result:=1+Data[1]*Data[2]*Power(Omega,Data[3])*cos(Pi*Data[3]/2);
end;

function TFF_IS_RRCPE.B(Omega: double; Data: TArrSingle): double;
begin
 Result:=Data[1]*Data[2]*Power(Omega,Data[3])*sin(Pi*Data[3]/2);
end;

function TFF_IS_RRCPE.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
 var Om, A1, B1 :double;
begin
  Om:=Omega(Point[cX]);
  A1:=A(Om,Data);
  B1:=B(Om,Data);
  Result:=Data[1]*B1/(sqr(A1)+sqr(B1));
end;

function TFF_IS_RRCPE.FuncForFitnessX(Point: TPointDouble;
  Data: TArrSingle): double;
 var Om, A1, B1 :double;
begin
  Om:=Omega(Point[cX]);
  A1:=A(Om,Data);
  B1:=B(Om,Data);
  Result:=Data[0]+Data[1]*A1/(sqr(A1)+sqr(B1));
end;

procedure TFF_IS_RRCPE.NamesDefine;
begin
  SetNameCaption('Cola-Cola 1',
      '(Rs) − (Rp ​|| CPE)');
end;

function TFF_IS_RRCPE.Omega(Zr: double): double;
begin
 Result:=DataToFit.AdditionalVector.Yvalue(Zr);
end;

procedure TFF_IS_RRCPE.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Rs','Rp','P','n']);
end;

procedure TFF_IS_RRCPE.TuningBeforeAccessorialDataCreate;
begin
 inherited TuningBeforeAccessorialDataCreate;
 fHasPicture:=False;
end;

end.
