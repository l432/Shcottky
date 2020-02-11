unit OApproxNew;

interface

uses
  IniFiles, OlegApprox, OlegVector, OlegType,
  OlegVectorManipulation, TeEngine, OlegTypePart2,
  Forms, FrameButtons, OlegFunction, Classes, OlegMathShottky;

//uses OlegType,Dialogs,SysUtils,Math,Forms,FrApprPar,Windows,
//      Messages,Controls,FrameButtons,IniFiles,ExtCtrls,Graphics,
//      OlegMath,ApprWindows,StdCtrls,FrParam,Series,Classes,
//      OlegGraph,OlegMaterialSamples,OlegFunction,OlegDefectsSi,
//      OlegVector;
//
//const
//  FunctionDiod='Diod';
//  FunctionPhotoDiod='PhotoDiod';
//  FunctionDiodLSM='Diod, LSM';
//  FunctionPhotoDiodLSM='PhotoDiod, LSM';
//  FunctionDiodLambert='Diod, Lambert';
//  FunctionPhotoDiodLambert='PhotoDiod, Lambert';
//  FunctionDDiod='D-Diod';
//  FunctionPhotoDDiod='Photo D-Diod';
//  FunctionOhmLaw='Ohm law';
//  FuncName:array[0..62]of string=
//           ('None','Linear',FunctionOhmLaw,'Quadratic','Exponent','Smoothing',
//           'Median filtr','Noise Smoothing','Derivative','Gromov / Lee','Ivanov',
//           FunctionDiod,FunctionPhotoDiod,FunctionDiodLSM,FunctionPhotoDiodLSM,
//           FunctionDiodLambert,FunctionPhotoDiodLambert,'Two Diod',
//           'Two Diod Full','D-Gaussian','Patch Barrier',
//           FunctionDDiod, FunctionPhotoDDiod,'Tunneling',
//           'Two power','TE and SCLC on V',
//           'TE and SCLC on V (II)','TE and SCLC on V (III)','TE reverse',
//           'TE and SCLC on 1/kT','TE and SCLCexp on 1/kT',
//           'TEstrict and SCLCexp on 1/kT','TE and TAHT on 1/kT',
//           'Brailsford on T','Brailsford on w',
//           'Phonon Tunneling on 1/kT','Phonon Tunneling on V',
//           'PAT and TE on 1/kT','PAT and TE on V',
//           'PAT and TEsoft on 1/kT','Tunneling trapezoidal','Lifetime in SCR',
//           'Tunneling diod forward','Illuminated tunneling diod',
//           'Tunneling diod revers','Tunneling diod revers with Rs',
//           'Barrier height',
//           'T-Diod','Photo T-Diod','Shot-circuit Current',
//           'D-Diod-Tau','Photo D-Diod-Tau','Tau DAP','Tau Fei-FeB',
//           'Rsh vs T','Rsh,2 vs T','Variated Polinom','Mobility',
//           'n vs T (donors and traps)',
//           'Ideal. Factor vs T & N_B & N_Fe','Ideal. Factor vs T & N_B',
//           'Ideal. Factor vs T','IV thin SC');
//  Voc_min=0.0002;
//  Isc_min=1e-11;
//
//
type

  TVar_RandNew=(vr_lin,vr_log,vr_const);
  {��� ������, �� ���������������� � ����������� �������,
  norm - ���������� �������� �����
  logar - ���������� �������� ��������� �����
  �ons - ����� ���������� ������}
//  TArrVar_Rand=array of TVar_Rand;
//  PTArrVar_Rand=^TArrVar_Rand;

  TEvolutionTypeNew= //����������� �����, ���� ��������������� ��� ������������
    (etDE, //differential evolution
     etMABC, // modified artificial bee colony
     etTLBO,  //teaching learning based optimization algorithm
     etPSO    // particle swarm optimization
     );
  {}
  TFitnessType=
   (ftSR,//the sum of squared residuals �������� ����������� �����
    ftRSR,//the sum relative of squared residuals ����������� ����� � �������� �������
    ftAR,//���� ������ ������
    ftRAR//���� ������ �������� ������
   );

  TRegulationType=(rtL1,rtL2);

const
 Var_RandNames:array[TVar_RandNew]of string=
           ('Normal','Logarithmic','Constant');


 EvTypeNames:array[TEvolutionTypeNew]of string=
         ('DE','MABC','TLBO','PSO');

type

TOIniFileNew=class (TIniFile)
public
  function ReadRand(const Section, Ident: string): TVar_RandNew; virtual;
  procedure WriteRand(const Section, Ident: string; Value: TVar_RandNew); virtual;
  function ReadEvType(const Section, Ident: string): TEvolutionTypeNew; virtual;
  procedure WriteEvType(const Section, Ident: string; Value: TEvolutionTypeNew); virtual;
  function ReadFitType(const Section, Ident: string): TFitnessType; virtual;
  procedure WriteFitType(const Section, Ident: string; Value: TFitnessType); virtual;
  function ReadRegType(const Section, Ident: string): TRegulationType; virtual;
  procedure WriteRegType(const Section, Ident: string; Value: TRegulationType); virtual;
end;

TFFParameter=class
  protected
  public
   procedure FormPrepare(Form:TForm);virtual;abstract;
   procedure UpDate;virtual;abstract;
   procedure FormClear;virtual;abstract;
   Procedure WriteToIniFile;virtual;abstract;
   Procedure ReadFromIniFile;virtual;abstract;
   function IsReadyToFitDetermination:boolean;virtual;abstract;
end;

TWindowShow=class
  protected
   fForm:TForm;
   fButtons:TFrBut;
   procedure CreateForm;
   procedure UpDate;virtual;
   procedure AdditionalFormClear;virtual;
   procedure AdditionalFormPrepare;virtual;
  public
   procedure Show;
 end;


TFFWindowShow=class(TWindowShow)
  protected
   fPS:TFFParameter;
//   fForm:TForm;
//   fButtons:TFrBut;
  public
//   procedure Show;virtual;abstract;
   constructor Create(PS:TFFParameter);
end;

TFitFunctionNew=class(TObject)
{����������� ���� ��� ������������,
�� ���� ���������� ���������}
private
 FName:string;//��'� �������
 FCaption:string; // ���� �������
// FPictureName:string;//��'�  ������� � ��������, �� ������������� FName+'Fig';
// fHasPicture:boolean;//�������� ��������
// fDataToFit:TVectorTransform; //��� ��� ������������
 fIsReadyToFit:boolean; //True, ���� ��� ������ ��� ���������� ������������
 fDiapazon:TDiapazon; //��� � ���� ���������� ������������
 fConfigFile:TOIniFileNew;//��� ������ � .ini-������
 fFileHeader:string;
 {����� ������� � ���� � ������������ ������������,
 �� ����������� ��������� FittingToGraphAndFile}
 fParameter:TFFParameter;
 fWShow:TFFWindowShow;
 fDigitNumber:byte;
 //������� ����, �� ���������� ��� ����� �����, �� ������������� 8
 fFileSuffix:string;
 //��, �� �������� �� ���� ����� ��� ����� ����������, �� ������������� 'fit'
 procedure DataContainerCreate;virtual;
 procedure DataContainerDestroy;virtual;

 procedure ParameterDestroy;virtual;
