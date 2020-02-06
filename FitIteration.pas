unit FitIteration;

interface

uses
  OlegTypePart2, OApproxNew, OlegType, Classes, FitVariable, IniFiles, 
  OlegVector, OlegVectorManipulation;

type

TFFDParam=class(TNamedAndDescripObject)
{базовий клас для параметрів, які
визначаються в результаті апроксимації}
 private
  fValue:Double;
  function GetIsConstant: boolean;virtual;
  procedure SetIsConstant(const Value: boolean);virtual;
 public
  property Value:Double read fValue write fValue;
  property IsConstant:boolean read GetIsConstant write SetIsConstant;
end;


TDParamArray=class
  private
   fFF:TFitFunctionNew;
//   fParams:array of TFFDParam;
   fMainParamHighIndex:integer;
   {індекс останного параметра, який безпосередньо визначається
   з апроксимації (MainParam)}
   procedure MainParamCreate(const MainParamNames: array of string);virtual;
   procedure AddParamCreate(const AddParamNames: array of string);
   procedure LastParamCreate;
   function GetParameterByName(str:string):TFFDParam;
  public
   fParams:array of TFFDParam;
   OutputData:TArrSingle;
   property ParametrByName[str:string]:TFFDParam read GetParameterByName;
   property MainParamHighIndex:integer read fMainParamHighIndex;
   constructor Create(FF:TFitFunctionNew;
                      const MainParamNames: array of string);overload;
   constructor Create(FF:TFitFunctionNew;
                      const MainParamNames: array of string;
                     const AddParamNames: array of string);overload;
   destructor Destroy;override;
   procedure OutputDataCoordinate;
   Procedure DataToStrings(OutStrings:TStrings);
end;

TConstParDetermination=class(TNamedObject)
{клас для обчислення значень
параметрів, які вважаються постійними
при ітераційній апроксимації}
 private
  function GetValue:Double;
  function GetArgument:Double;
 public
  fVarArray:TVarDoubArray;
  Coefficients:TArrSingle;
  CoefNames:array of string;
  fIndex:integer;
  fIsNotReverse:boolean;
  constructor Create(Nm:string;VarArray:TVarDoubArray);
  property Value:double read GetValue;
  procedure WriteToIniFile(ConfigFile:TIniFile;
                           const Section:string);
  procedure ReadFromIniFile(ConfigFile:TIniFile;
                           const Section:string);
end;


TFFParamIteration=class(TFFDParam)
{параметри, які визначаються в результаті
ітераційного процесу}
 private
//  fValue:Double;
  fIsConstant:boolean;
  function GetIsConstant: boolean;override;
  procedure SetIsConstant(const Value: boolean);override;
 public
  fCPDeter:TConstParDetermination;
  property IsConstant:boolean read GetIsConstant write SetIsConstant;
//  property Value:Double read fValue write fValue;
  procedure UpDate;
  constructor Create(Nm:string;VarArray:TVarDoubArray);
  destructor Destroy;override;
  procedure WriteToIniFile(ConfigFile:TIniFile;
                           const Section:string);
  procedure ReadFromIniFile(ConfigFile:TIniFile;
                           const Section:string);
end;

TDParamsIteration=class(TDParamArray)
  private
   fNit:integer;//кількість ітерацій
   fAccurancy:double;
  {величина, пов'язана з критерієм
   припинення ітераційного процесу}
   procedure MainParamCreate(const MainParamNames: array of string);override;
  public
   property Nit:integer read fNit write fNit;
   property Accurancy:double read fAccurancy write fAccurancy;
   procedure WriteToIniFile;
   procedure ReadFromIniFile;
   function IsReadyToFitDetermination:boolean;
   procedure UpDate;
end;


TFittingAgent=class
{той, що вміє проводити ітераційний процес}
 private
  fDescription:string;
  fCurrentIteration:integer;
  fToStop:boolean;
  fIsDone:boolean;
 public
  property Description:string read fDescription;
  property CurrentIteration:integer read fCurrentIteration;
  property IsDone:boolean read fIsDone write fIsDone;
  property ToStop:boolean read fToStop;
  procedure StartAction;virtual;
  procedure IterationAction;virtual;abstract;
  procedure EndAction;virtual;abstract;
end;

TFittingAgentLSM=class(TFittingAgent)
 private
  fPIteration:TDParamsIteration;
  fDataToFit:TVectorTransform;
  ftempVector: TVectorTransform;
  fDoubVars:TVarDoubArray;
  X2,derivX:TArrSingle;
  Procedure InitialApproximation;
  procedure RshInitDetermine;//Function IA_Determine3(Vector1,Vector2:TVector):double;
  Procedure nRsIoInitDetermine;//IA_Determine012
  procedure SetParameterValue(ParametrName:string;Value:double);
 public
  constructor Create(PIteration:TDParamsIteration;DataToFit,tempVector: TVectorTransform;
                     DoubVars:TVarDoubArray);
  procedure StartAction;override;
