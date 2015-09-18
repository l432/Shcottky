unit OlegApprox;

interface

uses OlegType,Dialogs,SysUtils,Math,Forms,FrApprPar,Windows,
      Messages,Controls,FrameButtons,IniFiles,ExtCtrls,Graphics,
      OlegMath,ApprWindows,StdCtrls,FrParam,Series,Classes,OlegGraph;

const
  FuncName:array[0..31]of string=
           ('None','Linear','Quadratic','Exponent','Smoothing',
           'Median filtr','Derivative','Gromov / Lee','Ivanov',
           'Diod','PhotoDiod','Diod, LSM','PhotoDiod, LSM',
           'Diod, Lambert','PhotoDiod, Lambert','Two Diod',
           'Two Diod Full','D-Gaussian','Patch Barrier',
           'D-Diod', 'Photo D-Diod','Tunneling','Two power','TE and SCLC',
           'TE and SCLC (II)','TE and SCLC (III)','TE reverse',
           'Ir on 1/T (I)','Ir on 1/T (II)','Ir on 1/T (III)',
           'Brailsford','Phohon Tunneling');
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
 private
 FNs:integer;//кількість змінних
 FNit:integer;//кількість ітерацій
 FXmin:TArrSingle;
 //мінімальні значення змінних при ініціалізації
 FXmax:TArrSingle;
 //максимальні значення змінних при ініціалізації
 FXminlim:TArrSingle;
//мінімальні значення змінних при еволюційному пошуку
  FXmaxlim:TArrSingle;
//максимальні значення змінних при еволюційному пошуку
 FXmode:TArrVar_Rand;
 //тип змінних
 {якщо тип змінної cons, то вона розраховується
 за формулою X=A+Bt+Ct^2,
 де А, В та С - константи, які
 зберігаються в масивах FA, FB та FC,
 t - може бути будь-яка додаткова величина,
 або величина, обернена до неї}
 FA,FB,FC:TArrSingle;
 FXt:array of integer;
 {містить числа, пов'язані з параметрами,
 які використовуються для розрахунку змінної:
 0 - без параметрів, тобто змінна = А
 2..(FPNs-1) - FParam[FXt[i]]
 (FPNs+2)..(2FPNs-1) - FParam[FXt[i]-FPNs]^(-1)}
 FXvalue:TArrSingle;
{значення змінних, якщо вони
 мають тип cons;
 фактично це поле дише для того,
 щоб не рахувати за формулою X=A+Bt+Ct^2
 кожного разу, а лише на початку апроксимації}
 FXname:TArrStr; // імена змінних
 FName:string;//ім'я функції
 FPEst:byte;
 //показник степеня дільника у цільовій функції
 FIsReady:boolean;
{показує, чи всі дані присутні і, отже, функція готова
 для використання}
 FParam:TArrSingle;
 {величини, які також потрібні для розрахунку
 функції, завжди
 FParam[0] - це змінна Х,
 FParam[1] - це змінна Y,
 решта залежать від функції}
 FPname:array of string;
 //імена додаткових величин
 FPNs:byte;
 //кількість додаткових величин
 FPbool:array of boolean;
 {якщо True, то значення відповідного
 параметру стале, відповідає
 введеному значенню, а не
 визначається програмно - наприклад,
 температура береться не з парметрів Pvector}
 FPValue:TArrSingle;
 {значення параметрів}
 FEvType:TEvolutionType;
 {еволюційний метод,
 який використовується для апроксимації}
 FCaption:string;
 {містить опис функції}
 FDodX:TArrSingle;
 {додаткові параметри, які
 можна розрахувати на основі апроксимації;
 наприклад, для ВАХ діода при
 освітленні це будуть
 Voc, Isc, FF та Pm}
 FDodXname:TArrStr;
 {імена додаткових параметрів}
  Labels:array of TLabel;
 {мітки, які показуються на вікні під
 час апроксимації}
 FDbool:boolean;
 {змінна, яка показує як треба
 застосовувати обмеження, вказані в
 діапазонній змінній,
 при True, то обмеження
на Ymin не використовуеться - потрібно
для аналізу ВАХ освітлених елементів,
за умовчанням False}
 //---------------------------
 { поля, для збереження параметрів матеріалу та зразка}
 FSzr:double;//площа зразка
 FArich:double;//стала Річардсона
 procedure SetNit(value:integer);
 Function EvFitPreparation(V:PVector;var Param:TArrSingle;
                          str:string; var Nit:integer):boolean;
{виконується на початку еволюційної апроксимації,
перевіряється готовність функції,
встановлюється параметри вікна,
зануляється кількість ітерацій;
якщо все добре - повертається False
}
Procedure  EvFitInit(V:PVector;var X:TArrArrSingle; var Fit:TArrSingle);
{початкове встановлення випадкових
значень в Х та розрахунок початкових
величин цільової функції}
Procedure EvFitShow(X:TArrArrSingle;Fit:TArrSingle; Nit,Nshow:integer);
{проводить зміну значень на вікні
під час еволюційної апроксимації,
якщо Nit кратна Nshow}
Procedure EvFitEnding(Fit:TArrSingle; X:TArrArrSingle; var Param:TArrSingle);
{виконується наприкінці еволюційної апроксимації,
очищається вікно,
записуються отримані результати в Param}
procedure FitName(var st: string; V: PVector);
{у змінну st вноситься змінене значення
V^.name, зміна полягає у дописуванні
'fit'перед першою крапкою}
procedure DodParDetermination(V: PVector;Variab:TArrSingle); virtual;
{розраховуються додаткові параметри}

procedure BeforeFitness(AP:Pvector);virtual;
 {виконується перед початком апроксимації,
 полягає у заповненні полів потрібними
 значеннями}
Procedure AproxN (V:PVector; var Param:TArrSingle);virtual;
{просто заглушка для функції, яка використовується
в класах-спадкоємцях;
потрібно, щоб можна було викликати для
змінних базового типу}
 Function Func(Variab:TArrSingle):double; virtual;abstract;
  {апроксимуюча функція... точніше та, яка використовується
  при побудові цільової функції; вона не завжди
  співпадає з апроксимуючою - наприклад для Diod
  не співпадає задля економії часу}
 Function FitnessFunc(AP:Pvector; Variab:TArrSingle):double;virtual;
 {функція для оцінки апроксимації залежності  AP
  даною функцією, найчастіше - квадратична форма}

 Constructor Create(N:integer);

 Procedure ReadValue;virtual;
 {зчитує дані для  FXmin, FXmax, FXminlim,  FXmaxlim, FXmode
 та FNit з ini-файла}
 Procedure WriteValue;virtual;
 {записує дані для  FXmin, FXmax, FXminlim,  FXmaxlim, FXmode
 та FNit в ini-файл}
 Procedure VarRand(var X:TArrSingle);
 {випадковим чином задає значення змінних
 масиву  Х в діапазоні від FXmin до FXmax}
 Procedure PenaltyFun(var X:TArrSingle);
 {контролює можливі значення параметрів у масиві X,
 що підбираються при апроксимації еволюційними методами,
 заважаючи їм прийняти нереальні значення -
 тобто за межами FXminlim та FXmaxlim}
 Procedure WindowPrepare();
 {підготовка вікна до показу даних}
 Procedure WindowClear();
 {очищення вікна після апроксимації}
 Procedure WindowDataShow(N:integer;X:TArrSingle);
 {показ номера біжучої ітерації
  та даних, які знаходяться в Х}

Procedure MABCFit (V:PVector; var Param:TArrSingle);
{апроксимуються дані у векторі V за методом modified artificial bee colony;
F визначає апроксимуючу функцію,
результати апроксимації вносяться в Param}

Procedure PSOFit (V:PVector; var Param:TArrSingle);
{апроксимуються дані у векторі V за методом
particle swarm optimization;
F визначає апроксимуючу функцію,
результати апроксимації вносяться в Param}

Procedure DEFit (V:PVector;  var Param:TArrSingle);
{апроксимуються дані у векторі V за методом
differential evolution;
Fu визначає апроксимуючу функцію,
результати апроксимації вносяться в Param}

Procedure TLBOFit (V:PVector; {F:TFitFunction;} var Param:TArrSingle);
{апроксимуються дані у векторі V за методом
teaching learning based optimization;
F визначає апроксимуючу функцію,
результати апроксимації вносяться в Param}
//----------------------------------------------
 public

 property Ns:integer read FNs;
 property Nit:integer read FNit write SetNit;
 property Xname:TArrStr read FXname;
 property Name:string read FName;
 property IsReady:boolean read FIsReady;
 property Xmode:TArrVar_Rand read FXmode;
// property Xmin:TArrSingle read FXmin write FXmin;
// property Xmax:TArrSingle read FXmax write FXmax;
// property Xminlim:TArrSingle read FXminlim write FXminlim;
 property Xvalue:TArrSingle read FXvalue;
 property EvType:TEvolutionType read FEvType;
 property DodXname:TArrStr read FDodXname;
 property DodX:TArrSingle read FDodX;
 property Caption:string read FCaption;
 Procedure SetValue(num,index:byte;value:double); overload;
 {встановлюються значення num-го елементу поля
 FXmin при index=1
 FXmax при index=2
 FXminlim при index=3
 FXmaxlim при index=4
 }
 Procedure SetValue(name:string;index:byte;value:double); overload;
{встановлюються значення елементу поля
 FXmin при index=1
 FXmax при index=2
 FXminlim при index=3
 FXmaxlim при index=4
 для якого елемент FXname співпадає з name}

 Procedure SetValueMode(num:byte;value:TVar_Rand); overload;
 {встановлюються значення num-го елементу поля
 FXmode }
 Procedure SetValueMode(name:string;value:TVar_Rand); overload;
 {встановлюються значення елементу поля
 FXmode для якого елемент FXname співпадає з name}
 Procedure SetValueGR;virtual;

 Function FinalFunc(X:double;Variab:TArrSingle):double; overload; virtual;
 {обчислюються значення апроксимуючої функції в
 точці з абсцисою Х, найчастіше значення співпадає
 з тим, що повертає Func при Fparam[0]=X}

Procedure Fitting (V:PVector; var Param:TArrSingle); overload; virtual;
{апроксимуються дані у векторі V, отримані параметри
розміщуються в Param;
при невдалому процесі -  показується повідомлення,
в Param[0] - 555;
загалом розмір Param  після процедури співпадає з кількістю
параметрів;
для базового типу - викликається один з типів
еволюційної апроксимації залежно від значення FEvType}
Procedure Fitting (Xlog,Ylog:boolean; V:PVector; var Param:TArrSingle); overload; virtual;
{дає можливість апроксимувати дані у векторі V,
розглануті у логарифмічному масштабі
Xlog = True - використовується логарифм абсцис,
Ylog = True - використовується логарифм ординат}
Procedure FittingGraph (V:PVector; var Par:TArrSingle;Series: TLineSeries); overload; virtual;
{апроксимація і дані вносяться в Series -
щоб можна було побудувати графік}

Procedure FittingGraph (Xlog,Ylog:boolean; V:PVector; var Param:TArrSingle;Series: TLineSeries); overload; virtual;
{див Fitting та FittingGraph}

Procedure FittingGraphFile (V:PVector; var Param:TArrSingle;Series: TLineSeries); overload; virtual;
{апроксимація, дані вносяться в Series, крім
того апроксимуюча крива заноситься в файл -
третім стопчиком як правило;
назва файлу -- V^.name + 'fit'}

Procedure FittingGraphFile (Xlog,Ylog:boolean; V:PVector; var Param:TArrSingle;Series: TLineSeries); overload; virtual;
{апроксимація, дані вносяться в Series, крім
того апроксимуюча крива заноситься в файл -
третім стопчиком як правило;
назва файлу -- V^.name + 'fit'}

Procedure FittingDiapazon (V:PVector; var Param:TArrSingle; D:Diapazon); virtual;
{апроксимуються дані у векторі V відповідно до обмежень
в D, отримані параметри розміщуються в Param}

Function Deviation (V:PVector):double;
{повертає середнеє значення відхилення апроксимації
даних V від самих даних}
//Procedure Fitting (V:PVector; var Param:TArrSingle);

 end;   // TFitFunction=class


TLinear=class (TFitFunction)
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure Fitting (V:PVector; var Param:TArrSingle); override;
 end; // TLinear=class (TFitFunction)

TQuadratic=class (TFitFunction)
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure Fitting (V:PVector; var Param:TArrSingle); override;
 end; // TLinear=class (TQuadratic)

TExponent=class (TFitFunction)
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure Fitting (V:PVector; var Par:TArrSingle); override;
 Procedure BeforeFitness(AP:Pvector);override;
 end; // TDiod=class (TFitFunction)

TSmoothing=class (TFitFunction)
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure FittingGraph(V:PVector; var Param:TArrSingle;Series: TLineSeries); {reintroduce; overload;}override;
 Procedure FittingGraphFile (V:PVector; var Param:TArrSingle;Series: TLineSeries); {reintroduce; overload;}override;
 end; // TDiod=class (TFitFunction)

TMedian=class (TFitFunction)
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure FittingGraph(V:PVector; var Param:TArrSingle;Series: TLineSeries); {reintroduce; overload;}override;
 Procedure FittingGraphFile (V:PVector; var Param:TArrSingle;Series: TLineSeries); {reintroduce; overload;}override;
 end; // TDiod=class (TFitFunction)

TDerivative=class (TFitFunction)
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure FittingGraph(V:PVector; var Param:TArrSingle;Series: TLineSeries); {reintroduce; overload;}override;
 Procedure FittingGraphFile (V:PVector; var Param:TArrSingle;Series: TLineSeries); {reintroduce; overload;}override;
 end; // TDiod=class (TFitFunction)

TGromov=class (TFitFunction)
 private
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure Fitting (V:PVector; var Param:TArrSingle); override;
 end; // TGromov=class (TFitFunction)

TIvanov=class (TFitFunction)
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Function FinalFunc(var X:double;Variab:TArrSingle):double; reintroduce; overload;
 Procedure BeforeFitness(AP:Pvector);override;
 Procedure Fitting (V:PVector; var Par:TArrSingle); override;
 Procedure FittingGraph(V:PVector; var Par:TArrSingle;Series: TLineSeries); override;
 end; // TIvanov=class (TFitFunction)


TNGausian=class (TFitFunction)
 public
 Constructor Create(NGaus:byte);
 Function Func(Variab:TArrSingle):double; override;
// Function FinalFunc(X:double;Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
// Procedure DodParDetermination(V: PVector; Variab:TArrSingle); override;
 end; // TNGausian=class (TFitFunction)

TDiod=class (TFitFunction)
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Function FinalFunc(X:double;Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 Procedure DodParDetermination(V: PVector; Variab:TArrSingle); override;
 end; // TDiod=class (TFitFunction)


TPhotoDiod=class (TFitFunction)
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Function FinalFunc(X:double;Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 Procedure DodParDetermination(V: PVector; Variab:TArrSingle); override;
 end; //  TPhotoDiod=class (TFitFunction)

TDiodTwo=class (TFitFunction)
{I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp(V/n2kT)-1]}
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 end; // TDiodTwo=class (TFitFunction)

TDiodTwoFull=class (TFitFunction)
{I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp((V-IRs2)/n2kT)-1]}
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 end; //TDiodTwoFull=class (TFitFunction)

TDGaus=class (TFitFunction)
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 end; //TDGaus=class (TFitFunction)

TLinEg=class (TFitFunction)
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 end; //TLinEg=class (TFitFunction)

TDoubleDiod=class (TFitFunction)
{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]+(V-IRs)/Rsh}
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 Function FinalFunc(X:double;Variab:TArrSingle):double; override;
 end; // TDoubleDiodo=class (TFitFunction)

TDoubleDiodLight=class (TFitFunction)
{I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]
         +(V-IRs)/Rsh-Iph}
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 Function FinalFunc(X:double;Variab:TArrSingle):double; override;
 Procedure DodParDetermination(V: PVector; Variab:TArrSingle); override;
 Function FitnessFunc(AP:Pvector; Variab:TArrSingle):double;override;
 end; // TDoubleDiodLight=class (TFitFunction)

TTunnel=class (TFitFunction)
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 end; //TTunnel=class (TFitFunction)

TPower2=class (TFitFunction)
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 end; //TPower2=class (TFitFunction)

TRevZriz=class (TFitFunction)
{I01*T^2*exp(-E1/kT)+I02*T^m*exp(-E2/kT)
m- константа
   I02*(x*k)^m*exp(-E2*x)+I01/(x*k)^2*exp(-E1*x)
АР - виміряні точки;
Variab - значення параметрів, очікується, що
Variab[0] - I10;
Variab[1] - E1;
Variab[2] - I20;
Variab[3] - E2;
}
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 end; // TRevZriz=class (TFitFunction)

TRevZriz2=class (TFitFunction)
{ I01*T^2*exp(-E/kT)+I02*T^(m)*A^(-300/T)
залежності від x=1/(kT)
  I01*(x*k)^Tpow*B^(Tc*x*k)+I02/(x*k)^2*exp(-E*x)}
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 Function FitnessFunc(AP: PVector; Variab: TArrSingle):double;override;
 end; // TRevZriz2=class (TFitFunction)

TRevZriz3=class (TFitFunction)
{I01*T^2*exp(-E/kT)+I02*T^(m)*exp(-(Tc/T)^p)}
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 end; // TRevZriz3=class (TFitFunction)

TPhonAsTun=class (TFitFunction)
{Розраховується залежність струму, пов'язаного
з phonon-assisted tunneling як функції температури,
тобто при сталому значенні напругии,
величина поля підбирається як параметр}
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 end; // TRevZriz3=class (TFitFunction)

