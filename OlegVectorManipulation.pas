unit OlegVectorManipulation;

interface
 uses OlegVector,OlegType, OlegMaterialSamples, OlegFunction;


type

  TSplainCoef=record
         B:double;
         C:double;
         D:Double
         end;
  TSplainCoefArray=array of TSplainCoef;


    TVectorManipulation=class
      private
       procedure SetVector(const Value: TVector);
      protected
       fVector:TVector;
      public
       property Vector:TVector read fVector write SetVector;
       Constructor Create(ExternalVector:TVector);overload;
       Constructor Create();overload;
       procedure Free;
    end;

   TProcTarget=Procedure(Target:TVector) of object;

//   TVectorTransform=class(TVectorManipulation)
   TVectorTransform=class(TVector)
    private
//     procedure SetVector(const Value: TVectorNew);
     procedure InitArrSingle(var OutputData: TArrSingle;NumberOfData:word);
     Procedure CopyLimited (Coord:TCoord_type;Target:TVector;Clim1, Clim2:double);
     procedure Branch(Coord:TCoord_type;Target:TVector;
                      const IsPositive:boolean=True;
                      const IsRigorous:boolean=True);
     procedure Module(Coord:TCoord_type;Target:TVector);
    protected
     Procedure InitTarget(Target:TVector);
    public
//     Constructor Create(ExternalVector:TVectorNew);overload;
//     Constructor Create();overload;
     Procedure CopyLimitedX (Target:TVector;Xmin,Xmax:double);
       {��������� � ������ ������� � Target
        - �����, ��� ���� ������� � �������� �� Xmin �� Xmax �������
         - ���� � �� name}
     Procedure CopyLimitedY (Target:TVector;Ymin,Ymax:double);
     procedure AbsX(Target:TVector);
         {�������� � Target �����, ��� ���� X ������� ������ � ������
         �������, � Y ���� ����; ���� �=0, �� ����� ����������}
     procedure AbsY(Target:TVector);
         {�������� � Target �����, ��� ���� Y ������� ������ Y ������
         �������, � X ���� ����; ���� Y=0, �� ����� ����������}
     Procedure PositiveX(Target:TVector);//overload;
         {�������� � Target � �����, ��� ���� X ����� ����}
     procedure PositiveY(Target:TVector);
         {�������� � Target � �����, ��� ���� Y ����� ����}
     Procedure ForwardX(Target:TVector);
         {�������� � Target � �����, ��� ���� X ����� ��� ���� ����}
     Procedure ForwardY(Target:TVector);
     procedure NegativeX(Target:TVector);
         {�������� � Target � �����, ��� ���� X ����� ����}
     procedure NegativeY(Target:TVector);
         {�������� � Target � �����, ��� ���� Y ����� ����}
     Procedure ReverseX(Target:TVector);
         {�������� � Target � �����, ��� ���� X ����� ��� ���� ����}
     Procedure ReverseY(Target:TVector);
     Procedure ReverseIV(Target:TVector);
     {������ � Target ����� � �����, �� ����������
     ��������� ������ ��� (��� ���� ���������� X ����� ����),
     ������� ������ ������ ���������}
     Procedure Median (Target:TVector);
      {� Target ���������� ��������� 䳿 �� ���� � Vector
      ��������� �������������� �������;
      ���� � ��������� ����� ������� ����� ����� �����,
      �� � ������������� ���� ������� �������}
     Procedure Splain3(Target:TVector;beg:double; step:double);
      {� Target ��������� ������������ �����
      � ������������� ������� ��������,
      ��������� � ����� � �����������
      beg � � ������ step;
      ���� ������� ������� �����������
      (�� ��������� � ������� ���� ������� �������),
      �� � ������������� ������ ������� �������}
     Function YvalueSplain3(Xvalue:double):double;
    {������� ���������� �������� ������� � ����� Xvalue ��������������
     ������ �������, ���������� �� ����� ������ ����� � ����� V
     Result=Ai+Bi(X-Xi)+Ci(X-Xi)^2+Di(X-Xi)^3 ��� Xi-1<=X<=Xi}
     Function YvalueLagrang(Xvalue:double):double;
     {������� ���������� �������� ������� � ����� Xvalue
      �������������� ������ ��������}
     Function YvalueLinear(Xvalue:double):double;
     {������� �������� �����, ��� �� ������� XValue
      ��� ������ ���������, ���������� �� Vector}
     Function XvalueLinear(YValue:double):double;
      {�������  ������� �����, ��� ��  �������� YValue
      ��� ������ ���������, ���������� �� ����� Vector}
     Function GromovAprox (var  OutputData:TArrSingle):boolean;
      {�������������� ���� ����������
      y=OutputData[0]+OutputData[1]*x+OutputData[2]*ln(x);
      ���� ������������ ������� - ����������� False}
     Function LinAprox (var  OutputData:TArrSingle):boolean;
     {�������������� ���� � ������ V �������
      ���������� y=OutputData[0]+OutputData[1]*x}
     function LinAproxBconst (b:double):double;
      {����������� ���������� � ������
      ������������ ����� ���������� y=a+b*x;
      �������� b ��������� ������}
     function LinAproxAconst (a:double):double;
      {����������� ���������� b ������
      ������������ ����� ���������� y=a+b*x;
      �������� a ��������� ������}
     Function ParabAprox (var  OutputData:TArrSingle):boolean;
      {�������������� ����  �����������
      ���������� y=OutputData[0]+OutputData[1]*x+OutputData[2]*x^2}
     Function NPolinomAprox (N:word;var  OutputData:TArrSingle):boolean;
      {�������������� ����  �������� N-�� �������
      y=OutputData[0]+OutputData[1]*x+OutputData[2]*x^2+...+OutputData[N]*x^N}
     Function IvanovAprox (var  OutputData:TArrSingle;
                           DD: TDiod_Schottky; OutsideTemperature: Double = 555):boolean;
      {������������ ����� � ������ V ������������� ����������
      I=Szr AA T^2 exp(-Fb/kT) exp(qVs/kT)
      V=Vs+del*[Sqrt(2q Nd ep / eps0) (Sqrt(Fb/q)-Sqrt(Fb/q-Vs))]
      ��
      AA - ����� г��������
      Szr - ����� ��������
      Fb - ������ ���'��� �����
      Vs - ������ ������� �� ��� �������������
           (�������� ���������)
      del - ������� ������������� ����
      (���� ������� - ������� ����, ������� ��
      �������� ������� ����������� ���������� ����)
      Nd - ������������ ������ � �������������;
      e� - ����������� ����������� �������������
      ��0 - ����������� �����
      OutputData[0]=del;
      OutputData[1]=Fb;
      }

     Function  ImpulseNoiseSmoothing(const Coord:TCoord_type): Double;

     Function ImpulseNoiseSmoothingByNpoint(const Coord:TCoord_type;
                                       Npoint:Word=0): Double;

      {������������� ������� �������� �� ����� ����� � �����������
      �������� ���������� ����,
      �� ����� �� ImpulseNoiseSmoothing ���� ������������ �� ������
      �� Npoint ���� �� ����� ���� ������������� �������,
      ���� ������� ������������ �� ������ ....}
     Procedure ImNoiseSmoothedArray(Target:TVector;Npoint:Word=0);
      {� Target ���������� ����������
      ����������� (��� ImpulseNoiseSmoothingByNpoint) Source
      �� Npoint ������}
     Procedure Itself(ProcTarget:TProcTarget);
     {�������� �������� ������� Vector}
     Procedure Smoothing (Target:TVector);
      {� Target ���������� �������� ������� �����
      � Vector;
      � ���� ����������� ����������� �� ����� ������,
      ������� ����������� � �������� �������������,
      �� ������������ ��������� ����� � �������� 0.6;
      ���� � ��������� ����� ������� ����� ����� �����,
      �� � ������������� ���� ������� �������}
     Function DerivateAtPoint(PointNumber:integer):double;
     {����������� ������� �� �������, ��� ��������
     � Vector � ����� � �������� PointNumber}
     Procedure Derivate (Target:TVector);
      {� Target ���������� ������� �� �������, ������������
      � Vector;
      ���� � ��������� ����� ������� ����� ����� �����,
      �� � ������������� ���� ������� �������}
     Function ExtremumXvalue():double;
      {��������� ������� ���������� �������,
      �� ����������� � Vector;
      ����������, �� ��������� ����;
      ���� ���������� ���� - ����������� ErResult;
      ���� ��������� �� ������ - ������� ������
      �������� :-)}
     Function MaximumCount():integer;
      {������������ ������� ���������
      ��������� � Vector;
      ���� ����� ���� ������������ �� ��������� X}
     Procedure CopyDiapazonPoint(Target:TVector;D:TDiapazon;InitVector:TVector);overload;
      {������ � Target � ����� � Vector, ��������
      �� ���� ����� � InitVector (���������) �������������
      ������ D; ��������, �� ��� Vector
      ����� ���� ������� N_begin;
      Target.N_begin �� �������������}
     Procedure CopyDiapazonPoint(Target:TVector;Lim:Limits;InitVector:TVector);overload;
     Procedure CopyDiapazonPoint(Target:TVector;D:TDiapazon);overload;
      {������ � Target � ����� � Vector, ��
      ������������� ������ D;
      Vector.N_begin �� ���� 0;
      Target.N_begin �� �������������}
     function Isc():double;
      {������������ ����� ��������� ���������}
     function Voc():double;
      {������������ ������� ��������� ����}
     function Pm():double;
      {������������ ����������� ������� ����������,
      ��������������� ����� � ������
      ProgPhotov_25_p623-625.pdf
      ��� ������� SNR=80 dB}
   end;


