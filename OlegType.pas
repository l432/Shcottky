unit OlegType;


interface
//uses Windows,Messages,SysUtils,Forms;
 uses IniFiles,SysUtils, StdCtrls;

const Kb=8.625e-5; {����� ���������, []=eV/K}
      Eps0=8.85e-12; {����������� �����, []=�/�}
      Qelem=1.6e-19; {������������ �����, []=��}
      Hpl=1.05457e-34; {������� ������ ������������, []=�� c}
      m0=9.11e-31; {���� ��������� []=��}
      ErResult=555;
var   StartValue,EndValue,Freq:Int64;

//QueryPerformanceCounter(StartValue);
//
//QueryPerformanceCounter(EndValue);
//QueryPerformanceFrequency(Freq);
//showmessage('tics='+inttostr(EndValue-StartValue)+#10+#13+
//             'time='+floattostr((EndValue-StartValue)/Freq)
//             +' s'+#10+#13+
//                'freq+'+inttostr(Freq));

type

  TFunS=Function(x:double):double;
  TFun=Function(Argument:double;Parameters:array of double):double;

  TFunSingle=Function(x:double):double of object;
  TFunDouble=Function(x,y:double):double of object;
  TFunTriple=Function(x,y,z:double):double of object;

//  TSimpleEvent = procedure() of object;

  TArrSingle=array of double;
  PTArrSingle=^TArrSingle;
  T2DArray=array of array of double;


  TArrArrSingle=array of TArrSingle;
  PClassroom=^TArrArrSingle;

  TArrWord=array of word;



  TArrStr=array of string;

    Vector=record
         X:array of double;
         Y:array of double;
         n:integer; //������� �����, � ����� ���� ���������
                 //�� 0 �� n-1
         name:string; // ����� �����, ����� ���������� ���
         T:Extended;  // �����������, �� ������� ��� �����
         time:string; //��� ��������� �����, ������:�������
         N_begin:integer; //������ ��������� � ������ �����
         N_end:integer;  //�����, �� ������������� �� �������
         Procedure SetLenVector(Number:integer);
         procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
         procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
         procedure Add(newX,newY:double);
         procedure Delete(Ndel:integer);
         {������� � ������ ����� � ������� Ndel}
         Procedure Sorting (Increase:boolean=True);
         {��������� ���������� (������� ���������)
          ����� �� ��������� (��� Increase=True) ���������� �}
         Procedure DeleteDuplicate;
         {����������� �����, ��� ���� �������� ������� ��� �����������}
         Procedure DeleteErResult;
         {����������� �����, ��� ������� �� �������� ���� ErResult}
         Procedure SwapXY;
         {���������� ������� � �� Y}
         Function MaxX:double;
          {����������� �������� �������� � ������ �}
         Function MaxY:double;
          {����������� �������� �������� � ������ Y}
         Function MinX:double;
          {����������� �������� �������� � ������ �}
         Function MinY:double;
          {����������� �������� �������� � ������ Y}
         Function Xvalue(Yvalue:double):double;
         {������� ������� ��������� ������� ����� �
          ��������� Yvalue;
          ���� Yvalue �� �������� �������� ����
         ������� �������, �� ����������� ErResult}
         Function Yvalue(Xvalue:double):double;
         {������� ������� ��������� �������� ����� �
          ��������� Xvalue;
          ���� Xvalue �� �������� �������� ����
         ������� �������, �� ����������� ErResult}
         Function SumX:double;
         Function SumY:double;
         {������������ ���� �������� ������ X �� Y ��������}
         Procedure Copy (var Target:Vector);
         {��������� ���� � ������ ������� � Target}
         Procedure CopyLimitedX (var Target:Vector;Xmin,Xmax:double);
         {��������� � ������ ������� � Target
         - �����, ��� ���� �������� � ������� �� Xmin �� Xmax �������
         - ���� � �� name}
         Procedure PositiveX(var Target:Vector);
         {�������� � Target � �����, ��� ���� X ����� ��� ���� ����;
         ���� X, Y �� n ��� ���� ���� Target �� ���������}
         Procedure PositiveY(var Target:Vector);
         {�������� � Target � �����, ��� ���� Y ����� ��� ���� ����;
         ���� X, Y �� n ��� ���� ���� Target �� ���������}
         Procedure AbsX(var Target:Vector);
         {�������� � Target �����, ��� ���� X ������� ������ � ������
         �������, � Y ���� ����; ���� �=0, �� ����� ����������;
         ���� X, Y �� n ��� ���� ���� Target �� ���������}
         Procedure AbsY(var Target:Vector);
         {�������� � Target �����, ��� ���� Y ������� ������ Y ������
         �������, � X ���� ����; ���� Y=0, �� ����� ����������;
         ���� X, Y �� n ��� ���� ���� Target �� ���������}
         Procedure NegativeX(var Target:Vector);
         {�������� � Target � �����, ��� ���� X ����� ����;
         ���� X, Y �� n ��� ���� ���� Target �� ���������}
         Procedure NegativeY(var Target:Vector);
         {�������� � Target � �����, ��� ���� Y ����� ����;
         ���� X, Y �� n ��� ���� ���� Target �� ���������}
         Procedure Write_File(sfile:string; NumberDigit:Byte=4);
        {������ � ���� � ������ sfile ��� � ������ X �� Y;
        ���� n=0, �� ����� �� ����������; NumberDigit - ������� �������� ����}
         Procedure DeltaY(deltaVector:Vector);
         {�� ������� Y ���������� �������� deltaVector.Y;
          ���� ������� ����� ��� - ����� �� �� ����������}
         Procedure Clear();
         {������ ����������� ������� �����, ����� �������� �� �����������}
         Procedure Filling(Fun:TFun;Xmin,Xmax,deltaX:double;Parameters:array of double);overload;
         {� ������������ ���������� �� Xmin �� Xmax � ������ deltaX
         Y[i]=Fun(X[i],Parameters)}
         Procedure Filling(Fun: TFun; Xmin, Xmax: Double; Parameters: array of Double; Nstep: Integer=100);overload;
         {�� ���������, ����� ��������������� �� ����, � ��������
         ������� ����� Nstep �� �������� ��������}
         Procedure Filling(Fun:TFun;Xmin,Xmax,deltaX:double);overload;
        end;

    PVector=^Vector;

  TFunEvolution=Function(AP:Pvector; Variab:array of double):double;
  PFunEvolution=^TFunEvolution;


  SysEquation=record
      A:T2DArray;//array of array of double;
      f:array of double;
      x:array of double;
      N:integer;
     end;
    {��� ��������������� ��� ����'����
    ������� ������ ������
    � - ����� �����������
    f - ������ ������ �����
    x - ������ ��������
    N - ������� ������}

  PSysEquation=^SysEquation;

  TFun1D=Function(A:Pvector; Variab:array of double;
                  Param:array of double;
                  var Rez:array of double):word;
  {��� ��� �������, ��� ��������������� � �����
  �������, �� ������ ��������� ����� ����� Rez, ��
  � ���������� ������� ������ ��� ������,
  ����� ��������� � Variab;
  Param - ����� ���������, �� ������� �� ����� ������;
  A - ������, �� ����� ����� �������������� �������,
  ������� ��� ��������� ������������
  ������� ���� ���������� ����;
  ��� ����� �������� ������� ������� 0,
  ��� ������� - ������� �����, � � Rez �� �������� ErResult}

  TFun2D=Function(A:Pvector; Variab:array of double;
                  Param:array of double;
                  var Rez:T2DArray):word;
  {��� ��� �������, ��� ��������������� � �����
  �������, �� ������ ��������� �������� ����� ����� Rez, ��
  � ���������� ������� (������ �������)
  �� ������� ������ ��� ������,
  ����� ��������� � Variab;
  Param - ����� ���������, �� ���������������� �
  ����� �������;
  A - ������, �� ����� ����� �������������� �������,
  ������� ��� ��������� ������������
  ������� ���� ���������� ����;
  ��� ����� �������� ������� ������� 0,
  ��� ������� - ������� �����, � � Rez �� �������� ErResult}



  IRE=array[1..3] of double;
  {����� ��������������� ��� ������������
   ����������� y=I0(exp(x/E)-1)+x/R;
   [1] - I0
   [2] - R
   [3] - E}

   IRE2=array [1..3,1..3] of double;
   //��� ��������������� ��� ������������,
   //������� 3�3

  Limits=record     //��� ��� ����������� ������� �������
         MinXY:0..1; //0 - ����������� �������� �������� �������
         MaxXY:0..1; //1 - ����������� ����������� �������� ��������
         MinValue:array [0..1] of double;
         MaxValue:array [0..1] of double;
             //������� �������� ��� ��������� �������
         end;

