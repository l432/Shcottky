unit OlegFunction;

interface

uses ComCtrls, Spin, StdCtrls, Series, Forms, Controls, IniFiles, OlegType,
 Dialogs, OlegMath, StrUtils;

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

Procedure ElementsFromForm(Form:TForm);
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

procedure IVC(Func:TFunDouble;
              T:double;
              ResultFileName:string='';
              Vmin:double=0.01;
              Vmax:double=0.6;
              delV:double=0.01);
{розраховується ВАХ за законом I=Func(T,V)
і записується у файл ResultFileName}

Function SomeSpaceToOne(str:string):string;
{замінює декілька пробілів на один}

Function Acronym(str:string):string;
{створюється аббревіатура рядка}

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


implementation

uses
  SysUtils, Classes, Windows;

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


Procedure ElementsFromForm(Form:TForm);
var i:integer;
begin
   for I := Form.ComponentCount-1 downto 0 do
     Form.Components[i].Free;
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

procedure IVC(Func:TFunDouble;
              T:double;
              ResultFileName:string='';
              Vmin:double=0.01;
              Vmax:double=0.6;
              delV:double=0.01);
 Var V:double;
     Vax:PVector;
begin
 new(Vax);
 Vax^.Clear;
 V:=Vmin;
 repeat
   Vax^.Add(V,Func(T,V));
   V:=V+delV;
//  showmessage(floattostr(V));
 until (V>Vmax);
 if ResultFileName<>'' then Vax^.Write_File(ResultFileName);
 dispose(Vax);
end;

Function SomeSpaceToOne(str:string):string;
begin
  Result:=str;
  Result:=AnsiReplaceStr(Result,#9,' ');
  while AnsiContainsStr(Result,'  ') do
     Result:=AnsiReplaceStr(Result,'  ',' ');
end;

Function Acronym(str:string):string;
begin
  Result:='';
  if AnsiEndsStr(' ',str) then Delete(str, Length(str), 1);
  if AnsiStartsStr(' ',str) then Delete(str, 1, 1);
  if Length(str)<1 then Exit;
  Result:=str[1];
  while AnsiContainsStr(str,' ') do
    begin
    str:=Copy(str, AnsiPos (' ',str)+1, Length(str)-AnsiPos (' ',str));
    Result:=Result+str[1];
    end;
  Result:=AnsiUpperCase(Result);  
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
      fi,delta{,r2_over,L_over,L0}:double;
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


end.