// procedure RealFitting;virtual;//abstract;
 procedure DataPreraration(InputFileName:string);overload;
 function FittingBegin:boolean;
protected
 fResultsIsReady:boolean; //True, ���� ������������ ����� ��������
 fHasPicture:boolean;//�������� ��������
 fDataToFit:TVectorTransform; //��� ��� ������������
 FPictureName:string;//��'�  ������� � ��������, �� ���������� FName+'Fig';
 ftempVector: TVectorShottky;//��������� �������
 procedure AccessorialDataCreate;virtual;
 procedure AccessorialDataDestroy;virtual;
 function ParameterCreate:TFFParameter;virtual;
 procedure RealFitting;virtual;abstract;
 Procedure RealToFile;virtual;
 procedure SetNameCaption(FunctionName,FunctionCaption:string);
 procedure NamesDefine;virtual;abstract;
 procedure TuningAfterReadFromIni;virtual;
 procedure TuningBeforeAccessorialDataCreate;virtual;
 function RealFinalFunc(X:double):double;virtual;
 procedure DataPreraration(InputData: TVector);overload;virtual;
 procedure RealToGraph (Series: TChartSeries);virtual;
 procedure VariousPreparationBeforeFitting;virtual;
public
 FittingData:TVector;
 property DataToFit:TVectorTransform read fDataToFit;
 property Name:string read FName;
 property PictureName:string read FPictureName;
 property Caption:string read FCaption;
 property ResultsIsReady:boolean read fResultsIsReady;
// property Xname:TArrStr read FXname;
 property HasPicture:boolean read fHasPicture;
 property IsReadyToFit:boolean read fIsReadyToFit;
 property Diapazon:TDiapazon read fDiapazon;
 property ConfigFile:TOIniFileNew read fConfigFile;
 property DigitNumber:byte read fDigitNumber write fDigitNumber;
 property FileSuffix:string read fFileSuffix write fFileSuffix;
// Constructor Create(FunctionName,FunctionCaption:string);//overload;
 Constructor Create;//virtual;//overload;
 destructor Destroy;override;
 procedure SetParametersGR;virtual;
 Procedure IsReadyToFitDetermination;//virtual;
 {�� ��������� ���� �����������, �� ����� ��� ��
 ������������}
// Procedure WriteToIniFile;virtual;
 {������ ��� � ini-����, � ����� ���� - ��� fDiapazon}
 Procedure Fitting (InputData:TVector);overload;//virtual;abstract;
 Procedure Fitting (InputFileName:string);overload;//virtual;abstract;
 Procedure FittingToGraphAndFile(InputData:TVector;
              Series: TChartSeries);virtual;
 Function FinalFunc(X:double):double;
 {������������ �������� ������������ ������� �
 ����� � �������� �;
 ��� ResultsIsReady=False ������� ErResult}
 Procedure DataToStrings(OutStrings:TStrings);virtual;
 {���������� � OutStrings ���������� ������������...
 ���������� ����� ��������� ����� �� ������������ �������}
 end;   // TFitFunctionNew=class

//--------------------------------------------------------------------

TFFWindowShowBase=class(TFFWindowShow)
 private
  fFF:TFitFunctionNew;
 protected
  procedure UpDate;override;
  procedure AdditionalFormClear;override;
  procedure AdditionalFormPrepare;override;
//  procedure CreateForm;
 public
  constructor Create(FF:TFitFunctionNew);
//  procedure Show;override;
end;



////----------------------------------------------
//TFitSumFunction=class(TFitVoltageIsUsed)
//{��� �������, �� � ����� ���� ����� �
//������� ��� �������� ������������ � ����
//������ ����� ���������� ����� ��������}
//private
// fSumFunctionIsUsed:boolean;
// {�� ���������� - False,
// ��� ��������������� �������������� � ���� ����������
// ������� ��� ���������� � �reate ������ �� True}
// Constructor Create(FunctionName,FunctionCaption:string;
//                     Npar,Nvar:byte);
// Function Func(Parameters:TArrSingle):double; override;
// Function Sum1(Parameters:TArrSingle):double; virtual;
// Function Sum2(Parameters:TArrSingle):double; virtual;
//// Function StringToFile(InputData:PVector;Number:integer;OutputData:TArrSingle;
////              Xlog,Ylog:boolean):string;override;
// Function StringToFile(InputData:TVector;Number:integer;OutputData:TArrSingle;
//              Xlog,Ylog:boolean):string;override;
//public
//end; //TFitSumFunction=class(TFitVoltageIsUsed)
//
////----------------------------------------------
//

