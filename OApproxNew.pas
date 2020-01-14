unit OApproxNew;

interface

uses
  IniFiles, OlegApprox, OlegVector, OlegType, OlegVectorManipulation;

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
//
//  TVar_Rand=(lin,logar,cons);
//  {��� ������, �� ���������������� � ����������� �������,
//  norm - ���������� �������� �����
//  logar - ���������� �������� ��������� �����
//  �ons - ����� ���������� ������}
//  TArrVar_Rand=array of TVar_Rand;
//  PTArrVar_Rand=^TArrVar_Rand;
//
//  TEvolutionType= //����������� �����, ���� ��������������� ��� ������������
//    (TDE, //differential evolution
//     TMABC, // modified artificial bee colony
//     TTLBO,  //teaching learning based optimization algorithm
//     TPSO    // particle swarm optimization
//     );
//  {}
//
TOIniFileNew=class (TIniFile)
public
function ReadRand(const Section, Ident: string): TVar_Rand; virtual;
procedure WriteRand(const Section, Ident: string; Value: TVar_Rand); virtual;
function ReadEvType(const Section, Ident: string): TEvolutionType; virtual;
procedure WriteEvType(const Section, Ident: string; Value: TEvolutionType); virtual;
end;



TFitFunctionNew=class(TObject)
{����������� ���� ��� ������������,
�� ���� ���������� ���������}
private
 FName:string;//��'� �������
 FCaption:string; // ���� �������
 FPictureName:string;//��'�  ������� � ��������, �� ���������� FName+'Fig';
// FXname:TArrStr; // ����� ������
 fHasPicture:boolean;//��������� ��������
 fDataToFit:TVectorTransform; //���� ��� ������������
 fDiapazon:TDiapazon; //��� � ���� ���������� ������������
 fIsReadyToFit:boolean; //True, ���� ��� ������ ��� ���������� ������������
 fResultsIsReady:boolean; //True, ���� ������������ ����� ��������
 fConfigFile:TOIniFile;//��� ������ � .ini-������
// fFileHeading:string;
// {����� ������� � ���� � ������������ ������������,
// �� ����������� ��������� FittingGraphFile}
 procedure DataContainerCreate;virtual;
 procedure DipazonCreate;virtual;
 procedure DataContainerDestroy;virtual;
 procedure DiapazonDestroy;virtual;
 procedure RealFitting;virtual;abstract;
    procedure DataPreraration(InputData: TVector);
//// Procedure RealToGraph (InputData:PVector; var OutputData:TArrSingle;
////              Series: TLineSeries;
////              Xlog,Ylog:boolean; Np:Word); overload;virtual;abstract;
// Procedure RealToGraph (InputData:TVector; var OutputData:TArrSingle;
//              Series: TLineSeries;
//              Xlog,Ylog:boolean; Np:Word); {overload;}virtual;abstract;
// {���. FittingGraph}
//// Procedure RealToFile (InputData:PVector; var OutputData:TArrSingle;
////              Xlog,Ylog:boolean; suf:string);overload;virtual;//abstract;
// Procedure RealToFile (InputData:TVector; var OutputData:TArrSingle;
//              Xlog,Ylog:boolean; suf:string);{overload;}virtual;//abstract;
// {���. FittingGraphFile}
//// Function StringToFile(InputData:PVector;Number:integer; OutputData:TArrSingle;
////              Xlog,Ylog:boolean):string;overload;virtual;
// Function StringToFile(InputData:TVector;Number:integer; OutputData:TArrSingle;
//              Xlog,Ylog:boolean):string;{overload;}virtual;
// {����������� �����, ���� ��������� � ���� � ������������
// ������������; ��������������� � RealToFile}
// Procedure PictureToForm(Form:TForm;maxWidth,maxHeight,Top,Left:integer);
protected
 Procedure ReadFromIniFile;virtual;
 {����� ���� � ini-�����, � ����� ���� - fDiapazon}
 Procedure WriteToIniFile;virtual;
 {������ ���� � ini-����, � ����� ���� - ��� fDiapazon}
public
 FittingData:TVector;
 property Name:string read FName;
 property PictureName:string read FPictureName;
 property Caption:string read FCaption;
 property ResultsIsReady:boolean read fResultsIsReady;
// property Xname:TArrStr read FXname;
 property HasPicture:boolean read fHasPicture;
 Constructor Create(FunctionName,FunctionCaption:string);
 destructor Destroy;override;
// procedure SetValueGR;virtual;
// Function FinalFunc(X:double;DeterminedParameters:TArrSingle;
//     Xlog:boolean=False;Ylog:boolean=False):double; virtual;abstract;
// {������������ �������� ������������ ������� �
// ����� � �������� �, ��������� �������� �������
// � ���, �� ������� Func ��� Fparam[0]=X,
// ��� ����, ��������
// ����������� ��������, ���� ������������ ������������
// �����, ������������� � ������������� �������
// Xlog = True - ������� � � ������������� �������,
// Ylog = True - �������� � ������������� �������}
//// Procedure Fitting (InputData:PVector; var OutputData:TArrSingle;
////             Xlog:boolean=False;Ylog:boolean=False);overload;virtual;abstract;
 Procedure Fitting (InputData:TVector);//virtual;abstract;
 {��������, �������� ��� ��������� RealFitting,
 �� ����� ���������� ������������;
 �� ��������� ���� �������� �������,
 � ��� ��������� ������ ���������� �����������,
 � OutputData[0] - ErResult;
 ������� ����� OutputData  ���� ��������� ������� �
 ������� ������� ���������;
 ������� ����� ���������� ������������� ����,
 ������������ � ������ InputData � ������������� �������
 Xlog = True - ������� � � ������������� �������,
 Ylog = True - �������� � ������������� �������}
