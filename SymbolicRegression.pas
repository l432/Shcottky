unit SymbolicRegression;

interface

uses
  OlegType, OlegMaterialSamples;

const
 C_J0=17.90;

type

TDatasetPrepare=class
  private
    FTrainNumber: integer;
    FTestNumber: integer;
    FLowLimit: integer;
    FHighLimit: integer;
    FHeader: string;
    fUsedParam: TArrInteger;
    fResults: TArrSingle;
    FFileNameBegin: string;
    procedure SetTrainNumber(const Value: integer);
    procedure SetTestNumber(const Value: integer);
    procedure SetHighLimit(const Value: integer);
    procedure SetLowLimit(const Value: integer);
    procedure SetHeader(const Value: string);
    function RecordToString(const Index:integer):string;virtual;
    procedure SetFileNameBegin(const Value: string);
    procedure LastNEntriesToFile(LastN:integer;Filename:string);
    {останні LastN входжень записуються у файл з назвою Filename}
    procedure newNEntriesCreate(newN:integer);virtual;
    {створюються newN унікальних записів}
    function ResultCalculate(const Index:integer):double;virtual;
  public
   property TrainNumber:integer read FTrainNumber write SetTrainNumber;
   property TestNumber:integer read FTestNumber write SetTestNumber;
   property LowLimit:integer read FLowLimit write SetLowLimit;
   property HighLimit:integer read FHighLimit write SetHighLimit;
   property Header:string read FHeader write SetHeader;
   property FileNameBegin:string read FFileNameBegin write SetFileNameBegin;
   Constructor Create;
   procedure CreateDatasets();
   procedure CreateFullDataset();virtual;
end;

TDatasetPrepareEg_T=class(TDatasetPrepare)
 private
  fSil:TMaterial;
  function ResultCalculate(const Index:integer):double;override;
 public
  Constructor Create;
  destructor Destroy;override;
end;

TDatasetPrepareLn_Isc=class(TDatasetPrepare)
 private
  fLambda,fT:Integer;
  function RecordToString(const Index:integer):string;override;
  function ResultCalculate(const Index:integer):double;override;
 public
  Constructor Create;
end;

TDatasetPrepareJ0_T=class(TDatasetPrepare)
 private
  function ResultCalculate(const Index:integer):double;override;
 public
  Constructor Create;
end;

TParametrType=(ptInt,ptDouble,ptDoubleLn);
{можливі типи параметрів, які змінюються
ptDoubleLn - дійсний, для широкі діапазони змін і тому
використовуємо рівномірний розподіл у логарифмічному масштабі}

TDatasetPrepareNdim=class(TDatasetPrepare)
 private
  fNdim:integer;
  fParamTypes:array of TParametrType;
  fLowLimits: TArrSingle;
  fHighLimits: TArrSingle;
  fUsedParams: TArrArrSingle;
  function RecordToString(const Index:integer):string;override;
  procedure newNEntriesCreate(newN:integer);override;
  {створюються newN унікальних записів}
  function ResultCalculate(const Index:integer):double;override;
 public
  property HighLimits: TArrSingle read fHighLimits write fHighLimits;
  property LowLimits: TArrSingle read fLowLimits write fLowLimits;
  Constructor Create(Ndim:integer);
  procedure CreateFullDataset2D();
end;

TDatasetPrepareLn_IscT=class(TDatasetPrepareNdim)
 private
  fLambda:Integer;
  function RecordToString(const Index:integer):string;override;
  function ResultCalculate(const Index:integer):double;override;
 public
  Constructor Create;
end;

TDatasetPrepareMobility=class(TDatasetPrepareNdim)
 private
  fItIsMajority:Boolean;
  fItIsElectron:Boolean;
  function ResultCalculate(const Index:integer):double;override;
 public
  Constructor Create(ItIsMajority,ItIsElectron:Boolean);
end;



procedure DeepOfAbsorbtion(T:integer;FileName:string='SiAbsorb');
{записує у файл FileNameT.dat залежність
величини, оберноної до коеф. поглинання світла у кремнії
при температурі T, від довжини хвилі}

