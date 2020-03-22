unit OApproxFunction;

interface

uses
  FitGradient, FitHeuristic, FitMaterial, OlegType,
  OlegMath, OlegVector;

type

TFFDiod=class (TFFHeuristic)
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
 published
  property Schottky:TDSchottkyFit read fSchottky;
end; // TFFDiod=class (TFFHeuristic)


TFFDiodTun=class (TFFHeuristic)
{I=I0*exp(A*(V-IRs)+(V-IRs)/Rsh}
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFDiodTun=class (TFFHeuristic)


TFFTunRevers=class (TFFHeuristic)
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
 published
  property Layer:TMaterialLayerFit read fMaterialLayer;
end; //TFFTunRevers=class (TFFHeuristic)


TFFTunReversRs=class (TFFHeuristic)
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
 published
  property Layer:TMaterialLayerFit read fMaterialLayer;
end; // TFFTunReversRs=class (TFFHeuristic))

TFFPhotoDiod=class (TFFIlluminatedDiode)
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFPhotoDiod=class (TFFIlluminatedDiode)


TFFPhotoDiodTun=class (TFFIlluminatedDiode)
{I=I0*exp(A*(V-IRs)+(V-IRs)/Rsh}
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFPhotoDiodTun=class (TFFIlluminatedDiode)

TFFDiodTwoFull=class (TFFHeuristic)
{I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp((V-IRs2)/n2kT)-1]}
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFDiodTwoFull=class (TFFHeuristic)

TFFDGaus=class (TFFHeuristic)
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
 published
  property Material:TMaterialFit read fMaterial;
end; // TFFTunReversRs=class (TFFHeuristic))


TFFLinEg=class (TFFHeuristic)
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
 published
  property Schottky:TDSchottkyFit read fSchottky;
end; // TFFLinEg=class (TFFHeuristic)

TFFTauG=class (TFFHeuristic)
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure AddDoubleVars;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFTauG=class (TFFHeuristic)

TFFTwoPower=class (TFFHeuristic)
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure AddDoubleVars;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFTwoPower=class (TFFHeuristic)

TFFMobility=class (TFFHeuristic)
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFMobility=class (TFFHeuristic)

TFFElectronConcentration=class (TFFHeuristic)
 private
  Function FermiLevelEquationS(Ef:double;
                            Parameters:array of double):double;
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure RealFitting;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
 published
  property Material:TMaterialFit read fMaterial;
end; //  TFFElectronConcentration=class (TFFHeuristic)


TFFnFeBPart=class (TFFHeuristic)
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFTnFeBPart=class (TFFHeuristic)

TFFIV_thin=class (TFFXYSwap)
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure AdditionalParamDetermination;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFIV_thin=class (TFFXYSwap)

TFFTauDAP=class (TFFHeuristic)
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFTauDAP=class (TFFHeuristic)

TFFRsh_T=class (TFFHeuristic)
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  class Function Rsh_T(T,A,Et,qUs:double;U0:double=0):double;
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFRsh_T=class (TFFHeuristic)

TFFRsh2_T=class (TFFHeuristic)
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFRsh2_T=class (TFFHeuristic)

implementation

uses
  FitIteration, FitVariable, Math, Dialogs, SysUtils,
  OlegMaterialSamples, OlegFunction;

{ TFFTDiod }

function TFFDiod.FuncForFitness(Point:TPointDouble; Data: TArrSingle): double;
begin
 Result:=IV_Diod(Point[cX],[Data[0],Data[1],Data[2],
                (DoubVars.Parametr[0] as TVarDouble).Value],Point[cY])
         +(Point[cX]-Point[cY]*Data[1])/Data[3];
end;

procedure TFFDiod.NamesDefine;
begin
 SetNameCaption('Diod',
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

{ TFFDiodTun }

function TFFDiodTun.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  Result:=Data[2]*(exp((Point[cX]-Point[cY]*Data[1])*Data[0]))
      +(Point[cX]-Point[cY]*Data[1])/Data[3];
end;

procedure TFFDiodTun.NamesDefine;
begin
 SetNameCaption('diodtun',
      'Tunneling diode function, meta heuristic fitting');
end;

procedure TFFDiodTun.ParamArrayCreate;
begin
  fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['A','Rs','Io','Rsh']);
end;

function TFFDiodTun.RealFinalFunc(X: double): double;
begin
 Result:=Full_IV(IV_DiodTunnel,X,[fDParamArray.OutputData[0],
                 fDParamArray.OutputData[1],fDParamArray.OutputData[2]],fDParamArray.OutputData[3]);
end;

procedure TFFDiodTun.TuningBeforeAccessorialDataCreate;
begin
  inherited;
  fTemperatureIsRequired:=False;
end;

{ TFFTunRevers }

function TFFTunRevers.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
 var F,V:double;
begin
 V:=Point[cX];
 F:=sqrt(Qelem*fMaterialLayer.Nd*(Data[2]+V)/2/fMaterialLayer.Material.Eps/Eps0);
 Result:=(Data[2]+V)*Data[0]*exp(-4*sqrt(2*fMaterialLayer.Meff*m0)*
                           Power(Qelem*Data[1],1.5)/
                           (3*Qelem*Hpl*F))+Data[3];
end;

procedure TFFTunRevers.NamesDefine;
begin
 SetNameCaption('TunRev',
      'Trap-assisted tunneling,  reverse diode');
end;

procedure TFFTunRevers.ParamArrayCreate;
begin
  fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Io','Et','Ud','Iph']);
end;

procedure TFFTunRevers.TuningBeforeAccessorialDataCreate;
begin
  inherited;
  fTemperatureIsRequired:=False;
end;

{ TFFTunReversRs }

function TFFTunReversRs.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
  var F:double;
begin
 F:=sqrt(Qelem*fMaterialLayer.Nd*(Data[2]+Point[cX]-Point[cY]*Data[3])/
                  (2*fMaterialLayer.Material.Eps*Eps0));

 Result:=Data[0]*(Data[2]+Point[cX]-Point[cY]*Data[3])
            *exp(-4*sqrt(2*fMaterialLayer.Meff*m0)*
             Power(Qelem*Data[1],1.5)/(3*Qelem*Hpl*F));
end;

procedure TFFTunReversRs.NamesDefine;
begin
 SetNameCaption('TunRevRs',
      'Trap-assisted tunneling with series resistance,  reverse diode');
end;

procedure TFFTunReversRs.ParamArrayCreate;
begin
  fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Io','Et','Ud','Rs']);
end;

function TFFTunReversRs.RealFinalFunc(X: double): double;
begin
 Result:=Full_IV(IV_DiodTATrev,X,[fDParamArray.OutputData[0],
                 fDParamArray.OutputData[3],
                 fDParamArray.OutputData[2],
                 fDParamArray.OutputData[1],
                 fMaterialLayer.Meff,
                 fMaterialLayer.Nd,
                 fMaterialLayer.Material.Eps]);
end;

procedure TFFTunReversRs.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fHasPicture:=False;
 fTemperatureIsRequired:=False;
end;

{ TFFPhotoDiod }

function TFFPhotoDiod.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  Result:=IV_Diod(Point[cX],[Data[0],Data[1],Data[2],
                 (DoubVars.Parametr[0] as TVarDouble).Value],Point[cY])
      +(Point[cX]-Point[cY]*Data[1])/Data[3]-Data[4];
end;

procedure TFFPhotoDiod.NamesDefine;
begin
 SetNameCaption('PhotoDiod',
      'One-diode model, illumination, meta heuristic fitting');
end;

procedure TFFPhotoDiod.ParamArrayCreate;
begin
  fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['n','Rs','Io','Rsh','Iph'],
                 ['Voc','Isc','FF','Pm','Vm','Im']);
