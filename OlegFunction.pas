unit OlegFunction;

interface

uses ComCtrls, Spin, StdCtrls, Series, Forms, Controls, IniFiles, OlegType;

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


Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                     Value:double);overload;
{������ � .ini-���� �������� ����� ���� ���� �� ������� ErResult}

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:integer);overload;
{������ � .ini-���� �������� ����� ���� ���� �� ������� ErResult}

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:Boolean);overload;
{������ � .ini-���� �������� ����� ���� ���� ������� True}


implementation

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

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:double);
{������ � .ini-���� �������� ����� ���� ���� �� ������� ErResult}
begin
 if (Value<>ErResult) then ConfigFile.WriteFloat(Section,Ident,Value);
end;

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:integer);
{������ � .ini-���� �������� ����� ���� ���� �� ������� ErResult}
begin
 if (Value<>ErResult) then ConfigFile.WriteInteger(Section,Ident,Value);
end;

Procedure WriteIniDef(ConfigFile:TIniFile;const Section, Ident: string;
                      Value:Boolean);
{������ � .ini-���� �������� ����� ���� ���� �� ������� ErResult}
begin
 if Value then ConfigFile.WriteBool(Section,Ident,Value);
end;

end.
