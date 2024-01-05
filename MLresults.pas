unit MLresults;
{����, �� ����������������� ��� �������
���������� ��������� ��� ��������� ��������}

interface

type TDescriptors=(aFe,aB,aT,aD);

const
   ParametersNames:array[TDescriptors]of string=
       ('N_Fe','N_B','T','d');

   LimitErrorNumber = 3;
   LimitErrorValues:array[0..LimitErrorNumber]of double=
       (0.01,0.1,1,10);
   HeaderErrorPercent=' P001 P01 P1 P10';

procedure MLresultsTransform(FileName:string);

implementation

uses
  Vcl.Dialogs, System.Classes, OlegFunction, System.SysUtils, OlegVector;

procedure MLresultsTransform(FileName:string);
 var  SLstart:TStringList;
      SLfinish:TStringList;
      i,j:integer;
      valstr,tempstr:string;
      descript:TDescriptors;
      ArrVec:TArrVec;
      DataVector:TVector;

begin
 SLstart:=TStringList.Create;
 SLfinish:=TStringList.Create;
 DataVector:=TVector.Create;
 for descript := Low(TDescriptors) to High(TDescriptors) do
 begin
  SLstart.Clear;
  SLstart.LoadFromFile(FileName);
  SLfinish.Clear;
  SLfinish.Add(ParametersNames[descript]+HeaderErrorPercent);
  VectorArrayFreeAndNil(ArrVec);
  DataVector.Clear;
  while SLstart.Count>1 do
   begin
    i:=1;
    AddVectorToArray(ArrVec);
    repeat
     if ArrVec[High(ArrVec)].Count<1 then valstr:=StringDataFromRow(SLstart[1],ord(descript)+1);
     if valstr=StringDataFromRow(SLstart[i],ord(descript)+1) then
       begin
        ArrVec[High(ArrVec)].Add(ArrVec[High(ArrVec)].Count,
        abs(FloatDataFromRow(SLstart[i],1)-FloatDataFromRow(SLstart[i],5))
                     /FloatDataFromRow(SLstart[i],1));
        SLstart.Delete(i);
       end                                             else
       i:=i+1;
    until (i>=SLstart.Count);
    DataVector.Add(StrToFloat(valstr),High(ArrVec));
   end;
  DataVector.Sorting();

  for I := 0 to DataVector.HighNumber do
    begin
     tempstr:=floattostr(DataVector.X[i]);
     for j := 0 to LimitErrorNumber do
      tempstr:=tempstr+' '
        +floattostr(ArrVec[round(DataVector.Y[i])].PercentOfPointLessThan(LimitErrorValues[j]));
     SLfinish.Add(tempstr);
    end;

   SLfinish.SaveToFile(FitName(FileName,ParametersNames[descript]));
 end;
 FreeAndNil(DataVector);
 FreeAndNil(SLfinish);
 FreeAndNil(SLstart);

end;

end.