Procedure TauIntrinsic();
{розрахунок власного часу життя
(лише міжзонна та оже рекомбінації) в р-кремнії
для температурного діапазону 280-350 К
та діапазону рівнів легування 10^14 - 10^16 см^-3  }


procedure TauOnL(T:integer;Ndop:double);
{співвідношення між Ln (від 1 мкм до 300 мкм)
та часом життя електронів у p-Si }

procedure Ln_Isc();
{створюється тренувальний та тестовий набір для залежності
довжини дифузії (друга колонка) від струму короткого замикання,
поділеного на інтенсивність світла та (1-R)
(хоча насправді рахується навпаки),
L в діапазоні 5..300 мкм,
довжина хвилі 940 нм,
температура 300 К}

procedure Eg_T();
{залежність ширини забороненої зони від температури
для кремнію за формулою Варшні
діапазон зміни темпратури - 100 - 500 К}

function J0(const T:double):double;
{повертає струм насичення через діод
J0 = C*T^3*exp(-Eg/kT)
для кремнію,
Eg за формулою Passler,
С=C_J0=17.90 mA cm^-2 K^-3 (SolarEnerMatSC_101_p36)
діапазон зміни темпратури - 100 - 500 К
[J0]= mA cm^-2
}

procedure J0_T();
{залежність струму насичення через кремнієвий діод
від температури - див. попередню функцію}


procedure Ln_IscT();
{створюється тренувальний та тестовий набір для залежності
довжини дифузії (третя колонка) від температури та струму короткого замикання,
поділеного на інтенсивність світла та (1-R)
L в діапазоні 5..300 мкм,
температура в діапазоні 290 - 340 К
довжина хвилі 940 нм}


procedure Mu_TNdop(ItIsMajority,ItIsElectron:Boolean);
{створюються набори для залежності
рухливості носіїв заряду у кремнії від температури та концентрації
легуючої домішки,
T в діапазоні 77..500 K,
Ndop: (10^13 - 10^20) cm-3
[результат] = см^2 / (B c)
}


procedure Ti();
{створюється залежність температури, при якій важливою є власна
провідність для легованого кремнія від концентрації леганта}

procedure Ts(delE:double);
{створюється залежність температури виснаження леганта
з енергією іонізації delE для кремнію,
від концентрації леганта}

implementation

uses
  OlegVector, System.SysUtils, System.Math,
  System.Classes, OApproxFunction2, OlegMath;

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
{створюється тренувальний та тестовий набір для залежності
довжини дифузії (друга колонка) від струму короткого замикання,
поділеного на інтенсивність світла та (1-R)
(хоча насправді рахується навпаки),
L в діапазоні 5..300 мкм,
довжина хвилі 940 нм,
температура 300 К}
 var
   Dataset:TDatasetPrepareLn_Isc;
begin
 Dataset:=TDatasetPrepareLn_Isc.Create;
 Dataset.CreateDatasets();
 Dataset.CreateFullDataset();
 FreeAndNil(Dataset);
end;


procedure Eg_T();
{залежність ширини забороненої зони від температури
для кремнію за формулою Варшні
діапазон зміни темпратури - 100 - 500 К}
 var
     DatasetPrepare:TDatasetPrepare;
begin
 DatasetPrepare:=TDatasetPrepareEg_T.Create;
 DatasetPrepare.CreateDatasets();
 FreeAndNil(DatasetPrepare);
end;

function J0(const T:double):double;
begin
  Result:=C_J0*Power(T,3)*exp(-Silicon.Eg(T)/Kb/T);
//  Result:=C_J0*Power(T,3)*exp(-1/Kb/T);
end;

procedure J0_T();
{залежність струму насичення через кремнієвий діод
від температури - див. попередню функцію}
 var      DatasetPrepare:TDatasetPrepare;
begin
 DatasetPrepare:=TDatasetPrepareJ0_T.Create;
 DatasetPrepare.CreateDatasets();
 FreeAndNil(DatasetPrepare);
end;

