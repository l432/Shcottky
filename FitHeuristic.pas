unit FitHeuristic;

interface

uses
  FitGradient, OlegType, FitIteration, OApproxNew, OlegVector;

type

TFFHeuristic=class(TFFIteration)
 private
  function GetParamsHeuristic:TDParamsHeuristic;
 protected
  function RealFinalFunc(X:double):double;override;
 public
  property ParamsHeuristic:TDParamsHeuristic read GetParamsHeuristic;
  function FuncForFitness(X:double;Data:TArrSingle):double;virtual;abstract;
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
  function Term(X,Y:double;
                 Parameters:TArrSingle):double;overload;virtual;abstract;
  function Term(Point:TPointDouble;Parameters:TArrSingle):double;overload;
  destructor Destroy;override;
end;


TFitnessTermSR=class(TFitnessTerm)
 public
  function Term(X,Y:double;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTermRSR=class(TFitnessTerm)
 public
  function Term(X,Y:double;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTermAR=class(TFitnessTerm)
 public
  function Term(X,Y:double;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTermRAR=class(TFitnessTerm)
 public
  function Term(X,Y:double;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTermLnSR=class(TFitnessTerm)
 public
  function Term(X,Y:double;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTermLnRSR=class(TFitnessTerm)
 public
  function Term(X,Y:double;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTermLnAR=class(TFitnessTerm)
 public
  function Term(X,Y:double;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTermLnRAR=class(TFitnessTerm)
 public
  function Term(X,Y:double;
                 Parameters:TArrSingle):double;override;
end;

TFitnessTerm_Class=class of TFitnessTerm;

const
  FitnessTermClasses:array[TFitnessType]of TFitnessTerm_Class=
  (TFitnessTermSR,TFitnessTermRSR,
   TFitnessTermAR,TFitnessTermRAR);

  LogFitnessTermClasses:array[TFitnessType]of TFitnessTerm_Class=
  (TFitnessTermLnSR,TFitnessTermLnRSR,
   TFitnessTermLnAR,TFitnessTermLnRAR);


type

TRegulationZero=class
 public
  function Term(Parameters:TArrSingle):double;virtual;
end;

TRegTerm=class
  fXmin:double;
  fXmaxXmin:double;
  fIsLog:boolean;
 public
  Number:integer;//порядковий номер в масиві параметрів
  constructor Create(const Param:TFFParamHeuristic);
  function RegTerm(Arg:double):double;
end;

TRegulation=class(TRegulationZero)
  fRegTerms:array of TRegTerm;
  fRegWeight:double;
 public
  constructor Create(FF:TFFHeuristic);
//  function Term(Parameters:TArrSingle):double;virtual;abstract;
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

TFA_Heuristic=class(TFittingAgent)
//  fFuncForFitness:TFunObj;
//  fParamsHeuristic:TDParamsHeuristic;
 private
  fData:TVector;
  fFF:TFFHeuristic;
  fFitTerm:TFitnessTerm;
  fRegTerm:TRegulationZero;
  FitnessData:TArrSingle;
  procedure Initiation;
 {початкове встановлення випадкових значень
 параметрів та розрахунок
 відповідних величин цільової функції}
  Function FitnessFunc(OutputData:TArrSingle):double;
 {цільова функція для оцінки якості апроксимації
 даних в InputData з використанням OutputData}
 public
  constructor Create(FF:TFFHeuristic);
  destructor Destroy;override;
end;

//TFittingAgent=class
//{той, що вміє проводити ітераційний процес}
// private
//  fDescription:string;
//  fCurrentIteration:integer;
//  fToStop:boolean;
////  fIsDone:boolean;
// public
//  property Description:string read fDescription;
//  property CurrentIteration:integer read fCurrentIteration;
////  property IsDone:boolean read fIsDone write fIsDone;
//  property ToStop:boolean read fToStop;
//  procedure StartAction;virtual;
//  procedure IterationAction;virtual;abstract;
////  procedure EndAction;virtual;abstract;
//end;

implementation

uses
  SysUtils;

{ TFFHeuristic }

function TFFHeuristic.GetParamsHeuristic: TDParamsHeuristic;
begin
 Result:=(fDParamArray as TDParamsHeuristic);
end;

function TFFHeuristic.RealFinalFunc(X: double): double;
begin
 Result:=FuncForFitness(X,fDParamArray.OutputData);
end;

{ TFA_Heuristic }

constructor TFA_Heuristic.Create(FF: TFFHeuristic);
begin
 inherited Create;
 fFF:=FF;

 if FF.ParamsHeuristic.LogFitness
  then fFitTerm:=FitnessTermClasses[FF.ParamsHeuristic.FitType].Create(FF)
  else fFitTerm:=LogFitnessTermClasses[FF.ParamsHeuristic.FitType].Create(FF);

 fData:=TVector.Create(FF.DataToFit);
 if (FF.ParamsHeuristic.ArgumentType=cY) then fData.SwapXY;

 if (FF.ParamsHeuristic.RegWeight=0)
   then fRegTerm:=TRegulationZero.Create
   else fRegTerm:=RegulationClasses[FF.ParamsHeuristic.RegType].Create(FF);
//  fFuncForFitness:=FF.FuncForFitness;
//  fParamsHeuristic:=FF.ParamsHeuristic;
end;

destructor TFA_Heuristic.Destroy;
begin
  FreeAndNil(fRegTerm);
  FreeAndNil(fFitTerm);
  FreeAndNil(fData);
  fFF:=nil;
//  fFuncForFitness:=nil;
//  fParamsHeuristic:=nil;
  inherited;
end;

function TFA_Heuristic.FitnessFunc(OutputData: TArrSingle): double;
 var i:integer;
begin
 Result:=0;
 for I := 0 to fData.HighNumber do
    Result:=Result+fFitTerm.Term(fData[i],OutputData);
 Result:=Result+fRegTerm.Term(OutputData);
end;

procedure TFA_Heuristic.Initiation;
begin
// var i:integer;
//begin
//  i:=0;
//  repeat
//   if (i mod 25)=0 then Randomize;
//     VarRand(X[i]);
//     try
//      Fit[i]:=FitnessFunc(InputData,X[i])
//     except
//      Continue;
//     end;
//    inc(i);
//  until (i>High(X));

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

function TFitnessTerm.Term(Point: TPointDouble; Parameters: TArrSingle): double;
begin
 Result:=Term(Point[cX],Point[cY],Parameters);
end;

{ TFitnessTermSR }

function TFitnessTermSR.Term(X,Y:double;
                              Parameters:TArrSingle):double;
begin
 Result:=sqr(fFuncForFitness(X,Parameters)-Y);
end;

{ TFitnessTermRSR }

function TFitnessTermRSR.Term(X, Y: double; Parameters: TArrSingle): double;
begin
 try
  Result:=sqr((fFuncForFitness(X,Parameters)-Y)/Y);
 except
  Result:=0;
 end;
end;

{ TFitnessTermAR }

function TFitnessTermAR.Term(X, Y: double; Parameters: TArrSingle): double;
begin
 Result:=abs(fFuncForFitness(X,Parameters)-Y);
end;

{ TFitnessTermRAR }

function TFitnessTermRAR.Term(X, Y: double; Parameters: TArrSingle): double;
begin
 try
  Result:=abs((fFuncForFitness(X,Parameters)-Y)/Y);
 except
  Result:=0;
 end;
end;

{ TFitnessTermLogSR }

function TFitnessTermLnSR.Term(X, Y: double; Parameters: TArrSingle): double;
begin
 try
  Result:=sqr(ln(fFuncForFitness(X,Parameters))-ln(Y));
 except
  Result:=0;
 end;
end;

{ TFitnessTermLnRSR }

function TFitnessTermLnRSR.Term(X, Y: double; Parameters: TArrSingle): double;
begin
 try
  Result:=sqr((ln(fFuncForFitness(X,Parameters))-ln(Y))/ln(Y));
 except
  Result:=0;
 end;
end;

{ TFitnessTermLnAR }

function TFitnessTermLnAR.Term(X, Y: double; Parameters: TArrSingle): double;
begin
 try
  Result:=abs(ln(fFuncForFitness(X,Parameters))-ln(Y));
 except
  Result:=0;
 end;
end;

{ TFitnessTermLnRAR }

function TFitnessTermLnRAR.Term(X, Y: double; Parameters: TArrSingle): double;
begin
  try
  Result:=abs((ln(fFuncForFitness(X,Parameters))-ln(Y))/ln(Y));
 except
  Result:=0;
 end;
end;

{ TRegTerm }

constructor TRegTerm.Create(const Param: TFFParamHeuristic);
begin
 fIsLog:=(Param.Mode=vr_ln);
 if fIsLog then begin
                 fXmin:=ln(Param.fMinLim);
                 fXmaxXmin:=ln(Param.fMaxLim)-fXmin;
                 end
            else begin
                 fXmin:=Param.fMinLim;
                 fXmaxXmin:=Param.fMaxLim-fXmin;
                 end
end;

function TRegTerm.RegTerm(Arg: double): double;
begin
 if fIsLog then Result:=(ln(Arg)-fXmin)
           else Result:=(Arg-fXmin)/fXmaxXmin;
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
        fRegTerms[High(fRegTerms)]:=TRegTerm.Create((FF.ParamsHeuristic.Parametr[i] as TFFParamHeuristic));
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

{ TRegulationZero }

function TRegulationZero.Term(Parameters: TArrSingle): double;
begin
 Result:=0;
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

end.
