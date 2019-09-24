unit OlegTypeNew;


interface
//uses Windows,Messages,SysUtils,Forms;
 uses IniFiles,SysUtils, StdCtrls;

const Kb=8.625e-5; {стала Больцмана, []=eV/K}
      Eps0=8.85e-12; {діелектрична стала, []=Ф/м}
      Qelem=1.6e-19; {елементарний заряд, []=Кл}
      Hpl=1.05457e-34; {постійна Планка перекреслена, []=Дж c}
      m0=9.11e-31; {маса електрону []=кг}
      ErResult=555;
      DoubleConstantSection='DoubleConstant';
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

  TCoord_type=(cX,cY);
  TPointDouble=array[TCoord_type]of double;


{}  TDiapazon=class //(TObject)// тип для збереження тих меж, в яких
                           // відбуваються апроксимації різних функцій
         private
           fXMin:double;
           fYMin:double;
           fXMax:double;
           fYMax:double;
           fBr:Char; //'F' коли діапазон для прямої гілки
                     //'R' коли діапазон для зворотньої гілки
           procedure SetData(Index:integer; value:double);
           procedure SetDataBr(value:Char);

         public
           property XMin:double Index 1 read fXMin write SetData;
           property YMin:double Index 2 read fYMin write SetData;
           property XMax:double Index 3 read fXMax write SetData;
           property YMax:double Index 4 read fYMax write SetData;
           property Br:Char read fBr write SetDataBr;
           Constructor Create();
           procedure Copy (Souсe:TDiapazon);
           procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
           procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
           function PoinValide(Point:TPointDouble): boolean;
           {визначає, чи задовільняють координати точки Point межам}
         end;

//{тип, для збереження різних параметрів, які використовуються
// в розрахунках}
// TGraphParameters=class
//  private
//  public
//   Diapazon:TDiapazon;
//   Rs:double;
//   n:double;
//   Fb:double;
//   Gamma:double;
//    {параметр у функції Норда}
//   Gamma1:double;
//   Gamma2:double;
//    {Gamma1,Gamma2 - коефіцієнти для побудови функцій Норда
//                  у методі Бохліна}
//   Va:double;
//    {напруга, яка використовується для побудови
//     допоміжних функцій у методах Сібілса та Лі}
//   I0:double;
//   Iph:double;
//   Rsh:double;
//   Krec:double;
//   {коефіцієнт випрямлення}
//   Vrect:double;
//  {напруга, при якій відбувається визначення
//   коефіцієнта випрямлення}
//   RA:double;
//   RB:double;
//   RC:double;
//  {RA, RB, RC - змінні для обчислення послідовного опору за залежністю
//      Rs=A+B*T+C*T^2}
//   ForForwardBranch:boolean;
//    {used in M_V_Fun()}
//   NssType:boolean;
//    {used in Nss_Fun()}
//   Iph_Exp:boolean;
//   Iph_Lam:boolean;
//   Iph_DE:boolean;
//  {визначають, чи потрібно підбирати фотострум
//   у формулі I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph,
//  тобто чи освітлена ВАХ апроксимується;
//  Iph_Exp - пряма апроксимація за МНК (fnDiodLSM)
//  Iph_Lam - апроксимація за МНК функції Ламберта (fnDiodLambert)
//  Iph_DE - еволюційний метод(fnDiodEvolution)}
//   Procedure Clear();
//   procedure WriteToIniFile(ConfigFile:TIniFile);
//   procedure ReadFromIniFile(ConfigFile:TIniFile);
// end;
//


  TFunS=Function(x:double):double;
  TFun=Function(Argument:double;Parameters:array of double):double;

  TFunSingle=Function(x:double):double of object;
  TFunDouble=Function(x,y:double):double of object;
  TFunTriple=Function(x,y,z:double):double of object;


//  TSimpleEvent = procedure() of object;
  TSimpleEvent = procedure() of object;
  TByteEvent = procedure(B: byte) of object;

  TArrSingle=array of double;
  PTArrSingle=^TArrSingle;
  T2DArray=array of array of double;


  TArrArrSingle=array of TArrSingle;
  PClassroom=^TArrArrSingle;

  TArrWord=array of word;
  PArrWord=^TArrWord;

