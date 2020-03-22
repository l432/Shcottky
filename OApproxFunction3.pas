unit OApproxFunction3;

interface

uses
  FitHeuristic, FitMaterial, OlegType, OlegMaterialSamples;

const
 PhonAsTunName='Dependence of reverse photon-assisted tunneling current at constant bias on ';
 PhonAsTunAndTEName='Dependence of photon-assisted tunneling current and thermionic emission current (strict rule) at constant bias on ';

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
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFRevSh=class (TFFEvolutionEm)

TFFTEandSCLCV=class (TFFEvolutionEm)
{I(V) = I01*V^m+I02*exp(A*Em(V)/kT)(1-exp(-eV/kT))}
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFTEandSCLCV=class (TFFEvolutionEm)

TFFRevShSCLC3=class (TFFEvolutionEm)
{I(V) = I01*V^m1+I02*V^m2+I03*exp(A*Em(V)/kT)*(1-exp(-eV/kT))}
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFRevShSCLC3=class (TFFEvolutionEm)

TFFRevShSCLC2=class (TFFEvolutionEm)
{I(V) = I01*(V^m1+b*V^m2)+I02*exp(A*Em(V)/kT)*(1-exp(-eV/kT))
m1=1+T01/T;
m2=1+T02/T}
 private
  Fm1:double;
  Fm2:double;
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure AddDoubleVars;override;
  procedure VariousPreparationBeforeFitting;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFRevShSCLC2=class (TFFEvolutionEm)


TFFPhonAsTun=class (TFFEvolutionEm)
{Розраховується залежність струму, пов'язаного
з phonon-assisted tunneling}
 private
  fmeff: Double; //абсолютна величина ефективної маси
 protected
  procedure VariousPreparationBeforeFitting;override;
  procedure AddDoubleVars;override;
 public
  Function PhonAsTun(V,kT1:double;Parameters:TArrSingle):double;virtual;
  class Function PAT(Sample:TDiod_Schottky; V,kT1,Fb0,a,hw,Ett,Nss:double):double;
end; //  TFFPhonAsTun=class (TFFEvolutionEm)

TFFPhonAsTunOnly=class (TFFPhonAsTun)
{базовий клас для розрахунків, де лище струм, пов'язаний
з phonon-assisted tunneling}
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
 public
end; //  TFFPhonAsTun=class (TFFEvolutionEm)

TFFPhonAsTun_kT1=class (TFFPhonAsTunOnly)
{струм як функція 1/kT,
тобто стале значення напруги потрібно вводити}
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure AddDoubleVars;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFPhonAsTun_kT1=class (TFFPhonAsTunOnly)

TFFPhonAsTun_V=class (TFFPhonAsTunOnly)
{струм як функція зворотньої напруги,
потрібна температура}
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFPhonAsTun_V=class (TFFPhonAsTunOnly)

TFFPATAndTE=class (TFFPhonAsTun)
{базовий клас для розрахунків, де струм, пов'язаний
з phonon-assisted tunneling та термоемісійним}
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
end; //  TFFPhonAsTun=class (TFFEvolutionEm)

TFFPATandTE_kT1=class (TFFPATAndTE)
{струм як функція 1/kT,
тобто стале значення напруги потрібно вводити}
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure AddDoubleVars;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFPATandTE_kT1=class (TFFPATAndTE)


TFFPATandTE_V=class (TFFPATAndTE)
{струм як функція зворотньої напруги,
потрібна температура}
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFPATandTE_V=class (TFFPATAndTE)

TFFPhonAsTunAndTE2_kT1=class (TFFPhonAsTun)
{струм як функція 1/kT,
тобто стале значення напруги потрібно вводити}
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure VariousPreparationBeforeFitting;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure AddDoubleVars;override;
  procedure AdditionalParamDetermination;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFPhonAsTunAndTE2_kT1=class (TFFPhonAsTun)

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


{ TFFRevShSCLC3 }

function TFFRevShSCLC3.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  Result:=Data[0]*Power(Point[cX],Data[1])+Data[2]*Power(Point[cX],Data[3])
   +Data[4]*exp(Data[5]*sqrt(F2*(F1+Point[cX]))/fkT)*(1-exp(-Point[cX]/fKT));
end;

procedure TFFRevShSCLC3.NamesDefine;
begin
  SetNameCaption('RevShSCLC3',
      'Dependence of reverse current on bias. '
      +'First component is SCLC current, second is TE current');
end;

procedure TFFRevShSCLC3.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Io1','p1','Io2','p2','Io3','A']);
end;


{ TFFRevShSCLC2 }

