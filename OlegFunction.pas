unit OlegFunction;

interface

uses ComCtrls, Spin, StdCtrls, Series, Forms, Controls, IniFiles, OlegType, Dialogs;

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


implementation

uses
  SysUtils;

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
 until (V>Vmax);
 if ResultFileName<>'' then Vax^.Write_File(ResultFileName);
 dispose(Vax);
end;

end.