{}  TDiapazon=class //(TObject)// ��� ��� ���������� ��� ���, � ����
                           // ����������� ������������ ����� �������
         private
           fXMin:double;
           fYMin:double;
           fXMax:double;
           fYMax:double;
           fBr:Char; //'F' ���� ������� ��� ����� ����
                     //'R' ���� ������� ��� ��������� ����
//           function GetData(Index:integer):double;
           procedure SetData(Index:integer; value:double);
           procedure SetDataBr(value:Char);

         public
           property XMin:double Index 1 read fXMin write SetData;
           property YMin:double Index 2 read fYMin write SetData;
           property XMax:double Index 3 read fXMax write SetData;
           property YMax:double Index 4 read fYMax write SetData;
//           property XMin:double Index 1 read GetData write SetData;
//           property YMin:double Index 2 read GetData write SetData;
//           property XMax:double Index 3 read GetData write SetData;
//           property YMax:double Index 4 read GetData write SetData;
           property Br:Char read fBr write SetDataBr;
           procedure Copy (Sou�e:TDiapazon);
           procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
           procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
         end;

   Curve3=class //(TObject)// ��� ��� ���������� ����� ���������,
                           // �� ���� ����� ���������� ��� ���� ����
         private
           fA:double;
           fB:double;
           fC:double;
           function GetData(Index:integer):double;
           procedure SetData(Index:integer; value:double);

         public
           property A:double Index 1 read GetData write SetData;
           property B:double Index 2 read GetData write SetData;
           property C:double Index 3 read GetData write SetData;
           Constructor Create; OVERLOAD;
           Constructor Create(x:double;y:double=1;z:double=1); overload;
           function GS(x:double;y0:double=0):double;
           {������� �������� ������� �����
           F(x)=y0+A*exp(-(x-B)^2/(2*C^2));
           ���� �=0, �� ���������� �� �=1}
           function GS_Sq:double;
           {������� ����� �� ������ �����,
           ���� �� ���������� �� ���������� ������
           �����: � - ������ ���������,
           � - ������ ��������,
           � - ������ ��������}
           function is_Gaus:boolean;
           {�������, �� ����� ���������� ����� �����
           �� ����� ����������; ��������, ������������ ���� ��, ���
           � �� ���� ����� �����}
           function Parab(x:double):double;
           {������� �������� ������� �������
           ������� F(x)=A+B*x+C*x^2}
           procedure Copy (Sou�e:Curve3);
           {����� �������� ���� � Sou�e � �����}
         end;

     TEvent = procedure() of object;

  TParameterShow=class