//// Procedure FittingGraph (InputData:PVector; var OutputData:TArrSingle;
////              Series: TLineSeries;
////              Xlog:boolean=False;Ylog:boolean=False;
////              Np:Word=150);overload;virtual;
// Procedure FittingGraph (InputData:TVector; var OutputData:TArrSingle;
//              Series: TLineSeries;
//              Xlog:boolean=False;Ylog:boolean=False;
//              Np:Word=150);{overload;}virtual;
// {������������ � ���� ��������� � Series -
// ��� ����� ���� ���������� ������
// Np - ������� ����� �� �������,
// Xlog,Ylog ���. Fitting
// �������� �� �������� ��� RealToGraph, ���
// � �������� ���� �������}
//// Procedure FittingGraphFile (InputData:PVector; var OutputData:TArrSingle;
////              Series: TLineSeries;
////              Xlog:boolean=False;Ylog:boolean=False;
////              Np:Word=150; suf:string='fit');overload;virtual;
// Procedure FittingGraphFile (InputData:TVector; var OutputData:TArrSingle;
//              Series: TLineSeries;
//              Xlog:boolean=False;Ylog:boolean=False;
//              Np:Word=150; suf:string='fit');{overload;}virtual;
// {������������, ���� ��������� � Series, ���
// ���� ������������ ����� ���������� � ���� -
// ����� ���������;
// ����� ����� -- V^.name + suf,
// Xlog,Ylog ���. Fitting,
// �������� �� �������� ��� RealToFile, ���
// � �������� ���� �������}
//// Procedure FittingDiapazon (InputData:PVector; var OutputData:TArrSingle;
////                            D:TDiapazon);overload;virtual;abstract;
// Procedure FittingDiapazon (InputData:TVector; var OutputData:TArrSingle;
//                            D:TDiapazon);{overload;}virtual;abstract;
//{�������������� ���� � ������ V �������� �� ��������
// � D, �������� ��������� ����������� � OutputData}
// Procedure DataToStrings(DeterminedParameters:TArrSingle;
//                         OutStrings:TStrings);virtual;abstract;
// {� OutStrings ��������� �����, �� ������
// ����� ��� ���������� ������� �� �� ��������,
// �� ����������� � DeterminedParameters}
 end;   // TFitFunc=class