Function Kub (x:double;coef:array of double):double;overload;
{������� coef[0]+coef[1]*(x-coef[4])+
                  coef[2]*(x-coef[4])^2+
                  coef[3]*(x-coef[4])^3;
�������, �������, ��� ������������ ��������}

Function Kub(x:double;
             Point:TPointDouble;
             SplainCoef:TSplainCoef):double;overload;

Procedure SplainCoefCalculate(V:TVector;var SplainCoef:TSplainCoefArray);
{�������������� ����������� ��������� ��� ������������ ����� � Vector}

Function DerivateLagr(x:double;Point1,Point2,Point3:TPointDouble):double;overload;
  {�������� ������� ��� ����������� ������� -
  ������� �� ������� ��������, ����������� �����
  ��� �����}
Function DerivateLagr(Point1,Point2,Point3:TPointDouble):double;overload;
{� ����������� �����}

Function DerivateTwoPoint(Point1,Point2:TPointDouble):double;


implementation

uses
  Math, Dialogs, SysUtils, OlegMath;




{ TVectorManipulation }

constructor TVectorManipulation.Create(ExternalVector: TVector);
begin
  Create();
  SetVector(ExternalVector);
end;

constructor TVectorManipulation.Create;
begin
  inherited Create;
  fVector:=TVector.Create;
end;

procedure TVectorManipulation.Free;
begin
 fVector.Free;
 inherited Free;
end;


procedure TVectorManipulation.SetVector(const Value: TVector);
begin
 Value.CopyTo(fVector);
end;


{ TVectorTransform }

function TVectorTransform.MaximumCount: integer;
 var i:integer;
begin
  if Count<3 then
     begin
       Result:=ErResult;
       Exit;
     end;
  Result:=0;
  for i:=1 to HighNumber-1 do
   if (Y[i]>Y[i-1])
       and(Y[i]>Y[i+1])
          then inc(Result);