////---------------------------------------------
//TFitFunctEvolution=class (TFitAdditionParam)
//{��� �������, �� ������������ ����������
//�� ��������� ����������� ������}
//private
// FXmin:TArrSingle; //������� �������� ������ ��� �����������
// FXmax:TArrSingle; //���������� �������� ������ ��� �����������
// FXminlim:TArrSingle; //������� �������� ������ ��� ������������ ������
// FXmaxlim:TArrSingle; //���������� �������� ������ ��� ������������ ������
// FEvType:TEvolutionType; //����������� �����,���� ��������������� ��� ������������
// fY:double;//���� ��� ��������� �������� Y � �����, �� ��������������
// Constructor Create(FunctionName,FunctionCaption:string;
//                     Npar,Nvar,NaddX:byte);
// Procedure RealReadFromIniFile;override;
// {������������� ����� ��� � ini-�����, � ����� ���� - �� ����}
// Procedure RealWriteToIniFile;override;
// {������������� ������ ��� � ini-����, � ����� ���� - �� ����}
// Procedure FIsNotReadyDetermination;override;
// Procedure GREvTypeToForm(Form:TForm);
// {��������� �� ����� ��� ��������� �����������
// ��������, ���'������ � �����
// ������������ ������ }
// Procedure GRElementsToForm(Form:TForm);override;
// Procedure GRSetValueEvType(Component:TComponent;ToForm:boolean);
// {��� ��� ��� ������������ ������}
// Procedure GRSetValueParam(Component:TComponent;ToForm:boolean);override;
// Procedure GRRealSetValue(Component:TComponent;ToForm:boolean);override;
//// Procedure TrueFitting (InputData:PVector;var OutputData:TArrSingle); override;
// Procedure TrueFitting (InputData:TVector;var OutputData:TArrSingle); override;
// Procedure PenaltyFun(var X:TArrSingle);
// {��������� ������ �������� ��������� � ����� X,
// �� ����������� ��� ������������ ������������ ��������,
// ��������� �� �������� �������� �������� -
// ����� �� ������ FXminlim �� FXmaxlim}
//// Function FitnessFunc(InputData:Pvector; OutputData:TArrSingle):double;overload;virtual;
// Function FitnessFunc(InputData:TVector; OutputData:TArrSingle):double;{overload;}virtual;
// {������� ������� ��� ������ ����� ������������
// ����� � InputData � ������������� OutputData,
// ��������� - ����������� �����}
// Function Summand(OutputData:TArrSingle):double;virtual;
// {���������� ������� � ������� �������}
// Function Weight(OutputData:TArrSingle):double;virtual;
// {���������� ���� ������� � ������� �������}
// Procedure VarRand(var X:TArrSingle);
// {���������� ����� ���� �������� ������
// ������  � � ������� �� FXmin �� FXmax}
//// Procedure  EvFitInit(InputData:PVector;var X:TArrArrSingle; var Fit:TArrSingle);overload;
// Procedure  EvFitInit(InputData:TVector;var X:TArrArrSingle; var Fit:TArrSingle);//overload;
// {��������� ������������ ���������� ������� � �
// �� ���������� ���������� ������� ������� �������}
// Procedure EvFitShow(X:TArrArrSingle; Fit:TArrSingle; Nit,Nshow:integer);
// {��������� ���� ������� �� ��� �� ��� ���������� ������������,
// ���� Nit ������ Nshow}
//// Procedure MABCFit (InputData:PVector;var OutputData:TArrSingle);overload;
// Procedure MABCFit (InputData:TVector;var OutputData:TArrSingle);//overload;
//  {�������������� ��� � ������ InputData �� �������
//  modified artificial bee colony;
//  ���������� ������������ ��������� � OutputData}
//// Procedure PSOFit (InputData:PVector;var OutputData:TArrSingle);overload;
// Procedure PSOFit (InputData:TVector;var OutputData:TArrSingle);//overload;
//  {�������������� ��� � ������ InputData �� �������
//  particle swarm optimization;
//  ���������� ������������ ��������� � OutputData}
//// Procedure DEFit (InputData:PVector;var OutputData:TArrSingle);overload;
// Procedure DEFit (InputData:TVector;var OutputData:TArrSingle);//overload;
//  {�������������� ��� � ������ InputData �� �������
//  differential evolution;
//  ���������� ������������ ��������� � OutputData}
//// Procedure TLBOFit (InputData:PVector;var OutputData:TArrSingle);overload;
// Procedure TLBOFit (InputData:TVector;var OutputData:TArrSingle);//overload;
//  {�������������� ��� � ������ InputData �� �������
//  teaching learning based optimization;
//  ���������� ������������ ��������� � OutputData}
//public
//end; // TFitFunctEvolution=class (TFitAdditionParam)
//
////-----------------------------------------
//TDiod=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
// Function RealFunc(DeterminedParameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TDiod=class (TFitFunctEvolution)
//
//TDiodTun=class (TFitFunctEvolution)
//{I=I0*exp(A*(V-IRs)+(V-IRs)/Rsh}
//private
// Function Func(Parameters:TArrSingle):double; override;
// Function RealFunc(DeterminedParameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TDiodTun=class (TFitFunctEvolution)
//
//TTunRevers=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//// Procedure BeforeFitness(InputData:Pvector);override;
// Procedure BeforeFitness(InputData:TVector);override;
//end; // TTunRevers=class (TFitFunctEvolution)
//
//TTunReversRs=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//// Procedure BeforeFitness(InputData:Pvector);override;
//end; // TTunRevers=class (TFitFunctEvolution)
//
//
//TPhotoDiod=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
// Function RealFunc(DeterminedParameters:TArrSingle):double; override;
// Function Weight(OutputData:TArrSingle):double;override;
//public
// Constructor Create;
//end; //  TPhotoDiod=class (TFitFunctEvolution)
//
//TPhotoDiodTun=class (TFitFunctEvolution)
//{I=I0*exp(A*(V-IRs)+(V-IRs)/Rsh}
//private
// Function Func(Parameters:TArrSingle):double; override;
// Function RealFunc(DeterminedParameters:TArrSingle):double; override;
// Function Weight(OutputData:TArrSingle):double;override;
//// Procedure AddParDetermination(InputData:PVector;
////                               var OutputData:TArrSingle); override;
// Procedure AddParDetermination(InputData:TVector;
//                               var OutputData:TArrSingle); override;
// Procedure CreateFooter;override;
//public
// Constructor Create;
//end; //  TPhotoDiodTun=class (TFitFunctEvolution)
//
//TDiodTwo=class (TFitFunctEvolution)
//{I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp(V/n2kT)-1]}
//private
// Function Sum1(Parameters:TArrSingle):double; override;
// Function Sum2(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TDiodTwo=class (TFitFunctEvolution)
//
//TDiodTwoFull=class (TFitFunctEvolution)
//{I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp((V-IRs2)/n2kT)-1]}
//private
// Function Sum1(Parameters:TArrSingle):double; override;
// Function Sum2(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; //TDiodTwoFull=class (TFitFunctEvolution)
//
//TDGaus=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
// Function Weight(OutputData:TArrSingle):double;override;
//public
// Constructor Create;
//end; //TDGaus=class (TFitFunctEvolution)
//
//TLinEg=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
// Function Weight(OutputData:TArrSingle):double;override;
//public
// Constructor Create;
//end; //TLinEg=class (TFitFunctEvolution)
//
//TTauG=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
//// Function Weight(OutputData:TArrSingle):double;override;
//public
// Constructor Create;
//end; //TTauG=class (TFitFunctEvolution)
//
//TTwoPower=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; //TTwoPower=class (TFitFunctEvolution)
//
//TMobility=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; //TMobility=class (TFitFunctEvolution)
//
//TElectronConcentration=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
// Function Weight(OutputData:TArrSingle):double;Override;
//public
// Constructor Create;
//end; //TElectronConcentration=class (TFitFunctEvolution)
//
//
//TnFeBPart=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
// Function Weight(OutputData:TArrSingle):double;Override;
//public
// Constructor Create;
//end;
//
//
//TIV_thin=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
//// Function Weight(OutputData:TArrSingle):double;Override;
//// Function FitnessFunc(InputData:Pvector; OutputData:TArrSingle):double;override;
// Function FitnessFunc(InputData:TVector; OutputData:TArrSingle):double;override;
//// Procedure RealToFile (InputData:PVector; var OutputData:TArrSingle;
////              Xlog,Ylog:boolean; suf:string);override;
//// Function StringToFile(InputData:PVector;Number:integer;OutputData:TArrSingle;
////              Xlog,Ylog:boolean):string;override;
// Function StringToFile(InputData:TVector;Number:integer;OutputData:TArrSingle;
//              Xlog,Ylog:boolean):string;override;
//// Procedure RealToGraph (InputData:PVector; var OutputData:TArrSingle;
////              Series: TLineSeries;
////              Xlog,Ylog:boolean; Np:Word); override;
// Procedure RealToGraph (InputData:TVector; var OutputData:TArrSingle;
//              Series: TLineSeries;
//              Xlog,Ylog:boolean; Np:Word); override;
// Procedure CreateFooter;override;
//// Procedure AddParDetermination(InputData:PVector;
////                               var OutputData:TArrSingle); override;
// Procedure AddParDetermination(InputData:TVector;
//                               var OutputData:TArrSingle); override;
//
//
//public
//// Function Deviation (InputData:PVector;OutputData:TArrSingle):double;override;
// Function Deviation (InputData:TVector;OutputData:TArrSingle):double;override;
// Constructor Create;
//end;
//
//TManyArgumentsFitEvolution=class (TFitFunctEvolution)
//private
// fFileName:string;
// fSL:TStringList;
// fCAN:integer;
// {fCurrentArgumentsNumber}
// fAllArguments:array of array of double;
// fArgumentsName:array of string;
// fArgumentNumber:byte;
//// fFunctionColumnInFile:byte;
// procedure Initiation;
// procedure DataReading;
// procedure DataCorrection();virtual;
// function ColumnsTitle():string;
//
//// Function FitnessFunc(InputData:Pvector; OutputData:TArrSingle):double;override;
// Function FitnessFunc(InputData:TVector; OutputData:TArrSingle):double;override;
//// Procedure BeforeFitness(InputData:Pvector);override;
// Procedure BeforeFitness(InputData:TVector);override;
//// Procedure RealToFile (InputData:PVector; var OutputData:TArrSingle;
////              Xlog,Ylog:boolean; suf:string);override;
// Procedure RealToFile (InputData:TVector; var OutputData:TArrSingle;
//              Xlog,Ylog:boolean; suf:string);override;
//// Procedure RealToGraph (InputData:PVector; var OutputData:TArrSingle;
////              Series: TLineSeries;
////              Xlog,Ylog:boolean; Np:Word); override;
// Procedure RealToGraph (InputData:TVector; var OutputData:TArrSingle;
//              Series: TLineSeries;
//              Xlog,Ylog:boolean; Np:Word); override;
// procedure AditionalRealToFile(OutputData:TArrSingle);virtual;
//// Procedure CreateFooter;override;
//public
// Constructor Create(FunctionName,FunctionCaption:string;
//                     Npar,Nvar,NaddX,ArgNum{,FCIF}:byte;
//                     FileName:string='');
// procedure Free;
//// Function Deviation (InputData:PVector;OutputData:TArrSingle):double;override;
// Function Deviation (InputData:TVector;OutputData:TArrSingle):double;override;
//end; //TManyArgumentsFitEvolution=class (TFitFunctEvolution)
//
////Tn_FeB=class (TFitFunctEvolution)
//Tn_FeB=class(TManyArgumentsFitEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
// procedure AditionalRealToFile(OutputData:TArrSingle);override;
// public
// Constructor Create(FileName:string='');
//end; //Tn_FeB=class (TFitFunctEvolution)
//
//Tn_FeBNew=class(TManyArgumentsFitEvolution)
//private
// procedure DataCorrection();override;
// Function Func(Parameters:TArrSingle):double; override;
// procedure AditionalRealToFile(OutputData:TArrSingle);override;
//public
// Constructor Create(FileName:string='');
//end; //Tn_FeBNew=class(TManyArgumentsFitEvolution)
//
//TTauDAP=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
//// Function Weight(OutputData:TArrSingle):double;override;
//public
// Constructor Create;
//end; //TTauDAP=class (TFitFunctEvolution)
//
//TRsh_T=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
// class Function Rsh_T(T,A,Et,qUs:double;U0:double=0):double;
//end; //TRsh_T=class (TFitFunctEvolution)
//
//
//TRsh2_T=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; //TRsh_T=class (TFitFunctEvolution)
//
//
//TDoubleDiodAbstract=class (TFitFunctEvolution)
//  private
//   fFunc:TFun_IV;
//   Procedure CreateFooter;override;
//   Procedure Hook();virtual;
////   Function FitnessFunc(InputData:Pvector; OutputData:TArrSingle):double;override;
//   Function FitnessFunc(InputData:TVector; OutputData:TArrSingle):double;override;
//   Function Func(Parameters:TArrSingle):double; override;
//   Function RealFunc(DeterminedParameters:TArrSingle):double; override;
////   Procedure BeforeFitness(InputData:Pvector);override;
//   Procedure BeforeFitness(InputData:TVector);override;
// public
//end;  // TDoubleDiodAbstract=class (TFitFunctEvolution)
//
//
//TDoubleDiod=class (TDoubleDiodAbstract)
//{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]+(V-IRs)/Rsh}
//private
//public
// Constructor Create;
//end; // TDoubleDiodo=class (TDoubleDiodAbstract)
//
//TDoubleDiodTau=class (TDoubleDiod)
//{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]+(V-IRs)/Rsh
//I01 �� I02 ����������� ����� ���� ����� -
//���������������� ���������� DiodPN}
//private
// Procedure Hook;override;
//public
//end; // TDoubleDiodTau=class (TDoubleDiod)
//
//
//TDoubleDiodLight=class (TDoubleDiodAbstract)
//{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]
//         +(V-IRs)/Rsh-Iph}
//private
//public
// Constructor Create;
//// Procedure AddParDetermination(InputData:PVector;
////                               var OutputData:TArrSingle); override;
// Procedure AddParDetermination(InputData:TVector;
//                               var OutputData:TArrSingle); override;
//end; // TDoubleDiodLight=class (TDoubleDiodAbstract)
//
//TDoubleDiodTauLight=class (TDoubleDiodLight)
//{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]
//         +(V-IRs)/Rsh-Iph
//I01 �� I02 ����������� ����� ���� ����� -
//���������������� ���������� DiodPN}
//private
// Procedure Hook;override;
//public
//end; // TDoubleDiodTauLight=class (TDoubleDiodLight)
//
//
//TTripleDiod=class (TFitFunctEvolution)
//{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]+
//    I03[exp((V-IRs)/n3kT)-1]+(V-IRs)/Rsh}
//private
// Function Func(Parameters:TArrSingle):double; override;
// Function RealFunc(DeterminedParameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TTripleDiod=class (TFitFunctEvolution)
//
//TTripleDiodLight=class (TFitFunctEvolution)
//{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]
//          I03[exp((V-IRs)/n3kT)-1]
//         +(V-IRs)/Rsh-Iph}
//private
// Function Func(Parameters:TArrSingle):double; override;
// Function RealFunc(DeterminedParameters:TArrSingle):double; override;
// Function Weight(OutputData:TArrSingle):double;override;
//// Procedure AddParDetermination(InputData:PVector;
////                               var OutputData:TArrSingle); override;
// Procedure AddParDetermination(InputData:TVector;
//                               var OutputData:TArrSingle); override;
// Procedure CreateFooter;override;
//public
// Constructor Create;
//end; // TTripleDiodLight=class (TFitFunctEvolution)
//
//
//TNGausian=class (TFitFunctEvolution)
//private
// Function Func(Parameters:TArrSingle):double; override;
//// Procedure BeforeFitness(InputData:Pvector);override;
// Procedure BeforeFitness(InputData:TVector);override;
//public
// Constructor Create(NGaus:byte);
//end; // TNGausian=class (TFitFunctEvolution)
//
//TTunnel=class (TFitFunctEvolution)
//{I0*exp(-A*(B+x)^0.5)}
//private
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; //TTunnel=class (TFitFunctEvolution)
//
//TTunnelFNmy=class (TFitFunctEvolution)
//{I(V)=I0*exp(-4/3h (2mq)^0.5 d/(nu V) [(Uo + nu V)^3/2-Uo^3/2])
//����������� ����� ��������������� ���'�� ������� d,
//���������, �� �� ���'�� ���� (nu V) �� ����������
//������� V, � ��� ������� ���'�� �����������
//������� Uo}
//private
//// Function Weight(OutputData:TArrSingle):double;override;
//// Function Summand(OutputData:TArrSingle):double;override;
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; //TTunnelFNmy=class (TFitFunctEvolution)
//
//TPower2=class (TFitFunctEvolution)
//{A1*(x^m1 + A2*x^m2)}
//private
// Function Sum1(Parameters:TArrSingle):double; override;
// Function Sum2(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//// Procedure BeforeFitness(InputData: Pvector);override;
// Procedure BeforeFitness(InputData: TVector);override;
//end; //TPower2=class (TFitFunctEvolution)
//
//TTEandSCLC_kT1=class (TFitFunctEvolution)
//{I(1/kT) = I01*T^2*exp(-E1/kT)+I02*T^m*exp(-E2/kT)
//m- ���������}
//private
// Function Func(Parameters:TArrSingle):double; override;
// Function Sum1(Parameters:TArrSingle):double; override;
// Function Sum2(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TTEandSCLC_kT1=class (TFitFunctEvolution)
//
//
//
//TTEandSCLCexp_kT1=class (TFitFunctEvolution)
//{ I(1/kT)=I01*T^2*exp(-E/kT)+I02*T^(m)*A^(-300/T)
//��������� �� x=1/(kT)}
//private
// Function Sum1(Parameters:TArrSingle):double; override;
// Function Sum2(Parameters:TArrSingle):double; override;
// Function Weight(OutputData:TArrSingle):double;override;
// Function Summand(OutputData:TArrSingle):double;override;
//public
// Constructor Create;
//end; // TTEandSCLCexp_kT1=class (TFitFunctEvolution)
//
//TTEandTAHT_kT1=class (TFitFunctEvolution)
//{I(1/kT)=I01*T^2*exp(-E/kT)+I02*T^(m)*exp(-(Tc/T)^p)}
//private
//// Function Func(Parameters:TArrSingle):double; override;
// Function Sum1(Parameters:TArrSingle):double; override;
// Function Sum2(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TTEandTAHT_kT1=class (TFitFunctEvolution)
//
////---------------------------------------------------
//TBrails=class (TFitFunctEvolution)
//{��� ���������� ������������ (���� TBrailsford) ���
//�������� (���� TBrailsfordw) ��������� �����������
//���������� �����
//alpha(T,w) = A*w/T*(B*w*exp(E/kT))/(1+(B*w*exp(E/kT)^2) }
//private
// Function Weight(OutputData:TArrSingle):double;override;
// Constructor Create(FunctionName:string);
//public
//end; // TBrails=class (TFitFunctEvolution)
//
//TBrailsford=class (TBrails)
//private
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TBrailsford=class (TBrails)
//
//TBrailsfordw=class (TBrails)
//private
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TBrailsford=class (TBrails))
//
////-----------------------------------------------------------------------
//TBarierHeigh=class (TFitFunctEvolution)
//{Fb=Fb0-a*x- b*x^0.5}
//private
// Function Func(Parameters:TArrSingle):double; override;
//// Function Weight(OutputData:TArrSingle):double;override;
//public
// Constructor Create;
//end; // TBarierHeigh=class (TFitFunctEvolution)
//
////-----------------------------------------------------
//TCurrentSC=class (TFitFunctEvolution)
//{Isc(T)=Nph*Abs*Lo*T^m/(1+Abs*Lo*T^m)}
//private
//// Procedure RealToFile (InputData:PVector; var OutputData:TArrSingle;
////              Xlog,Ylog:boolean; suf:string);override;//abstract;
// Procedure RealToFile (InputData:TVector; var OutputData:TArrSingle;
//              Xlog,Ylog:boolean; suf:string);override;//abstract;
//
//public
// Constructor Create;
// Function Func(Parameters:TArrSingle):double; override;
//end; // TCurrentSC=class (TFitFunctEvolution)
//
////--------------------------------------------------------
//TFitFunctEvolutionEm=class (TFitFunctEvolution)
//{��� �������, �� ������������
//����������� ���� �� ��������� Em}
//private
// F1:double; //������ Fb(T)-Vn
// F2:double; // ������  2qNd/(eps_0 eps_s)
// fkT:double; //������ kT
// fEmIsNeeded:boolean;
// {���� �rue, �� �� ���������� ��������
// ������������� ������ (�� ��������
// ����������) �������� �������������
// ������������ ���� �� �������;
// ���������, ��������������� ���������
// ������ �� 1/��, � ��������
// ������� ��� ���� ��������������
// ����������� � FVariab[0]}
// Constructor Create (FunctionName,FunctionCaption:string;
//                     Npar,Nvar:byte);
//// Procedure BeforeFitness(InputData:Pvector);override;
// Procedure BeforeFitness(InputData:TVector);override;
// Procedure FIsNotReadyDetermination;override;
// Function Weight(OutputData:TArrSingle):double;override;
// Function TECurrent(V,T,Seff,A:double):double;
// {������� �������� Seff S A* T^2 exp(-(Fb0-A Em)/kT)(1-exp(-qV/kT))}
// Procedure CreateFooter;override;
//// Procedure AddParDetermination(InputData:PVector;
////                               var OutputData:TArrSingle); override;
// Procedure AddParDetermination(InputData:TVector;
//                               var OutputData:TArrSingle); override;
//public
//// Procedure Fitting (InputData:PVector; var OutputData:TArrSingle;
////                    Xlog:boolean=False;Ylog:boolean=False);override;
//end; // TFitFunctEvolutionEm=class (TFitFunctEvolution)
//
//
//TTEstrAndSCLCexp_kT1=class (TFitFunctEvolutionEm)
//{ I(1/kT)=Seff S A* T^2 exp(-(Fb0-A Em)/kT)(1-exp(-qV/kT))
//          +I02*T^(m)*A^(-300/T)}
//private
// Function Sum1(Parameters:TArrSingle):double; override;
// Function Sum2(Parameters:TArrSingle):double; override;
// Function Weight(OutputData:TArrSingle):double;override;
// Function Summand(OutputData:TArrSingle):double;override;
//public
// Constructor Create;
//end; // TTEstrAndSCLCexp_kT1=class (TFitFunctEvolutionEm)
//
//
//TRevSh=class(TFitFunctEvolutionEm)
//{I(V) = I01*exp(A1*Em(V)+B*Em(V)^0.5)*(1-exp(-V/kT))+
//        I02*exp(A2*Em(V)+B*Em(V)^0.5)*(1-exp(-V/kT))}
//private
// Function Sum1(Parameters:TArrSingle):double; override;
// Function Sum2(Parameters:TArrSingle):double; override;
// Function Weight(OutputData:TArrSingle):double;override;
//public
// Constructor Create;
//end; // class(TFitFunctEvolutionEm))
//
//TTEandSCLCV=class (TFitFunctEvolutionEm)
//{I(V) = I01*V^m+I02*exp(A*Em(V)/kT)(1-exp(-eV/kT))}
//private
// Function Sum1(Parameters:TArrSingle):double; override;
// Function Sum2(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TRevShSCLC=class (TFitFunctEvolutionEm)
//
//TRevShSCLC3=class (TFitFunctEvolutionEm)
//{I(V) = I01*V^m1+I02*V^m2+I03*exp(A*Em(V)/kT)*(1-exp(-eV/kT))}
//private
// Function Sum1(Parameters:TArrSingle):double; override;
// Function Sum2(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TRevShSCLC3=class (TFitFunctEvolutionEm)
//
//TRevShSCLC2=class (TFitFunctEvolutionEm)
//{I(V) = I01*(V^m1+b*V^m2)+I02*exp(A*Em(V)/kT)*(1-exp(-eV/kT))
//m1=1+T01/T;
//m2=1+T02/T}
//private
// Fm1:double;
// Fm2:double;
// Function Sum1(Parameters:TArrSingle):double; override;
// Function Sum2(Parameters:TArrSingle):double; override;
//// Procedure BeforeFitness(InputData:Pvector);override;
// Procedure BeforeFitness(InputData:TVector);override;
//public
// Constructor Create;
//end; // TRevShSCLC2=class (TFitFunctEvolutionEm)
//
//TPhonAsTun=class (TFitFunctEvolutionEm)
//{������������� ��������� ������, ���'�������
//� phonon-assisted tunneling}
//private
// fmeff: Double; //��������� �������� ��������� ����
// Function Weight(OutputData:TArrSingle):double;override;
// Constructor Create (FunctionName,FunctionCaption:string;
//                     Npar:byte);
//// Function PhonAsTun(V,kT1:double;Parameters:TArrSingle):double;
//public
// Function PhonAsTun(V,kT1:double;Parameters:TArrSingle):double;virtual;
// class Function PAT(Sample:TDiod_Schottky; V,kT1,Fb0,a,hw,Ett,Nss:double):double;
//end; // TPhonAsTun=class (TFitFunctEvolutionEm)
//
//TPhonAsTunOnly=class (TPhonAsTun)
//{������� ���� ��� ����������, �� ���� �����, ���'������
//� phonon-assisted tunneling}
//private
// Constructor Create(FunctionName:string);overload;
//end; // TPhonAsTunOnly=class (TPhonAsTun)
//
//TPhonAsTun_kT1=class (TPhonAsTunOnly)
//{����� �� ������� 1/kT,
//����� ����� �������� ������� ������� �������}
//private
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TPhonAsTun_kT1=class (TPhonAsTunOnly)
//
//TPhonAsTun_V=class (TPhonAsTunOnly)
//{����� �� ������� ��������� �������,
//������� �����������}
//private
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TPhonAsTun_V=class (TPhonAsTunOnly)
//
//TPATAndTE=class (TPhonAsTun)
//{������� ���� ��� ����������, �� �����, ���'������
//� phonon-assisted tunneling �� ������������}
//private
// Constructor Create(FunctionName:string);overload;
//end; // TPATAndTE=class (TPhonAsTun)
//
//TPATandTE_kT1=class (TPATAndTE)
//{����� �� ������� 1/kT,
//����� ����� �������� ������� ������� �������}
//private
// Function Sum1(Parameters:TArrSingle):double; override;
// Function Sum2(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TPATandTE_kT1=class (TPATAndTE)
//
//TPATandTE_V=class (TPATAndTE)
//{����� �� ������� ��������� �������,
//������� �����������}
//private
//// Function Func(Parameters:TArrSingle):double; override;
// Function Sum1(Parameters:TArrSingle):double; override;
// Function Sum2(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TPATandTE_V=class (TPATAndTE)
//
//TPhonAsTunAndTE2=class (TPhonAsTun)
//{������� ���� ��� ����������, �� �����, ���'������
//� phonon-assisted tunneling �� ������������}
//private
// Constructor Create(FunctionName:string);overload;
//end; // TPhonAsTunAndTE=class (TPhonAsTun)
//
//TPhonAsTunAndTE2_kT1=class (TPhonAsTunAndTE2)
//{����� �� ������� 1/kT,
//����� ����� �������� ������� ������� �������}
//private
//// Procedure BeforeFitness(InputData:Pvector);override;
// Procedure BeforeFitness(InputData:TVector);override;
// Function Sum1(Parameters:TArrSingle):double; override;
// Function Sum2(Parameters:TArrSingle):double; override;
//// Procedure AddParDetermination(InputData:PVector;
////                               var OutputData:TArrSingle); override;
// Procedure AddParDetermination(InputData:TVector;
//                               var OutputData:TArrSingle); override;
// Procedure CreateFooter;override;
//public
//// Function PhonAsTun(V,kT1:double;Parameters:TArrSingle):double;override;
// Constructor Create;
//end; // TPhonAsTunAndTE_kT1=class (TPhonAsTunAndTE)
//
//
////TPhonAsTunAndTE3_kT1=class (TPhonAsTun)
////{������� ���� ��� ����������, �� �����, ���'������
////� phonon-assisted tunneling �� ������������}
////private
////// Constructor Create(FunctionName:string);overload;
//// Function Sum1(Parameters:TArrSingle):double; override;
//// Function Sum2(Parameters:TArrSingle):double; override;
////public
//// Constructor Create;
////end; // TPhonAsTunAndTE=class (TPhonAsTun)
//
//TTAU_Fei_FeB=class (TFitFunctEvolution)
//{������ ��������� ���� ����� ���������� ����,
//���� ���������� ������� ������������
//����� � �������� FeB
//tau(t)= 1/(1/tau_FeB+1/tau_Fei+1/tau_r)
//�� tau_r - ��� �����, �� ������� ������ ����������
//�����������, ���� �� �����, ��'������� � Fei �� FeB;
//���������, �� ����������� - ������� ������������
//����� ����� (����������� �� � ����� FeB) �� tau_r}
//private
// fFei:TDefect;
// fFeB:TDefect;
// Function Func(Parameters:TArrSingle):double; override;
//
//public
// Constructor Create;
// Procedure Free;
//end; //TTAU_Fei_FeB=class (TFitFunctEvolution)
//
//
var
 FitFunctionNew:TFitFunctionNew;
