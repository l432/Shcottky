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
  procedure UpDate;virtual;
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
   function GetValue(index:integer):double;
   function GetParameter(index:integer):TFFDParam;
    procedure CreateSuffix(FF: TFitFunctionNew; const MainParamNames: array of string);
  public
   fParams:array of TFFDParam;
   OutputData:TArrSingle;
   property Value[index:integer]:double read GetValue;default;
   property ParametrByName[str:string]:TFFDParam read GetParameterByName;
   property Parametr[index:integer]:TFFDParam read GetParameter;
   property MainParamHighIndex:integer read fMainParamHighIndex;
   constructor Create(FF:TFitFunctionNew;
                      const MainParamNames: array of string);overload;
   constructor Create(FF:TFitFunctionNew;
                      const MainParamNames: array of string;
                     const AddParamNames: array of string);overload;
   destructor Destroy;override;
   procedure OutputDataCoordinate;
   procedure OutputDataCoordinateByName(str:string);
   Procedure DataToStrings(OutStrings:TStrings);
   procedure SetValueByName(Name:string;Value:double);
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
 public
  fCPDeter:TConstParDetermination;
  procedure UpDate;override;
  constructor Create(Nm:string;VarArray:TVarDoubArray);
  destructor Destroy;override;
  procedure WriteToIniFile(ConfigFile:TOIniFileNew;
                           const Section:string);virtual;
  procedure ReadFromIniFile(ConfigFile:TOIniFileNew;
                           const Section:string);virtual;
end;

TFFParamGradient=class(TFFParamIteration)
{параметри, які визначаються в результаті
ітераційного процесу}
 private
  fIsConstant:boolean;
  function GetIsConstant: boolean;override;
  procedure SetIsConstant(const Value: boolean);override;
 public
//  fCPDeter:TConstParDetermination;
//  property IsConstant:boolean read GetIsConstant write SetIsConstant;
//  property Value:Double read fValue write fValue;
//  procedure UpDate;
//  constructor Create(Nm:string;VarArray:TVarDoubArray);
//  destructor Destroy;override;
  procedure WriteToIniFile(ConfigFile:TOIniFileNew;
                           const Section:string);override;
  procedure ReadFromIniFile(ConfigFile:TOIniFileNew;
                           const Section:string);override;
end;

TFFParamHeuristic=class(TFFParamIteration)
{параметри, які визначаються в результаті
ітераційного процесу}
 private
  fMode:TVar_RandNew; //тип параметрів
  function GetIsConstant: boolean;override;

 public
  fMinLim:double; //мінімальні значення змінних при еволюційному пошуку
  fMaxLim:double; //максимальні значення змінних при еволюційному пошуку
  property Mode:TVar_RandNew read fMode write fMode;
  procedure WriteToIniFile(ConfigFile:TOIniFileNew;
                           const Section:string);override;
  procedure ReadFromIniFile(ConfigFile:TOIniFileNew;
                           const Section:string);override;
  procedure ToCorrectData;
end;


TDParamsIteration=class(TDParamArray)
  private
   fNit:integer;//кількість ітерацій
//   fAccurancy:double;
//  {величина, пов'язана з критерієм
//   припинення ітераційного процесу}
//   procedure MainParamCreate(const MainParamNames: array of string);override;
  public
   property Nit:integer read fNit write fNit;
//   property Accurancy:double read fAccurancy write fAccurancy;
   procedure WriteToIniFile;virtual;
   procedure ReadFromIniFile;virtual;
   function IsReadyToFitDetermination:boolean;virtual;
   procedure UpDate;
end;


TDParamsGradient=class(TDParamsIteration)
  private
//   fNit:integer;//кількість ітерацій
   fAccurancy:double;
  {величина, пов'язана з критерієм
   припинення ітераційного процесу}
   procedure MainParamCreate(const MainParamNames: array of string);override;
  public
//   property Nit:integer read fNit write fNit;
   property Accurancy:double read fAccurancy write fAccurancy;
   procedure WriteToIniFile;override;
   procedure ReadFromIniFile;override;
   function IsReadyToFitDetermination:boolean;override;
//   procedure UpDate;
end;


TDParamsHeuristic=class(TDParamsIteration)
  private
   fEvType:TEvolutionTypeNew;
   {еволюційний метод}
   fFitType:TFitnessType;
   {спосіб розрахунку функції вартості}
   fLogFitness:boolean;
   {при True функція вартості розраховується
   з використанням логарифмів величин}
   fRegType:TRegulationType;
   {тип регуляризації}
   fRegWeight:double;
   {вагова вартість - множник у обчисленні регуляризації}
   fArgumentType:TCoord_type;
   procedure MainParamCreate(const MainParamNames: array of string);override;

  public
   property RegWeight:double read fRegWeight write fRegWeight;
   property EvType:TEvolutionTypeNew read fEvType write fEvType;
   property FitType:TFitnessType read fFitType write fFitType;
   property RegType:TRegulationType read fRegType write fRegType;
   property LogFitness:boolean read fLogFitness write fLogFitness;
   property ArgumentType:TCoord_type read fArgumentType write fArgumentType;
   procedure WriteToIniFile;override;
   procedure ReadFromIniFile;override;
end;

//  TEvolutionTypeNew= //еволюційний метод, який використовується для апроксимації
//    (etDE, //differential evolution
//     etMABC, // modified artificial bee colony
//     etTLBO,  //teaching learning based optimization algorithm
//     etPSO    // particle swarm optimization
//     );
//  {}
//  TFitnessType=
//   (ftSR,//the sum of squared residuals звичайна квадратична форма
//    ftRSR,//the sum relative of squared residuals квадратична форма з відносних величин
//    ftAR,//сума модулів різниць
//    ftRAR//сума модулів відносних різниць
//   );



TFittingAgent=class
{той, що вміє проводити ітераційний процес}
 private
  fToStop:boolean;
//  fIsDone:boolean;
 protected
  fDescription:string;
  fCurrentIteration:integer;
  function GetIstimeToShow:boolean;virtual;
 public
  property Description:string read fDescription;
  property CurrentIteration:integer read fCurrentIteration;
//  property IsDone:boolean read fIsDone write fIsDone;
  property ToStop:boolean read fToStop;
  property IsTimeToShow:boolean read GetIstimeToShow;
  procedure StartAction;virtual;
  procedure IterationAction;virtual;
  procedure DataCoordination;virtual;
//  procedure EndAction;virtual;abstract;
end;

