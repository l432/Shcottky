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
  fNpoint_in_fulldataset:integer;
  fParamTypes:array of TParametrType;
  fLowLimits: TArrSingle;
  fHighLimits: TArrSingle;
  fUsedParams: TArrArrSingle;
  fSteps:TArrSingle;
  function RecordToString(const Index:integer):string;override;
  procedure newNEntriesCreate(newN:integer);override;
  {створюються newN унікальних записів}
  function ResultCalculate(const Index:integer):double;override;
  procedure CreateStepsForFullDataset();virtual;
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


TDatasetSiPorous=class(TDatasetPrepareNdim)
 private
  function ResultCalculate(const Index:integer):double;override;
  procedure CreateStepsForFullDataset();override;
 public
  Constructor Create;
end;

TDatasetRefractiveSiPorous=class(TDatasetPrepareNdim)
 private
  fT:integer;
  function ResultCalculate(const Index:integer):double;override;
  procedure CreateStepsForFullDataset();override;
 public
  Constructor Create(T:integer);
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

procedure TC_porT();
{створюються набори для залежності теплопровідності
від поруватості та температури
}

procedure RI_porSi(T:Integer);
{створюються набори для залежності
показника заломлення поруватого кремнія
від поруватості та довжини хвилі при температурі Т,
р в діапазоні 0-80%
Lambda в діапазоні 400..1450 нм,
}

procedure Ti();
{створюється залежність температури, при якій важливою є власна
провідність для легованого кремнія від концентрації леганта}

procedure Ts(delE:double);
{створюється залежність температури виснаження леганта
з енергією іонізації delE для кремнію,
від концентрації леганта}


procedure ToDecreaseNumberCount();

function SymRegrMobilityCalculate(const T:double; const Nd:double):double;


implementation

uses
  OlegVector, System.SysUtils, System.Math,
  System.Classes, OApproxFunction2, OlegMath, Vcl.Dialogs,
  OlegVectorManipulation;

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

procedure TC_porT();
{створюються набори для залежності теплопровідності
від поруватості та температури
}
var
   Dataset:TDatasetSiPorous;
begin
 Dataset:=TDatasetSiPorous.Create();
// Dataset.CreateDatasets();
 Dataset.CreateFullDataset2D();
 FreeAndNil(Dataset);
end;

procedure RI_porSi(T:Integer);
{створюються набори для залежності
показника заломлення поруватого кремнія
від поруватості та довжини хвилі при температурі Т,
р в діапазоні 0-80%
Lambda в діапазоні 400..1450 нм,
}
var
   Dataset:TDatasetRefractiveSiPorous;
begin
 Dataset:=TDatasetRefractiveSiPorous.Create(T);
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
 fNpoint_in_fulldataset:=50;
 SetLength(fParamTypes,fNdim);
 SetLength(fLowLimits,fNdim);
 SetLength(fHighLimits,fNdim);
 SetLength(fUsedParams,fNdim);
 SetLength(fSteps,fNdim);
 for I := 0 to High(fParamTypes) do
  begin
   fParamTypes[i]:=ptInt;
   fLowLimits[i]:=1;
   fHighLimits[i]:=10;
  end;

end;

procedure TDatasetPrepareNdim.CreateFullDataset2D;
// const Npoint=50;
 var i:integer;
     NewParametrValues{,Steps}:TArrSingle;
begin
// Не знаю як зробити: в загальному випадку
// невідома кількість вкладень циклів перебору змінних

 SetLength(NewParametrValues,fNdim);
// SetLength(Steps,fNdim);
 SetLength(fResults,0);
 for i := 0 to High(NewParametrValues) do
  begin
   NewParametrValues[i]:=FLowLimits[i];
   SetLength(fUsedParams[i],0);
