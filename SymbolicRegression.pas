unit SymbolicRegression;

interface

const
 C_J0=17.90;

procedure DeepOfAbsorbtion(T:integer;FileName:string='SiAbsorb');
{������ � ���� FileNameT.dat ���������
��������, �������� �� ����. ���������� ����� � �����
��� ���������� T, �� ������� ����}

Procedure TauIntrinsic();
{���������� �������� ���� �����
(���� ������� �� ��� �����������) � �-�����
��� �������������� �������� 280-350 �
�� �������� ���� ��������� 10^14 - 10^16 ��^-3  }


procedure TauOnL(T:integer;Ndop:double);
{������������ �� Ln (�� 1 ��� �� 300 ���)
�� ����� ����� ��������� � p-Si }

procedure Ln_Isc();
{����������� ������������ �� �������� ���� ��� ���������
������� ����糿 (����� �������) �� ������ ��������� ���������,
��������� �� ������������ ����� �� (1-R)
(���� �������� �������� �������),
L � ������� 5..300 ���,
������� ���� 940 ��,
����������� 300 �}

procedure Eg_T();
{��������� ������ ���������� ���� �� �����������
��� ������ �� �������� �����
������� ���� ���������� - 100 - 500 �}

function J0(const T:double):double;
{������� ����� ��������� ����� ���
J0 = C*T^3*exp(-Eg/kT)
��� ������,
Eg �� �������� Passler,
�=C_J0=17.90 mA cm^-2 K^-3 (SolarEnerMatSC_101_p36)
������� ���� ���������� - 100 - 500 �
[J0]= mA cm^-2
}

procedure J0_T();
{��������� ������ ��������� ����� �������� ���
�� ����������� - ���. ��������� �������}


implementation

uses
  OlegVector, System.SysUtils, OlegMaterialSamples, OlegType, System.Math,
  System.Classes, OApproxFunction2;

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

Procedure TauIntrinsic();
 var SL:TStringList;
     T,Ndop,delT,delNdop,T0,Tk,Ndop0,Ndopk:double;
begin
 T0:=280;
 Tk:=350;
 Ndop0:=1e20;
 Ndopk:=1e22;
 delT:=5;
 delNdop:=(Log10(Ndopk)-Log10(Ndop0))/10;
// T:=T0;
 Ndop:=Ndop0;
 SL:=TStringList.Create;
 SL.Add('N_A T tau');
 repeat
  T:=T0;
  repeat
   SL.Add(floattostr(Log10(Ndop))+' '
          +inttostr(round(T))+' '
          +floattostr(TMaterial.TauMatthiessenRule([
                         Silicon.TAUbtb(Ndop,0,T),
                         Silicon.TAUager_p(Ndop,T)])));
   T:=T+delT;
  until (T>Tk);

  Ndop:=Power(10,Log10(Ndop)+delNdop);
 until (Ndop>Ndopk*1.01);

 SL.SaveToFile('Tau_i.dat');
 FreeAndNil(SL);
end;


procedure TauOnL(T:integer;Ndop:double);
 var
     Vec:TVector;
     L:integer;
     temp:string;
begin
 Vec:=TVector.Create;
 L:=1;
 temp:=FloatToStrF(Ndop,ffFixed,4,2);
 temp:= StringReplace(temp, '.', 'p',[rfReplaceAll, rfIgnoreCase]);
 repeat
  Vec.Add(L,sqr(L*1e-6)/Kb/T/Silicon.mu_n(T,Ndop*1e6,False));
  inc(L);
 until (L>300);
 Vec.WriteToFile('TauOnL'+inttostr(T)+'Na'+temp+'.dat',6,'L(mkm) Tau(s)');
 FreeAndNil(Vec);
end;

procedure Ln_Isc();
{����������� ������������ �� �������� ���� ��� ���������
������� ����糿 (����� �������) �� ������ ��������� ���������,
��������� �� ������������ ����� �� (1-R)
(���� �������� �������� �������),
L � ������� 5..300 ���,
������� ���� 940 ��,
����������� 300 �}
 var
     Vec:TVector;
     Lambda,T,L,TrainNumber,TestNumber:integer;
     LUsed: TArrInteger;
