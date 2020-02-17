unit FitHeuristic;

interface

uses
  FitGradient, OlegType, FitIteration, OApproxNew, OlegVector,
  OlegMath, OlegFunction;

type

TFFHeuristic=class(TFFIteration)
 private
  fPoint:TPointDouble;
  function GetParamsHeuristic:TDParamsHeuristic;
 protected
//  procedure TuningBeforeAccessorialDataCreate;override;
  function RealFinalFunc(X:double):double;override;
  procedure FittingAgentCreate;override;
 public
  property ParamsHeuristic:TDParamsHeuristic read GetParamsHeuristic;
  function FuncForFitness(Point:TPointDouble;Data:TArrSingle):double;virtual;abstract;
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
  FitnessTermClasses:array[TFitnessType]of TFitnessTerm_Class=
  (TFitnessTermSR,TFitnessTermRSR,
   TFitnessTermAR,TFitnessTermRAR);

  LogFitnessTermClasses:array[TFitnessType]of TFitnessTerm_Class=
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
  Number:integer;//���������� ����� � ����� ���������
  function RegTerm(Arg:double):double;virtual;abstract;
end;

TRegTerm=class(TReTerm)
//  fXmin:double;
//  fXmaxXmin:double;
//  fIsLog:boolean;
 public
//  Number:integer;//���������� ����� � ����� ���������
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
  fData:TVector;
  fFitTerm:TFitnessTerm;
 public
  constructor Create(FF:TFFHeuristic);
  Function FitnessFunc(const OutputData:TArrSingle):double;virtual;
  destructor Destroy;override;
end;

TFitnessCalculationWithRegalation=class(TFitnessCalculation)
 private
  fRegTerm:TRegulation;
 public
  constructor Create(FF:TFFHeuristic);
  Function FitnessFunc(const OutputData:TArrSingle):double;override;
  destructor Destroy;override;
end;


TToolKit=class
 private
  Xmin:double;
  Xmax:double;
  procedure DataSave(const Param: TFFParamHeuristic);virtual;
 public
  constructor Create(const Param:TFFParamHeuristic);
  function RandValue:double;virtual;abstract;
 {������� ��������� � ��������� Xmin-Xmax}
  procedure Penalty(var X:double);virtual;abstract;
 {���� � �� ������ ���������, �� ������� ���� ����}
  function DE_Mutation(X1,X2,X3,F:double):double;virtual;abstract;
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
end;

TToolKitConst=class(TToolKit)
 private
  procedure DataSave(const Param: TFFParamHeuristic);override;
 public
//  constructor Create(const Param:TFFParamHeuristic);override;
  function RandValue:double;override;
  procedure Penalty(var X:double);override;
  function DE_Mutation(X1,X2,X3,F:double):double;override;
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
  {������� ������� FitnessFunc}
  fNp:integer;
  {������� ������ ���������}
  fFF:TFFHeuristic;
  fFitCalcul:TFitnessCalculation;
  fToolKitArr:array of TToolKit;
  Parameters:TArrArrSingle;
  {������ ���������}
  FitnessData:TArrSingle;
  {�������� ������� ������� ��� ����� ������ ���������}
  procedure RandomValueToParameter(i:integer);
  {��������� ���������� ������
  �-�� ������ � Parameters}
  procedure Penalty (X:TArrSingle);
  {������������ ��������  ������ �}
  procedure Initiation;
  {��������� ������������ ���������� �������
  ��������� �� ����������
  ��������� ������� ������� �������}
  Function FitnessFunc(OutputData:TArrSingle):double;
 {������� ������� ��� ������ ����� ������������
 ����� � InputData � ������������� OutputData}
  function NpDetermination:integer;virtual;abstract;
  procedure ConditionalRandomize;
  procedure CreateFields;virtual;
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
  {��������� �-�� ������� �������}
  procedure Crossover(i:integer);
  procedure MutationCreateAll;
  procedure CrossoverAll;
  procedure GreedySelection;
  procedure CreateFields;override;
 public
//  constructor Create(FF:TFFHeuristic);
  procedure IterationAction;override;
//  procedure DataCoordination;override;
end;


TFA_MABC=class(TFA_Heuristic)
 private
//  F:double;
//  CR:double;
//  r:array [1..3] of integer;
//  Mutation:TArrArrSingle;
  FitnessDataMutation:TArrSingle;
  Count:TArrSingle;
  ParametersNew:TArrSingle;
  Limit:integer;
  function NpDetermination:integer;override;