end;

function TFFPhotoDiod.RealFinalFunc(X: double): double;
begin
 Result:=Full_IV(IV_Diod,X,[fDParamArray.OutputData[0]*Kb*(DoubVars.Parametr[0] as TVarDouble).Value,
                 fDParamArray.OutputData[1],fDParamArray.OutputData[2]],
                 fDParamArray.OutputData[3],fDParamArray.OutputData[4]);
end;

{ TFFPhotoDiodTun }

function TFFPhotoDiodTun.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
 Result:=Full_IV(IV_DiodTunnelLight,Point[cX],[Data[0],
                 Data[1],Data[2],Data[4]],
                 Data[3]);
end;

procedure TFFPhotoDiodTun.NamesDefine;
begin
 SetNameCaption('Photo diode tun',
      'Diode funneling function under illumination');
end;

procedure TFFPhotoDiodTun.ParamArrayCreate;
begin
  fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['A','Rs','Io','Rsh','Iph'],
                 ['Voc','Isc','FF','Pm','Vm','Im']);
end;

procedure TFFPhotoDiodTun.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
 FPictureName:='photodiodtunFig';
end;

{ TFFDiodTwoFull }

function TFFDiodTwoFull.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
 Result:=Full_IV(IV_Diod,Point[cX],[Data[0]*Kb*(DoubVars.Parametr[0] as TVarDouble).Value,
                 Data[1],Data[2]])
         +Full_IV(IV_Diod,Point[cX],[Data[3]*Kb*(DoubVars.Parametr[0] as TVarDouble).Value,
                 Data[4],Data[5]]);
