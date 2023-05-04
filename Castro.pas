unit Castro;
{функції, пов'язані зі статистичною
обробкою дво-діодної зустрічної моделі}

interface

uses
  OlegVector, OlegType, OApproxCaption, FitSimple, OApproxNew, System.Classes;

const
 Npar=9;
 I001=2e-3;
 I01Ea=0.15;
 I01const=1.5e-5;
 I002=1e3;
 I02Ea=0.43;
 n1A=7;
 n2T0=500;
 Rsh1const=8e4;
 Rsh20=9e-3;
 Rsh2Ea=0.32;
 Iph0=1e-3;

 Nrep=30;

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
                        Vec:TVector);overload;

procedure CastroFitting(EvolType:TEvolutionTypeNew;
                        Parameters:TArrSingle);overload;

function StatTitle(ParamNames:TArrStr):string;
function ResultAllTitle(ParamNames:TArrStr):string;

function StatString(RezVec:array of TVector;Parameters:TArrSingle):string;
function ResultAllString(FitFunction:TFFSimple;Parameters:TArrSingle):string;


procedure SafeLoad(SL:TStringList; FileName,Title:string);

procedure pssAfiting();

procedure ReadEvolParResult(EvolType: TEvolutionTypeNew; ParName: string; Vec: TVector;
                          FileName: string = 'ResultAll.dat');

procedure ReadEvolAllParResult(ParName: string; VecEvol: TArrVec;
                           FileName: string = 'ResultAll.dat');


procedure SomethingForCastro();

procedure  MainParamToStringArray(FitFunction: TFFSimple;var SA:TArrStr);
{в SA розміщуються назви основних параметрів, які визначає FitFunction,
а також rmsre}


implementation

uses
  OlegMath, System.Math, System.SysUtils, Vcl.Dialogs, OlegTests,
  OlegFunction, FitIteration;


 Procedure CreateVecEvol(var VecEvol:TArrVec);
  var EvolType:TEvolutionTypeNew;
 begin
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
 if T>=0
   then Result:=Iph0
   else Result:=ErResult;
end;

Function CasRs(const T:double):double;
begin
 if T>=0
   then Result:=50+(T-290)
//   then Result:=0
   else Result:=ErResult;
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
                        Vec:TVector);
 var FFunction:TFitFunctionNew;
     ParamNames:TArrStr;
     i,j:byte;
     StrStat,StrRez:TStringList;
//     tempstr:string;
     RezVec:array of TVector;
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
  RezVec[i]:=TVector.Create;
  RezVec[i].Name:=EvTypeNames[EvolType];
  end;


// FFunction.ConfigFile.WriteEvType(FFunction.Name,'EvType',EvolType);

// showmessage(EvTypeNames[((FFunction as TFFSimple).DParamArray as TDParamsHeuristic).EvType]);

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
    end
                                else Break;
  end;

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
 var Vec:TVector;
begin
 Vec:=TVector.Create;
 CastroIV_Creation(Vec,Parameters,1.001);
 CastroFitting(EvolType,Parameters,Vec);
 FreeAndNil(Vec);
end;

function StatTitle(ParamNames:TArrStr):string;
 var i:byte;
begin
  Result:='Name T';
  for I := 0 to High(ParamNames) do
   begin
    Result:=Result+' '+ParamNames[i]
           +' se'+ParamNames[i];
    if i<>High(ParamNames)
      then Result:=Result+' re'+ParamNames[i];
//           +' rse'+ParamNames[i];
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

function StatString(RezVec:array of TVector;Parameters:TArrSingle):string;
 var i:byte;
begin
  Result:=RezVec[0].Name;
  Result:=Result+' '+inttostr(round(Parameters[8]));
  for I := 0 to High(RezVec) do
   begin
    Result:=Result+' '+FloatToStrF(RezVec[i].MeanY,ffExponent,10,2)
           +' '+FloatToStrF(RezVec[i].StandartErrorY,ffExponent,10,2);
    if i<>High(RezVec)
      then Result:=Result+' '+FloatToStrF(RelativeDifference(Parameters[i],RezVec[i].MeanY),ffExponent,10,2);
//           +' '+FloatToStrF(abs(RezVec[i].StandartErrorY/Parameters[i]),ffExponent,10,2);
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
  Vec: TVector;
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

  Vec := TVector.Create;
  Vec.ReadFromFile('pssA.dat');
  for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
    CastroFitting(EvolType, Par1, Vec);
  FreeAndNil(Vec);
end;

procedure ReadEvolParResult(EvolType: TEvolutionTypeNew; ParName: string; Vec: TVector;
               FileName: string = 'ResultAll.dat');
 var StrRez:TStringList;
     EvolTypeName:string;
     ParNumber,ParTrueNumber,i:integer;
begin
  StrRez:=TStringList.Create;
  Vec.Clear;
  EvolTypeName:=EvTypeNames[EvolType];
  try
   StrRez.LoadFromFile(FileName);
   ParNumber:=SubstringNumberFromRow(ParName,StrRez[0]);
   if (ParNumber=0)
     then raise Exception.Create('Parameter is absente');
   ParTrueNumber:=SubstringNumberFromRow(ParName+'tr',StrRez[0]);

//   Vec.Name:=EvolTypeName;
   for i := 1 to StrRez.Count-1 do
    if StringDataFromRow(StrRez[i],1)=EvolTypeName then
      begin
       if ParTrueNumber=0
          then Vec.Add(Vec.Count+1,FloatDataFromRow(StrRez[i],ParNumber))
          else Vec.Add(Vec.Count+1,
                        RelativeDifference(FloatDataFromRow(StrRez[i],ParTrueNumber),
                                           FloatDataFromRow(StrRez[i],ParNumber)));
      end;
  finally
   FreeAndNil(StrRez);
  end;
end;

procedure ReadEvolAllParResult(ParName: string; VecEvol: TArrVec;
                           FileName: string = 'ResultAll.dat');
 var EvolType:TEvolutionTypeNew;
begin
 CreateVecEvol(VecEvol);
 for EvolType := Low(TEvolutionTypeNew) to High(TEvolutionTypeNew) do
   ReadEvolParResult(EvolType, ParName, VecEvol[ord(EvolType)],FileName);
end;

procedure SomethingForCastro;
// const
// par:array [0..1] of double=
//   (1.2,2);
 var Par1,Par2,Par3:TArrSingle;
     Vec:TVector;
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
//  Vec := TVector.Create;
//  ReadEvolParResult(etMABC,'rmsre',Vec);
//  showmessage(Vec.XYtoString);
//  FreeAndNil(Vec);
end;

procedure  MainParamToStringArray(FitFunction: TFFSimple;var SA:TArrStr);
begin
  SetLength(SA,0);
  FitFunction.ParameterNamesToArray(SA);
  SA[FitFunction.DParamArray.MainParamHighIndex+1]:=SA[High(SA)];
  SetLength(SA,FitFunction.DParamArray.MainParamHighIndex+2);
end;

end.
