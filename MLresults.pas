unit MLresults;
{щось, що використовувалося для обробки
результатів отриманих при машинному навчанні}

interface

type TDescriptors=(aFe,aB,aT,aD);

const
   ParametersNames:array[TDescriptors]of string=
       ('N_Fe','N_B','T','d');

   LimitErrorNumber = 3;
   LimitErrorValues:array[0..LimitErrorNumber]of double=
       (0.01,0.1,1,10);
   HeaderErrorPercent=' P001 P01 P1 P10';

   FileEstimateName='estimateNew.txt';

   MeanResultAll=11.999996343232;
   StdResultAll=1.20185081298897;

   MeanFull=12.0078188950927;
   StdFull=1.1935833450372;


procedure MLresultsTransform(FileName:string);
{вхідний файл має містити колонки
Ytrue Nb T d Ypred RSE
На виході отримуємо 4 файли, в яких перша колонка значення параметру
(концентрація заліза, або концентрація бору, або температура, або товщина)
а решта чотири - частка передбачень при даному значенні, для яких похибка менша
величин з LimitErrorValues (1%, 10%, 100%, 1000%)}

procedure MLresultsEstimate(FileName:string);
{вхідний файл має містити колонки
Ytrue та Ypred,
в результаті в FileEstimateName будуть додані дані
'name MSE R2 MAPE MedAPE p01 p10'
де MedAPE - медіанне значення відносної похибки,
р01 - частка передбачень, для яких помилка не перевищує 1%
р10 - частка передбачень, для яких помилка не перевищує 10%;
Крім того, створюється файл FileName+'est',
який містить залежність частки передбачень, які мають похибку не більшу за певне
значення, від величини цього значення}

implementation

uses
  Vcl.Dialogs, System.Classes, OlegFunction, System.SysUtils, OlegVector,
  OlegVectorManipulation;

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

procedure MLresultsEstimate(FileName:string);
 var VecTr,VecTr2:TVectorTransform;
     FileEstimatePath,ShotFileName,tempStr:string;
     ErrorValue:double;
     i:integer;
begin
 FileEstimatePath:=ExtractFilePath(FileName)+FileEstimateName;
 ShotFileName:=ExtractFileName(FileName);
 ShotFileName:=copy(ShotFileName,1,length(ShotFileName)-4);
 if not(FileExists(FileEstimatePath))
//   then  AddRowToFile('name MSE MRE R R2',FileEstimatePath);
   then  AddRowToFile('name MSE R2 MAPE MedAPE p01 p10',FileEstimatePath);

 VecTr:=TVectorTransform.Create;
 VecTr2:=TVectorTransform.Create;
 VecTr.ReadFromFile(FileName,['Ytrue','Ypred']);
 if Pos('Full',ShotFileName)>0
   then
    VecTr.StandartScaler(VecTr2,MeanFull,StdFull,True)
   else
    VecTr.StandartScaler(VecTr2,MeanResultAll,StdResultAll,True);
 tempstr:=ShotFileName;
// tempstr:=tempstr+' '+floattostr(VecTr2.MSE);
 tempstr:=tempstr+' '+floattostrf(VecTr2.MSE*1000,ffFixed,4,2);
// tempstr:=tempstr+' '+floattostr(VecTr.MRE);
 tempstr:=tempstr+' '+floattostrf(VecTr.R2determination,ffFixed,5,5);
 tempstr:=tempstr+' '+floattostrf(VecTr.MRE*100,ffGeneral,4,2);
// tempstr:=tempstr+' '+floattostr(VecTr.Rcorrelation);
// tempstr:=tempstr+' '+floattostr(VecTr.R2determination);

 VecTr.REdata(VecTr2);
 VecTr.Clear;

 ErrorValue:=0;
 repeat
  for i := 0 to LimitErrorNumber do
    if ErrorValue<LimitErrorValues[i]
        then
         begin
          ErrorValue:=ErrorValue+LimitErrorValues[i]/10;
          Break
         end;
  VecTr.Add(ErrorValue,VecTr2.PercentOfPointLessThan(ErrorValue));
 until (ErrorValue>=LimitErrorValues[High(LimitErrorValues)]);

 tempstr:=tempstr+' '+floattostrf(VecTr2.MedianProperty*100,ffGeneral,4,2);
 tempstr:=tempstr+' '+floattostrf(VecTr2.PercentOfPointLessThan(0.01),ffGeneral,4,2);
 tempstr:=tempstr+' '+floattostrf(VecTr2.PercentOfPointLessThan(0.1),ffGeneral,4,4);
 VecTr.WriteToFile(FitName(FileName,'est'),8);

 AddRowToFile(tempstr,FileEstimatePath);

 FreeAndNil(VecTr2);
 FreeAndNil(VecTr);
end;

end.