end;

procedure TFFDiodTwoFull.NamesDefine;
begin
 SetNameCaption('DiodTwoFull',
      'Two Full Diode function');
end;

procedure TFFDiodTwoFull.ParamArrayCreate;
begin
  fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['n1','Rs1','Io1','n2','Rs2','Io2']);
end;

{ TFFDGaus }

function TFFDGaus.FuncForFitness(Point: TPointDouble; Data: TArrSingle): double;
 var temp:double;
begin
 temp:=Kb*Point[cX];
 Result:=-temp*ln(Data[0]*exp(-Material.Varshni(Data[1],Point[cX])/temp+sqr(Data[2])/2/sqr(temp))
                 +(1-Data[0])*exp(-Material.Varshni(Data[3],Point[cX])/temp+sqr(Data[4])/2/sqr(temp)));
end;

procedure TFFDGaus.NamesDefine;
begin
  SetNameCaption('DGaus',
      'Double Gaussian barrier distribution');
end;

procedure TFFDGaus.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['A','Fb01','Sigma1','Fb02','Sigma2']);
end;

procedure TFFDGaus.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFLinEg }

function TFFLinEg.FuncForFitness(Point: TPointDouble; Data: TArrSingle): double;
 var Fb,Vbb:double;
begin
 Fb:=Schottky.Semiconductor.Material.Varshni(Data[2],Point[cX]);
 Vbb:=Fb-Schottky.Vbi(Point[cX]);
 Result:=Fb-Data[0]*Power(Vbb/Schottky.nu,1.0/3.0)
         -Kb*Point[cX]*ln(Data[0]*Data[1]*4*3.14*Kb*Point[cX]/9*Power(Schottky.nu/Vbb,2.0/3.0));
end;

procedure TFFLinEg.NamesDefine;
begin
  SetNameCaption('LinEg',
      'Patch current fitting');
end;

procedure TFFLinEg.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Gam','C1','Fb0']);
end;

procedure TFFLinEg.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFTauG }

procedure TFFTauG.AddDoubleVars;
begin
  inherited;
  DoubVars.Add(Self,'Tr');
  DoubVars.ParametrByName['Tr'].Description:='recombination time (Tr)';
  DoubVars.ParametrByName['Tr'].Limits.SetLimits(0);
  DoubVars.Add(Self,'m');
  DoubVars.ParametrByName['m'].Description:='power-law parameter (m)';
end;