procedure Ln_IscT();
{створюється тренувальний та тестовий набір для залежності
довжини дифузії (третя колонка) від температури та струму короткого замикання,
поділеного на інтенсивність світла та (1-R)
L в діапазоні 5..300 мкм,
температура в діапазоні 290 - 340 К
довжина хвилі 940 нм}
 var
   Dataset:TDatasetPrepareLn_IscT;
begin
 Dataset:=TDatasetPrepareLn_IscT.Create;
 Dataset.CreateDatasets();
 FreeAndNil(Dataset);

end;

procedure Mu_TNdop(ItIsMajority,ItIsElectron:Boolean);
{створюються набори для залежності
рухливості носіїв заряду у кремнії від температури та концентрації
легуючої домішки,
T в діапазоні 77..500 K,
Ndop: (10^13 - 10^20) cm-3
[результат] = см^2 / (B c)
}
var
   Dataset:TDatasetPrepareMobility;
begin
 Dataset:=TDatasetPrepareMobility.Create(ItIsMajority,ItIsElectron);
 Dataset.CreateDatasets();
 Dataset.CreateFullDataset2D();
 FreeAndNil(Dataset);

end;

{ TDatasetPrepare }

Constructor TDatasetPrepare.Create;
begin
 inherited Create;
 FTrainNumber:=100;
 FTestNumber:=10;
 FLowLimit:=1;
 FHighLimit:=10;
 FHeader:='x y';
 FFileNameBegin := 'File';
end;

procedure TDatasetPrepare.CreateDatasets;
begin
 newNEntriesCreate(FTrainNumber);
 LastNEntriesToFile(FTrainNumber,FFileNameBegin+'train.dat');
 newNEntriesCreate(FTestNumber);
 LastNEntriesToFile(FTestNumber,FFileNameBegin+'test.dat');
end;

procedure TDatasetPrepare.CreateFullDataset;
 var Value:integer;
begin
 Value:=FLowLimit;
 SetLength(fUsedParam,0);
 SetLength(fResults,0);
 repeat
  AddNumberToArray(Value,fUsedParam);
  AddNumberToArray(ResultCalculate(High(fUsedParam)),fResults);
  inc(Value);
 until (Value>=FHighLimit);
 LastNEntriesToFile(High(fResults)+1,FFileNameBegin+'full.dat');
end;

procedure TDatasetPrepare.LastNEntriesToFile(LastN: integer; Filename: string);
 var FistIndex,i:integer;
     SL:TStringList;
begin
 FistIndex:=High(fResults)+1-LastN;
 if FistIndex<0 then Exit;
 SL:=TStringList.Create;
 if fHeader<>'' then SL.Add(fHeader);
 for I := FistIndex to High(fResults) do
    SL.Add(RecordToString(i));
 if Filename<>'' then SL.SaveToFile(Filename);
 FreeAndNil(SL);
end;

procedure TDatasetPrepare.newNEntriesCreate(newN: integer);
 var StartIndex:integer;
     NewProbParametrValue:integer;
begin
 Randomize();
 StartIndex:=High(fResults);
 repeat
  NewProbParametrValue:=RandomAB(FLowLimit,FHighLimit);
  if IsNumberInArray(NewProbParametrValue,fUsedParam)
    then Continue
    else
     begin
      AddNumberToArray(NewProbParametrValue,fUsedParam);
      AddNumberToArray(ResultCalculate(High(fUsedParam)),fResults);
     end;
 until ((High(fResults)-StartIndex)>=newN);
end;

function TDatasetPrepare.RecordToString(const Index: integer): string;
begin
 Result:=inttostr(fUsedParam[Index])+' '
        +FloatToStrF(fResults[Index],ffExponent,6,0);
end;

function TDatasetPrepare.ResultCalculate(const Index: integer): double;
begin
 Result:=fUsedParam[Index];
end;

procedure TDatasetPrepare.SetFileNameBegin(const Value: string);
begin
  FFileNameBegin := Value;
end;

procedure TDatasetPrepare.SetHeader(const Value: string);
begin
  FHeader := Value;
end;

