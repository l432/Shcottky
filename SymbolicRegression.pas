unit SymbolicRegression;

interface

procedure DeepOfAbsorbtion(T:integer;FileName:string='SiAbsorb');
{записує у файл FileNameT.dat залежність
величини, оберноної до коеф. поглинання світла у кремнії
при температурі T, від довжини хвилі}

Procedure TauIntrinsic();
{розрахунок власного часу життя
(лише міжзонна та оже рекомбінації) в р-кремнії
для температурного діапазону 280-350 К
та діапазону рівнів легування 10^14 - 10^16 см^-3  }

implementation

uses
  OlegVector, System.SysUtils, OlegMaterialSamples, OlegType, System.Math,
  System.Classes;

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

end.
