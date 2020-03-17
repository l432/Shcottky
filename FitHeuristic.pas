unit FitHeuristic;

interface

uses
  FitGradient, OlegType, FitIteration, OApproxNew, OlegVector,
  OlegMath, OlegFunction, FitIterationShow, OlegApprox, OlegVectorManipulation;

type

TFFHeuristic=class(TFFIteration)
 private
  function GetParamsHeuristic:TDParamsHeuristic;
 protected
  fPoint:TPointDouble;
  procedure PointDetermine(X:double);
//  procedure TuningBeforeAccessorialDataCreate;override;
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

//TFFIteration =class(TFFVariabSet)
// private
//  fFittingAgent:TFittingAgent;
//  fWindowAgent:TWindowIterationAbstract;
//  procedure WindowAgentCreate;
// protected
//  procedure FittingAgentCreate;virtual;abstract;
//  function FittingCalculation:boolean;override;
//  procedure VariousPreparationBeforeFitting;override;
//  function ParameterCreate:TFFParameter;override;
// public
//  property FittingAgent:TFittingAgent read fFittingAgent;
//end;

TFitnessTerm=class
  fFuncForFitness:TFunObj;
 public
  constructor Create(FF:TFFHeuristic);
//  function Term(X,Y:double;
//                 Parameters:TArrSingle):double;overload;virtual;abstract;
//  function Term(Point:TPointDouble;Parameters:TArrSingle):double;overload;
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
//  FitnessTermClasses:array[TFitnessType]of TFitnessTerm_Class=
  FitnessTermClasses:array[ftSR..ftRAR]of TFitnessTerm_Class=
  (TFitnessTermSR,TFitnessTermRSR,
   TFitnessTermAR,TFitnessTermRAR);

//  LogFitnessTermClasses:array[TFitnessType]of TFitnessTerm_Class=
  LogFitnessTermClasses:array[ftSR..ftRAR]of TFitnessTerm_Class=
  (TFitnessTermLnSR,TFitnessTermLnRSR,
   TFitnessTermLnAR,TFitnessTermLnRAR);


type

//TRegulationZero=class
// public
//  function Term(Parameters:TArrSingle):double;virtual;
//end;

TReTerm=class
  fXmin:double;
  fXmaxXmin:double;
 public
  Number:integer;//порядковий номер в масиві параметрів
  function RegTerm(Arg:double):double;virtual;abstract;
end;

TRegTerm=class(TReTerm)
//  fXmin:double;
//  fXmaxXmin:double;
//  fIsLog:boolean;
 public
//  Number:integer;//порядковий номер в масиві параметрів
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
//  fData:TVector;
  procedure SomeActions(FF:TFFHeuristic);virtual;
 public
  constructor Create(FF:TFFHeuristic);
  Function FitnessFunc(const OutputData:TArrSingle):double;virtual;
//  destructor Destroy;override;
end;

TFitnessCalculationData=class(TFitnessCalculation)
 private
  fData:TVector;
  procedure SomeActions(FF:TFFHeuristic);override;
 public
//  constructor Create(FF:TFFHeuristic);
  destructor Destroy;override;
end;



TFitnessCalculationArea=class(TFitnessCalculationData)
{according to PROGRESS  IN  PHOTOVOLTAICS: RESEARCH  AND APPLICATIONS,  VOL  1,  93-106 (1993) }
 private
  fDataFitness:TVectorTransform;
//  fDataAbs:TVectorTransform;
  fFuncForFitness:TFunObj;
  procedure Prepare(const OutputData:TArrSingle);virtual;
  procedure SomeActions(FF:TFFHeuristic);override;
 public
//  constructor Create(FF:TFFHeuristic);
  Function FitnessFunc(const OutputData:TArrSingle):double;override;
  destructor Destroy;override;
end;

TFitnessCalculationAreaLn=class(TFitnessCalculationArea)
 private
  fDataInit:TVectorTransform;
  procedure Prepare(const OutputData:TArrSingle);override;
  procedure SomeActions(FF:TFFHeuristic);override;
 public
//  constructor Create(FF:TFFHeuristic);
//  Function FitnessFunc(const OutputData:TArrSingle):double;override;
  destructor Destroy;override;
end;

TFitnessCalculationSum=class(TFitnessCalculationData)
 private
//  fData:TVector;
  fFitTerm:TFitnessTerm;
  procedure SomeActions(FF:TFFHeuristic);override;
 public
