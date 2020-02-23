unit OApproxFunction;

interface

uses
  FitGradient, FitHeuristic, FitMaterial, OlegType, OlegMath;

type

TFFDiod=class (TFFHeuristic)
 protected
//  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
//  procedure AdditionalParamDetermination;override;
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
  private
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

implementation

uses
  FitIteration, FitVariable, Math, Dialogs, SysUtils;

{ TFFTDiod }

//procedure TFFDiod.FittingAgentCreate;
//begin
//
//end;

//procedure TFFDiod.AdditionalParamDetermination;
//begin
// fDParamArray.ParametrByName['Fb'].Value:=fSchottky.Fb((DoubVars.ParametrByName['T'] as TVarDouble).Value,
//                                                        fDParamArray.ParametrByName['Io'].Value);
// inherited AdditionalParamDetermination;
//end;

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

//procedure TFFDiod.TuningBeforeAccessorialDataCreate;
//begin
//  inherited;
//  FPictureName:='DiodFig';
//end;

{ TFFDiodTun }

function TFFDiodTun.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
begin
  Result:=Data[2]*(exp((Point[cX]-Point[cY]*Data[1])*Data[0]))
      +(Point[cX]-Point[cY]*Data[1])/Data[3];
// Result:=Full_IV(IV_DiodTunnel,Point[cX],[Data[0],
//                 Data[1],Data[2]],Data[3]);
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
//  FPictureName:='diodtunFig';
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
//  FPictureName:='TunRevFig';
  fTemperatureIsRequired:=False;
end;

{ TFFTunReversRs }

function TFFTunReversRs.FuncForFitness(Point: TPointDouble;
  Data: TArrSingle): double;
  var F:double;
begin
// Result:=Full_IV(IV_DiodTATrev,Point[cX],[Data[0],
//                 Data[3],Data[2],Data[1],
//                 fMaterialLayer.Meff,
//                 fMaterialLayer.Nd,
//                 fMaterialLayer.Material.Eps]);


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
//  FPictureName:='TunRevRsFig';
end;

end.
