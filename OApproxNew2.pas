unit OApproxNew2;

interface

uses
  OApproxNew, FitVariable, OlegApprox, Classes, OlegType, OlegMath;

type

TFitFunctionWithArbitraryArgument =class(TFitFunctionNew)
  {����������� ���� ��� �������, ���� ������������
  ������� ���� ���� ����������� � ����-��� �����...�� ���������}
 private
  fIntVars:TVarIntArray;
  {� ����� ���� �������� ���� ���� ��������, Npoint
  ������� ����� � �������� ���������;
  ���� = 0, �� ������ �, �� � ������� �����;
  ���� �����, �� �� TFFNoiseSmoothing ������ �������������
  ����������� ���������}
 protected
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
  procedure Tuning;override;
 public
// constructor Create;
end;

TFFSplain=class(TFitFunctionWithArbitraryArgument)
 protected
  procedure RealFitting;override;
  procedure NamesDefine;override;
  procedure Tuning;override;
 public
//  constructor Create;
end;


TFFSimple=class (TFitFunctionWithArbitraryArgument)
{������� ���� ��� �������, �� ������������ ���������}
 private
  fDParamArray:TDParamArray;
 protected
//  fFun:TFun;
  procedure AccessorialDataCreate;override;
  procedure ParametersCreate;virtual;abstract;
  procedure AccessorialDataDestroy;override;
  procedure RealFitting;override;
  function FittingCalculation:boolean;virtual;abstract;
  procedure FittingDataFilling;
  procedure AddParamDetermination;
  function Deviation:double;
 public

//  constructor Create(FunctionName,FunctionCaption:string;
//                     const MainParamNames: array of string);overload;
//  constructor Create(FunctionName,FunctionCaption:string;
//                     const MainParamNames: array of string;
//                     const AddParamNames: array of string);overload;
//  destructor Destroy;override;
  Procedure DataToStrings(OutStrings:TStrings);override;
//  Function FinalFunc(X:double):double; override;
end;

TFFLinear=class (TFFSimple)
 protected
  procedure ParametersCreate;override;
  function FittingCalculation:boolean;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
public
end; // TFFLinear=class (TFFSimple)


TFFOhmLaw=class (TFFSimple)
 protected
  procedure ParametersCreate;override;
  function FittingCalculation:boolean;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
public
end; // TFFOhmLaw=class (TFFSimple)


TFFQuadratic=class (TFFSimple)
 protected
  procedure ParametersCreate;override;
  function FittingCalculation:boolean;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
public
end; // TFFQuadratic=class (TFitFunctionSimple)

TFFGromov=class (TFFSimple)
 protected
  procedure ParametersCreate;override;
  function FittingCalculation:boolean;override;
  procedure NamesDefine;override;
  function RealFinalFunc(X:double):double;override;
public
end; //TFFGromov=class (TFFSimple)

TFFPolinom=class (TFFSimple)
 protected
  procedure ParametersCreate;override;
  function FittingCalculation:boolean;override;
  procedure NamesDefine;override;
  procedure Tuning;override;
  function RealFinalFunc(X:double):double;override;
public
end; //TFFPolinom=class (TFFSimple)


//TFitFunctionWithArbitraryArgument =class(TFitFunctionNew)
//  {����������� ���� ��� �������, ���� ������������
//  ������� ���� ���� ����������� � ����-��� �����...�� ���������}
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
//  TMethod(Proc).Code := @TClass1.Mtd; // ����������� �����
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
//��������, ��� ������ C3.Method1 ����� ������� C2.Method1
//���
//inherited Method1;
//� ��� ��� ������ C3.Method1 ���� ������� C1.Method1?
//
//procedure C3.Method1;
//type tproc=procedure of object;
//var m:tmethod;
//begin
//m.code:=@c1.method1;
//m.data:=self;
//TProc(m);
//end;



//� �����, � ���������� TStream, ��� ������ ������, �������� ���������� �������� ������� �����:
//
//procedure Object3.Method;
//var
//  c: TClass;
//begin
//  c:=ClassParent.ClassParent;
//  Object1(@c).Method;
//end;
//
//� ���� ������ �������� ������ Self, �� ���� �� ����������� � ������ � ���������� ����� ����������. � ������ Self ������� ������ ����:
//
//procedure Object3.Method;
//var
//  c: TClass;
//  m: TThreadMethod; // ������������� � �������
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
//� ��������� ��� �����������
//
//TAClass = class(TAllParentClass)
//TBClass = class(TAllParentClass)
//TCClass = class(TAllParentClass)
//
//����� ����� ������
//
//��� �������� � ������� �������� ���� � ������ ���������� � ��� ��� �������?
//
//function CreateAnyClass(?):TAllParentClass;
//begin
//Result:=?;
//end;

//����������, ��� ������
//
//���� ���� ��������
//
//
//
//TAllParentClass_Class=class of TAllParentClass
//
//����� ������� ����� ���������
//
//
//
//function CreateAnyClass(AChildClass:TClass):TAllParentClass;
//begin
//Result:=TAllParentClass_Class(AChildClass).Create;
//end;




implementation

uses
  FitVariableShow, Graphics, Dialogs, SysUtils;


