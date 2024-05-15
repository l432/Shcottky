unit FitSimple;

interface

uses
  OApproxNew, FitVariable, Classes, OlegType, OlegMath, OlegVector,
  TeEngine, FitIteration;

type

TFitFunctionWithArbitraryArgument =class(TFitFunctionNew)
  {абстрактний клас для випадку, коли апроксимуюча
  функція може бути розрахована у будь-якій точці...ну практично}
  protected
  fIntVars:TVarIntArray;
  {в цьому класі міститиме лише один параметр, Npoint
  кількість точок у фітуючій залежності;
  якщо = 0, то стільки ж, як у вхідних даних;
  деякі класи, як то TFFNoiseSmoothing можуть перевизначати
  призначення параметру}
  Procedure RealToFile;override;
  procedure FileFilling;virtual;
  procedure AccessorialDataCreate;override;
  procedure AccessorialDataDestroy;override;
  function ParameterCreate:TFFParameter;override;
 end;

TFFNoiseSmoothing=class(TFitFunctionWithArbitraryArgument)
 protected
  procedure RealFitting;override;
  procedure AccessorialDataCreate;override;
  procedure NamesDefine;override;
//  procedure TuningAfterReadFromIni;override;
 public
// constructor Create;
end;

TFFSplain=class(TFitFunctionWithArbitraryArgument)
 protected
  procedure RealFitting;override;
  procedure NamesDefine;override;
//  procedure TuningAfterReadFromIni;override;
 public
//  constructor Create;
end;


TFFSimple=class (TFitFunctionWithArbitraryArgument)
{базовий клас для функцій, де визначаються параметри}
 protected
  fDParamArray:TDParamArray;
  procedure AccessorialDataCreate;override;
  procedure ParamArrayCreate;virtual;abstract;
  procedure AccessorialDataDestroy;override;
  procedure RealFitting;override;
  function FittingCalculation:boolean;virtual;abstract;
  procedure FittingDataFilling;virtual;
  procedure AdditionalParamDetermination;virtual;
  function Deviation:double;virtual;
 public
  property DParamArray:TDParamArray read fDParamArray;
  Procedure DataToStrings(OutStrings:TStrings);override;
  Procedure ParameterNamesToArray(var Arr:TArrStr);override;
  function ParametersNumber:byte;override;
  function ParameterName(i:byte):string;override;
  procedure OutputDataImport(Source:TArrSingle);override;
  procedure OutputDataExport(Target:TArrSingle);override;
  function ParameterIndexByName(Name:string):integer;override;
end;


TFFSimpleLogEnable=class (TFFSimple)
  {функція, яка дозволяє апроксимувати
  дані, представлені у логарифмічному масштабі}
 private
  fXlog: boolean;
  fYlog: boolean;
 protected
  procedure DataPreraration(InputData: TVector);override;
  procedure RealToGraph (Series: TChartSeries);override;
  procedure TuningAfterReadFromIni;override;
 public
  procedure SetAxisScale(Xlog:boolean=False;Ylog:boolean=False);
end;

TFFLinear=class (TFFSimpleLogEnable)
 protected
  procedure ParamArrayCreate;override;
  function FittingCalculation:boolean;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
public
end; // TFFLinear=class (TFFSimpleLogEnable)

TFFPVParareters=class (TFFSimpleLogEnable)
 protected
  procedure ParamArrayCreate;override;
  function FittingCalculation:boolean;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
  procedure TuningBeforeAccessorialDataCreate;override;
public
end; // TFFPVParareters=class (TFFSimpleLogEnable)


TFFOhmLaw=class (TFFSimpleLogEnable)
 protected
  procedure ParamArrayCreate;override;
  function FittingCalculation:boolean;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
public
end; // TFFOhmLaw=class (TFFSimpleLogEnable)


TFFQuadratic=class (TFFSimpleLogEnable)
 protected
  procedure ParamArrayCreate;override;
  function FittingCalculation:boolean;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
