unit OApproxFunction3;

interface

uses
  FitHeuristic, FitMaterial, OlegType;

type


TFFEvolutionEm=class (TFFHeuristic)
{для функцій, де обчислюється
максимальне поле на інтерфейсі Em}
 private
   F1:double; //містить Fb(T)-Vn
   F2:double; // містить  2qNd/(eps_0 eps_s)
   fkT:double; //містить kT
//   fEmIsNeeded:boolean;
//   {якщо Тrue, то як додатковий параметр
//   розраховується середнє (по діапазону
//   температур) значення максимального
//   електричного поля на границі;
//   необхідно, апроксимувалась залежність
//   струму від 1/кТ, а значення
//   напруги для цієї характеристики
//   знаходилась в FVariab[0]}
   fFb0IsNeeded:boolean;
   Function TECurrent(V,T,Seff,A:double):double;
 {повертає величину Seff S A* T^2 exp(-(Fb0-A Em)/kT)(1-exp(-qV/kT))}
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure AddDoubleVars;override;
  procedure VariousPreparationBeforeFitting;override;
  procedure AdditionalParamDetermination;override;
 published
  property Schottky:TDSchottkyFit read fSchottky;
 public
end; //TFFEvolutionEm=class (TFFHeuristic)

TFFTEstrAndSCLCexp_kT1=class (TFFEvolutionEm)
{ I(1/kT)=Seff S A* T^2 exp(-(Fb0-A Em)/kT)(1-exp(-qV/kT))
          +I02*T^(m)*A^(-300/T)}
 protected
  procedure AddDoubleVars;override;
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFTEstrAndSCLCexp_kT1=class (TFFEvolutionEm)

TFFRevSh=class (TFFEvolutionEm)
{I(V) = I01*exp(A1*Em(V)+B*Em(V)^0.5)*(1-exp(-V/kT))+
        I02*exp(A2*Em(V)+B*Em(V)^0.5)*(1-exp(-V/kT))}
 protected
//  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFRevSh=class (TFFEvolutionEm)

TFFTEandSCLCV=class (TFFEvolutionEm)
{I(V) = I01*V^m+I02*exp(A*Em(V)/kT)(1-exp(-eV/kT))}
 protected
//  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFTEandSCLCV=class (TFFEvolutionEm)

implementation

uses
  FitVariable, FitIteration, OlegMath, Dialogs, SysUtils, Math;

{ TFFEvolutionEm }

procedure TFFEvolutionEm.AddDoubleVars;
begin
 inherited;
 if fFb0IsNeeded then
    begin
     DoubVars.Add(Self,'Fb0');
     DoubVars.ParametrByName['Fb0'].Limits.SetLimits(0);
     DoubVars.ParametrByName['Fb0'].Description:=
       'Barrier Height (Fb0)';
    end;
end;

procedure TFFEvolutionEm.AdditionalParamDetermination;
begin
  if ((fDParamArray.ParametrByName['Em'])<>nil) then
  begin
//   showmessage(floattostr((DoubVars.ParametrByName['V'] as TVarDouble).Value)+#10
//               +floattostr((DoubVars.ParametrByName['Fb0'] as TVarDouble).Value)+#10
//               +floattostr(1/fDataToFit.X[0]/Kb)+#10
//               +floattostr(fDataToFit.X[fDataToFit.HighNumber]));

   fDParamArray.ParametrByName['Em'].Value:=
     0.5*(Schottky.Em(1/fDataToFit.X[0]/Kb,
             (DoubVars.ParametrByName['Fb0'] as TVarDouble).Value,
             (DoubVars.ParametrByName['V'] as TVarDouble).Value)
        +Schottky.Em(1/fDataToFit.X[fDataToFit.HighNumber]/Kb,
        (DoubVars.ParametrByName['Fb0'] as TVarDouble).Value,
        (DoubVars.ParametrByName['V'] as TVarDouble).Value));
   fDParamArray.OutputDataCoordinateByName('Em');
  end;
  inherited;
end;

function TFFEvolutionEm.TECurrent(V, T, Seff, A: double): double;
 var kT:double;