//
////--------------------------------------------------------------------
//TFitWithoutParameteres=class (TFitFunction)
//private
//  FErrorMessage:string; //���������� ��� �������
////  Procedure RealToGraph (InputData:PVector; var OutputData:TArrSingle;
////              Series: TLineSeries;
////              Xlog,Ylog:boolean; Np:Word); override;
//  Procedure RealToGraph (InputData:TVector; var OutputData:TArrSingle;
//              Series: TLineSeries;
//              Xlog,Ylog:boolean; Np:Word); override;
////  Function StringToFile(InputData:PVector;Number:integer; OutputData:TArrSingle;
////              Xlog,Ylog:boolean):string;override;
//  Function StringToFile(InputData:TVector;Number:integer; OutputData:TArrSingle;
//              Xlog,Ylog:boolean):string;override;
//protected
// fVector:TVector;//���������� �������� ���� ��� �����������
//public
//// FtempVector:PVector;  //���������� �������� ���� ��� �����������
// Constructor Create(FunctionName:string);
// Procedure Free;
//// procedure RealTransform(InputData:PVector);overload;
// procedure RealTransform(InputData:TVector);{overload;}
//  {c��� ��� � FtempVector ��������� ������������ �������� ����� InputData}
// Function FinalFunc(X:double;DeterminedParameters:TArrSingle;
//                     Xlog:boolean=False;Ylog:boolean=False):double;override;
//// Procedure Fitting (InputData:PVector; var OutputData:TArrSingle;
////                    Xlog:boolean=False;Ylog:boolean=False);override;
// Procedure Fitting (InputData:TVector; var OutputData:TArrSingle;
//                    Xlog:boolean=False;Ylog:boolean=False);override;
//// Procedure FittingDiapazon (InputData:PVector;
////                   var OutputData:TArrSingle;D:TDiapazon);override;
// Procedure FittingDiapazon (InputData:TVector;
//                   var OutputData:TArrSingle;D:TDiapazon);override;
//// Function Deviation (InputData:PVector):double;override;
// Procedure DataToStrings(DeterminedParameters:TArrSingle;
//                         OutStrings:TStrings);override;
//end;  //TFitWithoutParameteres=class (TFitFunction)
//
////--------------------------------------------------------------------
//TFitFunctionSimple=class (TFitFunction)
//{����������� ���� ��� �������, �� ������������ ���������}
//private
//  FNx:byte;//������� ���������, �� ������������
//  fX:double; //����� �, ��� ��������������� ��� ���������� �������
//  fYminDontUsed:boolean;
// {��������������� � FittingDiapazon,
// ��� ��� �������, �� �� ������� �����������
// ��������� �� ��������� �������� ��������
// (��� ��������� ��������),
// ��������� ���������� � Create � True}
// Constructor Create(FunctionName,FunctionCaption:string;N:byte);
// Function Func(Parameters:TArrSingle):double; virtual;abstract;
//  {������������ �������... ������� ��, ��� ���������������
//  ��� ������� ������� �������;
//  ���� �� ������   ������� � ������������� -
//  ��������� �� ��� Diod  ����� �����쳿 ����}
// Function RealFunc(Parameters:TArrSingle):double; virtual;
//  {� ��� �� - ������������ �������,
//  �� ���������� ������� � Func}
//// Procedure RealFitting (InputData:PVector;
////         var OutputData:TArrSingle); overload;virtual;abstract;
// Procedure RealFitting (InputData:TVector;
//         var OutputData:TArrSingle); overload;virtual;abstract;
// {�������������� ���� � ������ InputData, �������� ���������
// ����������� � OutputData;}
//// Procedure RealToGraph (InputData:PVector; var OutputData:TArrSingle;
////              Series: TLineSeries;
////              Xlog,Ylog:boolean; Np:Word); override;
// Procedure RealToGraph (InputData:TVector; var OutputData:TArrSingle;
//              Series: TLineSeries;
//              Xlog,Ylog:boolean; Np:Word); override;
//// Function StringToFile(InputData:PVector;Number:integer;OutputData:TArrSingle;
////              Xlog,Ylog:boolean):string;override;
// Function StringToFile(InputData:TVector;Number:integer;OutputData:TArrSingle;
//              Xlog,Ylog:boolean):string;override;
//
//public
// Function FinalFunc(X:double;DeterminedParameters:TArrSingle;
//                     Xlog:boolean=False;Ylog:boolean=False):double; override;
// {������������ �������� ������������ ������� �
// ����� � �������� �, ��������� �������� �������
// � ���, �� ������� Func ��� fX=X,
// ��� ����, ��������
// ����������� ��������, ���� ������������ ������������
// �����, ������������� � ������������� �������
// Xlog = True - ������� � � ������������� �������,
// Ylog = True - �������� � ������������� �������
//}
//// Procedure Fitting (InputData:PVector; var OutputData:TArrSingle;
////                    Xlog:boolean=False;Ylog:boolean=False);override;
// Procedure Fitting (InputData:TVector; var OutputData:TArrSingle;
//                    Xlog:boolean=False;Ylog:boolean=False);override;
//// Procedure FittingDiapazon (InputData:PVector; var OutputData:TArrSingle;
////                            D:TDiapazon);override;
// Procedure FittingDiapazon (InputData:TVector; var OutputData:TArrSingle;
//                            D:TDiapazon);override;
//// Function Deviation (InputData:PVector):double;overload;
// Function Deviation (InputData:TVector):double;overload;
// {������� ������� ����������� �������
// ��������� ������������ ����� � InputData
// �� ����� �����}
//// Function Deviation (InputData:PVector;OutputData:TArrSingle):double;overload;virtual;
// Function Deviation (InputData:TVector;OutputData:TArrSingle):double;overload;virtual;
// Procedure DataToStrings(DeterminedParameters:TArrSingle;
//                         OutStrings:TStrings);override;
//end;   // TFitFunc=class
//
////--------------------------------------------------------------------
//TLinear=class (TFitFunctionSimple)
//private
////  Procedure RealFitting (InputData:PVector; var OutputData:TArrSingle);override;
//  Procedure RealFitting (InputData:TVector; var OutputData:TArrSingle);override;
//  Function Func(Parameters:TArrSingle):double; override;
//public
//  Constructor Create;
//end; // TLinear=class (TFitFunction)
//
//TOhmLaw=class (TFitFunctionSimple)
//private
////  Procedure RealFitting (InputData:PVector; var OutputData:TArrSingle);override;
//  Procedure RealFitting (InputData:TVector; var OutputData:TArrSingle);override;
//  Function Func(Parameters:TArrSingle):double; override;
//public
//  Constructor Create;
//end; // TOhmLaw=class (TFitFunctionSimple)
//
//TQuadratic=class (TFitFunctionSimple)
//private
////  Procedure RealFitting (InputData:PVector; var OutputData:TArrSingle);override;
//  Procedure RealFitting (InputData:TVector; var OutputData:TArrSingle);override;
//  Function Func(Parameters:TArrSingle):double; override;
//public
//  Constructor Create;
//end; // TQuadratic=class (TFitFunction)
//
//TGromov=class (TFitFunctionSimple)
//private
////  Procedure RealFitting (InputData:PVector;var OutputData:TArrSingle);override;
//  Procedure RealFitting (InputData:TVector;var OutputData:TArrSingle);override;
//  Function Func(Parameters:TArrSingle):double; override;
//public
//  Constructor Create;
//end; // TGromov=class (TFitFunction)
//
////-----------------------------------------------
//TFitVariabSet=class(TFitFunctionSimple)
//{��� �������, �� ������� ����� ������� ��� ���� � �� Y}
//private
// FVarNum:byte; //������� ���������� (��� X �� Y) �������, �� ������� ��� ���������� �������
// FVariab:TArrSingle;
// {��������, �� ������� ��� ���������� �������}
// FVarName:array of string;  //����� ���������� �������
// FVarBool:array of boolean;
// {���� True, �� �������� �������� ���������
// �������� �������  ��������� ��������, � ��
// ����������� ��������� - ���������,
// ����������� �������� �� � �������� Pvector}
// FVarManualDefinedOnly:array of boolean;
// {���� True, �� �������� ��������
// ���� ����������� ���� ������� ����������� ��������;
// �� ���������� False, �������� �������� ����
// � Create}
// FVarValue:TArrSingle;
// {�� �������� ���������� �������,
// ���� ����������� � .ini-����}
// FIsNotReady:boolean;
//{������, �� �� ���� �������� �, ����, �� ������� ������
// ��� ������������}
// FConfigFile:TOIniFile;//��� ������ � .ini-������
// Constructor Create(FunctionName,FunctionCaption:string;
//                     Npar,Nvar:byte);
// Procedure FIsNotReadyDetermination;virtual;
// {�� ��������� ���� �����������, �� ����� ���� ��
// ������������}
// Procedure ReadFromIniFile;virtual;
// {����� ���� � ini-�����, �������� ��� RealReadFromIniFile}
// Procedure RealReadFromIniFile;virtual;
// {������������� ����� ���� � ini-�����, � ����� ���� - FVarValue, FVarBool}
// Procedure WriteToIniFile;virtual;
// {������ ���� � ini-����, �������� ��� RealWriteToIniFile}
// Procedure RealWriteToIniFile;virtual;
// {������������� ������ ���� � ini-����, � ����� ���� - FVarValue, FVarBool}
//// Procedure BeforeFitness(InputData:Pvector);overload;virtual;
// Procedure BeforeFitness(InputData:TVector);{overload;}virtual;
// {���������� ����� �������� ������������,
// ������ � ���������� ���� ���������
// ����������}
// Procedure WriteIniDefFit(const Ident: string;Value:double);overload;
// {������ ���� � ������ � ��'�� FName �������������� FConfigFile}
// Procedure WriteIniDefFit(const Ident: string;Value:integer);overload;
// Procedure WriteIniDefFit(const Ident: string;Value:Boolean);overload;
// Procedure WriteIniDefFit(const Ident: string; var Value:TVar_Rand);overload;
// Procedure  ReadIniDefFit(const Ident: string; var Value:double);overload;
// {�����  ���� � ������ � ��'�� FName �������������� FConfigFile}
// Procedure  ReadIniDefFit(const Ident: string; var Value:integer);overload;
// Procedure  ReadIniDefFit(const Ident: string; var Value:boolean);overload;
// Procedure ReadIniDefFit(const Ident: string; var Value:TVar_Rand);overload;
// Procedure GRFormPrepare(Form:TForm);
//  {��������� ��������� ����� ��� ��������� �����������}
// Procedure GRElementsToForm(Form:TForm);
// {��������� ������������ �������� �� �����
//  ��� ��������� �����������, �������� -
//  �������� ��� ����� �������} virtual;
// Function  GrVariabLeftDefine(Form: TForm):integer;
// Function GrVariabTopDefine(Form: TForm):integer;
// {������� �� ����, �� � �� ����,
// ����������� ���������, �� ������ ����������
// �������� � ��������� ��������}
// Procedure GRVariabToForm(Form:TForm);
// {���������� � �������� ��������, ���'�����
// � ����������� ����������}
// Procedure GRFieldFormExchange(Form:TForm;ToForm:boolean);
// {��� ToForm=True ���������� ������� �������� �� ����
//  ��� ��������� �����������,
//  ��� ToForm=False ���������� ������� �����;
//  �������� -  �������� ��� GRRealSetValue}
// Procedure GRRealSetValue(Component:TComponent;ToForm:boolean);virtual;
// {������������/���������� �������� ���������� Component}
// Procedure GRSetValueVariab(Component:TComponent;ToForm:boolean);
// {���� Component ��'������ � �����������
// ����������, �� ������������/���������� ���� ��������}
// Procedure GRButtonsToForm(Form:TForm);
// {�� ����� ���������� ������ Ok, Cancel}
//public
//// Procedure Fitting (InputData:PVector; var OutputData:TArrSingle;
////                    Xlog:boolean=False;Ylog:boolean=False);override;
// Procedure Fitting (InputData:TVector; var OutputData:TArrSingle;
//                    Xlog:boolean=False;Ylog:boolean=False);override;
// procedure SetValueGR;override;
// {����� ����� ��� ��������� ����������� ������������}
//end;   // TFitVariabSet=class(TFitFunctionSimple)
////---------------------------------------------
//TNoiseSmoothing=class(TFitVariabSet)
//// FtempVector:PVector;
// Function Func(Parameters:TArrSingle):double; override;
//// Procedure RealFitting (InputData:PVector;
////         var OutputData:TArrSingle); override;
// Procedure RealFitting (InputData:TVector;
//         var OutputData:TArrSingle); override;
//// Procedure Fitting (InputData:PVector; var OutputData:TArrSingle;
////                    Xlog:boolean=False;Ylog:boolean=False);override;
// Procedure Fitting (InputData:TVector; var OutputData:TArrSingle;
//                    Xlog:boolean=False;Ylog:boolean=False);override;
//// Procedure RealToGraph (InputData:PVector; var OutputData:TArrSingle;
////              Series: TLineSeries;
////              Xlog,Ylog:boolean; Np:Word);override;
// Procedure RealToGraph (InputData:TVector; var OutputData:TArrSingle;
//              Series: TLineSeries;
//              Xlog,Ylog:boolean; Np:Word);override;
//// Procedure RealToFile (InputData:PVector; var OutputData:TArrSingle;
////              Xlog,Ylog:boolean; suf:string);override;
// Procedure RealToFile (InputData:TVector; var OutputData:TArrSingle;
//              Xlog,Ylog:boolean; suf:string);override;
//protected
// fVector:TVector;
//public
//Constructor Create;
//Procedure Free;
////Function FinalFunc(var X:double;DeterminedParameters:TArrSingle):double; override;
//
//end;
//
//
//
////------------------------------------
//TFitTemperatureIsUsed=class(TFitVariabSet)
//{��� �������, �� ��������������� �����������}
//private
// fTemperatureIsRequired:boolean;
// {���� � ������� ����������� �� ���������������,
// ��������� ��� ���������� � �reate ��������� �� ����� � False}
// Constructor Create(FunctionName,FunctionCaption:string;
//                     Npar,Nvar:byte);
//// Procedure BeforeFitness(InputData:Pvector);override;
// Procedure BeforeFitness(InputData:TVector);override;
// procedure SetT(const Value: double);
// Function GetT():double;
//public
// property T:double read GetT write SetT;
//end; //TFitTemperature=class(TFitVariabSet)
//
////----------------------------------------------
//TFitVoltageIsUsed=class(TFitTemperatureIsUsed)
//{��� �������, �� ������� �������, ��� �����
//��������� � ����� �����}
//private
// fVoltageIsRequired:boolean;
// {��� ��������������� ���������
// ������������� ���������� �������� FVariab[0] ��������
// ������� �� ����� ��� ���������� � �reate
// ��������� �� ����� � True}
// Constructor Create(FunctionName,FunctionCaption:string;
//                     Npar,Nvar:byte);
//// Procedure BeforeFitness(InputData:Pvector);override;
// Procedure BeforeFitness(InputData:TVector);override;
//// Function DetermineVoltage(InputData:Pvector):double;overload;
// Function DetermineVoltage(InputData:TVector):double;//overload;
//public
//end; //TFitVoltageIsUsed=class(TFitTemperatureIsUsed)
//
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
//TFitSampleIsUsed=class(TFitSumFunction)
//{��� �������, �� ��������������� ��������� ������}
//private
// fSampleIsRequired:boolean;
// {���� � ������� ���� ��� ������ �� ���������������,
// ��������� ��� ���������� � �reate ��������� �� ����� � False}
// FSample: TDiodMaterial;
//// FSample:TDiod_Schottky;
// Constructor Create(FunctionName,FunctionCaption:string;
//                     Npar,Nvar:byte);
// Procedure FIsNotReadyDetermination;override;
//public
//end; //TFitSampleIsUsed=class(TFitSumFunction)
//
////----------------------------------------------
//TExponent=class (TFitSampleIsUsed)
//private
// Function Func(Parameters:TArrSingle):double; override;
//// Procedure RealFitting (InputData:PVector;
////               var OutputData:TArrSingle); override;
// Procedure RealFitting (InputData:TVector;
//               var OutputData:TArrSingle); override;
//public
// Constructor Create;
//end; // TDiod=class (TFitSampleIsUsed)
//
//TIvanov=class (TFitSampleIsUsed)
//private
//  Function Func(Parameters:TArrSingle):double; override;
////  Procedure RealFitting (InputData:PVector;
////         var OutputData:TArrSingle); override;
//  Procedure RealFitting (InputData:TVector;
//         var OutputData:TArrSingle); override;
//  Procedure FIsNotReadyDetermination;override;
////  Procedure RealToGraph (InputData:PVector; var OutputData:TArrSingle;
////              Series: TLineSeries;
////              Xlog,Ylog:boolean; Np:Word);override;
//  Procedure RealToGraph (InputData:TVector; var OutputData:TArrSingle;
//              Series: TLineSeries;
//              Xlog,Ylog:boolean; Np:Word);override;
//public
// Constructor Create;
// Function FinalFunc(var X:double;DeterminedParameters:TArrSingle):double; reintroduce; overload;
//end; // TIvanov=class (TFitSampleIsUsed)
//
////-----------------------------------------------
//TFitIteration=class (TFitSampleIsUsed)
//{��� ������������ ���������������
//����������� ������}
//private
// FNit:integer;//������� ��������
// Labels:array of TLabel;
// {����, �� ����������� �� ���� ��
// ��� ������������}
// FXmode:TArrVar_Rand; //��� ���������
// {���� ��� - cons, �� �������� �������������
// �� �������� X = A + B*t + C*t^2,
// �� �, � �� � - ���������, ��
// ����������� � ������� FA, FB �� FC,
// t - ���� ���� ����-��� ��������� �������� (FVariab),
// ��� ��������, �������� �� ��}
// FA,FB,FC:TArrSingle;
// FXt:array of integer;
// {���������� ������ ������� � FNx,
// �� ������ �����, ���'����� � ���,
// �� �������� �������� ����������������
// ��� ���������� cons-���������:
// 0 - �� ����������������, ����� �������� = �
// 1..FVarNum - t = FVariab[ FXt[i]-1 ]
// (FVarNum+1)..(2*FVarNum) - t = (FVariab[ FXt[i]- FVarNum - 1])^(-1)
// }
// FXvalue:TArrSingle;
//{�������� ���������, ���� ����  ����� ��� cons;
// �������� �� ���� ���� ��� ����,
// ��� �� �������� �� �������� X = A + B*t+ C*t^2
// ������� ����, � ���� �� ������� ������������}
// fIterWindow: TApp;
// {�����, ��� ���������� ����� ��������}
// procedure SetNit(value:integer);
// Procedure RealReadFromIniFile;override;
// {������������� ����� ���� � ini-�����, � ����� ���� - Nit,FXmode,FA,FB,FC,FXt}
// Procedure RealWriteToIniFile;override;
// {������������� ������ ���� � ini-����, � ����� ���� - Nit,,FXmode,FA,FB,FC,FXt}
// Procedure FIsNotReadyDetermination;override;
// Procedure GRParamToForm(Form:TForm);virtual;
// {��������� �� ����� ��� ��������� �����������
// ��������, ���'������ �������������
// � �����������, �� ������������}
// Procedure GRNitToForm(Form:TForm);
//{��������� �� ����� ��� ��������� �����������
// ��������, ���'������ � ������� ��������}
// Procedure GRElementsToForm(Form:TForm);override;
// Procedure GRSetValueNit(Component:TComponent;ToForm:boolean);
// {���� ��� ������� ��������}
// Procedure GRSetValueParam(Component:TComponent;ToForm:boolean);virtual;
// {���� ��� ��� ���������}
// Procedure GRRealSetValue(Component:TComponent;ToForm:boolean);override;
//// Procedure BeforeFitness(InputData:Pvector);override;
// Procedure BeforeFitness(InputData:TVector);override;
// Constructor Create(FunctionName,FunctionCaption:string;
//                     Npar,Nvar:byte);
//// Procedure IterWindowPrepare(InputData:PVector);overload;virtual;
// Procedure IterWindowPrepare(InputData:TVector);{overload;}virtual;
//{��������� ���� �� ������ �����}
// Procedure IterWindowDataShow(CurrentIterNumber:integer; InterimResult:TArrSingle);
// {����� ������ ����� ��������
//  �� �������� �����, �� ����������� � InterimResult}
// Procedure IterWindowClear;
// {�������� ���� ���� ������������}
// Procedure EndFitting(FinalResult:TArrSingle;
//              var OutputData:TArrSingle);virtual;
//{����������� ����� � FinalResult � OutputData,
//���������������, �� ������� � TrueFitting}
//// Procedure RealFitting (InputData:PVector;
////         var OutputData:TArrSingle); override;
// Procedure RealFitting (InputData:TVector;
//         var OutputData:TArrSingle); override;
// {��� ����� ����� �� ������� ��� ���������,
// �� ������������� ����� ������ � ������ fIterWindow,
// ���� ������������ ���������� � TrueFitting}
//// Procedure TrueFitting (InputData:PVector;
////         var OutputData:TArrSingle); overload;virtual;abstract;
// Procedure TrueFitting (InputData:TVector;
//         var OutputData:TArrSingle); {overload;}virtual;abstract;
//public
// property Nit:integer read FNit write SetNit;
//end;  // TFitIteration=class (TFitSampleIsUsed)
//
////--------------------------------------------------------
//TFitAdditionParam=class (TFitIteration)
//{� �������� ���������, �� �����
//������������ � ��������� ������������,
// ���������, ��� ��� ���� ���
// ��������� �� ������
// Voc, Isc, FF �� Pm}
//private
// fNAddX:byte;//������� ���������� ���������
// fIsDiod:boolean;
// fIsPhotoDiod:boolean;
// {���� ����� � ���� ���������� ������� True,
// �� ��� ���������� ���������� ���������
// ��������������� ���������� �������
// ��� ���� �� ���� ��� ��������� � ������
// ��������� �����}
// Constructor Create(FunctionName,FunctionCaption:string;
//                     Npar,Nvar,NaddX:byte);
// Procedure CreateFooter;virtual;
//// procedure AddParDetermination(InputData:PVector;
////                               var OutputData:TArrSingle); overload;virtual;
// procedure AddParDetermination(InputData:TVector;
//                               var OutputData:TArrSingle); {overload;}virtual;
//{�������������� �������� ���������}
//public
//// Procedure Fitting (InputData:PVector; var OutputData:TArrSingle;
////                    Xlog:boolean=False;Ylog:boolean=False);override;
// Procedure Fitting (InputData:TVector; var OutputData:TArrSingle;
//                    Xlog:boolean=False;Ylog:boolean=False);override;
//end;
//
////---------------------------------------------
//TFitFunctLSM=class (TFitAdditionParam)
//{��� �������, �� ������������ ����������
//�� ��������� ������ ��������� ��������
//� ����'����� ������� ������ �������
//����������� ���䳺������ ������}
//private
// fAccurancy:double;
//{��������, ���'����� � �������
// ���������� ������������ �������}
// Constructor Create(FunctionName,FunctionCaption:string;
//                     Npar:byte);
// Procedure RealReadFromIniFile;override;
// {������������� ����� ���� � ini-�����, � ����� ���� - fAccurancy}
// Procedure RealWriteToIniFile;override;
// {������������� ������ ���� � ini-����, � ����� ���� - fAccurancy}
// Procedure FIsNotReadyDetermination;override;
// Procedure GRParamToForm(Form:TForm);override;
// Procedure GRAccurToForm(Form:TForm);
//{��������� �� ����� ��� ��������� �����������
// ��������, ���'������ � �������
// ���������� ������������ �������}
// Procedure GRElementsToForm(Form:TForm);override;
// Procedure GRSetValueAccur(Component:TComponent;ToForm:boolean);
// {���� ��� ������� ��������}
// Procedure GRRealSetValue(Component:TComponent;ToForm:boolean);override;
//// Procedure BeforeFitness(InputData:Pvector);override;
// Procedure BeforeFitness(InputData:TVector);override;
//// Procedure IterWindowPrepare(InputData:PVector);override;
// Procedure IterWindowPrepare(InputData:TVector);override;
//// Procedure RealFitting (InputData:PVector;
////         var OutputData:TArrSingle); override;
// Procedure RealFitting (InputData:TVector;
//         var OutputData:TArrSingle); override;
//// Procedure TrueFitting (InputData:PVector;var OutputData:TArrSingle); override;
// Procedure TrueFitting (InputData:TVector;var OutputData:TArrSingle); override;
////------C������ ������� ��� ���-----------------------
//// Procedure InitialApproximation(InputData:PVector;var IA:TArrSingle);overload;virtual;
// Procedure InitialApproximation(InputData:TVector;var IA:TArrSingle);{overload;}virtual;
//  {�� ��������� � InputData ������� ��������� ����������
//  ��� ��������� � ���������� � IA,
//  ��� ���� �������������� ������� �������
//  ��� ������ IA �� Another}
//// Procedure IA_Begin(var AuxiliaryVector:PVector;var IA:TArrSingle);overload;
// Procedure IA_Begin(var AuxiliaryVector:TVector;var IA:TArrSingle);//overload;
//// Function IA_Determine3(Vector1,Vector2:PVector):double;overload;
// Function IA_Determine3(Vector1,Vector2:TVector):double;//overload;
//// Procedure IA_Determine012(AuxiliaryVector:PVector;var IA:TArrSingle);overload;
// Procedure IA_Determine012(AuxiliaryVector:TVector;var IA:TArrSingle);//overload;
//// Function ParamCorectIsDone(InputData:PVector;var IA:TArrSingle):boolean;overload;virtual;
// Function ParamCorectIsDone(InputData:TVector;var IA:TArrSingle):boolean;{overload;}virtual;
//{������������ �������� � IA, ��� �� ����� ���� ��������������� ���
//������������ InputData, ���� ���� �� ������� -
//����������� False}
//// Function ParamIsBad(InputData:PVector; IA:TArrSingle):boolean;overload;virtual;
// Function ParamIsBad(InputData:TVector; IA:TArrSingle):boolean;{overload;}virtual;
//  {�������� �� ��������� ����� ��������������� ���
//  ������������ ����� � InputData �������� I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh
//  IA[0] - n, IA[1] - Rs, IA[2] - I0, IA[3] - Rsh}
//// Function SquareFormIsCalculated(InputData:PVector; X:TArrSingle;
////             var RezF:TArrSingle; var RezSum:double):boolean;overload;virtual;
// Function SquareFormIsCalculated(InputData:TVector; X:TArrSingle;
//             var RezF:TArrSingle; var RezSum:double):boolean;{overload;}virtual;
// {������������ �������� ����������� ����� RezSum,
// ����������� ��� InputData �� ������� ��������� � �;
// ����� ������������ �������� ������� RezF,
// ��������� �� ������� �� ����������� �����;
// ��� �������� ������� ����������� False}
//// Function Secant(num:word;a,b,F:double;InputData:PVector;IA:TArrSingle):double;overload;
// Function Secant(num:word;a,b,F:double;InputData:TVector;IA:TArrSingle):double;//overload;
//  {������������ ���������� �������� ��������� al
//  � ����� ������������� ������;
//  ��������������� ����� ������쳿;
//  � �� b ������� ���������� ������, �� �������� ����'����}
//// Function SquareFormDerivate(InputData:Pvector;num:byte;al,F:double;
////                     X:TArrSingle):double;overload;virtual;
// Function SquareFormDerivate(InputData:TVector;num:byte;al,F:double;
//                     X:TArrSingle):double;{overload;}virtual;
//  {������������� �������� ������� ����������� �����,
//  ������� ��������������� ���  ��������������� ������ � ������������
//  ������� �� al, ��� ����� ����  ���� �� ������ ��������� ������������
//  Param = Param - al*F, ��  Param �������� �� num
//  F - �������� ������� ����������� ����� �� Param ��� al = 0
//  (��, �� ������� ������� SquareFormIsCalculated � RezF)}
//public
//end; // TFitFunctLSM=class (TFitAdditionParam)
//
////----------------------------------------------
//TDiodLSM=class (TFitFunctLSM)
//private
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TDiodLSM=class (TFitFunctLSM)
//
//
//TPhotoDiodLSM=class (TFitFunctLSM)
//private
//// Procedure InitialApproximation(InputData:PVector;var IA:TArrSingle);override;
// Procedure InitialApproximation(InputData:TVector;var IA:TArrSingle);override;
//{Param = n  ��� num = 0; Rs ��� 1; I0 ��� 2; Rsh ��� 3; Iph ��� 4}
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TPhotoDiodLSM=class (TFitFunctLSM)
//
//TDiodLam=class (TFitFunctLSM)
//private
//// Function ParamIsBad(InputData:PVector; IA:TArrSingle):boolean;override;
// Function ParamIsBad(InputData:TVector; IA:TArrSingle):boolean;override;
// {�������� �� ��������� ����� ��������������� ���
// ������������ ����� � InputData �������� ��������,
// IA[0] - n, IA[1] - Rs, IA[2] - I0, IA[3] - Rsh}
//// Function SquareFormIsCalculated(InputData:PVector; X:TArrSingle;
////             var RezF:TArrSingle; var RezSum:double):boolean;override;
// Function SquareFormIsCalculated(InputData:TVector; X:TArrSingle;
//             var RezF:TArrSingle; var RezSum:double):boolean;override;
//// Function SquareFormDerivate(InputData:Pvector;num:byte;al,F:double;
////                     X:TArrSingle):double;overload;override;
// Function SquareFormDerivate(InputData:TVector;num:byte;al,F:double;
//                     X:TArrSingle):double;overload;override;
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TDiodLam=class (TFitFunctLSM)
//
//TPhotoDiodLam=class (TFitFunctLSM)
//private
//// Procedure InitialApproximation(InputData:PVector;var  IA:TArrSingle);override;
// Procedure InitialApproximation(InputData:TVector;var  IA:TArrSingle);override;
//// Function ParamCorectIsDone(InputData:PVector;var IA:TArrSingle):boolean;override;
// Function ParamCorectIsDone(InputData:TVector;var IA:TArrSingle):boolean;override;
//// Function ParamIsBad(InputData:PVector; IA:TArrSingle):boolean;override;
// Function ParamIsBad(InputData:TVector; IA:TArrSingle):boolean;override;
// {�������� �� ��������� ����� ��������������� ���
// ������������ ��� ��� ��������� � InputData ������� ��������,
//  A[0] - n, IA[1] - Rs, IA[2] - Isc, IA[3] - Rsh, IA[3] - Voc}
//// Function SquareFormIsCalculated(InputData:PVector; X:TArrSingle;
////             var RezF:TArrSingle; var RezSum:double):boolean;override;
// Function SquareFormIsCalculated(InputData:TVector; X:TArrSingle;
//             var RezF:TArrSingle; var RezSum:double):boolean;override;
//{X[0] - n, X[1] - Rs, X[2] -  Rsh, X[3] -  Isc, X[4] - Voc;
//RezF[0] - ������� �� n, RezF[1] - �� Rs, RezF[3] - �� Rsh}
//// Function SquareFormDerivate(InputData:Pvector;num:byte;al,F:double;
////                     X:TArrSingle):double;override;
// Function SquareFormDerivate(InputData:TVector;num:byte;al,F:double;
//                     X:TArrSingle):double;override;
// Procedure EndFitting(FinalResult:TArrSingle;
//              var OutputData:TArrSingle);override;
// Function Func(Parameters:TArrSingle):double; override;
//public
// Constructor Create;
//end; // TPhotoDiodLam=class (TFitFunctLSM)
//
////---------------------------------------------
//TFitFunctEvolution=class (TFitAdditionParam)
//{��� �������, �� ������������ ����������
//�� ��������� ����������� ������}
//private
// FXmin:TArrSingle; //��������� �������� ������ ��� ������������
// FXmax:TArrSingle; //����������� �������� ������ ��� ������������
// FXminlim:TArrSingle; //��������� �������� ������ ��� ������������ ������
// FXmaxlim:TArrSingle; //����������� �������� ������ ��� ������������ ������
// FEvType:TEvolutionType; //����������� �����,���� ��������������� ��� ������������
// fY:double;//���� ��� ��������� �������� Y � �����, �� ��������������
// Constructor Create(FunctionName,FunctionCaption:string;
//                     Npar,Nvar,NaddX:byte);
// Procedure RealReadFromIniFile;override;
// {������������� ����� ���� � ini-�����, � ����� ���� - �� ����}
// Procedure RealWriteToIniFile;override;
// {������������� ������ ���� � ini-����, � ����� ���� - �� ����}
// Procedure FIsNotReadyDetermination;override;
// Procedure GREvTypeToForm(Form:TForm);
// {��������� �� ����� ��� ��������� �����������
// ��������, ���'������ � �����
// ������������ ������ }
// Procedure GRElementsToForm(Form:TForm);override;
// Procedure GRSetValueEvType(Component:TComponent;ToForm:boolean);
// {���� ��� ��� ������������ ������}
// Procedure GRSetValueParam(Component:TComponent;ToForm:boolean);override;
// Procedure GRRealSetValue(Component:TComponent;ToForm:boolean);override;
//// Procedure TrueFitting (InputData:PVector;var OutputData:TArrSingle); override;
// Procedure TrueFitting (InputData:TVector;var OutputData:TArrSingle); override;
// Procedure PenaltyFun(var X:TArrSingle);
// {��������� ������ �������� ��������� � ����� X,
// �� ����������� ��� ������������ ������������ ��������,
// ��������� �� �������� ��������� �������� -
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
// ������  � � �������� �� FXmin �� FXmax}
//// Procedure  EvFitInit(InputData:PVector;var X:TArrArrSingle; var Fit:TArrSingle);overload;
// Procedure  EvFitInit(InputData:TVector;var X:TArrArrSingle; var Fit:TArrSingle);//overload;
// {��������� ������������ ���������� ������� � �
// �� ���������� ���������� ������� ������� �������}
// Procedure EvFitShow(X:TArrArrSingle; Fit:TArrSingle; Nit,Nshow:integer);
// {��������� ���� ������� �� ���� �� ��� ���������� ������������,
// ���� Nit ������ Nshow}
//// Procedure MABCFit (InputData:PVector;var OutputData:TArrSingle);overload;
// Procedure MABCFit (InputData:TVector;var OutputData:TArrSingle);//overload;
//  {�������������� ���� � ������ InputData �� �������
//  modified artificial bee colony;
//  ���������� ������������ ��������� � OutputData}
//// Procedure PSOFit (InputData:PVector;var OutputData:TArrSingle);overload;
// Procedure PSOFit (InputData:TVector;var OutputData:TArrSingle);//overload;
//  {�������������� ���� � ������ InputData �� �������
//  particle swarm optimization;
//  ���������� ������������ ��������� � OutputData}
//// Procedure DEFit (InputData:PVector;var OutputData:TArrSingle);overload;
// Procedure DEFit (InputData:TVector;var OutputData:TArrSingle);//overload;
//  {�������������� ���� � ������ InputData �� �������
//  differential evolution;
//  ���������� ������������ ��������� � OutputData}
//// Procedure TLBOFit (InputData:PVector;var OutputData:TArrSingle);overload;
// Procedure TLBOFit (InputData:TVector;var OutputData:TArrSingle);//overload;
//  {�������������� ���� � ������ InputData �� �������
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
// ������������� ������� (�� ��������
// ����������) �������� �������������
// ������������ ���� �� �������;
// ���������, ��������������� ����������
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
//var
// FitFunction:TFitFunction;
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
  SysUtils, Forms, Dialogs;