//  ��� ����������� �� ����
//  �) �������� ���������
//  �) ���� �����
//��� �� ������� ������� ����� ������ ��� ���� ����
   private
    STData:TStaticText; //�������� ���������
//    BChange:TButton;//������ ��� ����
    fWindowCaption:string; //����� ������ ���� ���������
    fWindowText:string;  //����� � ����� ������
    fHook:TEvent;
    procedure ButtonClick(Sender: TObject);
    function GetData:double;
    procedure SetData(value:double);
   public
    STCaption:TLabel;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
//                       BC:TButton;
//                       ButtonCaption:string;
                       WC,WT:string;
                       InitValue:double
    );
    property Data:double read GetData write SetData;
    property Hook:TEvent read fHook write fHook;

  end;  //   TParameterShow=object


Procedure SetLenVector(A:Pvector;n:integer);
{�������������� ������� ����� � ������ �}

 Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                     Value:double; Default:double=ErResult);overload;
{������ � .ini-���� �������� ����� ���� ���� �� ������� Default}

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:integer; Default:integer=ErResult);overload;
{������ � .ini-���� �������� ����� ���� ���� �� ������� Default}

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:string; Default:string='');overload;
{������ � .ini-���� �������� ����� ���� ���� �� ������� Default}

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:Boolean);overload;
{������ � .ini-���� �������� ����� ���� ���� ������� True}

implementation
uses OlegMath,OlegGraph, Classes, Dialogs, Controls;

//function TDiapazon.GetData(Index:integer):double;
//begin
//case Index of
// 1:Result:=fXMin;
// 2:Result:=fYMin;
// 3:Result:=fXMax;
// 4:Result:=fYMax;
// else Result:=0;
// end;
//end;

