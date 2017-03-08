unit OlegFunction;

interface

uses ComCtrls, Spin, StdCtrls, Series, Forms, Controls, IniFiles, OlegType, Dialogs, OlegMath, StrUtils;

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

Function TwoSpaceToOne(str:string):string;

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


implementation

uses
  SysUtils, Classes;

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

Function TwoSpaceToOne(str:string):string;
begin
  Result:=str;
  Result:=AnsiReplaceStr(Result,#9,' ');
  while AnsiContainsStr(Result,'  ') do
     Result:=AnsiReplaceStr(Result,'  ',' ');
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
  Result:=(1+x+sqr(x)/3)*exp(-x);
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
 begin
  SetLength(Param,6);
  Param[0]:=30e-9;
  Param[1]:=5e-10;
  Param[2]:=1e-9;
  Param[5]:=3.23e-9;


  Str:=TStringList.Create;
  Str1:=TStringList.Create;
  Str.Add('delta fi R2');
  Str1.Add('delta fi L');

  delta:=0;
  repeat
   Param[4]:=delta;
  fi:=0;
  repeat
   Param[3]:=fi;
   Str.Add(FloatToStrF(delta,ffFixed,3,0)+' '+
           FloatToStrF(fi,ffFixed,3,0)+' '+
           FloatToStrF(OverageValue(PointDistance2,Param)/sqr(Param[0]),ffExponent,4,0));
   Str1.Add(FloatToStrF(delta,ffFixed,3,0)+' '+
           FloatToStrF(fi,ffFixed,3,0)+' '+
           FloatToStrF(OverageValue(OverlapIntegralVibrate,Param)/OverlapIntegral(Param[0]/Param[5]),ffExponent,4,0));

   fi:=fi+2;
  until fi>180;
   delta:=delta+2;
  until delta>360;

  Str.SaveToFile('r2.dat');
  Str.Free;
  Str1.SaveToFile('L_r.dat');
  Str1.Free;

 end;



end.