end;

procedure TVectorTransform.Median(Target: TVector);
  var i:integer;
begin
  InitTarget(Target);
  if Self.Count<3 then Exit;
  Self.CopyTo(Target);
  for i:=1 to Target.HighNumber-1 do
    Target.y[i]:=MedianFiltr(Self.y[i-1],Self.y[i],Self.y[i+1]);;
end;

procedure TVectorTransform.Module(Coord: TCoord_type; Target: TVector);
 var i:integer;
begin
 InitTarget(Target);
 for I := 0 to Self.HighNumber do
     if Self.Point[i][Coord]=0
       then
       else
         begin
         Target.Add(Self[i]);
         if Coord=cX then Target.X[Target.Count-1]:=Abs(Target.X[Target.Count-1]);
         if Coord=cY then Target.Y[Target.Count-1]:=Abs(Target.Y[Target.Count-1]);
         end;
end;

procedure TVectorTransform.AbsX(Target: TVector);
begin
  Module(cX,Target);
end;

procedure TVectorTransform.AbsY(Target: TVector);
begin
 Module(cY,Target);
end;


procedure TVectorTransform.Branch(Coord: TCoord_type; Target: TVector;
                const IsPositive:boolean=True;
                const IsRigorous:boolean=True);
 function SuitablePoint(Value:double):boolean;
  begin
   if IsPositive then
      begin
        if IsRigorous then Result:=(Value>0)
                      else Result:=(Value>=0)
      end        else
      begin
        if IsRigorous then Result:=(Value<0)
                      else Result:=(Value<=0)
      end;

  end;
 var i,N_begin:integer;

begin
 InitTarget(Target);
 N_begin:=-1;
 for I := 0 to Self.HighNumber do
  if SuitablePoint(Self[i][Coord]) then
    begin
      Target.Add(Self[i]);
      if N_begin<0 then N_begin:=i
    end;
 if N_begin>=0 then Target.N_begin:=Cardinal(N_begin);
end;

procedure TVectorTransform.CopyDiapazonPoint(Target: TVector;
                      D: TDiapazon; InitVector: TVector);
 var i,j:integer;
begin
 InitTarget(Target);
 Target.T:=InitVector.T;
 j:=-1;
 for I := 0 to Self.HighNumber do
   if InitVector.PointInDiapazon(D,i+Self.N_begin)
     then
      begin
      if j<0 then
         begin
           j:=0;
           Target.N_begin:=Target.N_begin+i;
         end;
      Target.Add(Self[i]);
      end;
end;

procedure TVectorTransform.CopyDiapazonPoint(Target: TVector;
  D: TDiapazon);
begin
 CopyDiapazonPoint(Target,D,Self);
end;

procedure TVectorTransform.CopyDiapazonPoint(Target: TVector;
  Lim: Limits; InitVector: TVector);
 var i,j:integer;
begin
 InitTarget(Target);
 Target.T:=InitVector.T;
 j:=-1;
 for I := 0 to Self.HighNumber do
   if InitVector.PointInDiapazon(Lim,i+Self.N_begin)
     then
      begin
      if j<0 then
         begin
           j:=0;
           Target.N_begin:=Target.N_begin+i;
         end;
      Target.Add(Self[i]);
      end;
end;

procedure TVectorTransform.CopyLimited(Coord: TCoord_type;
           Target: TVector; Clim1, Clim2: double);
 var i:integer;
     Cmin,Cmax:double;
begin
  if Clim1>Clim2 then
      begin
        Cmax:=Clim1;
        Cmin:=Clim2;
      end        else
      begin
        Cmax:=Clim2;
        Cmin:=Clim1;
      end;
  InitTarget(Target);
  for I := 0 to Self.HighNumber do
    if (Self[i][Coord]>=Cmin)and(Self[i][Coord]<=Cmax) then
       Target.Add(Self[i]);
end;

procedure TVectorTransform.CopyLimitedX(Target: TVector; Xmin, Xmax: double);
begin
 CopyLimited(cX,Target,Xmin, Xmax);
end;

procedure TVectorTransform.CopyLimitedY(Target: TVector; Ymin,
  Ymax: double);
begin
 CopyLimited(cY,Target,Ymin, Ymax);
end;

//constructor TVectorTransform.Create;
//begin
// inherited Create;
//end;

//constructor TVectorTransform.Create(ExternalVector: TVectorNew);
//begin
//  Create();
//  SetVector(ExternalVector);
//end;

function TVectorTransform.DerivateAtPoint(PointNumber: integer): double;
begin
 Result:=ErResult;
 try
  if PointNumber=0
    then Result:=DerivateTwoPoint(Self[1],Self[0]);
  if PointNumber=Self.HighNumber
    then Result:=DerivateTwoPoint(Self[Self.HighNumber],Self[Self.HighNumber-1]);
  if (PointNumber>0)and(PointNumber<Self.HighNumber)
     then Result:=DerivateLagr(Self[PointNumber-1],Self[PointNumber],Self[PointNumber+1]);
 except

 end;
end;

function TVectorTransform.ExtremumXvalue: double;
 var temp:TVector;
begin
  temp:=TVector.Create;
  Self.Derivate(temp);
  Result:=temp.Xvalue(0);
  if (Result>Self.MaxX)or(Result<Self.MinX)
     then result:=ErResult;
  temp.Free;
end;

procedure TVectorTransform.Derivate(Target: TVector);
var i:integer;
begin
 InitTarget(Target);
 if Self.Count<3 then Exit;
 Self.CopyTo(Target);
 for i:=0 to Self.HighNumber do
   Target.Y[i]:=DerivateAtPoint(i);
end;

procedure TVectorTransform.ForwardX(Target: TVector);
begin
  Branch(cX,Target,true,false);