//  TEvent = procedure() of object;



  TArrStr=array of string;

  TArrObj=array of TObject;



  SysEquation=record
      A:T2DArray;//array of array of double;
      f:array of double;
      x:array of double;
      N:integer;
      Procedure SetLengthSys(Number:integer);
      procedure Clear;
      procedure CopyTo(var SE:SysEquation);
     end;
    {тип використовується при розв'язку
    системи лінійних рівнянь
    А - масив коефіцієнтів
    f - вектор вільних членів
    x - вектор невідомих
    N - кількість рівнянь}

  PSysEquation=^SysEquation;



  IRE=array[1..3] of double;
  {масив використовується при апроксимації
   експонентою y=I0(exp(x/E)-1)+x/R;
   [1] - I0
   [2] - R
   [3] - E}

   IRE2=array [1..3,1..3] of double;
   //тип використовується при апроксимації,
   //матриця 3х3

  TBinary=0..1;

  Limits=record     //тип для відображення частини графіку
         MinXY:TBinary; //0 - встановлене мінімальне значення абсциси
         MaxXY:TBinary; //1 - встановлене максимальне значення ординати
         MinValue:array [TBinary] of double;
         MaxValue:array [TBinary] of double;
             //граничні величини для координат графіку
         function PoinValide(Point:TPointDouble): boolean;             
         end;



   Curve3=class //(TObject)// тип для збереження трьох параметрів,
                           // по яким можна побудувати різні криві тощо
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
           {повертає значення функції Гауса
           F(x)=y0+A*exp(-(x-B)^2/(2*C^2));
           якщо С=0, то заміняється на С=1}
           function GS_Sq:double;
           {повертає площу під кривою Гауса,
           якщо її побудувати по параметрам даного
           класу: А - висота максимуму,
           В - середнє значення,
           С - ширина розподілу}
           function is_Gaus:boolean;
           {повертає, чи можна побудувати криву Гауса
           по даним параметрам; фактично, перевіряється лише те, щоб
           С не було рівним нулеві}
           function Parab(x:double):double;
           {повертає значення поліному другого
           ступеня F(x)=A+B*x+C*x^2}
           procedure Copy (Souсe:Curve3);
           {копіює значення полів з Souсe в даний}
         end;



  TParameterShow=class
//  для відображення на формі
//  а) значення параметру
//  б) його назви
//клік на значенні викликає появу віконця для його зміни
   private
    STData:TStaticText; //величина параметру
    fWindowCaption:string; //назва віконця зміни параметра
    fWindowText:string;  //текст у цьому віконці
    fHook:TSimpleEvent;
    FDefaulValue:double;
    fDigitNumber:byte;
    procedure ButtonClick(Sender: TObject);
    function GetData:double;
    procedure SetData(value:double);
    procedure SetDefaulValue(const Value: double);
    function ValueToString(Value:double):string;
   public
    STCaption:TLabel;
    property DefaulValue:double read FDefaulValue write SetDefaulValue;
    Constructor Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       WC,WT:string;
                       InitValue:double;
                       DN:byte=3
    );
    property Data:double read GetData write SetData;
    property Hook:TSimpleEvent read fHook write fHook;
    procedure ReadFromIniFile(ConfigFile:TIniFile);
    procedure WriteToIniFile(ConfigFile:TIniFile);
  end;  //   TParameterShow=object

TSimpleClass=class
   public
    class procedure EmptyProcedure;
  end;

//var
//  GraphParameters:TGraphParameters;



 Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                     Value:double; Default:double=ErResult);overload;
{записує в .ini-файл значення тільки якщо воно не дорівнює Default}

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:integer; Default:integer=ErResult);overload;
{записує в .ini-файл значення тільки якщо воно не дорівнює Default}

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:string; Default:string='');overload;
{записує в .ini-файл значення тільки якщо воно не дорівнює Default}

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:Boolean);overload;
{записує в .ini-файл значення тільки якщо воно дорівнює True}

implementation
uses OlegMathNew,{OlegGraphNew,} Classes, Dialogs, Controls, Math;


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

Procedure TDiapazon.Copy (Souсe:TDiapazon);
           {копіює значення полів з Souсe в даний}
begin
XMin:=Souсe.Xmin;
YMin:=Souсe.Ymin;
XMax:=Souсe.Xmax;
YMax:=Souсe.Ymax;
Br:=Souсe.Br;
end;

constructor TDiapazon.Create;
begin
 inherited Create;
 fXMin:=0;
 fYMin:=0;
 fXMax:=ErResult;
 fYMax:=ErResult;
 fBr:='F';
end;

function TDiapazon.PoinValide(Point: TPointDouble): boolean;
 var bXmax, bXmin, bYmax, bYmin:boolean;
begin
 bXmax:=false;bYmax:=false;bXmin:=false;bYmin:=false;
