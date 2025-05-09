unit OApproxFunction2;

interface

uses
  FitHeuristic, OlegType, FitMaterial, FitVariable, OApproxNew, OlegDefectsSi;

const
 BrailsfordName='Ultrasound atteniation, Brailsford"s theory. w is a frequency. ';

type


TFFDoubleDiod=class (TFFHeuristic)
{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]+(V-IRs)/Rsh}
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFDoubleDiod=class (TFFHeuristic)

TFFDoubleDiodTau=class (TFFHeuristic)
{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]+(V-IRs)/Rsh
I01 та I02 виражаються через часи життя}
 private
  Igen,Iscr:double;
  Igen0,Igen1,Iscr0:double;
  procedure IgenIscrDetermine(tau_n,tau_g, Rs:double;Point:TPointDouble);
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
  procedure VariousPreparationBeforeFitting;override;
 published
  property PN_Diode:TD_PNFit read fPNDiode;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFDoubleDiodTau=class (TFFHeuristic)


TFFDoubleDiodLight=class (TFFIlluminatedDiode)
{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]
         +(V-IRs)/Rsh-Iph}
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFDoubleDiodLight=class (TFFIlluminatedDiode)


TFFDoubleDiodTauLight=class (TFFIlluminatedDiode)
{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]
         +(V-IRs)/Rsh-Iph
I01 та I02 виражаються через часи життя}
 private
  Igen,Iscr:double;
  Igen0,Igen1,Iscr0:double;
  procedure IgenIscrDetermine(tau_n,tau_g, Rs:double;Point:TPointDouble);
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
  procedure VariousPreparationBeforeFitting;override;
 published
  property PN_Diode:TD_PNFit read fPNDiode;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFDoubleDiodTauLight=class (TFFIlluminatedDiode)

TFFTripleDiod=class (TFFHeuristic)
{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]+
    I03[exp((V-IRs)/n3kT)-1]+(V-IRs)/Rsh}
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFTripleDiod=class (TFFHeuristic)


TFFTripleDiodLight=class (TFFIlluminatedDiode)
{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]+
    I03[exp((V-IRs)/n3kT)-1]+(V-IRs)/Rsh}
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; //  TFFDoubleDiodLight=class (TFFIlluminatedDiode)

TFFNGausian=class (TFFHeuristic)
 private
  fNgaus:byte;
  fRealNgaus:byte;
  procedure SetNGaus(Value:byte);
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure AccessorialDataCreate;override;
  function FittingCalculation:boolean;override;
  Procedure RealToFile;override;
 public
  property Ngaus:byte read fNgaus write SetNGaus;
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFNGausian=class (TFFHeuristic)

TFFTunnel=class (TFFHeuristic)
{I0*exp(-A*(B+x)^0.5)}
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFTunnel=class (TFFHeuristic)

TFFTunnelFNmy=class (TFFHeuristic)
{I(V)=I0*exp(-4/3h (2mq)^0.5 d/(nu V) [(Uo + nu V)^3/2-Uo^3/2])
тунелювання через трапеціїдальний бар'єр шириною d,
вважається, що на бар'єрі падає (nu V) від прикладеної
напруги V, а без напруги бар'єр прямокутний
висотою Uo}
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFTunnelFNmy=class (TFFHeuristic)

TFFPower2=class (TFFHeuristic)
{A1*(x^m1 + A2*x^m2)}
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFTunnelFNmy=class (TFFHeuristic)

TFFTEandSCLC_kT1=class (TFFHeuristic)
{I(1/kT) = I01*T^2*exp(-E1/kT)+I02*T^m*exp(-E2/kT)
m- константа}
 private
  fIsSerial:TVarBool;
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure AddDoubleVars;override;
  procedure AccessorialDataCreate;override;
  function ParameterCreate:TFFParameter;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFTEandSCLC_kT1=class (TFFHeuristic)

TFFTEandSCLCexp_kT1=class (TFFHeuristic)
{ I(1/kT)=I01*T^2*exp(-E/kT)+I02*T^(m)*A^(-300/T)
залежності від x=1/(kT)}
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure AddDoubleVars;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFTEandSCLCexp_kT1=class (TFFHeuristic)

TFFTEandTAHT_kT1=class (TFFHeuristic)
{I(1/kT)=I01*T^2*exp(-E/kT)+I02*T^(m)*exp(-(Tc/T)^p)}
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure AddDoubleVars;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFTEandTAHT_kT1=class (TFFHeuristic)