public
end; // TFFQuadratic=class (TFFSimpleLogEnable)

TFFGromov=class (TFFSimple)
 protected
  procedure ParamArrayCreate;override;
  function FittingCalculation:boolean;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
public
end; //TFFGromov=class (TFFSimple)

TFFPolinom=class (TFFSimple)
 protected
  procedure ParamArrayCreate;override;
  function FittingCalculation:boolean;override;
  procedure NamesDefine;override;
  procedure TuningAfterReadFromIni;override;
  function RealFinalFunc(X:double):double;override;
public
end; //TFFPolinom=class (TFFSimple)



//
//type
//  TProc = procedure of object;
//
//procedure TClassN.SomeMethod;
//var
//  Proc: TProc;
//begin
//  TMethod(Proc).Code := @TClass1.Mtd; // Статический адрес
//  TMethod(Proc).Data := Self;
//  Proc();
//end;
//
//
//
//type
//C1 = class
//procedure Method1;virtual;
//end;
//
//type
//C2 = class(C1)
//procedure Method1;override;
//end;
//
//type
//C3 = class(C2)
//procedure Method1;override;
//end;
//Известно, что внутри C3.Method1 можно вызвать C2.Method1
//как
//inherited Method1;
//А вот как внутри C3.Method1 явно вызвать C1.Method1?
//
//procedure C3.Method1;
//type tproc=procedure of object;
//var m:tmethod;
//begin
//m.code:=@c1.method1;
//m.data:=self;
//TProc(m);
//end;



//К слову, в реализации TStream, для такого случая, борланды используют довольно простой метод:
//
//procedure Object3.Method;
//var
//  c: TClass;
//begin
//  c:=ClassParent.ClassParent;
//  Object1(@c).Method;
//end;
//
//В этом случае приходит кривой Self, но если не оперировать с полями и свойствами этого достаточно. С прямым Self немного больше кода:
//
//procedure Object3.Method;
//var
//  c: TClass;
//  m: TThreadMethod; // применительно к примеру
//begin
//  c:=ClassParent.ClassParent;
//  m:=Object1(@c).Method;
//  TMethod(m).Data:=Self;
//  m;
//end;


//function TLevel3.VirtualFunction: string;
//
//var
//
//ClassOld: TClass;
//
//begin
//
//ClassOld := PClass(Self)^;
//
//PClass(Self)^ := Self.ClassParent.ClassParent;
//
//Result := VirtualFunction + ' Level3';
//
//PClass(Self)^ := ClassOld;
//
//end;


//------------------------

//TAllParentClass = class
//
//и несколько его наследников
//
//TAClass = class(TAllParentClass)
//TBClass = class(TAllParentClass)
//TCClass = class(TAllParentClass)
//
//далее такой вопрос
//
//как передать в функцию например инфу о классе наследнике и там его создать?
//
//function CreateAnyClass(?):TAllParentClass;
//begin
//Result:=?;
//end;

//разобрался, все просто
//
//надо было объявить
//
//
//
//TAllParentClass_Class=class of TAllParentClass
//
//тогда функция будет выглядеть
//
//
//
//function CreateAnyClass(AChildClass:TClass):TAllParentClass;
//begin
//Result:=TAllParentClass_Class(AChildClass).Create;
//end;




implementation

uses
  FitVariableShow, Graphics, Dialogs, SysUtils, Math, OlegFunction;


{ TFFSplain }

procedure TFFSplain.NamesDefine;
begin
  SetNameCaption('Splain','Approximation by cubic splines');
end;

procedure TFFSplain.RealFitting;
begin
 fDataToFit.Splain3(FittingData,fIntVars[0]);
end;



//procedure TFFSplain.TuningAfterReadFromIni;
//begin
//  inherited;
//  fHasPicture:=False;
//end;

{ TNoiseSmoothingNew }

