unit Castro;
 {функції, пов'язані зі статистичною
обробкою дво-діодної зустрічної моделі}

interface

uses
  OlegVector, OlegType, OApproxCaption, FitSimple, OApproxNew, System.Classes,
  OlegVectorManipulation;

const
 Npar=9;
 I001=2e-3;
 I01Ea=0.15;
 I01const=1.5e-5;
 I002=5e2;
 I02Ea=0.40;
 n1A=7;
 n2T0=500;
 Rsh1const=1e4;
 Rsh20=9e-3;
 Rsh2Ea=0.32;
 Iph0=1e-3;
 TC_Iph=1e-3;
 Rs0=50;
 TC_Rs=0.02;
 Tbegin=260;
 Tend=350;

 Nrep=51;
// Nrep=1;

 TimeOfFiting:array[TEvolutionTypeNew]of double=
  (42,
   22,
   93,
   20.2,
   48,
   56.1,
   15,
   13.8,
   19,
   37,
   6.5,
   10.6,
   16.6,
   1.4
  );

 Niter:array[TEvolutionTypeNew]of integer=
    (8000, //differential evolution
     3000, // EBLSHADE
     12000,//DE with the Lagrange interpolation argument
     5000,// DE with  with neighborhood-based adaptive mechanism
     8000, // modified artificial bee colony
     5000,  //teaching learning based optimization algorithm
     6000,//generalized oppositional  TLBO
     13000,//Simplified TLBO
     4000,    // particle swarm optimization
     30000, //improved JAVA
     5000,   //improved sine cosine algorithm
     5000,  //Neural network  algorithm
     3000,  // Chaotic Whale Optimization Algorithm
     3000// Water wave optimization
     );


  VS='_versus_';
  NNposthocNumber=3;
  NNposthocNames:array[0..NNposthocNumber-1]of string=
   ('Nemenyi', 'Holm', 'Shaffer');

  N1TestNumber=3;
  N1posthocNumber=4;
  N1posthocNames:array[0..N1posthocNumber-1]of string=
   ('Finner', 'Holm', 'Hochberg', 'Holland');

  N1testNames:array[0..N1TestNumber-1]of string=
   ('Friedman','FriedmanAligned','Quade');
//type
// TVecEvol=array[TEvolutionTypeNew] of TVector;

 Procedure CreateVecEvol(var VecEvol:TArrVec);
 Procedure FreeVecEvol(var VecEvol:TArrVec);

Function CasI01(const T:double):double;
Function CasI02(const T:double):double;
Function Casn1(const T:double):double;
Function Casn2(const T:double):double;
Function CasRsh1(const T:double):double;
Function CasRsh2(const T:double):double;
Function CasIph(const T:double):double;
Function CasRs(const T:double):double;

Procedure CasParDetermination(const T:double;
                              var Parameters:TArrSingle);

Function CastroIVdod(I:double;Parameters:array of double):double;
{використовується при обчисленні функції Кастро при певному значенні напруги,
а не струму
Parameters[9] - V (ота сама напруга)}

Function CastroIV_onV(V:double;Parameters:array of double;
                     const Imax:double=1; const Imin:double=0;
                     const eps:double=1e-6):double;
{розрахунок струму відповідно до моделі Кастро при певному значенні напруги,
використовується метод ділення навпіл,
Imax, Imin - інтервал для пошуку}

//Function Bisection(const F:TFun; const Parameters:array of double;
//                   const Xmax:double=5; const Xmin:double=0;
//                   const eps:double=1e-6

Procedure CastroIV_Creation(Vec:TVector;Parameters:array of double;
                           const Vmax:double=1;
                           const stepV:double=0.01;
                           const eps:double=1e-6);
{створюється ВАХ за формулою Кастро у вже існуючому Vec
від 0 до Vmax з кроком stepV}

procedure CastroFitting(EvolType:TEvolutionTypeNew;
                        Parameters:TArrSingle;
                        Vec:TVectorTransform);overload;

procedure CastroFittingIdeal(EvolType:TEvolutionTypeNew;
                        Parameters:TArrSingle);

procedure CastroFitting(EvolType:TEvolutionTypeNew;
                        Parameters:TArrSingle);overload;

function StatTitle(ParamNames:TArrStr;ForMedianValue:boolean=True):string;
function ResultAllTitle(ParamNames:TArrStr):string;

function StatString(RezVec:array of TVectorTransform;Parameters:TArrSingle):string;
function StatStringIdeal(RezVec:TArrVec;Parameters:TArrSingle):string;

function ResultAllString(FitFunction:TFFSimple;Parameters:TArrSingle):string;
//function ResultAllStrings2(RezVec:array of TVectorTransform;Parameters:TArrSingle):string;

procedure SafeLoad(SL:TStringList; FileName,Title:string);

procedure pssAfiting();

procedure Idealfiting();

procedure Test1NResultRebuilding();

procedure TestNNResultRebuilding(FileName:string);

function ValueTo1NTable(Value:double):string;

function ValueTo1NTableRezult(Value:double;limitP:double=0.1):string;


function RowOfDataInStringList(EvolType: TEvolutionTypeNew;
                               T:integer;
                               SL:TStringList):integer;
{повертає номер рядочка в SL, який починаэться
з назви алгоритму та значення температури}

procedure ReadEvolParResult(EvolType: TEvolutionTypeNew; ParName: string; Vec: TVector;
                          FileName: string = 'ResultAll.dat';ReadRelativeError:boolean=True);

procedure ReadEvolAllParResult(ParName: string; VecEvol: TArrVec;
                           FileName: string = 'ResultAll.dat';ReadRelativeError:boolean=True);

procedure ReadEvolParComplex(EvolType: TEvolutionTypeNew; Vec: TVector;
                          FileName: string = 'ResultAll.dat');

procedure ReadEvolAllParComplex(VecEvol: TArrVec;
                          FileName: string = 'ResultAll.dat');

procedure ReadEvolParWideT(EvolType: TEvolutionTypeNew; Vec: TVector;
                          FileName: string = 'Stat.dat');

procedure ReadEvolAllParWideT(VecEvol: TArrVec;
                          FileName: string = 'Stat.dat');

procedure SomethingForCastro();

procedure ReadParamAndToFiles(FileName:string);

procedure SomethingForCastro2(FileName:string);

procedure WilcoxonTestOfFitFunction(FileNameSqrEr,FileNameAbsEr:string);

procedure WilcoxonTestOfMethod(FileName:string);

procedure WilcoxonTestOfMethodComplex(FileName:string);

procedure WilcoxonTestOfMethodWideT(FileName:string);

procedure Tests1N(FileName:string);

procedure Tests1NComplex(FileName:string);

procedure Tests1NWideT(FileName:string);


procedure MultipleComparisonsTests(FileName:string);

procedure MultipleComparisonsComplex(FileName:string);

procedure MultipleComparisonsWideT(FileName:string);

procedure MeanValuesCalculation(FileName:string);

procedure MeanValuesCalculation2(FileName:string);

procedure  MainParamToStringArray(FitFunction: TFFSimple;var SA:TArrStr);
{в SA розміщуються назви основних параметрів, які визначає FitFunction,
а також rmsre}

procedure CastroParamToStringArray(var SA:TArrStr);
{в SA назви основних параметрів для TFFIV_thin}

procedure SortingStringList(SL:TStringList;ColumnNumber:byte=2);




implementation

uses
  OlegMath, System.Math, System.SysUtils, Vcl.Dialogs, OlegTests,
  OlegFunction, FitIteration, Vcl.FileCtrl, OlegStatistic;


 Procedure CreateVecEvol(var VecEvol:TArrVec);
  var EvolType:TEvolutionTypeNew;
 begin
  SetLength(VecEvol,ord(High(TEvolutionTypeNew))+1);
  for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
   begin
    VecEvol[ord(EvolType)]:=TVector.Create;
    VecEvol[ord(EvolType)].Name:=EvTypeNames[EvolType];
   end;
 end;

 Procedure FreeVecEvol(var VecEvol:TArrVec);
   var EvolType:TEvolutionTypeNew;
 begin
  for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
    VecEvol[ord(EvolType)].Free;
 end;

Function CasI01(const T:double):double;
begin
//  Result:=ThermallyActivated(I001,I01Ea,T);
  Result:=I01const;
end;

Function CasI02(const T:double):double;
begin
  Result:=ThermallyActivated(I002,I02Ea,T);
end;

Function Casn1(const T:double):double;
begin
 if T>=0
   then Result:=1/Kb/T/n1A
   else Result:=ErResult;
end;

Function Casn2(const T:double):double;
begin
 if T>=0
   then Result:=1+n2T0/T
   else Result:=ErResult;
end;

Function CasRsh1(const T:double):double;
begin
 if T>=0
   then Result:=Rsh1const
   else Result:=ErResult;
end;

Function CasRsh2(const T:double):double;
begin
 Result:=ThermallyActivated(Rsh20,-Rsh2Ea,T);
end;

Function CasIph(const T:double):double;
begin
 Result:=ThermallyLiniar(Iph0,TC_Iph,T)
// if T>=0
//   then Result:=Iph0
//   else Result:=ErResult;
end;

Function CasRs(const T:double):double;
begin
 Result:=ThermallyLiniar(Rs0,TC_Rs,T)
end;

Procedure CasParDetermination(const T:double;
                              var Parameters:TArrSingle);
