unit FitGradient;

interface

uses
  FitSimple, FitVariable, OApproxNew, FitMaterial, OlegType,
  OlegMath, FitIteration, Forms, OlegFunction;

type

{$M+}
TFFVariabSet =class(TFFSimple)
  {для функцій, де для обчислень потрібні
  додаткові дійсні параметри}
 private
  fDoubVars:TVarDoubArray;
  procedure SetT(const Value: double);
  Function GetT():double;
 protected
  fTemperatureIsRequired:boolean;
  fVoltageIsRequired:boolean;
  fSchottky:TDSchottkyFit;
  fMaterialLayer:TMaterialLayerFit;
  fMaterial:TMaterialFit;
  fPNDiode:TD_PNFit;
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure AddDoubleVars;virtual;
  {додаються дійсні параметри, потрібні для
  обчислення функції}
  procedure AccessorialDataCreate;override;
  procedure AccessorialDataDestroy;override;
  function ParameterCreate:TFFParameter;override;
  procedure VariousPreparationBeforeFitting;override;
  procedure AutoDoubVarsDetermination;virtual;
  {визначення дійсних параметрів, які
  не задаються в ручному режимі}
  procedure AdditionalParamDetermination;override;
 public
  property T:double read GetT write SetT;
  property DoubVars:TVarDoubArray read fDoubVars;
 end;
{$M-}

TFFVariabSetSchottky=class (TFFVariabSet)
 published
  property Schottky:TDSchottkyFit read fSchottky;
end;


TFFExponent=class (TFFVariabSetSchottky)
 protected
  procedure ParamArrayCreate;override;
  function FittingCalculation:boolean;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
public
end; //TFFExponent=class (TFFVariabSetSchottky)


TFFIvanov=class (TFFVariabSetSchottky)
 protected
  procedure FittingDataFilling;override;
  function Deviation:double;override;
  function IvanovFun(X:double):TPointDouble;
  procedure ParamArrayCreate;override;
  function FittingCalculation:boolean;override;
  procedure NamesDefine;override;
public
end; //TFFExponent=class (TFFVariabSetSchottky)


TWindowIterationAbstract=class
  public
   Form:TForm;
   procedure Show;virtual;abstract;
   procedure UpDate;virtual;abstract;
   procedure Hide;virtual;abstract;
 end;

TFFIteration =class(TFFVariabSet)
  private
    function GetNrep: byte;
 protected
  fWindowAgent:TWindowIterationAbstract;
  fFittingAgent:TFittingAgent;
  procedure WindowAgentCreate;virtual;
  procedure FittingAgentCreate;virtual;abstract;
  function FittingCalculation:boolean;override;
  procedure VariousPreparationBeforeFitting;override;
  function ParameterCreate:TFFParameter;override;
  procedure AdditionalParamDetermination;override;
  procedure AccessorialDataCreate;override;
  procedure TuningAfterReadFromIni;override;
  published
 public
  property FittingAgent:TFittingAgent read fFittingAgent;
  property Nrep:byte read GetNrep; 
end;

TFFDiodLSM=class (TFFIteration)
 protected
  procedure FittingAgentCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
 published
  property Schottky:TDSchottkyFit read fSchottky;
end; // TFFDiodLSM=class (TFFIterationLSMSchottky)

TFFPhotoDiodLSM=class (TFFIteration)
 protected
  procedure FittingAgentCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
  procedure AdditionalParamDetermination;override;
end; // TFFTPhotoDiodLSM=class (TFFIterationLSM)


TFFDiodLam=class (TFFDiodLSM)
 protected
//  procedure TuningBeforeAccessorialDataCreate;override;
  procedure FittingAgentCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
end;

TFFPhotoDiodLam=class (TFFIteration)
 protected
  procedure FittingAgentCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
  procedure AdditionalParamDetermination;override;
end; // TFFTPhotoDiodLSM=class (TFFIterationLSM)

implementation

uses
  FitVariableShow, SysUtils, OlegMathShottky, FitIterationShow,
  HighResolutionTimer, TypInfo, Math;