//   case fParamTypes[i] of
//    ptInt:if (FHighLimits[i]-FLowLimits[i])>99
//              then Steps[i]:=round((FHighLimits[i]-FLowLimits[i])/(Npoint-1))
//              else Steps[i]:=1;
//    ptDouble:Steps[i]:=(FHighLimits[i]-FLowLimits[i])/(Npoint-1);
//    ptDoubleLn:Steps[i]:=(ln(FHighLimits[i])-ln(FLowLimits[i]))/(Npoint-1);
//   end;
  end;

 CreateStepsForFullDataset();

 repeat

  NewParametrValues[1]:=FLowLimits[1];
  repeat
   for i := 0 to High(fParamTypes) do
        AddNumberToArray(NewParametrValues[i],fUsedParams[i]);
   AddNumberToArray(ResultCalculate(High(fResults)+1),fResults);

    case fParamTypes[1] of
      ptInt,ptDouble:NewParametrValues[1]:=NewParametrValues[1]+fSteps[1];
      ptDoubleLn:NewParametrValues[1]:=exp(ln(NewParametrValues[1])+fSteps[1]);
    end;
  until (NewParametrValues[1]>FHighLimits[1]*1.01);
//  showmessage(floattostr(NewParametrValues[1]));
  case fParamTypes[0] of
    ptInt,ptDouble:NewParametrValues[0]:=NewParametrValues[0]+fSteps[0];
    ptDoubleLn:NewParametrValues[0]:=exp(ln(NewParametrValues[0])+fSteps[0]);
  end;

 until (NewParametrValues[0]>FHighLimits[0]*1.01);

 LastNEntriesToFile(High(fResults)+1,FFileNameBegin+'full.dat');

end;

procedure TDatasetPrepareNdim.CreateStepsForFullDataset;
 var i:integer;
begin
 for i := 0 to fNdim-1 do
  begin
   case fParamTypes[i] of
    ptInt:if (FHighLimits[i]-FLowLimits[i])>99
              then fSteps[i]:=round((FHighLimits[i]-FLowLimits[i])/(fNpoint_in_fulldataset-1))
              else fSteps[i]:=1;
    ptDouble:fSteps[i]:=(FHighLimits[i]-FLowLimits[i])/(fNpoint_in_fulldataset-1);
    ptDoubleLn:fSteps[i]:=(ln(FHighLimits[i])-ln(FLowLimits[i]))/(fNpoint_in_fulldataset-1);
   end;
  end;
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


 LowLimits[0]:=200;
 HighLimits[0]:=500;

 LowLimits[1]:=1e13;
 HighLimits[1]:=1e19;

// LowLimits[1]:=1e16;
// HighLimits[1]:=1e19;


// LowLimits[0]:=175;
// HighLimits[0]:=525;
//
// LowLimits[1]:=5e12;
// HighLimits[1]:=5e19;

// LowLimits[0]:=150;
// HighLimits[0]:=550;
//
// LowLimits[1]:=1e12;
// HighLimits[1]:=1e20;

//  LowLimits[0]:=150;
// HighLimits[0]:=500;
//
// LowLimits[1]:=1e13;
// HighLimits[1]:=1e20;

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
// for pow := 13 to 20 do
//   begin
//    concent:=Power(10,pow+6);
//    Vec.Add(Power(10,pow),Ts_inSi(concent,delE));
//   end;
// Vec.WriteToFile('Ts.dat',5,'Nd Ts');

 for pow:=5 to 700 do
//   Vec.Add(pow,Silicon.Nv(pow)/1e6);
//   Vec.Add(pow,ChargeCarrierConcentrationNew(pow, 1e23,0.045,True,True,True)/1e6);
   Vec.Add(pow,ChargeCarrierConcentrationNew(pow, 1e23,0.045,True,True,False)/1e6);
//   Vec.Add(pow,ChargeCarrierConcentrationNew(pow, 1e20,0.045,False, True)/1e6);

 Vec.WriteToFile('Nd.dat',5,'T Nd');


 FreeAndNil(Vec)
end;


{ TDatasetSiPorous }

constructor TDatasetSiPorous.Create;
begin
 inherited Create(2);
 TrainNumber:=100;
 TestNumber:=100;
 Header:='por(%) T(K) TC(W/mK)';
 FileNameBegin:='porSi';
 LowLimits[0]:=0;
 HighLimits[0]:=80;
 LowLimits[1]:=250;
 HighLimits[1]:=1000;