TFFBrails=class (TFFHeuristic)
{для визначення температурної (клас TFFBrailsford) або
частотної (клас TFFBrailsfordw) залежності коефіцієнта
поглинання звуку
alpha(T,w) = A*w/T*(B*w*exp(E/kT))/(1+(B*w*exp(E/kT)^2) }
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure AddDoubleVars;override;
end; // TFFBrails=class (TFFHeuristic)

TFFBrailsford=class (TFFBrails)
 protected
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFBrailsford=class (TFFBrails)


TFFBrailsfordw=class (TFFBrails)
 protected
  procedure NamesDefine;override;
  procedure AddDoubleVars;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFBrails=class (TFFHeuristic)


TFFBarierHeigh=class (TFFHeuristic)
{Fb=Fb0-a*x- b*x^0.5}
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFBarierHeigh=class (TFFHeuristic)


TFFCurrentSC=class (TFFHeuristic)
{Isc(T)=Nph*Abs*Lo*T^m/(1+Abs*Lo*T^m)}
 private
  fT0:double;
  function TemperatureToString(T:double):string;
  function PointToString(Point:TPointDouble):string;
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure AddDoubleVars;override;
  Procedure RealToFile;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFCurrentSC=class (TFFHeuristic)

TFFFei_FeB=class (TFFHeuristic)
{базовий клас для функцій, що передбачають перетворення
Fei->FeB}
 private
  fFei:TDefect;
  fFeB:TDefect;
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
 public
  destructor Destroy;override;
end;

TFFTAU_Fei_FeB=class (TFFFei_FeB)
  private

    fMaterialLayer: TMaterialLayerFit;{часова залежність часу життя неосновних носіїв,
якщо відбувається перехід міжвузольного
заліза в комплекс FeB
tau(t)= 1/(1/tau_FeB+1/tau_Fei+1/tau_r)
де tau_r - час життя, що задаєься іншими механізмами
рекомбінації, окрім на рівнях, зв'язаними з Fei та FeB;
параметри, які підбираються - сумарна концентрація
атомів заліза (міжвузольних та в парах FeB) та tau_r}
// private
//  fFei:TDefect;
//  fFeB:TDefect;
 protected
//  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  procedure AddDoubleVars;override;
 published
  property Layer:TMaterialLayerFit read fMaterialLayer;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
//  destructor Destroy;override;
end; //TFFTAU_Fei_FeB=class (TFFHeuristic)

TFFIsc_shablon=class (TFFFei_FeB)
 {базовий клас для функцій, що описують
часова залежність струму короткого замикання,
якщо відбувається перехід міжвузольного
заліза в комплекс FeB
час життя неосновних носіїв розраховується як
tau(t)= 1/(1/tau_FeB+1/tau_Fei+1/tau_r+1/tau_band-to-band+1/tau_ceauger)
де tau_r - час життя, що задаєься іншими механізмами
рекомбінації, окрім на рівнях, зв'язаними з Fei та FeB;
 }
 private
  fAbsorp:double;
  fNph:double;
  fT:double;
  mukT:double;
  ftau_btb:double;
  ftau_auger:double;
//    fPNDiode: TD_PNFit;
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure AddDoubleVars;override;
  procedure VariousPreparationBeforeFitting;override;
 public
  class function Nph(Lambda:double;R:double=0):double;
  {повертає величину
  (1-R)*q*Lambda/hc,
  [Lambda]=nm}
  class function Al_L(Abs,L:double):double;
  {Result=Abs*L/(1+Abs*L),
  [Lambda]=нм}
 published
  property PN_Diode:TD_PNFit read fPNDiode;
end;


TFFIsc_Fei_FeB=class (TFFIsc_shablon)
{параметри, які підбираються:
 Nfe - сумарна концентрація атомів заліза (міжвузольних та в парах FeB)
 tau_r
 Wph - інтенсивність освітлення
 Em - енергія міграції міжвузольного заліза
  (в літературі 0,68 еВ)}
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
// published
//  property PN_Diode:TD_PNFit read fPNDiode;
  procedure AdditionalParamDetermination;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFIsc_Fei_FeB=class (TFFHeuristic)


TFFIsc2_Fei_FeB=class (TFFIsc_shablon)
{параметри, які підбираються:
 Nfe - сумарна концентрація атомів заліза (міжвузольних та в парах FeB)
 tau_r
 Wph - інтенсивність освітлення
 t_asos - характерний час поєднання
 Kr - частка міжвузольних атомів в початковий момент
 (Nfei(o)=Kr*Nfe)}
 protected
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFIsc_Fei_FeB=class (TFFHeuristic)

TFFPlanc=class (TFFHeuristic)
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
 public
  class Function Planck(lambda,T:double;A:double=1):double;
  {[lambda]=nm}
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;override;
end; // TFFPlanc=class (TFFHeuristic)


implementation

uses
  FitIteration, OlegMath, Math, SysUtils, OlegMaterialSamples, Classes, OlegFunction
  {XP Win}
  ,Vcl.Dialogs, OlegStatistic
  ;

{ TFFDoubleDiod }

function TFFDoubleDiod.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  Result:=IV_DiodDouble(Point[cX],[Data[0],Data[1],Data[2],
                   Data[4],Data[5],
                   (DoubVars.Parametr[0] as TVarDouble).Value],
                   Point[cY])
                   +(Point[cX]-Point[cY]*Data[1])/Data[3];
end;

procedure TFFDoubleDiod.NamesDefine;
begin
  SetNameCaption('DoubleDiod',
      'Two-diode model of solar cell I-V');
end;

procedure TFFDoubleDiod.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['n1','Rs','Io1','Rsh','n2','Io2']);
end;

function TFFDoubleDiod.RealFinalFunc(X: double): double;
begin
  Result:=Full_IV(IV_DiodDouble,X,[fDParamArray.OutputData[0],
                 fDParamArray.OutputData[1],fDParamArray.OutputData[2],
                 fDParamArray.OutputData[4],fDParamArray.OutputData[5],
                 (DoubVars.Parametr[0] as TVarDouble).Value],
                 fDParamArray.OutputData[3]);
end;


{ TFFDoubleDiodTau }

function TFFDoubleDiodTau.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  IgenIscrDetermine(Data[2],Data[5],
                    Data[1],Point);
  Result:=IV_DiodDouble(Point[cX],[Data[0],Data[1],Igen,
                   Data[4],Iscr,
                   (DoubVars.Parametr[0] as TVarDouble).Value],
                   Point[cY])
                   +(Point[cX]-Point[cY]*Data[1])/Data[3];
end;

procedure TFFDoubleDiodTau.IgenIscrDetermine(tau_n, tau_g, Rs: double;
                                            Point:TPointDouble);
begin
  Igen:=Igen0*sqrt(Igen1/tau_n);
  Iscr:=Iscr0*PN_Diode.W((DoubVars.Parametr[0] as TVarDouble).Value,Point[cX]-Point[cY]*Rs)/tau_g;
end;

procedure TFFDoubleDiodTau.NamesDefine;
begin
  SetNameCaption('DoubleDiodTau',
      'Two-diode model of solar cell I-V, life times are used');
end;

procedure TFFDoubleDiodTau.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['n1','Rs','tau_n','Rsh','n2','tau_g']);
end;