function TFFTauG.FuncForFitness(Point: TPointDouble; Data: TArrSingle): double;
begin
 Result:=2*(DoubVars.Parametr[0] as TVarDouble).Value
           *Power(1/Point[cX]/Kb/300,(DoubVars.Parametr[1] as TVarDouble).Value)
         *Sqrt(Data[0])*cosh(Data[1]*Point[cX]);
end;

procedure TFFTauG.NamesDefine;
begin
  SetNameCaption('TauG',
      'Lifetime in SCR');
end;

procedure TFFTauG.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['SnSp','Et']);
end;

procedure TFFTauG.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFTwoPower }

procedure TFFTwoPower.AddDoubleVars;
begin
  inherited;
  DoubVars.Add(Self,'m1');
  DoubVars.ParametrByName['m1'].Description:='First power-law parameter (m1)';
  DoubVars.Add(Self,'m2');
  DoubVars.ParametrByName['m2'].Description:='Second power-law parameter (m2)';
end;

function TFFTwoPower.FuncForFitness(Point: TPointDouble;
        Data: TArrSingle): double;
begin
  Result:=Data[0]
          +Data[1]*Power(Point[cX],(DoubVars.Parametr[0] as TVarDouble).Value)
          +Data[2]*Power(Point[cX],(DoubVars.Parametr[1] as TVarDouble).Value);
end;

procedure TFFTwoPower.NamesDefine;
begin
  SetNameCaption('TwoPower',
      'Variate Polynomial');
end;

procedure TFFTwoPower.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['a0','a1','a2']);
end;

procedure TFFTwoPower.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFMobility }

function TFFMobility.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
 Result:=0;
 if Data[0]<>0 then Result:=Result+1/Data[0];
 if Data[1]<>0 then Result:=Result+1/(Data[1]*Point[cX]);
 if Data[2]<>0 then Result:=Result+1/(Data[2]*Power(Point[cX],1.5));
 if Data[3]<>0 then Result:=Result+1/(Data[3]*Power(Point[cX],-1.5));
 if Data[4]<>0 then Result:=Result+1/(Data[4]*Power(Point[cX],-0.5));
 if (Data[5]<>0)and(Point[cX]>0)
   then Result:=Result+1/(Data[5]*exp(-Data[6]/Kb/Point[cX]));
 if Result<>0 then Result:=1/Result;
end;

procedure TFFMobility.NamesDefine;
begin
  SetNameCaption('Mobility',
      'Mobility vs temperature');
end;

procedure TFFMobility.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
              ['An','Adisl','Ai','Aph','Apz','Af','Fb']);
end;

procedure TFFMobility.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFElectronConcentration }

function TFFElectronConcentration.FermiLevelEquationS(Ef: double;
  Parameters: array of double): double;
 var T:double;
begin
 Result:=ErResult;
 if High(Parameters)<>1 then Exit;
 T:=Parameters[High(Parameters)];
 if T<=0 then Exit;
 Result:=abs(Parameters[0])-
         Material.Nc(T)*TMaterial.FDIntegral_05(-Ef/T/Kb);
end;

function TFFElectronConcentration.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  Result:=ElectronConcentrationSimple(Point[cX],Data,4,3,
                     ftempVector.Yvalue(Point[cX]),Material);
end;

procedure TFFElectronConcentration.NamesDefine;
begin
  SetNameCaption('n_vs_T',
      'Electron concentration in n-type semiconductors with donors and traps');
end;

procedure TFFElectronConcentration.ParamArrayCreate;
 var i:byte;
     FXname:array of string;
begin
 SetLength(FXname,15);
 FXname[0]:='Na';
 for I := 0 to 2 do
  begin
   FXname[2*i+1]:='Nd'+inttostr(i+1);
   FXname[2*i+2]:='Ed'+inttostr(i+1);
   FXname[2*i+9]:='Nt'+inttostr(i+1);
   FXname[2*i+10]:='Et'+inttostr(i+1);
  end;
  FXname[7]:='Nd4';
  FXname[8]:='Ed4';
  fDParamArray:=TDParamsHeuristic.Create(Self,
                  FXname);