//  procedure MutationCreate(i:integer);
//  {��������� �-�� ������� �������}
//  procedure Crossover(i:integer);
//  procedure MutationCreateAll;
//  procedure CrossoverAll;
//  procedure GreedySelection;
  procedure CreateFields;override;
 public
  procedure IterationAction;override;
//  procedure DataCoordination;override;
end;

//TFittingAgent=class
//{���, �� �쳺 ��������� ����������� ������}
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
  SysUtils, Math, Dialogs;

{ TFFHeuristic }

procedure TFFHeuristic.FittingAgentCreate;
begin
 fFittingAgent:=TFA_DE.Create(Self);
end;

function TFFHeuristic.GetParamsHeuristic: TDParamsHeuristic;
begin
 Result:=(fDParamArray as TDParamsHeuristic);
end;

function TFFHeuristic.RealFinalFunc(X: double): double;
begin
 fPoint[cX]:=X;
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
  if (fNfit mod 100)=0 then Randomize;
end;

constructor TFA_Heuristic.Create(FF: TFFHeuristic);
 var i:integer;
begin
 inherited Create;
 fFF:=FF;

 if (FF.ParamsHeuristic.RegWeight=0)
   then fFitCalcul:=TFitnessCalculation.Create(FF)
   else fFitCalcul:=TFitnessCalculationWithRegalation.Create(FF);

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

procedure TFA_Heuristic.Penalty(X:TArrSingle);
 var j:integer;
begin
 Randomize;
 for j := 0 to High(fToolKitArr) do
  fToolKitArr[j].Penalty(X[j]);
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
 try
  Result:=sqr((fFuncForFitness(Point,Parameters)-Point[cY])/Point[cY]);
 except
  Result:=0;
 end;
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
  Result:=abs((fFuncForFitness(Point,Parameters)-Point[cY])/Point[cY]);
 except
  Result:=0;
 end;
end;

{ TFitnessTermLogSR }

function TFitnessTermLnSR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
 try
  Result:=sqr(ln(fFuncForFitness(Point,Parameters))-ln(Point[cY]));
 except
  Result:=0;
 end;
end;

{ TFitnessTermLnRSR }

function TFitnessTermLnRSR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
 try
  Result:=sqr((ln(fFuncForFitness(Point,Parameters))-ln(Point[cY]))/ln(Point[cY]));
 except
  Result:=0;
 end;
end;

{ TFitnessTermLnAR }

function TFitnessTermLnAR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
 try
  Result:=abs(ln(fFuncForFitness(Point,Parameters))-ln(Point[cY]));
 except
  Result:=0;
 end;
end;

{ TFitnessTermLnRAR }

function TFitnessTermLnRAR.Term(Point:TPointDouble; Parameters: TArrSingle): double;
begin
  try
  Result:=abs((ln(fFuncForFitness(Point,Parameters))-ln(Point[cY]))/ln(Point[cY]));
 except
  Result:=0;
 end;
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

{ TFitnessCalculation }

constructor TFitnessCalculation.Create(FF: TFFHeuristic);
begin
 inherited Create;
 if FF.ParamsHeuristic.LogFitness
  then fFitTerm:=LogFitnessTermClasses[FF.ParamsHeuristic.FitType].Create(FF)
  else fFitTerm:=FitnessTermClasses[FF.ParamsHeuristic.FitType].Create(FF);

 fData:=TVector.Create(FF.DataToFit);
 if (FF.ParamsHeuristic.ArgumentType=cY) then fData.SwapXY;
end;

destructor TFitnessCalculation.Destroy;
begin
  FreeAndNil(fFitTerm);
  FreeAndNil(fData);
  inherited;
end;

function TFitnessCalculation.FitnessFunc(const OutputData: TArrSingle): double;
 var i:integer;
begin
 Result:=0;
 for I := 0 to fData.HighNumber do
    Result:=Result+fFitTerm.Term(fData[i],OutputData);
end;

{ TFitnessCalculationWithRegalation }

constructor TFitnessCalculationWithRegalation.Create(FF: TFFHeuristic);
begin
 inherited;
 fRegTerm:=RegulationClasses[FF.ParamsHeuristic.RegType].Create(FF);
end;

destructor TFitnessCalculationWithRegalation.Destroy;
begin
  FreeAndNil(fRegTerm);
  inherited;