case fBr of
 'F':begin
    bXmax:=(XMax=ErResult)or(Point[cX]<XMax);
    bXmin:=(XMin=ErResult)or(Point[cX]>XMin);
    bYmax:=(YMax=ErResult)or(Point[cY]<YMax);
    bYmin:=(YMin=ErResult)or(Point[cY]>YMin);
     end;
 'R':begin
    bXmax:=(XMax=ErResult)or(Point[cX]>-XMax);
    bXmin:=(XMin=ErResult)or(Point[cX]<-XMin);
    bYmax:=(YMax=ErResult)or(Point[cY]>-YMax);
    bYmin:=(YMin=ErResult)or(Point[cY]<-YMin);
    end;
 end; //case
// if YminDontUsed then bYmin:=True;

 Result:=bXmax and bXmin and bYmax and bYmin;


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
           {повертає значення функції Гауса
           F(x)=y0+A*exp(-(x-B)^2/(2*C^2));
           якщо С=0, то заміняється на С=1}
 begin
  if C=0 then C:=1;
  Result:=y0+A*exp(-sqr((x-B))/2/sqr(C));
 end;


Function Curve3.GS_Sq:double;
           {повертає площу під кривою Гауса,
           якщо її побудувати по параметрам даного
           класу: А - висота максимуму,
           В - середнє значення,
           С - ширина розподілу}
 begin
   Result:=A*C*sqrt(2*3.14);
 end;

Function Curve3.is_Gaus:boolean;
           {повертає, чи можна побудувати криву Гауса
           по даним параметрам; фактично, перевіряється лише те, щоб
           С не було рівним нулеві}
 begin
   Result:=not(C=0);
 end;

Function Curve3.Parab(x:double):double;
           {повертає значення поліному другого
           ступеня F(x)=A+B*x+C*x^2}
 begin
   Result:=A+B*x+C*sqr(x);
 end;

Procedure Curve3.Copy (Souсe:Curve3);
           {копіює значення полів з Souсe в даний}
begin
  A:=Souсe.A;
  B:=Souсe.B;
  C:=Souсe.C;
end;





Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:double; Default:double=ErResult);
{записує в .ini-файл значення тільки якщо воно не дорівнює Default}
begin
 if (Value<>Default) then ConfigFile.WriteFloat(Section,Ident,Value);
end;

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:integer; Default:integer=ErResult);
{записує в .ini-файл значення тільки якщо воно не дорівнює Default}
begin
 if (Value<>Default) then ConfigFile.WriteInteger(Section,Ident,Value);
end;

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:string; Default:string='');overload;
{записує в .ini-файл значення тільки якщо воно не дорівнює Default}
begin
 if (Value<>Default) then ConfigFile.WriteString(Section,Ident,Value);
end;

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:Boolean);
{записує в .ini-файл значення тільки якщо воно дорівнює True}
begin
 if Value then ConfigFile.WriteBool(Section,Ident,Value);
end;

Constructor TParameterShow.Create(STD:TStaticText;
                       STC:TLabel;
                       ParametrCaption:string;
                       WC,WT:string;
                       InitValue:double;
                       DN:byte=3
                       );
begin
  inherited Create;
  fDigitNumber:=DN;

  STData:=STD;
  STData.Caption:=ValueToString(InitValue);
  STData.OnClick:=ButtonClick;
  STData.Cursor:=crHandPoint;
  STCaption:=STC;
  STCaption.Caption:=ParametrCaption;
  STCaption.WordWrap:=True;
  fWindowCaption:=WC;
  fWindowText:=WT;
  DefaulValue:=InitValue;
end;

procedure TParameterShow.ButtonClick(Sender: TObject);
 var temp:double;
     st:string;
begin
  st:=InputBox(fWindowCaption,fWindowText,STData.Caption);
  try
    temp:=StrToFloat(st);
    STData.Caption:=ValueToString(temp);
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
    STData.Caption:=ValueToString(value);
  finally

  end;
end;

procedure TParameterShow.ReadFromIniFile(ConfigFile:TIniFile);
begin
 STData.Caption:=ValueToString(ConfigFile.ReadFloat(DoubleConstantSection,STCaption.Caption,DefaulValue));
end;

procedure TParameterShow.WriteToIniFile(ConfigFile:TIniFile);
begin
 WriteIniDef(ConfigFile, DoubleConstantSection, STCaption.Caption, StrToFloat(STData.Caption),DefaulValue)
end;

procedure TParameterShow.SetDefaulValue(const Value: double);
begin
  FDefaulValue := Value;
end;

function TParameterShow.ValueToString(Value:double):string;
begin
  if (Frac(Value)=0)and(Int(Value/Power(10,fDigitNumber+1))=0)
    then Result:=FloatToStrF(Value,ffGeneral,fDigitNumber,fDigitNumber-1)
    else Result:=FloatToStrF(Value,ffExponent,fDigitNumber,fDigitNumber-1);
