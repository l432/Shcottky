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

  TFunS=Function(x:double):double;
  TFun=Function(Argument:double;Parameters:array of double):double;

  TFunSingle=Function(x:double):double of object;
  TFunDouble=Function(x,y:double):double of object;
  TFunTriple=Function(x,y,z:double):double of object;

  TCoord_type=(cX,cY);
  TPointDouble=array[TCoord_type]of double;

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

  Limits=record     //тип для відображення частини графіку
         MinXY:0..1; //0 - встановлене мінімальне значення абсциси
         MaxXY:0..1; //1 - встановлене максимальне значення ординати
         MinValue:array [0..1] of double;
         MaxValue:array [0..1] of double;
             //граничні величини для координат графіку
         end;

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
           procedure Copy (Souсe:TDiapazon);
           procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
           procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
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
uses OlegMathNew,OlegGraphNew, Classes, Dialogs, Controls, Math;


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



end.