begin
  SetLength(Parameters,Npar);
  Parameters[0]:=CasI01(T);
  Parameters[1]:=Casn1(T);
  Parameters[2]:=CasRsh1(T);
  Parameters[3]:=CasI02(T);
  Parameters[4]:=Casn2(T);
  Parameters[5]:=CasRsh2(T);
  Parameters[6]:=CasRs(T);
  Parameters[7]:=CasIph(T);
  Parameters[8]:=T;
end;

Function CastroIVdod(I:double;Parameters:array of double):double;
{використовується при обчисленні функції Кастро при певному значенні напруги,
а не струму
Parameters[9] - V (ота сама напруга)}
begin
  Result:=Parameters[9]-CastroIV(I,Parameters);
end;

Function CastroIV_onV(V:double;Parameters:array of double;
                     const Imax:double=1; const Imin:double=0;
                     const eps:double=1e-6):double;
{розрахунок струму відповідно до моделі Кастро при певному значенні напруги,
використовується метод ділення навпіл,
Imax, Imin - інтервал для пошуку}
 var Par:array of double;
     i:byte;
begin
 SetLength(Par,10);
 for I := 0 to 8 do
    Par[i]:=Parameters[i];
 Par[9]:=V;
 Result:=Bisection(CastroIVdod,Par,Imax,Imin,eps);
end;

Procedure CastroIV_Creation(Vec:TVector;Parameters:array of double;
                           const Vmax:double=1;
                           const stepV:double=0.01;
                           const eps:double=1e-6);
{створюється ВАХ за формулою Кастро у вже існуючому Vec
від 0 до Vmax з кроком stepV}
var V,Imin,Imax:double;
begin
 Vec.Clear;
 if High(Parameters)<8 then Exit;
 Vec.T:=Parameters[8];
 if (stepV<=0)
     or(Parameters[7]<0) then Exit;

 V:=0;
 Imin:=-Parameters[7]-max(1e-4,abs(Parameters[7])*0.1);
 Imax:=0+min(1e-4,abs(Parameters[7])*0.1);
 repeat
   Vec.Add(V,CastroIV_onV(V,Parameters,Imin,Imax,eps));
   if Vec.Y[Vec.HighNumber]=ErResult then Break;
   V:=V+stepV;
   Imin:=Vec.Y[Vec.HighNumber];
   Imax:=max(abs(Parameters[7]),2*abs(Imin));
   Imax:=Imin+max(Imax,1e-4);
 until V>Vmax;

end;

procedure CastroFitting(EvolType:TEvolutionTypeNew;
                        Parameters:TArrSingle;
                        Vec:TVectorTransform);
 var FFunction:TFitFunctionNew;
     ParamNames:TArrStr;
     i,j:byte;
     StrStat,StrRez:TStringList;
     RezVec:array of TVectorTransform;
     MaxXnumber:integer;
begin
 FFunction:=FitFunctionFactory(ThinDiodeNames[0]);
 FFunction.ConfigFile.WriteEvType(FFunction.Name,'EvType',EvolType);
 WriteIniDef(FFunction.ConfigFile,FFunction.Name,'Nit',Niter[EvolType],1000);

 FreeAndNil(FFunction);
 FFunction:=FitFunctionFactory(ThinDiodeNames[0]);

 MainParamToStringArray((FFunction as TFFSimple),ParamNames);

 StrStat:=TStringList.Create;
 StrRez:=TStringList.Create;
 SafeLoad(StrStat,'Stat.dat',StatTitle(ParamNames));
 SafeLoad(StrRez,'ResultAll.dat',ResultAllTitle(ParamNames));

 SetLength(RezVec,High(ParamNames)+1);
 for I := 0 to High(ParamNames) do
  begin
  RezVec[i]:=TVectorTransform.Create;
  RezVec[i].Name:=EvTypeNames[EvolType];
  end;



 for I := 1 to Nrep do
  begin
   (FFunction as TFitFunctionNew).Fitting(Vec);
   if FFunction.ResultsIsReady then
    begin
      StrRez.Add(ResultAllString((FFunction as TFFSimple),Parameters));
      StrRez.SaveToFile('ResultAll.dat');
      for j := 0 to (FFunction as TFFSimple).DParamArray.MainParamHighIndex do
       RezVec[j].Add(i,(FFunction as TFFSimple).DParamArray.OutputData[j]);
      RezVec[High(RezVec)].Add(i,(FFunction as TFFSimple).DParamArray.OutputData[High((FFunction as TFFSimple).DParamArray.OutputData)]);

//    FFunction.FileSuffix:=EvTypeNames[EvolType];
//    FFunction.RealToFile;
// кривих збіжності
//     RenameFile(ExtractFilePath(ParamStr(0))+'converg.dat',
//                ExtractFilePath(ParamStr(0))+EvTypeNames[EvolType]+'_AE'+'converg.dat')

    end
                                else Break;
  end;

 for I := 1 to round(Nrep*0.2) do
  for j := 0 to High(RezVec) do
   begin
   MaxXnumber:=RezVec[High(RezVec)].MaxXnumber;
   RezVec[j].DeletePoint(MaxXnumber);
   end;


// for I := 1 to round(Nrep*0.2) do
//  begin
//    MaxXnumber:=RezVec[High(RezVec)].MaxXnumber;
//    for j := 0 to High(RezVec) do
//     RezVec[j].DeletePoint(MaxXnumber);
//  end;
// for I := 0 to RezVec[High(RezVec)].HighNumber  do
//  begin
//    tempstr:=EvTypeNames[EvolType];
//    tempstr:=tempstr+' '+inttostr(round(Parameters[8]));
//    for j := 0 to (FFunction as TFFSimple).DParamArray.MainParamHighIndex do
//      tempstr:=tempstr+' '+FloatToStrF(RezVec[j].Y[i],ffExponent,10,2)
//         +' '+FloatToStrF(Parameters[j],ffExponent,10,2);
//    tempstr:=tempstr+' '+FloatToStrF(RezVec[High(RezVec)].Y[i],ffExponent,10,2);
//    StrRez.Add(tempstr);
//  end;
// StrRez.SaveToFile('ResultAll.dat');


 StrStat.Add(StatString(RezVec,Parameters));

 for I := 0 to High(ParamNames) do
  FreeAndNil(RezVec[i]);

 StrStat.SaveToFile('Stat.dat');
 FreeAndNil(StrStat);
 FreeAndNil(StrRez);
 FreeAndNil(FFunction);
end;

procedure CastroFitting(EvolType:TEvolutionTypeNew;
                        Parameters:TArrSingle);overload;
 var Vec:TVectorTransform;
begin
 Vec:=TVectorTransform.Create;
 CastroIV_Creation(Vec,Parameters,1.001);
 CastroFitting(EvolType,Parameters,Vec);
 FreeAndNil(Vec);
end;

procedure CastroFittingIdeal(EvolType:TEvolutionTypeNew;
                        Parameters:TArrSingle);
 var Vec:TVectorTransform;
     FFunction:TFitFunctionNew;
     ParamNames:TArrStr;
     i,j:byte;
     StrStat,StrRez:TStringList;
     RezVec:TArrVec;
begin
 Vec:=TVectorTransform.Create;
 CastroIV_Creation(Vec,Parameters,1.001);
 Vec.Name:=EvTypeNames[EvolType]+inttostr(round(Parameters[8]))+'.dat';

 FFunction:=FitFunctionFactory(ThinDiodeNames[0]);
 FFunction.ConfigFile.WriteEvType(FFunction.Name,'EvType',EvolType);
 WriteIniDef(FFunction.ConfigFile,FFunction.Name,'Nit',round(1.5*Niter[EvolType]),1000);

 FreeAndNil(FFunction);
 FFunction:=FitFunctionFactory(ThinDiodeNames[0]);

 MainParamToStringArray((FFunction as TFFSimple),ParamNames);

 StrStat:=TStringList.Create;
 StrRez:=TStringList.Create;
 SafeLoad(StrStat,'Stat.dat',StatTitle(ParamNames));
 SafeLoad(StrRez,'ResultAll.dat',ResultAllTitle(ParamNames));

 SetLength(RezVec,High(ParamNames)+1);
 for I := 0 to High(ParamNames) do
  begin
  RezVec[i]:=TVector.Create;
  RezVec[i].Name:=EvTypeNames[EvolType];
  end;


 for I := 1 to Nrep do
  begin
   (FFunction as TFitFunctionNew).Fitting(Vec);
   if FFunction.ResultsIsReady then
    begin
      StrRez.Add(ResultAllString((FFunction as TFFSimple),Parameters));
      StrRez.SaveToFile('ResultAll.dat');
      for j := 0 to (FFunction as TFFSimple).DParamArray.MainParamHighIndex do
       RezVec[j].Add(i,(FFunction as TFFSimple).DParamArray.OutputData[j]);
      RezVec[High(RezVec)].Add(i,(FFunction as TFFSimple).DParamArray.OutputData[High((FFunction as TFFSimple).DParamArray.OutputData)]);

//    FFunction.RealToFile;
    end
                                else Break;
  end;

 if i>Nrep then
  StrStat.Add(StatStringIdeal(RezVec,Parameters));

 for I := 0 to High(ParamNames) do
  FreeAndNil(RezVec[i]);

 StrStat.SaveToFile('Stat.dat');
 FreeAndNil(StrStat);
 FreeAndNil(StrRez);
 FreeAndNil(FFunction);

 FreeAndNil(Vec);
