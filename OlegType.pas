unit OlegType;

interface
// uses Dialogs,SysUtils;
const Kb=8.625e-5; {����� ���������, []=eV/K}
      Eps0=8.85e-12; {����������� �����, []=�/�}
      Qelem=1.6e-19; {������������ �����, []=��}
      Hpl=1.05457e-34; {������� ������ ������������, []=�� c}
      m0=9.11e-31; {���� ��������� []=��}
//      Tpow=0.83;
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
         end;
         
    PVector=^Vector;

//   TFuncType=(diod,photodiod,DiodTwo,DiodTwoFull,DGaus,
//              DoubleDiod,DoubleDiodLight,LinEg,RevZriz,RevShSCLC,
//              RevShSCLC2,RevShSCLC3,RevShTwo,RevShNew,RevShNew2,
//              RevZriz2,RevZriz3,
//              Power2,Tun);
{�������, �� ����� ������������� ������������ ��������:
diod - I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh;
photodiod - I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph;
DiodTwo - I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp(V/n2kT)-1];
DiodTwoFull  - I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp((V-IRs2)/n2kT)-1]
DoubleDiod  - I=I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]+(V-IRs)/Rsh;
DoubleDiodLight  - I=I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]+(V-IRs)/Rsh-Iph;
}
{   TEvolutionType= //����������� �����, ���� ��������������� ��� ������������
    (TDE, //differential evolution
     TMABC, // modified artificial bee colony
     TTLBO,  //teaching learning based optimization algorithm
     TPSO    // particle swarm optimization
     );
 }
  T2DArray=array of array of double;

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

 // T2DArray=array of array of double;

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
  ��� ������� - ������� �����, � � Rez �� �������� 555}

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
  ��� ������� - ������� �����, � � Rez �� �������� 555}

  TFunSingle=Function(x:double):double of object;
  PTFunSingle=^TFunSingle;

  TFunDouble=Function(x,y:double):double of object;
  PTFunDouble=^TFunDouble;

  TFunEvolution=Function(AP:Pvector; Variab:array of double):double;
  PFunEvolution=^TFunEvolution;

  TArrSingle=array of double;
  PTArrSingle=^TArrSingle;

  TArrArrSingle=array of TArrSingle;
  PClassroom=^TArrArrSingle;

  TArrStr=array of string;

 { TVar_Rand=(lin,logar,cons);
  {��� ������, �� ���������������� � ����������� �������,
  lin - ���������� �������� �����
  logar - ���������� �������� ��������� �����
  �ons - ����� ���������� ������}
{  TArrVar_Rand=array of TVar_Rand;
  PTArrVar_Rand=^TArrVar_Rand;     {}

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

{}  Diapazon=class //(TObject)// ��� ��� ���������� ��� ���, � ����
                           // ����������� ������������ ����� �������
         private
           fXMin:double;
           fYMin:double;
           fXMax:double;
           fYMax:double;
           fBr:Char; //'F' ���� ������� ��� ����� ����
                     //'R' ���� ������� ��� ��������� ����
           function GetData(Index:integer):double;
           procedure SetData(Index:integer; value:double);
           procedure SetDataBr(value:Char);

         public
           property XMin:double Index 1 read GetData write SetData;
           property YMin:double Index 2 read GetData write SetData;
           property XMax:double Index 3 read GetData write SetData;
           property YMax:double Index 4 read GetData write SetData;
           property Br:Char read fBr write SetDataBr;
           procedure Copy (Sou�e:Diapazon);
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


Procedure SetLenVector(A:Pvector;n:integer);
{�������������� ������� ����� � ������ �}

implementation

function Diapazon.GetData(Index:integer):double;
begin
case Index of
 1:Result:=fXMin;
 2:Result:=fYMin;
 3:Result:=fXMax;
 4:Result:=fYMax;
 else Result:=0;
 end;
end;

procedure Diapazon.SetData(Index:integer; value:double);
begin
case Index of
 1: if (value<0)or(value=555) then fXMin:=-0.005//0.001
                else fXMin:=value;
 2: if (value<0)or(value=555)  then fYMin:=0
                else fYMin:=value;
 3: if (value<=fXmin)and(fXMin<>555) then fXMax:=555
                      else fXMax:=value;
 4: if (value<=fYmin)and(fYMin<>555) then fYMax:=555
                      else fYMax:=value;
 end;
end;

procedure Diapazon.SetDataBr(value:char);
begin
if value='R' then fBr:=value
             else fBr:='F';
end;

Procedure Diapazon.Copy (Sou�e:Diapazon);
           {����� �������� ���� � Sou�e � �����}
begin
XMin:=Sou�e.Xmin;
YMin:=Sou�e.Ymin;
XMax:=Sou�e.Xmax;
YMax:=Sou�e.Ymax;
Br:=Sou�e.Br;
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




end.