function TFFDoubleDiodTau.RealFinalFunc(X: double): double;
begin
  PointDetermine(X);
  IgenIscrDetermine(fDParamArray.OutputData[2],
                    fDParamArray.OutputData[5],
                    fDParamArray.OutputData[1],fPoint);
  Result:=Full_IV(IV_DiodDouble,X,[fDParamArray.OutputData[0],
                 fDParamArray.OutputData[1],Igen,
                 fDParamArray.OutputData[4],Iscr,
                 (DoubVars.Parametr[0] as TVarDouble).Value],
                 fDParamArray.OutputData[3]);

end;


procedure TFFDoubleDiodTau.VariousPreparationBeforeFitting;
begin
 inherited VariousPreparationBeforeFitting;
 Igen0:=Qelem*PN_Diode.Area
        *Power(PN_Diode.n_i((DoubVars.Parametr[0] as TVarDouble).Value),2)
        /PN_Diode.Nd;
 Igen1:=PN_Diode.mu((DoubVars.Parametr[0] as TVarDouble).Value)
        *Kb*(DoubVars.Parametr[0] as TVarDouble).Value;
 Iscr0:=Qelem*PN_Diode.Area
        *PN_Diode.n_i((DoubVars.Parametr[0] as TVarDouble).Value)/2
end;

{ TFFDoubleDiodLight }

function TFFDoubleDiodLight.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  Result:=IV_DiodDouble(Point[cX],[Data[0],Data[1],Data[2],
                   Data[4],Data[5],
                   (DoubVars.Parametr[0] as TVarDouble).Value],
                   Point[cY])
                   +(Point[cX]-Point[cY]*Data[1])/Data[3]
                   -Data[6];

//  Result:=IV_Diod(Point[cX],[Data[0],Data[1],Data[2],
//                 (DoubVars.Parametr[0] as TVarDouble).Value],Point[cY])
//      +(Point[cX]-Point[cY]*Data[1])/Data[3]-Data[4];
end;

procedure TFFDoubleDiodLight.NamesDefine;
begin
  SetNameCaption('DoubleDiodLight',
      'Two-diode model of illuminated solar cell I-V');
end;

procedure TFFDoubleDiodLight.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['n1','Rs','Io1','Rsh','n2','Io2','Iph'],
                 ['Voc','Isc','FF','Pm','Vm','Im']);
end;

function TFFDoubleDiodLight.RealFinalFunc(X: double): double;
begin
   Result:=Full_IV(IV_DiodDouble,X,[fDParamArray.OutputData[0],
                 fDParamArray.OutputData[1],fDParamArray.OutputData[2],
                 fDParamArray.OutputData[4],fDParamArray.OutputData[5],
                 (DoubVars.Parametr[0] as TVarDouble).Value],
                 fDParamArray.OutputData[3],
                 fDParamArray.OutputData[6]);
end;


{ TFFDoubleDiodTauLight }

function TFFDoubleDiodTauLight.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  IgenIscrDetermine(Data[2],Data[5],
                    Data[1],Point);
  Result:=IV_DiodDouble(Point[cX],[Data[0],Data[1],Igen,
                   Data[4],Iscr,
                   (DoubVars.Parametr[0] as TVarDouble).Value],
                   Point[cY])
                   +(Point[cX]-Point[cY]*Data[1])/Data[3]
                   -Data[6];
end;

procedure TFFDoubleDiodTauLight.IgenIscrDetermine(tau_n, tau_g, Rs: double;
  Point: TPointDouble);
begin
  Igen:=Igen0*sqrt(Igen1/tau_n);
  Iscr:=Iscr0*PN_Diode.W((DoubVars.Parametr[0] as TVarDouble).Value,Point[cX]-Point[cY]*Rs)/tau_g;
end;

procedure TFFDoubleDiodTauLight.NamesDefine;
begin
  SetNameCaption('DoubleDiodTauLight',
      'Two-diode model of illuminated solar cell I-V, life times are used');
end;

procedure TFFDoubleDiodTauLight.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['n1','Rs','tau_n','Rsh','n2','tau_g','Iph'],
                 ['Voc','Isc','FF','Pm','Vm','Im']);
end;

function TFFDoubleDiodTauLight.RealFinalFunc(X: double): double;
begin
  PointDetermine(X);
  IgenIscrDetermine(fDParamArray.OutputData[2],
                    fDParamArray.OutputData[5],
                    fDParamArray.OutputData[1],fPoint);
  Result:=Full_IV(IV_DiodDouble,X,[fDParamArray.OutputData[0],
                 fDParamArray.OutputData[1],Igen,
                 fDParamArray.OutputData[4],Iscr,
                 (DoubVars.Parametr[0] as TVarDouble).Value],
                 fDParamArray.OutputData[3],
                 fDParamArray.OutputData[6]);
end;


procedure TFFDoubleDiodTauLight.VariousPreparationBeforeFitting;
begin
 inherited;
 Igen0:=Qelem*PN_Diode.Area
        *Power(PN_Diode.n_i((DoubVars.Parametr[0] as TVarDouble).Value),2)
        /PN_Diode.Nd;
 Igen1:=PN_Diode.mu((DoubVars.Parametr[0] as TVarDouble).Value)
        *Kb*(DoubVars.Parametr[0] as TVarDouble).Value;
 Iscr0:=Qelem*PN_Diode.Area
        *PN_Diode.n_i((DoubVars.Parametr[0] as TVarDouble).Value)/2
end;

{ TFFTripleDiod }

function TFFTripleDiod.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
 var Veff,neff:double;
begin
 Veff:=Point[cX]-Point[cY]*Data[1];
 neff:=Veff/Kb/(DoubVars.Parametr[0] as TVarDouble).Value;
 Result:=Data[2]*(exp(neff/Data[0])-1)
       +Data[5]*(exp(neff/Data[4])-1)
       +Data[6]*(exp(neff/Data[7])-1)
       +Veff/Data[3];
end;

procedure TFFTripleDiod.NamesDefine;
begin
  SetNameCaption('TripleDiod',
      '3-diode model of solar cell I-V');

