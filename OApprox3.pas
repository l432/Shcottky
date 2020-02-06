unit OApprox3;

interface

uses
  FitSimple, FitVariable, OApproxNew, FitMaterial, OlegType,
  OlegMath, FitIteration, Forms;

type
TFFVariabSet =class(TFFSimple)
  {для функцій, де для обчислень потрібні
  додаткові дійсні параметри}
 private
  fDoubVars:TVarDoubArray;
  fTemperatureIsRequired:boolean;
  fVoltageIsRequired:boolean;
 protected
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
 public
  property DoubVars:TVarDoubArray read fDoubVars;
 end;

TFFVariabSetSchottky=class (TFFVariabSet)
 private
  fSchottky:TDSchottkyFit;
 protected
  procedure AccessorialDataCreate;override;
  procedure AccessorialDataDestroy;override;
  function ParameterCreate:TFFParameter;override;

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
  fFittingAgent:TFittingAgent;
  fWindowAgent:TWindowIterationAbstract;
  procedure FittingAgentCreate;virtual;abstract;
  procedure WindowAgentCreate;
 protected
  function ParameterCreate:TFFParameter;override;
  function FittingCalculation:boolean;override;
  procedure VariousPreparationBeforeFitting;override;
 public
  property FittingAgent:TFittingAgent read fFittingAgent;
end;


TFFDiodLSM=class (TFFIteration)
 private
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
end; // TFFDiodLSM=class (TFFIteration)

implementation

uses
  FitVariableShow, SysUtils, OlegMathShottky, FitIterationShow, 
  HighResolutionTimer;

{ TFFVariabSet }

procedure TFFVariabSet.AccessorialDataCreate;
begin
//  inherited;
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
  inherited;
end;

procedure TFFVariabSet.AccessorialDataDestroy;
begin
 fDoubVars.Free;
 inherited;
end;

procedure TFFVariabSet.AddDoubleVars;
begin

end;

procedure TFFVariabSet.AutoDoubVarsDetermination;
begin
 if (fTemperatureIsRequired)
    and (fDoubVars.ParametrByName['T'] as TVarDouble).AutoDeterm then
      (fDoubVars.ParametrByName['T'] as TVarDouble).Value:=fDataToFit.T;

 if (fVoltageIsRequired)
    and (fDoubVars.ParametrByName['V'] as TVarDouble).AutoDeterm then
     begin
      try
       (fDoubVars.ParametrByName['V'] as TVarDouble).Value:=
       StrToFloat(copy(fDataToFit.name,1,length(fDataToFit.name)-4))/10;
      except
       (fDoubVars.ParametrByName['V'] as TVarDouble).Value:=ErResult;
      end;
     end;
end;

function TFFVariabSet.ParameterCreate: TFFParameter;
begin
  Result:=TDecVarNumberArrayParameter.Create(fDoubVars,
                         inherited ParameterCreate);
end;

procedure TFFVariabSet.TuningBeforeAccessorialDataCreate;
begin
 fTemperatureIsRequired:=True;
 fVoltageIsRequired:=False;
end;

procedure TFFVariabSet.VariousPreparationBeforeFitting;
begin
  AutoDoubVarsDetermination;
  inherited;
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

{ TFFVariabSetSchottky }

procedure TFFVariabSetSchottky.AccessorialDataCreate;
begin
  inherited;
  fSchottky:=TDSchottkyFit.Create(Self);
end;

procedure TFFVariabSetSchottky.AccessorialDataDestroy;
begin
  fSchottky.Free;
  inherited;
end;

function TFFVariabSetSchottky.ParameterCreate: TFFParameter;
begin
  Result:=TDecDSchottkyParameter.Create(fSchottky,
                         inherited ParameterCreate);
end;

{ TFFIvanov }

function TFFIvanov.Deviation: double;
 var i:integer;
begin
  Result:=0;
  fDataToFit.ToFill(FittingData,IvanovFun);
  for I := 0 to fDataToFit.HighNumber
   do Result:=Result+SqrRelativeDifference(fDataToFit.Y[i],FittingData.Y[i]);
 Result:=sqrt(Result)/fDataToFit.Count;
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
// var Vd,x0:double;
begin
//  x0:=X;
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

//procedure TFFIteration.FittingAgentCreate;
//begin
// fFittingAgent:=TFittingAgent.Create;
//end;

function TFFIteration.FittingCalculation: boolean;
begin
// Result:=False;
 FittingAgentCreate;
 WindowAgentCreate;
 try
  fWindowAgent.Show;
  try
   fFittingAgent.IsDone:=False;
   fFittingAgent.StartAction;
       repeat
        fFittingAgent.IterationAction;
        Timer.StartTimer;

        if ((fFittingAgent.CurrentIteration mod 25)=0)
           or(Timer.ReadTimer>15000) then
           begin
            fWindowAgent.UpDate;
            Application.ProcessMessages;
            Timer.StartTimer;
         end;

       until (fFittingAgent.ToStop
            or(fFittingAgent.CurrentIteration>=(fDParamArray as TDParamsIteration).Nit)
            or not(fWindowAgent.Form.Visible));
   fFittingAgent.EndAction;

  finally
   fWindowAgent.Hide;
  end;
 finally
  fWindowAgent.Free;
  Result:=fFittingAgent.IsDone;
  fFittingAgent.Free;
 end;

end;

function TFFIteration.ParameterCreate: TFFParameter;
begin
  Result:=TDecParamsIteration.Create((fDParamArray as TDParamsIteration),
                         inherited ParameterCreate);
end;



procedure TFFIteration.VariousPreparationBeforeFitting;
begin
  (fDParamArray as TDParamsIteration).UpDate;
  inherited;
end;

procedure TFFIteration.WindowAgentCreate;
begin
  fWindowAgent:=TWindowIterationShow.Create(Self);
end;

{ TFFDiodLSM }

procedure TFFDiodLSM.NamesDefine;
begin
 SetNameCaption('DiodLSMa',
      'Diod function, least-squares fitting');
end;

procedure TFFDiodLSM.ParamArrayCreate;
begin
  fDParamArray:=TDParamsIteration.Create(Self,['n','Rs','Io','Rsh']);
end;

procedure TFFDiodLSM.TuningBeforeAccessorialDataCreate;
begin
  inherited;
  FPictureName:='DiodLSM'+'Fig';
end;

end.
