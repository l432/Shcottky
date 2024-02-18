unit OlegType;


interface
//uses Windows,Messages,SysUtils,Forms;
 uses IniFiles,SysUtils, StdCtrls;

const Kb=8.625e-5; {стала Больцмана, []=eV/K}
      Eps0=8.85e-12; {діелектрична стала, []=Ф/м}
      Qelem=1.6e-19; {елементарний заряд, []=Кл}
      Hpl=1.05457e-34; {постійна Планка перекреслена, []=Дж c}
      m0=9.11e-31; {маса електрону []=кг}
      Clight=3e8;
      ErResult=555;
      DoubleConstantSection='DoubleConstant';
      Voc_min=0.0002;
      Isc_min=1e-11;
      mask='*.dat';
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

  TDiapazonLimits=(dlXMin,dlYMin,dlXMax,dlYMax);

const
  DiapazonLimitNames:array[TDiapazonLimits]of string=
    ('Xmin','Ymin','Xmax','Ymax');
type

{}  TDiapazon=class //(TObject)// тип для збереження тих меж, в яких
                           // відбуваються апроксимації різних функцій
         private
           fXMin:double;
           fYMin:double;
           fXMax:double;
           fYMax:double;
           fBr:Char; //'F' коли діапазон для прямої гілки
                     //'R' коли діапазон для зворотньої гілки
           fStrictEquality:boolean;
                     {TRUE - в PoinValide строгі рівності}
           procedure SetData(Index:integer; value:double);
           procedure SetDataBr(value:Char);

         public
           property XMin:double Index 1 read fXMin write SetData;
           property YMin:double Index 2 read fYMin write SetData;
           property XMax:double Index 3 read fXMax write SetData;
           property YMax:double Index 4 read fYMax write SetData;
           property Br:Char read fBr write SetDataBr;
           property StrictEquality:boolean  read fStrictEquality write fStrictEquality;
           Constructor Create();
           procedure CopyFrom (Souсe:TDiapazon);
           procedure ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
           procedure WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
           function PoinValide(Point:TPointDouble): boolean;
           {визначає, чи задовільняють координати точки Point межам}
           procedure SetLimits(const XmMin,XmMax,YmMin,YmMax:double);
           function ToStringMy:string;
           procedure Clear;
           class function LimitCaption(DL:TDiapazonLimits):string;
           function LimitValue(DL:TDiapazonLimits):double;
         end;


  TArrSingle=array of double;
  PTArrSingle=^TArrSingle;
  T2DArray=array of array of double;


  TArrInteger=array of integer;

  TFunS=Function(x:double):double;
  TFun=Function(Argument:double;Parameters:array of double):double;
  TFunDoubleObj=Function(Argument:double;Parameters:array of double):double of object;
  TFunIJObj=Function(i,j:byte):double of object;

  TFunPoint=Function(Argument:double):TPointDouble of object;

  TFunObj=Function(Point:TPointDouble;Parameters:TArrSingle):double of object;
  TFunSingle=Function(x:double):double of object;
  TFunDouble=Function(x,y:double):double of object;
  TFunTriple=Function(x,y,z:double):double of object;


  TSimpleEvent = procedure() of object;
  TByteEvent = procedure(B: byte) of object;
  TOnePopulationCreate = procedure (i:integer)of object;

  TProcedFile=Procedure(FileName:string);


  TArrArrSingle=array of TArrSingle;

  TArrWord=array of word;
  PArrWord=^TArrWord;

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
      procedure OutPutX(var OutputData:TArrSingle);
      procedure InPutF(InputData:TArrSingle);
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


function IsNumberInArray(const Value: Integer; const Arr: array of Integer): Boolean;
{перевіряє, чи зустрічається Value в Arr}

procedure AddNumberToArray(const Value: Integer; var Arr: TArrInteger);
{додає ще один елемент до масиву, збільшуючи його довжину}

procedure AddUniqueNumberToArray(const Value: Integer; var Arr: TArrInteger);
{додає ще один елемент до масиву, якщо його там ще немає}

implementation
uses OlegMath, Classes, Dialogs, Controls, Math;


procedure TDiapazon.SetData(Index:integer; value:double);
begin
case Index of
 1: if ((Value=ErResult)or(fXMax=ErResult))
       or((fXMax<>ErResult)and(Value<fXMax)) then fXMin:=Value;
 2: if ((Value=ErResult)or(fYmax=ErResult))
       or((fYMax<>ErResult)and(Value<fYMax)) then fYMin:=Value;
 3: if ((Value=ErResult)or(fXMin=ErResult))
       or((fXMin<>ErResult)and(Value>fXMin)) then fXMax:=value;
 4: if ((Value=ErResult)or(fYMin=ErResult))
       or((fYMin<>ErResult)and(Value>fYMin)) then fYMax:=value;
 end;
end;

procedure TDiapazon.SetDataBr(value:char);
begin
if value='R' then fBr:=value
             else fBr:='F';
end;


procedure TDiapazon.SetLimits(const XmMin, XmMax, YmMin, YmMax: double);
begin
 if ((XmMin=ErResult)or(XmMax=ErResult)or(XmMax>XmMin))
    and((YmMin=ErResult)or(YmMax=ErResult)or(YmMax>YmMin)) then
 begin
   Self.fXMin:=XmMin;
   Self.fXMax:=XmMax;
   Self.fYMin:=YmMin;
   Self.fYMax:=YmMax;
 end;
end;

function TDiapazon.ToStringMy: string;
begin
 Result:='Xmin='+floattostr(fXMin)
         +#10+'Xmax='+floattostr(fXMax)
         +#10+'Ymin='+floattostr(fYMin)
         +#10+'Ymax='+floattostr(fYMax);