end;

procedure TFFTripleDiod.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['n1','Rs','Io1','Rsh','n2',
                 'Io2','Io3','n3']);
end;

function TFFTripleDiod.RealFinalFunc(X: double): double;
begin
 Result:=Full_IV(IV_DiodTriple,X,
               [fDParamArray.OutputData[0]
                *Kb*(DoubVars.Parametr[0] as TVarDouble).Value,
                fDParamArray.OutputData[1],
                fDParamArray.OutputData[2],
                fDParamArray.OutputData[4]
                *Kb*(DoubVars.Parametr[0] as TVarDouble).Value,
                fDParamArray.OutputData[5],
                fDParamArray.OutputData[7]
                *Kb*(DoubVars.Parametr[0] as TVarDouble).
                Value,fDParamArray.OutputData[6]],
                fDParamArray.OutputData[3],0);
end;


{ TFFTripleDiodLight }

function TFFTripleDiodLight.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
 var Veff,neff:double;
begin
 Veff:=Point[cX]-Point[cY]*Data[1];
 neff:=Veff/Kb/(DoubVars.Parametr[0] as TVarDouble).Value;
 Result:=Data[2]*(exp(neff/Data[0])-1)
       +Data[5]*(exp(neff/Data[4])-1)
       +Data[7]*(exp(neff/Data[8])-1)
       +Veff/Data[3]-Data[6];
end;

procedure TFFTripleDiodLight.NamesDefine;
begin
  SetNameCaption('TripleDiodLight',
      '3-diode model of illuminated solar cell I-V');
end;

procedure TFFTripleDiodLight.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['n1','Rs','Io1','Rsh','n2',
                 'Io2','Iph','Io3','n3'],
                 ['Voc','Isc','FF','Pm','Vm','Im']);
end;

function TFFTripleDiodLight.RealFinalFunc(X: double): double;
begin
 Result:=Full_IV(IV_DiodTriple,X,
               [fDParamArray.OutputData[0]
                *Kb*(DoubVars.Parametr[0] as TVarDouble).Value,
                fDParamArray.OutputData[1],
                fDParamArray.OutputData[2],
                fDParamArray.OutputData[4]
                *Kb*(DoubVars.Parametr[0] as TVarDouble).Value,
                fDParamArray.OutputData[5],
                fDParamArray.OutputData[8]
                *Kb*(DoubVars.Parametr[0] as TVarDouble).
                Value,fDParamArray.OutputData[7]],
                fDParamArray.OutputData[3],
                fDParamArray.OutputData[6]);
end;


{ TFFNGausian }

procedure TFFNGausian.AccessorialDataCreate;
begin
  inherited;
  fIntVars.Add(Self,'Ng');
  fIntVars.ParametrByName['Ng'].Limits.SetLimits(1);
  fIntVars.ParametrByName['Ng'].Description:=
        'Gaussian number';
end;

function TFFNGausian.FittingCalculation: boolean;
 var i:integer;
     Names,AddNames:array of string;
     Xmin,Xmax,delY,delX:double;
     aRegWeight,SumArea:double;
     aEvType:TEvolutionTypeNew;
     aFitType:TFitnessType;
     aRegType:TRegulationType;
     aLogFitness:boolean;
begin
  if Ngaus>0
   then (fIntVars.ParametrByName['Ng'] as TVarInteger).Value:=Ngaus;

  fRealNgaus:=(fIntVars.ParametrByName['Ng'] as TVarInteger).Value;

  SetLength(Names,3*fRealNgaus);
  for I := 1 to fRealNgaus do
   begin
    Names[3*i-3]:='A'+inttostr(i);
    Names[3*i-2]:='X0'+inttostr(i);
    Names[3*i-1]:='Sig'+inttostr(i);
   end;

  SetLength(AddNames,2*fRealNgaus+1);
  for I := 1 to fRealNgaus do
   AddNames[i-1]:='Area'+inttostr(i);
  for I := 1 to fRealNgaus do
   AddNames[i-1+fRealNgaus]:='Eps_ar'+inttostr(i);
  AddNames[2*fRealNgaus]:='ArTotal';

   aRegWeight:=(fDParamArray as TDParamsHeuristic).RegWeight;
   aEvType:=(fDParamArray as TDParamsHeuristic).EvType;
   aFitType:=(fDParamArray as TDParamsHeuristic).FitType;
   aRegType:=(fDParamArray as TDParamsHeuristic).RegType;
   aLogFitness:=(fDParamArray as TDParamsHeuristic).LogFitness;

  FreeAndNil(fDParamArray);
//  fDParamArray:=TDParamsHeuristic.Create(Self,
//                 Names);
  fDParamArray:=TDParamsHeuristic.Create(Self,
                 Names,AddNames);
   (fDParamArray as TDParamsHeuristic).RegWeight:=aRegWeight;
   (fDParamArray as TDParamsHeuristic).EvType:=aEvType;
   (fDParamArray as TDParamsHeuristic).FitType:=aFitType;
   (fDParamArray as TDParamsHeuristic).RegType:=aRegType;
   (fDParamArray as TDParamsHeuristic).LogFitness:=aLogFitness;


  for I := 0 to fDParamArray.MainParamHighIndex do
    begin
    fDParamArray.fParams[i].IsConstant:=False;
    (fDParamArray.fParams[i] as TFFParamHeuristic).Mode:=vr_lin;
    end;

  Xmin:=fDataToFit.MinX;
  Xmax:=fDataToFit.MaxX;
  delY:=fDataToFit.MaxY-fDataToFit.MinY;
  delX:=Xmax-Xmin;
  for I := 1 to fRealNgaus do
   begin
    (fDParamArray.fParams[3*i-3] as TFFParamHeuristic).fMinLim:=0;
