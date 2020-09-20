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
  function  ChaoticMutation(Xb,F:double):double;virtual;
 public
  constructor Create(const Param:TFFParamHeuristic);
  function RandValue:double;virtual;abstract;
 {повертає випадкове з інтервалу Xmin-Xmax}
  procedure Penalty(var X:double);virtual;abstract;
 {якщо Х за межами інтервалу, то повертає його туди}
  procedure PenaltySimple(var X:double);virtual;abstract;
  procedure RenaltySHADE(var V:double;Xold:double);virtual;abstract;
  function DE_Mutation(X1,X2,X3,F:double):double;virtual;abstract;
  function DE_Mutation2(X1,X2,X3,X4,X5,F:double):double;virtual;abstract;
  function DE_Mutation3(X1,X2,X3,X4,X5,X6,X7,F:double):double;virtual;abstract;
  function PSO_Transform(X2,X3,F:double):double;virtual;abstract;
  procedure PSO_Penalty(var X:double;var Velocity:double;
                        const Parameter:double);virtual;abstract;
  function TLBO_ToMeanValue(X:double):double;virtual;abstract;
  function TLBO_Transform(X1,X2,Xmean,r:double;Tf:integer):double;virtual;abstract;
  function IJAYA_CEL(Xb,F:double):double;virtual;abstract;
  function IJAYA_SAW(X,Xb,Xw,R1,R2:double):double;virtual;abstract;
  function GetOppPopul(X:double):double;virtual;abstract;
  function GetGenOppPopul(X:double):double;virtual;abstract;
  function ISCA_Update(X,Xb,R1,R2,R3,R4,Weight:double):double;virtual;abstract;
  function STLBO_Teach(Xb,F:double):double;virtual;abstract;
  function NNA_UpdatePattern(Parameters,Weights:TArrArrSingle;
                            j,k:integer):double;virtual;abstract;
   {j - номер набору; k - номер змінної}
  function WOA_SearchFP(X1,X2,A,C:double):double;virtual;abstract;
  function WOA_BubleNA(X,Xb,l:double):double;virtual;abstract;
  function EBLSHADE_Mutation(X,Xbp,Xm,Xw,F:double):double;virtual;abstract;
  function ADELI_Lagrange(Xb,X1,X2,Fitb,Fit1,Fit2:double):double;virtual;abstract;
  function ADELI_LagrangeOtherwise(Xb,X1,X2,Fitb,Fit1,Fit2:double):double;virtual;
  function ADELI_LocalSearch(X,Xpmin,Xpmax:double;Np:integer;ToUp:boolean):double;virtual;abstract;
  function WaterWave_Prop(X,WL:double):double;virtual;abstract;
  function WaterWave_Refrac(X,Xbest:double):double;virtual;abstract;
end;


TToolKitLinear=class(TToolKit)
 private
  Xmax_Xmin:double;
  procedure DataSave(const Param: TFFParamHeuristic);override;
  function  ChaoticMutation(Xb,F:double):double;override;
 public
  function RandValue:double;override;
  procedure Penalty(var X:double);override;
  procedure PenaltySimple(var X:double);override;
  procedure RenaltySHADE(var V:double;Xold:double);override;
  function DE_Mutation(X1,X2,X3,F:double):double;override;
  function DE_Mutation2(X1,X2,X3,X4,X5,F:double):double;override;
  function DE_Mutation3(X1,X2,X3,X4,X5,X6,X7,F:double):double;override;
  function PSO_Transform(X2,X3,F:double):double;override;
  procedure PSO_Penalty(var X:double;var Velocity:double;
                        const Parameter:double);override;
  function TLBO_ToMeanValue(X:double):double;override;
  function TLBO_Transform(X1,X2,Xmean,r:double;Tf:integer):double;override;
  function IJAYA_CEL(Xb,F:double):double;override;
  function IJAYA_SAW(X,Xb,Xw,R1,R2:double):double;override;
  function GetOppPopul(X:double):double;override;
  function GetGenOppPopul(X:double):double;override;
  function ISCA_Update(X,Xb,R1,R2,R3,R4:double;Weight:double=1):double;override;
  function STLBO_Teach(Xb,F:double):double;override;
  function NNA_UpdatePattern(Parameters,Weights:TArrArrSingle;
                            j,k:integer):double;override;
   {j - номер набору; k - номер змінної}
  function WOA_SearchFP(X1,X2,A,C:double):double;override;
  function WOA_BubleNA(X,Xb,l:double):double;override;
  function EBLSHADE_Mutation(X,Xbp,Xm,Xw,F:double):double;override;
  function ADELI_Lagrange(Xb,X1,X2,Fitb,Fit1,Fit2:double):double;override;
  function ADELI_LocalSearch(X,Xpmin,Xpmax:double;Np:integer;ToUp:boolean):double;override;
  function WaterWave_Prop(X,WL:double):double;override;
  function WaterWave_Refrac(X,Xbest:double):double;override;
end;

TToolKitLog=class(TToolKit)
 private
  lnXmax:double;
  lnXmin:double;
  lnXmax_Xmin:double;
  procedure DataSave(const Param: TFFParamHeuristic);override;
  function  ChaoticMutation(Xb,F:double):double;override;
 public
  function RandValue:double;override;
  procedure Penalty(var lnX:double);override;
  procedure PenaltySimple(var lnX:double);override;
  procedure RenaltySHADE(var lnV:double;Xold:double);override;
  function DE_Mutation(X1,X2,X3,F:double):double;override;
  function DE_Mutation2(X1,X2,X3,X4,X5,F:double):double;override;
  function DE_Mutation3(X1,X2,X3,X4,X5,X6,X7,F:double):double;override;
  function PSO_Transform(X2,X3,F:double):double;override;
  procedure PSO_Penalty(var X:double;var Velocity:double;
                        const Parameter:double);override;
  function TLBO_ToMeanValue(X:double):double;override;
  function TLBO_Transform(X1,X2,Xmean,r:double;Tf:integer):double;override;
  function IJAYA_CEL(Xb,F:double):double;override;
  function IJAYA_SAW(X,Xb,Xw,R1,R2:double):double;override;
  function GetOppPopul(X:double):double;override;
  function GetGenOppPopul(X:double):double;override;
  function ISCA_Update(X,Xb,R1,R2,R3,R4:double;Weight:double=1):double;override;
  function STLBO_Teach(Xb,F:double):double;override;
  function NNA_UpdatePattern(Parameters,Weights:TArrArrSingle;
                            j,k:integer):double;override;
   {j - номер набору; k - номер змінної}
  function WOA_SearchFP(X1,X2,A,C:double):double;override;
  function WOA_BubleNA(X,Xb,l:double):double;override;
  function EBLSHADE_Mutation(X,Xbp,Xm,Xw,F:double):double;override;
  function ADELI_LocalSearch(X,Xpmin,Xpmax:double;Np:integer;ToUp:boolean):double;override;
  function ADELI_Lagrange(Xb,X1,X2,Fitb,Fit1,Fit2:double):double;override;
  function WaterWave_Prop(X,WL:double):double;override;
  function WaterWave_Refrac(X,Xbest:double):double;override;
end;

TToolKitConst=class(TToolKit)
 private
  procedure DataSave(const Param: TFFParamHeuristic);override;
 public
  function RandValue:double;override;
  procedure Penalty(var X:double);override;
  procedure PenaltySimple(var X:double);override;
  procedure RenaltySHADE(var V:double;Xold:double);override;
  function DE_Mutation(X1,X2,X3,F:double):double;override;
  function DE_Mutation2(X1,X2,X3,X4,X5,F:double):double;override;
  function DE_Mutation3(X1,X2,X3,X4,X5,X6,X7,F:double):double;override;
  function PSO_Transform(X2,X3,F:double):double;override;
  procedure PSO_Penalty(var X:double;var Velocity:double;
                        const Parameter:double);override;
  function TLBO_ToMeanValue(X:double):double;override;
  function TLBO_Transform(X1,X2,Xmean,r:double;Tf:integer):double;override;
  function IJAYA_CEL(Xb,F:double):double;override;
  function IJAYA_SAW(X,Xb,Xw,R1,R2:double):double;override;
  function GetOppPopul(X:double):double;override;
  function GetGenOppPopul(X:double):double;override;
  function ISCA_Update(X,Xb,R1,R2,R3,R4:double;Weight:double=1):double;override;
  function STLBO_Teach(Xb,F:double):double;override;
  function NNA_UpdatePattern(Parameters,Weights:TArrArrSingle;
                            j,k:integer):double;override;
   {j - номер набору; k - номер змінної}
  function WOA_SearchFP(X1,X2,A,C:double):double;override;
  function WOA_BubleNA(X,Xb,l:double):double;override;
  function EBLSHADE_Mutation(X,Xbp,Xm,Xw,F:double):double;override;
  function ADELI_LocalSearch(X,Xpmin,Xpmax:double;Np:integer;ToUp:boolean):double;override;
  function ADELI_Lagrange(Xb,X1,X2,Fitb,Fit1,Fit2:double):double;override;
  function WaterWave_Prop(X,WL:double):double;override;
  function WaterWave_Refrac(X,Xbest:double):double;override;
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
  fDim:integer;
  {кількість змінних в наборі,
  витягуємо сюди, щоб зручніше}
  fFF:TFFHeuristic;
  fFitCalcul:TFitnessCalculation;
  fToolKitArr:array of TToolKit;
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
                             NewParameter:TArrSingle):boolean;//overload;
//  function GreedySelection(OldParameter,NewParameter:TArrSingle;
//                           var OldFitnessData,NewFitnessData:double):boolean;overload;
//  function GreedySelectionToLocalBest(var OldParameter:TArrSingle;
//                           var OldFitnessData:double;
//                           ItIsAlways:boolean=false):boolean;virtual;
//  {замінює те, що в OldParameter та OldFitnessData кращим з поточних
//  значень в Parameters;
//  при ItIsAlways=true заміна відбувається незалежно від OldFitnessData,
//  при ItIsAlways=falde тільки тоді, коли OldFitnessData більша
//  ніж в кращого з поточних}
 protected
  function GetIstimeToShow:boolean;override;
  procedure ArrayToHeuristicParam(Data:TArrSingle);
 public
  Parameters:TArrArrSingle;
  {набори параметрів}
  FitnessData:TArrSingle;
  {значення цільової функції для різних наборів параметрів}
  property Np:integer read fNp;
  property Dim:integer read fDim;
  constructor Create(FF:TFFHeuristic);
  destructor Destroy;override;
  procedure StartAction;override;
  procedure DataCoordination;override;
end;

TFA_ConsecutiveGeneration=class(TFA_Heuristic)
 private
  GreedySelectionRequired:boolean;
  ParametersNew:TArrArrSingle;
  VectorForOppositePopulation:TVector;
  procedure NewPopulationCreate(i:integer);virtual;abstract;
  procedure GenerateOppositePopulation(i:integer);
  procedure GenerateGeneralOppositePopulation(i:integer);
  procedure GenerateOppositePopulationAll(OnePopulationCreate:TOnePopulationCreate);
  procedure VectorForOppositePopulationFilling;virtual;
  procedure OppositePopulationSelection;
  procedure GreedySelectionAll;virtual;
  procedure CreateFields;override;
  procedure NewPopulationCreateAll;overload;virtual;
  procedure NewPopulationCreateAll(OnePopulationCreate:TOnePopulationCreate;
                                   ToFillFitnessDataNew:boolean=true);overload;virtual;
  procedure BeforeNewPopulationCreate;virtual;
  procedure AfterNewPopulationCreate;virtual;
  procedure KoefDetermination;virtual;
  function LinearDecrease(InitValue,EndValue:double):double;
 public
  FitnessDataNew:TArrSingle;
  procedure IterationAction;override;
  procedure StartAction;override;
  destructor Destroy;override;
  class function LogisticChaoticMap(Z:double):Double;
  class function NewLogisticChaoticMap:Double;
  class function SingerChaoticMap(Z:double):Double;
end;

TFA_WithoutGreedySelection=class(TFA_ConsecutiveGeneration)
{насправді GreedySelection можна ввімкнути,
поставивши GreedySelectionRequired=true в CreateFields}
 private
  GlobalBest:TArrSingle;
  GlobalBestFitness:double;
  procedure CreateFields;override;
  procedure KoefDetermination;override;
  function GreedySelectionToLocalBest(ItIsAlways:boolean=false):integer;virtual;
  {замінює те, що в GlobalBest та GlobalBestFitness кращим з поточних
  значень в Parameters;
  при ItIsAlways=true заміна відбувається незалежно від GlobalBestFitness,
  при ItIsAlways=false тільки тоді, коли GlobalBestFitness більша
  ніж в кращого з поточних;
  якщо заміна відбулася - повертається номер найкращого,
  якщо ні, то -1}
 public
  procedure StartAction;override;
  procedure DataCoordination;override;
end;


//TFA_CWOA=class(TFA_ConsecutiveGeneration)
TFA_CWOA=class(TFA_WithoutGreedySelection)
{Applied Energy 200 (2017) 141–154}
 private
  a:double;
  prob:double;
  Avec,Cvec:double;
//  Prey:TArrSingle;
//  PreyFitness:double;
  function NpDetermination:integer;override;
  procedure UpDate(i:integer);
  procedure SearchForPrey(i:integer);
  procedure BubbleNetAttacking(i:integer);
  procedure CreateFields;override;
  procedure KoefDetermination;override;
  procedure NewPopulationCreate(i:integer);override;
// public
//  procedure StartAction;override;
//  procedure DataCoordination;override;
end;


//TFA_NNA=class(TFA_ConsecutiveGeneration)
TFA_NNA=class(TFA_WithoutGreedySelection)
{Applied Soft Computing 71 (2018) 747–782,
додав GreedySelection - пробував без цього для подвійного діода, виходить гірше}
 private
//  NumberBest:integer;
  Weights:TArrArrSingle;
  GlobalBestWeights:TArrSingle;
  betta:double;
  ItIsBias:boolean;
  function NpDetermination:integer;override;
  procedure KoefDetermination;override;
  function GreedySelectionToLocalBest(ItIsAlways:boolean=false):integer;override;
  procedure NewPopulationCreate(i:integer);override;
  procedure UpdatePattern(i:integer);
  procedure UpdateWeights(i:integer);
  procedure BiasPattern(i:integer);
  procedure TransferFunction(i:integer);
  procedure BiasWeights(i:integer);
  procedure CreateFields;override;
  procedure WeightsInitialization;
  procedure WeightsNormalisation;
  procedure BeforeNewPopulationCreate;override;
  procedure AfterNewPopulationCreate;override;