end;

procedure TVectorTransform.ForwardY(Target: TVector);
begin
  Branch(cy,Target,true,false);
end;

function TVectorTransform.GromovAprox(var OutputData: TArrSingle):boolean;
var R:PSysEquation;
    i:integer;
begin
  Result:=False;
  InitArrSingle(OutputData,3);

  for I:=0 to Self.HighNumber do
    if Self.X[i]<0 then Exit;

  new(R);
  R^.SetLengthSys(3);
  R^.Clear;

  R^.A[0,0]:=Self.Count;
  for i:=0 to Self.HighNumber do
   begin
     R^.A[0,1]:=R^.A[0,1]+Self.X[i];
     R^.A[0,2]:=R^.A[0,2]+ln(Self.X[i]);
     R^.A[1,1]:=R^.A[1,1]+Self.X[i]*Self.X[i];
     R^.A[1,2]:=R^.A[1,2]+Self.X[i]*ln(Self.X[i]);
     R^.A[2,2]:=R^.A[2,2]+ln(Self.X[i])*ln(Self.X[i]);
     R^.f[0]:=R^.f[0]+Self.Y[i];
     R^.f[1]:=R^.f[1]+Self.Y[i]*Self.X[i];
     R^.f[2]:=R^.f[2]+Self.Y[i]*ln(Self.X[i]);
   end;
  R^.A[1,0]:=R^.A[0,1];
  R^.A[2,0]:=R^.A[0,2];
  R^.A[2,1]:=R^.A[1,2];

  GausGol(R);
  if R^.N=ErResult then Exit;

  OutputData[0]:=R^.x[0];
  OutputData[1]:=R^.x[1];
  OutputData[2]:=R^.x[2];
  dispose(R);
  Result:=True;
end;

procedure TVectorTransform.ImNoiseSmoothedArray(Target: TVector;
                            Npoint: Word);
 var TG:TVectorTransform;
     CountTargetElement,i:integer;
     j:Word;
begin
 InitTarget(Target);
 if Self.Count<1 then Exit;

 if Npoint=0 then Npoint:=Trunc(sqrt(Self.Count+1));
 if Npoint=0 then Exit;

 CountTargetElement:=Self.Count div Npoint;
 if CountTargetElement=0
  then
   begin
   Target.Add(Self.ImpulseNoiseSmoothing(cX),
              Self.ImpulseNoiseSmoothing(cY));
   Exit;
   end;

 Target.SetLenVector(CountTargetElement);

  TG:=TVectorTransform.Create();
  TG.SetLenVector(Npoint);
  for I := 0 to CountTargetElement - 2 do
   begin
     for j := 0 to Npoint - 1 do
       begin
        TG.X[j]:=Self.X[I*Npoint+j];
        TG.Y[j]:=Self.Y[I*Npoint+j];
       end;
     Target.X[I]:=TG.ImpulseNoiseSmoothing(cX);
     Target.Y[I]:=TG.ImpulseNoiseSmoothing(cY);
   end;

  I:=Self.Count mod Npoint;
  TG.SetLenVector(I+Npoint);
  for j := 0 to Npoint+I-1 do
   begin
    TG.X[j]:=Self.X[(CountTargetElement - 1)*Npoint+j];
    TG.Y[j]:=Self.Y[(CountTargetElement - 1)*Npoint+j];
   end;

  Target.X[CountTargetElement - 1]:=TG.ImpulseNoiseSmoothing(cX);
  Target.Y[CountTargetElement - 1]:=TG.ImpulseNoiseSmoothing(cY);
  TG.Free;
end;

function TVectorTransform.ImpulseNoiseSmoothing(
                   const Coord: TCoord_type): Double;
 var i_min,i_max,j,PositivDeviationCount,NegativeDeviationCount:integer;
     PositivDeviation,Value_Mean:double;
     tempVector:TVector;
begin

  if Self.Count<1 then
    begin
      Result:=ErResult;
      Exit;
    end;
  if Self.Count<5 then
    begin
      Result:=Self.MeanValue(Coord);
      Exit;
    end;

  i_min:=Self.MinNumber(Coord);
  i_max:=Self.MaxNumber(Coord);

 tempVector:=TVector.Create;
 Self.CopyTo(tempVector);
 if i_min=i_max then TempVector.DeletePoint(i_min)
                else
                 begin
                  TempVector.DeletePoint(max(i_min,i_max));
                  TempVector.DeletePoint(min(i_min,i_max));
                 end;

 Value_Mean:=tempVector.MeanValue(Coord);
 PositivDeviationCount:=0;
 NegativeDeviationCount:=0;
 PositivDeviation:=0;
 for j := 0 to tempVector.HighNumber do
  begin
   if tempVector[j][Coord]>Value_Mean then
    begin
      inc(PositivDeviationCount);
      PositivDeviation:=PositivDeviation+(tempVector[j][Coord]-Value_Mean);
    end;
   if tempVector[j][Coord]<Value_Mean then
      inc(NegativeDeviationCount);
  end;

 Result:=Value_Mean+
        (PositivDeviationCount-NegativeDeviationCount)
        *PositivDeviation/sqr(tempVector.HighNumber+1);
  tempVector.Free;
end;

function TVectorTransform.ImpulseNoiseSmoothingByNpoint(
           const Coord: TCoord_type; Npoint: Word): Double;
 var temp:TVectorTransform;
begin
 Result:=ErResult;
 if Self.Count<1 then Exit;

 if Npoint=0 then Npoint:=Trunc(sqrt(Self.Count+1));
 if Npoint=0 then Exit;


 temp:=TVectorTransform.Create;


 Self.ImNoiseSmoothedArray(temp, Npoint);
 if temp.Count=1
  then Result:=temp[0][Coord]
  else Result:=temp.ImpulseNoiseSmoothingByNpoint(Coord,Npoint);
 temp.Free;