//    (fDParamArray.fParams[3*i-3] as TFFParamHeuristic).fMaxLim:=delY*10;
    (fDParamArray.fParams[3*i-3] as TFFParamHeuristic).fMaxLim:=delY*3;
    (fDParamArray.fParams[3*i-2] as TFFParamHeuristic).fMinLim:=Xmin-delX;
    (fDParamArray.fParams[3*i-2] as TFFParamHeuristic).fMaxLim:=Xmax+delX;
//    (fDParamArray.fParams[3*i-2] as TFFParamHeuristic).fMinLim:=Xmin-5*delX;
//    (fDParamArray.fParams[3*i-2] as TFFParamHeuristic).fMaxLim:=Xmax+5*delX;
//    (fDParamArray.fParams[3*i-1] as TFFParamHeuristic).fMinLim:=delX/1000;
    (fDParamArray.fParams[3*i-1] as TFFParamHeuristic).fMinLim:=delX/100;
    (fDParamArray.fParams[3*i-1] as TFFParamHeuristic).fMaxLim:=10*delX;
   end;
//  (fDParamArray as TDParamsIteration).Nit:=2000*(4+sqr(fRealNgaus));
  (fDParamArray as TDParamsIteration).Nit:=2000*(4+round(Power(fRealNgaus,2.8)));

  Result:=Inherited FittingCalculation;


  SumArea:=0;
  for I := 1 to fRealNgaus do
   begin
   fDParamArray.ParametrByName['Area'+inttostr(i)].Value:=
    fDParamArray.ParametrByName['A'+inttostr(i)].Value*
    TNormalD.CDF_AB(DataToFit.MinX,DataToFit.MaxX,
                    fDParamArray.ParametrByName['X0'+inttostr(i)].Value,
                    fDParamArray.ParametrByName['Sig'+inttostr(i)].Value);
   SumArea:=SumArea+fDParamArray.ParametrByName['Area'+inttostr(i)].Value;
   end;
  for I := 1 to fRealNgaus do
   fDParamArray.ParametrByName['Eps_ar'+inttostr(i)].Value:=
     fDParamArray.ParametrByName['Area'+inttostr(i)].Value/SumArea;

  fDParamArray.ParametrByName['ArTotal'].Value:=SumArea;

end;

function TFFNGausian.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
 var i:byte;
begin
 Result:=0;
 for I := 1 to fRealNgaus do
   Result:=Result+
//     Data[3*i-3]/sqrt(2*Pi)/Data[3*i-1]
//     *exp(-sqr((Point[cX]-Data[3*i-2]))/2/sqr(Data[3*i-1]));
     Data[3*i-3]*TNormalD.PDF(Point[cX], Data[3*i-2], Data[3*i-1])
//   Result:=1/sigma/sqrt(2*Pi)*exp(-sqr((x-mu)/sigma)/2);
end;

procedure TFFNGausian.NamesDefine;
begin
  SetNameCaption('N_Gausian',
      'Sum of Gaussian');
end;


procedure TFFNGausian.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 []);
end;

procedure TFFNGausian.RealToFile;
var Str1:TStringList;
    i,j{,FCN}:integer;
    tempStr:string;
begin
  Str1:=TStringList.Create;
 for I := 0 to FittingData.HighNumber do
 begin
  tempStr:='';
  tempStr:=tempStr+FloatToStrF(FittingData.X[i],ffExponent,DigitNumber,0);
  for j := 1 to fRealNgaus do
    tempStr:=tempStr+' '+
       FloatToStrF(fDParamArray.fParams[3*j-3].Value
        *TNormalD.PDF(FittingData.X[i], fDParamArray.fParams[3*j-2].Value,
                      fDParamArray.fParams[3*j-1].Value),
       ffExponent,DigitNumber,0);
  tempStr:=tempStr+' '+FloatToStrF(FittingData.Y[i],ffExponent,DigitNumber,0);
  str1.Add(tempStr);
 end;

 Str1.SaveToFile(FitName(fDataToFit,FileSuffix));
 Str1.Free;
end;

procedure TFFNGausian.SetNGaus(Value: byte);
begin
 if Value>0 then fNgaus:=Value;
end;

procedure TFFNGausian.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
// fHasPicture:=False;
 Ngaus:=0;
end;

{ TFFTunnel }

function TFFTunnel.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  Result:=TunFun(Point[cX],Data);
end;

procedure TFFTunnel.NamesDefine;
begin
  SetNameCaption('Tunnel',
      'Tunneling through rectangular barrier');
end;

procedure TFFTunnel.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Io','A','B']);
end;

procedure TFFTunnel.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFTunnelFNmy }

function TFFTunnelFNmy.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
 Result:=Data[0]*exp(-4/(3*Hpl)*sqrt(2*Qelem*m0*0.5)*
                           Data[1]/(Data[2]*Point[cX])*
    (Power((Data[3]+Data[2]*Point[cX]),1.5)-Power(Data[3],1.5)));
end;

procedure TFFTunnelFNmy.NamesDefine;
begin
  SetNameCaption('TunnelFNMy',
      'Tunneling through trapezoidal barrier with depth d, '+
      'if voltage is absent, then barrier is rectangular with Uo height'+
      'and only part of voltage is drop on barrier');
end;

procedure TFFTunnelFNmy.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Io','d','nu','Uo']);

end;

procedure TFFTunnelFNmy.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFPower2 }

function TFFPower2.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
 Result:=Data[0]
        *(Power(Point[cX],Data[2])+Data[1]*Power(Point[cX],Data[3]));
end;

procedure TFFPower2.NamesDefine;
begin
  SetNameCaption('Power2',
      'Two power-law function');
end;

procedure TFFPower2.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['A1','A2','m1','m2']);
end;

procedure TFFPower2.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFTEandSCLC_kT1 }

procedure TFFTEandSCLC_kT1.AccessorialDataCreate;
begin
  inherited;
  fIsSerial:=TVarBool.Create(Self,'Serial Configuration');
end;

procedure TFFTEandSCLC_kT1.AddDoubleVars;
begin
  inherited;
  DoubVars.Add(Self,'m');