procedure TDiapazon.SetData(Index:integer; value:double);
begin
case Index of
 1: if {(value<-0.005)or}(value=ErResult) then fXMin:=0//-0.005//0.001
                else fXMin:=value;
 2: if {(value<0)or}(value=ErResult)  then fYMin:=0
                else fYMin:=value;
 3: if (value<=fXmin)and(fXMin<>ErResult) then fXMax:=ErResult
                      else fXMax:=value;
 4: if (value<=fYmin)and(fYMin<>ErResult) then fYMax:=ErResult
                      else fYMax:=value;
 end;
end;

procedure TDiapazon.SetDataBr(value:char);
begin
if value='R' then fBr:=value
             else fBr:='F';
end;

Procedure TDiapazon.Copy (Sou�e:TDiapazon);
           {����� �������� ���� � Sou�e � �����}
begin
XMin:=Sou�e.Xmin;
YMin:=Sou�e.Ymin;
XMax:=Sou�e.Xmax;
YMax:=Sou�e.Ymax;
Br:=Sou�e.Br;
end;

procedure TDiapazon.ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
begin
  XMin:=ConfigFile.ReadFloat(Section,Ident+'XMin',0.001);
  YMin:=ConfigFile.ReadFloat(Section,Ident+'YMin',0);
  XMax:=ConfigFile.ReadFloat(Section,Ident+'XMax',ErResult);
  YMax:=ConfigFile.ReadFloat(Section,Ident+'Ymax',ErResult);
  Br:=ConfigFile.ReadString(Section,Ident+'Br','F')[1];
end;

procedure TDiapazon.WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
begin
 WriteIniDef(ConfigFile,Section,Ident+'XMin',Xmin,0.001);
 WriteIniDef(ConfigFile,Section,Ident+'YMin',Ymin,0);
 WriteIniDef(ConfigFile,Section,Ident+'XMax',Xmax);
 WriteIniDef(ConfigFile,Section,Ident+'Ymax',Ymax);
 ConfigFile.WriteString(Section,Ident+'Br',Br);
// WriteIniDef(ConfigFile,Section,Ident+'Br',Br,'F');
end;


function Curve3.GetData(Index:integer):double;
begin
case Index of
 1:Result:=fA;
 2:Result:=fB;
 3:Result:=fC;
 else Result:=0;
 end;
end;

procedure Curve3.SetData(Index:integer; value:double);
begin
case Index of
 1: fA:=value;
 2: fB:=value;
 3: fC:=value;
 end;
end;

Constructor Curve3.Create;
 begin
  Inherited {Create};
  self.A:=1;
  self.B:=1;
  self.C:=1;
 end;


Constructor Curve3.Create(x:double;y:double=1;z:double=1);
 begin
  self.A:=x;
  self.B:=y;
  self.C:=z;
 end;

Function Curve3.GS(x:double;y0:double=0):double;
           {������� �������� ������� �����
           F(x)=y0+A*exp(-(x-B)^2/(2*C^2));
           ���� �=0, �� ���������� �� �=1}
 begin
  if C=0 then C:=1;
  Result:=y0+A*exp(-sqr((x-B))/2/sqr(C));
 end;


Function Curve3.GS_Sq:double;
           {������� ����� �� ������ �����,
           ���� �� ���������� �� ���������� ������
           �����: � - ������ ���������,
           � - ������ ��������,
           � - ������ ��������}
 begin
   Result:=A*C*sqrt(2*3.14);
 end;

Function Curve3.is_Gaus:boolean;
           {�������, �� ����� ���������� ����� �����
           �� ����� ����������; ��������, ������������ ���� ��, ���
           � �� ���� ����� �����}
 begin
   Result:=not(C=0);
 end;

Function Curve3.Parab(x:double):double;
           {������� �������� ������� �������
           ������� F(x)=A+B*x+C*x^2}
 begin
   Result:=A+B*x+C*sqr(x);
 end;

Procedure Curve3.Copy (Sou�e:Curve3);
           {����� �������� ���� � Sou�e � �����}
begin
  A:=Sou�e.A;
  B:=Sou�e.B;
  C:=Sou�e.C;
end;



