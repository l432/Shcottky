unit OApproxNew2;

interface

uses
  OApproxNew, FitVariable;

type
TFitFunctionWithArbitraryArgument =class(TFitFunctionNew)
  {����������� ���� ��� �������, ���� ������������
  ������� ���� ���� ����������� � ����-��� �����...�� ���������}
 private
  fIntVars:TVarIntArray;
  {� ����� ���� �������� ���� ���� ��������, Npoint
  ������� ����� � �������� ���������;
  ���� = 0, �� ������ �, �� � ������� �����}
 protected
  procedure RealFitting;override;
  Procedure RealToFile (suf:string;NumberDigit: Byte=8);override;
  procedure DipazonCreate;override;
  procedure DiapazonDestroy;override;
  function ParameterCreate:TFFParameter;override;
  procedure  FittingCalculation;virtual;abstract;
  procedure FittingDataFilling;virtual;abstract;
  procedure FileFilling;virtual;abstract;
end;

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


implementation

uses
  FitVariableShow;

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
  fIntVars[0]:=0;
  fIntVars.ParametrByName['Npoint'].Limits.SetLimits(0);
  fIntVars.ParametrByName['Npoint'].Description:=
        'Fitting poin number (0 - as in init date)';
end;

function TFitFunctionWithArbitraryArgument.ParameterCreate: TFFParameter;
begin
 Result:=TDecVarNumberArrayParameter.Create(fIntVars,
                         inherited ParameterCreate);
end;

procedure TFitFunctionWithArbitraryArgument.RealFitting;
begin
 FittingCalculation;
 FittingDataFilling;
 if not(FittingData.IsEmpty) then fResultsIsReady:=True;
end;

procedure TFitFunctionWithArbitraryArgument.RealToFile(suf: string;
  NumberDigit: Byte);
begin
  if fIntVars[0]<>0 then FileFilling
                    else Inherited  RealToFile(suf,NumberDigit);
end;

end.