// EvolParam:TArrSingle;
//{����� � double, ��������������� � ����������� ����������}
//
////-------------------------------------------------
//procedure PictLoadScale(Img: TImage; ResName:String);
//{� Img ������������� bmp-�������� � ������� � ������
//ResName � ������������ ����������, ��� �� �����
//�� ��� ������ Img, �� ���� ����� ���}
//
//Procedure FunCreate(str:string; var F:TFitFunction;
//          FileName:string='');
//{������� F ���� �� ������ ���� �������
//�� �������� str}
//
////Function FitName(V: PVector; st:string='fit'):string;overload;
//Function FitName(V: TVector; st:string='fit'):string;//overload;
//{������� ������ �������� V^.name,
//���� ������ � ���������� st ����� ������ �������}
//
////Function Parametr(V: PVector; FunName,ParName:string):double;overload;
//Function Parametr(V: TVector; FunName,ParName:string):double;//overload;
//{������� �������� � ������ ParName,
//���� ����������� � ��������� ������������ ����� � V
//�� ��������� ������� FunName}
//
//
//Function StepDetermination(Xmin,Xmax:double;Npoint:integer;
//                   Var_Rand:TVar_Rand):double;
//{���� ��� ���� �������� � ��������
//[Xmin, Xmax] � ��������� �������
//����� Npoint;
//Var_Rand  ���� ������� ���� (������ �� ������������)
//� ���������� ������� �����������
//���������� �������� �����
//}
//
//--------------------------------------------------------------------
//--------------------------------------------------------------------


