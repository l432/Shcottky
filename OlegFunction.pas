unit OlegFunction;

interface

uses ComCtrls, Spin, StdCtrls, Series, Forms, Controls, IniFiles, OlegType,
 Dialogs, OlegMath, StrUtils, Classes, Windows, OlegVector, Grids, ExtCtrls
//{XP Win}
 ,VCLTee.TeEngine
 ;

Procedure ToTrack (Num:double;Track:TTrackbar; Spin:TSpinEdit; CBox:TCheckBox);
{встановлюється значення Spin та позиція Track відповідно до
порядку та величини числа Num;
якщо число негативне - встановлюється вибраність СВох;
бажано, щоб діапазон зміни Track від 1 до 1000}

Function ToNumber (Track:TTrackbar; Spin:TSpinEdit; CBox:TCheckBox):double;
{перетворює те, що встановлено на візуальних компонентах
в число - детальніше див. процедуру ToTrack}

Procedure GraphSum (Lines: array of TLineSeries);
{в нульовий елемент масиву вносить суму графіків,
що знаходяться в інших;
передбачається, що у цих всіх інших кількість
точок та їх абсциси однакові}

//Procedure ElementsFromForm(Form:TForm);
Procedure ElementsFromForm(WinControl:TWinControl);
{забирає всі елементи з форми}


Procedure CompEnable(Fm:TForm;Tag:integer;State:boolean);
{для всіх елементів, що знаходяться на формі Fm та мають таг Tag,
властивості Enable встановлюється значення State}

procedure StrToNumber(St:TCaption; Def:double; var Num:double);
{процедура переведення тестового рядка St в чисельне
значення Num;
якщо формат рядка поганий - змінна не зміниться,
буде показано віконечко з відповідним написом;
якщо рядок порожній - Num  буде присвоєне
значення Def}

Function SomeSpaceToOne(str:string):string;
{замінює декілька пробілів на один}

Function Acronym(str:string):string;
{створюється аббревіатура рядка}

Function StringDataFromRow(str:string;Number:word):string;
{вважається, що частини рядка відділені один від одного пробілами;
повертається частина з номером Number (нумерація починається з 1)}

Function FloatDataFromRow(str:string;Number:word):double;
{вважається, що частини рядка відділені один від одного пробілами;
повертається число, розташоване в частині з номером Number
(нумерація починається з 1);
якщо там не число - то повертається ErResult}

Function NumberOfSubstringInRow(row:string):integer;
{визначається кількість частин у рядку row, відділених
пробілами}

Function SubstringNumberFromRow(substring,row:string):integer;
{визначається номер частини substring з рядка row,
нумерація починається з одиниці,
якщо частина відсутня повертається нуль}

Function  DeleteStringDataFromRow(str:string;Number:word):string;
{повертає рядок з видаленою частиною (відділеною пробілами - див.
попередні) з номером Number}

Function NumberDetermine(Names:array of string;
                          Source:string;
                          var Numbers:TArrInteger):boolean;
{визначення номерів позицій елементів з Names в рядку Source;
якщо хоча б одного елементу немає - результат False}

function ArrayToString(ArrSingle:TArrSingle):string;overload;

function ArrayToString(AOS:array of string):string;overload;

function ArrayToString(ArrSingle:TArrSingle;TitelsArr:array of string):string;overload;

function VecNamesToString(AV:TArrVec):string;

Procedure ShowArrayOfString(AOS:array of string);

Function NewStringByNumbers(Source:string;
                           Numbers:TArrInteger):string;
{створюється новий рядок з тих частин Source, номери яких вказані в Numbers,
частини розділені пробілами, крайній пробіл видалено}

Function NewStringFromStringArray(Source:array of string;
                                 Syffix:string=''):string;
{створюється новий рядок з усіх значень Source,
до кожного елемента дописується Syffix,
елементи розділені пробілами, крайній пробіл видалено}

Function DeleteLastDir(LongPath:string):string;
{з довгого шляху LongPath, що закінчується '\',
видаляє останню папку}

//-----використовуються при моделюванні DAP-----------
Function PointDistance(t:double;Parameters:array of double):double;
{відстань, між двома точками, які коливаються з однаковою частотою
та різними амплітудами в момент часу t
(правильніше t - частка періоду, час нормований на період,[t]=1)
Parameters[0] - r0 - відстань між точками в рівновазі
Parameters[1] - A1 - амплітуда коливань першої точки
Parameters[2] - A2 - амплітуда коливань другої точки
Parameters[3] - fi - кут між напрямком коливань
               та прямою, що з'єднує рівноважні положення точок
Parameters[4] - delta - зсув фаз між коливаннями другої та першої точок
[fi]=[delta]=degree
}

Function PointDistance2(t:double;Parameters:array of double):double;
{квадрат відстані - див. попередню}

Function OverlapIntegral(x:double):double;
{повертає L(x)=[1+x+1/3*x^2]*exp(-x)}

Function OverlapIntegralVibrate(t:double;Parameters:array of double):double;
{повертає значення  OverlapIntegral(r/a0) в
момент часу t;
r описується PointDistance(t);
a0=Parameters[5]}

Function OverageValue(Fun:TFun;Parameters:array of double):double;

Procedure DegreeDependence();
//-----END---використовуються при моделюванні DAP-----------

//Procedure VocFF_Dependence();

Procedure  DelaySleep(mSec:Cardinal);

Procedure  DelayQueryPerformance(mSec:Cardinal);

Function  ImpulseNoiseSmoothing(const Data:  PTArrSingle): Double;overload;
{розраховується середнє значення на масиві даних з врахуванням
можливих імпульсних шумів
див Р.Лайонс "Цифровая обработка сигналов", с.551
DoubleArrayPointer - вказівник на масив даних (на початковий елемент),
який має бути array of double, при виклиці щось на кшталт  @DATA[Low(DATA)]
HighDoubleArray - найбільше значення індексу масиву
}