{ TFFVariabSet }

procedure TFFVariabSet.AccessorialDataCreate;
begin
  fDoubVars:=TVarDoubArray.Create(Self,[]);
  if fTemperatureIsRequired then
      begin
       fDoubVars.Add(Self,'T');
       (fDoubVars.ParametrByName['T'] as TVarDouble).ManualDetermOnly:=False;
       fDoubVars.ParametrByName['T'].Limits.SetLimits(0.1);
       fDoubVars.ParametrByName['T'].Description:=
         'Temperature';
      end;
  if fVoltageIsRequired then
      begin
       fDoubVars.Add(Self,'V');
       (fDoubVars.ParametrByName['V'] as TVarDouble).ManualDetermOnly:=False;
       fDoubVars.ParametrByName['V'].Description:=
         'Voltage';
      end;
  AddDoubleVars;
  inherited AccessorialDataCreate;
end;

procedure TFFVariabSet.AccessorialDataDestroy;
begin
 FreeAndNil(fMaterial);
 FreeAndNil(fMaterialLayer);
 FreeAndNil(fSchottky);
 FreeAndNil(fPNDiode);
 fDoubVars.Free;
 inherited;
end;

procedure TFFVariabSet.AddDoubleVars;
begin

end;

procedure TFFVariabSet.AdditionalParamDetermination;
begin
  if (GetPropInfo(Self.ClassInfo, 'Schottky')<>nil)
   and ((fDParamArray.ParametrByName['Fb'])<>nil)
     then
   fDParamArray.ParametrByName['Fb'].Value:=fSchottky.Fb((DoubVars.ParametrByName['T'] as TVarDouble).Value,
                                            fDParamArray.ParametrByName['Io'].Value);
  fDParamArray.OutputDataCoordinateByName('Fb');
  inherited;
end;

procedure TFFVariabSet.AutoDoubVarsDetermination;
begin
 if (fTemperatureIsRequired)
    and (fDoubVars.ParametrByName['T'] as TVarDouble).AutoDeterm then
      (fDoubVars.ParametrByName['T'] as TVarDouble).Value:=fDataToFit.T;

 if (fVoltageIsRequired)
    and (fDoubVars.ParametrByName['V'] as TVarDouble).AutoDeterm then
     (fDoubVars.ParametrByName['V'] as TVarDouble).Value:=FileNameToVoltage(fDataToFit.name);
end;

function TFFVariabSet.GetT: double;
begin
 if Assigned(fDoubVars.ParametrByName['T'])
  then Result:=(fDoubVars.ParametrByName['T'] as TVarDouble).Value
  else Result:=ErResult;
end;

function TFFVariabSet.ParameterCreate: TFFParameter;
begin
  Result:=TDecVarNumberArrayParameter.Create(fDoubVars,
                         inherited ParameterCreate);

  if GetPropInfo(Self.ClassInfo, 'Schottky')<>nil then
   begin
    fSchottky:=TDSchottkyFit.Create(Self);
    Result:=TDecDSchottkyParameter.Create(fSchottky,Result);
   end;

  if GetPropInfo(Self.ClassInfo, 'Layer')<>nil then
   begin
    fMaterialLayer:=TMaterialLayerFit.Create(Self);
    Result:=TDecMaterialLayerParameter.Create(fMaterialLayer,Result);
   end;

  if GetPropInfo(Self.ClassInfo, 'Material')<>nil then
   begin
    fMaterial:=TMaterialFit.Create(Self);
    Result:=TDecMaterialParameter.Create(fMaterial,Result);
   end;

  if GetPropInfo(Self.ClassInfo, 'PN_Diode')<>nil then
   begin
    fPNDiode:=TD_PNFit.Create(Self);
    Result:=TDecD_PNParameter.Create(fPNDiode,Result);
   end;

end;

procedure TFFVariabSet.SetT(const Value: double);
begin
 if Assigned(fDoubVars.ParametrByName['T'])
    and (Value>0)
  then (fDoubVars.ParametrByName['T'] as TVarDouble).Value:=Value;
end;