end;

function TFFTEandSCLC_kT1.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
 var I1,I2:double;
begin
  Result:=ErResult;
  if Point[cX]<=0 then Exit;
  I1:= RevZrizFun(Point[cX],2,Data[0],Data[1]);
  I2:= RevZrizFun(Point[cX],
                 (DoubVars.Parametr[0] as TVarDouble).Value,
                  Data[2],Data[3]);;
  if fIsSerial.Value then Result:=I1+I2
                     else Result:=I1*I2/(I1+I2);
end;

procedure TFFTEandSCLC_kT1.NamesDefine;
begin
  SetNameCaption('TEandSCLC',
      'Dependence of reverse current'+
      'at constant bias on inverse temperature. '+
      'First component is TE current, second is SCLC current');
end;

procedure TFFTEandSCLC_kT1.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Io1','E1','Io2','E2']);
end;

function TFFTEandSCLC_kT1.ParameterCreate: TFFParameter;
begin
  Result:=TDecBoolVarParameter.Create(fIsSerial,
               inherited ParameterCreate);
end;

procedure TFFTEandSCLC_kT1.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFTEandSCLCexp_kT1 }

procedure TFFTEandSCLCexp_kT1.AddDoubleVars;
begin
  inherited;
  DoubVars.Add(Self,'m');
  DoubVars.ParametrByName['m'].Description:='temperature power-law parameter (m)';
end;

function TFFTEandSCLCexp_kT1.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
 Result:=RevZrizFun(Point[cX],2,Data[0],Data[1])
         +RevZrizSCLC(Point[cX],(DoubVars.Parametr[0] as TVarDouble).Value,
                      Data[2],Data[3]);
end;

procedure TFFTEandSCLCexp_kT1.NamesDefine;
begin
  SetNameCaption('TEandSCLCexp',
      'Dependence of reverse current'+
                'at constant bias on inverse temperature. '+
                'First component is TE current, second is SCLC current (exponential trap distribution); '+
                'ln-based fitness function is recommended');
end;

procedure TFFTEandSCLCexp_kT1.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Io1','E','Io2','A']);
end;

procedure TFFTEandSCLCexp_kT1.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFTEandTAHT_kT1 }

procedure TFFTEandTAHT_kT1.AddDoubleVars;
begin
  inherited;
  DoubVars.Add(Self,'m');
  DoubVars.Add(Self,'p');
end;

function TFFTEandTAHT_kT1.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
  var T1:double;
begin
 T1:=Kb*Point[cX];
 Result:=RevZrizFun(Point[cX],2,Data[0],Data[1])
         +Data[2]*exp(-Power((Data[3]*T1),(DoubVars.Parametr[1] as TVarDouble).Value))
         *Power(T1,-(DoubVars.Parametr[0] as TVarDouble).Value);
end;

procedure TFFTEandTAHT_kT1.NamesDefine;
begin
  SetNameCaption('TEandTAHT',
      'Dependence of reverse current'+
                'at constant bias on inverse temperature. '+
                'First component is TE current, second is termally-assisted hopping transport');
end;

procedure TFFTEandTAHT_kT1.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Io1','E','Io2','Tc']);
end;

procedure TFFTEandTAHT_kT1.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFBrails }

procedure TFFBrails.AddDoubleVars;
begin
  inherited;
  DoubVars.Add(Self,'w');
  DoubVars.ParametrByName['w'].Description:='Frequency';
end;

procedure TFFBrails.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['A','B','E']);
end;

procedure TFFBrails.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
 FPictureName:='BrailsfordFig';
end;

{ TFFBrailsford }

function TFFBrailsford.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
 Result:=Brailsford(Point[cX],
           (DoubVars.Parametr[0] as TVarDouble).Value,
           Data);
end;

procedure TFFBrailsford.NamesDefine;
begin
  SetNameCaption('Brailsford',
      BrailsfordName+'Dependence on temperature.');
end;

{ TFFBrailsfordw }

procedure TFFBrailsfordw.AddDoubleVars;
begin
  inherited;
  DoubVars.ParametrByName['w'].Description:='Temperature';
end;

function TFFBrailsfordw.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
 Result:=Brailsford((DoubVars.Parametr[0] as TVarDouble).Value,
              Point[cX],Data);
end;

procedure TFFBrailsfordw.NamesDefine;
begin
  SetNameCaption('Brailsfordw',
      BrailsfordName+'Dependence on frequency.');
end;

{ TFFBarierHeigh }

function TFFBarierHeigh.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  Result:=Data[0]-Data[1]*Point[cX]-Data[2]*sqrt(Point[cX]);
end;

procedure TFFBarierHeigh.NamesDefine;
begin
  SetNameCaption('BarierHeigh',
      'Barier heigh on electric field, '+
      'Schottky (Poole-Frenkel) effect (b value) and linear (a value)');
end;

procedure TFFBarierHeigh.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Fbo','a','b']);
end;

procedure TFFBarierHeigh.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
end;

{ TFFCurrentSC }

procedure TFFCurrentSC.AddDoubleVars;
begin
  inherited;
  DoubVars.Add(Self,'L_nm');
  DoubVars.ParametrByName['L_nm'].Description:='Illumination wave length (nm)';
  DoubVars.ParametrByName['L_nm'].Limits.SetLimits(0);
end;

function TFFCurrentSC.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
 var AlL:double;
begin
 AlL:=Silicon.Absorption((DoubVars.Parametr[0] as TVarDouble).Value,Point[cX])*
          Data[1]*Power(Point[cX]/fT0,Data[2]);
 Result:=Data[0]*AlL/(1+AlL);
end;

procedure TFFCurrentSC.NamesDefine;
begin
  SetNameCaption('Isc',
      'Isc on temperature for monochromatic llumination');
end;

procedure TFFCurrentSC.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Nph','Lo','m']);
end;

function TFFCurrentSC.PointToString(Point: TPointDouble): string;
 var AlL:double;
