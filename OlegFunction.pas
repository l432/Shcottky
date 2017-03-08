unit OlegFunction;

interface

uses ComCtrls, Spin, StdCtrls, Series, Forms, Controls, IniFiles, OlegType, Dialogs, OlegMath, StrUtils;

Procedure ToTrack (Num:double;Track:TTrackbar; Spin:TSpinEdit; CBox:TCheckBox);
{�������������� �������� Spin �� ������� Track �������� ��
������� �� �������� ����� Num;
���� ����� ��������� - �������������� ��������� ����;
������, ��� ������� ���� Track �� 1 �� 1000}

Function ToNumber (Track:TTrackbar; Spin:TSpinEdit; CBox:TCheckBox):double;
{���������� ��, �� ����������� �� ��������� �����������
� ����� - ��������� ���. ��������� ToTrack}

Procedure GraphSum (Lines: array of TLineSeries);
{� �������� ������� ������ ������� ���� �������,
�� ����������� � �����;
�������������, �� � ��� ��� ����� �������
����� �� �� ������� �������}

Procedure ElementsFromForm(Form:TForm);
{������ �� �������� � �����}


Procedure CompEnable(Fm:TForm;Tag:integer;State:boolean);
{��� ��� ��������, �� ����������� �� ���� Fm �� ����� ��� Tag,
���������� Enable �������������� �������� State}

procedure StrToNumber(St:TCaption; Def:double; var Num:double);
{��������� ����������� ��������� ����� St � ��������
�������� Num;
���� ������ ����� ������� - ����� �� ��������,
���� �������� �������� � ��������� �������;
���� ����� ������� - Num  ���� ��������
�������� Def}

procedure IVC(Func:TFunDouble;
              T:double;
              ResultFileName:string='';
              Vmin:double=0.01;
              Vmax:double=0.6;
              delV:double=0.01);
{������������� ��� �� ������� I=Func(T,V)
� ���������� � ���� ResultFileName}

Function TwoSpaceToOne(str:string):string;

//-----���������������� ��� ���������� DAP-----------
Function PointDistance(t:double;Parameters:array of double):double;
{�������, �� ����� �������, �� ����������� � ��������� ��������
�� ������ ���������� � ������ ���� t
(���������� t - ������ ������, ��� ���������� �� �����,[t]=1)
Parameters[0] - r0 - ������� �� ������� � �������
Parameters[1] - A1 - �������� �������� ����� �����
Parameters[2] - A2 - �������� �������� ����� �����
Parameters[3] - fi - ��� �� ��������� ��������
               �� ������, �� �'���� �������� ��������� �����
Parameters[4] - delta - ���� ��� �� ����������� ����� �� ����� �����
[fi]=[delta]=degree
}

Function PointDistance2(t:double;Parameters:array of double):double;
{������� ������ - ���. ���������}

Function OverlapIntegral(x:double):double;
{������� L(x)=[1+x+1/3*x^2]*exp(-x)}

Function OverlapIntegralVibrate(t:double;Parameters:array of double):double;
{������� ��������  OverlapIntegral(r/a0) �
������ ���� t;
r ��������� PointDistance(t);
a0=Parameters[5]}

Function OverageValue(Fun:TFun;Parameters:array of double):double;

Procedure DegreeDependence();
//-----END---���������������� ��� ���������� DAP-----------

//Procedure VocFF_Dependence();


implementation

uses
  SysUtils, Classes;

Procedure ToTrack (Num:double;Track:TTrackbar; Spin:TSpinEdit; CBox:TCheckBox);
{�������������� �������� Spin �� ������� Track �������� ��
������� �� �������� ����� Num;
���� ����� ��������� - �������������� ��������� ����;
������, ��� ������� ���� Track �� 1 �� 1000}
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
{���������� ��, �� ����������� �� ��������� �����������
� ����� - ��������� ���. ��������� ToTrack}
var i:integer;
begin
  Result:=Track.Position/100;
  for i := 1 to abs(Spin.Value) do
   if Spin.Value>0 then Result:=Result*10
                   else Result:=Result/10;
if CBox.Checked then Result:=-1*Result;

end;

Procedure GraphSum (Lines: array of TLineSeries);
{� �������� ������� ������ ������� ���� �������,
�� ����������� � �����;
�������������, �� � ��� ��� ����� �������
����� �� �� ������� �������}
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
{��� ��� ��������, �� ����������� �� ���� Fm �� ����� ��� Tag,
���������� Enable �������������� �������� State}
var i:integer;
begin
for I := 0 to Fm.ComponentCount-1 do
  if (Fm.Components[i].Tag=Tag)and(Fm.Components[i] is TControl)
     then (Fm.Components[i] as TControl).Enabled:=State;
end;

procedure StrToNumber(St:TCaption; Def:double; var Num:double);
{��������� ����������� ��������� ����� St � ��������
�������� Num;
���� ������ ����� ������� - ����� �� ��������,
���� �������� �������� � ��������� �������;
���� ����� ������� - Num  ���� ��������
�������� Def}
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
