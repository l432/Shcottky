﻿unit OlegApprox;

interface

uses OlegType,Dialogs,SysUtils,Math,Forms,FrApprPar,Windows,
      Messages,Controls,FrameButtons,IniFiles,ExtCtrls,Graphics,
      OlegMath,ApprWindows,StdCtrls,FrParam,Series,Classes,
      OlegGraph,OlegMaterialSamples,OlegFunction;

const
  FuncName:array[0..36]of string=
           ('None','Linear','Quadratic','Exponent','Smoothing',
           'Median filtr','Derivative','Gromov / Lee','Ivanov',
           'Diod','PhotoDiod','Diod, LSM','PhotoDiod, LSM',
           'Diod, Lambert','PhotoDiod, Lambert','Two Diod',
           'Two Diod Full','D-Gaussian','Patch Barrier',
           'D-Diod', 'Photo D-Diod','Tunneling','Two power','TE and SCLC',
           'TE and SCLC (II)','TE and SCLC (III)','TE reverse',
           'Ir on 1/T (I)','Ir on 1/T (II)','Ir on 1/T (IIa)','Ir on 1/T (III)',
           'Brailsford on T','Brailsford on w',
           'Phonon Tunneling on 1/kT','Phonon Tunneling on V',
           'TE and Phonon Tunn. on 1/kT','TE and Phonon Tunn. on V');
type

  TVar_Rand=(lin,logar,cons);
  {для змінних, які використовуються у еволюційних методах,
  norm - еволюціонує значення змінної
  logar - еволюціонує значення логарифму змінної
  сons - змінна залишається сталою}
  TArrVar_Rand=array of TVar_Rand;
  PTArrVar_Rand=^TArrVar_Rand;

  TEvolutionType= //еволюційний метод, який використовується для апроксимації
    (TDE, //differential evolution
     TMABC, // modified artificial bee colony
     TTLBO,  //teaching learning based optimization algorithm
     TPSO    // particle swarm optimization
     );
  {}

TOIniFile=class (TIniFile)
public
function ReadRand(const Section, Ident: string): TVar_Rand; virtual;
procedure WriteRand(const Section, Ident: string; Value: TVar_Rand); virtual;
function ReadEvType(const Section, Ident: string; Default: TEvolutionType): TEvolutionType; virtual;
procedure WriteEvType(const Section, Ident: string; Value: TEvolutionType); virtual;
end;



TFitFunction=class //(TObject)//
{найпростіший клас для апроксимацій,
де нема визначення параметрів}
private
 FName:string;//ім'я функції
 FCaption:string; // опис функції
 FPictureName:string;//ім'я  рисунку в ресурсах, за умовчанням FName+'Fig';
 FXname:TArrStr; // імена змінних
 fHasPicture:boolean;//наявність картинки
 Constructor Create(FunctionName,FunctionCaption:string);
 Procedure RealToGraph (InputData:PVector; var OutputData:TArrSingle;
              Series: TLineSeries;
              Xlog,Ylog:boolean; Np:Word); virtual;abstract;
 {див. FittingGraph}
 Procedure RealToFile (InputData:PVector; var OutputData:TArrSingle;
              Xlog,Ylog:boolean; suf:string);virtual;abstract;
 {див. FittingGraphFile}
 Procedure PictureToForm(Form:TForm;maxWidth,maxHeight,Top,Left:integer);
public
 property Name:string read FName;
 property PictureName:string read FPictureName;
 property Caption:string read FCaption;
 property Xname:TArrStr read FXname;
 property HasPicture:boolean read fHasPicture;
 procedure SetValueGR;virtual;
 Function FinalFunc(X:double;DeterminedParameters:TArrSingle;
     Xlog:boolean=False;Ylog:boolean=False):double; virtual;abstract;
 {обчислюються значення апроксимуючої функції в
 точці з абсцисою Х, найчастіше значення співпадає
 з тим, що повертає Func при Fparam[0]=X,
 крім того, дозволяє
 обчислювати значення, якщо здійснювалась апроксимація
 даних, представлених у логарифмічному масштабі
 Xlog = True - абсциси у у логарифмічному масштабі,
 Ylog = True - ординати у логарифмічному масштабі}
 Procedure Fitting (InputData:PVector; var OutputData:TArrSingle;
             Xlog:boolean=False;Ylog:boolean=False);virtual;abstract;
 {фактично, обгортка для процедури RealFitting,
 де дійсно відбувається апроксимація;
 ця процедура лише виловлює помилки,
 і при невдалому процесі показується повідомлення,
 в OutputData[0] - ErResult;
 загалом розмір OutputData  після процедури співпадає з
 кількістю шуканих параметрів;
 останні змінні дозволяють апроксимувати дані,
 представлені у векторі InputData у логарифмічному масштабі
 Xlog = True - абсциси у у логарифмічному масштабі,
 Ylog = True - ординати у логарифмічному масштабі}
 Procedure FittingGraph (InputData:PVector; var OutputData:TArrSingle;
              Series: TLineSeries;
              Xlog:boolean=False;Ylog:boolean=False;
              Np:Word=150);virtual;
 {апроксимація і дані вносяться в Series -
 щоб можна було побудувати графік
 Np - кількість точок на графіку,
 Xlog,Ylog див. Fitting
 фактично це обгортка для RealToGraph, яка
 у нащадках може мінятися}
 Procedure FittingGraphFile (InputData:PVector; var OutputData:TArrSingle;
              Series: TLineSeries;
              Xlog:boolean=False;Ylog:boolean=False;
              Np:Word=150; suf:string='fit');virtual;
 {апроксимація, дані вносяться в Series, крім
 того апроксимуюча крива заноситься в файл -
 третім стопчиком;
 назва файлу -- V^.name + suf,
 Xlog,Ylog див. Fitting,
 фактично це обгортка для RealToFile, яка
 у нащадках може мінятися}
 Procedure FittingDiapazon (InputData:PVector; var OutputData:TArrSingle;
                            D:TDiapazon);virtual;abstract;
{апроксимуються дані у векторі V відповідно до обмежень
 в D, отримані параметри розміщуються в OutputData}
 Function Deviation (InputData:PVector):double;virtual;abstract;
 {повертає середнеє квадратичне відносне
 відхилення апроксимації даних у InputData
 від самих даних}
 Procedure DataToStrings(DeterminedParameters:TArrSingle;
                         OutStrings:TStrings);virtual;abstract;
 {в OutStrings додаються рядки, які містять
 назви всіх визначених величин та їх значення,
 які розташовані в DeterminedParameters}
 end;   // TFitFunc=class

//--------------------------------------------------------------------
TFitWithoutParameteres=class (TFitFunction)
private
  FtempVector:PVector;  //результати операції саме тут розміщуються
  FErrorMessage:string; //виводиться при помилці
  procedure RealTransform(InputData:PVector);
  {cаме тут в FtempVector вноситься перетворений потрібним чином InputData}
  Procedure RealToGraph (InputData:PVector; var OutputData:TArrSingle;
              Series: TLineSeries;
              Xlog,Ylog:boolean; Np:Word); override;
  Procedure RealToFile (InputData:PVector; var OutputData:TArrSingle;
              Xlog,Ylog:boolean; suf:string);override;
public
 Constructor Create(FunctionName:string);
 Procedure Free;
 Function FinalFunc(X:double;DeterminedParameters:TArrSingle;
                     Xlog:boolean=False;Ylog:boolean=False):double;override;
 Procedure Fitting (InputData:PVector; var OutputData:TArrSingle;
                    Xlog:boolean=False;Ylog:boolean=False);override;
 Procedure FittingDiapazon (InputData:PVector;
                   var OutputData:TArrSingle;D:TDiapazon);override;
 Function Deviation (InputData:PVector):double;override;
 Procedure DataToStrings(DeterminedParameters:TArrSingle;
                         OutStrings:TStrings);override;
end;  //TFitWithoutParameteres=class (TFitFunction)

//--------------------------------------------------------------------
TFitFunctionSimple=class (TFitFunction)
{абстрактний клас для функцій, де визначаються параметри}
private
  FNx:byte;//кількість параметрів, які визначаються
  fX:double; //змінна Х, яка використовується для розрахунку функцій
  fYminDontUsed:boolean;
 {використовується в FittingDiapazon,
 для тих нащадків, де не потрібно враховувати
 обмеження на мінімальне значення ординати
 (ВАХ освітлених елементів),
 необхідно встановити в Create в True}
 Constructor Create(FunctionName,FunctionCaption:string;N:byte);
 Function Func(Parameters:TArrSingle):double; virtual;abstract;
  {апроксимуюча функція... точніше та, яка використовується
  при побудові цільової функції;
  вона не завжди   співпадає з апроксимуючою -
  наприклад як для Diod  задля економії часу}
 Function RealFunc(Parameters:TArrSingle):double; virtual;
  {а ось це - апроксимуюча функція,
  за умовчанням співпадає з Func}
 Procedure RealFitting (InputData:PVector;
         var OutputData:TArrSingle); virtual;abstract;
 {апроксимуються дані у векторі InputData, отримані параметри
 розміщуються в OutputData;}
 Procedure RealToGraph (InputData:PVector; var OutputData:TArrSingle;
              Series: TLineSeries;
              Xlog,Ylog:boolean; Np:Word); override;
 Procedure RealToFile (InputData:PVector; var OutputData:TArrSingle;
              Xlog,Ylog:boolean; suf:string);override;
public
 Function FinalFunc(X:double;DeterminedParameters:TArrSingle;
                     Xlog:boolean=False;Ylog:boolean=False):double; override;
 {обчислюються значення апроксимуючої функції в
 точці з абсцисою Х, найчастіше значення співпадає
 з тим, що повертає Func при fX=X,
 крім того, дозволяє
 обчислювати значення, якщо здійснювалась апроксимація
 даних, представлених у логарифмічному масштабі
 Xlog = True - абсциси у у логарифмічному масштабі,
 Ylog = True - ординати у логарифмічному масштабі
}
 Procedure Fitting (InputData:PVector; var OutputData:TArrSingle;
                    Xlog:boolean=False;Ylog:boolean=False);override;
 Procedure FittingDiapazon (InputData:PVector; var OutputData:TArrSingle;
                            D:TDiapazon);override;
 Function Deviation (InputData:PVector):double;override;
 Procedure DataToStrings(DeterminedParameters:TArrSingle;
                         OutStrings:TStrings);override;
end;   // TFitFunc=class

//--------------------------------------------------------------------
TLinear=class (TFitFunctionSimple)
private
  Procedure RealFitting (InputData:PVector; var OutputData:TArrSingle);override;
  Function Func(Parameters:TArrSingle):double; override;
public
  Constructor Create;
end; // TLinear=class (TFitFunction)

TQuadratic=class (TFitFunctionSimple)
private
  Procedure RealFitting (InputData:PVector; var OutputData:TArrSingle);override;
  Function Func(Parameters:TArrSingle):double; override;
public
  Constructor Create;
end; // TQuadratic=class (TFitFunction)

TGromov=class (TFitFunctionSimple)
private
  Procedure RealFitting (InputData:PVector;var OutputData:TArrSingle);override;
  Function Func(Parameters:TArrSingle):double; override;
public
  Constructor Create;
end; // TGromov=class (TFitFunction)