begin
 AlL:=Silicon.Absorption((DoubVars.Parametr[0] as TVarDouble).Value,Point[cX])*
          fDParamArray.OutputData[1]*Power(Point[cX]/fT0,fDParamArray.OutputData[2]);
 Result:=FloatToStrF(Point[cX],ffExponent,4,0)+' '
         +FloatToStrF(Point[cY],ffExponent,DigitNumber,0)+' '
         +FloatToStrF(fDParamArray.OutputData[0]*AlL/(1+AlL),ffExponent,DigitNumber,0)+' '
         +FloatToStrF(fDParamArray.OutputData[1]*Power(Point[cX]/fT0,fDParamArray.OutputData[2]),ffExponent,DigitNumber,0);
end;

procedure TFFCurrentSC.RealToFile;
var Str1:TStringList;
    i:integer;
begin
  Str1:=TStringList.Create;
  if fIntVars[0]<>0 then
   begin
    Str1.Add('T Isc_fit DiffLength');
    for i := 0 to FittingData.HighNumber do
     Str1.Add(TemperatureToString(FittingData.X[i]));

   end              else
   begin
    Str1.Add('T Isc Isc_fit DiffLength');
    for i := 0 to fDataToFit.HighNumber do
     Str1.Add(PointToString(fDataToFit[i]));
   end;
  Str1.SaveToFile(FitName(fDataToFit,FileSuffix));
  Str1.Free;
end;

function TFFCurrentSC.TemperatureToString(T:double): string;
 var AlL:double;
begin
 AlL:=Silicon.Absorption((DoubVars.Parametr[0] as TVarDouble).Value,T)*
          fDParamArray.OutputData[1]*Power(T/fT0,fDParamArray.OutputData[2]);
 Result:=FloatToStrF(T,ffExponent,4,0)+' '
         +FloatToStrF(fDParamArray.OutputData[0]*AlL/(1+AlL),ffExponent,DigitNumber,0)+' '
         +FloatToStrF(fDParamArray.OutputData[1]*Power(T/fT0,fDParamArray.OutputData[2]),ffExponent,DigitNumber,0);
end;

procedure TFFCurrentSC.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
 fT0:=300;
end;

{ TFFTAU_Fei_FeB }

procedure TFFTAU_Fei_FeB.AddDoubleVars;
begin
  inherited;
  DoubVars.Add(Self,'delN');
  DoubVars.ParametrByName['delN'].Limits.SetLimits(0);
end;

function TFFTAU_Fei_FeB.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
 fFei.Nd:=Fe_i_t(Point[cX],Layer,Data[0],
                (DoubVars.Parametr[0] as TVarDouble).Value);
 fFeB.Nd:=Data[0]-fFei.Nd;
 Result:=TMaterial.TauMatthiessenRule([Data[1],
            fFei.TAUsrh(Layer.Nd,
                    (DoubVars.Parametr[1] as TVarDouble).Value,
                    (DoubVars.Parametr[0] as TVarDouble).Value),
            fFeB.TAUsrh(Layer.Nd,
                    (DoubVars.Parametr[1] as TVarDouble).Value,
                    (DoubVars.Parametr[0] as TVarDouble).Value)
                    ]);

// Result:=1/(1/Data[1]
//           +1/fFei.TAUsrh(Layer.Nd,
//                    (DoubVars.Parametr[1] as TVarDouble).Value,
//                    (DoubVars.Parametr[0] as TVarDouble).Value)
//           +1/fFeB.TAUsrh(Layer.Nd,
//                    (DoubVars.Parametr[1] as TVarDouble).Value,
//                    (DoubVars.Parametr[0] as TVarDouble).Value));
end;

procedure TFFTAU_Fei_FeB.NamesDefine;
begin
  SetNameCaption('TTAUFeiFeB',
      'Time dependence of minority'+
                'carrier life time');
end;

procedure TFFTAU_Fei_FeB.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Fe','tau_r']);
end;

{ class function TFFTAU_Fei_FeB.TauMatthiessenRule(TAUs: array of double): double;
begin

end;

TFFIsc_Fei_FeB }

procedure TFFIsc_Fei_FeB.AdditionalParamDetermination;
begin
//   fDParamArray.ParametrByName['Fei_eq'].Value:=
//              Fe_i_eq(PN_Diode.LayerP,
//                 fDParamArray.ParametrByName['Nfe'].Value, fT);
//  fDParamArray.OutputDataCoordinateByName('Fei_eq');

   fDParamArray.ParametrByName['t_ass'].Value:=
              t_assFeB(PN_Diode.LayerP.Nd*1e-6,
                          fT,fDParamArray.ParametrByName['Em'].Value);
  fDParamArray.OutputDataCoordinateByName('t_ass');

  inherited;
end;

function TFFIsc_Fei_FeB.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
  var L,{AlL,}tau:double;
begin
  fFei.Nd:=Fe_i_t(Point[cX],PN_Diode.LayerP,
                  Data[0], fT,Data[3]);
 fFeB.Nd:=Data[0]-fFei.Nd;

 tau:=TMaterial.TauMatthiessenRule([Data[1],
             fFei.TAUsrh(PN_Diode.LayerP.Nd,0,fT),
             fFeB.TAUsrh(PN_Diode.LayerP.Nd,0,fT),
             ftau_btb,ftau_auger]);
// tau:=1/(1/Data[1]
//           +1/fFei.TAUsrh(PN_Diode.LayerP.Nd,
//                    0,fT)
//           +1/fFeB.TAUsrh(PN_Diode.LayerP.Nd,
//                    0,fT)
//           +1/ftau_btb
//           +1/ftau_auger);
 L:=sqrt(tau*mukT);
// AlL:=fAbsorp*L;
// Result:=Data[2]*fNph*AlL/(1+AlL);
 Result:=Data[2]*fNph*Al_L(fAbsorp,L);
end;