{ TFFSplain }



//constructor TFFSplain.Create;
//begin
//  inherited Create;
//  SetNameCaption('Splain','Approximation by cubic splines');
//end;

procedure TFFSplain.NamesDefine;
begin
  SetNameCaption('Splain','Approximation by cubic splines');
end;

procedure TFFSplain.RealFitting;
begin
 fDataToFit.Splain3(FittingData,fIntVars[0]);
end;



procedure TFFSplain.Tuning;
begin
  inherited;
  fHasPicture:=False;
end;

{ TNoiseSmoothingNew }

//constructor TFFNoiseSmoothing.Create;
//begin
// inherited Create;
// SetNameCaption('NoiseSmoothing','Noise Smoothing on Np point')
//end;

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


procedure TFFNoiseSmoothing.Tuning;
begin
  inherited;
  fHasPicture:=False;
end;

{ TFitFunctionWithArbitraryArgument }

procedure TFitFunctionWithArbitraryArgument.AccessorialDataDestroy;
begin
 fIntVars.Free;
 inherited;
end;

procedure TFitFunctionWithArbitraryArgument.AccessorialDataCreate;
begin
  inherited;
  fIntVars:=TVarIntArray.Create(Self,'Npoint');
  fIntVars.ParametrByName['Npoint'].Limits.SetLimits(0);
  fIntVars.ParametrByName['Npoint'].Description:=
        'Fitting poin number (0 - as in init date)';
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

//constructor TFFSimple.Create(FunctionName, FunctionCaption: string;
//             const MainParamNames: array of string);
//begin
// inherited Create(FunctionName, FunctionCaption);
// fDParamArray:=TDParamArray.Create(MainParamNames);
//end;
//
//constructor TFFSimple.Create(FunctionName, FunctionCaption: string;
//  const MainParamNames, AddParamNames: array of string);
//begin
// inherited Create(FunctionName, FunctionCaption);
//   fDParamArray:=TDParamArray.Create(MainParamNames, AddParamNames);
//end;

procedure TFFSimple.AccessorialDataCreate;
begin
  inherited;
  ParametersCreate;
end;

procedure TFFSimple.AccessorialDataDestroy;
begin
  fDParamArray.Free;
  inherited;
end;

procedure TFFSimple.AddParamDetermination;
begin
 fDParamArray.OutputData[High(fDParamArray.OutputData)]:=Deviation;
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
  for I := 0 to fDataToFit.HighNumber do
   begin
    if fDataToFit.Y[i]<>0 then
         Result:=Result+sqr((fDataToFit.Y[i]-FittingData.Y[i])/fDataToFit.Y[i])
                            else
         if FittingData.Y[i]<>0 then
                  Result:=Result+sqr((fDataToFit.Y[i]-FittingData.Y[i])/FittingData.Y[i])
   end;
 Result:=sqrt(Result)/fDataToFit.Count;
end;

//function TFFSimple.FinalFunc(X: double): double;
//begin
// if fResultsIsReady then Result:=fFun(X,fDParamArray.OutputData)
//                    else Result:=ErResult;
//end;

procedure TFFSimple.FittingDataFilling;
begin
 if fIntVars[0]<>0 then
     begin
     FittingData.T:=fDataToFit.T;
     FittingData.name:=fDataToFit.name;
     FittingData.Filling(RealFinalFunc,fDataToFit.MinX,fDataToFit.MaxX,fIntVars[0])
     end;
//                   else
//     fDataToFit.ToFill(FittingData,fFun,fDParamArray.OutputData);

end;

procedure TFFSimple.RealFitting;
begin
 if FittingCalculation then
  begin
  AddParamDetermination;
  FittingDataFilling;
  end;
end;

//destructor TFFSimple.Destroy;
//begin
//  fDParamArray.Free;
//  inherited;
//end;

{ TFFLinear }

//constructor TFFLinear.Create;
//begin
//  inherited Create;
//  fHasPicture:=True;
//  fFun:=Linear;
//end;

function TFFLinear.FittingCalculation: boolean;
begin
 Result:=fDataToFit.LinAprox(fDParamArray.OutputData);
end;

procedure TFFLinear.NamesDefine;
begin
 SetNameCaption('Linear',
                  'Linear fitting, least-squares method');
end;

procedure TFFLinear.ParametersCreate;
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

procedure TFFOhmLaw.ParametersCreate;
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

procedure TFFQuadratic.ParametersCreate;
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
//  showmessage(booltostr(Result));
end;

procedure TFFGromov.NamesDefine;
begin
   SetNameCaption('Gromov',
      'Least-squares fitting,  which is used in Gromov and Lee methods');
end;

procedure TFFGromov.ParametersCreate;
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

procedure TFFPolinom.ParametersCreate;
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

procedure TFFPolinom.Tuning;
 var Names:array of string;
     i:integer;
begin
  inherited;
  fHasPicture:=False;
  SetLength(Names,(fIntVars.ParametrByName['N'] as TVarInteger).Value+1);
  for I := 0 to High(Names) do Names[i]:='A'+inttostr(i);
  fDParamArray:=TDParamArray.Create(Self,Names);
end;

end.