{ TOIniFileNew }

function TOIniFileNew.ReadEvType(const Section, Ident: string): TEvolutionType;
begin
  try
    Result:=TEvolutionType(ReadInteger(Section, Ident,0));
  except
    Result:=TEvolutionType(0);
  end;
end;

function TOIniFileNew.ReadRand(const Section, Ident: string): TVar_Rand;
begin
  try
    Result:=TVar_Rand(ReadInteger(Section, Ident,2));
  except
    Result:=TVar_Rand(2);
  end;
end;

procedure TOIniFileNew.WriteEvType(const Section, Ident: string;
  Value: TEvolutionType);
begin
 WriteInteger(Section, Ident,ord(Value));
end;

procedure TOIniFileNew.WriteRand(const Section, Ident: string;
                                 Value: TVar_Rand);
begin
  WriteInteger(Section, Ident,ord(Value));
end;

{ TFitFunctionNew }

constructor TFitFunctionNew.Create(FunctionName, FunctionCaption: string);
begin
 inherited Create;
 DecimalSeparator:='.';
 FName:=FunctionName;
 FCaption:=FunctionCaption;
 fHasPicture:=False;
 FPictureName:=FName+'Fig';
 fIsReadyToFit:=False;
 fResultsIsReady:=False;
 // fFileHeading:='';
 DataContainerCreate;
 DipazonCreate;
 fConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
 ReadFromIniFile;