procedure TFFNoiseSmoothing.AccessorialDataCreate;
begin
  inherited;
  fIntVars.ParametrByName['Npoint'].Description:=
        'Number of smoothing poins';
end;

procedure TFFNoiseSmoothing.NamesDefine;
begin
 SetNameCaption('NoiseSmoothing','Noise Smoothing on Np point')
end;

procedure TFFNoiseSmoothing.RealFitting;
begin
 fDataToFit.ImNoiseSmoothedArray(FittingData,fIntVars[0]);
end;


//procedure TFFNoiseSmoothing.TuningAfterReadFromIni;
//begin
//  inherited;
////  fHasPicture:=False;
//end;

{ TFitFunctionWithArbitraryArgument }

procedure TFitFunctionWithArbitraryArgument.AccessorialDataDestroy;
begin
 FreeAndNil(fIntVars);
 inherited;
end;

procedure TFitFunctionWithArbitraryArgument.AccessorialDataCreate;
begin
  inherited AccessorialDataCreate;
  fIntVars:=TVarIntArray.Create(Self,'Npoint');
  fIntVars.ParametrByName['Npoint'].Limits.SetLimits(0);
  fIntVars.ParametrByName['Npoint'].Description:=
        'Fitting point number (0 - as in init data)';
end;

procedure TFitFunctionWithArbitraryArgument.FileFilling;
begin
  FittingData.WriteToFile(FitName(FittingData,FileSuffix),DigitNumber);
end;

function TFitFunctionWithArbitraryArgument.ParameterCreate: TFFParameter;
begin
 Result:=TDecVarNumberArrayParameter.Create(fIntVars,
                         inherited ParameterCreate);
end;


procedure TFitFunctionWithArbitraryArgument.RealToFile;
begin
  if fIntVars[0]<>0 then FileFilling
                    else Inherited  RealToFile;
end;

{ TFFSimple }

procedure TFFSimple.AccessorialDataCreate;
begin
  inherited AccessorialDataCreate;
  ParamArrayCreate;
end;

procedure TFFSimple.AccessorialDataDestroy;
begin
  FreeAndNil(fDParamArray);
  inherited;
end;

procedure TFFSimple.AdditionalParamDetermination;
begin
 fDParamArray.OutputData[High(fDParamArray.OutputData)]:=Deviation;
end;

procedure TFFSimple.OutputDataImport(Source: TArrSingle);
 var i:integer;
begin
 for I := 0 to min(High(Source),High(DParamArray.OutputData)) do
   DParamArray.OutputData[i]:=Source[i];
 inherited OutputDataImport(Source);
end;

procedure TFFSimple.DataToStrings(OutStrings: TStrings);
begin
  inherited DataToStrings(OutStrings);
  if fResultsIsReady then  fDParamArray.DataToStrings(OutStrings);
end;

function TFFSimple.Deviation: double;
 var i:integer;
begin
  Result:=0;
  fDataToFit.ToFill(FittingData,RealFinalFunc);
  for I := 0 to fDataToFit.HighNumber
     do Result:=Result+SqrRelativeDifference(fDataToFit.Y[i],FittingData.Y[i]);
  Result:=sqrt(Result/fDataToFit.Count);

// Sq.Err
//  for I := 0 to fDataToFit.HighNumber
//     do Result:=Result+Sqr(fDataToFit.Y[i]-FittingData.Y[i]);
// Abs.Err
//  for I := 0 to fDataToFit.HighNumber
//     do Result:=Result+abs(fDataToFit.Y[i]-FittingData.Y[i]);
end;

procedure TFFSimple.FittingDataFilling;
begin
 if fIntVars[0]<>0 then
     begin
     FittingData.T:=fDataToFit.T;
     FittingData.name:=fDataToFit.name;
     FittingData.Filling(RealFinalFunc,fDataToFit.MinX,fDataToFit.MaxX,fIntVars[0])
     end;
end;

procedure TFFSimple.OutputDataExport(Target: TArrSingle);
 var i:integer;