end;

function StatTitle(ParamNames:TArrStr;ForMedianValue:boolean=True):string;
 var i:byte;
begin
//  Result:='Name T';
  if ForMedianValue then
    begin
    Result:='Name T';
    for I := 0 to High(ParamNames) do
     begin
      Result:=Result+' '+ParamNames[i]+'med '
             +ParamNames[i]+'q25 '
             +ParamNames[i]+'q75 ';
      if i<>High(ParamNames)
         then Result:=Result+ParamNames[i]+'er';
     end;
    end
                else
    begin
    Result:='T';
    for I := 0 to High(ParamNames) do
     begin
      Result:=Result+' '+ParamNames[i]+'mean '
             +ParamNames[i]+'sd ';
      if i<>High(ParamNames)
        then Result:=Result+'er'+ParamNames[i];
  //           +' rse'+ParamNames[i];
     end;
    end;
end;

function ResultAllTitle(ParamNames:TArrStr):string;
 var i:byte;
begin
  Result:='Name T';
  for I := 0 to High(ParamNames) do
   begin
    Result:=Result+' '+ParamNames[i];
    if i<>High(ParamNames)
      then Result:=Result+' '+ParamNames[i]+'tr';
   end;
end;

function StatString(RezVec:array of TVectorTransform;Parameters:TArrSingle):string;
 var i:byte;
begin
  Result:=RezVec[0].Name;
  Result:=Result+' '+inttostr(round(Parameters[8]));
  for I := 0 to High(RezVec) do
   begin
    Result:=Result+' '+FloatToStrF(RezVec[i].MeanY,ffExponent,10,2)
           +' '+FloatToStrF(RezVec[i].StandartErrorY,ffExponent,10,2);
//           +' '+FloatToStrF(RezVec[i].ImpulseNoiseSmoothing(cY),ffExponent,10,2);
    if i<>High(RezVec)
      then Result:=Result+' '+FloatToStrF(RelativeDifference(Parameters[i],RezVec[i].MeanY),ffExponent,10,2);
//           +' '+FloatToStrF(abs(RezVec[i].StandartErrorY/Parameters[i]),ffExponent,10,2);
   end;
end;

function StatStringIdeal(RezVec:TArrVec;Parameters:TArrSingle):string;
 var i:byte;
begin
  Result:=RezVec[0].Name;
  Result:=Result+' '+inttostr(round(Parameters[8]));
  for I := 0 to High(RezVec) do
   begin
    Result:=Result+' '+FloatToStrF(RezVec[i].Median,ffExponent,10,2)
           +' '+FloatToStrF(RezVec[i].Q1,ffExponent,10,2)
           +' '+FloatToStrF(RezVec[i].Q3,ffExponent,10,2);
    if i<>High(RezVec)
      then Result:=Result+' '+FloatToStrF(RelativeDifference(Parameters[i],RezVec[i].Median),ffExponent,10,2);
   end;
end;

function ResultAllString(FitFunction:TFFSimple;Parameters:TArrSingle):string;
 var i:byte;
begin
  Result:=EvTypeNames[(FitFunction.DParamArray as TDParamsHeuristic).EvType];
  Result:=Result+' '+inttostr(round(Parameters[8]));
  for I := 0 to FitFunction.DParamArray.MainParamHighIndex do
   Result:=Result+' '+FloatToStrF(FitFunction.DParamArray.OutputData[i],ffExponent,10,2)
         +' '+FloatToStrF(Parameters[i],ffExponent,10,2);
  Result:=Result+' '+FloatToStrF(FitFunction.DParamArray.OutputData[FitFunction.ParametersNumber-1],ffExponent,10,2)
end;


procedure SafeLoad(SL:TStringList; FileName,Title:string);
begin
 try
  SL.LoadFromFile(FileName);
 except
  SL.Add(Title);
 end;
end;

procedure pssAfiting();
var
  Vec: TVectorTransform;
  EvolType: TEvolutionTypeNew;
  Par1:TArrSingle;
begin
 SetLength(Par1,9);
 Par1[0]:=1.6e-9;
 Par1[1]:=1.92;
 Par1[2]:=190;
 Par1[3]:=1.6e-4;
 Par1[4]:=1.92;
 Par1[5]:=190;
 Par1[6]:=45;
 Par1[7]:=8e-3;
 Par1[8]:=300;

  Vec := TVectorTransform.Create;
  Vec.ReadFromFile('pssA.dat');
  for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
    CastroFitting(EvolType, Par1, Vec);
  FreeAndNil(Vec);
end;

procedure Idealfiting();
var
//  Vec: TVector;
  EvolType: TEvolutionTypeNew;
  Parameters:TArrSingle;
  T,i:integer;
  StrStat,StrRez:TStringList;
  SA:TArrStr;
begin
 StrStat:=TStringList.Create;
 CastroParamToStringArray(SA);
 StrRez:=TStringList.Create;

 for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
  begin
   T:=Tbegin;
   repeat
    SafeLoad(StrStat,'Stat.dat',StatTitle(SA));
    if RowOfDataInStringList(EvolType,T,StrStat)>-1
     then
      begin
       T:=T+10;
       Continue;
      end;
    SafeLoad(StrRez,'ResultAll.dat',ResultAllTitle(SA));
    repeat
     i:=RowOfDataInStringList(EvolType,T,StrRez);
     if i>-1 then StrRez.Delete(i);
    until (i<0);
    StrRez.SaveToFile('ResultAll.dat');

    CasParDetermination(T,Parameters);
    CastroFittingIdeal(EvolType, Parameters);
    T:=T+10;
   until (T>Tend);

  end;

 FreeAndNil(StrRez);

 FreeAndNil(StrStat);
end;


procedure Test1NResultRebuilding();
 var MethodName:string;
     EvolType,EvolType2: TEvolutionTypeNew;
     SR : TSearchRec;
     SLInput,SLOutputTable,SLOutputRez:TStringList;
     VecArray:array[1..N1TestNumber,1..N1posthocNumber] of TVector;
     i,j,k,k1:integer;
     tempstr,tempstrRez:string;
begin
 SLInput:=TStringList.Create;
 SLOutputTable:=TStringList.Create;
 SLOutputRez:=TStringList.Create;
 for I := 1 to N1TestNumber do
   for j := 1 to N1posthocNumber do  VecArray[i,j]:=TVector.Create;

 for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
// for EvolType := etADELI to etADELI do
// for EvolType := etDE to etDE do
 begin
  MethodName:=EvTypeNames[EvolType];
  for I := 1 to N1TestNumber do
   for j := 1 to N1posthocNumber do  VecArray[i,j].Clear;
  SLOutputTable.Clear;
  SLOutputTable.Add('Algorithm Test '+ArrayToString(N1posthocNames));
  SLOutputRez.Clear;
  SLOutputRez.Add('Algorithm Test '+ArrayToString(N1posthocNames));
  if FindFirst(mask, faAnyFile, SR) <> 0 then Exit;
  repeat
   if Pos(MethodName+'Compl',SR.Name)=1 then
    begin
      SLInput.LoadFromFile(SR.Name);
      for I := 1 to N1TestNumber do
       if Pos(N1testNames[i-1]+'Pval',SR.Name)>0 then
         begin
         for EvolType2 := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
          begin
            if EvolType2=EvolType then Continue;
            for j := 1 to SLInput.Count-1 do
              if StringDataFromRow(SLInput[j],1)=EvTypeNames[EvolType2] then
                begin
                 for k:=1 to N1posthocNumber do
                   VecArray[i,k].Add(ord(EvolType2),FloatDataFromRow(SLInput[j],k+1));
                 Break;
                end;
          end;
         end;
    end;
  until (FindNext(SR) <> 0);
//  showmessage(VecArray[1,1].XYToString);
  VecArray[1,1].SwapXY();
  VecArray[1,1].Sorting();
  VecArray[1,1].SwapXY();

  for I := 0 to VecArray[1,1].HighNumber do
   begin
    for j:= 1 to N1TestNumber do
     begin
     tempstr:=EvTypeNames[TEvolutionTypeNew(round(VecArray[1,1].X[i]))];
     tempstr:=tempstr+' '+N1testNames[j-1];
     tempstrRez:=tempstr;
     for k := 1 to N1posthocNumber do
      for k1 := 0 to VecArray[j,k].HighNumber do
        if round(VecArray[j,k].X[k1])=round(VecArray[1,1].X[i]) then
          begin
           tempstr:=tempstr+' '+ValueTo1NTable(VecArray[j,k].Y[k1]);
           tempstrRez:=tempstrRez+' '+ValueTo1NTableRezult(VecArray[j,k].Y[k1]);
           Break;
          end;
     SLOutputTable.Add(tempstr);
     SLOutputRez.Add(tempstrRez);
     end;
   end;
  SLOutputTable.SaveToFile(MethodName+'Table.dat');
  SLOutputRez.SaveToFile(MethodName+'RezTable.dat');
 end;
 for I := 1 to N1TestNumber do
   for j := 1 to N1posthocNumber do  FreeAndNil(VecArray[i,j]);
 FreeAndNil(SLInput);
 FreeAndNil(SLOutputTable);
 FreeAndNil(SLOutputRez);
end;

