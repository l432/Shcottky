unit porousSi;

interface

procedure FirsTPorSi(FileName:string='J0Jt.1.dat');

implementation

uses
  System.Classes, System.SysUtils, Vcl.Dialogs, OlegVector,
  OlegVectorManipulation, OlegFunction;

procedure FirsTPorSi(FileName:string='J0Jt.1.dat');
 var SL:TStringList;
     i,ColumnNumber,Temperature:integer;
     Vec10,Vec100,VecTemp:TVector;
     Vec,VecIntegral:TVectorTransform;
begin
 SL:=TStringList.Create;
 SL.LoadFromFile(FileName);
 Vec:=TVectorTransform.Create;
 VecIntegral:=TVectorTransform.Create;
 Vec10:=TVector.Create;
 Vec100:=TVector.Create;
 VecTemp:=TVector.Create;
// showmessage(SL[4]);
// ColumnNumber:=5;
 Temperature:=300;

 for ColumnNumber := 4 to 6 do
 begin
   Vec.Clear;
   VecIntegral.Clear;
   for I := 4 to SL.Count-1 do
    begin
      Vec.Add(FloatDataFromRow(SL[i],2),FloatDataFromRow(SL[i],ColumnNumber));
      if Vec.HighNumber>2 then VecIntegral.Add(Vec.X[Vec.HighNumber],Vec.Int_Trap/Temperature);

    end;

   Vec.WriteToFile(inttostr(ColumnNumber-3)+'.dat',6);
   VecIntegral.WriteToFile(inttostr(ColumnNumber-3)+'int.dat',8);

   Vec.ImNoiseSmoothedArray(Vec10,10);
   Vec.ImNoiseSmoothedArray(Vec100,100);
   VecTemp.Clear;
   VecIntegral.Clear;
   VecTemp.Add(Vec[0]);
   VecTemp.Add(Vec[1]);
   VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap/Temperature);

   for I := 0 to 2 do
     begin
      VecTemp.Add(Vec10[i]);
      VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap/Temperature);
     end;

   for I := 0 to Vec100.HighNumber do
     begin
      VecTemp.Add(Vec100[i]);
      VecIntegral.Add(VecTemp.X[VecTemp.HighNumber],VecTemp.Int_Trap/Temperature);
     end;

   VecTemp.WriteToFile(inttostr(ColumnNumber-3)+'sm.dat',6);
   VecIntegral.WriteToFile(inttostr(ColumnNumber-3)+'sm_int.dat',8);

 end;

 FreeAndNil(VecTemp);
 FreeAndNil(Vec100);
 FreeAndNil(Vec10);
 FreeAndNil(Vec);
 FreeAndNil(VecIntegral);
 FreeAndNil(SL);
end;


end.