//  procedure IterationAction;override;
//  procedure EndAction;override;
end;



implementation

uses
  SysUtils, OlegFunction, OlegMath, OApprox3;

{ TDParamArray }

constructor TDParamArray.Create(FF:TFitFunctionNew;
                               const MainParamNames: array of string);
begin
  inherited Create;
  fFF:=FF;
  MainParamCreate(MainParamNames);
  LastParamCreate;
end;

procedure TDParamArray.AddParamCreate(const AddParamNames: array of string);
 var i: Integer;
begin
  SetLength(fParams, fMainParamHighIndex + High(AddParamNames)+2);
  for I := 0 to High(AddParamNames)+1 do
    fParams[i+fMainParamHighIndex] := TFFDParam.Create(AddParamNames[i]);
end;

constructor TDParamArray.Create(FF:TFitFunctionNew;
                               const MainParamNames: array of string;
                              const AddParamNames: array of string);
begin
  inherited Create;
  fFF:=FF;
  MainParamCreate(MainParamNames);
  AddParamCreate(AddParamNames);
  LastParamCreate;
end;

procedure TDParamArray.DataToStrings(OutStrings: TStrings);
 var i:integer;
begin
 for I := 0 to High(fParams) do
  OutStrings.Add(fParams[i].Name+'='+FloatToStrF(OutputData[i],ffExponent,fFF.DigitNumber,0));
end;

destructor TDParamArray.Destroy;
 var I:integer;
begin
  for I := 0 to High(fParams) do fParams[i].Free;
  inherited;
end;

function TDParamArray.GetParameterByName(str: string): TFFDParam;
 var I:integer;
begin
  for I := 0 to High(fParams) do
    if fParams[i].Name=str then
      begin
        Result:=fParams[i];
        Exit;
      end;
  Result:=nil;
end;

procedure TDParamArray.LastParamCreate;
begin
 SetLength(fParams,High(fParams)+2);
 fParams[High(fParams)]:=TFFDParam.Create('dev');
 SetLength(OutputData,High(fParams)+1);
end;

procedure TDParamArray.MainParamCreate(const MainParamNames: array of string);
var
  i: Integer;
begin
  fMainParamHighIndex := High(MainParamNames);
  SetLength(fParams, fMainParamHighIndex + 1);
  for I := 0 to fMainParamHighIndex do
    fParams[i] := TFFDParam.Create(MainParamNames[i]);
end;

procedure TDParamArray.OutputDataCoordinate;
 var I:integer;
begin
  for I := 0 to High(fParams)
     do OutputData[i]:=fParams[i].Value;
end;

{ TConstParDetermination }

constructor TConstParDetermination.Create(Nm:string;VarArray:TVarDoubArray);
 var ch:char;
     i:integer;
begin
 inherited Create(Nm);
 fVarArray:=VarArray;
 InitArrSingle(Coefficients,3,0);
 SetLength(CoefNames,3);
 ch:='A';
 for I := 0 to High(CoefNames) do
  begin
   CoefNames[i]:=ch;
   Inc(ch);
  end;

 fIndex:=-1;
 fIsNotReverse:=True;
end;

function TConstParDetermination.GetArgument: Double;
begin
 try
  Result:=fVarArray[fIndex];
  if Result=ErResult
    then Raise Exception.Create('Fault!!!!');
  if not(fIsNotReverse) then  Result:=1/Result;
 except
  Result:=0;
 end;
end;

function TConstParDetermination.GetValue: Double;
begin
 Result:= NPolinom(GetArgument,Coefficients);
end;

procedure TConstParDetermination.ReadFromIniFile(ConfigFile: TIniFile;
                               const Section: string);
  var i:integer;
begin
 for I := 0 to High(Coefficients) do
  Coefficients[i]:=
    ConfigFile.ReadFloat(Section,Name+CoefNames[i],0);
// Coefficients[1]:=ConfigFile.ReadFloat(Section,Prefix+'B',0);
// Coefficients[2]:=ConfigFile.ReadFloat(Section,Prefix+'C',0);
 fIndex:=ConfigFile.ReadInteger(Section,Name+'_tt',-1);
 fIsNotReverse:=ConfigFile.ReadBool(Section,Name+'_Reverse',False);
end;

procedure TConstParDetermination.WriteToIniFile(ConfigFile: TIniFile;
                               const Section: string);
 var i:integer;
begin
 for I := 0 to High(Coefficients) do
   WriteIniDef(ConfigFile,Section,Name+CoefNames[i],Coefficients[i],0);
