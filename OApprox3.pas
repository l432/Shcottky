unit OApprox3;

interface

uses
  FitSimple, FitVariable, OApproxNew;

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
 end;

implementation

uses
  FitVariableShow, SysUtils, OlegType;

{ TFFVariabSet }

procedure TFFVariabSet.AccessorialDataCreate;
begin
  inherited;
  fDoubVars:=TVarDoubArray.Create(Self,[]);
  if fTemperatureIsRequired then
      begin
       fDoubVars.Add(Self,'T');
       fDoubVars.ParametrByName['T'].Limits.SetLimits(0.1);
       fDoubVars.ParametrByName['T'].Description:=
         'Temperature';
      end;
  if fVoltageIsRequired then
      begin
       fDoubVars.Add(Self,'V');
       fDoubVars.ParametrByName['V'].Description:=
         'Voltage';
      end;
  AddDoubleVars;
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

end.