Procedure SetLenVector(A:Pvector;n:integer);
{�������������� ������� ����� � ������ �}
begin
  A^.n:=n;
  SetLength(A^.X, A^.n);
  SetLength(A^.Y, A^.n);
end;

Procedure Vector.SetLenVector(Number:integer);
{�������������� ������� ����� � ������ �}
begin
  n:=Number;
  SetLength(X, n);
  SetLength(Y, n);
end;

procedure Vector.ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
 var i:integer;
begin
  i:=ConfigFile.ReadInteger(Section,Ident+'n',0);
  if i>0 then
    begin
      Self.SetLenVector(i);
      for I := 0 to High(X) do
        begin
          X[i]:=ConfigFile.ReadFloat(Section,Ident+'X'+IntToStr(i),ErResult);
          Y[i]:=ConfigFile.ReadFloat(Section,Ident+'Y'+IntToStr(i),ErResult);
        end;
    end
         else
    n:=0;
  name:=ConfigFile.ReadString(Section,Ident+'name','');
  time:=ConfigFile.ReadString(Section,Ident+'time','');
  T:=ConfigFile.ReadFloat(Section,Ident+'T',ErResult);
  N_begin:=ConfigFile.ReadInteger(Section,Ident+'N_begin',0);
  N_end:=ConfigFile.ReadInteger(Section,Ident+'N_end',n-1);
end;

procedure Vector.WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
var
  I: Integer;
begin
 WriteIniDef(ConfigFile,Section,Ident+'n',n,0);
 WriteIniDef(ConfigFile,Section,Ident+'name',name);
 WriteIniDef(ConfigFile,Section,Ident+'time',time);
 WriteIniDef(ConfigFile,Section,Ident+'T',T);
 WriteIniDef(ConfigFile,Section,Ident+'N_begin',N_begin,0);
 WriteIniDef(ConfigFile,Section,Ident+'N_end',N_end,n-1);
 for I := 0 to High(X) do
  begin
   ConfigFile.WriteFloat(Section,Ident+'X'+IntToStr(i),X[i]);
   ConfigFile.WriteFloat(Section,Ident+'Y'+IntToStr(i),Y[i])
  end;
end;

procedure Vector.Add(newX,newY:double);
begin
 Self.SetLenVector(n+1);
 X[n-1]:=newX;
 Y[n-1]:=newY;
end;

procedure Vector.Delete(Ndel:integer);
var
  I: Integer;
begin
 if (Ndel<0)or(Ndel>(n-1)) then Exit;
 if n<1 then Exit;
 for I := Ndel to n-2 do
  begin
    X[i]:=X[i+1];
    Y[i]:=Y[i+1];
  end;
 if N_end=n then N_end:=N_end-1;
 Self.SetLenVector(n-1);
end;

Procedure Vector.Sorting (Increase:boolean=True);
var i,j:integer;
    ChangeNeed:boolean;
    temp:double;
begin
for I := 0 to High(X)-1 do
  for j := 0 to High(X)-1-i do
     begin
      if Increase then ChangeNeed:=X[j]>X[j+1]
                  else ChangeNeed:=X[j]<X[j+1];
      if ChangeNeed then
          begin
          temp:=X[j];
          X[j]:=X[j+1];
          X[j+1]:=temp;
          temp:=Y[j];
          Y[j]:=Y[j+1];
          Y[j+1]:=temp;
          end;
     end;
end;

Procedure Vector.DeleteDuplicate;
 var i,j,PointToDelete,Point:integer;
 label Start;
begin
  Point:=0;
  PointToDelete:=-1;
 Start:
  if PointToDelete<>-1 then
//    begin
     Self.Delete(PointToDelete);
//     PointToDelete:=-1;
//    end;
  for I := Point to High(X)-1 do
    begin
      for j := i+1 to High(X) do
        if X[i]=X[j] then
          begin
            PointToDelete:=j;
            goto Start;
          end;
      Point:=I+1;
    end;
end;

Procedure Vector.DeleteErResult;
 var i,Point:integer;
 label Start;
begin
  Point:=0;
  i:=-1;
 Start:
  if i<>-1 then
     Self.Delete(i);
  for I := Point to High(X)-1 do
    begin
      if (X[i]=ErResult)or(Y[i]=ErResult) then
            goto Start;
      Point:=I+1;
    end;
end;

Procedure Vector.SwapXY;
 var i:integer;