procedure TFFVariabSet.TuningBeforeAccessorialDataCreate;
begin
 fTemperatureIsRequired:=True;
 fVoltageIsRequired:=False;
end;

procedure TFFVariabSet.VariousPreparationBeforeFitting;
begin
  AutoDoubVarsDetermination;
  inherited VariousPreparationBeforeFitting;
end;

{ TFFExponent }

function TFFExponent.FittingCalculation: boolean;
begin
 ftempVector.CopyFrom(fDataToFit);
 Result:=ftempVector.ExKalkFit(fSchottky,fDParamArray.OutputData,fDoubVars[0]);
end;

procedure TFFExponent.NamesDefine;
begin
   SetNameCaption('Exponent',
      'Linear least-squares fitting of semi-log plot');
end;

procedure TFFExponent.ParamArrayCreate;
begin
 fDParamArray:=TDParamArray.Create(Self,['Io','n','Fb']);
end;

function TFFExponent.RealFinalFunc(X: double): double;
begin
 Result:=fDParamArray.OutputData[0]
       *exp(X/(fDParamArray.OutputData[1]*Kb
               *(fDoubVars.ParametrByName['T'] as TVarDouble).Value));
end;

{ TFFIvanov }

function TFFIvanov.Deviation: double;
 var i:integer;
begin
  Result:=0;
  fDataToFit.ToFill(FittingData,IvanovFun);
  for I := 0 to fDataToFit.HighNumber
   do Result:=Result+SqrRelativeDifference(fDataToFit.Y[i],FittingData.Y[i]);
 Result:=sqrt(Result/fDataToFit.Count);
end;

function TFFIvanov.FittingCalculation: boolean;
begin
 ftempVector.CopyFrom(fDataToFit);
 Result:=ftempVector.IvanovAprox(fDParamArray.OutputData,fSchottky,fDoubVars[0]);
end;

procedure TFFIvanov.FittingDataFilling;
begin
 if fIntVars[0]<>0 then
     begin
     FittingData.T:=fDataToFit.T;
     FittingData.name:=fDataToFit.name;
     FittingData.Filling(IvanovFun,fDataToFit.MinX,fDataToFit.MaxX,fIntVars[0])
     end;
end;

function TFFIvanov.IvanovFun(X: double): TPointDouble;
begin
  Result[cX]:=X+fDParamArray.OutputData[1]
               *sqrt(2*Qelem*fSchottky.Semiconductor.Nd
                     *fSchottky.Semiconductor.Material.Eps/Eps0)
               *(sqrt(fDParamArray.OutputData[0])-sqrt(fDParamArray.OutputData[0]-X));
  Result[cY]:=fSchottky.I0(fDoubVars[0],fDParamArray.OutputData[0])*exp(X/Kb/fDoubVars[0]);
end;

procedure TFFIvanov.NamesDefine;
begin
   SetNameCaption('Ivanov',
      'I-V fitting for dielectric layer width d determination, Ivanov method');
end;

procedure TFFIvanov.ParamArrayCreate;
begin
 fDParamArray:=TDParamArray.Create(Self,['Fb','d/ep']);
end;


{ TFFIteration }

procedure TFFIteration.AccessorialDataCreate;
begin
  inherited;
  fIntVars.Add(Self,'Nrep');
  fIntVars.ParametrByName['Nrep'].Limits.SetLimits(1);
  fIntVars.ParametrByName['Nrep'].Description:=
        'Number of repetitions';
end;

procedure TFFIteration.AdditionalParamDetermination;
begin
 fDParamArray.OutputDataCoordinate;
 inherited AdditionalParamDetermination;
end;