procedure TFFRevShSCLC2.AddDoubleVars;
begin
  inherited;
  DoubVars.Add(Self,'To1');
  DoubVars.Add(Self,'To2');
  DoubVars.Add(Self,'b');
  DoubVars.ParametrByName['b'].Limits.SetLimits(0);
  DoubVars.ParametrByName['To1'].Limits.SetLimits(0);
  DoubVars.ParametrByName['To2'].Limits.SetLimits(0);
end;

function TFFRevShSCLC2.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
 Result:=Data[0]*(Power(Point[cX],Fm1)
        +(DoubVars.Parametr[4] as TVarDouble).Value*Power(Point[cX],Fm2))
        +Data[1]*exp(Data[2]*sqrt(F2*(F1+Point[cX]))/fkT)
        *(1-exp(-Point[cX]/fkT));
end;

procedure TFFRevShSCLC2.NamesDefine;
begin
  SetNameCaption('RevShSCLC2',
      'Dependence of reverse current on bias. '
      +'First component is SCLC current, second is TE current');
end;

procedure TFFRevShSCLC2.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Io1','Io2','A']);
end;


procedure TFFRevShSCLC2.VariousPreparationBeforeFitting;
begin
 inherited VariousPreparationBeforeFitting;
 Fm1:=1+(DoubVars.ParametrByName['To1'] as TVarDouble).Value
        /(DoubVars.ParametrByName['T'] as TVarDouble).Value;
 Fm2:=1+(DoubVars.ParametrByName['To2'] as TVarDouble).Value
        /(DoubVars.ParametrByName['T'] as TVarDouble).Value;
end;

{ TFFPhonAsTun }

procedure TFFPhonAsTun.AddDoubleVars;
begin
  inherited;
  DoubVars.Add(Self,'a');
  DoubVars.Add(Self,'hw');
  DoubVars.ParametrByName['a'].Limits.SetLimits(0);
  DoubVars.ParametrByName['hw'].Limits.SetLimits(0);

end;

class function TFFPhonAsTun.PAT(Sample: TDiod_Schottky; V, kT1, Fb0, a, hw, Ett,
  Nss: double): double;
 var g,gam,gam1,qE,Et,meff:double;
begin
  Result:=ErResult;
  if kT1<=0 then Exit;
  qE:=Qelem*Sample.Em(1/(kT1*Kb),Fb0,V);
  Et:=Ett*Qelem;
  meff:=m0*Sample.Semiconductor.Meff;
  g:=a*sqr(hw*Qelem)*(1+2/(exp(hw*kT1)-1));
  gam:=sqrt(2*meff)*g/(Hpl*qE*sqrt(Et));
  gam1:=sqrt(1+sqr(gam));
  Result:=Sample.Area*Nss*qE*Qelem/sqrt(8*meff*Et)*sqrt(1-gam/gam1)*
          exp(-4*sqrt(2*meff)*Et*sqrt(Et)/(3*Hpl*qE)*
              sqr(gam1-gam)*(gam1+0.5*gam));
 end;

function TFFPhonAsTun.PhonAsTun(V, kT1: double; Parameters: TArrSingle): double;
begin
  Result:=PAT(Schottky,V,kT1,
         (DoubVars.Parametr[1] as TVarDouble).Value,
         (DoubVars.Parametr[2] as TVarDouble).Value,
         (DoubVars.Parametr[3] as TVarDouble).Value,
         Parameters[1],Parameters[0]);
end;

procedure TFFPhonAsTun.VariousPreparationBeforeFitting;
begin
  inherited;
  fmeff:=m0*Schottky.Semiconductor.Meff;
end;

{ TFFPhonAsTunOnly }

procedure TFFPhonAsTunOnly.TuningBeforeAccessorialDataCreate;
begin
  inherited;
  FPictureName:='PhonAsTunFig';
end;

{ TFFPhonAsTun_kT1 }

procedure TFFPhonAsTun_kT1.AddDoubleVars;
begin
  inherited;
  DoubVars.ParametrByName['V'].Description:='V (volt)';
end;

function TFFPhonAsTun_kT1.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  Result:=PhonAsTun((DoubVars.Parametr[0] as TVarDouble).Value,
                    Point[cX],Data);
end;

procedure TFFPhonAsTun_kT1.NamesDefine;
begin
   SetNameCaption('PhonAsTun',
      PhonAsTunName+'inverse temperature');
end;

procedure TFFPhonAsTun_kT1.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Nss','Et'],['Em']);
end;

procedure TFFPhonAsTun_kT1.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
 fVoltageIsRequired:=True;
end;

{ TFFPhonAsTun_V }

function TFFPhonAsTun_V.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
   Result:=PhonAsTun(Point[cX],1/fkT,Data);
end;