end;

procedure TVectorTransform.InitArrSingle(var OutputData: TArrSingle;
  NumberOfData: word);
  var i:word;
begin
 if High(OutputData)<(NumberOfData-1) then SetLength(OutputData,NumberOfData);
 for i := 0 to High(OutputData)
    do OutputData[i]:=ErResult;
end;

procedure TVectorTransform.InitTarget(Target: TVector);
begin
//  try
//   Target.Clear
//  except
//   Target:=TVectorNew.Create;
//  end;
  Target.Clear;
  Target.T:=Self.T;
  Target.name:=Self.name;
  Target.N_begin:=Self.N_begin;
end;

function TVectorTransform.Isc: double;
 var temp, temp2:double;
begin
 Result:=0;
 if Self.Count<2 then Exit;
 temp:=Self.Yvalue(0);
 temp2:=Self.Yvalue(0.01);
 if (abs(temp2/temp)>2) then Exit
             else Result:=-temp;
 if temp=ErResult then
      Result:=(-Self.Y[1]*Self.X[0]+Self.Y[0]*Self.X[1])
              /(Self.X[0]-Self.X[1]);
end;

procedure TVectorTransform.Itself(ProcTarget: TProcTarget);
 var Target:TVector;
begin
 Target:=TVector.Create;
 ProcTarget(Target);
 Target.CopyTo(Self);
 Target.Free;
end;

function TVectorTransform.IvanovAprox(var OutputData: TArrSingle;
  DD: TDiod_Schottky; OutsideTemperature: Double): boolean;
var temp:TVector;
    a,b,Temperature:double;
    i:integer;
    Param:array of double;
begin
 Result:=False;
 InitArrSingle(OutputData,2);
  if OutsideTemperature=ErResult then Temperature:=Self.T
                                 else Temperature:=OutsideTemperature;
  if (Temperature<=0)or(Self.Count=0) then Exit;
  SetLength(Param,6);

  temp:=TVector.Create;
  temp.SetLenVector(Self.Count);
  try
  for I := 0 to temp.HighNumber do
    begin
     temp.X[i]:=1/Self.X[i];
     temp.Y[i]:=sqrt(DD.Fb(Temperature,Self.Y[i]));
    end;
  except
   temp.Free;
   Exit;
  end;//try

  Param[0]:=temp.Count;
  for i := 1 to 5 do Param[i]:=0;
  try
    for I := 0 to temp.HighNumber do
    begin
    Param[1]:=Param[1]+temp.X[i];
    Param[2]:=Param[2]+temp.X[i]*temp.Y[i];
    Param[3]:=Param[3]+temp.X[i]*sqr(temp.Y[i]);
    Param[4]:=Param[4]+temp.X[i]*temp.Y[i]*sqr(temp.Y[i]);
    Param[5]:=Param[5]+temp.Y[i];
    end;
    temp.Free;
  except
    temp.Free;
    Exit;
  end;//try

  try
  a:=(Param[2]*(Param[0]+Param[3])-Param[1]*(Param[5]+Param[4]))/(Param[3]*Param[1]-sqr(Param[2]));
  b:=(Param[3]*(Param[0]+Param[3])-Param[2]*(Param[5]+Param[4]))/(Param[3]*Param[1]-sqr(Param[2]));
  b:=(sqrt(sqr(a)+4*b)-a)/2;
  except
    Exit;
  end;
  OutputData[0]:=a/sqrt(2*Qelem*DD.Semiconductor.Nd*DD.Semiconductor.Material.Eps/Eps0);
  OutputData[1]:=sqr(b);
  Result:=True;
end;

function TVectorTransform.LinAprox(var OutputData: TArrSingle): boolean;
  var Sx,Sy,Sxy,Sx2:double;
      i:integer;
begin
  Result:=False;
  InitArrSingle(OutputData,2);
  Sx:=0;Sy:=0;Sxy:=0;Sx2:=0;
  for i:=0 to Self.HighNumber do
     begin
     Sx:=Sx+Self.x[i];
     Sy:=Sy+Self.y[i];
     Sxy:=Sxy+Self.x[i]*Self.y[i];
     Sx2:=Sx2+Self.x[i]*Self.x[i];
     end;
  try
  OutputData[0]:=(Sx2*Sy-Sxy*Sx)/(Self.Count*Sx2-Sx*Sx);
  OutputData[1]:=(Self.Count*Sxy-Sy*Sx)/(Self.Count*Sx2-Sx*Sx);
  except
   InitArrSingle(OutputData,2);
   Exit;
  end;
  Result:=True;
end;

function TVectorTransform.LinAproxAconst(a: double): double;
var Sx,Sxy,Sx2:double;
    i:integer;
begin
 Sx:=0;Sxy:=0;Sx2:=0;
 for i:=0 to Self.HighNumber do
   begin
   Sx:=Sx+Self.x[i];
   Sxy:=Sxy+Self.x[i]*Self.y[i];
   Sx2:=Sx2+Self.x[i]*Self.x[i];
   end;
 try
 Result:=(Sxy-a*Sx)/Sx2;
 except
  Result:=ErResult;
 end;
end;

function TVectorTransform.LinAproxBconst(b: double): double;
begin
 if Self.IsEmpty then Result:=ErResult
                   else
      Result:=(Self.SumY-b*Self.SumX)/Self.Count;
end;

procedure TVectorTransform.NegativeX(Target: TVector);
begin
  Branch(cX,Target,false);
end;

procedure TVectorTransform.NegativeY(Target: TVector);
begin
 Branch(cY,Target,false);
end;

function TVectorTransform.NPolinomAprox(N:word;
           var OutputData: TArrSingle): boolean;
var R:PSysEquation;
    i,j:integer;
    SumX,SumXY:TArrSingle;
    temp:double;