//-----------------------------------------------
TFitVariabSet=class(TFitFunctionSimple)
{для функцій, де потрібно більше величин ніж лише Х та Y}
private
 FVarNum:byte; //кількість додаткових (крім X та Y) величин, які потрібні для розрахунку функції
 FVariab:TArrSingle;
 {величини, які потрібні для розрахунку функції}
 FVarName:array of string;  //імена додаткових величин
 FVarBool:array of boolean;
 {якщо True, то значення відповідної додаткової
 величини відповідає  введеному значенню, а не
 визначається програмно - наприклад,
 температура береться не з парметрів Pvector}
 FVarManualDefinedOnly:array of boolean;
 {якщо True, то відповідна величина
 може визначатися лише завдяки зовнішньому введенню;
 за умовчанням False, міняються величини лише
 в Create}
 FVarValue:TArrSingle;
 {ці значення додаткових величин,
 вони зберігаються в .ini-файлі}
 FIsNotReady:boolean;
{показує, чи всі дані присутні і, отже, чи функція готова
 для використання}
 FConfigFile:TOIniFile;//для роботи з .ini-файлом
 Constructor Create(FunctionName,FunctionCaption:string;
                     Npar,Nvar:byte);
 Procedure FIsNotReadyDetermination;virtual;
 {по значенням полів визначається, чи готові дані до
 апроксимації}
 Procedure ReadFromIniFile;virtual;
 {зчитує дані з ini-файла, обгортка для RealReadFromIniFile}
 Procedure RealReadFromIniFile;virtual;
 {безпосередньо зчитує дані з ini-файла, в цьому класі - FVarValue, FVarBool}
 Procedure WriteToIniFile;virtual;
 {записує дані в ini-файл, обгортка для RealWriteToIniFile}
 Procedure RealWriteToIniFile;virtual;
 {безпосередньо записує дані в ini-файл, в цьому класі - FVarValue, FVarBool}
 Procedure BeforeFitness(InputData:Pvector);virtual;
 {виконується перед початком апроксимації,
 полягає у заповненні полів потрібними
 значеннями}
 Procedure WriteIniDefFit(const Ident: string;Value:double);overload;
 {записує дані в секцію з ім'ям FName використовуючи FConfigFile}
 Procedure WriteIniDefFit(const Ident: string;Value:integer);overload;
 Procedure WriteIniDefFit(const Ident: string;Value:Boolean);overload;
 Procedure WriteIniDefFit(const Ident: string; var Value:TVar_Rand);overload;
 Procedure  ReadIniDefFit(const Ident: string; var Value:double);overload;
 {зчитує  дані з секції з ім'ям FName використовуючи FConfigFile}
 Procedure  ReadIniDefFit(const Ident: string; var Value:integer);overload;
 Procedure  ReadIniDefFit(const Ident: string; var Value:boolean);overload;
 Procedure ReadIniDefFit(const Ident: string; var Value:TVar_Rand);overload;
 Procedure GRFormPrepare(Form:TForm);
  {початкове створення форми для керування параметрами}
 Procedure GRElementsToForm(Form:TForm);
 {виведення різноманітних елементів на форму
  для керування параметрами, фактично -
  обгортка для інших функцій} virtual;
 Function  GrVariabLeftDefine(Form: TForm):integer;
 Function GrVariabTopDefine(Form: TForm):integer;
 {залежно від того, що є на формі,
 визначається положення, де будуть виводитися
 елементи в наступній процедурі}
 Procedure GRVariabToForm(Form:TForm);
 {виводяться в стовпчик елементи, пов'язані
 з додатковими величинами}
 Procedure GRFieldFormExchange(Form:TForm;ToForm:boolean);
 {при ToForm=True заповнення значень елементів на формі
  для керування параметрами,
  при ToForm=False зчитування значень звідти;
  фактично -  обгортка для GRRealSetValue}
 Procedure GRRealSetValue(Component:TComponent;ToForm:boolean);virtual;
 {заповнюється/зчитуються значення компонента Component}
 Procedure GRSetValueVariab(Component:TComponent;ToForm:boolean);
 {якщо Component зв'язаний з додатковими
 величинами, то заповнюються/зчитуються його значення}
 Procedure GRButtonsToForm(Form:TForm);
 {На форму виводяться кнопки Ok, Cancel}
public
 Procedure Fitting (InputData:PVector; var OutputData:TArrSingle;
                    Xlog:boolean=False;Ylog:boolean=False);override;
 procedure SetValueGR;override;
 {показ форми для керування параметрами апроксимації}
end;   // TFitVariabSet=class(TFitFunctionSimple)

//------------------------------------
TFitTemperatureIsUsed=class(TFitVariabSet)
{для функцій, де використовується температура}
private
 fTemperatureIsRequired:boolean;
 {якщо у функції температура не використовується,
 необхідно для спадкоємців у Сreate поставити цю змінну в False}
 Constructor Create(FunctionName,FunctionCaption:string;
                     Npar,Nvar:byte);
 Procedure BeforeFitness(InputData:Pvector);override;
public
end; //TFitTemperature=class(TFitVariabSet)

//----------------------------------------------
TFitSampleIsUsed=class(TFitTemperatureIsUsed)
{для функцій, де використовується параметри зразка}
private
 fSampleIsRequired:boolean;
 {якщо у функції дані про зразок не використовується,
 необхідно для спадкоємців у Сreate поставити цю змінну в False}
 FSample:TDiodSample;
 Constructor Create(FunctionName,FunctionCaption:string;
                     Npar,Nvar:byte);
 Procedure FIsNotReadyDetermination;override;
public
end; //TFitSampleIsUsed=class(TFitTemperatureIsUsed))

//----------------------------------------------
TExponent=class (TFitSampleIsUsed)
private
 Function Func(Parameters:TArrSingle):double; override;
 Procedure RealFitting (InputData:PVector;
               var OutputData:TArrSingle); override;
public
 Constructor Create;
end; // TDiod=class (TFitSampleIsUsed)

TIvanov=class (TFitSampleIsUsed)
private
  Function Func(Parameters:TArrSingle):double; override;
  Procedure RealFitting (InputData:PVector;
         var OutputData:TArrSingle); override;
  Procedure FIsNotReadyDetermination;override;
  Procedure RealToGraph (InputData:PVector; var OutputData:TArrSingle;
              Series: TLineSeries;
              Xlog,Ylog:boolean; Np:Word);override;
public
 Constructor Create;
 Function FinalFunc(var X:double;DeterminedParameters:TArrSingle):double; reintroduce; overload;
end; // TIvanov=class (TFitSampleIsUsed)

//-----------------------------------------------
TFitIteration=class (TFitSampleIsUsed)
{при апроксимації використовується
ітераційний процес}
private
 FNit:integer;//кількість ітерацій
 Labels:array of TLabel;
 {мітки, які показуються на вікні під
 час апроксимації}
 FXmode:TArrVar_Rand; //тип параметрів
 {якщо тип - cons, то параметр розраховується
 за формулою X = A + B*t + C*t^2,
 де А, В та С - константи, які
 зберігаються в масивах FA, FB та FC,
 t - може бути будь-яка додаткова величина (FVariab),
 або величина, обернена до неї}
 FA,FB,FC:TArrSingle;
 FXt:array of integer;
 {розмірність масиву зпівпадає з FNx,
 він містить числа, пов'язані з тим,
 як додаткові величини використовуються
 для розрахунку cons-параметра:
 0 - не використовуються, тобто параметр = А
 1..FVarNum - t = FVariab[ FXt[i]-1 ]
 (FVarNum+1)..(2*FVarNum) - t = (FVariab[ FXt[i]- FVarNum - 1])^(-1)
 }
 FXvalue:TArrSingle;
{значення параметрів, якщо вони  мають тип cons;
 фактично це поле дише для того,
 щоб не рахувати за формулою X = A + B*t+ C*t^2
 кожного разу, а лише на початку апроксимації}
 fIterWindow: TApp;
 {форма, яка показується підчас ітерацій}
 procedure SetNit(value:integer);
 Procedure RealReadFromIniFile;override;
 {безпосередньо зчитує дані з ini-файла, в цьому класі - Nit,FXmode,FA,FB,FC,FXt}
 Procedure RealWriteToIniFile;override;
 {безпосередньо записує дані в ini-файл, в цьому класі - Nit,,FXmode,FA,FB,FC,FXt}
 Procedure FIsNotReadyDetermination;override;
 Procedure GRParamToForm(Form:TForm);virtual;
 {виведення на форму для керування параметрами
 елементів, пов'язаних безпосередньо
 з параметрами, які визначаються}
 Procedure GRNitToForm(Form:TForm);
{виведення на форму для керування параметрами
 елементів, пов'язаних з кількістю ітерацій}
 Procedure GRElementsToForm(Form:TForm);override;
 Procedure GRSetValueNit(Component:TComponent;ToForm:boolean);
 {дані про кількість ітерацій}
 Procedure GRSetValueParam(Component:TComponent;ToForm:boolean);virtual;
 {дані про тип параметрів}
 Procedure GRRealSetValue(Component:TComponent;ToForm:boolean);override;
 Procedure BeforeFitness(InputData:Pvector);override;
 Constructor Create(FunctionName,FunctionCaption:string;
                     Npar,Nvar:byte);
 Procedure IterWindowPrepare(InputData:PVector);virtual;
{підготовка вікна до показу даних}
 Procedure IterWindowDataShow(CurrentIterNumber:integer; InterimResult:TArrSingle);
 {показ номера біжучої ітерації
  та проміжних даних, які знаходяться в InterimResult}
 Procedure IterWindowClear;
 {очищення вікна після апроксимації}
 Procedure EndFitting(FinalResult:TArrSingle;
              var OutputData:TArrSingle);virtual;
{перенесення даних з FinalResult в OutputData,
використовується, як правило в TrueFitting}
 Procedure RealFitting (InputData:PVector;
         var OutputData:TArrSingle); override;
 {для цього класу та нащадків стає обгорткою,
 де забезпечується певна робота з формою fIterWindow,
 сама інтерполяція відбувається в TrueFitting}
 Procedure TrueFitting (InputData:PVector;
         var OutputData:TArrSingle); virtual;abstract;
public
 property Nit:integer read FNit write SetNit;
end;  // TFitIteration=class (TFitSampleIsUsed)

//--------------------------------------------------------
TFitAdditionParam=class (TFitIteration)
{є додаткові параметри, які також
визначаються в пезультаті апроксимації,
 наприклад, для ВАХ діода при
 освітленні це будуть
 Voc, Isc, FF та Pm}
private
 fNAddX:byte;//кількість додаткових параметрів
 fIsDiod:boolean;
 fIsPhotoDiod:boolean;
 {якщо якась з двох попередніх величин True,
 то при обчисленні додаткових параметрів
 використовується стандартна функція
 для діода чи діода при освітленні в рамках
 однодіодної моделі}
 Constructor Create(FunctionName,FunctionCaption:string;
                     Npar,Nvar,NaddX:byte);
 procedure AddParDetermination(InputData:PVector;
                               var OutputData:TArrSingle); virtual;
{розраховуються додаткові параметри}
public
 Procedure Fitting (InputData:PVector; var OutputData:TArrSingle;
                    Xlog:boolean=False;Ylog:boolean=False);override;
end;

//---------------------------------------------
TFitFunctLSM=class (TFitAdditionParam)
{для функцій, де апроксимація відбувається
за допомогою методу найменших квадратів
з розв'язком системи рівнянь методом
покрокового градієнтного спуску}
private
 fAccurancy:double;
{величина, пов'язана з критерієм
 припинення ітераційного процесу}
 Constructor Create(FunctionName,FunctionCaption:string;
                     Npar:byte);
 Procedure RealReadFromIniFile;override;
 {безпосередньо зчитує дані з ini-файла, в цьому класі - fAccurancy}
 Procedure RealWriteToIniFile;override;
 {безпосередньо записує дані в ini-файл, в цьому класі - fAccurancy}
 Procedure FIsNotReadyDetermination;override;
 Procedure GRParamToForm(Form:TForm);override;
 Procedure GRAccurToForm(Form:TForm);
{виведення на форму для керування параметрами
 елементів, пов'язаних з критерієм
 припинення ітераційного процесу}
 Procedure GRElementsToForm(Form:TForm);override;
 Procedure GRSetValueAccur(Component:TComponent;ToForm:boolean);
 {дані про кількість ітерацій}
 Procedure GRRealSetValue(Component:TComponent;ToForm:boolean);override;
 Procedure BeforeFitness(InputData:Pvector);override;
 Procedure IterWindowPrepare(InputData:PVector);override;
 Procedure RealFitting (InputData:PVector;
         var OutputData:TArrSingle); override;
 Procedure TrueFitting (InputData:PVector;var OutputData:TArrSingle); override;
//------Cлужбові функції для МНК-----------------------
 Procedure InitialApproximation(InputData:PVector;var IA:TArrSingle);virtual;
  {по значенням в InputData визначає початкове наближення
  для параметрів і заносяться в IA,
  крім того встановлюються потрібні довжини
  для масивів IA та Another}
 Procedure IA_Begin(var AuxiliaryVector:PVector;var IA:TArrSingle);
 Function IA_Determine3(Vector1,Vector2:PVector):double;
 Procedure IA_Determine012(AuxiliaryVector:PVector;var IA:TArrSingle);
 Function ParamCorectIsDone(InputData:PVector;var IA:TArrSingle):boolean;virtual;
{коректуються величини в IA, щоб їх можна було використовувати для
апроксимації InputData, якщо таки не вдалося -
повертається False}
 Function ParamIsBad(InputData:PVector; IA:TArrSingle):boolean;virtual;
  {перевіряє чи параметри можна використовувати для
  апроксимації даних в InputData функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh
  IA[0] - n, IA[1] - Rs, IA[2] - I0, IA[3] - Rsh}
 Function SquareFormIsCalculated(InputData:PVector; X:TArrSingle;
             var RezF:TArrSingle; var RezSum:double):boolean;virtual;
 {обчислюються значення квадратичної форми RezSum,
 розрахованої для InputData та значень параметрів в Х;
 також обчислюються значення функцій RezF,
 отриманих як похідні від квадратичної форми;
 при невдалих спробах повертається False}
 Function Secant(num:word;a,b,F:double;InputData:PVector;IA:TArrSingle):double;
  {обчислюється оптимальне значення параметра al
  в методі поординатного спуску;
  використовується метод дихотомії;
  а та b задають початковий відрізок, де шукається розв'язок}
 Function SquareFormDerivate(InputData:Pvector;num:byte;al,F:double;
                     X:TArrSingle):double;virtual;
  {розраховується значення похідної квадратичної форми,
  функція використовується при  покоординатному спуску і обчислюється
  похідна по al, яка описує зміну  того чи іншого параметра апроксимації
  Param = Param - al*F, де  Param залежить від num
  F - значення похідної квадритичної форми по Param при al = 0
  (те, що повертає функція SquareFormIsCalculated в RezF)}
public
end; // TFitFunctLSM=class (TFitAdditionParam)

//----------------------------------------------
TDiodLSM=class (TFitFunctLSM)
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TDiodLSM=class (TFitFunctLSM)


TPhotoDiodLSM=class (TFitFunctLSM)
private
 Procedure InitialApproximation(InputData:PVector;var IA:TArrSingle);override;
{Param = n  при num = 0; Rs при 1; I0 при 2; Rsh при 3; Iph при 4}
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TPhotoDiodLSM=class (TFitFunctLSM)

TDiodLam=class (TFitFunctLSM)
private
 Function ParamIsBad(InputData:PVector; IA:TArrSingle):boolean;override;
 {перевіряє чи параметри можна використовувати для
 апроксимації даних в InputData функцією Ламверта,
 IA[0] - n, IA[1] - Rs, IA[2] - I0, IA[3] - Rsh}
 Function SquareFormIsCalculated(InputData:PVector; X:TArrSingle;
             var RezF:TArrSingle; var RezSum:double):boolean;override;
 Function SquareFormDerivate(InputData:Pvector;num:byte;al,F:double;
                     X:TArrSingle):double;override;
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TDiodLam=class (TFitFunctLSM)

TPhotoDiodLam=class (TFitFunctLSM)
private
 Procedure InitialApproximation(InputData:PVector;var  IA:TArrSingle);override;
 Function ParamCorectIsDone(InputData:PVector;var IA:TArrSingle):boolean;override;
 Function ParamIsBad(InputData:PVector; IA:TArrSingle):boolean;override;
 {перевіряє чи параметри можна використовувати для
 апроксимації ВАХ при освітленні в InputData функцію Ламверта,
  A[0] - n, IA[1] - Rs, IA[2] - Isc, IA[3] - Rsh, IA[3] - Voc}
 Function SquareFormIsCalculated(InputData:PVector; X:TArrSingle;
             var RezF:TArrSingle; var RezSum:double):boolean;override;
{X[0] - n, X[1] - Rs, X[2] -  Rsh, X[3] -  Isc, X[4] - Voc;
RezF[0] - похідна по n, RezF[1] - по Rs, RezF[3] - по Rsh}
 Function SquareFormDerivate(InputData:Pvector;num:byte;al,F:double;
                     X:TArrSingle):double;override;
 Procedure EndFitting(FinalResult:TArrSingle;
              var OutputData:TArrSingle);override;
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TPhotoDiodLam=class (TFitFunctLSM)

//---------------------------------------------
TFitFunctEvolution=class (TFitAdditionParam)
{для функцій, де апроксимація відбувається
за допомогою еволюційних методів}
private
 FXmin:TArrSingle; //мінімальні значення змінних при ініціалізації
 FXmax:TArrSingle; //максимальні значення змінних при ініціалізації
 FXminlim:TArrSingle; //мінімальні значення змінних при еволюційному пошуку
 FXmaxlim:TArrSingle; //максимальні значення змінних при еволюційному пошуку
 FEvType:TEvolutionType; //еволюційний метод,який використовується для апроксимації
 fY:double;//поле для розміщення значення Y з даних, які апроксимуються
 Constructor Create(FunctionName,FunctionCaption:string;
                     Npar,Nvar,NaddX:byte);
 Procedure RealReadFromIniFile;override;
 {безпосередньо зчитує дані з ini-файла, в цьому класі - всі поля}
 Procedure RealWriteToIniFile;override;
 {безпосередньо записує дані в ini-файл, в цьому класі - всі поля}
 Procedure FIsNotReadyDetermination;override;
 Procedure GREvTypeToForm(Form:TForm);
 {виведення на форму для керування параметрами
 елементів, пов'язаних з типом
 еволюційного методу }
 Procedure GRElementsToForm(Form:TForm);override;
 Procedure GRSetValueEvType(Component:TComponent;ToForm:boolean);
 {дані про тип еволюційного методу}
 Procedure GRSetValueParam(Component:TComponent;ToForm:boolean);override;
 Procedure GRRealSetValue(Component:TComponent;ToForm:boolean);override;
 Procedure TrueFitting (InputData:PVector;var OutputData:TArrSingle); override;
 Procedure PenaltyFun(var X:TArrSingle);
 {контролює можливі значення параметрів у масиві X,
 що підбираються при апроксимації еволюційними методами,
 заважаючи їм прийняти нереальні значення -
 тобто за межами FXminlim та FXmaxlim}
 Function FitnessFunc(InputData:Pvector; OutputData:TArrSingle):double;virtual;
 {цільова функція для оцінки якості апроксимації
 даних в InputData з використанням OutputData,
 найчастіше - квадратична форма}
 Function Summand(OutputData:TArrSingle):double;virtual;
 {обчислення доданку у цільовій функції}
 Function Weight(OutputData:TArrSingle):double;virtual;
 {обчислення ваги доданку у цільовій функції}
 Procedure VarRand(var X:TArrSingle);
 {випадковим чином задає значення змінних
 масиву  Х в діапазоні від FXmin до FXmax}
 Procedure  EvFitInit(InputData:PVector;var X:TArrArrSingle; var Fit:TArrSingle);
 {початкове встановлення випадкових значень в Х
 та розрахунок початкових величин цільової функції}
 Procedure EvFitShow(X:TArrArrSingle; Fit:TArrSingle; Nit,Nshow:integer);
 {проводить зміну значень на вікні під час еволюційної апроксимації,
 якщо Nit кратна Nshow}
 Procedure MABCFit (InputData:PVector;var OutputData:TArrSingle);
  {апроксимуються дані у векторі InputData за методом
  modified artificial bee colony;
  результати апроксимації вносяться в OutputData}
 Procedure PSOFit (InputData:PVector;var OutputData:TArrSingle);
  {апроксимуються дані у векторі InputData за методом
  particle swarm optimization;
  результати апроксимації вносяться в OutputData}
 Procedure DEFit (InputData:PVector;var OutputData:TArrSingle);
  {апроксимуються дані у векторі InputData за методом
  differential evolution;
  результати апроксимації вносяться в OutputData}
 Procedure TLBOFit (InputData:PVector;var OutputData:TArrSingle);
  {апроксимуються дані у векторі InputData за методом
  teaching learning based optimization;
  результати апроксимації вносяться в OutputData}
public
end; // TFitFunctEvolution=class (TFitAdditionParam)

//-----------------------------------------
TDiod=class (TFitFunctEvolution)
private
 Function Func(Parameters:TArrSingle):double; override;
 Function RealFunc(DeterminedParameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TDiod=class (TFitFunctEvolution)

TPhotoDiod=class (TFitFunctEvolution)
private
 Function Func(Parameters:TArrSingle):double; override;
 Function RealFunc(DeterminedParameters:TArrSingle):double; override;
 Function Weight(OutputData:TArrSingle):double;override;
public
 Constructor Create;
end; //  TPhotoDiod=class (TFitFunctEvolution)

TDiodTwo=class (TFitFunctEvolution)
{I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp(V/n2kT)-1]}
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TDiodTwo=class (TFitFunctEvolution)

TDiodTwoFull=class (TFitFunctEvolution)
{I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp((V-IRs2)/n2kT)-1]}
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; //TDiodTwoFull=class (TFitFunctEvolution)

TDGaus=class (TFitFunctEvolution)
private
 Function Func(Parameters:TArrSingle):double; override;
 Function Weight(OutputData:TArrSingle):double;override;
public
 Constructor Create;
end; //TDGaus=class (TFitFunctEvolution)

TLinEg=class (TFitFunctEvolution)
private
 Function Func(Parameters:TArrSingle):double; override;
 Function Weight(OutputData:TArrSingle):double;override;
public
 Constructor Create;
end; //TLinEg=class (TFitFunctEvolution)

TDoubleDiod=class (TFitFunctEvolution)
{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]+(V-IRs)/Rsh}
private
 Function Func(Parameters:TArrSingle):double; override;
 Function RealFunc(DeterminedParameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TDoubleDiodo=class (TFitFunctEvolution)

TDoubleDiodLight=class (TFitFunctEvolution)
{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]
         +(V-IRs)/Rsh-Iph}
private
 Function Func(Parameters:TArrSingle):double; override;
 Function RealFunc(DeterminedParameters:TArrSingle):double; override;
 Function Weight(OutputData:TArrSingle):double;override;
 Procedure AddParDetermination(InputData:PVector;
                               var OutputData:TArrSingle); override;
public
 Constructor Create;
end; // TDoubleDiodLight=class (TFitFunctEvolution)

TNGausian=class (TFitFunctEvolution)
private
 Function Func(Parameters:TArrSingle):double; override;
 Procedure BeforeFitness(InputData:Pvector);override;
public
 Constructor Create(NGaus:byte);
end; // TNGausian=class (TFitFunctEvolution)

TTunnel=class (TFitFunctEvolution)
{I0*exp(-A*(B+x)^0.5)}
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; //TTunnel=class (TFitFunctEvolution)

TPower2=class (TFitFunctEvolution)
{A1*(x^m1 + A2*x^m2)}
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; //TPower2=class (TFitFunctEvolution)

TRevZriz=class (TFitFunctEvolution)
{I(1/kT) = I01*T^2*exp(-E1/kT)+I02*T^m*exp(-E2/kT)
m- константа}
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TRevZriz=class (TFitFunctEvolution)

TRevZriz2=class (TFitFunctEvolution)
{ I(1/kT)=I01*T^2*exp(-E/kT)+I02*T^(m)*A^(-300/T)
залежності від x=1/(kT)}
private
 Function Func(Parameters:TArrSingle):double; override;
 Function Weight(OutputData:TArrSingle):double;override;
 Function Summand(OutputData:TArrSingle):double;override;
public
 Constructor Create;
end; // TRevZriz2=class (TFitFunctEvolution)

TRevZriz3=class (TFitFunctEvolution)
{I(1/kT)=I01*T^2*exp(-E/kT)+I02*T^(m)*exp(-(Tc/T)^p)}
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TRevZriz3=class (TFitFunctEvolution)

//---------------------------------------------------
TBrails=class (TFitFunctEvolution)
{для визначення температурної (клас TBrailsford) або
частотної (клас TBrailsfordw) залежності коефіцієнта
поглинання звуку
alpha(T,w) = A*w/T*(B*w*exp(E/kT))/(1+(B*w*exp(E/kT)^2) }
private
 Function Weight(OutputData:TArrSingle):double;override;
 Constructor Create(FunctionName:string);
public
end; // TBrails=class (TFitFunctEvolution)

TBrailsford=class (TBrails)
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TBrailsford=class (TBrails)

TBrailsfordw=class (TBrails)
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TBrailsford=class (TBrails))

//-----------------------------------------------------------------------
TFitFunctEvolutionEm=class (TFitFunctEvolution)
{для функцій, де обчислюється
максимальне поле на інтерфейсі Em}
private
 F1:double; //містить Fb(T)-Vn
 F2:double; // містить  2qNd/(eps_0 eps_s)
 fkT:double; //містить kT
 Constructor Create (FunctionName,FunctionCaption:string;
                     Npar,Nvar:byte);
 Procedure BeforeFitness(InputData:Pvector);override;
 Procedure FIsNotReadyDetermination;override;
 Function Weight(OutputData:TArrSingle):double;override;
 Function TECurrent(V,T,Seff,A:double):double;
 {повертає величину Seff S A* T^2 exp(-(Fb0-A Em)/kT)(1-exp(-qV/kT))}
public
end; // TFitFunctEvolutionEm=class (TFitFunctEvolution)


TRevZriz2ΤΕ=class (TFitFunctEvolutionEm)
{ I(1/kT)=Seff S A* T^2 exp(-(Fb0-A Em)/kT)(1-exp(-qV/kT))
          +I02*T^(m)*A^(-300/T)}
private
 Function Func(Parameters:TArrSingle):double; override;
 Function Weight(OutputData:TArrSingle):double;override;
 Function Summand(OutputData:TArrSingle):double;override;
public
 Constructor Create;
end; // TRevZriz2ΤΕ=class (TFitFunctEvolutionEm)


TRevSh=class(TFitFunctEvolutionEm)
{I(V) = I01*exp(A1*Em(V)+B*Em(V)^0.5)*(1-exp(-V/kT))+
        I02*exp(A2*Em(V)+B*Em(V)^0.5)*(1-exp(-V/kT))}
private
 Function Func(Parameters:TArrSingle):double; override;
 Function Weight(OutputData:TArrSingle):double;override;
public
 Constructor Create;
end; // class(TFitFunctEvolutionEm))

TRevShSCLC=class (TFitFunctEvolutionEm)
{I(V) = I01*V^m+I02*exp(A*Em(V)/kT)(1-exp(-eV/kT))}
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TRevShSCLC=class (TFitFunctEvolutionEm)

TRevShSCLC3=class (TFitFunctEvolutionEm)
{I(V) = I01*V^m1+I02*V^m2+I03*exp(A*Em(V)/kT)*(1-exp(-eV/kT))}
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TRevShSCLC3=class (TFitFunctEvolutionEm)

TRevShSCLC2=class (TFitFunctEvolutionEm)
{I(V) = I01*(V^m1+b*V^m2)+I02*exp(A*Em(V)/kT)*(1-exp(-eV/kT))
m1=1+T01/T;
m2=1+T02/T}
private
 Fm1:double;
 Fm2:double;
 Function Func(Parameters:TArrSingle):double; override;
 Procedure BeforeFitness(InputData:Pvector);override;
public
 Constructor Create;
end; // TRevShSCLC2=class (TFitFunctEvolutionEm)

TPhonAsTun=class (TFitFunctEvolutionEm)
{Розраховується залежність струму, пов'язаного
з phonon-assisted tunneling}
private
 fmeff: Double; //абсолютна величина ефективної маси
// Procedure BeforeFitness(InputData:Pvector);override;
 Function Weight(OutputData:TArrSingle):double;override;
 Constructor Create (FunctionName,FunctionCaption:string;
                     Npar:byte);
 Function PhonAsTun(V,kT1:double;Parameters:TArrSingle):double;
public
end; // TPhonAsTun=class (TFitFunctEvolutionEm)

TPhonAsTunOnly=class (TPhonAsTun)
{базовий клас для розрахунків, де лище струм, пов'язаний
з phonon-assisted tunneling}
private
 Constructor Create(FunctionName:string);overload;
end; // TPhonAsTunOnly=class (TPhonAsTun)

TPhonAsTun_kT1=class (TPhonAsTunOnly)
{струм як функція 1/kT,
тобто стале значення напруги потрібно вводити}
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TPhonAsTun_kT1=class (TPhonAsTunOnly)

TPhonAsTun_V=class (TPhonAsTunOnly)
{струм як функція зворотньої напруги,
потрібна температура}
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TPhonAsTun_V=class (TPhonAsTunOnly)

TPhonAsTunAndTE=class (TPhonAsTun)
{базовий клас для розрахунків, де струм, пов'язаний
з phonon-assisted tunneling та термоемісійний}
private
 Constructor Create(FunctionName:string);overload;
end; // TPhonAsTunAndTE=class (TPhonAsTun)

TPhonAsTunAndTE_kT1=class (TPhonAsTunAndTE)
{струм як функція 1/kT,
тобто стале значення напруги потрібно вводити}
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TPhonAsTunAndTE_kT1=class (TPhonAsTunAndTE)

TPhonAsTunAndTE_V=class (TPhonAsTunAndTE)
{струм як функція зворотньої напруги,
потрібна температура}
private
 Function Func(Parameters:TArrSingle):double; override;
public
 Constructor Create;
end; // TPhonAsTunAndTE_V=class (TPhonAsTunAndTE)

//-------------------------------------------------
procedure PictLoadScale(Img: TImage; ResName:String);
{в Img завантажується bmp-картинка з ресурсу з назвою
ResName і масштабується зображення, щоб не вийшо
за межі розмірів Img, які були перед цим}

Procedure FunCreate(str:string; var F:TFitFunction);
{створює F того чи іншого типу залежно
від значення str}

Function FitName(V: PVector; st:string='fit'):string;
{повертає змінене значення V^.name,
зміна полягає у дописуванні st перед першою крапкою}

//--------------------------------------------------------------------
//--------------------------------------------------------------------
implementation

function TOIniFile.ReadRand(const Section, Ident: string): TVar_Rand;
var j:integer;
begin
    j:=ReadInteger(Section, Ident,3);
    case j of
     1:Result:=lin;
     2:Result:=logar;
     else Result:=cons;
     end;
end;

procedure TOIniFile.WriteRand(const Section, Ident: string; Value: TVar_Rand);
begin
 case Value of
     lin:  WriteInteger(Section, Ident,1);
     logar:WriteInteger(Section, Ident,2);
     end;
end;

function TOIniFile.ReadEvType(const Section, Ident: string; Default: TEvolutionType): TEvolutionType;
var j:integer;
begin
    j:=ReadInteger(Section, Ident,5);
    case j of
     1:Result:=TDE;
     2:Result:=TMABC;
     3:Result:=TTLBO;
     4:Result:=TPSO;
     else Result:=Default;
     end;
end;

procedure TOIniFile.WriteEvType(const Section, Ident: string; Value: TEvolutionType);
begin
 case Value of
     TDE:  WriteInteger(Section, Ident,1);
     TMABC:WriteInteger(Section, Ident,2);
     TTLBO:  WriteInteger(Section, Ident,3);
     TPSO:WriteInteger(Section, Ident,4);
     end;
end;

//-------------------------------------------------------------------
Constructor TFitFunction.Create(FunctionName,FunctionCaption:string);
begin
 inherited Create;
 DecimalSeparator:='.';
 FName:=FunctionName;
 FCaption:=FunctionCaption;
 fHasPicture:=True;
 FPictureName:=FName+'Fig';
end;

Procedure TFitFunction.SetValueGR;
begin
  showmessage('The options are absent');
end;

Procedure TFitFunction.FittingGraph (InputData:PVector; var OutputData:TArrSingle;
              Series: TLineSeries;
              Xlog:boolean=False;Ylog:boolean=False;
              Np:Word=150);
begin
  Fitting(InputData,OutputData,Xlog,Ylog);
  if OutputData[0]=ErResult then Exit;
  RealToGraph(InputData,OutputData,Series,Xlog,Ylog,Np);
end;

Procedure TFitFunction.FittingGraphFile (InputData:PVector; var OutputData:TArrSingle;
              Series: TLineSeries;
              Xlog:boolean=False;Ylog:boolean=False;
              Np:Word=150; suf:string='fit');
begin
  FittingGraph(InputData,OutputData,Series,Xlog,Ylog);
  if OutputData[0]=ErResult then Exit;
  RealToFile (InputData,OutputData,Xlog,Ylog,suf);
end;

Procedure TFitFunction.PictureToForm(Form:TForm;maxWidth,maxHeight,Top,Left:integer);
 var Img:TImage;
begin
 if fHasPicture then
  begin
   Img:=TImage.Create(Form);
   Img.Name:='Image';
   Img.Parent:=Form;
   Img.Top:=Top;
   Img.Left:=Left;
   Img.Height:=maxHeight;
   Img.Width:=maxWidth;
   Img.Stretch:=True;
   PictLoadScale(Img,FPictureName);
   Form.Width:=max(Form.Width,Img.Left+Img.Width+10);
   Form.Height:=max(Form.Height,Img.Top+Img.Height+10);
  end;
end;

//------------------------------------------------------
Constructor TFitWithoutParameteres.Create(FunctionName:string);
begin
 if FunctionName='Smoothing'then
      begin
        inherited Create('Smoothing',
           '3-point averaging, the weighting coefficient are determined by Gaussian distribution with 60% dispersion'
            );
        FErrorMessage:='The smoothing is imposible,'+#10+
               'the points" quantity is very low';
      end;
 if FunctionName='Derivative'then
      begin
        inherited Create('Derivative',
           'Derivative, which is calculated as derivative of 3-poin Lagrange polynomial'
            );
        FErrorMessage:='The derivative is imposible,'+#10+
               'the points" quantity is very low';
      end;
 if FunctionName='Median'then
      begin
        inherited Create('Median','3-point median filtering');
        FErrorMessage:='The median filter"s using is imposible,'+#10+
          'the points" quantity is very low';
      end;
 new(FtempVector);
end;

Procedure TFitWithoutParameteres.RealTransform(InputData:PVector);
begin
 if Name='Smoothing' then Smoothing(InputData,FtempVector);
 if Name='Derivative' then Diferen(InputData,FtempVector);
 if Name='Median' then Median(InputData,FtempVector);
end;

Procedure TFitWithoutParameteres.RealToGraph (InputData:PVector; var OutputData:TArrSingle;
              Series: TLineSeries;
              Xlog,Ylog:boolean; Np:Word);
var
   i:integer;
begin
   Series.Clear;
   for I := 0 to High(FtempVector^.X) do
     Series.AddXY(FtempVector^.X[i],FtempVector^.Y[i]);
end;

Procedure TFitWithoutParameteres.RealToFile (InputData:PVector; var OutputData:TArrSingle;
              Xlog,Ylog:boolean; suf:string);
var Str1:TStringList;
    i:integer;
begin
  Str1:=TStringList.Create;
   for I := 0 to High(FtempVector^.X) do
     Str1.Add(FloatToStrF(InputData^.X[i],ffExponent,4,0)+' '+
           FloatToStrF(InputData^.Y[i],ffExponent,4,0)+' '+
           FloatToStrF(FtempVector^.Y[i],ffExponent,4,0));
  Str1.SaveToFile(FitName(InputData,suf));
  Str1.Free;
end;

Procedure TFitWithoutParameteres.Free;
begin
 dispose(FtempVector);
 inherited;
end;

Function TFitWithoutParameteres.FinalFunc(X:double;DeterminedParameters:TArrSingle;
                     Xlog:boolean=False;Ylog:boolean=False):double; {overload; virtual;}
begin
 Result:=ErResult;
end;

Procedure TFitWithoutParameteres.Fitting (InputData:PVector; var OutputData:TArrSingle;
                    Xlog:boolean=False;Ylog:boolean=False);
begin
  SetLength(OutputData,1);
  OutputData[0]:=ErResult;
  try
   RealTransform(InputData);
  finally
  end;
  if FtempVector^.n=0 then
    begin
     MessageDlg(FErrorMessage, mtError, [mbOK], 0);
     Exit;
    end;
  OutputData[0]:=1;
end;

Procedure TFitWithoutParameteres.FittingDiapazon (InputData:PVector;
                   var OutputData:TArrSingle;D:TDiapazon);
begin
end;

Function TFitWithoutParameteres.Deviation (InputData:PVector):double;
begin
 Result:=ErResult;
end;

Procedure TFitWithoutParameteres.DataToStrings(DeterminedParameters:TArrSingle;
                         OutStrings:TStrings);
begin
end;

//-------------------------------------------------------------------
Constructor TFitFunctionSimple.Create(FunctionName,FunctionCaption:string;
                                     N:byte);
begin
 inherited Create(FunctionName,FunctionCaption);
 FNx:=N;
 SetLength(FXname,FNx);
 if High(FXname)>0 then
     begin
     FXname[0]:='A';
     FXname[1]:='B';
     end;
 if High(FXname)>1 then FXname[2]:='C';
 fYminDontUsed:=False;
end;

Function TFitFunctionSimple.RealFunc(Parameters:TArrSingle):double;
begin
  Result:=Func(Parameters);
end;

Procedure TFitFunctionSimple.RealToGraph (InputData:PVector; var OutputData:TArrSingle;
              Series: TLineSeries;
              Xlog,Ylog:boolean; Np:Word);
var h,x,y:double;
    i:integer;
begin
  Series.Clear;
  h:=(InputData^.X[High(InputData^.X)]-InputData^.X[0])/Np;
  for I := 0 to Np do
    begin
    x:=InputData^.X[0]+i*h;
    y:=FinalFunc(x,OutputData,Xlog,Ylog);
    Series.AddXY(x, y);
    end;
end;

Procedure TFitFunctionSimple.RealToFile (InputData:PVector; var OutputData:TArrSingle;
              Xlog,Ylog:boolean; suf:string);
var Str1:TStringList;
    i:integer;
begin
  Str1:=TStringList.Create;
  for I := 0 to High(InputData^.X) do
   Str1.Add(FloatToStrF(InputData^.X[i],ffExponent,4,0)+' '+
            FloatToStrF(InputData^.Y[i],ffExponent,4,0)+' '+
            FloatToStrF(FinalFunc(InputData^.X[i],OutputData,Xlog,Ylog),ffExponent,4,0)
            );
  Str1.SaveToFile(FitName(InputData,suf));
  Str1.Free;
end;

Function TFitFunctionSimple.FinalFunc(X:double;DeterminedParameters:TArrSingle;
                     Xlog:boolean=False;Ylog:boolean=False):double;
begin
   if XLog then fX:=log10(x)
            else fX:=x;
   Result:=RealFunc(DeterminedParameters);
   if YLog then Result:=exp(Result*ln(10))
end;

Procedure TFitFunctionSimple.Fitting (InputData:PVector; var OutputData:TArrSingle;
                    Xlog:boolean=False;Ylog:boolean=False);
var i:integer;
    tempV:Pvector;
begin
 SetLength(OutputData,FNx);
 OutputData[0]:=ErResult;
 new(tempV);
 try
  IVchar(InputData,tempV);
  for i := 0 to High(tempV^.X)do
   begin
     if XLog then tempV^.X[i]:=Log10(InputData^.X[i]);
     if YLog then tempV^.Y[i]:=Log10(InputData^.Y[i]);
   end;
 except
  dispose(tempV);
  MessageDlg('Data are uncorrect!!!', mtError,[mbOk],0);
  Exit;
 end; //try

 try
   RealFitting (tempV,OutputData);
 except
   OutputData[0]:=ErResult;
 end;
 dispose(tempV);
 if (OutputData[0]=ErResult) then
   MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
end;


Procedure TFitFunctionSimple.FittingDiapazon (InputData:PVector;
                   var OutputData:TArrSingle;D:TDiapazon);
  var temp:Pvector;
begin
  new(temp);
  A_B_Diapazon(InputData,temp,D,fYminDontUsed);
  Fitting(temp,OutputData);
  dispose(temp);
end;

Function TFitFunctionSimple.Deviation (InputData:PVector):double;
 var Param:TArrSingle;
     i:integer;
begin
 Result:=ErResult;
 Fitting (InputData,Param);
 if Param[0]=ErResult then Exit;
 Result:=0;
 for I := 0 to High(InputData^.X) do
  Result:=Result+sqr((InputData^.Y[i]-FinalFunc(InputData^.X[i],Param))/InputData^.Y[i]);
 Result:=sqrt(Result)/InputData^.n;
end;

Procedure TFitFunctionSimple.DataToStrings(DeterminedParameters:TArrSingle;
                         OutStrings:TStrings);
 var i:integer;
begin
 if High(DeterminedParameters)<>High(FXname) then Exit;
 for I := 0 to High(FXname) do
   OutStrings.Add(FXname[i]+'='+
           FloatToStrF(DeterminedParameters[i],ffExponent,4,3));
end;

//--------------------------------------------------------------------
Constructor TLinear.Create;
begin
 inherited Create('Linear',
                  'Linear fitting, least-squares method',
                  2);
end;

Function TLinear.Func(Parameters:TArrSingle):double;
begin
 Result:=Parameters[0]+Parameters[1]*fX;
end;

Procedure TLinear.RealFitting (InputData:PVector; var OutputData:TArrSingle);
begin
   LinAprox(InputData,OutputData[0],OutputData[1]);
end;

Constructor TQuadratic.Create;
begin
 inherited Create('Quadratic',
                  'Quadratic fitting, least-squares method',
                  3);
end;

Function TQuadratic.Func(Parameters:TArrSingle):double;
begin
 Result:=Parameters[0]+Parameters[1]*fX+Parameters[2]*sqr(fX);
end;

Procedure TQuadratic.RealFitting (InputData:PVector; var OutputData:TArrSingle);
begin
   ParabAprox(InputData,OutputData[0],OutputData[1],OutputData[2]);
end;

Constructor TGromov.Create;
begin
 inherited Create('Gromov',
                  'Least-squares fitting,  which is used in Gromov and Lee methods',
                   3);
end;

Function TGromov.Func(Parameters:TArrSingle):double;
begin
 Result:=Parameters[0]+Parameters[1]*fX+Parameters[2]*ln(fX);
end;

Procedure TGromov.RealFitting (InputData:PVector; var OutputData:TArrSingle);
begin
  GromovAprox(InputData,OutputData[0],OutputData[1],OutputData[2]);
end;

//--------------------------------------------------------------------
Constructor TFitVariabSet.Create(FunctionName,FunctionCaption:string;
                     Npar,Nvar:byte);
 var i:integer;
begin
  inherited Create(FunctionName,FunctionCaption,Npar);
  if Nvar<1 then Exit;
  FVarNum:=Nvar;
  SetLength(FVariab,FVarNum);
  SetLength(FVarName,FVarNum);
  SetLength(FVarBool,FVarNum);
  SetLength(FVarValue,FVarNum);
  SetLength(FVarManualDefinedOnly,FVarNum);
  for I := 0 to High(FVarbool) do
   begin
    FVarbool[i]:=True;
    FVarManualDefinedOnly[i]:=False;
   end;
end;

Procedure TFitVariabSet.FIsNotReadyDetermination;
 var i:integer;
begin
 FIsNotReady:=False;
 for I := 0 to High(FVarbool) do
   if ((FVarbool[i])and(FVarValue[i]=ErResult)) then FIsNotReady:=True;
end;

Procedure TFitVariabSet.ReadFromIniFile;
begin
 FConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
 try
  RealReadFromIniFile;
 except
 end;
 FConfigFile.Free;
end;

Procedure TFitVariabSet.RealReadFromIniFile;
 var i:integer;
begin
 for I := 0 to High(FVarbool) do
  begin
   ReadIniDefFit('Var'+IntToStr(i)+'Bool',FVarbool[i]);
   ReadIniDefFit('Var'+IntToStr(i)+'Val',FVarValue[i]);
   if FVarManualDefinedOnly[i] then FVarBool[i]:=True;
  end;
end;

Procedure TFitVariabSet.WriteToIniFile;
begin
 FConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
 FConfigFile.EraseSection(FName);
 try
   RealWriteToIniFile;
 finally
 end;
 FConfigFile.Free;
end;

Procedure TFitVariabSet.RealWriteToIniFile;
var  i:integer;
begin
 for I := 0 to High(FVarbool) do
  begin
   WriteIniDefFit('Var'+IntToStr(i)+'Bool',FVarbool[i]);
   WriteIniDefFit('Var'+IntToStr(i)+'Val',FVarValue[i]);
  end;
end;

Procedure TFitVariabSet.BeforeFitness(InputData:Pvector);
 var i:integer;
begin
 for I := 0 to High(FVarbool) do
  if FVarbool[i] then FVariab[i]:=FVarValue[i];
end;

Procedure TFitVariabSet.WriteIniDefFit(const Ident: string; Value:double);
begin
 WriteIniDef(FConfigFile,FName,Ident,Value);
end;

Procedure TFitVariabSet.WriteIniDefFit(const Ident: string; Value:Integer);
begin
 WriteIniDef(FConfigFile,FName,Ident,Value);
end;

Procedure TFitVariabSet.WriteIniDefFit(const Ident: string;Value:Boolean);
begin
 WriteIniDef(FConfigFile,FName,Ident,Value);
end;

Procedure TFitVariabSet.WriteIniDefFit(const Ident: string; var Value:TVar_Rand);
begin
 FConfigFile.WriteRand(FName,Ident,Value);
end;

Procedure TFitVariabSet.ReadIniDefFit(const Ident: string; var Value:double);
begin
 Value:=FConfigFile.ReadFloat(Fname,Ident,ErResult);
end;

Procedure TFitVariabSet.ReadIniDefFit(const Ident: string; var Value:integer);
begin
 Value:=FConfigFile.ReadInteger(Fname,Ident,ErResult);
end;

Procedure TFitVariabSet.ReadIniDefFit(const Ident: string; var Value:boolean);
begin
 Value:=FConfigFile.ReadBool(Fname,Ident,False);
end;

Procedure TFitVariabSet.ReadIniDefFit(const Ident: string; var Value:TVar_Rand);
begin
 Value:=FConfigFile.ReadRand(FName,Ident);
end;

Procedure TFitVariabSet.Fitting (InputData:PVector; var OutputData:TArrSingle;
                    Xlog:boolean=False;Ylog:boolean=False);
begin
  FIsNotReadyDetermination;
  if FIsNotReady then SetValueGR;
  if FIsNotReady then
     begin
     MessageDlg('Approximation is imposible.'+#10+#13+
                  'Parameters of function are undefined', mtError,[mbOk],0);
     SetLength(OutputData,FNx);
     OutputData[0]:=ErResult;
     Exit;
     end;
  BeforeFitness(InputData);
  inherited;
end;

Procedure TFitVariabSet.GRFormPrepare(Form:TForm);
begin
 Form.Name:=Fname;
 Form.Position:=poMainFormCenter;
 Form.AutoScroll:=True;
 Form.BorderIcons:=[biSystemMenu];
 Form.Caption:=FName+' function '+', parameters';
 Form.Font.Name:='Tahoma';
 Form.Font.Size:=8;
 Form.Font.Style:=[fsBold];
 Form.Color:=RGB(222,254,233);
 Form.Height:=10;
 Form.Width:=10;
end;

Procedure TFitVariabSet.GRElementsToForm(Form:TForm);
begin
  GRVariabToForm(Form);
end;

Function TFitVariabSet.GrVariabLeftDefine(Form: TForm):integer;
var
  i: Byte;
begin
 Result:=10;
 try
  for i := Form.ComponentCount - 1 downto 0 do
    if Form.Components[i].Name = FXname[0] then
      Result := 10 + (Form.Components[i] as TFrApprP).Panel1.Width;
 except
 end;
end;

Function TFitVariabSet.GrVariabTopDefine(Form: TForm):integer;
 var i: Byte;
begin
 Result:=Form.Height;
 try
  for i := Form.ComponentCount - 1 downto 0 do
    if Form.Components[i].Name = FXname[0] then
      Result :=(Form.Components[i] as TFrApprP).Top;
 except
 end;
end;

Procedure TFitVariabSet.GRVariabToForm(Form:TForm);
const PaddingBetween=5;
var VarP:array of TFrParamP;
    i:integer;
    Left,Top:integer;
begin
  if FVarNum<1 then Exit;
  SetLength(VarP,FVarNum);
  Left:=GrVariabLeftDefine(Form);
  Top:=GrVariabTopDefine(Form);
  for I :=0 to High(VarP) do
    begin
    VarP[i]:=TFrParamP.Create(Form);
    VarP[i].Name:='Var'+inttostr(i)+FVarName[i];
    VarP[i].Parent:=Form;
    VarP[i].Left:=Left;
    VarP[i].Top:=Top+i*(VarP[i].Height+PaddingBetween);
    VarP[i].LName.Caption:=FVarName[i];
  end;
  Form.Height:=max(Form.Height,VarP[High(VarP)].Top+VarP[High(VarP)].Height+10);
  Form.Width:=max(Form.Width,VarP[High(VarP)].Left+VarP[High(VarP)].Width+10);
end;

Procedure TFitVariabSet.GRFieldFormExchange(Form:TForm;ToForm:boolean);
var i:integer;
begin
 for I := Form.ComponentCount-1 downto 0 do
     GRRealSetValue(Form.Components[i],ToForm);
end;

Procedure TFitVariabSet.GRRealSetValue(Component:TComponent;ToForm:boolean);
begin
 GRSetValueVariab(Component,ToForm);
end;

Procedure TFitVariabSet.GRSetValueVariab(Component:TComponent;ToForm:boolean);
 var i:integer;
begin
 for i := 0 to High(FVarBool) do
    if Component.Name='Var'+inttostr(i)+FVarName[i] then
      if ToForm then
          begin
            (Component as TFrParamP).EParam.Text:=ValueToStr555(FVarValue[i]);
            (Component as TFrParamP).CBIntr.Checked:=FVarBool[i];
            (Component as TFrParamP).CBIntr.Enabled:=not(FVarManualDefinedOnly[i]);
          end
                else
          begin
            FVarbool[i]:=(Component as TFrParamP).CBIntr.Checked;
            if FVarbool[i] then
             FVarValue[i]:=StrToFloat555((Component as TFrParamP).EParam.Text);
          end;
end;

Procedure TFitVariabSet.GRButtonsToForm(Form:TForm);
 var Buttons:TFrBut;
begin
 Buttons:=TFrBut.Create(Form);
 Buttons.Parent:=Form;
 Buttons.Left:=min(150,round(Form.Width/3));
 Buttons.Top:=Form.Height;
 Form.Height:=Form.Height+Buttons.Height+50;
 Form.Width:=max(Form.Width,Buttons.Left+Buttons.Width+30);
end;

Procedure TFitVariabSet.SetValueGR;
const PaddingTop=120;
      PaddingBetween=5;
      PaddingLeft=50;
 var Form:TForm;
begin
 Form:=TForm.Create(Application);
 GRFormPrepare(Form);
 PictureToForm(Form,450,60,10,10);
 GRElementsToForm(Form);
 GRFieldFormExchange(Form,True);
 GRButtonsToForm(Form);
 if Form.ShowModal=mrOk then
   begin
     GRFieldFormExchange(Form,False);
     FIsNotReadyDetermination;
     if not(FIsNotReady) then WriteToIniFile;
   end;
 ElementsFromForm(Form);
 Form.Hide;
 Form.Release;
end;

//----------------------------------------------------
Constructor TFitTemperatureIsUsed.Create(FunctionName,FunctionCaption:string;
                     Npar,Nvar:byte);
begin
 inherited Create(FunctionName,FunctionCaption,Npar,Nvar);
 if FVarNum>0 then  FVarName[0]:='T';
 fTemperatureIsRequired:=(FVarNum>0);
end;

Procedure TFitTemperatureIsUsed.BeforeFitness(InputData:Pvector);
begin
 if fTemperatureIsRequired then FVariab[0]:=InputData^.T;
 inherited BeforeFitness(InputData);
end;

//------------------------------------------------------------
Constructor TFitSampleIsUsed.Create(FunctionName,FunctionCaption:string;
                     Npar,Nvar:byte);
begin
 inherited Create(FunctionName,FunctionCaption,Npar,Nvar);
 FSample:=Diod;
 fSampleIsRequired:=True;
end;

Procedure TFitSampleIsUsed.FIsNotReadyDetermination;
begin
 inherited FIsNotReadyDetermination;
 if fSampleIsRequired then
  begin
   if (FSample=nil) then
     begin
       FIsNotReady:=True;
       Exit;
     end;
   if (FSample.Area=ErResult)or(FSample.Material.ARich=ErResult) then FIsNotReady:=True;
  end;
end;

//-------------------------------------------------
Constructor TExponent.Create;
begin
 inherited Create('Exponent',
                  'Linear least-squares fitting of semi-log plot',
                   3,1);
 FXname[0]:='Io';
 FXname[1]:='n';
 FXname[2]:='Fb';
 ReadFromIniFile();
end;

Function TExponent.Func(Parameters:TArrSingle):double;
begin
 Result:=Parameters[0]*exp(fX/(Parameters[1]*Kb*FVariab[0]));
end;

Procedure TExponent.RealFitting (InputData:PVector;
         var OutputData:TArrSingle);
begin
   ExKalk(InputData,FSample,OutputData[1],OutputData[0],OutputData[2],FVariab[0]);
end;


Constructor TIvanov.Create;
begin
 inherited Create('Ivanov',
                  'I-V fitting for dielectric layer width d determination, Ivanov method',
                   2,1);
 FXname[0]:='Fb';
 FXname[1]:='d/ep';
 ReadFromIniFile();
end;

Function TIvanov.Func(Parameters:TArrSingle):double;
begin
 Result:=ErResult;
end;

Function TIvanov.FinalFunc(var X:double;DeterminedParameters:TArrSingle):double;
 var Vd,x0:double;
begin
  x0:=X;
  Vd:=DeterminedParameters[1]*sqrt(2*Qelem*FSample.Nd*FSample.Material.Eps/Eps0)*
    (sqrt(DeterminedParameters[0])-sqrt(DeterminedParameters[0]-x0));
  X:=Vd+x0;
  Result:=FSample.I0(FVariab[0],DeterminedParameters[0])*exp(x0/Kb/FVariab[0]);
end;

Procedure TIvanov.FIsNotReadyDetermination;
begin
 inherited FIsNotReadyDetermination;
 if (FSample.Material.Eps=ErResult)or(FSample.Nd=ErResult) then FIsNotReady:=True;
end;


Procedure TIvanov.RealFitting (InputData:PVector;
                       var OutputData:TArrSingle);
begin
   IvanovAprox(InputData,FSample,OutputData[1],OutputData[0],FVariab[0]);
end;

Procedure TIvanov.RealToGraph (InputData:PVector; var OutputData:TArrSingle;
              Series: TLineSeries;
              Xlog,Ylog:boolean; Np:Word);
var h,x,y:double;
    i:integer;
begin
  Series.Clear;
  h:=(InputData^.X[High(InputData^.X)]-InputData^.X[0])/Np;
  for I := 0 to Np do
    begin
    x:=InputData^.X[0]+i*h;
    y:=FinalFunc(x,OutputData);
    Series.AddXY(x, y);
    end;
end;

//-----------------------------------------------
Constructor TFitIteration.Create(FunctionName,FunctionCaption:string;
                     Npar,Nvar:byte);
begin
 inherited Create(FunctionName,FunctionCaption,Npar,Nvar);
 SetLength(FXmode,fNx);
 SetLength(FA,fNx);
 SetLength(FB,fNx);
 SetLength(FC,fNx);
 SetLength(FXvalue,fNx);
 SetLength(FXt,fNx);
end;

procedure TFitIteration.SetNit(value:integer);
begin
  if value>0 then fNit:=value
             else fNit:=1000;
end;

Procedure TFitIteration.RealReadFromIniFile;
 var i:integer;
begin
 inherited RealReadFromIniFile;
 ReadIniDefFit('Nit',FNit);
 for I := 0 to High(FXmode) do
   begin
    ReadIniDefFit(FXname[i]+'Mode',FXmode[i]);
    ReadIniDefFit(FXname[i]+'A',FA[i]);
    ReadIniDefFit(FXname[i]+'B',FB[i]);
    ReadIniDefFit(FXname[i]+'C',FC[i]);
    ReadIniDefFit(FXname[i]+'tt',FXt[i]);
   end;
end;

Procedure TFitIteration.RealWriteToIniFile;
 var i:integer;
begin
 inherited RealWriteToIniFile;
 WriteIniDefFit('Nit',Nit);
 for I := 0 to High(FXmode) do
   begin
    WriteIniDefFit(FXname[i]+'Mode',FXmode[i]);
    WriteIniDefFit(FXname[i]+'A',FA[i]);
    WriteIniDefFit(FXname[i]+'B',FB[i]);
    WriteIniDefFit(FXname[i]+'C',FC[i]);
    WriteIniDefFit(FXname[i]+'tt',FXt[i]);
   end;
end;

Procedure TFitIteration.FIsNotReadyDetermination;
 var i:integer;
begin
 inherited FIsNotReadyDetermination;
 if (Nit=ErResult) then FIsNotReady:=True;
 for I := 0 to High(FXmode) do
  if FXmode[i]=cons then
      begin
        if FA[i]=ErResult then FIsNotReady:=True;
        if not(FXt[i]in[0..2*FVarNum]) then FIsNotReady:=True;
        if ((FXt[i]in[1..2*FVarNum])and
              (FC[i]=ErResult)and(FB[i]=ErResult)) then FIsNotReady:=True;
      end;
end;


Procedure TFitIteration.GRParamToForm(Form:TForm);
 const PaddingBetween=5;
 var  Pan:array of TFrApprP;
      i:integer;
begin
 SetLength(Pan,FNx);
 for I := 0 to High(Pan) do
  begin
    Pan[i]:=TFrApprP.Create(Form);
    Pan[i].Name:=FXname[i];
    Pan[i].Parent:=Form;
    Pan[i].Left:=5;
    Pan[i].Top:=Form.Height+i*(Pan[i].Panel1.Height+PaddingBetween);
    Pan[i].LName.Caption:=FXname[i];
  end;
 for i := Form.ComponentCount-1 downto 0 do
    if (Form.Components[i].Name='Nit') then
      (Form.Components[i] as TLabeledEdit).OnKeyPress:=Pan[0].minIn.OnKeyPress;
 Form.Height:=max(Form.Height,Pan[High(Pan)].Top+Pan[High(Pan)].Height+10);
 Form.Width:=max(Form.Width,Pan[High(Pan)].Left+Pan[High(Pan)].Width+10);
end;

Procedure TFitIteration.GRNitToForm(Form:TForm);
 var Niter:TLabeledEdit;
begin
 Niter:=TLabeledEdit.Create(Form);
 Niter.Parent:=Form;
 Niter.Name:='Nit';
 Niter.Left:=65;
 Niter.Top:=Form.Height;
 Niter.LabelPosition:=lpLeft;
 Niter.EditLabel.Width:=40;
 Niter.EditLabel.WordWrap:=True;
 Niter.EditLabel.Caption:='Iteration number';
 Niter.Width:=50;
 Form.Height:=Niter.Top+Niter.Height+10;
 Form.Width:=max(Form.Width,Niter.Left+Niter.Height+10);
end;

Procedure TFitIteration.GRElementsToForm(Form:TForm);
begin
 GRNitToForm(Form);
 GRParamToForm(Form);
 GRVariabToForm(Form);
end;

Procedure TFitIteration.GRRealSetValue(Component:TComponent;ToForm:boolean);
begin
 inherited GRRealSetValue(Component,ToForm);
 GRSetValueNit(Component,ToForm);
 GRSetValueParam(Component,ToForm);
end;

Procedure TFitIteration.GRSetValueNit(Component:TComponent;ToForm:boolean);
begin
  if Component.Name='Nit' then
    if ToForm then (Component as TLabeledEdit).Text:=ValueToStr555(Nit)
              else  Nit:=StrToInt555((Component as TLabeledEdit).Text);
end;

Procedure TFitIteration.GRSetValueParam(Component:TComponent;ToForm:boolean);
 var i,j:integer;
begin
 for i:=0 to fNx-1 do
  if Component.Name=FXname[i] then
    if ToForm then
      begin
        case FXmode[i] of
         lin:  (Component as TFrApprP).RBNorm.Checked:=True;
         logar:(Component as TFrApprP).RBLogar.Checked:=True;
         cons: (Component as TFrApprP).RBCons.Checked:=True;
        end;
        SetLength((Component as TFrApprP).FVarName,FVarNum);
        for j := 0 to High(FVarName) do
           (Component as TFrApprP).FVarName[j]:=FVarName[j];
        (Component as TFrApprP).FA:=FA[i];
        (Component as TFrApprP).FB:=FB[i];
        (Component as TFrApprP).FC:=FC[i];
        (Component as TFrApprP).FXt:=FXt[i];
      end
              else // if ToForm then
         begin
          if (Component as TFrApprP).RBNorm.Checked then FXmode[i]:=lin;
          if (Component as TFrApprP).RBLogar.Checked then FXmode[i]:=logar;
          if (Component as TFrApprP).RBCons.Checked then  FXmode[i]:=cons;
          FA[i]:=(Component as TFrApprP).FA;
          FB[i]:=(Component as TFrApprP).FB;
          FC[i]:=(Component as TFrApprP).FC;
          FXt[i]:=(Component as TFrApprP).FXt;
         end;
end;

Procedure TFitIteration.BeforeFitness(InputData:Pvector);
 var i:integer;
begin
 inherited BeforeFitness(InputData);
 for I := 0 to High(FXmode) do
  if FXmode[i]=cons then
    begin
     FXvalue[i]:=FA[i];
     if (FXt[i]<=FVarNum)and(FXt[i]>0) then
       FXvalue[i]:=FXvalue[i]+FB[i]*FVariab[FXt[i]]+
                   FC[i]*sqr(FVariab[FXt[i]]);
     if FXt[i]>FVarNum then
       FXvalue[i]:=FXvalue[i]+FB[i]/FVariab[FXt[i]-FVarNum]+
                     FC[i]/sqr(FVariab[FXt[i]-FVarNum]);
    end;
end;

Procedure TFitIteration.IterWindowPrepare(InputData:PVector);
 var i:integer;
begin
 fIterWindow:=TApp.Create(Application);
 SetLength(Labels,2*FNx);
 for I := 0 to FNx - 1 do
  begin
    Labels[i]:=TLabel.Create(fIterWindow);
    Labels[i].Name:='Lb'+IntToStr(i)+FXname[i];
    Labels[i+FNx]:=TLabel.Create(fIterWindow);
    Labels[i+FNx].Name:='Lb'+IntToStr(i)+FXname[i]+'n';
    Labels[i].Parent:=fIterWindow;
    Labels[i+FNx].Parent:=fIterWindow;
    Labels[i].Left:=24;
    Labels[i+FNx].Left:=90;
    Labels[i].Top:=round(3.5*fIterWindow.LNmax.Height)+i*round(1.5*Labels[i].Height);
    Labels[i+FNx].Top:=Labels[i].Top;
    Labels[i].Caption:=FXname[i]+' =';
  end;
 fIterWindow.LNmaxN.Caption:=inttostr(FNit);
 fIterWindow.Height:=Labels[High(Labels)].Top+3*Labels[High(Labels)].Height;
 if InputData^.name<>'' then fIterWindow.Caption:=', '+InputData^.name;
 fIterWindow.Show;
end;

Procedure TFitIteration.IterWindowClear;
 var i:integer;
begin
 for I := 0 to High(Labels) do
  begin
    Labels[i].Parent:=nil;
    Labels[i].Free;
  end;
end;

Procedure TFitIteration.EndFitting(FinalResult:TArrSingle;
              var OutputData:TArrSingle);
 var i:integer;
begin
 if fIterWindow.Visible then
      for i := 0 to High(OutputData) do
         OutputData[i]:=FinalResult[i];
end;

Procedure TFitIteration.IterWindowDataShow(CurrentIterNumber:integer; InterimResult:TArrSingle);
 var i:byte;
begin
  for I := 0 to FNx - 1 do
   Labels[i+FNx].Caption:=floattostrf(InterimResult[i],ffExponent,4,3);
  fIterWindow.LNitN.Caption:=Inttostr(CurrentIterNumber);
end;

Procedure TFitIteration.RealFitting (InputData:PVector;
         var OutputData:TArrSingle);
begin
 IterWindowPrepare(InputData);

 //QueryPerformanceCounter(StartValue);

 TrueFitting (InputData,OutputData);

//QueryPerformanceCounter(EndValue);
//QueryPerformanceFrequency(Freq);
//showmessage('tics='+inttostr(EndValue-StartValue)+#10+#13+
//             'time='+floattostr((EndValue-StartValue)/Freq)
//             +' s'+#10+#13+
//                'freq+'+inttostr(Freq));

 IterWindowClear();
 fIterWindow.Close;
 fIterWindow.Destroy;
end;

//-----------------------------------------------------
Constructor TFitAdditionParam.Create(FunctionName,FunctionCaption:string;
                     Npar,Nvar,NaddX:byte);
begin
 inherited Create(FunctionName,FunctionCaption,Npar{+NaddX},Nvar);
 fNAddX:=NaddX;
 SetLength(FXname,FNx+fNAddX);
 fIsDiod:=False;
 fIsPhotoDiod:=False;
end;

procedure TFitAdditionParam.AddParDetermination(InputData:PVector;
                               var OutputData:TArrSingle);
begin
  if (fIsDiod and(fNaddX=1) and (FNx>3)) then
   begin
     FXname[FNx]:='Fb';
     OutputData[FNx]:=FSample.Fb(FVariab[0],OutputData[2]);
   end;

  if (fIsPhotoDiod and (fNaddX=4) and (FNx>4)) then
   begin
     FXname[FNx]:='Voc';
     FXname[FNx+1]:='Isc';
     FXname[FNx+2]:='Pm';
     FXname[FNx+3]:='FF';
    if (OutputData[4]>1e-7) then
       begin
        OutputData[FNx]:=
           Voc_Isc_Pm(1,InputData,OutputData[0],OutputData[1],OutputData[2],OutputData[3],OutputData[4]);
        OutputData[FNx+1]:=
           Voc_Isc_Pm(2,InputData,OutputData[0],OutputData[1],OutputData[2],OutputData[3],OutputData[4]);
       end;
    if (OutputData[FNx]>0.002)and
       (OutputData[FNx+1]>1e-7)and
       (OutputData[FNx]<>ErResult)and
       (OutputData[FNx+1]<>ErResult) then
         begin
          OutputData[FNx+2]:=
            Voc_Isc_Pm(3,InputData,OutputData[0],OutputData[1],OutputData[2],OutputData[3],OutputData[4]);
          OutputData[FNx+3]:=OutputData[FNx+2]/OutputData[FNx]/OutputData[FNx+1];
         end;
   end;
end;

Procedure TFitAdditionParam.Fitting (InputData:PVector; var OutputData:TArrSingle;
                    Xlog:boolean=False;Ylog:boolean=False);
begin
  inherited;
  if (fNaddX>0)and(not(FIsNotReady))and(OutputData[0]<>ErResult) then
   begin
     SetLength(OutputData,FNx+fNAddX);
     AddParDetermination(InputData,OutputData);
   end;
end;

//---------------------------------------------------------
Constructor TFitFunctLSM.Create(FunctionName,FunctionCaption:string;
                     Npar:byte);
begin
 if Npar=4 then
     begin
     inherited Create(FunctionName,FunctionCaption,Npar,1,1);
     fIsDiod:=True;
     end;
 if Npar=5 then
     begin
     inherited Create(FunctionName,FunctionCaption,Npar,1,4);
     fIsPhotoDiod:=True;
     end;
 FXname[0]:='n';
 FXname[1]:='Rs';
 FXname[2]:='Io';
 FXname[3]:='Rsh';
 if Npar=5 then FXname[4]:='Iph'
end;

Procedure TFitFunctLSM.RealReadFromIniFile;
begin
 inherited RealReadFromIniFile;
 ReadIniDefFit('eps',fAccurancy);
end;

Procedure TFitFunctLSM.RealWriteToIniFile;
begin
 inherited RealWriteToIniFile;
 WriteIniDefFit('eps',fAccurancy);
end;

Procedure TFitFunctLSM.FIsNotReadyDetermination;
begin
 inherited FIsNotReadyDetermination;
 if (fAccurancy=ErResult) then FIsNotReady:=True;
end;

Procedure TFitFunctLSM.GRParamToForm(Form:TForm);
 var i,j:integer;
begin
 inherited;
 for j := Form.ComponentCount-1 downto 0 do
  for I := 0 to FNx-1 do
   if (Form.Components[j].Name=FXname[i]) then
     begin
      (Form.Components[j] as TFrApprP).GBoxInit.Visible:=False;
      (Form.Components[j] as TFrApprP).GBoxLim.Visible:=False;
      (Form.Components[j] as TFrApprP).RBLogar.Visible:=False;
      (Form.Components[j] as TFrApprP).RBNorm.Caption:='Variated';
      (Form.Components[j] as TFrApprP).GBoxMode.Left:=
                  (Form.Components[j] as TFrApprP).GBoxInit.Left;
      (Form.Components[j] as TFrApprP).Panel1.Width:=
            (Form.Components[j] as TFrApprP).GBoxMode.Left+
            (Form.Components[j] as TFrApprP).GBoxMode.Width+30;
      (Form.Components[j] as TFrApprP).Width:=(Form.Components[j] as TFrApprP).Panel1.Width+2;

      if (Fname='PhotoDiodLam')and((i=2)or(i=4)) then
        (Form.Components[j] as TFrApprP).Enabled:=False;
     end;
end;

Procedure TFitFunctLSM.GRAccurToForm(Form:TForm);
 var Acur:TLabeledEdit;
     i:integer;
begin
 Acur:=TLabeledEdit.Create(Form);
 Acur.Name:='Accuracy';
 Acur.Parent:=Form;
 Acur.Left:=250;
 Acur.Top:=85;
 Acur.LabelPosition:=lpLeft;
 Acur.EditLabel.Width:=40;
 Acur.EditLabel.WordWrap:=True;
 Acur.EditLabel.Caption:='Accuracy';
 Acur.Width:=50;
 try
   for i := Form.ComponentCount-1 downto 0 do
    begin
      if (Form.Components[i].Name=FXname[0]) then
        Acur.OnKeyPress:=(Form.Components[i] as TFrApprP).minIn.OnKeyPress;
      if (Form.Components[i].Name='Nit') then
        Acur.Top:=(Form.Components[i] as TLabeledEdit).Top;
    end;
 finally
 end;
 Form.Width:=max(Form.Width,Acur.Left+Acur.Width+10)
end;

Procedure TFitFunctLSM.GRElementsToForm(Form:TForm);
begin
  inherited GRElementsToForm(Form);
  GRAccurToForm(Form);
end;

Procedure TFitFunctLSM.GRRealSetValue(Component:TComponent;ToForm:boolean);
begin
 inherited;
 GRSetValueAccur(Component,ToForm);
end;

Procedure TFitFunctLSM.GRSetValueAccur(Component:TComponent;ToForm:boolean);
begin
  if Component.Name='Accuracy' then
    if ToForm then (Component as TLabeledEdit).Text:=ValueToStr555(fAccurancy)
              else  fAccurancy:=StrToFloat555((Component as TLabeledEdit).Text);
end;

Procedure TFitFunctLSM.BeforeFitness(InputData:Pvector);
 var i:integer;
begin
 inherited BeforeFitness(InputData);
 for I := 0 to High(FXmode) do
  begin
    if (FXname[i]='Rs')and(FXvalue[i]<=1e-4) then FXvalue[i]:=1e-4;
    if (FXname[i]='Rsh')and((FXvalue[i]>=1e12)or(FXvalue[i]<=0))
       then FXvalue[i]:=1e12;
    if (FXname[i]='n')and(FXvalue[i]<=0) then FXvalue[i]:=1;
  end;
end;

Procedure TFitFunctLSM.IterWindowPrepare(InputData:PVector);
begin
 inherited IterWindowPrepare(InputData);
 if (Name='PhotoDiodLam') then
  begin
   Labels[2].Visible:=False;
   Labels[2+fNx].Visible:=False;
   Labels[4].Visible:=False;
   Labels[4+fNx].Visible:=False;
   Labels[3].Top:=Labels[2].Top;
   Labels[3+fNx].Top:=Labels[3].Top;
   fIterWindow.Height:=Labels[3].Top+3*Labels[3].Height;
  end;
 if FName='DiodLSM' then
   fIterWindow.Caption:='Direct Aproximation'+fIterWindow.Caption;
 if FName='DiodLam' then
   fIterWindow.Caption:='Lambert Aproximation'+fIterWindow.Caption;
 if FName='PhotoDiodLSM' then
   fIterWindow.Caption:='Direct Aproximation of Illuminated I-V'+fIterWindow.Caption;
 if FName='PhotoDiodLam' then
   fIterWindow.Caption:='Lambert Aproximation of Illuminated I-V'+fIterWindow.Caption;
end;

Procedure TFitFunctLSM.RealFitting (InputData:PVector;
         var OutputData:TArrSingle);
begin
 if not((FName='DiodLSM')or(FName='DiodLam')
    or(FName='PhotoDiodLSM')or(FName='PhotoDiodLam'))
      then Exit;
 if FVariab[0]<=0 then Exit;
 if InputData^.n<7 then  Exit;
 inherited RealFitting (InputData, OutputData);
end;


Function TFitFunctLSM.Secant(num:word;a,b,F:double;
                InputData:PVector;IA:TArrSingle):double;
  var i:integer;
      c,Fb,Fa:double;
begin
    Result:=0;
    Fa:=SquareFormDerivate(InputData,num,a,F,IA);
    if Fa=ErResult then Exit;
    if Fa=0 then
               begin
                  Result:=a;
                  Exit;
                end;
    repeat
      Fb:=SquareFormDerivate(InputData,num,b,F,IA);
      if Fb=0 then
                begin
                  Result:=b;
                  Exit;
                end;
      if Fb=ErResult then Break
                     else
                       begin
                       if Fb*Fa<=0 then Break
                                  else b:=2*b
                       end;
    until false;
    i:=0;
    repeat
      inc(i);
      c:=(a+b)/2;
      Fb:=SquareFormDerivate(InputData,num,c,F,IA);
      Fa:=SquareFormDerivate(InputData,num,a,F,IA);
      if (Fb*Fa<=0) or (Fb=ErResult)
        then b:=c
        else a:=c;
    until (i>1e5)or(abs((b-a)/c)<1e-2);
    if (i>1e5) then Exit;
    Result:=c;
end;


Procedure TFitFunctLSM.TrueFitting (InputData:PVector;
         var OutputData:TArrSingle);
 var X,X2,derivX:TArrSingle;
     bool:boolean;
     Nitt,i:integer;
     Sum1,Sum2,al:double;
begin
  SetLength(X,fNx);
  SetLength(derivX,fNx);
  SetLength(X2,fNx);
  InitialApproximation(InputData,X);
  if X[1]<0 then X[1]:=1;
  if X[0]=ErResult then
                  begin
                    IterWindowClear();
                    Exit;
                  end;
  if not(ParamCorectIsDone(InputData,X)) then
                  begin
                    IterWindowClear();
                    Exit;
                  end;
  Nitt:=0;
  Sum2:=1;

  repeat
   if Nitt<1 then
      if not(SquareFormIsCalculated(InputData,X,derivX,Sum1)) then
                  begin
                    IterWindowClear();
                    Exit;
                  end;

   bool:=true;
   if not(odd(Nitt)) then for I := 0 to High(X) do X2[i]:=X[i];
   if not(odd(Nitt))or (Nitt=0) then Sum2:=Sum1;

   for I := 0 to High(X) do
       begin
         if FXmode[i]=cons then Continue;
         if derivX[i]=0 then Continue;
         if abs(X[i]/100/derivX[i])>1e100 then Continue;
         al:=Secant(i,0,0.1*abs(X[i]/derivX[i]),derivX[i],InputData,X);
         if abs(al*derivX[i]/X[i])>2 then Continue;
         X[i]:=X[i]-al*derivX[i];
         if not(ParamCorectIsDone(InputData,X)) then
                  begin
                    IterWindowClear();
                    Exit;
                  end;
         bool:=(bool)and(abs((X2[i]-X[i])/X[i])<fAccurancy);
         if not(SquareFormIsCalculated(InputData,X,derivX,Sum1)) then
            begin
              IterWindowClear();
              Exit;
            end;
       end;

    if (Nitt mod 25)=0 then
       begin
        IterWindowDataShow(Nitt,X);
        for I := 0 to FNx - 1 do
         begin
         if (FXname[i]='Rs')and(X[i]<=1e-4) then
                     Labels[i+FNx].Caption:='0';
         if (FXname[i]='Rsh')and(X[i]>=9e11) then
                     Labels[i+FNx].Caption:='INF';
         end;
        Application.ProcessMessages;
       end;

    Inc(Nitt);
  until (abs((sum2-sum1)/sum1)<fAccurancy) or
        bool or
        (Nitt>FNit) or
        not(FIterWindow.Visible);
  EndFitting(X,OutputData);
end;

Procedure TFitFunctLSM.IA_Begin(var AuxiliaryVector:PVector;
               var IA:TArrSingle);
begin
   IA[0]:=ErResult;
   new(AuxiliaryVector);
end;

Function TFitFunctLSM.IA_Determine3(Vector1,Vector2:PVector):double;
begin
 Diferen (Vector1,Vector2);
   {фактично, в temp залеженість оберненого опору від напруги}
 if FXmode[3]=cons then Result:=FXvalue[3]
                   else
         Result:=(Vector2^.X[1]/Vector2^.y[2]-Vector2^.X[2]/Vector2^.y[1])/
                (Vector2^.X[1]-Vector2^.X[2]);
  {Rsh0 - по початковим двом значенням опору проводиться пряма і визначається очікуване
        значення при нульовій напрузі}
end;

Procedure TFitFunctLSM.IA_Determine012(AuxiliaryVector:PVector;var IA:TArrSingle);
 var i,k:integer;
     temp2:PVector;
begin
  k:=-1;
  for i:=0 to High(AuxiliaryVector^.X) do
         if AuxiliaryVector^.Y[i]<0 then k:=i;
  new(temp2);
  if k<0 then IVchar(AuxiliaryVector,temp2)
         else
         begin
           SetLenVector(temp2,AuxiliaryVector^.n-k-1);
           for i:=0 to High(temp2^.X) do
             begin
              temp2^.Y[i]:=AuxiliaryVector^.Y[i+k+1];
              temp2^.X[i]:=AuxiliaryVector^.X[i+k+1];
             end;
         end;
  for i:=0 to High(temp2^.X) do
     temp2^.Y[i]:=ln(temp2^.Y[i]);

  if High(temp2^.X)>6 then
     begin
       SetLenVector(AuxiliaryVector,High(temp2^.X)-3);
       for i:=3 to High(temp2^.X) do
        begin
         AuxiliaryVector^.X[i-3]:=temp2^.X[i];
         AuxiliaryVector^.Y[i-3]:=temp2^.Y[i];
        end;
     end;
  LinAprox(AuxiliaryVector,IA[2],IA[0]);{}
  IA[2]:=exp(IA[2]);
  IA[0]:=1/(Kb*FVariab[0]*IA[0]);
  {I00 та n0 в результаті лінійної апроксимації залежності
  ln(I) від напруги, береться ВАХ з врахуванням Rsh0}
  if FXmode[2]=cons then IA[2]:=FXvalue[2];
  if FXmode[0]=cons then IA[0]:=FXvalue[0];

  for i:=0 to High(temp2^.X) do
     begin
      temp2^.Y[i]:=exp(temp2^.Y[i]);;
     end;
 {в temp2 - частина ВАХ з врахуванням Rsh0, для якої
  значення струму додатні}

  Diferen (temp2,AuxiliaryVector);
   for i:=0 to High(AuxiliaryVector.X) do
     begin
     AuxiliaryVector^.X[i]:=1/temp2^.Y[i];
     AuxiliaryVector^.Y[i]:=1/AuxiliaryVector^.Y[i];
     end;
  {в temp - залежність dV/dI від 1/І}

  if AuxiliaryVector^.n>5 then
     begin
     SetLenVector(temp2,5);
     for i:=0 to 4 do
       begin
           temp2^.X[i]:=AuxiliaryVector^.X[High(AuxiliaryVector.X)-i];
           temp2^.Y[i]:=AuxiliaryVector^.Y[High(AuxiliaryVector.X)-i];
       end;
     end
             else
         IVchar(temp2,AuxiliaryVector);
  LinAprox(temp2,IA[1],AuxiliaryVector^.X[0]);
  {Rs0 - як вільних член лінійної апроксимації
  щонайбільше п'яти останніх точок залежності dV/dI від 1/І;
  dV/dI= (nKbT)/(qI)+Rs;
  temp^.X[0] використане лише для того, щоб
  не вводити допоміжну змінну}
  if FXmode[1]=cons then IA[1]:=FXvalue[1];
 dispose(temp2);
end;

Procedure TFitFunctLSM.InitialApproximation(InputData:PVector;var IA:TArrSingle);
  var temp:Pvector;
      i:integer;
begin
 IA_Begin(temp,IA);
 IA[3]:=IA_Determine3(InputData,temp);
 for I := 0 to High(temp^.X) do
    temp^.Y[i]:=(InputData^.Y[i]-InputData^.X[i]/IA[3]);
  {в temp - ВАХ з врахуванням Rsh0}
 IA_Determine012(temp,IA);
 dispose(temp);
end;

Function TFitFunctLSM.ParamCorectIsDone(InputData:PVector;var IA:TArrSingle):boolean;
begin
  Result:=false;
  if IA[1]<0.0001 then IA[1]:=0.0001;
  if (IA[3]<=0) or (IA[3]>1e12) then IA[3]:=1e12;
  while (ParamIsBad(InputData,IA))and(IA[0]<1000) do
     IA[0]:=IA[0]*2;
  while (ParamIsBad(InputData,IA))and(IA[2]>1e-15) do
     IA[2]:=IA[2]/1.5;
  if  ParamIsBad(InputData,IA) then Exit;
  Result:=true;
end;

Function TFitFunctLSM.ParamIsBad(InputData:PVector; IA:TArrSingle):boolean;
 var bt:double;
     i:integer;
begin
  Result:=true;
  if IA[0]<=0 then Exit;
  bt:=2/Kb/FVariab[0]/IA[0];
  if IA[1]<0 then Exit;
  if (IA[2]<0) or (IA[2]>1) then Exit;
  if IA[3]<=1e-4 then Exit;
  for I := 0 to High(InputData^.X) do
    if bt*(InputData^.X[i]-IA[1]*InputData^.Y[i])>700 then Exit;
  Result:=false;
end;

Function TFitFunctLSM.SquareFormIsCalculated(InputData:PVector; X:TArrSingle;
             var RezF:TArrSingle; var RezSum:double):boolean;
 var i:integer;
     n, Rs, I0, Rsh, Iph,
     Zi,ZIi,nkT,vi,ei,eiI0:double;
begin
 n:=X[0];
 Rs:=X[1];
 I0:=X[2];
 Rsh:=X[3];
 Iph:=0;
 if High(X)=4 then Iph:=X[4];
 nkT:=n*Kb*FVariab[0];
 for I := 0 to High(RezF) do  RezF[i]:=0;
 RezSum:=0;
 try
  for I := 0 to High(InputData^.X) do
     begin
       vi:=(InputData^.X[i]-InputData^.Y[i]*Rs);
       ei:=exp(vi/nkT);
       Zi:=I0*(ei-1)+vi/Rsh-InputData^.Y[i];
       if High(X)>3 then Zi:=Zi-Iph;
       ZIi:=Zi/abs(InputData^.Y[i]);
       eiI0:=ei*I0/nkT;
       RezSum:=RezSum+ZIi*Zi;
       RezF[0]:=RezF[0]-ZIi*eiI0*vi;
       RezF[1]:=RezF[1]-Zi*(eiI0+1/Rsh);
       RezF[2]:=RezF[2]+ZIi*(ei-1);
       RezF[3]:=RezF[3]-ZIi*vi;
       if High(X)=4 then RezF[4]:=RezF[4]-ZIi;
     end;
  for I := 0 to High(RezF) do RezF[i]:=RezF[i]*2;
  RezF[0]:=RezF[0]/n;
  RezF[3]:=RezF[3]/Rsh/Rsh;
  Result:=True;
 except
  Result:=False;
 end;
end;


Function TFitFunctLSM.SquareFormDerivate(InputData:Pvector;num:byte;al,F:double;
                     X:TArrSingle):double;
 var i:integer;
     Zi,Rez,nkT,vi,ei,eiI0,
     n,Rs,I0,Rsh,Iph:double;
begin
 Result:=ErResult;
 n:=X[0];
 Rs:=X[1];
 I0:=X[2];
 Rsh:=X[3];
 Iph:=0;
 if High(X)>3 then Iph:=X[4];
 try
  case num of
   0:n:=n-al*F;
   1:Rs:=Rs-al*F;
   2:I0:=I0-al*F;
   3:Rsh:=Rsh-al*F;
   4:Iph:=Iph-al*F;
  end;//case
  if ParamIsBad(InputData,X) then  Exit;
  nkT:=n*Kb*FVariab[0];
  Rez:=0;
  for I := 0 to High(InputData^.X) do
   begin
     vi:=(InputData^.X[i]-InputData^.Y[i]*Rs);
     ei:=exp(vi/nkT);
     Zi:=I0*(ei-1)+vi/Rsh-InputData^.Y[i];
     if High(X)>3 then Zi:=Zi-Iph;
     eiI0:=ei*I0/nkT;

     case num of
       0:Rez:=Rez+Zi/abs(InputData^.Y[i])*eiI0*vi;
       1:Rez:=Rez+Zi*(eiI0+1/Rsh);
       2:Rez:=Rez+Zi/abs(InputData^.Y[i])*(1-ei);
       3:Rez:=Rez+Zi/abs(InputData^.Y[i])*vi/Rsh/Rsh;
       4:Rez:=Rez-ZI/abs(InputData^.Y[i]);
     end; //case
   end;
   Rez:=2*F*Rez;
   if num=0 then Rez:=Rez/n;
  Result:=Rez;
 except
 end;//try
end;

//-------------------------------------------------------
Constructor TDiodLSM.Create;
begin
 inherited Create('DiodLSM','Diod function, least-squares fitting',
                     4);
 ReadFromIniFile();
end;

Function TDiodLSM.Func(Parameters:TArrSingle):double;
begin
 Result:=Full_IV(fX,Parameters[0]*Kb*FVariab[0],Parameters[1],
                 Parameters[2],Parameters[3],0);
end;


Function TDiodLam.ParamIsBad(InputData:PVector; IA:TArrSingle):boolean;
var bt:double;
begin
  Result:=true;
  if IA[0]<=0 then Exit;
  bt:=1/Kb/FVariab[0];
  if IA[0]<=0 then Exit;
  if IA[1]<0 then Exit;
  if IA[2]<0  then Exit;
  if IA[3]<0 then Exit;
  if bt/IA[0]*(InputData^.X[InputData^.n-1]+IA[1]*IA[2])>ln(1e308)
                       then Exit;
  if bt*IA[1]*IA[2]/IA[0]*exp(Kb*FVariab[0]/IA[0]*(InputData^.X[InputData^.n-1]+IA[1]*IA[2]))>ln(1e308)
                       then Exit;
  Result:=false;
end;


Function TDiodLam.SquareFormIsCalculated(InputData:PVector; X:TArrSingle;
             var RezF:TArrSingle; var RezSum:double):boolean;
 var i:integer;
     n, Rs, I0, Rsh,
     bt,Zi,Wi,F1s,
     I0Rs,nWi,ci,ZIi,s23,
     F2,F1:double;
begin
 n:=X[0];
 Rs:=X[1];
 I0:=X[2];
 Rsh:=X[3];
 bt:=1/Kb/FVariab[0];
 for I := 0 to High(RezF) do  RezF[i]:=0;
 RezSum:=0;

 I0Rs:=I0*Rs;
 F2:=bt*I0Rs;
 F1:=bt*Rs;
 try
  for I := 0 to High(InputData^.X) do
     begin
       ci:=bt*(InputData^.X[i]+I0Rs);
       Wi:=Lambert(bt*I0Rs/n*exp(ci/n));
       nWi:=n*Wi;
       Zi:=n/bt/Rs*Wi+InputData^.X[i]/Rsh-I0-InputData^.Y[i];
       ZIi:=Zi/abs(InputData^.Y[i]);
       F1s:=F1*(Wi+1);
       s23:=(F2-nWi)/F1s;
       RezSum:=RezSum+ZIi*Zi;
       RezF[0]:=RezF[0]+ZIi*Wi*(nWi-ci)/F1s;
       RezF[1]:=RezF[1]+ZIi*Wi*s23;
       RezF[2]:=RezF[2]-ZIi*s23;
       RezF[3]:=RezF[3]-ZIi*InputData^.X[i];
     end;

  for I := 0 to High(RezF) do RezF[i]:=RezF[i]*2;
  RezF[1]:=RezF[1]/n;
  RezF[2]:=RezF[2]/Rs;
  RezF[2]:=RezF[2]/I0;
  RezF[3]:=RezF[3]/Rsh/Rsh;
  Result:=True;
 except
  Result:=False;
 end;
end;

Function TDiodLam.SquareFormDerivate(InputData:Pvector;num:byte;al,F:double;
                     X:TArrSingle):double;
 var i:integer;
     Yi,bt,Zi,Wi,I0Rs,ci,Rez,g1,
     n,Rs,I0,Rsh:double;
begin
 Result:=ErResult;
 n:=X[0];
 Rs:=X[1];
 I0:=X[2];
 Rsh:=X[3];
 try
  case num of
   0:n:=n-al*F;
   1:Rs:=Rs-al*F;
   2:I0:=I0-al*F;
   3:Rsh:=Rsh-al*F;
  end;//case
  if ParamIsBad(InputData,X) then  Exit;
  bt:=1/Kb/FVariab[0];
  I0Rs:=I0*Rs;
  g1:=bt*I0Rs;
  Rez:=0;
  for I := 0 to High(InputData^.X) do
     begin
       ci:=bt*(InputData^.X[i]+I0Rs);
       Yi:=bt*I0Rs/n*exp(ci/n);
       Wi:=Lambert(Yi);
       Zi:=n/bt/Rs*Wi+InputData^.X[i]/Rsh-I0-InputData^.Y[i];
       case num of
           0:Rez:=Rez-Zi/abs(InputData^.Y[i])*Wi*(ci-n*Wi)/(1+Wi);
           1:Rez:=Rez+Zi/abs(InputData^.Y[i])*Wi*(n*Wi-g1)/(1+Wi);
           2:Rez:=Rez-Zi/abs(InputData^.Y[i])*(n*Wi-g1)/(1+Wi);
           3:Rez:=Rez+Zi/abs(InputData^.Y[i])*InputData^.X[i];
        end; //case
     end;
  case num of
       0:Rez:=2*Rez*F/(bt*n*Rs);
       1:Rez:=2*Rez*F/(bt*Rs*Rs);
       2:Rez:=2*Rez*F/(bt*I0Rs);
       3:Rez:=2*Rez*F/Rsh/Rsh;
  end; //case
  Result:=Rez;
 except
 end;//try
end;

Constructor TDiodLam.Create;
begin
 inherited Create('DiodLam','Diod function, Lambert function fitting',
                     4);
 ReadFromIniFile();
end;

Function TDiodLam.Func(Parameters:TArrSingle):double;
begin
 Result:=LambertAprShot(fX,Parameters[0]*Kb*FVariab[0],Parameters[1],
                 Parameters[2],Parameters[3]);
end;


Procedure TPhotoDiodLSM.InitialApproximation(InputData:PVector;var  IA:TArrSingle);
 var temp,temp2:Pvector;
     i:integer;
begin
 IA_Begin(temp,IA);

 if (VocCalc(InputData)<=0.002) then Exit;
 IA[4]:=IscCalc(InputData);
 if (IA[4]<=1e-8) then Exit;

 new(temp2);
 IVchar(InputData,temp2);
 for I := 0 to High(temp2^.X) do
   temp2^.Y[i]:=temp2^.Y[i]+IA[4];

 IA[3]:=IA_Determine3(temp2,temp);

 for I := 0 to High(temp^.X) do
   temp^.Y[i]:=(temp2^.Y[i]-temp2^.X[i]/IA[3]);
    {в temp - ВАХ з врахуванням Rsh0}
 dispose(temp2);
 IA_Determine012(temp,IA);
 dispose(temp);
end;


Constructor TPhotoDiodLSM.Create;
begin
 inherited Create('PhotoDiodLSM',
                  'Function of lightened diod, least-squares fitting',
                    5);
 fYminDontUsed:=True;
 ReadFromIniFile();
end;

Function TPhotoDiodLSM.Func(Parameters:TArrSingle):double;
begin
 Result:=Full_IV(fX,Parameters[0]*Kb*FVariab[0],Parameters[1],
                 Parameters[2],Parameters[3],Parameters[4]);
end;

Constructor TPhotoDiodLam.Create;
begin
 inherited Create('PhotoDiodLam',
                  'Function of lightened diod, Lambert function fitting',
                    5);
 fYminDontUsed:=True;
 ReadFromIniFile();
end;



Procedure TPhotoDiodLam.InitialApproximation(InputData:PVector;var  IA:TArrSingle);
  var temp,temp2:Pvector;
      i:integer;
begin
   IA_Begin(temp,IA);

   IA[2]:=IscCalc(InputData);
   IA[4]:=VocCalc(InputData);
   if (IA[4]<=0.002)or(IA[2]<1e-8) then Exit;
   FXmode[2]:=cons;
   FXmode[4]:=cons;

   IA[3]:=IA_Determine3(InputData,temp);

   {n та Rs0 - як нахил та вільних член лінійної апроксимації
    щонайбільше семи останніх точок залежності dV/dI від kT/q(Isc+I-V/Rsh);}
    for I := 0 to High(temp^.X) do
       begin
         temp^.Y[i]:=1/temp^.Y[i];
         temp^.X[i]:=Kb*FVariab[0]/(IA[2]+InputData^.Y[i]-InputData^.X[i]/IA[3]);
       end;
    new(temp2);
    if temp^.n>7 then
       begin
        SetLenVector(temp2,7);
       for i:=0 to 6 do
          begin
            temp2^.X[i]:=temp^.X[High(temp.X)-i];
            temp2^.Y[i]:=temp^.Y[High(temp.X)-i];
          end;
       end
                else IVchar(temp2,temp);
       LinAprox(temp2,IA[1],IA[0]);
    if FXmode[1]=cons then IA[1]:=FXvalue[1];
    if FXmode[0]=cons then IA[0]:=FXvalue[0];
    dispose(temp2);
    dispose(temp);
end;


Function TPhotoDiodLam.ParamCorectIsDone(InputData:PVector;var IA:TArrSingle):boolean;
begin
  Result:=false;
  if (FVariab[0]<=0) or (IA[2]<=5e-8) or (IA[4]<=1e-3) then Exit;
  if (IA[0]=0)or(IA[0]=ErResult) then Exit;
  if IA[1]<0.0001 then IA[1]:=0.0001;
  if (IA[3]<=0) or (IA[3]>1e12) then IA[3]:=1e12;
  while (ParamIsBad(InputData,IA))and(IA[0]<1000) do
   IA[0]:=IA[0]*2;
  if  ParamIsBad(InputData,IA) then Exit;
  Result:=true;
end;

Function TPhotoDiodLam.ParamIsBad(InputData:PVector; IA:TArrSingle):boolean;
var nkT,t1,t2:double;
begin
  Result:=true;
  nkT:=IA[0]*Kb*FVariab[0];
  if IA[0]<=0 then Exit;
  if IA[1]<=0 then Exit;
  if IA[3]<=0 then Exit;
  if IA[2]<=0 then Exit;
  if IA[4]<=0 then Exit;
  if 2*(IA[4]+IA[2]*IA[1])/nkT > ln(1e308) then Exit;
  if exp(IA[4]/nkT) = exp(IA[2]*IA[1]/nkT) then Exit;
  t1:=(IA[1]*IA[2]-IA[4])/nkT;
  if t1 > ln(1e308) then Exit;
  t2:=IA[3]*IA[1]/nkT/(IA[1]+IA[3])*
      (IA[4]/IA[3]+(IA[2]+(IA[1]*IA[2]-IA[4])/IA[3])/(1-exp(t1))
           +InputData^.X[InputData^.n-1]/IA[1]);
  if abs(t2) > ln(1e308) then Exit;
  if IA[1]/nkT*(IA[2]-IA[4]/(IA[1]+IA[3]))*exp(-IA[4]/nkT)*exp(t2)/(1-exp(t1))> 700
                         then Exit;
  Result:=false;
end;


Function TPhotoDiodLam.SquareFormIsCalculated(InputData:PVector; X:TArrSingle;
             var RezF:TArrSingle; var RezSum:double):boolean;
 var i:integer;
    Yi,Zi,Wi,GVI,Z1,Y1,F1,F12,F21,F22,F3,F31,
    ZIi,nkT,W_W1,
    n,Rs,Rsh,Isc,Voc:double;
begin
 Result:=False;
 for I := 0 to High(RezF) do  RezF[i]:=0;
 RezSum:=0;
 n:=X[0];
 Rs:=X[1];
 Rsh:=X[3];
 Isc:=X[2];
 Voc:=X[4];

 try
  nkT:=n*kb*FVariab[0];
  GVI:=(exp(Isc*Rs/nkT)-exp(Voc/nkT));
  Z1:=Rsh/(Rs+Rsh)*((Isc+(Rs*Isc-Voc)/Rsh)/(1-exp((Rs*Isc-Voc)/nkT))+Voc/Rsh);
  Y1:=Voc/Rsh+(Isc+(Rs*Isc-Voc)/Rsh)/(1-exp((Rs*Isc-Voc)/nkT));
  F1:=exp((Isc*Rs+Voc)/nkT)*(Isc*Rs-Voc)*(Isc*(Rs+Rsh)-Voc)/(nkT*n*(Rs+Rsh)*GVI*GVI);
  F12:=(exp(2*Voc/nkT)*(Rs+Rsh)*(nkT+Isc*Rs-Voc)+
     exp(2*Isc*Rs/nkT)*((nkT-Isc*Rs)*(Rs+Rsh)+Rs*Voc)+
     exp((Isc*Rs+Voc)/nkT)*(-2*nkT*(Rs+Rsh)+(Rs*(Isc*Rs-Voc)*(Isc*(Rs+Rsh)-Voc))/nkT+Rsh*Voc))/sqr(GVI);
  F21:=(exp(2*Isc*Rs/nkT)*nkT*Voc-exp((Isc*Rs+Voc)/nkT)*
      (Isc*(Rs + Rsh)*(Isc*(Rs + Rsh)-Voc)+nkT*Voc))/
      (sqr(GVI)*nkT*sqr((Rs + Rsh)));
  F22:=(-exp(Voc/nkT)*nkT*(Rs + Rsh) +
     exp(Isc*Rs/nkT)*((nkT - Isc*Rs)*(Rs + Rsh) + Rs*Voc))*
     (exp(Isc*Rs/nkT)*nkT*(Isc*(Rs + Rsh)*(Rs+Rsh) - Rsh*Voc) +
     exp(Voc/nkT)*(-Isc*(nkT + Isc*Rs)*(Rs + Rsh)*(Rs+Rsh) +
     (nkT*Rsh + Isc* Rs* (Rs + Rsh))* Voc))/(nkT*Rs*sqr(GVI)*(Isc*(Rs+Rsh)-Voc));
  F3:=Voc/(1-exp((Voc-Isc*Rs)/nkT));
  F31:=nkT*Voc/(Rs*(Isc-Voc/(Rs+Rsh)));

  for I := 0 to High(InputData^.X) do
     begin
       Yi:=Rs/nkT*(Isc-Voc/(Rs+Rsh))*exp(-Voc/nkT)/(1-exp((Rs*Isc-Voc)/nkT))*
       exp(Rsh*Rs/nkT/(Rs+Rsh)*(InputData^.X[i]/Rs+Y1));
       Zi:=InputData^.X[i]/(Rs+Rsh)-Z1+nkT/Rs*Lambert(Yi)-InputData^.Y[i];
       Wi:=Lambert(Yi);
       if Wi=ErResult then Exit;
       W_W1:=Wi/(Wi+1);
       ZIi:=Zi/abs(InputData^.Y[i]);
       RezSum:=RezSum+ZIi*Zi;
       RezF[0]:=RezF[0]+ZIi*(F1+Kb*FVariab[0]/Rs*Wi-
                W_W1/(n*Rs*(Rs+Rsh))*(F12+Rsh*InputData^.X[i]));
       RezF[1]:=RezF[1]+ZIi*(-InputData^.X[i]/sqr(Rs+Rsh)+F21-nkT/sqr(Rs)*Wi+
              W_W1/(Rs*sqr(Rs+Rsh))*(F22-Rsh*InputData^.X[i]));
      RezF[3]:=RezF[3]+ZIi*(F3-InputData^.X[i]+F31*Wi)/((1+Wi)*sqr(Rs+Rsh));
     end;
  for I := 0 to High(RezF) do RezF[i]:=RezF[i]*2;
  Result:=True;
 finally
 end;
end;

Function TPhotoDiodLam.SquareFormDerivate(InputData:Pvector;num:byte;al,F:double;
                     X:TArrSingle):double;
 var i:integer;
     Yi,Zi,Wi,GVI,Z1,Y1,F1,F12,F21,F22,F3,F31,
     nkT,W_W1,Rez,
     n,Rs,Rsh,Isc,Voc:double;
begin
 Result:=ErResult;
 n:=X[0];
 Rs:=X[1];
 Rsh:=X[3];
 Isc:=X[2];
 Voc:=X[4];
 try
  case num of
     0:n:=n-al*F;
     1:Rs:=Rs-al*F;
     3:Rsh:=Rsh-al*F;
   end;//case
  if ParamIsBad(InputData,X) then  Exit;
  nkT:=n*kb*FVariab[0];
  GVI:=(exp(Isc*Rs/nkT)-exp(Voc/nkT));
  Z1:=Rsh/(Rs+Rsh)*((Isc+(Rs*Isc-Voc)/Rsh)/(1-exp((Rs*Isc-Voc)/nkT))+Voc/Rsh);
  Y1:=Voc/Rsh+(Isc+(Rs*Isc-Voc)/Rsh)/(1-exp((Rs*Isc-Voc)/nkT));
  F1:=exp((Isc*Rs+Voc)/nkT)*(Isc*Rs-Voc)*(Isc*(Rs+Rsh)-Voc)/(nkT*n*(Rs+Rsh)*GVI*GVI);
  F12:=(exp(2*Voc/nkT)*(Rs+Rsh)*(nkT+Isc*Rs-Voc)+
     exp(2*Isc*Rs/nkT)*((nkT-Isc*Rs)*(Rs+Rsh)+Rs*Voc)+
     exp((Isc*Rs+Voc)/nkT)*(-2*nkT*(Rs+Rsh)+(Rs*(Isc*Rs-Voc)*(Isc*(Rs+Rsh)-Voc))/nkT+Rsh*Voc))/sqr(GVI);
  F21:=(exp(2*Isc*Rs/nkT)*nkT*Voc-exp((Isc*Rs+Voc)/nkT)*
      (Isc*(Rs + Rsh)*(Isc*(Rs + Rsh)-Voc)+nkT*Voc))/
      (sqr(GVI)*nkT*sqr((Rs + Rsh)));
  F22:=(-exp(Voc/nkT)*nkT*(Rs + Rsh) +
     exp(Isc*Rs/nkT)*((nkT - Isc*Rs)*(Rs + Rsh) + Rs*Voc))*
     (exp(Isc*Rs/nkT)*nkT*(Isc*(Rs + Rsh)*(Rs+Rsh) - Rsh*Voc) +
     exp(Voc/nkT)*(-Isc*(nkT + Isc*Rs)*(Rs + Rsh)*(Rs+Rsh) +
     (nkT*Rsh + Isc* Rs* (Rs + Rsh))* Voc))/(nkT*Rs*sqr(GVI)*(Isc*(Rs+Rsh)-Voc));
  F3:=Voc/(1-exp((Voc-Isc*Rs)/nkT));
  F31:=nkT*Voc/(Rs*(Isc-Voc/(Rs+Rsh)));

  Rez:=0;
  for I := 0 to High(InputData^.X) do
     begin
       Yi:=Rs/nkT*(Isc-Voc/(Rs+Rsh))*exp(-Voc/nkT)/(1-exp((Rs*Isc-Voc)/nkT))*
       exp(Rsh*Rs/nkT/(Rs+Rsh)*(InputData^.X[i]/Rs+Y1));
       Zi:=InputData^.X[i]/(Rs+Rsh)-Z1+nkT/Rs*Lambert(Yi)-InputData^.Y[i];
       Wi:=Lambert(Yi);
       if Wi=ErResult then Exit;
       W_W1:=Wi/(Wi+1);

       case num of
        0: Rez:=Rez+Zi/abs(InputData^.Y[i])*(F1+Kb*FVariab[0]/Rs*Wi-
                    W_W1/(n*Rs*(Rs+Rsh))*(F12+Rsh*InputData^.X[i]));

        1: Rez:=Rez+Zi/abs(InputData^.Y[i])*(-InputData^.X[i]/sqr(Rs+Rsh)+F21-nkT/sqr(Rs)*Wi+
                  W_W1/(Rs*sqr(Rs+Rsh))*(F22-Rsh*InputData^.X[i]));

        3: Rez:=Rez+Zi/abs(InputData^.Y[i])*(F3-InputData^.X[i]+F31*Wi)/((1+Wi)*sqr(Rs+Rsh));

       end; //case
     end;
  Rez:=2*F*Rez;
  Result:=Rez;
 except
 end;//try
end;

Procedure TPhotoDiodLam.EndFitting(FinalResult:TArrSingle;
              var OutputData:TArrSingle);
begin
 inherited EndFitting(FinalResult,OutputData);
 OutputData[2]:=(FinalResult[2]+(FinalResult[1]*FinalResult[2]-FinalResult[4])/FinalResult[3])*
              exp(-FinalResult[4]/FinalResult[0]/Kb/FVariab[0])/
              (1-exp((FinalResult[1]*FinalResult[2]-FinalResult[4])/FinalResult[0]/Kb/FVariab[0]));
 OutputData[4]:= OutputData[2]*(exp(FinalResult[4]/FinalResult[0]/Kb/FVariab[0])-1)+
                FinalResult[4]/FinalResult[3];
end;

Function TPhotoDiodLam.Func(Parameters:TArrSingle):double;
begin
 Result:=LambertLightAprShot(fX,Parameters[0]*Kb*FVariab[0],
        Parameters[1],Parameters[2],Parameters[3],Parameters[4]);
end;

//--------------------------------------------------
Constructor TFitFunctEvolution.Create(FunctionName,FunctionCaption:string;
                     Npar,Nvar,NaddX:byte);
begin
 inherited Create(FunctionName,FunctionCaption,Npar,Nvar,NaddX);
 SetLength(FXmin,FNx);
 SetLength(FXmax,FNx);
 SetLength(FXminlim,FNx);
 SetLength(FXmaxlim,FNx);
end;

Procedure TFitFunctEvolution.RealReadFromIniFile;
 var i:byte;
begin
 inherited RealReadFromIniFile;
 for I := 0 to High(FXmin) do
  begin
   ReadIniDefFit(FXname[i]+'Xmin',FXmin[i]);
   ReadIniDefFit(FXname[i]+'Xmax',FXmax[i]);
   ReadIniDefFit(FXname[i]+'Xminlim',FXminlim[i]);
   ReadIniDefFit(FXname[i]+'Xmaxlim',FXmaxlim[i]);
  end;
 FEvType:=FConfigFile.ReadEvType(FName,'EvType',TDE);
end;

Procedure TFitFunctEvolution.RealWriteToIniFile;
 var i:byte;
begin
 inherited RealWriteToIniFile;
 for I := 0 to High(FXmin) do
  begin
   WriteIniDefFit(FXname[i]+'Xmin',FXmin[i]);
   WriteIniDefFit(FXname[i]+'Xmax',FXmax[i]);
   WriteIniDefFit(FXname[i]+'Xminlim',FXminlim[i]);
   WriteIniDefFit(FXname[i]+'Xmaxlim',FXmaxlim[i]);
  end;
 FConfigFile.WriteEvType(FName,'EvType',FEvType);
end;

Procedure TFitFunctEvolution.FIsNotReadyDetermination;
 var i:byte;
begin
 inherited FIsNotReadyDetermination;
 for I := 0 to High(FXmode) do
   if ((FXmin[i]=ErResult) or
       (FXmax[i]=ErResult) or
       (FXminlim[i]=ErResult)or
       (FXmaxlim[i]=ErResult))  then FIsNotReady:=True;
end;

Procedure TFitFunctEvolution.GREvTypeToForm(Form:TForm);
var GrBox:TGroupBox;
    EvMode:array [0..3] of TRadioButton;
    i:integer;
begin
 GrBox:=TGroupBox.Create(Form);
 GrBox.Parent:=Form;
 GrBox.Caption:='Evolution Type';
 GrBox.Name:='EvolutionType';
 GrBox.Left:=250;
 GrBox.Top:=85;
 try
   for i := Form.ComponentCount-1 downto 0 do
    if (Form.Components[i].Name='Nit') then
      begin
        GrBox.Top:=(Form.Components[i] as TLabeledEdit).Top-15;
        GrBox.Left:=(Form.Components[i] as TLabeledEdit).Left+
                 (Form.Components[i] as TLabeledEdit).Width+20;
      end;
 finally
 end;
 for I := 0 to High(EvMode) do
   begin
   EvMode[i]:=TRadioButton.Create(Form);
   EvMode[i].Parent:=GrBox;
   EvMode[i].Top:=20;
   EvMode[i].Width:=60;
   end;
 EvMode[0].Caption:='DE';
 EvMode[1].Caption:='MABC';
 EvMode[2].Caption:='TLBO';
 EvMode[3].Caption:='PSO';
 EvMode[0].Name:='DE';
 EvMode[1].Name:='MABC';
 EvMode[2].Name:='TLBO';
 EvMode[3].Name:='PSO';
 EvMode[0].Left:=5;
 for I := 1 to High(EvMode) do
   begin
   EvMode[i].Left:=5+EvMode[i-1].Left+EvMode[i-1].Width;
   end;
 GrBox.Width:=EvMode[High(EvMode)].Left+EvMode[High(EvMode)].Width+5;
 GrBox.Height:=EvMode[High(EvMode)].Height+30;

 Form.Width:=max(Form.Width,GrBox.Width+10);
end;

Procedure TFitFunctEvolution.GRElementsToForm(Form:TForm);
begin
  inherited GRElementsToForm(Form);
  GREvTypeToForm(Form);
end;

Procedure TFitFunctEvolution.GRSetValueEvType(Component:TComponent;ToForm:boolean);
   Procedure EvTypeRead(str:string;ev:TEvolutionType);
     begin
        if (Component.Name=str)and(FEvType=ev) then
          begin
                  (Component as TRadioButton).Checked:=True;

          end;
     end;
   Procedure EvTypeWrite(str:string;ev:TEvolutionType);
     begin
        if (Component.Name=str)and((Component as TRadioButton).Checked)
          then FEvType:=ev;
     end;
begin
 if ToForm then
   begin
    EvTypeRead('DE',TDE);
    EvTypeRead('MABC',TMABC);
    EvTypeRead('TLBO',TTLBO);
    EvTypeRead('PSO',TPSO);
   end
           else
   begin
    EvTypeWrite('DE',TDE);
    EvTypeWrite('MABC',TMABC);
    EvTypeWrite('TLBO',TTLBO);
    EvTypeWrite('PSO',TPSO);
   end;
end;

Procedure TFitFunctEvolution.GRSetValueParam(Component:TComponent;ToForm:boolean);
 var i:byte;
begin
 inherited GRSetValueParam(Component,ToForm);
 for i:=0 to fNx-1 do
  if Component.Name=FXname[i] then
    if ToForm then
      begin
       (Component as TFrApprP).minIn.Text:=ValueToStr555(FXmin[i]);
       (Component as TFrApprP).maxIn.Text:=ValueToStr555(FXmax[i]);
       (Component as TFrApprP).minLim.Text:=ValueToStr555(FXminlim[i]);
       (Component as TFrApprP).maxLim.Text:=ValueToStr555(FXmaxlim[i]);
      end
              else
      begin
       FXmin[i]:=StrToFloat555((Component as TFrApprP).minIn.Text);
       FXmax[i]:=StrToFloat555((Component as TFrApprP).maxIn.Text);
       FXminlim[i]:=StrToFloat555((Component as TFrApprP).minLim.Text);
       FXmaxlim[i]:=StrToFloat555((Component as TFrApprP).maxLim.Text);
      end;
end;

Procedure TFitFunctEvolution.GRRealSetValue(Component:TComponent;ToForm:boolean);
begin
  inherited GRRealSetValue(Component,ToForm);
  GRSetValueEvType(Component,ToForm);
end;

Procedure TFitFunctEvolution.TrueFitting (InputData:PVector;var OutputData:TArrSingle);
begin
  case fEvType of
    TMABC:MABCFit (InputData,OutputData);
    TTLBO:TLBOFit (InputData,OutputData);
    TPSO: PSOFit (InputData,OutputData);
    else DEFit (InputData,OutputData);
  end;
end;


Procedure TFitFunctEvolution.PenaltyFun(var X:TArrSingle);
 var i:byte;
     temp:double;
begin
 Randomize;
 for i := 0 to High(X) do
  if (FXmode[i]<>cons) then
     while(X[i]>FXmaxlim[i])or(X[i]<FXminlim[i])do
        case FXmode[i] of
         lin:
           begin
              if (X[i]>FXmaxlim[i]) then
                 temp:=X[i]-Random*(FXmaxlim[i]-FXminlim[i])
                                    else
                 temp:=X[i]+Random*(FXmaxlim[i]-FXminlim[i]);
              if (temp>FXmaxlim[i])
                or(temp<FXminlim[i]) then Continue;
              X[i]:=temp;
           end;//lin:
         logar:
           begin
              if (X[i]>FXmaxlim[i]) then
                 temp:=ln(X[i])-RandomAB(-1,1)*(ln(FXmaxlim[i])-ln(FXminlim[i]))
                                    else
                 temp:=ln(X[i])+RandomAB(-1,1)*(ln(FXmaxlim[i])-ln(FXminlim[i]));
             if (temp>ln(FXmaxlim[i]))
                or(temp<ln(FXminlim[i])) then Continue;
              X[i]:=exp(temp);
           end;//logar:
        end;//case FXmode[i] of
end;

Function TFitFunctEvolution.FitnessFunc(InputData:Pvector; OutputData:TArrSingle):double;
 var i:integer;
begin
  Result:=0;
  for I := 0 to High(InputData^.X) do
     begin
       fX:=InputData^.X[i];
       fY:=InputData^.Y[i];
       Result:=Result+sqr(Summand(OutputData))/Weight(OutputData);
     end;
end;

Function TFitFunctEvolution.Summand(OutputData:TArrSingle):double;
begin
 Result:=Func(OutputData)-fY;
end;

Function TFitFunctEvolution.Weight(OutputData:TArrSingle):double;
begin
 Result:=sqr(fY);
end;

Procedure TFitFunctEvolution.VarRand(var X:TArrSingle);
 var i:byte;
begin
  SetLength(X,FNx);
  for I := 0 to High(X) do
    case FXmode[i] of
     logar: X[i]:=RandomLnAB(FXmin[i],FXmax[i]);
     cons:  X[i]:=FXValue[i];
     else   X[i]:=RandomAB(FXmin[i],FXmax[i]);
    end;
end;

Procedure  TFitFunctEvolution.EvFitInit(InputData:PVector;
                  var X:TArrArrSingle; var Fit:TArrSingle);
 var i:integer;
begin
  i:=0;
  repeat  
   if (i mod 25)=0 then Randomize;
     VarRand(X[i]);
     try
      Fit[i]:=FitnessFunc(InputData,X[i])
     except
      Continue;
     end;
    inc(i);
  until (i>High(X));
end;

Procedure TFitFunctEvolution.EvFitShow(X:TArrArrSingle;
            Fit:TArrSingle; Nit,Nshow:integer);
begin
  if (Nit mod Nshow)=0 then
     begin
      IterWindowDataShow(Nit,X[MinElemNumber(Fit)]);
      Application.ProcessMessages;
     end;
end;

Procedure TFitFunctEvolution.MABCFit (InputData:PVector;var OutputData:TArrSingle);
var Fit,FitMut,Count,Xnew:TArrSingle;
    Np,i,j,Nitt,Limit:integer;
    X:TArrArrSingle;
    SumFit:double;

 Procedure NewSolution(i:integer);
 Label NewSLabel;
 var j,k:integer;
     r,temp:double;
     bool:boolean;
 begin
  NewSLabel:
  repeat
   j:=Random(Np);
  until (j<>i);
  r:=RandomAB(-1,1);
  for k := 0 to fNx - 1 do
     case fXmode[k] of
      lin:Xnew[k]:=X[i,k]+r*(X[i,k]-X[j,k]);
      logar:
          begin
          temp:=ln(X[i,k])+r*(ln(X[i,k])-ln(X[j,k]));;
          Xnew[k]:=exp(temp);
          end;
      cons:Xnew[k]:=fXValue[k];
     end;//case Xmode[k] of
  PenaltyFun(Xnew);
  bool:=False;
  try
   FitMut[i]:=FitnessFunc(InputData,Xnew)
  except
   bool:=True
  end;
  if bool then goto NewSLabel;
 end; // Procedure NewSolution

begin
  Limit:=36;
  Np:=fNx*8;
  SetLength(X,Np,fNx);
  SetLength(Fit,Np);
  SetLength(Count,Np);
  SetLength(FitMut,Np);
  SetLength(Xnew,fNx);
  for i:=0 to High(X) do  Count[i]:=0;

  Nitt:=0;
  fIterWindow.Caption:='Modified Artificial Bee Colony'+fIterWindow.Caption;

  try
   EvFitInit(InputData,X,Fit);
   repeat
     i:=0;
     repeat  //Employed bee
      if (i mod 25)=0 then Randomize;
      NewSolution(i);
      if Fit[i]>FitMut[i] then
       begin
        X[i]:=Copy(Xnew);
        Fit[i]:=FitMut[i];
        Count[i]:=0;
       end
                     else
        Count[i]:=Count[i]+1;
      inc(i);
     until (i>(Np-1));  //Employed bee

     SumFit:=0;   //Onlookers bee
     for I := 0 to Np - 1 do
       SumFit:=SumFit+1/(1+Fit[i]);

     i:=0;//номер   Onlookers bee
     j:=0; // номер джерела меду
     repeat
       if (i mod 25)=0 then Randomize;
       if Random<1/(1+Fit[j])/SumFit then
        begin
          i:=i+1;
          NewSolution(j);
          if Fit[j]>FitMut[j] then
           begin
           X[j]:=Copy(Xnew);
           Fit[j]:=FitMut[j];
           Count[j]:=0;
           end
        end;    // if Random<1/(1+Fit[j])/SumFit then
       j:=j+1;
       if j=Np then j:=0;
     until(i=Np);     //Onlookers bee

     i:=0;
     repeat   //scout
      if (i mod 25)=0 then Randomize;
      j:=MinElemNumber(Fit);
      if (Count[i]>Limit)and(i<>j) then
       begin
        VarRand(X[i]);
        try
         Fit[i]:=FitnessFunc(InputData,X[i])
        except
         Continue;
        end;
        Count[i]:=0;
       end;// if Count[i]>Limit then
      inc(i);
     until i>(Np-1);//scout

     EvFitShow(X,Fit,Nitt,100);
     inc(Nitt);
   until (Nitt>fNit)or not(fIterWindow.Visible);
  finally
   EndFitting(X[MinElemNumber(Fit)],OutputData);
  end;//try
end;


Procedure TFitFunctEvolution.PSOFit (InputData:PVector;var OutputData:TArrSingle);
 const
      C1=2;
      C2=2;
      Wmax=0.9;
      Wmin=0.4;
 var LocBestFit,VelArhiv,XArhiv:TArrSingle;
     Np,i,j,Nitt,GlobBestNumb,k:integer;
     X,Vel,LocBestPar:TArrArrSingle;
     W,temp:double;

begin
 Nitt:=0;
 fIterWindow.Caption:='Particle Swarm Optimization'+fIterWindow.Caption;
 Np:=fNx*15;
 SetLength(X,Np);
 SetLength(LocBestFit,Np);
 SetLength(LocBestPar,Np,fNx);
 SetLength(VelArhiv,fNx);
 SetLength(XArhiv,fNx);

 try
  EvFitInit(InputData,X,LocBestFit);
  GlobBestNumb:=MinElemNumber(LocBestFit);
  for I := 0 to High(X) do LocBestPar[i]:=Copy(X[i]);
  {початкові значення швидкостей}
  SetLength(Vel,Np,fNx);
  for I := 0 to Np-1 do
   for j:= 0 to fNx-1 do Vel[i,j]:=0;

  k:=0;
  repeat
   temp:=0;
   W:=Wmax-(Wmax-Wmin)*Nitt/fNit;
   i:=0;
   repeat
    if (i mod 25)=0 then Randomize;
    VelArhiv:=Copy(Vel[i]);
    XArhiv:=Copy(X[i]);
    for j := 0 to High(fXmode) do
      case fXmode[j] of
        lin:VelArhiv[j]:=W*VelArhiv[j]+C1*Random*(LocBestPar[i,j]-X[i,j])+
                     C2*Random*(LocBestPar[GlobBestNumb,j]-X[i,j]);
        logar:
            VelArhiv[j]:=W*VelArhiv[j]+C1*Random*(ln(LocBestPar[i,j])-ln(X[i,j]))+
                     C2*Random*(ln(LocBestPar[GlobBestNumb,j])-ln(X[i,j]));
      end; //case fXmode[j] of
    for j := 0 to High(fXmode) do
      case fXmode[j] of
        lin:
          begin
            XArhiv[j]:=XArhiv[j]+VelArhiv[j];
            while(XArhiv[j]>FXmaxlim[j])
                or(XArhiv[j]<FXminlim[j])do
              begin
               if XArhiv[j]>FXmaxlim[j] then
                  begin
                   VelArhiv[j]:=FXmaxlim[j]-X[i,j];
                   temp:=FXmaxlim[j]-Random*X[i,j];

                  end
                                       else
                  begin
                   VelArhiv[j]:=FXminlim[j]-X[i,j];
                   temp:=FXminlim[j]+Random*X[i,j];
                  end;
               if (temp>FXmaxlim[j])
                  or(temp<FXminlim[j]) then
                  begin
                   Continue;
                  end;
               XArhiv[j]:=temp;
              end;//while(XArhiv[j]>FXmaxlim[j]) or(XArhiv[j]<FXminlim[j])
          end;// lin:
        logar:
          begin
            XArhiv[j]:=ln(XArhiv[j])+VelArhiv[j];
            while(XArhiv[j]>ln(FXmaxlim[j]))
                or(XArhiv[j]<ln(FXminlim[j]))do
              begin
               if (XArhiv[j]>ln(FXmaxlim[j])) then
                  begin
                   VelArhiv[j]:=ln(FXmaxlim[j])-ln(X[i,j]);
                   temp:=ln(FXmaxlim[j])-RandomAB(-1,1)*ln(X[i,j]);
                  end
                                              else
                  begin
                    VelArhiv[j]:=ln(FXminlim[j])-ln(X[i,j]);
                    temp:=ln(FXminlim[j])+RandomAB(-1,1)*ln(X[i,j]);
                  end;
               if (temp>ln(FXmaxlim[j]))
                     or(temp<ln(FXminlim[j])) then Continue;
               XArhiv[j]:=temp;
              end;//while(XArhiv[j]>ln(FXmaxlim[j])) or(XArhiv[j]<ln(FXminlim[j]))
             XArhiv[j]:=exp(XArhiv[j]);
          end; //logar:
      end;//case Xmode[j] of

    try
      temp:=FitnessFunc(InputData,XArhiv)
    except
     inc(k);
     if k>20 then VarRand(X[i]);
     Continue;
    end;
    k:=0;
    Vel[i]:=Copy(VelArhiv);
    X[i]:=Copy(XArhiv);
    if temp<LocBestFit[i] then
        begin
         LocBestFit[i]:=temp;
         LocBestPar[i]:=Copy(X[i]);
        end;
    inc(i);
   until (i>High(X));
   GlobBestNumb:=MinElemNumber(LocBestFit);
   EvFitShow(LocBestPar,LocBestFit,Nitt,100);
   inc(Nitt);
  until (Nitt>fNit)or not(fIterWindow.Visible);
 finally
  EndFitting(LocBestPar[MinElemNumber(LocBestFit)],OutputData);
 end;//try
end;

Procedure TFitFunctEvolution.DEFit (InputData:PVector;var OutputData:TArrSingle);
 const
      F=0.8;
      CR=0.3;
 var Fit,FitMut:TArrSingle;
     Np,i,j,Nitt,k:integer;
     X,Mut:TArrArrSingle;
     r:array [1..3] of integer;
     temp:double;
begin
 Nitt:=0;
 fIterWindow.Caption:='Differential Evolution'+fIterWindow.Caption;
 Np:=fNx*8;
 SetLength(X,Np,fNx);
 SetLength(Mut,Np,fNx);
 SetLength(Fit,Np);
 SetLength(FitMut,Np);

 try
  EvFitInit(InputData,X,Fit);
  repeat
    i:=0;
    repeat  //Вектор мутації
     if (i mod 25)=0 then Randomize;
     for j := 1 to 3 do
        repeat
          r[j]:=Random(Np);
        until (r[j]<>i);
     for k := 0 to High(fXmode) do
        case fXmode[k] of
          lin:Mut[i,k]:=X[r[1],k]+F*(X[r[2],k]-X[r[3],k]);
          logar:
            begin
             temp:=ln(X[r[1],k])+F*(ln(X[r[2],k])-ln(X[r[3],k]));;
             Mut[i,k]:=exp(temp);
            end;
          cons:Mut[i,k]:=fXvalue[k];
        end;//case fXmode[k] of
     PenaltyFun(Mut[i]);
     try
      FitnessFunc(InputData,Mut[i])
     except
      Continue;
     end;
     inc(i);
    until (i>High(Mut));  //Вектор мутації

    i:=0;
    repeat  //Пробні вектори
       if (i mod 25)=0 then Randomize;
       r[2]:=Random(fNx); //randn(i)
       for k := 0 to High(fXmode)do
        case fXmode[k] of
          lin,logar:
            if (Random>CR) and (k<>r[2]) then Mut[i,k]:=X[i,k];
        end;//case Xmode[k] of
       PenaltyFun(Mut[i]);
       try
        FitMut[i]:=FitnessFunc(InputData,Mut[i])
       except
        Continue;
       end;
       inc(i);
    until i>(Np-1);

    for I := 0 to High(X) do
     if Fit[i]>FitMut[i] then
       begin
        X[i]:=Copy(Mut[i]);
        Fit[i]:=FitMut[i]
       end;

    EvFitShow(X,Fit,Nitt,100);
    inc(Nitt);
  until (Nitt>fNit)or not(fIterWindow.Visible);
 finally
  EndFitting(X[MinElemNumber(Fit)],OutputData);
 end;//try
end;

Procedure TFitFunctEvolution.TLBOFit (InputData:PVector;var OutputData:TArrSingle);
 var X:PClassroom;
     Fit:PTArrSingle;
     Xmean,Xnew:TArrSingle;
     i,j,Nitt,Tf,k,Nl:integer;
     temp,r:double;
begin
 Nitt:=0;
 fIterWindow.Caption:='Teaching Learning Based Optimization'+fIterWindow.Caption;
 Nl:=1000;
 SetLength(Xmean,fNx);
 SetLength(Xnew,fNx);
 new(X);
 SetLength(X^,Nl,fNx);
 new(Fit);
 SetLength(Fit^,Nl);
 try
  EvFitInit(InputData,X^,Fit^);
  temp:=1e10;
  repeat
  //----------Teacher phase--------------
    for I := 0 to High(Xmean) do Xmean[i]:=0;
    j:=MaxElemNumber(Fit^);
    for I := 0 to Nl-1 do
      begin
        for k := 0 to High(fXmode) do
            case fXmode[k] of
              lin:Xmean[k]:=Xmean[k]+X^[i,k];
              logar:Xmean[k]:=Xmean[k]+ln(X^[i,k]);
            end;
      end;  //for I := 0 to Nl-1 do
    for k := 0 to High(fXmode) do
      case fXmode[k] of
         lin,logar:Xmean[k]:=Xmean[k]/Nl;
         cons:Xmean[k]:=fXvalue[k];
      end;
    i:=0;
    repeat
      if (i mod 25)=0 then Randomize;
      if i=j then
        begin
          inc(i);
          Continue;
        end;
      r:=Random;
      Tf:=1+Random(2);
      for k := 0 to High(fXmode) do
        case fXmode[k] of
          lin:Xnew[k]:=X^[i,k]+r*(X^[j,k]-Tf*Xmean[k]);
          logar:
            begin
             temp:=ln(X^[i,k])+r*(ln(X^[j,k])-Tf*Xmean[k]);
             Xnew[k]:=exp(temp);
            end;
          cons:Xnew[k]:=fXvalue[k];
        end;
      PenaltyFun(Xnew);
      try
       temp:=FitnessFunc(InputData,Xnew)
      except
       Continue;
      end;
      if Fit^[i]>temp then
          begin
           for k := 0 to High(Xnew) do X^[i,k]:=Xnew[k];
           Fit^[i]:=temp;
          end;
      inc(i);
    until i>High(Fit^);

  //----------Learner phase--------------
    i:=0;
    repeat
      if (i mod 25)=0 then Randomize;
      r:=Random;
      repeat
       Tf:=Random(Nl);
      until (Tf<>i);
      if Fit^[i]>Fit^[Tf] then r:=-1*r;
      for k := 0 to High(fXmode) do
       case fXmode[k] of
         lin:Xnew[k]:=X^[i,k]+r*(X^[i,k]-X^[Tf,k]);
         logar:
            begin
             temp:=ln(X^[i,k])+r*(ln(X^[j,k])-ln(X^[Tf,k]));
             Xnew[k]:=exp(temp);
            end;
         cons:Xnew[k]:=fXvalue[k];
       end;//case

      PenaltyFun(Xnew);
      try
       temp:=FitnessFunc(InputData,Xnew)
      except
       Continue;
      end;
      if Fit^[i]>temp then
          begin
           for k := 0 to High(Xnew) do X^[i,k]:=Xnew[k];
           Fit^[i]:=temp;
          end;
      inc(i);
    until i>High(Fit^);
    EvFitShow(X^,Fit^,Nitt,25);
    inc(Nitt);
  until (Nitt>Nit)or not(fIterWindow.Visible);
 finally
  EndFitting(X^[MinElemNumber(Fit^)],OutputData);
  dispose(X);
  dispose(Fit);
 end;//try
end;


//-------------------------------------------------------
Constructor TDiod.Create;
begin
 inherited Create('Diod','Diod function,  evolution fitting',
                   4,1,1);
 FXname[0]:='n';
 FXname[1]:='Rs';
 FXname[2]:='Io';
 FXname[3]:='Rsh';
 fIsDiod:=True;
 ReadFromIniFile();
end;

Function TDiod.Func(Parameters:TArrSingle):double;
begin
 Result:=Parameters[2]*(exp((fX-fY*Parameters[1])/(Parameters[0]*Kb*FVariab[0]))-1)
      +(fX-fY*Parameters[1])/Parameters[3];
end;

Function TDiod.RealFunc(DeterminedParameters:TArrSingle):double;
begin
 Result:=Full_IV(fX,DeterminedParameters[0]*Kb*FVariab[0],
          DeterminedParameters[1],DeterminedParameters[2],DeterminedParameters[3],0);
end;


Constructor TPhotoDiod.Create;
begin
 inherited Create('PhotoDiod','Function of lightened diod, evolution fitting',
                  5,1,4);
 FXname[0]:='n';
 FXname[1]:='Rs';
 FXname[2]:='Io';
 FXname[3]:='Rsh';
 FXname[4]:='Iph';
 fIsPhotoDiod:=True;
 fYminDontUsed:=True;
 ReadFromIniFile();
end;

Function TPhotoDiod.Func(Parameters:TArrSingle):double;
begin
  Result:=Parameters[2]*(exp((fX-fY*Parameters[1])/(Parameters[0]*Kb*FVariab[0]))-1)
      +(fX-fY*Parameters[1])/Parameters[3]-Parameters[4];
end;


Function TPhotoDiod.RealFunc(DeterminedParameters:TArrSingle):double;
begin
 Result:=Full_IV(fX,DeterminedParameters[0]*Kb*FVariab[0],
          DeterminedParameters[1],DeterminedParameters[2],
          DeterminedParameters[3],DeterminedParameters[4]);
end;

Function TPhotoDiod.Weight(OutputData:TArrSingle):double;
begin
 Result:=sqr(fY+OutputData[4]);
end;

Constructor TDiodTwo.Create;
begin
 inherited Create('DiodTwo','Two Diod function, evolution fitting',
                  5,1,0);
 FName:='DiodTwo';
 FXname[0]:='n1';
 FXname[1]:='Rs';
 FXname[2]:='Io1';
 FXname[3]:='n2';
 FXname[4]:='Io2';
 fSampleIsRequired:=False;
 ReadFromIniFile();
end;

Function TDiodTwo.Func(Parameters:TArrSingle):double;
begin
 Result:=Full_IV(fX,Parameters[0]*Kb*FVariab[0],Parameters[1],Parameters[2],1e13,0)+
       Parameters[4]*(exp(fX/(Parameters[3]*Kb*FVariab[0]))-1);
end;

Constructor TDiodTwoFull.Create;
begin
 inherited Create('DiodTwoFull','Two Full Diod function, evolution fitting',
                  6,1,0);
 FName:='DiodTwoFull';
 FXname[0]:='n1';
 FXname[1]:='Rs1';
 FXname[2]:='Io1';
 FXname[3]:='n2';
 FXname[4]:='Io2';
 FXname[5]:='Rs2';
 fSampleIsRequired:=False;
 ReadFromIniFile();
end;

Function TDiodTwoFull.Func(Parameters:TArrSingle):double;
begin
 Result:=Full_IV(fX,Parameters[0]*Kb*FVariab[0],Parameters[1],Parameters[2],1e13,0)+
         Full_IV(fX,Parameters[3]*Kb*FVariab[0],Parameters[5],Parameters[4],1e13,0);
end;

Constructor TDGaus.Create;
begin
 inherited Create('DGaus','Double Gaussian barrier distribution, evolution fitting',
                  5,0,0);
 FXname[0]:='A';
 FXname[1]:='Fb01';
 FXname[2]:='Sig1';
 FXname[3]:='Fb02';
 FXname[4]:='Sig2';
 fTemperatureIsRequired:=False;
 ReadFromIniFile();
end;

Function TDGaus.Func(Parameters:TArrSingle):double;
 var temp:double;
begin
 temp:=Kb*fX;
 Result:=-temp*ln(Parameters[0]*exp(-FSample.Material.Varshni(Parameters[1],fX)/temp+sqr(Parameters[2])/2/sqr(temp))+
   (1-Parameters[0])*exp(-FSample.Material.Varshni(Parameters[3],fX)/temp+sqr(Parameters[4])/2/sqr(temp)));
end;

Function TDGaus.Weight(OutputData:TArrSingle):double;
begin
 Result:=1;
end;


Constructor TLinEg.Create;
begin
 inherited Create('LinEg','Patch current fitting',
                  3,0,0);
 FXname[0]:='Gam';
 FXname[1]:='C1';
 FXname[2]:='Fb0';
 fTemperatureIsRequired:=False;
 ReadFromIniFile();
end;

Function TLinEg.Func(Parameters:TArrSingle):double;
 var Fb,Vbb:double;
begin
 Fb:=FSample.Material.Varshni(Parameters[2],fX);
 Vbb:=Fb-FSample.Vbi(fX);
 Result:=Fb-Parameters[0]*Power(Vbb/FSample.nu,1.0/3.0)-
        Kb*fX*ln(Parameters[0]*Parameters[1]*4*3.14*Kb*fX/9*Power(FSample.nu/Vbb,2.0/3.0));
end;

Function TLinEg.Weight(OutputData:TArrSingle):double;
begin
 Result:=1;
end;

Constructor TDoubleDiod.Create;
begin
 inherited Create('DoubleDiod','Double diod fitting of solar cell I-V',
                  6,1,0);
 FXname[0]:='n1';
 FXname[1]:='Rs';
 FXname[2]:='Io1';
 FXname[3]:='Rsh';
 FXname[4]:='n2';
 FXname[5]:='Io2';
 fSampleIsRequired:=False;
 ReadFromIniFile();
end;

Function TDoubleDiod.Func(Parameters:TArrSingle):double;
begin
 Result:=Parameters[2]*(exp((fX-fY*Parameters[1])/(Parameters[0]*Kb*FVariab[0]))-1)
       +Parameters[5]*(exp((fX-fY*Parameters[1])/(Parameters[4]*Kb*FVariab[0]))-1)
       +(fX-fY*Parameters[1])/Parameters[3];
end;

Function TDoubleDiod.RealFunc(DeterminedParameters:TArrSingle):double;
begin
 Result:=Full_IV_2Exp(fX,DeterminedParameters[0]*Kb*FVariab[0],DeterminedParameters[4]*Kb*FVariab[0],
    DeterminedParameters[1],DeterminedParameters[2],DeterminedParameters[5],DeterminedParameters[3],0);
end;

Constructor TDoubleDiodLight.Create;
begin
 inherited Create('DoubleDiodLight','Double diod fitting of lightened solar cell I-V',
                  7,1,4);
 FXname[0]:='n1';
 FXname[1]:='Rs';
 FXname[2]:='Io1';
 FXname[3]:='Rsh';
 FXname[4]:='n2';
 FXname[5]:='Io2';
 FXname[6]:='Iph';
 FXname[7]:='Voc';
 FXname[8]:='Isc';
 FXname[9]:='Pm';
 FXname[10]:='FF';
 fYminDontUsed:=True;
 ReadFromIniFile();
end;

Function TDoubleDiodLight.Func(Parameters:TArrSingle):double;
begin
  Result:=Parameters[2]*(exp((fX-fY*Parameters[1])/(Parameters[0]*Kb*FVariab[0]))-1)
        +Parameters[5]*(exp((fX-fY*Parameters[1])/(Parameters[4]*Kb*FVariab[0]))-1)
        +(fX-fY*Parameters[1])/Parameters[3]-Parameters[6];
end;

Function TDoubleDiodLight.RealFunc(DeterminedParameters:TArrSingle):double;
begin
 Result:=Full_IV_2Exp(fX,DeterminedParameters[0]*Kb*FVariab[0],
          DeterminedParameters[4]*Kb*FVariab[0],DeterminedParameters[1],
          DeterminedParameters[2],DeterminedParameters[5],
          DeterminedParameters[3],DeterminedParameters[6]);
end;

Function TDoubleDiodLight.Weight(OutputData:TArrSingle):double;
begin
 Result:=sqr(fY+OutputData[6]);
end;

procedure TDoubleDiodLight.AddParDetermination(InputData:PVector;
                               var OutputData:TArrSingle);
begin
  OutputData[FNx]:=ErResult;
  OutputData[FNx+1]:=ErResult;
  OutputData[FNx+2]:=ErResult;
  OutputData[FNx+3]:=ErResult;
  if (OutputData[6]>1e-7) then
    begin
     OutputData[7]:=Voc_Isc_Pm_DoubleDiod(1,OutputData[0]*Kb*FVariab[0],
                        OutputData[4]*Kb*FVariab[0],OutputData[1],
                        OutputData[2],OutputData[5],OutputData[3],OutputData[6]);
     OutputData[8]:=Voc_Isc_Pm_DoubleDiod(2,OutputData[0]*Kb*FVariab[0],
                        OutputData[4]*Kb*FVariab[0],OutputData[1],
                        OutputData[2],OutputData[5],OutputData[3],OutputData[6]);
    end;
  if (OutputData[FNx]>0.002)and
     (OutputData[FNx+1]>1e-7)and
     (OutputData[FNx]<>ErResult)and
     (OutputData[FNx+1]<>ErResult) then
    begin
     OutputData[9]:=Voc_Isc_Pm_DoubleDiod(3,OutputData[0]*Kb*FVariab[0],
                        OutputData[4]*Kb*FVariab[0],OutputData[1],
                        OutputData[2],OutputData[5],OutputData[3],OutputData[6]);
     OutputData[FNx+3]:=OutputData[FNx+2]/OutputData[FNx]/OutputData[FNx+1];
    end;
end;

Constructor TNGausian.Create(NGaus:byte);
 var i:byte;
begin
 inherited Create('N_Gausian','Sum of '+inttostr(NGaus)+' Gaussian',
                  3*NGaus,0,0);
 for I := 1 to NGaus do
   begin
    FXname[3*i-3]:='A'+inttostr(i);
    FXname[3*i-2]:='X0'+inttostr(i);
    FXname[3*i-1]:='Sig'+inttostr(i);
   end;
 FIsNotReady:=False;
 for I := 0 to High(FXmode) do
   begin
     FXmode[i]:=lin;
     FA[i]:=0;
     FB[i]:=0;
     FC[i]:=0;
     FXt[i]:=0;
     FXvalue[i]:=0;
   end;
 FNit:=1000*(4+NGaus*NGaus);
 FEvType:=TDE;
end;

Function TNGausian.Func(Parameters:TArrSingle):double;
 var i:byte;
begin
 Result:=0;
 for I := 1 to round(FNx/3) do
   Result:=Result+
     Parameters[3*i-3]*exp(-sqr((fX-Parameters[3*i-2]))/2/sqr(Parameters[3*i-1]));
end;

Procedure TNGausian.BeforeFitness(InputData:Pvector);
 var i:byte;
     Xmin,Xmax,delY,delX:double;
begin
 Xmin:=InputData^.X[MinElemNumber(InputData^.X)];
 Xmax:=InputData^.X[MaxElemNumber(InputData^.X)];
 delY:=InputData^.Y[MaxElemNumber(InputData^.Y)]-
       InputData^.Y[MinElemNumber(InputData^.Y)];
 delX:=Xmax-Xmin;
 for I := 1 to round(FNx/3) do
  begin
   FXmin[3*i-3]:=0;
   FXmax[3*i-3]:=delY;
   FXminlim[3*i-3]:=0;
   FXmaxlim[3*i-3]:=delY*10;

   FXmin[3*i-2]:=Xmin;
   FXmax[3*i-2]:=Xmax;
   FXminlim[3*i-2]:=Xmin-5*delX;
   FXmaxlim[3*i-2]:=Xmax+5*delX;

   FXmin[3*i-1]:=delX/10;
   FXmax[3*i-1]:=delX;
   FXminlim[3*i-1]:=delX/1000;
   FXmaxlim[3*i-1]:=10*delX;
  end;
// if High(InputData^.X)>150 then
//   FNit:=500*(1+sqr(round(FNx/3)))
//                    else
//   FNit:=1000*(1+sqr(round(FNx/3)));
end;

Constructor TTunnel.Create;
begin
 inherited Create('Tunnel','Tunneling through rectangular barrier',
                  3,0,0);
 FXname[0]:='Io';
 FXname[1]:='A';
 FXname[2]:='B';
 fTemperatureIsRequired:=False;
 fSampleIsRequired:=False;
 ReadFromIniFile();
end;

Function TTunnel.Func(Parameters:TArrSingle):double;
begin
 Result:=TunFun(fX,Parameters);
end;

Constructor TPower2.Create;
begin
 inherited Create('Power2','Two power function',
                  4,0,0);
 FXname[0]:='A1';
 FXname[1]:='A2';
 FXname[2]:='m1';
 FXname[3]:='m2';
 fTemperatureIsRequired:=False;
 fSampleIsRequired:=False;
 ReadFromIniFile();
end;

Function TPower2.Func(Parameters:TArrSingle):double;
begin
 Result:=Parameters[0]*(Power(fX,Parameters[2])
        +Parameters[1]*Power(fX,Parameters[3]));
end;

Constructor TRevZriz.Create;
begin
 inherited Create('RevZriz','Dependence of reverse current'+
                'at constant bias on inverse temperature. '+
                'First component is TE current, second is SCLC current',
                 4,2,0);
 FXname[0]:='Io1';
 FXname[1]:='E1';
 FXname[2]:='Io2';
 FXname[3]:='E2';
 FVarName[0]:='m';
 FVarName[1]:='b';
 fTemperatureIsRequired:=False;
 fSampleIsRequired:=False;
 FVarManualDefinedOnly[0]:=True;
 FVarManualDefinedOnly[1]:=True;
 ReadFromIniFile();
end;

Function TRevZriz.Func(Parameters:TArrSingle):double;
 var I1,I2:double;
begin
  Result:=ErResult;
  if fX<=0 then Exit;
  I1:=RevZrizFun(fX,FVariab[0],Parameters[2],Parameters[3]);
  I2:=RevZrizFun(fX,2,Parameters[0],Parameters[1]);
  if FVariab[1]>=0 then Result:=I1+I2
                  else Result:=I1*I2/(I1+I2);
end;

Constructor TRevZriz2.Create;
begin
 inherited Create('RevZriz2','Dependence of reverse current'+
                'at constant bias on inverse temperature. '+
                'First component is TE current, second is SCLC current (exponential trap distribution)',
                 4,1,0);
 FXname[0]:='Io1';
 FXname[1]:='E';
 FXname[2]:='Io2';
 FXname[3]:='A';
 FVarName[0]:='m';
 fTemperatureIsRequired:=False;
 fSampleIsRequired:=False;
 FVarManualDefinedOnly[0]:=True;
 ReadFromIniFile();
end;

Function TRevZriz2.Func(Parameters:TArrSingle):double;
begin
  Result:=ErResult;
  if fX<=0 then Exit;
  Result:=RevZrizFun(fX,2,Parameters[0],Parameters[1])+
   RevZrizSCLC(fX,FVariab[0],Parameters[2],Parameters[3]);
end;

Function TRevZriz2.Weight(OutputData:TArrSingle):double;
begin
 Result:=sqr(ln(fY));
end;

Function TRevZriz2.Summand(OutputData:TArrSingle):double;
begin
 Result:=ln(Func(OutputData))-ln(fY);
end;

Constructor TRevZriz3.Create;
begin
 inherited Create('RevZriz3','Dependence of reverse current'+
                'at constant bias on inverse temperature. '+
                'First component is TE current, second is termally-assisted hopping transport',
                 4,2,0);
 FXname[0]:='Io1';
 FXname[1]:='E';
 FXname[2]:='Io2';
 FXname[3]:='Tc';
 FVarName[0]:='m';
 FVarName[1]:='p';
 FVarManualDefinedOnly[0]:=True;
 FVarManualDefinedOnly[1]:=True;
 fTemperatureIsRequired:=False;
 fSampleIsRequired:=False;
 ReadFromIniFile()
end;

Function TRevZriz3.Func(Parameters:TArrSingle):double;
 var T1:double;
begin
 Result:=ErResult;
 if fX<=0 then Exit;
 T1:=Kb*fX;
 Result:=RevZrizFun(fX,2,Parameters[0],Parameters[1])+
   Parameters[2]*exp(-Power((Parameters[3]*T1),FVariab[1]))*Power(T1,-FVariab[0]);
end;


Constructor TBrails.Create(FunctionName:string);
begin
 inherited Create(FunctionName,'Ultrasound atteniation, Brailsford theory. w is a frequancy.',
                 3,1,0);
 FXname[0]:='A';
 FXname[1]:='B';
 FXname[2]:='E';
 FVarManualDefinedOnly[0]:=True;
 fTemperatureIsRequired:=False;
 fSampleIsRequired:=False;
 FPictureName:='BrailsfordFig';
end;

Function TBrails.Weight(OutputData:TArrSingle):double;
begin
 Result:=abs(fY);
end;

Constructor TBrailsford.Create;
begin
 inherited Create('Brailsford');
 FCaption:=FCaption+' Dependence on temperature.';
 FVarName[0]:='w';
 ReadFromIniFile()
end;

Function TBrailsford.Func(Parameters:TArrSingle):double;
begin
 Result:=Brailsford(fX,FVariab[0],Parameters);
end;

Constructor TBrailsfordw.Create;
begin
 inherited Create('Brailsfordw');
 FCaption:=FCaption+' Dependence on frequancy.';
 FVarName[0]:='T';
 ReadFromIniFile();
end;

Function TBrailsfordw.Func(Parameters:TArrSingle):double;
begin
 Result:=Brailsford(FVariab[0],fX,Parameters);
end;

//-----------------------------------------------------------------------
Constructor TFitFunctEvolutionEm.Create(FunctionName,FunctionCaption:string;
                     Npar,Nvar:byte);
begin
 inherited Create(FunctionName,FunctionCaption,Npar,Nvar,0);
 if Nvar>1 then
  begin
   FVarName[1]:='Fb0';
   FVarManualDefinedOnly[1]:=True;
  end;
end;


Procedure TFitFunctEvolutionEm.BeforeFitness(InputData:Pvector);
begin
 inherited BeforeFitness(InputData);
 F2:=2/FSample.nu;
 F1:=FSample.Material.Varshni(FVariab[1],FVariab[0])-FSample.Vbi(FVariab[0]);
 fkT:=Kb*FVariab[0];
end;

Procedure TFitFunctEvolutionEm.FIsNotReadyDetermination;
begin
 inherited FIsNotReadyDetermination;
 if FIsNotReady then  Exit;
 if (FSample.Nd=ErResult)or
    (FSample.Material.VarshA=ErResult)or
    (FSample.Material.VarshB=ErResult)
                   then FIsNotReady:=True;
end;

Function TFitFunctEvolutionEm.Weight(OutputData:TArrSingle):double;
begin
 Result:=abs(fY);
end;

Function TFitFunctEvolutionEm.TECurrent(V,T,Seff,A:double):double;
 var kT:double;
begin
  kT:=Kb*T;
  Result:=Seff*FSample.I0(T,FVariab[1])*exp(A*FSample.Em(T,FVariab[1],V)/kT)*(1-exp(-V/kT));
end;


Constructor TRevZriz2ΤΕ.Create;
begin
 inherited Create('RevZriz2TE','Dependence of reverse current'+
                'at constant bias on inverse temperature. '+
                'First component is TE current, second is SCLC current (exponential trap distribution)',
                 4,3);
 FXname[0]:='Seff';
 FXname[1]:='Al';
 FXname[2]:='Io2';
 FXname[3]:='A';
 FVarName[2]:='m';
 FVarName[0]:='V';
 fTemperatureIsRequired:=False;
 FVarManualDefinedOnly[0]:=True;
 FVarManualDefinedOnly[2]:=True;
 fHasPicture:=false;
 ReadFromIniFile();
end;

Function TRevZriz2ΤΕ.Func(Parameters:TArrSingle):double;
begin
  Result:=ErResult;
  if fX<=0 then Exit;
  Result:=TECurrent(FVariab[0],1/fx/Kb,Parameters[0],Parameters[1])+
    RevZrizSCLC(fX,FVariab[2],Parameters[2],Parameters[3]);
end;

Function TRevZriz2ΤΕ.Weight(OutputData:TArrSingle):double;
begin
 Result:=sqr(ln(fY));
end;

Function TRevZriz2ΤΕ.Summand(OutputData:TArrSingle):double;
begin
 Result:=ln(Func(OutputData))-ln(fY);
end;


Constructor TRevSh.Create;
begin
 inherited Create('RevSh','Dependence of reverse TE current on bias',
                  5,2);
 FXname[0]:='Io1';
 FXname[1]:='A1';
 FXname[2]:='B1';
 FXname[3]:='Io2';
 FXname[4]:='A2';
 ReadFromIniFile();
end;

Function TRevSh.Func(Parameters:TArrSingle):double;
 var Em:double;
begin
 Em:=sqrt(F2*(F1+fX));
 Result:=(Parameters[0]*exp((Parameters[1]*Em+Parameters[2]*sqrt(Em))/fkT)+
        Parameters[3]*exp(Parameters[4]*Em/fkT))*(1-exp(-fX/fkT));
end;

Function TRevSh.Weight(OutputData:TArrSingle):double;
begin
 if FXmode[2]<>cons then Result:=sqr(fY)
                    else Result:=inherited Weight(OutputData);
end;

Constructor TRevShSCLC.Create;
begin
 inherited Create('RevShSCLC','Dependence of reverse current on bias. First component is SCLC current, second is TE current',
                  4,2);
 FXname[0]:='Io1';
 FXname[1]:='p';
 FXname[2]:='A';
 FXname[3]:='Io2';
 ReadFromIniFile();
end;

Function TRevShSCLC.Func(Parameters:TArrSingle):double;
begin
 Result:=Parameters[0]*Power(fX,Parameters[1])+
   Parameters[3]*exp(Parameters[2]*sqrt(F2*(F1+fX))/fkT)*(1-exp(-fX/fkT));
end;

Constructor TRevShSCLC3.Create;
begin
 inherited Create('RevShSCLC3','Dependence of reverse current on bias. First component is SCLC current, second is TE current',
                  6,2);
 FXname[0]:='Io1';
 FXname[1]:='p1';
 FXname[2]:='Io2';
 FXname[3]:='p2';
 FXname[4]:='Io3';
 FXname[5]:='A';
 ReadFromIniFile();
end;

Function TRevShSCLC3.Func(Parameters:TArrSingle):double;
begin
 Result:=Parameters[0]*Power(fX,Parameters[1])+Parameters[2]*Power(fX,Parameters[3])+
   Parameters[4]*exp(Parameters[5]*sqrt(F2*(F1+fX))/fkT)*(1-exp(-fX/fKT));
end;

Constructor TRevShSCLC2.Create;
begin
 inherited Create('RevShSCLC2','Dependence of reverse current on bias. First component is SCLC current, second is TE current',
                  3,5);
 FXname[0]:='Io1';
 FXname[1]:='Io2';
 FXname[2]:='A';
 FVarName[2]:='To1';
 FVarManualDefinedOnly[2]:=True;
 FVarName[3]:='To2';
 FVarManualDefinedOnly[3]:=True;
 FVarName[4]:='b';
 FVarManualDefinedOnly[4]:=True;
 ReadFromIniFile();
end;

Function TRevShSCLC2.Func(Parameters:TArrSingle):double;
begin
 Result:=Parameters[0]*(Power(fX,Fm1)+FVariab[4]*Power(fX,Fm2))+
    Parameters[1]*exp(Parameters[2]*sqrt(F2*(F1+fX))/fkT)*(1-exp(-fX/fkT));
end;

Procedure TRevShSCLC2.BeforeFitness(InputData:Pvector);
begin
 inherited BeforeFitness(InputData);
 Fm1:=1+FVariab[2]/FVariab[0];
 Fm2:=1+FVariab[3]/FVariab[0];
end;

Constructor TPhonAsTun.Create(FunctionName,FunctionCaption:string;
                     Npar:byte);
begin
 inherited Create(FunctionName,FunctionCaption,Npar,4);
 if Npar>1 then
  begin
   FXname[0]:='Nss';
   FXname[1]:='Et';
  end;
 FVarName[2]:='a';
 FVarName[3]:='hw';
 FVarManualDefinedOnly[2]:=True;
 FVarManualDefinedOnly[3]:=True;
 fmeff:=m0*FSample.Material.Meff;
end;


Function TPhonAsTun.Weight(OutputData:TArrSingle):double;
begin
 Result:=sqr(fY);
end;

Function TPhonAsTun.PhonAsTun(V,kT1:double;Parameters:TArrSingle):double;
var g,gam,gam1,qE,Et:double;
begin
  Result:=ErResult;
  if kT1<=0 then Exit;
  qE:=Qelem*FSample.Em(1/(kT1*Kb),FVariab[1],V);
  Et:=Parameters[1]*Qelem;
  g:=FVariab[2]*sqr(FVariab[3]*Qelem)*(1+2/(exp(FVariab[3]*kT1)-1));
  gam:=sqrt(2*fmeff)*g/(Hpl*qE*sqrt(Et));
  gam1:=sqrt(1+sqr(gam));
  Result:=FSample.Area*Parameters[0]*qE/sqrt(8*fmeff*Parameters[1])*sqrt(1-gam/gam1)*
          exp(-4*sqrt(2*fmeff)*Et*sqrt(Et)/(3*Hpl*qE)*
              sqr(gam1-gam)*(gam1+0.5*gam));
end;

Constructor TPhonAsTunOnly.Create(FunctionName:string);
begin
 inherited Create(FunctionName,'Dependence of reverse photon-assisted tunneling current at constant bias on ',
                  2);
 FPictureName:='PhonAsTunFig';
end;

Constructor TPhonAsTun_kT1.Create;
begin
 inherited Create('PhonAsTun');
 FCaption:=FCaption+'inverse temperature';
 fTemperatureIsRequired:=False;
 FVarName[0]:='V_volt';
 FVarManualDefinedOnly[0]:=True;
 ReadFromIniFile();
end;

Function TPhonAsTun_kT1.Func(Parameters:TArrSingle):double;
begin
  Result:=PhonAsTun(FVariab[0],fX,Parameters);
end;

Constructor TPhonAsTun_V.Create;
begin
 inherited Create('PhonAsTunV');
 FCaption:=FCaption+'reverse voltage';
 ReadFromIniFile();
end;

Function TPhonAsTun_V.Func(Parameters:TArrSingle):double;
begin
  Result:=PhonAsTun(fX,1/fkT,Parameters);
end;

Constructor TPhonAsTunAndTE.Create(FunctionName:string);
begin
 inherited Create(FunctionName,'Dependence of reverse thermionic emission current and photon-assisted tunneling current at constant bias on ',
                  4);
 FXname[2]:='Seff';
 FXname[3]:='A';
 fHasPicture:=false;
end;

Constructor TPhonAsTunAndTE_kT1.Create;
begin
 inherited Create('PhonAsTunTEkT1');
 FCaption:=FCaption+'inverse temperature';
 fTemperatureIsRequired:=False;
 FVarName[0]:='V_volt';
 FVarManualDefinedOnly[0]:=True;
 ReadFromIniFile();
end;

Function TPhonAsTunAndTE_kT1.Func(Parameters:TArrSingle):double;
begin
  Result:=PhonAsTun(FVariab[0],fX,Parameters)+TECurrent(FVariab[0],1/fx/Kb,Parameters[2],Parameters[3]);
end;

Constructor TPhonAsTunAndTE_V.Create;
begin
 inherited Create('PhonAsTunTEV');
 FCaption:=FCaption+'reverse voltage';
 ReadFromIniFile();
end;

Function TPhonAsTunAndTE_V.Func(Parameters:TArrSingle):double;
begin
  Result:=PhonAsTun(fX,1/fkT,Parameters)+TECurrent(fX,FVariab[0],Parameters[2],Parameters[3]);
end;

//-----------------------------------------------------------------------------------

procedure PictLoadScale(Img: TImage; ResName:String);
{в Img завантажується bmp-картинка з ресурсу з назвою
ResName і масштабується зображення, щоб не вийшо
за межі розмірів Img, які були перед цим}
var
  scaleY: double;
  scaleX: double;
  scale: double;
begin
  Img.Picture.Bitmap.LoadFromResourceName(hInstance,ResName);
  if Img.Picture.Width > Img.Width then
    scaleX := Img.Width / Img.Picture.Width
  else
    scaleX := 1;
  if Img.Picture.Height > Img.Height then
    scaleY := Img.Height / Img.Picture.Height
  else
    scaleY := 1;
  if scaleX < scaleY then
    scale := scaleX
  else
    scale := scaleY;
  Img.Height := Round(Img.Picture.Height * scale);
  Img.Width := Round(Img.Picture.Width * scale);
end;


Procedure FunCreate(str:string; var F:TFitFunction);
begin
  if str='Linear' then F:=TLinear.Create;
  if str='Quadratic' then F:=TQuadratic.Create;
  if (str='Smoothing')or(str='Derivative')
        then F:=TFitWithoutParameteres.Create(str);
  if str='Median filtr' then F:=TFitWithoutParameteres.Create('Median');
  if str='Exponent' then F:=TExponent.Create;
  if str='Gromov / Lee' then F:=TGromov.Create;
  if str='Ivanov' then F:=TIvanov.Create;
  if str='Diod' then F:=TDiod.Create;
  if str='PhotoDiod' then F:=TPhotoDiod.Create;
  if str='Diod, LSM' then F:=TDiodLSM.Create;
  if str='PhotoDiod, LSM' then F:=TPhotoDiodLSM.Create;
  if str='Diod, Lambert' then F:=TDiodLam.Create;
  if str='PhotoDiod, Lambert' then F:=TPhotoDiodLam.Create;
  if str='Two Diod' then F:=TDiodTwo.Create;
  if str='Two Diod Full' then F:=TDiodTwoFull.Create;
  if str='D-Gaussian' then F:=TDGaus.Create;
  if str='Patch Barrier' then F:=TLinEg.Create;
  if str='D-Diod' then F:=TDoubleDiod.Create;
  if str='Photo D-Diod' then F:=TDoubleDiodLight.Create;
  if str='Ir on 1/T (I)' then F:=TRevZriz.Create;
  if str='Ir on 1/T (II)' then F:=TRevZriz2.Create;
  if str='Ir on 1/T (III)' then F:=TRevZriz3.Create;
  if str='TE and SCLC' then F:=TRevShSCLC.Create;
  if str='TE and SCLC (II)' then F:=TRevShSCLC2.Create;
  if str='TE and SCLC (III)' then F:=TRevShSCLC3.Create;
  if str='Tunneling' then F:=TTunnel.Create;
  if str='Two power' then F:=TPower2.Create;
  if str='TE reverse' then F:=TRevSh.Create;
  if str='Brailsford on T' then F:=TBrailsford.Create;
  if str='Brailsford on w' then F:=TBrailsfordw.Create;
  if str='Phonon Tunneling on 1/kT' then F:=TPhonAsTun_kT1.Create;
  if str='Phonon Tunneling on V' then F:=TPhonAsTun_V.Create;
  if str='TE and Phonon Tunn. on 1/kT' then F:=TPhonAsTunAndTE_kT1.Create;
  if str='TE and Phonon Tunn. on V' then F:=TPhonAsTunAndTE_V.Create;
  if str='Ir on 1/T (IIa)' then F:=TRevZriz2ΤΕ.Create;
//  if str='None' then F:=TDiod.Create;
end;


Function  FitName(V: PVector; st:string='fit'):string;
begin
  if V^.name = '' then
    Result := st+'.dat'
  else
  begin
    Result := V^.name;
    Insert(st, Result, Pos('.', Result));
  end;
end;

end.