implementation

uses
  SysUtils, Dialogs, OApproxShow, Graphics, Math, Controls;

{ TOIniFileNew }

function TOIniFileNew.ReadEvType(const Section, Ident: string): TEvolutionTypeNew;
begin
  try
    Result:=TEvolutionTypeNew(ReadInteger(Section, Ident,0));
  except
    Result:=TEvolutionTypeNew(0);
  end;
end;

function TOIniFileNew.ReadFitType(const Section, Ident: string): TFitnessType;
begin
  try
    Result:=TFitnessType(ReadInteger(Section, Ident,1));
  except
    Result:=TFitnessType(1);
  end;
end;

function TOIniFileNew.ReadRand(const Section, Ident: string): TVar_RandNew;
begin
  try
    Result:=TVar_RandNew(ReadInteger(Section, Ident,0));
  except
    Result:=TVar_RandNew(0);
  end;
end;

function TOIniFileNew.ReadRegType(const Section,
  Ident: string): TRegulationType;
begin
  try
    Result:=TRegulationType(ReadInteger(Section, Ident,0));
  except
    Result:=TRegulationType(0);
  end;
end;

procedure TOIniFileNew.WriteEvType(const Section, Ident: string;
  Value: TEvolutionTypeNew);
begin
 WriteInteger(Section, Ident,ord(Value));