function TFFIteration.FittingCalculation: boolean;
begin
 FittingAgentCreate;
 WindowAgentCreate;
 try
  fWindowAgent.Show;
  try
   Result:=False;
   fFittingAgent.StartAction;
   Timer.StartTimer;
   fFittingAgent.DataCoordination;
   fWindowAgent.UpDate;
   Application.ProcessMessages;

       repeat
        fFittingAgent.IterationAction;

        if fFittingAgent.IstimeToShow
           or(Timer.ReadTimer>15000) then
           begin
            fFittingAgent.DataCoordination;
            fWindowAgent.UpDate;
            Application.ProcessMessages;
            Timer.StartTimer;
           end;

       until (fFittingAgent.ToStop
            or(fFittingAgent.CurrentIteration>=(fDParamArray as TDParamsIteration).Nit)
            or not(fWindowAgent.Form.Visible));
   if fWindowAgent.Form.Visible then
    begin
      Result:=True;
      fFittingAgent.DataCoordination;
      fDParamArray.OutputDataCoordinate;
    end;

  finally
   fWindowAgent.Hide;
  end;
 finally
  fWindowAgent.Free;
  fFittingAgent.Free;
 end;

end;


function TFFIteration.GetNrep: byte;
begin
 if Assigned(fIntVars.ParametrByName['Nrep'])
   then Result:=(fIntVars.ParametrByName['Nrep'] as TVarInteger).Value
   else Result:=0;
end;

function TFFIteration.ParameterCreate: TFFParameter;
begin
  Result:=TDecParamsIteration.Create((fDParamArray as TDParamsIteration),
                         inherited ParameterCreate);
end;

procedure TFFIteration.TuningAfterReadFromIni;
begin
  inherited;
 (fIntVars.ParametrByName['Nrep'] as TVarInteger).Value:=max(1,
              (fIntVars.ParametrByName['Nrep'] as TVarInteger).Value);
end;

procedure TFFIteration.VariousPreparationBeforeFitting;
begin
  inherited VariousPreparationBeforeFitting;
  (fDParamArray as TDParamsIteration).UpDate;
end;

procedure TFFIteration.WindowAgentCreate;
begin
  fWindowAgent:=TWindowIterationShow.Create(Self);
end;

{ TFFDiodLSM }

procedure TFFDiodLSM.FittingAgentCreate;
begin
 fFittingAgent:=TFittingAgentLSM.Create((fDParamArray as TDParamsGradient),
                                        fDataToFit,ftempVector,
                                        (fDoubVars.ParametrByName['T'] as TVarDouble).Value);
end;

procedure TFFDiodLSM.NamesDefine;
begin
 SetNameCaption('DiodLSM',
      'One-diode model, gradient descent least-squares fitting');
end;

procedure TFFDiodLSM.ParamArrayCreate;
begin
  fDParamArray:=TDParamsGradient.Create(Self,
                 ['n','Rs','Io','Rsh'],
                 ['Fb']);
end;

function TFFDiodLSM.RealFinalFunc(X: double): double;
begin
 Result:=Full_IV(IV_Diod,X,[fDParamArray.OutputData[0]
                            *Kb*(fDoubVars.ParametrByName['T'] as TVarDouble).Value,
                            fDParamArray.OutputData[1],
                            fDParamArray.OutputData[2]],
                            fDParamArray.OutputData[3]);
end;

{ TFFTPhotoDiodLSM }

procedure TFFPhotoDiodLSM.AdditionalParamDetermination;
begin
 PVparameteres(fDataToFit,fDParamArray);
 inherited AdditionalParamDetermination;
end;

procedure TFFPhotoDiodLSM.FittingAgentCreate;
begin
 fFittingAgent:=TFittingAgentPhotoDiodLSM.Create((fDParamArray as TDParamsGradient),
                                        fDataToFit,ftempVector,
                                        (fDoubVars.ParametrByName['T'] as TVarDouble).Value);
end;

procedure TFFPhotoDiodLSM.NamesDefine;
begin
 SetNameCaption('PhotoDiodLSM',
      'One-diode model, illumination, gradient descent least-squares fitting');
end;

procedure TFFPhotoDiodLSM.ParamArrayCreate;
begin
  fDParamArray:=TDParamsGradient.Create(Self,
                 ['n','Rs','Io','Rsh','Iph'],
                 ['Voc','Isc','FF','Pm','Vm','Im']);
end;