begin
 if ResultsIsReady then
  begin
   SetLength(Target,High(DParamArray.OutputData)+1);
   for I := 0 to High(Target) do
     Target[i]:=DParamArray.OutputData[i];
  end              else
   inherited  OutputDataExport(Target);
end;

function TFFSimple.ParameterIndexByName(Name: string): integer;
 var i:integer;
begin
 Result:=inherited ParameterIndexByName(Name);
 for I := 0 to High(DParamArray.OutputData) do
  if DParamArray.fParams[i].Name=Name then
   begin
    Result:=i;
    Break;
   end;
end;

function TFFSimple.ParameterName(i: byte): string;
begin
  if i<High(DParamArray.fParams)
   then Result:=DParamArray.fParams[i].Name
   else Result:=inherited ParameterName(i);
end;

procedure TFFSimple.ParameterNamesToArray(var Arr: TArrStr);
 var i,temp:integer;
begin
 temp:=High(Arr);
 SetLength(Arr,temp+High(DParamArray.fParams)+2);
 for I := 0 to High(DParamArray.fParams) do
   Arr[i+temp+1]:=DParamArray.fParams[i].Description;
end;

function TFFSimple.ParametersNumber: byte;
begin
  Result:=High(DParamArray.fParams)+1;
end;

procedure TFFSimple.RealFitting;
begin
 if FittingCalculation then
  begin
  AdditionalParamDetermination;
  FittingDataFilling;
  end;
end;

{ TFFLinear }

function TFFLinear.FittingCalculation: boolean;
begin
 Result:=fDataToFit.LinAprox(fDParamArray.OutputData);
end;

procedure TFFLinear.NamesDefine;
begin
 SetNameCaption('Linear',
                  'Linear fitting, least-squares method');
end;

procedure TFFLinear.ParamArrayCreate;
begin
 fDParamArray:=TDParamArray.Create(Self,['A','B']);
end;

function TFFLinear.RealFinalFunc(X:double): double;
begin
 Result:=Linear(X,fDParamArray.OutputData);
end;


{ TFFOhmLaw }

function TFFOhmLaw.FittingCalculation: boolean;
begin
 fDParamArray.OutputData[0]:=fDataToFit.LinAproxAconst(0);
 if fDParamArray.OutputData[0]<>ErResult then
    try
      fDParamArray.OutputData[0]:=1/fDParamArray.OutputData[0];
    except
      fDParamArray.OutputData[0]:=ErResult;
    end;
 Result:=fDParamArray.OutputData[0]<>ErResult;
end;

procedure TFFOhmLaw.NamesDefine;
begin
 SetNameCaption('OhmLaw',
                  'Fitting by Ohm law, least-squares method');
end;

procedure TFFOhmLaw.ParamArrayCreate;
begin
  fDParamArray:=TDParamArray.Create(Self,['R']);
end;

function TFFOhmLaw.RealFinalFunc(X: double): double;
begin
 Result:=X/fDParamArray.OutputData[0];
end;

{ TFFQuadratic }

function TFFQuadratic.FittingCalculation: boolean;
begin
 Result:=fDataToFit.ParabAprox(fDParamArray.OutputData);
end;

procedure TFFQuadratic.NamesDefine;
begin
 SetNameCaption('Quadratic',
                  'Fitting by quadratic function, least-squares method');
end;

procedure TFFQuadratic.ParamArrayCreate;
begin
   fDParamArray:=TDParamArray.Create(Self,['A','B','C']);
end;

function TFFQuadratic.RealFinalFunc(X: double): double;
begin
 Result:=NPolinom(X,2,fDParamArray.OutputData);
end;

{ TFFGromov }

function TFFGromov.FittingCalculation: boolean;
begin
  Result:=fDataToFit.GromovAprox(fDParamArray.OutputData);
end;