//  procedure GreedySelectionAll;override;
 public
  procedure StartAction;override;
//  procedure DataCoordination;override;
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
  procedure MutationCreate(i:integer);virtual;
  {створення і-го вектора мутації}
  procedure Crossover(i:integer);
//  procedure MutationCreateAll;
  procedure CreateFields;override;
end;

TDE_Supplementary=class
 private
  fFA_DE:TFA_DE;
 public
  constructor Create(FA_DE:TFA_DE);
  procedure GenerateData();virtual;abstract;
end;

TFandCrCreatorSimple=class(TDE_Supplementary)
 private
//  fFA_DE:TFA_DE;
  Data:TVector;
  {розмір - Np,
  зберігаються значення F (X) та Сr (Y),
  які використовуються в розрахунках}
  function GetF(index:integer):double;
  function GetCr(index:integer):double;
 public
  property F[index:integer]:double read GetF;
  property Cr[index:integer]:double read GetCr;
  constructor Create(FA_DE:TFA_DE);
  destructor Destroy;override;
//  procedure GenerateData();virtual;abstract;
end;

//TADELI_FandCrCreator=class
TADELI_FandCrCreator=class(TFandCrCreatorSimple)
 private
  tau1:double;
  tau2:double;
  Flow:double;
  Fup:double;
 public
  constructor Create(FA_DE:TFA_DE);
  procedure GenerateData();override;
end;

TFA_ADELI=class(TFA_DE)
{Information Sciences 472 (2019) 180–202}
 private
  LR:double;
  LRmin:double;
  LRmax:double;
  ParXLagr:TArrArrSingle;
  {набори параметрів, які використовуються в Лагранжевій інтерполяції}
  FitDataLagr:TArrSingle;
  {значення цільової функції для ParXLagr}
  FandCrCreator:TADELI_FandCrCreator;
  procedure RsearchDetermination;
  procedure LagrangeInterpolation;
  procedure BeforeNewPopulationCreate;override;
  procedure CreateFields;override;
  procedure KoefDetermination;override;
  procedure MutationCreate(i:integer);override;
  procedure NewPopulationCreate(i:integer);override;
 public
  destructor Destroy;override;
end;

TDE_Mem=class
 private
  fk:integer;
  fH:integer;
  Mdata:TVector;
  {розмір - fH,
  зберігаються значення M-коефіцієнтів}
  function GetData(Index:Integer):double;
  procedure SetData(Index: Integer;Value:double);
 public
  property X:double Index ord(cX) read GetData write SetData;
  property Y:double Index ord(cY) read GetData write SetData;
  property Len:integer read fH;
  constructor Create(H:integer=5);
  destructor Destroy;override;
  procedure UpDate;virtual;
  function GetX(i:integer):double;
  function GetY(i:integer):double;
end;

TDE_MemSimple=class(TDE_Mem)
 public
  constructor Create();
  procedure UpDate;override;
end;

//TDE_Memory=class
// private
//  fFA_DE:TFA_DE;
//  fk:integer;
//  fH:integer;
//  Mdata:TVector;
//  {розмір - fH,
//  зберігаються значення M-коефіцієнтів}
// public
//  constructor Create(FA_DE:TFA_DE;H:integer=5);
//  destructor Destroy;override;
//  procedure GenerateData();virtual;abstract;
//  procedure UpDate;virtual;
//end;

TFandCrCreatorCauchyNormal=class(TFandCrCreatorSimple)
 private
  Mem:TDE_Mem;
{ зберігаються значення M-коефіцієнтів,
  на основі яких розраховуються F  та Cr}
  Koef:TVector;
  {розмір - змінний, числу замін у цьому поколінні,
  містить різниці старої та нової цільвої функцій (Х)
  та номер екземляра, для якого ці дані (Y)}
  function GenerateF(mean:double):double;
  function GenerateCr(mean:double):double;
  procedure MemCreate;virtual;
  procedure MemUpDate(sumF2,sumF,sumCr:double);virtual;
 public
  constructor Create(FA_DE:TFA_DE);
  destructor Destroy;override;
//  procedure GenerateData();override;
  function NewIsBetter(const i:integer):boolean;
  procedure UpDate;virtual;
end;

TEBLSHADE_FandCrCreator=class(TFandCrCreatorCauchyNormal)
 private
 public
  procedure GenerateData();override;
end;

TNDE_FandCrCreator=class(TFandCrCreatorCauchyNormal)
 private
  fc:double;
  procedure MemCreate;override;
  procedure MemUpDate(sumF2,sumF,sumCr:double);override;
 public
  constructor Create(FA_DE:TFA_DE);
  procedure GenerateData();override;
end;


//TFandCrCreator=class(TDE_Memory)
// private
//  Data:TVector;
//  {розмір - Np,
//  зберігаються значення F (X) та Сr (Y),
//  які використовуються в розрахунках}
////  Mdata:TVector;
//  {розмір - fH,
//  зберігаються значення M-коефіцієнтів,
//  на основі яких розраховуються F  та Cr}
//  Koef:TVector;
//  {розмір - змінний, числу замін у цьому поколінні,
//  містить різниці старої та нової цільвої функцій (Х)
//  та номер екземляра, для якого ці дані (Y)}
//  function GetF(index:integer):double;
//  function GetCr(index:integer):double;
//  function GenerateF(k:integer):double;
//  function GenerateCr(k:integer):double;
// public
//  property F[index:integer]:double read GetF;
//  property Cr[index:integer]:double read GetCr;
//  constructor Create(FA_DE:TFA_DE;H:integer=5);
//  destructor Destroy;override;
//  procedure GenerateData();override;
//  function NewIsBetter(const i:integer):boolean;
//  procedure UpDate;override;
//end;

TEBLSHADE_FCP=class(TDE_Supplementary)
 private
  Mem:TDE_Mem;
  fLearningRate:double;
  Koef:TVector;
  fIsFirstAlgorithm:array of boolean;
  function GetIsFirstAlgorithm(index:integer):boolean;
 public
  property IsFirstAlgorithm[index:integer]:boolean read GetIsFirstAlgorithm;
  constructor Create(FA_DE:TFA_DE;H:integer=5;LR:double=0.8);
  procedure GenerateData();override;
  procedure UpDate;
  destructor Destroy;override;
  procedure AddData(i:integer);
end;


//TFCP=class(TDE_Memory)
// private
//  fLearningRate:double;
//  Koef:TVector;
//  fIsFirstAlgorithm:array of boolean;
//  function GetIsFirstAlgorithm(index:integer):boolean;
// public
//  property IsFirstAlgorithm[index:integer]:boolean read GetIsFirstAlgorithm;
//  constructor Create(FA_DE:TFA_DE;H:integer=5;LR:double=0.8);
//  procedure GenerateData();override;
//  procedure UpDate;override;
//  destructor Destroy;override;
//  procedure AddData(i:integer);
//end;

TDEArchiv=class
 private
  fFA_DE:TFA_DE;
  fArc_rate:double;
  function GetSize:integer;
  function GetMaxSize:integer;
 public
  Archiv:TArrArrSingle;
  property Size:integer read GetSize;
  {кількість записів у архіві}
  property MaxSize:integer read GetMaxSize;
  constructor Create(FA_DE:TFA_DE;const Arc_rate:double=1);
  procedure AddToArchiv(i:integer);
  procedure ResizeToMaxSize;
end;

TFA_DEcomplex =class(TFA_DE)
 private
  FandCrCreator:TFandCrCreatorCauchyNormal;
  NPinit:integer;
  NPmin:integer;
  function NewNp:integer;
  procedure VectorForOppositePopulationFilling;override;
  procedure KoefDetermination;override;
  procedure Datatransform;
  procedure NewPopulationCreate(i:integer);override;
  procedure GreedySelectionAll;override;
  procedure PopulationReSize;virtual;
  procedure PopulationUpDate(i: Integer);virtual;
  procedure FandCrCreatorCreate;virtual;abstract;
//  procedure MutationCreate(i:integer);override;
 public
//  function NpDetermination:integer;override;
  procedure CreateFields;override;
  destructor Destroy;override;
  procedure DataCoordination;override;
end;


//TFA_EBLSHADE =class(TFA_DE)
TFA_EBLSHADE =class(TFA_DEcomplex)
{Swarm and Evolutionary Computation 50 (2019) 100455}
 private
  Archiv:TDEArchiv;
  FCP:TEBLSHADE_FCP;
//  FandCrCreator:TEBLSHADE_FandCrCreator;
//  NPinit:integer;
//  NPmin:integer;
  p_init:double;
  p_min:double;
  pbestNumber:integer;
  function NewpbestNumber:integer;
//  function NewNp:integer;
//  procedure VectorForOppositePopulationFilling;override;
  procedure KoefDetermination;override;
//  procedure Datatransform;
//  procedure NewPopulationCreate(i:integer);override;
//  procedure GreedySelectionAll;override;
  procedure MutationCreate(i:integer);override;
  procedure FandCrCreatorCreate;override;
  procedure PopulationUpDate(i: Integer);override;
 public
  function NpDetermination:integer;override;
  procedure CreateFields;override;
  destructor Destroy;override;
  procedure DataCoordination;override;
end;


TNDE_neighborhood=class
 private
  fNrsize: integer;
  fNsize: integer;
  procedure SetNrsize(Value:integer);
 public
  Numg: integer;
  Nums: integer;
  fit_best: double;
  fit_worst: double;
  fit_aver: double;
  Std: double;
  fit_bestOld: double;
  fit_worstOld: double;
  fit_averOld: Extended;
  StdOld: Extended;
  Eps1: double;
  nr1: integer;
  nr2: integer;
  Num_best:integer;
  IsNeededToRecalculate:boolean;
  property Nrsize: integer read fNrsize write SetNrsize;
  property Nsize: integer read fNsize;
  constructor Create;
  procedure ClearNum;
  procedure ToOld;
end;


TNDE_neighborhoods=class
 private
  fgm:integer;
  fFA_DE:TFA_DE;
  group_fits:array of double;
  group_index:array of integer;
  fneighborhoods:array of TNDE_neighborhood;
  fStd_aver:double;
  procedure GroupIndexDetermine(i:integer);
  procedure GroupFitsDetermine(i:integer);
  function GetNB(index:integer):TNDE_neighborhood;
 public
  property gm:integer read fgm;
  property Std_aver:double read fStd_aver;
  property NB[index:integer]:TNDE_neighborhood read GetNB;
  constructor Create(FA_DE:TFA_DE);
  destructor Destroy;override;
  procedure IncreaseNrsize(i:integer);
  procedure DataCalculate(i:integer;IsAlways:boolean);
  procedure UpDate;
  procedure DataCalculateAll;
  procedure ReSize;
  procedure ChangeNums;
  procedure CalculateStdaver;
end;

TFA_NDE =class(TFA_DEcomplex)
{Information Sciences 478 (2019) 422–448}
 private
  NBs:TNDE_neighborhoods;
  ParameterTemp:TArrSingle;
  Eps2:double;
  procedure FandCrCreatorCreate;override;
  procedure PopulationReSize;override;
  procedure MutationCreate(i:integer);override;
  procedure AfterNewPopulationCreate;override;
  procedure NDE_IndividualsGenerate(i:integer; IsRandomUsed:boolean);
 public
  function NpDetermination:integer;override;
  procedure CreateFields;override;
  destructor Destroy;override;
end;


TFA_WaterWave=class(TFA_ConsecutiveGeneration)
{Computers & Operations Research 55 (2015) 1–11}
 private
  NumberBest:integer;
  betta_init:double;
  betta_end:double;
  betta:double;
  alpha:double;
  h_max:integer;
  k_max:integer;
  WaveLengths:TArrSingle;
  Amplitudes:array of integer;
  function NpDetermination:integer;override;
  procedure CreateFields;override;
  function NewBetta:double;
  procedure KoefDetermination;override;
  procedure Propagation(i:integer);
  procedure Refraction(i:integer);
  procedure Breaking(i:integer);
  procedure NewPopulationCreate(i:integer);override;
  procedure AfterNewPopulationCreate;override;
  procedure GreedySelectionAll;override;
 public
  procedure DataCoordination;override;
  procedure StartAction;override;
end;

TFA_IJAYA=class(TFA_ConsecutiveGeneration)
// Energy Conversion and Management 150 (2017) 742–753
 private
  NumberBest:integer;
  NumberWorst:integer;
  Weight:double;
  Z:double;
  function NpDetermination:integer;override;
  procedure NewPopulationCreate(i:integer);override;
  procedure KoefDetermination;override;
  procedure ChaoticEliteLearning(i:integer);
  procedure SelfAdaptiveWeight(i:integer);
  procedure ExperienceBasedLearning(i:integer);
  procedure CreateFields;override;
end;