end;

procedure TOIniFileNew.WriteFitType(const Section, Ident: string;
  Value: TFitnessType);
begin
 WriteInteger(Section, Ident,ord(Value));
end;

procedure TOIniFileNew.WriteRand(const Section, Ident: string;
                                 Value: TVar_RandNew);
begin
  WriteInteger(Section, Ident,ord(Value));
end;

procedure TOIniFileNew.WriteRegType(const Section, Ident: string;
  Value: TRegulationType);
begin
  WriteInteger(Section, Ident,ord(Value));
end;

{ TFitFunctionNew }

//constructor TFitFunctionNew.Create(FunctionName, FunctionCaption: string);
constructor TFitFunctionNew.Create;
begin
 inherited Create;
 DecimalSeparator:='.';
 NamesDefine;
// FName:=FunctionName;
// FCaption:=FunctionCaption;
 fDigitNumber:=8;
 fFileSuffix:='fit';
 fHasPicture:=True;
 FPictureName:=FName+'Fig';
 fIsReadyToFit:=False;
 fResultsIsReady:=False;
 fFileHeader:='X Y Yfit';
 TuningBeforeAccessorialDataCreate;

 DataContainerCreate;
 AccessorialDataCreate;

 fConfigFile:=TOIniFileNew.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');

 fParameter:=ParameterCreate;
 fWShow:=TFFWindowShowBase.Create(Self);
 fParameter.ReadFromIniFile;
 IsReadyToFitDetermination;

 TuningAfterReadFromIni;