Function  ImpulseNoiseSmoothing(const Data:  TVector; ItIsXVector:boolean=False): Double;overload;
{якщо ItIsXVector=True, то середнє рахується
по значенням  координати X, інакше - по Y}


Procedure ImNoiseSmoothedArray(const Source:PTArrSingle;
                               Target:PTArrSingle;
                               Npoint:Word=0);overload;
{в Target записується результата
зглажування (див ImpulseNoiseSmoothingByNpoint) Source
по Npoint точкам}


Function ImpulseNoiseSmoothingByNpoint(Data:  PTArrSingle;
                                       Npoint:Word=0): Double;overload;
{розраховується середнє значення на масиві даних з врахуванням
можливих імпульсних шумів,
на відміну від ImpulseNoiseSmoothing дані розбиваються на порції
по Npoint штук на наборі яких розраховується середнє,
потім середні розбиваються на порції ....}

//Function Bisection(const F:TFun; const Parameters:array of double;
//                   const Xmax:double=5; const Xmin:double=0;
//                   const eps:double=1e-6):double;overload;
//{метод ділення навпіл для функції F на інтервалі [Xmin,Xmax]
//eps - відносна точність розв'язку
//(ширина кінцевого інтервалу по відношенню до величини його границь)}
//
//Function Bisection(const F:TFunDoubleObj; const Parameters:array of double;
//                   const Xmax:double=5; const Xmin:double=0;
//                   const eps:double=1e-6):double;overload;
//
//
//
//Function Hord(const F:TFun; const Parameters:array of double;
//                   const Xmax:double=5; const Xmin:double=0;
//                   const eps:double=1e-6):double;
//{метод хорд для функції F на інтервалі [Xmin,Xmax]
//eps - відносна точність розв'язку
//(зміна наступного наближення по відношенню до його величини)}

Function SelectFromVariants(Variants:TStringList;
                            Index:ShortInt;
                            WindowsCaption:string='Select'):ShortInt;
{показує модальне вікно, де вибір радіо-кнопок,
підписаних відповідно до вмісту Variants;
при натиснутій "Ok" повертає
індекс вибраного вваріанту, інакше -1}

Procedure AccurateCheckBoxCheckedChange(CB:TCheckBox;Value:boolean);
//зміна значення  CheckBox.Checked без виклику процедури onClick

Procedure HelpForMe(str:string; filname:string='');

Procedure DecimationArray(var Data:  TArrSingle; const N:word);
{у масиві залишається лише 0-й, ?-й, 2N-й.... елементи,
при N=0 масив не міняється}

Function GetHDDSerialNumber():LongWord;

Procedure CreateDirSafety(DirName: string);
{створюється директорія з назвою DirName
в поточному каталозі, ігноруються можливі помилки;
як правило, ці помилки викликані тим, що директорія з такою назвою вже є}

Function MilliSecond:integer;
{повертає поточне значення мілісекунд з
врахуванням хвилин та секунд}

function SecondFromDayBegining:integer;overload;
{повертає кількість секунд з початку доби}
function SecondFromDayBegining(ttime: TDateTime):integer;overload;


procedure InitArray(var OutputData: TArrSingle;NumberOfData:word;
                             InitialValue:double=ErResult);overload;
{забезпечую, щоб в OutputData було не менше
NumberOfData елементів та призначає цим
елементам значення InitialValue}
procedure InitArray(var OutputData:TArrInteger;NumberOfData:word;
                             InitialValue:integer=0);overload;


procedure StringArrayToStringList(const Arr:array of string;
                                  StringList:TStringList;
                                  ClearStringList:boolean=True);

Function FileNameToVoltage(name:string):double;

procedure AddRowToFileFromStringGrid(FileName:string;
                   StrGridData: TStringGrid;
                   RowNumber:integer);
{до файла FileName додається рядок з номером RowNumber з StrGridData}

procedure  StringGridToFile(FileName:string;
                   StrGridData: TStringGrid);
{всі дані з StrGridData заносяться у файл}


procedure PictLoadScale(Img: TImage; ResName:String);
{в Img завантажується bmp-картинка з ресурсу з назвою
ResName і масштабується зображення, щоб не вийшо
за межі розмірів Img, які були перед цим}

Function FitName(V: TVector; st:string='fit'):string;//overload;
{повертає змінене значення V.name,
зміна полягає у дописуванні st перед першою крапкою}

function NvsRo(Nd:double;param:array of double):double;
{param[0] - Ro
 param[1] - T
}

function IntToFrac(i:integer):double;
{ділить модуль і доти, поки не буде число, менше 1,
його і повертає}

procedure StringListShow(StrL:TStringList);


implementation

uses
  SysUtils, Math, Graphics, OlegMaterialSamples;

Procedure ToTrack (Num:double;Track:TTrackbar; Spin:TSpinEdit; CBox:TCheckBox);
{встановлюється значення Spin та позиція Track відповідно до
порядку та величини числа Num;
якщо число негативне - встановлюється вибраність СВох;
бажано, щоб діапазон зміни Track від 1 до 1000}
var i:integer;
temp:double;
begin
if Num=0 then
   begin
     Spin.Value:=0;
     Track.Position:=0;
     CBox.Checked:=False;
     Exit;
   end;
i:=0;
temp:=abs(Num);
if abs(Num)>=10 then
 repeat
  temp:=temp/10;
  i:=i+1;
 until (temp<10);
if abs(Num)<1 then
 repeat
  temp:=temp*10;
  i:=i-1;
 until (temp>1);