procedure TFFIsc_Fei_FeB.NamesDefine;
begin
  SetNameCaption('IscFeiFeB',
      'Time dependence of short circuit current '+
      'for monochromatic llumination '+
                'if Fei -> FeB');
end;

procedure TFFIsc_Fei_FeB.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Nfe','tau_r','Wph','Em'],
                 ['t_ass'{,'Fei_eq'}]);
end;


{ TFFFei_FeB }

destructor TFFFei_FeB.Destroy;
begin
 FreeAndNil(fFei);
 FreeAndNil(fFeB);
 inherited;
end;

procedure TFFFei_FeB.TuningBeforeAccessorialDataCreate;
begin
 inherited TuningBeforeAccessorialDataCreate;
 fFei:=TDefect.Create(Fei);
 fFeB:=TDefect.Create(FeB_ac);
end;

{ TFFIsc_shablon }

procedure TFFIsc_shablon.AddDoubleVars;
begin
  inherited;
  DoubVars.Add(Self,'L_nm');
  DoubVars.ParametrByName['L_nm'].Description:='Illumination wave length (nm)';
  DoubVars.ParametrByName['L_nm'].Limits.SetLimits(0);
  DoubVars.Add(Self,'R_ph');
  DoubVars.ParametrByName['R_ph'].Description:='Photon reflection coefficient';
  DoubVars.ParametrByName['R_ph'].Limits.SetLimits(0,1);
  (DoubVars.ParametrByName['R_ph'] as TVarDouble).DefaultValue:=0;
  (DoubVars.ParametrByName['T'] as TVarDouble).ManualDetermOnly:=True;
end;

class function TFFIsc_shablon.Al_L(Abs, L: double): double;
  {Result=Absorbtion(Lambda,T)*L/(1+Absorbtion*L)}
begin
  Result:=Abs*L/(1+Abs*L);
end;

class function TFFIsc_shablon.Nph(Lambda, R: double): double;
begin
 Result:=(1-R)*Qelem*Lambda*1e-9
        /Hpl/Clight/2/Pi;
end;

procedure TFFIsc_shablon.TuningBeforeAccessorialDataCreate;
begin
 inherited TuningBeforeAccessorialDataCreate;
 fHasPicture:=False;
end;

procedure TFFIsc_shablon.VariousPreparationBeforeFitting;
begin
  inherited VariousPreparationBeforeFitting;
  fT:=(DoubVars.ParametrByName['T'] as TVarDouble).Value;
  fAbsorp:=Silicon.Absorption((DoubVars.ParametrByName['L_nm'] as TVarDouble).Value,
                              fT);
  fNph:=Nph((DoubVars.ParametrByName['L_nm'] as TVarDouble).Value,
           (DoubVars.ParametrByName['R_ph'] as TVarDouble).Value);
//  fNph:=(1-(DoubVars.ParametrByName['R_ph'] as TVarDouble).Value)
//        *Qelem*(DoubVars.ParametrByName['L_nm'] as TVarDouble).Value*1e-9
//        {*PN_Diode.Area}/Hpl/Clight/2/Pi;
  mukT:=PN_Diode.mu(fT)*Kb*fT;
  ftau_btb:=Silicon.TAUbtb(PN_Diode.LayerP.Nd,0,fT);
  ftau_auger:=Silicon.TAUager_p(PN_Diode.LayerP.Nd,fT);
end;

{ TFFIsc2_Fei_FeB }

function TFFIsc2_Fei_FeB.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
  var L,{AlL,}tau,Fe_i_e:double;
begin
 Fe_i_e:=Fe_i_eq(PN_Diode.LayerP,Data[0],T);
 fFei.Nd:=(Data[0]*Data[4]-Fe_i_e)*
           exp(-Point[cX]/Data[3])+Fe_i_e;
 fFeB.Nd:=Data[0]-fFei.Nd;
 tau:=TMaterial.TauMatthiessenRule([Data[1],
             fFei.TAUsrh(PN_Diode.LayerP.Nd,0,fT),
             fFeB.TAUsrh(PN_Diode.LayerP.Nd,0,fT),
             ftau_btb,ftau_auger]);
// tau:=1/(1/Data[1]
//           +1/fFei.TAUsrh(PN_Diode.LayerP.Nd,
//                    0,fT)
//           +1/fFeB.TAUsrh(PN_Diode.LayerP.Nd,
//                    0,fT)
//           +1/ftau_btb
//           +1/ftau_auger);
 L:=sqrt(tau*mukT);
// AlL:=fAbsorp*L;
// Result:=Data[2]*fNph*AlL/(1+AlL);
 Result:=Data[2]*fNph*Al_L(fAbsorp,L);
end;

procedure TFFIsc2_Fei_FeB.NamesDefine;
begin
  SetNameCaption('IscFeiFeB-2',
      'Time dependence of short circuit current '+
      'for monochromatic llumination '+
                'if Fei -> FeB');
end;

procedure TFFIsc2_Fei_FeB.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['Nfe','tau_r','Wph','t_asos','Kr']);
end;

{ TFFPlanc }

function TFFPlanc.FuncForFitness(Point: TPointDouble; Data: TArrSingle): double;
begin
 Result:=Planck(Point[cX],Data[0],Data[1]);
end;

procedure TFFPlanc.NamesDefine;
begin
  SetNameCaption('Planck',
      'Plancks radiation low');
end;

procedure TFFPlanc.ParamArrayCreate;
begin
 fDParamArray:=TDParamsHeuristic.Create(Self,
                 ['T','A']);
end;

class function TFFPlanc.Planck(lambda, T, A: double): double;
begin
  Result:=A*16*Clight*Hpl*Pi*Pi/Power(lambda*1e-9,5)
         /(exp(2*Pi*Hpl*Clight/(lambda*1e-9*Kb*Qelem*T))-1);
end;

procedure TFFPlanc.TuningBeforeAccessorialDataCreate;
begin
 inherited;
 fTemperatureIsRequired:=False;
 fHasPicture:=False;
end;

end.