procedure TDatasetPrepare.SetHighLimit(const Value: integer);
begin
  FHighLimit := Value;
end;

procedure TDatasetPrepare.SetLowLimit(const Value: integer);
begin
  FLowLimit := Value;
end;

procedure TDatasetPrepare.SetTestNumber(const Value: integer);
begin
  FTestNumber := Value;
end;

procedure TDatasetPrepare.SetTrainNumber(const Value: integer);
begin
  FTrainNumber := Value;
end;

{ TDatasetPrepareEg_T }

constructor TDatasetPrepareEg_T.Create;
begin
 inherited Create;
 TrainNumber:=300;
 TestNumber:=50;
 LowLimit:=100;
 HighLimit:=500;
 Header:='T(K) Eg(eV)';
 FileNameBegin:='EgOnT';
 fSil:=TMaterial.Create(Si);
end;

destructor TDatasetPrepareEg_T.Destroy;
begin
  FreeAndNil(fSil);
  inherited;
end;

function TDatasetPrepareEg_T.ResultCalculate(const Index: integer): double;
begin
 Result:=fSil.EgT(fUsedParam[Index]);
end;

{ TDatasetPrepareLn_Isc }

constructor TDatasetPrepareLn_Isc.Create;
begin
 inherited Create;
 TrainNumber:=150;
 TestNumber:=30;
 LowLimit:=5;
 HighLimit:=300;
 Header:='Isc(A) L(mkm)';
 FileNameBegin:='LOnIsc';
 fLambda:=940;
 fT:=300;
end;

function TDatasetPrepareLn_Isc.RecordToString(const Index: integer): string;
begin
 Result:=FloatToStrF(fResults[Index],ffExponent,6,0)+' '
       + FloatToStrF(fUsedParam[Index]*1e-6,ffExponent,6,0);
end;

function TDatasetPrepareLn_Isc.ResultCalculate(const Index: integer): double;
begin
 Result:=TFFIsc_shablon.Nph(fLambda)
        *TFFIsc_shablon.Al_L(Silicon.Absorption(fLambda,fT),fUsedParam[Index]*1e-6)
end;

{ TDatasetPrepareJ0_T }

constructor TDatasetPrepareJ0_T.Create;
begin
 inherited Create;
 TrainNumber:=300;
 TestNumber:=50;
 LowLimit:=100;
 HighLimit:=500;
 Header:='T(K) J0(mAcm-2)';
 FileNameBegin:='J0OnT';
end;

function TDatasetPrepareJ0_T.ResultCalculate(const Index: integer): double;
begin
 Result:=J0(fUsedParam[Index]);
end;

{ TDatasetPrepareNdim }

constructor TDatasetPrepareNdim.Create(Ndim: integer);
 var i:integer;
begin
 inherited Create;
 fNdim:=Ndim;
 SetLength(fParamTypes,fNdim);
 SetLength(fLowLimits,fNdim);
 SetLength(fHighLimits,fNdim);
 SetLength(fUsedParams,fNdim);
 for I := 0 to High(fParamTypes) do
  begin
   fParamTypes[i]:=ptInt;
   fLowLimits[i]:=1;
   fHighLimits[i]:=10;
  end;

end;

procedure TDatasetPrepareNdim.CreateFullDataset2D;
 const Npoint=50;
 var i:integer;
     NewParametrValues,Steps:TArrSingle;