// fDataToFit:TVector; //���� ��� ������������
// fDiapazon:TDiapazon; //��� � ���� ���������� ������������

end;

procedure TFitFunctionNew.DataContainerCreate;
begin
  fDataToFit:=TVectorTransform.Create;
  FittingData:=TVector.Create;
end;

procedure TFitFunctionNew.DataContainerDestroy;
begin
  fDataToFit.Free;
  FittingData.Free;
end;

destructor TFitFunctionNew.Destroy;
begin
  DataContainerDestroy;
  DiapazonDestroy;
  fConfigFile.Free;
  inherited;
end;

procedure TFitFunctionNew.DiapazonDestroy;
begin
 fDiapazon.Free;
end;

procedure TFitFunctionNew.DipazonCreate;
begin
 fDiapazon:=TDiapazon.Create;
 fDiapazon.Crear;
end;

procedure TFitFunctionNew.Fitting(InputData: TVector);
begin
 fResultsIsReady:=false;
 FittingData.Clear;
 if not(fIsReadyToFit) then
     begin
       MessageDlg('To tune options, please',mtWarning, [mbOk], 0);
//       showmessage('To tune options, please');
       Exit;
     end;
 DataPreraration(InputData);
 if fDataToFit.IsEmpty then
    begin
       MessageDlg('No data to fit',mtWarning, [mbOk], 0);
       Exit;
    end;
 RealFitting;
end;

procedure TFitFunctionNew.DataPreraration(InputData: TVector);
var
  tempVector: TVectorTransform;
begin
  tempVector := TVectorTransform.Create;
  tempVector.CopyFrom(InputData);
  tempVector.N_Begin := 0;
  tempVector.CopyDiapazonPoint(fDataToFit, fDiapazon);
  tempVector.Free;
end;

procedure TFitFunctionNew.ReadFromIniFile;
begin
  fDiapazon.ReadFromIniFile(fConfigFile,FName,'DiapazonFit');
end;


procedure TFitFunctionNew.WriteToIniFile;
begin
 fDiapazon.WriteToIniFile(fConfigFile,FName,'DiapazonFit');
end;

end.
