unit OlegParametricFitting;

interface

uses
  FitHeuristic, OlegType;

type

TFF_IS=class (TFFHeuristicParametric)
{спільний предок, який вміє визначати частоту та каже, що картинки немає}
 protected
  function Omega(Zr:double):double;
  function cs(n:double):double;
  function sn(n:double):double;
  function modZ2(re,im:double):double;
  function Apar(R,Q,n,Om:double):double;
  function Bpar(R,Q,n,Om:double):double;
  procedure TuningBeforeAccessorialDataCreate;override;
 public
end; //TFF_IS=class (TFFHeuristicParametric)

TFF_IS_RRCPE=class (TFF_IS)
{(Rs​)−(Rp​∥ CPE(Q,n))}
 protected
//  function Omega(Zr:double):double;
//  function A(Omega:double; Data: TArrSingle):double;
//  function B(Omega:double; Data: TArrSingle):double;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
//  procedure TuningBeforeAccessorialDataCreate;override;
//  function RealFinalFunc(X:double):double;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
  function FuncForFitnessX(Point:TPointDouble;Data:TArrSingle):double;override;
end; //TFF_IS_RRCPE=class (TFFHeuristicParametric)

TFF_IS_RRCPERCPE=class (TFF_IS)
{(Rs​)−(Rt​∥ CPE(Pt,nt)) - (Rr​∥ CPE(Qr,nr))}
 protected
//  function Ar(Omega:double; Data: TArrSingle):double;
//  function Br(Omega:double; Data: TArrSingle):double;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
  function FuncForFitnessX(Point:TPointDouble;Data:TArrSingle):double;override;
end; //TFF_IS_RRCPERCPE=class (TFF_IS)

TFF_IS_RCPERRCPE=class (TFF_IS)
{(Rs​)−[CPEt || (Rt - (Rr || CPEr))]}
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
  function FuncForFitnessX(Point:TPointDouble;Data:TArrSingle):double;override;
end; //TFF_IS_RCPERRCPE=class (TFF_IS)

implementation

uses
  FitIteration, System.Math, Vcl.Dialogs, System.SysUtils;

{ TFF_IS_RRCPE }

//function TFF_IS_RRCPE.A(Omega: double;Data: TArrSingle): double;
//begin
// Result:=1+Data[1]*Data[2]*Power(Omega,Data[3])*cos(Pi*Data[3]/2);
//end;
//
//function TFF_IS_RRCPE.B(Omega: double; Data: TArrSingle): double;
//begin
// Result:=Data[1]*Data[2]*Power(Omega,Data[3])*sin(Pi*Data[3]/2);
//end;

function TFF_IS_RRCPE.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
 var Om, A1, B1 :double;
begin
  Om:=Omega(Point[cX]);
//  A1:=A(Om,Data);
//  B1:=B(Om,Data);
  A1:=Apar(Data[1],Data[2],Data[3],Om);
  B1:=Bpar(Data[1],Data[2],Data[3],Om);
  Result:=Data[1]*B1/modZ2(A1,B1);
end;

function TFF_IS_RRCPE.FuncForFitnessX(Point: TPointDouble;
  Data: TArrSingle): double;
 var Om, A1, B1 :double;
begin
  Om:=Omega(Point[cX]);
//  A1:=A(Om,Data);
//  B1:=B(Om,Data);
  A1:=Apar(Data[1],Data[2],Data[3],Om);
  B1:=Bpar(Data[1],Data[2],Data[3],Om);
  Result:=Data[0]+Data[1]*A1/modZ2(A1,B1);
end;

procedure TFF_IS_RRCPE.NamesDefine;
begin
  SetNameCaption('Cola-Cola 1',
      '(Rs) − (Rp ​|| CPE)');
end;

//function TFF_IS_RRCPE.Omega(Zr: double): double;
//begin
// Result:=DataToFit.AdditionalVector.Yvalue(Zr);
//end;

procedure TFF_IS_RRCPE.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Rs','Rp','Q','n']);
end;

//procedure TFF_IS_RRCPE.TuningBeforeAccessorialDataCreate;
//begin
// inherited TuningBeforeAccessorialDataCreate;
// fHasPicture:=False;
//end;

{ TFF_IS }

function TFF_IS.Apar(R, Q, n, Om: double): double;
begin
 Result:=1+R*Q*Power(Om,n)*cs(n);
end;

function TFF_IS.Bpar(R, Q, n, Om: double): double;
begin
 Result:=R*Q*Power(Om,n)*sn(n);
end;

function TFF_IS.cs(n: double): double;
begin
 Result:=cos(Pi*n/2);
end;

function TFF_IS.modZ2(re, im: double): double;
begin
 Result:=sqr(re)+sqr(im);
end;

function TFF_IS.Omega(Zr: double): double;
begin
  Result:=2*Pi*DataToFit.AdditionalVector.Yvalue(Zr);
