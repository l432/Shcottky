unit OApprox3;

interface

uses
  FitSimple, FitVariable, OApproxNew, FitMaterial, OlegType,
  OlegMath, FitIteration, Forms, OlegFunction;

type
TFFVariabSet =class(TFFSimple)
  {��� �������, �� ��� ��������� �������
  �������� ����� ���������}
 private
  fDoubVars:TVarDoubArray;
  fTemperatureIsRequired:boolean;
  fVoltageIsRequired:boolean;
 protected
  procedure TuningBeforeAccessorialDataCreate;override;
  procedure AddDoubleVars;virtual;
  {��������� ����� ���������, ������� ���
  ���������� �������}
  procedure AccessorialDataCreate;override;
  procedure AccessorialDataDestroy;override;
  function ParameterCreate:TFFParameter;override;
  procedure VariousPreparationBeforeFitting;override;
  procedure AutoDoubVarsDetermination;virtual;
  {���������� ������ ���������, ��
  �� ��������� � ������� �����}
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
  function FittingCalculation:boolean;override;
  procedure VariousPreparationBeforeFitting;override;
 public
  property FittingAgent:TFittingAgent read fFittingAgent;
end;


TFFIterationLSM =class(TFFIteration)
 private
//  procedure FittingAgentCreate;virtual;abstract;
 protected
  function ParameterCreate:TFFParameter;override;
end;

//TFFIterationLSMSchottky=class (TFFIterationLSM)
//{��� �������, �� ��������������
//���������� � ������� ������}
// private
//  fSchottky:TDSchottkyFit;
// protected
//  procedure AccessorialDataCreate;override;
//  procedure AccessorialDataDestroy;override;
//  function ParameterCreate:TFFParameter;override;
//  procedure AdditionalParamDetermination;override;
//end;


//TFFDiodLSM=class (TFFIterationLSMSchottky)
TFFDiodLSM=class (TFFIterationLSM)
 private
  fSchottky:TDSchottkyFit;
  procedure FittingAgentCreate;override;
 protected
  procedure AccessorialDataCreate;override;
  procedure AccessorialDataDestroy;override;
  function ParameterCreate:TFFParameter;override;
//  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
  procedure AdditionalParamDetermination;override;
end; // TFFDiodLSM=class (TFFIterationLSMSchottky)

TFFPhotoDiodLSM=class (TFFIterationLSM)
 private
  procedure FittingAgentCreate;override;
 protected
//  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
  procedure AdditionalParamDetermination;override;
end; // TFFTPhotoDiodLSM=class (TFFIterationLSM)


TFFDiodLam=class (TFFDiodLSM)
 private
  procedure FittingAgentCreate;override;
 protected
//  procedure TuningBeforeAccessorialDataCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
end;

TFFPhotoDiodLam=class (TFFIterationLSM)
 private
  procedure FittingAgentCreate;override;
 protected
//  procedure TuningBeforeAccessorialDataCreate;override;
  procedure ParamArrayCreate;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
  procedure AdditionalParamDetermination;override;
end; // TFFTPhotoDiodLSM=class (TFFIterationLSM)

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
   Result:=False;
//   fFittingAgent.IsDone:=False;
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
            or(fFittingAgent.CurrentIteration>=(fDParamArray as TDParamsGradient).Nit)
            or not(fWindowAgent.Form.Visible));
   if fWindowAgent.Form.Visible then
    begin
      Result:=True;
//      fFittingAgent.IsDone:=True;
      fDParamArray.OutputDataCoordinate;
    end;
//   fFittingAgent.EndAction;

  finally
   fWindowAgent.Hide;
  end;
 finally
  fWindowAgent.Free;
//  Result:=fFittingAgent.IsDone;
  fFittingAgent.Free;
 end;

end;





procedure TFFIteration.VariousPreparationBeforeFitting;
begin
  inherited VariousPreparationBeforeFitting;
  (fDParamArray as TDParamsGradient).UpDate;
end;

procedure TFFIteration.WindowAgentCreate;
begin
  fWindowAgent:=TWindowIterationShow.Create(Self);
end;

{ TFFDiodLSM }

procedure TFFDiodLSM.AccessorialDataCreate;
begin
  inherited;
  fSchottky:=TDSchottkyFit.Create(Self);
end;

procedure TFFDiodLSM.AccessorialDataDestroy;
begin
  fSchottky.Free;
  inherited;
end;

procedure TFFDiodLSM.AdditionalParamDetermination;
begin
 fDParamArray.ParametrByName['Fb'].Value:=fSchottky.Fb((fDoubVars.ParametrByName['T'] as TVarDouble).Value,
                                                        fDParamArray.ParametrByName['Io'].Value);
 inherited AdditionalParamDetermination;
end;

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

function TFFDiodLSM.ParameterCreate: TFFParameter;
begin
   Result:=TDecDSchottkyParameter.Create(fSchottky,
                         inherited ParameterCreate);
end;

function TFFDiodLSM.RealFinalFunc(X: double): double;
begin
 Result:=Full_IV(IV_Diod,X,[fDParamArray.OutputData[0]
                            *Kb*(fDoubVars.ParametrByName['T'] as TVarDouble).Value,
                            fDParamArray.OutputData[1],
                            fDParamArray.OutputData[2]],
                            fDParamArray.OutputData[3]);
end;

//procedure TFFDiodLSM.TuningBeforeAccessorialDataCreate;
//begin
//  inherited;
//  FPictureName:='DiodLSM'+'Fig';
//end;

{ TFFIterationLSM }

function TFFIterationLSM.ParameterCreate: TFFParameter;
begin
  Result:=TDecParamsIteration.Create((fDParamArray as TDParamsGradient),
                         inherited ParameterCreate);
end;

//{ TFFIterationLSMSchottky }
//
//procedure TFFIterationLSMSchottky.AccessorialDataCreate;
//begin
//  inherited;
//  fSchottky:=TDSchottkyFit.Create(Self);
//end;
//
//procedure TFFIterationLSMSchottky.AccessorialDataDestroy;
//begin
//  fSchottky.Free;
//  inherited;
//end;
//
//procedure TFFIterationLSMSchottky.AdditionalParamDetermination;
//begin
// fDParamArray.ParametrByName['Fb'].Value:=fSchottky.Fb((fDoubVars.ParametrByName['T'] as TVarDouble).Value,
//                                                        fDParamArray.ParametrByName['Io'].Value);
// inherited AdditionalParamDetermination;
//end;
//
//function TFFIterationLSMSchottky.ParameterCreate: TFFParameter;
//begin
//   Result:=TDecDSchottkyParameter.Create(fSchottky,
//                         inherited ParameterCreate);
//end;

{ TFFTPhotoDiodLSM }

procedure TFFPhotoDiodLSM.AdditionalParamDetermination;
begin
 PVparameteres(fDataToFit,fDParamArray);
 inherited;
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

//procedure TFFPhotoDiodLSM.TuningBeforeAccessorialDataCreate;
//begin
//  inherited;
//  FPictureName:='PhotoDiodLSMFig';
//end;

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

//procedure TFFDiodLam.TuningBeforeAccessorialDataCreate;
//begin
//  inherited;
//  FPictureName:='DiodLamFig';
//end;

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
 fDParamArray.OutputDataCoordinate;
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

//procedure TFFPhotoDiodLam.TuningBeforeAccessorialDataCreate;
//begin
//  inherited;
//  FPictureName:='PhotoDiodLamFig';
//end;

end.