//  constructor Create(FF:TFFHeuristic);
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
end;


TToolKitLinear=class(TToolKit)
 private
  Xmax_Xmin:double;
  procedure DataSave(const Param: TFFParamHeuristic);override;
 public
//  constructor Create(const Param:TFFParamHeuristic);override;
  function RandValue:double;override;
  procedure Penalty(var X:double);override;
  function DE_Mutation(X1,X2,X3,F:double):double;override;
  function PSO_Transform(X2,X3,F:double):double;override;
  procedure PSO_Penalty(var X:double;var Velocity:double;
                        const Parameter:double);override;
  function TLBO_ToMeanValue(X:double):double;override;
  function TLBO_Transform(X1,X2,Xmean,r:double;Tf:integer):double;override;

end;

TToolKitLog=class(TToolKit)
 private
  lnXmax:double;
  lnXmin:double;
  lnXmax_Xmin:double;
  procedure DataSave(const Param: TFFParamHeuristic);override;
 public
//  constructor Create(const Param:TFFParamHeuristic);override;
  function RandValue:double;override;
  procedure Penalty(var X:double);override;
  function DE_Mutation(X1,X2,X3,F:double):double;override;
  function PSO_Transform(X2,X3,F:double):double;override;
  procedure PSO_Penalty(var X:double;var Velocity:double;
                        const Parameter:double);override;
  function TLBO_ToMeanValue(X:double):double;override;
  function TLBO_Transform(X1,X2,Xmean,r:double;Tf:integer):double;override;

end;

TToolKitConst=class(TToolKit)
 private
  procedure DataSave(const Param: TFFParamHeuristic);override;
 public
//  constructor Create(const Param:TFFParamHeuristic);override;
  function RandValue:double;override;
  procedure Penalty(var X:double);override;
  function DE_Mutation(X1,X2,X3,F:double):double;override;
  function PSO_Transform(X2,X3,F:double):double;override;
  procedure PSO_Penalty(var X:double;var Velocity:double;
                        const Parameter:double);override;
  function TLBO_ToMeanValue(X:double):double;override;
  function TLBO_Transform(X1,X2,Xmean,r:double;Tf:integer):double;override;

end;

TToolKit_Class=class of TToolKit;

const
  ToolKitClasses:array[TVar_RandNew]of TToolKit_Class=
  (TToolKitLinear,TToolKitLog,TToolKitConst);

type


TFA_Heuristic=class(TFittingAgent)
//  fFuncForFitness:TFunObj;
//  fParamsHeuristic:TDParamsHeuristic;
 private
//  fData:TVector;
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
//  procedure Penalty (X:TArrSingle);
//  {перевіряються значення  набору Х}
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


TFA_DE=class(TFA_Heuristic)
 private
  F:double;
  CR:double;
  r:array [1..3] of integer;
  Mutation:TArrArrSingle;
  FitnessDataMutation:TArrSingle;
  function NpDetermination:integer;override;
  procedure MutationCreate(i:integer);
  {створення і-го вектора мутації}
  procedure Crossover(i:integer);
  procedure MutationCreateAll;
  procedure CrossoverAll;
  procedure GreedySelectionAll;
  procedure CreateFields;override;
 public
//  constructor Create(FF:TFFHeuristic);
  procedure IterationAction;override;
//  procedure DataCoordination;override;
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
//  VelocityArhiv:TArrSingle;
//  ParameterArhiv:TArrSingle;
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
//  MaxFitnessData:double;
  r:double;
  Tf:integer;
  temp:double;
//  C1:byte;
//  C2:byte;
//  Wmax:double;
//  Wmin:double;
//  LocBestPar:TArrArrSingle;
//  Velocity:TArrArrSingle;
//  GlobBestNumb:integer;
  ParameterMean:TArrSingle;
  ParameterNew:TArrSingle;
  function NpDetermination:integer;override;
  procedure CreateFields;override;
  procedure ParameterMeanCalculate;
  procedure TeacherPhase;
  procedure LearnerPhase;
 public
  procedure IterationAction;override;
//  procedure StartAction;override;
//  procedure DataCoordination;override;
end;


TFA_Heuristic_Class=class of TFA_Heuristic;