end;

function TFF_IS.sn(n: double): double;
begin
 Result:=sin(Pi*n/2);
end;

procedure TFF_IS.TuningBeforeAccessorialDataCreate;
begin
 inherited TuningBeforeAccessorialDataCreate;
 fHasPicture:=False;
end;

{ TFF_IS_RRCPERCPE }

//function TFF_IS_RRCPERCPE.Ar(Omega: double; Data: TArrSingle): double;
//begin
// Result:=1+Data[4]*Data[5]*Power(Omega,Data[6])*cos(Pi*Data[6]/2);
//end;
//
//function TFF_IS_RRCPERCPE.Br(Omega: double; Data: TArrSingle): double;
//begin
// Result:=Data[4]*Data[5]*Power(Omega,Data[6])*sin(Pi*Data[6]/2);
//end;

function TFF_IS_RRCPERCPE.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
  var Om, At, Bt, Ar, Br :double;
begin
  Om:=Omega(Point[cX]);
//  At:=A(Om,Data);
//  Bt:=B(Om,Data);
//  Arec:=Ar(Om,Data);
//  Brec:=Br(Om,Data);
  At:=Apar(Data[1],Data[2],Data[3],Om);
  Bt:=Bpar(Data[1],Data[2],Data[3],Om);
  Ar:=Apar(Data[4],Data[5],Data[6],Om);
  Br:=Bpar(Data[4],Data[5],Data[6],Om);
  Result:=Data[1]*Bt/modZ2(At,Bt)+Data[4]*Br/modZ2(Ar,Br);
end;

function TFF_IS_RRCPERCPE.FuncForFitnessX(Point: TPointDouble;
  Data: TArrSingle): double;
  var Om, At, Bt, Ar, Br :double;
begin
  Om:=Omega(Point[cX]);
//  At:=A(Om,Data);
//  Bt:=B(Om,Data);
//  Arec:=Ar(Om,Data);
//  Brec:=Br(Om,Data);
//  Result:=Data[0]+Data[1]*At/(sqr(At)+sqr(Bt))+Data[4]*Arec/(sqr(Arec)+sqr(Brec));
  At:=Apar(Data[1],Data[2],Data[3],Om);
  Bt:=Bpar(Data[1],Data[2],Data[3],Om);
  Ar:=Apar(Data[4],Data[5],Data[6],Om);
  Br:=Bpar(Data[4],Data[5],Data[6],Om);
  Result:=Data[1]*At/modZ2(At,Bt)+Data[4]*Ar/modZ2(Ar,Br);
end;

procedure TFF_IS_RRCPERCPE.NamesDefine;
begin
  SetNameCaption('Cola-Cola 2',
      '(Rs) − (Rt ​|| CPEt) - (Rr ​|| CPEr)' );

end;

procedure TFF_IS_RRCPERCPE.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Rs','Rt','Qt','nt','Rr','Qr','nr']);
end;

{ TFF_IS_RCPERRCPE }

function TFF_IS_RCPERRCPE.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
 var Om,C,D,S,A,B,G:double;
begin
 Om:=Omega(Point[cX]);
 C:=1/Data[4]+Data[5]*Power(Om,Data[6])*cs(Data[6]);
 D:=Data[5]*Power(Om,Data[6])*sn(Data[6]);
 S:=modZ2(C,D);
 G:=1+2*Data[1]*C+sqr(Data[1])*S;
 A:=Data[2]*Power(Om,Data[3])*cs(Data[3])+(C+Data[1]*S)/G;
 B:=Data[2]*Power(Om,Data[3])*sn(Data[3])+D/G;
 Result:=B/modZ2(A,B)

end;

function TFF_IS_RCPERRCPE.FuncForFitnessX(Point: TPointDouble;
  Data: TArrSingle): double;
 var Om,C,D,S,A,B,G:double;
begin
 Om:=Omega(Point[cX]);
 C:=1/Data[4]+Data[5]*Power(Om,Data[6])*cs(Data[6]);
 D:=Data[5]*Power(Om,Data[6])*sn(Data[6]);
 S:=modZ2(C,D);
 G:=1+2*Data[1]*C+sqr(Data[1])*S;
 A:=Data[2]*Power(Om,Data[3])*cs(Data[3])+(C+Data[1]*S)/G;
 B:=Data[2]*Power(Om,Data[3])*sn(Data[3])+D/G;
 Result:=Data[0]+A/modZ2(A,B)
end;

procedure TFF_IS_RCPERRCPE.NamesDefine;
begin
  SetNameCaption('Cola-Cola 3',
      '(Rs​)−[CPEt || (Rt - (Rr || CPEr))]' );

end;

procedure TFF_IS_RCPERRCPE.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Rs','Rt','Qt','nt','Rr','Qr','nr']);
end;

end.