begin
 Vec:=TVector.Create;
 Lambda:=940;
 T:=300;
 Randomize();
 TrainNumber:=150;
 TestNumber:=30;

 repeat
  L:=5+Random(296);
  if IsNumberInArray(L,LUsed)
    then Continue
    else
     begin
      AddNumberToArray(L,LUsed);
      Vec.Add(L*1e-6,TFFIsc_shablon.Nph(Lambda)
                     *TFFIsc_shablon.Al_L(Silicon.Absorption(Lambda,T),L*1e-6));
     end;
 until (Vec.Count>=TrainNumber);
 Vec.WriteToFile('LOnIsctrain.dat',6,'L(mkm) Isc(A)');

 Vec.Clear;
 repeat
  L:=5+Random(296);
  if IsNumberInArray(L,LUsed)
    then Continue
    else
     begin
      AddNumberToArray(L,LUsed);
      Vec.Add(L*1e-6,TFFIsc_shablon.Nph(Lambda)
                     *TFFIsc_shablon.Al_L(Silicon.Absorption(Lambda,T),L*1e-6));
     end;
 until (Vec.Count>=TestNumber);
 Vec.WriteToFile('LOnIsctest.dat',6,'L(mkm) Isc(A)');


 FreeAndNil(Vec);
end;


procedure Eg_T();
{��������� ������ ���������� ���� �� �����������
��� ������ �� �������� �����
������� ���� ���������� - 100 - 500 �}
 var
     Vec:TVector;
     T,TrainNumber,TestNumber:integer;
     TUsed: TArrInteger;
     Sil:TMaterial;
begin
 Vec:=TVector.Create;
 Sil:=TMaterial.Create(Si);

 Randomize();
 TrainNumber:=300;
 TestNumber:=50;

 repeat
  T:=100+Random(401);
  if IsNumberInArray(T,TUsed)
    then Continue
    else
     begin
      AddNumberToArray(T,TUsed);
      Vec.Add(T,Sil.EgT(T));
     end;
 until (Vec.Count>=TrainNumber);
 Vec.WriteToFile('EgOnTtrain.dat',6,'T(K) Eg(eV)');

 Vec.Clear;
 repeat
  T:=100+Random(401);
  if IsNumberInArray(T,TUsed)
    then Continue
    else
     begin
      AddNumberToArray(T,TUsed);
      Vec.Add(T,Sil.EgT(T));
     end;
 until (Vec.Count>=TestNumber);
 Vec.WriteToFile('EgOnTtest.dat',6,'T(K) Eg(eV)');

 FreeAndNil(Sil);
 FreeAndNil(Vec);
end;

function J0(const T:double):double;
begin
  Result:=C_J0*Power(T,3)*Silicon.Eg(T);
end;

procedure J0_T();
{��������� ������ ��������� ����� �������� ���
�� ����������� - ���. ��������� �������}
 var
     Vec:TVector;
     T,TrainNumber,TestNumber:integer;
     TUsed: TArrInteger;
begin
// Vec:=TVector.Create;
//
// Randomize();
// TrainNumber:=300;
// TestNumber:=50;
//
// repeat
//  T:=100+Random(401);
//  if IsNumberInArray(T,TUsed)
//    then Continue
//    else
//     begin
//      AddNumberToArray(T,TUsed);
//      Vec.Add(T,J0(T));
//     end;
// until (Vec.Count>=TrainNumber);
// Vec.WriteToFile('J0OnTtrain.dat',6,'T(K) J0(mAcm-2)');
//
// Vec.Clear;
// repeat
//  T:=100+Random(401);
//  if IsNumberInArray(T,TUsed)
//    then Continue
//    else
//     begin
//      AddNumberToArray(T,TUsed);
//      Vec.Add(T,Sil.EgT(T));
//     end;
// until (Vec.Count>=TestNumber);
// Vec.WriteToFile('EgOnTtest.dat',6,'T(K) Eg(eV)');
//
// FreeAndNil(Sil);
// FreeAndNil(Vec);
end;

end.