const
  FA_HeuristicClasses:array[TEvolutionTypeNew]of TFA_Heuristic_Class=
  (TFA_DE,TFA_MABC,TFA_TLBO,TFA_PSO);


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
// fFittingAgent:=TFA_DE.Create(Self);
// fFittingAgent:=TFA_MABC.Create(Self);
// fFittingAgent:=TFA_PSO.Create(Self);
// fFittingAgent:=TFA_TLBO.Create(Self);
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
// fPoint[cX]:=X;
// fPoint[cY]:=DataToFit.Yvalue(X);
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
//  if (fNfit mod 100)=0 then Randomize;
  if (fNfit > 100) then
     begin
     Randomize;
     fNfit:=0;
     end;
end;

constructor TFA_Heuristic.Create(FF: TFFHeuristic);
 var i:integer;
begin
 inherited Create;
 fFF:=FF;

// if (FF.ParamsHeuristic.RegWeight=0)
//   then fFitCalcul:=TFitnessCalculation.Create(FF)
//   else fFitCalcul:=TFitnessCalculationWithRegalation.Create(FF);

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
//  FreeAndNil(fRegTerm);
//  FreeAndNil(fFitTerm);
//  FreeAndNil(fData);
  fFF:=nil;
//  fFuncForFitness:=nil;
//  fParamsHeuristic:=nil;
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

//procedure TFA_Heuristic.Penalty(X:TArrSingle);
// var j:integer;
//begin
// ConditionalRandomize;
// for j := 0 to High(fToolKitArr) do
//  fToolKitArr[j].Penalty(X[j]);
//end;

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

//function TFitnessTerm.Term(Point: TPointDouble; Parameters: TArrSingle): double;
//begin
// Result:=Term(Point[cX],Point[cY],Parameters);
//end;

{ TFitnessTermSR }

function TFitnessTermSR.Term(Point:TPointDouble;
                              Parameters:TArrSingle):double;
begin
 Result:=sqr(fFuncForFitness(Point,Parameters)-Point[cY]);
end;

{ TFitnessTermRSR }

function TFitnessTermRSR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
// try
  Result:=sqr((fFuncForFitness(Point,Parameters)-Point[cY])/Point[cY]);
// except
//  Result:=0;
// end;
end;

{ TFitnessTermAR }

function TFitnessTermAR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
 Result:=abs(fFuncForFitness(Point,Parameters)-Point[cY]);
end;

{ TFitnessTermRAR }

function TFitnessTermRAR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
// try
  Result:=abs((fFuncForFitness(Point,Parameters)-Point[cY])/Point[cY]);
// except
//  Result:=0;
// end;
end;

{ TFitnessTermLogSR }

function TFitnessTermLnSR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
// try
  Result:=sqr(ln(fFuncForFitness(Point,Parameters))-ln(Point[cY]));
// except
//  Result:=0;
// end;
end;

{ TFitnessTermLnRSR }

function TFitnessTermLnRSR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
// try
  Result:=sqr((ln(fFuncForFitness(Point,Parameters))-ln(Point[cY]))/ln(Point[cY]));
// except
//  Result:=0;
// end;
end;

{ TFitnessTermLnAR }

function TFitnessTermLnAR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
// try
  Result:=abs(ln(fFuncForFitness(Point,Parameters))-ln(Point[cY]));
// except
//  Result:=0;
// end;
end;

{ TFitnessTermLnRAR }

function TFitnessTermLnRAR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
//  try
  Result:=abs((ln(fFuncForFitness(Point,Parameters))-ln(Point[cY]))/ln(Point[cY]));
// except
//  Result:=0;
// end;
end;

{ TRegTerm }

constructor TRegTerm.Create(const Param: TFFParamHeuristic);
begin
 inherited Create;
// fIsLog:=(Param.Mode=vr_ln);
// if fIsLog then begin
//                 fXmin:=ln(Param.fMinLim);
//                 fXmaxXmin:=ln(Param.fMaxLim)-fXmin;
//                 end
//            else begin
                 fXmin:=Param.fMinLim;
                 fXmaxXmin:=Param.fMaxLim-fXmin;
//                 end
end;

function TRegTerm.RegTerm(Arg: double): double;
begin
// if fIsLog then Result:=(ln(Arg)-fXmin)
//           else
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

//{ TRegulationZero }
//
//function TRegulationZero.Term(Parameters: TArrSingle): double;
//begin
// Result:=0;
//end;

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