// fDataToFit:TVector; //��� ��� ������������
// fDiapazon:TDiapazon; //��� � ���� ���������� ������������

end;



procedure TFitFunctionNew.DataContainerCreate;
begin
  fDataToFit:=TVectorTransform.Create;
  ftempVector:=TVectorShottky.Create;
  FittingData:=TVector.Create;
end;

procedure TFitFunctionNew.DataContainerDestroy;
begin
  fDataToFit.Free;
  ftempVector.Free;
  FittingData.Free;
end;

procedure TFitFunctionNew.DataPreraration(InputData: TVector);
begin
  ftempVector.CopyFrom(InputData);
  ftempVector.N_Begin := 0;
  ftempVector.CopyDiapazonPoint(fDataToFit, fDiapazon);
end;

procedure TFitFunctionNew.DataPreraration(InputFileName: string);
begin
  ftempVector.ReadFromFile(InputFileName);
  ftempVector.CopyDiapazonPoint(fDataToFit, fDiapazon);
end;

procedure TFitFunctionNew.DataToStrings(OutStrings: TStrings);
begin
 OutStrings.Add(fDataToFit.name);
end;

destructor TFitFunctionNew.Destroy;
begin
  DataContainerDestroy;
  AccessorialDataDestroy;
  ParameterDestroy;
  fConfigFile.Free;
  inherited;
end;

procedure TFitFunctionNew.AccessorialDataDestroy;
begin
 fDiapazon.Free;
end;

//constructor TFitFunctionNew.Create;
//begin
// Create('','');
//end;

procedure TFitFunctionNew.AccessorialDataCreate;
begin
 fDiapazon:=TDiapazon.Create;
// fDiapazon.Clear;
end;

procedure TFitFunctionNew.IsReadyToFitDetermination;
begin
 fIsReadyToFit:=fParameter.IsReadyToFitDetermination;
// fIsReadyToFit:=True;
end;

function TFitFunctionNew.FinalFunc(X: double): double;
begin
 if fResultsIsReady then Result:=RealFinalFunc(X)
                    else Result:=ErResult;
end;

