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

  TVar_RandNew=(vr_lin,vr_ln,vr_const);
  {��� ������, �� ���������������� � ����������� �������,
  norm - ���������� �������� �����
  logar - ���������� �������� ������������ ��������� �����
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
    ftRAR,//���� ������ �������� ������
    ftArea//������ ����, ���.PROGRESS  IN  PHOTOVOLTAICS: RESEARCH  AND APPLICATIONS,  VOL  1,  93-106 (1993)
   );

  TRegulationType=(rtL2,rtL1);

const
 Var_RandNames:array[TVar_RandNew]of string=
           ('Normal','Logarithmic','Constant');


 EvTypeNames:array[TEvolutionTypeNew]of string=
         ('DE','MABC','TLBO','PSO');

 FitTypeNames:array[TFitnessType]of string=
         ('Sq.Res.','Rel.Sq.Res.','Abs.Res.','Rel.Abs.Res.',
          'Area');

 RegTypeNames:array[TRegulationType]of string=
         ('L2','L1');

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
// fHasPicture:boolean;//��������� ��������
// fDataToFit:TVectorTransform; //���� ��� ������������
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
 //��, �� �������� �� ����� ����� ��� ����� ����������, �� ������������� 'fit'
 procedure DataContainerCreate;virtual;
 procedure DataContainerDestroy;virtual;

 procedure ParameterDestroy;virtual;
// procedure RealFitting;virtual;//abstract;
 procedure DataPreraration(InputFileName:string);overload;
 function FittingBegin:boolean;
protected
 fResultsIsReady:boolean; //True, ���� ������������ ����� ��������
 fHasPicture:boolean;//��������� ��������
 fDataToFit:TVectorTransform; //���� ��� ������������
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
 {�� ��������� ���� �����������, �� ����� ���� ��
 ������������}
// Procedure WriteToIniFile;virtual;
 {������ ���� � ini-����, � ����� ���� - ��� fDiapazon}
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
//������� ��� ��������� ������������ � ����
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
//{������������� ���������� ������, ���'�������
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
//{������ ���������� ���� ����� ���������� ����,
//���� ���������� ������� ������������
//����� � �������� FeB
//tau(t)= 1/(1/tau_FeB+1/tau_Fei+1/tau_r)
//�� tau_r - ��� �����, �� ������� ������ �����������
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
//���� ������ � ����������� st ����� ������ �������}
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
//Var_Rand  ���� ������� ���� (������� �� ������������)
//� ���������� ������� �����������
//���������� �������� �����
//}
//
//--------------------------------------------------------------------
//--------------------------------------------------------------------


implementation

uses
  SysUtils, Dialogs, OApproxShow, Graphics, Math, Controls, TypInfo;

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

// fDataToFit:TVector; //���� ��� ������������
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