//constructor TFitnessCalculationSum.Create(FF: TFFHeuristic);
//begin
// inherited Create(FF);
// if FF.ParamsHeuristic.LogFitness
//  then fFitTerm:=LogFitnessTermClasses[FF.ParamsHeuristic.FitType].Create(FF)
//  else fFitTerm:=FitnessTermClasses[FF.ParamsHeuristic.FitType].Create(FF);
//
//// fData:=TVector.Create(FF.DataToFit);
//// if (FF.ParamsHeuristic.ArgumentType=cY) then fData.SwapXY;
//end;

destructor TFitnessCalculationSum.Destroy;
begin
  FreeAndNil(fFitTerm);
//  FreeAndNil(fData);
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
// Result:=fRegTerm.Term(OutputData)+inherited FitnessFunc(OutputData);
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

//constructor TToolKitLinear.Create(const Param: TFFParamHeuristic);
//begin
// inherited;
////// showmessage('TToolKitLinear');
//// Xmax_Xmin:=Param.fMaxLim-Xmin;
//end;

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
// var temp:double;
begin
 X:=X+Velocity;
 if  not(InRange(X,Xmin,Xmax)) then
  begin
   if X>Xmax then Velocity:=Xmax-Parameter
             else Velocity:=Xmin-Parameter;
   if X>Xmax then X:=Xmax
             else X:=Xmin;
//
//   repeat
//     if X>Xmax then temp:=Xmax-Random*Parameter
//               else temp:=Xmin+Random*Parameter;
//   until InRange(temp,Xmin,Xmax);
//   X:=temp;
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

//constructor TToolKitLog.Create(const Param: TFFParamHeuristic);
//begin
// inherited;
// showmessage('TToolKitLog');
// lnXmax:=Ln(Xmax);
// lnXmin:=ln(Xmin);
// lnXmax_Xmin:=lnXMax-lnXmin;
//end;

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
// Result:=exp(ln(X1)+F*(ln(X2)-ln(X3)));
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

//constructor TToolKitConst.Create(const Param: TFFParamHeuristic);
//begin
// inherited;
// Xmin:=Param.Value;
//end;

procedure TToolKitConst.DataSave(const Param: TFFParamHeuristic);
begin
 inherited;
 Xmin:=Param.Value;
end;

function TToolKitConst.DE_Mutation(X1, X2, X3, F: double): double;
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
  // showmessage('TToolKit');
  Xmin := Param.fMinLim;
  Xmax := Param.fMaxLim;
end;

{ TFA_DE }

//constructor TFA_DE.Create(FF: TFFHeuristic);
//begin
// inherited;
// SetLength(FitnessDataMutation,fNp);
// SetLength(Mutation,fNp,FF.ParamsHeuristic.MainParamHighIndex+1);
// fDescription:='Differential Evolution';
// F:=0.8;
// CR:=0.3;
//end;

procedure TFA_DE.CreateFields;
begin
 inherited;
 SetLength(FitnessDataMutation,fNp);
 SetLength(Mutation,fNp,fFF.DParamArray.MainParamHighIndex+1);
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
     and (j<>r[2]) then Mutation[i,j]:=Parameters[i,j];
end;

procedure TFA_DE.CrossoverAll;
 var i:integer;
//     temp:double;
begin
  i:=0;
  repeat
   ConditionalRandomize;
   Crossover(i);
//   Penalty(Mutation[i]);
   try
    FitnessDataMutation[i]:=FitnessFunc(Mutation[i]);
   except
    Continue;
   end;
    inc(i);
  until (i>High(Mutation));

end;

//procedure TFA_DE.DataCoordination;
//begin
// ArrayToHeuristicParam(Parameters[MinElemNumber(FitnessData)]);
//end;

procedure TFA_DE.GreedySelectionAll;
 var i:integer;
begin
 for I := 0 to High(FitnessData) do
   GreedySelection(i,FitnessDataMutation[i],Mutation[i]);
// if FitnessData[i]>FitnessDataMutation[i] then
//   begin
//    Parameters[i]:=Copy(Mutation[i]);
//    FitnessData[i]:=FitnessDataMutation[i]
//   end;
end;

procedure TFA_DE.IterationAction;
begin
   MutationCreateAll;
   CrossoverAll;
   GreedySelectionAll;
   inherited;
end;

procedure TFA_DE.MutationCreate(i: integer);
 var j:integer;