begin
  Result:=False;
  InitArrSingle(OutputData,N+1);
  if Self.Count<(N+1) then Exit;
  new(R);
  R^.SetLengthSys(N+1);
  R^.Clear;
  SetLength(SumXY,N+1);
  for I := 0 to High(SumXY) do SumXY[i]:=0;
  SetLength(SumX,2*N+1);
  for I := 0 to High(SumX) do SumX[i]:=0;

  SumX[0]:=Self.Count;
  SumXY[0]:=Self.SumY;
  for I := 0 to Self.HighNumber do
   begin
    temp:=1;
    for j := 1 to High(SumX) do
     begin
       temp:=temp*X[i];
       SumX[j]:=SumX[j]+temp;
       if j<(n+1) then
        SumXY[j]:=SumXY[j]+Y[i]*temp;
     end;
   end;

  R^.InPutF(SumXY);
  for I := 0 to N do
    for j := 0 to N do
       R^.A[i,j]:=SumX[i+j];
  GausGol(R);

  if R^.N=ErResult then Exit;
  R^.OutPutX(OutputData);
  dispose(R);
  Result:=True;
end;

function TVectorTransform.ParabAprox(var OutputData: TArrSingle): boolean;
var Sx,Sy,Sxy,Sx2,Sx3,Sx4,Syx2,pr:double;
    i:integer;
begin
  Result:=False;
  InitArrSingle(OutputData,3);
 Sx:=0;Sy:=0;Sxy:=0;Sx2:=0;Sx3:=0;Sx4:=0;Syx2:=0;
 with Self do begin
  for i:=0 to HighNumber do
   begin
   Sx:=Sx+x[i];
   Sy:=Sy+y[i];
   Sxy:=Sxy+x[i]*y[i];
   Sx2:=Sx2+sqr(x[i]);
   Sx3:=Sx3+sqr(x[i])*x[i];
   Sx4:=Sx4+sqr(sqr(x[i]));
   Syx2:=Syx2+sqr(x[i])*y[i];
   end;

  pr:=Sx4*(Count*Sx2-Sx*Sx)-Sx3*(Count*Sx3-Sx*Sx2)+Sx2*(Sx3*Sx-Sx2*Sx2);
  try
  OutputData[2]:=(Syx2*(Count*Sx2-Sx*Sx)-Sx3*(Count*Sxy-Sx*Sy)+Sx2*(Sxy*Sx-Sx2*Sy))/pr;
  OutputData[1]:=(Sx4*(Count*Sxy-Sx*Sy)-Syx2*(Count*Sx3-Sx*Sx2)+Sx2*(Sx3*Sy-Sx2*Sxy))/pr;
  OutputData[0]:=(Sx4*(Sy*Sx2-Sx*Sxy)-Sx3*(Sy*Sx3-Sxy*Sx2)+Syx2*(Sx3*Sx-Sx2*Sx2))/pr;
  Result:=True;
  except
  end;
 end;

end;

function TVectorTransform.Pm: double;
 var P_V,temp:TVectorTransform;
     i:integer;
     Pmax,Vmax,Imax,Voc:double;
     Number_Vmax:integer;
     outputData,koefDerivate:TArrSingle;
     FromVectorBegin:boolean;
begin
 Result:=ErResult;
 P_V:=TVectorTransform.Create();
 Self.ForwardX(P_V);
 if P_V.Count<5 then Exit;

 P_V.Sorting();
 for I := 0 to P_V.HighNumber do
      P_V.Y[i]:=P_V.Y[i]*P_V.X[i];
 Pmax:=P_V.MinY;
 if Pmax>=0 then Exit;

 Number_Vmax:=P_V.ValueNumberPrecise(cY,Pmax);
 Vmax:=P_V.X[Number_Vmax];
 Imax:=-Pmax/Vmax;
 temp:=TVectorTransform.Create();

// Number_Vmax:=Self.ValueNumberPrecise(cX,Vmax);
 temp.N_begin:=-1;
 for i := 0 to Self.HighNumber do
    if (Self.X[i]>=-0.5*Vmax)and(Self.X[i]<=0.42*Vmax) then
     begin
       if temp.N_begin<0 then  temp.N_begin:=i;
        Temp.Add(Self[i]);
     end;

 showmessage(temp.XYtoString);
 FromVectorBegin:=True;
// FromVectorBegin:=False;
 while temp.Count<2 do
  begin
    if FromVectorBegin then
      begin
        if temp.N_begin>0 then
           begin
            temp.N_begin:=temp.N_begin-1;
            temp.Add(Self[temp.N_begin]);
           end;
      end                 else
      begin
        if (temp.N_begin+temp.Count)<Self.HighNumber then
            Temp.Add(Self[temp.N_begin+temp.Count]);
      end;
   FromVectorBegin:=not(FromVectorBegin);
  end;
 temp.Sorting();
 showmessage(temp.XYtoString);
 temp.LinAprox(outputData);
 showmessage('Isc='+floattostr(-outputData[0]));

//----------------------------------------------
 temp.Clear;
 temp.N_begin:=-1;
 for i := 0 to Self.HighNumber do
    if (Self.Y[i]>=-0.11*Imax)and(Self.Y[i]<=0.33*Imax) then
     begin
       if temp.N_begin<0 then  temp.N_begin:=i;
        Temp.Add(Self[i]);
     end;

 showmessage(temp.XYtoString);
 FromVectorBegin:=False;
 while temp.Count<3 do
  begin
    if FromVectorBegin then
      begin
        if temp.N_begin>0 then
           begin
            temp.N_begin:=temp.N_begin-1;
            temp.Add(Self[temp.N_begin]);
           end;
      end                 else
      begin
        if (temp.N_begin+temp.Count)<Self.HighNumber then
            Temp.Add(Self[temp.N_begin+temp.Count]);
      end;
   FromVectorBegin:=not(FromVectorBegin);
  end;
 temp.Sorting();
 showmessage(temp.XYtoString);
 temp.ParabAprox(outputData);
 Voc:=Bisection(NPolinom,outputData,
                 temp.X[0],temp.X[temp.HighNumber]);
 showmessage('Voc='+floattostr(Voc));