begin
// Не знаю як зробити: в загальному випадку
// невідома кількість вкладень циклів перебору змінних

 SetLength(NewParametrValues,fNdim);
 SetLength(Steps,fNdim);
 SetLength(fResults,0);
 for i := 0 to High(NewParametrValues) do
  begin
   NewParametrValues[i]:=FLowLimits[i];
   SetLength(fUsedParams[i],0);
   case fParamTypes[i] of
    ptInt:if (FHighLimits[i]-FLowLimits[i])>99
              then Steps[i]:=round((FHighLimits[i]-FLowLimits[i])/(Npoint-1))
              else Steps[i]:=1;
    ptDouble:Steps[i]:=(FHighLimits[i]-FLowLimits[i])/(Npoint-1);
    ptDoubleLn:Steps[i]:=(ln(FHighLimits[i])-ln(FLowLimits[i]))/(Npoint-1);
   end;
  end;

 repeat

  NewParametrValues[1]:=FLowLimits[1];
  repeat
   for i := 0 to High(fParamTypes) do
        AddNumberToArray(NewParametrValues[i],fUsedParams[i]);
   AddNumberToArray(ResultCalculate(High(fResults)+1),fResults);

    case fParamTypes[1] of
      ptInt,ptDouble:NewParametrValues[1]:=NewParametrValues[1]+Steps[1];
      ptDoubleLn:NewParametrValues[1]:=exp(ln(NewParametrValues[1])+Steps[1]);
    end;
  until (NewParametrValues[1]>FHighLimits[1]);
  case fParamTypes[0] of
    ptInt,ptDouble:NewParametrValues[0]:=NewParametrValues[0]+Steps[0];
    ptDoubleLn:NewParametrValues[0]:=exp(ln(NewParametrValues[0])+Steps[0]);
  end;

 until (NewParametrValues[0]>FHighLimits[0]);

 LastNEntriesToFile(High(fResults)+1,FFileNameBegin+'full.dat');

end;

procedure TDatasetPrepareNdim.newNEntriesCreate(newN: integer);
 var StartIndex,i:integer;
     NewProbParametrValues:TArrSingle;
     NumbersInArray:Boolean;
begin
 Randomize();
 SetLength(NewProbParametrValues,fNdim);
 StartIndex:=High(fResults);
 repeat
  for i := 0 to High(fParamTypes) do
   begin
     case fParamTypes[i] of
      ptInt:NewProbParametrValues[i]:=RandomAB(round(FLowLimits[i]),round(FHighLimits[i]));
      ptDouble:NewProbParametrValues[i]:=RandomAB(FLowLimits[i],FHighLimits[i]);
      ptDoubleLn:NewProbParametrValues[i]:=RandomLnAB(FLowLimits[i],FHighLimits[i]);
     end;
   end;
  NumbersInArray:=True;
  for i := 0 to High(fParamTypes) do
    NumbersInArray:= NumbersInArray
          and IsNumberInArray(NewProbParametrValues[i],fUsedParams[i]);
  if NumbersInArray
    then Continue
    else
     begin
      for i := 0 to High(fParamTypes) do
        AddNumberToArray(NewProbParametrValues[i],fUsedParams[i]);
      AddNumberToArray(ResultCalculate(High(fResults)+1),fResults);
     end;
 until ((High(fResults)-StartIndex)>=newN);
end;


function TDatasetPrepareNdim.RecordToString(const Index: integer): string;
 var i:integer;
begin
 Result:='';
 for I := 0 to High(fParamTypes) do
  if fParamTypes[i]=ptInt
    then Result:=Result+inttostr(round(fUsedParams[i][Index]))+' '
    else Result:=Result+FloatToStrF(fUsedParams[i][Index],ffExponent,6,0)+' ';
 Result:=Result+FloatToStrF(fResults[Index],ffExponent,6,0);
end;

function TDatasetPrepareNdim.ResultCalculate(const Index: integer): double;
begin
 Result:=ErResult;
end;

{ TDatasetPrepareLn_IscT }

constructor TDatasetPrepareLn_IscT.Create;
begin
 inherited Create(2);
 TrainNumber:=1000;
 TestNumber:=200;
 Header:='Isc(A) T(K) L(mkm)';
 FileNameBegin:='LOnIscT';
 fLambda:=940;
 LowLimits[0]:=5;
 HighLimits[0]:=300;
 LowLimits[1]:=290;
 HighLimits[1]:=340;
end;

function TDatasetPrepareLn_IscT.RecordToString(const Index: integer): string;
begin
 Result:=FloatToStrF(fResults[Index],ffExponent,6,0)+' '
         +inttostr(round(fUsedParams[1][Index]))+' '
         +FloatToStrF(round(fUsedParams[0][Index])*1e-6,ffExponent,3,0);