// WriteIniDef(ConfigFile,Section,Prefix+'B',Coefficients[1],0);
// WriteIniDef(ConfigFile,Section,Prefix+'C',Coefficients[2],0);
 WriteIniDef(ConfigFile,Section,Name+'_tt',fIndex,-1);
 WriteIniDef(ConfigFile,Section,Name+'_Reverse',fIsNotReverse);
end;


{ TFFParamIteration }

constructor TFFParamIteration.Create(Nm: string; VarArray: TVarDoubArray);
begin
 inherited Create(Nm);
 IsConstant:=False;
 fCPDeter:=TConstParDetermination.Create(Nm,VarArray);
end;

destructor TFFParamIteration.Destroy;
begin
 fCPDeter.Free;
 inherited;
end;

function TFFParamIteration.GetIsConstant: boolean;
begin
 Result:=fIsConstant;
end;

procedure TFFParamIteration.ReadFromIniFile(ConfigFile: TIniFile;
  const Section: string);
begin
  fCPDeter.ReadFromIniFile(ConfigFile,Section);
  IsConstant:=ConfigFile.ReadBool(Section,Name+'_IsConstant',False);
end;

procedure TFFParamIteration.SetIsConstant(const Value: boolean);
begin
  fIsConstant:=Value;
end;

procedure TFFParamIteration.UpDate;
begin
 if IsConstant then Value:=fCPDeter.Value;
end;

procedure TFFParamIteration.WriteToIniFile(ConfigFile: TIniFile;
  const Section: string);
begin
  fCPDeter.WriteToIniFile(ConfigFile,Section);
  WriteIniDef(ConfigFile,Section,Name+'_IsConstant',IsConstant);
end;

{ TDParamIterationArray }

function TDParamsIteration.IsReadyToFitDetermination: boolean;
  var I:integer;
begin
 Result:=True;
 Result:=Result and (fAccurancy<>ErResult)
         and (fNit<>ErResult) and (fNit>0);
 for I := 0 to fMainParamHighIndex do
  if fParams[i].IsConstant
    then Result:=Result and (fParams[i].Value<>ErResult);
end;

procedure TDParamsIteration.MainParamCreate(
         const MainParamNames: array of string);
 var i: Integer;
begin
  fMainParamHighIndex := High(MainParamNames);
  SetLength(fParams, fMainParamHighIndex + 1);
  for I := 0 to fMainParamHighIndex do
    fParams[i] := TFFParamIteration.Create(MainParamNames[i],
                               (fFF as TFFVariabSet).DoubVars);

end;

procedure TDParamsIteration.ReadFromIniFile;
 var I:integer;
begin
  for I := 0 to fMainParamHighIndex
    do (fParams[i] as TFFParamIteration).ReadFromIniFile(fFF.ConfigFile,fFF.Name);
  fAccurancy:=fFF.ConfigFile.ReadFloat(fFF.Name,'Accurancy',1e-8);
  fNit:=fFF.ConfigFile.ReadInteger(fFF.Name,'Nit',1000);
end;

procedure TDParamsIteration.UpDate;
 var i:integer;
begin
 for I := 0 to MainParamHighIndex do
    (fParams[i] as TFFParamIteration).UpDate;
end;

procedure TDParamsIteration.WriteToIniFile;
 var I:integer;
begin
  for I := 0 to fMainParamHighIndex
    do (fParams[i] as TFFParamIteration).WriteToIniFile(fFF.ConfigFile,fFF.Name);
  WriteIniDef(fFF.ConfigFile,fFF.Name,'Accurancy',fAccurancy);
  WriteIniDef(fFF.ConfigFile,fFF.Name,'Nit',fNit);
end;

{ TFittingAgent }

procedure TFittingAgent.StartAction;
begin
 fToStop:=false;
 fCurrentIteration:=0;
end;

{ TFittingAgentLSM }

constructor TFittingAgentLSM.Create(PIteration: TDParamsIteration;
                                    DataToFit,tempVector: TVectorTransform;
                                    DoubVars:TVarDoubArray);
begin
 inherited Create;
 fPIteration:=PIteration;
 fDataToFit:=DataToFit;
 ftempVector:=tempVector;
 fDoubVars:=DoubVars;
 fDescription:='Coordinate gradient descent';
end;

procedure TFittingAgentLSM.InitialApproximation;
 var i:integer;
begin
 RshInitDetermine;

 ftempVector.SetLenVector(fDataToFit.Count);
 for I := 0 to ftempVector.HighNumber do
    ftempVector.Y[i]:=(fDataToFit.Y[i]-fDataToFit.X[i]
                /fPIteration.ParametrByName['Rsh'].Value);
  {в temp - ВАХ з врахуванням Rsh0}
  nRsIoInitDetermine;