end;

class procedure TSimpleClass.EmptyProcedure;
begin

end;



{ SysEquation }

procedure SysEquation.Clear;
 var i,j:integer;
begin
 for i := 0 to High(f) do
   begin
   f[i]:=0;
   x[i]:=0;
   for j:=0 to N-1 do A[i,j]:=0;
   end;
end;

procedure SysEquation.CopyTo(var SE: SysEquation);
 var i,j:integer;
begin
 SE.SetLengthSys(Self.N);
  for i := 0 to High(f) do
   begin
   SE.f[i]:=Self.f[i];
   SE.x[i]:=Self.x[i];
   for j:=0 to N-1 do SE.A[i,j]:=Self.A[i,j];
   end;
end;

procedure SysEquation.SetLengthSys(Number: integer);
begin
  N:=Number;
  SetLength(f,N);
  SetLength(x,N);
  SetLength(A,N,N);
end;

//{ TGraphParameters }
//
//procedure TGraphParameters.Clear;
//begin
//   Rs:=ErResult;
//   n:=ErResult;
//   Fb:=ErResult;
//   I0:=ErResult;
//   Iph:=ErResult;
//   Rsh:=ErResult;
//   Krec:=ErResult;
//end;
//
//procedure TGraphParameters.ReadFromIniFile(ConfigFile: TIniFile);
//begin
// Iph_Exp:=ConfigFile.ReadBool('Approx','Iph_Exp',True);
// Iph_Lam:=ConfigFile.ReadBool('Approx','Iph_Lam',True);
// Iph_DE:=ConfigFile.ReadBool('Approx','Iph_DE',True);
// Gamma:=ConfigFile.ReadFloat('Diapaz','Gamma',2);
// Gamma1:=ConfigFile.ReadFloat('Diapaz','Gamma1',2);
// Gamma2:=ConfigFile.ReadFloat('Diapaz','Gamma2',2.5);
// Va:=ConfigFile.ReadFloat('Diapaz','Va',0.05);
// Vrect:=ConfigFile.ReadFloat('Diapaz','Vrect',0.12);
// RA:=ConfigFile.ReadFloat('Resistivity','RA',1);
// RB:=ConfigFile.ReadFloat('Resistivity','RB',0);
// RC:=ConfigFile.ReadFloat('Resistivity','RC',0);
//end;
//
//procedure TGraphParameters.WriteToIniFile(ConfigFile: TIniFile);
//begin
// ConfigFile.WriteBool('Approx','Iph_Exp',Iph_Exp);
// ConfigFile.WriteBool('Approx','Iph_Lam',Iph_Lam);
// ConfigFile.WriteBool('Approx','Iph_DE',Iph_DE);
// ConfigFile.WriteFloat('Diapaz','Gamma',Gamma);
// ConfigFile.WriteFloat('Diapaz','Gamma1',Gamma1);
// ConfigFile.WriteFloat('Diapaz','Gamma2',Gamma2);
// ConfigFile.WriteFloat('Diapaz','Va',Va);
// ConfigFile.WriteFloat('Diapaz','Vrect',Vrect);
// ConfigFile.WriteFloat('Resistivity','RA',RA);
// ConfigFile.WriteFloat('Resistivity','RB',RB);
// ConfigFile.WriteFloat('Resistivity','RC',RC);
//
//end;


{ Limits }

function Limits.PoinValide(Point: TPointDouble): boolean;
begin
    Result:=False;
    if (MinXY=0) and (MaxXY=0)
     then
      Result:=((MinValue[0]=ErResult)or(Point[cX]>MinValue[0]))
       and ((MaxValue[0]=ErResult)or(Point[cX]<MaxValue[0]));

    if (MinXY=0) and (MaxXY=1)
     then
      Result:=((MinValue[0]=ErResult)or(Point[cX]>MinValue[0]))
       and ((MaxValue[1]=ErResult) or (Point[cY]<MaxValue[1]));

    if (MinXY=1) and (MaxXY=1)
     then
      Result:=((MinValue[1]=ErResult)or(Point[cY]>MinValue[1]))
       and ((MaxValue[1]=ErResult)or(Point[cY]<MaxValue[1]));

    if (MinXY=1) and (MaxXY=0)
     then
      Result:=((MinValue[1]=ErResult)or(Point[cY]>MinValue[1]))
       and ((MaxValue[0]=ErResult)or(Point[cX]<MaxValue[0]));
end;

end.
