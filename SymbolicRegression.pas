unit SymbolicRegression;

interface

procedure DeepOfAbsorbtion(T:integer;FileName:string='SiAbsorb');
{������ � ���� FileNameT.dat ���������
��������, �������� �� ����. ���������� ����� � �����
��� ���������� T, �� ������� ����}

implementation

uses
  OlegVector, System.SysUtils, OlegMaterialSamples, OlegType, System.Math;

procedure DeepOfAbsorbtion(T:integer;FileName:string='SiAbsorb');
 var i:integer;
     Vec:TVector;
     L_max:integer;
begin
 Vec:=TVector.Create;
 L_max:=floor(Hpl*2*Pi*Clight/Silicon.Eg(T)/Qelem*1e9);
 for i:=250 to  L_max do
  Vec.Add(i,1/Silicon.Absorption(i,T));
 Vec.WriteToFile(FileName+inttostr(T)+'.dat',6,'Lambda AbsInverse');
 FreeAndNil(Vec);
end;

end.
