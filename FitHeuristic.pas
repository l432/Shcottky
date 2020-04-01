unit FitHeuristic;

interface

uses
  FitGradient, OlegType, FitIteration, OApproxNew, OlegVector,
  OlegMath, OlegFunction, FitIterationShow, OlegVectorManipulation;

type

TFFHeuristic=class(TFFIteration)
 private
  function GetParamsHeuristic:TDParamsHeuristic;
 protected
  fPoint:TPointDouble;
  procedure PointDetermine(X:double);
  function RealFinalFunc(X:double):double;override;
  procedure FittingAgentCreate;override;
 public
  property ParamsHeuristic:TDParamsHeuristic read GetParamsHeuristic;
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;virtual;abstract;
end;

TWindowIterationShowID=class(TWindowIterationShow)
  public
   procedure UpDate;override;
 end;

TFFIlluminatedDiode=class(TFFHeuristic)
 protected
  procedure WindowAgentCreate;override;
  function FittingCalculation:boolean;override;
end;

TFFXYSwap=class(TFFHeuristic)
 protected
  Procedure RealToFile;override;
  procedure RealFitting;override;
end;

TFitnessTerm=class
  fFuncForFitness:TFunObj;
 public
  constructor Create(FF:TFFHeuristic);
  function Term(Point:TPointDouble;Parameters:TArrSingle):double;virtual;abstract;
  destructor Destroy;override;
end;