//---------------------------------------
 temp.Clear;
 temp.N_begin:=-1;
 for i := 0 to Number_Vmax - 1 do
    if P_V.Y[i]<=Pmax*0.82 then
     begin
       if temp.N_begin<0 then  temp.N_begin:=i;
        Temp.Add(P_V[i]);
     end;

 for i := Number_Vmax to P_V.HighNumber do
    if P_V.Y[i]<=Pmax*0.94 then
        Temp.Add(P_V[i]);

// showmessage(temp.XYtoString);
 FromVectorBegin:=True;
// FromVectorBegin:=False;
 while temp.Count<5 do
  begin
    if FromVectorBegin then
      begin
        if temp.N_begin>0 then
           begin
            temp.N_begin:=temp.N_begin-1;
            temp.Add(P_V[temp.N_begin]);
           end;
      end                 else
      begin
        if (temp.N_begin+temp.Count)<P_V.HighNumber then
            Temp.Add(P_V[temp.N_begin+temp.Count]);
      end;
   FromVectorBegin:=not(FromVectorBegin);
  end;
 temp.Sorting();
// showmessage(temp.XYtoString);

 temp.NPolinomAprox(4,outputData);

 SetLength(koefDerivate,4);
 koefDerivate[0]:=outputData[1];
 koefDerivate[1]:=2*outputData[2];
 koefDerivate[2]:=3*outputData[3];
 koefDerivate[3]:=4*outputData[4];
 Vmax:=Bisection(NPolinom,koefDerivate,
                 temp.X[0],temp.X[temp.HighNumber]);
 Result:=-P_V.YvalueSplain3(Vmax);
 Imax:=-Self.YvalueSplain3(Vmax);
// showmessage('Vmax='+floattostr(Vmax)
//             +' Imax='+floattostr(Imax)
//             +' Pmax='+floattostr(Result));
 P_V.Free;
 temp.Free;
end;

procedure TVectorTransform.PositiveX(Target: TVector);
begin
 Branch(cX,Target);
end;


procedure TVectorTransform.PositiveY(Target: TVector);
begin
 Branch(cY,Target);
end;

procedure TVectorTransform.ReverseIV(Target: TVector);
 var temp:TVectorTransform;
begin
 temp:=TVectorTransform.Create(Self);
 temp.Itself(temp.NegativeX);
 temp.Itself(temp.AbsX);
 temp.AbsY(Target);
 temp.Free;
end;

procedure TVectorTransform.ReverseX(Target: TVector);
begin
   Branch(cX,Target,false,false);
end;

procedure TVectorTransform.ReverseY(Target: TVector);
begin
   Branch(cY,Target,false,false);
end;

//procedure TVectorTransform.SetVector(const Value: TVectorNew);
//begin
// Value.CopyTo(Self);
//end;

procedure TVectorTransform.Smoothing(Target: TVector);
const W0=17;W1=66;W2=17;
{����� ����������� ��� �������, ����� �� ����� �����}
var i:integer;
begin
  InitTarget(Target);
  if Self.Count<3 then Exit;
  Self.CopyTo(Target);
  for i:=1 to Target.HighNumber-1 do
      Target.y[i]:=(W0*Self.y[i-1]+W1*Self.y[i]+W2*Self.y[i+1])
                   /(W0+W1+W2);
  Target.y[0]:=(W1*Self.y[0]+W2*Self.y[1])/(W1+W2);
  Target.y[Self.HighNumber]:=(W1*Self.y[Self.HighNumber]
                     +W0*Self.y[Self.HighNumber-1])/(W1+W0);
end;

procedure TVectorTransform.Splain3(Target:TVector;beg:double; step:double);
 var i,j:integer;
     temp:double;
     SplainCoef:TSplainCoefArray;
begin
  InitTarget(Target);
   j:=Self.ValueNumber(cX,beg);
   if j<0 then Exit;

  SplainCoefCalculate(Self,SplainCoef);
  i:=0;
  temp:=beg;
  repeat
   inc(i);
   temp:=temp+step;
  until (temp>Self.X[Self.HighNumber]);

  Target.SetLenVector(i);
  for i:=0 to Target.HighNumber do
   begin
    temp:=beg+i*step;
    Target.X[i]:=temp;
    j:=Self.ValueNumber(cX,temp);
    Target.Y[i]:=Kub(temp,Self.Point[j],SplainCoef[j]);
   end;

end;

function TVectorTransform.Voc: double;
 var temp:double;
begin
 Result:=0;
 temp:=Self.Xvalue(0);
 if (temp=ErResult)or
    (temp<=0) then Exit
              else Result:=temp;
end;

function TVectorTransform.XvalueLinear(YValue: double): double;
 var OutputData: TArrSingle;
begin
  Result:=ErResult;
  if YValue=ErResult then Exit;
  if LinAprox(OutputData) then
    try
     Result:=(YValue-OutputData[0])/OutputData[1];
    except
    end;
end;

function TVectorTransform.YvalueLagrang(Xvalue: double): double;
 var i,j:word;
     t1,t2:double;
begin
   Result:=ErResult;
   if (Xvalue-Self.X[Self.HighNumber])*(Xvalue-Self.X[0])>0 then Exit;
   t1:=0;
   for i:=0 to Self.HighNumber do
     begin
       t2:=1;
       for j:=0 to Self.HighNumber do
         if (j<>i) then
          t2:=t2*(Xvalue-Self.X[j])/(Self.X[i]-Self.X[j]);
       t1:=t1+Self.Y[i]*t2;
     end;
  Result:=t1;
