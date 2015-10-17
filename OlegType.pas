unit OlegType;


interface
//uses Windows,Messages,SysUtils,Forms;
 uses IniFiles;

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

    Vector=record
         X:array of double;
         Y:array of double;
         n:integer; //������� �����, � ����� ���� ���������
                 //�� 0 �� n-1
         name:string; // ����� �����, ����� ����������� ����
         T:Extended;  // �����������, �� ������� ��� �����
         time:string; //��� ��������� �����, ������:�������
         N_begin:integer; //������ ��������� � ������ �����
         N_end:integer;  //�����, �� ������������� �� �������
         end;

    PVector=^Vector;

  T2DArray=array of array of double;

  SysEquation=record
      A:T2DArray;//array of array of double;
      f:array of double;
      x:array of double;
      N:integer;
     end;
    {��� ��������������� ��� ����'����
    ������� ������� ������
    � - ����� �����������
    f - ������ ������ ������
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
         MinXY:0..1; //0 - ����������� ��������� �������� �������
         MaxXY:0..1; //1 - ����������� ����������� �������� ��������
         MinValue:array [0..1] of double;
         MaxValue:array [0..1] of double;
             //�������� �������� ��� ��������� �������
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
           function GetData(Index:integer):double;
           procedure SetData(Index:integer; value:double);
           procedure SetDataBr(value:Char);

         public
           property XMin:double Index 1 read GetData write SetData;
           property YMin:double Index 2 read GetData write SetData;
           property XMax:double Index 3 read GetData write SetData;
           property YMax:double Index 4 read GetData write SetData;
           property Br:Char read fBr write SetDataBr;
           procedure Copy (Sou�e:TDiapazon);
           procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
           procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
         end;

   Curve3=class //(TObject)// ��� ��� ���������� ����� ���������,
                           // �� ���� ����� ���������� ���� ���� ����
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
           � - ������� ��������,
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

function TDiapazon.GetData(Index:integer):double;
begin
case Index of
 1:Result:=fXMin;
 2:Result:=fYMin;
 3:Result:=fXMax;
 4:Result:=fYMax;
 else Result:=0;
 end;
end;

procedure TDiapazon.SetData(Index:integer; value:double);
begin
case Index of
 1: if (value<-0.005)or(value=ErResult) then fXMin:=-0.005//0.001
                else fXMin:=value;
 2: if (value<0)or(value=ErResult)  then fYMin:=0
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
  XMin:=ConfigFile.ReadFloat(Section,Ident+' XMin',0.001);
  YMin:=ConfigFile.ReadFloat(Section,Ident+' YMin',0);
  XMax:=ConfigFile.ReadFloat(Section,Ident+' XMax',ErResult);
  YMax:=ConfigFile.ReadFloat(Section,Ident+' Ymax',ErResult);
  Br:=ConfigFile.ReadString(Section,Ident+' Br','F')[1];
end;

procedure TDiapazon.WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
begin
 WriteIniDef(ConfigFile,Section,Ident,Xmin,0.001);
 WriteIniDef(ConfigFile,Section,Ident,Ymin,0);
 WriteIniDef(ConfigFile,Section,Ident,Xmax);
 WriteIniDef(ConfigFile,Section,Ident,Ymax);
 WriteIniDef(ConfigFile,Section,Ident,Br,'F');
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
           � - ������� ��������,
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

end.