function ValueTo1NTable(Value:double):string;
begin
  if Value<1e-13 then
     begin
     Result:='<1E-13';
     Exit;
     end;
  if Value=1 then
     begin
     Result:='1.0';
     Exit;
     end;
  result:=FloatToStrF(Value,ffExponent,6,2)
end;

function ValueTo1NTableRezult(Value:double;limitP:double=0.1):string;
begin
  if Value<limitP then Result:='+'
                  else Result:='-';
end;


procedure TestNNResultRebuilding(FileName:string);
 var SLInput,SLOutputTable,SLOutputRez:TStringList;
     Pvalues:array[1..NNposthocNumber] of double;
     i,j:integer;
     tempstr,tempstr2:string;
     EvolType,EvolType2: TEvolutionTypeNew;
//  NNposthocNumber=3;
//  NNposthocNames:array[0..NNposthocNumber-1]of string=
//   ('Nemenyi', 'Holm', 'Shaffer');
begin
 SLInput:=TStringList.Create;
 SLOutputTable:=TStringList.Create;
 SLOutputRez:=TStringList.Create;
 SLInput.LoadFromFile(FileName);
 SLOutputTable.Add('Method_versus_Method '+ArrayToString(NNposthocNames));
 SLOutputRez.Add('Method_versus_Method '+ArrayToString(NNposthocNames));
 for I := 1 to SLInput.Count-1 do
  begin
    tempstr:='';
    tempstr:=StringDataFromRow(SLInput[i],1)+VS+StringDataFromRow(SLInput[i],3);
    tempstr2:=tempstr;
    for j := 1 to NNposthocNumber do
      Pvalues[j]:=FloatDataFromRow(SLInput[i],j+3);
    for j := 1 to NNposthocNumber do
      begin
      tempstr:=tempstr+' '+ValueTo1NTable(Pvalues[j]);
      tempstr2:=tempstr2+' '+ValueTo1NTableRezult(Pvalues[j]);
      end;
    SLOutputTable.Add(tempstr);
    SLOutputRez.Add(tempstr2);
  end;
 SLOutputTable.SaveToFile(FitName(FileName,'Table'));
 SLOutputRez.SaveToFile(FitName(FileName,'TableRez'));

// for I := 1 to NNposthocNumber do
// begin
//   SLOutputRez.Clear;
//   SLOutputRez.Add('Method '+ArrayToString(EvTypeNames));
//   for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
//   begin
//     tempstr:=EvTypeNames[EvolType];
//     for EvolType2 := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
//     begin
//       if EvolType=EvolType2 then
//          begin
//            tempstr:=tempstr+' '+'0';
//            Continue;
//          end;
//       for j := 1 to SLInput.Count-1 do
//        if (EvTypeNames[EvolType]=StringDataFromRow(SLInput[j],1))
//           and(EvTypeNames[EvolType2]=StringDataFromRow(SLInput[j],3)) then
//          begin
//           if FloatDataFromRow(SLInput[j],i+3)<0.1
//             then tempstr:=tempstr+' '+'1'
//             else tempstr:=tempstr+' '+'0';
//           Break;
//          end;
//     end;
//     SLOutputRez.Add(tempstr);
//   end;
//   SLOutputRez.SaveToFile(FitName(FileName,NNposthocNames[i-1]));
// end;

 SLOutputRez.Clear;
 SLOutputRez.Add('Method Method '+ArrayToString(NNposthocNames));
 for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
 begin
  for EvolType2 := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
  begin
   tempstr:=EvTypeNames[EvolType]+' '+inttostr(ord(EvolType2)+1);
   if EvolType=EvolType2 then
    begin
    tempstr:=tempstr+' -0.05 -0.05 -0.05';
    SLOutputRez.Add(tempstr);
    Continue;
    end;
   for j := 1 to SLInput.Count-1 do
    if (EvTypeNames[EvolType]=StringDataFromRow(SLInput[j],1))
       and(EvTypeNames[EvolType2]=StringDataFromRow(SLInput[j],3)) then
    begin
     for I := 1 to NNposthocNumber do
      if FloatDataFromRow(SLInput[j],i+3)<0.1
          then tempstr:=tempstr+' '+'1'
          else tempstr:=tempstr+' '+'0';
      Break;
    end;
   SLOutputRez.Add(tempstr);
  end;
 end;

 SLOutputRez.SaveToFile(FitName(FileName,'Fig'));

 FreeAndNil(SLInput);
 FreeAndNil(SLOutputTable);
 FreeAndNil(SLOutputRez);
end;

function RowOfDataInStringList(EvolType: TEvolutionTypeNew;
                               T:integer;
                               SL:TStringList):integer;
 var i:integer;
begin
  Result:=-1;
  for i:=0 to SL.Count-1 do
   if (StringDataFromRow(SL[i],1)=EvTypeNames[EvolType])
      and  (round(FloatDataFromRow(SL[i],2))=T)
      then
        begin
         Result:=i;
         Break;
        end;
end;

procedure ReadEvolParResult(EvolType: TEvolutionTypeNew; ParName: string; Vec: TVector;
               FileName: string = 'ResultAll.dat';ReadRelativeError:boolean=True);
 var StrRez:TStringList;
     EvolTypeName:string;
     ParNumber,ParTrueNumber,i:integer;
begin
  StrRez:=TStringList.Create;
  Vec.Clear;
  EvolTypeName:=EvTypeNames[EvolType];
  Vec.Name:=EvolTypeName;
  try
   StrRez.LoadFromFile(FileName);
   ParNumber:=SubstringNumberFromRow(ParName,StrRez[0]);
   if (ParNumber=0)
     then raise Exception.Create('Parameter is absente');
   ParTrueNumber:=SubstringNumberFromRow(ParName+'tr',StrRez[0]);
   for i := 1 to StrRez.Count-1 do
    if StringDataFromRow(StrRez[i],1)=EvolTypeName then
      begin
       if (ParTrueNumber=0)or not(ReadRelativeError)
          then Vec.Add(Vec.Count+1,FloatDataFromRow(StrRez[i],ParNumber))
          else Vec.Add(Vec.Count+1,
                        RelativeDifference(FloatDataFromRow(StrRez[i],ParTrueNumber),
                                           FloatDataFromRow(StrRez[i],ParNumber)));
//          else Vec.Add(Vec.Count+1,
//                        round(100*RelativeDifference(FloatDataFromRow(StrRez[i],ParTrueNumber),
//                                           FloatDataFromRow(StrRez[i],ParNumber)))/100);
      end;
  finally
   FreeAndNil(StrRez);
  end;
end;

procedure ReadEvolAllParResult(ParName: string; VecEvol: TArrVec;
                           FileName: string = 'ResultAll.dat';ReadRelativeError:boolean=True);
 var EvolType:TEvolutionTypeNew;
begin
// CreateVecEvol(VecEvol);
 for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
   ReadEvolParResult(EvolType, ParName, VecEvol[ord(EvolType)],FileName,ReadRelativeError);
end;

procedure ReadEvolParComplex(EvolType: TEvolutionTypeNew; Vec: TVector;
                          FileName: string = 'ResultAll.dat');
 var StrRez:TStringList;
     EvolTypeName:string;
     ParNumber,ParTrueNumber,i,k:integer;
     SA:TArrStr;
     tempVec:TVector;
begin
  StrRez:=TStringList.Create;
  Vec.Clear;
  EvolTypeName:=EvTypeNames[EvolType];
  Vec.Name:=EvolTypeName;
  CastroParamToStringArray(SA);
  tempVec:=TVector.Create;
  try
   StrRez.LoadFromFile(FileName);
   for I := 0 to High(SA) do
    begin
     tempVec.Clear;
     ParNumber:=SubstringNumberFromRow(SA[i],StrRez[0]);
     if (ParNumber=0)
      then raise Exception.Create('Parameter is absente');
     ParTrueNumber:=SubstringNumberFromRow(SA[i]+'tr',StrRez[0]);
     if (ParTrueNumber=0)and(i<>High(SA))
      then raise Exception.Create('Parameter is absente');
     for k := 1 to StrRez.Count-1 do
      if StringDataFromRow(StrRez[k],1)=EvolTypeName then
       tempVec.Add(FloatDataFromRow(StrRez[k],ParTrueNumber),
                   FloatDataFromRow(StrRez[k],ParNumber));
     if odd(tempVec.HighNumber) then  tempVec.DeletePoint(tempVec.MaxYnumber);
     if i=High(SA)
      then Vec.Add(Vec.Count+1,tempVec.Median)
      else Vec.Add(Vec.Count+1,RelativeDifference(tempVec.X[0],
                                           tempVec.Median));
    end;
  finally
   Vec.Add(Vec.Count+1,TimeOfFiting[EvolType]);
   FreeAndNil(StrRez);
   FreeAndNil(tempVec);
  end;
end;

procedure ReadEvolParWideT(EvolType: TEvolutionTypeNew; Vec: TVector;
                          FileName: string = 'Stat.dat');
 var StrRez:TStringList;
     EvolTypeName:string;
     ParNumber,i,k:integer;
     SA:TArrStr;
//     tempVec:TVector;
     T:integer;
begin
  StrRez:=TStringList.Create;
  Vec.Clear;
  EvolTypeName:=EvTypeNames[EvolType];
  Vec.Name:=EvolTypeName;
  CastroParamToStringArray(SA);