end;

procedure TDatasetSiPorous.CreateStepsForFullDataset;
begin
 fSteps[0]:=2;
 fSteps[1]:=10;
end;

function TDatasetSiPorous.ResultCalculate(const Index: integer): double;
begin
  Result:=1;
end;

procedure ToDecreaseNumberCount();
 var T,Nd,NdStep:double;
     i:integer;
     Vec:TVectorTransform;
     VecEr:TVectorTransform;
     temp:string;
 const
//NN07
//       MRE='MRE=0.094   ';
//       RE_Max='REmax=1.19   ';
//       RE_Med='REmed=0.0448   ';
//       MAE='MAE=0.475   ';

//PP08
//       MRE='MRE=0.140   ';
//       RE_Max='REmax=1.488   ';
//       RE_Med='REmed=0.079   ';
//       MAE='MAE=0.313   ';

//NP10
//       MRE='MRE=0.141   ';
//       RE_Max='REmax=1.05   ';
//       RE_Med='REmed=0.084   ';
//       MAE='MAE=0.765   ';

//PN09
       MRE='MRE=0.0497   ';
       RE_Max='REmax=0.61   ';
       RE_Med='REmed=0.0274   ';
       MAE='MAE=0.119   ';
begin
 Vec:=TVectorTransform.Create;
 VecEr:=TVectorTransform.Create;

 T:=200;
 NdStep:=(19-13)/49;
 repeat
  Nd:=1e13;
  i:=0;
  repeat
//   Vec.Add(1e4*Silicon.mu_n(T,Nd*1e6,True),
//          SymRegrMobilityCalculate(T,Nd));
//   Vec.Add(1e4*Silicon.mu_p(T,Nd*1e6,True),
//          SymRegrMobilityCalculate(T,Nd));
//   Vec.Add(1e4*Silicon.mu_n(T,Nd*1e6,False),
//          SymRegrMobilityCalculate(T,Nd));
   Vec.Add(1e4*Silicon.mu_p(T,Nd*1e6,False),
          SymRegrMobilityCalculate(T,Nd));
   i:=i+1;
   Nd:=Power(10,13+i*NdStep)
  until (Nd>1e19);

  T:=T+6;
 until (T>500);
 Vec.REdata(VecEr);
 temp:=MRE+FloatToStrF(Vec.MRE*100,ffGeneral,3,3)+#10#13;
 temp:=temp+RE_Max+FloatToStrF(VecEr.MaxY*100,ffGeneral,4,4)+#10#13;
 temp:=temp+RE_Med+FloatToStrF(VecEr.MedianProperty*100,ffGeneral,4,4)+#10#13;
 for I := 0 to VecEr.HighNumber do
   VecEr.Y[i]:=VecEr.Y[i]*VecEr.X[i];
 temp:=temp+MAE+FloatToStrF(VecEr.MeanY,ffGeneral,4,4);
 ShowMessage(temp);

 FreeAndNil(VecEr);
 FreeAndNil(Vec);
end;

function SymRegrMobilityCalculate(const T:double; const Nd:double):double;
 var Tn,Ndn,Mul1,Mul2:double;
 const
////NN07
////  C1=1413.197;
////  P1=2.2508056;
////  P2=0.721221;
////  P3=0.58024335;
////  C2=0.8727662203;
////  C3=0.0728198954391157;
////  C4=0.21521291;
////  C5=10.496482;
////  C6=1.3418822;
//  C1=1413.2;
//  P1=2.2508;
//  P2=0.7212;
//  P3=0.580;
//  C2=0.873;
//  C3=0.0727;
//  C4=0.215;
//  C5=10.5;
//  C6=1.342;
//begin
//  Tn:=T/300;
//  Ndn:=Nd/1e17;
//  Mul1:=Power(Ndn/(C2*Tn+C3),P2);
//  Mul2:=C4*Power(Ndn,P3)+C5*Tn-C6;
//  Result:=(Ndn+C1)
//   /(Power(Tn,P1)+(Mul1*Mul2)/(Mul1+Mul2));