end;

procedure TFittingAgentLSM.nRsIoInitDetermine;
 var temp2:TVectorTransform;
      i:integer;
     OutputData:TArrSingle;
begin
  temp2:=TVectorTransform.Create;
  ftempVector.PositiveY(temp2);
  for i:=0 to temp2.HighNumber do
       temp2.Y[i]:=ln(temp2.Y[i]);

  temp2.CopyTo(ftempVector);
  if ftempVector.HighNumber>6
    then ftempVector.DeleteNfirst(3);
  ftempVector.LinAprox(OutputData);

  OutputData[0]:=exp(OutputData[0]);
  OutputData[1]:=1/(Kb*fDoubVars[0]*OutputData[1]);

  {I00 та n0 в результаті лінійної апроксимації залежності
  ln(I) від напруги, береться ВАХ з врахуванням Rsh0}
  SetParameterValue('Io',OutputData[0]);
  SetParameterValue('n',OutputData[1]);

  for i:=0 to temp2.HighNumber do
     begin
      temp2.Y[i]:=exp(temp2.Y[i]);
     end;
 {в temp2 - частина ВАХ з врахуванням Rsh0, для якої
  значення струму додатні}

   temp2.Derivate(ftempVector);
   for i:=0 to ftempVector.HighNumber do
     begin
     ftempVector.X[i]:=1/temp2.Y[i];
     ftempVector.Y[i]:=1/ftempVector.Y[i];
     end;
  {в ftempVector - залежність dV/dI від 1/І}

  if ftempVector.Count>5 then ftempVector.DeleteNfirst(ftempVector.Count-5);
  ftempVector.LinAprox(OutputData);
  SetParameterValue('Rs',OutputData[0]);
  {Rs0 - як вільних член лінійної апроксимації
  щонайбільше п'яти останніх точок залежності dV/dI від 1/І;
  dV/dI= (nKbT)/(qI)+Rs}
  temp2.Free;
end;

procedure TFittingAgentLSM.RshInitDetermine;
begin
 if fPIteration.ParametrByName['Rsh'].IsConstant then Exit;
 fDataToFit.Derivate(ftempVector);
   {фактично, в ftempVector залеженість оберненого опору від напруги}
 if ftempVector.Count<3 then Raise Exception.Create('Fault in RshInitDetermine');
  
 fPIteration.ParametrByName['Rsh'].Value:=(ftempVector.X[1]/ftempVector.y[2]
                                           -ftempVector.X[2]/ftempVector.y[1])
                                           /(ftempVector.X[1]-ftempVector.X[2]);
  {Rsh0 - по початковим двом значенням опору проводиться пряма і визначається очікуване
        значення при нульовій напрузі}
end;

procedure TFittingAgentLSM.SetParameterValue(ParametrName: string;
          Value: double);
begin
   if not(fPIteration.ParametrByName[ParametrName].IsConstant) then
      fPIteration.ParametrByName[ParametrName].Value:=Value;
end;

procedure TFittingAgentLSM.StartAction;
begin
  inherited StartAction;
  SetLength(X2,fPIteration.MainParamHighIndex+1);
  SetLength(derivX,fPIteration.MainParamHighIndex+1);
  InitialApproximation;


//procedure TFitFunctLSM.TrueFitting(InputData: TVector;
//  var OutputData: TArrSingle);
// var X,X2,derivX:TArrSingle;
//     bool:boolean;
//     Nitt,i:integer;
//     Sum1,Sum2,al:double;
//begin
//  SetLength(X,fNx);
//  SetLength(derivX,fNx);
//  SetLength(X2,fNx);
//  InitialApproximation(InputData,X);
//  if X[1]<0 then X[1]:=1;
//  if X[0]=ErResult then
//                  begin
//                    IterWindowClear();
//                    Exit;
//                  end;
//  if not(ParamCorectIsDone(InputData,X)) then
//                  begin
//                    IterWindowClear();
//                    Exit;
//                  end;
//  Nitt:=0;
//  Sum2:=1;

//  repeat
//   if Nitt<1 then
//      if not(SquareFormIsCalculated(InputData,X,derivX,Sum1)) then
//                  begin
//                    IterWindowClear();
//                    Exit;
//                  end;
//
//   bool:=true;
//   if not(odd(Nitt)) then for I := 0 to High(X) do X2[i]:=X[i];
//   if not(odd(Nitt))or (Nitt=0) then Sum2:=Sum1;
end;

{ TFFDParam }

function TFFDParam.GetIsConstant: boolean;
begin
 Result:=False;
end;

procedure TFFDParam.SetIsConstant(const Value: boolean);
begin

end;

end.