end;

Procedure TDiapazon.CopyFrom (Souсe:TDiapazon);
           {копіює значення полів з Souсe в даний}
begin
XMin:=Souсe.Xmin;
YMin:=Souсe.Ymin;
XMax:=Souсe.Xmax;
YMax:=Souсe.Ymax;
Br:=Souсe.Br;
end;

procedure TDiapazon.Clear;
begin
 fXMin:=ErResult;
 fYMin:=ErResult;
 fXMax:=ErResult;
 fYMax:=ErResult;
end;

constructor TDiapazon.Create;
begin
 inherited Create;
 fXMin:=0;
 fYMin:=0;
 fXMax:=ErResult;
 fYMax:=ErResult;
 fBr:='F';
 fStrictEquality:=True;
end;

class function TDiapazon.LimitCaption(DL: TDiapazonLimits): string;
begin
 Result:=DiapazonLimitNames[DL];
end;

function TDiapazon.LimitValue(DL: TDiapazonLimits): double;
begin
 case DL of
  dlXMin:Result:=fXMin;
  dlYMin:Result:=fYMin;
  dlXMax:Result:=fXMax;
  dlYMax:Result:=fYMax;
  else Result:=ErResult;
 end;
end;

function TDiapazon.PoinValide(Point: TPointDouble): boolean;
 var bXmax, bXmin, bYmax, bYmin:boolean;
begin
 bXmax:=false;bYmax:=false;bXmin:=false;bYmin:=false;
case fBr of
 'F':begin
      if fStrictEquality then
          begin
            bXmax:=(XMax=ErResult)or(Point[cX]<XMax);
            bXmin:=(XMin=ErResult)or(Point[cX]>XMin);
            bYmax:=(YMax=ErResult)or(Point[cY]<YMax);
            bYmin:=(YMin=ErResult)or(Point[cY]>YMin);
          end            else
          begin
            bXmax:=(XMax=ErResult)or(Point[cX]<=XMax);
            bXmin:=(XMin=ErResult)or(Point[cX]>=XMin);
            bYmax:=(YMax=ErResult)or(Point[cY]<=YMax);
            bYmin:=(YMin=ErResult)or(Point[cY]>=YMin);
          end;
     end;
 'R':begin
      if fStrictEquality then
          begin
            bXmax:=(XMax=ErResult)or(Point[cX]>-XMax);
            bXmin:=(XMin=ErResult)or(Point[cX]<-XMin);
            bYmax:=(YMax=ErResult)or(Point[cY]>-YMax);
            bYmin:=(YMin=ErResult)or(Point[cY]<-YMin);
          end            else
          begin
            bXmax:=(XMax=ErResult)or(Point[cX]>=-XMax);
            bXmin:=(XMin=ErResult)or(Point[cX]<=-XMin);
            bYmax:=(YMax=ErResult)or(Point[cY]>=-YMax);
            bYmin:=(YMin=ErResult)or(Point[cY]<=-YMin);
          end;
    end;
 end; //case
// if YminDontUsed then bYmin:=True;

 Result:=bXmax and bXmin and bYmax and bYmin;


end;

procedure TDiapazon.ReadFromIniFile(ConfigFile:TIniFile;const Section, Ident: string);
begin
  fXMin:=ConfigFile.ReadFloat(Section,Ident+'XMin',ErResult);
  fYMin:=ConfigFile.ReadFloat(Section,Ident+'YMin',ErResult);
  fXMax:=ConfigFile.ReadFloat(Section,Ident+'XMax',ErResult);
  fYMax:=ConfigFile.ReadFloat(Section,Ident+'Ymax',ErResult);
  fBr:=ConfigFile.ReadString(Section,Ident+'Br','F')[1];
end;

procedure TDiapazon.WriteToIniFile(ConfigFile:TIniFile;const Section, Ident: string);
begin
 WriteIniDef(ConfigFile,Section, Ident+'XMin',fXmin);
 WriteIniDef(ConfigFile,Section, Ident+'YMin',fYMin);
 WriteIniDef(ConfigFile,Section, Ident+'XMax',fXMax);
 WriteIniDef(ConfigFile,Section, Ident+'Ymax',fYmax);
 WriteIniDef(ConfigFile,Section, Ident+'Br',fBr,'F');
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

procedure SysEquation.InPutF(InputData: TArrSingle);
 var i:integer;
begin
  try
    for I := 0 to High(InputData) do
      f[i]:=InputData[i];
  finally

  end;
end;

procedure SysEquation.OutPutX(var OutputData: TArrSingle);
 var i:integer;
begin
  try
    for I := 0 to High(x) do
      OutputData[i]:=x[i];
  finally

  end;
end;

procedure SysEquation.SetLengthSys(Number: integer);
begin
  N:=Number;
  SetLength(f,N);
  SetLength(x,N);
  SetLength(A,N,N);
end;

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

function IsNumberInArray(const Value: Integer; const Arr: array of Integer): Boolean;
var
  Index: Integer;
begin
  for Index := Low(Arr) to High(Arr) do
  begin
    if Arr[Index] = Value then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

procedure AddNumberToArray(const Value: Integer; var Arr: TArrInteger);
{додає ще один елемент до масиву, збільшуючи його довжину}
begin
  SetLength(Arr, High(Arr) + 2); // Збільшення розміру масиву на 1
  Arr[High(Arr)] := Value;
end;

procedure AddUniqueNumberToArray(const Value: Integer; var Arr: TArrInteger);
{додає ще один елемент до масиву, якщо його там ще немає}
begin
  if IsNumberInArray(Value,Arr)
    then Exit
    else AddNumberToArray(Value,Arr);

end;

end.