TFittingAgentLSM=class(TFittingAgent)
 private
  fPIteration:TDParamsGradient;
  fDataToFit:TVectorTransform;
  ftempVector: TVectorTransform;
  fT:double;
  X2,derivX:TArrSingle;
  Sum1,Sum2{,al}:double;
  Procedure InitialApproximation;virtual;
  procedure RshInitDetermine(InitVector:TVectorTransform);//Function IA_Determine3(Vector1,Vector2:TVector):double;
  Procedure nRsIoInitDetermine;//IA_Determine012
  procedure SetParameterValue(ParametrName:string;Value:double);
  Function SquareFormIsCalculated:boolean;virtual;
  Function Secant(num:word;a,b,F:double):double;
  {обчислюється оптимальне значення параметра al
  в методі поординатного спуску;
  використовується метод дихотомії;
  а та b задають початковий відрізок, де шукається розв'язок}
  Function SquareFormDerivate(num:byte;al,F:double):double;virtual;
  {розраховується значення похідної квадратичної форми,
  функція використовується при  покоординатному спуску і обчислюється
  похідна по al, яка описує зміну  того чи іншого параметра апроксимації
  Param = Param - al*F, де  Param залежить від num
  F - значення похідної квадритичної форми по Param при al = 0
  (те, що повертає функція SquareFormIsCalculated в RezF)}
 Function ParamIsBad:boolean;virtual;
  {перевіряє чи параметри можна використовувати для
  апроксимації даних в InputData функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh
  IA[0] - n, IA[1] - Rs, IA[2] - I0, IA[3] - Rsh}
 Function ParamCorectIsDone:boolean;{overload;}virtual;
{коректуються величини в IA, щоб їх можна було використовувати для
апроксимації InputData, якщо таки не вдалося -
повертається False}

 public
  constructor Create(PIteration:TDParamsGradient;DataToFit,tempVector: TVectorTransform;
                     T:double);
//                     DoubVars:TVarDoubArray);
  procedure StartAction;override;
  procedure IterationAction;override;
//  procedure EndAction;override;
end;


TFittingAgentPhotoDiodLSM=class(TFittingAgentLSM)
 private
  Procedure InitialApproximation;override;
end;

TFittingAgentDiodLam=class(TFittingAgentLSM)
 private
 Function ParamIsBad:boolean;override;
 {перевіряє чи параметри можна використовувати для
 апроксимації даних в InputData функцією Ламверта,
 IA[0] - n, IA[1] - Rs, IA[2] - I0, IA[3] - Rsh}
 Function SquareFormIsCalculated:boolean;override;
 Function SquareFormDerivate(num:byte;al,F:double):double;override;
end;


TFittingAgentPhotoDiodLam=class(TFittingAgentLSM)
 private
 Voc:double;
 Isc:double;
 Procedure InitialApproximation;override;
 Function ParamCorectIsDone:boolean;override;
 Function SquareFormIsCalculated:boolean;override;
{X[0] - n, X[1] - Rs, X[2] -  Rsh;
RezF[0] - похідна по n, RezF[1] - по Rs, RezF[2] - по Rsh}
 Function SquareFormDerivate(num:byte;al,F:double):double;override;
 Function ParamIsBad:boolean;override;
 {перевіряє чи параметри можна використовувати для
 апроксимації даних в InputData функцією Ламверта,
 IA[0] - n, IA[1] - Rs, IA[2] - Rsh}
end;

Procedure PVparameteres(DataToFit:TVectorTransform;ParamArray:TDParamArray);
{занесення величин Voc, Isc, Pm, Vm, Im, FF,
отриманих на основі значень в  DataToFit,
до елементів ParamArray з відповідними назвами}

implementation

uses
  SysUtils, OlegFunction, OlegMath, FitGradient, Math;

{ TDParamArray }

constructor TDParamArray.Create(FF:TFitFunctionNew;
                               const MainParamNames: array of string);
begin
  inherited Create;
  CreateSuffix(FF, MainParamNames);
  MainParamCreate(MainParamNames);
  LastParamCreate;
end;

procedure TDParamArray.AddParamCreate(const AddParamNames: array of string);
 var i: Integer;
begin
  SetLength(fParams, fMainParamHighIndex + High(AddParamNames)+2);
  for I := 0 to High(AddParamNames) do
    fParams[i+fMainParamHighIndex+1] := TFFDParam.Create(AddParamNames[i]);
end;

constructor TDParamArray.Create(FF:TFitFunctionNew;
                               const MainParamNames: array of string;
                              const AddParamNames: array of string);
begin
  inherited Create;
//  fFF:=FF;
  CreateSuffix(FF, MainParamNames);
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

function TDParamArray.GetParameter(index: integer): TFFDParam;
begin
 Result:=fParams[index];
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

function TDParamArray.GetValue(index: integer): double;
begin
  Result:=fParams[index].Value;
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
//  fMainParamHighIndex := High(MainParamNames);
//  SetLength(fParams, fMainParamHighIndex + 1);
  for I := 0 to fMainParamHighIndex do
    fParams[i] := TFFDParam.Create(MainParamNames[i]);
end;

procedure TDParamArray.OutputDataCoordinate;
 var I:integer;
begin
  for I := 0 to High(fParams)
     do OutputData[i]:=fParams[i].Value;
end;

procedure TDParamArray.OutputDataCoordinateByName(str: string);
 var I:integer;
begin
  for I := 0 to High(fParams) do
   if fParams[i].Name=str then
      begin
        OutputData[i]:=fParams[i].Value;
        Exit;
      end;
end;

procedure TDParamArray.SetValueByName(Name: string; Value: double);
begin
 try
   ParametrByName[Name].Value:=Value;
 finally
 end;
end;

procedure TDParamArray.CreateSuffix(FF: TFitFunctionNew; const MainParamNames: array of string);
begin
  fFF := FF;
  fMainParamHighIndex := High(MainParamNames);
  SetLength(fParams, fMainParamHighIndex + 1);
end;

{ TConstParDetermination }

constructor TConstParDetermination.Create(Nm:string;VarArray:TVarDoubArray);
 var ch:char;
     i:integer;
begin
 inherited Create(Nm);
 fVarArray:=VarArray;
 InitArray(Coefficients,3,0);
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

//constructor TFFParamGradient.Create(Nm: string; VarArray: TVarDoubArray);
//begin
// inherited Create(Nm);
// IsConstant:=False;
// fCPDeter:=TConstParDetermination.Create(Nm,VarArray);
//end;

//destructor TFFParamGradient.Destroy;
//begin
// fCPDeter.Free;
// inherited;
//end;

function TFFParamGradient.GetIsConstant: boolean;
begin
 Result:=fIsConstant;
end;

procedure TFFParamGradient.ReadFromIniFile(ConfigFile: TOIniFileNew;
  const Section: string);
begin
  inherited;
//  fCPDeter.ReadFromIniFile(ConfigFile,Section);
  IsConstant:=ConfigFile.ReadBool(Section,Name+'_IsConstant',False);
end;

procedure TFFParamGradient.SetIsConstant(const Value: boolean);
begin
  fIsConstant:=Value;
end;

//procedure TFFParamGradient.UpDate;
//begin
// if IsConstant then Value:=fCPDeter.Value;
//end;

procedure TFFParamGradient.WriteToIniFile(ConfigFile: TOIniFileNew;
  const Section: string);
begin
  inherited;
//  fCPDeter.WriteToIniFile(ConfigFile,Section);
  WriteIniDef(ConfigFile,Section,Name+'_IsConstant',IsConstant);
end;

{ TDParamIterationArray }

function TDParamsGradient.IsReadyToFitDetermination: boolean;
//  var I:integer;
begin
 Result:= inherited IsReadyToFitDetermination;
 Result:=Result and (fAccurancy<>ErResult);
end;

procedure TDParamsGradient.MainParamCreate(
         const MainParamNames: array of string);
 var i: Integer;
begin
//  fMainParamHighIndex := High(MainParamNames);
//  SetLength(fParams, fMainParamHighIndex + 1);
  for I := 0 to fMainParamHighIndex do
    fParams[i] := TFFParamGradient.Create(MainParamNames[i],
                               (fFF as TFFVariabSet).DoubVars);
end;

procedure TDParamsGradient.ReadFromIniFile;
 var I:integer;
begin
  inherited;
  for I := 0 to fMainParamHighIndex
    do (fParams[i] as TFFParamGradient).ReadFromIniFile(fFF.ConfigFile,fFF.Name);
  fAccurancy:=fFF.ConfigFile.ReadFloat(fFF.Name,'Accurancy',1e-8);
//  fNit:=fFF.ConfigFile.ReadInteger(fFF.Name,'Nit',1000);
end;

//procedure TDParamsGradient.UpDate;
// var i:integer;
//begin
// for I := 0 to MainParamHighIndex do
//    (fParams[i] as TFFParamGradient).UpDate;
//end;

procedure TDParamsGradient.WriteToIniFile;
 var I:integer;
begin
  inherited;
  for I := 0 to fMainParamHighIndex
    do (fParams[i] as TFFParamGradient).WriteToIniFile(fFF.ConfigFile,fFF.Name);
  WriteIniDef(fFF.ConfigFile,fFF.Name,'Accurancy',fAccurancy,1e-8);
//  WriteIniDef(fFF.ConfigFile,fFF.Name,'Nit',fNit,1000);
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

procedure TFFParamIteration.ReadFromIniFile(ConfigFile: TOIniFileNew;
  const Section: string);
begin
   fCPDeter.ReadFromIniFile(ConfigFile,Section);
end;

procedure TFFParamIteration.UpDate;
begin
 if IsConstant then Value:=fCPDeter.Value;
end;

procedure TFFParamIteration.WriteToIniFile(ConfigFile: TOIniFileNew;
  const Section: string);
begin
  fCPDeter.WriteToIniFile(ConfigFile,Section);
end;

{ TFittingAgent }

procedure TFittingAgent.DataCoordination;
begin
end;

function TFittingAgent.GetIstimeToShow: boolean;
begin
 Result:=((fCurrentIteration mod 25)=0);
end;

procedure TFittingAgent.IterationAction;
begin
  Inc(fCurrentIteration);
end;

procedure TFittingAgent.StartAction;
begin
 fToStop:=false;
 fCurrentIteration:=0;
end;

{ TFittingAgentLSM }

constructor TFittingAgentLSM.Create(PIteration: TDParamsGradient;
                                    DataToFit,tempVector: TVectorTransform;
                                    T:double);
//                                    DoubVars:TVarDoubArray);
begin
 inherited Create;
 fPIteration:=PIteration;
 fDataToFit:=DataToFit;
 ftempVector:=tempVector;
// fDoubVars:=DoubVars;
 fT:=T;
 fDescription:='Coordinate gradient descent';
end;

procedure TFittingAgentLSM.InitialApproximation;
 var i:integer;
begin
 SetParameterValue('n',ErResult);

 RshInitDetermine(fDataToFit);
 ftempVector.SetLenVector(fDataToFit.Count);
 for I := 0 to ftempVector.HighNumber do
    ftempVector.Y[i]:=(fDataToFit.Y[i]-fDataToFit.X[i]
                /fPIteration.ParametrByName['Rsh'].Value);
  {в temp - ВАХ з врахуванням Rsh0}
  nRsIoInitDetermine;

end;

procedure TFittingAgentLSM.IterationAction;
 var i:integer;
     al:double;
begin
  fToStop:=True;
  if not(odd(fCurrentIteration)) then
     begin
      for I := 0 to High(X2) do X2[i]:=fPIteration[i];
      Sum2:=Sum1;
     end;

   for I := 0 to fPIteration.MainParamHighIndex do
       begin
         if fPIteration.fParams[i].IsConstant then Continue;
         if derivX[i]=0 then Continue;
         if abs(fPIteration[i]/100/derivX[i])>1e100
                        then Continue;
         al:=Secant(i,0,0.1*abs(fPIteration[i]/derivX[i]),derivX[i]);
         if abs(al*derivX[i]/fPIteration[i])>2 then Continue;
         fPIteration.fParams[i].Value:=fPIteration.fParams[i].Value-al*derivX[i];
         if not(ParamCorectIsDone) then
              Raise Exception.Create('Fault! not ParamCorectIsDone');

         fToStop:=fToStop
                  and (abs((X2[i]-fPIteration[i])/fPIteration[i])<fPIteration.fAccurancy);

         if not(SquareFormIsCalculated) then
            Raise Exception.Create('Fault! not SquareFormIsCalculated');
       end;

  inherited;
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
  OutputData[1]:=1/(Kb*fT*OutputData[1]);

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

function TFittingAgentLSM.ParamCorectIsDone: boolean;
begin
  Result:=False;
  if fPIteration[1]<0.0001 then fPIteration.fParams[1].Value:=0.0001;
  if (fPIteration[3]<=0) or (fPIteration[3]>1e12)
      then fPIteration.fParams[3].Value:=1e12;
  while (ParamIsBad)and(fPIteration[0]<1000) do
     fPIteration.fParams[0].Value:=fPIteration[0]*2;
  while (ParamIsBad)and(fPIteration[2]>1e-15) do
     fPIteration.fParams[2].Value:=fPIteration[2]/1.5;
  if  ParamIsBad then Exit;
  Result:=true;
end;

function TFittingAgentLSM.ParamIsBad: boolean;
 var bt:double;
     i:integer;
begin
  Result:=True;
  if fPIteration[0]<=0 then Exit;
  bt:=2/Kb/fT/fPIteration[0];
  if fPIteration[1]<0 then Exit;
  if (fPIteration[2]<0) or (fPIteration[2]>1) then Exit;
  if fPIteration[3]<=1e-4 then Exit;
  for I := 0 to fDataToFit.HighNumber do
    if bt*(fDataToFit.X[i]-fPIteration[1]*fDataToFit.Y[i])>700
          then Exit;
  Result:=False;
end;

procedure TFittingAgentLSM.RshInitDetermine(InitVector:TVectorTransform);
 var tVector:TVectorTransform;
begin
 if fPIteration.ParametrByName['Rsh'].IsConstant then Exit;
 tVector:=TVectorTransform.Create;

 fDataToFit.Derivate(tVector);
   {фактично, в ftempVector залеженість оберненого опору від напруги}
 if tVector.Count<3 then
    Raise Exception.Create('Fault in RshInitDetermine');

 fPIteration.ParametrByName['Rsh'].Value:=(tVector.X[1]/tVector.y[2]
                                           -tVector.X[2]/tVector.y[1])
                                           /(tVector.X[1]-tVector.X[2]);
  {Rsh0 - по початковим двом значенням опору проводиться пряма і визначається очікуване
        значення при нульовій напрузі}
  tVector.Free;
end;

function TFittingAgentLSM.Secant(num: word; a, b, F: double): double;
  var i:integer;
      c,Fb,Fa:double;
begin
  Result:=0;
    Fa:=SquareFormDerivate(num,a,F);
    if Fa=ErResult then Exit;
    if Fa=0 then
               begin
                  Result:=a;
                  Exit;
                end;
    repeat
      Fb:=SquareFormDerivate(num,b,F);
      if Fb=0 then
                begin
                  Result:=b;
                  Exit;
                end;
      if Fb=ErResult then Break
                     else
                       begin
                       if Fb*Fa<=0 then Break
                                  else b:=2*b
                       end;
    until false;
    i:=0;
    repeat
      inc(i);
      c:=(a+b)/2;
      Fb:=SquareFormDerivate(num,c,F);
      Fa:=SquareFormDerivate(num,a,F);
      if (Fb*Fa<=0) or (Fb=ErResult)
        then b:=c
        else a:=c;
    until (i>1e5)or(abs((b-a)/c)<1e-2);
    if (i>1e5) then Exit;
    Result:=c;

end;

procedure TFittingAgentLSM.SetParameterValue(ParametrName: string;
          Value: double);
begin
   if not(fPIteration.ParametrByName[ParametrName].IsConstant) then
      fPIteration.ParametrByName[ParametrName].Value:=Value;
end;

function TFittingAgentLSM.SquareFormDerivate(num: byte; al, F: double): double;
  var i:integer;
     Zi,Rez,nkT,vi,ei,eiI0,
     n,Rs,I0,Rsh,Iph:double;
begin
 Result:=ErResult;
 if ParamIsBad then  Exit;
 n:=fPIteration[0];
 Rs:=fPIteration[1];
 I0:=fPIteration[2];
 Rsh:=fPIteration[3];
 Iph:=0;
 if fPIteration.MainParamHighIndex>3 then Iph:=fPIteration[4];
 try
  case num of
   0:n:=n-al*F;
   1:Rs:=Rs-al*F;
   2:I0:=I0-al*F;
   3:Rsh:=Rsh-al*F;
   4:Iph:=Iph-al*F;
  end;//case
  nkT:=n*Kb*fT;
  Rez:=0;
  for I := 0 to fDataToFit.HighNumber do
   begin
     vi:=(fDataToFit.X[i]-fDataToFit.Y[i]*Rs);
     ei:=exp(vi/nkT);
     Zi:=I0*(ei-1)+vi/Rsh-fDataToFit.Y[i];
     if fPIteration.MainParamHighIndex>3 then Zi:=Zi-Iph;
     eiI0:=ei*I0/nkT;

     case num of
       0:Rez:=Rez+Zi/abs(fDataToFit.Y[i])*eiI0*vi;
       1:Rez:=Rez+Zi*(eiI0+1/Rsh);
       2:Rez:=Rez+Zi/abs(fDataToFit.Y[i])*(1-ei);
       3:Rez:=Rez+Zi/abs(fDataToFit.Y[i])*vi/Rsh/Rsh;
       4:Rez:=Rez-ZI/abs(fDataToFit.Y[i]);
     end; //case
   end;
   Rez:=2*F*Rez;
   if num=0 then Rez:=Rez/n;
  Result:=Rez;
 except
 end;//try

end;

function TFittingAgentLSM.SquareFormIsCalculated: boolean;
 var   Zi,ZIi,nkT,vi,ei,eiI0:double;
       i:integer;
begin
// ['n','Rs','Io','Rsh']

 nkT:=fPIteration[0]*Kb*fT;
 InitArray(derivX,fPIteration.MainParamHighIndex+1,0);
 Sum1:=0;

 try
  for I := 0 to fDataToFit.HighNumber do
     begin
       vi:=(fDataToFit.X[i]-fDataToFit.Y[i]
                           *fPIteration[1]);
       ei:=exp(vi/nkT);
       Zi:=fPIteration[2]
          *(ei-1)+vi/fPIteration[3]
          -fDataToFit.Y[i];
       if fPIteration.MainParamHighIndex=4
          then Zi:=Zi-fPIteration[4];
       ZIi:=Zi/abs(fDataToFit.Y[i]);
       eiI0:=ei*fPIteration[2]/nkT;
       Sum1:=Sum1+ZIi*Zi;
       derivX[0]:=derivX[0]-ZIi*eiI0*vi;
       derivX[1]:=derivX[1]-Zi*(eiI0+1/fPIteration[3]);
       derivX[2]:=derivX[2]+ZIi*(ei-1);
       derivX[3]:=derivX[3]-ZIi*vi;
       if fPIteration.MainParamHighIndex=4
          then derivX[4]:=derivX[4]-ZIi;
     end;
  for I := 0 to High(derivX) do derivX[i]:=derivX[i]*2;
  derivX[0]:=derivX[0]/fPIteration[0];
  derivX[3]:=derivX[3]/sqr(fPIteration[3]);
  Result:=True;
 except
  Result:=False;
 end;
end;

procedure TFittingAgentLSM.StartAction;
// var i:integer;
begin
  inherited StartAction;
  SetLength(X2,fPIteration.MainParamHighIndex+1);
  InitialApproximation;

  if fPIteration.ParametrByName['Rs'].Value<0
     then SetParameterValue('Rs',1);

  if (fPIteration.ParametrByName['Rsh'].Value>=1e12)
      or(fPIteration.ParametrByName['Rsh'].Value<=0)
      then SetParameterValue('Rsh',1e12);

  if fPIteration.ParametrByName['n'].Value<=0
     then SetParameterValue('n',1);

  if fPIteration.ParametrByName['n'].Value=ErResult
     then Raise Exception.Create('Fault, n=ErResult');

//    for I := 0 to fPIteration.MainParamHighIndex do
//    HelpForMe(inttostr(i)+'0_'+floattostr(fPIteration[i]));

  if not(SquareFormIsCalculated)
    then Raise Exception.Create('Fault in SquareFormIsCalculated');
//  HelpForMe('sum1'+floattostr(Sum1));
  Sum2:=Sum1;


//    for I := 0 to fPIteration.MainParamHighIndex do
//    HelpForMe(inttostr(i)+'0_'+floattostr(fPIteration[i]));
end;

{ TFFDParam }

function TFFDParam.GetIsConstant: boolean;
begin
 Result:=False;
end;

procedure TFFDParam.SetIsConstant(const Value: boolean);
begin

end;

procedure TFFDParam.UpDate;
begin

end;

{ TFittingAgentPhotoDiodLSM }

procedure TFittingAgentPhotoDiodLSM.InitialApproximation;
 var i:integer;
begin
 SetParameterValue('n',ErResult);
 if (fDataToFit.Voc<=0.002) then Exit;
 SetParameterValue('Iph',fDataToFit.Isc);
 if fPIteration.ParametrByName['Iph'].Value<=1e-8 then Exit;
 fDataToFit.CopyTo(ftempVector);
 ftempVector.AdditionY(fPIteration.ParametrByName['Iph'].Value);
 RshInitDetermine(ftempVector);
 for I := 0 to ftempVector.HighNumber do
    ftempVector.Y[i]:=(ftempVector.Y[i]-ftempVector.X[i]
                /fPIteration[3]);
  {в temp - ВАХ з врахуванням Rsh0}
  nRsIoInitDetermine;
end;

{ TFittingAgentDiodLam }

function TFittingAgentDiodLam.ParamIsBad: boolean;
 var bt:double;
begin
  Result:=true;
  bt:=1/Kb/fT;
  if fPIteration[0]<=0 then Exit;
  if fPIteration[1]<0 then Exit;
  if fPIteration[2]<0  then Exit;
  if fPIteration[3]<0 then Exit;
  if bt/fPIteration[0]*(fDataToFit.X[fDataToFit.HighNumber]+fPIteration[1]*fPIteration[2])>ln(1e308)
                       then Exit;
  if bt*fPIteration[1]*fPIteration[2]
     /fPIteration[0]*exp(Kb*fT/fPIteration[0]
                        *(fDataToFit.X[fDataToFit.HighNumber]+fPIteration[1]*fPIteration[2]))>ln(1e308)
                       then Exit;
  Result:=false;
end;

function TFittingAgentDiodLam.SquareFormDerivate(num: byte; al,
  F: double): double;

 var i:integer;
     Yi,bt,Zi,Wi,I0Rs,ci,Rez,g1,
     n,Rs,I0,Rsh:double;
begin
 Result:=ErResult;
 n:=fPIteration[0];
 Rs:=fPIteration[1];
 I0:=fPIteration[2];
 Rsh:=fPIteration[3];
 try
  case num of
   0:n:=n-al*F;
   1:Rs:=Rs-al*F;
   2:I0:=I0-al*F;
   3:Rsh:=Rsh-al*F;
  end;//case
  if ParamIsBad then  Exit;
  bt:=1/Kb/fT;
  I0Rs:=I0*Rs;
  g1:=bt*I0Rs;
  Rez:=0;
  for I := 0 to fDataToFit.HighNumber do
     begin
       ci:=bt*(fDataToFit.X[i]+I0Rs);
       Yi:=bt*I0Rs/n*exp(ci/n);
       Wi:=Lambert(Yi);
       Zi:=n/bt/Rs*Wi+fDataToFit.X[i]/Rsh-I0-fDataToFit.Y[i];
       case num of
           0:Rez:=Rez-Zi/abs(fDataToFit.Y[i])*Wi*(ci-n*Wi)/(1+Wi);
           1:Rez:=Rez+Zi/abs(fDataToFit.Y[i])*Wi*(n*Wi-g1)/(1+Wi);
           2:Rez:=Rez-Zi/abs(fDataToFit.Y[i])*(n*Wi-g1)/(1+Wi);
           3:Rez:=Rez+Zi/abs(fDataToFit.Y[i])*fDataToFit.X[i];
        end; //case
     end;
  case num of
       0:Rez:=2*Rez*F/(bt*n*Rs);
       1:Rez:=2*Rez*F/(bt*Rs*Rs);
       2:Rez:=2*Rez*F/(bt*I0Rs);
       3:Rez:=2*Rez*F/Rsh/Rsh;
  end; //case
  Result:=Rez;
 except
 end;//try
end;

function TFittingAgentDiodLam.SquareFormIsCalculated: boolean;
 var i:integer;
     bt,Zi,Wi,F1s,
     I0Rs,nWi,ci,ZIi,s23,
     F2,F1:double;
begin
 bt:=1/Kb/fT;
 InitArray(derivX,fPIteration.MainParamHighIndex+1,0);
 Sum1:=0;

 I0Rs:=fPIteration[2]*fPIteration[1];
 F2:=bt*I0Rs;
 F1:=bt*fPIteration[1];
 try
  for I := 0 to fDataToFit.HighNumber do
     begin
       ci:=bt*(fDataToFit.X[i]+I0Rs);
       Wi:=Lambert(bt*I0Rs/fPIteration[0]*exp(ci/fPIteration[0]));
       nWi:=fPIteration[0]*Wi;
       Zi:=fPIteration[0]/bt/fPIteration[1]*Wi+fDataToFit.X[i]/fPIteration[3]
           -fPIteration[2]-fDataToFit.Y[i];
       ZIi:=Zi/abs(fDataToFit.Y[i]);
       F1s:=F1*(Wi+1);
       s23:=(F2-nWi)/F1s;
       Sum1:=Sum1+ZIi*Zi;
       derivX[0]:=derivX[0]+ZIi*Wi*(nWi-ci)/F1s;
       derivX[1]:=derivX[1]+ZIi*Wi*s23;
       derivX[2]:=derivX[2]-ZIi*s23;
       derivX[3]:=derivX[3]-ZIi*fDataToFit.X[i];
     end;

  for I := 0 to High(derivX) do derivX[i]:=derivX[i]*2;
  derivX[1]:=derivX[1]/fPIteration[0];
  derivX[2]:=derivX[2]/fPIteration[1];
  derivX[2]:=derivX[2]/fPIteration[2];
  derivX[3]:=derivX[3]/sqr(fPIteration[3]);
  Result:=True;
 except
  Result:=False;
 end;
end;


Procedure PVparameteres(DataToFit:TVectorTransform;ParamArray:TDParamArray);
{занесення величин Voc, Isc, Pm, Vm, Im, FF,
отриманих на основі значень в  DataToFit,
до елементів ParamArray з відповідними назвами}
 var  OutputData:TArrSingle;
begin
 DataToFit.PVParareters(OutputData);
 ParamArray.SetValueByName('Voc',OutputData[0]);
 ParamArray.SetValueByName('Isc',OutputData[1]);
 ParamArray.SetValueByName('Pm',OutputData[2]);
 ParamArray.SetValueByName('Vm',OutputData[3]);
 ParamArray.SetValueByName('Im',OutputData[4]);
 ParamArray.SetValueByName('FF',OutputData[5]);
end;


{ TFittingAgentPhotoDiodLam }

procedure TFittingAgentPhotoDiodLam.InitialApproximation;
 var i:integer;
     OutputData:TArrSingle;
begin
  SetParameterValue('n',ErResult);
  Isc:=fDataToFit.Isc;
  Voc:=fDataToFit.Voc;
  if (Voc<=0.001)or(Isc<5e-8)
    then Exception.Create('Fault! Voc or Isc is so small');
  RshInitDetermine(fDataToFit);

//  HelpForMe('Rsh'+floattostr(fPIteration[2]));
   {n та Rs0 - як нахил та вільних член лінійної апроксимації
    щонайбільше семи останніх точок залежності dV/dI від kT/q(Isc+I-V/Rsh);}
  fDataToFit.Derivate(ftempVector);
//  ftempVector.DeleteZeroY;
  for I := 0 to ftempVector.HighNumber do
       begin
         ftempVector.Y[i]:=1/ftempVector.Y[i];
         ftempVector.X[i]:=Kb*fT
                  /(Isc+fDataToFit.Y[i]-fDataToFit.X[i]
                    /fPIteration[2]);
       end;

   if ftempVector.Count>7 then ftempVector.DeleteNfirst(ftempVector.Count-7);
   ftempVector.LinAprox(OutputData);
   SetParameterValue('Rs',OutputData[0]);
   SetParameterValue('n',OutputData[1]);

//    HelpForMe('n'+floattostr(fPIteration[0]));
//    HelpForMe('Rs'+floattostr(fPIteration[1]));
end;

function TFittingAgentPhotoDiodLam.ParamCorectIsDone: boolean;
begin
  Result:=false;
  if (fPIteration[0]=0)or(fPIteration[0]=ErResult) then Exit;
  if fPIteration[1]<0.0001 then fPIteration.fParams[1].Value:=0.0001;

  if (fPIteration[2]<=0) or (fPIteration[2]>1e12)
      then fPIteration.fParams[2].Value:=1e12;
  while (ParamIsBad)and(fPIteration[0]<1000) do
   fPIteration.fParams[0].Value:=fPIteration[0]*2;
  if  ParamIsBad then Exit;
  Result:=true;
end;

function TFittingAgentPhotoDiodLam.ParamIsBad: boolean;
 var nkT,t1,t2:double;
begin
  Result:=true;
  nkT:=fPIteration[0]*Kb*fT;
  if fPIteration[0]<=0 then Exit;
  if fPIteration[1]<=0 then Exit;
  if fPIteration[2]<=0 then Exit;
  if 2*(Voc+Isc*fPIteration[1])/nkT > ln(1e308) then Exit;
  if exp(Voc/nkT) = exp(Isc*fPIteration[1]/nkT) then Exit;
  t1:=(fPIteration[1]*Isc-Voc)/nkT;
  if t1 > ln(1e308) then Exit;
  t2:=fPIteration[2]*fPIteration[1]/nkT/(fPIteration[1]+fPIteration[2])*
      (Voc/fPIteration[2]+(Isc+(fPIteration[1]*Isc-Voc)/fPIteration[2])/(1-exp(t1))
           +fDataToFit.X[fDataToFit.HighNumber]/fPIteration[1]);
  if abs(t2) > ln(1e308) then Exit;
  if fPIteration[1]/nkT*(Isc-Voc/(fPIteration[1]+fPIteration[2]))
          *exp(-Voc/nkT)*exp(t2)/(1-exp(t1))> 700   then Exit;
  Result:=false;
end;

function TFittingAgentPhotoDiodLam.SquareFormDerivate(num: byte; al,
  F: double): double;
 var i:integer;
     Yi,Zi,Wi,GVI,Z1,Y1,F1,F12,F21,F22,F3,F31,
     nkT,W_W1,Rez,
     n,Rs,Rsh:double;
begin
 Result:=ErResult;
 n:=fPIteration[0];
 Rs:=fPIteration[1];
 Rsh:=fPIteration[2];

 try
  case num of
     0:n:=n-al*F;
     1:Rs:=Rs-al*F;
     2:Rsh:=Rsh-al*F;
   end;//case
  if ParamIsBad then  Exit;
  nkT:=n*kb*fT;
  GVI:=(exp(Isc*Rs/nkT)-exp(Voc/nkT));
  Z1:=Rsh/(Rs+Rsh)*((Isc+(Rs*Isc-Voc)/Rsh)/(1-exp((Rs*Isc-Voc)/nkT))+Voc/Rsh);
  Y1:=Voc/Rsh+(Isc+(Rs*Isc-Voc)/Rsh)/(1-exp((Rs*Isc-Voc)/nkT));
  F1:=exp((Isc*Rs+Voc)/nkT)*(Isc*Rs-Voc)*(Isc*(Rs+Rsh)-Voc)/(nkT*n*(Rs+Rsh)*GVI*GVI);
  F12:=(exp(2*Voc/nkT)*(Rs+Rsh)*(nkT+Isc*Rs-Voc)+
     exp(2*Isc*Rs/nkT)*((nkT-Isc*Rs)*(Rs+Rsh)+Rs*Voc)+
     exp((Isc*Rs+Voc)/nkT)*(-2*nkT*(Rs+Rsh)+(Rs*(Isc*Rs-Voc)*(Isc*(Rs+Rsh)-Voc))/nkT+Rsh*Voc))/sqr(GVI);
  F21:=(exp(2*Isc*Rs/nkT)*nkT*Voc-exp((Isc*Rs+Voc)/nkT)*
      (Isc*(Rs + Rsh)*(Isc*(Rs + Rsh)-Voc)+nkT*Voc))/
      (sqr(GVI)*nkT*sqr((Rs + Rsh)));
  F22:=(-exp(Voc/nkT)*nkT*(Rs + Rsh) +
     exp(Isc*Rs/nkT)*((nkT - Isc*Rs)*(Rs + Rsh) + Rs*Voc))*
     (exp(Isc*Rs/nkT)*nkT*(Isc*(Rs + Rsh)*(Rs+Rsh) - Rsh*Voc) +
     exp(Voc/nkT)*(-Isc*(nkT + Isc*Rs)*(Rs + Rsh)*(Rs+Rsh) +
     (nkT*Rsh + Isc* Rs* (Rs + Rsh))* Voc))/(nkT*Rs*sqr(GVI)*(Isc*(Rs+Rsh)-Voc));
  F3:=Voc/(1-exp((Voc-Isc*Rs)/nkT));
  F31:=nkT*Voc/(Rs*(Isc-Voc/(Rs+Rsh)));

  Rez:=0;
  for I := 0 to fDataToFit.HighNumber do
     begin
       Yi:=Rs/nkT*(Isc-Voc/(Rs+Rsh))*exp(-Voc/nkT)/(1-exp((Rs*Isc-Voc)/nkT))*
       exp(Rsh*Rs/nkT/(Rs+Rsh)*(fDataToFit.X[i]/Rs+Y1));
       Zi:=fDataToFit.X[i]/(Rs+Rsh)-Z1+nkT/Rs*Lambert(Yi)-fDataToFit.Y[i];
       Wi:=Lambert(Yi);
       if Wi=ErResult then Exit;
       W_W1:=Wi/(Wi+1);

       case num of
        0: Rez:=Rez+Zi/abs(fDataToFit.Y[i])*(F1+Kb*fT/Rs*Wi-
                    W_W1/(n*Rs*(Rs+Rsh))*(F12+Rsh*fDataToFit.X[i]));

        1: Rez:=Rez+Zi/abs(fDataToFit.Y[i])*(-fDataToFit.X[i]/sqr(Rs+Rsh)+F21-nkT/sqr(Rs)*Wi+
                  W_W1/(Rs*sqr(Rs+Rsh))*(F22-Rsh*fDataToFit.X[i]));

        2: Rez:=Rez+Zi/abs(fDataToFit.Y[i])*(F3-fDataToFit.X[i]+F31*Wi)/((1+Wi)*sqr(Rs+Rsh));

       end; //case
     end;
  Rez:=2*F*Rez;
  Result:=Rez;
 except
 end;//try
end;

function TFittingAgentPhotoDiodLam.SquareFormIsCalculated: boolean;
 var i:integer;
    Yi,Zi,Wi,GVI,Z1,Y1,F1,F12,F21,F22,F3,F31,
    ZIi,nkT,W_W1,
    n,Rs,Rsh:double;
begin
 Result:=False;
 InitArray(derivX,fPIteration.MainParamHighIndex+1,0);
 Sum1:=0;
 n:=fPIteration[0];
 Rs:=fPIteration[1];
 Rsh:=fPIteration[2];

 try
  nkT:=n*kb*fT;
  GVI:=(exp(Isc*Rs/nkT)-exp(Voc/nkT));
  Z1:=Rsh/(Rs+Rsh)*((Isc+(Rs*Isc-Voc)/Rsh)/(1-exp((Rs*Isc-Voc)/nkT))+Voc/Rsh);
  Y1:=Voc/Rsh+(Isc+(Rs*Isc-Voc)/Rsh)/(1-exp((Rs*Isc-Voc)/nkT));
  F1:=exp((Isc*Rs+Voc)/nkT)*(Isc*Rs-Voc)*(Isc*(Rs+Rsh)-Voc)/(nkT*n*(Rs+Rsh)*GVI*GVI);
  F12:=(exp(2*Voc/nkT)*(Rs+Rsh)*(nkT+Isc*Rs-Voc)+
     exp(2*Isc*Rs/nkT)*((nkT-Isc*Rs)*(Rs+Rsh)+Rs*Voc)+
     exp((Isc*Rs+Voc)/nkT)*(-2*nkT*(Rs+Rsh)+(Rs*(Isc*Rs-Voc)*(Isc*(Rs+Rsh)-Voc))/nkT+Rsh*Voc))/sqr(GVI);
  F21:=(exp(2*Isc*Rs/nkT)*nkT*Voc-exp((Isc*Rs+Voc)/nkT)*
      (Isc*(Rs + Rsh)*(Isc*(Rs + Rsh)-Voc)+nkT*Voc))/
      (sqr(GVI)*nkT*sqr((Rs + Rsh)));
  F22:=(-exp(Voc/nkT)*nkT*(Rs + Rsh) +
     exp(Isc*Rs/nkT)*((nkT - Isc*Rs)*(Rs + Rsh) + Rs*Voc))*
     (exp(Isc*Rs/nkT)*nkT*(Isc*(Rs + Rsh)*(Rs+Rsh) - Rsh*Voc) +
     exp(Voc/nkT)*(-Isc*(nkT + Isc*Rs)*(Rs + Rsh)*(Rs+Rsh) +
     (nkT*Rsh + Isc* Rs* (Rs + Rsh))* Voc))/(nkT*Rs*sqr(GVI)*(Isc*(Rs+Rsh)-Voc));
  F3:=Voc/(1-exp((Voc-Isc*Rs)/nkT));
  F31:=nkT*Voc/(Rs*(Isc-Voc/(Rs+Rsh)));

  for I := 0 to fDataToFit.HighNumber do
     begin
       Yi:=Rs/nkT*(Isc-Voc/(Rs+Rsh))*exp(-Voc/nkT)/(1-exp((Rs*Isc-Voc)/nkT))*
       exp(Rsh*Rs/nkT/(Rs+Rsh)*(fDataToFit.X[i]/Rs+Y1));
       Zi:=fDataToFit.X[i]/(Rs+Rsh)-Z1+nkT/Rs*Lambert(Yi)-fDataToFit.Y[i];
       Wi:=Lambert(Yi);
       if Wi=ErResult then Exit;
       W_W1:=Wi/(Wi+1);
       ZIi:=Zi/abs(fDataToFit.Y[i]);
       Sum1:=Sum1+ZIi*Zi;
       derivX[0]:=derivX[0]+ZIi*(F1+Kb*fT/Rs*Wi-
                W_W1/(n*Rs*(Rs+Rsh))*(F12+Rsh*fDataToFit.X[i]));
       derivX[1]:=derivX[1]+ZIi*(-fDataToFit.X[i]/sqr(Rs+Rsh)+F21-nkT/sqr(Rs)*Wi+
              W_W1/(Rs*sqr(Rs+Rsh))*(F22-Rsh*fDataToFit.X[i]));
      derivX[2]:=derivX[2]+ZIi*(F3-fDataToFit.X[i]+F31*Wi)/((1+Wi)*sqr(Rs+Rsh));
     end;
  for I := 0 to High(derivX) do derivX[i]:=derivX[i]*2;
  Result:=True;
 finally
 end;
end;

{ TFFParamHeuristic }

function TFFParamHeuristic.GetIsConstant: boolean;
begin
 Result:=(fMode=vr_const);
end;

procedure TFFParamHeuristic.ReadFromIniFile(ConfigFile: TOIniFileNew;
  const Section: string);
begin
  inherited;
  fMode:=ConfigFile.ReadRand(Section,Name+'Mode');
  fMinLim:=ConfigFile.ReadFloat(Section,Name+'MinLim',0);
  fMaxLim:=ConfigFile.ReadFloat(Section,Name+'MaxLim',1);
  ToCorrectData;
end;

procedure TFFParamHeuristic.ToCorrectData;
begin
  if fMaxLim < fMinLim then Swap(fMaxLim, fMinLim);
  if fMaxLim = fMinLim then fMaxLim := fMaxLim + 1;
  if (fMode = vr_ln) and (fMinLim <= 0) then fMinLim := 1E-40;
  if (fMode = vr_ln) and (fMaxLim <= 0) then fMaxLim := fMinLim+1;

end;

procedure TFFParamHeuristic.WriteToIniFile(ConfigFile: TOIniFileNew;
  const Section: string);
begin
  inherited;
  ConfigFile.WriteRand(Section, Name+'Mode', fMode);
  ConfigFile.WriteFloat(Section, Name+'MinLim',fMinLim);
  ConfigFile.WriteFloat(Section, Name+'MaxLim',fMaxLim);
end;

{ TDParamsIteration }

function TDParamsIteration.IsReadyToFitDetermination: boolean;
 var i:integer;
begin
 Result:=True;
 for I := 0 to fMainParamHighIndex do
  if fParams[i].IsConstant
    then Result:=Result and (fParams[i].Value<>ErResult);
 Result:=Result and (fNit<>ErResult) and (fNit>0);
end;

procedure TDParamsIteration.ReadFromIniFile;
begin
 fNit:=fFF.ConfigFile.ReadInteger(fFF.Name,'Nit',1000);
end;

procedure TDParamsIteration.UpDate;
 var i:integer;
begin
 for I := 0 to MainParamHighIndex do fParams[i].UpDate;
end;

procedure TDParamsIteration.WriteToIniFile;
begin
  WriteIniDef(fFF.ConfigFile,fFF.Name,'Nit',fNit,1000);
end;

{ TDParamsHeuristic }

procedure TDParamsHeuristic.MainParamCreate(
  const MainParamNames: array of string);
 var i: Integer;
begin
  for I := 0 to fMainParamHighIndex do
    fParams[i] := TFFParamHeuristic.Create(MainParamNames[i],
                               (fFF as TFFVariabSet).DoubVars);
  fArgumentType:=cX;
end;

procedure TDParamsHeuristic.ReadFromIniFile;
 var I:integer;
begin
  inherited;
  for I := 0 to fMainParamHighIndex
    do (fParams[i] as TFFParamHeuristic).ReadFromIniFile(fFF.ConfigFile,fFF.Name);
  fEvType:=fFF.ConfigFile.ReadEvType(fFF.Name,'EvType');
  fFitType:=fFF.ConfigFile.ReadFitType(fFF.Name,'FitType');
  fRegType:=fFF.ConfigFile.ReadRegType(fFF.Name,'RegType');
  fRegWeight:=fFF.ConfigFile.ReadFloat(fFF.Name,'RegWeight',0);
  fLogFitness:=fFF.ConfigFile.ReadBool(fFF.Name,'LogFitness',False);
end;

procedure TDParamsHeuristic.WriteToIniFile;
 var I:integer;
begin
  inherited;
  for I := 0 to fMainParamHighIndex
    do (fParams[i] as TFFParamHeuristic).WriteToIniFile(fFF.ConfigFile,fFF.Name);
  fFF.ConfigFile.WriteEvType(fFF.Name,'EvType',fEvType);
  fFF.ConfigFile.WriteFitType(fFF.Name,'FitType',fFitType);
  fFF.ConfigFile.WriteRegType(fFF.Name,'RegType',fRegType);
  WriteIniDef(fFF.ConfigFile,fFF.Name,'RegWeight',fRegWeight,0);
  WriteIniDef(fFF.ConfigFile,fFF.Name,'LogFitness',fLogFitness);
end;

end.