//  tempVec:=TVector.Create;
  try
   StrRez.LoadFromFile(FileName);
   for I := 0 to High(SA) do
    begin
     if i<>High(SA) then ParNumber:=SubstringNumberFromRow(SA[i]+'er',StrRez[0])
                    else ParNumber:=SubstringNumberFromRow(SA[i]+'med',StrRez[0]);
     if (ParNumber=0)
      then raise Exception.Create('Parameter is absente');

     T:=Tbegin;
     repeat
      for k := 1 to StrRez.Count-1 do
       begin
        if (StringDataFromRow(StrRez[k],1)=EvolTypeName)
           and(StringDataFromRow(StrRez[k],2)=inttostr(T)) then
            begin
            Vec.Add(Vec.Count+1,FloatDataFromRow(StrRez[k],ParNumber));
            Break;
            end;
       end;
      T:=T+10;
     until (T>Tend);
    end;
  finally
   Vec.Add(Vec.Count+1,TimeOfFiting[EvolType]);
   FreeAndNil(StrRez);
//   FreeAndNil(tempVec);
  end;
end;

procedure ReadEvolAllParComplex(VecEvol: TArrVec;
                          FileName: string = 'ResultAll.dat');
 var EvolType:TEvolutionTypeNew;
begin
 for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
   ReadEvolParComplex(EvolType,  VecEvol[ord(EvolType)],FileName);
end;

procedure ReadEvolAllParWideT(VecEvol: TArrVec;
                          FileName: string = 'Stat.dat');
 var EvolType:TEvolutionTypeNew;
begin
 for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
   ReadEvolParWideT(EvolType,  VecEvol[ord(EvolType)],FileName);
end;


procedure SomethingForCastro;
// const
// par:array [0..1] of double=
//   (1.2,2);
 var Par1,Par2,Par3,Parameters:TArrSingle;
//     Vec1,Vec2:TVector;
//     T:integer;
begin
 {значення параметрів з pssA_219_2100403}
 SetLength(Par1,9);
 Par1[0]:=1.6e-9;
 Par1[1]:=1.92;
 Par1[2]:=190;
 Par1[3]:=1.6e-4;
 Par1[4]:=1.92;
 Par1[5]:=190;
 Par1[6]:=45;
 Par1[7]:=8e-3;
 Par1[8]:=300;
 SetLength(Par2,9);
 Par2[0]:=2e-12;
 Par2[1]:=1;
 Par2[2]:=150;
 Par2[3]:=6e-4;
 Par2[4]:=3;
 Par2[5]:=840;
 Par2[6]:=53;
 Par2[7]:=9e-3;
 Par2[8]:=300;
 SetLength(Par3,9);
 Par3[0]:=5.84e-5;
 Par3[1]:=6.44;
 Par3[2]:=41.2;
 Par3[3]:=1.21e-4;
 Par3[4]:=2.49;
 Par3[5]:=191;
 Par3[6]:=0;
 Par3[7]:=6.49e-3;
 Par3[8]:=300;
  // SetLength(Par3,9);
  // Par3[0]:=1.5e-5;
  // Par3[1]:=2.4;
  // Par3[2]:=1e8;
  // Par3[3]:=2.4e-7;
  // Par3[4]:=9.5;
  // Par3[5]:=4.6e4;
  // Par3[6]:=0;
  // Par3[7]:=4.85e-5;
  // Par3[8]:=300;

  pssAfiting();

// Idealfiting();

//Test1NResultRebuilding();


end;

procedure SomethingForCastro2(FileName:string);
begin
// WilcoxonTestOfMethod(FileName);
// Tests1N(FileName);
// MultipleComparisonsTests(FileName);

// WilcoxonTestOfMethodComplex(FileName);
// Tests1NComplex(FileName);
// MultipleComparisonsComplex(FileName);

// WilcoxonTestOfMethodWideT(FileName);
// Tests1NWideT(FileName);
// MultipleComparisonsWideT(FileName);
// MeanValuesCalculation(FileName);
// TestNNResultRebuilding(FileName);
 MeanValuesCalculation2(FileName);
end;


procedure ReadParamAndToFiles(FileName:string);
 var VecEvol:TArrVec;
     StrRez:TStringList;
     tempstr:string;
     i,j,k:integer;
     path, fileNameShot:string;
     drive:char;
     SA:TArrStr;