end;

function TDatasetPrepareLn_IscT.ResultCalculate(const Index: integer): double;
begin
 Result:=TFFIsc_shablon.Nph(fLambda)
        *TFFIsc_shablon.Al_L(Silicon.Absorption(fLambda,fUsedParams[1][Index]),fUsedParams[0][Index]*1e-6)
end;

{ TDatasetPrepareMobility }

constructor TDatasetPrepareMobility.Create(ItIsMajority,
  ItIsElectron: Boolean);
begin
 inherited Create(2);
 fItIsMajority:=ItIsMajority;
 fItIsElectron:=ItIsElectron;

 TrainNumber:=1000;
 TestNumber:=200;

 Header:='T(K) Nd(cm-3) Mu(cm2/Vs)';
 FileNameBegin:='Mu_';

 if fItIsElectron
   then FileNameBegin:=FileNameBegin+'n_'
   else FileNameBegin:=FileNameBegin+'p_';

 if fItIsMajority
   then FileNameBegin:=FileNameBegin+'maj'
   else FileNameBegin:=FileNameBegin+'min';


// LowLimits[0]:=200;
// HighLimits[0]:=500;
//
// LowLimits[1]:=1e13;
// HighLimits[1]:=1e19;

 LowLimits[0]:=150;
 HighLimits[0]:=550;

 LowLimits[1]:=5e12;
 HighLimits[1]:=1e20;

// LowLimits[0]:=200;
// HighLimits[0]:=500;
//
// LowLimits[1]:=1e13;
// HighLimits[1]:=1e19;


//===============================================
// LowLimits[0]:=77;
// HighLimits[0]:=273;

// LowLimits[0]:=273;
// HighLimits[0]:=500;

// LowLimits[0]:=77;
// HighLimits[0]:=500;


//----------------------------------------------

// LowLimits[1]:=1e13;
// HighLimits[1]:=1e17;

// LowLimits[1]:=1e17;
// HighLimits[1]:=1e20;

// LowLimits[1]:=1e13;
// HighLimits[1]:=1e20;

 fParamTypes[1]:=ptDoubleLn;

end;

function TDatasetPrepareMobility.ResultCalculate(const Index: integer): double;
begin
 if fItIsElectron
   then
     Result:=1e4*Silicon.mu_n(fUsedParams[0][Index],
                          fUsedParams[1][Index]*1e6,
                          fItIsMajority)
   else
     Result:=1e4*Silicon.mu_p(fUsedParams[0][Index],
                          fUsedParams[1][Index]*1e6,
                          fItIsMajority);
end;


procedure Ti();
{створюється залежність температури, при якій важливою є власна
провідність для легованого кремнія від концентрації леганта}
var Vec:TVector;
    concent:double;
    pow:integer;
begin
 Vec:=TVector.Create;
 for pow := 13 to 20 do
   begin
    concent:=Power(10,pow+6);
    Vec.Add(Power(10,pow),Ti_inSi(concent));
   end;
 Vec.WriteToFile('Ti.dat',5,'Nd Ti');

 FreeAndNil(Vec)
end;

procedure Ts(delE:double);
{створюється залежність температури виснаження леганта
з енергією іонізації delE для кремнію,
від концентрації леганта}
var Vec:TVector;
    concent:double;
    pow:integer;
begin
 Vec:=TVector.Create;
 for pow := 13 to 20 do
   begin
    concent:=Power(10,pow+6);
    Vec.Add(Power(10,pow),Ts_inSi(concent,delE));
   end;
 Vec.WriteToFile('Ts.dat',5,'Nd Ts');

// for pow:=5 to 700 do
////   Vec.Add(pow,Silicon.Nv(pow)/1e6);
//   Vec.Add(pow,ChargeCarrierConcentrationNew(pow, 1e23,0.045,True,True)/1e6);
////   Vec.Add(pow,ChargeCarrierConcentrationNew(pow, 1e20,0.045,False, True)/1e6);
//
// Vec.WriteToFile('n.dat',5,'T n');


 FreeAndNil(Vec)
end;


end.