begin
 for I := 0 to High(X) do
   Swap(X[i],Y[i]);
end;

Function Vector.MaxX:double;
begin
  if n<1 then
    Result:=ErResult
         else
    Result:=X[MaxElemNumber(X)];
end;

Function Vector.MaxY:double;
begin
  if n<1 then
    Result:=ErResult
         else
    Result:=Y[MaxElemNumber(Y)];
end;

Function Vector.MinX:double;
begin
  if n<1 then
    Result:=ErResult
         else
    Result:=X[MinElemNumber(X)];
end;

Function Vector.MinY:double;
begin
  if n<1 then
    Result:=ErResult
         else
    Result:=Y[MinElemNumber(Y)];
end;

Function Vector.SumX:double;
 var i:integer;
begin
 Result:=0;
 for I := 0 to High(X) do
   Result:=Result+X[i]
end;

Function Vector.SumY:double;
 var i:integer;
begin
 Result:=0;
 for I := 0 to High(Y) do
   Result:=Result+Y[i]
end;

Function Vector.Xvalue(Yvalue:double):double;
var i:integer;
//    bool:boolean;
begin
//  bool:=false;
  i:=1;
  Result:=ErResult;
  if High(X)<0 then Exit;
  repeat
   if ((Y[i]-Yvalue)*(Y[i-1]-Yvalue))<=0 then
     begin
     Result:=X_Y0(X[i],Y[i],X[i-1],Y[i-1],Yvalue);
     i:=High(X);
//     bool:= true;
     end;
   i:=i+1;
//  until ((bool) or (i>High(X)));
  until (i>High(X));
end;

Function Vector.Yvalue(Xvalue:double):double;
var i:integer;
//    bool:boolean;
begin
//  bool:=false;
  i:=1;
  Result:=ErResult;
  if High(X)<0 then Exit;
  repeat
   if ((X[i]-Xvalue)*(X[i-1]-Xvalue))<=0 then
     begin
     Result:=Y_X0(X[i],Y[i],X[i-1],Y[i-1],Xvalue);
     i:=High(X);
//     bool:= true;
     end;
   i:=i+1;
  until (i>High(X));
//  until ((bool) or (i>High(X)));
end;


Procedure Vector.Copy (var Target:Vector);
 var i:integer;
begin
  Target.SetLenVector(n);
  for I := 0 to n-1 do
    begin
     Target.X[i]:=X[i];
     Target.Y[i]:=Y[i];
    end;
  Target.T:=T;
  Target.name:=name;
  Target.time:=time;
  Target.N_begin:=N_begin;
  Target.N_end:=N_end;
end;

Procedure Vector.CopyLimitedX (var Target:Vector;Xmin,Xmax:double);
 var i:integer;
begin
  Target.Clear;
  Target.T:=T;
  Target.name:=name;
  for I := 0 to High(X) do
    if (X[i]>=Xmin)and(X[i]<=Xmax) then
       Target.Add(X[i],Y[i])
end;

Procedure Vector.PositiveX(var Target:Vector);
 var i:integer;
begin
 Target.SetLenVector(0);
 for I := 0 to n - 1 do
   if X[i]>=0 then
     Target.Add(X[i],Y[i]);
end;

Procedure Vector.PositiveY(var Target:Vector);
 var i:integer;
begin
 Target.SetLenVector(0);
 for I := 0 to n - 1 do
   if Y[i]>=0 then
     Target.Add(X[i],Y[i]);
end;

Procedure Vector.AbsX(var Target:Vector);
 var i:integer;
begin
 Copy(Target);
 for I := 0 to n - 1 do
     if Target.X[i]=0 then Target.Delete(i)
                      else
     Target.X[i]:=abs(Target.X[i]);
end;

Procedure Vector.AbsY(var Target:Vector);
 var i:integer;
begin
 Copy(Target);
 for I := 0 to n - 1 do
     if Target.Y[i]=0 then Target.Delete(i)
                      else
     Target.Y[i]:=abs(Target.Y[i]);
end;

Procedure Vector.NegativeX(var Target:Vector);
 var i:integer;
begin
 Target.SetLenVector(0);
 for I := 0 to n - 1 do
   if X[i]<0 then
     Target.Add(X[i],Y[i]);
end;

Procedure Vector.NegativeY(var Target:Vector);
 var i:integer;