end;

procedure TFFElectronConcentration.RealFitting;
 var i:integer;
begin
 ftempVector.CopyFrom(fDataToFit);
 for i := 0 to ftempVector.HighNumber do
   ftempVector.Y[i]:=Bisection(FermiLevelEquationS,
                           [ftempVector.Y[i],ftempVector.X[i]],
                            Material.EgT(ftempVector.X[i]),0,5e-4);
 inherited RealFitting;
end;

procedure TFFElectronConcentration.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFTnFeBPart }

function TFFnFeBPart.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
 Result:=1+Data[0]*Power(Point[cX],Data[3])
    /(1+Silicon.Nv(Point[cX])*Data[2]
      *exp(-Data[1]/Kb/Point[cX]));
end;

procedure TFFnFeBPart.NamesDefine;
begin
  SetNameCaption('n_FeB_vs_T',
      'Temperature dependence of ideality factor');
end;

procedure TFFnFeBPart.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['n0','Eeff','gamma','m_T']);
end;

procedure TFFnFeBPart.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFIV_thin }

procedure TFFIV_thin.AdditionalParamDetermination;
begin
 fDataToFit.SwapXY;
 PVparameteres(fDataToFit,fDParamArray);
 fDataToFit.SwapXY;
 inherited AdditionalParamDetermination;
end;

function TFFIV_thin.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
 Result:=CastroIV(Point[cX],[Data[0],Data[1],Data[2],
                            Data[3],Data[4],Data[5],
                            Data[6],Data[7],
                      (DoubVars.Parametr[0] as TVarDouble).Value]);
end;

procedure TFFIV_thin.NamesDefine;
begin
  SetNameCaption('IV_thin',
      'IV for thin film SC, Castro model is used');
end;

procedure TFFIV_thin.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['I01','n1','Rsh1','I02','n2','Rsh2','Rs','Iph'],
                 ['Voc','Isc','FF','Pm','Vm','Im']);
end;

procedure TFFIV_thin.TuningBeforeAccessorialDataCreate;
begin
  inherited;
  fHasPicture:=False;
end;

{ TFFTauDAP }

function TFFTauDAP.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
 Result:=Data[1]*Power(Point[cX]/300,Data[0]-0.5)/
         sqr(1+Data[2]*Point[cX]);
end;

procedure TFFTauDAP.NamesDefine;
begin
  SetNameCaption('TauDAP',
      'Lifetime in DAP theory');
end;

procedure TFFTauDAP.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['m','A','B']);
end;

procedure TFFTauDAP.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFRsh_T }

function TFFRsh_T.FuncForFitness(Point: TPointDouble; Data: TArrSingle): double;
begin
   Result:=Rsh_T(Point[cX],Data[0],Data[1],Data[3],Data[2]);
end;

procedure TFFRsh_T.NamesDefine;
begin
  SetNameCaption('RshT',
      'Shunt resistance vs T');
end;

procedure TFFRsh_T.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['A','Et','U0','qUs']);
end;

class function TFFRsh_T.Rsh_T(T, A, Et, qUs, U0: double): double;
begin
 Result:=A*T*(cosh(Et/T/Kb-U0)+cosh(qUs/T/Kb-U0));
end;

procedure TFFRsh_T.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFRsh2_T }

function TFFRsh2_T.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
 var Rdisl,Rmet:double;
begin
 Rdisl:=TFFRsh_T.Rsh_T(Point[cX],Data[0],Data[1],Data[2],0);
 Rmet:=Data[3]*(1+(Point[cX]-293)*Data[4]);
 Result:=Rdisl*Rmet/(Rdisl+Rmet);
end;

procedure TFFRsh2_T.NamesDefine;
begin
  SetNameCaption('RdislRmet',
      'Shunt resistance with T');
end;

procedure TFFRsh2_T.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['A','Et','qUs','R0','alp']);

end;

procedure TFFRsh2_T.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

end.