end;

function TFitnessCalculationWithRegalation.FitnessFunc(
  const OutputData: TArrSingle): double;
begin
 Result:=fRegTerm.Term(OutputData)+inherited FitnessFunc(OutputData);
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
end;

procedure TToolKitLinear.Penalty(var X: double);
 var temp:double;
begin
 while not(InRange(X,Xmin,Xmax)) do
  begin
    if X>Xmax then temp:=X-Random*Xmax_Xmin
               else temp:=X+Random*Xmax_Xmin;
    if InRange(temp,Xmin,Xmax) then X:=temp;
  end;
end;

function TToolKitLinear.RandValue: double;
begin
   Result:=Xmin+Xmax_Xmin*Random;
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
begin
 Result:=exp(ln(X1)+F*(ln(X2)-ln(X3)));
end;

procedure TToolKitLog.Penalty(var X: double);
 var temp,lnX:double;
begin
 if InRange(X,Xmin,Xmax) then Exit;
 lnX:=ln(X);
 while not(InRange(X,Xmin,Xmax)) do
  begin
    if lnX>lnXmax then temp:=lnX-Random*lnXmax_Xmin
                  else temp:=lnX+Random*lnXmax_Xmin;
    if InRange(temp,lnXmin,lnXmax) then X:=exp(temp);
  end;

end;

function TToolKitLog.RandValue: double;
begin
 Result:=exp(lnXmin+lnXmax_Xmin*Random);
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

function TToolKitConst.RandValue: double;
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

procedure TFA_DE.GreedySelection;
 var i:integer;
begin
 for I := 0 to High(FitnessData) do
 if FitnessData[i]>FitnessDataMutation[i] then
   begin
    Parameters[i]:=Copy(Mutation[i]);
    FitnessData[i]:=FitnessDataMutation[i]
   end;
end;

procedure TFA_DE.IterationAction;
begin
   MutationCreateAll;
   CrossoverAll;
   GreedySelection;
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
   Penalty(Mutation[i]);
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
 InitArrSingle(Count,word(fNp),0);
 SetLength(ParametersNew,fFF.DParamArray.MainParamHighIndex+1);
 fDescription:='Modified Artificial Bee Colony';
 Limit:=36;
end;

//procedure TFA_MABC.DataCoordination;
//begin
//  inherited;
//
//end;

procedure TFA_MABC.IterationAction;
begin
//     i:=0;
//     repeat  //Employed bee
//      if (i mod 25)=0 then Randomize;
//      NewSolution(i);
//      if Fit[i]>FitMut[i] then
//       begin
//        X[i]:=Copy(Xnew);
//        Fit[i]:=FitMut[i];
//        Count[i]:=0;
//       end
//                     else
//        Count[i]:=Count[i]+1;
//      inc(i);
//     until (i>(Np-1));  //Employed bee
//
//     SumFit:=0;   //Onlookers bee
//     for I := 0 to Np - 1 do
//       SumFit:=SumFit+1/(1+Fit[i]);
//
//     i:=0;//�����   Onlookers bee
//     j:=0; // ����� ������� ����
//     repeat
//       if (i mod 25)=0 then Randomize;
//       if Random<1/(1+Fit[j])/SumFit then
//        begin
//          i:=i+1;
//          NewSolution(j);
//          if Fit[j]>FitMut[j] then
//           begin
//           X[j]:=Copy(Xnew);
//           Fit[j]:=FitMut[j];
//           Count[j]:=0;
//           end
//        end;    // if Random<1/(1+Fit[j])/SumFit then
//       j:=j+1;
//       if j=Np then j:=0;
//     until(i=Np);     //Onlookers bee
//
//     i:=0;
//     repeat   //scout
//      if (i mod 25)=0 then Randomize;
//      j:=MinElemNumber(Fit);
//      if (Count[i]>Limit)and(i<>j) then
//       begin
//        VarRand(X[i]);
//        try
//         Fit[i]:=FitnessFunc(InputData,X[i])
//        except
//         Continue;
//        end;
//        Count[i]:=0;
//       end;// if Count[i]>Limit then
//      inc(i);
//     until i>(Np-1);//scout

  inherited;
end;

function TFA_MABC.NpDetermination: integer;
begin
  Result:=(fFF.DParamArray.MainParamHighIndex+1)*8;
end;

end.