begin
 for j := 1 to 3 do
  repeat
   r[j]:=Random(fNp);
  until (r[j]<>i);
 for j := 0 to High(fToolKitArr) do
  Mutation[i][j]:=fToolKitArr[j].DE_Mutation(Parameters[r[1],j],
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
//   Penalty(Mutation[i]);
   try
    FitnessFunc(Mutation[i]);
   except
    Continue;
   end;
    inc(i);
  until (i>High(Mutation));
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

//procedure TFA_MABC.DataCoordination;
//begin
//  inherited;
//
//end;

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
//  Penalty(ParametersNew);
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
//LocBestFit-> FitnessData
 SetLength(LocBestPar,fNp,fFF.DParamArray.MainParamHighIndex + 1);
 SetLength(Velocity,fNp);
// SetLength(VelocityArhiv,fFF.DParamArray.MainParamHighIndex + 1);
// SetLength(ParameterArhiv,fFF.DParamArray.MainParamHighIndex + 1);

 fDescription:='Particle Swarm Optimization';
 C1:=2;
 C2:=2;
 Wmax:=0.9;
 Wmin:=0.4;
end;

procedure TFA_PSO.DataCoordination;
begin
//  ArrayToHeuristicParam(LocBestPar[MinElemNumber(FitnessData)]);
  ArrayToHeuristicParam(LocBestPar[GlobBestNumb]);
end;

procedure TFA_PSO.IterationAction;
 var temp,W:double;
     i,j{,k}:integer;
begin
   temp:=0;
   W:=Wmax-(Wmax-Wmin)*fCurrentIteration/(fFF.fDParamArray as TDParamsIteration).Nit;
   i:=0;
//   k:=0;
   repeat

    ConditionalRandomize;
//    VelocityArhiv:=Copy(Velocity[i]);
//    ParameterArhiv:=Copy(Parameters[i]);
    for j := 0 to High(fToolKitArr) do
//      VelocityArhiv[j]:=W*VelocityArhiv[j]
      Velocity[i,j]:=W*Velocity[i,j]
              +fToolKitArr[j].PSO_Transform(LocBestPar[i,j],Parameters[i,j],C1*Random)
              +fToolKitArr[j].PSO_Transform(LocBestPar[GlobBestNumb,j],Parameters[i,j],C2*Random);

    for j := 0 to High(fToolKitArr) do
//     fToolKitArr[j].PSO_Penalty(ParameterArhiv[j],
     fToolKitArr[j].PSO_Penalty(Parameters[i,j],
                                Velocity[i,j],
//                                VelocityArhiv[j],
                                Parameters[i,j]);

    try
//     temp:=FitnessFunc(ParameterArhiv)
     temp:=FitnessFunc(Parameters[i])
    except
//     inc(k);
//     if k>20 then
//         begin
//         RandomValueToParameter(i);
//         k:=0;
//         end;
     Continue;
    end;
//    k:=0;
//    Velocity[i]:=Copy(VelocityArhiv);
//    Parameters[i]:=Copy(ParameterArhiv);
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
//  k:=0;
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
//   Penalty(ParameterNew);
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
//   Penalty(ParameterNew);
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

//destructor TFitnessCalculation.Destroy;
//begin
//  FreeAndNil(fData);
//  inherited;
//end;

function TFitnessCalculation.FitnessFunc(const OutputData: TArrSingle): double;
begin
 Result:=0;
end;

procedure TFitnessCalculation.SomeActions(FF:TFFHeuristic);
begin
end;

{ TFitnessCalculationArea }

//constructor TFitnessCalculationArea.Create(FF: TFFHeuristic);
//begin
// inherited Create(FF);
//
//end;

destructor TFitnessCalculationArea.Destroy;
begin
  fFuncForFitness:=nil;
  FreeAndNil(fDataFitness);
//  FreeAndNil(fDataAbs);
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
//      then Result:=TFitnessCalculationAreaLn.Create(FF)
//      else Result:=TFitnessCalculationArea.Create(FF);
      then Result:=LogFitnessFuncClasses[FF.ParamsHeuristic.FitType].Create(FF)
      else Result:=FitnessFuncClasses[FF.ParamsHeuristic.FitType].Create(FF);
    end;
end;

{ TFitnessCalculationAreaLn }

//constructor TFitnessCalculationAreaLn.Create(FF: TFFHeuristic);
// var i:integer;
//begin
// inherited;
// fDataInit:=TVectorTransform.Create(fData);
// fDataInit.DeleteZeroY;
// fDataInit.AbsY(fData);
// for I := 0 to fData.HighNumber do  fData.Y[i]:=ln(fData.Y[i]);
// fData.CopyTo(fDataFitness);
//end;

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

end.