procedure TFFPhonAsTun_V.NamesDefine;
begin
   SetNameCaption('PhonAsTunV',
      PhonAsTunName+'reverse voltage');
end;

procedure TFFPhonAsTun_V.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Nss','Et']);
end;

{ TFFPATAndTE }

procedure TFFPATAndTE.TuningBeforeAccessorialDataCreate;
begin
  inherited;
  FPictureName:='PATandTEFig';
end;

{ TFFPATandTE_kT1 }

procedure TFFPATandTE_kT1.AddDoubleVars;
begin
  inherited;
  DoubVars.ParametrByName['V'].Description:='V (volt)';
end;

function TFFPATandTE_kT1.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  Result:=PhonAsTun((DoubVars.Parametr[0] as TVarDouble).Value,
                    Point[cX],Data)
         +TECurrent((DoubVars.Parametr[0] as TVarDouble).Value,
                    1/Point[cX]/Kb,Data[2],Data[3]);
end;

procedure TFFPATandTE_kT1.NamesDefine;
begin
   SetNameCaption('PATandTEkT1',
      PhonAsTunAndTEName+'inverse temperature');
end;

procedure TFFPATandTE_kT1.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Nss','Et','Seff','alpha'],['Em']);
end;

procedure TFFPATandTE_kT1.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
 fVoltageIsRequired:=True;
end;

{ TFFPATandTE_V }

function TFFPATandTE_V.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
   Result:=PhonAsTun(Point[cX],1/fkT,Data)
      +TECurrent(Point[cX],
           (DoubVars.Parametr[0] as TVarDouble).Value,
           Data[2],Data[3]);
end;

procedure TFFPATandTE_V.NamesDefine;
begin
   SetNameCaption('PATandTEV',
      PhonAsTunAndTEName+'reverse voltage');
end;

procedure TFFPATandTE_V.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Nss','Et','Seff','alpha']);
end;

{ TFFPhonAsTunAndTE2_kT1 }

procedure TFFPhonAsTunAndTE2_kT1.AddDoubleVars;
begin
 DoubVars.Add(Self,'Vsmp');
 DoubVars.ParametrByName['Vsmp'].Description:='V_smp';
 inherited;

end;

procedure TFFPhonAsTunAndTE2_kT1.AdditionalParamDetermination;
begin
   fDParamArray.ParametrByName['Emax'].Value:=
     0.5*(Schottky.Em(1/fDataToFit.X[0]/Kb,
             fDParamArray.ParametrByName['Fb0'].Value,
             (DoubVars.ParametrByName['V'] as TVarDouble).Value)
        +Schottky.Em(1/fDataToFit.X[fDataToFit.HighNumber]/Kb,
             fDParamArray.ParametrByName['Fb0'].Value,
             (DoubVars.ParametrByName['V'] as TVarDouble).Value));
   fDParamArray.OutputDataCoordinateByName('Emax');

   fDParamArray.ParametrByName['V'].Value:=(DoubVars.Parametr[0] as TVarDouble).Value
                                          /(DoubVars.Parametr[1] as TVarDouble).Value;
   fDParamArray.OutputDataCoordinateByName('V');
  inherited;
end;

function TFFPhonAsTunAndTE2_kT1.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  Result:=PAT(Schottky,(DoubVars.Parametr[0] as TVarDouble).Value,
             Point[cX],Data[3],
             (DoubVars.Parametr[2] as TVarDouble).Value,
             (DoubVars.Parametr[3] as TVarDouble).Value,
              Data[1],Data[0])
         +RevZrizFun(Point[cX],2,Data[2],
           Schottky.Semiconductor.Material.Varshni(Data[3],1/Kb/Point[cX]))
          *(1-exp(-(DoubVars.Parametr[0] as TVarDouble).Value*Point[cX]));
end;

procedure TFFPhonAsTunAndTE2_kT1.NamesDefine;
begin
   SetNameCaption('PATandTEsoftkT1',
      'Dependence of photon-assisted tunneling current '
      +'and thermionic emission current (soft rule)  at constant bias on '
      +'inverse temperature');
end;

procedure TFFPhonAsTunAndTE2_kT1.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Nss','Et','I0','Fb0'],
                 ['Emax','V']);
end;

procedure TFFPhonAsTunAndTE2_kT1.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
 fVoltageIsRequired:=True;
 fFb0IsNeeded:=False;
end;

procedure TFFPhonAsTunAndTE2_kT1.VariousPreparationBeforeFitting;
begin
 inherited;
 (DoubVars.Parametr[0] as TVarDouble).Value:=(DoubVars.Parametr[0] as TVarDouble).Value
         *(DoubVars.Parametr[1] as TVarDouble).Value;
end;

end.