Spin.Value:=i;
Track.Position:=Round(temp*100);
CBox.Checked:=(Num<0);
end;

Function ToNumber (Track:TTrackbar; Spin:TSpinEdit; CBox:TCheckBox):double;
{перетворює те, що встановлено на візуальних компонентах
в число - детальніше див. процедуру ToTrack}
var i:integer;
begin
  Result:=Track.Position/100;
  for i := 1 to abs(Spin.Value) do
   if Spin.Value>0 then Result:=Result*10
                   else Result:=Result/10;
if CBox.Checked then Result:=-1*Result;

end;

Procedure GraphSum (Lines: array of TLineSeries);
{в нульовий елемент масиву вноситу суму графіків,
що знаходяться в інших;
передбачається, що у цих всіх інших кількість
точок та їх абсциси однакові}
var i,j:integer;
     y:double;
begin
try
  Lines[0].Clear;
  for I := 0 to Lines[1].Count - 1 do
    begin
    y:=0;
    for j := 1 to High(Lines) do
      y:=y+Lines[j].YValue[i];
    Lines[0].AddXY(Lines[1].XValue[i],y)
    end;
finally
end; //try
end;

Procedure ElementsFromForm(WinControl:TWinControl);
var i:integer;
begin
   for I := WinControl.ComponentCount-1 downto 0 do
     WinControl.Components[i].Free;
end;

Procedure CompEnable(Fm:TForm;Tag:integer;State:boolean);
{для всіх елементів, що знаходяться на формі Fm та мають таг Tag,
властивості Enable встановлюється значення State}
var i:integer;
begin
for I := 0 to Fm.ComponentCount-1 do
  if (Fm.Components[i].Tag=Tag)and(Fm.Components[i] is TControl)
     then (Fm.Components[i] as TControl).Enabled:=State;
end;

procedure StrToNumber(St:TCaption; Def:double; var Num:double);
{процедура переведення тестового рядка St в чисельне
значення Num;
якщо формат рядка поганий - змінна не зміниться,
буде показано віконечко з відповідним написом;
якщо рядок порожній - Num  буде присвоєне
значення Def}
var temp:real;
begin
if St='' then Num:=Def
         else
          begin
           try
            temp:=StrToFloat(St);
           except
            on Exception : EConvertError do
                   begin
                   ShowMessage(Exception.Message);
                   Exit;
                   end;
           end;//try
           Num:=temp;
          end;//else
end;