begin
 Target.SetLenVector(0);
 for I := 0 to n - 1 do
   if Y[i]<0 then
     Target.Add(X[i],Y[i]);
end;

Procedure Vector.Write_File(sfile:string; NumberDigit:Byte=4);
var i:integer;
    Str:TStringList;
begin
  if n=0 then Exit;
  Str:=TStringList.Create;
  for I := 0 to High(X) do
     Str.Add(FloatToStrF(X[i],ffExponent,NumberDigit,0)+' '+
             FloatToStrF(Y[i],ffExponent,NumberDigit,0));
  Str.SaveToFile(sfile);
  Str.Free;
end;

Procedure Vector.DeltaY(deltaVector:Vector);
 var i:integer;
begin
 if High(X)<>High(deltaVector.X) then Exit;
 for i := 0 to High(X) do
        Y[i]:=Y[i]-deltaVector.Y[i];
end;

Procedure Vector.Clear();
begin
  SetLenVector(0);
end;

Procedure Vector.Filling(Fun:TFun;Xmin,Xmax,deltaX:double;Parameters:array of double);
 const Nmax=10000;
 var i:integer;
     argument:double;
begin
 i:=0;
 argument:=Xmin;
 repeat
   inc(i);
   argument:=argument+deltaX;
 until (argument>Xmax)or(i>Nmax);
 if (i>Nmax) then
   begin
     Clear();
     Exit;
   end;
 SetLenVector(i);
 for I := 0 to n - 1 do
  begin
    X[i]:=Xmin+i*deltaX;
    Y[i]:=Fun(X[i],Parameters);
  end;
end;


Procedure Vector.Filling(Fun: TFun; Xmin, Xmax: Double; Parameters: array of Double; Nstep: Integer);
begin
  if Nstep<1 then Clear()
    else if Nstep=1 then Filling(Fun,Xmin,Xmax,Xmax-Xmin+1,Parameters)
       else Filling(Fun,Xmin,Xmax,(Xmax-Xmin)/(Nstep-1),Parameters)
end;

Procedure Vector.Filling(Fun:TFun;Xmin,Xmax,deltaX:double);
begin
 Filling(Fun,Xmin,Xmax,deltaX,[]);
end;


Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:double; Default:double=ErResult);
{������ � .ini-���� �������� ����� ���� ���� �� ������� Default}
begin
 if (Value<>Default) then ConfigFile.WriteFloat(Section,Ident,Value);
end;

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:integer; Default:integer=ErResult);
{������ � .ini-���� �������� ����� ���� ���� �� ������� Default}
begin
 if (Value<>Default) then ConfigFile.WriteInteger(Section,Ident,Value);
end;

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:string; Default:string='');overload;
{������ � .ini-���� �������� ����� ���� ���� �� ������� Default}
begin
 if (Value<>Default) then ConfigFile.WriteString(Section,Ident,Value);
end;

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:Boolean);
{������ � .ini-���� �������� ����� ���� ���� �� ������� True}
begin
 if Value then ConfigFile.WriteBool(Section,Ident,Value);
end;

Constructor TParameterShow.Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
//                       BC:TButton;
//                       ButtonCaption:string;
                       WC,WT:string;
                       InitValue:double
                       );
begin
  inherited Create;
  STData:=STD;
  STData.Caption:=FloatToStrF(InitValue,ffExponent,3,2);
  STData.OnClick:=ButtonClick;
  STData.Cursor:=crHandPoint;
  STCaption:=STC;
  STCaption.Caption:=ParametrCaption;
  STCaption.WordWrap:=True;
//  BChange:=BC;
//  BChange.Caption:=ButtonCaption;
//  BChange.OnClick:=ButtonClick;
  fWindowCaption:=WC;
  fWindowText:=WT;
end;

procedure TParameterShow.ButtonClick(Sender: TObject);
 var temp:double;
     st:string;
begin
  st:=InputBox(fWindowCaption,fWindowText,STData.Caption);
  try
    temp:=StrToFloat(st);
    STData.Caption:=FloatToStrF(temp,ffExponent,3,2);
    Hook();
  finally

  end;
end;

function TParameterShow.GetData:double;
begin
 Result:=StrToFloat(STData.Caption);
end;

procedure TParameterShow.SetData(value:double);
begin
  try
    STData.Caption:=FloatToStrF(value,ffExponent,3,2);
  finally

  end;
end;

end.