TBrailsford=class (TFitFunction)
{A*w/T*(B*w*exp(E/kT))/(1+(B*w*exp(E/kT)^2) }
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 end; // TRevZriz3=class (TFitFunction)


TFitFunctionEm=class (TFitFunction)
{для функцій, де обчислюється
максимальне поле на інтерфейсі}
 private
 F1:double; //містить Fb(T)-Vn
 F2:double; // містить  2qNd/(eps_0 eps_s)
 FNd:double;  //концентрація носіїв
 Fep:double;  //діелектрична стала н/п
 public
 Constructor Create (N:integer);
 Procedure BeforeFitness(AP:Pvector);override;
 end; // TFitFunctionEm=class (TFitFunction)


TRevShSCLC=class (TFitFunctionEm)
{I01*V^m+I02*exp(A*Em/kT)(1-exp(-eV/kT))}
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 end; // TRevShSCLC=class (TFitFunction)


TRevShSCLC2=class (TFitFunctionEm)
{I01*(V^m1+b*V^m2)+I02*exp(A*Em/kT)*(1-exp(-eV/kT))
m1=1+T01/T;
m2=1+T02/T;
АР - виміряні точки;
Em - максимальне поле
Variab[0] - I01;
Variab[1] - I02;
Variab[2] - A;
}
 private
 Fm1:double;
 Fm2:double;
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 end; // TRevShSCLC2=class (TFitFunction)

TRevShSCLC3=class (TFitFunctionEm)
{I01*V^m1+I02*V^m2+I03*exp(A*Em/kT)*(1-exp(-eV/kT))
АР - виміряні точки;
Em - максимальне поле}
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 end; // TRevShSCLC3=class (TFitFunction)

TRevSh=class (TFitFunctionEm)
{I=I01*exp(A1*Em+B*Em^0.5)*(1-exp(-x/kT))+
   I02*exp(A2*Em+B*Em^0.5)*(1-exp(-x/kT))
}
 public
 Constructor Create;
 Function Func(Variab:TArrSingle):double; override;
 Procedure BeforeFitness(AP:Pvector);override;
 end; // TRevSh=class (TFitFunctionEm)

TFitFunctionLSM=class (TFitFunction)
{для функцій, де апроксимація відбувається
не за допомогою еволюційних методів}
 public
 Procedure ReadValue;  override;
 Procedure WriteValue;  override;
 Procedure AproxN (V:PVector; var Param:TArrSingle);override;
 Function Func(Variab:TArrSingle):double; override;
 Procedure SetValueGR;override;
 procedure BeforeFitness(AP:Pvector); override;
 Procedure Fitting (V:PVector; var Param:TArrSingle); override;
 end; // TFitFunctionLSM=class (TFitFunction)

TDiodLSM=class (TFitFunctionLSM)
 public
 Constructor Create;
 Function FinalFunc(X:double;Variab:TArrSingle):double; override;
 Procedure DodParDetermination(V: PVector; Variab:TArrSingle); override;
 end; // TDiodLSM=class (TFitFunction)

TPhotoDiodLSM=class (TFitFunctionLSM)
 public
 Constructor Create;
 Function FinalFunc(X:double;Variab:TArrSingle):double; override;
 Procedure DodParDetermination(V: PVector; Variab:TArrSingle); override;
 end; //  TPhotoDiodLSM=class (TFitFunctionLSM)

TDiodLam=class (TFitFunctionLSM)
 public
 Constructor Create;
 Function FinalFunc(X:double;Variab:TArrSingle):double; override;
 Procedure DodParDetermination(V: PVector; Variab:TArrSingle); override;
 end; // TDiodLSM=class (TFitFunction)

TPhotoDiodLam=class (TFitFunctionLSM)
 public
 Constructor Create;
 Function FinalFunc(X:double;Variab:TArrSingle):double; override;
 Procedure DodParDetermination(V: PVector; Variab:TArrSingle); override;
 end; //  TPhotoDiodLSM=class (TFitFunctionLSM)


procedure PictLoadScale(Img: TImage; ResName:String);
{в Img завантажується bmp-картинка з ресурсу з назвою
ResName і масштабується зображення, щоб не вийшо
за межі розмірів Img, які були перед цим}


//Procedure dB_dV_Fun(A:Pvector; var B:Pvector; fun:byte; Isc0:double;
//              Iscbool,Rbool:boolean;D:Diapazon; Mode:byte;
//              Light:boolean;Func:byte);
//{по даним у векторі А будує залежність похідної
//диференційного нахилу ВАХ від напруги (метод Булярського)
//fun - кількість зглажувань
//Isc - струм короткого замикання
//Iscbool=true - потрібно враховувати Isc
//Rbool=true - потрібно враховувати послідовний
//та шунтуючі опори
//D, Mode, Light та Func потрібні лише для
//виклику функції ExpKalkNew}

Procedure FunCreate(str:string; var F:TFitFunction);
{створює F того чи іншого типу залежно
від значення str}

implementation
uses Unit1;

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
     else WriteInteger(Section, Ident,3);
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

Constructor TFitFunction.Create(N:integer);
begin
 inherited Create;
 FNs:=N;
 SetLength(FXmin,FNs);
 SetLength(FXmax,FNs);
 SetLength(FXminlim,FNs);
 SetLength(FXmaxlim,FNs);
 SetLength(FXmode,FNs);
 SetLength(FXname,FNs);
 SetLength(FA,FNs);
 SetLength(FB,FNs);
 SetLength(FC,FNs);
 SetLength(FXvalue,FNs);
 SetLength(FXt,FNs);
 FIsReady:=False;
 FPNs:=2;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='X';
 FPName[1]:='Y';
 FPEst:=2;
 FDbool:=False;
 DecimalSeparator:='.';
end;


procedure TFitFunction.BeforeFitness(AP:Pvector);
 {виконується перед початком апроксимації,
 полягає у заповненні полів потрібними
 значеннями}
var i:integer;
begin
for I := 0 to FPNs - 3 do
  if FPbool[i] then
    begin
    FParam[i+2]:=FPValue[i];
    end;

for I := 0 to High(FXmode) do
  if FXmode[i]=cons then
    begin
     if FXt[i]=0 then FXvalue[i]:=FA[i];
     if (FXt[i]<FPNs)and(FXt[i]>0) then
       FXvalue[i]:=FA[i]+FB[i]*FParam[FXt[i]]+
                   FC[i]*sqr(FParam[FXt[i]]);
     if FXt[i]>FPNs then
       FXvalue[i]:=FA[i]+FB[i]/FParam[FXt[i]-FPNs]+
                     FC[i]/sqr(FParam[FXt[i]-FPNs]);
    end;
end;


Function TFitFunction.FitnessFunc(AP: PVector; Variab: TArrSingle):double;
var i:integer;
    Zi:double;
begin
Result:=0;
for I := 0 to High(AP^.X) do
   begin
   Fparam[0]:=AP^.X[i];
   Fparam[1]:=AP^.Y[i];
   Zi:=Func(Variab)-AP^.Y[i];
   Result:=Result+Zi*Zi/Power(abs(AP^.Y[i]),FPEst);
   end;
end;

Function TFitFunction.FinalFunc(X:double;Variab:TArrSingle):double;
 {обчислюються значення апроксимуючої функції в
 точці з абсцисою Х, найчастіше значення співпадає
 з тим, що повертає Func при Fparam[0]=X}
begin
  FParam[0]:=X;
  Result:=Func(Variab);
end;


procedure TFitFunction.SetNit(value:integer);
begin
  if value>0 then fNit:=value
             else fNit:=1000;
end;

Procedure TFitFunction.SetValue(num,index:byte;value:double);
 {встановлюються значення num-го елементу поля
 FXmin при index=1
 FXmax при index=2
 FXminlim при index=3
 FXmaxlim при index=4
 }
begin
if num>(FNs-1) then Exit;
case index of
 1:FXmin[num]:=value;
 2:FXmax[num]:=value;
 3:FXminlim[num]:=value;
 4:FXmaxlim[num]:=value;
 end;
end;

Procedure TFitFunction.SetValue(name:string;index:byte;value:double);
{встановлюються значення елементу поля
 FXmin при index=1
 FXmax при index=2
 FXminlim при index=3
 FXmaxlim при index=4
для якого елемент FXname співпадає з name}
var i:byte;
begin
for I := 0 to High(FXname) do
  if name=FXname[i] then
    begin
      case index of
        1:FXmin[i]:=value;
        2:FXmax[i]:=value;
        3:FXminlim[i]:=value;
        4:FXmaxlim[i]:=value;
        end;
     Break;
    end;
end;

Procedure TFitFunction.SetValueMode(num:byte;value:TVar_Rand);
 {встановлюються значення num-го елементу поля
 FXmode }
begin
if num>(FNs-1) then Exit;
 FXmode[num]:=value;
end;

Procedure TFitFunction.SetValueMode(name:string;value:TVar_Rand);
var i:byte;
begin
for I := 0 to High(FXname) do
  if name=FXname[i] then
    begin
     FXmode[i]:=value;
     Break;
    end;
end;

Procedure TFitFunction.SetValueGR;
const PaddingTop=120;
      PaddingBetween=5;
      PaddingLeft=50;
var Form:TForm;
    Pan:array of TFrApprP;
    Buttons:TFrBut;
    Niter:TLabeledEdit;
    ParamP:array of TFrParamP;
    Img:TImage;
    GrBox:TGroupBox;
    EvMode:array [0..3] of TRadioButton;
    i:integer;
    ConfigFile:TOIniFile;
begin
 ConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
 Form:=Tform.Create(Application);
 Form.Name:=Fname;
 Form.Position:=poMainFormCenter;
 Form.AutoScroll:=True;
 Form.BorderIcons:=[biSystemMenu];
 Form.Caption:=FName+' function '+', parameters';
 Form.Font.Name:='Tahoma';
 Form.Font.Size:=8;
 Form.Font.Style:=[fsBold];
 Form.Color:=RGB(222,254,233);

// Mode_DE:=1;

 Img:=TImage.Create(Form);
 Img.Parent:=Form;
 Img.Top:=10;
 Img.Left:=10;
// Img.AutoSize:=True;
 Img.Height:=60;
 Img.Width:=450;
 Img.Stretch:=True;
 PictLoadScale(Img,FName+'Fig');
// Img.Transparent:=True;


 SetLength(Pan,FNs);
 for I := 0 to FNs - 1 do
  begin
  Pan[i]:=TFrApprP.Create(Form);
  Pan[i].Name:=FXname[i];
  Pan[i].Parent:=Form;
  Pan[i].Left:=5;
  Pan[i].Top:=PaddingTop+i*(Pan[i].Panel1.Height+PaddingBetween);
  Pan[i].LName.Caption:=FXname[i];
  Pan[i].minIn.Text:=ValueToStr555(ConfigFile.ReadFloat(FName,FXname[i]+'Xmin',555));
  Pan[i].maxIn.Text:=ValueToStr555(ConfigFile.ReadFloat(FName,FXname[i]+'Xmax',555));
  Pan[i].minLim.Text:=ValueToStr555(ConfigFile.ReadFloat(FName,FXname[i]+'Xminlim',555));
  Pan[i].maxLim.Text:=ValueToStr555(ConfigFile.ReadFloat(FName,FXname[i]+'Xmaxlim',555));
      case ConfigFile.ReadRand(FName,FXname[i]+'Mode') of
       lin:  Pan[i].RBNorm.Checked:=True;
       logar:Pan[i].RBLogar.Checked:=True;
       cons: Pan[i].RBCons.Checked:=True;
       end;
  end;

  if FPNs>2 then
   begin
    SetLength(ParamP,FPNs-2);
    for I :=0 to High(ParamP) do
    begin
    ParamP[i]:=TFrParamP.Create(Form);
    ParamP[i].Name:=ParamP[i].Name+FPname[i+2];
    if (FName='LinEg')and(i>2) then Continue;
    ParamP[i].Parent:=Form;
    ParamP[i].Left:=Pan[0].Panel1.Width+10;
    ParamP[i].Top:=PaddingTop+i*(Pan[0].Panel1.Height+PaddingBetween);
    ParamP[i].LName.Caption:=FPname[i+2];
    ParamP[i].EParam.OnKeyPress:=Pan[0].minIn.OnKeyPress;
    ParamP[i].CBIntr.Checked:=true;
    ParamP[i].EParam.Text:=ValueToStr555(ConfigFile.ReadFloat(FName,FPname[i+2]+'Val',555));
    ParamP[i].CBIntr.Checked:=ConfigFile.ReadBool(FName,FPname[i+2]+'Bool',True);;
    end;
   end;

   if (Fname='RevShSCLC')
    then  ParamP[High(Paramp)].Top:=PaddingTop-(Pan[0].Panel1.Height+PaddingBetween);
   
 Niter:=TLabeledEdit.Create(Form);
 Niter.Parent:=Form;
 Niter.Left:=65;
 Niter.Top:=85;
 Niter.LabelPosition:=lpLeft;
 Niter.EditLabel.Width:=40;
 Niter.EditLabel.WordWrap:=True;
 Niter.EditLabel.Caption:='Iteration number';
 Niter.Width:=50;
 Niter.OnKeyPress:=Pan[0].minIn.OnKeyPress;
 Niter.Text:=ValueToStr555(ConfigFile.ReadInteger(FName,'Nit',555));

 Buttons:=TFrBut.Create(Form);
 Buttons.Parent:=Form;
 Buttons.Left:=150;
 Buttons.Top:=PaddingTop+FNs*(Pan[0].Panel1.Height+PaddingBetween);

 GrBox:=TGroupBox.Create(Form);
 GrBox.Parent:=Form;
 GrBox.Caption:='Evolution Type';
 GrBox.Left:=Niter.Left+Niter.Width+20;
 GrBox.Top:=70;
 for I := 0 to High(EvMode) do
   begin
   EvMode[i]:=TRadioButton.Create(GrBox);
   EvMode[i].Parent:=GrBox;
   EvMode[i].Top:=20;
   EvMode[i].Width:=60;
   end;
 EvMode[0].Caption:='DE';
 EvMode[1].Caption:='MABC';
 EvMode[2].Caption:='TLBO';
 EvMode[3].Caption:='PSO';
 EvMode[0].Left:=5;
 for I := 1 to High(EvMode) do
   begin
   EvMode[i].Left:=5+EvMode[i-1].Left+EvMode[i-1].Width;
   end;
 GrBox.Width:=EvMode[High(EvMode)].Left+EvMode[High(EvMode)].Width+5;
 GrBox.Height:=EvMode[High(EvMode)].Height+30;
 EvMode[ord(ConfigFile.ReadEvType(FName,'EvType',TDE))].Checked:=True;

  Form.Height:=FNs*(Pan[0].Panel1.Height+PaddingBetween)+PaddingTop+
               Buttons.Height+50;

if Fname='RevShSCLC2' then
   begin
   ParamP[5].Top:=ParamP[3].Top;
   ParamP[6].Top:=ParamP[3].Top;
   ParamP[7].Top:=ParamP[4].Top;
   ParamP[7].Left:=5;
   ParamP[5].Left:=5;
   ParamP[6].Left:=round((ParamP[3].Left-ParamP[7].Left)/2);
   Buttons.Top:=PaddingTop+(FNs+2)*(Pan[0].Panel1.Height+PaddingBetween);
   Form.Height:=(FNs+2)*(Pan[0].Panel1.Height+PaddingBetween)+PaddingTop+
               Buttons.Height+50;
   end;


// showmessage(inttostr(max(Pan[0].Panel1.Left+Pan[0].Panel1.Width,Img.Left+Img.Width)));
 Form.Width:=max(Pan[0].Panel1.Left+Pan[0].Panel1.Width,Img.Left+Img.Width)+PaddingLeft;
 if High(ParamP)>-1 then Form.Width:=Form.Width+ParamP[0].Panel.Width;

 ConfigFile.Free;

 if Form.ShowModal=mrOk then
  begin
      ConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
      ConfigFile.WriteInteger(FName,'Nit',StrToInt555(Niter.Text));


      for I := 0 to FNs - 1 do
        begin
          ConfigFile.WriteFloat(FName,FXname[i]+'Xmin',StrToFloat555(Pan[i].minIn.Text));
          ConfigFile.WriteFloat(FName,FXname[i]+'Xmax',StrToFloat555(Pan[i].maxIn.Text));
          ConfigFile.WriteFloat(FName,FXname[i]+'Xminlim',StrToFloat555(Pan[i].minLim.Text));
          ConfigFile.WriteFloat(FName,FXname[i]+'Xmaxlim',StrToFloat555(Pan[i].maxLim.Text));

          if Pan[i].RBNorm.Checked then ConfigFile.WriteRand(FName,FXname[i]+'Mode',lin);
          if Pan[i].RBLogar.Checked then ConfigFile.WriteRand(FName,FXname[i]+'Mode',logar);
          if Pan[i].RBCons.Checked then  ConfigFile.WriteRand(FName,FXname[i]+'Mode',cons);
        end;  //for I := 0 to FNs - 1 do

      if FPNs>2 then
        for I :=0 to High(ParamP) do
          begin
           if (FName='LinEg')and(i>2) then Continue;
           ConfigFile.WriteFloat(FName,FPname[i+2]+'Val',StrToFloat555(ParamP[i].EParam.Text));
           ConfigFile.WriteBool(FName,FPname[i+2]+'Bool',ParamP[i].CBIntr.Checked);
          end;

      if EvMode[0].Checked then FEvType:=TDE;
      if EvMode[1].Checked then FEvType:=TMABC;
      if EvMode[2].Checked then FEvType:=TTLBO;
      if EvMode[3].Checked then FEvType:=TPSO;
      ConfigFile.WriteEvType(FName,'EvType',FEvType);
       ConfigFile.Free;
  end;// if Form.ShowModal=mrOk then

 ReadValue;

 for I := 0 to FNs - 1 do
  begin
  Pan[i].Parent:=nil;
  Pan[i].Free;
  end;

 for I := 0 to FPNs - 3 do
  begin
  ParamP[i].Parent:=nil;
  ParamP[i].Free;
  end;

 Buttons.Parent:=nil;
 Buttons.Free;
 Niter.Parent:=nil;
 Niter.Free;
 Img.Parent:=nil;
 Img.Free;

  for I := 0 to High(EvMode) do
   begin
   EvMode[i].Parent:=nil;
   EvMode[i].Free;
   end;
 GrBox.Parent:=nil;
 GrBox.Free;

 Form.Hide;
 Form.Release;
end;

Procedure TFitFunction.ReadValue;
 {зчитує дані для  FXmin, FXmax, FXminlim,  FXmaxlim, FXmode
 та FNit з ini-файла}
var ConfigFile:TOIniFile;
    i:integer;
    str:string;
begin
 ConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
 try
 str:='';
 for I := 0 to High(FPname) do
  str:=str+FPname[i]+'*';
 ConfigFile.WriteString(FName,'Pnames',str);
 FIsReady:=true;
 for I := 0 to High(FXname) do
   begin
    FXmin[i]:=ConfigFile.ReadFloat(FName,FXname[i]+'Xmin',555);
    FXmax[i]:=ConfigFile.ReadFloat(FName,FXname[i]+'Xmax',555);
    FXminlim[i]:=ConfigFile.ReadFloat(FName,FXname[i]+'Xminlim',555);
    FXmaxlim[i]:=ConfigFile.ReadFloat(FName,FXname[i]+'Xmaxlim',555);
    FXmode[i]:=ConfigFile.ReadRand(FName,FXname[i]+'Mode');
    FIsReady:=FIsReady and (FXmin[i]<>555) and (FXmax[i]<>555)
              and (FXminlim[i]<>555) and (FXmaxlim[i]<>555);
    FA[i]:=ConfigFile.ReadFloat(FName,FXname[i]+'A',555);
    FB[i]:=ConfigFile.ReadFloat(FName,FXname[i]+'B',555);
    FC[i]:=ConfigFile.ReadFloat(FName,FXname[i]+'C',555);
    FXt[i]:=ConfigFile.ReadInteger(FName,FXname[i]+'tt',0);
    if FXmode[i]=cons then
      begin
        if not(FXt[i]in[0,2..(FPNs-1),(FPNs+2)..(2*FPNs-1)]) then FIsready:=False;
        if ((FXt[i]=0) and (FA[i]=555)) then FIsready:=False;
        if ((FXt[i]in[2..(FPNs-1),(FPNs+2)..(2*FPNs-1)])
             and(FA[i]=555)and(FC[i]=555)and(FB[i]=555)) then FIsready:=False;
      end;
   end;
FEvType:=ConfigFile.ReadEvType(FName,'EvType',TDE);
Nit:=ConfigFile.ReadInteger(FName,'Nit',555);
FIsready:=FIsready and (Nit<>555);

 for I := 0 to High(FPname)-2 do
 begin
  if (FName='LinEg')and(i>2) then Continue;
  FPbool[i]:=ConfigFile.ReadBool(FName,FPname[i+2]+'Bool',True);
  FPValue[i]:=ConfigFile.ReadFloat(FName,FPname[i+2]+'Val',555);
  if ((FPbool[i])and(FPValue[i]=555)) then FIsready:=False;
 end;
 except
  FIsReady:=False;
 end;
 FSzr:=ConfigFile.ReadFloat('Parameters','Square',3.14e-6);
 FArich:=ConfigFile.ReadFloat('Parameters','RichConst',1.12e6);
ConfigFile.Free;
end;

Procedure TFitFunction.WriteValue;
 {записує дані для  FXmin, FXmax, FXminlim,  FXmaxlim, FXmode
 та FNit в ini-файл}
var ConfigFile:TOIniFile;
    i:integer;
begin
if not(IsReady) then Exit;
 ConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
 for I := 0 to High(FXname) do
   begin
    ConfigFile.WriteFloat(FName,FXname[i]+'Xmin',FXmin[i]);
    ConfigFile.WriteFloat(FName,FXname[i]+'Xmax',FXmax[i]);
    ConfigFile.WriteFloat(FName,FXname[i]+'Xminlim',FXminlim[i]);
    ConfigFile.WriteFloat(FName,FXname[i]+'Xmaxlim',FXmaxlim[i]);
    ConfigFile.WriteRand(FName,FXname[i]+'Mode',FXmode[i]);
    ConfigFile.WriteFloat(FName,FXname[i]+'A',FA[i]);
    ConfigFile.WriteFloat(FName,FXname[i]+'B',FB[i]);
    ConfigFile.WriteFloat(FName,FXname[i]+'C',FC[i]);
    ConfigFile.WriteInteger(FName,FXname[i]+'tt',FXt[i]);
   end;
for I := 0 to High(FPname)-2 do
 begin
  if (FName='LinEg')and(i>2) then Continue;
  ConfigFile.WriteBool(FName,FPname[i+2]+'Bool',FPbool[i]);
  ConfigFile.WriteFloat(FName,FPname[i+2]+'Val',FPValue[i]);
 end;
ConfigFile.WriteEvType(FName,'EvType',FEvType);
ConfigFile.WriteInteger(FName,'Nit',Nit);
ConfigFile.Free;
end;

Procedure TFitFunction.VarRand(var X:TArrSingle);
 {випадковим чином задає значення змінних
 масиву  Х в діапазоні від FXmin до FXmax}
var i:byte;
begin
SetLength(X,FNs);
for I := 0 to High(X) do
  case FXmode[i] of
   logar: X[i]:=RandomLnAB(FXmin[i],FXmax[i]);
   cons:  X[i]:=FXValue[i];
   else   X[i]:=RandomAB(FXmin[i],FXmax[i]);
  end;
end;

Procedure TFitFunction.PenaltyFun(var X:TArrSingle);
 {контролює можливі значення параметрів у масиві X,
 що підбираються при апроксимації еволюційними методами,
 заважаючи їм прийняти нереальні значення -
 тобто за межами FXminlim та FXmaxlim}
var i:byte;
    temp:double;
begin
Randomize;
for i := 0 to High(X) do
  if (FXmode[i]<>cons) then
   begin


     while(X[i]>FXmaxlim[i])
         or(X[i]<FXminlim[i])do
       begin
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
       end;//     while(X[i]>FXmaxlim[i])or(X[i]<FXminlim[i])do



//    while(X[i]>FXmaxlim[i])do
//     case FXmode[i] of
//       lin:X[i]:=X[i]-Random*(FXmaxlim[i]-FXminlim[i]);
//       logar:
//         begin
//         temp:=ln(X[i])-Random*(ln(FXmaxlim[i])-ln(FXminlim[i]));
//         while (temp>88) do temp:=temp-1;
//         X[i]:=exp(temp);
//         end;
//      end;//case
//   while (X[i]<FXminlim[i]) do
//     case FXmode[i] of
//       lin:X[i]:=X[i]+Random*(FXmaxlim[i]-FXminlim[i]);
//       logar:
//         begin
//         temp:=ln(X[i])+Random*(ln(FXmaxlim[i])-ln(FXminlim[i]));
//         while (temp>88) do temp:=temp-1;
//         X[i]:=exp(temp);
//         end;
//     end;//case
    end; // if (FXmode[i]<>cons) then begin
end;

Procedure TFitFunction.WindowPrepare();
 {підготовка вікна до показу даних}
var //Labels:array of TLabel;
    i:byte;
begin
SetLength(Labels,2*FNs);
 for I := 0 to FNs - 1 do
  begin
  Labels[i]:=TLabel.Create(App);
  Labels[i].Name:=Labels[i].Name+FXname[i];
  Labels[i+FNs]:=TLabel.Create(App);
  Labels[i+FNs].Name:=Labels[i].Name+FXname[i]+'n';
  Labels[i].Parent:=App;
  Labels[i+FNs].Parent:=App;
  Labels[i].Left:=24;
  Labels[i+FNs].Left:=90;
  Labels[i].Top:=round(3.5*App.LNmax.Height)+i*round(1.5*Labels[i].Height);
  Labels[i+FNs].Top:=round(3.5*App.LNmax.Height)+i*round(1.5*Labels[i].Height);
  Labels[i].Caption:=FXname[i]+' =';
  end;
  App.LNmaxN.Caption:=inttostr(FNit);
  App.Height:=Labels[High(Labels)].Top+3*Labels[High(Labels)].Height;
end;

Procedure TFitFunction.WindowClear();
 {очищення вікна після апроксимації}
var i:byte;
begin
 for I := 0 to 2*FNs - 1 do
  begin
    Labels[i].Parent:=nil;
    Labels[i].Free;
  end;
end;

Procedure TFitFunction.WindowDataShow(N:integer;X:TArrSingle);
 {показ номера біжучої ітерації
  та даних, які знаходяться в Х}
var i:byte;
begin
  for I := 0 to FNs - 1 do
   Labels[i+FNs].Caption:=floattostrf(X[i],ffExponent,4,3);
   App.LNitN.Caption:=Inttostr(N);
end;

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

Constructor TLinear.Create;
begin
 inherited Create(2);
 FName:='Linear';
 FXname[0]:='A';
 FXname[1]:='B';
 FPEst:=2;
 FCaption:='Linear fitting, least-squares method';
// ReadValue;
end;

Function TLinear.Func(Variab:TArrSingle):double;
begin
Result:=Variab[0]+Variab[1]*FParam[0];
end;

Constructor TQuadratic.Create;
begin
 inherited Create(3);
 FName:='Quadratic';
 FXname[0]:='A';
 FXname[1]:='B';
 FXname[2]:='C';
 FCaption:='Quadratic fitting, least-squares method';
end;

Function TQuadratic.Func(Variab:TArrSingle):double;
begin
Result:=Variab[0]+Variab[1]*FParam[0]+Variab[2]*sqr(FParam[0]);
end;

Constructor TExponent.Create;
begin
 inherited Create(3);
 FName:='Exponent';
 FXname[0]:='Io';
 FXname[1]:='n';
 FXname[2]:='Fb';
 FPNs:=5;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='V';
 FPName[1]:='I';
 FPName[2]:='T';
 FPName[3]:='S';
 FPName[4]:='A*';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 FCaption:='Linear least-squares fitting of semi-log plot';
end;

Function TExponent.Func(Variab:TArrSingle):double;
begin
Result:=Variab[0]*exp(FParam[0]/(Variab[1]*Kb*FParam[2]));
end;

Procedure TExponent.BeforeFitness(AP:Pvector);
 {виконується перед початком апроксимації,
 полягає у заповненні полів потрібними
 значеннями}
var    ConfigFile:TOIniFile;
begin
 ConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
 FParam[3]:=ConfigFile.ReadFloat('Parameters','Square',3.14e-6);
 FParam[4]:=ConfigFile.ReadFloat('Parameters','RichConst',1.12e6);
 ConfigFile.Free;
 FParam[2]:=AP^.T;
end;

Constructor TSmoothing.Create;
begin
 inherited Create(0);
 FName:='Smoothing';
 FCaption:='3-point averaging, the weighting coefficient are determined by Gaussian distribution with 60% dispersion'
end;

Function TSmoothing.Func(Variab:TArrSingle):double;
begin
Result:=555;
end;

Constructor TMedian.Create;
begin
 inherited Create(0);
 FName:='Median';
 FCaption:='3-point median filtering'
end;

Function TMedian.Func(Variab:TArrSingle):double;
begin
Result:=555;
end;

Constructor TDerivative.Create;
begin
 inherited Create(0);
 FName:='Derivative';
 FCaption:='Derivative, which is calculated as derivative of 3-poin Lagrange polynomial'
end;

Function TDerivative.Func(Variab:TArrSingle):double;
begin
Result:=555;
end;

Constructor TGromov.Create;
begin
 inherited Create(3);
 FName:='Gromov';
 FXname[0]:='A';
 FXname[1]:='B';
 FXname[2]:='C';
 FCaption:='Least-squares fitting,  which is used in Gromov and Lee methods';
end;

Function TGromov.Func(Variab:TArrSingle):double;
begin
Result:=Variab[0]+Variab[1]*FParam[0]+Variab[2]*ln(FParam[0]);
end;

Constructor TIvanov.Create;
begin
 inherited Create(2);
 FName:='Ivanov';
 FXname[0]:='Fb';
 FXname[1]:='d/ep';
 FPNs:=5;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='V';
 FPName[1]:='I';
 FPName[2]:='T';
 FPName[3]:='Nd';
 FPName[4]:='ep';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 ReadValue;
 FCaption:='I-V fitting for dielectric layer width d determination, Ivanov method';
end;

Function TIvanov.Func(Variab:TArrSingle):double;
begin
Result:=555;
end;

Function TIvanov.FinalFunc(var X:double;Variab:TArrSingle):double;
var Vd,x0:double;
begin
  x0:=X;
  Vd:=Variab[1]*sqrt(2*Qelem*FParam[3]*FParam[4]/Eps0)*(sqrt(Variab[0])-sqrt(Variab[0]-x0));
  X:=Vd+x0;
  Result:=FArich*FSzr*sqr(FParam[2])*exp(-Variab[0]/Kb/FParam[2])*exp(x0/Kb/FParam[2]);
end;

Procedure TIvanov.BeforeFitness(AP:Pvector);
 {виконується перед початком апроксимації,
 полягає у заповненні полів потрібними
 значеннями}
var
    ConfigFile:TOIniFile;
begin
 ConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
 FParam[3]:=ConfigFile.ReadFloat('Parameters','Concentration',5e21);
 FParam[4]:=ConfigFile.ReadFloat('Parameters','InsulPerm',4);
 FParam[2]:=AP^.T;
 ConfigFile.Free;
end;


Constructor TNGausian.Create(NGaus:byte);
var i:byte;
begin

 inherited Create(3*NGaus);
 FName:='N Gausian';
 for I := 1 to NGaus do
   begin
    FXname[3*i-3]:='A'+inttostr(i);
    FXname[3*i-2]:='X0'+inttostr(i);
    FXname[3*i-1]:='Sig'+inttostr(i);
   end;
 FCaption:='Sum of '+inttostr(NGaus)+' Gaussian';
 FIsReady:=True;
 for I := 0 to High(FXmode) do
   begin
   FXmode[i]:=lin;
   FA[i]:=0;
   FB[i]:=0;
   FC[i]:=0;
   FXt[i]:=0;
   FXvalue[i]:=0;
   end;
  FNit:=1000*(1+NGaus*NGaus);
  FEvType:=TDE;
//  FEvType:=TMABC;

end;

Function TNGausian.Func(Variab:TArrSingle):double;
var i:byte;
begin
 Result:=0;
 for I := 1 to round(FNs/3) do
   Result:=Result+
           Variab[3*i-3]*exp(-sqr((FParam[0]-Variab[3*i-2]))/2/sqr(Variab[3*i-1]));
end;

Procedure TNGausian.BeforeFitness(AP:Pvector);
var i:byte;
    Xmin,Xmax,delY,delX:double;
begin
 Xmin:=AP^.X[MinElemNumber(AP^.X)];
 Xmax:=AP^.X[MaxElemNumber(AP^.X)];
 delY:=AP^.Y[MaxElemNumber(AP^.Y)]-AP^.Y[MinElemNumber(AP^.Y)];
 delX:=Xmax-Xmin;
 for I := 1 to round(FNs/3) do
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

// if High(AP^.X)>150 then
//   FNit:=500*(1+sqr(round(FNs/3)))
//                    else
//   FNit:=1000*(1+sqr(round(FNs/3)));
end;


Constructor TDiod.Create;
begin
 inherited Create(4);
 FName:='Diod';
 FXname[0]:='n';
 FXname[1]:='Rs';
 FXname[2]:='Io';
 FXname[3]:='Rsh';
 FPNs:=3;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='V';
 FPName[1]:='I';
 FPName[2]:='T';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 ReadValue;
 FCaption:='Diod function, evolution fitting';
 SetLength(FDodXname,1);
 SetLength(FDodX,1);
 FDodXname[0]:='Fb';
end;

Function TDiod.Func(Variab:TArrSingle):double;
begin
Result:=Variab[2]*(exp((FParam[0]-FParam[1]*Variab[1])/(Variab[0]*Kb*FParam[2]))-1)
      +(FParam[0]-FParam[1]*Variab[1])/Variab[3];
end;

Procedure TDiod.BeforeFitness(AP:Pvector);
 {виконується перед початком апроксимації,
 полягає у заповненні полів потрібними
 значеннями}
begin
FParam[2]:=AP^.T;
inherited;
end;

Procedure TDiod.DodParDetermination(V: PVector; Variab:TArrSingle);
begin
FDodX[0]:=555;
if (FSzr<>0)and(FSzr<>555)and(FArich<>0)and(FArich<>555) then
   FDodX[0]:=Kb*FParam[2]*ln(FSzr*FArich*sqr(FParam[2])/Variab[2]);
end;


Function TDiod.FinalFunc(X:double;Variab:TArrSingle):double;
begin
 Result:=Full_IV(X,Variab[0]*Kb*FParam[2],Variab[1],
                 Variab[2],Variab[3],0);
end;


Constructor TPhotoDiod.Create;
begin
 inherited Create(5);
 FName:='PhotoDiod';
 FXname[0]:='n';
 FXname[1]:='Rs';
 FXname[2]:='Io';
 FXname[3]:='Rsh';
 FXname[4]:='Iph';
 FPNs:=3;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='V';
 FPName[1]:='I';
 FPName[2]:='T';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 FPEst:=1;
 FCaption:='Function of lightened diod, evolution fitting';
 SetLength(FDodXname,4);
 SetLength(FDodX,4);
 FDodXname[0]:='Voc';
 FDodXname[1]:='Isc';
 FDodXname[2]:='Pm';
 FDodXname[3]:='FF';
 ReadValue;
 FDbool:=True;
end;

Function TPhotoDiod.Func(Variab:TArrSingle):double;
begin
Result:=Variab[2]*(exp((FParam[0]-FParam[1]*Variab[1])/(Variab[0]*Kb*FParam[2]))-1)
      +(FParam[0]-FParam[1]*Variab[1])/Variab[3]-Variab[4];
end;

Procedure TPhotoDiod.BeforeFitness(AP:Pvector);
 {виконується перед початком апроксимації,
 полягає у заповненні полів потрібними
 значеннями}
begin
FParam[2]:=AP^.T;
inherited;
end;


Function TPhotoDiod.FinalFunc(X:double;Variab:TArrSingle):double;
begin
 Result:=Full_IV(X,Variab[0]*Kb*FParam[2],Variab[1],
                 Variab[2],Variab[3],Variab[4]);
end;

Procedure TPhotoDiod.DodParDetermination(V: PVector; Variab:TArrSingle);
begin
FDodX[0]:=555;
FDodX[1]:=555;
FDodX[2]:=555;
FDodX[3]:=555;
if (Variab[4]>1e-7) then
   begin
    FDodX[0]:=Voc_Isc_Pm(1,V,Variab[0],Variab[1],Variab[2],Variab[3],Variab[4]);
    FDodX[1]:=Voc_Isc_Pm(2,V,Variab[0],Variab[1],Variab[2],Variab[3],Variab[4]);
   end;
if (FDodX[0]>0.002)and(FDodX[1]>1e-7)and(FDodX[0]<>555)and(FDodX[1]<>555) then
    FDodX[2]:=Voc_Isc_Pm(3,V,Variab[0],Variab[1],Variab[2],Variab[3],Variab[4]);
if (FDodX[0]<>0)and(FDodX[0]<>555)and(FDodX[1]<>0)and(FDodX[1]<>555) then
   FDodX[3]:=FDodX[2]/FDodX[0]/FDodX[1];
end;


Constructor TDiodTwo.Create;
begin
 inherited Create(5);
 FName:='DiodTwo';
 FXname[0]:='n1';
 FXname[1]:='Rs';
 FXname[2]:='Io1';
 FXname[3]:='n2';
 FXname[4]:='Io2';
 FPNs:=3;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='V';
 FPName[1]:='I';
 FPName[2]:='T';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 ReadValue;
 FCaption:='Two Diod function, evolution fitting';
end;

Function TDiodTwo.Func(Variab:TArrSingle):double;
begin
 Result:=Full_IV(FParam[0],Variab[0]*Kb*FParam[2],Variab[1],Variab[2],1e13,0)+
       Variab[4]*(exp(FParam[0]/(Variab[3]*Kb*FParam[2]))-1);
end;

Procedure TDiodTwo.BeforeFitness(AP:Pvector);
 {виконується перед початком апроксимації,
 полягає у заповненні полів потрібними
 значеннями}
begin
FParam[2]:=AP^.T;
inherited;
end;

Constructor TDiodTwoFull.Create;
begin
 inherited Create(6);
 FName:='DiodTwoFull';
 FXname[0]:='n1';
 FXname[1]:='Rs1';
 FXname[2]:='Io1';
 FXname[3]:='n2';
 FXname[4]:='Io2';
 FXname[5]:='Rs2';
 FPNs:=3;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='V';
 FPName[1]:='I';
 FPName[2]:='T';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 ReadValue;
 FCaption:='Two Full Diod function, evolution fitting';
end;

Function TDiodTwoFull.Func(Variab:TArrSingle):double;
begin
 Result:=Full_IV(FParam[0],Variab[0]*Kb*FParam[2],Variab[1],Variab[2],1e13,0)+
         Full_IV(FParam[0],Variab[3]*Kb*FParam[2],Variab[5],Variab[4],1e13,0);
end;

Procedure TDiodTwoFull.BeforeFitness(AP:Pvector);
 {виконується перед початком апроксимації,
 полягає у заповненні полів потрібними
 значеннями}
begin
FParam[2]:=AP^.T;
inherited;
end;

Constructor TDGaus.Create;
begin
 inherited Create(5);
 FName:='DGaus';
 FXname[0]:='A';
 FXname[1]:='Fb01';
 FXname[2]:='Sig1';
 FXname[3]:='Fb02';
 FXname[4]:='Sig2';
 FPNs:=4;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='T';
 FPName[1]:='Fb';
 FPName[2]:='Alpha';
 FPName[3]:='Betta';
 FPEst:=0;
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 ReadValue;
 FCaption:='Double Gaussian barrier distribution, evolution fitting';
end;

Function TDGaus.Func(Variab:TArrSingle):double;
var temp,temp2:double;
begin
temp:=Kb*FParam[0];
temp2:=FParam[3]*sqr(FParam[0])/(FParam[2]+FParam[0]);
Result:=-temp*ln(Variab[0]*exp(-(Variab[1]-temp2)/temp+sqr(Variab[2])/2/sqr(temp))+
               (1-Variab[0])*exp(-(Variab[3]-temp2)/temp+sqr(Variab[4])/2/sqr(temp)));
end;

Procedure TDGaus.BeforeFitness(AP:Pvector);
begin
 FPbool[1]:=True;
 FPbool[0]:=True;
 inherited;
end;


Constructor TLinEg.Create;
begin
 inherited Create(3);
 FName:='LinEg';
 FXname[0]:='Gam';
 FXname[1]:='C1';
 FXname[2]:='Fb0';
 FPNs:=7;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='T';
 FPName[1]:='Fb';
 FPName[2]:='Alpha';
 FPName[3]:='Betta';
 FPName[4]:='mef';
 FPName[5]:='Nd';
 FPName[6]:='ep';
 FPEst:=0;
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 ReadValue;
 FCaption:='Patch current fitting';
end;

Function TLinEg.Func(Variab:TArrSingle):double;
var Fb,Vbb,nu:double;
begin
Fb:=Variab[2]-FParam[3]*sqr(FParam[0])/(FParam[2]+FParam[0]);
Vbb:=Fb-Kb*FParam[0]*ln((2.5e25*FParam[4]*Power(FParam[0]/300,3.0/2.0))/FParam[5]);
nu:=Eps0*FParam[6]/Qelem/FParam[5];
Result:=Fb-Variab[0]*Power(Vbb/nu,1.0/3.0)-
        Kb*FParam[0]*ln(Variab[0]*Variab[1]*4*3.14*Kb*FParam[0]/9*Power(nu/Vbb,2.0/3.0));
end;

Procedure TLinEg.BeforeFitness(AP:Pvector);
var
    ConfigFile:TOIniFile;
begin
 ConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
 FParam[5]:=ConfigFile.ReadFloat('Parameters','Concentration',5e21);
 FParam[6]:=ConfigFile.ReadFloat('Parameters','InsulPerm',4);
 FPbool[3]:=False;
 FPbool[4]:=False;
 FPbool[2]:=True;
 FPbool[1]:=True;
 FPbool[0]:=True;
 ConfigFile.Free;
 inherited;
end;


Constructor TDoubleDiod.Create;
begin
 inherited Create(6);
 FName:='DoubleDiod';
 FXname[0]:='n1';
 FXname[1]:='Rs';
 FXname[2]:='Io1';
 FXname[3]:='Rsh';
 FXname[4]:='n2';
 FXname[5]:='Io2';
 FPNs:=3;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='V';
 FPName[1]:='I';
 FPName[2]:='T';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 ReadValue;
 FCaption:='Double diod fitting of solar cell I-V';
end;

Function TDoubleDiod.Func(Variab:TArrSingle):double;
begin
Result:=Variab[2]*(exp((FParam[0]-FParam[1]*Variab[1])/(Variab[0]*Kb*FParam[2]))-1)
      +Variab[5]*(exp((FParam[0]-FParam[1]*Variab[1])/(Variab[4]*Kb*FParam[2]))-1)
      +(FParam[0]-FParam[1]*Variab[1])/Variab[3];
end;

Procedure TDoubleDiod.BeforeFitness(AP:Pvector);
 {виконується перед початком апроксимації,
 полягає у заповненні полів потрібними
 значеннями}
begin
FParam[2]:=AP^.T;
inherited;
end;

Function TDoubleDiod.FinalFunc(X:double;Variab:TArrSingle):double;
begin
Result:=Full_IV_2Exp(X,Variab[0]*Kb*FParam[2],Variab[4]*Kb*FParam[2],
               Variab[1],Variab[2],Variab[5],Variab[3],0);
end;

Constructor TDoubleDiodLight.Create;
begin
 inherited Create(7);
 FName:='DoubleDiodLight';
 FXname[0]:='n1';
 FXname[1]:='Rs';
 FXname[2]:='Io1';
 FXname[3]:='Rsh';
 FXname[4]:='n2';
 FXname[5]:='Io2';
 FXname[6]:='Iph';
 FPNs:=3;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='V';
 FPName[1]:='I';
 FPName[2]:='T';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 FCaption:='Double diod fitting of lightened solar cell I-V';
 SetLength(FDodXname,4);
 SetLength(FDodX,4);
 FDodXname[0]:='Voc';
 FDodXname[1]:='Isc';
 FDodXname[2]:='Pm';
 FDodXname[3]:='FF';
 ReadValue;
 FDbool:=True;
end;

Function TDoubleDiodLight.Func(Variab:TArrSingle):double;
begin
Result:=Variab[2]*(exp((FParam[0]-FParam[1]*Variab[1])/(Variab[0]*Kb*FParam[2]))-1)
      +Variab[5]*(exp((FParam[0]-FParam[1]*Variab[1])/(Variab[4]*Kb*FParam[2]))-1)
      +(FParam[0]-FParam[1]*Variab[1])/Variab[3]-Variab[6];
end;




Procedure TDoubleDiodLight.BeforeFitness(AP:Pvector);
begin
FParam[2]:=AP^.T;
inherited;
end;

Function TDoubleDiodLight.FinalFunc(X:double;Variab:TArrSingle):double;
begin
Result:=Full_IV_2Exp(X,Variab[0]*Kb*FParam[2],Variab[4]*Kb*FParam[2],
               Variab[1],Variab[2],Variab[5],Variab[3],Variab[6]);
end;

Function TDoubleDiodLight.FitnessFunc(AP: PVector; Variab: TArrSingle):double;
var i:integer;
    Zi:double;
begin
Result:=0;
for I := 0 to High(AP^.X) do
   begin
   Fparam[0]:=AP^.X[i];
   Fparam[1]:=AP^.Y[i];
   Zi:=Func(Variab)-AP^.Y[i];
   Result:=Result+Zi*Zi/sqr(AP^.Y[i]+Variab[6]);
   end;
end;

Procedure TDoubleDiodLight.DodParDetermination(V: PVector; Variab:TArrSingle);
begin
FDodX[0]:=555;
FDodX[1]:=555;
FDodX[2]:=555;
FDodX[3]:=555;
if (Variab[6]>1e-7) then
      begin
      FDodX[0]:=Voc_Isc_Pm_DoubleDiod(1,Variab[0]*Kb*FParam[2],Variab[4]*Kb*FParam[2],
       Variab[1],Variab[2],Variab[5],Variab[3],Variab[6]);

      FDodX[1]:=Voc_Isc_Pm_DoubleDiod(2,Variab[0]*Kb*FParam[2],Variab[4]*Kb*FParam[2],
       Variab[1],Variab[2],Variab[5],Variab[3],Variab[6]);
      end;
if (FDodX[0]>0.002)and(FDodX[1]>1e-7)and(FDodX[0]<>555)and(FDodX[1]<>555) then
    FDodX[2]:=Voc_Isc_Pm_DoubleDiod(3,Variab[0]*Kb*FParam[2],Variab[4]*Kb*FParam[2],
       Variab[1],Variab[2],Variab[5],Variab[3],Variab[6]);
if (FDodX[0]<>0)and(FDodX[0]<>555)and(FDodX[1]<>0)and(FDodX[1]<>555) then
   FDodX[3]:=FDodX[2]/FDodX[0]/FDodX[1];
end;

Constructor TTunnel.Create;
begin
 inherited Create(3);
 FName:='Tunnel';
 FXname[0]:='Io';
 FXname[1]:='A';
 FXname[2]:='B';
 FPName[0]:='V';
 FPName[1]:='I';
 ReadValue;
 FCaption:='Tunneling through rectangular barrier';
end;

Function TTunnel.Func(Variab:TArrSingle):double;
begin
Result:=TunFun(FParam[0],Variab);
end;

Constructor TPower2.Create;
begin
 inherited Create(4);
 FName:='Power2';
 FXname[0]:='A1';
 FXname[1]:='A2';
 FXname[2]:='m1';
 FXname[3]:='m2';
 ReadValue;
 FCaption:='Two power function';
end;

Function TPower2.Func(Variab:TArrSingle):double;
begin
Result:=Variab[0]*(Power(FParam[0],Variab[2])
       +Variab[1]*Power(FParam[0],Variab[3]));
end;


Constructor TRevZriz.Create;
begin
 inherited Create(4);
 FName:='RevZriz';
 FXname[0]:='Io1';
 FXname[1]:='E1';
 FXname[2]:='Io2';
 FXname[3]:='E2';
 FPNs:=4;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='1/kT';
 FPName[1]:='I';
 FPName[2]:='m';
 FPName[3]:='b';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 ReadValue;
 FCaption:='Dependence of reverse current at constant bias on inverse temperature. First component is TE current, second is SCLC current ';
end;

Function TRevZriz.Func(Variab:TArrSingle):double;
var I1,I2:double;
begin
Result:=555;
if FParam[0]<=0 then Exit;
I1:=RevZrizFun(FParam[0],FParam[2],Variab[2],Variab[3]);
I2:=RevZrizFun(FParam[0],2,Variab[0],Variab[1]);
if FParam[3]>=0 then Result:=I1+I2
                else Result:=I1*I2/(I1+I2);
end;

Procedure TRevZriz.BeforeFitness(AP:Pvector);
begin
 FPbool[1]:=True;
 FPbool[0]:=True;
inherited;
end;

Constructor TRevZriz2.Create;
begin
 inherited Create(4);
 FName:='RevZriz2';
 FXname[0]:='Io1';
 FXname[1]:='E';
 FXname[2]:='Io2';
 FXname[3]:='A';
 FPNs:=3;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='1/kT';
 FPName[1]:='I';
 FPName[2]:='m';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 ReadValue;
 FCaption:='Dependence of reverse current at constant bias on inverse temperature. First component is TE current, second is SCLC current (exponential trap distribution)';
end;

Function TRevZriz2.Func(Variab:TArrSingle):double;
begin
Result:=555;
if FParam[0]<=0 then Exit;
Result:=RevZrizFun(FParam[0],2,Variab[0],Variab[1])+
RevZrizSCLC(FParam[0],FParam[2],Variab[2],Variab[3]);
end;

Procedure TRevZriz2.BeforeFitness(AP:Pvector);
begin
 FPbool[0]:=True;
inherited;
end;

Function TRevZriz2.FitnessFunc(AP: PVector; Variab: TArrSingle):double;
var i:integer;
    Zi:double;
begin
Result:=0;
for I := 0 to High(AP^.X) do
   begin
   Fparam[0]:=AP^.X[i];
   Fparam[1]:=AP^.Y[i];
   Zi:=ln(Func(Variab))-ln(AP^.Y[i]);
   Result:=Result+Zi*Zi/Power(abs(ln(AP^.Y[i])),FPEst)
   end;
end;

Constructor TRevZriz3.Create;
begin
 inherited Create(4);
 FName:='RevZriz3';
 FXname[0]:='Io1';
 FXname[1]:='E';
 FXname[2]:='Io2';
 FXname[3]:='Tc';
 FPNs:=4;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='1/kT';
 FPName[1]:='I';
 FPName[2]:='m';
 FPName[3]:='p';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 ReadValue;
 FCaption:='Dependence of reverse current at constant bias on inverse temperature. First component is TE current, second is termally-assisted hopping transport';
end;

Function TRevZriz3.Func(Variab:TArrSingle):double;
var T1:double;
begin
Result:=555;
if FParam[0]<=0 then Exit;
T1:=Kb*FParam[0];
Result:=RevZrizFun(FParam[0],2,Variab[0],Variab[1])+
  Variab[2]*exp(-Power((Variab[3]*T1),FParam[3]))*Power(T1,-FParam[2]);
end;

Procedure TRevZriz3.BeforeFitness(AP:Pvector);
begin
 FPbool[1]:=True;
 FPbool[0]:=True;
inherited;
end;

Constructor TPhonAsTun.Create;
begin
 inherited Create(3);
 FName:='PhonAsTun';
 FXname[0]:='Nss';
 FXname[1]:='Et';
 FXname[2]:='Em';
 FPNs:=5;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='1/kT';
 FPName[1]:='I';
 FPName[2]:='a';
 FPName[3]:='hw';
 FPName[4]:='meff';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 ReadValue;
 FCaption:='Dependence of reverse photon-assisted tunneling current at constant bias on inverse temperature';
end;

Function TPhonAsTun.Func(Variab:TArrSingle):double;
var g,gam,gam1,meff,qE,Et:double;
begin
Result:=555;
if FParam[0]<=0 then Exit;
meff:=FParam[4]*m0;
qE:=Qelem*Variab[2];
Et:=Variab[1]*Qelem;
g:=FParam[2]*sqr(FParam[3]*Qelem)*(1+2/(exp(FParam[3]*FParam[0])-1));
gam:=sqrt(2*meff)*g/(Hpl*qE*sqrt(Et));
gam1:=sqrt(1+sqr(gam));
Result:=FSzr*Variab[0]*qE/sqrt(8*meff*Variab[1])*sqrt(1-gam/gam1)*
        exp(-4*sqrt(2*meff)*Et*sqrt(Et)/(3*Hpl*qE)*
            sqr(gam1-gam)*(gam1+0.5*gam));
end;

Procedure TPhonAsTun.BeforeFitness(AP:Pvector);
begin
 FPbool[2]:=True;
 FPbool[1]:=True;
 FPbool[0]:=True;
inherited;
end;


Constructor TBrailsford.Create;
begin
 inherited Create(3);
 FName:='Brailsford';
 FXname[0]:='A';
 FXname[1]:='B';
 FXname[2]:='E';
 FPNs:=3;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='T';
// FPName[0]:='w';
 FPName[1]:='Al';
 FPName[2]:='w';
// FPName[2]:='T';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 FPEst:=1;
 ReadValue;
 FCaption:='Ultrasound atteniation, Brailsford theory. w is a frequancy.';
end;

Function TBrailsford.Func(Variab:TArrSingle):double;
var d:double;
begin
Result:=555;
if FParam[2]<=0 then Exit;
d:=Variab[1]*FParam[2]*exp(Variab[2]/Kb/FParam[0]);
Result:=Variab[0]*FParam[2]/FParam[0]*d/(1+sqr(d));
//d:=Variab[1]*FParam[0]*exp(Variab[2]/Kb/FParam[2]);
//Result:=Variab[0]*FParam[0]/FParam[2]*d/(1+sqr(d));
end;

Procedure TBrailsford.BeforeFitness(AP:Pvector);
begin
 FPbool[1]:=True;
inherited;
end;


Constructor TFitFunctionEm.Create(N:integer);
var    ConfigFile:TOIniFile;
begin
 inherited Create(N);
 FPNs:=7;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='V';
 FPName[1]:='I';
 FPName[2]:='T';
 FPName[3]:='Fb';
 FPName[4]:='Alpha';
 FPName[5]:='Betta';
 FPName[6]:='mef';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 ConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
 FNd:=ConfigFile.ReadFloat('Parameters','Concentration',5e21);
 Fep:=ConfigFile.ReadFloat('Parameters','InsulPerm',4);
 ConfigFile.Free;
end;


Procedure TFitFunctionEm.BeforeFitness(AP:Pvector);
begin
 FPbool[1]:=True;
 FPbool[2]:=True;
 FPbool[3]:=True;
 FPbool[4]:=True;
 FParam[2]:=AP^.T;
 F2:=2*Qelem*FNd/Fep/Eps0;
inherited;
 F1:=FParam[3]-FParam[5]*sqr(FParam[2])/(FParam[4]+FParam[2])-
     Kb*FParam[2]*ln((2.5e25*FParam[6]*Power(FParam[2]/300,3.0/2.0))/FNd);
end;


Constructor TRevShSCLC.Create;
begin
 inherited Create(4);
 FName:='RevShSCLC';
 FXname[0]:='Io1';
 FXname[1]:='p';
 FXname[2]:='A';
 FXname[3]:='Io2';
 FPEst:=1;
 ReadValue;
 FCaption:='Dependence of reverse current on bias. First component is SCLC current, second is TE current ';
end;

Function TRevShSCLC.Func(Variab:TArrSingle):double;
begin
Result:=Variab[0]*Power(FParam[0],Variab[1])+
   Variab[3]*exp(Variab[2]*sqrt(F2*(F1+FParam[0]))/Kb/FParam[2])*(1-exp(-FParam[0]/Kb/FParam[2]));

end;


Constructor TRevShSCLC2.Create;
begin
 inherited Create(3);
 FName:='RevShSCLC2';
 FXname[0]:='Io1';
 FXname[1]:='Io2';
 FXname[2]:='A';
 FPNs:=10;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[7]:='To1';
 FPName[8]:='To2';
 FPName[9]:='b';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 FPEst:=1;
 ReadValue;
 FCaption:='Dependence of reverse current on bias. First component is SCLC current, second is TE current ';
end;

Function TRevShSCLC2.Func(Variab:TArrSingle):double;
begin
Result:=Variab[0]*(Power(FParam[0],Fm1)+FParam[9]*Power(FParam[0],Fm2))+
   Variab[1]*exp(Variab[2]*sqrt(F2*(F1+FParam[0]))/Kb/FParam[2])*(1-exp(-FParam[0]/Kb/FParam[2]));

end;

Procedure TRevShSCLC2.BeforeFitness(AP:Pvector);
begin
 FPbool[5]:=True;
 FPbool[6]:=True;
 FPbool[7]:=True;
inherited;
 Fm1:=1+FParam[7]/FParam[2];
 Fm2:=1+FParam[8]/FParam[2];
end;

Constructor TRevShSCLC3.Create;
begin
 inherited Create(6);
 FName:='RevShSCLC3';
 FXname[0]:='Io1';
 FXname[1]:='p1';
 FXname[2]:='Io2';
 FXname[3]:='p2';
 FXname[4]:='Io3';
 FXname[5]:='A';
 FPEst:=1;
 ReadValue;
 FCaption:='Dependence of reverse current on bias. First component is SCLC current, second is TE current ';
end;

Function TRevShSCLC3.Func(Variab:TArrSingle):double;
begin
Result:=Variab[0]*Power(FParam[0],Variab[1])+Variab[2]*Power(FParam[0],Variab[3])+
   Variab[4]*exp(Variab[5]*sqrt(F2*(F1+FParam[0]))/Kb/FParam[2])*(1-exp(-FParam[0]/Kb/FParam[2]));
end;

Constructor TRevSh.Create;
begin
 inherited Create(5);
 FName:='RevSh';
 FXname[0]:='Io1';
 FXname[1]:='A1';
 FXname[2]:='B1';
 FXname[3]:='Io2';
 FXname[4]:='A2';
 ReadValue;
 FCaption:='Dependence of reverse TE current on bias';
end;

Function TRevSh.Func(Variab:TArrSingle):double;
var Em,kT:double;
begin
Result:=555;
if FParam[2]<=0 then Exit;
Em:=sqrt(F2*(F1+FParam[0]));
kT:=Kb*FParam[2];
Result:=(Variab[0]*exp((Variab[1]*Em+Variab[2]*sqrt(Em))/kT)+
        Variab[3]*exp(Variab[4]*Em/kT))*(1-exp(-FParam[0]/kT));
end;

Procedure TRevSh.BeforeFitness(AP:Pvector);
begin
inherited;
if FXmode[2]=cons then FPEst:=1;
end;

Constructor TPhotoDiodLSM.Create;
begin
 inherited Create(5);
 FName:='PhotoDiodLSM';
 FXname[0]:='n';
 FXname[1]:='Rs';
 FXname[2]:='Io';
 FXname[3]:='Rsh';
 FXname[4]:='Iph';
 FPNs:=3;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='V';
 FPName[1]:='I';
 FPName[2]:='T';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 FPEst:=1;
 FCaption:='Function of lightened diod, least-squares fitting';
 SetLength(FDodXname,4);
 SetLength(FDodX,4);
 FDodXname[0]:='Voc';
 FDodXname[1]:='Isc';
 FDodXname[2]:='Pm';
 FDodXname[3]:='FF';
 ReadValue;
 FDbool:=True;
end;




Function TPhotoDiodLSM.FinalFunc(X:double;Variab:TArrSingle):double;
begin
 Result:=Full_IV(X,Variab[0]*Kb*FParam[2],Variab[1],
                 Variab[2],Variab[3],Variab[4]);
end;

Procedure TPhotoDiodLSM.DodParDetermination(V: PVector; Variab:TArrSingle);
begin
FDodX[0]:=555;
FDodX[1]:=555;
FDodX[2]:=555;
FDodX[3]:=555;
if (Variab[4]>1e-7) then
   begin
    FDodX[0]:=Voc_Isc_Pm(1,V,Variab[0],Variab[1],Variab[2],Variab[3],Variab[4]);
    FDodX[1]:=Voc_Isc_Pm(2,V,Variab[0],Variab[1],Variab[2],Variab[3],Variab[4]);
   end;
if (FDodX[0]>0.002)and(FDodX[1]>1e-7)and(FDodX[0]<>555)and(FDodX[1]<>555) then
    FDodX[2]:=Voc_Isc_Pm(3,V,Variab[0],Variab[1],Variab[2],Variab[3],Variab[4]);
if (FDodX[0]<>0)and(FDodX[0]<>555)and(FDodX[1]<>0)and(FDodX[1]<>555) then
   FDodX[3]:=FDodX[2]/FDodX[0]/FDodX[1];
end;

Constructor TDiodLam.Create;
begin
 inherited Create(4);
 FName:='DiodLam';
 FXname[0]:='n';
 FXname[1]:='Rs';
 FXname[2]:='Io';
 FXname[3]:='Rsh';
 FPNs:=3;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='V';
 FPName[1]:='I';
 FPName[2]:='T';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 ReadValue;
 FCaption:='Diod function, Lambert function fitting';
 SetLength(FDodXname,1);
 SetLength(FDodX,1);
 FDodXname[0]:='Fb'; 
end;

Function TDiodLam.FinalFunc(X:double;Variab:TArrSingle):double;
begin
 Result:=LambertAprShot(X,Variab[0]*Kb*FParam[2],Variab[1],
                 Variab[2],Variab[3]);
end;

Procedure TDiodLam.DodParDetermination(V: PVector; Variab:TArrSingle);
begin
FDodX[0]:=555;
if (FSzr<>0)and(FSzr<>555)and(FArich<>0)and(FArich<>555) then
   FDodX[0]:=Kb*FParam[2]*ln(FSzr*FArich*sqr(FParam[2])/Variab[2]);
end;

Constructor TPhotoDiodLam.Create;
begin
 inherited Create(5);
 FName:='PhotoDiodLam';
 FXname[0]:='n';
 FXname[1]:='Rs';
 FXname[2]:='Io';
 FXname[3]:='Rsh';
 FXname[4]:='Iph';
 FPNs:=3;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='V';
 FPName[1]:='I';
 FPName[2]:='T';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 FPEst:=1;
 FCaption:='Function of lightened diod, Lambert function fitting';
 SetLength(FDodXname,4);
 SetLength(FDodX,4);
 FDodXname[0]:='Voc';
 FDodXname[1]:='Isc';
 FDodXname[2]:='Pm';
 FDodXname[3]:='FF';
 ReadValue;
 FDbool:=True;
end;




Function TPhotoDiodLam.FinalFunc(X:double;Variab:TArrSingle):double;
begin
 Result:=LambertLightAprShot(X,Variab[0]*Kb*FParam[2],Variab[1],
                 Variab[2],Variab[3],Variab[4])
end;

Procedure TPhotoDiodLam.DodParDetermination(V: PVector; Variab:TArrSingle);
begin
FDodX[0]:=555;
FDodX[1]:=555;
FDodX[2]:=555;
FDodX[3]:=555;
if (Variab[4]>1e-7) then
   begin
    FDodX[0]:=Voc_Isc_Pm(1,V,Variab[0],Variab[1],Variab[2],Variab[3],Variab[4]);
    FDodX[1]:=Voc_Isc_Pm(2,V,Variab[0],Variab[1],Variab[2],Variab[3],Variab[4]);
   end;
if (FDodX[0]>0.002)and(FDodX[1]>1e-7)and(FDodX[0]<>555)and(FDodX[1]<>555) then
    FDodX[2]:=Voc_Isc_Pm(3,V,Variab[0],Variab[1],Variab[2],Variab[3],Variab[4]);
if (FDodX[0]<>0)and(FDodX[0]<>555)and(FDodX[1]<>0)and(FDodX[1]<>555) then
   FDodX[3]:=FDodX[2]/FDodX[0]/FDodX[1];
end;



Procedure TFitFunctionLSM.ReadValue;
var ConfigFile:TOIniFile;
    i:byte;
    str:string;
begin
 ConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
 try
 str:='';
 for I := 0 to High(FPname) do
  str:=str+FPname[i]+'*';
 ConfigFile.WriteString(FName,'Pnames',str);
 FIsReady:=true;
 FXmaxlim[0]:=ConfigFile.ReadFloat(FName,'eps',555);
 FIsReady:=FIsReady and (FXmaxlim[0]<>555);
 for I := 0 to High(FXname) do
   begin
    FXmode[i]:=ConfigFile.ReadRand(FName,FXname[i]+'Mode');
    FA[i]:=ConfigFile.ReadFloat(FName,FXname[i]+'A',555);
    FB[i]:=ConfigFile.ReadFloat(FName,FXname[i]+'B',555);
    FC[i]:=ConfigFile.ReadFloat(FName,FXname[i]+'C',555);
    FXt[i]:=ConfigFile.ReadInteger(FName,FXname[i]+'tt',0);
    if FXmode[i]=cons then
      begin
        if not(FXt[i]in[0,2..(FPNs-1),(FPNs+2)..(2*FPNs-1)]) then FIsready:=False;
        if ((FXt[i]=0) and (FA[i]=555)) then FIsready:=False;
        if ((FXt[i]in[2..(FPNs-1),(FPNs+2)..(2*FPNs-1)])
             and(FA[i]=555)and(FC[i]=555)and(FB[i]=555)) then FIsready:=False;
      end;
   end;
Nit:=ConfigFile.ReadInteger(FName,'Nit',555);
FIsready:=FIsready and (Nit<>555);
 for I := 0 to High(FPname)-2 do
 begin
  FPbool[i]:=ConfigFile.ReadBool(FName,FPname[i+2]+'Bool',False);
  FPValue[i]:=ConfigFile.ReadFloat(FName,FPname[i+2]+'Val',555);
  if ((FPbool[i])and(FPValue[i]=555)) then FIsready:=False;
 end;
 except
  FIsReady:=False;
 end;
 FSzr:=ConfigFile.ReadFloat('Parameters','Square',3.14e-6);
 FArich:=ConfigFile.ReadFloat('Parameters','RichConst',1.12e6);
ConfigFile.Free;
end;

Procedure TFitFunctionLSM.WriteValue;
var ConfigFile:TOIniFile;
    i:byte;
begin
if not(IsReady) then Exit;
 ConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
 ConfigFile.WriteFloat(FName,'eps',FXmaxlim[0]);
 for I := 0 to High(FXname) do
   begin
    ConfigFile.WriteRand(FName,FXname[i]+'Mode',FXmode[i]);
    ConfigFile.WriteFloat(FName,FXname[i]+'A',FA[i]);
    ConfigFile.WriteFloat(FName,FXname[i]+'B',FB[i]);
    ConfigFile.WriteFloat(FName,FXname[i]+'C',FC[i]);
    ConfigFile.WriteInteger(FName,FXname[i]+'tt',FXt[i]);
   end;
for I := 0 to High(FPname)-2 do
 begin
  ConfigFile.WriteBool(FName,FPname[i+2]+'Bool',FPbool[i]);
  ConfigFile.WriteFloat(FName,FPname[i+2]+'Val',FPValue[i]);
 end;
ConfigFile.WriteInteger(FName,'Nit',Nit);
ConfigFile.Free;
end;

Procedure TFitFunctionLSM.SetValueGR;
const PaddingTop=120;
      PaddingBetween=5;
      PaddingLeft=50;
var Form:TForm;
    Pan:array of TFrApprP;
    Buttons:TFrBut;
    Niter,Acur:TLabeledEdit;
    Img:TImage;
    i:integer;
    ConfigFile:TOIniFile;
begin
 ConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
 Form:=Tform.Create(Application);
 Form.Name:=Fname;
 Form.Position:=poMainFormCenter;
 Form.AutoScroll:=True;
 Form.BorderIcons:=[biSystemMenu];
 Form.Caption:=FName+' function '+', parameters';
 Form.Font.Name:='Tahoma';
 Form.Font.Size:=8;
 Form.Font.Style:=[fsBold];
 Form.Color:=RGB(222,254,233);

 Img:=TImage.Create(Form);
 Img.Parent:=Form;
 Img.Top:=10;
 Img.Left:=10;
 Img.Height:=60;
 Img.Width:=450;
 Img.Stretch:=True;
 PictLoadScale(Img,FName+'Fig');


 SetLength(Pan,FNs);
 for I := 0 to FNs - 1 do
  begin
  Pan[i]:=TFrApprP.Create(Form);
  Pan[i].Name:=FXname[i];
  Pan[i].Parent:=Form;
  Pan[i].Left:=80;
  Pan[i].Top:=PaddingTop+i*(Pan[i].Panel1.Height+PaddingBetween);
  Pan[i].LName.Caption:=FXname[i];
  Pan[i].GBoxInit.Visible:=False;
  Pan[i].GBoxLim.Visible:=False;
  Pan[i].RBLogar.Visible:=False;
  Pan[i].RBNorm.Caption:='Variated';
  Pan[i].GBoxMode.Left:=Pan[i].GBoxInit.Left;
  Pan[i].Panel1.Width:=Pan[i].GBoxMode.Left+Pan[i].GBoxMode.Width+30;
  Pan[i].Width:=Pan[i].Panel1.Width+2;

  case ConfigFile.ReadRand(FName,FXname[i]+'Mode') of
       lin:  Pan[i].RBNorm.Checked:=True;
       else  Pan[i].RBCons.Checked:=True;
       end;
  end;
  if Fname='PhotoDiodLam' then
     begin
       Pan[2].Enabled:=False;
       Pan[4].Enabled:=False;
     end;


 Niter:=TLabeledEdit.Create(Form);
 Niter.Parent:=Form;
 Niter.Left:=65;
 Niter.Top:=85;
 Niter.LabelPosition:=lpLeft;
 Niter.EditLabel.Width:=40;
 Niter.EditLabel.WordWrap:=True;
 Niter.EditLabel.Caption:='Iteration number';
 Niter.Width:=50;
 Niter.OnKeyPress:=Pan[0].minIn.OnKeyPress;
 Niter.Text:=ValueToStr555(ConfigFile.ReadInteger(FName,'Nit',555));

 Acur:=TLabeledEdit.Create(Form);
 Acur.Parent:=Form;
 Acur.Left:=250;
 Acur.Top:=85;
 Acur.LabelPosition:=lpLeft;
 Acur.EditLabel.Width:=40;
 Acur.EditLabel.WordWrap:=True;
 Acur.EditLabel.Caption:='Accuracy';
 Acur.Width:=50;
 Acur.OnKeyPress:=Pan[0].minIn.OnKeyPress;
 Acur.Text:=ValueToStr555(ConfigFile.ReadFloat(FName,'eps',555));


 Buttons:=TFrBut.Create(Form);
 Buttons.Parent:=Form;
 Buttons.Left:=20;
 Buttons.Top:=PaddingTop+FNs*(Pan[0].Panel1.Height+PaddingBetween);


 Form.Height:=FNs*(Pan[0].Panel1.Height+PaddingBetween)+PaddingTop+
               Buttons.Height+50;

 Form.Width:=max(Pan[0].Panel1.Left+Pan[0].Panel1.Width,Img.Left+Img.Width)+PaddingLeft;
// Form.Width:=Img.Left+Img.Width+10;

 ConfigFile.Free;

 if Form.ShowModal=mrOk then
  begin
      ConfigFile:=TOIniFile.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');
      ConfigFile.WriteInteger(FName,'Nit',StrToInt555(Niter.Text));
      ConfigFile.WriteFloat(FName,'eps',StrToFloat555(Acur.Text));

      for I := 0 to FNs - 1 do
        begin
          if Pan[i].RBNorm.Checked then ConfigFile.WriteRand(FName,FXname[i]+'Mode',lin);
          if Pan[i].RBCons.Checked then  ConfigFile.WriteRand(FName,FXname[i]+'Mode',cons);
        end;  //for I := 0 to FNs - 1 do
       ConfigFile.Free;
  end;// if Form.ShowModal=mrOk then

 ReadValue;

 for I := 0 to FNs - 1 do
  begin
  Pan[i].Parent:=nil;
  Pan[i].Free;
  end;

 Buttons.Parent:=nil;
 Buttons.Free;
 Acur.Parent:=nil;
 Acur.Free;
 Niter.Parent:=nil;
 Niter.Free;
 Img.Parent:=nil;
 Img.Free;

 Form.Hide;
 Form.Release;
end;


Function TFitFunctionLSM.Func(Variab:TArrSingle):double;
begin
  Result:=555;
end;

procedure TFitFunctionLSM.BeforeFitness(AP:Pvector);
var i:byte;
begin
inherited;
for I := 0 to High(FXmode) do
  begin
    if (FXname[i]='Rs')and(FXvalue[i]<=1e-4) then FXvalue[i]:=1e-4;
    if (FXname[i]='Rsh')and((FXvalue[i]>=1e12)or(FXvalue[i]<=0))
       then FXvalue[i]:=1e12;
    if (FXname[i]='n')and(FXvalue[i]<=0) then FXvalue[i]:=1;
  end;
FParam[2]:=AP^.T;  
end;


Constructor TDiodLSM.Create;
begin
 inherited Create(4);
 FName:='DiodLSM';
 FXname[0]:='n';
 FXname[1]:='Rs';
 FXname[2]:='Io';
 FXname[3]:='Rsh';
 FPNs:=3;
 SetLength(FParam,FPNs);
 SetLength(FPname,FPNs);
 FPName[0]:='V';
 FPName[1]:='I';
 FPName[2]:='T';
 SetLength(FPbool,FPNs-2);
 SetLength(FPValue,FPNs-2);
 ReadValue;
 FCaption:='Diod function, least-squares fitting';
 SetLength(FDodXname,1);
 SetLength(FDodX,1);
 FDodXname[0]:='Fb';
end;

Function TDiodLSM.FinalFunc(X:double;Variab:TArrSingle):double;
begin
 Result:=Full_IV(X,Variab[0]*Kb*FParam[2],Variab[1],
                 Variab[2],Variab[3],0);
end;

Procedure TDiodLSM.DodParDetermination(V: PVector; Variab:TArrSingle);
begin
FDodX[0]:=555;
if (FSzr<>0)and(FSzr<>555)and(FArich<>0)and(FArich<>555) then
   FDodX[0]:=Kb*FParam[2]*ln(FSzr*FArich*sqr(FParam[2])/Variab[2]);
end;

Function TFitFunction.EvFitPreparation(V:PVector;var Param:TArrSingle;
                          str:string; var Nit:integer):boolean;
{виконується на початку еволюційної апроксимації,
перевіряється готовність функції,
встановлюється параметри вікна,
зануляється кількість ітерацій;
якщо все добре - повертається False
}
begin
Result:=True;
SetLength(Param,1);
Param[0]:=555;
if not(IsReady) then SetValueGR;
if not(IsReady) then
   begin
   MessageDlg('Approximation is imposible.'+#10+#13+
                'Parameters of function are undefined', mtError,[mbOk],0);
   Exit;
   end;
//if V^.n<7 then
//   begin
//   MessageDlg('Approximation is imposible.'+#10+#13+
//                'The lack of points', mtError,[mbOk],0);
//   Exit;
//   end;
Nit:=0;
WindowPrepare;
App.Caption:=str;
if V^.name<>'' then App.Caption:=App.Caption+', '+V^.name;
BeforeFitness(V);
Result:=False;
end;

Procedure  TFitFunction.EvFitInit(V:PVector;var X:TArrArrSingle; var Fit:TArrSingle);
{початкове встановлення випадкових
значень в Х та розрахунок початкових
величин цільової функції}
var i:integer;
begin
i:=0;
repeat  //початкові випадкові значення
 if (i mod 25)=0 then Randomize;
   VarRand(X[i]);
   try
    Fit[i]:=FitnessFunc(V,X[i])
   except
    Continue;
   end;
  inc(i);
until (i>High(X));
App.Show;
end;

Procedure TFitFunction.EvFitShow(X:TArrArrSingle;
            Fit:TArrSingle; Nit,Nshow:integer);
{проводить зміну значень на вікні
під час еволюційної апроксимації,
якщо Nit кратна Nshow}
var j:integer;
begin
  if (Nit mod Nshow)=0 then
     begin
      j:=MinElemNumber(Fit);
      WindowDataShow(Nit,X[j]);
      Application.ProcessMessages;
     end;
end;

Procedure TFitFunction.EvFitEnding(Fit:TArrSingle;
             X:TArrArrSingle; var Param:TArrSingle);
{виконується наприкінці еволюційної апроксимації,
очищається вікно,
записуються отримані результати в Param}
var j,k:integer;
begin
if App.Visible then
  begin
    j:=MinElemNumber(Fit);
    SetLength(Param,Ns);
    for k := 0 to Ns-1 do
       Param[k]:=X[j,k];
   end;
WindowClear;
App.Close;
end;

Procedure TFitFunction.MABCFit (V:PVector; {F:TFitFunction; }var Param:TArrSingle);
{апроксимуються дані у векторі V за методом modified artificial bee colony;
F визначає апроксимуючу функцію,
результати апроксимації вносяться в Param}
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
     for k := 0 to Ns - 1 do
      case Xmode[k] of
        lin:Xnew[k]:=X[i,k]+r*(X[i,k]-X[j,k]);
        logar:
          begin
          temp:=ln(X[i,k])+r*(ln(X[i,k])-ln(X[j,k]));;
//          if temp > 88 then goto NewSLabel;
          Xnew[k]:=exp(temp);
          end;
       cons:Xnew[k]:=XValue[k];
      end;//case Xmode[k] of
   PenaltyFun(Xnew);
   bool:=False;
   try
    FitMut[i]:=FitnessFunc(V,Xnew)
   except
    bool:=True
   end;
   if bool then goto NewSLabel;
 end; // NewSolution



begin

if EvFitPreparation(V,Param,
   'Modified Artificial Bee Colony',Nitt) then Exit;


Limit:=36;
Np:=Ns*8;
SetLength(X,Np,Ns);
SetLength(Fit,Np);
SetLength(Count,Np);
SetLength(FitMut,Np);
SetLength(Xnew,Ns);

for i:=0 to High(X) do  Count[i]:=0;

//QueryPerformanceCounter(StartValue);

EvFitInit(V,X,Fit);
try
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
      Fit[i]:=FitnessFunc(V,X[i])
     except
      Continue;
     end;
     Count[i]:=0;
    end;// if Count[i]>Limit then
    inc(i);
    until i>(Np-1);//scout

EvFitShow(X,Fit,Nitt,100);

inc(Nitt);
until (Nitt>Nit)or not(App.Visible);

//QueryPerformanceCounter(EndValue);
//QueryPerformanceFrequency(Freq);
//showmessage('tics='+inttostr(EndValue-StartValue)+#10+#13+
//             'time='+floattostr((EndValue-StartValue)/Freq)
//             +' s'+#10+#13+
//                'freq+'+inttostr(Freq));


finally
EvFitEnding(Fit,X,Param);
end;//try
end;

Procedure TFitFunction.PSOFit (V:PVector; var Param:TArrSingle);
{апроксимуються дані у векторі V за методом
particle swarm optimization;
F визначає апроксимуючу функцію,
результати апроксимації вносяться в Param}
const
      C1=2;
      C2=2;
      Wmax=0.9;
      Wmin=0.4;

var LocBestFit,VelArhiv,XArhiv:TArrSingle;
    Np,i,j,Nitt,GlobBestNumb:integer;
    X,Vel,LocBestPar:TArrArrSingle;
    W,temp:double;
  k: Integer;

begin
if EvFitPreparation(V,Param,
   'Particle Swarm Optimization',Nitt) then Exit;

try
Np:=Ns*15;
SetLength(X,Np);
SetLength(LocBestFit,Np);
SetLength(LocBestPar,Np,Ns);
SetLength(VelArhiv,Ns);
SetLength(XArhiv,Ns);


//QueryPerformanceCounter(StartValue);
{початкові значення координат}
EvFitInit(V,X,LocBestFit);
GlobBestNumb:=MinElemNumber(LocBestFit);
for I := 0 to High(X) do
     LocBestPar[i]:=Copy(X[i]);

{початкові значення швидкостей}
SetLength(Vel,Np,Ns);
for I := 0 to Np-1 do
  for j:= 0 to Ns-1 do
        Vel[i,j]:=0;

k:=0;
repeat
  temp:=0;
  W:=Wmax-(Wmax-Wmin)*Nitt/Nit;
  i:=0;
   repeat

    if (i mod 25)=0 then Randomize;
    VelArhiv:=Copy(Vel[i]);
    XArhiv:=Copy(X[i]);
    for j := 0 to Ns - 1 do
    case Xmode[j] of
      lin:VelArhiv[j]:=W*VelArhiv[j]+C1*Random*(LocBestPar[i,j]-X[i,j])+
                   C2*Random*(LocBestPar[GlobBestNumb,j]-X[i,j]);
      logar:
          begin
          VelArhiv[j]:=W*VelArhiv[j]+C1*Random*(ln(LocBestPar[i,j])-ln(X[i,j]))+
                   C2*Random*(ln(LocBestPar[GlobBestNumb,j])-ln(X[i,j]));
          end;
      end; //case Xmode[j] of

    for j := 0 to Ns - 1 do
     case Xmode[j] of
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
            end;
         end;
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
            end;
           XArhiv[j]:=exp(XArhiv[j]);
        end; //logar:
      end;//case Xmode[j] of

   try
    temp:=FitnessFunc(V,XArhiv)
   except
   inc(k);
   if k>20 then
     VarRand(X[i]);
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
until (Nitt>Nit)or not(App.Visible);

//QueryPerformanceCounter(EndValue);
//QueryPerformanceFrequency(Freq);
//showmessage('tics='+inttostr(EndValue-StartValue)+#10+#13+
//             'time='+floattostr((EndValue-StartValue)/Freq)
//             +' s'+#10+#13+
//                'freq+'+inttostr(Freq));


finally
EvFitEnding(LocBestFit,LocBestPar,Param);
//str1.Free;
end;//try
end;




Procedure TFitFunction.DEFit (V:PVector; {Fu:TFitFunction;} var Param:TArrSingle);
{апроксимуються дані у векторі V за методом
differential evolution;
F визначає апроксимуючу функцію,
результати апроксимації вносяться в Param}

const
      F=0.8;
      CR=0.3;
 Label
   MutLabel;

var Fit,FitMut:TArrSingle;
    Np,i,j,Nitt,k:integer;
    X,Mut:TArrArrSingle;
    r:array [1..3] of integer;
    temp:double;


begin
if EvFitPreparation(V,Param,
   'Differential Evolution',Nitt) then Exit;

Np:=Ns*8;
SetLength(X,Np,Ns);
SetLength(Mut,Np,Ns);
SetLength(Fit,Np);
SetLength(FitMut,Np);

//QueryPerformanceCounter(StartValue);

EvFitInit(V,X,Fit);

try
repeat
   i:=0;

   repeat  //Вектор мутації
   if (i mod 25)=0 then Randomize;
Mutlabel:
     for j := 1 to 3 do
         repeat
         r[j]:=Random(Np);
         until (r[j]<>i);
     for k := 0 to Ns - 1 do
      case Xmode[k] of
        lin:Mut[i,k]:=X[r[1],k]+F*(X[r[2],k]-X[r[3],k]);
        logar:
          begin
          temp:=ln(X[r[1],k])+F*(ln(X[r[2],k])-ln(X[r[3],k]));;
//          if temp > 88 then goto Mutlabel;
          Mut[i,k]:=exp(temp);
          end;
       cons:Mut[i,k]:=Xvalue[k];
      end;//case Xmode[k] of


   PenaltyFun(Mut[i]);
   try
    FitnessFunc(V,Mut[i])
   except
    Continue;
   end;
    inc(i);
   until (i>High(Mut));  //Вектор мутації

   i:=0;
   repeat  //Пробні вектори
     if (i mod 25)=0 then Randomize;
     r[2]:=Random(Ns); //randn(i)
     for k := 0 to Ns - 1 do
      case Xmode[k] of
        lin,logar:
          if (Random>CR) and (k<>r[2]) then Mut[i,k]:=X[i,k];
      end;//case Xmode[k] of
     PenaltyFun(Mut[i]);
     try
      FitMut[i]:=FitnessFunc(V,Mut[i])
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
until (Nitt>Nit)or not(App.Visible);


//QueryPerformanceCounter(EndValue);
//QueryPerformanceFrequency(Freq);
//showmessage('tics='+inttostr(EndValue-StartValue)+#10+#13+
//             'time='+floattostr((EndValue-StartValue)/Freq)
//             +' s'+#10+#13+
//                'freq+'+inttostr(Freq));

finally
EvFitEnding(Fit,X,Param);
end;//try
end;

Procedure TFitFunction.TLBOFit (V:PVector; {F:TFitFunction;} var Param:TArrSingle);
{апроксимуються дані у векторі V за методом
teaching learning based optimization;
F визначає апроксимуючу функцію,
результати апроксимації вносяться в Param}

label TeachLabel,LeanLabel;
var X:PClassroom;
    Fit:PTArrSingle;
    Xmean,Xnew:TArrSingle;
    i,j,Nitt,Tf,k,Nl:integer;
    temp,r:double;

begin
if EvFitPreparation(V,Param,
   'Teaching Learning Based Optimization',Nitt) then Exit;

Nl:=1000;
SetLength(Xmean,Ns);
SetLength(Xnew,Ns);

new(X);
SetLength(X^,Nl,Ns);
new(Fit);
SetLength(Fit^,Nl);

//QueryPerformanceCounter(StartValue);

EvFitInit(V,X^,Fit^);
try
temp:=1e10;
repeat

//----------Teacher phase--------------
    for I := 0 to High(Xmean) do Xmean[i]:=0;
//    j:=MinElemNumber(Fit^);
    j:=MaxElemNumber(Fit^);

    for I := 0 to Nl-1 do
        begin
         for k := 0 to Ns - 1 do
          case Xmode[k] of
            lin:Xmean[k]:=Xmean[k]+X^[i,k];
            logar:Xmean[k]:=Xmean[k]+ln(X^[i,k]);
          end;
       end;  //for I := 0 to Nl-1 do

   for k := 0 to Ns - 1 do
     case Xmode[k] of
       lin,logar:Xmean[k]:=Xmean[k]/Nl;
       cons:Xmean[k]:=Xvalue[k];
      end;

  i:=0;
 repeat
   if (i mod 25)=0 then Randomize;
TeachLabel:
    if i=j then
      begin
        inc(i);
        Continue;
      end;

    r:=Random;
    Tf:=1+Random(2);
   for k := 0 to Ns - 1 do
     case Xmode[k] of
       lin:Xnew[k]:=X^[i,k]+r*(X^[j,k]-Tf*Xmean[k]);
       logar:
          begin
          temp:=ln(X^[i,k])+r*(ln(X^[j,k])-Tf*Xmean[k]);
//          if temp > 88 then goto TeachLabel;
          Xnew[k]:=exp(temp);
          end;
       cons:Xnew[k]:=Xvalue[k];
      end;

    PenaltyFun(Xnew);
   try
    temp:=FitnessFunc(V,Xnew)
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
LeanLabel:
    r:=Random;
    repeat
    Tf:=Random(Nl);
    until (Tf<>i);

    if Fit^[i]>Fit^[Tf] then r:=-1*r;

   for k := 0 to Ns - 1 do
     case Xmode[k] of
       lin:Xnew[k]:=X^[i,k]+r*(X^[i,k]-X^[Tf,k]);
       logar:
          begin
          temp:=ln(X^[i,k])+r*(ln(X^[j,k])-ln(X^[Tf,k]));
//          if temp > 88 then goto LeanLabel;
          Xnew[k]:=exp(temp);
          end;
       cons:Xnew[k]:=Xvalue[k];
      end;//case

     PenaltyFun(Xnew);
   try
    temp:=FitnessFunc(V,Xnew)
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
until (Nitt>Nit)or not(App.Visible);

//QueryPerformanceCounter(EndValue);
//QueryPerformanceFrequency(Freq);
//showmessage('tics='+inttostr(EndValue-StartValue)+#10+#13+
//             'time='+floattostr((EndValue-StartValue)/Freq)
//             +' s'+#10+#13+
//                'freq+'+inttostr(Freq));


finally
EvFitEnding(Fit^,X^,Param);
dispose(X);
dispose(Fit);
end;//try
end;


Procedure TFitFunction.Fitting (V:PVector; var Param:TArrSingle);
{апроксимуються дані у векторі V, отримані параметри
розміщуються в Param;
при невдалому процесі -  показується повідомлення,
в Param[0] - 555;
загалом розмір Param  після процедури співпадає з кількістю
параметрів;
для базового типу - викликається один з типів
еволюційної апроксимації залежно від значення FEvType}
begin
  case EvType of
    TMABC:MABCFit (V,Param);
    TTLBO:TLBOFit (V,Param);
    TPSO: PSOFit (V,Param);
    else DEFit (V,Param);
  end;
DodParDetermination(V,Param);
end;

Procedure TFitFunction.Fitting (Xlog,Ylog:boolean; V:PVector; var Param:TArrSingle);
{дає можливість апроксимувати дані у векторі V,
розглануті у логарифмічному масштабі
Xlog = True - використовується логарифм абсцис,
Ylog = True - використовується логарифм ординат
}
var i:integer;
    tempV:Pvector;

begin
 SetLength(Param,FNs);
 Param[0]:=555;
 new(tempV);
 try
  SetLenVector(tempV,V^.n);
  for i := 0 to High(tempV^.X)do
  begin
    if XLog then tempV^.X[i]:=Log10(V^.X[i])
            else tempV^.X[i]:=V^.X[i];
    if YLog then tempV^.Y[i]:=Log10(V^.Y[i])
            else tempV^.Y[i]:=V^.Y[i];
  end;
  Fitting(tempV,Param);
 finally
  dispose(tempV);
 end;//try
DodParDetermination(V,Param);
end;

Procedure TLinear.Fitting (V:PVector; var Param:TArrSingle);
{апроксимуються дані у векторі V, отримані параметри
розміщуються в Param;
при невдалому процесі -  показується повідомлення,
в Param[0] - 555;
загалом розмір Param  після процедури співпадає з кількістю
параметрів;
для базового типу - викликається один з типів
еволюційної апроксимації залежно від значення FEvType}
begin
  SetLength(Param,FNs);
  Param[0]:=555;
  try
//   Param[0]:=0;
//   LinAproxAconst(V,Param[0],Param[1]);
   LinAprox(V,Param[0],Param[1]);
  except
   MessageDlg('Approximation unseccessful', mtError,[mbOk],0)
  end;
end;


Procedure TQuadratic.Fitting (V:PVector; var Param:TArrSingle);
begin
  SetLength(Param,FNs);
  Param[0]:=555;
  try
   ParabAprox(V,Param[0],Param[1],Param[2]);
  except
   MessageDlg('Approximation unseccessful', mtError,[mbOk],0)
  end;
end;

Procedure TExponent.Fitting (V:PVector; var Par:TArrSingle);
begin
  SetLength(Par,FNs);
  Par[0]:=555;
  try
   BeforeFitness(V);
   ExKalk(V,FParam[4],FParam[3],Par[1],Par[0],Par[2]);
  except
   MessageDlg('Approximation unseccessful', mtError,[mbOk],0)
  end;
end;

Procedure TGromov.Fitting (V:PVector; var Param:TArrSingle);
begin
  SetLength(Param,FNs);
  Param[0]:=555;
  try
   GromovAprox(V,Param[0],Param[1],Param[2]);
  except
    MessageDlg('The approximation is imposible'+#10+
    '(may be some points have negative abscissa)', mtError, [mbOK], 0);
  end;
end;

Procedure TIvanov.Fitting (V:PVector; var Par:TArrSingle);
begin
  SetLength(Par,FNs);
  Par[0]:=555;
  try
   BeforeFitness(V);
   IvanovAprox(V,FArich,FSzr,Fparam[3],Fparam[4],Par[1],Par[0]);
  except
   MessageDlg('Approximation unseccessful', mtError,[mbOk],0)
  end;
end;


Procedure TFitFunction.FittingGraph (V:PVector; var Par:TArrSingle;Series: TLineSeries);
{апроксимація і дані вносяться в Series -
щоб можна було побудувати графік}
const Np=150; //кількість точок, по яким будується апроксимація
var h,x,y:double;
    i:integer;
begin
  Series.Clear;
  Fitting(V,Par);
  if Par[0]=555 then  Exit;
  h:=(V^.X[High(V^.X)]-V^.X[0])/Np;
  for I := 0 to Np do
    begin
    x:=V^.X[0]+i*h;
    y:=FinalFunc(x,Par);
    Series.AddXY(x, y);
    end;
end;

Procedure TFitFunction.FittingGraph (Xlog,Ylog:boolean; V:PVector;
           var Param:TArrSingle;Series: TLineSeries);
{апроксимація і дані вносяться в Series -
щоб можна було побудувати графік}
const Np=150; //кількість точок, по яким будується апроксимація
var h,x,y,xl:double;
    i:integer;
begin
  Fitting(Xlog,Ylog,V,Param);
  if Param[0]=555 then Exit;
  Series.Clear;
  h:=(V^.X[High(V^.X)]-V^.X[0])/Np;
  for I := 0 to Np do
    begin
    x:=V^.X[0]+i*h;
    if XLog then xl:=log10(x)
            else xl:=x;
    if YLog then y:=exp(FinalFunc(xl,Param)*ln(10))
            else y:=FinalFunc(xl,Param);
    Series.AddXY(x, y);
    end;
end;


Procedure TFitFunction.FittingGraphFile (V:PVector; var Param:TArrSingle;Series: TLineSeries);
{апроксимація, дані вносяться в Series, крім
того апроксимуюча крива заноситься в файл -
третім стопчиком як правило;
назва файлу -- V^.name + 'fit'}
var Str1:TStringList;
    i:integer;
    st:string;
begin
  FittingGraph(V,Param,Series);
  if Param[0]=555 then Exit;

  Str1:=TStringList.Create;
  for I := 0 to High(V^.X) do
   Str1.Add(FloatToStrF(V^.X[i],ffExponent,4,0)+' '+
           FloatToStrF(V^.Y[i],ffExponent,4,0)+' '+
           FloatToStrF(FinalFunc(V^.X[i],Param),ffExponent,4,0));
  FitName(st, V);
  Str1.SaveToFile(st);

//  str1.Clear;
//  for I := 0 to Series.Count-1 do
//   Str1.Add(FloatToStrF(Series.XValue[i],ffExponent,4,0)+' '+
//           FloatToStrF(Series.YValue[i],ffExponent,4,0));
//  Str1.SaveToFile(V^.name+'f');

  Str1.Free;

end;

Procedure TFitFunction.FittingDiapazon (V:PVector; var Param:TArrSingle; D:Diapazon);
{апроксимуються дані у векторі V відповідно до обмежень
в D, отримані параметри розміщуються в Param}
var temp1:Pvector;
begin
if (D.YMin=555) or (D.YMin<=0) then D.YMin:=0;
if (D.XMin=555) then D.XMin:=0.001;
new(temp1);
A_B_Diapazon(FDbool,V,temp1,D);
Fitting(temp1,Param);
dispose(temp1);
end;

Function TFitFunction.Deviation (V:PVector):double;
{повертає середнеє значення відхилення апроксимації
даних V від самих даних}
//Procedure Fitting (V:PVector; var Param:TArrSingle);
var Param:TArrSingle;
    i:integer;
begin
Result:=555;
Fitting (V,Param);
if Param[0]=555 then Exit;
Result:=0;
for I := 0 to High(V^.X) do
  Result:=Result+sqr((V^.Y[i]-FinalFunc(V^.X[i],Param))/V^.Y[i]);
Result:=sqrt(Result)/V^.n;
end;

Procedure TFitFunction.FittingGraphFile (Xlog,Ylog:boolean; V:PVector;
            var Param:TArrSingle;Series: TLineSeries);
{апроксимація, дані вносяться в Series, крім
того апроксимуюча крива заноситься в файл -
третім стопчиком як правило;
назва файлу -- V^.name + 'fit'}
var Str1:TStringList;
    i:integer;
    st:string;
    xl:double;
begin
  FittingGraph(Xlog,Ylog,V,Param,Series);
  if Param[0]=555 then Exit;

  Str1:=TStringList.Create;
  for I := 0 to High(V^.X) do
   begin
   st:=FloatToStrF(V^.X[i],ffExponent,4,0)+' '+
           FloatToStrF(V^.Y[i],ffExponent,4,0)+' ';
   if XLog then xl:=log10(V^.X[i])
            else xl:=V^.X[i];
   if YLog then st:=st+FloatToStrF(exp(FinalFunc(xl,Param)*ln(10)),ffExponent,4,0)
            else st:=st+FloatToStrF(FinalFunc(xl,Param),ffExponent,4,0);
   Str1.Add(st);
   end;
  FitName(st, V);
  Str1.SaveToFile(st);
  Str1.Free;
end;

procedure TFitFunction.FitName(var st: string; V: PVector);
begin
  if V^.name = '' then
    st := 'fit.dat'
  else
  begin
    st := V^.name;
    Insert('fit', st, Pos('.', st));
  end;
end;

procedure TFitFunction.DodParDetermination(V: PVector; Variab:TArrSingle);
{розраховуються додаткові параметри}
begin

end;

Procedure TSmoothing.FittingGraph (V:PVector; var Param:TArrSingle;Series: TLineSeries);
{апроксимація і дані вносяться в Series -
щоб можна було побудувати графік}
var  tempV:PVector;
     i:integer;
begin
  SetLength(Param,1);
  Param[0]:=555;
  new(tempV);
  Smoothing (V,tempV);
  if tempV^.n=0 then
        begin
          MessageDlg('The smoothing is imposible,'+#10+
          'the points" quantity is very low', mtError, [mbOK], 0);
          dispose(tempV);
          Exit;
        end;
   Series.Clear;
   for I := 0 to High(tempV^.X) do
     Series.AddXY(tempV^.X[i],tempV^.Y[i]);
  Param[0]:=1;
  dispose(tempV);
end;


Procedure TSmoothing.FittingGraphFile (V:PVector; var Param:TArrSingle;Series: TLineSeries);
{апроксимація, дані вносяться в Series, крім
того апроксимуюча крива заноситься в файл -
третім стопчиком як правило;
назва файлу -- V^.name + 'fit'}
var Str1:TStringList;
    tempV:PVector;
    i:integer;
    st:string;
begin
  SetLength(Param,1);
  Param[0]:=555;
  new(tempV);
  Str1:=TStringList.Create;
  Smoothing (V,tempV);
  if tempV^.n=0 then
        begin
          MessageDlg('The smoothing is imposible,'+#10+
          'the points" quantity is very low', mtError, [mbOK], 0);
          dispose(tempV);
          Str1.Free;
          Exit;
        end;
   Series.Clear;
   for I := 0 to High(tempV^.X) do
     begin
     Series.AddXY(tempV^.X[i],tempV^.Y[i]);
     Str1.Add(FloatToStrF(V^.X[i],ffExponent,4,0)+' '+
           FloatToStrF(V^.Y[i],ffExponent,4,0)+' '+
           FloatToStrF(tempV^.Y[i],ffExponent,4,0));
     end;
   FitName(st, V);
   Str1.SaveToFile(st);
  Param[0]:=1;
  dispose(tempV);
  Str1.Free;
end;

Procedure TMedian.FittingGraph (V:PVector; var Param:TArrSingle;Series: TLineSeries);
{апроксимація і дані вносяться в Series -
щоб можна було побудувати графік}
var  tempV:PVector;
     i:integer;
begin
  SetLength(Param,1);
  Param[0]:=555;
  new(tempV);
  Median (V,tempV);
  if tempV^.n=0 then
        begin
          MessageDlg('The median filter"s using is imposible,'+#10+
          'the points" quantity is very low', mtError, [mbOK], 0);
          dispose(tempV);
          Exit;
        end;
  Series.Clear;
  for I := 0 to High(tempV^.X) do
     Series.AddXY(tempV^.X[i],tempV^.Y[i]);
  dispose(tempV);
  Param[0]:=1;
  dispose(tempV);
end;


Procedure TMedian.FittingGraphFile (V:PVector; var Param:TArrSingle;Series: TLineSeries);
{апроксимація, дані вносяться в Series, крім
того апроксимуюча крива заноситься в файл -
третім стопчиком як правило;
назва файлу -- V^.name + 'fit'}
var Str1:TStringList;
    tempV:PVector;
    i:integer;
    st:string;
begin
  SetLength(Param,1);
  Param[0]:=555;
  new(tempV);
  Str1:=TStringList.Create;
  Median (V,tempV);
  if tempV^.n=0 then
        begin
          MessageDlg('The median filter"s using is imposible,'+#10+
          'the points" quantity is very low', mtError, [mbOK], 0);
          dispose(tempV);
          Str1.Free;
          Exit;
        end;
  Series.Clear;
  for I := 0 to High(tempV^.X) do
     begin
     Series.AddXY(tempV^.X[i],tempV^.Y[i]);
     Str1.Add(FloatToStrF(V^.X[i],ffExponent,4,0)+' '+
           FloatToStrF(V^.Y[i],ffExponent,4,0)+' '+
           FloatToStrF(tempV^.Y[i],ffExponent,4,0));
     end;
  FitName(st, V);
  Str1.SaveToFile(st);
  Param[0]:=1;
  dispose(tempV);
  Str1.Free;
end;

Procedure TDerivative.FittingGraph (V:PVector; var Param:TArrSingle;Series: TLineSeries);
{апроксимація і дані вносяться в Series -
щоб можна було побудувати графік}
var  tempV:PVector;
     i:integer;
begin
  SetLength(Param,1);
  Param[0]:=555;
  new(tempV);
  Diferen (V,tempV);
  if tempV^.n=0 then
        begin
          MessageDlg('The smoothing is imposible,'+#10+
          'the points" quantity is very low', mtError, [mbOK], 0);
          dispose(tempV);
          Exit;
        end;
  Series.Clear;
  for I := 0 to High(tempV^.X) do
     Series.AddXY(tempV^.X[i],tempV^.Y[i]);
  Param[0]:=1;
  dispose(tempV);
end;


Procedure TDerivative.FittingGraphFile (V:PVector; var Param:TArrSingle;Series: TLineSeries);
{апроксимація, дані вносяться в Series, крім
того апроксимуюча крива заноситься в файл -
третім стопчиком як правило;
назва файлу -- V^.name + 'fit'}
var Str1:TStringList;
    tempV:PVector;
    i:integer;
    st:string;
begin
  SetLength(Param,1);
  Param[0]:=555;
  new(tempV);
  Str1:=TStringList.Create;
  Diferen (V,tempV);
  if tempV^.n=0 then
        begin
          MessageDlg('The smoothing is imposible,'+#10+
          'the points" quantity is very low', mtError, [mbOK], 0);
          dispose(tempV);
          Str1.Free;
          Exit;
        end;

  Series.Clear;
  for I := 0 to High(tempV^.X) do
    begin
     Series.AddXY(tempV^.X[i],tempV^.Y[i]);
     Str1.Add(FloatToStrF(V^.X[i],ffExponent,4,0)+' '+
           FloatToStrF(V^.Y[i],ffExponent,4,0)+' '+
           FloatToStrF(tempV^.Y[i],ffExponent,4,0));
    end;
  FitName(st, V);
  Str1.SaveToFile(st);
  Param[0]:=1;
  dispose(tempV);
  Str1.Free;
end;

Procedure TIvanov.FittingGraph (V:PVector; var Par:TArrSingle;Series: TLineSeries);
const Np=150; //кількість точок, по яким будується апроксимація
var h,x,y:double;
    i:integer;
begin
  Fitting(V,Par);
  if Par[0]=555 then Exit;
  Series.Clear;
  h:=(V^.X[High(V^.X)]-V^.X[0])/Np;
  for I := 0 to Np do
    begin
    x:=V^.X[0]+i*h;
    y:=FinalFunc(x,Par);
    Series.AddXY(x, y);
    end;
end;

Function LamLightParamIsBad(V:PVector;n0,Rs0,Rsh0,Isc0,Voc0:double):boolean;
{перевіряє чи параметри можна використовувати для
апроксимації ВАХ при освітленні в V функцію Ламверта}
var nkT,t1,t2:double;
begin
  Result:=true;
  if V^.T<=0 then Exit;
  nkT:=n0*Kb*V^.T;
  if n0<=0 then Exit;
  if Rs0<=0 then Exit;
  if Rsh0<=0 then Exit;
  if Isc0<=0 then Exit;
  if Voc0<=0 then Exit;
  if 2*(Voc0+Isc0*Rs0)/nkT > ln(1e308) then Exit;
  if exp(Voc0/nkT) = exp(Isc0*Rs0/nkT) then Exit;
  t1:=(Rs0*Isc0-Voc0)/nkT;
  if t1 > ln(1e308) then Exit;
  t2:=Rsh0*Rs0/nkT/(Rs0+Rsh0)*
      (Voc0/Rsh0+(Isc0+(Rs0*Isc0-Voc0)/Rsh0)/(1-exp(t1))+V^.X[V^.n-1]/Rs0);
  if abs(t2) > ln(1e308) then Exit;
  if Rs0/nkT*(Isc0-Voc0/(Rs0+Rsh0))*exp(-Voc0/nkT)*exp(t2)/(1-exp(t1))> ln(1e308)then Exit;
  Result:=false;
end;


Function ExpParamIsBad(V:PVector;n,Rs,I0,Rsh:double):boolean;overload;
{перевіряє чи параметри можна використовувати для
апроксимації даних в V функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh}
var bt:double;
    i:integer;
begin
  Result:=true;
  if V^.T<=0 then Exit;
  if n<=0 then Exit;
  bt:=2/kb/V^.T/n;

  if Rs<0 then Exit;
  if (I0<0) or (I0>1) then Exit;
  if Rsh<=1e-4 then Exit;
  for I := 0 to High(V^.X) do
    if bt*(V^.X[i]-Rs*V^.Y[i])>(700{+ln(abs(V^.Y[i]))}) then Exit;
  Result:=false;
end;

Function ExpParamIsBad(V:PVector;n,Rs,I0,Rsh,Iph:double):boolean;overload;
{перевіряє чи параметри можна використовувати для
апроксимації даних в V функцією
I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh-Iph-Iph}
begin
  Result:=ExpParamIsBad(V,n,Rs,I0,Rsh)or(Iph<1e-12)or(Iph>1);
end;


Function LamParamIsBad(V:PVector;n0,Rs0,I00,Rsh0:double):boolean;
{перевіряє чи параметри можна використовувати для
апроксимації даних в V функцією Ламверта}
var bt:double;
begin
  Result:=true;
  if V^.T<=0 then Exit;
  bt:=1/kb/V^.T;
  if n0<=0 then Exit;
  if Rs0<0 then Exit;
  if I00<0 then Exit;
  if Rsh0<0 then Exit;
  if bt/n0*(V^.X[V^.n-1]+Rs0*I00)>ln(1e308) then Exit;
  if bt*Rs0*I00/n0*exp(Kb*V^.T/n0*(V^.X[V^.n-1]+Rs0*I00))>ln(1e308)  then Exit;

  Result:=false;
end;



Function FG_LamShotA(AP:Pvector; Variab:TArrSingle;
                  RezF:TArrSingle;
                  var RezSum:double):word;
{функція для апроксимації ВАХ функцією Ламберта
за МНК; АР - виміряні точки;
Variab - значення параметрів, очікується, що
цей масив містить 4 значення, n, Rs, I0, Rsh;
RezF - значення функцій, отриманих як похідні
від квадратичної форми;
RezSum - значення квадратичної форми}
var i:integer;
    n, Rs, I0, Rsh,
    bt,Zi,Wi,F1s,
    I0Rs,nWi,ci,ZIi,s23,
    F2,F1:double;
begin


for I := 0 to High(RezF) do  RezF[i]:=555;
 RezSum:=555;
Result:=1;

n:=Variab[0];
Rs:=Variab[1];
I0:=Variab[2];
Rsh:=Variab[3];

if LamParamIsBad(AP,n,Rs,I0,Rsh) then Exit;
                    
bt:=1/kb/AP^.T;

for I := 0 to High(RezF) do  RezF[i]:=0;
  RezSum:=0;

I0Rs:=I0*Rs;
F2:=bt*I0Rs;
F1:=bt*Rs;

for I := 0 to High(AP^.X) do
   begin
     ci:=bt*(AP^.X[i]+I0Rs);
     Wi:=Lambert(bt*I0Rs/n*exp(ci/n));
     nWi:=n*Wi;
     Zi:=n/bt/Rs*Wi+AP^.X[i]/Rsh-I0-AP^.Y[i];
     ZIi:=Zi/abs(AP^.Y[i]);
     F1s:=F1*(Wi+1);
     s23:=(F2-nWi)/F1s;

   RezSum:=RezSum+ZIi*Zi;

   RezF[0]:=RezF[0]+ZIi*Wi*(nWi-ci)/F1s;
   RezF[1]:=RezF[1]+ZIi*Wi*s23;
   RezF[2]:=RezF[2]-ZIi*s23;
   RezF[3]:=RezF[3]-ZIi*AP^.X[i];
   end;

  for I := 0 to High(RezF) do RezF[i]:=RezF[i]*2;
  RezF[1]:=RezF[1]/n;
  RezF[2]:=RezF[2]/Rs;
  RezF[2]:=RezF[2]/I0;
  RezF[3]:=RezF[3]/Rsh/Rsh;
Result:=0;
end;

Function FG_ExpLightShotA(AP:Pvector; Variab:TArrSingle;
                  RezF:TArrSingle;
                  var RezSum:double):word;
{функція для апроксимації ВАХ
функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh-Iph
за МНК; АР - виміряні точки;
Variab - значення параметрів, очікується, що
цей масив містить 4 значення, n, Rs, I0, Rsh;
RezF - значення функцій, отриманих як похідні
від квадратичної форми;
RezSum - значення квадратичної форми}
var i:integer;
    n, Rs, I0, Rsh,Iph,
    Zi,ZIi,nkT,vi,ei,eiI0:double;
begin

for I := 0 to High(RezF) do  RezF[i]:=555;
 RezSum:=555;
Result:=1;

n:=Variab[0];
Rs:=Variab[1];
I0:=Variab[2];
Rsh:=Variab[3];
Iph:=Variab[4];

if ExpParamIsBad(AP,n,Rs,I0,Rsh) then Exit;

nkT:=n*kb*AP^.T;

for I := 0 to High(RezF) do  RezF[i]:=0;
  RezSum:=0;

for I := 0 to High(AP^.X) do
   begin
     vi:=(AP^.X[i]-AP^.Y[i]*Rs);
     ei:=exp(vi/nkT);
     Zi:=I0*(ei-1)+vi/Rsh-Iph-AP^.Y[i];
     ZIi:=Zi/abs(AP^.Y[i]);
     eiI0:=ei*I0/nkT;

   RezSum:=RezSum+ZIi*Zi;

   RezF[0]:=RezF[0]-ZIi*eiI0*vi;
   RezF[1]:=RezF[1]-Zi*(eiI0+1/Rsh);
   RezF[2]:=RezF[2]+ZIi*(ei-1);
   RezF[3]:=RezF[3]-ZIi*vi;
   RezF[4]:=RezF[4]-ZIi;
   end;

  for I := 0 to High(RezF) do RezF[i]:=RezF[i]*2;
  RezF[0]:=RezF[0]/n;
  RezF[3]:=RezF[3]/Rsh/Rsh;
Result:=0;
end;

Function FG_LamLightShotA(AP:Pvector; n,Rs,Rsh,Isc,Voc:double;
                  var RezF:TArrSingle;
                  var RezSum:double):word;
{функція для апроксимації ВАХ при освітленні
функцією Ламбертаза МНК;
АР - виміряні точки;
Variab - значення параметрів, очікується, що
цей масив містить 5 значеннь,
Variab[0] - n,
Variab[1] - Rs,
Variab[2] -  Rsh,
Variab[3] -  Isc,
Variab[4] - Voc;
RezF - значення функцій, отриманих як похідні
від квадратичної форми;
RezF[0] - похідна по n,
RezF[1] - похідна по Rs,
RezF[3] - похідна по Rsh,
RezSum - значення квадратичної форми}
var i:integer;
   Yi,Zi,Wi,GVI,Z1,Y1,F1,F12,F21,F22,F3,F31,
   ZIi,nkT,W_W1:double;
begin


for I := 0 to High(RezF) do  RezF[i]:=555;
 RezSum:=555;
Result:=1;

if AP^.T<=0 then Exit;
if LamLightParamIsBad(AP,n,Rs,Rsh,Isc,Voc) then Exit;

for I := 0 to High(RezF) do  RezF[i]:=0;
  RezSum:=0;

nkT:=n*kb*AP^.T;
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

for I := 0 to High(AP^.X) do
   begin
     Yi:=Rs/nkT*(Isc-Voc/(Rs+Rsh))*exp(-Voc/nkT)/(1-exp((Rs*Isc-Voc)/nkT))*
     exp(Rsh*Rs/nkT/(Rs+Rsh)*(AP^.X[i]/Rs+Y1));
     Zi:=AP^.X[i]/(Rs+Rsh)-Z1+nkT/Rs*Lambert(Yi)-AP^.Y[i];
     Wi:=Lambert(Yi);
     if Wi=555 then Exit;
     W_W1:=Wi/(Wi+1);
     ZIi:=Zi/abs(AP^.Y[i]);

   RezSum:=RezSum+ZIi*Zi;

    RezF[0]:=RezF[0]+ZIi*(F1+Kb*AP^.T/Rs*Wi-
              W_W1/(n*Rs*(Rs+Rsh))*(F12+Rsh*AP^.X[i]));

    RezF[1]:=RezF[1]+ZIi*(-AP^.X[i]/sqr(Rs+Rsh)+F21-nkT/sqr(Rs)*Wi+
            W_W1/(Rs*sqr(Rs+Rsh))*(F22-Rsh*AP^.X[i]));

    RezF[3]:=RezF[3]+ZIi*(F3-AP^.X[i]+F31*Wi)/((1+Wi)*sqr(Rs+Rsh));
   end;

  for I := 0 to High(RezF) do RezF[i]:=RezF[i]*2;
Result:=0;
end;


Function FG_ExpShotA(AP:Pvector; Variab:TArrSingle;
                  var RezF:TArrSingle;
                  var RezSum:double):word;overload;
{функція для апроксимації ВАХ
функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh
за МНК; АР - виміряні точки;
Variab - значення параметрів, очікується, що
цей масив містить 4 значення, n, Rs, I0, Rsh;
RezF - значення функцій, отриманих як похідні
від квадратичної форми;
RezSum - значення квадратичної форми}
var i:integer;
    n, Rs, I0, Rsh,
    Zi,ZIi,nkT,vi,ei,eiI0:double;
begin

for I := 0 to High(RezF) do  RezF[i]:=555;
 RezSum:=555;
Result:=1;

n:=Variab[0];
Rs:=Variab[1];
I0:=Variab[2];
Rsh:=Variab[3];

if ExpParamIsBad(AP,n,Rs,I0,Rsh) then Exit;

nkT:=n*kb*AP^.T;

for I := 0 to High(RezF) do  RezF[i]:=0;
  RezSum:=0;

for I := 0 to High(AP^.X) do
   begin
     vi:=(AP^.X[i]-AP^.Y[i]*Rs);
     ei:=exp(vi/nkT);
     Zi:=I0*(ei-1)+vi/Rsh-AP^.Y[i];
     ZIi:=Zi/abs(AP^.Y[i]);
     eiI0:=ei*I0/nkT;

   RezSum:=RezSum+ZIi*Zi;

   RezF[0]:=RezF[0]-ZIi*eiI0*vi;
   RezF[1]:=RezF[1]-Zi*(eiI0+1/Rsh);
   RezF[2]:=RezF[2]+ZIi*(ei-1);
   RezF[3]:=RezF[3]-ZIi*vi;
   end;

  for I := 0 to High(RezF) do RezF[i]:=RezF[i]*2;
  RezF[0]:=RezF[0]/n;
  RezF[3]:=RezF[3]/Rsh/Rsh;
Result:=0;
end;


Function aSdal_LamLightShotA(AP:Pvector;num:word;al,F,n,Rs,Rsh,Isc,Voc:double):double;
{розраховується значення похідної квадратичної форми
яка виникає при апроксимації ВАХ при освітленні
функцією Ламберта;
ця функція використовується при
покоординатному спуску і обчислюється
похідна по al, яка описує зміну
того чи іншого параметра апроксимації
Param = Param - al*F,
де  Param = n  при num = 0
Param = Rs при num = 1
Param = Rsh при num = 3
F - значення похідної квадритичної
форми по Param при al = 0
(те, що повертає функція FG_LamLightShot в RezF)
}
var i:integer;
    Yi,Zi,Wi,GVI,Z1,Y1,F1,F12,F21,F22,F3,F31,
    nkT,W_W1,Rez:double;
begin
Result:=555;
if LamLightParamIsBad(AP,n,Rs,Rsh,Isc,Voc) then  Exit;

try
case num of
   0:n:=n-al*F;
   1:Rs:=Rs-al*F;
   3:Rsh:=Rsh-al*F;
 end;//case
if LamLightParamIsBad(AP,n,Rs,Rsh,Isc,Voc) then  Exit;
nkT:=n*kb*AP^.T;
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
for I := 0 to High(AP^.X) do
   begin
     Yi:=Rs/nkT*(Isc-Voc/(Rs+Rsh))*exp(-Voc/nkT)/(1-exp((Rs*Isc-Voc)/nkT))*
     exp(Rsh*Rs/nkT/(Rs+Rsh)*(AP^.X[i]/Rs+Y1));
     Zi:=AP^.X[i]/(Rs+Rsh)-Z1+nkT/Rs*Lambert(Yi)-AP^.Y[i];
     Wi:=Lambert(Yi);
     if Wi=555 then Exit;
     W_W1:=Wi/(Wi+1);

     case num of
      0: Rez:=Rez+Zi/abs(AP^.Y[i])*(F1+Kb*AP^.T/Rs*Wi-
                  W_W1/(n*Rs*(Rs+Rsh))*(F12+Rsh*AP^.X[i]));

      1: Rez:=Rez+Zi/abs(AP^.Y[i])*(-AP^.X[i]/sqr(Rs+Rsh)+F21-nkT/sqr(Rs)*Wi+
                W_W1/(Rs*sqr(Rs+Rsh))*(F22-Rsh*AP^.X[i]));

      3: Rez:=Rez+Zi/abs(AP^.Y[i])*(F3-AP^.X[i]+F31*Wi)/((1+Wi)*sqr(Rs+Rsh));

      end; //case
   end;
Rez:=2*F*Rez;
Result:=Rez;
except
end;//try
end;


Procedure TFitFunction.AproxN (V:PVector; var Param:TArrSingle);
begin

end;


Function aSdal_ExpShot(AP:Pvector;num:word;al,F,n,Rs,I0,Rsh:double):double;
{розраховується значення похідної квадратичної форми
яка виникає при апроксимації ВАХ функцією
I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh;
ця функція використовується при
покоординатному спуску і обчислюється
похідна по al, яка описує зміну
того чи іншого параметра апроксимації
Param = Param - al*F,
де  Param = n  при num = 0
Param = Rs при num = 1
Param = I0 при num = 2
Param = Rsh при num = 3
F - значення похідної квадритичної
форми по Param при al = 0
(те, що повертає функція FG_ExpShot в RezF)
}
var i:integer;
    Zi,Rez,nkT,vi,ei,eiI0:double;
begin
Result:=555;
if ExpParamIsBad(AP,n,Rs,I0,Rsh) then  Exit;

try
case num of
   0:n:=n-al*F;
   1:Rs:=Rs-al*F;
   2:I0:=I0-al*F;
   3:Rsh:=Rsh-al*F;
 end;//case

if ExpParamIsBad(AP,n,Rs,I0,Rsh) then  Exit;
nkT:=n*kb*AP^.T;

Rez:=0;
for I := 0 to High(AP^.X) do
   begin
     vi:=(AP^.X[i]-AP^.Y[i]*Rs);
     ei:=exp(vi/nkT);
     Zi:=I0*(ei-1)+vi/Rsh-AP^.Y[i];
     eiI0:=ei*I0/nkT;

     case num of
         0:Rez:=Rez+Zi/abs(AP^.Y[i])*eiI0*vi;
         1:Rez:=Rez+Zi*(eiI0+1/Rsh);
         2:Rez:=Rez+Zi/abs(AP^.Y[i])*(1-ei);
         3:Rez:=Rez+Zi/abs(AP^.Y[i])*vi/Rsh/Rsh;
      end; //case
   end;
{}case num of
   0:Rez:=2*F*Rez/n;
   1:Rez:=2*F*Rez;
   2:Rez:=2*F*Rez;
   3:Rez:=2*F*Rez;
end; //case
Result:=Rez;
except
end;//try
end;

Function aSdal_LamShot(AP:Pvector;num:word;al,F,n,Rs,I0,Rsh:double):double;
{розраховується значення похідної квадратичної форми
яка виникає при апроксимації ВАХ функцією
Ламберта;
ця функція використовується при
покоординатному спуску і обчислюється
похідна по al, яка описує зміну
того чи іншого параметра апроксимації
Param = Param - al*F,
де  Param = n  при num = 0
Param = Rs при num = 1
Param = I0 при num = 2
Param = Rsh при num = 3
F - значення похідної квадритичної
форми по Param при al = 0
(те, що повертає функція FG_LamShot в RezF)
}
var i:integer;
    Yi,bt,Zi,Wi,I0Rs,ci,Rez,g1:double;
begin
Result:=555;
if LamParamIsBad(AP,n,Rs,I0,Rsh) then  Exit;

try
case num of
   0:n:=n-al*F;
   1:Rs:=Rs-al*F;
   2:I0:=I0-al*F;
   3:Rsh:=Rsh-al*F;
 end;//case

if LamParamIsBad(AP,n,Rs,I0,Rsh) then  Exit;
bt:=1/kb/AP^.T;
I0Rs:=I0*Rs;
g1:=bt*I0Rs;
Rez:=0;
for I := 0 to High(AP^.X) do
   begin
     ci:=bt*(AP^.X[i]+I0Rs);
     Yi:=bt*I0Rs/n*exp(ci/n);
     Wi:=Lambert(Yi);
     Zi:=n/bt/Rs*Wi+AP^.X[i]/Rsh-I0-AP^.Y[i];
     case num of
         0:Rez:=Rez-Zi/abs(AP^.Y[i])*Wi*(ci-n*Wi)/(1+Wi);
         1:Rez:=Rez+Zi/abs(AP^.Y[i])*Wi*(n*Wi-g1)/(1+Wi);
         2:Rez:=Rez-Zi/abs(AP^.Y[i])*(n*Wi-g1)/(1+Wi);
         3:Rez:=Rez+Zi/abs(AP^.Y[i])*AP^.X[i];
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

Function aSdal_ExpLightShot(AP:Pvector;num:word;al,F,n,Rs,I0,Rsh,Iph:double):double;
{розраховується значення похідної квадратичної форми
яка виникає при апроксимації ВАХ функцією
I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh-Iph;
ця функція використовується при
покоординатному спуску і обчислюється
похідна по al, яка описує зміну
того чи іншого параметра апроксимації
Param = Param - al*F,
де  Param = n  при num = 0
Param = Rs при num = 1
Param = I0 при num = 2
Param = Rsh при num = 3
Param = Iph при num = 4
F - значення похідної квадритичної
форми по Param при al = 0
(те, що повертає функція FG_ExpLightShot в RezF)
}
var i:integer;
    Zi,Rez,nkT,vi,ei,eiI0:double;
begin
Result:=555;
if ExpParamIsBad(AP,n,Rs,I0,Rsh) then  Exit;

try
case num of
   0:n:=n-al*F;
   1:Rs:=Rs-al*F;
   2:I0:=I0-al*F;
   3:Rsh:=Rsh-al*F;
   4:Iph:=Iph-al*F;
 end;//case

if ExpParamIsBad(AP,n,Rs,I0,Rsh) then  Exit;
nkT:=n*kb*AP^.T;

Rez:=0;
for I := 0 to High(AP^.X) do
   begin
     vi:=(AP^.X[i]-AP^.Y[i]*Rs);
     ei:=exp(vi/nkT);
     Zi:=I0*(ei-1)+vi/Rsh-AP^.Y[i]-Iph;
     eiI0:=ei*I0/nkT;

     case num of
         0:Rez:=Rez+Zi/abs(AP^.Y[i])*eiI0*vi;
         1:Rez:=Rez+Zi*(eiI0+1/Rsh);
         2:Rez:=Rez+Zi/abs(AP^.Y[i])*(1-ei);
         3:Rez:=Rez+Zi/abs(AP^.Y[i])*vi/Rsh/Rsh;
         4:Rez:=Rez-ZI/abs(AP^.Y[i]);
      end; //case
   end;
{}case num of
   0:Rez:=2*F*Rez/n;
   1:Rez:=2*F*Rez;
   2:Rez:=2*F*Rez;
   3:Rez:=2*F*Rez;
   4:Rez:=2*F*Rez;
end; //case
Result:=Rez;
except
end;//try
end;

Function ParamCorect(V:PVector;var n0,Rs0,Rsh0,Isc,Voc:double):boolean;overload;
{для корекції параметрів, які використовуються
для апроксимації ΒΑΧ при освітленні в V;
}
begin
  Result:=false;
  if (V^.T<=0) or (Isc<=5e-8) or (Voc<=1e-3) then Exit;
  if (n0=0)or(n0=555) then Exit;
  if Rs0<0.0001 then Rs0:=0.0001;
  if (Rsh0<=0) or (Rsh0>1e12) then Rsh0:=1e12;
  while (LamLightParamIsBad(V,n0,Rs0,Rsh0,Isc,Voc))and(n0<1000) do
   n0:=n0*2;
 { while (Fun(V,n0,Rs0,I00,Rsh0))and(I00>1e-15) do
    I00:=I00/1.5;}
    if  LamLightParamIsBad(V,n0,Rs0,Rsh0,Isc,Voc) then Exit;
  Result:=true;
end;


Function ParamCorect(V:PVector;Fun:Funbool;var n0,Rs0,I00,Rsh0:double):boolean;overload;
{коректує значення параметрів, які використовуються
для апроксимації даних в V функцією Ламверта;
якщо коректування все ж невдале, то
повертається false}
begin
  Result:=false;
  if V^.T<=0 then Exit;
  if Rs0<0.0001 then Rs0:=0.0001;
  if (Rsh0<=0) or (Rsh0>1e12) then Rsh0:=1e12;
  while (Fun(V,n0,Rs0,I00,Rsh0))and(n0<1000) do
   n0:=n0*2;
  while (Fun(V,n0,Rs0,I00,Rsh0))and(I00>1e-15) do
    I00:=I00/1.5;
  if  Fun(V,n0,Rs0,I00,Rsh0) then Exit;
  Result:=true;
end;


//Function FG_LamShot(AP:Pvector; Variab:array of double;
//                  var RezF:array of double;
//                  var RezG:T2DArray;var RezSum:double):word;overload;
//{функція для апроксимації ВАХ функцією Ламберта
//за МНК; АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//цей масив містить 4 значення, n, Rs, I0, Rsh;
//RezF - значення функцій, отриманих як похідні
//від квадратичної форми;
//RezG - значення матриці Якобі;
//RezSum - значення квадратичної форми}
//var i,j:integer;
//    n, Rs, I0, Rsh,
//    Yi,bt,Zi,Wi,Wi1,WW1n,F1s,F2s,WZ,WZIi,
//    dWdn,dWdRs,dWdI0,dZdn,dZdRs,dZdI0,dZdRsh,
//    dWZn,dWZRs,dWZI0,I0Rs,nWi,ci,
//    Wi2,Wi12,Wi13,ZIi,s23,s2,s3,s33,all,n2,Rs2,bt2:double;
//begin
//
//
//for I := 0 to High(RezF) do
//  begin
//  RezF[i]:=555;
//  for j := 0 to High(RezF) do
//     RezG[i,j]:=555;
//  end;
// RezSum:=555;
//Result:=1;
//
//n:=Variab[0];
//Rs:=Variab[1];
//I0:=Variab[2];
//Rsh:=Variab[3];
//
//if LamParamIsBad(AP,n,Rs,I0,Rsh) then Exit;
//
//bt:=1/kb/AP^.T;
//
//for I := 0 to High(RezF) do
//  begin
//  RezF[i]:=0;
//  for j := 0 to High(RezF) do
//     RezG[i,j]:=0;
//  end;
//  RezSum:=0;
//
//   I0Rs:=I0*Rs;
//   s2:=n+bt*I0Rs;
//   all:=bt*I0Rs*n;
//   n2:=n*n;
//   Rs2:=Rs*Rs;
//   bt2:=bt*bt;
//
//for I := 0 to High(AP^.X) do
//   begin
//   ci:=bt*(AP^.X[i]+I0Rs);
//   Yi:=bt*I0Rs/n*exp(ci/n);
//   Wi:=Lambert(Yi);
//   Wi1:=Wi+1;
//   Wi2:=Wi*Wi;
//   Wi12:=Wi1*Wi1;
//   Wi13:=Wi12*Wi1;
//   nWi:=n*Wi;
//   Zi:=n/bt/Rs*Wi+AP^.X[i]/Rsh-I0-AP^.Y[i];
//   WZ:=Wi*Zi;
//   ZIi:=Zi/abs(AP^.Y[i]);
//   WZIi:=WZ/AP^.Y[i];
//   F1s:=(nWi-ci)/(bt*n*Rs*Wi1);
//   dZdn:=Wi*F1s;
//   s23:=(bt*I0Rs-nWi)/(bt*Rs*Wi1);
//   F2s:=s23/Rs;
//   dZdRs:=Wi*F2s;
//   dZdI0:=-s23/I0;
//   dZdRsh:=-AP^.X[i]/Rsh/Rsh;
//   WW1n:=Wi/(Wi1*n);
//   dWdn:=-WW1n*(n+ci)/n;
//   dWdRs:=WW1n*s2/Rs;
//   dWdI0:=WW1n*s2/I0;
//   dWZn:=dWdn*Zi+Wi*dZdn;
//   dWZRs:=dWdRs*Zi+Wi*dZdRs;
//   dWZI0:=dWdI0*Zi+Wi*dZdI0;
//
//   RezSum:=RezSum+ZIi*Zi;
//
//   RezF[0]:=RezF[0]+ZIi*dZdn;
//   RezF[1]:=RezF[1]+ZIi*dZdRs;
//   RezF[2]:=RezF[2]+ZIi*dZdI0;
//   RezF[3]:=RezF[3]+ZIi*dZdRsh;
//
//   RezG[0,0]:=RezG[0,0]+1/AP^.Y[i]*(dWZn*F1s+
//              WZ*(bt*n*ci*(1+Wi2)-Wi*(n2+ci*ci))/(bt*n2*n*Rs*Wi13));
//   RezG[0,1]:=RezG[0,1]+1/AP^.Y[i]*(dWZRs*F1s+
//               WZ*(bt*n*AP^.X[i]+Wi*bt*(bt*I0Rs*I0Rs+3*n*AP^.X[i])+I0Rs*(2*n+bt*AP^.X[i]+
//               Wi2*n*(bt*AP^.X[i]-2*n)))/(bt*n2*Rs2*Wi13));
//   RezG[0,2]:=RezG[0,2]++1/AP^.Y[i]*(dWZI0*F1s+
//               WZ*(-bt*n*I0Rs+Wi*(n2+bt*AP^.X[i]*n+bt2*I0Rs*ci)-Wi2*I0Rs*n*bt)/(all*n*Wi13));
//   RezG[0,3]:=RezG[0,3]+Wi*dZdRsh*F1s/AP^.Y[i];
//
//   RezG[1,0]:=RezG[1,0]+1/AP^.Y[i]*(dWZn*F2s+
//                WZ*Wi*(bt*(bt*I0Rs*I0Rs+n*AP^.X[i]+I0Rs*(2*n+bt*AP^.X[i]))-
//                n2*(2*Wi-Wi2))/(bt*n2*Rs2*Wi13));
//
//   RezG[1,1]:=RezG[1,1]+1/AP^.Y[i]*(dWZRs*F2s+
//                WZ*(-all+Wi*(n2-4*all-bt2*I0Rs*I0Rs)+
//                Wi2*n*(4*n-bt*I0Rs)+Wi2*Wi*2*n2)/(bt*n*Rs2*Rs*Wi13));
//
//   RezG[1,2]:=RezG[1,2]+1/AP^.Y[i]*(dWZI0*F2s+
//                WZ*(all-Wi*(n2+bt2*I0Rs*I0Rs)+Wi2*all)/(all*Rs*Wi13));
//
//   RezG[1,3]:=RezG[1,3]+Wi*dZdRsh*F2s/AP^.Y[i];
//
//
//   s3:=n2*(2*Wi+Wi2);
//   RezG[2,0]:=RezG[2,0]+1/AP^.Y[i]*(dZdn*dZdI0+
//               WZ*(-bt*(bt*I0Rs*I0Rs+n*AP^.X[i]+I0Rs*(2*n+bt*AP^.X[i]))
//               +s3)/(all*n*Wi13));
//   s33:=bt*I0Rs*(2*n+bt*I0Rs)-s3;
//   RezG[2,1]:=RezG[2,1]+1/AP^.Y[i]*(dZdRs*dZdI0+
//               WZ*s33/(all*Rs*Wi13));
//   RezG[2,2]:=RezG[2,2]+1/AP^.Y[i]*(dZdI0*dZdI0+
//               WZ*s33/(all*I0*Wi13));
//   RezG[2,3]:=RezG[2,3]+dZdRsh*dZdI0/AP^.Y[i];
//
//   RezG[3,0]:=RezG[3,0]+1/AP^.Y[i]*dZdn*dZdRsh;
//   RezG[3,1]:=RezG[3,1]+1/AP^.Y[i]*dZdRs*dZdRsh;
//   RezG[3,2]:=RezG[3,2]+1/AP^.Y[i]*dZdI0*dZdRsh;;
//   RezG[3,3]:=RezG[3,3]+1/AP^.Y[i]*(dZdRsh*dZdRsh+Zi*2*AP^.X[i]/Rsh/Rsh/Rsh);
//   end;
//
//  for I := 0 to High(RezF) do
//    begin
//    RezF[i]:=RezF[i]*2;
//     for j := 0 to High(RezF) do
//      RezG[i,j]:=RezG[i,j]*2;
//    end;
//Result:=0;
//end;

//Function FG_LamShot(AP:Pvector; Variab:array of double;
//                  var RezF:array of double;
//                  var RezSum:double):word;overload;
//{функція для апроксимації ВАХ функцією Ламберта
//за МНК; АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//цей масив містить 4 значення, n, Rs, I0, Rsh;
//RezF - значення функцій, отриманих як похідні
//від квадратичної форми;
//RezSum - значення квадратичної форми}
//var i:integer;
//    n, Rs, I0, Rsh,
//    bt,Zi,Wi,F1s,
//    I0Rs,nWi,ci,ZIi,s23,
//    F2,F1:double;
//begin
//
//
//for I := 0 to High(RezF) do  RezF[i]:=555;
// RezSum:=555;
//Result:=1;
//
//n:=Variab[0];
//Rs:=Variab[1];
//I0:=Variab[2];
//Rsh:=Variab[3];
//
//if LamParamIsBad(AP,n,Rs,I0,Rsh) then Exit;
//
//bt:=1/kb/AP^.T;
//
//for I := 0 to High(RezF) do  RezF[i]:=0;
//  RezSum:=0;
//
//I0Rs:=I0*Rs;
//F2:=bt*I0Rs;
//F1:=bt*Rs;
//
//for I := 0 to High(AP^.X) do
//   begin
//     ci:=bt*(AP^.X[i]+I0Rs);
//     Wi:=Lambert(bt*I0Rs/n*exp(ci/n));
//     nWi:=n*Wi;
//     Zi:=n/bt/Rs*Wi+AP^.X[i]/Rsh-I0-AP^.Y[i];
//     ZIi:=Zi/abs(AP^.Y[i]);
//     F1s:=F1*(Wi+1);
//     s23:=(F2-nWi)/F1s;
//
//   RezSum:=RezSum+ZIi*Zi;
//
//   RezF[0]:=RezF[0]+ZIi*Wi*(nWi-ci)/F1s;
//   RezF[1]:=RezF[1]+ZIi*Wi*s23;
//   RezF[2]:=RezF[2]-ZIi*s23;
//   RezF[3]:=RezF[3]-ZIi*AP^.X[i];
//   end;
//
//  for I := 0 to High(RezF) do RezF[i]:=RezF[i]*2;
//  RezF[1]:=RezF[1]/n;
//  RezF[2]:=RezF[2]/Rs;
//  RezF[2]:=RezF[2]/I0;
//  RezF[3]:=RezF[3]/Rsh/Rsh;
//Result:=0;
//end;

//Function FG_LamShot(AP:Pvector; Variab:array of double;
//                  var RezSum:double):word;overload;
//{на відміну від попередньої, розраховується
//лише значення квадратичної форми}
//var i:integer;
//    n, Rs, I0, Rsh, bt, I0Rs,
//    Wi,ci,Zi:double;
//begin
//   RezSum:=555;
//   Result:=1;
////    try
//    n:=Variab[0];
//    Rs:=Variab[1];
//    I0:=Variab[2];
//    Rsh:=Variab[3];
//   if LamParamIsBad(AP,n,Rs,I0,Rsh) then Exit;
//    bt:=1/kb/AP^.T;
//
//      RezSum:=0;
//     I0Rs:=I0*Rs;
//
//    for I := 0 to High(AP^.X) do
//       begin
//       ci:=bt*(AP^.X[i]+I0Rs);
//       Wi:=Lambert(bt*I0Rs/n*exp(ci/n));
//       Zi:=n/bt/Rs*Wi+AP^.X[i]/Rsh-I0-AP^.Y[i];
//       RezSum:=RezSum+Zi*Zi/abs(AP^.Y[i]);
//       end;
//end;

//Function FG_ExpShot(AP:Pvector; Variab:array of double;
//                  var RezF:array of double;
//                  var RezSum:double):word;overload;
//{функція для апроксимації ВАХ
//функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh
//за МНК; АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//цей масив містить 4 значення, n, Rs, I0, Rsh;
//RezF - значення функцій, отриманих як похідні
//від квадратичної форми;
//RezSum - значення квадратичної форми}
//var i:integer;
//    n, Rs, I0, Rsh,
//    Zi,ZIi,nkT,vi,ei,eiI0:double;
//begin
//
//for I := 0 to High(RezF) do  RezF[i]:=555;
// RezSum:=555;
//Result:=1;
//
//n:=Variab[0];
//Rs:=Variab[1];
//I0:=Variab[2];
//Rsh:=Variab[3];
//
//if ExpParamIsBad(AP,n,Rs,I0,Rsh) then Exit;
//
//nkT:=n*kb*AP^.T;
//
//for I := 0 to High(RezF) do  RezF[i]:=0;
//  RezSum:=0;
//
//for I := 0 to High(AP^.X) do
//   begin
//     vi:=(AP^.X[i]-AP^.Y[i]*Rs);
//     ei:=exp(vi/nkT);
//     Zi:=I0*(ei-1)+vi/Rsh-AP^.Y[i];
//     ZIi:=Zi/abs(AP^.Y[i]);
//     eiI0:=ei*I0/nkT;
//
//   RezSum:=RezSum+ZIi*Zi;
//
//   RezF[0]:=RezF[0]-ZIi*eiI0*vi;
//   RezF[1]:=RezF[1]-Zi*(eiI0+1/Rsh);
//   RezF[2]:=RezF[2]+ZIi*(ei-1);
//   RezF[3]:=RezF[3]-ZIi*vi;
//   end;
//
//  for I := 0 to High(RezF) do RezF[i]:=RezF[i]*2;
//  RezF[0]:=RezF[0]/n;
//  RezF[3]:=RezF[3]/Rsh/Rsh;
//Result:=0;
//end;

//Function FG_ExpShot(AP:Pvector; Variab:array of double;
//                  var RezSum:double):word;overload;
//{функція для апроксимації ВАХ
//функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh
//за МНК; АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//цей масив містить 4 значення, n, Rs, I0, Rsh;
//RezSum - значення квадратичної форми}
//var i:integer;
//    n, Rs, I0, Rsh,Zi:double;
//begin
//
//RezSum:=555;
//Result:=1;
//
//n:=Variab[0];
//Rs:=Variab[1];
//I0:=Variab[2];
//Rsh:=Variab[3];
//
//if ExpParamIsBad(AP,n,Rs,I0,Rsh) then Exit;
//RezSum:=0;
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=I0*(exp((AP^.X[i]-AP^.Y[i]*Rs)/(n*Kb*AP^.T))-1)+(AP^.X[i]-AP^.Y[i]*Rs)/Rsh-AP^.Y[i];
//   RezSum:=RezSum+Zi*Zi/abs(AP^.Y[i]);
//   end;
//Result:=0;
//end;
//
//Function FG_ExpLightShot(AP:Pvector; Variab:array of double;
//                  var RezF:array of double;
//                  var RezSum:double):word;
//{функція для апроксимації ВАХ
//функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh-Iph
//за МНК; АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//цей масив містить 4 значення, n, Rs, I0, Rsh;
//RezF - значення функцій, отриманих як похідні
//від квадратичної форми;
//RezSum - значення квадратичної форми}
//var i:integer;
//    n, Rs, I0, Rsh,Iph,
//    Zi,ZIi,nkT,vi,ei,eiI0:double;
//begin
//
//for I := 0 to High(RezF) do  RezF[i]:=555;
// RezSum:=555;
//Result:=1;
//
//n:=Variab[0];
//Rs:=Variab[1];
//I0:=Variab[2];
//Rsh:=Variab[3];
//Iph:=Variab[4];
//
//if ExpParamIsBad(AP,n,Rs,I0,Rsh) then Exit;
//
//nkT:=n*kb*AP^.T;
//
//for I := 0 to High(RezF) do  RezF[i]:=0;
//  RezSum:=0;
//
//for I := 0 to High(AP^.X) do
//   begin
//     vi:=(AP^.X[i]-AP^.Y[i]*Rs);
//     ei:=exp(vi/nkT);
//     Zi:=I0*(ei-1)+vi/Rsh-Iph-AP^.Y[i];
//     ZIi:=Zi/abs(AP^.Y[i]);
//     eiI0:=ei*I0/nkT;
//
//   RezSum:=RezSum+ZIi*Zi;
//
//   RezF[0]:=RezF[0]-ZIi*eiI0*vi;
//   RezF[1]:=RezF[1]-Zi*(eiI0+1/Rsh);
//   RezF[2]:=RezF[2]+ZIi*(ei-1);
//   RezF[3]:=RezF[3]-ZIi*vi;
//   RezF[4]:=RezF[4]-ZIi;
//   end;
//
//  for I := 0 to High(RezF) do RezF[i]:=RezF[i]*2;
//  RezF[0]:=RezF[0]/n;
//  RezF[3]:=RezF[3]/Rsh/Rsh;
//Result:=0;
//end;





Procedure TFitFunctionLSM.AproxN (V:PVector; var Param:TArrSingle);
                  {var n0,Rs0,I00,Rsh0,Isc0,Voc0,Iph0:double}
{апроксимуються ВАХ при освітленні у векторі V
залежністю I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
за методом найменших квадратів зі
статистичними ваговими коефіцієнтами

Func0 = 0 - безпосередньо виразом
          I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh;
Func0 = 1 - використовується функція Ламберта;
Func0 = 3 - безпосередньо виразом
          I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph;
Func0 = 4 - використовується функція Ламберта;

mode0 - режим апроксимації:
mode0 = 0 - всі параметри підбираються;
mode0 = 1 - вважається, що Rsh нескінченність (1е12);
mode0 = 1 - вважається, що Rs нульовий(1е-4)
mode0 = 3 - Rsh нескінченність + Rs нульовий
}

var
    i,Nitt,j:integer;
    bool,bool1:boolean;
    Sum,al,sum2:double;

   Function Secant(num:word;a,b,F:double):double;
  {обчислюється оптимальне значення параметра al
  в методі поординатного спуску;
  використовується метод дихотомії;
  а та b задають початковий відрізок, де шукається
  розв'язок}
  var i:integer;
      c,Fb,Fa:double;
  begin
    Result:=0;
    Fa:=555;
    if FName='DiodLSM'
      then Fa:=aSdal_ExpShot(V,num,a,F,FXmin[0],FXmin[1],FXmin[2],FXmin[3]);
    if FName='DiodLam'
      then Fa:=aSdal_LamShot(V,num,a,F,FXmin[0],FXmin[1],FXmin[2],FXmin[3]);
    if FName='PhotoDiodLSM'
      then Fa:=aSdal_ExpLightShot(V,num,a,F,FXmin[0],FXmin[1],FXmin[2],FXmin[3],FXmin[4]);
    if FName='PhotoDiodLam'
      then  Fa:=aSdal_LamLightShotA(V,num,a,F,FXmin[0],FXmin[1],FXmin[3],FXmin[2],FXmin[4]);

    if Fa=555 then
    begin
//    showmessage('jjj');
    Exit;
    end;

    if Fa=0 then
               begin
                  Result:=a;
                  Exit;
                end;
    repeat
    Fb:=0;
    if FName='DiodLSM'
      then Fb:=aSdal_ExpShot(V,num,b,F,FXmin[0],FXmin[1],FXmin[2],FXmin[3]);
    if FName='DiodLam'
      then Fb:=aSdal_LamShot(V,num,b,F,FXmin[0],FXmin[1],FXmin[2],FXmin[3]);
    if FName='PhotoDiodLSM'
      then Fb:=aSdal_ExpLightShot(V,num,b,F,FXmin[0],FXmin[1],FXmin[2],FXmin[3],FXmin[4]);
    if FName='PhotoDiodLam'
      then Fb:=aSdal_LamLightShotA(V,num,b,F,FXmin[0],FXmin[1],FXmin[3],FXmin[2],FXmin[4]);

     if Fb=0 then
                begin
                  Result:=b;
                  Exit;
                end;
     if Fb=555 then break
               else
                 begin
                 if Fb*Fa<=0 then break
                            else b:=2*b
                 end;
    until false;

     i:=0;
    repeat
      inc(i);
      c:=(a+b)/2;
    if FName='DiodLSM'
      then
       begin
       Fb:=aSdal_ExpShot(V,num,c,F,FXmin[0],FXmin[1],FXmin[2],FXmin[3]);
       Fa:=aSdal_ExpShot(V,num,a,F,FXmin[0],FXmin[1],FXmin[2],FXmin[3]);
       end;
    if FName='DiodLam'
      then
      begin
      Fb:=aSdal_LamShot(V,num,c,F,FXmin[0],FXmin[1],FXmin[2],FXmin[3]);
      Fa:=aSdal_LamShot(V,num,a,F,FXmin[0],FXmin[1],FXmin[2],FXmin[3]);
      end;
    if FName='PhotoDiodLSM'
      then
      begin
      Fb:=aSdal_ExpLightShot(V,num,c,F,FXmin[0],FXmin[1],FXmin[2],FXmin[3],FXmin[4]);
      Fa:=aSdal_ExpLightShot(V,num,a,F,FXmin[0],FXmin[1],FXmin[2],FXmin[3],FXmin[4]);
      end;
    if FName='PhotoDiodLam'
      then
      begin
      Fb:=aSdal_LamLightShotA(V,num,b,F,FXmin[0],FXmin[1],FXmin[3],FXmin[2],FXmin[4]);
      Fa:=aSdal_LamLightShotA(V,num,a,F,FXmin[0],FXmin[1],FXmin[3],FXmin[2],FXmin[4]);
      end;

     if (Fb*Fa<=0) or (Fb=555)
       then b:=c
       else a:=c;
     until (i>1e5)or(abs((b-a)/c)<1e-2);
    if (i>1e5) then Exit;
    Result:=c;
  end;

 Procedure VuhDatExpLightmAprox (Par:TArrSingle);
  {по значенням в V визначає початкове наближення
  для n,Rs,I0,Rsh,Iph}
  var temp,temp2:Pvector;
      i,k:integer;
   begin
    Par[0]:=555;
    if (VocCalc(V)<=0.002) then Exit;
    Par[4]:=IscCalc(V);
    if (Par[4]<=1e-8) then Exit;

    new(temp2);
    IVchar(V,temp2);
     for I := 0 to High(temp2^.X) do
      temp2^.Y[i]:=temp2^.Y[i]+Par[4];

    new(temp);
    Diferen (temp2,temp);
  {фактично, в temp залеженість оберненого опору від напруги}
    Par[3]:=(temp^.X[1]/temp^.y[2]-temp^.X[2]/temp^.y[1])/(temp^.X[1]-temp^.X[2]);
  {Rsh0 - по початковим двом значенням опору проводиться пряма і визначається очікуване
      значення при нульовій напрузі}
   if FXmode[3]=cons then Par[3]:=FXvalue[3];

    for I := 0 to High(temp^.X) do
      temp^.Y[i]:=(temp2^.Y[i]-temp2^.X[i]/Par[3]);
    {в temp - ВАХ з врахуванням Rsh0}

    k:=-1;
    for i:=0 to High(temp^.X) do
           if Temp^.Y[i]<0 then k:=i;

   if k<0 then IVchar(temp,temp2)
          else
           begin
             SetLenVector(temp2,temp^.n-k-1);
             for i:=0 to High(temp2^.X) do
               begin
                temp2^.Y[i]:=temp^.Y[i+k+1];
                temp2^.X[i]:=temp^.X[i+k+1];
               end;
           end;
     for i:=0 to High(temp2^.X) do
       temp2^.Y[i]:=ln(temp2^.Y[i]);

{}    if High(temp2^.X)>6 then
         begin
         SetLenVector(temp,High(temp2^.X)-3);
         for i:=3 to High(temp2^.X) do
          begin
           temp^.X[i-3]:=temp2^.X[i];
           temp^.Y[i-3]:=temp2^.Y[i];
          end;
         end;
    LinAprox(temp,Par[2],Par[0]);{}
    Par[2]:=exp(Par[2]);
    Par[0]:=1/(Kb*V^.T*Par[0]);
    {I00 та n0 в результаті лінійної апроксимації залежності
    ln(I) від напруги, береться ВАХ з врахуванням Rsh0}
   if FXmode[2]=cons then Par[2]:=FXvalue[2];
   if FXmode[0]=cons then Par[0]:=FXvalue[0];
     for i:=0 to High(temp2^.X) do
       begin
       temp2^.Y[i]:=exp(temp2^.Y[i]);;
       end;
   {в temp2 - частина ВАХ з врахуванням Rsh0, для якої
   значення струму додатні}

    Diferen (temp2,temp);
     for i:=0 to High(temp.X) do
       begin
       temp^.X[i]:=1/temp2^.Y[i];
       temp^.Y[i]:=1/temp^.Y[i];
       end;
    {в temp - залежність dV/dI від 1/І}

    if temp^.n>5 then
       begin
       SetLenVector(temp2,5);
       for i:=0 to 4 do
         begin
             temp2^.X[i]:=temp^.X[High(temp.X)-i];
             temp2^.Y[i]:=temp^.Y[High(temp.X)-i];
         end;
       end
               else
           IVchar(temp2,temp);

    LinAprox(temp2,Par[1],temp^.X[0]);
    {Rs0 - як вільних член лінійної апроксимації
    щонайбільше п'яти останніх точок залежності dV/dI від 1/І;
   dV/dI= (nKbT)/(qI)+Rs;
    temp^.X[0] використане лише для того, щоб
    не вводити допоміжну змінну}
   if FXmode[1]=cons then Par[1]:=FXvalue[1];

    dispose(temp2);
    dispose(temp);
   end;


  Procedure VuhDatAprox (Par:TArrSingle);//overload;
  {по значенням в V визначає початкове наближення
  для n,Rs,I0,Rsh}

  var temp,temp2:Pvector;
      i,k:integer;
   begin
    Par[0]:=555;
 if High(Par)=4 then
    begin
    Par[2]:=IscCalc(V);
    Par[4]:=VocCalc(V);
    if ( Par[4]<=0.002)or(Par[2]<1e-8) then Exit;
    end;

    new(temp);
    Diferen (V,temp);
  {фактично, в temp залеженість оберненого опору від напруги}
    Par[3]:=(temp^.X[1]/temp^.y[2]-temp^.X[2]/temp^.y[1])/(temp^.X[1]-temp^.X[2]);
  {Rsh0 - по початковим двом значенням опору проводиться пряма і визначається очікуване
      значення при нульовій напрузі}
   if FXmode[3]=cons then Par[3]:=FXvalue[3];

 if High(Par)=4 then
    begin
        for I := 0 to High(temp^.X) do
          begin
          temp^.Y[i]:=1/temp^.Y[i];
          temp^.X[i]:=Kb*V^.T/(Par[2]+V^.Y[i]-V^.X[i]/Par[3]);
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
                   else
              IVchar(temp2,temp);
        LinAprox(temp2,Par[1],Par[0]);
          {n та Rs0 - як нахил та вільних член лінійної апроксимації
          щонайбільше семи останніх точок залежності
          dV/dI від kT/q(Isc+I-V/Rsh);}
//          if Par[0]>1e5 then  Par[0]:=1;
         if FXmode[1]=cons then Par[1]:=FXvalue[1];
         if FXmode[0]=cons then Par[0]:=FXvalue[0];
    end

    else
    begin
              for I := 0 to High(temp^.X) do
                temp^.Y[i]:=(V^.Y[i]-V^.X[i]/Par[3]);
              {в temp - ВАХ з врахуванням Rsh0}
              k:=-1;
              for i:=0 to High(temp^.X) do
                     if Temp^.Y[i]<0 then k:=i;
              new(temp2);

             if k<0 then IVchar(temp,temp2)
                    else
                     begin
                       SetLenVector(temp2,temp^.n-k-1);
                       for i:=0 to High(temp2^.X) do
                         begin
                          temp2^.Y[i]:=temp^.Y[i+k+1];
                          temp2^.X[i]:=temp^.X[i+k+1];
                         end;
                     end;
               for i:=0 to High(temp2^.X) do
                 temp2^.Y[i]:=ln(temp2^.Y[i]);

            {}    if High(temp2^.X)>6 then
                   begin
                   SetLenVector(temp,High(temp2^.X)-3);
                   for i:=3 to High(temp2^.X) do
                    begin
                     temp^.X[i-3]:=temp2^.X[i];
                     temp^.Y[i-3]:=temp2^.Y[i];
                    end;
                   end;
              LinAprox(temp,Par[2],Par[0]);{}
              Par[2]:=exp(Par[2]);
              Par[0]:=1/(Kb*V^.T*Par[0]);
//              if Par[0]>1e5 then  Par[0]:=1;
              {I00 та n0 в результаті лінійної апроксимації залежності
              ln(I) від напруги, береться ВАХ з врахуванням Rsh0}
            if FXmode[2]=cons then Par[2]:=FXvalue[2];
            if FXmode[0]=cons then Par[0]:=FXvalue[0];

               for i:=0 to High(temp2^.X) do
                 begin
                 temp2^.Y[i]:=exp(temp2^.Y[i]);;
                 end;
             {в temp2 - частина ВАХ з врахуванням Rsh0, для якої
             значення струму додатні}

              Diferen (temp2,temp);
               for i:=0 to High(temp.X) do
                 begin
                 temp^.X[i]:=1/temp2^.Y[i];
                 temp^.Y[i]:=1/temp^.Y[i];
                 end;
              {в temp - залежність dV/dI від 1/І}

              if temp^.n>5 then
                 begin
                 SetLenVector(temp2,5);
                 for i:=0 to 4 do
                   begin
                       temp2^.X[i]:=temp^.X[High(temp.X)-i];
                       temp2^.Y[i]:=temp^.Y[High(temp.X)-i];
                   end;
                 end
                         else
                     IVchar(temp2,temp);
              LinAprox(temp2,Par[1],temp^.X[0]);
              {Rs0 - як вільних член лінійної апроксимації
              щонайбільше п'яти останніх точок залежності dV/dI від 1/І;
             dV/dI= (nKbT)/(qI)+Rs;
              temp^.X[0] використане лише для того, щоб
              не вводити допоміжну змінну}
             if FXmode[1]=cons then Par[1]:=FXvalue[1];
     end;

    dispose(temp2);
    dispose(temp);
   end; //  VuhDatAprox


begin
SetLength(Param,FNs);
Param[0]:=555;

if not((FName='DiodLSM')or(FName='DiodLam')
    or(FName='PhotoDiodLSM')or(FName='PhotoDiodLam'))
      then Exit;
if V^.T=0 then Exit;
if V^.n<7 then  Exit;

SetLength(Labels,2*FNs);
 j:=0;
 for I := 0 to FNs - 1 do
  begin
  Labels[i]:=TLabel.Create(App);
  Labels[i].Name:=Labels[i].Name+FXname[i];
  Labels[i+FNs]:=TLabel.Create(App);
  Labels[i+FNs].Name:=Labels[i].Name+FXname[i]+'n';

  if ((Name='PhotoDiodLam')and((i=2)or(i=4))) then Continue;
  Labels[i].Parent:=App;
  Labels[i+FNs].Parent:=App;
  Labels[i].Left:=24;
  Labels[i+FNs].Left:=90;
  Labels[i].Top:=round(3.5*App.LNmax.Height)+j*round(1.5*Labels[i].Height);
  Labels[i+FNs].Top:=round(3.5*App.LNmax.Height)+j*round(1.5*Labels[i].Height);
  Labels[i].Caption:=FXname[i]+' =';
  inc(j);
  end;
  App.LNmaxN.Caption:=inttostr(FNit);
  if (Name='PhotoDiodLam') then
      App.Height:=Labels[3].Top+3*Labels[3].Height
                           else
  App.Height:=Labels[High(Labels)].Top+3*Labels[High(Labels)].Height;

if FName='DiodLSM' then
  App.Caption:='Direct Aproximation';
if FName='DiodLam' then
  App.Caption:='Lambert Aproximation';
if FName='PhotoDiodLSM' then
  App.Caption:='Direct Aproximation of Illuminated I-V';
if FName='PhotoDiodLam' then
  App.Caption:='Lambert Aproximation of Illuminated I-V';
if V^.name<>'' then App.Caption:=App.Caption+', '+V^.name;


if FName='PhotoDiodLSM' then VuhDatExpLightmAprox(FXmin)
                        else VuhDatAprox (FXmin);
// showmessage(floattostr(FXmin[1]));
 if FXmin[1]<0 then FXmin[1]:=1;


   if FXmin[0]=555 then
                begin
                  WindowClear();
                  Exit;
                end;
if FName='PhotoDiodLam' then
     begin
     FXmode[2]:=cons;
     FXmode[4]:=cons;
     end;

bool:=true;
if FName='PhotoDiodLam'
 then bool:=ParamCorect(V,FXmin[0],FXmin[1],FXmin[3],FXmin[2],FXmin[4]);
if FName='DiodLam'
 then bool:=ParamCorect(V,LamParamIsBad,FXmin[0],FXmin[1],FXmin[2],FXmin[3]);
if (FName='DiodLSM')or(FName='PhotoDiodLSM')
 then bool:=ParamCorect(V,ExpParamIsBad,FXmin[0],FXmin[1],FXmin[2],FXmin[3]);

if not(bool) then
                begin
                  WindowClear();
                  Exit;
                end;

//  showmessage(floattostr(FXmin[1]));

 Nitt:=0;
 sum2:=1;
App.Show;


//QueryPerformanceCounter(StartValue);

repeat

 if Nitt<1 then
   begin
    bool1:=true;
     if FName='DiodLam' then
      bool1:=FG_LamShotA(V,FXmin,FXminlim,Sum)<>0;
     if FName='PhotoDiodLSM' then
      bool1:=(FG_ExpLightShotA(V,FXmin,FXminlim,Sum)<>0);
     if FName='PhotoDiodLam' then
      bool1:=(FG_LamLightShotA(V,FXmin[0],FXmin[1],
               FXmin[3],FXmin[2],FXmin[4],FXminlim,Sum)<>0);
     if FName='DiodLSM' then
      bool1:=(FG_ExpShotA(V,FXmin,FXminlim,Sum)<>0);
    if bool1 then
                begin
                  WindowClear();
                  Exit;
                end;


   end;




  bool:=true;
  if not(odd(Nitt)) then for I := 0 to High(FXmin) do FXmax[i]:=FXmin[i];
  if not(odd(Nitt))or (Nitt=0) then sum2:=sum;

  for I := 0 to High(FXmin) do
     begin

       if FXmode[i]=cons then Continue;
       if FXminlim[i]=0 then Continue;
       if abs(FXmin[i]/100/FXminlim[i])>1e30 then Continue;

       al:=Secant(i,0,0.1*abs(FXmin[i]/FXminlim[i]),FXminlim[i]);

//    if i=1 then      showmessage(floattostr(FXmin[1]));
//         showmessage(floattostr(FXminlim[0]));
//          showmessage(inttostr(Nitt)+' '+floattostr(al*FXminlim[i]/FXmin[i]));
       if abs(al*FXminlim[i]/FXmin[i])>2 then Continue;

       FXmin[i]:=FXmin[i]-al*FXminlim[i];

//   if i=1 then    showmessage('2 -- '+floattostr(FXmin[1]));

      bool1:=true;
      if FName='PhotoDiodLam' then
       bool1:=(ParamCorect(V,FXmin[0],FXmin[1],FXmin[3],FXmin[2],FXmin[4]));
      if FName='DiodLam' then
       bool1:=(ParamCorect(V,LamParamIsBad,FXmin[0],FXmin[1],FXmin[2],FXmin[3]));
      if (FName='DiodLSM')or(FName='PhotoDiodLSM') then
       bool1:=(ParamCorect(V,ExpParamIsBad,FXmin[0],FXmin[1],FXmin[2],FXmin[3]));
      if not(bool1) then
                begin
                  WindowClear();
                  Exit;
                end;

       bool:=(bool)and(abs((FXmax[i]-FXmin[i])/FXmin[i])<FXmaxlim[0]);




    bool1:=true;
     if FName='DiodLam' then
      bool1:=FG_LamShotA(V,FXmin,FXminlim,Sum)<>0;
     if FName='PhotoDiodLSM' then
      bool1:=(FG_ExpLightShotA(V,FXmin,FXminlim,Sum)<>0);
     if FName='PhotoDiodLam' then
      bool1:=(FG_LamLightShotA(V,FXmin[0],FXmin[1],
               FXmin[3],FXmin[2],FXmin[4],FXminlim,Sum)<>0);
     if FName='DiodLSM' then
      bool1:=(FG_ExpShotA(V,FXmin,FXminlim,Sum)<>0);
     if bool1 then
                begin
                  WindowClear();
                  Exit;
                end;

     end;

  if (Nitt mod 25)=0 then
     begin
      WindowDataShow(Nitt,FXmin);
      for I := 0 to FNs - 1 do
       begin
       if (FXname[i]='Rs')and(FXmin[i]<=1e-4) then
                   Labels[i+FNs].Caption:='0';
       if (FXname[i]='Rsh')and(FXmin[i]>=9e11) then
                   Labels[i+FNs].Caption:='INF';
       end;

         Application.ProcessMessages;
     end;
  Inc(Nitt);

//until (Nitt>10000) or not(App.Visible);
until (abs((sum2-sum)/sum)<FXmaxlim[0]) or bool or (Nitt>FNit) or not(App.Visible);

//QueryPerformanceCounter(EndValue);
//QueryPerformanceFrequency(Freq);
//showmessage('tics='+inttostr(EndValue-StartValue)+#10+#13+
//             'time='+floattostr((EndValue-StartValue)/Freq)
//             +' s'+#10+#13+
//                'freq+'+inttostr(Freq));

if App.Visible then
    begin
    for i := 0 to High(FXmin) do
       Param[i]:=FXmin[i];
    if FName='PhotoDiodLam' then
       begin
       Param[2]:=(FXmin[2]+(FXmin[1]*FXmin[2]-FXmin[4])/FXmin[3])*exp(-FXmin[4]/FXmin[0]/Kb/V^.T)/
                       (1-exp((FXmin[1]*FXmin[2]-FXmin[4])/FXmin[0]/Kb/V^.T));
       Param[4]:= Param[2]*(exp(FXmin[4]/FXmin[0]/Kb/V^.T)-1)+FXmin[4]/FXmin[3];
       end;
    end;

WindowClear();
App.Close;
end;

Procedure TFitFunctionLSM.Fitting (V:PVector; var Param:TArrSingle);
begin
if not(IsReady) then SetValueGR;
if not(IsReady) then
   begin
   MessageDlg('Approximation is imposible.'+#10+#13+
                'Parameters of function are undefined', mtError,[mbOk],0);
   Exit;
   end;
BeforeFitness(V);
AproxN(V,Param);
if Param[0]=555 then
  begin
      MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
      Exit;
  end;
DodParDetermination(V,Param);
end;


//Procedure dB_dV_Fun(A:Pvector; var B:Pvector; fun:byte; Isc0:double;
//              Iscbool,Rbool:boolean;D:Diapazon; Mode:byte;
//              Light:boolean;Func:byte);
//{по даним у векторі А будує залежність похідної
//диференційного нахилу ВАХ від напруги (метод Булярського)
//fun - кількість зглажувань
//Isc - струм короткого замикання
//Iscbool=true - потрібно враховувати Isc
//Rbool=true - потрібно враховувати послідовний
//та шунтуючі опори
//D, Mode, Light та Func потрібні лише для
//виклику функції ExpKalkNew}
//var j,id:integer;
//    temp,A_apr,temp_apr,B_apr,Alim:Pvector;
//    tsingle:double;
//    EvolParam:TArrSingle;
//    Fit:TFitFunction;
//begin
// B^.n:=0;
// new(Alim);
// A_B_Diapazon(Light,A,Alim,D);
//
//
// if (Alim^.T=0)or(Alim^.n<3) then
//     begin
//     dispose(Alim);
//     Exit;
//     end;
//
//
//
//new(temp);
//new(A_apr);
//new(temp_apr);
//new(B_apr);
//
//IVchar(Alim,temp);
//IVchar(Alim,A_apr);
//IVchar(Alim,temp_apr);
//
//
//
//
//if Rbool then
//  begin
//{  if Light then MABC (temp,DoubleDiodLight,Mode,EvolParam)
//           else MABC (temp,DoubleDiod,Mode,EvolParam);{}
//  if Light then Fit:=TDoubleDiodLight.Create
//           else Fit:=TDoubleDiodLight.Create;
//  Fit.Fitting(temp,EvolParam);
////  MABC (temp,DoubleDiodLight,Mode,EvolParam)
//////           else DifEvol (temp,DoubleDiod,Mode,EvolParam);
////           else MABC (temp,DoubleDiod,Mode,EvolParam);
//
////  ExpKalkNew(A,D,Mode,Light,Func,AA,Sk,nn,I00,Fbb,Rss,Rsh,Iph,Voc,Isc,Pm,FF);
//
//  if EvolParam[0]=555 then
//          begin
//            dispose(temp);
//            dispose(temp_apr);
//            dispose(A_apr);
//            dispose(B_apr); {}
//            dispose(Alim);
//            Exit;
//          end;
////  if Light then Iph:=EvolParam[6];
////  Rss:=EvolParam[1];
////  Rsh:=EvolParam[3];
////------------------
//  if not(Light) then
//   begin
//     SetLength(EvolParam,7);
//     EvolParam[6]:=0;
//   end;
//
//SetLenVector(A_apr,Alim^.n);
//SetLenVector(temp_apr,Alim^.n);
//
//for j:=0 to High(Alim^.X) do
// begin
//   A_apr^.X[j]:=Alim^.X[j];
//   A_apr^.Y[j]:=Full_IV_2Exp(Alim^.X[j],EvolParam[0]*Kb*Alim^.T,EvolParam[4]*Kb*Alim^.T,
//               EvolParam[1],EvolParam[2],EvolParam[5],EvolParam[3],EvolParam[6]);
// end;
//
////------------------
//
//{ for j:=0 to High(A^.X) do
//    begin
//     temp^.X[j]:=A^.X[j]-Rss*A^.Y[j];
//     temp^.Y[j]:=A^.Y[j]-A^.X[j]/Rsh;
////-------------------
//     temp_apr^.X[j]:=A_apr^.X[j]-Rss*A_apr^.Y[j];
//     temp_apr^.Y[j]:=A_apr^.Y[j]-A_apr^.X[j]/Rsh;
////-------------------
//    end;
//  end;
//}
//
// for j:=0 to High(Alim^.X) do
//    begin
//     temp^.X[j]:=Alim^.X[j];
//     temp^.Y[j]:=Alim^.Y[j];
////-------------------
//     temp_apr^.X[j]:=A_apr^.X[j];
//     temp_apr^.Y[j]:=A_apr^.Y[j];
////-------------------
//    end;
//
//
//  end;
//
//
//{if Iscbool then
//  begin
//   if (Rbool) and (Iph<>0)and(Iph<>555) then
//     for j:=0 to High(temp^.X) do
//        temp^.Y[j]:=temp^.Y[j]+Iph;
//   if not(Rbool) and (Isc0<>0)and(Isc0<>555) then
//     for j:=0 to High(temp^.X) do
//        temp^.Y[j]:=temp^.Y[j]+Isc0;
//  end;}
//
//{if Rbool then
//  for j:=0 to High(A^.X) do
//    begin
//     temp^.X[j]:=A^.X[j]-Rss*A^.Y[j];
//     temp^.Y[j]:=A^.Y[j]-A^.X[j]/Rsh;
//    end;
// }
//
// Diferen (temp,B);
//
// Diferen (temp_apr,B_apr);
//
// if B^.n=0 then
//           begin
//            dispose(temp);
//            dispose(temp_apr);
//            dispose(A_apr);
//            dispose(B_apr); {}
//            dispose(Alim);
//            Exit;
//          end;
//
//
// tsingle:=Alim^.T*Kb;
// for j:=0 to High(B^.X) do
//        begin
//        B^.Y[j]:=1/B^.Y[j]*Alim^.Y[j]/tsingle;
//        B_apr^.Y[j]:=1/B_apr^.Y[j]*A_apr^.Y[j]/tsingle;
//        end;
//// Write_File('DeepL.dat',B);
//// showmessage(inttostr(fun));
//
//
// ForwardIV(B,temp);
// IVchar(temp,B);
// ForwardIV(B_apr,temp_apr);
// IVchar(temp_apr,B_apr);
//
// for j:=1 to fun do
//  begin
//   Smoothing (B,temp);
//   IVchar(temp,B);
//   Smoothing (B_apr,temp_apr);
//   IVchar(temp_apr,B_apr);
//  end;
//
// Diferen (B,temp);
// Diferen (B_apr,temp_apr);
// id:=0;
// for j:=0 to High(temp^.X) do
//        if (temp^.X[j]>0.038)and(temp^.X[j]<(temp^.X[High(temp^.X)]-0.04)) then id:=id+1;
// if id<1 then
//     begin
//       B^.n:=0;
//       dispose(temp);
//       Exit;
//     end;
// SetLenVector(B,id);
// SetLenVector(B_apr,id);
//
//{} id:=0;
// for j:=0 to High(temp^.X) do
//        if (temp^.X[j]>0.038)and(temp^.X[j]<(temp^.X[High(temp^.X)]-0.04)) then
//         begin
//          B^.X[id]:=temp^.X[j];
//          B^.Y[id]:=temp^.Y[j];
//          B_apr^.X[id]:=temp_apr^.X[j];
//          B_apr^.Y[id]:=temp_apr^.Y[j];
//          id:=id+1;
//         end;
//
//if (Rbool)and(not(Iscbool)) then
//  for j := 0 to High(B^.X) do
//    B^.Y[j]:=B^.Y[j]-B_apr^.Y[j];
//{}
//// IVchar(temp,B);
//
//// ForwardIV(temp,B);
// dispose(temp);
// dispose(temp_apr);
// dispose(A_apr);
// dispose(B_apr); {}
// dispose(Alim);
//
//if (Rbool)and(Light) then DataFileWrite('rez.dat',A,EvolParam);
//end;



Procedure FunCreate(str:string; var F:TFitFunction);
{створює F того чи іншого типу залежно
від значення str}
begin
  if str='Linear' then F:=TLinear.Create;
  if str='Quadratic' then F:=TQuadratic.Create;
  if str='Smoothing' then F:=TSmoothing.Create;
  if str='Exponent' then F:=TExponent.Create;
  if str='Median filtr' then F:=TMedian.Create;
  if str='Derivative' then F:=TDerivative.Create;
  if str='Diod' then F:=TDiod.Create;
  if str='Gromov / Lee' then F:=TGromov.Create;
  if str='Ivanov' then F:=TIvanov.Create;
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
  if str='Brailsford' then F:=TBrailsford.Create;
  if str='Phohon Tunneling' then F:=TPhonAsTun.Create;
//  if str='None' then F:=TDiod.Create;
end;


end.