begin
  kT:=Kb*T;
//  Result:=Seff*FSample.Em(T,FVariab[1],V)*Power(T,-2.33)*FSample.I0(T,FVariab[1])*
//    exp(A*sqrt(FSample.Em(T,FVariab[1],V))/kT)*(1-exp(-V/kT));
  Result:=Seff*Schottky.I0(T,(DoubVars.Parametr[1] as TVarDouble).Value)
      *exp(A*Schottky.Em(T,(DoubVars.Parametr[1] as TVarDouble).Value,V)/kT)
      *(1-exp(-V/kT));
end;

procedure TFFEvolutionEm.TuningBeforeAccessorialDataCreate;
begin
 inherited;
// fEmIsNeeded:=False;
 fFb0IsNeeded:=True;
end;

procedure TFFEvolutionEm.VariousPreparationBeforeFitting;
begin
 inherited;
 F2:=2/Schottky.nu;
 if (DoubVars.ParametrByName['T']<>nil)
     and(DoubVars.ParametrByName['Fb0']<>nil) then
  begin
   F1:=Schottky.Semiconductor.Material.Varshni((DoubVars.ParametrByName['Fb0'] as TVarDouble).Value,
                                               (DoubVars.ParametrByName['T'] as TVarDouble).Value)
     -Schottky.Vbi((DoubVars.ParametrByName['T'] as TVarDouble).Value);
   fkT:=Kb*(DoubVars.ParametrByName['T'] as TVarDouble).Value;
  end;
// showmessage(floattostr(fkT));
end;

{ TFFTEstrAndSCLCexp_kT1 }

procedure TFFTEstrAndSCLCexp_kT1.AddDoubleVars;
begin
  inherited;
  DoubVars.Add(Self,'m');
end;

function TFFTEstrAndSCLCexp_kT1.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
 Result:=TECurrent((DoubVars.Parametr[0] as TVarDouble).Value,
                   1/Point[cX]/Kb,Data[0],Data[1])
        +RevZrizSCLC(Point[cX],
                     (DoubVars.Parametr[2] as TVarDouble).Value,
                     Data[2],Data[3]);
end;

procedure TFFTEstrAndSCLCexp_kT1.NamesDefine;
begin
  SetNameCaption('TEstrAndSCLCexp',
           'Dependence of reverse current'
           +'at constant bias on inverse temperature. '
           +'First component is TE current (strict rule), '
           +'second is SCLC current (exponential trap distribution). '
           +'Ln-based fitness function is recomended');
end;

procedure TFFTEstrAndSCLCexp_kT1.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['S_eff','alpha','Io2','A'],
                 ['Em']);
end;

procedure TFFTEstrAndSCLCexp_kT1.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
 fVoltageIsRequired:=True;
end;

{ TFFRevSh }

function TFFRevSh.FuncForFitness(Point: TPointDouble; Data: TArrSingle): double;
 var Em:double;
begin
 Em:=sqrt(F2*(F1+Point[cX]));
 Result:=(Data[0]*exp((Data[1]*Em+Data[2]*sqrt(Em))/fkT)
         +Data[3]*exp(Data[4]*Em/fkT))*(1-exp(-Point[cX]/fkT));
end;

procedure TFFRevSh.NamesDefine;
begin
  SetNameCaption('RevSh',
      'Dependence of reverse TE current on bias');
end;

procedure TFFRevSh.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Io1','A1','B1','Io2','A2']);
end;


{ TFFTEandSCLCV }

function TFFTEandSCLCV.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  Result:=Data[3]*exp(Data[2]*sqrt(F2*(F1+Point[cX]))/fkT)
    *(1-exp(-Point[cX]/fkT))
    +Data[0]*Power(Point[cX],Data[1]);
end;

procedure TFFTEandSCLCV.NamesDefine;
begin
  SetNameCaption('TEandSCLCV',
      'Dependence of reverse current on bias. '
      +'First component is SCLC current, second is TE current');
end;

procedure TFFTEandSCLCV.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 [ 'Io1','p','A','Io2']);
end;


end.