TFitnessTermSR=class(TFitnessTerm)
 public
  function Term(Point:TPointDouble;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTermRSR=class(TFitnessTerm)
 public
  function Term(Point:TPointDouble;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTermAR=class(TFitnessTerm)
 public
  function Term(Point:TPointDouble;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTermRAR=class(TFitnessTerm)
 public
  function Term(Point:TPointDouble;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTermLnSR=class(TFitnessTerm)
 public
  function Term(Point:TPointDouble;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTermLnRSR=class(TFitnessTerm)
 public
  function Term(Point:TPointDouble;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTermLnAR=class(TFitnessTerm)
 public
  function Term(Point:TPointDouble;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTermLnRAR=class(TFitnessTerm)
 public
  function Term(Point:TPointDouble;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTerm_Class=class of TFitnessTerm;

const
  FitnessTermClasses:array[ftSR..ftRAR]of TFitnessTerm_Class=
  (TFitnessTermSR,TFitnessTermRSR,
   TFitnessTermAR,TFitnessTermRAR);

  LogFitnessTermClasses:array[ftSR..ftRAR]of TFitnessTerm_Class=
  (TFitnessTermLnSR,TFitnessTermLnRSR,
   TFitnessTermLnAR,TFitnessTermLnRAR);


type

TReTerm=class
  fXmin:double;
  fXmaxXmin:double;
 public
  Number:integer;//порядковий номер в масиві параметрів
  function RegTerm(Arg:double):double;virtual;abstract;
end;

TRegTerm=class(TReTerm)
 public
  constructor Create(const Param:TFFParamHeuristic);
  function RegTerm(Arg:double):double;override;
end;

TRegTermLog=class(TReTerm)
  constructor Create(const Param:TFFParamHeuristic);
  function RegTerm(Arg:double):double;override;
end;

TRegulation=class//(TRegulationZero)
  fRegTerms:array of TReTerm;
  fRegWeight:double;
 public
  constructor Create(FF:TFFHeuristic);
  function Term(Parameters:TArrSingle):double;virtual;abstract;
  destructor Destroy;override;
end;

TRegulationL2=class(TRegulation)
 public
  function Term(Parameters:TArrSingle):double;override;
end;

TRegulationL1=class(TRegulation)
 public
  function Term(Parameters:TArrSingle):double;override;
end;

TRegulation_Class=class of TRegulation;

const
  RegulationClasses:array[TRegulationType]of TRegulation_Class=
  (TRegulationL2,TRegulationL1);

type

TFitnessCalculation=class
 private
  procedure SomeActions(FF:TFFHeuristic);virtual;
 public
  constructor Create(FF:TFFHeuristic);
  Function FitnessFunc(const OutputData:TArrSingle):double;virtual;
end;

TFitnessCalculationData=class(TFitnessCalculation)
 private
  fData:TVector;
  procedure SomeActions(FF:TFFHeuristic);override;
 public
  destructor Destroy;override;
end;



TFitnessCalculationArea=class(TFitnessCalculationData)
{according to PROGRESS  IN  PHOTOVOLTAICS: RESEARCH  AND APPLICATIONS,  VOL  1,  93-106 (1993) }
 private
  fDataFitness:TVectorTransform;
  fFuncForFitness:TFunObj;
  procedure Prepare(const OutputData:TArrSingle);virtual;
  procedure SomeActions(FF:TFFHeuristic);override;
 public
  Function FitnessFunc(const OutputData:TArrSingle):double;override;
  destructor Destroy;override;
end;

TFitnessCalculationAreaLn=class(TFitnessCalculationArea)
 private
  fDataInit:TVectorTransform;
  procedure Prepare(const OutputData:TArrSingle);override;
  procedure SomeActions(FF:TFFHeuristic);override;
 public
  destructor Destroy;override;
end;

TFitnessCalculationSum=class(TFitnessCalculationData)
 private
  fFitTerm:TFitnessTerm;
  procedure SomeActions(FF:TFFHeuristic);override;
 public
  Function FitnessFunc(const OutputData:TArrSingle):double;override;
  destructor Destroy;override;
end;

TFitnessCalculationWithRegalation=class(TFitnessCalculation)
 private
  fRegTerm:TRegulation;
  fFitCalcul:TFitnessCalculation;
 public
  constructor Create(FF:TFFHeuristic;FitCalcul:TFitnessCalculation);
  Function FitnessFunc(const OutputData:TArrSingle):double;override;
  destructor Destroy;override;
end;

TFitnessFunc_Class=class of TFitnessCalculation;

const
  FitnessFuncClasses:array[ftArea..ftArea]of TFitnessFunc_Class=
  (TFitnessCalculationArea);


  LogFitnessFuncClasses:array[ftArea..ftArea]of TFitnessFunc_Class=
  (TFitnessCalculationAreaLn);

type

TToolKit=class
 private
  Xmin:double;
  Xmax:double;
  procedure DataSave(const Param: TFFParamHeuristic);virtual;
 public
  constructor Create(const Param:TFFParamHeuristic);
  function RandValue:double;virtual;abstract;
 {повертає випадкове з інтервалу Xmin-Xmax}
  procedure Penalty(var X:double);virtual;abstract;
 {якщо Х за межами інтервалу, то повертає його туди}
  function DE_Mutation(X1,X2,X3,F:double):double;virtual;abstract;
  function PSO_Transform(X2,X3,F:double):double;virtual;abstract;
  procedure PSO_Penalty(var X:double;var Velocity:double;
                        const Parameter:double);virtual;abstract;
  function TLBO_ToMeanValue(X:double):double;virtual;abstract;
  function TLBO_Transform(X1,X2,Xmean,r:double;Tf:integer):double;virtual;abstract;
  function IJAYA_CEL(X,Xb,F:double):double;virtual;abstract;
  function IJAYA_SAW(X,Xb,Xw,R1,R2:double):double;virtual;abstract;
  function GetOppPopul(X:double):double;virtual;abstract;
  function ISCA_Update(X,Xb,R1,R2,R3,R4,Weight:double):double;virtual;abstract;
end;


TToolKitLinear=class(TToolKit)
 private
  Xmax_Xmin:double;
  procedure DataSave(const Param: TFFParamHeuristic);override;
 public
  function RandValue:double;override;
  procedure Penalty(var X:double);override;
  function DE_Mutation(X1,X2,X3,F:double):double;override;
  function PSO_Transform(X2,X3,F:double):double;override;
  procedure PSO_Penalty(var X:double;var Velocity:double;
                        const Parameter:double);override;
  function TLBO_ToMeanValue(X:double):double;override;
  function TLBO_Transform(X1,X2,Xmean,r:double;Tf:integer):double;override;
  function IJAYA_CEL(X,Xb,F:double):double;override;
  function IJAYA_SAW(X,Xb,Xw,R1,R2:double):double;override;
  function GetOppPopul(X:double):double;override;
  function ISCA_Update(X,Xb,R1,R2,R3,R4:double;Weight:double=1):double;override;

end;

TToolKitLog=class(TToolKit)
 private
  lnXmax:double;
  lnXmin:double;
  lnXmax_Xmin:double;
  procedure DataSave(const Param: TFFParamHeuristic);override;
 public
  function RandValue:double;override;
  procedure Penalty(var X:double);override;
  function DE_Mutation(X1,X2,X3,F:double):double;override;
  function PSO_Transform(X2,X3,F:double):double;override;
  procedure PSO_Penalty(var X:double;var Velocity:double;
                        const Parameter:double);override;
  function TLBO_ToMeanValue(X:double):double;override;
  function TLBO_Transform(X1,X2,Xmean,r:double;Tf:integer):double;override;
  function IJAYA_CEL(X,Xb,F:double):double;override;
  function IJAYA_SAW(X,Xb,Xw,R1,R2:double):double;override;
  function GetOppPopul(X:double):double;override;
  function ISCA_Update(X,Xb,R1,R2,R3,R4:double;Weight:double=1):double;override;

end;

TToolKitConst=class(TToolKit)
 private
  procedure DataSave(const Param: TFFParamHeuristic);override;
 public
  function RandValue:double;override;
  procedure Penalty(var X:double);override;
  function DE_Mutation(X1,X2,X3,F:double):double;override;
  function PSO_Transform(X2,X3,F:double):double;override;
  procedure PSO_Penalty(var X:double;var Velocity:double;
                        const Parameter:double);override;
  function TLBO_ToMeanValue(X:double):double;override;
  function TLBO_Transform(X1,X2,Xmean,r:double;Tf:integer):double;override;
  function IJAYA_CEL(X,Xb,F:double):double;override;
  function IJAYA_SAW(X,Xb,Xw,R1,R2:double):double;override;
  function GetOppPopul(X:double):double;override;
  function ISCA_Update(X,Xb,R1,R2,R3,R4:double;Weight:double=1):double;override;

end;

TToolKit_Class=class of TToolKit;

const
  ToolKitClasses:array[TVar_RandNew]of TToolKit_Class=
  (TToolKitLinear,TToolKitLog,TToolKitConst);

type


TFA_Heuristic=class(TFittingAgent)
 private
  fNfit:Int64;
  {кількість викликів FitnessFunc}
  fNp:integer;
  {кількість наборів параметрів}
  fFF:TFFHeuristic;
  fFitCalcul:TFitnessCalculation;
  fToolKitArr:array of TToolKit;
  Parameters:TArrArrSingle;
  {набори параметрів}
  FitnessData:TArrSingle;
  {значення цільової функції для різних наборів параметрів}
  procedure RandomValueToParameter(i:integer);
  {заповненя випадковим даними
  і-го набору з Parameters}
  procedure Initiation;
  {початкове встановлення випадкових значень
  параметрів та розрахунок
  відповідних величин цільової функції}
  Function FitnessFunc(OutputData:TArrSingle):double;
 {цільова функція для оцінки якості апроксимації
 даних в InputData з використанням OutputData}
  function NpDetermination:integer;virtual;abstract;
  procedure ConditionalRandomize;
  procedure CreateFields;virtual;
  function GreedySelection(i:integer;NewFitnessData:double;
                             NewParameter:TArrSingle):boolean;
 protected
  function GetIstimeToShow:boolean;override;
  procedure ArrayToHeuristicParam(Data:TArrSingle);
 public
  constructor Create(FF:TFFHeuristic);
  destructor Destroy;override;
  procedure StartAction;override;
  procedure DataCoordination;override;
end;

TFA_ConsecutiveGeneration=class(TFA_Heuristic)
 private
  ParametersNew:TArrArrSingle;
  FitnessDataNew:TArrSingle;
  VectorForOppositePopulation:TVector;
  procedure NewPopulationCreate(i:integer);virtual;abstract;
  procedure GenerateOppositePopulation(i:integer);
  procedure GenerateOppositePopulationAll;
  procedure VectorForOppositePopulationFilling;
  procedure OppositePopulationSelection;
  procedure GreedySelectionAll;virtual;
  procedure CreateFields;override;
  procedure NewPopulationCreateAll;virtual;
  procedure BeforeNewPopulationCreate;virtual;
  procedure AfterNewPopulationCreate;virtual;
 public
  procedure IterationAction;override;
  destructor Destroy;override;
end;


//TFA_DE=class(TFA_Heuristic)
TFA_DE=class(TFA_ConsecutiveGeneration)
 private
  F:double;
  CR:double;
  r:array [1..3] of integer;
  function NpDetermination:integer;override;
  procedure BeforeNewPopulationCreate;override;
  procedure NewPopulationCreate(i:integer);override;
  procedure MutationCreate(i:integer);
  {створення і-го вектора мутації}
  procedure Crossover(i:integer);
  procedure MutationCreateAll;
  procedure CreateFields;override;
end;


//TFA_IJAYA=class(TFA_Heuristic)
TFA_IJAYA=class(TFA_ConsecutiveGeneration)
// Energy Conversion and Management 150 (2017) 742–753
 private
  NumberBest:integer;
  NumberWorst:integer;
  Weight:double;
  Z:double;
  function NewZ:double;
  function NpDetermination:integer;override;
  procedure AfterNewPopulationCreate;override;
  procedure NewPopulationCreate(i:integer);override;
  procedure KoefDetermination;
  procedure ChaoticEliteLearning(i:integer);
  procedure SelfAdaptiveWeight(i:integer);
  procedure ExperienceBasedLearning(i:integer);
  procedure CreateFields;override;
 public
  procedure StartAction;override;
end;


TFA_ISCA=class(TFA_ConsecutiveGeneration)
{ основа - Knowledge-Based Systems 96 (2016) 120–133
поращення - з Expert Systems With Applications 123 (2019) 108–126  (все що там є)
 та  Expert Systems With Applications 119 (2019) 210–230 (opposite population)
також додав Greedy Selection - його там спочатку не було,
але в якійсь роботі бачив рекомендації таки долучити}
 private
  NumberBest:integer;
  Weight:double;
  R1,R2,R3,R4:double;
  Wstart,Wend:double;
  Astart,Aend:double;
  k:integer;
  Jr:double;
  ItIsOppositeGeneration:boolean;
  function NewR1:double;
  function NewWeight:double;
  function NpDetermination:integer;override;

  procedure AfterNewPopulationCreate;override;
  procedure NewPopulationCreate(i:integer);override;
  procedure KoefDetermination;
  procedure SinCosinUpdate(i:integer);
  procedure NewPopulationCreateAll;override;
  procedure GreedySelectionAll;override;
  procedure GreedySelectionSimple;
  procedure CreateFields;override;
  procedure RandomKoefDetermination;
 public
  procedure StartAction;override;
end;



TFA_MABC=class(TFA_Heuristic)
 private
  FitnessDataMutation:TArrSingle;
  Count:TArrInteger;
  ParametersNew:TArrSingle;
  Limit:integer;
  function NpDetermination:integer;override;
  procedure CreateFields;override;
  procedure CreateParametersNew(i:integer);
  procedure EmployedBee;
  procedure OnlookersBee;
  procedure ScoutBee;
 public
  procedure IterationAction;override;
end;

TFA_PSO=class(TFA_Heuristic)
 private
  C1:byte;
  C2:byte;
  Wmax:double;
  Wmin:double;
  LocBestPar:TArrArrSingle;
  Velocity:TArrArrSingle;
  GlobBestNumb:integer;
  function NpDetermination:integer;override;
  procedure CreateFields;override;
 public
  procedure IterationAction;override;
  procedure StartAction;override;
  procedure DataCoordination;override;
end;


TFA_TLBO=class(TFA_Heuristic)
 private
  r:double;
  Tf:integer;
  temp:double;
  ParameterMean:TArrSingle;
  ParameterNew:TArrSingle;
  function NpDetermination:integer;override;
  procedure CreateFields;override;
  procedure ParameterMeanCalculate;
  procedure TeacherPhase;
  procedure LearnerPhase;
 public
  procedure IterationAction;override;
end;


TFA_Heuristic_Class=class of TFA_Heuristic;

const
  FA_HeuristicClasses:array[TEvolutionTypeNew]of TFA_Heuristic_Class=
  (TFA_DE,TFA_MABC,TFA_TLBO,TFA_PSO,TFA_IJAYA,TFA_ISCA);


Function FitnessCalculationFactory(FF: TFFHeuristic):TFitnessCalculation;

//uses TypInfo
//
//procedure TForm1.Button10Click(Sender: TObject);
//var
// p : PPropInfo;
//begin
// p := GetPropInfo(Timer1, "Font");
// if Assigned(p) then
//   ShowMessage("Yea!")
// else
//   ShowMessage("No!")
//end;

//
//  try
//
//    DataSource:=GetObjectProp(Components[i],'DataSource');
//
//  except
//
//    DataSource:=nil;
//
//  end

implementation

uses
  SysUtils, Math, Dialogs, Classes, Windows, Graphics;

{ TFFHeuristic }

procedure TFFHeuristic.FittingAgentCreate;
begin
 fFittingAgent:=FA_HeuristicClasses[ParamsHeuristic.EvType].Create(Self);
end;

function TFFHeuristic.GetParamsHeuristic: TDParamsHeuristic;
begin
 Result:=(fDParamArray as TDParamsHeuristic);
end;

procedure TFFHeuristic.PointDetermine(X: double);
begin
 fPoint[cX]:=X;
 fPoint[cY]:=DataToFit.Yvalue(X);
end;

function TFFHeuristic.RealFinalFunc(X: double): double;
begin
 PointDetermine(X);
 Result:=FuncForFitness(fPoint,fDParamArray.OutputData);
end;

{ TFA_Heuristic }

procedure TFA_Heuristic.ArrayToHeuristicParam(Data: TArrSingle);
 var i:integer;
begin
 for I := 0 to fFF.ParamsHeuristic.MainParamHighIndex do
  fFF.ParamsHeuristic.Parametr[i].Value:=Data[i];
end;

procedure TFA_Heuristic.ConditionalRandomize;
begin
  if (fNfit > 100)or(fNfit=0) then
     begin
     Randomize;
     fNfit:=1;
     end;
end;

constructor TFA_Heuristic.Create(FF: TFFHeuristic);
 var i:integer;
begin
 inherited Create;
 fFF:=FF;

 if (FF.ParamsHeuristic.RegWeight=0)
   then fFitCalcul:=FitnessCalculationFactory(FF)
   else fFitCalcul:=TFitnessCalculationWithRegalation.Create(FF,FitnessCalculationFactory(FF));


 SetLength(fToolKitArr,FF.DParamArray.MainParamHighIndex+1);
 for I := 0 to High(fToolKitArr) do
   fToolKitArr[i]:=ToolKitClasses[(FF.DParamArray.Parametr[i] as TFFParamHeuristic).Mode].Create((FF.DParamArray.Parametr[i] as TFFParamHeuristic));

 fNp:=NpDetermination;
 CreateFields;
end;

procedure TFA_Heuristic.DataCoordination;
begin
 ArrayToHeuristicParam(Parameters[MinElemNumber(FitnessData)]);
end;

destructor TFA_Heuristic.Destroy;
  var i:integer;
begin
  for I := 0 to High(fToolKitArr) do  FreeAndNil(fToolKitArr[i]);
  FreeAndNil(fFitCalcul);
  fFF:=nil;
  inherited;
end;

function TFA_Heuristic.FitnessFunc(OutputData: TArrSingle): double;
begin
 inc(fNfit);
 Result:=fFitCalcul.FitnessFunc(OutputData);
end;

function TFA_Heuristic.GetIstimeToShow: boolean;
begin
  Result:=((fCurrentIteration mod 100)=0);
end;

function TFA_Heuristic.GreedySelection(i:integer;NewFitnessData:double;
                             NewParameter:TArrSingle):boolean;
begin
 if FitnessData[i]>NewFitnessData then
   begin
    Parameters[i]:=Copy(NewParameter);
    FitnessData[i]:=NewFitnessData;
    Result:=True;
   end                             else
    Result:=False;
end;

procedure TFA_Heuristic.RandomValueToParameter(i: integer);
 var j:integer;
begin
 for j := 0 to High(fToolKitArr) do
  Parameters[i][j]:=fToolKitArr[j].RandValue;
end;

procedure TFA_Heuristic.StartAction;
begin
 inherited;
 fNfit:=0;
 Initiation;
end;

procedure TFA_Heuristic.CreateFields;
begin
  SetLength(FitnessData, fNp);
  SetLength(Parameters, fNp, fFF.DParamArray.MainParamHighIndex + 1);
end;

procedure TFA_Heuristic.Initiation;
 var i:integer;
begin
  i:=0;
  repeat
     ConditionalRandomize;
     RandomValueToParameter(i);
     try
      FitnessData[i]:=FitnessFunc(Parameters[i]);
     except
      Continue;
     end;
    inc(i);
  until (i>High(Parameters));
end;

{ TFitnessTerm }

constructor TFitnessTerm.Create(FF: TFFHeuristic);
begin
 fFuncForFitness:=FF.FuncForFitness;
end;

destructor TFitnessTerm.Destroy;
begin
  fFuncForFitness:=nil;
  inherited;
end;

{ TFitnessTermSR }

function TFitnessTermSR.Term(Point:TPointDouble;
                              Parameters:TArrSingle):double;
begin
 Result:=sqr(fFuncForFitness(Point,Parameters)-Point[cY]);
end;

{ TFitnessTermRSR }

function TFitnessTermRSR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
  try
   Result:=1/Point[cY];
  except
   on EZeroDivide do
     begin
       Result:=0;
       Exit;
     end;
  end;
  Result:=sqr((fFuncForFitness(Point,Parameters)-Point[cY])*Result);
//  Result:=sqr((fFuncForFitness(Point,Parameters)-Point[cY])/Point[cY]);
end;

{ TFitnessTermAR }

function TFitnessTermAR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
 Result:=abs(fFuncForFitness(Point,Parameters)-Point[cY]);
end;

{ TFitnessTermRAR }

function TFitnessTermRAR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
  try
   Result:=1/Point[cY];
  except
   on EZeroDivide do
     begin
       Result:=0;
       Exit;
     end;
  end;
  Result:=abs((fFuncForFitness(Point,Parameters)-Point[cY])*Result);
//  Result:=abs((fFuncForFitness(Point,Parameters)-Point[cY])/Point[cY]);
end;

{ TFitnessTermLogSR }

function TFitnessTermLnSR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
  try
   Result:=ln(Point[cY]);
  except
   on EZeroDivide do
    begin
    Result:=0;
    Exit;
    end;
   on EInvalidOp  do
    begin
    Result:=0;
    Exit;
    end;
  end;
  Result:=sqr(ln(fFuncForFitness(Point,Parameters))-Result);
//  Result:=sqr(ln(fFuncForFitness(Point,Parameters))-ln(Point[cY]));
end;

{ TFitnessTermLnRSR }

function TFitnessTermLnRSR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
 var temp:double;
begin
  try
   temp:=ln(Point[cY]);
  except
   on EZeroDivide do
     begin
       Result:=0;
       Exit;
     end;
   on EInvalidOp  do
     begin
       Result:=0;
       Exit;
     end;
  end;

  try
   Result:=1/temp;
  except
   on EZeroDivide do
     begin
       Result:=0;
       Exit;
     end;
  end;
  Result:=sqr((ln(fFuncForFitness(Point,Parameters))-temp)*Result);

//  Result:=sqr((ln(fFuncForFitness(Point,Parameters))-ln(Point[cY]))/ln(Point[cY]));
end;

{ TFitnessTermLnAR }

function TFitnessTermLnAR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
  try
   Result:=ln(Point[cY]);
  except
   on EZeroDivide do
    begin
    Result:=0;
    Exit;
    end;
   on EInvalidOp  do
    begin
    Result:=0;
    Exit;
    end;
  end;
  Result:=abs(ln(fFuncForFitness(Point,Parameters))-Result);
//  Result:=abs(ln(fFuncForFitness(Point,Parameters))-ln(Point[cY]));
end;

{ TFitnessTermLnRAR }

function TFitnessTermLnRAR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
 var temp:double;
begin
  try
   temp:=ln(Point[cY]);
  except
   on EZeroDivide do
     begin
       Result:=0;
       Exit;
     end;
   on EInvalidOp  do
     begin
       Result:=0;
       Exit;
     end;
  end;

  try
   Result:=1/temp;
  except
   on EZeroDivide do
     begin
       Result:=0;
       Exit;
     end;
  end;
  Result:=abs((ln(fFuncForFitness(Point,Parameters))-temp)*Result);

//  Result:=abs((ln(fFuncForFitness(Point,Parameters))-ln(Point[cY]))/ln(Point[cY]));
end;

{ TRegTerm }

constructor TRegTerm.Create(const Param: TFFParamHeuristic);
begin
 inherited Create;
 fXmin:=Param.fMinLim;
 fXmaxXmin:=Param.fMaxLim-fXmin;
end;

function TRegTerm.RegTerm(Arg: double): double;
begin
 Result:=(Arg-fXmin)/fXmaxXmin;
end;

{ TRegulationTerm }

constructor TRegulation.Create(FF: TFFHeuristic);
 var i:integer;
begin
 inherited Create;
 for I := 0 to FF.ParamsHeuristic.MainParamHighIndex do
   if not(FF.ParamsHeuristic.Parametr[i].IsConstant) then
      begin
        SetLength(fRegTerms,High(fRegTerms)+2);
        if (FF.ParamsHeuristic.Parametr[i] as TFFParamHeuristic).Mode=vr_lin
          then fRegTerms[High(fRegTerms)]:=TRegTerm.Create((FF.ParamsHeuristic.Parametr[i] as TFFParamHeuristic))
          else fRegTerms[High(fRegTerms)]:=TRegTermLog.Create((FF.ParamsHeuristic.Parametr[i] as TFFParamHeuristic));
        fRegTerms[High(fRegTerms)].Number:=i;
      end;
 fRegWeight:=FF.ParamsHeuristic.RegWeight;
end;

destructor TRegulation.Destroy;
 var i:integer;
begin
  for I := 0 to High(fRegTerms) do FreeAndNil(fRegTerms[i]);
  inherited;
end;

{ TRegulationL2 }

function TRegulationL2.Term(Parameters: TArrSingle): double;
 var i:integer;
begin
 Result:=0;
 for I := 0 to High(fRegTerms) do
    Result:=Result+
          sqr(fRegTerms[i].RegTerm(Parameters[fRegTerms[i].Number]));
 Result:=fRegWeight*Result;
end;

{ TRegulationL1 }

function TRegulationL1.Term(Parameters: TArrSingle): double;
 var i:integer;
begin
 Result:=0;
 for I := 0 to High(fRegTerms) do
    Result:=Result+
          abs(fRegTerms[i].RegTerm(Parameters[fRegTerms[i].Number]));
 Result:=fRegWeight*Result;
end;

{ TFitnessCalculationSum }

destructor TFitnessCalculationSum.Destroy;
begin
  FreeAndNil(fFitTerm);
  inherited;
end;

function TFitnessCalculationSum.FitnessFunc(const OutputData: TArrSingle): double;
 var i:integer;
begin
 Result:=0;
 for I := 0 to fData.HighNumber do
    Result:=Result+fFitTerm.Term(fData[i],OutputData);
end;

procedure TFitnessCalculationSum.SomeActions(FF: TFFHeuristic);
begin
  inherited;
  if FF.ParamsHeuristic.LogFitness
   then fFitTerm:=LogFitnessTermClasses[FF.ParamsHeuristic.FitType].Create(FF)
   else fFitTerm:=FitnessTermClasses[FF.ParamsHeuristic.FitType].Create(FF);
end;

{ TFitnessCalculationWithRegalation }

constructor TFitnessCalculationWithRegalation.Create(FF: TFFHeuristic;FitCalcul:TFitnessCalculation);
begin
 inherited Create(FF);
 fFitCalcul:=FitCalcul;
 fRegTerm:=RegulationClasses[FF.ParamsHeuristic.RegType].Create(FF);
end;

destructor TFitnessCalculationWithRegalation.Destroy;
begin
  FreeAndNil(fFitCalcul);
  FreeAndNil(fRegTerm);
  inherited;
end;

function TFitnessCalculationWithRegalation.FitnessFunc(
  const OutputData: TArrSingle): double;
begin
 Result:=fRegTerm.Term(OutputData)+fFitCalcul.FitnessFunc(OutputData);
end;

{ TRegTermLn }

constructor TRegTermLog.Create(const Param: TFFParamHeuristic);
begin
 inherited Create;
 fXmin:=ln(Param.fMinLim);
 fXmaxXmin:=ln(Param.fMaxLim)-fXmin;
end;

function TRegTermLog.RegTerm(Arg: double): double;
begin
 Result:=(ln(Arg)-fXmin)/fXmaxXmin;
end;

{ TToolKitLinear }

procedure TToolKitLinear.DataSave(const Param: TFFParamHeuristic);
begin
  inherited;
  Xmax_Xmin:=Param.fMaxLim-Xmin;
end;

function TToolKitLinear.DE_Mutation(X1, X2, X3, F: double): double;
begin
 Result:=X1+F*(X2-X3);
 Penalty(Result);
end;

function TToolKitLinear.GetOppPopul(X: double): double;
begin
 Result:=Xmin+Xmax-X;
end;

function TToolKitLinear.IJAYA_CEL(X,Xb, F: double): double;
begin
  Result:=X+F*(Xb-X);
end;

function TToolKitLinear.IJAYA_SAW(X, Xb, Xw, R1, R2:double): double;
begin
 Result:=X+R1*(Xb-abs(X))-R2*(Xw-abs(X));
end;

function TToolKitLinear.ISCA_Update(X, Xb, R1, R2, R3, R4,
  Weight: double): double;
begin
 if R4<0.5 then
   Result:=Weight*X+R1*sin(R2)*abs(R3*Xb-X)
           else
   Result:=Weight*X+R1*cos(R2)*abs(R3*Xb-X);
end;

procedure TToolKitLinear.Penalty(var X: double);
 var temp:double;
begin
 if InRange(X,Xmin,Xmax) then Exit;
 if not(InRange(X,Xmin-Xmax_Xmin,Xmax+Xmax_Xmin))
    then
      begin
       X:=RandValue;
       Exit;
      end;
 repeat
    if X>Xmax then temp:=X-Random*Xmax_Xmin
              else temp:=X+Random*Xmax_Xmin;
    if InRange(temp,Xmin,Xmax) then  Break;
 until False;
 X:=temp;
end;

procedure TToolKitLinear.PSO_Penalty(var X, Velocity: double;
  const Parameter: double);
begin
 X:=X+Velocity;
 if  not(InRange(X,Xmin,Xmax)) then
  begin
   if X>Xmax then Velocity:=Xmax-Parameter
             else Velocity:=Xmin-Parameter;
   if X>Xmax then X:=Xmax
             else X:=Xmin;
  end;
end;

function TToolKitLinear.PSO_Transform(X2, X3, F: double): double;
begin
 Result:=F*(X2-X3);
end;

function TToolKitLinear.RandValue: double;
begin
   Result:=Xmin+Xmax_Xmin*Random;
end;

function TToolKitLinear.TLBO_ToMeanValue(X: double): double;
begin
 Result:=X;
end;

function TToolKitLinear.TLBO_Transform(X1, X2, Xmean,r:double;Tf:integer): double;
begin
 Result:=X1+r*(X2-Tf*Xmean);
 Penalty(Result);
end;

{ TToolKitLog }

procedure TToolKitLog.DataSave(const Param: TFFParamHeuristic);
begin
 inherited;
 lnXmax:=Ln(Xmax);
 lnXmin:=ln(Xmin);
 lnXmax_Xmin:=lnXMax-lnXmin;
end;

function TToolKitLog.DE_Mutation(X1, X2, X3, F: double): double;
 var temp:double;
begin
 Result:=ln(X1)+F*(ln(X2)-ln(X3));
 if InRange(Result,lnXmin,lnXmax) then
   begin
   Result:=exp(Result);
   Exit;
   end;
 if not(InRange(Result,lnXmin-lnXmax_Xmin,lnXmax+lnXmax_Xmin))
    then
      begin
       Result:=RandValue;
       Exit;
      end;
 repeat
    if Result>lnXmax then temp:=Result-Random*lnXmax_Xmin
                     else temp:=Result+Random*lnXmax_Xmin;
    if InRange(temp,lnXmin,lnXmax) then  Break;
 until False;
 Result:=exp(temp);
end;

function TToolKitLog.GetOppPopul(X: double): double;
begin
 Result:=lnXmin+lnXmax-ln(X);
 Result:=exp(Result);
end;

function TToolKitLog.IJAYA_CEL(X,Xb, F: double): double;
begin
 Result:=ln(X)+F*(ln(Xb)-ln(X));
// if InRange(Result,lnXmin,lnXmax) then
//   begin
//   Result:=exp(Result);
//   Exit;
//   end;
// if not(InRange(Result,lnXmin-lnXmax_Xmin,lnXmax+lnXmax_Xmin))
//    then
//      begin
//       Result:=RandValue;
//       Exit;
//      end;
// repeat
//    if Result>lnXmax then temp:=Result-Random*lnXmax_Xmin
//                     else temp:=Result+Random*lnXmax_Xmin;
//    if InRange(temp,lnXmin,lnXmax) then  Break;
// until False;
 Result:=exp(Result);
end;

function TToolKitLog.IJAYA_SAW(X, Xb, Xw, R1, R2:double): double;
begin
 Result:=ln(X)+R1*(ln(Xb)-abs(ln(X)))-R2*(ln(Xw)-abs(ln(X)));
 Result:=exp(Result);
end;

function TToolKitLog.ISCA_Update(X, Xb, R1, R2, R3, R4, Weight: double): double;
 var lnX:double;
begin
 lnX:=ln(X);
 if R4<0.5 then
   Result:=Weight*lnX+R1*sin(R2)*abs(R3*ln(Xb)-lnX)
           else
   Result:=Weight*lnX+R1*cos(R2)*abs(R3*ln(Xb)-lnX);
 Result:=exp(Result);
end;

procedure TToolKitLog.Penalty(var X: double);
 var temp,lnX:double;
begin
 if InRange(X,Xmin,Xmax) then Exit;
 lnX:=ln(X);
 if not(InRange(lnX,lnXmin-lnXmax_Xmin,lnXmax+lnXmax_Xmin))
    then
      begin
       X:=RandValue;
       Exit;
      end;
 repeat
    if lnX>lnXmax then temp:=lnX-Random*lnXmax_Xmin
                  else temp:=lnX+Random*lnXmax_Xmin;
    if InRange(temp,lnXmin,lnXmax) then  Break;
 until False;
 X:=exp(temp);
end;

procedure TToolKitLog.PSO_Penalty(var X, Velocity: double;
                                 const Parameter: double);
begin
 X:=exp(ln(X)+Velocity);
 if not(InRange(X,Xmin,Xmax)) then
  begin
   if X>Xmax then Velocity:=lnXmax-ln(Parameter)
             else Velocity:=lnXmin-ln(Parameter);
   if X>Xmax then X:=Xmax
             else X:=Xmin;
  end;
end;


function TToolKitLog.PSO_Transform(X2, X3, F: double): double;
begin
 Result:=F*(ln(X2)-ln(X3));
end;

function TToolKitLog.RandValue: double;
begin
 Result:=exp(lnXmin+lnXmax_Xmin*Random);
end;

function TToolKitLog.TLBO_ToMeanValue(X: double): double;
begin
 Result:=ln(X);
end;

function TToolKitLog.TLBO_Transform(X1, X2, Xmean,r:double;Tf:integer): double;
// var temp:double;
begin
 Result:=exp(ln(X1)+r*(ln(X2)-Tf*Xmean));
 Penalty(Result);
end;

{ TToolKitConst }

procedure TToolKitConst.DataSave(const Param: TFFParamHeuristic);
begin
 inherited;
 Xmin:=Param.Value;
end;

function TToolKitConst.DE_Mutation(X1, X2, X3, F: double): double;
begin
 Result:=Xmin;
end;

function TToolKitConst.GetOppPopul(X: double): double;
begin
 Result:=Xmin;
end;

function TToolKitConst.IJAYA_CEL(X,Xb, F: double): double;
begin
 Result:=Xmin;
end;

function TToolKitConst.IJAYA_SAW(X, Xb, Xw, R1, R2:double): double;
begin
  Result:=Xmin;
end;

function TToolKitConst.ISCA_Update(X, Xb, R1, R2, R3, R4,
  Weight: double): double;
begin
 Result:=Xmin;
end;

procedure TToolKitConst.Penalty(var X: double);
begin
end;

procedure TToolKitConst.PSO_Penalty(var X, Velocity: double;
                                   const Parameter: double);
begin
end;

function TToolKitConst.PSO_Transform(X2, X3, F: double): double;
begin
 Result:=0;
end;

function TToolKitConst.RandValue: double;
begin
 Result:=Xmin;
end;

function TToolKitConst.TLBO_ToMeanValue(X: double): double;
begin
 Result:=Xmin;
end;

function TToolKitConst.TLBO_Transform(X1, X2, Xmean,r:double;Tf:integer): double;
begin
 Result:=Xmin;
end;

{ TToolKit }

constructor TToolKit.Create(const Param: TFFParamHeuristic);
begin
 inherited Create;
 DataSave(Param);
end;

procedure TToolKit.DataSave(const Param: TFFParamHeuristic);
begin
  Xmin := Param.fMinLim;
  Xmax := Param.fMaxLim;
end;

{ TFA_DE }

procedure TFA_DE.BeforeNewPopulationCreate;
begin
 MutationCreateAll;
end;

procedure TFA_DE.CreateFields;
begin
 inherited;
// SetLength(FitnessDataMutation,fNp);
// SetLength(Mutation,fNp,fFF.DParamArray.MainParamHighIndex+1);
 fDescription:='Differential Evolution';
 F:=0.8;
 CR:=0.3;
end;

procedure TFA_DE.Crossover(i: integer);
 var j:integer;
begin
 r[2]:=Random(fFF.DParamArray.MainParamHighIndex+1); //randn(i)
 for j := 0 to High(fToolKitArr) do
  if not(fFF.DParamArray.Parametr[j].IsConstant)
     and(Random>CR)
//     and (j<>r[2]) then Mutation[i,j]:=Parameters[i,j];
     and (j<>r[2]) then ParametersNew[i,j]:=Parameters[i,j];
end;

//procedure TFA_DE.CrossoverAll;
// var i:integer;
//begin
//  i:=0;
//  repeat
//   ConditionalRandomize;
//   Crossover(i);
//   try
//    FitnessDataMutation[i]:=FitnessFunc(Mutation[i]);
//   except
//    Continue;
//   end;
//    inc(i);
//  until (i>High(Mutation));
//
//end;

//procedure TFA_DE.GreedySelectionAll;
// var i:integer;
//begin
// for I := 0 to High(FitnessData) do
//   GreedySelection(i,FitnessDataMutation[i],Mutation[i]);
//end;

//procedure TFA_DE.IterationAction;
//begin
//   MutationCreateAll;
//   CrossoverAll;
//   GreedySelectionAll;
//   inherited;
//end;

procedure TFA_DE.MutationCreate(i: integer);
 var j:integer;
begin
 for j := 1 to 3 do
  repeat
   r[j]:=Random(fNp);
  until (r[j]<>i);
 for j := 0 to High(fToolKitArr) do
//  Mutation[i][j]:=fToolKitArr[j].DE_Mutation(Parameters[r[1],j],
  ParametersNew[i][j]:=fToolKitArr[j].DE_Mutation(Parameters[r[1],j],
                                                  Parameters[r[2],j],
                                                  Parameters[r[3],j],F);
end;

procedure TFA_DE.MutationCreateAll;
 var i:integer;
begin
  i:=0;
  repeat
   ConditionalRandomize;
   MutationCreate(i);
   try
//    FitnessFunc(Mutation[i]);
    FitnessFunc(ParametersNew[i]);
   except
    Continue;
   end;
    inc(i);
//  until (i>High(Mutation));
  until (i>High(ParametersNew));
end;

procedure TFA_DE.NewPopulationCreate(i: integer);
begin
  Crossover(i);
end;

function TFA_DE.NpDetermination: integer;
begin
 Result:=(fFF.DParamArray.MainParamHighIndex+1)*8;
end;

{ TFA_MABC }

procedure TFA_MABC.CreateFields;
begin
 inherited;
 SetLength(FitnessDataMutation,fNp);
 InitArray(Count,word(fNp),0);
 SetLength(ParametersNew,fFF.DParamArray.MainParamHighIndex+1);
 fDescription:='Modified Artificial Bee Colony';
 Limit:=36;
end;

procedure TFA_MABC.CreateParametersNew(i: integer);
 Label NewSLabel;
 var j,k:integer;
     bool:boolean;
     r:double;
 begin
  NewSLabel:
  repeat
   j:=Random(fNp);
  until (j<>i);
  r:=(-1+Random*2);
  for k := 0 to High(fToolKitArr) do
  ParametersNew[k]:=fToolKitArr[k].DE_Mutation(Parameters[i,k],
                                             Parameters[i,k],
                                             Parameters[j,k],
                                             r);
  bool:=False;
  try
   FitnessDataMutation[i]:=FitnessFunc(ParametersNew)
  except
   bool:=True
  end;
  if bool then goto NewSLabel;
end;

procedure TFA_MABC.EmployedBee;
 var i:integer;
begin
  i:=0;
  repeat
   ConditionalRandomize;
   CreateParametersNew(i);
   if GreedySelection(i,FitnessDataMutation[i],ParametersNew)
      then Count[i]:=0
      else inc(Count[i]);
   inc(i);
  until (i>(fNp-1));
end;

procedure TFA_MABC.IterationAction;
begin
 EmployedBee;
 OnlookersBee;
 ScoutBee;
 inherited;
end;

function TFA_MABC.NpDetermination: integer;
begin
  Result:=(fFF.DParamArray.MainParamHighIndex+1)*8;
end;

procedure TFA_MABC.OnlookersBee;
 var i,j:integer;
     SumFit:double;
begin
  SumFit:=0;   //Onlookers bee
  for I := 0 to fNp - 1 do
    SumFit:=SumFit+1/(1+FitnessData[i]);

  i:=0;//номер   Onlookers bee
  j:=0; // номер джерела меду
  repeat
   ConditionalRandomize;
   if Random<1/(1+FitnessData[j])/SumFit then
      begin
        inc(i);
        CreateParametersNew(j);
        if GreedySelection(j,FitnessDataMutation[j],ParametersNew)
           then Count[j]:=0
      end;    // if Random<1/(1+Fit[j])/SumFit then
       inc(j);
       if j=fNp then j:=0;
     until(i=fNp);     //Onlookers bee
end;

procedure TFA_MABC.ScoutBee;
 var i,j:integer;
begin
  i:=0;
  j:=MinElemNumber(FitnessData);
  repeat
   ConditionalRandomize;
   if (Count[i]>Limit)and(i<>j) then
    begin
     RandomValueToParameter(i);
     try
      FitnessData[i]:=FitnessFunc(Parameters[i]);
     except
      Continue;
     end;
     Count[i]:=0;
     if FitnessData[i]<FitnessData[j] then j:=i;
    end;  // if (Count[i]>Limit)and(i<>j) then
   inc(i);
  until (i>(fNp-1));
end;

{ TFA_PSO }

procedure TFA_PSO.CreateFields;
begin
 inherited CreateFields;
 SetLength(LocBestPar,fNp,fFF.DParamArray.MainParamHighIndex + 1);
 SetLength(Velocity,fNp);
 fDescription:='Particle Swarm Optimization';
 C1:=2;
 C2:=2;
 Wmax:=0.9;
 Wmin:=0.4;
end;

procedure TFA_PSO.DataCoordination;
begin
  ArrayToHeuristicParam(LocBestPar[GlobBestNumb]);
end;

procedure TFA_PSO.IterationAction;
 var temp,W:double;
     i,j:integer;
begin
   temp:=0;
   W:=Wmax-(Wmax-Wmin)*fCurrentIteration/(fFF.fDParamArray as TDParamsIteration).Nit;
   i:=0;
   repeat

    ConditionalRandomize;
    for j := 0 to High(fToolKitArr) do
      Velocity[i,j]:=W*Velocity[i,j]
              +fToolKitArr[j].PSO_Transform(LocBestPar[i,j],Parameters[i,j],C1*Random)
              +fToolKitArr[j].PSO_Transform(LocBestPar[GlobBestNumb,j],Parameters[i,j],C2*Random);

    for j := 0 to High(fToolKitArr) do
     fToolKitArr[j].PSO_Penalty(Parameters[i,j],
                                Velocity[i,j],
                                Parameters[i,j]);

    try
     temp:=FitnessFunc(Parameters[i])
    except
     Continue;
    end;
    if temp<FitnessData[i] then
        begin
         FitnessData[i]:=temp;
         LocBestPar[i]:=Copy(Parameters[i]);
        end;
    inc(i);
   until (i>High(Parameters));
   GlobBestNumb:=MinElemNumber(FitnessData);
  inherited IterationAction;
end;

function TFA_PSO.NpDetermination: integer;
begin
 Result:=(fFF.DParamArray.MainParamHighIndex+1)*15;
end;

procedure TFA_PSO.StartAction;
 var i:integer;
begin
  inherited StartAction;
  GlobBestNumb:=MinElemNumber(FitnessData);
  for I := 0 to High(Parameters)
     do LocBestPar[i]:=Copy(Parameters[i]);
  {початкові значення швидкостей}
  for I := 0 to High(Velocity) do
    InitArray(Velocity[i],word(fFF.DParamArray.MainParamHighIndex + 1),0);
end;

{ TFA_TLBO }

procedure TFA_TLBO.CreateFields;
begin
  inherited CreateFields;
  fDescription:='Teaching Learning Based Optimization';
  SetLength(ParameterMean,fFF.DParamArray.MainParamHighIndex + 1);
  SetLength(ParameterNew,fFF.DParamArray.MainParamHighIndex + 1);
  temp:=1e10;
end;

procedure TFA_TLBO.IterationAction;
begin
  TeacherPhase;
  LearnerPhase;
  inherited;
end;

procedure TFA_TLBO.LearnerPhase;
 var i,k:integer;
begin
  i:=0;
  repeat
   ConditionalRandomize;
   r:=Random;
   repeat
     Tf:=Random(fNp);
    until (Tf<>i);
    if FitnessData[i]>FitnessData[Tf] then r:=-1*r;
    for k := 0 to High(fToolKitArr) do
     ParameterNew[k]:=fToolKitArr[k].DE_Mutation(Parameters[i,k],
                                                 Parameters[i,k],
                                                 Parameters[Tf,k],
                                                 r);
   try
    temp:=FitnessFunc(ParameterNew)
   except
    Continue;
   end;
   GreedySelection(i,temp, ParameterNew);
   inc(i);
  until i>High(FitnessData);
end;

function TFA_TLBO.NpDetermination: integer;
begin
 Result:=1000;
end;

procedure TFA_TLBO.ParameterMeanCalculate;
 var i,k:integer;
begin
 InitArray(ParameterMean,High(ParameterMean)+1,0);
 for I := 0 to fNp-1 do
   for k := 0 to High(fToolKitArr) do
     ParameterMean[k]:=ParameterMean[k]
        +fToolKitArr[k].TLBO_ToMeanValue(Parameters[i,k]);
 for k := 0 to High(fToolKitArr) do
   ParameterMean[k]:=ParameterMean[k]/fNp;
end;

procedure TFA_TLBO.TeacherPhase;
 var j,i,k:integer;
begin
 ParameterMeanCalculate;
 j:=MaxElemNumber(FitnessData);

 i:=0;
 repeat
  ConditionalRandomize;
  if i=j then
    begin
      inc(i);
      Continue;
    end;

  r:=Random;
  Tf:=1+Random(2);
  for k := 0 to High(fToolKitArr) do
   ParameterNew[k]:=fToolKitArr[k].TLBO_Transform(Parameters[i,k],
                                                  Parameters[j,k],
                                                  ParameterMean[k],
                                                  r,Tf);
   try
    temp:=FitnessFunc(ParameterNew);
   except
    Continue;
   end;

   GreedySelection(i,temp, ParameterNew);
   inc(i);
  until i>High(FitnessData);
end;

{ TFFIlluminatedDiode }

function TFFIlluminatedDiode.FittingCalculation: boolean;
begin
  PVparameteres(fDataToFit,fDParamArray);
  fDataToFit.AdditionY(fDParamArray.ParametrByName['Isc'].Value);
  Result:=Inherited FittingCalculation;
  fDParamArray.ParametrByName['Iph'].Value:=fDParamArray.ParametrByName['Iph'].Value
                                           +fDParamArray.ParametrByName['Isc'].Value;
  fDataToFit.AdditionY(-fDParamArray.ParametrByName['Isc'].Value);
end;

procedure TFFIlluminatedDiode.WindowAgentCreate;
begin
 fWindowAgent:=TWindowIterationShowID.Create(Self);
end;

{ TWindowIterationShowID }

procedure TWindowIterationShowID.UpDate;
 var i:byte;
     str:string;
begin
   for I := 0 to fFF.DParamArray.MainParamHighIndex do
    if not(fFF.DParamArray.fParams[i].IsConstant) then
     begin
       if fFF.DParamArray.fParams[i].Name='Iph' then
       str:=floattostrf(fFF.DParamArray.fParams[i].Value
                  +fFF.DParamArray.ParametrByName['Isc'].Value,ffExponent,4,2)
                                               else
       str:=floattostrf(fFF.DParamArray.fParams[i].Value,ffExponent,4,2);
       if str=fLabels[i+fFF.DParamArray.MainParamHighIndex+1].Caption
         then fLabels[i+fFF.DParamArray.MainParamHighIndex+1].Font.Color:=clBlack
         else
           begin
           fLabels[i+fFF.DParamArray.MainParamHighIndex+1].Font.Color:=clRed;
           fLabels[i+fFF.DParamArray.MainParamHighIndex+1].Caption:=str;
           end;
     end;
  fLabels[High(fLabels)].Caption:=IntToStr(fFF.FittingAgent.CurrentIteration);
end;

{ TFFXYSwap }

procedure TFFXYSwap.RealFitting;
begin
 fDataToFit.SwapXY;
 inherited RealFitting;
 fDataToFit.SwapXY;
 FittingData.SwapXY;
end;

procedure TFFXYSwap.RealToFile;
  var Str1:TStringList;
    i:integer;
begin
  if fIntVars[0]<>0 then FileFilling
                    else
   begin
    Str1:=TStringList.Create;
    Str1.Add('X Y Xfit Y');
    for I := 0 to fDataToFit.HighNumber do
      Str1.Add(fDataToFit.PoinToString(i,DigitNumber)
               +' '
               +FittingData.PoinToString(i,DigitNumber));
    Str1.SaveToFile(FitName(fDataToFit,FileSuffix));
    Str1.Free;
   end;
end;

{ TFitnessCalculation }

constructor TFitnessCalculation.Create(FF: TFFHeuristic);
begin
 inherited Create;
 SomeActions(FF);
end;

function TFitnessCalculation.FitnessFunc(const OutputData: TArrSingle): double;
begin
 Result:=0;
end;

procedure TFitnessCalculation.SomeActions(FF:TFFHeuristic);
begin
end;

{ TFitnessCalculationArea }

destructor TFitnessCalculationArea.Destroy;
begin
  fFuncForFitness:=nil;
  FreeAndNil(fDataFitness);
  inherited;
end;

function TFitnessCalculationArea.FitnessFunc(
  const OutputData: TArrSingle): double;
 var i:integer;
begin
  Prepare(OutputData);
  Result:=0;
  for I := 0 to fData.HighNumber-1 do
   begin
     if fDataFitness.X[i]*fDataFitness.X[i+1]<0 then
         Result:=Result+abs((sqr(fDataFitness.X[i])+sqr(fDataFitness.X[i+1]))
                            *(fData.X[i+1]-fData.X[i])
                            /(abs(fDataFitness.X[i])+abs(fDataFitness.X[i+1])))
                                                else
         Result:=Result+abs((fDataFitness.X[i]+fDataFitness.X[i+1])
                            *((fData.X[i+1]-fData.X[i])));
    end;
end;

procedure TFitnessCalculationArea.Prepare(const OutputData:TArrSingle);
 var i:integer;
begin
 for I := 0 to fDataFitness.HighNumber do
    begin
    fDataFitness.Y[i]:=fFuncForFitness(fData.Point[i],OutputData);
    fDataFitness.X[i]:=fDataFitness.Y[i]-fData.Y[i];
    end;
end;

procedure TFitnessCalculationArea.SomeActions(FF:TFFHeuristic);
begin
  inherited;
  fDataFitness:=TVectorTransform.Create(fData);
  fFuncForFitness:=FF.FuncForFitness;
end;

Function FitnessCalculationFactory(FF: TFFHeuristic):TFitnessCalculation;
begin
  if (FF.ParamsHeuristic.FitType in [ftSR..ftRAR])
   then Result:=TFitnessCalculationSum.Create(FF)
   else
    begin
     if FF.ParamsHeuristic.LogFitness
      then Result:=LogFitnessFuncClasses[FF.ParamsHeuristic.FitType].Create(FF)
      else Result:=FitnessFuncClasses[FF.ParamsHeuristic.FitType].Create(FF);
    end;
end;

{ TFitnessCalculationAreaLn }

destructor TFitnessCalculationAreaLn.Destroy;
begin
  FreeAndNil(fDataInit);
  inherited;
end;

procedure TFitnessCalculationAreaLn.Prepare(const OutputData: TArrSingle);
 var i:integer;
begin
 for I := 0 to fDataFitness.HighNumber do
    begin
    fDataFitness.Y[i]:=ln(abs(fFuncForFitness(fDataInit.Point[i],OutputData)));
    fDataFitness.X[i]:=fDataFitness.Y[i]-fData.Y[i];
    end;
end;

procedure TFitnessCalculationAreaLn.SomeActions(FF: TFFHeuristic);
 var i:integer;
begin
  inherited;
 fDataInit:=TVectorTransform.Create(fData);
 fDataInit.DeleteZeroY;
 fDataInit.AbsY(fData);
 for I := 0 to fData.HighNumber do  fData.Y[i]:=ln(fData.Y[i]);
 fData.CopyTo(fDataFitness);
end;

{ TFitnessCalculationData }

destructor TFitnessCalculationData.Destroy;
begin
  FreeAndNil(fData);
  inherited;
end;

procedure TFitnessCalculationData.SomeActions(FF:TFFHeuristic);
begin
  inherited;
  fData:=TVector.Create(FF.DataToFit);
end;

{ TFA_IJAYA }

procedure TFA_IJAYA.AfterNewPopulationCreate;
begin
 KoefDetermination;
end;

procedure TFA_IJAYA.ChaoticEliteLearning(i: integer);
 var mult:double;
     j:integer;
begin
// ConditionalRandomize;
 mult:=Random*(2*Z-1);
 for j := 0 to High(fToolKitArr) do
  ParametersNew[i][j]:=fToolKitArr[j].IJAYA_CEL(Parameters[i,j],
                                                Parameters[NumberBest,j],
                                                mult);
end;

procedure TFA_IJAYA.CreateFields;
begin
 inherited;
// SetLength(FitnessDataNew,fNp);
// SetLength(ParametersNew,fNp,fFF.DParamArray.MainParamHighIndex+1);
 fDescription:='Improved JAYA';
 Z:=Random;
end;

procedure TFA_IJAYA.ExperienceBasedLearning(i: integer);
 var r:double;
     k,l,j:integer;
begin
 repeat
   k:=Random(fNp);
 until (k<>i);
 repeat
   l:=Random(fNp);
 until (l<>i)and(l<>k);
 r:=Random;

 if FitnessData[k]<FitnessData[l]
   then
    for j := 0 to High(fToolKitArr) do
     ParametersNew[i][j]:=fToolKitArr[j].DE_Mutation(Parameters[i,j],
                                                     Parameters[k,j],
                                                     Parameters[l,j],
                                                     r)
   else
    for j := 0 to High(fToolKitArr) do
     ParametersNew[i][j]:=fToolKitArr[j].DE_Mutation(Parameters[i,j],
                                                     Parameters[l,j],
                                                     Parameters[k,j],
                                                     r);
end;

//procedure TFA_IJAYA.GreedySelectionAll;
// var i:integer;
//begin
// for I := 0 to High(FitnessData) do
//   GreedySelection(i,FitnessDataNew[i],ParametersNew[i]);
//end;

//procedure TFA_IJAYA.IterationAction;
//begin
//
////   MutationCreateAll;
////   CrossoverAll;
//  NewPopulationCreateAll;
//  GreedySelectionAll;
//  KoefDetermination;
//  inherited;
//end;

procedure TFA_IJAYA.KoefDetermination;
begin
 NumberBest:=MinElemNumber(FitnessData);
 NumberWorst:=MaxElemNumber(FitnessData);
 if FitnessData[NumberWorst]=0
   then Weight:=1
   else Weight:=sqr(FitnessData[NumberBest]/FitnessData[NumberWorst]);
 Z:=NewZ;
end;

procedure TFA_IJAYA.NewPopulationCreate(i: integer);
begin
  if i=NumberBest then ChaoticEliteLearning(i)
                else
     if Random<Random then SelfAdaptiveWeight(i)
                      else ExperienceBasedLearning(i);
end;

//procedure TFA_IJAYA.NewPopulationCreateAll;
// var i:integer;
//begin
//  i:=0;
//  repeat
//   ConditionalRandomize;
//    if i=NumberBest then ChaoticEliteLearning(i)
//                    else
//         if Random<Random then SelfAdaptiveWeight(i)
//                          else ExperienceBasedLearning(i);
//   try
//    FitnessDataNew[i]:=FitnessFunc(ParametersNew[i]);
//   except
//    Continue;
//   end;
//    inc(i);
//  until (i>High(FitnessDataNew));
//end;

function TFA_IJAYA.NewZ: double;
begin
 Result:=4*Z*(1-Z);
end;

function TFA_IJAYA.NpDetermination: integer;
begin
  Result:=(fFF.DParamArray.MainParamHighIndex+1)*4;
end;

procedure TFA_IJAYA.SelfAdaptiveWeight(i: integer);
 var r1,Wr2:double;
     j:integer;
begin
// ConditionalRandomize;
 r1:=Random;
 Wr2:=Random*Weight;

 for j := 0 to High(fToolKitArr) do
    ParametersNew[i][j]:=fToolKitArr[j].IJAYA_SAW(Parameters[i,j],
                                                  Parameters[NumberBest,j],
                                                  Parameters[NumberWorst,j],
                                                  r1,Wr2);
end;

procedure TFA_IJAYA.StartAction;
begin
  inherited;
  KoefDetermination;
end;

{ TFA_ConsecutiveGeneration }

procedure TFA_ConsecutiveGeneration.AfterNewPopulationCreate;
begin
end;

procedure TFA_ConsecutiveGeneration.BeforeNewPopulationCreate;
begin
end;

procedure TFA_ConsecutiveGeneration.CreateFields;
begin
 inherited;
 SetLength(FitnessDataNew,fNp);
 SetLength(ParametersNew,fNp,fFF.DParamArray.MainParamHighIndex+1);
 VectorForOppositePopulation:=TVector.Create;
 VectorForOppositePopulation.SetLenVector(fNp);
end;

destructor TFA_ConsecutiveGeneration.Destroy;
begin
  FreeAndNil(VectorForOppositePopulation);
  inherited;
end;

procedure TFA_ConsecutiveGeneration.GenerateOppositePopulation(i: integer);
 var j:integer;
begin
 for j := 0 to High(fToolKitArr) do
  ParametersNew[i][j]:=fToolKitArr[j].GetOppPopul(Parameters[i,j]);
end;

procedure TFA_ConsecutiveGeneration.GenerateOppositePopulationAll;
 var i:integer;
     maxFitness:double;
begin
  maxFitness:=FitnessData[MaxElemNumber(FitnessData)];
  i:=0;
  repeat
   ConditionalRandomize;
   GenerateOppositePopulation(i);
   try
    FitnessDataNew[i]:=FitnessFunc(ParametersNew[i]);
   except
    FitnessDataNew[i]:=maxFitness+1;
   end;
    inc(i);
  until (i>High(FitnessDataNew));
  VectorForOppositePopulationFilling;
  VectorForOppositePopulation.Sorting();
//  OppositePopulationSelection;
end;

procedure TFA_ConsecutiveGeneration.GreedySelectionAll;
 var i:integer;
begin
 for I := 0 to High(FitnessData) do
   GreedySelection(i,FitnessDataNew[i],ParametersNew[i]);
end;

procedure TFA_ConsecutiveGeneration.IterationAction;
begin
  BeforeNewPopulationCreate;
  NewPopulationCreateAll;
  GreedySelectionAll;
  AfterNewPopulationCreate;
  inherited;
end;

procedure TFA_ConsecutiveGeneration.NewPopulationCreateAll;
 var i:integer;
begin
  i:=0;
  repeat
   ConditionalRandomize;
   NewPopulationCreate(i);
   try
    FitnessDataNew[i]:=FitnessFunc(ParametersNew[i]);
   except
    Continue;
   end;
    inc(i);
  until (i>High(FitnessDataNew));
end;

procedure TFA_ConsecutiveGeneration.OppositePopulationSelection;
 var i:integer;
begin
  for I := 0 to fNp - 1 do
   begin
     if VectorForOppositePopulation.Y[i]<fNp
       then Parameters[i]:=Copy(Parameters[round(VectorForOppositePopulation.Y[i])])
       else Parameters[i]:=Copy(ParametersNew[round(VectorForOppositePopulation.Y[i]-fNp)]);
     FitnessData[i]:=VectorForOppositePopulation.X[i]
   end;
end;

procedure TFA_ConsecutiveGeneration.VectorForOppositePopulationFilling;
 var i:integer;
begin
 for I := 0 to fNp - 1 do
   begin
    VectorForOppositePopulation.X[i]:=FitnessData[i];
    VectorForOppositePopulation.Y[i]:=i;
    VectorForOppositePopulation.X[i+fNp]:=FitnessDataNew[i];
    VectorForOppositePopulation.Y[i+fNp]:=i+fNp;
   end;
end;

{ TFA_ISCA }

procedure TFA_ISCA.AfterNewPopulationCreate;
begin
 KoefDetermination;
end;

procedure TFA_ISCA.CreateFields;
begin
  inherited;
 inherited;
// SetLength(FitnessDataNew,fNp);
// SetLength(ParametersNew,fNp,fFF.DParamArray.MainParamHighIndex+1);
 fDescription:='Improved sine cosine algorithm';
 Astart:=2;
 Aend:=0;
 Wstart:=1;
 Wend:=0;
 k:=15;
 Jr:=0.1;
end;

procedure TFA_ISCA.GreedySelectionAll;
begin
 if ItIsOppositeGeneration
   then OppositePopulationSelection
//   else GreedySelectionSimple;
   else inherited GreedySelectionAll;
 end;

procedure TFA_ISCA.GreedySelectionSimple;
 var i:integer;
begin
 for I := 0 to fNp do
  begin
    Parameters[i]:=Copy(ParametersNew[i]);
    FitnessData[i]:=FitnessDataNew[i];
  end;
end;

procedure TFA_ISCA.KoefDetermination;
begin
 NumberBest:=MinElemNumber(FitnessData);
 R1:=NewR1();
// RandomKoefDetermination;
 ItIsOppositeGeneration:=(Random<Jr);
 Weight:=NewWeight();
end;

procedure TFA_ISCA.NewPopulationCreate(i: integer);
begin
 SinCosinUpdate(i);
end;

procedure TFA_ISCA.NewPopulationCreateAll;
begin
 if ItIsOppositeGeneration
   then GenerateOppositePopulationAll
   else inherited NewPopulationCreateAll;
end;

function TFA_ISCA.NewR1: double;
begin
 Result:=(Astart-Aend)
   *exp(-sqr(fCurrentIteration/k/(fFF.fDParamArray as TDParamsIteration).Nit))
   +Aend;
end;

function TFA_ISCA.NewWeight: double;
begin
 Result:=Wend+(Wstart-Wend)
 *((fFF.fDParamArray as TDParamsIteration).Nit-fCurrentIteration)/(fFF.fDParamArray as TDParamsIteration).Nit;
end;

function TFA_ISCA.NpDetermination: integer;
begin
   Result:=30;
end;

procedure TFA_ISCA.SinCosinUpdate(i:integer);
 var j:integer;
begin
// if i=NumberBest then  ParametersNew[i]:=Copy(Parameters[i])
//                 else
//   begin
     RandomKoefDetermination;
     for j := 0 to High(fToolKitArr) do
      ParametersNew[i][j]:=fToolKitArr[j].ISCA_Update(Parameters[i,j],
                                                     Parameters[NumberBest,j],
                                                      R1,R2,R3,R4,Weight);
//   end;
end;

procedure TFA_ISCA.StartAction;
begin
  inherited;
  KoefDetermination;
end;

procedure TFA_ISCA.RandomKoefDetermination;
begin
  R2 := Random * 2 * Pi;
  R3 := Random * 2;
  R4 := Random;
end;

end.