procedure TFFGromov.NamesDefine;
begin
   SetNameCaption('Gromov',
      'Least-squares fitting,  which is used in Gromov and Lee methods');
end;

procedure TFFGromov.ParamArrayCreate;
begin
 fDParamArray:=TDParamArray.Create(Self,['A','B','C']);
end;

function TFFGromov.RealFinalFunc(X: double): double;
begin
 Result:=Gromov(X,fDParamArray.OutputData);
end;

{ TFFPolinom }

function TFFPolinom.FittingCalculation: boolean;
begin
 Result:=fDataToFit.NPolinomAprox(fIntVars[1],fDParamArray.OutputData);
end;

procedure TFFPolinom.NamesDefine;
begin
   SetNameCaption('Polinom',
      'Polynomial least-squares fitting, N is degree of polynomial function');
end;

procedure TFFPolinom.ParamArrayCreate;
begin
  fIntVars.Add(Self,'N');
  fIntVars.ParametrByName['N'].Limits.SetLimits(0);
  fIntVars.ParametrByName['N'].Description:=
        'Degree of polynomial function';
end;

function TFFPolinom.RealFinalFunc(X: double): double;
begin
 Result:=NPolinom(X,fIntVars[1],fDParamArray.OutputData);
end;

procedure TFFPolinom.TuningAfterReadFromIni;
 var Names:array of string;
     i:integer;
begin
  inherited;
//  fHasPicture:=False;
  SetLength(Names,(fIntVars.ParametrByName['N'] as TVarInteger).Value+1);
  for I := 0 to High(Names) do Names[i]:='A'+inttostr(i);
  fDParamArray:=TDParamArray.Create(Self,Names);
end;

{ TFFSimpleLogEnable }

procedure TFFSimpleLogEnable.DataPreraration(InputData: TVector);
 var i:integer;
begin
 inherited DataPreraration(InputData);
 try
  for i := 0 to fDataToFit.HighNumber do
   begin
     if fXLog then fDataToFit.X[i]:=Log10(fDataToFit.X[i]);
     if fYLog then fDataToFit.Y[i]:=Log10(fDataToFit.Y[i]);
   end;
 except
  fDataToFit.Free;
 end;

end;

procedure TFFSimpleLogEnable.RealToGraph(Series: TChartSeries);
 var i:integer;
begin
 FittingData.CopyTo(ftempVector);
 try
  for i := 0 to ftempVector.HighNumber do
   begin
     if fXLog then ftempVector.X[i]:=exp(ftempVector.X[i]*ln(10));
     if fYLog then ftempVector.Y[i]:=exp(ftempVector.Y[i]*ln(10));
   end;
 except
  ftempVector.Free;
 end;
  ftempVector.WriteToGraph(Series);
end;

procedure TFFSimpleLogEnable.SetAxisScale(Xlog, Ylog: boolean);
begin
  fXlog:=Xlog;
  fYlog:=Ylog;
end;

procedure TFFSimpleLogEnable.TuningAfterReadFromIni;
begin
  inherited;
  fXlog:=False;
  fYlog:=False;
end;

{ TFFPVParareters }

function TFFPVParareters.FittingCalculation: boolean;
begin
 Result:=fDataToFit.PVParareters(fDParamArray.OutputData);
end;

procedure TFFPVParareters.NamesDefine;
begin
 SetNameCaption('SC Parameters',
                  'Determination Voc, Isc, Pm, Vm, Im, FF (Prog. Photovolt: Res. Appl. v.25, p.623)');
end;

procedure TFFPVParareters.ParamArrayCreate;
begin
  fDParamArray:=TDParamArray.Create(Self,['Voc','Isc','Pm','Vm','Im','FF']);
end;

function TFFPVParareters.RealFinalFunc(X: double): double;
begin
 Result:=fDataToFit.Yvalue(X);
end;

procedure TFFPVParareters.TuningBeforeAccessorialDataCreate;
begin
  inherited;
  fHasPicture:=False;
end;

end.
