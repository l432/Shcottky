unit OApproxNew2;

interface

uses
  OApproxNew, FitVariable, OlegApprox;

type

TFitFunctionWithArbitraryArgument =class(TFitFunctionNew)
  {абстрактний клас для випадку, коли апроксимуюча
  функція може бути розрахована у будь-якій точці...ну практично}
 private
  fIntVars:TVarIntArray;
  {в цьому класі міститиме лише один параметр, Npoint
  кількість точок у фітуючій залежності;
  якщо = 0, то стільки ж, як у вхідних даних;
  деякі класи, як то TFFNoiseSmoothing можуть перевизначати
  призначення параметру}
 protected
  Procedure RealToFile (suf:string;NumberDigit: Byte=8);override;
  procedure FileFilling(suf:string;NumberDigit: Byte=8);virtual;
  procedure DipazonCreate;override;
  procedure DiapazonDestroy;override;
  function ParameterCreate:TFFParameter;override;
 end;

TFFNoiseSmoothing=class(TFitFunctionWithArbitraryArgument)
 protected
  procedure RealFitting;override;
  procedure DipazonCreate;override;
 public
 constructor Create;
end;

TFFSplain=class(TFitFunctionWithArbitraryArgument)
 protected
  procedure RealFitting;override;
 public
 constructor Create;
end;


//TFitFunctionWithArbitraryArgument =class(TFitFunctionNew)
//  {абстрактний клас для випадку, коли апроксимуюча
//  функція може бути розрахована у будь-якій точці...ну практично}
// private
//  fIntVars:TVarIntArray;
// protected
//  procedure RealFitting;override;
//  Procedure RealToFile (suf:string;NumberDigit: Byte=8);override;
//  procedure DipazonCreate;override;
//  procedure DiapazonDestroy;override;
//  function ParameterCreate:TFFParameter;override;
//  procedure  FittingCalculation;virtual;abstract;
//  procedure FittingDataFilling;virtual;abstract;
//  procedure FileFilling;virtual;abstract;
//end;




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


implementation

uses
  FitVariableShow;


{ TFFSplain }



constructor TFFSplain.Create;
begin
  inherited Create('Splain','Approximation by cubic splines');
end;

procedure TFFSplain.RealFitting;
begin
 fDataToFit.Splain3(FittingData,fIntVars[0]);
end;



{ TNoiseSmoothingNew }

constructor TFFNoiseSmoothing.Create;
begin
 inherited Create('NoiseSmoothing','Noise Smoothing on Np point');
end;

procedure TFFNoiseSmoothing.DipazonCreate;
begin
  inherited;
  fIntVars.ParametrByName['Npoint'].Description:=
        'Number of smoothing poins';
end;


procedure TFFNoiseSmoothing.RealFitting;
begin
 fDataToFit.ImNoiseSmoothedArray(FittingData,fIntVars[0]);
end;


{ TFitFunctionWithArbitraryArgument }

procedure TFitFunctionWithArbitraryArgument.DiapazonDestroy;
begin
 fIntVars.Free;
 inherited;
end;

procedure TFitFunctionWithArbitraryArgument.DipazonCreate;
begin
  inherited;
  fIntVars:=TVarIntArray.Create(Self,'Npoint');
  fIntVars.ParametrByName['Npoint'].Limits.SetLimits(0);
  fIntVars.ParametrByName['Npoint'].Description:=
        'Fitting poin number (0 - as in init date)';
end;

procedure TFitFunctionWithArbitraryArgument.FileFilling(suf:string;NumberDigit: Byte=8);
begin
  FittingData.WriteToFile(FitName(FittingData,suf),NumberDigit);
end;

function TFitFunctionWithArbitraryArgument.ParameterCreate: TFFParameter;
begin
 Result:=TDecVarNumberArrayParameter.Create(fIntVars,
                         inherited ParameterCreate);
end;


procedure TFitFunctionWithArbitraryArgument.RealToFile(suf: string;
  NumberDigit: Byte);
begin
  if fIntVars[0]<>0 then FileFilling(suf,NumberDigit)
                    else Inherited  RealToFile(suf,NumberDigit);
end;

end.