procedure TFitFunctionNew.Fitting(InputFileName: string);
begin
 DataPreraration(InputFileName);
 if FittingBegin then RealFitting;
 if not(FittingData.IsEmpty) then fResultsIsReady:=True; 
end;

procedure TFitFunctionNew.Fitting(InputData: TVector);
begin
 DataPreraration(InputData);
 if FittingBegin then RealFitting;
 if not(FittingData.IsEmpty)
      then fResultsIsReady:=True
      else
   MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
end;


function TFitFunctionNew.RealFinalFunc(X: double): double;
begin
 Result:=FittingData.Yvalue(X);
end;

procedure TFitFunctionNew.RealToFile;
 var Str1:TStringList;
    i:integer;
begin
  Str1:=TStringList.Create;
  if fFileHeader<>'' then Str1.Add(fFileHeader);
  for I := 0 to fDataToFit.HighNumber do
    Str1.Add(fDataToFit.PoinToString(i,DigitNumber)
             +' '
             +FloatToStrF(FittingData.Y[i],ffExponent,DigitNumber,0));
  Str1.SaveToFile(FitName(fDataToFit,FileSuffix));
  Str1.Free;
end;

procedure TFitFunctionNew.RealToGraph(Series: TChartSeries);
begin
 FittingData.WriteToGraph(Series);
end;

procedure TFitFunctionNew.SetNameCaption(FunctionName, FunctionCaption: string);
begin
 FName:=FunctionName;
 FCaption:=FunctionCaption;
end;

procedure TFitFunctionNew.SetParametersGR;
begin
 fWShow.Show;
end;

procedure TFitFunctionNew.TuningAfterReadFromIni;
begin

end;

procedure TFitFunctionNew.TuningBeforeAccessorialDataCreate;
begin

end;

procedure TFitFunctionNew.VariousPreparationBeforeFitting;
begin
 IsReadyToFitDetermination;
end;

//procedure TFitFunctionNew.WriteToIniFile;
//begin
// fDiapazon.WriteToIniFile(fConfigFile,FName,'DiapazonFit');
//end;

function TFitFunctionNew.FittingBegin: boolean;
begin
 VariousPreparationBeforeFitting;
 fResultsIsReady:=false;
 FittingData.Clear;
 Result:=False;
 if fDataToFit.IsEmpty then
    begin
       MessageDlg('No data to fit',mtWarning, [mbOk], 0);
       Exit;
    end;
 if not(fIsReadyToFit) then
     begin
       SetParametersGR;
       if not(fIsReadyToFit) then
         begin
          MessageDlg('Fitting is imposible.'+#10+#13+
            'To tune options, please',mtWarning, [mbOk], 0);
          Exit;
         end;
     end;
 Result:=True;
end;

procedure TFitFunctionNew.FittingToGraphAndFile(InputData: TVector;
                    Series: TChartSeries);
begin
  Fitting(InputData);
  if not(fResultsIsReady) then Exit;
  RealToGraph(Series);
  RealToFile;
end;

function TFitFunctionNew.ParameterCreate:TFFParameter;
begin
 Result:=TFFParameterBase.Create(Self);
end;

procedure TFitFunctionNew.ParameterDestroy;
begin
 fWShow.Free;
 fParameter.Free;
end;


{ TWindowShow }

constructor TFFWindowShow.Create(PS: TFFParameter);
begin
  inherited Create;
  fPS:=PS;
end;


{ TWindowShowBase }

procedure TFFWindowShowBase.AdditionalFormClear;
begin
  inherited;
  fPS.FormClear;
end;

procedure TFFWindowShowBase.AdditionalFormPrepare;
begin
 inherited;
 fForm.Caption := 'Parameters of ' + fFF.Name + ' function';
 fPS.FormPrepare(fForm);
end;

constructor TFFWindowShowBase.Create(FF: TFitFunctionNew);
begin
 fFF:=FF;
 inherited Create(fFF.fParameter);
end;

//procedure TFFWindowShowBase.CreateForm;
//begin
////  inherited
////  fForm.Caption := 'Parameters of ' + fFF.Name + ' function';
//
//  fForm := TForm.Create(Application);
//  fForm.Position := poMainFormCenter;
//  fForm.AutoScroll := True;
//  fForm.BorderIcons := [biSystemMenu];
//  fForm.ParentFont := True;
//  fForm.Font.Style := [fsBold];
//  fForm.Caption := 'Parameters of ' + fFF.Name + ' function';
//  fForm.Color := clLtGray;
//end;

//procedure TFFWindowShowBase.Show;
//begin
// CreateForm;
// fPS.FormPrepare(fForm);
//
// fButtons := TFrBut.Create(fForm);
// fButtons.Parent := fForm;
// fButtons.Left := 10;
// fButtons.Top := fForm.Height+MarginTop;
//
// fForm.Width:=max(fForm.Width,fButtons.Width)+MarginLeft+10;
// fForm.Height:=fButtons.Top+fButtons.Height+2*MarginTop+10;
//
// if fForm.ShowModal=mrOk then
//   begin
//     fPS.UpDate;
//     fFF.IsReadyToFitDetermination;
//     if fFF.IsReadyToFit then  fFF.fParameter.WriteToIniFile;
//   end;
//
// fPS.FormClear;
// fButtons.Parent:=nil;
// fButtons.Free;
// ElementsFromForm(fForm);
//
// fForm.Hide;
// fForm.Release;
//
//end;





procedure TFFWindowShowBase.UpDate;
begin
  inherited;
  fPS.UpDate;
  fFF.IsReadyToFitDetermination;
  if fFF.IsReadyToFit then  fFF.fParameter.WriteToIniFile;
end;

{ TWindowShow }

procedure TWindowShow.AdditionalFormPrepare;
begin

end;

procedure TWindowShow.CreateForm;
begin
  fForm := TForm.Create(Application);
  fForm.Position := poMainFormCenter;
  fForm.AutoScroll := True;
  fForm.BorderIcons := [biSystemMenu];
  fForm.ParentFont := True;
  fForm.Font.Style := [fsBold];
  fForm.Caption := 'Some Captions';
  fForm.Color := clLtGray;

  AdditionalFormPrepare;

  fButtons := TFrBut.Create(fForm);
  fButtons.Parent := fForm;
  fButtons.Left := 10;
  fButtons.Top := fForm.Height+MarginTop;

  fForm.Width:=max(fForm.Width,fButtons.Width)+MarginLeft+10;
  fForm.Height:=fButtons.Top+fButtons.Height+2*MarginTop+10;
end;

procedure TWindowShow.UpDate;
begin

end;

procedure TWindowShow.AdditionalFormClear;
begin

end;

procedure TWindowShow.Show;
begin
 CreateForm;

 if fForm.ShowModal=mrOk then UpDate;

 AdditionalFormClear;
 fButtons.Parent:=nil;
 fButtons.Free;
 ElementsFromForm(fForm);

 fForm.Hide;
 fForm.Release;
end;

end.