end;

function TVectorTransform.YvalueLinear(Xvalue: double): double;
 var OutputData: TArrSingle;
begin
  Result:=ErResult;
  if XValue=ErResult then Exit;
  if LinAprox(OutputData)
    then Result:=Linear(Xvalue,OutputData);
end;

function TVectorTransform.YvalueSplain3(Xvalue: double): double;
 var i:integer;
     SplainCoef:TSplainCoefArray;
begin
   Result:=ErResult;
   i:=Self.ValueNumber(cX,Xvalue);
   if i<0 then Exit;

   if (Xvalue>Self.MaxX)or(Xvalue<Self.MinX) then Exit;
   SplainCoefCalculate(Self,SplainCoef);

  Result:=Kub(Xvalue,Self[i],SplainCoef[i]);
end;

Function Kub (x:double;coef:array of double):double;overload;
{������� coef[0]+coef[1]*(x-coef[4])+
                  coef[2]*(x-coef[4])^2+
                  coef[3]*(x-coef[4])^3;
�������, �������, ��� ������������ ��������}
 var x0,temp:double;
     i:integer;
begin
  Result:=0;
  if High(coef)>3 then x0:=coef[4]
                  else x0:=0;
  temp:=1;
  for I := 0 to High(coef) do
   begin
     Result:=Result+coef[i]*temp;
     temp:=temp*(x-x0);
     if i=3 then Break;
   end;
end;

Function Kub(x:double;Point:TPointDouble;SplainCoef:TSplainCoef):double;overload;
begin
  Result:=Kub(x,[Point[cY],SplainCoef.B,SplainCoef.C,SplainCoef.D,Point[cX]])
end;


Procedure SplainCoefCalculate(V:TVector;var SplainCoef:TSplainCoefArray);
 var Bt,Dl,AA,BB,H:TArrSingle;
     i:integer;
  begin
   if V.HighNumber<1 then
    begin
    SetLength(SplainCoef,0);
    Exit;
    end;

   SetLength(SplainCoef,V.HighNumber);
   SetLength(Bt,V.HighNumber);
   SetLength(Dl,V.HighNumber);
   SetLength(AA,V.HighNumber);
   SetLength(BB,V.HighNumber);
   SetLength(H,V.HighNumber);
   for I := 0 to V.HighNumber - 1 do
       H[i]:=V.X[i+1]-V.X[i];

   Bt[0]:=1;
   Dl[0]:=1;
   for I := 1 to V.HighNumber - 1 do
     begin
       Bt[i]:=2*(H[i-1]+H[i]);
       Dl[i]:=3*((V.Y[i+1]-V.Y[i])/H[i]-(V.Y[i]-V.Y[i-1])/H[i-1]);
     end;

  AA[0]:=0;
  BB[0]:=1;

    AA[1]:=-H[1]/Bt[1];
    BB[1]:=(Dl[1]-H[0])/Bt[1];
    for I := 2 to V.HighNumber - 2 do
     begin
       AA[i]:=-H[i]/(Bt[i]+H[i-1]*AA[i-1]);
       BB[i]:=(Dl[i]-H[i-1]*BB[i-1])/(Bt[i]+H[i-1]*AA[i-1]);
     end;
   AA[V.HighNumber-1]:=0;
   BB[V.HighNumber-1]:=(Dl[V.HighNumber-1]-
                             H[V.HighNumber-2]*BB[V.HighNumber-2])
                             /(Bt[V.HighNumber-1]+H[V.HighNumber-2]
                               *AA[V.HighNumber-2]);

  SplainCoef[V.HighNumber-1].C:=BB[V.HighNumber-1];
  for I := V.HighNumber-2 downto 0 do
    SplainCoef[i].C:=AA[i]*SplainCoef[i+1].C+BB[i];

 SplainCoef[V.HighNumber-1].D:=-SplainCoef[V.HighNumber-1].C/3/H[V.HighNumber-1];
 SplainCoef[V.HighNumber-1].B:=(V.Y[V.HighNumber]-V.Y[V.HighNumber-1])
          /H[V.HighNumber-1]-2/3*SplainCoef[V.HighNumber-1].C*H[V.HighNumber-1];

 for I := 0 to V.HighNumber-2 do
   begin
     SplainCoef[i].D:=(SplainCoef[i+1].C-SplainCoef[i].C)/3/H[i];
     SplainCoef[i].B:=(V.Y[i+1]-V.Y[i])/H[i]-H[i]
                     /3*(SplainCoef[i+1].C+2*SplainCoef[i].C);
   end;

end;

Function DerivateLagr(x:double;Point1,Point2,Point3:TPointDouble):double;
  {�������� ������� ��� ����������� ������� -
  ������� �� ������� ��������, ����������� �����
  ��� �����}
begin
  Result:=Point1[cY]*(2*x-Point2[cX]-Point3[cX])
            /(Point1[cX]-Point2[cX])/(Point1[cX]-Point3[cX])
        +Point2[cY]*(2*x-Point1[cX]-Point3[cX])/
           (Point2[cX]-Point1[cX])/(Point2[cX]-Point3[cX])
        +Point3[cY]*(2*x-Point1[cX]-Point2[cX])
         /(Point3[cX]-Point1[cX])/(Point3[cX]-Point2[cX]);
end;

Function DerivateLagr(Point1,Point2,Point3:TPointDouble):double;
begin
  Result:=DerivateLagr(Point2[cX],Point1,Point2,Point3);
end;

Function DerivateTwoPoint(Point1,Point2:TPointDouble):double;
begin
  Result:=(Point2[cY]-Point1[cY])/(Point2[cX]-Point1[cX])
end;

end.