Function SomeSpaceToOne(str:string):string;
begin
  Result:=str;
  Result:=AnsiReplaceStr(Result,#9,' ');
  while AnsiContainsStr(Result,'  ') do
     Result:=AnsiReplaceStr(Result,'  ',' ');
  Result:=Trim(Result);
end;

Function Acronym(str:string):string;
begin
  Result:='';
  str:=Trim(str);
  if Length(str)<1 then Exit;
  Result:=str[1];
  while AnsiContainsStr(str,' ') do
    begin
    str:=Copy(str, AnsiPos (' ',str)+1, Length(str)-AnsiPos (' ',str));
    Result:=Result+str[1];
    end;
  Result:=AnsiUpperCase(Result);
end;

Function StringDataFromRow(str:string;Number:word):string;
{вважається, що частини рядка відділені один від одного пробілами;
повертається частина з номером Number (нумерація починається з 1)}
 var i:word;
begin
  Result:='';
  if Number<1 then Exit;
  Result:=SomeSpaceToOne(str);
  for I := 1 to Number-1 do
   if AnsiPos (' ', Result)>0 then
       Delete(Result, 1, AnsiPos (' ', Result))
                              else
       begin
         Result:='';
         Exit;
       end;
  if AnsiPos (' ', Result)>0 then
   Result:=Copy(Result, 1, AnsiPos (' ', Result)-1);
end;


Function NumberOfSubstringInRow(row:string):integer;
{визначається частин у рядку row, відділених
пробілами}
 var tempstr:string;
begin
  tempstr:=SomeSpaceToOne(row);
  if tempstr='' then Result:=0
                else Result:=1;
  while AnsiPos (' ', tempstr)>0 do
     begin
      Delete(tempstr, 1, AnsiPos (' ', tempstr));
      inc(Result);
     end;
end;


Function SubstringNumberFromRow(substring,row:string):integer;
 var tempstr:string;
     i:integer;
begin
  Result:=0;
  tempstr:=SomeSpaceToOne(row);
  i:=1;
  repeat
   if AnsiPos (' ', tempstr)>0 then
    begin
      if substring=Copy(tempstr, 1, AnsiPos (' ', tempstr)-1) then
        begin
          Result:=i;
          Break;
        end;
      Delete(tempstr, 1, AnsiPos (' ', tempstr));
    end                       else
    begin
      if substring=tempstr then
        begin
          Result:=i;
          Break;
        end;
      tempstr:='';
    end;
    inc(i);
  until tempstr='';
end;

Function  DeleteStringDataFromRow(str:string;Number:word):string;
{повертає рядок з видаленою частиною (відділеною пробілами - див.
попередні) з номером Number}
 var i,FirstSpacePosition:word;
     tempStr:string;
begin
  Result:='';
  if Number<1 then
    begin
    Result:=SomeSpaceToOne(str);
    Exit;
    end;
  tempStr:=SomeSpaceToOne(str);
  for I := 1 to Number-1 do
   begin
    FirstSpacePosition:=AnsiPos (' ', tempStr);
    if FirstSpacePosition>0 then
       begin
       Result:=Result+AnsiLeftStr(tempStr,FirstSpacePosition);
       Delete(tempStr, 1, FirstSpacePosition);
       end                  else
       begin
        Result:=Result+tempStr;
        Exit;
       end;
   end;

  FirstSpacePosition:=AnsiPos (' ', tempStr);
  if FirstSpacePosition>0 then
   Result:=Result+AnsiRightStr(tempStr,Length(tempStr)-FirstSpacePosition)
                          else
   Result:=Trim(Result);
end;

Function FloatDataFromRow(str:string;Number:word):double;
{вважається, що частини рядка відділені один від одного пробілами;
повертається число, рохташоване в частині з номером Number
(нумерація починається з 1);
якщо там не число - то повертається ErResult}
begin
  try
   Result:=StrToFloat(StringDataFromRow(str,Number));
  except
   Result:=ErResult;
  end;
end;


Function NumberDetermine(Names:array of string;
                          Source:string;
                          var Numbers:TArrInteger):boolean;
{визначення номерів позицій елементів з Names в рядку Source;
якщо хоча б одного елементу немає - результат False}
 var i:integer;
begin
 SetLength(Numbers,High(Names)+1);
 Result:=True;
 for I := Low(Names) to High(Names) do
  begin
  Numbers[i]:=SubstringNumberFromRow(Names[i],Source);
  Result:=Result and  (Numbers[i]<>0);
  end;
end;

function ArrayToString(ArrSingle:TArrSingle):string;overload;
 var i:integer;
begin
  Result:='';
  for I := 0 to High(ArrSingle) do
    Result:=Result+floattostr(ArrSingle[i])+' ';
end;

function ArrayToString(AOS:array of string):string;overload;
 var i:integer;
begin
  Result:='';
  for I := Low(AOS) to High(AOS) do
    Result:=Result+AOS[i]+' ';
end;

function ArrayToString(ArrSingle:TArrSingle;TitelsArr:array of string):string;overload;
 var i:integer;
begin
  Result:='';
  for I := 0 to High(ArrSingle) do
    begin
    if i<=High(TitelsArr) then  Result:=Result+TitelsArr[i]+' =';
    Result:=Result+' '+floattostr(ArrSingle[i])+#10;
    end;
end;

function VecNamesToString(AV:TArrVec):string;
 var i:integer;
begin
 Result:='';
 for I := 0 to High(AV) do
  Result:=Result+AV[i].name+' ';
end;

Procedure ShowArrayOfString(AOS:array of string);
// var temp:string;
//     i:integer;
begin
//  temp:='';
//  for I := Low(AOS) to High(AOS) do
//    temp:=temp+AOS[i]+' ';
  showmessage(ArrayToString(AOS));
end;

Function NewStringByNumbers(Source:string;
                           Numbers:TArrInteger):string;
{створюється новий рядок з тих частин Source, номери яких вказані в Numbers,
частини розділені пробілами, крайній пробіл видалено}
 var i:integer;
begin
  Result:='';
  for I := Low(Numbers) to High(Numbers) do
    Result:=Result+StringDataFromRow(Source,Numbers[i])+' ';
  Result:=TrimRight(Result);
end;

Function NewStringFromStringArray(Source:array of string;
                                 Syffix:string=''):string;
{створюється новий рядок з усіх значень Source,
до кожного елемента дописується Syffix,
елементи розділені пробілами, крайній пробіл видалено}
 var i:integer;
begin
  Result:='';
  for I := Low(Source) to High(Source) do
    Result:=Result+Source[i]+Syffix+' ';
  Result:=TrimRight(Result);
end;

Function DeleteLastDir(LongPath:string):string;
{з довгого шляху LongPath, що закінчується '\',
видаляє останню папку}
begin
  Result:=LongPath;
  SetLength (Result, Length(Result)-1);
  Delete(Result,LastDelimiter('\', Result),Length(Result)-LastDelimiter('\', Result)+1);
  Result:=Result+'\';
end;



Function PointDistance(t:double;Parameters:array of double):double;
 var fi,omega,delta:double;
begin
 fi:=Parameters[3]*Pi/180;
 omega:=2*Pi;
 delta:=Parameters[4]*Pi/180;
 Result:=sqrt(sqr(Parameters[0]+Parameters[2]*cos(fi)*cos(omega*t+delta)-
                  Parameters[1]*cos(fi)*cos(omega*t))+
              sqr(Parameters[2]*sin(fi)*cos(omega*t+delta)-
                  Parameters[1]*sin(fi)*cos(omega*t)));
end;

Function PointDistance2(t:double;Parameters:array of double):double;
begin
 Result:=sqr(PointDistance(t,Parameters));
end;

Function OverlapIntegral(x:double):double;
begin
  Result:=(1+x+sqr(x)/3.0)*exp(-x);
end;

Function OverlapIntegralVibrate(t:double;Parameters:array of double):double;
  var argument:double;
begin
  argument:=PointDistance(t,Parameters)/Parameters[5];
  Result:=OverlapIntegral(argument);
end;

Function OverageValue(Fun:TFun;Parameters:array of double):double;
 begin
  Result:=Int_Trap(Fun,0,1,Parameters,100);
 end;

Procedure DegreeDependence();
  var Param:array of double;
      fi,delta:double;
      Str,str1:TStringList;
      strg,strg1:string;

  Function L_string():string;
    var L_over,L0:double;
   begin
    L_over:=OverageValue(OverlapIntegralVibrate,Param);
    L0:=OverlapIntegral(Param[0]/Param[5]);
    Result:=FloatToStrF((L_over-L0)/L0, ffExponent,4,0);
   end;

  Function r2_string():string;
    var r2_over:double;
   begin
    r2_over:=OverageValue(PointDistance2,Param);
    Result:=FloatToStrF((r2_over-sqr(Param[0]))/sqr(Param[0]), ffExponent,4,0);
   end;
 begin
  SetLength(Param,6);

//  Param[0]:=10e-9;
//  Param[1]:=5e-10;
//  Param[2]:=10e-10;
//  Param[5]:=3.23e-9;
//
//  Str:=TStringList.Create;
//  Str1:=TStringList.Create;
//  Str.Add('delta fi R2');
//  Str1.Add('delta fi L');
//
//  delta:=0;
//  repeat
//   Param[4]:=delta;
//  fi:=0;
//  repeat
//   Param[3]:=fi;
//   Str.Add(FloatToStrF(delta,ffFixed,3,0)+' '+
//           FloatToStrF(fi,ffFixed,3,0)+' '+
//           r2_string());
//   Str1.Add(FloatToStrF(delta,ffFixed,3,0)+' '+
//           FloatToStrF(fi,ffFixed,3,0)+' '+
//           L_string());
//
//   fi:=fi+2;
//  until fi>180;
//   delta:=delta+2;
//  until delta>360;
//
//  Str.SaveToFile('r2.dat');
//  Str.Free;
//  Str1.SaveToFile('L_r.dat');
//  Str1.Free;

//------------------------------------------------------------------

//Parameters[0] - r0 - відстань між точками в рівновазі
//Parameters[1] - A1 - амплітуда коливань першої точки
//Parameters[2] - A2 - амплітуда коливань другої точки
//Parameters[3] - fi - кут між напрямком коливань
//               та прямою, що з'єднує рівноважні положення точок
//Parameters[4] - delta - зсув фаз між коливаннями другої та першої точок

  Param[3]:=30;
  Param[4]:=0;
  Param[5]:=3.23e-9;
//  Param[5]:=3.23e-9;

//  Str:=TStringList.Create;
  Str1:=TStringList.Create;
//  Str.Add('r0 A5A5 A5A10 A3A6 A5A15 A10A10 A5A20 A3A13');
//  Str1.Add('r0 AminusA epsL');
//  Str1.Add('r0 AminusA epsSig');

  Str1.Add('r0 AplusA epsSig');
//  Str1.Add('r0 AplusA epsL');


  Param[0]:=5e-9;
//  Param[1]:=3e-10;
  Param[2]:=0e-10;
  repeat
//    strg1:=FloatToStrF(Param[0],ffExponent,4,0);


   Param[1]:=3e-10;
   repeat
//     Param[2]:=20e-10+Param[1];
//     Param[2]:=20e-10-Param[1];
       strg1:=FloatToStrF(Param[0],ffExponent,4,0);
       strg1:=strg1+' '+FloatToStrF(Param[1]-Param[2],ffExponent,4,0);

////--------------------------------------
//       Param[3]:=0;
//       fi:=0;
//       delta:=0;
//       repeat
////         delta:=delta+(OverageValue(PointDistance2,Param)-sqr(Param[0]))/sqr(Param[0]);
//         delta:=delta+(OverageValue(OverlapIntegralVibrate,Param)-
//                       OverlapIntegral(Param[0]/Param[5]))/OverlapIntegral(Param[0]/Param[5]);
//         fi:=fi+1;
//         Param[3]:=Param[3]+1;
//       until (Param[3]>180.1);
//       strg1:=strg1+' '+FloatToStrF(delta/fi, ffExponent,4,0);
//
////---------------------------------------
//       strg1:=strg1+' '+L_string();
       strg1:=strg1+' '+r2_string();
       Param[1]:=Param[1]+0.5e-10;
       Str1.Add(strg1);

//   until ((Param[1]+Param[2])>40.1e-10);
   until ((Param[1]-Param[2])>40.1e-10);



//   Str1.Add(strg1);
//   Param[2]:=Param[2]+0.05e-10;
//  until (Param[2]>27e-10);
//   Param[0]:=Param[0]+0.5e-9;
   Param[0]:=Param[0]+10e-9;
  until (Param[0]>30.1e-9);

//  Str.SaveToFile('r2fi0del180.dat');
//  Str.Free;
//  Str1.SaveToFile('L.dat');
  Str1.SaveToFile('r2.dat');
  Str1.Free;



//------------------------------------

//  Param[0]:=10e-9;
//  Param[3]:=0;
//  Param[4]:=0;
//  Param[5]:=3.23e-9;
//
//  Str:=TStringList.Create;
//  Str.Add('A1 A2 R2');
//
//  delta:=1e-10;
//  repeat
//   Param[1]:=delta;
//  fi:=1e-10;
//  repeat
//   Param[2]:=fi;
//   r2_over:=OverageValue(PointDistance2,Param);
//   L_over:=OverageValue(OverlapIntegralVibrate,Param);
//   L0:=OverlapIntegral(Param[0]/Param[5]);
//
//   Str.Add(FloatToStrF(delta,ffExponent,4,0)+' '+
//           FloatToStrF(fi,ffExponent,4,0)+' '+
//           FloatToStrF(
//           (r2_over-sqr(Param[0]))/sqr(Param[0]),
//            ffExponent,4,0));
//
//   fi:=fi+5e-11;
//  until fi>20e-10;
//   delta:=delta+5e-11;
//  until delta>20e-10;
//
//  Str.SaveToFile('r2del0.dat');
//  Str.Free;

 end;


Procedure  DelaySleep(mSec:Cardinal);
 Var TargetTime:Cardinal;
Begin
  TargetTime:=GetTickCount+mSec;
  While TargetTime>GetTickCount Do
    begin
        Application.ProcessMessages;
        Sleep(1);
        If Application.Terminated then Exit;
    end;
End;


Procedure  DelayQueryPerformance(mSec:Cardinal);
 var StartValue,EndValue, Freq :Int64;
begin
 QueryPerformanceCounter(StartValue);
 QueryPerformanceFrequency(Freq);
 {кількість відліків лічильника в секунду}
 repeat
   QueryPerformanceCounter(EndValue);
   if (EndValue-StartValue)/Freq>1e-3 then Application.ProcessMessages;
   sin(48.5);
   If Application.Terminated then Exit;
 until ((EndValue-StartValue)/Freq<mSec*1e-3);
end;




Function  ImpulseNoiseSmoothing(const Data:  PTArrSingle): Double;
 var i,i_min,i_max,
     PositivDeviationCount,NegativeDeviationCount:integer;
     Value_min,Value_max,PositivDeviation,Value_Mean:double;
begin

  if High(Data^)<0 then
    begin
      Result:=ErResult;
      Exit;
    end;

  if High(Data^)<4 then
    begin
      Result:=Mean(Data^);
      Exit;
    end;

  i_min:=0;
  i_max:=High(Data^);
  Value_min:=Data^[0];
  Value_max:=Data^[High(Data^)];
  for i := 0 to High(Data^) do
    begin
      if Data^[i]>Value_max then
        begin
          Value_max:=Data^[i];
          i_max:=i;
        end;
      if Data^[i]<Value_min then
        begin
          Value_min:=Data^[i];
          i_min:=i;
        end;
    end;

  Value_Mean:=(Sum(Data^)-Data^[i_min]-Data^[i_max])/(High(Data^)-1);


 PositivDeviationCount:=0;
 NegativeDeviationCount:=0;
 PositivDeviation:=0;
 for i := 0 to High(Data^) do
   if (i<>i_min)and(i<>i_max)
     then
      begin
         if Data^[i]>Value_Mean then
          begin
            inc(PositivDeviationCount);
            PositivDeviation:=PositivDeviation+(Data^[i]-Value_Mean);
          end;
         if Data^[i]<Value_Mean then
            inc(NegativeDeviationCount);
      end;
 Result:=Value_Mean+
        (PositivDeviationCount-NegativeDeviationCount)
        *PositivDeviation/sqr(High(Data^)-1);
end;

Function  ImpulseNoiseSmoothing(const Data:  TVector; ItIsXVector:boolean=False): Double;overload;
 var temp:PTArrSingle;
begin
 if ItIsXVector then temp:=Data.CopyXtoPArray
                else temp:=Data.CopyYtoPArray;
 Result:=ImpulseNoiseSmoothing(temp);
 dispose(temp);
end;

Procedure ImNoiseSmoothedArray(const Source:PTArrSingle;
                               Target:PTArrSingle;
                               Npoint:Word=0);overload;
 var TG:PTArrSingle;
     CountTargetElement,i:integer;
     j:Word;
begin
 SetLength(Target^, 0);
 if High(Source^)<0 then Exit;

 if Npoint=0 then Npoint:=Trunc(sqrt(High(Source^)+1));

 if Npoint=0 then Exit;

 CountTargetElement:=(High(Source^)+1) div Npoint;
 if CountTargetElement=0
 then
  begin
   SetLength(Target^, 1);
   Target^[0]:=ImpulseNoiseSmoothing(Source);
   Exit;
  end;
  SetLength(Target^,CountTargetElement);

  new(TG);
  SetLength(TG^,Npoint);
  for I := 0 to CountTargetElement - 2 do
   begin
     for j := 0 to Npoint - 1
       do TG^[j]:=Source^[I*Npoint+j];
     Target^[I]:=ImpulseNoiseSmoothing(TG);
   end;

  I:=(High(Source^)+1) mod Npoint;
  SetLength(TG^,I+Npoint);
  for j := 0 to Npoint+I-1
  do TG^[j]:=Source^[(CountTargetElement - 1)*Npoint+j];

  Target^[CountTargetElement - 1]:=ImpulseNoiseSmoothing(TG);
  dispose(TG);
end;

Function ImpulseNoiseSmoothingByNpoint(Data:  PTArrSingle;
                                       Npoint:Word=0): Double;
 var temp:PTArrSingle;
begin
 Result:=ErResult;
 if High(Data^)<0 then Exit;

 if Npoint=0 then Npoint:=Trunc(sqrt(High(Data^)+1));

 if Npoint=0 then Exit;

 new(temp);
 ImNoiseSmoothedArray(Data, temp, Npoint);
 if High(temp^)=0 then Result:=temp^[0]
                  else Result:=ImpulseNoiseSmoothingByNpoint(temp,Npoint);
 dispose(temp);
end;

//Function Bisection(const F:TFun; const Parameters:array of double;
//                   const Xmax:double=5; const Xmin:double=0;
//                   const eps:double=1e-6):double;
// const Nit_Max=1e6;
// var a,b,c,Fa,Fc :double;
//     i:integer;
//begin
//  Result:=ErResult;
//  a:=F(Xmin,Parameters);
//  b:=F(Xmax,Parameters);
//  if a=0 then Result:=Xmin;
//  if b=0 then Result:=Xmax;
//
//  if a*b>=0 then Exit;
//
//  Fa:=a;
//  a:=Xmin;
//  b:=Xmax;
//
//  i:=0;
//  try
//    repeat
//     inc(i);
//      c:=(a+b)/2;
//      Fc:=F(c,Parameters);
//      if (Fc*Fa<=0)
//         then b:=c
//         else begin
//              a:=c;
//              Fa:=Fc;
//              end;
//    until (IsEqual(a,b,eps) or (i>Nit_Max));
//    if (i<=Nit_Max) then Result:=c;
//  except
//
//  end;
//end;
//
//Function Bisection(const F:TFunDoubleObj; const Parameters:array of double;
//                   const Xmax:double=5; const Xmin:double=0;
//                   const eps:double=1e-6):double;overload;
// const Nit_Max=1e6;
// var a,b,c,Fa,Fc :double;
//     i:integer;
//begin
//  Result:=ErResult;
//  a:=F(Xmin,Parameters);
//  b:=F(Xmax,Parameters);
//  if a=0 then Result:=Xmin;
//  if b=0 then Result:=Xmax;
//
//  if a*b>=0 then Exit;
//
//  Fa:=a;
//  a:=Xmin;
//  b:=Xmax;
//
//  i:=0;
//  try
//    repeat
//     inc(i);
//      c:=(a+b)/2;
//      Fc:=F(c,Parameters);
//      if (Fc*Fa<=0)
//         then b:=c
//         else begin
//              a:=c;
//              Fa:=Fc;
//              end;
//    until (IsEqual(a,b,eps) or (i>Nit_Max));
//    if (i<=Nit_Max) then Result:=c;
//  except
//
//  end;
//end;
//
//
//Function Hord(const F:TFun; const Parameters:array of double;
//                   const Xmax:double=5; const Xmin:double=0;
//                   const eps:double=1e-6):double;
// const Nit_Max=1e6;
// var a,b,c,c_old,Fa,Fb,Fc :double;
//     i:integer;
//begin
//  Result:=ErResult;
//  Fa:=F(Xmin,Parameters);
//  Fb:=F(Xmax,Parameters);
//  if Fa=0 then Result:=Xmin;
//  if Fb=0 then Result:=Xmax;
//
//  if Fa*Fb>=0 then Exit;
//
//  a:=Xmin;
//  b:=Xmax;
//
//  i:=0;
//  c:=a;
//  try
//    repeat
//     inc(i);
//     c_old:=c;
//     c:=(a*Fb-b*Fa)/(Fb-Fa);
//     Fc:=F(c,Parameters);
//      if (Fc*Fa<=0)
//         then begin
//              b:=c;
//              Fb:=Fc;
//              end
//         else begin
//              a:=c;
//              Fa:=Fc;
//              end;
//    until (IsEqual(c,c_old,eps) or (i>Nit_Max));
//    if (i<=Nit_Max) then Result:=c;
//  except
//
//  end;
//end;
//
//

Function SelectFromVariants(Variants:TStringList;
                            Index:ShortInt;
                            WindowsCaption:string='Select'):ShortInt;
{показує модальне вікно, де вибір радіо-кнопок,
підписаних відповідно до вмісту Variants;
при натиснутій "Ok" повертає
індекс вибраного вваріанту, інакше -1}

var Form:TForm;
    ButOk,ButCancel: TButton;
    RG:TRadioGroup;
    i:integer;
begin
 Result:=-1;

 Form:=TForm.Create(Application);
 Form.Position:=poMainFormCenter;
 Form.AutoScroll:=True;
 Form.BorderIcons:=[biSystemMenu];
 Form.ParentFont:=True;
 Form.Font.Style:=[fsBold];
 Form.Font.Height:=-16;
 Form.Caption:=WindowsCaption;
 Form.Color:=clMoneyGreen;
 RG:=TRadioGroup.Create(Form);
 RG.Parent:=Form;
 RG.Items:=Variants;
 if (Index>=0)and(Index<Variants.Count) then
   RG.ItemIndex:=Index;

 if RG.Items.Count>8 then  RG.Columns:=3
                     else  RG.Columns:=2;
 RG.Width:=RG.Columns*200+20;
 RG.Height:=Ceil(RG.Items.Count/RG.Columns)*50+20;
 Form.Width:=RG.Width;
 Form.Height:=RG.Height+100;
  RG.Align:=alTop;

 ButOk:=TButton.Create(Form);
 ButOk.Parent:=Form;
 ButOk.ParentFont:=True;
 ButOk.Height:=30;
 ButOk.Width:=79;
 ButOk.Caption:='Ok';
 ButOk.ModalResult:=mrOk;
 ButOk.Top:=RG.Height+10;
 ButOk.Left:=round((Form.Width-2*ButOk.Width)/3.0);

 ButCancel:=TButton.Create(Form);
 ButCancel.Parent:=Form;
 ButCancel.ParentFont:=True;
 ButCancel.Height:=30;
 ButCancel.Width:=79;
 ButCancel.Caption:='Cancel';
 ButCancel.ModalResult:=mrCancel;
 ButCancel.Top:=RG.Height+10;
 ButCancel.Left:=2*ButOk.Left+ButOk.Width;

  if Form.ShowModal=mrOk then Result:=RG.ItemIndex;
 for I := Form.ComponentCount-1 downto 0 do
     Form.Components[i].Free;
 Form.Hide;
 Form.Release;
end;

Procedure AccurateCheckBoxCheckedChange(CB:TCheckBox;Value:boolean);
 var Temp:TNotifyEvent;
begin
 temp:=CB.OnClick;
 CB.OnClick:=nil;
 CB.Checked:=Value;
 CB.OnClick:=temp;
end;

Procedure HelpForMe(str:string; filname:string='');
 var ST:TStringList;
begin
 ST:=TStringList.Create;
 ST.Add(str);
 if filname='' then ST.SaveToFile(str+'.dat')
               else ST.SaveToFile(filname+'.dat');
 ST.Free;
end;


Procedure DecimationArray(var Data:  TArrSingle; const N:word);
{у масиві залишається лише 0-й, ?-й, 2N-й.... елементи,
при N=0 масив не міняється}
 var i:integer;
begin
  if (N<=1)or(High(Data)<0) then Exit;
  i:=1;
  while(i*N)<=High(Data) do
   begin
    Data[i]:=Data[i*N];
    inc(i);
   end;
  SetLength(Data,i);
end;


Function GetHDDSerialNumber():LongWord;
Var
_VolumeName,_FileSystemName:array [0..MAX_PATH-1] of Char;
_VolumeSerialNo,_MaxComponentLength,_FileSystemFlags:LongWord;

begin
  if GetVolumeInformation(nil,_VolumeName,MAX_PATH,@_VolumeSerialNo,
         _MaxComponentLength,_FileSystemFlags,_FileSystemName,MAX_PATH)
          then
  begin
    Result:=_VolumeSerialNo;
  end
     else Result:=ErResult;
end;

procedure CreateDirSafety(DirName: string);
begin
  try
    CreateDir(DirName);
  except
     ;
  end;
end;

Function MilliSecond:integer;
 var Hour,Min,Sec,MSec:word;
begin
 DecodeTime(Time,Hour,Min,Sec,MSec);
 Result:=MSec+1000*Sec+60*1000*Min;
end;

function SecondFromDayBegining:integer;
 var Hour,Min,Sec,MSec:word;
begin
 DecodeTime(Time,Hour,Min,Sec,MSec);
 Result:=Sec+60*Min+60*60*Hour;
end;

function SecondFromDayBegining(ttime: TDateTime):integer;
 var Hour,Min,Sec,MSec:word;
begin
 DecodeTime(ttime,Hour,Min,Sec,MSec);
 Result:=Sec+60*Min+60*60*Hour;
end;


procedure InitArray(var OutputData: TArrSingle;NumberOfData:word;
                             InitialValue:double=ErResult);
  var i:word;
begin
 if High(OutputData)<(NumberOfData-1)
      then SetLength(OutputData,NumberOfData);
 for i := 0 to (NumberOfData-1)
    do OutputData[i]:=InitialValue;
end;

procedure InitArray(var OutputData:TArrInteger;NumberOfData:word;
                             InitialValue:integer=0);
  var i:word;
begin
 if High(OutputData)<(NumberOfData-1)
      then SetLength(OutputData,NumberOfData);
 for i := 0 to (NumberOfData-1)
    do OutputData[i]:=InitialValue;
end;

procedure StringArrayToStringList(const Arr:array of string;
                                  StringList:TStringList;
                                  ClearStringList:boolean=True);
 var i:integer;
begin
 if ClearStringList then StringList.Clear;
 for I := Low(Arr) to High(Arr) do StringList.Add(Arr[i]);
end;

Function FileNameToVoltage(name:string):double;
 var i:byte;
     tempstr:string;
begin
 tempstr:='';
 for I := 1 to Length(name) do
  begin
  if (ANSIChar(name[i]) in ['0'..'9']) then tempstr:=tempstr+name[i];
  if (name[i]='m') then tempstr:=tempstr+'-';
  if (name[i]='_') then tempstr:=tempstr+'.';
  end;
 try
  Result:=StrToFloat(tempstr);
  if (ANSIChar(name[1]) in ['0'..'9']) then Result:=Result/10;
 except
  Result:=ErResult;
 end;
end;

procedure AddRowToFileFromStringGrid(FileName:string;
                   StrGridData: TStringGrid;
                   RowNumber:integer);
 var f:TextFile;
     i:integer;
begin

   AssignFile(f,FileName);
  try
   Append (f);
  except
   Rewrite(f);
  end;

   for I := 0 to StrGridData.ColCount-1 do
                    write(f,StrGridData.Cells[i,RowNumber],' ');
   writeln(f);
   CloseFile(f);
end;

procedure  StringGridToFile(FileName:string;
                   StrGridData: TStringGrid);
 var f:TextFile;
     i,j:integer;
begin
  try
   AssignFile(f,FileName);
   Rewrite(f);
   for j := 0 to StrGridData.RowCount-1 do
     begin
     for I := 0 to StrGridData.ColCount-1 do
                           write(f,StrGridData.Cells[i,j],' ');
     writeln(f);
     end;
   CloseFile(f);
  finally

  end;
end;

procedure PictLoadScale(Img: TImage; ResName:String);
{в Img завантажується bmp-картинка з ресурсу з назвою
ResName і масштабується зображення, щоб не вийшо
за межі розмірів Img, які були перед цим}
var
  scaleY: double;
  scaleX: double;
  scale: double;
begin
  try
  Img.Picture.Bitmap.LoadFromResourceName(hInstance,ResName);
  if Img.Picture.Width > Img.Width then
    scaleX := Img.Width / Img.Picture.Width
  else
    scaleX := 1;
  if Img.Picture.Height > Img.Height then
    scaleY := Img.Height / Img.Picture.Height
  else
    scaleY := 1;
  if scaleX < scaleY then
    scale := scaleX
  else
    scale := scaleY;
  Img.Height := Round(Img.Picture.Height * scale);
  Img.Width := Round(Img.Picture.Width * scale);
  finally

  end;
end;


Function FitName(V: TVector; st:string='fit'):string;overload;
begin
  if V.name = '' then
    Result := st+'.dat'
  else
  begin
    Result := V.name;
    Insert(st, Result, Pos('.', Result));
  end;
end;

function NvsRo(Nd:double;param:array of double):double;
{param[0] - Ro
 param[1] - T
}
 begin
  Result:=Nd-1/(Qelem*0.1*param[0]*Silicon.mu_p(param[1],Nd))
 end;

function IntToFrac(i:integer):double;
{ділить модуль і доти, поки не буде число, менше 1,
його і повертає}
begin
 if i=0 then
  begin
    Result:=0;
    Exit;
  end;
 Result:=abs(i)/10.0;
 while (Result>1) do Result:=Result/10;
end;

procedure StringListShow(StrL:TStringList);
 var temp:string;
   i:integer;
begin
 temp:='';
 if StrL.Count>0
   then
     for I := 0 to StrL.Count-1 do
       temp:=temp+ StrL[i]+#10
   else
    temp:='is empty';
 showmessage(temp);
end;

end.