function TFFPhotoDiodLSM.RealFinalFunc(X: double): double;
begin
 Result:=Full_IV(IV_Diod,X,[fDParamArray.OutputData[0]
                            *Kb*(fDoubVars.ParametrByName['T'] as TVarDouble).Value,
                            fDParamArray.OutputData[1],
                            fDParamArray.OutputData[2]],
                            fDParamArray.OutputData[3],
                            fDParamArray.OutputData[4]);
end;

{ TFFDiodLam }

procedure TFFDiodLam.FittingAgentCreate;
begin
 fFittingAgent:=TFittingAgentDiodLam.Create((fDParamArray as TDParamsGradient),
                                        fDataToFit,ftempVector,
                                        (fDoubVars.ParametrByName['T'] as TVarDouble).Value);
end;

procedure TFFDiodLam.NamesDefine;
begin
  SetNameCaption('DiodLam',
      'One-diode description by Lambert function, gradient descent least-squares fitting');
end;

function TFFDiodLam.RealFinalFunc(X: double): double;
begin
  Result:=LambertAprShot(X,fDParamArray.OutputData[0]*
                        Kb*(fDoubVars.ParametrByName['T'] as TVarDouble).Value,
                        fDParamArray.OutputData[1],
                        fDParamArray.OutputData[2],
                        fDParamArray.OutputData[3]);
end;

{ TFFPhotoDiodLam }

procedure TFFPhotoDiodLam.AdditionalParamDetermination;
begin
 PVparameteres(fDataToFit,fDParamArray);
 fDParamArray.SetValueByName('Io',(fDParamArray.ParametrByName['Isc'].Value
      +(fDParamArray.ParametrByName['Rs'].Value*fDParamArray.ParametrByName['Isc'].Value
        -fDParamArray.ParametrByName['Voc'].Value)/fDParamArray.ParametrByName['Rsh'].Value)
        *exp(-fDParamArray.ParametrByName['Voc'].Value/fDParamArray.ParametrByName['n'].Value
        /Kb/(fDoubVars.ParametrByName['T'] as TVarDouble).Value)
        /(1-exp((fDParamArray.ParametrByName['Rs'].Value
          *fDParamArray.ParametrByName['Isc'].Value-fDParamArray.ParametrByName['Voc'].Value)
          /fDParamArray.ParametrByName['n'].Value/Kb/(fDoubVars.ParametrByName['T'] as TVarDouble).Value)));

 fDParamArray.SetValueByName('Iph',fDParamArray.ParametrByName['Io'].Value
       *(exp(fDParamArray.ParametrByName['Voc'].Value/fDParamArray.ParametrByName['n'].Value
       /Kb/(fDoubVars.ParametrByName['T'] as TVarDouble).Value)-1)
       +fDParamArray.ParametrByName['Voc'].Value/fDParamArray.ParametrByName['Rsh'].Value);
 inherited AdditionalParamDetermination;
end;

procedure TFFPhotoDiodLam.FittingAgentCreate;
begin
 fFittingAgent:=TFittingAgentPhotoDiodLam.Create((fDParamArray as TDParamsGradient),
                                        fDataToFit,ftempVector,
                                        (fDoubVars.ParametrByName['T'] as TVarDouble).Value);
end;

procedure TFFPhotoDiodLam.NamesDefine;
begin
 SetNameCaption('PhotoDiodLam',
      'One-diode description by Lambert function, illumination, gradient descent least-squares fitting');
end;

procedure TFFPhotoDiodLam.ParamArrayCreate;
begin
  fDParamArray:=TDParamsGradient.Create(Self,
                 ['n','Rs','Rsh'],
                 ['Io','Iph','Voc','Isc','FF','Pm','Vm','Im']);
end;

function TFFPhotoDiodLam.RealFinalFunc(X: double): double;
begin
  Result:=LambertLightAprShot(X,fDParamArray.OutputData[0]
                          *Kb*(fDoubVars.ParametrByName['T'] as TVarDouble).Value,
                          fDParamArray.OutputData[1],
                          fDParamArray.OutputData[3],
                          fDParamArray.OutputData[2],
                          fDParamArray.OutputData[4]);
end;

end.