////PP08
//// P1=0.448615;
//// P2=2.2504785;
//// P3=0.7587021;
//// P4=0.7545584;
//// P5=0.1669551;
//// C1=469.99396;
//// C2=0.577894117790871;
//// C3=2.6517315;
//
// P1=0.448;
// P2=2.2505;
// P3=0.7587;
// P4=0.755;
// P5=0.1669;
// C1=470;
// C2=0.578;
// C3=2.652;
//begin
//  Tn:=T/300;
//  Ndn:=Nd/1e17;
//  Mul1:=Power(Ndn,P3)*Power(Tn,-P4)*C2;
//  Mul2:=C3*Tn*Power(Ndn,P5);
//  Result:=Power(Ndn,P1)
//   +C1/(Power(Tn,P2)+Mul1*Mul2/(Mul1+Mul2));

//NP10
//   C1=26.3181184369889;
//   C2=191.78508;
//   C3=1412.3245;
//   C4=5.6990414;
//   C5=0.07073425;
//   C6=1.92196991182138;
//   P1=0.6221507;
//   P2=2.2496324;
//   P3=0.1029627;
//   P4=0.716149;

//   C1=26.3;
//   C2=192;
//   C3=1412.3;
//   C4=5.7;
//   C5=0.071;
//   C6=1.92;
//   P1=0.62;
//   P2=2.25;
//   P3=0.103;
//   P4=0.717;
//
//begin
//  Tn:=T/300;
//  Ndn:=Nd/1e17;
//  Mul1:=C4*Power(Ndn,P3)*Tn;
//  Mul2:=C6*Power((Ndn/(Tn+C5)),P4);
//  Result:=C1*Power((Ndn/(Ndn+C2)),P1)
//  +C3/(Power(Tn,P2)+Mul1*Mul2/(Mul1+Mul2));

//PN09
//  C1=0.0225809909822258;
//  C2=0.62785673;
//  C3=113.563966230219;
//  C4=0.156170722587861;
//  C5=1.15078960427592;
//  C6=4.2095237;
//  P1=0.76547503;
//  P2=2.9405906;
//  P3=1.1768336;
//  P4=0.60845184;
//  P5=1.1430243;

  C1=0.0226;
  C2=0.63;
  C3=113.56;
  C4=0.15617;
  C5=1.151;
  C6=4.21;
  P1=0.76547;
  P2=2.940;
  P3=1.177;
  P4=0.6085;
  P5=1.143;

begin
  Tn:=T/300;
  Ndn:=Nd/1e17;
  Mul1:=Power(Ndn,P4);
  Mul2:=Power(Tn,P5);
  Result:=C1*Ndn*Ln(Tn)/(Ln(Tn)+C2)
   +C3/Power(C4*Power(Tn,P2)+Power(Mul1*Mul2/(C5*Mul1+C6*Mul2),P3),P1);
end;


{ TDatasetRefractiveSiPorous }

constructor TDatasetRefractiveSiPorous.Create(T: integer);
begin
 inherited Create(2);
 fT:=T;
 TrainNumber:=600;
 TestNumber:=300;
 Header:='por(%) Lambda(nm) RI';
 FileNameBegin:='RIporSi'+inttostr(T);

 LowLimits[0]:=0;
 HighLimits[0]:=80;
 LowLimits[1]:=400;
 HighLimits[1]:=1440;

end;

procedure TDatasetRefractiveSiPorous.CreateStepsForFullDataset;
begin
 fSteps[0]:=2;
 fSteps[1]:=10;
end;

function TDatasetRefractiveSiPorous.ResultCalculate(
  const Index: integer): double;
  var A:double;
      p,nsi2:double;
begin
 p:=fUsedParams[0][Index]/100;
 nsi2:=sqr(Silicon.RefractiveIndex(fUsedParams[1][Index],fT));
 A:=3*nsi2*P-2*nsi2-3*P+1;
 Result:=sqrt((sqrt(sqr(A)+8*nsi2)-A)/4)
// A:=(1-p)*(nsi2-1)/(nsi2+2);
// showmessage(floattostr(p-2*A));
// Result:=sqrt((p-2*A)/(A+p));
end;

end.