begin
  CreateVecEvol(VecEvol);
  CastroParamToStringArray(SA);
  StrRez:=TStringList.Create;
  for k := 0 to High(SA) do
    begin
      StrRez.Clear;
      ReadEvolAllParResult(SA[k],VecEvol,FileName);

      tempstr:='number';
      for I := 0 to High(VecEvol) do
        tempstr:=tempstr+' '+VecEvol[i].Name;
      StrRez.Add(tempstr);
      for I := 0 to VecEvol[0].HighNumber do
       begin
         tempstr:=inttostr(i);
         for j := 0 to High(VecEvol) do
          tempstr:=tempstr+' '+floattostr(VecEvol[j].Y[i]);
         StrRez.Add(tempstr);
       end;
      ProcessPath(FileName, drive, path, fileNameShot);
      StrRez.SaveToFile(drive + ':' + path+'\'+SA[k]+'.dat');
    end;

  FreeAndNil(StrRez);
  FreeVecEvol(VecEvol);
end;

procedure WilcoxonTestOfFitFunction(FileNameSqrEr,FileNameAbsEr:string);
 var VecEvolSqrEr,VecEvolAbsEr:TVector;
     StrLSqrBetter,StrLAbsBetter:TStringList;
     tempstr,tempstrAbs:string;
     k:integer;
     SA:TArrStr;
     EvolType:TEvolutionTypeNew;
begin
  VecEvolSqrEr:=TVector.Create;
  VecEvolAbsEr:=TVector.Create;
  CastroParamToStringArray(SA);
  StrLSqrBetter:=TStringList.Create;
  StrLAbsBetter:=TStringList.Create;
  tempstr:='Name '+ArrayToString(SA);
  StrLSqrBetter.Add(tempstr);
  StrLAbsBetter.Add(tempstr);

  for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
   begin
     tempstr:=EvTypeNames[EvolType];
     tempstrAbs:=tempstr;
     for k := 0 to High(SA) do
      begin
        ReadEvolParResult(EvolType,SA[k],VecEvolSqrEr,FileNameSqrEr);
        ReadEvolParResult(EvolType,SA[k],VecEvolAbsEr,FileNameAbsEr);
        if AbetterBWilcoxon(VecEvolSqrEr,VecEvolAbsEr,True,0.05)
          then tempstr:=tempstr+' '+'Sqr'
          else tempstr:=tempstr+' '+'0';
        if AbetterBWilcoxon(VecEvolAbsEr,VecEvolSqrEr,True,0.05)
          then tempstrAbs:=tempstrAbs+' '+'Abs'
          else tempstrAbs:=tempstrAbs+' '+'0';
      end;
     StrLSqrBetter.Add(tempstr);
     StrLAbsBetter.Add(tempstrAbs);
   end;
  StrLSqrBetter.SaveToFile('SqrBetter.dat');
  StrLAbsBetter.SaveToFile('AbsBetter.dat');
  FreeAndNil(StrLAbsBetter);
  FreeAndNil(StrLSqrBetter);
  FreeAndNil(VecEvolAbsEr);
  FreeAndNil(VecEvolSqrEr);
end;


procedure WilcoxonTestOfMethod(FileName:string);
 var VecEvol:TArrVec;
     StrL:TStringList;
     tempstr,tempstr2:string;
     k:integer;
     SA:TArrStr;
     EvolType,EvolType2:TEvolutionTypeNew;
     path, fileNameShot:string;
     drive:char;
begin
  CreateVecEvol(VecEvol);
  CastroParamToStringArray(SA);
  StrL:=TStringList.Create;
  ProcessPath(FileName, drive, path, fileNameShot);

  tempstr:='Method';
  for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
   tempstr:=tempstr+' '+EvTypeNames[EvolType];
  for k := 0 to High(SA) do
   begin
    StrL.Clear;
    StrL.Add(tempstr);
    ReadEvolAllParResult(SA[k],VecEvol,FileName);
//    for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
//      VecEvol[ord(EvolType)].WriteToFile(SA[k]+'_'+VecEvol[ord(EvolType)].name+'.dat');
      for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
       begin
        tempstr2:=VecEvol[ord(EvolType)].Name;
        for EvolType2 := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
         begin
           if EvolType=EvolType2
               then tempstr2:=tempstr2+' ='
               else
               begin
                 if AbetterBWilcoxon(VecEvol[ord(EvolType)],VecEvol[ord(EvolType2)],True,0.05)
                    then tempstr2:=tempstr2+' +'
                    else tempstr2:=tempstr2+' 0';
               end;
         end;
        StrL.Add(tempstr2);
       end;
    StrL.SaveToFile(drive + ':' + path+'\'+SA[k]+'_WilcT.dat');
   end;
  FreeAndNil(StrL);
  FreeVecEvol(VecEvol);
end;

procedure WilcoxonTestOfMethodComplex(FileName:string);
 var VecEvol:TArrVec;
     MinMax:TVector;
     StrL:TStringList;
     tempstr2:string;
     EvolType,EvolType2:TEvolutionTypeNew;
     path, fileNameShot:string;
     drive:char;
begin
  CreateVecEvol(VecEvol);
  MinMax:=TVector.Create;
  StrL:=TStringList.Create;
  StrL.Clear;
  StrL.Add('Method '+VecNamesToString(VecEvol));
  ProcessPath(FileName, drive, path, fileNameShot);

  ReadEvolAllParComplex(VecEvol,FileName);
  MinMaxValues(VecEvol,MinMax);

  for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
   begin
    tempstr2:=VecEvol[ord(EvolType)].Name;
    for EvolType2 := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
     begin
       if EvolType=EvolType2
           then tempstr2:=tempstr2+' ='
           else
           begin
             if AbetterBWilcoxon(VecEvol[ord(EvolType)],VecEvol[ord(EvolType2)],MinMax,True,0.05)
                then tempstr2:=tempstr2+' +'
                else tempstr2:=tempstr2+' 0';
           end;
     end;
    StrL.Add(tempstr2);
   end;

  StrL.SaveToFile(drive + ':' + path+'\'+'Complex_WilcT.dat');

  FreeAndNil(StrL);
  FreeAndNil(MinMax);
  FreeVecEvol(VecEvol);
end;

procedure WilcoxonTestOfMethodWideT(FileName:string);
 var VecEvol:TArrVec;
     MinMax:TVector;
     StrL:TStringList;
     tempstr2:string;
     EvolType,EvolType2:TEvolutionTypeNew;
     path, fileNameShot:string;
     drive:char;
begin
  CreateVecEvol(VecEvol);
  MinMax:=TVector.Create;
  StrL:=TStringList.Create;
  StrL.Clear;
  StrL.Add('Method '+VecNamesToString(VecEvol));
  ProcessPath(FileName, drive, path, fileNameShot);

  ReadEvolAllParWideT(VecEvol,FileName);
  MinMaxValues(VecEvol,MinMax);
//  showmessage(VecEvol[LOW(VecEvol)].XYtoString);


  for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
   begin
    tempstr2:=VecEvol[ord(EvolType)].Name;
    for EvolType2 := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
     begin
       if EvolType=EvolType2
           then tempstr2:=tempstr2+' ='
           else
           begin
             if AbetterBWilcoxon(VecEvol[ord(EvolType)],VecEvol[ord(EvolType2)],MinMax,True,0.05)
                then tempstr2:=tempstr2+' +'
                else tempstr2:=tempstr2+' 0';
           end;
     end;
    StrL.Add(tempstr2);
   end;

  StrL.SaveToFile(drive + ':' + path+'\'+'Ideal_WilcT.dat');

  FreeAndNil(StrL);
  FreeAndNil(MinMax);
  FreeVecEvol(VecEvol);
end;

procedure Tests1N(FileName:string);
 var VecEvol:TArrVec;
     SLNullHyp,SLRanks,SLAdjPvalues:TStringList;
     tempstr:string;
     k,i:integer;
     SA:TArrStr;
     EvolType,EvolType2:TEvolutionTypeNew;
     Tests:TOneToNTestSArray;
     tempStrs:array [0..OneToNTestNumber] of string;
begin
  CreateVecEvol(VecEvol);
  CastroParamToStringArray(SA);
  SLNullHyp:=TStringList.Create;
  SLRanks:=TStringList.Create;
  SLAdjPvalues:=TStringList.Create;
  SLNullHyp.Add('Test '+ArrayToString(SA));


  for k := 0 to High(SA) do
//  for k := 0 to 0 do
   begin
    ReadEvolAllParResult(SA[k],VecEvol,FileName);
    CreateOneToNTests(Tests,VecEvol);
//----------------NullHypothesis------------------------------
    if k=0 then
      for I := 0 to High(Tests) do
         tempStrs[i]:=Tests[i].Name;

    for I := 0 to High(Tests) do
     tempStrs[i]:=tempStrs[i]+' '+FloatToStrF(Tests[i].NullhypothesisP(),ffExponent,5,2);

//-------------------Ranks-------------------------------------
    SLRanks.Clear;
    SLRanks.Add('Test '+VecNamesToString(VecEvol));
    for I := 0 to High(Tests) do
     begin
      if i=1 then Continue;

      tempstr:=Tests[i].Name;
      for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
       begin
        if (i=0) then
           tempstr:=tempstr+' '+floattostr(Tests[i].Rj(ord(EvolType)+1));
        if i=2 then
           tempstr:=tempstr+' '+floattostrf((Tests[i] as TFriedmanAligned).RjTotal(ord(EvolType)+1)
                                            /50/50,ffGeneral,5,3);
        if i=3 then
           tempstr:=tempstr+' '+floattostrf((Tests[i] as TQuade).Tj(ord(EvolType)+1),ffGeneral,4,2);
       end;
      SLRanks.Add(tempstr);
     end;
    SLRanks.SaveToFile(FolderFromFullPath(FileName)+SA[k]+'Rank.dat');

//------------------------- Adjusted p-values------------------------------------------
    for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
//    for EvolType := etADELI to etADELI do
//    for EvolType := etNDE to et_WaterWave do
     begin
      for I := 0 to High(Tests) do
       begin
        if i=1 then Continue;
//        if i=2 then Continue;
        SLAdjPvalues.Clear();
        SLAdjPvalues.Add('Method Finner Holm Hochberg Holland');
        for EvolType2 := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
         begin
          if EvolType2=EvolType then Continue;
          tempstr:=EvTypeNames[EvolType2];
          tempstr:=tempstr+' '+floattostrf(Tests[i].FinnerAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          tempstr:=tempstr+' '+floattostrf(Tests[i].HolmAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          tempstr:=tempstr+' '+floattostrf(Tests[i].HochbergAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          tempstr:=tempstr+' '+floattostrf(Tests[i].HollandAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          SLAdjPvalues.Add(tempstr);
         end;
        SortingStringList(SLAdjPvalues);
        SLAdjPvalues.SaveToFile(FolderFromFullPath(FileName)+EvTypeNames[EvolType]+SA[k]+Tests[i].Name+'Pval.dat');
       end;
     end;


    FreeOneToNTests(Tests);
   end;

  StringArrayToStringList(tempStrs,SLNullHyp,False);
  SLNullHyp.SaveToFile(FolderFromFullPath(FileName)+'NullHyp.dat');
  FreeAndNil(SLAdjPvalues);
  FreeAndNil(SLRanks);
  FreeAndNil(SLNullHyp);
  FreeVecEvol(VecEvol);
end;

procedure Tests1NComplex(FileName:string);
 var VecEvol:TArrVec;
     SLNullHyp,SLRanks,SLAdjPvalues:TStringList;
     tempstr:string;
     k,i:integer;
     EvolType,EvolType2:TEvolutionTypeNew;
     Tests:TOneToNTestSArray;
     tempStrs:array [0..OneToNTestNumber] of string;
begin
  CreateVecEvol(VecEvol);
  SLNullHyp:=TStringList.Create;
  SLRanks:=TStringList.Create;
  SLAdjPvalues:=TStringList.Create;

  ReadEvolAllParComplex(VecEvol,FileName);
//  showmessage(VecEvol[0].XYtoString);
//  MinMaxNormalization(VecEvol);
//  showmessage(VecEvol[0].XYtoString);
//  for I := 0 to High(VecEvol) do
//   begin
//     SLNullHyp.Add(VecEvol[i].Name);
//     SLNullHyp.Add(VecEvol[i].XYtoString);
//   end;


  CreateOneToNTests(Tests,VecEvol);

  SLNullHyp.Add('Test Complex');


//----------------NullHypothesis------------------------------
    for I := 0 to High(Tests) do
     SLNullHyp.Add(Tests[i].Name+' '
                   +FloatToStrF(Tests[i].NullhypothesisP(),ffExponent,5,2));

//-------------------Ranks-------------------------------------
    SLRanks.Add('Test '+VecNamesToString(VecEvol));
    for I := 0 to High(Tests) do
     begin
      if i=1 then Continue;

      tempstr:=Tests[i].Name;
      for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
       begin
        if (i=0) then
           tempstr:=tempstr+' '+floattostr(Tests[i].Rj(ord(EvolType)+1));
        if i=2 then
           tempstr:=tempstr+' '+floattostrf((Tests[i] as TFriedmanAligned).RjTotal(ord(EvolType)+1)
                                            /sqr(VecEvol[0].Count),ffGeneral,5,3);
        if i=3 then
           tempstr:=tempstr+' '+floattostrf((Tests[i] as TQuade).Tj(ord(EvolType)+1),ffGeneral,4,2);
       end;
      SLRanks.Add(tempstr);
     end;
    SLRanks.SaveToFile(FolderFromFullPath(FileName)+'ComplexRank.dat');

//------------------------- Adjusted p-values------------------------------------------
    for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
//    for EvolType := etADELI to etADELI do
     begin
      for I := 0 to High(Tests) do
       begin
        if i=1 then Continue;
        SLAdjPvalues.Clear();
        SLAdjPvalues.Add('Method Finner Holm Hochberg Holland');
        for EvolType2 := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
         begin
          if EvolType2=EvolType then Continue;
          tempstr:=EvTypeNames[EvolType2];
          tempstr:=tempstr+' '+floattostrf(Tests[i].FinnerAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          tempstr:=tempstr+' '+floattostrf(Tests[i].HolmAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          tempstr:=tempstr+' '+floattostrf(Tests[i].HochbergAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          tempstr:=tempstr+' '+floattostrf(Tests[i].HollandAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          SLAdjPvalues.Add(tempstr);
         end;
        SortingStringList(SLAdjPvalues);
        SLAdjPvalues.SaveToFile(FolderFromFullPath(FileName)+EvTypeNames[EvolType]+'Compl'+Tests[i].Name+'Pval.dat');
       end;

     end;


    FreeOneToNTests(Tests);
  SLNullHyp.SaveToFile(FolderFromFullPath(FileName)+'NullHypComplex.dat');
  FreeAndNil(SLAdjPvalues);
  FreeAndNil(SLRanks);
  FreeAndNil(SLNullHyp);
  FreeVecEvol(VecEvol);
end;

procedure Tests1NWideT(FileName:string);
 var VecEvol:TArrVec;
     SLNullHyp,SLRanks,SLAdjPvalues:TStringList;
     tempstr:string;
     k,i:integer;
     EvolType,EvolType2:TEvolutionTypeNew;
     Tests:TOneToNTestSArray;
     tempStrs:array [0..OneToNTestNumber] of string;
begin
  CreateVecEvol(VecEvol);
  SLNullHyp:=TStringList.Create;
  SLRanks:=TStringList.Create;
  SLAdjPvalues:=TStringList.Create;

  ReadEvolAllParWideT(VecEvol,FileName);

  CreateOneToNTests(Tests,VecEvol);

  SLNullHyp.Add('Test Ideal');


//----------------NullHypothesis------------------------------
    for I := 0 to High(Tests) do
     SLNullHyp.Add(Tests[i].Name+' '
                   +FloatToStrF(Tests[i].NullhypothesisP(),ffExponent,5,2));

//-------------------Ranks-------------------------------------
    SLRanks.Add('Test '+VecNamesToString(VecEvol));
    for I := 0 to High(Tests) do
     begin
      if i=1 then Continue;

      tempstr:=Tests[i].Name;
      for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
       begin
        if (i=0) then
           tempstr:=tempstr+' '+floattostrf(Tests[i].Rj(ord(EvolType)+1),ffGeneral,4,2);
        if i=2 then
           tempstr:=tempstr+' '+floattostrf((Tests[i] as TFriedmanAligned).RjTotal(ord(EvolType)+1)
                                            /sqr(VecEvol[0].Count),ffGeneral,5,3);
        if i=3 then
           tempstr:=tempstr+' '+floattostrf((Tests[i] as TQuade).Tj(ord(EvolType)+1),ffGeneral,4,2);
       end;
      SLRanks.Add(tempstr);
     end;
    SLRanks.SaveToFile(FolderFromFullPath(FileName)+'IdealRank.dat');

////------------------------- Adjusted p-values------------------------------------------
    for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
//    for EvolType := etADELI to High(TEvolutionTypeNew) do
     begin
      for I := 0 to High(Tests) do
       begin
        if i=1 then Continue;
//        if i<>2 then Continue;
        SLAdjPvalues.Clear();
        SLAdjPvalues.Add('Method Finner Holm Hochberg Holland');
        for EvolType2 := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
         begin
          if EvolType2=EvolType then Continue;
          tempstr:=EvTypeNames[EvolType2];
          tempstr:=tempstr+' '+floattostrf(Tests[i].FinnerAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
//          HelpForMe(EvTypeNames[EvolType2]+'Finner');
          tempstr:=tempstr+' '+floattostrf(Tests[i].HolmAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
//          HelpForMe(EvTypeNames[EvolType2]+'Holm');

          tempstr:=tempstr+' '+floattostrf(Tests[i].HochbergAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
//          HelpForMe(EvTypeNames[EvolType2]+'Hoch');

          tempstr:=tempstr+' '+floattostrf(Tests[i].HollandAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
//          HelpForMe(EvTypeNames[EvolType2]+'Holland');

          SLAdjPvalues.Add(tempstr);
         end;
        SortingStringList(SLAdjPvalues);
        SLAdjPvalues.SaveToFile(FolderFromFullPath(FileName)+EvTypeNames[EvolType]+'Ideal'+Tests[i].Name+'Pval.dat');
       end;

     end;


  FreeOneToNTests(Tests);
  SLNullHyp.SaveToFile(FolderFromFullPath(FileName)+'NullHypIdeal.dat');
  FreeAndNil(SLAdjPvalues);
  FreeAndNil(SLRanks);
  FreeAndNil(SLNullHyp);
  FreeVecEvol(VecEvol);
end;

procedure MultipleComparisonsTests(FileName:string);
 var VecEvol:TArrVec;
     SLAdjPvalues:TStringList;
     tempstr:string;
     k:integer;
     SA:TArrStr;
     EvolType,EvolType2:TEvolutionTypeNew;
     Test:TMultipleComparisons;
begin
  CreateVecEvol(VecEvol);
  CastroParamToStringArray(SA);
  SLAdjPvalues:=TStringList.Create;

  for k := 0 to High(SA) do
   begin
    ReadEvolAllParResult(SA[k],VecEvol,FileName);
    Test:=TMultipleComparisons.Create(VecEvol);
//    SLAdjPvalues.Clear();
//    SLAdjPvalues.Add('Method versus Method Nemenyi Holm Shaffer');
    for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
     begin
        SLAdjPvalues.Clear();
        SLAdjPvalues.Add('Method Nemenyi Holm Shaffer');
        for EvolType2 := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
         begin
          if EvolType2=EvolType then Continue;
//          tempstr:=EvTypeNames[EvolType]+' versus '+EvTypeNames[EvolType2];
          tempstr:=EvTypeNames[EvolType2];
          tempstr:=tempstr+' '+floattostrf(Test.MultipleNemenyiAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          tempstr:=tempstr+' '+floattostrf(Test.MultipleHolmAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          tempstr:=tempstr+' '+floattostrf(Test.MultipleShafferStaticAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          SLAdjPvalues.Add(tempstr);
         end;
        SortingStringList(SLAdjPvalues,4);
        SLAdjPvalues.SaveToFile(FolderFromFullPath(FileName)+EvTypeNames[EvolType]+SA[k]+'MCPval.dat');
     end;
//    SortingStringList(SLAdjPvalues,6);
//    SLAdjPvalues.SaveToFile(FolderFromFullPath(FileName)+SA[k]+'MCPval.dat');

    FreeAndNil(Test);
   end;

  FreeAndNil(SLAdjPvalues);
  FreeVecEvol(VecEvol);
end;

procedure MultipleComparisonsComplex(FileName:string);
 var VecEvol:TArrVec;
     SLAdjPvalues:TStringList;
     tempstr:string;
     EvolType,EvolType2:TEvolutionTypeNew;
     Test:TMultipleComparisons;
begin
  CreateVecEvol(VecEvol);
  SLAdjPvalues:=TStringList.Create;
  ReadEvolAllParComplex(VecEvol,FileName);

   Test:=TMultipleComparisons.Create(VecEvol);
    SLAdjPvalues.Clear();
    SLAdjPvalues.Add('Method versus Method Nemenyi Holm Shaffer');
    for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
     begin
//        SLAdjPvalues.Clear();
//        SLAdjPvalues.Add('Method Nemenyi Holm Shaffer');
        for EvolType2 := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
         begin
          if EvolType2=EvolType then Continue;
          tempstr:=EvTypeNames[EvolType]+' versus '+EvTypeNames[EvolType2];
//          tempstr:=EvTypeNames[EvolType2];
          tempstr:=tempstr+' '+floattostrf(Test.MultipleNemenyiAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          tempstr:=tempstr+' '+floattostrf(Test.MultipleHolmAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          tempstr:=tempstr+' '+floattostrf(Test.MultipleShafferStaticAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          SLAdjPvalues.Add(tempstr);
         end;
//        SortingStringList(SLAdjPvalues,4);
//        SLAdjPvalues.SaveToFile(drive + ':' + path+'\'+EvTypeNames[EvolType]+'Compl'+'MCPval.dat');
     end;
    SortingStringList(SLAdjPvalues,6);
//    SLAdjPvalues.SaveToFile(FolderFromFullPath(FileName)+'Compl'+'MCPval.dat');
    SLAdjPvalues.SaveToFile(FolderFromFullPath(FileName)+'Compl'+'MCPval.dat');

    FreeAndNil(Test);

  FreeAndNil(SLAdjPvalues);
  FreeVecEvol(VecEvol);
end;

procedure MultipleComparisonsWideT(FileName:string);
 var VecEvol:TArrVec;
     SLAdjPvalues:TStringList;
     tempstr:string;
     EvolType,EvolType2:TEvolutionTypeNew;
     Test:TMultipleComparisons;
begin
  CreateVecEvol(VecEvol);
  SLAdjPvalues:=TStringList.Create;
  ReadEvolAllParWideT(VecEvol,FileName);

   Test:=TMultipleComparisons.Create(VecEvol);
//    SLAdjPvalues.Clear();
//    SLAdjPvalues.Add('Method versus Method Nemenyi Holm Shaffer');
    for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
     begin
        SLAdjPvalues.Clear();
        SLAdjPvalues.Add('Method Nemenyi Holm Shaffer');
        for EvolType2 := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
         begin
          if EvolType2=EvolType then Continue;
//          tempstr:=EvTypeNames[EvolType]+' versus '+EvTypeNames[EvolType2];
          tempstr:=EvTypeNames[EvolType2];

          tempstr:=tempstr+' '+floattostrf(Test.MultipleNemenyiAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          tempstr:=tempstr+' '+floattostrf(Test.MultipleHolmAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          tempstr:=tempstr+' '+floattostrf(Test.MultipleShafferStaticAPV(ord(EvolType)+1,ord(EvolType2)+1),
                                           ffExponent,10,2);
          SLAdjPvalues.Add(tempstr);
         end;
        SortingStringList(SLAdjPvalues,4);
        SLAdjPvalues.SaveToFile(FolderFromFullPath(FileName)+EvTypeNames[EvolType]+'Ideal'+'MCPval.dat');
     end;
    SortingStringList(SLAdjPvalues,6);
//    SLAdjPvalues.SaveToFile(FolderFromFullPath(FileName)+'Ideal'+'MCPval.dat');

    FreeAndNil(Test);

  FreeAndNil(SLAdjPvalues);
  FreeVecEvol(VecEvol);
end;

procedure MeanValuesCalculation(FileName:string);
 var EvolType:TEvolutionTypeNew;
      StrStat,StrResultAll,StrStatNew:TStringList;
      SA:TArrStr;
      T,i,k:integer;
      tempStr:string;
      ParNumber,ParNumberTrue:byte;
      Vec:TVector;
begin
 StrStat:=TStringList.Create;
 StrResultAll:=TStringList.Create;
 StrStatNew:=TStringList.Create;
 Vec:=TVector.Create;
 StrResultAll.LoadFromFile(FileName);
 CastroParamToStringArray(SA);

 StrStatNew.Add('Name '+StatTitle(SA,False));
 for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
 begin
  StrStat.Clear;
  StrStat.Add(StatTitle(SA,False));
  T:=Tbegin;
//  T:=300;
  repeat
   TempStr:=inttostr(T);
   for I := 0 to High(SA) do
    begin
     ParNumber:=SubstringNumberFromRow(SA[i],StrResultAll[0]);
     if (ParNumber=0)
      then raise Exception.Create('Parameter is absente');
       ParNumberTrue:=SubstringNumberFromRow(SA[i]+'tr',StrResultAll[0]);
     Vec.Clear;
     for k := 1 to StrResultAll.Count-1 do
     begin
      if (StringDataFromRow(StrResultAll[k],1)=EvTypeNames[EvolType])
         and(StringDataFromRow(StrResultAll[k],2)=inttostr(T)) then
           Vec.Add(FloatDataFromRow(StrResultAll[k],ParNumberTrue),FloatDataFromRow(StrResultAll[k],ParNumber));
     end;

    TempStr:=TempStr+' '+FloatToStrF(Vec.MeanY,ffExponent,6,2)
           +' '+FloatToStrF(Vec.StandartDeviationY,ffExponent,6,2);

//    TempStr:=TempStr+' '+FloatToStrF(Vec.Median,ffExponent,6,2)
//           +' '+FloatToStrF((Vec.Q3-Vec.Q1),ffExponent,6,2);

    if i<>High(SA)
      then TempStr:=TempStr+' '+FloatToStrF(RelativeDifference(Vec.MeanX,Vec.MeanY),ffExponent,6,2);
    end;
    StrStat.Add(TempStr);
    StrStatNew.Add(EvTypeNames[EvolType]+' '+TempStr);
    T:=T+10;
   until (T>Tend);
//   until (T>300);

  StrStat.SaveToFile(FolderFromFullPath(FileName)+EvTypeNames[EvolType]+'StatMean.dat');
 end;
 StrStatNew.SaveToFile(FolderFromFullPath(FileName)+'StatMean.dat');
 FreeAndNil(Vec);
 FreeAndNil(StrStatNew);
 FreeAndNil(StrResultAll);
 FreeAndNil(StrStat);
end;


procedure MeanValuesCalculation2(FileName:string);
 var EvolType:TEvolutionTypeNew;
      StrStat,StrResultAll,StrStatNew:TStringList;
      SA:TArrStr;
      T,i,k:integer;
      TStr,tempstr:string;
      ParNumber,ParNumberTrue:array of byte;
//      Vec:TVector;
      VecParam:TArrVec;
begin
// StrStat:=TStringList.Create;
 StrResultAll:=TStringList.Create;
 StrStatNew:=TStringList.Create;
// Vec:=TVector.Create;
 StrResultAll.LoadFromFile(FileName);
 CastroParamToStringArray(SA);

 SetLength(VecParam,High(SA)+1);
 SetLength(ParNumber,High(SA)+1);
 SetLength(ParNumberTrue,High(SA)+1);

 for i:=0 to High(SA) do
   begin
    VecParam[i]:=TVector.Create;
    VecParam[i].Name:=SA[i];
    ParNumber[i]:=SubstringNumberFromRow(SA[i],StrResultAll[0]);
     if (ParNumber[i]=0)
      then raise Exception.Create('Parameter is absente');
    ParNumberTrue[i]:=SubstringNumberFromRow(SA[i]+'tr',StrResultAll[0]);
   end;


// StrStatNew.Add('Name Param '+ArrayToString(SA));
 StrStatNew.Add('Name '+ArrayToString(SA));
   T:=Tbegin;
//  T:=300;
  repeat
   TStr:=inttostr(T);
   StrStatNew.Add('% % % % % T='+TStr+' % % % %');
   for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
   begin
    for i:=0 to High(SA) do VecParam[i].Clear;
    for k := 1 to StrResultAll.Count-1 do
     if (StringDataFromRow(StrResultAll[k],1)=EvTypeNames[EvolType])
         and(StringDataFromRow(StrResultAll[k],2)=TStr) then
       begin
        for i:=0 to High(SA) do
           VecParam[i].Add(FloatDataFromRow(StrResultAll[k],ParNumberTrue[i]),
                           FloatDataFromRow(StrResultAll[k],ParNumber[i]));
       end;

    if (EvolType = Low(TEvolutionTypeNew)) then
     begin
//      tempstr:=EvTypeNames[EvolType]+' true_value';
      tempstr:='true_value';
      for i:=0 to High(SA) do
        tempstr:=tempstr+' '+FloatToStrF(VecParam[i].X[0],ffExponent,6,2);
      StrStatNew.Add(tempstr);
     end;

    StrStatNew.Add(EvTypeNames[EvolType]+' % % % % % % % % %');
//    tempstr:=EvTypeNames[EvolType]+' MEAN';
    tempstr:='MEAN';
    for i:=0 to High(SA) do
      tempstr:=tempstr+' '+FloatToStrF(VecParam[i].MeanY,ffExponent,6,2);
    StrStatNew.Add(tempstr);

//    tempstr:=EvTypeNames[EvolType]+' MEDIAN';
    tempstr:='MEDIAN';
    for i:=0 to High(SA) do
      tempstr:=tempstr+' '+FloatToStrF(VecParam[i].Median,ffExponent,6,2);
    StrStatNew.Add(tempstr);

//    tempstr:=EvTypeNames[EvolType]+' STD';
    tempstr:='STD';
    for i:=0 to High(SA) do
      tempstr:=tempstr+' '+FloatToStrF(VecParam[i].StandartDeviationY,ffExponent,6,2);
    StrStatNew.Add(tempstr);

//    tempstr:=EvTypeNames[EvolType]+' IQR';
    tempstr:='IQR';
    for i:=0 to High(SA) do
      tempstr:=tempstr+' '+FloatToStrF((VecParam[i].Q3-VecParam[i].Q1),ffExponent,6,2);
    StrStatNew.Add(tempstr);

   end;


//   StrStatNew.Add('');
//   StrStatNew.Add('');

   T:=T+10;
  until (T>Tend);

 StrStatNew.SaveToFile(FolderFromFullPath(FileName)+'StatAll.dat');

 for i := 0 to High(SA) do
    FreeAndNil(VecParam[i]);
// FreeAndNil(Vec);
 FreeAndNil(StrStatNew);
 FreeAndNil(StrResultAll);
// FreeAndNil(StrStat);
end;



procedure  MainParamToStringArray(FitFunction: TFFSimple;var SA:TArrStr);
begin
  SetLength(SA,0);
  FitFunction.ParameterNamesToArray(SA);
  SA[FitFunction.DParamArray.MainParamHighIndex+1]:=SA[High(SA)];
  SetLength(SA,FitFunction.DParamArray.MainParamHighIndex+2);
end;

procedure CastroParamToStringArray(var SA:TArrStr);
 var FFunction:TFitFunctionNew;
begin
 FFunction:=FitFunctionFactory(ThinDiodeNames[0]);
 MainParamToStringArray((FFunction as TFFSimple),SA);
 FreeAndNil(FFunction);
end;

procedure SortingStringList(SL:TStringList;ColumnNumber:byte=2);
 var tempSL:TStringList;
     Vec:TVector;
     i:integer;
begin
 tempSL:=TStringList.Create;
 tempSL.Assign(SL);
 Vec:=TVector.Create;
 for I := 1 to SL.Count-1 do
   Vec.Add(FloatDataFromRow(SL[i],ColumnNumber),i);
 Vec.Sorting();
 SL.Clear;
 SL.Add(tempSL[0]);
 for I := 0 to Vec.HighNumber do
   SL.Add(tempSL[round(Vec.Y[i])]);
 FreeAndNil(Vec);
 FreeAndNil(tempSL);
end;

end.