TFA_ISCA=class(TFA_ConsecutiveGeneration)
{ основа - Knowledge-Based Systems 96 (2016) 120–133
покращення - з Expert Systems With Applications 123 (2019) 108–126  (все що там є)
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
  procedure NewPopulationCreate(i:integer);override;
  procedure KoefDetermination;override;
  procedure SinCosinUpdate(i:integer);
  procedure NewPopulationCreateAll;override;
  procedure GreedySelectionAll;override;
  procedure CreateFields;override;
  procedure RandomKoefDetermination;
end;

TFA_TLBO=class(TFA_ConsecutiveGeneration)
//TFA_TLBO=class(TFA_Heuristic)
 private
  NumberBest:integer;
  r:double;
  Tf:integer;
//  temp:double;
  ParameterMean:TArrSingle;
//  ParameterNew:TArrSingle;
  function NpDetermination:integer;override;
  procedure NewPopulationCreate(i:integer);override;
  procedure CreateFields;override;
  procedure KoefDetermination;override;
  procedure BeforeNewPopulationCreate;override;
  procedure ParameterMeanCalculate;
  procedure TeacherPhase(i:integer);
  procedure LearnerPhase(i:integer);
//  procedure TeacherPhase;
//  procedure LearnerPhase;
// public
//  procedure IterationAction;override;
end;


TFA_GOTLBO=class(TFA_TLBO)
{Energy 99 (2016) p.170-180}
 private
 procedure CreateFields;override;
 function NpDetermination:integer;override;
 procedure KoefDetermination;override;
end;

TFA_STLBO=class(TFA_ConsecutiveGeneration)
{International journal of hydrogen energy 39 (2014) p.3837-3854}
 private
  NumberBest:integer;
  NumberWorst:integer;
  NewP:TArrSingle;
  Z:double;
  mu:double;
  function New_mu:double;
  procedure CreateFields;override;
  function NpDetermination:integer;override;
  procedure KoefDetermination;override;
  procedure SimplifiedTeacherPhase;
  procedure BeforeNewPopulationCreate;override;
  procedure LearnerPhase(i:integer);
  procedure NewPopulationCreate(i:integer);override;
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





TFA_Heuristic_Class=class of TFA_Heuristic;

const
  FA_HeuristicClasses:array[TEvolutionTypeNew]of TFA_Heuristic_Class=
  (TFA_DE,TFA_EBLSHADE,TFA_ADELI,TFA_NDE,TFA_MABC,TFA_TLBO,TFA_GOTLBO,TFA_STLBO,
   TFA_PSO,TFA_IJAYA,TFA_ISCA,TFA_NNA,TFA_CWOA,TFA_WaterWave);


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

 fDim:=FF.DParamArray.MainParamHighIndex+1;
 SetLength(fToolKitArr,fDim);
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

//function TFA_Heuristic.GreedySelection(OldParameter, NewParameter: TArrSingle;
//                   var OldFitnessData, NewFitnessData: double): boolean;
//begin
// if OldFitnessData>NewFitnessData then
//   begin
//    OldParameter:=Copy(NewParameter);
//    OldFitnessData:=NewFitnessData;
//    Result:=True;
//   end                             else
//    Result:=False;
//end;

//function TFA_Heuristic.GreedySelectionToLocalBest(var OldParameter: TArrSingle;
//     var OldFitnessData: double; ItIsAlways: boolean): boolean;
// var NumberBest:integer;
//begin
// NumberBest:=MinElemNumber(FitnessData);
// if (ItIsAlways) or (FitnessData[NumberBest]<OldFitnessData) then
//   begin
//    OldParameter:=Copy(Parameters[NumberBest]);
//    OldFitnessData:=FitnessData[NumberBest];
//    Result:=True;
//   end                             else
//    Result:=False;
//end;

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
 for j := 0 to fDim-1 do
  Parameters[i][j]:=fToolKitArr[j].RandValue;
end;

procedure TFA_Heuristic.StartAction;
begin
 inherited StartAction;
 fNfit:=0;
 Initiation;
end;

procedure TFA_Heuristic.CreateFields;
begin
  SetLength(FitnessData, fNp);
  SetLength(Parameters, fNp, fDim);
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
  until (i>=fNp);
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

function TToolKitLinear.ADELI_Lagrange(Xb, X1, X2,Fitb,Fit1,Fit2: double): double;
 var I,a,b:double;
begin
 I:=(X1-Xb)*(X1-X2)*(X2-Xb);
 if I=0
  then  Result:=ADELI_LagrangeOtherwise(Xb, X1, X2,Fitb, Fit1, Fit2)
  else
   begin
     a:=((X2-X1)*Fitb+(Xb-X2)*Fit1+(X1-Xb)*Fit2);
     b:=((sqr(X1)-sqr(X2))*Fitb+(sqr(X2)-sqr(Xb))*Fit1+(sqr(Xb)-sqr(X1))*Fit2);
     if a>0 then Result:=-b/2/a
            else
            if (a=0)and(b=0)
              then Result:=0.5*(X1+X2)+(random-0.5)*(X1-X2)
              else Result:=ADELI_LagrangeOtherwise(Xb, X1, X2,Fitb, Fit1, Fit2);
   end;
 if InRange(Result,Xmin,Xmax) then Exit;
 Result:=RandValue;
end;


function TToolKitLinear.ADELI_LocalSearch(X, Xpmin, Xpmax: double; Np: integer;
               ToUp: boolean): double;
  var R:double;
begin
  R:=(Xpmax-Xpmin)*random/Np;
  if ToUp then Result:=X+R
          else Result:=X-R;
  PenaltySimple(Result);
end;

function TToolKitLinear.ChaoticMutation(Xb, F: double): double;
begin
  Result:=Xb*(1+F);
end;

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

function TToolKitLinear.DE_Mutation2(X1, X2, X3, X4, X5, F: double): double;
begin
 Result:=X1+F*(X2-X3+X4-X5);
end;

function TToolKitLinear.DE_Mutation3(X1, X2, X3, X4, X5, X6, X7,
  F: double): double;
begin
 Result:=X1+F*(X2-X3+X4-X5+X6-X7);
 Penalty(Result);
end;

function TToolKitLinear.EBLSHADE_Mutation(X, Xbp, Xm, Xw, F: double): double;
begin
 Result:=DE_Mutation2(X,Xbp,X,Xm,Xw,F);
 RenaltySHADE(Result,X);
end;

function TToolKitLinear.GetGenOppPopul(X: double): double;
begin
  Result:=Random*(Xmin+Xmax)-X;
  if InRange(Result,Xmin,Xmax)
     then Exit
     else Result:=RandValue;
end;

function TToolKitLinear.GetOppPopul(X: double): double;
begin
 Result:=Xmin+Xmax-X;
end;

function TToolKitLinear.IJAYA_CEL(Xb, F: double): double;
begin
  Result:=ChaoticMutation(Xb, F);
//  Result:=Xb*(1+F);
  Penalty(Result);
end;

function TToolKitLinear.IJAYA_SAW(X, Xb, Xw, R1, R2:double): double;
begin
 Result:=X+R1*(Xb-abs(X))-R2*(Xw-abs(X));
  Penalty(Result);
end;

function TToolKitLinear.ISCA_Update(X, Xb, R1, R2, R3, R4,
  Weight: double): double;
begin
 if R4<0.5 then
   Result:=Weight*X+R1*sin(R2)*abs(R3*Xb-X)
           else
   Result:=Weight*X+R1*cos(R2)*abs(R3*Xb-X);
 Penalty(Result);
end;

function TToolKitLinear.NNA_UpdatePattern(Parameters, Weights: TArrArrSingle;
                       j,k: integer): double;
 var i:integer;
begin
 Result:=Parameters[j,k];
 for I := 0 to High(Parameters) do
     Result:=Result+Weights[i,j]*Parameters[i,k];
  PenaltySimple(Result);
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

procedure TToolKitLinear.PenaltySimple(var X: double);
begin
  X:=EnsureRange(X,Xmin,Xmax);
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

procedure TToolKitLinear.RenaltySHADE(var V: double; Xold: double);
begin
 if InRange(V,Xmin,Xmax) then Exit;
 if V>Xmax then V:=0.5*(Xmax+Xold)
           else V:=0.5*(Xmin+Xold);
end;

function TToolKitLinear.STLBO_Teach(Xb, F: double): double;
begin
  Result:=ChaoticMutation(Xb, F);
  PenaltySimple(Result);
end;

function TToolKitLinear.TLBO_ToMeanValue(X: double): double;
begin
 Result:=X;
end;

function TToolKitLinear.TLBO_Transform(X1, X2, Xmean,r:double;Tf:integer): double;
begin
 Result:=X1+r*(X2-Tf*Xmean);
 PenaltySimple(Result);
end;

function TToolKitLinear.WaterWave_Prop(X, WL:double): double;
begin
 Result:=X+WL*Xmax_Xmin;
 PenaltySimple(Result);
end;

function TToolKitLinear.WaterWave_Refrac(X, Xbest: double): double;
begin
 Result:=RandG((X+Xbest)/2,abs((X-Xbest)/2));
 PenaltySimple(Result);
end;

function TToolKitLinear.WOA_BubleNA(X, Xb, l: double): double;
begin
 Result:=abs(Xb-X)*exp(l)*cos(2*Pi*l)+Xb;
 PenaltySimple(Result);
end;

function TToolKitLinear.WOA_SearchFP(X1, X2, A, C: double): double;
begin
 Result:=X2-A*abs(C*X2-X1);
 PenaltySimple(Result);
end;

{ TToolKitLog }

function TToolKitLog.ADELI_Lagrange(Xb, X1, X2, Fitb, Fit1,
  Fit2: double): double;
 var lnXb,lnX1,lnX2,
     I,a,b:double;
begin
 lnXb:=ln(Xb);
 lnX1:=ln(X1);
 lnX2:=ln(X2);
 I:=(X1-Xb)*(X1-X2)*(X2-Xb);
 if I=0
  then  Result:=ADELI_LagrangeOtherwise(lnXb, lnX1, lnX2,Fitb, Fit1, Fit2)
  else
   begin
     a:=((lnX2-lnX1)*Fitb+(lnXb-lnX2)*Fit1+(lnX1-lnXb)*Fit2);
     b:=((sqr(lnX1)-sqr(lnX2))*Fitb+(sqr(lnX2)-sqr(lnXb))*Fit1+(sqr(lnXb)-sqr(lnX1))*Fit2);
     if a>0 then Result:=-b/2/a
            else
            if (a=0)and(b=0)
              then Result:=0.5*(lnX1+lnX2)+(random-0.5)*(lnX1-lnX2)
              else Result:=ADELI_LagrangeOtherwise(lnXb, lnX1, lnX2,Fitb, Fit1, Fit2);
   end;
 if InRange(Result,lnXmin,lnXmax)
   then Result:=exp(Result)
   else Result:=RandValue;
end;


function TToolKitLog.ADELI_LocalSearch(X, Xpmin, Xpmax: double; Np: integer;
  ToUp: boolean): double;
  var R:double;
begin
 R:=(ln(Xpmax)-ln(Xpmin))*random/Np;
 if ToUp then Result:=ln(X)+R
         else Result:=ln(X)-R;
 PenaltySimple(Result);
 Result:=exp(Result);
end;

function TToolKitLog.ChaoticMutation(Xb, F: double): double;
begin
 Result:=ln(Xb)*(1+F);
end;

procedure TToolKitLog.DataSave(const Param: TFFParamHeuristic);
begin
 inherited;
 lnXmax:=Ln(Xmax);
 lnXmin:=ln(Xmin);
 lnXmax_Xmin:=lnXMax-lnXmin;
end;

function TToolKitLog.DE_Mutation(X1, X2, X3, F: double): double;
// var temp:double;
begin
 Result:=ln(X1)+F*(ln(X2)-ln(X3));
 Penalty(Result);
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
// Result:=exp(temp);
 Result:=exp(Result);
end;

function TToolKitLog.DE_Mutation2(X1, X2, X3, X4, X5, F: double): double;
begin
 Result:=ln(X1)+F*(ln(X2)-ln(X3)+ln(X4)-ln(X5));
end;

function TToolKitLog.DE_Mutation3(X1, X2, X3, X4, X5, X6, X7,
  F: double): double;
begin
 Result:=ln(X1)+F*(ln(X2)-ln(X3)+ln(X4)-ln(X5)+ln(X6)+ln(X7));
 Penalty(Result);
 Result:=exp(Result);
end;

function TToolKitLog.EBLSHADE_Mutation(X, Xbp, Xm, Xw, F: double): double;
begin
 Result:=DE_Mutation2(X,Xbp,X,Xm,Xw,F);
 RenaltySHADE(Result,X);
 Result:=exp(Result);
end;

function TToolKitLog.GetGenOppPopul(X: double): double;
begin
 Result:=Random*(lnXmin+lnXmax)-ln(X);
 if InRange(Result,lnXmin,lnXmax)
    then Result:=exp(Result)
    else Result:=RandValue;
end;

function TToolKitLog.GetOppPopul(X: double): double;
begin
 Result:=lnXmin+lnXmax-ln(X);
 Result:=exp(Result);
end;

function TToolKitLog.IJAYA_CEL(Xb, F: double): double;
begin
  Result:=ChaoticMutation(Xb, F);
//  Result:=ln(Xb)*(1+F);
  Penalty(Result);
 Result:=exp(Result);
end;

function TToolKitLog.IJAYA_SAW(X, Xb, Xw, R1, R2:double): double;
begin
 Result:=ln(X)+R1*(ln(Xb)-abs(ln(X)))-R2*(ln(Xw)-abs(ln(X)));
 Penalty(Result);
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

 Penalty(Result);
 Result:=exp(Result);
end;

function TToolKitLog.NNA_UpdatePattern(Parameters, Weights: TArrArrSingle; j,
  k: integer): double;
 var i:integer;
begin
 Result:=ln(Parameters[j,k]);
 for I := 0 to High(Parameters) do
     Result:=Result+Weights[i,j]*ln(Parameters[i,k]);
 PenaltySimple(Result);
 Result:=exp(Result);
end;

procedure TToolKitLog.Penalty(var lnX: double);
 var temp:double;
begin
 if InRange(lnX,lnXmin,lnXmax) then Exit;
 if not(InRange(lnX,lnXmin-lnXmax_Xmin,lnXmax+lnXmax_Xmin))
    then
      begin
       lnX:=ln(RandValue);
       Exit;
      end;
 repeat
    if lnX>lnXmax then temp:=lnX-Random*lnXmax_Xmin
                  else temp:=lnX+Random*lnXmax_Xmin;
    if InRange(temp,lnXmin,lnXmax) then  Break;
 until False;
 lnX:=temp;
end;

procedure TToolKitLog.PenaltySimple(var lnX: double);
begin
 lnX:=EnsureRange(lnX,lnXmin,lnXmax);
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

procedure TToolKitLog.RenaltySHADE(var lnV: double; Xold: double);
begin
 if InRange(lnV,lnXmin,lnXmax) then Exit;
 if lnV>lnXmax then lnV:=0.5*(lnXmax+ln(Xold))
               else lnV:=0.5*(lnXmin+ln(Xold));
end;

function TToolKitLog.STLBO_Teach(Xb, F: double): double;
begin
 Result:=ChaoticMutation(Xb, F);
 PenaltySimple(Result);
 Result:=exp(Result);
end;

function TToolKitLog.TLBO_ToMeanValue(X: double): double;
begin
 Result:=ln(X);
end;

function TToolKitLog.TLBO_Transform(X1, X2, Xmean,r:double;Tf:integer): double;
// var temp:double;
begin
 Result:=ln(X1)+r*(ln(X2)-Tf*Xmean);
 PenaltySimple(Result);
 Result:=exp(Result)
end;

function TToolKitLog.WaterWave_Prop(X, WL:double): double;
begin
 Result:=ln(X)+WL*lnXmax_Xmin;
 PenaltySimple(Result);
 Result:=exp(Result)
end;

function TToolKitLog.WaterWave_Refrac(X, Xbest: double): double;
 var lnX,lnXb:double;
begin
 lnXb:=ln(Xbest);
 lnX:=ln(X);
 Result:=RandG((lnX+lnXb)/2,abs((lnX-lnXb)/2));
 PenaltySimple(Result);
 Result:=exp(Result)
end;

function TToolKitLog.WOA_BubleNA(X, Xb, l: double): double;
 var lnXb:double;
begin
 lnXb:=ln(Xb);
 Result:=abs(lnXb-ln(X))*exp(l)*cos(2*Pi*l)+lnXb;
 PenaltySimple(Result);
 Result:=exp(Result)
end;

function TToolKitLog.WOA_SearchFP(X1, X2, A, C: double): double;
 var lnX2:double;
begin
 lnX2:=ln(X2);
 Result:=lnX2-A*abs(C*lnX2-ln(X1));
 PenaltySimple(Result);
 Result:=exp(Result)
end;

{ TToolKitConst }

function TToolKitConst.ADELI_Lagrange(Xb, X1, X2, Fitb, Fit1,
  Fit2: double): double;
begin
 Result:=Xmin;
end;

function TToolKitConst.ADELI_LocalSearch(X, Xpmin, Xpmax: double; Np: integer;
  ToUp: boolean): double;
begin
 Result:=Xmin;
end;

procedure TToolKitConst.DataSave(const Param: TFFParamHeuristic);
begin
 inherited;
 Xmin:=Param.Value;
end;

function TToolKitConst.DE_Mutation(X1, X2, X3, F: double): double;
begin
 Result:=Xmin;
end;

function TToolKitConst.DE_Mutation2(X1, X2, X3, X4, X5, F: double): double;
begin
 Result:=Xmin;
end;

function TToolKitConst.DE_Mutation3(X1, X2, X3, X4, X5, X6, X7,
  F: double): double;
begin
  Result:=Xmin;
end;

function TToolKitConst.EBLSHADE_Mutation(X, Xbp, Xm, Xw, F: double): double;
begin
 Result:=Xmin;
end;

function TToolKitConst.GetGenOppPopul(X: double): double;
begin
 Result:=Xmin;
end;

function TToolKitConst.GetOppPopul(X: double): double;
begin
 Result:=Xmin;
end;

function TToolKitConst.IJAYA_CEL(Xb, F: double): double;
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

function TToolKitConst.NNA_UpdatePattern(Parameters, Weights: TArrArrSingle; j,
  k: integer): double;
begin
 Result:=Xmin;
end;

procedure TToolKitConst.Penalty(var X: double);
begin
end;

procedure TToolKitConst.PenaltySimple(var X: double);
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

procedure TToolKitConst.RenaltySHADE(var V: double; Xold: double);
begin
end;

function TToolKitConst.STLBO_Teach(Xb, F: double): double;
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

function TToolKitConst.WaterWave_Prop(X, WL:double): double;
begin
 Result:=Xmin;
end;

function TToolKitConst.WaterWave_Refrac(X, Xbest: double): double;
begin
 Result:=Xmin;
end;

function TToolKitConst.WOA_BubleNA(X, Xb, l: double): double;
begin
 Result:=Xmin;
end;

function TToolKitConst.WOA_SearchFP(X1, X2, A, C: double): double;
begin
 Result:=Xmin;
end;

{ TToolKit }

function TToolKit.ADELI_LagrangeOtherwise(Xb, X1, X2, Fitb, Fit1,
  Fit2: double): double;
 const c3=0.25;
       c4=0.25;
 var Xj:TVector;
begin
  Xj:=TVector.Create;
  Xj.Add(Fitb,Xb);
  Xj.Add(Fit1,X1);
  Xj.Add(Fit2,X2);
  Xj.Sorting;
  Result:=Xj.Y[0]+random*c3*(Xj.Y[0]-Xj.Y[1])
                 +random*c4*(Xj.Y[0]-Xj.Y[2]);
  FreeAndNil(Xj);
//  Xj.Free;
end;

function TToolKit.ChaoticMutation(Xb, F: double): double;
begin
 Result:=0;
end;

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
 NewPopulationCreateAll(MutationCreate,false);
// MutationCreateAll;
end;

procedure TFA_DE.CreateFields;
begin
 inherited CreateFields;
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
  ParametersNew[i][j]:=fToolKitArr[j].DE_Mutation(Parameters[r[1],j],
                                                  Parameters[r[2],j],
                                                  Parameters[r[3],j],F);
end;

//procedure TFA_DE.MutationCreateAll;
// var i:integer;
//begin
//  i:=0;
//  repeat
//   ConditionalRandomize;
//   MutationCreate(i);
//   try
//    FitnessFunc(ParametersNew[i]);
//   except
//    Continue;
//   end;
//    inc(i);
//  until (i>High(ParametersNew));
//end;

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
//   temp:=0;
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

procedure TFA_TLBO.BeforeNewPopulationCreate;
begin
  NewPopulationCreateAll(TeacherPhase);
  GreedySelectionAll;
end;

procedure TFA_TLBO.CreateFields;
begin
  inherited CreateFields;
  fDescription:='Teaching Learning Based Optimization';
  SetLength(ParameterMean,fFF.DParamArray.MainParamHighIndex + 1);
//  SetLength(ParameterNew,fFF.DParamArray.MainParamHighIndex + 1);
//  temp:=1e10;
end;

//procedure TFA_TLBO.IterationAction;
//begin
//  TeacherPhase;
//  LearnerPhase;
//  inherited IterationAction;
//end;

procedure TFA_TLBO.KoefDetermination;
begin
  NumberBest:=MinElemNumber(FitnessData);
  ParameterMeanCalculate;
end;

procedure TFA_TLBO.LearnerPhase(i: integer);
 var k:integer;
begin
  r:=Random;
  repeat
   Tf:=Random(fNp);
  until (Tf<>i);
  if FitnessData[i]>FitnessData[Tf] then r:=-1*r;
  for k := 0 to High(fToolKitArr) do
   ParametersNew[i,k]:=fToolKitArr[k].DE_Mutation(Parameters[i,k],
                                               Parameters[i,k],
                                               Parameters[Tf,k],
                                               r);
end;

//procedure TFA_TLBO.LearnerPhase;
// var i,k:integer;
//begin
//  i:=0;
//  repeat
//   ConditionalRandomize;
//   r:=Random;
//   repeat
//     Tf:=Random(fNp);
//    until (Tf<>i);
//    if FitnessData[i]>FitnessData[Tf] then r:=-1*r;
//    for k := 0 to High(fToolKitArr) do
//     ParameterNew[k]:=fToolKitArr[k].DE_Mutation(Parameters[i,k],
//                                                 Parameters[i,k],
//                                                 Parameters[Tf,k],
//                                                 r);
//   try
//    temp:=FitnessFunc(ParameterNew)
//   except
//    Continue;
//   end;
//   GreedySelection(i,temp, ParameterNew);
//   inc(i);
//  until i>High(FitnessData);
//end;

procedure TFA_TLBO.NewPopulationCreate(i: integer);
begin
  LearnerPhase(i);
end;

function TFA_TLBO.NpDetermination: integer;
begin
 Result:=100;
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

procedure TFA_TLBO.TeacherPhase(i: integer);
 var k:integer;
begin
  if i=NumberBest
   then ParametersNew[i]:=Copy(Parameters[i])
   else
    begin
    r:=Random;
    Tf:=1+Random(2);
    for k := 0 to High(fToolKitArr) do
    ParametersNew[i,k]:=fToolKitArr[k].TLBO_Transform(Parameters[i,k],
                                                  Parameters[NumberBest,k],
                                                  ParameterMean[k],
                                                  r,Tf);
    end;
end;

//procedure TFA_TLBO.TeacherPhase;
// var j,i,k:integer;
//begin
// ParameterMeanCalculate;
// j:=MinElemNumber(FitnessData);
//
// i:=0;
// repeat
//  ConditionalRandomize;
//  if i=j then
//    begin
//      inc(i);
//      Continue;
//    end;
//
//  r:=Random;
//  Tf:=1+Random(2);
//  for k := 0 to High(fToolKitArr) do
//   ParameterNew[k]:=fToolKitArr[k].TLBO_Transform(Parameters[i,k],
//                                                  Parameters[j,k],
//                                                  ParameterMean[k],
//                                                  r,Tf);
//   try
//    temp:=FitnessFunc(ParameterNew);
//   except
//    Continue;
//   end;
//
//   GreedySelection(i,temp, ParameterNew);
//   inc(i);
//  until i>High(FitnessData);
//end;

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

//procedure TFA_IJAYA.AfterNewPopulationCreate;
//begin
// KoefDetermination;
//end;

procedure TFA_IJAYA.ChaoticEliteLearning(i: integer);
 var mult:double;
     j:integer;
begin
// ConditionalRandomize;
 mult:=Random*(2*Z-1);
 for j := 0 to High(fToolKitArr) do
  ParametersNew[i][j]:=fToolKitArr[j].IJAYA_CEL(Parameters[i,j],
                                                mult);
end;

procedure TFA_IJAYA.CreateFields;
begin
 inherited;
 fDescription:='Improved JAYA';
 Z:=NewLogisticChaoticMap;
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
 Z:=LogisticChaoticMap(Z);
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

//function TFA_IJAYA.NewZ: double;
//begin
// Result:=4*Z*(1-Z);
//end;

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

//procedure TFA_IJAYA.StartAction;
//begin
//  inherited StartAction;
//  KoefDetermination;
//end;

{ TFA_ConsecutiveGeneration }

procedure TFA_ConsecutiveGeneration.AfterNewPopulationCreate;
begin
end;

procedure TFA_ConsecutiveGeneration.BeforeNewPopulationCreate;
begin
end;

procedure TFA_ConsecutiveGeneration.CreateFields;
begin
 inherited CreateFields;
 SetLength(FitnessDataNew,fNp);
 SetLength(ParametersNew,fNp,fDim);
 GreedySelectionRequired:=true;
 VectorForOppositePopulation:=TVector.Create;
 VectorForOppositePopulation.SetLenVector(2*fNp);
end;

destructor TFA_ConsecutiveGeneration.Destroy;
begin
  FreeAndNil(VectorForOppositePopulation);
  inherited;
end;

procedure TFA_ConsecutiveGeneration.GenerateGeneralOppositePopulation(
  i: integer);
 var j:integer;
begin
 for j := 0 to fDim-1 do
  ParametersNew[i][j]:=fToolKitArr[j].GetGenOppPopul(Parameters[i,j]);
end;

procedure TFA_ConsecutiveGeneration.GenerateOppositePopulation(i: integer);
 var j:integer;
begin
 for j := 0 to fDim-1 do
  ParametersNew[i][j]:=fToolKitArr[j].GetOppPopul(Parameters[i,j]);
end;

procedure TFA_ConsecutiveGeneration.GenerateOppositePopulationAll(OnePopulationCreate:TOnePopulationCreate);
 var i:integer;
     maxFitness:double;
begin
  maxFitness:=FitnessData[MaxElemNumber(FitnessData)];
  i:=0;
  repeat
   ConditionalRandomize;
   OnePopulationCreate(i);
   try
    FitnessDataNew[i]:=FitnessFunc(ParametersNew[i]);
   except
    FitnessDataNew[i]:=maxFitness+1;
   end;
    inc(i);
  until (i>=fNp);
  VectorForOppositePopulationFilling;
  VectorForOppositePopulation.Sorting();
//  OppositePopulationSelection;
end;

procedure TFA_ConsecutiveGeneration.GreedySelectionAll;
 var i:integer;
begin
 if GreedySelectionRequired then
   for I := 0 to fNp-1 do
     GreedySelection(i,FitnessDataNew[i],ParametersNew[i])
                            else
   for I := 0 to fNp-1 do
    begin
     Parameters[i]:=Copy(ParametersNew[i]);
     FitnessData[i]:=FitnessDataNew[i];
    end;
end;

procedure TFA_ConsecutiveGeneration.IterationAction;
begin
  BeforeNewPopulationCreate;
  NewPopulationCreateAll;
  GreedySelectionAll;
  AfterNewPopulationCreate;
  KoefDetermination;
  inherited IterationAction;
end;

procedure TFA_ConsecutiveGeneration.KoefDetermination;
begin
end;

function TFA_ConsecutiveGeneration.LinearDecrease(InitValue,EndValue:double): double;
begin
 Result:=(EndValue-InitValue)*fCurrentIteration
          /(fFF.fDParamArray as TDParamsIteration).Nit
            +InitValue
end;

class function TFA_ConsecutiveGeneration.LogisticChaoticMap(Z: double): Double;
begin
 Result:=4*Z*(1-Z);
end;

class function TFA_ConsecutiveGeneration.NewLogisticChaoticMap: Double;
begin
 repeat
  Result:=Random;
 until not((Result=0.25)or(Result=0.5)or(Result=0.75)or(Result=1));
end;

procedure TFA_ConsecutiveGeneration.NewPopulationCreateAll(
                            OnePopulationCreate: TOnePopulationCreate;
                            ToFillFitnessDataNew:boolean=true);
 var i:integer;
begin
  i:=0;
  repeat
   ConditionalRandomize;
   OnePopulationCreate(i);
   try
    if ToFillFitnessDataNew
      then FitnessDataNew[i]:=FitnessFunc(ParametersNew[i])
      else FitnessFunc(ParametersNew[i])
   except
    Continue;
   end;
    inc(i);
  until (i>=fNp);
end;

procedure TFA_ConsecutiveGeneration.NewPopulationCreateAll;
// var i:integer;
begin
  NewPopulationCreateAll(NewPopulationCreate);
//  i:=0;
//  repeat
//   ConditionalRandomize;
//   NewPopulationCreate(i);
//   try
//    FitnessDataNew[i]:=FitnessFunc(ParametersNew[i]);
//   except
//    Continue;
//   end;
//    inc(i);
//  until (i>High(FitnessDataNew));
end;

procedure TFA_ConsecutiveGeneration.OppositePopulationSelection;
 var i,j,Num:integer;
     Vec:TVector;
begin
  Vec:=TVector.Create;
  Vec.SetLenVector(fNp);
  for I := 0 to fNp - 1 do
    begin
    Vec.X[i]:=i;
    Vec.Y[i]:=i;
    end;

  for I := 0 to fNp - 1 do
     if VectorForOppositePopulation.Y[i]<fNp
       then Vec.Y[round(VectorForOppositePopulation.Y[i])]:=-1;

  for I := 0 to fNp - 1 do
     begin
      Num:=round(VectorForOppositePopulation.Y[i]);
      if Num>=fNp then
        begin
          Num:=Num-fNp;
          for j := 0 to fNp - 1 do
             if Vec.Y[j]>=0 then
               begin
                Parameters[j]:=Copy(ParametersNew[Num]);
                FitnessData[j]:=VectorForOppositePopulation.X[i];
                Vec.Y[j]:=-1;
                Break;
               end;
        end;
     end;


//  for I := 0 to fNp - 1 do
//   begin
//     if VectorForOppositePopulation.Y[i]<fNp
//       then Parameters[i]:=Copy(Parameters[round(VectorForOppositePopulation.Y[i])])
//       else Parameters[i]:=Copy(ParametersNew[round(VectorForOppositePopulation.Y[i]-fNp)]);
//     FitnessData[i]:=VectorForOppositePopulation.X[i]
//   end;
  FreeAndNil(Vec);
end;

class function TFA_ConsecutiveGeneration.SingerChaoticMap(Z: double): Double;
begin
 Result:=z*(7.86+Z*(-23.31+Z*(28.75-13.3*Z)));
end;

procedure TFA_ConsecutiveGeneration.StartAction;
begin
  inherited StartAction;
  KoefDetermination;
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

//procedure TFA_ISCA.AfterNewPopulationCreate;
//begin
// KoefDetermination;
//end;

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

//procedure TFA_ISCA.GreedySelectionSimple;
// var i:integer;
//begin
// for I := 0 to fNp do
//  begin
//    Parameters[i]:=Copy(ParametersNew[i]);
//    FitnessData[i]:=FitnessDataNew[i];
//  end;
//end;

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
   then GenerateOppositePopulationAll(GenerateOppositePopulation)
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

//procedure TFA_ISCA.StartAction;
//begin
//  inherited;
//  KoefDetermination;
//end;

procedure TFA_ISCA.RandomKoefDetermination;
begin
  R2 := Random * 2 * Pi;
  R3 := Random * 2;
  R4 := Random;
end;

{ TFA_GOTLBO }

procedure TFA_GOTLBO.CreateFields;
begin
  inherited;
    fDescription:='Generalized Oppositional TLBO';
end;

procedure TFA_GOTLBO.KoefDetermination;
begin
  GenerateOppositePopulationAll(GenerateGeneralOppositePopulation);
  OppositePopulationSelection;
  inherited KoefDetermination;
end;

function TFA_GOTLBO.NpDetermination: integer;
begin
  Result:=20;
end;

{ TFA_STLBO }

procedure TFA_STLBO.BeforeNewPopulationCreate;
begin
 SimplifiedTeacherPhase;
end;

procedure TFA_STLBO.CreateFields;
begin
 inherited;
 fDescription:='Simplified TLBO';
 SetLength(NewP,fFF.DParamArray.MainParamHighIndex+1);
 Z:=NewLogisticChaoticMap;
end;

procedure TFA_STLBO.KoefDetermination;
begin
 inherited;
 NumberBest:=MinElemNumber(FitnessData);
 NumberWorst:=MaxElemNumber(FitnessData);
 Z:=LogisticChaoticMap(Z);
 mu:=New_mu;
end;

procedure TFA_STLBO.LearnerPhase(i: integer);
 var k,m,n:integer;
     r:double;
begin
  r:=Random;
  repeat
   m:=Random(fNp);
  until (m<>i);
  repeat
   n:=Random(fNp);
  until (n<>i)and(n<>m);
  
  if FitnessData[m]>FitnessData[n] then r:=-1*r;
  for k := 0 to High(fToolKitArr) do
   ParametersNew[i,k]:=fToolKitArr[k].DE_Mutation(Parameters[i,k],
                                               Parameters[m,k],
                                               Parameters[n,k],
                                               r);
end;

procedure TFA_STLBO.NewPopulationCreate(i: integer);
begin
 LearnerPhase(i);
end;

function TFA_STLBO.New_mu: double;
begin
  Result:=1-fCurrentIteration/(fFF.fDParamArray as TDParamsIteration).Nit;
end;

function TFA_STLBO.NpDetermination: integer;
begin
  Result:=20;
end;

procedure TFA_STLBO.SimplifiedTeacherPhase;
 var mult:double;
     j:integer;
begin
 mult:=(2*Z-1);
 for j := 0 to High(fToolKitArr) do
  if Random<mu then
   NewP[j]:=fToolKitArr[j].STLBO_Teach(Parameters[NumberBest,j],
                                                mult)
                else
   NewP[j]:=Parameters[NumberBest,j];
 try
  mult:=FitnessFunc(NewP);
 except
  Exit;
 end;  
  GreedySelection(NumberWorst,mult,NewP);
end;

{ TFA_NNA }

procedure TFA_NNA.AfterNewPopulationCreate;
 var i:integer;
begin
 if ItIsBias then
  begin
   for I := 0 to fNp - 1 do
     BiasWeights(i);
   WeightsNormalisation;
  end;
end;

procedure TFA_NNA.BeforeNewPopulationCreate;
 var i:integer;
begin
 Randomize;
 for I := 0 to fNp - 1 do
  begin
   UpdatePattern(i);
   UpdateWeights(i);
  end;
 WeightsNormalisation;
 ItIsBias:=(Random<=betta);
end;

procedure TFA_NNA.BiasPattern(i: integer);
 var j,number:integer;
begin
 for j := 0 to round(betta*High(fToolKitArr)) do
   begin
    number:=random(High(fToolKitArr)+1);
    ParametersNew[i][number]:=fToolKitArr[number].RandValue;
   end;
end;

procedure TFA_NNA.BiasWeights(i: integer);
 var j:integer;
begin
 Randomize;
 for j := 1 to round(betta*fNp) do
    Weights[i][random(fNp)]:=Random;
end;

procedure TFA_NNA.CreateFields;
begin
  inherited CreateFields;
  fDescription:='Neural Network  Algorithm';
  SetLength(Weights,fNp,fNp);
  SetLength(GlobalBestWeights,fNp);
  betta:=1;
  GreedySelectionRequired:=true;

end;

function TFA_NNA.GreedySelectionToLocalBest(ItIsAlways: boolean): integer;
begin
  Result:=inherited GreedySelectionToLocalBest(ItIsAlways);
  if Result>-1  then  GlobalBestWeights:=Copy(Weights[Result]);
end;

//procedure TFA_NNA.DataCoordination;
//begin
// ArrayToHeuristicParam(BestParameters);
//end;
//
//procedure TFA_NNA.GreedySelectionAll;
// var i:integer;
//begin
// for I := 0 to High(FitnessData) do
//   begin
//    Parameters[i]:=Copy(ParametersNew[i]);
//    FitnessData[i]:=FitnessDataNew[i];
//   end;
//end;

procedure TFA_NNA.KoefDetermination;
begin
  inherited;
  betta:=betta*0.99;
//  NumberBest:=MinElemNumber(FitnessData);

//  if FitnessData[NumberBest]<BestParametersFitness then
//   begin
//     BestParameters:=Copy(Parameters[NumberBest]);
//     BestParametersFitness:=FitnessData[NumberBest];
//   end;
end;

procedure TFA_NNA.NewPopulationCreate(i: integer);
begin
 if ItIsBias then BiasPattern(i)
             else TransferFunction(i);
end;

function TFA_NNA.NpDetermination: integer;
begin
 Result:=50;
end;

procedure TFA_NNA.StartAction;
begin
  inherited;
  WeightsInitialization;
end;

procedure TFA_NNA.TransferFunction(i: integer);
 var j:integer;
     r:double;
begin
 r:=2*Random;
 for j := 0 to High(fToolKitArr) do
  ParametersNew[i][j]:=fToolKitArr[j].DE_Mutation(ParametersNew[i][j],
//                                                  Parameters[NumberBest,j],
                                                  GlobalBest[j],
                                                  ParametersNew[i][j],r);
end;

procedure TFA_NNA.UpdatePattern(i: integer);
 var k:integer;
begin
  for k := 0 to High(fToolKitArr) do
   ParametersNew[i,k]:=fToolKitArr[k].NNA_UpdatePattern(Parameters,
                                                        Weights,
                                                        i,k);
end;

procedure TFA_NNA.UpdateWeights(i: integer);
 var j:integer;
     r:double;
begin
  r:=Random;
  for j := 0 to fNp-1 do 
//    Weights[i,j]:=Weights[i,j]+2*r*(Weights[NumberBest,j]-Weights[i,j]);
    Weights[i,j]:=Weights[i,j]+2*r*(GlobalBestWeights[j]-Weights[i,j]);
end;

procedure TFA_NNA.WeightsInitialization;
 var i,j:integer;
begin
 for I := 0 to fNp-1 do
  begin
    Randomize;
    for j := 0 to fNp-1 do Weights[i,j]:=Random;
  end;
 WeightsNormalisation;
end;

procedure TFA_NNA.WeightsNormalisation;
 var i:integer;
begin
 for I := 0 to fNp-1 do NormalArray(Weights[i]);
end;

{ TFA_CWOA }

procedure TFA_CWOA.BubbleNetAttacking(i: integer);
 var l:double;
     j:integer;
begin
 l:=2*random-1;
 for j := 0 to High(fToolKitArr) do
   ParametersNew[i][j]:=fToolKitArr[j].WOA_BubleNA(Parameters[i][j],
//                                                    Prey[j],
                                                    GlobalBest[j],
                                                    l);
end;

procedure TFA_CWOA.CreateFields;
begin
  inherited;
  fDescription:='Chaotic Whale Optimization Algorithm';
  GreedySelectionRequired:=false;
//  SetLength(Prey,fFF.DParamArray.MainParamHighIndex+1);
//  PreyFitness:=1e10;
  Randomize;
  prob:=Random;
end;

//procedure TFA_CWOA.DataCoordination;
//begin
// ArrayToHeuristicParam(Prey);
//end;

procedure TFA_CWOA.KoefDetermination;
begin
  inherited;
  a:=2*(1-fCurrentIteration/(fFF.fDParamArray as TDParamsIteration).Nit);
//  GreedySelectionToLocalBest(Prey,PreyFitness);
  prob:=SingerChaoticMap(prob);
end;

procedure TFA_CWOA.NewPopulationCreate(i: integer);
begin
 UpDate(i);
end;

function TFA_CWOA.NpDetermination: integer;
begin
 Result:=100;
end;

procedure TFA_CWOA.SearchForPrey(i: integer);
 var j:integer;
     r:integer;
begin
 if abs(Avec)>=1 then
  begin
    r:=Random(fNp);
    for j := 0 to High(fToolKitArr) do
     ParametersNew[i][j]:=fToolKitArr[j].WOA_SearchFP(Parameters[i][j],
                                                      Parameters[r,j],
                                                       Avec,Cvec);
  end             else
    for j := 0 to High(fToolKitArr) do
     ParametersNew[i][j]:=fToolKitArr[j].WOA_SearchFP(Parameters[i][j],
//                                                      Prey[j],
                                                      GlobalBest[j],
                                                      Avec,Cvec);
end;

//procedure TFA_CWOA.StartAction;
//begin
//  inherited StartAction;
//  GreedySelectionToLocalBest(Prey,PreyFitness,true);
//end;

procedure TFA_CWOA.UpDate(i: integer);
 var r:double;
begin
 r:=Random;
 Cvec:=2*r;
 Avec:=a*(Cvec-1);
 if prob<0.5 then SearchForPrey(i)
             else BubbleNetAttacking(i);
end;

{ TFA_WithoutGreedySelection }

procedure TFA_WithoutGreedySelection.CreateFields;
begin
  inherited;
  GreedySelectionRequired:=false;
  SetLength(GlobalBest,fFF.DParamArray.MainParamHighIndex+1);
  GlobalBestFitness:=1e10;
end;

procedure TFA_WithoutGreedySelection.DataCoordination;
begin
 ArrayToHeuristicParam(GlobalBest);
end;

function TFA_WithoutGreedySelection.GreedySelectionToLocalBest(
  ItIsAlways: boolean): integer;
 var NumberBest:integer;
begin
 NumberBest:=MinElemNumber(FitnessData);
 if (ItIsAlways) or (FitnessData[NumberBest]<GlobalBestFitness) then
   begin
    GlobalBest:=Copy(Parameters[NumberBest]);
    GlobalBestFitness:=FitnessData[NumberBest];
    Result:=NumberBest;
   end                             else
    Result:=-1;
end;

procedure TFA_WithoutGreedySelection.KoefDetermination;
begin
  inherited KoefDetermination;
//  GreedySelectionToLocalBest(GlobalBest,GlobalBestFitness);
  GreedySelectionToLocalBest();
end;

procedure TFA_WithoutGreedySelection.StartAction;
begin
  inherited;
//  GreedySelectionToLocalBest(GlobalBest,GlobalBestFitness,true);
  GreedySelectionToLocalBest(true);
end;

//{ TFandCrCreator }
//
//constructor TFandCrCreator.Create(FA_DE:TFA_DE;H: integer=5);
//// var i:integer;
//begin
// inherited;
//// fFA_DE:=FA_DE;
//// Mdata:=TVector.Create;
// data:=TVector.Create;
// Koef:=TVector.Create;
//// fH:=H;
//// for I := 0 to fH - 1 do
////  Mdata.Add(0.5,0.5);
//// fk:=0;
// data.SetLenVector(fFA_DE.Np);
//end;
//
//destructor TFandCrCreator.Destroy;
//begin
//  FreeAndNil(data);
//  FreeAndNil(Koef);
////  FreeAndNil(Mdata);
//  inherited;
//end;
//
//function TFandCrCreator.GenerateCr(k: integer): double;
//begin
// Result:=RandG(Mdata.Y[k],0.1);
// Result:=EnsureRange(Result,0.0,1.0);
//end;
//
//procedure TFandCrCreator.GenerateData;
// var k,i:integer;
//begin
// randomize;
// for i := 0 to fFA_DE.Np - 1 do
//  begin
//   k:=random(fH);
//   Data.X[i]:=GenerateF(k);
//   Data.Y[i]:=GenerateCr(k);
//  end;
//end;
//
//function TFandCrCreator.GenerateF(k: integer): double;
//begin
// repeat
//  Result:=RandCauchy(Mdata.X[k],0.1);
// until Result>=0;
// Result:=min(Result,1.0);
//end;
//
//function TFandCrCreator.GetCr(index:integer): double;
//begin
// Result:=Data.Y[index];
//end;
//
//function TFandCrCreator.GetF(index:integer): double;
//begin
// Result:=Data.X[index];
//end;
//
//function TFandCrCreator.NewIsBetter(const i:integer): boolean;
//begin
// Result:=fFA_DE.FitnessData[i]>fFA_DE.FitnessDataNew[i];
// if Result then Koef.Add((fFA_DE.FitnessData[i]-fFA_DE.FitnessDataNew[i]),i);
//end;
//
//procedure TFandCrCreator.UpDate;
// var summa,sumF,sumCr:double;
//     i,number:integer;
//begin
// if Koef.HighNumber<0 then Exit;
// summa:=Koef.SumX;
// for I := 0 to Koef.HighNumber do
//   Koef.X[i]:=Koef.X[i]/summa;
// summa:=0;
// sumF:=0;
// sumCr:=0;
// for I := 0 to Koef.HighNumber do
//   begin
//    number:=round(Koef.Y[i]);
//    summa:=summa+Koef.X[i]*sqr(Data.X[number]);
//    sumF:=sumF+Koef.X[i]*Data.X[number];
//    sumCr:=sumCr+Koef.X[i]*Data.Y[number];
//   end;
// Mdata.X[fk]:=summa/sumF;
// Mdata.Y[fk]:=sumCr;
// Koef.Clear;
// inherited UpDate;
//// inc(fk);
//// if fk>=fH then fk:=0;
//
//end;

{ TDEArchiv }

procedure TDEArchiv.AddToArchiv(i: integer);
 var j:integer;
begin
 SetLength(Archiv,High(Archiv)+2);
 SetLength(Archiv[High(Archiv)],fFA_DE.Dim+1);
 for j := 0 to fFA_DE.Dim-1 do
    Archiv[High(Archiv),j]:=fFA_DE.Parameters[i,j];
 Archiv[High(Archiv),fFA_DE.Dim]:=fFA_DE.FitnessData[i];
end;

constructor TDEArchiv.Create(FA_DE: TFA_DE;const Arc_rate:double=1);
begin
 fFA_DE:=FA_DE;
 SetLength(Archiv,0);
end;

function TDEArchiv.GetMaxSize: integer;
begin
 Result:=max(1,Ceil(fFA_DE.Np*fArc_rate));
end;

function TDEArchiv.GetSize: integer;
begin
 Result:=High(Archiv)+1;
end;

procedure TDEArchiv.ResizeToMaxSize;
 var num:integer;
begin
 while Size>MaxSize do
  begin
   num:=random(High(Archiv)+1);
   if num<High(Archiv) then
     Archiv[num]:=Copy(Archiv[High(Archiv)]);
   SetLength(Archiv,High(Archiv));
  end;
end;

//{ TDE_Memory }
//
//constructor TDE_Memory.Create(FA_DE: TFA_DE; H: integer);
// var i:integer;
//begin
// inherited Create;
// fFA_DE:=FA_DE;
// Mdata:=TVector.Create;
// fH:=H;
// for I := 0 to fH - 1 do
//  Mdata.Add(0.5,0.5);
// fk:=0;
//end;
//
//destructor TDE_Memory.Destroy;
//begin
//  FreeAndNil(Mdata);
//  inherited;
//end;
//
//procedure TDE_Memory.UpDate;
//begin
// inc(fk);
// if fk>=fH then fk:=0;
//end;

//{ TTCP }
//
//procedure TFCP.AddData(i: integer);
//begin
// if fIsFirstAlgorithm[i]
//   then Koef.Add(fFA_DE.FitnessData[i]-fFA_DE.FitnessDataNew[i],0)
//   else Koef.Add(0,fFA_DE.FitnessData[i]-fFA_DE.FitnessDataNew[i]);
//end;
//
//constructor TFCP.Create(FA_DE: TFA_DE; H: integer=5;LR:double=0.8);
//begin
// inherited Create(FA_DE,H);
// SetLength(fIsFirstAlgorithm,FA_DE.Np);
// fLearningRate:=LR;
// Koef:=TVector.Create;
//end;
//
//destructor TFCP.Destroy;
//begin
//  FreeAndNil(Koef);
//  inherited;
//end;
//
//procedure TFCP.GenerateData;
// var i:integer;
//begin
// randomize;
// for i := 0 to fFA_DE.Np - 1 do
//  fIsFirstAlgorithm[i]:=(random<Mdata.X[random(fH)])
//end;
//
//function TFCP.GetIsFirstAlgorithm(index: integer): boolean;
//begin
// Result:=fIsFirstAlgorithm[index];
//end;
//
//procedure TFCP.UpDate;
// var summa,del_m:double;
//begin
// if Koef.HighNumber<0 then Exit;
// summa:=Koef.SumX;
// if summa=0 then del_m:=0.2
//           else del_m:=min(0.8,max(0.2,summa/(summa+Koef.SumY)));
// Mdata.X[fk]:=(1-fLearningRate)*Mdata.X[fk]
//              +fLearningRate*del_m;
// Koef.Clear;
// inherited UpDate;
//end;

{ TFA_ELSHADE }

procedure TFA_EBLSHADE.CreateFields;
begin
  inherited CreateFields;
  fDescription:='EBLSHADE';
//  NPinit:=Np;
//  NPmin:=4;
  p_init:=0.30;
  p_min:=0.15;
  Archiv:=TDEArchiv.Create(Self);
  FCP:=TEBLSHADE_FCP.Create(Self);
//  FandCrCreator:=TEBLSHADE_FandCrCreator.Create(Self);
//  VectorForOppositePopulation.SetLenVector(fNp);
//  {в цьому методі використовується для
//  сортування елементів в популяції}
end;

procedure TFA_EBLSHADE.DataCoordination;
begin
 ArrayToHeuristicParam(Parameters[round(VectorForOppositePopulation.Y[0])]);
end;

//procedure TFA_EBLSHADE.Datatransform;
// var i,k:integer;
//begin
// for I := fNp to VectorForOppositePopulation.HighNumber do
//  begin
//    k:=round(VectorForOppositePopulation.Y[i]);
//    Parameters[k]:=Copy(Parameters[i]);
//    FitnessData[k]:=FitnessData[i];
//  end;
//end;

destructor TFA_EBLSHADE.Destroy;
begin
//  FreeAndNil(FandCrCreator);
  FreeAndNil(FCP);
  FreeAndNil(Archiv);
  inherited;
end;

procedure TFA_EBLSHADE.FandCrCreatorCreate;
begin
 FandCrCreator:=TEBLSHADE_FandCrCreator.Create(Self);
end;

//procedure TFA_EBLSHADE.GreedySelectionAll;
// var i:integer;
//begin
//   for I := 0 to fNp-1 do
//    if FandCrCreator.NewIsBetter(i) then
//     begin
//      Archiv.AddToArchiv(i);
//      FCP.AddData(i);
//      Parameters[i]:=Copy(ParametersNew[i]);
//      FitnessData[i]:=FitnessDataNew[i];
//     end;
//end;

procedure TFA_EBLSHADE.KoefDetermination;
begin
 inherited KoefDetermination;

// VectorForOppositePopulationFilling;
// PopulationReSize;
// FandCrCreator.UpDate;
// FandCrCreator.GenerateData;

// VectorForOppositePopulationFilling;
// fNp:=NewNp;
// if fNp<=VectorForOppositePopulation.HighNumber then
//   begin
//     Datatransform;
//     VectorForOppositePopulation.SetLenVector(fNp);
//     VectorForOppositePopulationFilling;
//   end;

 pbestNumber:=NewpbestNumber;
 FCP.UpDate;
// FandCrCreator.UpDate;
 Fcp.GenerateData;
// FandCrCreator.GenerateData;
 Archiv.ResizeToMaxSize;
end;

procedure TFA_EBLSHADE.MutationCreate(i: integer);
 var j:integer;
begin
  repeat
   r[1]:=Random(pbestNumber);
   r[1]:=round(VectorForOppositePopulation.Y[r[1]]);
  until (r[1]<>i);

  repeat
   r[2]:=Random(Np);
  until (r[2]<>i)and(r[2]<>r[1]);

  repeat
   if FCP.IsFirstAlgorithm[i]
     then r[3]:=Random(Np+Archiv.Size)
     else r[3]:=Random(Np);
  until (r[3]<>i)and(r[3]<>r[1])and(r[3]<>r[2]);

 if FCP.IsFirstAlgorithm[i] then
  begin
    repeat
      Random(Np+Archiv.Size)
    until (r[3]<>i)and(r[3]<>r[1])and(r[3]<>r[2]);
    if r[3]<Np then
     for j := 0 to High(fToolKitArr) do
      ParametersNew[i][j]:=fToolKitArr[j].EBLSHADE_Mutation(Parameters[i,j],
                          Parameters[r[1],j],
                          Parameters[r[2],j],
                          Parameters[r[3],j],
                          FandCrCreator.F[i])
               else
     for j := 0 to High(fToolKitArr) do
      ParametersNew[i][j]:=fToolKitArr[j].EBLSHADE_Mutation(Parameters[i,j],
                          Parameters[r[1],j],
                          Parameters[r[2],j],
                          Archiv.Archiv[r[3]-Np,j],
                          FandCrCreator.F[i]);
  end                      else  //if FCP.IsFirstAlgorithm[i] then
  begin
    repeat
     r[3]:=Random(Np);
    until (r[3]<>i)and(r[3]<>r[1])and(r[3]<>r[2]);

    if FitnessData[r[1]]>FitnessData[r[2]] then Swap(r[1],r[2]);
    if FitnessData[r[2]]>FitnessData[r[3]] then Swap(r[2],r[3]);
    if FitnessData[r[1]]>FitnessData[r[2]] then Swap(r[1],r[2]);

    for j := 0 to High(fToolKitArr) do
      ParametersNew[i][j]:=fToolKitArr[j].EBLSHADE_Mutation(Parameters[i,j],
                          Parameters[r[1],j],
                          Parameters[r[2],j],
                          Parameters[r[3],j],
                          FandCrCreator.F[i])
  end;

end;

//function TFA_EBLSHADE.NewNp: integer;
//begin
// Result:=round((NPmin-NPinit)*fCurrentIteration
//          /(fFF.fDParamArray as TDParamsIteration).Nit
//            +NPinit);
//end;

function TFA_EBLSHADE.NewpbestNumber: integer;
begin
 Result:=max(2,Ceil(Np*(p_min-p_init)*fCurrentIteration
          /(fFF.fDParamArray as TDParamsIteration).Nit
            +p_init));
end;

//procedure TFA_EBLSHADE.NewPopulationCreate(i: integer);
//begin
//  CR:=FandCrCreator.Cr[i];
//  Crossover(i);
//end;

function TFA_EBLSHADE.NpDetermination: integer;
begin
 Result:=(fFF.DParamArray.MainParamHighIndex+1)*18;
end;

procedure TFA_EBLSHADE.PopulationUpDate(i: Integer);
begin
  Archiv.AddToArchiv(i);
  FCP.AddData(i);
  inherited PopulationUpDate(i);
end;

//procedure TFA_EBLSHADE.VectorForOppositePopulationFilling;
// var i:integer;
//begin
// for I := 0 to fNp - 1 do
//   begin
//    VectorForOppositePopulation.X[i]:=FitnessData[i];
//    VectorForOppositePopulation.Y[i]:=i;
//   end;
// VectorForOppositePopulation.Sorting();
//end;

{ TFA_ADELI }

procedure TFA_ADELI.BeforeNewPopulationCreate;
begin
 LagrangeInterpolation;
 inherited BeforeNewPopulationCreate;
end;

procedure TFA_ADELI.CreateFields;
begin
 inherited CreateFields;
 fDescription:='DE with the Lagrange interpolation';
 F:=0.5;
 CR:=0.9;
 LRmin:=0.1;
 LRmax:=0.9;
 LR:=LRmax;
 VectorForOppositePopulation.SetLenVector(fDim);
  {в цьому методі використовується для
  збереження мах (Х) та min (Y) значень
  змінних у популяції}
 SetLength(FitDataLagr,3);
 SetLength(ParXLagr,3,fDim);
 FandCrCreator:=TADELI_FandCrCreator.Create(Self);
end;

destructor TFA_ADELI.Destroy;
begin
  FreeAndNil(FandCrCreator);
  inherited;
end;

procedure TFA_ADELI.KoefDetermination;
begin
 FandCrCreator.GenerateData;
end;

procedure TFA_ADELI.LagrangeInterpolation;
  var NumberBest,j,i:integer;
      LagrangeInterIsSuccessful:boolean;
begin
 if random>=LR then Exit;
 LagrangeInterIsSuccessful:=False;
 RsearchDetermination;
 NumberBest:=MinElemNumber(FitnessData);

 for I := 0 to 2 do
  begin
   ParXLagr[i]:=Copy(Parameters[NumberBest]);
   FitDataLagr[i]:=FitnessData[NumberBest];
  end;

 for j := 0 to High(fToolKitArr) do
  if not(fFF.DParamArray.Parametr[j].IsConstant) then
   begin

    ParXLagr[1,j]:=fToolKitArr[j].ADELI_LocalSearch(ParXLagr[1,j],VectorForOppositePopulation.Y[j],
                    VectorForOppositePopulation.X[j],Np,True);
    try
     FitDataLagr[1]:=FitnessFunc(ParXLagr[1]);
    except
     ParXLagr[1,j]:=Parameters[NumberBest,j];
     Continue;
    end;

    ParXLagr[2,j]:=fToolKitArr[j].ADELI_LocalSearch(ParXLagr[2,j],VectorForOppositePopulation.Y[j],
                    VectorForOppositePopulation.X[j],Np,False);
    try
     FitDataLagr[2]:=FitnessFunc(ParXLagr[2]);
    except
     ParXLagr[2,j]:=Parameters[NumberBest,j];
     Continue;
    end;

    ParXLagr[0,j]:=fToolKitArr[j].ADELI_Lagrange(Parameters[NumberBest,j],
                                         ParXLagr[1,j],ParXLagr[2,j],
                                         FitnessData[NumberBest],
                                         FitDataLagr[1],
                                         FitDataLagr[2]);
    try
     FitDataLagr[0]:=FitnessFunc(ParXLagr[0]);
    except
     ParXLagr[0,j]:=Parameters[NumberBest,j];
     Continue;
    end;

    for I := 0 to 2 do
     if FitDataLagr[i]<FitnessData[NumberBest] then
     begin
      Parameters[NumberBest,j]:=ParXLagr[i,j];
      FitnessData[NumberBest]:=FitDataLagr[i];
      LagrangeInterIsSuccessful:=True;
     end;

    for I := 0 to 2 do
      ParXLagr[i,j]:=Parameters[NumberBest,j];

   end;

  if LagrangeInterIsSuccessful
    then LR:=LRmax
    else LR:=LRmin;
end;

procedure TFA_ADELI.MutationCreate(i: integer);
begin
 F:=FandCrCreator.F[i];
 inherited MutationCreate(i);
end;

procedure TFA_ADELI.NewPopulationCreate(i: integer);
begin
  CR:=FandCrCreator.Cr[i];
  Crossover(i);
end;

procedure TFA_ADELI.RsearchDetermination;
 var i,j:integer;
begin
 for I := 0 to Dim - 1 do
  begin
    VectorForOppositePopulation.X[i]:=Parameters[0,i];
    VectorForOppositePopulation.Y[i]:=Parameters[0,i];
    for j := 1 to Np - 1 do
     begin
      VectorForOppositePopulation.X[i]:=max(VectorForOppositePopulation.X[i],
                                            Parameters[j,i]);
      VectorForOppositePopulation.Y[i]:=min(VectorForOppositePopulation.Y[i],
                                            Parameters[j,i]);
     end;
  end;
end;

{ TSimpleFandCrCreator }

constructor TADELI_FandCrCreator.Create(FA_DE: TFA_DE);
 var i:integer;
begin
 inherited Create(FA_DE);
 for I := 0 to Data.HighNumber do
  begin
    Data.X[i]:=fFA_DE.F;
    Data.Y[i]:=fFA_DE.CR;
  end;
 tau1:=0.1;
 tau2:=0.1;
 Flow:=0.1;
 Fup:=0.9;

end;

procedure TADELI_FandCrCreator.GenerateData;
 var i:integer;
begin
 randomize;
 for i := 0 to fFA_DE.Np - 1 do
  begin
   if random<tau1 then Data.X[i]:=Flow+random*Fup;
   if random<tau2 then Data.Y[i]:=random;
  end;
end;


{ TNDE_neighborhood }

constructor TNDE_neighborhood.Create;
begin
 inherited;
 Nrsize:=1;
 ClearNum;
 IsNeededToRecalculate:=True;
end;

procedure TNDE_neighborhood.ClearNum;
begin
  Numg := 0;
  Nums := 0;
end;


procedure TNDE_neighborhood.SetNrsize(Value: integer);
begin
 if Value<0 then Exit;
 fNrsize:=Value;
 fNsize:=fNrsize*2+1;
end;

procedure TNDE_neighborhood.ToOld;
begin
  fit_bestOld:=fit_best;
  fit_worstOld:=fit_worst;
  fit_averOld:=fit_aver;
  StdOld:=Std;
end;

{ TNDE_neighborhoods }

procedure TNDE_neighborhoods.CalculateStdaver;
 var i:integer;
     temp:double;
begin
 temp:=0;
 for i := 0 to fFA_DE.Np-1 do
   temp:=temp+fneighborhoods[i].Std;
 fStd_aver:=temp/(fFA_DE.Np-1);
end;

procedure TNDE_neighborhoods.ChangeNums;
 var i:integer;
begin
 for I := 0 to fFA_DE.Np-1 do
  begin
   DataCalculate(i,true);
   if fneighborhoods[i].fit_best<fneighborhoods[i].fit_bestOld
    then fneighborhoods[i].ClearNum
    else
     begin
       Inc(fneighborhoods[i].Numg);
        if fneighborhoods[i].fit_aver>=fneighborhoods[i].fit_averOld
          then Inc(fneighborhoods[i].Nums);
     end;
  end;

end;

constructor TNDE_neighborhoods.Create(FA_DE: TFA_DE);
 var i:integer;
begin
 inherited Create;
 fFA_DE:=FA_DE;
 SetLength(fneighborhoods,fFA_DE.Np);
 for I := 0 to High(fneighborhoods) do
  fneighborhoods[i]:=TNDE_neighborhood.Create;
 fgm:=10;
end;

procedure TNDE_neighborhoods.DataCalculate(i: integer;IsAlways:boolean);
begin
 if (IsAlways or fneighborhoods[i].IsNeededToRecalculate) then
 begin
   GroupIndexDetermine(i);
   GroupFitsDetermine(i);
   fneighborhoods[i].fit_best:=MinValue(group_fits);
   fneighborhoods[i].fit_worst:=MaxValue(group_fits);
   fneighborhoods[i].fit_aver:=Mean(group_fits);
   fneighborhoods[i].Std:=StdDev(group_fits);
   {XP Win}
//   MeanAndStdDev(group_fits,fneighborhoods[i].fit_aver,
//                   fneighborhoods[i].Std);
   if IsEqual(fneighborhoods[i].fit_best,fneighborhoods[i].fit_worst)
      then  fneighborhoods[i].Eps1:=1/(1+exp(20))
      else  fneighborhoods[i].Eps1:=1/(1+exp(20
         *(fneighborhoods[i].fit_aver-fFA_DE.FitnessData[i])
         /(fneighborhoods[i].fit_worst-fneighborhoods[i].fit_best)));
   fneighborhoods[i].Num_best:=MinElemNumber(group_fits);
   repeat
    fneighborhoods[i].nr1:=group_index[random(fneighborhoods[i].Nsize)];
   until (fneighborhoods[i].nr1<>i);

   repeat
    fneighborhoods[i].nr2:=group_index[random(fneighborhoods[i].Nsize)];
   until (fneighborhoods[i].nr2<>i)
         and(fneighborhoods[i].nr2<>fneighborhoods[i].nr1);
   fneighborhoods[i].IsNeededToRecalculate:=False;
 end;
end;

procedure TNDE_neighborhoods.DataCalculateAll;
  var i:integer;
begin
  for I := 0 to fFA_DE.Np-1
    do  DataCalculate(i,False);
end;

destructor TNDE_neighborhoods.Destroy;
  var i:integer;
begin
  for I := 0 to High(fneighborhoods) do
    FreeAndNil(fneighborhoods[i]);
  inherited;
end;

function TNDE_neighborhoods.GetNB(index: integer): TNDE_neighborhood;
begin
 Result:=fneighborhoods[index];
end;

procedure TNDE_neighborhoods.IncreaseNrsize(i: integer);
begin
 fneighborhoods[i].Nrsize:=min(fneighborhoods[i].Nrsize+1,
                                Floor(0.5*(fFA_DE.Np-1)));
 fneighborhoods[i].IsNeededToRecalculate:=True;
end;


procedure TNDE_neighborhoods.ReSize;
 var maxNrsize,i:integer;
begin
 maxNrsize:=Floor(0.5*(fFA_DE.Np-1));
 for I := 0 to fFA_DE.Np-1 do
   begin
     fneighborhoods[i].Nrsize:=min(maxNrsize,
                               fneighborhoods[i].Nrsize);
     fneighborhoods[i].IsNeededToRecalculate:=True;
   end;
end;

procedure TNDE_neighborhoods.GroupFitsDetermine(i: integer);
 var j:integer;
begin
 SetLength(group_fits,fneighborhoods[i].Nsize);
 for j :=0 to High(group_fits) do
  group_fits[j]:=fFA_DE.FitnessData[group_index[j]];
end;

procedure TNDE_neighborhoods.GroupIndexDetermine(i: integer);
 var j,k:integer;
begin
 SetLength(group_index,fneighborhoods[i].Nsize);
 for j := i-fneighborhoods[i].Nrsize to i+fneighborhoods[i].Nrsize do
  begin
    k:=j-i+fneighborhoods[i].Nrsize;
    if j<0 then
      begin
       group_index[k]:=fFA_DE.Np+j;
       Continue;
      end;
    if j>=fFA_DE.Np then
      begin
       group_index[k]:=j-fFA_DE.Np;
       Continue;
      end;
    group_index[k]:=j;
  end;

end;

procedure TNDE_neighborhoods.UpDate;
 var maxNrsize,i:integer;
begin
 maxNrsize:=Floor(0.5*(fFA_DE.Np-1));
 for I := 0 to High(fneighborhoods) do
  fneighborhoods[i].Nrsize:=min(fneighborhoods[i].Nrsize,maxNrsize);
end;

{ TFandCrCreatorSimple }

constructor TFandCrCreatorSimple.Create(FA_DE: TFA_DE);
begin
 inherited Create(FA_DE);
// fFA_DE:=FA_DE;
 Data:=TVector.Create;
 Data.SetLenVector(fFA_DE.Np);
end;

destructor TFandCrCreatorSimple.Destroy;
begin
  FreeAndNil(Data);
  inherited;
end;

function TFandCrCreatorSimple.GetCr(index: integer): double;
begin
 Result:=Data.Y[index];
end;

function TFandCrCreatorSimple.GetF(index: integer): double;
begin
 Result:=Data.X[index];
end;

{ TDE_Supplementary }

constructor TDE_Supplementary.Create(FA_DE: TFA_DE);
begin
 inherited Create;
 fFA_DE:=FA_DE;
end;

{ TDE_Mem }

constructor TDE_Mem.Create(H: integer);
 var i:integer;
begin
 inherited Create;
 Mdata:=TVector.Create;
 fH:=H;
 for I := 0 to fH - 1 do
  Mdata.Add(0.5,0.5);
 fk:=0;
end;

destructor TDE_Mem.Destroy;
begin
  FreeAndNil(Mdata);
  inherited;
end;

function TDE_Mem.GetData(Index: Integer): double;
begin
 Result:=Mdata[fk][TCoord_type(Index)];
end;

function TDE_Mem.GetX(i: integer): double;
begin
 Result:=Mdata.X[EnsureRange(i,0,fH-1)];
end;

function TDE_Mem.GetY(i: integer): double;
begin
 Result:=Mdata.Y[EnsureRange(i,0,fH-1)];
end;

procedure TDE_Mem.SetData(Index: Integer; Value: double);
begin
 if Index=0 then Mdata.X[fk]:=Value
            else Mdata.Y[fk]:=Value;
end;


procedure TDE_Mem.UpDate;
begin
 inc(fk);
 if fk>=fH then fk:=0;
end;

{ TDE_MemSimple }

constructor TDE_MemSimple.Create;
begin
 inherited Create(1);
end;

procedure TDE_MemSimple.UpDate;
begin
end;

{ TFandCrCreatorCauchyNormal }

constructor TFandCrCreatorCauchyNormal.Create(FA_DE: TFA_DE);
begin
 inherited Create(FA_DE);
 Koef:=TVector.Create;
 MemCreate;
end;

destructor TFandCrCreatorCauchyNormal.Destroy;
begin
  FreeAndNil(Mem);
  FreeAndNil(Koef);
  inherited;
end;

function TFandCrCreatorCauchyNormal.GenerateCr(mean: double): double;
begin
 Result:=RandG(mean,0.1);
 Result:=EnsureRange(Result,0.0,1.0);
end;

//procedure TFandCrCreatorCauchyNormal.GenerateData;
// var k,i:integer;
//begin
// randomize;
// for i := 0 to fFA_DE.Np - 1 do
//  begin
//   k:=random(Mem.Len);
//   Data.X[i]:=GenerateF(Mem.GetX(k));
//   Data.Y[i]:=GenerateCr(Mem.GetY(k));
//  end;
//end;

function TFandCrCreatorCauchyNormal.GenerateF(mean: double): double;
begin
 repeat
  Result:=RandCauchy(mean,0.1);
 until Result>=0;
 Result:=min(Result,1.0);
end;

procedure TFandCrCreatorCauchyNormal.MemCreate;
begin
 Mem:=TDE_Mem.Create;
end;

procedure TFandCrCreatorCauchyNormal.MemUpDate(sumF2, sumF, sumCr: double);
begin
 Mem.X:=sumF2/sumF;
 Mem.Y:=sumCr;
 Mem.UpDate;
end;

function TFandCrCreatorCauchyNormal.NewIsBetter(const i: integer): boolean;
begin
 Result:=fFA_DE.FitnessData[i]>fFA_DE.FitnessDataNew[i];
 if Result then Koef.Add((fFA_DE.FitnessData[i]-fFA_DE.FitnessDataNew[i]),i);
end;

procedure TFandCrCreatorCauchyNormal.UpDate;
 var summa,sumF2,sumF,sumCr:double;
     i,number:integer;
begin
 if Koef.HighNumber<0 then Exit;
 summa:=Koef.SumX;
 for I := 0 to Koef.HighNumber do
   Koef.X[i]:=Koef.X[i]/summa;
 sumF2:=0;
 sumF:=0;
 sumCr:=0;
 for I := 0 to Koef.HighNumber do
   begin
    number:=round(Koef.Y[i]);
    sumF2:=sumF2+Koef.X[i]*sqr(Data.X[number]);
    sumF:=sumF+Koef.X[i]*Data.X[number];
    sumCr:=sumCr+Koef.X[i]*Data.Y[number];
   end;

 MemUpDate(sumF2,sumF,sumCr);

 Koef.Clear;
end;

{ TEBLSHADE_FandCrCreator }

procedure TEBLSHADE_FandCrCreator.GenerateData;
 var k,i:integer;
begin
 randomize;
 for i := 0 to fFA_DE.Np - 1 do
  begin
   k:=random(Mem.Len);
   Data.X[i]:=GenerateF(Mem.GetX(k));
   Data.Y[i]:=GenerateCr(Mem.GetY(k));
  end;
end;

{ TNDE_FandCrCreator }

constructor TNDE_FandCrCreator.Create(FA_DE: TFA_DE);
begin
 inherited;
 fc:=0.1;
end;

procedure TNDE_FandCrCreator.GenerateData;
 var i:integer;
begin
 randomize;
 for i := 0 to fFA_DE.Np - 1 do
  begin
   Data.X[i]:=GenerateF(Mem.X);
   Data.Y[i]:=GenerateCr(Mem.Y);
  end;
end;

procedure TNDE_FandCrCreator.MemCreate;
begin
 Mem:=TDE_MemSimple.Create;
end;

procedure TNDE_FandCrCreator.MemUpDate(sumF2, sumF, sumCr: double);
begin
 Mem.X:=(1-fc)*Mem.X+fc*sumF2/sumF;
 Mem.Y:=(1-fc)*Mem.Y+fc*sumCr;
end;

{ TEBLSHADE_FCP }

procedure TEBLSHADE_FCP.AddData(i: integer);
begin
 if fIsFirstAlgorithm[i]
   then Koef.Add(fFA_DE.FitnessData[i]-fFA_DE.FitnessDataNew[i],0)
   else Koef.Add(0,fFA_DE.FitnessData[i]-fFA_DE.FitnessDataNew[i]);
end;

constructor TEBLSHADE_FCP.Create(FA_DE: TFA_DE; H: integer; LR: double);
begin
 inherited Create(FA_DE);
 Mem:=TDE_Mem.Create(H);
 SetLength(fIsFirstAlgorithm,FA_DE.Np);
 fLearningRate:=LR;
 Koef:=TVector.Create;
end;

destructor TEBLSHADE_FCP.Destroy;
begin
  FreeAndNil(Koef);
  FreeAndNil(Mem);
  inherited;
end;

procedure TEBLSHADE_FCP.GenerateData;
 var i:integer;
begin
 randomize;
 for i := 0 to fFA_DE.Np - 1 do
  fIsFirstAlgorithm[i]:=(random<Mem.GetX(random(Mem.Len)));
end;

function TEBLSHADE_FCP.GetIsFirstAlgorithm(index: integer): boolean;
begin
  Result:=fIsFirstAlgorithm[index];
end;

procedure TEBLSHADE_FCP.UpDate;
 var summa,del_m:double;
begin
 if Koef.HighNumber<0 then Exit;
 summa:=Koef.SumX;
 if summa=0 then del_m:=0.2
           else del_m:=min(0.8,max(0.2,summa/(summa+Koef.SumY)));
 Mem.X:=(1-fLearningRate)*Mem.X+fLearningRate*del_m;
 Koef.Clear;
 Mem.UpDate;
end;

{ TFA_DEcomplex }

procedure TFA_DEcomplex.CreateFields;
begin
  inherited CreateFields;
  NPinit:=Np;
  NPmin:=4;
  FandCrCreatorCreate;
  VectorForOppositePopulation.SetLenVector(fNp);
  {в цьому методі використовується для
  сортування елементів в популяції}

end;

procedure TFA_DEcomplex.DataCoordination;
begin
 ArrayToHeuristicParam(Parameters[round(VectorForOppositePopulation.Y[0])]);
end;


procedure TFA_DEcomplex.PopulationUpDate(i: Integer);
begin
  Parameters[i] := Copy(ParametersNew[i]);
  FitnessData[i] := FitnessDataNew[i];
end;

procedure TFA_DEcomplex.PopulationReSize;
begin
//  fNp := NewNp;
//  if fNp <= VectorForOppositePopulation.HighNumber then
//  begin
    Datatransform;
    VectorForOppositePopulation.SetLenVector(fNp);
    VectorForOppositePopulationFilling;
//  end;
end;

procedure TFA_DEcomplex.Datatransform;
 var i,k:integer;
begin
 for I := fNp to VectorForOppositePopulation.HighNumber do
  begin
    k:=round(VectorForOppositePopulation.Y[i]);
    Parameters[k]:=Copy(Parameters[i]);
    FitnessData[k]:=FitnessData[i];
  end;
end;

destructor TFA_DEcomplex.Destroy;
begin
  FreeAndNil(FandCrCreator);
  inherited;
end;

procedure TFA_DEcomplex.GreedySelectionAll;
 var i:integer;
begin
 for I := 0 to fNp-1 do
  if FandCrCreator.NewIsBetter(i)
   then PopulationUpDate(i);
end;

procedure TFA_DEcomplex.KoefDetermination;
begin
 inherited;
 VectorForOppositePopulationFilling;
 fNp := NewNp;
 if fNp <= VectorForOppositePopulation.HighNumber
   then PopulationReSize;
 FandCrCreator.UpDate;
 FandCrCreator.GenerateData;
end;

function TFA_DEcomplex.NewNp: integer;
begin
 Result:=round(LinearDecrease(NPinit,NPmin));
// Result:=round((NPmin-NPinit)*fCurrentIteration
//          /(fFF.fDParamArray as TDParamsIteration).Nit
//            +NPinit);
end;

procedure TFA_DEcomplex.NewPopulationCreate(i: integer);
begin
  CR:=FandCrCreator.Cr[i];
  Crossover(i);
end;

procedure TFA_DEcomplex.VectorForOppositePopulationFilling;
 var i:integer;
begin
 for I := 0 to fNp - 1 do
   begin
    VectorForOppositePopulation.X[i]:=FitnessData[i];
    VectorForOppositePopulation.Y[i]:=i;
   end;
 VectorForOppositePopulation.Sorting();
end;

{ TFA_NDE }

procedure TFA_NDE.AfterNewPopulationCreate;
 var i:integer;
     temp:double;
begin
 VectorForOppositePopulationFilling;
 NBs.ChangeNums();
 NBs.CalculateStdaver;
 for I := 0 to fNp - 1 do
  if NBs.NB[i].Numg=NBs.gm then
   if random>(NBs.NB[i].Nums/NBs.NB[i].Numg)
     then NBs.IncreaseNrsize(i)
     else
      begin
       temp:=(VectorForOppositePopulation.X[VectorForOppositePopulation.HighNumber]
             -VectorForOppositePopulation.X[0]);
       if temp=0 then
          Eps2:=1-fCurrentIteration/(fFF.fDParamArray as TDParamsIteration).Nit
                 else
          Eps2:=1-min(fCurrentIteration
                   /(fFF.fDParamArray as TDParamsIteration).Nit,
                   (VectorForOppositePopulation.X[VectorForOppositePopulation.HighNumber]
                   -FitnessData[i])/temp);


//       Eps2:=1-min(fCurrentIteration
//                   /(fFF.fDParamArray as TDParamsIteration).Nit,
//                   (VectorForOppositePopulation.X[VectorForOppositePopulation.HighNumber]
//                   -FitnessData[i])
//                   /(VectorForOppositePopulation.X[VectorForOppositePopulation.HighNumber]
//                   -VectorForOppositePopulation.X[0]));
       ParameterTemp:=Copy(Parameters[i]);
       if NBs.NB[i].Std<NBs.Std_aver then
        begin
         NDE_IndividualsGenerate(i, true);
        end                          else
        begin
         Parameters[i]:=Copy(Parameters[NBs.NB[i].Num_best]);
         NDE_IndividualsGenerate(i, false);
        end;
        NBs.NB[i].ClearNum;
      end;
end;

procedure TFA_NDE.CreateFields;
begin
  inherited CreateFields;
  fDescription:='NDE';
  NPmin:=5;
  NBs:=TNDE_neighborhoods.Create(Self);
  SetLength(ParameterTemp,fDim);
end;

destructor TFA_NDE.Destroy;
begin
  FreeAndNil(NBs);
  inherited;
end;

procedure TFA_NDE.FandCrCreatorCreate;
begin
 FandCrCreator:=TNDE_FandCrCreator.Create(Self);
end;

procedure TFA_NDE.MutationCreate(i: integer);
 var j:integer;
begin
// inherited MutationCreate(i);
 F:=FandCrCreator.F[i];
 NBs.DataCalculate(i,false);
 NBs.NB[i].ToOld;
  repeat
   r[1]:=Random(Np);
  until (r[1]<>i);
  repeat
   r[2]:=Random(Np);
  until (r[2]<>i){and(r[2]<>r[1])};

 if random<NBs.NB[i].Eps1 then
    for j := 0 to High(fToolKitArr) do
    ParametersNew[i][j]:=fToolKitArr[j].DE_Mutation(Parameters[NBs.NB[i].nr1,j],
                                                   Parameters[r[1],j],
                                                   Parameters[r[2],j],F)
                         else
    for j := 0 to High(fToolKitArr) do
    ParametersNew[i][j]:=fToolKitArr[j].DE_Mutation3(Parameters[i,j],
                                                   Parameters[NBs.NB[i].Num_best,j],
                                                   Parameters[i,j],
                                                   Parameters[NBs.NB[i].nr1,j],
                                                   Parameters[NBs.NB[i].nr2,j],
                                                   Parameters[r[1],j],
                                                   Parameters[r[2],j],F);

end;

procedure TFA_NDE.NDE_IndividualsGenerate(i: integer; IsRandomUsed: boolean);
 var j:integer;
begin
  repeat
     ConditionalRandomize;
     if IsRandomUsed then RandomValueToParameter(i);
     for j := 0 to fDim-1 do
      begin
      if random>=Eps2 then
        Parameters[i][j]:=ParameterTemp[j];
//      if (fToolKitArr[j] is TToolKitLog)and(Parameters[i][j]<0) then showmessage('oops!');

      end;
     try
      FitnessData[i]:=FitnessFunc(Parameters[i]);
     except
      Continue;
     end;
  until (true);
end;

function TFA_NDE.NpDetermination: integer;
begin
  Result:=(fFF.DParamArray.MainParamHighIndex+1)*10;
end;

procedure TFA_NDE.PopulationReSize;
begin
  inherited PopulationReSize;
  NBs.ReSize;
end;

{ TFA_WaterWave }

procedure TFA_WaterWave.AfterNewPopulationCreate;
 var f_max,f_min:double;
     i:integer;
     IsEquals:boolean;
begin
 f_max:=MaxValue(FitnessData);
 f_min:=MinValue(FitnessData);
 IsEquals:=IsEqual(f_max,f_min);
 for I := 0 to Np - 1 do
  if IsEquals
   then WaveLengths[i]:=WaveLengths[i]/alpha
   else WaveLengths[i]:=WaveLengths[i]
             *Power(alpha,-(f_max-FitnessData[i])/(f_max-f_min))
end;

procedure TFA_WaterWave.Breaking(i: integer);
 var Ks:array of integer;
     l,j,k:integer;
     bool:boolean;
begin
 SetLength(Ks,random(k_max)+1);
 for l := 0 to High(Ks) do
  begin
  repeat
    k:=random(fDim);
    bool:=true;
    for j := 0 to l - 1 do
      bool:=bool and (k<>Ks[j])
  until bool;
  Ks[l]:=k;
  end;

 ParametersNew[i]:=Copy(Parameters[i]);
 for j := 0 to High(Ks) do
  begin
    repeat
      ConditionalRandomize;
      ParametersNew[i][Ks[j]]:=fToolKitArr[Ks[j]].WaterWave_Prop(ParametersNew[i][Ks[j]],
                                                             betta*RandG(0,1));
     try
      FitnessDataNew[i]:=FitnessFunc(ParametersNew[i]);
     except
      Continue;
     end;
    until (true);
    if FitnessDataNew[i]<FitnessData[i] then
     begin
       Parameters[i,Ks[j]]:=ParametersNew[i][Ks[j]];
       FitnessData[i]:=FitnessDataNew[i];
     end                                else
       ParametersNew[i,Ks[j]]:=Parameters[i][Ks[j]];
  end;
end;

procedure TFA_WaterWave.CreateFields;
 var i:integer;
begin
 inherited;
 fDescription:='Water Waves';
 h_max:=6;
 SetLength(WaveLengths,Np);
 SetLength(Amplitudes,Np);
 for i := 0 to Np - 1 do
  begin
   Amplitudes[i]:=h_max;
   WaveLengths[i]:=0.5;
  end;
 k_max:=min(12,round(Dim/2));
 alpha:=1.026;
 betta_init:=0.25;
 betta_end:=0.001;
end;

procedure TFA_WaterWave.DataCoordination;
begin
  ArrayToHeuristicParam(Parameters[NumberBest]);
end;

procedure TFA_WaterWave.GreedySelectionAll;
 var i:integer;
begin
 for I := 0 to fNp-1 do
   if GreedySelection(i,FitnessDataNew[i],ParametersNew[i])
     then
      begin
       if FitnessData[i]<=FitnessData[NumberBest] then
         begin
           Breaking(i);
           NumberBest:=i;
         end;
      end
     else
      begin
       Amplitudes[i]:=Amplitudes[i]-1;
       if Amplitudes[i]=0 then Refraction(i);
      end;
end;

procedure TFA_WaterWave.KoefDetermination;
begin
 inherited;
// NumberBest:=MinElemNumber(FitnessData);
 betta:=NewBetta();
end;

function TFA_WaterWave.NewBetta: double;
begin
 Result:=LinearDecrease(betta_init,betta_end);
end;

procedure TFA_WaterWave.NewPopulationCreate(i: integer);
begin
 Propagation(i);
end;

function TFA_WaterWave.NpDetermination: integer;
begin
 Result:=10;
end;

procedure TFA_WaterWave.Propagation(i: integer);
 var    j:integer;
begin
 for j := 0 to High(fToolKitArr) do
  ParametersNew[i][j]:=fToolKitArr[j].WaterWave_Prop(Parameters[i,j],
                                                WaveLengths[i]*(Random*2-1));
end;

procedure TFA_WaterWave.Refraction(i: integer);
 var    j:integer;
begin
  FitnessDataNew[i]:=FitnessData[i];
  repeat
     ConditionalRandomize;
     for j := 0 to High(fToolKitArr) do
      ParametersNew[i][j]:=fToolKitArr[j].WaterWave_Refrac(Parameters[i,j],
                                                    Parameters[NumberBest,j]);
     try
      FitnessData[i]:=FitnessFunc(Parameters[i]);
     except
      Continue;
     end;
  until (true);
  Amplitudes[i]:=h_max;
  if FitnessDataNew[i]=0
   then WaveLengths[i]:=WaveLengths[i]
   else
     WaveLengths[i]:=WaveLengths[i]*FitnessData[i]/FitnessDataNew[i];
end;

procedure TFA_WaterWave.StartAction;
begin
  inherited StartAction;
  NumberBest:=MinElemNumber(FitnessData);
end;

end.
