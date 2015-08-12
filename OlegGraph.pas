unit OlegGraph;
interface
uses OlegType, OlegMath, SysUtils, Dialogs, Classes, Series,
     {Approximation,} Forms,Controls,WinProcs;



{змінні та константи, які потрібні для співпраці
з потоком, де проводиться розрахунок апроксимації
за формулою Ламберта}
var Rs,Rsh,I0,n,Voc,Isc,Iph:double;
    mode,Func:byte;
    Vec:Pvector;



Procedure Read_File (sfile:string; var a:PVector);
{читає дані з файлу з коротким ім'ям sfile в
змінну a, з файлу comments в тій самій директорії
зчитується значення температури в a.T}

Procedure Write_File(sfile:string; A:PVector);
{записує у файл з іменем sfile дані з масиву А;
якщо A^.n=0, то запис у файл не відбувається}

Procedure Write_File_Series(sfile:string; Series:TLineSeries);overload;
{записує у файл з іменем sfile дані з Series;
якщо кількість точок нульова або Series не створена,то запис у файл не відбувається}

Procedure Write_File_Series(sfile:string; Series:TPointSeries);overload;
{записує у файл з іменем sfile дані з Series;
якщо кількість точок нульова або Series не створена,то запис у файл не відбувається}

Procedure Sorting (var A:PVector);
{процедура сортування (методом бульбашки)
даних у масиві А по зростанню компоненти А^.Х}

Procedure IVchar(a:Pvector; var b:Pvector);
{заносить копію з а в b}

Procedure LogX(A:Pvector; var B:Pvector);
{записує з A в B тільки ті точки, для яких
координата Х більше нуля}

Procedure LogY(A:Pvector; var B:Pvector);
{записує з A в B тільки ті точки, для яких
координата Y більше нуля}

Procedure ForwardIV(A:Pvector; var B:Pvector);
{записує з A в B тільки ті точки, які відповідають
прямій ділянці ВАХ (для яких координата X більше нуля)}

Procedure ReverseIV(A:Pvector; var B:Pvector);
{записує з A в B тільки ті точки, які відповідають
зворотній ділянці ВАХ (для яких координата X менше нуля),
причому записує модуль координат}

Procedure PidgFun(A:Pvector; var B:Pvector);
{підготовча процедура до побудови багатьох функцій;
визначає діапазон B^.N_begin та B^.N_end, для
яких у векторі А значення Х>0.01 та Y>0,
встановлює величину B^.n та розміри масивів B^.X та B^.Y;
саме заповнення масиву В не відбувається}

Procedure ChungFun(A:Pvector; var B:Pvector);
{записує в B Chung-функцію, побудовану по даним з А}

Procedure WernerFun(A:Pvector; var B:Pvector);
{записує в B функцію Вернера, побудовану по даним з А}

Procedure MikhAlpha_Fun(A:Pvector; var B:Pvector);
{записує в B Альфа-функцію (метод Міхелешвілі),
побудовану по даним з А,
Alpha=d(ln I)/d(ln V)}

Procedure MikhBetta_Fun(A:Pvector; var B:Pvector);
{записує в B Бетта-функцію (метод Міхелешвілі),
побудовану по даним з А,
Betta = d(ln Alpha)/d(ln V)
P.S. в статті ця функція називається Гамма}

Procedure MikhN_Fun(A:Pvector; var B:Pvector);
{записує в B залежність фактору неідеальності від
прикладеної напруги, пораховану за методом
метод Міхелешвілі, за даними векора А;
n = q V (Alpha - 1) [1 + Betta/(Alpha-1)] / k T Alpha^2}

Procedure MikhRs_Fun(A:Pvector; var B:Pvector);
{записує в B залежність послідовного опору від
прикладеної напруги, пораховану за методом
метод Міхелешвілі, за даними векора А;
Rs = V (1- Betta) / I Alpha^2}

Procedure HFun(A:Pvector; var B:Pvector; AA, Szr, N:double);
{записує в B H-функцію, побудовану по даним з А:
AA - стала Річардсона, Szr - площа контакту,
N - фактор неідеальності}

Procedure NordeFun(A:Pvector; var B:Pvector; AA, Szr, Gam:double{; Gam:word});
{записує в B функцію Норда, побудовану по даним з А;
AA - стала Річардсона, Szr - площа контакту,
Gam - показник гамма (див формулу)}

Procedure CibilsFunDod(A:Pvector; var B:Pvector; Va:double);
{записує в B функцію F(V)=V-Va*ln(I), побудовану по даним з А}

Procedure CibilsFun(A:Pvector; D:Diapazon; var B:Pvector);
{записує в B функцію Сібілса, побудовану по даним з А;
діапазон зміни напруги від kT до тих значень,
при яких функція F(V)=V-Va*ln(I) ще має мінімум,
крок - 0.001}

Procedure LeeFunDod(A:Pvector; var B:Pvector; Va:double);
{записує в B функцію F(I)=V-Va*ln(I), побудовану по даним з А}

Procedure LeeFun(A:Pvector; D:Diapazon; var B:Pvector);
{записує в B функцію Lee, побудовану по даним з А;
діапазон зміни напруги від kT до подвоєного найбільшого
позитивного значення напруги у вихідній ВАХ;
крок - 0.02;
в полі B^.T розміщюється не температура,
а параметр А апроксимації функцією А+B*x+C*ln(x);
він однаковий незалежно від величини Va і
використовується в функції LeeKalk для
розрахунку висоти бар'єру; ось такий контрабандний прийом :)}

Procedure ForwardIVwithRs(A:Pvector; var B:Pvector; Rs:double);
{записує в В пряму ділянку ВАХ з А з
врахуванням величини послідовного опору Rs}

Procedure Forward2Exp(A:Pvector; var B:Pvector; Rs:double);
{записує в В залежність величини
I/[1-exp(-qV/kT)] від напруги з
врахуванням величини послідовного опору Rs
для прямої ділянки з А}

Procedure Reverse2Exp(A:Pvector; var B:Pvector; Rs:double);
{записує в В залежність величини
I/[1-exp(-qV/kT)] від напруги з
врахуванням величини послідовного опору Rs
для зворотньої ділянки з А}

Procedure N_V_Fun(A:Pvector; var B:Pvector; Rs:double);
{записує в В залежність коефіцієнту неідеальності
від напруги використовуючи вираз n=q/kT* d(V)/d(lnI);
залежність I=I(V), яка знаходиться в А, спочатку
модифікується з врахуванням величини послідовного опору Rs}

Procedure M_V_Fun(A:Pvector; var B:Pvector; Bool:boolean; fun:word);
{по даним у векторі А будує функцію залежно від значення fun:
fun=1 - залежність коефіцієнта m=d(ln I)/d(ln V) від напруги
(для випадку коли  I=const*V^m);
2 - функція Фаулера-Нордгейма для прикладеної напруги
    ln(I/V^2)=f(1/V);
3 - функція Фаулера-Нордгейма для максимальної напруженості
    ln(I/V)=f(1/V^0.5);
4 - функція Абелеса для прикладеної напруги
    ln(I/V)=f(1/V);
5 - функція Абелеса для максимальної напруженості
    ln(I/V^0.5)=f(1/V^0.5);
6 - функція Френкеля-Пула для прикладеної напруги
    ln(I/V)=f(V^0.5);
7 - функція Френкеля-Пула для максимальної напруженості
    ln(I/V^0.5)=f(1/V^0.25);
якщо Bool=true, то будується залежність для прямої гілки,
якщо Bool=false - для зворотньої}



Procedure Nss_Fun(A:Pvector; var B:Pvector;
                  Fb,Rs,del,ep:double; D:Diapazon; nV:boolean);
{записує в В залежність густини станів
Nss=ep*ep0*(n-1)/q*del від різниці Ес-Ess=(Fb-V/n),
[Nss] = еВ-1 см-2; [Ec-Ess] = еВ;
n - фактор неідеальності,
nV - вибір яким методом обчислювати n
     true - за допомогою похідної
     (див попередню функцію);
     false - за методом Міхелешвілі
ер - діелектрична проникність напівпровідника
ер0 - діелектрична стала
del - товщина діелектричного шару
Fb - висота бар'єру Шотки
Rs - величина послідовного опору}

Procedure Dit_Fun(A:Pvector; var B:Pvector;
                  Rs,AA,Szr,Nd,eps:double; D:Diapazon);
{записує в В залежність густини станів,
обчислену за методом Іванова,
Dit=ep*ep0/(q^2*del)*d(Vcal-Vexp)/dVs
від різниці Ес-Ess=(Fb-qVs),
[Dit] = еВ-1 см-2; [Ec-Ess] = еВ;
ер - діелектрична проникність діелектрика
ер0 - діелектрична стала
del - товщина діелектричного шару
Rs - величина послідовного опору
Vcal та Vexp - розраховане та виміряне
значення напруги при однакових значеннях сируму;
Vcal=Vs+del*[Sqrt(2q*Nd*eps/eps0) (Sqrt(Fb/q)-Sqrt(Fb/q-Vs))]
Vexp=V-IRs
eр - діелектрична проникність напівпровідника
Fb - висота бар'єру Шотки
Nd - концентрація донорів у напівпровіднику;
Vs - падіння напруги на ОПЗ напівпровідника
Vs=Fb/q-kT/q*ln(Szr*AA*T^2/I);
AA - стала Річардсона
Szr - площа контакту
}


Procedure IvanovAprox (V:PVector; AA, Szr, Nd, ep:double;
                       var del,Fb:double);
{апроксимація даних у векторі V параметричною залежністю
I=Szr AA T^2 exp(-Fb/kT) exp(qVs/kT)
V=Vs+del*[Sqrt(2q Nd ep / eps0) (Sqrt(Fb/q)-Sqrt(Fb/q-Vs))]
де
AA - стала Річардсона
Szr - площа контакту
Fb - висота бар'єру Шотки
Vs - падіння напруги на ОПЗ напівпровідника
     (параметр залежності)
del - товщина діелектричного шару
(якщо точніше - товщина шару, поділена на
величину відносної діелектричної проникності шару)
Nd - концентрація донорів у напівпровіднику;
eр - діелектрична проникність напівпровідника
ер0 - діелектрична стала
підбираються значення del та Fb
}

Procedure A_B_Diapazon(Avuh,A:Pvector; var B:Pvector; D:Diapazon);overload;
{записує в В ті точки з вектора А, відповідні
до яких точки у векторі Avuh (вихідному) задовольняють
умовам D; зрозуміло, що для вектора А
мають бути відомими А^.N_begin та А^.N_end (хоча б перше);
B^.N_begin, B^.N_end не розраховуються}

Procedure A_B_Diapazon(Light:boolean;A:Pvector; var B:Pvector; D:Diapazon);overload;
{записує в В ті точки з вектора А, які
задовольняють умовам D;
B^.N_begin, B^.N_end не розраховуються
Якщо Light=True, то обмеження
на Ymin не використовуеться - потрібно
для аналізу ВАХ освітлених елементів}


Procedure Kam1_Fun (A:Pvector; var B:Pvector; D:Diapazon);
{записує в B функцію Камінскі першого роду
спираючись на ті точки вектора А, які задовольняють
умови D}

Procedure Kam2_Fun (A:Pvector; var B:Pvector; D:Diapazon);
{записує в B функцію Камінскі другого роду
спираючись на ті точки вектора А, які задовольняють
умови D}

Procedure Gr1_Fun (A:Pvector; var B:Pvector);
{записує в B функцію Громова першого роду
спираючись на точки вектора А}

Procedure Gr2_Fun (A:Pvector; var B:Pvector; AA, Szr:double);
{записує в B функцію Громова другого роду
спираючись на точки вектора А}

Procedure LimitFun(A, A1:Pvector; var B:Pvector; Lim:Limits);
{записує з А в В тільки ті точки, для яких
в масиві А1 виконуються умови, розташовані в Lim}

Function PoinValide(Dp:Diapazon; Original, Secondary:Pvector; k:integer): boolean;
{визначає, чи задовільняють координати точки
вектора Original, яка відповідає k-ій точці
вектора Secondary, умовам, записаним в змінній D;}

Function PoinValideYmin(Dp:Diapazon; Original, Secondary:Pvector; k:integer): boolean;
{визначає, чи задовільняють координати точки
вектора Original, яка відповідає k-ій точці
вектора Secondary, умовам, записаним в змінній D;
не розглядається лише умова для Ymin -
потрібно для аналізу ВАХ освітлених елементів}

Procedure ChungKalk(A:PVector; D:Diapazon; var Rs:double; var n:double);
{на основі даних з вектора А шляхом побудови та
лінійної апроксимації функції Чюнга (з врахуванням
обмежень, вказаних в D), визначає величину
послідовного опору Rs та коефіцієнта неідеальності n}

Procedure WernerKalk(A:PVector; var D:Diapazon; var Rs:double; var n:double);
{на основі даних з вектора А шляхом побудови та
лінійної апроксимації функції Вернера (з врахуванням
обмежень, вказаних в D), визначає величину
послідовного опору Rs та коефіцієнта неідеальності n}

Procedure MikhKalk(A:PVector; D:Diapazon; AA, Szr:double;
                   var Rs:double; var n:double; var I0:double; var Fb:double);
{на основі даних з вектора А за допомогою
методу Міхелешвілі визначаються величини
послідовного опору Rs, коефіцієнта неідеальності n,
висоти бар'єру Fb та струму насичення І0;
якщо температура не задана, то визначається
лише Rs та I0, решті величин присвоюється значення 555;
якщо неможливо побудувати функцію Громова,
то і ці величини 555;
AA - стала Річардсона,
Szr - площа контакту}

Procedure HFunKalk(A:Pvector; D:Diapazon; AA, Szr, N:double;
                   var Rs:double; var Fb:double);
{на основі даних з вектора А шляхом побудови та
лінійної апроксимації H-функції (з врахуванням
обмежень, вказаних в D), визначає величину
послідовного опору Rs та висоти бар'єру Fb;
для побудови Н-функції потрібні
AA - стала Річардсона,
Szr - площа контакту,
N - фактор неідеальності}

Procedure ExKalk(Index:integer; A:Pvector; D:Diapazon; Rs, AA, Szr :double;
                 var n:double; var I0:double; var Fb:double);overload;
{на основі даних з вектора А шляхом
лінійної апроксимації ВАХ в напівлогарифмічному
масштабі (з врахуванням
обмежень, вказаних в D), визначає величину
коефіцієнту неідеальності n,
струму насичення І0
висоту бар'єру Fb;
Фактично, це апроксимація за формулою I=I0exp(V/nkT)
Index вказує що саме апроксимується:
1 - величина вихідного струму І
2 - величина I/[1-exp(-qV/kT)] для прямої гілки
3 - величина I/[1-exp(-qV/kT)] для зворотньої гілки
для побудови ВАХ потрібний
Rs - послідовний опір,
для визначення Fb
AA - стала Річардсона,
Szr - площа контакту}

Procedure ExKalk_nconst(Index:integer; A:Pvector; D:Diapazon; Rs, AA, Szr :double;
                 n:double; var I0:double; var Fb:double);overload;
{на основі даних з вектора А шляхом
лінійної апроксимації ВАХ в напівлогарифмічному
масштабі (з врахуванням
обмежень, вказаних в D),
та значення коефіцієнту неідеальності n
визначає величину
струму насичення І0
висоту бар'єру Fb;
Фактично, це апроксимація за формулою I=I0exp(V/nkT)
Index вказує що саме апроксимується:
1 - величина вихідного струму І
2 - величина I/[1-exp(-qV/kT)] для прямої гілки
3 - величина I/[1-exp(-qV/kT)] для зворотньої гілки
для побудови ВАХ потрібний
Rs - послідовний опір,
для визначення Fb
AA - стала Річардсона,
Szr - площа контакту}


Procedure ExKalk(A:Pvector; AA, Szr :double;
                 var n:double; var I0:double; var Fb:double);overload;
{на основі даних з вектора А шляхом
лінійної апроксимації ВАХ в напівлогарифмічному
масштабі, визначає величину
коефіцієнту неідеальності n,
струму насичення І0
висоту бар'єру Fb;
Фактично, це апроксимація за формулою I=I0exp(V/nkT)
для визначення Fb потрібні
AA - стала Річардсона,
Szr - площа контакту}

Procedure ExpKalk(A:Pvector; D:Diapazon; Rs, AA, Szr :double; Xp:IRE;
                 var n:double; var I0:double; var Fb:double);
{на основі даних з вектора А шляхом
апроксимації ВАХ за формулою I=I0(exp(V/nkT)-1)+V/R
(з врахуванням обмежень, вказаних в D), визначає величину
коефіцієнту неідеальності n,
струму насичення І0
висоту бар'єру Fb;
для побудови ВАХ потрібний
Rs - послідовний опір,
Хр   - вектор початкових наближень
для визначення Fb
AA - стала Річардсона,
Szr - площа контакту}

//Procedure ExpKalkNew(A:Pvector; D:Diapazon; Mode:byte;
//         Light:boolean; Func:byte; AA, Szr :double;
//    var n:double; var I0:double; var Fb:double;var Rs:double;
//    var Rsh:double; var Iph:double; var Voc:double; var Isc:double;
//    var Pm:double; var FF:double);
//{на основі даних з вектора А шляхом
//прямої апроксимації ВАХ за формулою
//І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
//(з врахуванням обмежень, вказаних в D), визначає величину
//коефіцієнту неідеальності n,
//струму насичення І0
//висоту бар'єру Fb;
//послідовний опір Rs;
//шунтуючий опір Rsh;
//фотострум Iph;
//напругу холостого ходу Voc;
//струм короткого замикання Isc;
//максимальну вихідну потужність фотоелементу Pm;
//коефіцієнт форми ВАХ фотоелементу  FF;
//При Func=0 використовується метод прямої апроксимації,
//    Func=1 - функція Ламберта,
//    Func=2 - метод диференційної еволюції;
//при Light=False - Iph=0, Voc=0, Isc=0, Pm=0, FF=0;
//при Mode=1 - Rsh=1e12;
//при Mode=2 - Rs=1e-4;
//при Mode=3 - Rsh=1e12 та  Rs=1e-4;
//при Mode=0 - розраховуються всі величини;
//для визначення Fb потрібні
//AA - стала Річардсона,
//Szr - площа контакту}

//Procedure KalkOneDiod(A:Pvector; D:Diapazon; Mode:byte;
//         Light:boolean; EvolType:TEvolutionType;
//    var n:double; var I0:double; var Rs:double;
//    var Rsh:double; var Iph:double; var Voc:double; var Isc:double;
//    var Pm:double; var FF:double);
//{на основі даних з вектора А шляхом
//еволюційної апроксимації ВАХ за формулою
//І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
//(з врахуванням обмежень, вказаних в D), визначає величину
//коефіцієнту неідеальності n,
//струму насичення І0
//послідовний опір Rs;
//шунтуючий опір Rsh;
//фотострум Iph;
//напругу холостого ходу Voc;
//струм короткого замикання Isc;
//максимальну вихідну потужність фотоелементу Pm;
//коефіцієнт форми ВАХ фотоелементу  FF;
//EvolType - визначає еволюційний алгоритм
// (див. OlegType)
//
//при Light=False - Iph=0, Voc=0, Isc=0, Pm=0, FF=0;
//при Mode=1 - Rsh=1e12;
//при Mode=2 - Rs=0;
//при Mode=3 - Rsh=1e12 та  Rs=0;
//при Mode=0 - розраховуються всі величини;
//}

//Procedure KalkTwoDiod(A:Pvector; D:Diapazon; Mode:byte;
//         Light:boolean; EvolType:TEvolutionType;
//    var n1:double; var I01:double; var n2:double; var I02:double;
//    var Rs:double;
//    var Rsh:double; var Iph:double; var Voc:double; var Isc:double;
//    var Pm:double; var FF:double);
//{на основі даних з вектора А шляхом
//еволюційної апроксимації ВАХ за формулою
//І=I01*[exp(q(V-IRs)/n1kT)-1]+I02*[exp(q(V-IRs)/n2kT)-1]+(V-IRs)/Rsh-Iph
//(з врахуванням обмежень, вказаних в D), визначає величину
//коефіцієнтів неідеальності n1 та n2,
//струмів насичення І01 та І02,
//послідовний опір Rs;
//шунтуючий опір Rsh;
//фотострум Iph;
//напругу холостого ходу Voc;
//струм короткого замикання Isc;
//максимальну вихідну потужність фотоелементу Pm;
//коефіцієнт форми ВАХ фотоелементу  FF;
//EvolType - визначає еволюційний алгоритм
// (див. OlegType)
//
//при Light=False - Iph=0, Voc=0, Isc=0, Pm=0, FF=0;
//при Mode=1 - Rsh=1e12;
//при Mode=2 - Rs=0;
//при Mode=3 - Rsh=1e12 та  Rs=0;
//при Mode=0 - розраховуються всі величини;
//}


//
//Procedure KalkDiodTwo(A:Pvector; D:Diapazon; AA, Szr :double;
//    var n:double; var I0:double; var Fb:double; var Rs:double;
//    var Iph:double; var FF:double);

//Procedure KalkDiodTwoFull(A:Pvector; D:Diapazon; AA, Szr :double;
//    var n:double; var I0:double; var Fb:double; var Rs:double;
//    var Iph:double; var Voc:double; var Isc:double);


Procedure NordDodat(A:Pvector; D:Diapazon; AA, Szr,Gamma:double;
                   var V0:double; var I0:double; var F0:double);
{на основі даних з вектора А (з рахуванням
обмежень в D) будує функцію Норда та визначає
координату її мінімума V0, відповідне
значення самої фуекції F0 та значення струму І0,
яке відповідає V0 у вихідних даних}

Procedure NordKalk(A:Pvector; D:Diapazon; AA, Szr, Gamma:double; {Gamma:word;}
                   n:double; var Rs:double; var Fb:double);
{на основі даних з вектора А шляхом побудови
функції Норда (з врахуванням
обмежень, вказаних в D), визначає величину
послідовного опору Rs та висоти бар'єру Fb;
для побудови функції Норда потрібні
AA - стала Річардсона,
Szr - площа контакту,
Gamma - параметр гамма (див формулу)
для обчислення Rs
n - показник ідеальності}

Procedure CibilsKalk(const A:Pvector; const D:Diapazon;
                     out Rs:double; out n:double);
{на основі даних з вектора А шляхом побудови
функції Сібілса, визначає величину
послідовного опору Rs та
показника ідеальності n}

Procedure IvanovKalk(A:Pvector; D:Diapazon; Rs, AA, Szr, Nd, ep:double;
                     var del:double; var Fb:double);
{на основі даних з вектора А (з врахуванням
обмежень, вказаних в D), за методом Іванова
визначає величину товщини діелектричного шару del
(якщо точніше - товщини шару, поділеної на
величину відносної діелектричної проникності шару)
та висота бар'єру Fb;
AA - стала Річардсона
Szr - площа контакту
Nd - концентрація донорів у напівпровіднику;
eр - діелектрична проникність напівпровідника
Rs - послідовний опір, апроксимацію потрібно проводити
для ВАХ, побудованої з врахуванням Rs
}


Procedure Kam1Kalk (A:Pvector; D:Diapazon; var Rs:double; var n:double);
{на основі даних з вектора А шляхом побудови
функції Камінські (з врахуванням
обмежень, вказаних в D), визначає величину
послідовного опору Rs та коефіцієнта неідеальності n}

Procedure Kam2Kalk (const A:Pvector; const D:Diapazon; out Rs:double; out n:double);
{на основі даних з вектора А шляхом побудови
функції Камінські (з врахуванням
обмежень, вказаних в D), визначає величину
послідовного опору Rs та коефіцієнта неідеальності n}

Procedure Gr1Kalk (A:Pvector; D:Diapazon; AA, Szr:double;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{на основі даних з вектора А (з врахуванням
обмежень, вказаних в D) методом Громова
першого роду визначаються величини
послідовного опору Rs, коефіцієнта неідеальності n,
висоти бар'єру Fb та струму насичення І0;
якщо температура не задана, то визначається
лише Rs, решті величин присвоюється значення 555;
якщо неможливо побудувати функцію Громова,
то і Rs=555}

Procedure Gr2Kalk (A:Pvector; D:Diapazon; AA, Szr:double;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{на основі даних з вектора А (з врахуванням
обмежень, вказаних в D) методом Громова
другого роду визначаються величини
послідовного опору Rs, коефіцієнта неідеальності n,
висоти бар'єру Fb та струму насичення І0;
якщо температура не задана, то визначається
лише Rs, решті величин присвоюється значення 555;
якщо неможливо побудувати функцію Громова,
то і Rs=555}

Procedure BohlinKalk(A:Pvector; D:Diapazon; AA, Szr, Gamma1,Gamma2:double;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{на основі даних з вектора А (з врахуванням
обмежень, вказаних в D), за допомогою
методу Бохліна визначаються величини
послідовного опору Rs, фактора
неідеальності n та висоти бар'єру Fb
(а також струму насичення І0;
для побудови функцій Норда потрібні
AA - стала Річардсона,
Szr - площа контакту,
Gamma - параметр гамма,
друге значення гамма просте береться
на дві десятих більше ніж Gamma}

Procedure LeeKalk (A:Pvector; D:Diapazon; AA, Szr:double;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{на основі даних з вектора А (з врахуванням
обмежень, вказаних в D) методом побудови
функції Лі визначаються величини
послідовного опору Rs, коефіцієнта неідеальності n,
висоти бар'єру Fb та струму насичення І0;
якщо температура не задана, то визначається
лише Rs, решті величин присвоюється значення 555;
якщо неможливо побудувати функцію Лі,
то і Rs=555}

Function Y_X0 (X1,Y1,X2,Y2,X3:double):double;
{знаходить ординату точки з абсцисою Х3,
яка знаходиться між точками (Х1,Y1) та (X2,Y2) -
лінійна інтерполяція по двом точкам}

Function X_Y0 (X1,Y1,X2,Y2,Y3:double):double;
{знаходить абсцису точки з ординатою Y3,
яка знаходиться між точками (Х1,Y1) та (X2,Y2) -
лінійна інтерполяція по двом точкам}

function ChisloY (A:Pvector; X:double):double;
{визначає приблизну ординату точки з
абсцисою Х для випадку, коли ця точка
входила б до функціональної залежності,
записаної в А;
якщо Х не належить діапазону зміни
абсцис вектора А, то повертається 555}

function ChisloX (A:Pvector; Y:double):double;
{визначає приблизну абсцису точки з
ординатою Y для випадку, коли ця точка
входила б до функціональної залежності,
записаної в А;
якщо Y не належить діапазону зміни
ординат вектора А, то повертається 555}

function Krect(A:Pvector; V:double):double;
{обчислення коефіцієнту випрямлення
за даними у векторі А при напрузі V;
якщо точок в потрібному діапазоні немає -
пишиться повідомлення і повертається 555}

function IscCalc(A:Pvector):double;
{обчислюється струм короткого замикання
за даними у векторі А}

function VocCalc(A:Pvector):double;
{обчислюється напруга холостого ходу
за даними у векторі А}

Function Extrem (A:PVector):double;
{знаходить абсцису екстремума функції,
що знаходиться в А;
вважаеться, що екстремум один;
якщо екстремума немає - повертається 555;
якщо екстремум не чіткий - значить будуть
проблеми :-)}

Procedure GraphFill(Series:TLineSeries;Func:TFunSingle;
                    x1,x2:double;Npoint:word);overload;
{заповнює Series значеннями Func(х) в діапазоні
від х1 до х2 з загальною кількістю точок Npoint+1}

Procedure GraphFill(Series:TLineSeries;Func:TFunDouble;
                    x1,x2:double;Npoint:word;y0:double);overload;
{заповнює Series значеннями Func(х,y0) в діапазоні
від х1 до х2 з загальною кількістю точок Npoint+1}

//Procedure LamRshAprox (V:PVector; mode:byte; var n,Rs,I0,Rsh:double);
//{апроксимуються дані у векторі V
//залежністю I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh
//з використанням функції Ламберта
//за методом найменших квадратів зі
//статистичними ваговими коефіцієнтами;
//mode - режим апроксимації:
//mode = 0 - всі чотири параметри підбираються;
//mode = 1 - вважається, що Rsh нескінченність (1е12);
//mode = 1 - вважається, що Rs нульовий(1е-4)
//mode = 3 - Rsh нескінченність + Rs нульовий
//}

{Procedure Aprox (Func0:byte;V:PVector; mode0:byte; var n0,Rs0,I00,Rsh0:double);overload;
{апроксимуються дані у векторі V
залежністю I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh
за методом найменших квадратів зі
статистичними ваговими коефіцієнтами;

Func0 - функція, яка використовується
для апроксимації:
Func0 = 0 - безпосередньо виразом
          I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh;
Func0 = 1 - використовується функція Ламберта;

mode0 - режим апроксимації:
mode0 = 0 - всі чотири параметри підбираються;
mode0 = 1 - вважається, що Rsh нескінченність (1е12);
mode0 = 1 - вважається, що Rs нульовий(1е-4)
mode0 = 3 - Rsh нескінченність + Rs нульовий
}

{Procedure Aprox (Func0:byte; V:PVector; mode0:byte; var n0,Rs0,I00,Rsh0,Isc0,Voc0,Iph0:double);overload;
{апроксимуються ВАХ при освітленні у векторі V
залежністю I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
за методом найменших квадратів зі
статистичними ваговими коефіцієнтами
з використанням функції Ламберта;

Func0 = 3 - безпосередньо виразом
          I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph;
Func0 = 4 - використовується функція Ламберта;

mode0 - режим апроксимації:
mode0 = 0 - всі параметри підбираються;
mode0 = 1 - вважається, що Rsh нескінченність (1е12);
mode0 = 1 - вважається, що Rs нульовий(1е-4)
mode0 = 3 - Rsh нескінченність + Rs нульовий
}

//Procedure Aprox (Func0:byte; V:PVector; mode0:byte; var n0,Rs0,I00,Rsh0,Isc0,Voc0,Iph0:double);
//{апроксимуються ВАХ при освітленні у векторі V
//залежністю I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
//за методом найменших квадратів зі
//статистичними ваговими коефіцієнтами
//
//Func0 = 0 - безпосередньо виразом
//          I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh;
//Func0 = 1 - використовується функція Ламберта;
//Func0 = 3 - безпосередньо виразом
//          I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph;
//Func0 = 4 - використовується функція Ламберта;
//
//mode0 - режим апроксимації:
//mode0 = 0 - всі параметри підбираються;
//mode0 = 1 - вважається, що Rsh нескінченність (1е12);
//mode0 = 1 - вважається, що Rs нульовий(1е-4)
//mode0 = 3 - Rsh нескінченність + Rs нульовий
//}

Function Voc_Isc_Pm(mode:byte;Vec:PVector;n,Rs,I0,Rsh,Iph:double):double;
{обчислюється Voc (при mode=1),
Isc (при mode=2) чи максимальну
вихідну потужність (при mode=3) по відомим значеннм
n, Rs, I0, Rsh, Iph для значень в Vec.
Використовується метод дихотомії
для розв'язку рівняння
I0*[exp(qVoc/nkT)-1]+Voc/Rsh-Iph=0
або
I0*[exp(qRsIsc/nkT)-1]+RsIsc/Rsh-Iph+Isc=0.
FF обчислюється на основі апроксимації ВАХ
функцією Ламберта
I=V/Rs-Rsh(RsIph+RsI0+V)/Rs/(Rs+Rsh)+
  nkT/q/Rs*Lambert(qRsI0Rsh/((Rs+Rsh)nkT)exp(Rsh(RsIph+RsI0+V)/(nkT(Rs+Rsh)))
a саме, методом дихотомії знаходиться екстремум функції Pm=I*V
і обчислюється саме екстремальне значення
}

Function Voc_Isc_Pm_DoubleDiod(mode:byte;E1,E2,Rs,I01,I02,Rsh,Iph:double):double;

{обчислюється Voc (при mode=1),
Isc (при mode=2) чи максимальну
вихідну потужність (при mode=3) по відомим значенням
Е1, Е2, Rs, I01, I02, Rsh, Iph, вважаючи, що  ВАХ
має описуватися двома експонентами.
Використовується метод дихотомії
для розв'язку рівняння
I01*[exp(qVoc/Е1)-1]+I02*[exp(qVoc/Е2)-1]+Voc/Rsh-Iph=0
або
I01*[exp(qRsIsc/Е1)-1]+I02*[exp(qRsIsc/Е2)-1]+RsIsc/Rsh-Iph+Isc=0.
}


//Procedure DE2Exp (V:PVector; var n1,Rs1,I01,n2,I02:double);
//{апроксимуються дані у векторі V
//залежністю I=I01[exp((V-IRs1)/n1kT)-1]+I=I02[exp(V/n2kT)-1]
//за методом differential evoluation}


//Procedure TLBO (V:PVector; FuncType:TFuncType; mode:byte; var Param:TArrSingle);
//{апроксимуються дані у векторі V за методом teaching learning based optimization;
//FuncType визначає апроксимуючу функцію,
//mode - уточнює режим апроксимації:
//------------FuncType = diod
//залежнісь I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh
//Param[0] - n; Param[1] - Rs; Param[2] - I0; Param[3] - Rsh;
//mode = 0 - всі чотири параметри підбираються;
//mode = 1 - вважається, що Rsh нескінченність (1е12);
//mode = 2 - вважається, що Rs нульовий(1е-4)
//mode = 3 - Rsh нескінченність + Rs нульовий
//-------FuncType = photodiod
//залежнісь I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
//Param[4] - Iph, решта - див. diod}
//
//Procedure DifEvol (V:PVector; FuncType:TFuncType; mode:byte; var Param:TArrSingle);
//{апроксимуються дані у векторі V за методом teaching learning based optimization;
//FuncType визначає апроксимуючу функцію,
//mode - уточнює режим апроксимації:
//--------FuncType = diod
//залежнісь I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh
//Param[0] - n; Param[1] - Rs; Param[2] - I0; Param[3] - Rsh;
//mode = 0 - всі чотири параметри підбираються;
//mode = 1 - вважається, що Rsh нескінченність (1е12);
//mode = 2 - вважається, що Rs нульовий(1е-4)
//mode = 3 - Rsh нескінченність + Rs нульовий;
//-------FuncType = photodiod
//залежнісь I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
//Param[4] - Iph, решта - див. diod
//}
//
//Procedure MABC (V:PVector; FuncType:TFuncType; mode:byte; var Param:TArrSingle);
//{апроксимуються дані у векторі V за методом modified artificial bee colony;
//FuncType визначає апроксимуючу функцію,
//mode - уточнює режим апроксимації:
//--------FuncType = diod
//залежнісь I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh
//Param[0] - n; Param[1] - Rs; Param[2] - I0; Param[3] - Rsh;
//mode = 0 - всі чотири параметри підбираються;
//mode = 1 - вважається, що Rsh нескінченність (1е12);
//mode = 2 - вважається, що Rs нульовий(1е-4)
//mode = 3 - Rsh нескінченність + Rs нульовий;
//-------FuncType = photodiod
//залежнісь I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
//Param[4] - Iph, решта - див. diod
//--------FuncType = DiodTwo
//залежнісь I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp(V/n2kT)-1]
//Param[0] - n1; Param[1] - Rs; Param[2] - I01; Param[3] - n2;Param[3] - I02;
//}

Procedure DataFileWrite(fname:string;Vax:PVector;Param:TArrSingle);

implementation
//uses ApprThread;
{var thread:Apr;}


Procedure Read_File (sfile:string; var a:Pvector);
var F:TextFile;
    i:integer;
    ss, ss1:string;
    {drive:char;
    {path, fileName:string;}
    {SR : TSearchRec;}

begin
   a^.name:=sfile;
 {--------определяет колличество строк------------}
   AssignFile(f,sfile);
   Reset(f);
   a^.n:=0;
   while not(eof(f)) do
       begin
        a^.n:=a^.n+1;
        readln(f);
       end;
   CloseFile(f);

   a^.N_begin:=0;
   a^.N_end:=a^.n;

   SetLength(a^.X, a^.n);
   SetLength(a^.Y, a^.n);
 {a^.n:=i;}
 {---------считывание данных--------}
   Reset(f);
   for i := 0 to High (a^.X) do
      readln(f,a^.x[i],a^.y[i]);
   CloseFile(f);

 {-------считывание температуры и времени создания, если файла
 соmments нет или там отсутствует запись
 про соответствующий файл, то значение будет нулевым}
 a^.T:=0;
 a^.time:='';
  if FileExists('comments') then
    begin
     AssignFile(f,'comments');
     Reset(f);
     while not(Eof(f)) do
      begin
       readln(f,ss);
       ss1:=ss;
       delete(ss,AnsiPos(' ',ss),Length(ss)-AnsiPos(' ',ss)+1);
       if AnsiUpperCase(ss)=AnsiUpperCase(sfile) then
         begin
           delete(ss1,1,AnsiPos(':',ss1)-3);
           ss1:=Trim(ss1);
           readln(f,ss);
           delete(ss,1,2);
           delete(ss,AnsiPos(' ',ss),Length(ss)-AnsiPos(' ',ss)+1);
           break;
         end;
      end;
     {ShowMessage(ss1);}
     Try
     a^.T:=StrToFloat(ss);
     a^.time:=ss1;
     Except
     a^.T:=0;
     a^.time:='';
     End;
      CloseFile(f);
   end;
 Sorting(A);
 end;

 Procedure Write_File(sfile:string; A:PVector);
{записує у файл з іменем sfile дані з масиву А;
якщо A^.n=0, то запис у файл не відбувається}
var i:integer;
    Str:TStringList;
begin
if A^.n=0 then Exit;
Str:=TStringList.Create;
for I := 0 to High(A^.x) do
   Str.Add(FloatToStrF(A^.X[i],ffExponent,4,0)+' '+
           FloatToStrF(A^.Y[i],ffExponent,4,0));
Str.SaveToFile(sfile);
Str.Free;
end;

Procedure Write_File_Series(sfile:string; Series:TLineSeries);overload;
{записує у файл з іменем sfile дані з Series;
якщо кількість точок нульова або Series не створена,то запис у файл не відбувається}
var i:integer;
    Str:TStringList;
begin
if (not Assigned(Series)) or (Series.Count<1) then Exit;
Str:=TStringList.Create;
for I := 0 to Series.Count-1 do
   Str.Add(FloatToStrF(Series.XValue[i],ffExponent,4,0)+' '+
           FloatToStrF(Series.YValue[i],ffExponent,4,0));
Str.SaveToFile(sfile);
Str.Free;
end;

Procedure Write_File_Series(sfile:string; Series:TPointSeries);overload;
{записує у файл з іменем sfile дані з Series;
якщо кількість точок нульова або Series не створена,то запис у файл не відбувається}
var i:integer;
    Str:TStringList;
begin
if (not Assigned(Series)) or (Series.Count<1) then Exit;
Str:=TStringList.Create;
for I := 0 to Series.Count-1 do
   Str.Add(FloatToStrF(Series.XValue[i],ffExponent,4,0)+' '+
           FloatToStrF(Series.YValue[i],ffExponent,4,0));
Str.SaveToFile(sfile);
Str.Free;
end;

Procedure Sorting (var A:PVector);
{процедура сортування (методом бульбашки)
даних у масиві А по зростанню компоненти А^.Х}
var i,j:integer;
begin
for I := 0 to High(A^.X)-1 do
  for j := 0 to High(A^.X)-1-i do
      if A^.X[j]>A^.X[j+1] then
          begin
          Swap(A^.X[j],A^.X[j+1]);
          Swap(A^.Y[j],A^.Y[j+1]);
          end;
end;

 Procedure IVchar(a:Pvector; var b:Pvector);
 {заносить копію з а в b}
 var i:word;
begin
  if a^.n=0 then Exit;
  SetLenVector(b,a^.n);
  b^.name:=a^.name;
  b^.T:=a^.T;
  b^.N_begin:=a^.N_begin;
  b^.N_end:=a^.N_end;
  for I := 0 to High (b^.X) do
    begin
      b^.X[i]:=a^.X[i];
      b^.Y[i]:=a^.Y[i];
    end;
end;

Procedure LogX(A:Pvector; var B:Pvector);
{записує з A в B тільки ті точки, для яких
координата Х більше нуля}

var i,j:word;
begin
  B^.n:=A^.n;
  if B^.n=0 then Exit;

  B^.N_begin:=0;
  B^.N_end:=A^.N;
  B^.name:=A^.name;
  B^.T:=A^.T;

  for I := 0 to High(A^.X)-1 do
     if (A^.X[i]*A^.X[i+1]<=0) then
            begin
            if A^.X[i+1]>0 then B^.N_begin:=i+1;
            if A^.X[i+1]<0 then B^.N_end:=i+1;
            end;
  if B^.N_begin > B^.N_end then Swap(B^.N_begin,B^.N_end);
  B^.n:=B^.N_end-B^.N_begin;

  j:=0;
  for I := 0 to High(A^.X) do
   if A^.X[i]>0 then j:=j+1;

  if j=0 then
   begin
    B^.n:=0;
    B^.N_begin:=0;
    B^.N_end:=0;
    Exit;
   end;

  SetLength(B^.X, B^.n);
  SetLength(B^.Y, B^.n);
  for I := 0 to High (B^.X) do
    begin
      B^.X[i]:=A^.X[i+B^.N_begin];
      B^.Y[i]:=A^.Y[i+B^.N_begin];
    end;

  B^.N_begin:=B^.N_begin+A^.N_begin;
  B^.N_end:=B^.N_end+A^.N_begin;

end;

Procedure LogY(A:Pvector; var B:Pvector);
{записує з A в B тільки ті точки, для яких
координата Y більше нуля}

var i,j:word;
begin
  B^.n:=A^.n;
  if B^.n=0 then Exit;

  B^.N_begin:=0;
  B^.N_end:=A^.N;
  B^.name:=A^.name;
  B^.T:=A^.T;

  for I := 0 to High(A^.X)-1 do
     if (A^.Y[i]*A^.Y[i+1]<=0) then
            begin
            if A^.Y[i+1]>0 then B^.N_begin:=i+1;
            if A^.Y[i+1]<0 then B^.N_end:=i+1;
            end;
  if B^.N_begin > B^.N_end then Swap(B^.N_begin,B^.N_end);
  B^.n:=B^.N_end-B^.N_begin;

    j:=0;
  for I := 0 to High(A^.X) do
   if A^.Y[i]>0 then j:=j+1;

  if j=0 then
   begin
    B^.n:=0;
    B^.N_begin:=0;
    B^.N_end:=0;
    Exit;
   end;

  SetLength(B^.X, B^.n);
  SetLength(B^.Y, B^.n);

  for I := 0 to High (B^.X) do
    begin
      B^.X[i]:=A^.X[i+B^.N_begin];
      B^.Y[i]:=A^.Y[i+B^.N_begin];
    end;

  B^.N_begin:=B^.N_begin+A^.N_begin;
  B^.N_end:=B^.N_end+A^.N_begin;

end;

Procedure ForwardIV(A:Pvector; var B:Pvector);
{записує з A в B тільки ті точки, які відповідають
прямій ділянці ВАХ (для яких координата X більше нуля)}
begin
  LogX(A,B);
end;

Procedure ReverseIV(A:Pvector; var B:Pvector);
{записує з A в B тільки ті точки, які відповідають
зворотній ділянці ВАХ (для яких координата X менше нуля),
причому записує модуль координат}
 var i,j:word;
begin
  B^.n:=A^.n;
  if B^.n=0 then Exit;

  B^.N_begin:=0;
  B^.N_end:=A^.N;
  B^.name:=A^.name;
  B^.T:=A^.T;

  for I := 0 to High(A^.X)-1 do
     if (A^.X[i]*A^.X[i+1]<=0) then
            begin
            if A^.X[i+1]<0 then B^.N_begin:=i+1;
            if A^.X[i+1]>0 then B^.N_end:=i+1;
            end;
  if B^.N_begin > B^.N_end then Swap(B^.N_begin,B^.N_end);
  B^.n:=B^.N_end-B^.N_begin;

    j:=0;
  for I := 0 to High(A^.X) do
   if A^.X[i]<0 then j:=j+1;

  if j=0 then
   begin
    B^.n:=0;
    B^.N_begin:=0;
    B^.N_end:=0;
    Exit;
   end;

  SetLength(B^.X, B^.n);
  SetLength(B^.Y, B^.n);

  for I := 0 to High (B^.X) do
    begin
      B^.X[i]:=abs(A^.X[i+B^.N_begin]);
      B^.Y[i]:=abs(A^.Y[i+B^.N_begin]);
    end;

  B^.N_begin:=B^.N_begin+A^.N_begin;
  B^.N_end:=B^.N_end+A^.N_begin;
end;

Procedure PidgFun(A:Pvector; var B:Pvector);
{підготовча процедура до побудови багатьох функцій;
визначає діапазон B^.N_begin та B^.N_end, для
яких у векторі А значення Х>0.001 та Y>0,
встановлює величину B^.n та розміри масивів B^.X та B^.Y;
саме заповнення масиву В не відбувається}
var i,j:word;
     boolXY:array of boolean;
begin
B^.n:=A^.n;
if B^.n=0 then Exit;
B^.N_begin:=0;
B^.N_end:=A^.N;
B^.name:=A^.name;
B^.T:=A^.T;
SetLength(boolXY, A^.n);
j:=0;
for I := 0 to High(A^.X) do
  begin
   boolXY[i]:=(A^.X[i]>0.001) and (A^.Y[i]>0);
   if boolXY[i] then j:=j+1;
  end;

if j=0 then
   begin
    B^.n:=0;
 {   B^.N_begin:=0;
    B^.N_end:=0;}
    Exit;
   end;

for I := 0 to High(A^.X)-1 do
   if (boolXY[i] xor boolXY[i+1]) then
            begin
             if boolXY[i+1] then B^.N_begin:=i+1
                            else B^.N_end:=i+1;
            end;

if B^.N_begin > B^.N_end then Swap(B^.N_begin,B^.N_end);
B^.n:=B^.N_end-B^.N_begin;

SetLength(B^.X, B^.n);
SetLength(B^.Y, B^.n);
end;


Procedure ChungFun(A:Pvector; var B:Pvector);
{записує в B Chung-функцію, побудовану по даним з А}
 var i:word;
     temp:PVector;
begin
PidgFun(A,B);
if B^.n=0 then Exit;

  new(temp);
  temp^.n:=B^.n;
  SetLength(temp^.X, B^.n);
  SetLength(temp^.Y, B^.n);
  for I := 0 to High (B^.X) do
   begin
     temp^.X[i]:=ln(A^.Y[i+B^.N_begin]);
     temp^.Y[i]:=A^.X[i+B^.N_begin];
   end;
  for I := 0 to High (B^.X) do
   begin
     B^.X[i]:=exp(temp^.x[i]);
     B^.Y[i]:=Poh(temp,i);
   end;
  dispose(temp);

  B^.N_begin:=B^.N_begin+A^.N_begin;
  B^.N_end:=B^.N_end+A^.N_begin;
end;

Procedure WernerFun(A:Pvector; var B:Pvector);
{записує в B функцію Вернера, побудовану по даним з А}
 var i:word;
begin
PidgFun(A,B);
if B^.n=0 then Exit;

  for I := 0 to High (B^.X) do
   begin
     B^.X[i]:=Poh(A,i+B^.N_begin);
     B^.Y[i]:=B^.X[i]/A^.Y[i+B^.N_begin];
   end;

  B^.N_begin:=B^.N_begin+A^.N_begin;
  B^.N_end:=B^.N_end+A^.N_begin;
end;

Procedure MikhAlpha_Fun(A:Pvector; var B:Pvector);
{записує в B Альфа-функцію (метод Міхелешвілі),
побудовану по даним з А,
Alpha=d(ln I)/d(ln V)}
var temp:Pvector;
    i,j:word;
begin
PidgFun(A,B);
if B^.n=0 then Exit;
new(temp);
PidgFun(A,temp);

  for I := 0 to High (B^.X) do
   begin
     temp^.X[i]:=ln(A^.X[i+B^.N_begin]);
     temp^.Y[i]:=ln(A^.Y[i+B^.N_begin]);
   end;
{в temp функція ln I = f(ln V)}

  for I := 0 to High (B^.X) do
   begin
     B^.Y[i]:=Poh(temp,i);;
     B^.X[i]:=(A^.X[i+B^.N_begin]);
   end;
dispose(temp);
if B^.n<3 then
         begin
           B^.n:=0;
           Exit;
         end;
repeat
if B^.Y[0]>B^.Y[1] then
  begin
    B^.n:=B^.n-1;
    if B^.n<3 then
         begin
           B^.n:=0;
           Exit;
         end;
    B^.N_begin:=B^.N_begin+1;
    for i:=0 to High(B^.X)-1 do
       begin
         B^.X[i]:=B^.X[i+1];
         B^.Y[i]:=B^.Y[i+1];
       end;
    SetLength(B^.X,B^.n);
    SetLength(B^.Y,B^.n);
  end
                else Break;
until false;

i:=0;
repeat
if B^.Y[i]<=0 then
  begin
    B^.n:=B^.n-1;
    if B^.n<3 then
         begin
           B^.n:=0;
           Exit;
         end;
    if i=0 then B^.N_begin:=B^.N_begin+1;
    for J:=i to High(B^.X)-1 do
       begin
         B^.X[j]:=B^.X[j+1];
         B^.Y[j]:=B^.Y[j+1];
       end;
    SetLength(B^.X,B^.n);
    SetLength(B^.Y,B^.n);
  end;
Inc(i);
until (i>=B^.n);

end;

Procedure MikhBetta_Fun(A:Pvector; var B:Pvector);
{записує в B Бетта-функцію (метод Міхелешвілі),
побудовану по даним з А,
Betta = d(ln Alpha)/d(ln V)
P.S. в статті ця функція називається Гамма}
var temp:Pvector;
    i:word;
begin
MikhAlpha_Fun(A,B);
if B^.n=0 then Exit;
new(temp);
Smoothing(B,temp);
for I := 0 to High (B^.X) do
   begin
     temp^.X[i]:=ln(temp^.X[i]);
     temp^.Y[i]:=ln(temp^.Y[i]);
   end;
{в temp функція ln Aipha = f(ln V)}
for I := 0 to High (B^.X) do B^.Y[i]:=Poh(temp,i);
Smoothing(B,temp);
Smoothing(temp,B);
dispose(temp);
end;

Procedure MikhN_Fun(A:Pvector; var B:Pvector);
{записує в B залежність фактору неідеальності від
прикладеної напруги, пораховану за методом
метод Міхелешвілі, за даними векора А;
n = q V (Alpha - 1) [1 + Betta/(Alpha-1)] / k T Alpha^2}
var bet:Pvector;
    i:word;
begin
if A^.T=0 then
        Begin
          B^.n:=0;
          Exit;
        End;
MikhAlpha_Fun(A,B);
if B^.n=0 then Exit;
new(bet);
MikhBetta_Fun(A,bet);
for I := 0 to High (B^.X) do
  B^.Y[i]:=B^.X[i]*(B^.Y[i]-1)*(1+bet^.Y[i]/(B^.Y[i]-1))/Kb/A^.T/sqr(B^.Y[i]);

dispose(bet);
end;

Procedure MikhRs_Fun(A:Pvector; var B:Pvector);
{записує в B залежність послідовного опору від
прикладеної напруги, пораховану за методом
метод Міхелешвілі, за даними векора А;
Rs = V (1- Betta) / I Alpha^2}
var bet:Pvector;
    i:word;
begin
MikhAlpha_Fun(A,B);
if B^.n=0 then Exit;
new(bet);
MikhBetta_Fun(A,bet);
for I := 0 to High (B^.X) do
  B^.Y[i]:=B^.X[i]*(1-bet^.Y[i])/A^.Y[i+B^.N_begin]/sqr(B^.Y[i]);
dispose(bet);
end;


Procedure HFun(A:Pvector; var B:Pvector; AA, Szr, N:double);
{записує в B H-функцію, побудовану по даним з А:
AA - стала Річардсона, Szr - площа контакту,
N - фактор неідеальності}
 var i:word;
begin
B^.n:=0;
if n=555 then Exit;
if A^.T<=0 then Exit;
PidgFun(A,B);
if B^.n=0 then Exit;

  for I := 0 to High (B^.X) do
   begin
     B^.X[i]:=A^.Y[i+B^.N_begin];
     B^.Y[i]:=A^.X[i+B^.N_begin]-N*Kb*B^.T*ln(A^.Y[i+B^.N_begin]/Szr/AA/sqr(B^.T));
   end;

  B^.N_begin:=B^.N_begin+A^.N_begin;
  B^.N_end:=B^.N_end+A^.N_begin;
end;

Procedure NordeFun(A:Pvector; var B:Pvector; AA, Szr, Gam:double{; Gam:word});
{записує в B функцію Норда, побудовану по даним з А;
AA - стала Річардсона, Szr - площа контакту,
Gam - показник гамма (див формулу)}
 var i:word;
begin
B^.n:=0;
if A^.T<=0 then Exit;
PidgFun(A,B);


if B^.n=0 then Exit;

  for I := 0 to High (B^.X) do
   begin
     B^.X[i]:=A^.X[i+B^.N_begin];
     B^.Y[i]:=A^.X[i+B^.N_begin]/Gam-Kb*B^.T*ln(A^.Y[i+B^.N_begin]/Szr/AA/sqr(B^.T));
   end;

  B^.N_begin:=B^.N_begin+A^.N_begin;
  B^.N_end:=B^.N_end+A^.N_begin;

end;

Procedure CibilsFunDod(A:Pvector; var B:Pvector; Va:double);
{записує в B функцію F(V)=V-Va*ln(I), побудовану по даним з А}
 var i:word;
begin
PidgFun(A,B);
if B^.n=0 then Exit;

  for I := 0 to High (B^.X) do
   begin
     B^.X[i]:=A^.X[i+B^.N_begin];
     B^.Y[i]:=A^.X[i+B^.N_begin]-Va*ln(A^.Y[i+B^.N_begin]);
   end;

  B^.N_begin:=B^.N_begin+A^.N_begin;
  B^.N_end:=B^.N_end+A^.N_begin;
end;

Procedure CibilsFun(A:Pvector; D:Diapazon; var B:Pvector);
{записує в B функцію Сібілса, побудовану по даним з А
(з врахуванням умов D);
діапазон зміни напруги від kT до тих значень,
при яких функція F(V)=V-Va*ln(I) ще має мінімум,
крок - 0.001}
//const Np=15;//кількість точок у результуючій функції;
//залежно від всього діапазону крок зміни Va вибирається адаптивно
var Va:double;
    temp,temp2:PVector;
//    Vmin,Vmax,delV:double;
//    i:integer;
begin
B^.n:=0;
Va:=round(1000*(Kb*A^.T+0.004))/1000;
if Va<0.01 then Va:=0.015;
new(temp);
new(temp2);
//Vmin:=0;
//Vmax:=0;

repeat
CibilsFunDod(A,temp,Va);
{в temp функція F(V)=V-Va*ln(I), побудована
по всім [додатнім] значенням з вектора А}
if temp.n=0 then Break;

A_B_Diapazon(A,temp,temp2,D);
if temp2^.n=0 then
          begin
           dispose(temp);dispose(temp2);Exit;
          end;

{в temp2 - частина функції F(V)=V-Va*ln(I), яка
задовольняє умовам в D}


if temp2.n<3 then Break;
if (Poh(temp2,2)*Poh(temp2,High (temp2^.X)-2))>0 then Break;
//if Vmin=0 then Vmin:=Va
//          else Vmax:=Va;

B^.n:=B^.n+1;
SetLength(B^.X, B^.n);
SetLength(B^.Y, B^.n);
B^.X[B^.n-1]:=Va;
B^.Y[B^.n-1]:=ChisloY(A,Extrem(temp2));

Va:=Va+0.001;
if Va>A^.X[temp^.N_begin+High(temp^.X)] then Break;
until false;

//if (Vmax>Vmin)and(Vmin<>0) then
// begin
//  delV:=(Vmax-Vmin)/(Np-1);
//  SetLenVector(B,Np);
//  for I := 0 to Np-1 do
//    begin
//      Va:=Vmin+delV*i;
//      CibilsFunDod(A,temp,Va);
//      A_B_Diapazon(A,temp,temp2,D);
//      B^.X[i]:=Va;
//      B^.Y[i]:=ChisloY(A,Extrem(temp2));
//    end;
// end;


if B^.n<2 then B^.n:=0;

dispose(temp2);
dispose(temp);
end;


Procedure LeeFunDod(A:Pvector; var B:Pvector; Va:double);
{записує в B функцію F(I)=V-Va*ln(I), побудовану по даним з А}
 var i:word;
begin
PidgFun(A,B);
if B^.n=0 then Exit;

  for I := 0 to High (B^.X) do
   begin
     B^.X[i]:=A^.Y[i+B^.N_begin];
     B^.Y[i]:=A^.X[i+B^.N_begin]-Va*ln(A^.Y[i+B^.N_begin]);
   end;

  B^.N_begin:=B^.N_begin+A^.N_begin;
  B^.N_end:=B^.N_end+A^.N_begin;
end;

Procedure LeeFun(A:Pvector; D:Diapazon; var B:Pvector);
{записує в B функцію Lee, побудовану по даним з А;
діапазон зміни напруги від kT до подвоєного найбільшого
позитивного значення напруги у вихідній ВАХ;
крок - 0.02;
в полі B^.T розміщюється не температура,
а параметр А апроксимації функцією А+B*x+C*ln(x);
він однаковий незалежно від величини Va і
використовується в функції LeeKalk для
розрахунку висоти бар'єру; ось такий контрабандний прийом :)}
var Va,AA,BB,CC:double;
    temp,temp2:PVector;
begin
B^.n:=0;
Va:=round(100*(Kb*A^.T+0.004))/100;
//if Va<0.01 then Exit;
new(temp);
new(temp2);
repeat
LeeFunDod(A,temp,Va);
{в temp функція F(I)=V-Va*ln(I), побудована
по всім [додатнім] значенням з вектора А}
if temp.n=0 then Break;

A_B_Diapazon(A,temp,temp2,D);
if temp2^.n=0 then
          begin
           dispose(temp);dispose(temp2);Exit;
          end;
{в temp2 - частина функції F(I)=V-Va*ln(I), яка
задовольняє умовам в D}
if temp2.n<3 then Break;

GromovAprox (temp2,AA,BB,CC);
if AA=555 then Break;

B^.n:=B^.n+1;
SetLength(B^.X, B^.n);
SetLength(B^.Y, B^.n);
B^.X[B^.n-1]:=Va;
B^.Y[B^.n-1]:=-CC/BB;
Va:=Va+0.02;
B^.T:=AA;
if Va>2*A^.X[temp^.N_begin+High(temp^.X)] then Break;
until false;

if B^.n<2 then B^.n:=0;
dispose(temp2);
dispose(temp);
end;


Procedure ForwardIVwithRs(A:Pvector; var B:Pvector; Rs:double);
{записує в В пряму ділянку ВАХ з А з
врахуванням величини послідовного опору Rs}
var i,j:integer;
     temp:double;
begin
 B^.n:=0;
 if Rs=555 then Exit;

 B^.N_begin:=-1;
 B^.N_end:=-1;
 j:=0;
 for i:=0 to High(A^.X) do
   begin
   temp:=A^.X[i]-Rs*A^.Y[i];
   if (temp>0)and(A^.X[i]>0) then
     begin
       if B^.N_begin<0 then
             begin
              B^.N_begin:=i;
              SetLength(B^.X,1);
              SetLength(B^.Y,1);
              B^.X[0]:=temp;
              B^.Y[0]:=A^.Y[i];
              j:=1;
              Continue;
             end;
       if temp>=B^.X[j-1] then
             begin
              j:=j+1;
              SetLength(B^.X,j);
              SetLength(B^.Y,j);
              B^.X[j-1]:=temp;
              B^.Y[j-1]:=A^.Y[i];
              Continue;
             end;
         B^.N_end:=i-1;
         Break;
     end;
   end;
B^.T:=A^.T;
B^.n:=j;
{B^.T:=A^.T;
B^.n:=A^.n;
B^.N_begin:=A^.N_begin;
B^.N_end:=A^.N_end;
 ForwardIV(B,B);}
{ ForwardIV(A,B);
 for i:=0 to High(B^.X) do
   B^.X[i]:=B^.X[i]-Rs*B^.Y[i];}
end;

Procedure Forward2Exp(A:Pvector; var B:Pvector; Rs:double);
{записує в В залежність величини
I/[1-exp(-qV/kT)] від напруги з
врахуванням величини послідовного опору Rs
для прямої ділянкиз А}
var i:integer;
begin
 B^.n:=0;
 if (Rs=555) or (A^.T<=0) then Exit;
 ForwardIVwithRs(A,B,Rs);
 for i:=0 to High(B^.X) do
   B^.Y[i]:=B^.Y[i]/(1-exp(-B^.X[i]/Kb/A^.T));
end;

Procedure Reverse2Exp(A:Pvector; var B:Pvector; Rs:double);
{записує в В залежність величини
I/[1-exp(-qV/kT)] від напруги з
врахуванням величини послідовного опору Rs
для прямої зворотньої з А}
var i:integer;
     temp:PVector;
begin
 B^.n:=0;
 if (Rs=555) or (A^.T<=0) then Exit;
 new(temp);
 ReverseIV(A,temp);
 if temp^.n=0 then Exit;
 for i:=0 to High(temp^.X) do
   begin
   temp^.X[i]:=(temp^.X[i]-Rs*temp^.Y[i]);
   temp^.Y[i]:=-temp^.Y[i]/(1-exp(temp^.X[i]/Kb/A^.T));
   end;
 LogY(temp,B);
 dispose(temp);
end;

Procedure N_V_Fun(A:Pvector; var B:Pvector; Rs:double);
{записує в В залежність коефіцієнту неідеальності
від напруги використовуючи вираз n=q/kT* d(V)/d(lnI);
залежність I=I(V), яка знаходиться в А, спочатку
модифікується з врахуванням величини послідовного опору Rs}
var temp:Pvector;
    i:integer;
begin
B^.n:=0;
if A^.T<0 then Exit;
ForwardIVwithRs(A,B,Rs);
if B^.n=0 then Exit;

new(temp);
SetLength(temp^.X, B^.n);
SetLength(temp^.Y, B^.n);

for i:=0 to High(B^.X) do
  begin
  if B^.y[i]<=0 then
     begin
      dispose(temp);
      B^.n:=0;
      Exit;
     end;
  temp^.x[i]:=ln(B^.y[i]);
  temp^.y[i]:=B^.x[i];
  end;
{в temp залежність V=f(ln(I)) з врахуванням Rs}

for I := 0 to High(B^.X) do
 begin
  B^.X[i]:=temp^.Y[i];
  B^.Y[i]:=Poh(temp,i)/Kb/A^.T;
 end;
{зглажування}
Smoothing (B,temp);
Median (temp,B);
dispose(temp);
end;

Procedure M_V_Fun(A:Pvector; var B:Pvector; Bool:boolean; fun:word);
{по даним у векторі А будує функцію залежно від значення fun:
fun=1 - залежність коефіцієнта m=d(ln I)/d(ln V) від напруги
(для випадку коли  I=const*V^m);
2 - функція Фаулера-Нордгейма для прикладеної напруги
    ln(I/V^2)=f(1/V);
3 - функція Фаулера-Нордгейма для максимальної напруженості
    ln(I/V)=f(1/V^0.5);
4 - функція Абелеса для прикладеної напруги
    ln(I/V)=f(1/V);
5 - функція Абелеса для максимальної напруженості
    ln(I/V^0.5)=f(1/V^0.5);
6 - функція Френкеля-Пула для прикладеної напруги
    ln(I/V)=f(V^0.5);
7 - функція Френкеля-Пула для максимальної напруженості
    ln(I/V^0.5)=f(V^0.25);
якщо Bool=true, то будується залежність для прямої гілки,
якщо Bool=false - для зворотньої}
var temp:Pvector;
    i,j:integer;
begin
B^.n:=0;
new(temp);
if Bool then ForwardIV(A,temp)
        else ReverseIV(A,temp);
if temp^.n=0 then Exit;
i:=0;
repeat
   try
    case fun of
     1:  //  m=d(ln I)/d(ln V) = f (V)
      begin
       temp^.X[i]:=ln(temp^.X[i]);
       temp^.Y[i]:=ln(temp^.Y[i]);
      end;
     2:  // ln(I/V^2)=f(1/V)
      begin
       temp^.Y[i]:=ln(temp^.Y[i]/sqr(temp^.X[i]));
       temp^.X[i]:=1/temp^.X[i];
      end;
     3: // ln(I/V)=f(1/V^0.5)
      begin
       temp^.Y[i]:=ln(temp^.Y[i]/temp^.X[i]);
       temp^.X[i]:=1/sqrt(temp^.X[i]);
      end;
     4: // ln(I/V)=f(1/V)
      begin
       temp^.Y[i]:=ln(temp^.Y[i]/temp^.X[i]);
       temp^.X[i]:=1/temp^.X[i];
      end;
     5: // ln(I/V^0.5)=f(1/V^0.5)
      begin
       temp^.X[i]:=1/sqrt(temp^.X[i]);
       temp^.Y[i]:=ln(temp^.Y[i]*temp^.X[i]);
      end;
     6: // ln(I/V)=f(V^0.5)
      begin
       temp^.Y[i]:=ln(temp^.Y[i]/temp^.X[i]);
       temp^.X[i]:=sqrt(temp^.X[i]);
      end;
     7: // ln(I/V^0.5)=f(V^0.25)
      begin
       temp^.Y[i]:=ln(temp^.Y[i]/sqrt(temp^.X[i]));
       temp^.X[i]:=sqrt(sqrt(temp^.X[i]));
      end;
    end; //case
  Except
   for j:=i to High(temp^.X)-1 do
      begin
       temp^.X[j]:=temp^.X[j+1];
       temp^.Y[j]:=temp^.Y[j+1];
      end;
   temp^.n:=temp^.n-1;
   SetLength(temp^.X,temp^.n);
   SetLength(temp^.Y,temp^.n);
   i:=i-1;
   end;  //try
 inc(i);
until (i>High(temp^.X));

if temp^.n=0 then Exit;

case fun of
  1:
    begin
     Diferen (temp,B);
     for i:=0 to High(B^.X) do
        B^.X[i]:=exp(B^.X[i]);
    end;
  2..7:
    begin
     B^.n:=temp^.n;
     B^.X:=Copy(temp^.X);
     B^.Y:=Copy(temp^.Y);

{     SetLength(B^.X,B^.n);
     SetLength(B^.Y,B^.n);
     for i:=0 to High(B^.X) do
        begin
        B^.X[i]:=temp^.X[i];
        B^.Y[i]:=temp^.Y[i];
        end;}
    end;
 end; // case
end;


Procedure Nss_Fun(A:Pvector; var B:Pvector;
                  Fb,Rs,del,ep:double; D:Diapazon; nV:boolean);
{записує в В залежність густини станів
Nss=ep*ep0*(n-1)/q*del від різниці Ес-Ess=(Fb-V/n),
[Nss] = еВ-1 см-2; [Ec-Ess] = еВ;
n - фактор неідеальності,
nV - вибір яким методом обчислювати n
     true - за допомогою похідної
     (див попередню функцію);
     false - за методом Міхелешвілі
ер - діелектрична проникність напівпровідника
ер0 - діелектрична стала
del - товщина діелектричного шару
Fb - висота бар'єру Шотки
Rs - величина послідовного опору}
var temp:Pvector;
    i,j:integer;
    boolXY:array of boolean;
begin
B^.n:=0;
if (Fb=555)then Exit;

new(temp);
if nV then N_V_Fun(A,temp,Rs)
      else MikhN_Fun(A,temp);
if temp^.n=0 then
          begin
          dispose(temp);
          Exit;
          end;
B^.name:=A^.name;
B^.T:=A^.T;
B^.N_begin:=temp^.N_begin;
B^.N_end:=temp^.N_end;

SetLength(boolXY, temp^.n);
j:=0;
for I := 0 to High(boolXY) do
 begin
   boolXY[i]:=PoinValide(D,A,temp,i)and(temp^.Y[i]>=1);
   if boolXY[i] then j:=j+1;
 end;
{ j містить кількість точок з temp, які
 задовольняють умову D і для яких n не менше 1}

if j=0 then
   begin
    B^.n:=0;
    dispose(temp);
    Exit;
   end;
B^.n:=j;
SetLength(B^.X, B^.n);
SetLength(B^.Y, B^.n);
j:=0;
try
for I := 0 to High(temp^.X) do
  begin
     if boolXY[i] then
           begin
            B^.x[j]:=Fb-temp^.x[i]/temp^.y[i];
            B^.y[j]:=ep*8.85e-14*(temp^.y[i]-1)/del/1.6e-19;
            j:=j+1;
           end;
  end;
except
B^.n:=0;
end; //try

dispose(temp);
end;

Procedure Dit_Fun(A:Pvector; var B:Pvector;
                  Rs,AA,Szr,Nd,eps:double; D:Diapazon);
{записує в В залежність густини станів,
обчислену за методом Іванова,
Dit=ep*ep0/(q^2*del)*d(Vcal-Vexp)/dVs
від різниці Ес-Ess=(Fb-qVs),
[Dit] = еВ-1 см-2; [Ec-Ess] = еВ;
ер - діелектрична проникність діелектрика
ер0 - діелектрична стала
del - товщина діелектричного шару
Rs - величина послідовного опору
Vcal та Vexp - розраховане та виміряне
значення напруги при однакових значеннях сируму;
Vcal=Vs+(del/ep)*[Sqrt(2q*Nd*eps/eps0) (Sqrt(Fb/q)-Sqrt(Fb/q-Vs))]
Vexp=V-IRs
eр - діелектрична проникність напівпровідника
Fb - висота бар'єру Шотки
Nd - концентрація донорів у напівпровіднику;
Vs - падіння напруги на ОПЗ напівпровідника
Vs=Fb/q-kT/q*ln(Szr*AA*T^2/I);
AA - стала Річардсона
Szr - площа контакту
}
var i,j:integer;
    Vs,Vcal,del,Fb:double;
    temp:PVector;
begin
B^.n:=0;
if (Rs=555)then Exit;
IvanovKalk(A,D,Rs,AA,Szr,Nd,eps,del,Fb);
if (Fb=555)or(del<=0) then Exit;
new(temp);
A_B_Diapazon(A,A,temp,D);
if temp^.n=0 then
          begin
          Dispose(temp);
          Exit;
          end;
for I := 0 to High(temp^.X) do
  begin
   Vs:=Fb-Kb*A^.T*ln(Szr*AA*sqr(A^.T)/temp^.Y[i]);
   Vcal:=Vs+Rs*temp^.Y[i]+
         del*sqrt(2*Qelem*Nd*eps/Eps0)*(sqrt(Fb)-sqrt(Fb-Vs));
   temp^.Y[i]:=Vcal-temp^.X[i];
   temp^.X[i]:=Vs;
  end;
{B^.n:=temp^.n;
SetLength(B^.Y,B^.n);
SetLength(B^.X,B^.n);
B^.X:=Copy(temp^.X);
B^.Y:=Copy(temp^.Y);}
Diferen (temp,B);
dispose(temp);
for I := 0 to High(B^.X) do
 while (B^.Y[i]<=0)and(i<=High(B^.X)) do
   begin
     for j := i to High(B^.X)-1 do
            begin
              B^.X[j]:=B^.X[j+1];
              B^.Y[j]:=B^.Y[j+1];
            end;
     B^.n:=B^.n-1;
     SetLength(B^.X,B^.n);
     SetLength(B^.Y,B^.n);
   end;
if B^.n<2 then
     begin
       B^.n:=0;
       Exit;
     end;
for I := 0 to High(B^.X) do
 begin
  B^.Y[i]:=B^.Y[i]*Eps0/del/Qelem/1e4;
  B^.X[i]:=Fb-B^.X[i];
 end;
end;

Procedure IvanovAprox (V:PVector; AA, Szr, Nd, ep:double;
                       var del,Fb:double);
{апроксимація даних у векторі V параметричною залежністю
I=Szr AA T^2 exp(-Fb/kT) exp(qVs/kT)
V=Vs+del*[Sqrt(2q Nd ep / eps0) (Sqrt(Fb/q)-Sqrt(Fb/q-Vs))]
де
AA - стала Річардсона
Szr - площа контакту, []=м^2
Fb - висота бар'єру Шотки, []=eV
Vs - падіння напруги на ОПЗ напівпровідника
     (параметр залежності)
del - товщина діелектричного шару, []=м
(якщо точніше - товщина шару, поділена на
величину відносної діелектричної проникності шару)
Nd - концентрація донорів у напівпровіднику, []=м^-3;
eр - діелектрична проникність напівпровідника
ерs0 - діелектрична стала
підбираються значення del та Fb;
}

var temp:Pvector;
    a,b:double;
    i:integer;
    Param:array of double;
begin
del:=555;
Fb:=555;
if (V^.T<=0)or(V^.n=0) then Exit;
SetLength(Param,6);
new(temp);
temp^.n:=High(V^.X)+1;
SetLength(temp^.X,temp.n);
SetLength(temp^.Y,temp.n);
try
for I := 0 to High(V^.X) do
  begin
   temp^.X[i]:=1/V^.X[i];
   temp^.Y[i]:=sqrt(Kb*V^.T*ln(Szr*AA*sqr(V^.T)/V^.Y[i]));
  end;
except
 dispose(temp);
 Exit;
end;//try

Param[0]:=temp^.n;
for i := 1 to 5 do Param[i]:=0;
try
  for I := 0 to High(V^.X) do
  begin
  Param[1]:=Param[1]+temp^.X[i];
  Param[2]:=Param[2]+temp^.X[i]*temp^.Y[i];
  Param[3]:=Param[3]+temp^.X[i]*sqr(temp^.Y[i]);
  Param[4]:=Param[4]+temp^.X[i]*temp^.Y[i]*sqr(temp^.Y[i]);
  Param[5]:=Param[5]+temp^.Y[i];
  end;
  dispose(temp);
except
  dispose(temp);
  Exit;
end;//try
//dispose(temp);
//showmessage('p0='+FloatToStr(Param[0])+', p1='+FloatToStr(Param[1]));

try
a:=(Param[2]*(Param[0]+Param[3])-Param[1]*(Param[5]+Param[4]))/(Param[3]*Param[1]-sqr(Param[2]));
b:=(Param[3]*(Param[0]+Param[3])-Param[2]*(Param[5]+Param[4]))/(Param[3]*Param[1]-sqr(Param[2]));
b:=(sqrt(sqr(a)+4*b)-a)/2;
except
  Exit;
end;
del:=a/sqrt(2*Qelem*Nd*ep/Eps0);
Fb:=sqr(b);

end;



Procedure A_B_Diapazon(Avuh,A:Pvector; var B:Pvector; D:Diapazon);
{записує в В ті точки з вектора А, відповідні
до яких точки у векторі Avuh (вихідному) задовольняють
умовам D; зрозуміло, що для вектора А
мають бути відомими А^.N_begin та А^.N_end (хоча б перше);
B^.N_begin, B^.N_end не розраховуються}

var i,j:integer;
begin
B^.T:=Avuh^.T;
j:=0;
SetLength(B^.X, j);
SetLength(B^.Y, j);
for I := 0 to High(A^.X) do
 if PoinValide(D,Avuh,A,i) then
   begin
     j:=j+1;
     SetLength(B^.X, j);
     SetLength(B^.Y, j);
     B^.X[j-1]:=A^.X[i];
     B^.Y[j-1]:=A^.Y[i];
   end;
B^.n:=j;
end;

Procedure A_B_Diapazon(Light:boolean;A:Pvector; var B:Pvector; D:Diapazon);overload;
{записує в В ті точки з вектора А, які
задовольняють умовам D;
B^.N_begin, B^.N_end не розраховуються
Якщо Light=True, то обмеження
на Ymin не використовуеться - потрібно
для аналізу ВАХ освітлених елементів}
var i,j:integer;
begin
B^.T:=A^.T;
j:=0;
SetLength(B^.X, j);
SetLength(B^.Y, j);
if Light then
  for I := 0 to High(A^.X) do
      if PoinValideYmin(D,A,A,i) then
         begin
           j:=j+1;
           SetLength(B^.X, j);
           SetLength(B^.Y, j);
           B^.X[j-1]:=A^.X[i];
           B^.Y[j-1]:=A^.Y[i];
         end;
if not(Light) then
  for I := 0 to High(A^.X) do
      if PoinValide(D,A,A,i) then
         begin
           j:=j+1;
           SetLength(B^.X, j);
           SetLength(B^.Y, j);
           B^.X[j-1]:=A^.X[i];
           B^.Y[j-1]:=A^.Y[i];
         end;
B^.n:=j;
B^.name:=A^.name;
end;

Procedure Kam1_Fun (A:Pvector; var B:Pvector; D:Diapazon);
{записує в B функцію Камінскі першого роду
спираючись на ті точки вектора А, які задовольняють
умови D}
var temp:Pvector;
    i,j:integer;
begin
new(temp);


//A_B_Diapazon(A,A,temp,D);
//{в temp ті точки вектора А, які задовольняють D}
//
//if temp^.n=0 then
//             begin
//             B^.n:=0;
//             dispose(temp);
//             Exit;
//             end;
//

IVChar(A,temp);
SetLenVector(B,temp^.n-1);


//SetLength(B^.X, temp^.n-1);
//SetLength(B^.Y, temp^.n-1);
//B^.n:=temp^.n-1;

try
for i:=0 to High(B^.X) do
  begin
  B^.X[i]:=(temp^.Y[0]+temp^.Y[High(temp^.X)])/2;
  B^.Y[i]:=Int_Trap(temp)/(temp^.Y[High(temp^.X)]-temp^.Y[0]);
  if High(temp^.X)>1 then
    begin
    for j := 0 to High(temp^.X) do
          begin
          temp^.X[j]:=temp^.X[j+1];
          temp^.Y[j]:=temp^.Y[j+1];
          end;
    SetLenVector(temp,temp^.n-1);
//    temp^.n:=temp^.n-1;
//    SetLength(temp^.X, temp^.n);
//    SetLength(temp^.Y, temp^.n);
    end;
  end;
except
  dispose(temp);
  B^.n:=0;
  Exit;
end;

Sorting(B);
IVchar(B,temp);
temp^.N_Begin:=0;
A_B_Diapazon(temp,temp,B,D);
dispose(temp);

end;

Procedure Kam2_Fun (A:Pvector; var B:Pvector; D:Diapazon);
{записує в B функцію Камінскі другого роду
спираючись на ті точки вектора А, які задовольняють
умови D}
var temp:Pvector;
    i,j,k:integer;
begin
new(temp);
A_B_Diapazon(A,A,temp,D);
{в temp ті точки вектора А, які задовольняють D}

if temp^.n=0 then
             begin
             B^.n:=0;
             dispose(temp);
             Exit;
             end;
i:=round(temp^.n*(temp^.n-1)/2);
SetLength(B^.X, i);
SetLength(B^.Y, i);
B^.n:=i;

k:=0;
try
for i:=0 to High(temp^.X)-1 do
  for j := i+1 to High(temp^.X) do
   begin
    B^.X[k]:=(temp^.X[j]-temp^.X[i])/(temp^.Y[j]-temp^.Y[i]);
    B^.Y[k]:=ln(temp^.Y[j]/temp^.Y[i])/(temp^.Y[j]-temp^.Y[i]);
    k:=k+1;
   end;
except
 { MessageDlg('Forward characteristic has a repetitive element or negative current',
             mtError,[mbOk],0);}
  dispose(temp);
  B^.n:=0;
  Exit
end;
dispose(temp);
//сортування методом бульбашки
for I := 0 to High(B^.X)-1 do
  for j := 0 to High(B^.X)-i-1 do
      if B^.X[j]>B^.X[j+1] then
          begin
          Swap(B^.X[j],B^.X[j+1]);
          Swap(B^.Y[j],B^.Y[j+1]);
          end;
end;

Procedure Gr1_Fun (A:Pvector; var B:Pvector);
{записує в B функцію Громова першого роду
спираючись на точки вектора А}
var i:integer;
begin
ForwardIV(A,B);
for i:=0 to High(B^.X) do Swap(B^.X[i],B^.Y[i]);
end;


Procedure Gr2_Fun (A:Pvector; var B:Pvector; AA, Szr:double);
{записує в B функцію Громова другого роду
спираючись на точки вектора А}
var i:integer;
begin
NordeFun(A,B, AA, Szr,2);
for i:=0 to High(B^.X) do B^.X[i]:=A^.Y[i+B^.N_begin];
{фактично, правильно буде будувати лише у випадку,
коли в А знаходиться вихідний файл, для якого А^.N_begin=0}
end;


Procedure LimitFun(A, A1:Pvector; var B:Pvector; Lim:Limits);
{записує з А в В тільки ті точки, для яких
в масиві А1 виконуються умови, розташовані в Lim}
 var i,j:word;
     boolXY:array of boolean;
begin

  if A^.n=0 then Exit;
  B^.n:=A^.n;
  B^.N_begin:=0;
  B^.N_end:=A^.N;
  B^.name:=A^.name;
  B^.T:=A^.T;

  SetLength(boolXY, A^.n);
  j:=0;
  for I := 0 to High(A^.X) do
   begin

    if (Lim.MinXY=0) and (Lim.MaxXY=0)
     then
      boolXY[i]:=((Lim.MinValue[0]=555)or(A1^.X[i+A^.N_begin]>Lim.MinValue[0]))
       and ((Lim.MaxValue[0]=555)or(A1^.X[i+A^.N_begin]<Lim.MaxValue[0]));

    if (Lim.MinXY=0) and (Lim.MaxXY=1)
     then
      boolXY[i]:=((Lim.MinValue[0]=555)or(A1^.X[i+A^.N_begin]>Lim.MinValue[0]))
       and ((Lim.MaxValue[1]=555) or (A1^.Y[i+A^.N_begin]<Lim.MaxValue[1]));

    if (Lim.MinXY=1) and (Lim.MaxXY=1)
     then
      boolXY[i]:=((Lim.MinValue[1]=555)or(A1^.Y[i+A^.N_begin]>Lim.MinValue[1]))
       and ((Lim.MaxValue[1]=555)or(A1^.Y[i+A^.N_begin]<Lim.MaxValue[1]));

    if (Lim.MinXY=1) and (Lim.MaxXY=0)
     then
      boolXY[i]:=((Lim.MinValue[1]=555)or(A1^.Y[i+A^.N_begin]>Lim.MinValue[1]))
       and ((Lim.MaxValue[0]=555)or(A1^.X[i+A^.N_begin]<Lim.MaxValue[0]));

     if boolXY[i] then j:=j+1;
   end;

  if j=0 then
   begin
    B^.n:=0;
    B^.N_begin:=0;
    B^.N_end:=0;
    Exit;
   end;

  for I := 0 to High(A^.X)-1 do
     if (boolXY[i] xor boolXY[i+1]) then
            begin
             if boolXY[i+1] then B^.N_begin:=i+1
                            else B^.N_end:=i+1;
            end;

  if B^.N_begin > B^.N_end then Swap(B^.N_begin,B^.N_end);
  B^.n:=B^.N_end-B^.N_begin;

  SetLength(B^.X, B^.n);
  SetLength(B^.Y, B^.n);

  for I := 0 to High (B^.X) do
   begin
     B^.X[i]:=A^.X[i+B^.N_begin];
     B^.Y[i]:=A^.Y[i+B^.N_begin];
   end;

  B^.N_begin:=B^.N_begin+A^.N_begin;
  B^.N_end:=B^.N_end+A^.N_begin;
end;

Function PoinValide(Dp:Diapazon; Original, Secondary:Pvector; k:integer): boolean;
{визначає, чи задовільняють координати точки
вектора Original, яка відповідає k-ій точці
вектора Secondary, умовам, записаним в змінній Dp;}
var Xmax, Xmin, Ymax, Ymin:boolean;
begin
Xmax:=false;Ymax:=false;Xmin:=false;Ymin:=false;
case Dp.Br of
 'F':begin
    Xmax:=(Dp.XMax=555)or(Original^.X[k+Secondary.N_begin]<Dp.XMax);
    Xmin:=(Dp.XMin=555)or(Original^.X[k+Secondary.N_begin]>Dp.XMin);
    Ymax:=(Dp.YMax=555)or(Original^.Y[k+Secondary.N_begin]<Dp.YMax);
    Ymin:=(Dp.YMin=555)or(Original^.Y[k+Secondary.N_begin]>Dp.YMin);
     end;
 'R':begin
    Xmax:=(Dp.XMax=555)or(Original^.X[k+Secondary.N_begin]>-Dp.XMax);
    Xmin:=(Dp.XMin=555)or(Original^.X[k+Secondary.N_begin]<-Dp.XMin);
    Ymax:=(Dp.YMax=555)or(Original^.Y[k+Secondary.N_begin]>-Dp.YMax);
    Ymin:=(Dp.YMin=555)or(Original^.Y[k+Secondary.N_begin]<-Dp.YMin);
    end;
 end; //case
 Result:=Xmax and Xmin and Ymax and Ymin;
end;

Function PoinValideYmin(Dp:Diapazon; Original, Secondary:Pvector; k:integer): boolean;
{визначає, чи задовільняють координати точки
вектора Original, яка відповідає k-ій точці
вектора Secondary, умовам, записаним в змінній D;
не розглядається лише умова для Ymin -
потрібно для аналізу ВАХ освітлених елементів}
var Xmax, Xmin, Ymax:boolean;
begin
Xmax:=false;Ymax:=false;Xmin:=false;
case Dp.Br of
 'F':begin
    Xmax:=(Dp.XMax=555)or(Original^.X[k+Secondary.N_begin]<Dp.XMax);
    Xmin:=(Dp.XMin=555)or(Original^.X[k+Secondary.N_begin]>=Dp.XMin);
    Ymax:=(Dp.YMax=555)or(Original^.Y[k+Secondary.N_begin]<Dp.YMax);
     end;
 'R':begin
    Xmax:=(Dp.XMax=555)or(Original^.X[k+Secondary.N_begin]>-Dp.XMax);
    Xmin:=(Dp.XMin=555)or(Original^.X[k+Secondary.N_begin]<=-Dp.XMin);
    Ymax:=(Dp.YMax=555)or(Original^.Y[k+Secondary.N_begin]>-Dp.YMax);
    end;
 end; //case
 Result:=Xmax and Xmin and Ymax;
end;


Procedure ChungKalk(A:PVector; D:Diapazon; var Rs:double; var n:double);
{на основі даних з вектора А шляхом побудови та
лінійної апроксимації функції Чюнга (з врахуванням
обмежень, вказаних в D, визначає величину
послідовного опору Rs та коефіцієнта неідеальності n;
якщо A^.T<=0, то n=555 і розраховується лише Rs}
var temp1, temp2:Pvector;
begin
Rs:=555;
n:=555;
new(temp1);
ChungFun(A,temp1);         // в temp1 повна функція Чюнга
if temp1^.n=0 then
             begin
               dispose(temp1);
               Exit;
             end;
new(temp2);
A_B_Diapazon(A,temp1,temp2,D);
if temp2^.n<2 then
          begin
           dispose(temp1);dispose(temp2);Exit;
          end;
  {в temp2 лінійна частина функції Чюнга
  (якщо вдало вибрано діапазон)}
LinAprox(temp2,n,Rs);
if A^.T<=0 then n:=555
           else n:=n/Kb/A^.T;

dispose(temp1);dispose(temp2);
end;

Procedure WernerKalk(A:PVector; var D:Diapazon; var Rs:double; var n:double);
{на основі даних з вектора А шляхом побудови та
лінійної апроксимації функції Вернера (з врахуванням
обмежень, вказаних в D), визначає величину
послідовного опору Rs та коефіцієнта неідеальності n}
var temp1, temp2:Pvector;
    aa,bb:double;
//    Dev,DYmin:TArrSingle;
//    Dtemp:Diapazon;
//    Np,i,Ntemp:integer;
//    Xtemp:double;
begin
//Rs:=555;
//n:=555;
//if A^.T<=0 then Exit;
//new(temp1);
//WernerFun(A,temp1);         // в temp1 повна функція Вернера
//if temp1^.n=0 then
//             begin
//               dispose(temp1);
//               Exit;
//             end;
//Dtemp:=Diapazon.Create;
//Dtemp.Copy(D);
//new(temp2);
//Np:=0;
//Ntemp:=0;
//repeat
//  if A^.Y[MaxElemNumber(A^.Y)]<=Dtemp.Ymin
//    then Dtemp.Ymin:=0.99999*A^.Y[MaxElemNumber(A^.Y)];
//  A_B_Diapazon(A,temp1,temp2,Dtemp);
////  showmessage(floattostr(Dtemp.Ymin));
//  if (High(Dev)>-1)and(temp2^.n<=Ntemp) then Break;
//
//  if temp2^.n>1 then
//    begin
//    inc(Np);
//    SetLength(Dev,Np);
//    Dev[Np-1]:=0;
//    SetLength(DYmin,Np);
//    DYmin[Np-1]:=Dtemp.Ymin;
//    LinAprox(temp2,aa,bb);
//    Ntemp:=temp2^.n;
//    for I := 0 to High(temp2^.X) do
//     Dev[Np-1]:=Dev[Np-1]+sqr((temp2^.Y[i]-aa-bb*temp2^.X[i])/temp2^.Y[i]);
//    Dev[Np-1]:=sqrt(Dev[Np-1])/temp2^.n;
//    end;
//
//
//  if A^.Y[MinElemNumber(A^.Y)]>=Dtemp.Ymin
//    then Break;
//
//  Xtemp:=ChisloX(A,Dtemp.Ymin);
//  i:=0;
//  repeat
//    if (A^.X[i]<Xtemp)and(A^.X[i+1]>=Xtemp) then Break;
//    inc(i);
//  until (i=High(A^.X));
//
//  if i=High(A^.X) then Dtemp.Ymin:=0.9999999*A^.Y[0]
//                  else Dtemp.Ymin:=0.9999999*A^.Y[i];
//
//until False;
//
//if High(Dev)>0 then
//  begin
//    Dtemp.Ymin:=DYmin[MinElemNumber(Dev)];
//    A_B_Diapazon(A,temp1,temp2,Dtemp);
//    LinAprox(temp2,aa,bb);
//    n:=1/Kb/A^.T/aa;
//    Rs:=-bb/aa;
//    D.Copy(Dtemp);
//  end;
//dispose(temp1);dispose(temp2);
//Dtemp.Free;

Rs:=555;
n:=555;
if A^.T<=0 then Exit;
new(temp1);
WernerFun(A,temp1);         // в temp1 повна функція Вернера
if temp1^.n=0 then
             begin
               dispose(temp1);
               Exit;
             end;
new(temp2);
A_B_Diapazon(A,temp1,temp2,D);
if temp2^.n=0 then
          begin
           dispose(temp1);dispose(temp2);Exit;
          end;
  {в temp2 лінійна частина функції Вернера
  (якщо вдало вибрано діапазон)}
LinAprox(temp2,aa,bb);
n:=1/Kb/A^.T/aa;
Rs:=-bb/aa;
dispose(temp1);dispose(temp2);
end;

Procedure MikhKalk(A:PVector; D:Diapazon; AA, Szr:double;
                   var Rs:double; var n:double; var I0:double; var Fb:double);
{на основі даних з вектора А (тих, які задовольняють
умову D) за допомогою
методу Міхелешвілі визначаються величини
послідовного опору Rs, коефіцієнта неідеальності n,
висоти бар'єру Fb та струму насичення І0;
якщо температура не задана, то визначається
лише Rs та I0, решті величин присвоюється значення 555;
якщо неможливо побудувати Alpha-функцію Міхелешвілі,
то і ці величини 555;
AA - стала Річардсона,
Szr - площа контакту}
var temp1,temp2:PVector;
    Alpha_m,Vm,Im:double;
begin
Rs:=555;
n:=555;
Fb:=555;
I0:=555;

//QueryPerformanceCounter(StartValue);

new(temp1);
new(temp2);

MikhAlpha_Fun(A,temp1);
{ в temp1 Аlpha-функція Міхелешвілі,
побудована по всім [додатнім] точкам А}
if temp1^.n=0 then
            begin
             dispose(temp1);
             dispose(temp2);
             Exit;
            end;
A_B_Diapazon(A,temp1,temp2,D);
{в temp2 лише ті точки з temp1, для
яких відповідні точки у векторі А
задольняють умову D }
if temp2^.n<3 then
          begin
           dispose(temp1);
           dispose(temp2);
           Exit;
          end;

repeat
if NumberMax(temp2)<2 then Break;
Median (temp2,temp1);
Smoothing(temp1,temp2);
until False;

//write_file('gg.dat',temp2);

//Smoothing(temp2,temp1);
{в temp1 зглажена Аlpha-функція Міхелешвілі,
побудована лише по точкам, які задовольняють
діапазон D }

Vm:=Extrem(temp2);
if Vm=555 then
            begin
             dispose(temp2);
             dispose(temp1);
             Exit;
            end;
Alpha_m:=ChisloY(temp2,Vm);
Im:=ChisloY(A,Vm);
Rs:=Vm/Im/sqr(Alpha_m);
I0:=Im*exp(-Alpha_m-1);
if A^.T>0 then
   begin
   n:=Vm*(Alpha_m-1)/Kb/A^.T/sqr(Alpha_m);
   Fb:=Kb*A^.T*(Alpha_m+1-ln(Im/Szr/AA/sqr(A^.T)));
   end;


dispose(temp1);
dispose(temp2);

//QueryPerformanceCounter(EndValue);
//QueryPerformanceFrequency(Freq);
//showmessage('tics='+inttostr(EndValue-StartValue)+#10+#13+
//             'time='+floattostr((EndValue-StartValue)/Freq)
//             +' s');

end;

Procedure HFunKalk(A:Pvector; D:Diapazon; AA, Szr, N:double;
                   var Rs:double; var Fb:double);
{на основі даних з вектора А шляхом побудови та
лінійної апроксимації H-функції (з врахуванням
обмежень, вказаних в D), визначає величину
послідовного опору Rs та висоти бар'єру Fb;
для побудови Н-функції потрібні
AA - стала Річардсона,
Szr - площа контакту,
N - фактор неідеальності}
var temp1, temp2:Pvector;
begin
Rs:=555;
Fb:=555;
if N=555 then Exit;

new(temp1);
HFun(A,temp1,AA,Szr,N);         // в temp1 повна H-функція
if temp1^.n=0 then
             begin
               dispose(temp1);
               Exit;
             end;
new(temp2);
A_B_Diapazon(A,temp1,temp2,D);
if temp2^.n<2 then
          begin
           dispose(temp1);dispose(temp2);Exit;
          end;
  {в temp2 лінійна частина H-функції
  (якщо вдало вибрано діапазон)}
LinAprox(temp2,Fb,Rs);
Fb:=Fb/N;
dispose(temp1);dispose(temp2);
end;

Procedure ExKalk(Index:integer; A:Pvector; D:Diapazon; Rs, AA, Szr :double;
                 var n:double; var I0:double; var Fb:double);overload;
{на основі даних з вектора А шляхом
лінійної апроксимації ВАХ в напівлогарифмічному
масштабі (з врахуванням
обмежень, вказаних в D), визначає величину
коефіцієнту неідеальності n,
струму насичення І0
висоту бар'єру Fb;
Фактично, це апроксимація за формулою I=I0exp(V/nkT)
Index вказує що саме апроксимується:
1 - величина вихідного струму І
2 - величина I/[1-exp(-qV/kT)] для прямої гілки
3 - величина I/[1-exp(-qV/kT)] для зворотньої гілки
для побудови ВАХ потрібний
Rs - послідовний опір,
для визначення Fb
AA - стала Річардсона,
Szr - площа контакту}
var temp1,temp2:Pvector;
    i:integer;
begin
n:=555;
Fb:=555;
I0:=555;
if (Rs=555)or(AA=555)or(Szr=555)or(A^.T<=0) then Exit;

new(temp2);
case Index of
   1:ForwardIVwithRs(A,temp2,Rs);
   2:Forward2Exp(A,temp2,Rs);
   3:Reverse2Exp(A,temp2,Rs);
 end;//case
if temp2^.n=0 then
               begin
                dispose(temp2);
                Exit;
               end;
new(temp1);
A_B_Diapazon(A,temp2,temp1,D);
dispose(temp2);
if temp1^.n<2 then
    begin
      dispose(temp1);
      Exit;
    end;
for I := 0 to High(temp1^.X) do temp1^.Y[i]:=ln(temp1^.Y[i]);

 {в temp1 лінійна частина BAX в напівлогарифмічному
 масштабі з врахуванням Rs (якщо вдало вибрано діапазон)}
LinAprox(temp1,I0,n);
I0:=exp(I0);
n:=1/(Kb*A^.T*n);
if Index=3 then n:=-n;
Fb:=Kb*A^.T*ln(Szr*AA*sqr(A^.T)/I0);
dispose(temp1);
end;

Procedure ExKalk_nconst(Index:integer; A:Pvector; D:Diapazon; Rs, AA, Szr :double;
                 n:double; var I0:double; var Fb:double);overload;
{на основі даних з вектора А шляхом
лінійної апроксимації ВАХ в напівлогарифмічному
масштабі (з врахуванням
обмежень, вказаних в D),
та значення коефіцієнту неідеальності n
визначає величину
струму насичення І0
висоту бар'єру Fb;
Фактично, це апроксимація за формулою I=I0exp(V/nkT)
Index вказує що саме апроксимується:
1 - величина вихідного струму І
2 - величина I/[1-exp(-qV/kT)] для прямої гілки
3 - величина I/[1-exp(-qV/kT)] для зворотньої гілки
для побудови ВАХ потрібний
Rs - послідовний опір,
для визначення Fb
AA - стала Річардсона,
Szr - площа контакту}
var temp1,temp2:Pvector;
    i:integer;
    n_temp:double;
begin
//n:=555;
Fb:=555;
I0:=555;
if (Rs=555)or(AA=555)or(Szr=555)or(A^.T<=0) then Exit;

new(temp2);
case Index of
   1:ForwardIVwithRs(A,temp2,Rs);
   2:Forward2Exp(A,temp2,Rs);
   3:Reverse2Exp(A,temp2,Rs);
 end;//case
if temp2^.n=0 then
               begin
                dispose(temp2);
                Exit;
               end;
new(temp1);
A_B_Diapazon(A,temp2,temp1,D);
dispose(temp2);
if temp1^.n<2 then
    begin
      dispose(temp1);
      Exit;
    end;
for I := 0 to High(temp1^.X) do temp1^.Y[i]:=ln(temp1^.Y[i]);

 {в temp1 лінійна частина BAX в напівлогарифмічному
 масштабі з врахуванням Rs (якщо вдало вибрано діапазон)}
n_temp:=1/(Kb*A^.T*n);
LinAproxBconst(temp1,I0,n_temp);
I0:=exp(I0);
//n:=1/(Kb*A^.T*n);
//if Index=3 then n:=-n;
Fb:=Kb*A^.T*ln(Szr*AA*sqr(A^.T)/I0);
dispose(temp1);
end;


Procedure ExKalk(A:Pvector; AA, Szr :double;
                 var n:double; var I0:double; var Fb:double);overload;
{на основі даних з вектора А шляхом
лінійної апроксимації ВАХ в напівлогарифмічному
масштабі, визначає величину
коефіцієнту неідеальності n,
струму насичення І0
висоту бар'єру Fb;
Фактично, це апроксимація за формулою I=I0exp(V/nkT)
для визначення Fb потрібні
AA - стала Річардсона,
Szr - площа контакту}
var {temp1,}temp2:Pvector;
    i:integer;
begin
n:=555;
Fb:=555;
I0:=555;
if {(Rs=555)or}(AA=555)or(Szr=555)or(A^.T<=0) then Exit;

new(temp2);
IVchar(A,temp2);
{case Index of
  { 1:ForwardIVwithRs(A,temp2,Rs);
   2:Forward2Exp(A,temp2,Rs);
   3:Reverse2Exp(A,temp2,Rs);
 end;}//case
if temp2^.n=0 then
               begin
                dispose(temp2);
                Exit;
               end;
{new(temp1);
A_B_Diapazon(A,temp2,temp1,D);
dispose(temp2);}
if temp2^.n<2 then
    begin
      dispose(temp2);
      Exit;
    end;
try
for I := 0 to High(temp2^.X) do temp2^.Y[i]:=ln(temp2^.Y[i]);
except
  dispose(temp2);
  Exit;
end;

LinAprox(temp2,I0,n);
I0:=exp(I0);
n:=1/(Kb*A^.T*n);
{if Index=3 then n:=-n;}
Fb:=Kb*A^.T*ln(Szr*AA*sqr(A^.T)/I0);
dispose(temp2);
end;


Procedure ExpKalk(A:Pvector; D:Diapazon; Rs, AA, Szr :double; Xp:IRE;
                 var n:double; var I0:double; var Fb:double);
{на основі даних з вектора А шляхом
апроксимації ВАХ за формулою І=I0(exp(V/nkT)-1)
(з врахуванням обмежень, вказаних в D), визначає величину
коефіцієнту неідеальності n,
струму насичення І0
висоту бар'єру Fb;
для побудови ВАХ потрібний
Rs - послідовний опір,
Хр   - вектор початкових наближень
для визначення Fb
AA - стала Річардсона,
Szr - площа контакту}
var temp1:Pvector;
    i,rez:integer;
    Xr:IRE;
begin
if (D.YMin=555) or (D.YMin<=0) then D.YMin:=0;
if (D.XMin=555) then D.XMin:=0.001;
n:=555;
Fb:=555;
I0:=555;
if Rs=555 then Exit;

new(temp1);
A_B_Diapazon(A,A,temp1,D);
if temp1^.n=0 then
    begin
      dispose(temp1);
      Exit;
    end;
for I := 0 to High(temp1^.X) do
              temp1^.X[i]:=temp1^.X[i]-Rs*temp1^.Y[i];
 {в temp1 пряма BAX з врахуванням Rs }

try
 Newts(4,temp1,1e-6,Xp,Xr,rez);
except
{ st:='I=I0(exp(V/nkT)-1) approximation'+#13+
     'of '+A^.name+' file dates is unseccessful';
 MessageDlg(st, mtError,[mbOk],0);}
 rez:=-1;
end;
if rez=-1 then
  begin
  dispose(temp1);
  Exit;
  end;
I0:=Xr[1];
n:=Xr[3]/Kb/A^.T; {n}
if I0=0 then I0:=1;
Fb:=Kb*A^.T*ln(Szr*AA*sqr(A^.T)/I0);
dispose(temp1);
end;

//Procedure ExpKalkNew(A:Pvector; D:Diapazon; Mode:byte;
//         Light:boolean; Func:byte; AA, Szr :double;
//    var n:double; var I0:double; var Fb:double;var Rs:double;
//    var Rsh:double; var Iph:double; var Voc:double; var Isc:double;
//    var Pm:double; var FF:double);
//{на основі даних з вектора А шляхом
//прямої апроксимації ВАХ за формулою
//І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
//(з врахуванням обмежень, вказаних в D), визначає величину
//коефіцієнту неідеальності n,
//струму насичення І0
//висоту бар'єру Fb;
//послідовний опір Rs;
//шунтуючий опір Rsh;
//фотострум Iph;
//напругу холостого ходу Voc;
//струм короткого замикання Isc;
//максимальну вихідну потужність фотоелементу Pm;
//коефіцієнт форми ВАХ фотоелементу  FF;
//При Func=0 використовується метод прямої апроксимації,
//    Func=1 - функція Ламберта,
//    Func=2 - метод диференційної еволюції;
//при Light=False - Iph=0, Voc=0, Isc=0, Pm=0, FF=0;
//при Mode=1 - Rsh=1e12;
//при Mode=2 - Rs=1e-4;
//при Mode=3 - Rsh=1e12 та  Rs=1e-4;
//при Mode=0 - розраховуються всі величини;
//для визначення Fb потрібні
//AA - стала Річардсона,
//Szr - площа контакту}
//var temp1:Pvector;
//    Param:TArrSingle;
//begin
//if (D.YMin=555) or (D.YMin<=0) then D.YMin:=0;
//if (D.XMin=555) then D.XMin:=0.001;
//n:=555;
//Fb:=555;
//I0:=555;
//Rs:=555;
//Rsh:=555;
//Iph:=555;
//Voc:=555;
//Isc:=555;
//Pm:=555;
//FF:=555;
//
//new(temp1);
//A_B_Diapazon(Light,A,temp1,D);
//if temp1^.n=0 then
//    begin
//      dispose(temp1);
//      Exit;
//    end;
//if not(Light) then
//    begin
//      Iph:=0;Voc:=0;Isc:=0;Pm:=0;FF:=0;
//    end;
//
//try
//  if Light then
//       begin
//        case Func of
//         0: Aprox (3,temp1, Mode,n,Rs,I0,Rsh,Isc,Voc,Iph);
//         1: Aprox (4,temp1, Mode,n,Rs,I0,Rsh,Isc,Voc,Iph);
//         2: begin
//            DifEvol (temp1, photodiod,Mode,Param);
//            n:=Param[0];
//            Rs:=Param[1];
//            I0:=Param[2];
//            Rsh:=Param[3];
//            Iph:=Param[4];
//            if (Iph>1e-7) then
//              begin
//              Voc:=Voc_Isc_Pm(1,temp1,n,Rs,I0,Rsh,Iph);
//              Isc:=Voc_Isc_Pm(2,temp1,n,Rs,I0,Rsh,Iph);
//              end;
//            end; //'2'
//        end;// case Func of
//        if (Voc>0.002)and(Isc>1e-7)and(Voc<>555)and(Isc<>555) then
//            Pm:=Voc_Isc_Pm(3,temp1,n,Rs,I0,Rsh,Iph);
//        if (Voc<>0)and(Voc<>555)and(Isc<>0)and(Isc<>555) then
//           FF:=Pm/Voc/Isc;
//       end //then      if Light then
//           else
//        case Func of
//         0: Aprox (0,temp1, Mode,n,Rs,I0,Rsh,Isc,Voc,Iph);
//         1: Aprox (1,temp1, Mode,n,Rs,I0,Rsh,Isc,Voc,Iph);
//         2:
//           begin
////            DifEvol (temp1, diod,Mode,Param);
//            MABC (temp1, diod,Mode,Param);
//            n:=Param[0];
//            Rs:=Param[1];
//            I0:=Param[2];
//            Rsh:=Param[3];
//           end;
//        end;
//except
// n:=555;
//end;
//if n=555 then
//  begin
//  dispose(temp1);
//  Exit;
//  end;
//dispose(temp1);
//if (Szr<>0)and(Szr<>555)and(AA<>0)and(AA<>555) then
//   Fb:=Kb*A^.T*ln(Szr*AA*sqr(A^.T)/I0);
//end;
//

//Procedure KalkOneDiod(A:Pvector; D:Diapazon; Mode:byte;
//         Light:boolean; EvolType:TEvolutionType;
//    var n:double; var I0:double; var Rs:double;
//    var Rsh:double; var Iph:double; var Voc:double; var Isc:double;
//    var Pm:double; var FF:double);
//{на основі даних з вектора А шляхом
//еволюційної апроксимації ВАХ за формулою
//І=I0*[exp(q(V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
//(з врахуванням обмежень, вказаних в D), визначає величину
//коефіцієнту неідеальності n,
//струму насичення І0
//послідовний опір Rs;
//шунтуючий опір Rsh;
//фотострум Iph;
//напругу холостого ходу Voc;
//струм короткого замикання Isc;
//максимальну вихідну потужність фотоелементу Pm;
//коефіцієнт форми ВАХ фотоелементу  FF;
//EvolType - визначає еволюційний алгоритм
// (див. OlegType)
//
//при Light=False - Iph=0, Voc=0, Isc=0, Pm=0, FF=0;
//при Mode=1 - Rsh=1e12;
//при Mode=2 - Rs=0;
//при Mode=3 - Rsh=1e12 та  Rs=0;
//при Mode=0 - розраховуються всі величини;
//}
//var temp1:Pvector;
//    Param:TArrSingle;
//begin
//if (D.YMin=555) or (D.YMin<=0) then D.YMin:=0;
//if (D.XMin=555) then D.XMin:=0.001;
//n:=555;
////Fb:=555;
//I0:=555;
//Rs:=555;
//Rsh:=555;
//Iph:=555;
//Voc:=555;
//Isc:=555;
//Pm:=555;
//FF:=555;
//
//new(temp1);
//A_B_Diapazon(Light,A,temp1,D);
//if temp1^.n=0 then
//    begin
//      dispose(temp1);
//      Exit;
//    end;
//if not(Light) then
//    begin
//      Iph:=0;Voc:=0;Isc:=0;Pm:=0;FF:=0;
//    end;
//
//try
//  if Light then
//       begin
//       case EvolType of
//        TMABC:MABC (temp1, photodiod,Mode,Param);
//        TTLBO:TLBO (temp1, photodiod,Mode,Param);
//        TPSO:DifEvol (temp1, photodiod,Mode,Param);
//        else DifEvol (temp1, photodiod,Mode,Param);
//       end;
//       n:=Param[0];
//       Rs:=Param[1];
//       I0:=Param[2];
//       Rsh:=Param[3];
//       Iph:=Param[4];
//       if (Iph>1e-7) then
//              begin
//              Voc:=Voc_Isc_Pm(1,temp1,n,Rs,I0,Rsh,Iph);
//              Isc:=Voc_Isc_Pm(2,temp1,n,Rs,I0,Rsh,Iph);
//              end;
//        if (Voc>0.002)and(Isc>1e-7)and(Voc<>555)and(Isc<>555) then
//            Pm:=Voc_Isc_Pm(3,temp1,n,Rs,I0,Rsh,Iph);
//        if (Voc<>0)and(Voc<>555)and(Isc<>0)and(Isc<>555) then
//           FF:=Pm/Voc/Isc;
//       end //then      if Light then
//
//           else
//       begin
//         case EvolType of
//          TMABC:MABC (temp1, diod,Mode,Param);
//          TTLBO:TLBO (temp1, diod,Mode,Param);
//          TPSO:DifEvol (temp1, diod,Mode,Param);
//          else DifEvol (temp1, diod,Mode,Param);
//         end;
//          n:=Param[0];
//          Rs:=Param[1];
//          I0:=Param[2];
//          Rsh:=Param[3];
//       end;
//except
// n:=555;
//end;
//dispose(temp1);
//end;

//Procedure KalkTwoDiod(A:Pvector; D:Diapazon; Mode:byte;
//         Light:boolean; EvolType:TEvolutionType;
//    var n1:double; var I01:double; var n2:double; var I02:double;
//    var Rs:double;
//    var Rsh:double; var Iph:double; var Voc:double; var Isc:double;
//    var Pm:double; var FF:double);
//{на основі даних з вектора А шляхом
//еволюційної апроксимації ВАХ за формулою
//І=I01*[exp(q(V-IRs)/n1kT)-1]+I02*[exp(q(V-IRs)/n2kT)-1]+(V-IRs)/Rsh-Iph
//(з врахуванням обмежень, вказаних в D), визначає величину
//коефіцієнтів неідеальності n1 та n2,
//струмів насичення І01 та І02,
//послідовний опір Rs;
//шунтуючий опір Rsh;
//фотострум Iph;
//напругу холостого ходу Voc;
//струм короткого замикання Isc;
//максимальну вихідну потужність фотоелементу Pm;
//коефіцієнт форми ВАХ фотоелементу  FF;
//EvolType - визначає еволюційний алгоритм
// (див. OlegType)
//
//при Light=False - Iph=0, Voc=0, Isc=0, Pm=0, FF=0;
//при Mode=1 - Rsh=1e12;
//при Mode=2 - Rs=0;
//при Mode=3 - Rsh=1e12 та  Rs=0;
//при Mode=0 - розраховуються всі величини;
//}
//var temp1:Pvector;
//    Param:TArrSingle;
//begin
//if (D.YMin=555) or (D.YMin<=0) then D.YMin:=0;
//if (D.XMin=555) then D.XMin:=0.001;
////showmessage(floattostr(D.XMin));
//n1:=555;
//I01:=555;
//n2:=555;
//I02:=555;
//Rs:=555;
//Rsh:=555;
//Iph:=555;
//Voc:=555;
//Isc:=555;
//Pm:=555;
//FF:=555;
//
//new(temp1);
//A_B_Diapazon(Light,A,temp1,D);
//if temp1^.n=0 then
//    begin
//      dispose(temp1);
//      Exit;
//    end;
//if not(Light) then
//    begin
//      Iph:=0;Voc:=0;Isc:=0;Pm:=0;FF:=0;
//    end;
//
////showmessage(inttostr(temp1^.n));
//
//try
//  if Light then
//       begin
//       case EvolType of
//        TMABC:MABC (temp1, DoubleDiodLight,Mode,Param);
//        TTLBO:TLBO (temp1, DoubleDiodLight,Mode,Param);
//        TPSO:DifEvol (temp1, DoubleDiodLight,Mode,Param);
//        else DifEvol (temp1, DoubleDiodLight,Mode,Param);
//       end;
//       n1:=Param[0];
//       Rs:=Param[1];
//       I01:=Param[2];
//       Rsh:=Param[3];
//       n2:=Param[4];
//       I02:=Param[5];
//       Iph:=Param[6];
//       if (Iph>1e-7) then
//              begin
//              Voc:=Voc_Isc_Pm_DoubleDiod(1,Param[0]*Kb*A^.T,Param[4]*Kb*A^.T,
//               Param[1],Param[2],Param[5],Param[3],Param[6]);
//
//              Isc:=Voc_Isc_Pm_DoubleDiod(2,Param[0]*Kb*A^.T,Param[4]*Kb*A^.T,
//               Param[1],Param[2],Param[5],Param[3],Param[6]);
//              end;
//        if (Voc>0.002)and(Isc>1e-7)and(Voc<>555)and(Isc<>555) then
//            Pm:=Voc_Isc_Pm_DoubleDiod(3,Param[0]*Kb*A^.T,Param[4]*Kb*A^.T,
//               Param[1],Param[2],Param[5],Param[3],Param[6]);
//        if (Voc<>0)and(Voc<>555)and(Isc<>0)and(Isc<>555) then
//           FF:=Pm/Voc/Isc;
//       end //then      if Light then
//
//           else
//       begin
//         case EvolType of
//          TMABC:MABC (temp1, DoubleDiod,Mode,Param);
//          TTLBO:TLBO (temp1, DoubleDiod,Mode,Param);
//          TPSO:DifEvol (temp1, DoubleDiod,Mode,Param);
//          else DifEvol (temp1, DoubleDiod,Mode,Param);
//         end;
//         n1:=Param[0];
//         Rs:=Param[1];
//         I01:=Param[2];
//         Rsh:=Param[3];
//         n2:=Param[4];
//         I02:=Param[5];
//       end;
//except
// n:=555;
//end;
//dispose(temp1);
//end;
//


//Procedure KalkDiodTwo(A:Pvector; D:Diapazon; AA, Szr :double;
//    var n:double; var I0:double; var Fb:double; var Rs:double;
//    var Iph:double; var FF:double);
//var temp1:Pvector;
//    Param:TArrSingle;
//    Str1:TStringList;
//    i:integer;
//    I1,I2:double;
//
//begin
//if (D.YMin=555) or (D.YMin<=0) then D.YMin:=0;
//if (D.XMin=555) then D.XMin:=0.001;
//n:=555;
//Fb:=555;
//I0:=555;
//Rs:=555;
//Iph:=555;
//FF:=555;
//
//new(temp1);
//A_B_Diapazon(False,A,temp1,D);
//if temp1^.n=0 then
//    begin
//      dispose(temp1);
//      Exit;
//    end;
//
//try
//  MABC (temp1,DiodTwo,0,Param);
////  MABC (temp1, diod,Mode,Param);
//  n:=Param[3];
//  Rs:=Param[1];
//  I0:=Param[4];
//  Iph:=Param[2];
//  FF:=Param[0];
// Str1:=TStringList.Create;
// for I := 0 to High(temp1^.x) do
//   begin
//   I2:=Param[4]*(exp(temp1^.X[i]/(Param[3]*Kb*A^.T))-1);
//   I1:=Full_IV(temp1^.X[i],Param[0]*Kb*A^.T,Param[1],Param[2],1e13,0);
//   Str1.Add(FloatToStrF(temp1^.X[i],ffExponent,4,0)+' '+
//           FloatToStrF(temp1^.Y[i],ffExponent,4,0)+' '+
//           FloatToStrF(I1,ffExponent,4,0)+' '+
//           FloatToStrF(I2,ffExponent,4,0)+' '+
//           FloatToStrF(I1+I2,ffExponent,4,0));
//   end;
// Str1.SaveToFile(copy(A^.name,1,length(A^.name)-5)+'t.dat');
// Str1.Free;
//except
// n:=555;
//end;
//if n=555 then
//  begin
//  dispose(temp1);
//  Exit;
//  end;
//dispose(temp1);
//if (Szr<>0)and(Szr<>555)and(AA<>0)and(AA<>555) then
//   Fb:=Kb*A^.T*ln(Szr*AA*sqr(A^.T)/I0);
//end;

//Procedure KalkDiodTwoFull(A:Pvector; D:Diapazon; AA, Szr :double;
//    var n:double; var I0:double; var Fb:double; var Rs:double;
//    var Iph:double; var Voc:double; var Isc:double);
//var temp1:Pvector;
//    Param:TArrSingle;
//    Str1:TStringList;
//    i:integer;
//    I1,I2:double;
//
//begin
//if (D.YMin=555) or (D.YMin<=0) then D.YMin:=0;
//if (D.XMin=555) then D.XMin:=0.001;
//n:=555;
//Fb:=555;
//I0:=555;
//Rs:=555;
//Iph:=555;
//Voc:=555;
//Isc:=555;
//
//new(temp1);
//A_B_Diapazon(False,A,temp1,D);
//if temp1^.n=0 then
//    begin
//      dispose(temp1);
//      Exit;
//    end;
//
//try
//  MABC (temp1,DiodTwoFull,0,Param);
//  n:=Param[3];
//  Rs:=Param[1];
//  I0:=Param[4];
//  Iph:=Param[2];
//  Voc:=Param[0];
//  Isc:=Param[5];
// Str1:=TStringList.Create;
// for I := 0 to High(temp1^.x) do
//   begin
//   I2:=Full_IV(temp1^.X[i],Param[3]*Kb*A^.T,Param[5],Param[4],1e13,0);
//   I1:=Full_IV(temp1^.X[i],Param[0]*Kb*A^.T,Param[1],Param[2],1e13,0);
//   Str1.Add(FloatToStrF(temp1^.X[i],ffExponent,4,0)+' '+
//           FloatToStrF(temp1^.Y[i],ffExponent,4,0)+' '+
//           FloatToStrF(I1,ffExponent,4,0)+' '+
//           FloatToStrF(I2,ffExponent,4,0)+' '+
//           FloatToStrF(I1+I2,ffExponent,4,0));
//   end;
// Str1.SaveToFile(copy(A^.name,1,length(A^.name)-5)+'t.dat');
// Str1.Free;
//except
// n:=555;
//end;
//if n=555 then
//  begin
//  dispose(temp1);
//  Exit;
//  end;
//dispose(temp1);
//if (Szr<>0)and(Szr<>555)and(AA<>0)and(AA<>555) then
//   Fb:=Kb*A^.T*ln(Szr*AA*sqr(A^.T)/I0);
//end;
//


Procedure NordDodat(A:Pvector; D:Diapazon; AA, Szr,Gamma:double;
                   var V0:double; var I0:double; var F0:double);
{на основі даних з вектора А (з рахуванням
обмежень в D) будує функцію Норда та визначає
координату її мінімума V0, відповідне
значення самої фуекції F0 та значення струму І0,
яке відповідає V0 у вихідних даних}
var temp1,temp2:Pvector;
begin
V0:=555;
I0:=555;
F0:=555;
new(temp1);
NordeFun(A,temp1,AA,Szr,Gamma);    // в temp1 повна функція Норда
if temp1^.n=0 then
             begin
               dispose(temp1);
               Exit;
             end;
new(temp2);

repeat
if NumberMax(temp1)<2 then Break;
Median (temp1,temp2);
Smoothing(temp2,temp1);
until False;


A_B_Diapazon(A,temp1,temp2,D);

if temp2^.n<3 then
          begin
           dispose(temp1);dispose(temp2);Exit;
          end;
{в temp2 - частина функції Норда, яка
задовольняє умовам в D}

V0:=Extrem(temp2);
//showmessage(floattostr(V0));

F0:=ChisloY(temp2,V0);
//showmessage(floattostr(F0));

I0:=ChisloY(A,V0);
dispose(temp2);
dispose(temp1);
end;


Procedure NordKalk(A:Pvector; D:Diapazon; AA, Szr,Gamma:double; {Gamma:word;}
                   n:double; var Rs:double; var Fb:double);
{на основі даних з вектора А шляхом побудови
функції Норда (з врахуванням
обмежень, вказаних в D), визначає величину
послідовного опору Rs та висоти бар'єру Fb;
для побудови функції Норда потрібні
AA - стала Річардсона,
Szr - площа контакту,
Gamma - параметр гамма (див формулу)
для обчислення Rs
n - показник ідеальності}
var V0,I0,F0:double;
begin
Rs:=555;
Fb:=555;

NordDodat(A,D,AA,Szr,Gamma,V0,I0,F0);
if V0=555 then Exit;

if n<>555 then
     begin
     Fb:=F0+(Gamma-n)/n*(V0/Gamma-Kb*A^.T);
     Rs:=Kb*A^.T*(Gamma-n)/I0;
     end;
end;

//Procedure CibilsKalk(A:Pvector; D:Diapazon;
//                     var Rs:double; var n:double);
Procedure CibilsKalk(const A:Pvector; const D:Diapazon;
                     out Rs:double; out n:double);
{на основі даних з вектора А шляхом побудови
функції Сібілса, визначає величину
послідовного опору Rs та
показника ідеальності n}
var temp1:Pvector;
    a0,b0:double;
begin
Rs:=555;
n:=555;
new(temp1);
CibilsFun(A,D,temp1);
if temp1^.n<2 then
              begin
              dispose(temp1);
              Exit;
              end;
LinAprox(temp1,a0,b0);
Rs:=1/b0;
if A^.T>0 then n:=-a0/b0/Kb/A^.T;
dispose(temp1);
end;

Procedure IvanovKalk(A:Pvector; D:Diapazon; Rs, AA, Szr, Nd, ep:double;
                     var del:double; var Fb:double);
{на основі даних з вектора А (з врахуванням
обмежень, вказаних в D), за методом Іванова
визначає величину товщини діелектричного шару del
(якщо точніше - товщини шару, поділеної на
величину відносної діелектричної проникності шару)
та висоту бар'єру Fb;
AA - стала Річардсона
Szr - площа контакту
Nd - концентрація донорів у напівпровіднику;
eр - діелектрична проникність напівпровідника
Rs - послідовний опір, апроксимацію потрібно проводити
для ВАХ, побудованої з врахуванням Rs
}
var temp,temp2:PVector;
begin
del:=555;
Fb:=555;
if Rs=555 then Exit;
new(temp);
ForwardIVwithRs(A,temp,Rs);
if temp^.n=0 then
    begin
      dispose(temp);
      Exit;
    end;
new(temp2);
A_B_Diapazon(A,temp,temp2,D);
if temp2^.n=0 then
    begin
      dispose(temp2);
      dispose(temp);
      Exit;
    end;
IvanovAprox (temp2,AA, Szr, Nd, ep,del,Fb);
dispose(temp2);
dispose(temp);
end;

Procedure Kam1Kalk (A:Pvector; D:Diapazon; var Rs:double; var n:double);
{на основі даних з вектора А шляхом побудови
функції Камінські (з врахуванням
обмежень, вказаних в D), визначає величину
послідовного опору Rs та коефіцієнта неідеальності n;
якщо A^.T<=0, то n=555 і розраховується лише Rs}
var temp1:Pvector;
begin
new(temp1);
Kam1_Fun(A,temp1,D);    // в temp1 повна функція Камінськи І-роду
if temp1^.n=0 then
    begin
     Rs:=555;
     n:=555;
     dispose(temp1);
     Exit;
    end;
LinAprox(temp1,n,Rs);
if A^.T<=0 then n:=555
           else n:=n/Kb/A^.T;
dispose(temp1);
end;

//Procedure Kam2Kalk (A:Pvector; D:Diapazon; var Rs:double; var n:double);
Procedure Kam2Kalk (const A:Pvector; const D:Diapazon; out Rs:double; out n:double);
{на основі даних з вектора А шляхом побудови
функції Камінські (з врахуванням
обмежень, вказаних в D), визначає величину
послідовного опору Rs та коефіцієнта неідеальності n}
var temp1:Pvector;
begin
Rs:=555;
n:=555;

new(temp1);
Kam2_Fun(A,temp1,D);    // в temp1 повна функція Камінськи ІІ-роду
if temp1^.n<2 then
    begin
     dispose(temp1);
     Exit;
    end;
LinAprox(temp1,Rs,n);
Rs:=-Rs/n;
if A^.T>0 then n:=1/n/Kb/A^.T
          else n:=555;
dispose(temp1);
end;

Procedure Gr1Kalk (A:Pvector; D:Diapazon; AA, Szr:double;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{на основі даних з вектора А (з врахуванням
обмежень, вказаних в D) методом Громова
першого роду визначаються величини
послідовного опору Rs, коефіцієнта неідеальності n,
висоти бар'єру Fb та струму насичення І0;
якщо температура не задана, то визначається
лише Rs, решті величин присвоюється значення 555;
якщо неможливо побудувати функцію Громова,
то і Rs=555}
var temp1,temp2:Pvector;
    C0,C1,C2:double;
    Dtemp:Diapazon;
    i,j,Np:integer;
    DDD:Pvector;

begin

new(temp1);
new(DDD);
Rs:=555;
n:=555;
Fb:=555;
I0:=555;
Dtemp:=Diapazon.Create;
Dtemp.Copy(D);

  i:=0;
  repeat
    if (A^.X[i]>D.Xmin)and(A^.Y[i]>D.Ymin) then Break;
    inc(i);
  until (i=High(A^.X));

Np:=0;
new(temp2);

repeat
  Dtemp.Xmin:=0.99999*A^.X[i];
  A_B_Diapazon(A,A,temp1,Dtemp);
  if temp1^.n<6 then Break;
  Gr1_Fun (temp1,temp2);
  if temp2^.n<6 then Break;
  GromovAprox(temp2,C0,C1,C2);
  inc(Np);
  SetLenVector(DDD,Np);
  DDD^.Y[Np-1]:=0;
  DDD^.X[Np-1]:=Dtemp.Xmin;

//  if (C0<=0)or(C1<0)or(C2<=0) then
//      DDD^.Y[Np-1]:=555
//                               else


   for j := 0 to High(A^.X) do
     begin
     try
     DDD^.Y[Np-1]:=DDD^.Y[Np-1]+sqr(1-Full_IV(A^.X[j],C2,C1,exp(-C0/C2),1e13,0)/A^.Y[j]);
     except
      DDD^.Y[Np-1]:=555
     end;
     end;

  inc(i);
until False;



//Write_File('hhh.dat',DDD);

if High(DDD^.Y)>-1 then
  begin
    Dtemp.Xmin:=DDD^.X[MinElemNumber(DDD^.Y)];
    A_B_Diapazon(A,A,temp1,Dtemp);
    Gr1_Fun (temp1,temp2);
    GromovAprox(temp2,C0,C1,C2);
    Rs:=C1;
    if A^.T>0 then
       begin
       n:=C2/Kb/A^.T;
       Fb:=Kb*A^.T*C0/C2+Kb*A^.T*ln(Szr*AA*sqr(A^.T));
       I0:=exp(-C0/C2);
       end;
  end;

dispose(temp1);
Dtemp.Free;
dispose(temp2);
dispose(DDD);

//new(temp1);
//Rs:=555;
//n:=555;
//Fb:=555;
//I0:=555;
//A_B_Diapazon(A,A,temp1,D);
//// в temp1 ті точки з А, які задовольняють D
//if temp1^.n<3 then
//             begin
//             dispose(temp1);
//             Exit;
//             end;
//new(temp2);
//Gr1_Fun (temp1,temp2);
//{ в temp2 функція Громова першого роду,
//побудована лише по потрібним точкам}
//dispose(temp1);
//if temp2^.n<3 then
//             begin
//             dispose(temp2);
//             Exit;
//             end;
//GromovAprox(temp2,C0,C1,C2);
//Rs:=C1;
//if A^.T>0 then                   
//   begin
//   n:=C2/Kb/A^.T;
//   Fb:=Kb*A^.T*C0/C2+Kb*A^.T*ln(Szr*AA*sqr(A^.T));
//   I0:=exp(-C0/C2);
//   end;
//dispose(temp2);
end;

Procedure Gr2Kalk (A:Pvector; D:Diapazon; AA, Szr:double;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{на основі даних з вектора А (з врахуванням
обмежень, вказаних в D) методом Громова
другого роду визначаються величини
послідовного опору Rs, коефіцієнта неідеальності n,
висоти бар'єру Fb та струму насичення І0;
якщо температура не задана, то всі величини рівні 555}
var temp1,temp2:Pvector;
    C0,C1,C2:double;
//    Dtemp:Diapazon;
//    i,j,Np:integer;
//    DDD:Pvector;

begin
Rs:=555;
n:=555;
Fb:=555;
I0:=555;
if A^.T<=0 then Exit;


//new(temp1);
//new(DDD);
//
//
//Dtemp:=Diapazon.Create;
//Dtemp.Copy(D);
//
//  i:=0;
//  repeat
//    if (A^.X[i]>D.Xmin)and(A^.Y[i]>D.Ymin) then Break;
//    inc(i);
//  until (i=High(A^.X));
//
//Np:=0;
//new(temp2);
//
//repeat
//  Dtemp.Xmin:=0.99999*A^.X[i];
//  Gr2_Fun (A,temp1,AA,Szr);
//  if temp1^.n<6 then Break;
//   A_B_Diapazon(A,temp1,temp2,Dtemp);
//  if temp2^.n<6 then Break;
//{в temp2 частина функція Громова другого роду,
//  яка задовольняє умови в Dtemp}
//
//  GromovAprox(temp2,C0,C1,C2);
//  Rs:=2*C1;
//  n:=2*C2/Kb/A^.T+2;
//  Fb:=2*C0/n-Kb*A^.T/n*(2-n)*ln(Szr*AA*sqr(A^.T));
//  I0:=Szr*AA*sqr(A^.T)*exp(-Fb/Kb/A^.T);
//
//  inc(Np);
//  SetLenVector(DDD,Np);
//  DDD^.Y[Np-1]:=0;
//  DDD^.X[Np-1]:=Dtemp.Xmin;
//
//  if (Rs<0)or(n<=0) then
//      DDD^.Y[Np-1]:=555
//                               else
//
//   for j := 0 to High(A^.X) do
//     try
//     DDD^.Y[Np-1]:=DDD^.Y[Np-1]+sqr(1-Full_IV(A^.X[j],n*Kb*A^.T,Rs,I0,1e13,0)/A^.Y[j]);
//     except
//      DDD^.Y[Np-1]:=555
//     end;
//
//  inc(i);
//
//until False;
//
//
//if High(DDD^.Y)>-1 then
//  begin
//    Dtemp.Xmin:=DDD^.X[MinElemNumber(DDD^.Y)];
//    Gr2_Fun (A,temp1,AA,Szr);
//    A_B_Diapazon(A,temp1,temp2,Dtemp);
//    GromovAprox(temp2,C0,C1,C2);
//    Rs:=2*C1;
//    n:=2*C2/Kb/A^.T+2;
//    Fb:=2*C0/n-Kb*A^.T/n*(2-n)*ln(Szr*AA*sqr(A^.T));
//    I0:=Szr*AA*sqr(A^.T)*exp(-Fb/Kb/A^.T);
//  end;
//
//dispose(temp1);
//Dtemp.Free;
//dispose(temp2);
//dispose(DDD);

//-------------------------------------------------


new(temp1);
Gr2_Fun (A,temp1,AA,Szr);
{ в temp1 повна функція Громова другого роду}
if temp1^.n=0 then
             begin
             dispose(temp1);
             Exit;
             end;
new(temp2);
A_B_Diapazon(A,temp1,temp2,D);
{в temp2 частина функція Громова другого роду,
  яка задовольняє умови в D}
dispose(temp1);

if temp2^.n=0 then
          begin
           dispose(temp2);Exit;
          end;

GromovAprox(temp2,C0,C1,C2);
Rs:=2*C1;
n:=2*C2/Kb/A^.T+2;
Fb:=2*C0/n-Kb*A^.T/n*(2-n)*ln(Szr*AA*sqr(A^.T));
I0:=Szr*AA*sqr(A^.T)*exp(-Fb/Kb/A^.T);
dispose(temp2);
end;


Procedure BohlinKalk(A:Pvector; D:Diapazon; AA, Szr, Gamma1,Gamma2:double;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{на основі даних з вектора А (з врахуванням
обмежень, вказаних в D), за допомогою
методу Бохліна визначаються величини
послідовного опору Rs, фактора
неідеальності n та висоти бар'єру Fb
(а також струму насичення І0;
для побудови функцій Норда потрібні
AA - стала Річардсона,
Szr - площа контакту,
Gamma - параметр гамма,
друге значення гамма просте береться
на дві десятих більше ніж Gamma}
var V01,V02,I01,I02,F01,F02,temp:double;
begin
Rs:=555;
n:=555;
Fb:=555;
I0:=555;

NordDodat(A,D,AA,Szr,Gamma1,V01,I01,F01);
NordDodat(A,D,AA,Szr,Gamma2,V02,I02,F02);
if (V01=555) or (V02=555) then Exit;

temp:=(V01-V02+(Gamma2-Gamma1)*Kb*A^.T)/(F02-F01-V02/Gamma2+V01/Gamma1);
n:=((Gamma1*I02-Gamma2*I01)/(I02-I01));
n:=abs((n+temp)/2);

temp:=(Gamma2-n)*Kb*A^.T/I02;
Rs:=(Gamma1-n)*Kb*A^.T/I01;
Rs:=(Rs+temp)/2;


temp:=F02+V02*(1/n-1/Gamma2)-(Gamma2-n)*Kb*A^.T/n;
Fb:=F01+V01*(1/n-1/Gamma1)-(Gamma1-n)*Kb*A^.T/n;
Fb:=(Fb+temp)/2;
I0:=Szr*AA*sqr(A^.T)*exp(-Fb/Kb/A^.T);

end;

Procedure LeeKalk (A:Pvector; D:Diapazon; AA, Szr:double;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{на основі даних з вектора А (з врахуванням
обмежень, вказаних в D) методом побудови
функції Лі визначаються величини
послідовного опору Rs, коефіцієнта неідеальності n,
висоти бар'єру Fb та струму насичення І0;
якщо температура не задана, то визначається
лише Rs, решті величин присвоюється значення 555;
якщо неможливо побудувати функцію Лі,
то і Rs=555}
var temp1:Pvector;
    a0,b0:double;
//    Dtemp:Diapazon;
//    i,j,Np:integer;
//    DDD:Pvector;

begin

Rs:=555;
n:=555;
Fb:=555;
I0:=555;

//-------------------------------------

//if A^.T<=0 then Exit;
//new(temp1);
//new(DDD);
//Dtemp:=Diapazon.Create;
//Dtemp.Copy(D);
//
//  i:=0;
//  repeat
//    if (A^.X[i]>D.Xmin)and(A^.Y[i]>D.Ymin) then Break;
//    inc(i);
//  until (i=High(A^.X));
//
//Np:=0;
//
//
//repeat
//  Dtemp.Xmin:=0.99999*A^.X[i];
//  LeeFun(A,Dtemp,temp1);
//  if temp1^.n<4 then Break;
//  LinAprox(temp1,a0,b0);
//  Rs:=1/b0;
//  n:=-a0/b0/Kb/A^.T;
//  I0:=exp(-temp1^.T/Kb/A^.T/n);
//  Fb:=temp1^.T/n+Kb*A^.T*ln(Szr*AA*sqr(A^.T));
//
//  inc(Np);
//  SetLenVector(DDD,Np);
//  DDD^.Y[Np-1]:=0;
//  DDD^.X[Np-1]:=Dtemp.Xmin;
//
//  if (Rs<0)or(n<=0) then
//      DDD^.Y[Np-1]:=555*A^.n
//                               else
//
//   for j := 0 to High(A^.X) do
//     DDD^.Y[Np-1]:=DDD^.Y[Np-1]+sqr(1-Full_IV(A^.X[j],n*Kb*A^.T,Rs,I0,1e13,0)/A^.Y[j]);
//
//  inc(i);
//
//until False;
//
//
//if High(DDD^.Y)>-1 then
//  begin
//    Dtemp.Xmin:=DDD^.X[MinElemNumber(DDD^.Y)];
//    LeeFun(A,Dtemp,temp1);
//    LinAprox(temp1,a0,b0);
//    Rs:=1/b0;
//    n:=-a0/b0/Kb/A^.T;
//    I0:=exp(-temp1^.T/Kb/A^.T/n);
//    Fb:=temp1^.T/n+Kb*A^.T*ln(Szr*AA*sqr(A^.T));
//  end;
//
//dispose(temp1);
//Dtemp.Free;
//
//dispose(DDD);

//-------------------------------------------------



new(temp1);
LeeFun(A,D,temp1);
if temp1^.n<2 then
              begin
              dispose(temp1);
              Exit;
              end;
LinAprox(temp1,a0,b0);
Rs:=1/b0;
if A^.T>0 then
            begin
            n:=-a0/b0/Kb/A^.T;
            I0:=exp(-temp1^.T/Kb/A^.T/n);
            Fb:=temp1^.T/n+Kb*A^.T*ln(Szr*AA*sqr(A^.T));
            end;
dispose(temp1);
end;

Function Y_X0 (X1,Y1,X2,Y2,X3:double):double;
{знаходить ординату точки з абсцисою Х3,
яка знаходиться між точками (Х1,Y1) та (X2,Y2) -
лінійна інтерполяція по двом точкам}
begin
 Result:=(Y2*X1-Y1*X2)/(X1-X2)+X3*(Y1-Y2)/(X1-X2);
end;

Function X_Y0 (X1,Y1,X2,Y2,Y3:double):double;
{знаходить абсцису точки з ординатою Y3,
яка знаходиться між точками (Х1,Y1) та (X2,Y2) -
лінійна інтерполяція по двом точкам}
begin
 Result:=(Y3-(Y2*X1-Y1*X2)/(X1-X2))/(Y1-Y2)*(X1-X2);
end;

function ChisloY (A:Pvector; X:double):double;
{визначає приблизну ординату точки з
абсцисою Х для випадку, коли ця точка
входила б до функціональної залежності,
записаної в А;
якщо Х не належить діапазону зміни
абсцис вектора А, то повертається 555}
var i:integer;
    bool:boolean;
begin
bool:=false;
i:=1;
Result:=555;
repeat
 if ((A^.X[i]-X)*(A^.X[i-1]-X))<=0 then
   begin
   Result:=Y_X0(A^.X[i],A^.Y[i],a^.X[i-1],a^.Y[i-1],X);
   bool:= true;
   end;
 i:=i+1;
until ((bool) or (i>High(A^.X)));
end;

function ChisloX (A:Pvector; Y:double):double;
{визначає приблизну абсцису точки з
ординатою Y для випадку, коли ця точка
входила б до функціональної залежності,
записаної в А;
якщо Y не належить діапазону зміни
ординат вектора А, то повертається 555}
var i:integer;
    bool:boolean;
begin
bool:=false;i:=1;
Result:=555;
repeat
 if ((A^.Y[i]-Y)*(A^.Y[i-1]-Y))<=0 then
   begin
   Result:=X_Y0(A^.X[i],A^.Y[i],a^.X[i-1],a^.Y[i-1],Y);
   bool:= true;
   end;
 i:=i+1;
until ((bool) or (i>High(A^.X)));
end;

function Krect(A:Pvector; V:double):double;
{обчислення коефіцієнту випрямлення
за даними у векторі А при напрузі V;
якщо точок в потрібному діапазоні немає -
пишиться повідомлення і повертається 555}
var temp1, temp2:double;
begin
   Result:=555;
   temp1:=ChisloY(A,V);
   temp2:=ChisloY(A,-V);
   if (temp1=555)or(temp2=555) then Exit;
   if (temp2<>0) then Result:=abs(temp1/temp2);
end;

function IscCalc(A:Pvector):double;
{обчислюється струм короткого замикання
за даними у векторі А}
var temp, temp2:double;
begin
 Result:=0;
 if A^.n<2 then Exit;
 temp:=ChisloY(A,0);
 temp2:=ChisloY(A,0.01);
 if {(temp=555)or
    (temp2=555)or
    (temp>=0)or  }
    (abs(temp2/temp)>2) then Exit
             else Result:=-temp;
 if temp=555 then
      Result:=(-A^.Y[1]*A^.X[0]+A^.Y[0]*A^.X[1])/(A^.X[0]-A^.X[1]);
end;

function VocCalc(A:Pvector):double;
{обчислюється напруга холостого ходу
за даними у векторі А}
var temp:double;
begin
 Result:=0;
 temp:=ChisloX(A,0);
 if (temp=555)or
    (temp<=0) then Exit
              else Result:=temp;
end;

Function Extrem (A:PVector):double;
{знаходить абсцису екстремума функції,
що знаходиться в А;
вважаеться, що екстремум один;
якщо екстремума немає - повертається 555;
якщо екстремум не чіткий - значить будуть
проблеми :-)}
var temp:PVector;
begin
new(temp);
Diferen(A,temp);
Result:=ChisloX(temp,0);
dispose(temp);
end;

Procedure GraphFill(Series:TLineSeries;Func:TFunSingle;
                    x1,x2:double;Npoint:word);
{заповнює Series значеннями Func(х) в діапазоні
від х1 до х2 з загальною кількістю точок Npoint+1}
var x,dx:double;
    i:word;
begin
if Npoint>65534 then Npoint:=65534;
dx:=(x2-x1)/Npoint;
for I := 0 to Npoint do
  begin
    x:=x1+dx*i;
    Series.AddXY(x,Func(x));
  end;

end;

Procedure GraphFill(Series:TLineSeries;Func:TFunDouble;
                    x1,x2:double;Npoint:word;y0:double);overload;
{заповнює Series значеннями Func(х,y0) в діапазоні
від х1 до х2 з загальною кількістю точок Npoint+1}
var x,dx:double;
    i:word;
begin
Series.Clear;
if Npoint>65534 then Npoint:=65534;
dx:=(x2-x1)/Npoint;
for I := 0 to Npoint do
  begin
    x:=x1+dx*i;
    Series.AddXY(x,Func(x,y0));
  end;

end;

//Procedure LamRshAprox (V:PVector; mode:byte; var n,Rs,I0,Rsh:double);
//{апроксимуються дані у векторі V
//залежністю I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh
//з використанням функції Ламберта
//за методом найменших квадратів зі
//статистичними ваговими коефіцієнтами;
//mode - режим апроксимації:
//mode = 0 - всі чотири параметри підбираються;
//mode = 1 - вважається, що Rsh нескінченність (1е12);
//mode = 2 - вважається, що Rs нульовий(1е-4)
//mode = 3 - Rsh нескінченність + Rs нульовий}
//const eps=1e-7;
//      Nmax=10000;
//
//var F,X,X2:array of double;
//    i,Nit,Npar:integer;
//    ErStr:string;
//    bool:boolean;
//    Sum,al,sum2:double;
//    str:string;
//
// Function Secant(num:word;a,b,F{,n,Rs,I0,Rsh}:double):double;
//  {обчислюється оптимальне значення параметра al
//  в методі поординатного спуску;
//  використовується метод дихотомії;
//  а та b задають початковий відрізок, де шукається
//  розв'язок}
//  var i:integer;
//      c,Fb,Fa:double;
//  begin
//    Result:=0;
//
// //   showmessage('a='+floattostr(a)+#10+
////                'F='+floattostr(F));
////    Fa:=aSdal_LamShot(V,num,a,F,n,Rs,I0,Rsh);
////    Fa:=aSdal_LamShot(V,num,a,F,X[0],X[1],X[2],X[3]);
//
//    //    Fa:=aSdal_ExpShot(V,num,a,F,n,Rs,I0,Rsh);
//
//    Fa:=aSdal_LamLightShot(V,num,a,F,X[0],X[1],X[2],X[3],X[4]);
////    Fa:=aSdal_ExpLightShot(V,num,a,F,X[0],X[1],X[2],X[3],X[4]);
//
//    if Fa=555 then Exit;
//
//    if Fa=0 then
//               begin
//                  Result:=a;
//                  Exit;
//                end;
//
//    repeat
////    Fb:=aSdal_LamShot(V,num,b,F,X[0],X[1],X[2],X[3]);
////    Fb:=aSdal_ExpShot(V,num,b,F,n,Rs,I0,Rsh);
//
//    Fb:=aSdal_LamLightShot(V,num,b,F,X[0],X[1],X[2],X[3],X[4]);
////    Fb:=aSdal_ExpLightShot(V,num,b,F,X[0],X[1],X[2],X[3],X[4]);
//{    showmessage(' j ='+inttostr(num)+#10+
//                'b= '+FLOATTOSTR(b)+#10+
//                'fA= '+FLOATTOSTR(Fa)+#10+
//                'fB== '+FLOATTOSTR(Fb));
// {}
//        if Fb=0 then
//                begin
//                  Result:=b;
//                  Exit;
//                end;
// //    showmessage('fffb== '+FLOATTOSTR(Fb));
//    if Fb=555 then break//b:=b/10
//              else
//                 begin
//                 if Fb*Fa<=0 then break
//                            else b:=2*b
//                 end;
//    until false;
//
//
//     i:=0;
//    repeat
//      inc(i);
//      c:=(a+b)/2;
////        Fb:=aSdal_ExpLightShot(V,num,c,F,X[0],X[1],X[2],X[3],X[4]);
////        Fa:=aSdal_ExpLightShot(V,num,a,F,X[0],X[1],X[2],X[3],X[4]);
//        Fb:=aSdal_LamLightShot(V,num,c,F,X[0],X[1],X[2],X[3],X[4]);
//        Fa:=aSdal_LamLightShot(V,num,a,F,X[0],X[1],X[2],X[3],X[4]);
//
//        //      Fb:=aSdal_ExpShot(V,num,c,F,n,Rs,I0,Rsh);
////      Fa:=aSdal_ExpShot(V,num,a,F,n,Rs,I0,Rsh);
////      Fb:=aSdal_LamShot(V,num,c,F,X[0],X[1],X[2],X[3]);
// //     Fa:=aSdal_LamShot(V,num,a,F,X[0],X[1],X[2],X[3]);
//
//      if (Fb*Fa<=0) or (Fb=555)
//       then b:=c
//       else a:=c;
//     until (i>1e5)or(abs((b-a)/c)<1e-2);
//    if (i>1e5) then Exit;
//    Result:=c;
//  end;
//
//  Procedure VuhDatLamAprox (var n0,Rs0,I00,Rsh0:double);overload;
//  {по значенням в V визначає початкове наближення
//  для n,Rs,I0,Rsh}
//  var temp,temp2:Pvector;
//      i,k:integer;
//   begin
//    new(temp);
//     Diferen (V,temp);
//
//  {фактично, в temp залеженість оберненого опору від напруги}
//    Rsh0:=(temp^.X[1]/temp^.y[2]-temp^.X[2]/temp^.y[1])/(temp^.X[1]-temp^.X[2]);
//  {Rsh0 - по початковим двом значенням опору проводиться пряма і визначається очікуване
//      значення при нульовій напрузі}
//   if (mode=1)or(mode=3) then Rsh0:=1e12;
//
//    for I := 0 to High(temp^.X) do
//      temp^.Y[i]:=(V^.Y[i]-V^.X[i]/Rsh0);
//    {в temp - ВАХ з врахуванням Rsh0}
//
//    k:=-1;
//    for i:=0 to High(temp^.X) do
//           if Temp^.Y[i]<0 then k:=i;
//    new(temp2);
//
//   if k<0 then IVchar(temp,temp2)
//          else
//           begin
//             SetLenVector(temp2,temp^.n-k-1);
//             for i:=0 to High(temp2^.X) do
//               begin
//                temp2^.Y[i]:=temp^.Y[i+k+1];
//                temp2^.X[i]:=temp^.X[i+k+1];
//               end;
//           end;
//     for i:=0 to High(temp2^.X) do
//       temp2^.Y[i]:=ln(temp2^.Y[i]);
//
//{}    if High(temp2^.X)>6 then
//         begin
//         SetLenVector(temp,High(temp2^.X)-3);
//         for i:=3 to High(temp2^.X) do
//          begin
//           temp^.X[i-3]:=temp2^.X[i];
//           temp^.Y[i-3]:=temp2^.Y[i];
//          end;
//         end;
//    LinAprox(temp,I00,n0);{}
//{    LinAprox(temp2,I00,n0);{}
//    I00:=exp(I00);
//    n0:=1/(Kb*V^.T*n0);
//    {I00 та n0 в результаті лінійної апроксимації залежності
//    ln(I) від напруги, береться ВАХ з врахуванням Rsh0}
//     for i:=0 to High(temp2^.X) do
//       begin
//       temp2^.Y[i]:=exp(temp2^.Y[i]);;
//       end;
//   {в temp2 - частина ВАХ з врахуванням Rsh0, для якої
//   значення струму додатні}
//
//    Diferen (temp2,temp);
//     for i:=0 to High(temp.X) do
//       begin
//       temp^.X[i]:=1/temp2^.Y[i];
//       temp^.Y[i]:=1/temp^.Y[i];
//       end;
//    {в temp - залежність dV/dI від 1/І}
//
//    if temp^.n>5 then
//       begin
//       SetLenVector(temp2,5);
//       for i:=0 to 4 do
//         begin
//             temp2^.X[i]:=temp^.X[High(temp.X)-i];
//             temp2^.Y[i]:=temp^.Y[High(temp.X)-i];
//         end;
//       end
//               else
//           IVchar(temp2,temp);
//
//    LinAprox(temp2,Rs0,temp^.X[0]);
//    {Rs0 - як вільних член лінійної апроксимації
//    щонайбільше п'яти останніх точок залежності dV/dI від 1/І;
//   dV/dI= (nKbT)/(qI)+Rs;
//    temp^.X[0] використане лише для того, щоб
//    не вводити допоміжну змінну}
//    if (mode=2)or(mode=3) then Rs:=1e-4;
//
//    dispose(temp2);
//    dispose(temp);
//   end;
//
//     Procedure VuhDatExpLightmAprox (var n0,Rs0,I00,Rsh0,Iph0:double);overload;
//  {по значенням в V визначає початкове наближення
//  для n,Rs,I0,Rsh}
//  var temp,temp2:Pvector;
//      i,k:integer;
//   begin
//    Iph0:=IscCalc(V);
//    if (Iph0<=0) then Exit;
//
//    new(temp2);
//    IVchar(V,temp2);
//     for I := 0 to High(temp2^.X) do
//      temp2^.Y[i]:=temp2^.Y[i]+Iph0;
//
//    new(temp);
//    Diferen (temp2,temp);
//  {фактично, в temp залеженість оберненого опору від напруги}
//    Rsh0:=(temp^.X[1]/temp^.y[2]-temp^.X[2]/temp^.y[1])/(temp^.X[1]-temp^.X[2]);
//  {Rsh0 - по початковим двом значенням опору проводиться пряма і визначається очікуване
//      значення при нульовій напрузі}
//   if (mode=1)or(mode=3) then Rsh0:=1e12;
//
//    for I := 0 to High(temp^.X) do
//      temp^.Y[i]:=(temp2^.Y[i]-temp2^.X[i]/Rsh0);
//    {в temp - ВАХ з врахуванням Rsh0}
//
//    k:=-1;
//    for i:=0 to High(temp^.X) do
//           if Temp^.Y[i]<0 then k:=i;
////    new(temp2);
//
//   if k<0 then IVchar(temp,temp2)
//          else
//           begin
//             SetLenVector(temp2,temp^.n-k-1);
//             for i:=0 to High(temp2^.X) do
//               begin
//                temp2^.Y[i]:=temp^.Y[i+k+1];
//                temp2^.X[i]:=temp^.X[i+k+1];
//               end;
//           end;
//     for i:=0 to High(temp2^.X) do
//       temp2^.Y[i]:=ln(temp2^.Y[i]);
//
//{}    if High(temp2^.X)>6 then
//         begin
//         SetLenVector(temp,High(temp2^.X)-3);
//         for i:=3 to High(temp2^.X) do
//          begin
//           temp^.X[i-3]:=temp2^.X[i];
//           temp^.Y[i-3]:=temp2^.Y[i];
//          end;
//         end;
//    LinAprox(temp,I00,n0);{}
//{    LinAprox(temp2,I00,n0);{}
//    I00:=exp(I00);
//    n0:=1/(Kb*V^.T*n0);
//    {I00 та n0 в результаті лінійної апроксимації залежності
//    ln(I) від напруги, береться ВАХ з врахуванням Rsh0}
//     for i:=0 to High(temp2^.X) do
//       begin
//       temp2^.Y[i]:=exp(temp2^.Y[i]);;
//       end;
//   {в temp2 - частина ВАХ з врахуванням Rsh0, для якої
//   значення струму додатні}
//
//    Diferen (temp2,temp);
//     for i:=0 to High(temp.X) do
//       begin
//       temp^.X[i]:=1/temp2^.Y[i];
//       temp^.Y[i]:=1/temp^.Y[i];
//       end;
//    {в temp - залежність dV/dI від 1/І}
//
//    if temp^.n>5 then
//       begin
//       SetLenVector(temp2,5);
//       for i:=0 to 4 do
//         begin
//             temp2^.X[i]:=temp^.X[High(temp.X)-i];
//             temp2^.Y[i]:=temp^.Y[High(temp.X)-i];
//         end;
//       end
//               else
//           IVchar(temp2,temp);
//
//    LinAprox(temp2,Rs0,temp^.X[0]);
//    {Rs0 - як вільних член лінійної апроксимації
//    щонайбільше п'яти останніх точок залежності dV/dI від 1/І;
//   dV/dI= (nKbT)/(qI)+Rs;
//    temp^.X[0] використане лише для того, щоб
//    не вводити допоміжну змінну}
//    if (mode=2)or(mode=3) then Rs:=1e-4;
//
//    dispose(temp2);
//    dispose(temp);
//   end;
//
//
//       Procedure VuhDatAprox (var n0,Rs0,Rsh0,Isc0,Voc0:double);overload;
//  {по значенням в V визначає початкове наближення
//  для n,Rs,I0,Rsh}
//  var temp,temp2:Pvector;
//      i:integer;
//   begin
//    Isc0:=IscCalc(V);
//    Voc0:=VocCalc(V);
//    if (Isc0<=0) or (Voc0<=0) then Exit;
//    new(temp);
//    Diferen (V,temp);
// {        for I := 0 to High(temp^.X) do
//     temp^.Y[i]:=temp^.X[i]/2.5-(3.33e3*(2.5*6.4e-5+2.5*5.6e-7+temp^.X[i])/2.5/(2.5+3.33e3))+
//                 1.85*Kb*294.1/2.5*
//                 Lambert(2.5*5.6e-7*3.33e3/(2.5+3.33e3)/1.85/Kb/294.1*
//                  exp((3.33e3*(2.5*6.4e-5+2.5*5.6e-7+temp^.X[i]))/1.85/Kb/294.1/(3.33e3+2.5)));
//    Write_File('ff.dat',temp);
//      Diferen (V,temp);}
//  {фактично, в temp залеженість оберненого опору від напруги}
//    Rsh0:=(temp^.X[1]/temp^.y[2]-temp^.X[2]/temp^.y[1])/(temp^.X[1]-temp^.X[2]);
//  {Rsh0 - по початковим двом значенням опору проводиться пряма і визначається очікуване
//      значення при нульовій напрузі}
//   if (mode=1)or(mode=3) then Rsh0:=1e12;
//
//    for I := 0 to High(temp^.X) do
//      begin
//      temp^.Y[i]:=1/temp^.Y[i];
//      temp^.X[i]:=Kb*V^.T/(Isc0+V^.Y[i]-V^.X[i]/Rsh0);
//      end;
//    new(temp2);
//    if temp^.n>7 then
//       begin
//       SetLenVector(temp2,7);
//       for i:=0 to 6 do
//         begin
//             temp2^.X[i]:=temp^.X[High(temp.X)-i];
//             temp2^.Y[i]:=temp^.Y[High(temp.X)-i];
//         end;
//       end
//               else
//          IVchar(temp2,temp);
//    LinAprox(temp2,Rs0,n0);
//    {n та Rs0 - як нахил та вільних член лінійної апроксимації
//    щонайбільше семи останніх точок залежності
//    dV/dI від kT/q(Isc+I-V/Rsh);}
//    if (mode=2)or(mode=3) then Rs0:=1e-4;
//    dispose(temp2);
//    dispose(temp);
//   end; //  VuhDatAprox
//
//
//begin
//ErStr:='';
//I0:=555;
//n:=555;
//Rs:=555;
//Rsh:=555;
//if V^.n<7 then Exit;
//
//// i:=4;
// i:=7;
////i:=5;
// {бо чотири змінних - n,Rs,I0,Rsh}
//SetLength(X,i);
//SetLength(X2,i);
//SetLength(F,i);
//
////Npar:=4;
//Npar:=3;
////Npar:=5;
//
////showmessage('kkk');
//
////VuhDatExpLightmAprox (X[0],X[1],X[2],X[3],X[4]);
//VuhDatAprox (X[0],X[1],X[2],X[3],X[4]);
////VuhDatLamAprox (X[0],X[1],X[2],X[3]);
//if (mode=1)or(mode=3) then X[3]:=1e12;
//if (mode=2)or(mode=3) then X[1]:=1e-4;
//
//
//  //--------------------------------------------------------//
// if not(ParamCorect(V,X[0],X[1],X[2],X[3],X[4])) then Exit;
//
//// if not(ParamCorect(V,ExpParamIsBad,X[0],X[1],X[2],X[3])) then Exit;
//// if not(ParamCorect(V,LamParamIsBad,X[0],X[1],X[2],X[3])) then Exit;
//// if not(LamParamCorect(V,X[0],X[1],X[2],X[3])) then Exit;
//
//{  for I := 0 to High(X1) do X1[i]:=Vari[i];}
//
//{X1[0]:=1000*1.85;X1[1]:=2.5;X1[2]:=5.6e-7;X1[3]:=3.33e3;}
//
//  Nit:=0;
//
//{
//  FG_LamShot(V,X,Sum);
//  showmessage(floattostrf(X[0],ffExponent,4,3)+#10+
//            floattostrf(X[1],ffExponent,4,3)+#10+
//            floattostrf(X[2],ffExponent,4,3)+#10+
//            floattostrf(X[3],ffExponent,4,3)+#10+
//            'S='+floattostr(Sum));{}
//sum2:=1;
//repeat
//{ if ((Nit mod 1)=0) then
//
//showmessage(floattostrf(X[0],ffExponent,4,3)+#10+
//            floattostrf(X[1],ffExponent,4,3)+#10+
//            floattostrf(X[2],ffExponent,4,3)+#10+
//            floattostrf(X[3],ffExponent,4,3)+#10+
//            floattostrf(X[4],ffExponent,4,3)+#10+
//            'S='+floattostr(Sum)+#10+
//            'Nit= '+inttostr(Nit)
//            +str);{}
//
//if Nit<1 then
////       if (FG_LamShot(V,X,F,Sum)<>0)
//       if (FG_LamLightShot(V,X[0],X[1],X[2],X[3],X[4],F,Sum)<>0)
////       if (FG_ExpShot(V,X,F,Sum)<>0)
////       if (FG_ExpLightShot(V,X,F,Sum)<>0)
//        then
//          begin
//           ErStr:='Error in function';
//           Exit;
//          end;
//
// for I := 0 to Npar-1 do str:=str+#10+'F='+floattostrf(F[i],ffExponent,4,3);
//   if ((Nit mod 100)=0) then
//{} showmessage(floattostrf(X[0],ffExponent,4,3)+#10+
//            floattostrf(X[1],ffExponent,4,3)+#10+
//            floattostrf(X[2],ffExponent,4,3)+#10+
//            floattostrf(X[3],ffExponent,4,3)+#10+
//            floattostrf(X[4],ffExponent,4,3)+#10+
//            'S='+floattostr(Sum)+#10+
//            'Nit= '+inttostr(Nit)
//            +str);
//{ }
//
//bool:=true;
//if not(odd(Nit)) then for I := 0 to Npar-1 do X2[i]:=X[i];
// str:='';
//if not(odd(Nit)) or (Nit=0) then sum2:=sum;
//
//for I := 0 to Npar-1 do
//   begin
//       if ((mode=1)or(mode=3))and(i=3) then Continue;
//       if ((mode=2)or(mode=3))and(i=1) then Continue;
//       if F[i]=0 then Continue;
//       if abs(X[i]/100/F[i])>1e30 then Continue;
//       al:=Secant(i,0,0.1*abs(X[i]/F[i]),F[i]);
////       if abs(al*F[i])>abs(0.1*X[i]) then al:=abs(0.1*X[i]/F[i]);
//
////       al:=Secant(i,0,0.1*abs(X[i]/F[i]),F[i],X[0],X[1],X[2],X[3]);
//      X[i]:=X[i]-al*F[i];
// {     showmessage('al='+floattostr(al)+#10+
//                  'F[i]='+floattostr(F[i])+#10+
//                  'X[i]='+floattostr(X[i]));
//  {}
//      if not(ParamCorect(V,X[0],X[1],X[2],X[3],X[4])) then Exit;
//
////      if not(ParamCorect(V,ExpParamIsBad,X[0],X[1],X[2],X[3])) then  Exit;
////      if not(ParamCorect(V,LamParamIsBad,X[0],X[1],X[2],X[3])) then  Exit;
////      if not(LamParamCorect(V,X[0],X[1],X[2],X[3])) then  Exit;
// //       showmessage('kkk');
//
//       bool:=(bool)and(abs((X2[i]-X[i])/X[i])<eps);
//      str:=str+#10+ 'i='+inttostr(i);
//      str:=str+#10+ floattostr(X[i]);
//      str:=str+#10+ floattostr(X2[i]);
//    if (FG_LamLightShot(V,X[0],X[1],X[2],X[3],X[4],F,Sum)<>0)  then Exit;
//  {     showmessage(floattostrf(X[0],ffExponent,4,3)+#10+
//            floattostrf(X[1],ffExponent,4,3)+#10+
//            floattostrf(X[2],ffExponent,4,3)+#10+
//            floattostrf(X[3],ffExponent,4,3)+#10+
//            floattostrf(X[4],ffExponent,4,3)+#10+
//            'S='+floattostr(Sum)+#10+
//            'Nit= '+inttostr(Nit)
//            +str);}
////      if (FG_ExpLightShot(V,X,F,Sum)<>0)   then Exit;
////      if (FG_ExpShot(V,X,F,Sum)<>0)   then Exit;
////      if (FG_LamShot(V,X,F,Sum)<>0)   then Exit;
//   end;
//
//  Inc(Nit);
////until bool or (Nit>Nmax);
//until bool or (abs((sum2-sum)/sum)<eps) or (Nit>Nmax);
//
//{}     n:=X[0];
//       Rs:=X[1];
//       I0:=X[2];
//       Rsh:=X[3];
//       Iph:=X[4];{}
//
// if Nit>Nmax then
//     ErStr:='The number of iterations is too much'
//             else
//     begin
//{ }      n:=X[0];
//       Rs:=X[1];
//       I0:=X[2];
//       Rsh:=X[3];{}
//       ErStr:='';
//     end;
//showmessage('n='+floattostrf(n,ffExponent,4,3)+#10+
//            'I0='+floattostrf(I0,ffExponent,4,3)+#10+
//            'Iph='+floattostrf(Iph,ffExponent,4,3)+#10+
//            'Rs='+floattostrf(Rs,ffExponent,4,3)+#10+
//            'Rsh='+floattostrf(Rsh,ffExponent,4,3));
//
//end;


{Procedure Aprox (Func0:byte;V:PVector; mode0:byte; var n0,Rs0,I00,Rsh0:double);overload;
апроксимуються дані у векторі V
залежністю I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh
за методом найменших квадратів зі
статистичними ваговими коефіцієнтами;

Func0 - функція, яка використовується
для апроксимації:
Func0 = 0 - безпосередньо виразом
          I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh;
Func0 = 1 - використовується функція Ламберта;

mode0 - режим апроксимації:
mode0 = 0 - всі чотири параметри підбираються;
mode0 = 1 - вважається, що Rsh нескінченність (1е12);
mode0 = 2 - вважається, що Rs нульовий(1е-4)
mode0 = 3 - Rsh нескінченність + Rs нульовий
}

{begin
I00:=555;
n0:=555;
Rs0:=555;
Rsh0:=555;
mode:=mode0;
Func:=Func0;
new(Vec);
IVchar(V,Vec);

case mode of
  0:begin
      Approx.Label2.Visible:=true;
      Approx.Label8.Visible:=true;
      Approx.Label3.Visible:=true;
      Approx.Label9.Visible:=true;
    end;
  1:begin
      Approx.Label2.Visible:=true;
      Approx.Label8.Visible:=true;
      Approx.Label3.Visible:=false;
      Approx.Label9.Visible:=false;
     end;
  2:begin
      Approx.Label2.Visible:=false;
      Approx.Label8.Visible:=false;
      Approx.Label3.Visible:=true;
      Approx.Label9.Visible:=true;
     end;
  3:begin
      Approx.Label2.Visible:=false;
      Approx.Label8.Visible:=false;
      Approx.Label3.Visible:=false;
      Approx.Label9.Visible:=false;
    end;
   end;//case

case Func0 of
   1:Approx.Caption:='Lambert Aproximation';
   0:Approx.Caption:='Direct Aproximation';
end;

Approx.Label6.Visible:=True;
Approx.Ln.Visible:=True;
Approx.Label12.Visible:=False;
Approx.Label13.Visible:=False;

thread:=Apr.Create(true);
thread.FreeOnTerminate:=true;
thread.Priority:=tpNormal; // tpHigher;//tpHighest
thread.Resume;
if Approx.ShowModal=mrOk then
          begin
          thread.Terminate;
          WaitForSingleObject(thread.event, INFINITE);
          end;
dispose(Vec);
I00:=I0;
n0:=n;
Rs0:=Rs;
Rsh0:=Rsh;
end;{}
//---------------------------------------------------------------
//Procedure Aprox (Func0:byte; V:PVector; mode0:byte; var n0,Rs0,I00,Rsh0,Isc0,Voc0,Iph0:double);
//{апроксимуються ВАХ при освітленні у векторі V
//залежністю I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
//за методом найменших квадратів зі
//статистичними ваговими коефіцієнтами
//
//Func0 = 0 - безпосередньо виразом
//          I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh;
//Func0 = 1 - використовується функція Ламберта;
//Func0 = 3 - безпосередньо виразом
//          I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph;
//Func0 = 4 - використовується функція Ламберта;
//
//mode0 - режим апроксимації:
//mode0 = 0 - всі параметри підбираються;
//mode0 = 1 - вважається, що Rsh нескінченність (1е12);
//mode0 = 1 - вважається, що Rs нульовий(1е-4)
//mode0 = 3 - Rsh нескінченність + Rs нульовий
//}
//
//var F,X2,X:array of double;
//    i,Npar,Nit,Nmax:integer;
//    bool:boolean;
//    Sum,al,sum2,eps:double;
//
//   Function Secant(num:word;a,b,F:double):double;
//  {обчислюється оптимальне значення параметра al
//  в методі поординатного спуску;
//  використовується метод дихотомії;
//  а та b задають початковий відрізок, де шукається
//  розв'язок}
//  var i:integer;
//      c,Fb,Fa:double;
//  begin
//    Result:=0;
//     case Func0 of
//      1:  Fa:=aSdal_LamShot(V,num,a,F,X[0],X[1],X[2],X[3]);
//      3:  Fa:=aSdal_ExpLightShot(V,num,a,F,X[0],X[1],X[2],X[3],X[4]);
//      4:  Fa:=aSdal_LamLightShot(V,num,a,F,X[0],X[1],X[2],X[3],X[4]);
//      else Fa:=aSdal_ExpShot(V,num,a,F,X[0],X[1],X[2],X[3]);
//     end;
//    if Fa=555 then Exit;
//
//    if Fa=0 then
//               begin
//                  Result:=a;
//                  Exit;
//                end;
//    repeat
//     case Func0 of
//       1:  Fb:=aSdal_LamShot(V,num,b,F,X[0],X[1],X[2],X[3]);
//       3:  Fb:=aSdal_ExpLightShot(V,num,b,F,X[0],X[1],X[2],X[3],X[4]);
//       4:  Fb:=aSdal_LamLightShot(V,num,b,F,X[0],X[1],X[2],X[3],X[4]);
//      else Fb:=aSdal_ExpShot(V,num,b,F,X[0],X[1],X[2],X[3]);
//     end;
//     if Fb=0 then
//                begin
//                  Result:=b;
//                  Exit;
//                end;
//     if Fb=555 then break
//               else
//                 begin
//                 if Fb*Fa<=0 then break
//                            else b:=2*b
//                 end;
//    until false;
//
//     i:=0;
//    repeat
//      inc(i);
//      c:=(a+b)/2;
//     case Func0 of
//       1:begin
//         Fb:=aSdal_LamShot(V,num,c,F,X[0],X[1],X[2],X[3]);
//         Fa:=aSdal_LamShot(V,num,a,F,X[0],X[1],X[2],X[3]);
//         end;
//       3:begin
//         Fb:=aSdal_ExpLightShot(V,num,c,F,X[0],X[1],X[2],X[3],X[4]);
//         Fa:=aSdal_ExpLightShot(V,num,a,F,X[0],X[1],X[2],X[3],X[4]);
//         end;
//       4:begin
//         Fb:=aSdal_LamLightShot(V,num,c,F,X[0],X[1],X[2],X[3],X[4]);
//         Fa:=aSdal_LamLightShot(V,num,a,F,X[0],X[1],X[2],X[3],X[4]);
//         end;
//      else
//         begin
//         Fb:=aSdal_ExpShot(V,num,c,F,X[0],X[1],X[2],X[3]);
//         Fa:=aSdal_ExpShot(V,num,a,F,X[0],X[1],X[2],X[3]);
//         end;
//     end;
//     if (Fb*Fa<=0) or (Fb=555)
//       then b:=c
//       else a:=c;
//     until (i>1e5)or(abs((b-a)/c)<1e-2);
//    if (i>1e5) then Exit;
//    Result:=c;
//  end;
//
// Procedure VuhDatExpLightmAprox (var n0,Rs0,I00,Rsh0,Iph0:double);overload;
//  {по значенням в V визначає початкове наближення
//  для n,Rs,I0,Rsh,Iph}
//  var temp,temp2:Pvector;
//      i,k:integer;
//   begin
//    n0:=555;
//    Rs0:=555;
//    I00:=555;
//    Rsh0:=555;
//    if (VocCalc(V)<=0.002) then Exit;
//    Iph0:=IscCalc(V);
//    if (Iph0<=1e-8) then Exit;
//
//    new(temp2);
//    IVchar(V,temp2);
//     for I := 0 to High(temp2^.X) do
//      temp2^.Y[i]:=temp2^.Y[i]+Iph0;
//
//    new(temp);
//    Diferen (temp2,temp);
//  {фактично, в temp залеженість оберненого опору від напруги}
//    Rsh0:=(temp^.X[1]/temp^.y[2]-temp^.X[2]/temp^.y[1])/(temp^.X[1]-temp^.X[2]);
//  {Rsh0 - по початковим двом значенням опору проводиться пряма і визначається очікуване
//      значення при нульовій напрузі}
//   if (mode=1)or(mode=3) then Rsh0:=1e12;
//
//    for I := 0 to High(temp^.X) do
//      temp^.Y[i]:=(temp2^.Y[i]-temp2^.X[i]/Rsh0);
//    {в temp - ВАХ з врахуванням Rsh0}
//
//    k:=-1;
//    for i:=0 to High(temp^.X) do
//           if Temp^.Y[i]<0 then k:=i;
////    new(temp2);
//
//   if k<0 then IVchar(temp,temp2)
//          else
//           begin
//             SetLenVector(temp2,temp^.n-k-1);
//             for i:=0 to High(temp2^.X) do
//               begin
//                temp2^.Y[i]:=temp^.Y[i+k+1];
//                temp2^.X[i]:=temp^.X[i+k+1];
//               end;
//           end;
//     for i:=0 to High(temp2^.X) do
//       temp2^.Y[i]:=ln(temp2^.Y[i]);
//
//{}    if High(temp2^.X)>6 then
//         begin
//         SetLenVector(temp,High(temp2^.X)-3);
//         for i:=3 to High(temp2^.X) do
//          begin
//           temp^.X[i-3]:=temp2^.X[i];
//           temp^.Y[i-3]:=temp2^.Y[i];
//          end;
//         end;
//    LinAprox(temp,I00,n0);{}
//{    LinAprox(temp2,I00,n0);{}
//    I00:=exp(I00);
//    n0:=1/(Kb*V^.T*n0);
//    {I00 та n0 в результаті лінійної апроксимації залежності
//    ln(I) від напруги, береться ВАХ з врахуванням Rsh0}
//     for i:=0 to High(temp2^.X) do
//       begin
//       temp2^.Y[i]:=exp(temp2^.Y[i]);;
//       end;
//   {в temp2 - частина ВАХ з врахуванням Rsh0, для якої
//   значення струму додатні}
//
//    Diferen (temp2,temp);
//     for i:=0 to High(temp.X) do
//       begin
//       temp^.X[i]:=1/temp2^.Y[i];
//       temp^.Y[i]:=1/temp^.Y[i];
//       end;
//    {в temp - залежність dV/dI від 1/І}
//
//    if temp^.n>5 then
//       begin
//       SetLenVector(temp2,5);
//       for i:=0 to 4 do
//         begin
//             temp2^.X[i]:=temp^.X[High(temp.X)-i];
//             temp2^.Y[i]:=temp^.Y[High(temp.X)-i];
//         end;
//       end
//               else
//           IVchar(temp2,temp);
//
//    LinAprox(temp2,Rs0,temp^.X[0]);
//    {Rs0 - як вільних член лінійної апроксимації
//    щонайбільше п'яти останніх точок залежності dV/dI від 1/І;
//   dV/dI= (nKbT)/(qI)+Rs;
//    temp^.X[0] використане лише для того, щоб
//    не вводити допоміжну змінну}
//    if (mode=2)or(mode=3) then Rs:=1e-4;
//
//    dispose(temp2);
//    dispose(temp);
//   end;
//
//
//    Procedure VuhDatAprox (var n0,Rs0,I00,Rsh0:double);overload;
//  {по значенням в V визначає початкове наближення
//  для n,Rs,I0,Rsh}
//  var temp,temp2:Pvector;
//      i,k:integer;
//   begin
//    n0:=555;
//    Rs0:=555;
//    I00:=555;
//    Rsh0:=555;
//    new(temp);
//    Diferen (V,temp);
//  {фактично, в temp залеженість оберненого опору від напруги}
//    Rsh0:=(temp^.X[1]/temp^.y[2]-temp^.X[2]/temp^.y[1])/(temp^.X[1]-temp^.X[2]);
//  {Rsh0 - по початковим двом значенням опору проводиться пряма і визначається очікуване
//      значення при нульовій напрузі}
//   if (mode=1)or(mode=3) then Rsh0:=1e12;
//
//    for I := 0 to High(temp^.X) do
//      temp^.Y[i]:=(V^.Y[i]-V^.X[i]/Rsh0);
//    {в temp - ВАХ з врахуванням Rsh0}
//    k:=-1;
//    for i:=0 to High(temp^.X) do
//           if Temp^.Y[i]<0 then k:=i;
//    new(temp2);
//
//   if k<0 then IVchar(temp,temp2)
//          else
//           begin
//             SetLenVector(temp2,temp^.n-k-1);
//             for i:=0 to High(temp2^.X) do
//               begin
//                temp2^.Y[i]:=temp^.Y[i+k+1];
//                temp2^.X[i]:=temp^.X[i+k+1];
//               end;
//           end;
//     for i:=0 to High(temp2^.X) do
//       temp2^.Y[i]:=ln(temp2^.Y[i]);
//
//{}    if High(temp2^.X)>6 then
//         begin
//         SetLenVector(temp,High(temp2^.X)-3);
//         for i:=3 to High(temp2^.X) do
//          begin
//           temp^.X[i-3]:=temp2^.X[i];
//           temp^.Y[i-3]:=temp2^.Y[i];
//          end;
//         end;
//    LinAprox(temp,I00,n0);{}
//    I00:=exp(I00);
//    n0:=1/(Kb*V^.T*n0);
//    {I00 та n0 в результаті лінійної апроксимації залежності
//    ln(I) від напруги, береться ВАХ з врахуванням Rsh0}
//     for i:=0 to High(temp2^.X) do
//       begin
//       temp2^.Y[i]:=exp(temp2^.Y[i]);;
//       end;
//   {в temp2 - частина ВАХ з врахуванням Rsh0, для якої
//   значення струму додатні}
//
//    Diferen (temp2,temp);
//     for i:=0 to High(temp.X) do
//       begin
//       temp^.X[i]:=1/temp2^.Y[i];
//       temp^.Y[i]:=1/temp^.Y[i];
//       end;
//    {в temp - залежність dV/dI від 1/І}
//
//    if temp^.n>5 then
//       begin
//       SetLenVector(temp2,5);
//       for i:=0 to 4 do
//         begin
//             temp2^.X[i]:=temp^.X[High(temp.X)-i];
//             temp2^.Y[i]:=temp^.Y[High(temp.X)-i];
//         end;
//       end
//               else
//           IVchar(temp2,temp);
//
//    LinAprox(temp2,Rs0,temp^.X[0]);
//    {Rs0 - як вільних член лінійної апроксимації
//    щонайбільше п'яти останніх точок залежності dV/dI від 1/І;
//   dV/dI= (nKbT)/(qI)+Rs;
//    temp^.X[0] використане лише для того, щоб
//    не вводити допоміжну змінну}
//    if (mode=2)or(mode=3) then Rs0:=1e-4;
//
//    dispose(temp2);
//    dispose(temp);
//   end; //  VuhDatAprox
//
//    Procedure VuhDatAprox (var n0,Rs0,Rsh0,Isc0,Voc0:double);overload;
//  {по значенням в V визначає початкове наближення
//  для n,Rs,I0,Rsh}
//  var temp,temp2:Pvector;
//      i:integer;
//   begin
//    n0:=555;
//    Rsh0:=555;
//    Rs:=555;
//    Isc0:=IscCalc(V);
//    Voc0:=VocCalc(V);
//    if (Voc0<=0.002)or(Isc0<1e-8) then Exit;
//    new(temp);
//    Diferen (V,temp);
//  {фактично, в temp залеженість оберненого опору від напруги}
//    Rsh0:=(temp^.X[1]/temp^.y[2]-temp^.X[2]/temp^.y[1])/(temp^.X[1]-temp^.X[2]);
//  {Rsh0 - по початковим двом значенням опору проводиться пряма і визначається очікуване
//      значення при нульовій напрузі}
//   if (mode=1)or(mode=3) then Rsh0:=1e12;
//
//    for I := 0 to High(temp^.X) do
//      begin
//      temp^.Y[i]:=1/temp^.Y[i];
//      temp^.X[i]:=Kb*V^.T/(Isc0+V^.Y[i]-V^.X[i]/Rsh0);
//      end;
//    new(temp2);
//    if temp^.n>7 then
//       begin
//       SetLenVector(temp2,7);
//       for i:=0 to 6 do
//         begin
//             temp2^.X[i]:=temp^.X[High(temp.X)-i];
//             temp2^.Y[i]:=temp^.Y[High(temp.X)-i];
//         end;
//       end
//               else
//          IVchar(temp2,temp);
//    LinAprox(temp2,Rs0,n0);
//    {n та Rs0 - як нахил та вільних член лінійної апроксимації
//    щонайбільше семи останніх точок залежності
//    dV/dI від kT/q(Isc+I-V/Rsh);}
//    if (mode=2)or(mode=3) then Rs0:=1e-4;
//    dispose(temp2);
//    dispose(temp);
//   end; //  VuhDatAprox
//
//
//begin
//I00:=555;
//n0:=555;
//Rs0:=555;
//Rsh0:=555;
//Isc0:=555;
//Voc0:=555;
//Iph0:=555;
//{mode:=mode0;
//Func:=Func0;}
//{new(Vec);
//IVchar(V,Vec);}
//if (Func0=0) or (Func0=1) then
//  begin
//  Isc0:=0;
//  Voc0:=0;
//  Iph0:=0;
//  end;
//
//case mode of
//  0:begin
//      Approx.Label2.Visible:=true;
//      Approx.Label8.Visible:=true;
//      Approx.Label3.Visible:=true;
//      Approx.Label9.Visible:=true;
//    end;
//  1:begin
//      Approx.Label2.Visible:=true;
//      Approx.Label8.Visible:=true;
//      Approx.Label3.Visible:=false;
//      Approx.Label9.Visible:=false;
//     end;
//  2:begin
//      Approx.Label2.Visible:=false;
//      Approx.Label8.Visible:=false;
//      Approx.Label3.Visible:=true;
//      Approx.Label9.Visible:=true;
//     end;
//  3:begin
//      Approx.Label2.Visible:=false;
//      Approx.Label8.Visible:=false;
//      Approx.Label3.Visible:=false;
//      Approx.Label9.Visible:=false;
//    end;
//   end;//case
//
//
//case Func0 of
//   1:
//     begin
//     Approx.Caption:='Lambert Aproximation';
//     Approx.Label6.Visible:=True;
//     Approx.Ln.Visible:=True;
//     Approx.Label12.Visible:=False;
//     Approx.Label13.Visible:=False;
//     end;
//   0:
//     begin
//     Approx.Caption:='Direct Aproximation';
//     Approx.Label6.Visible:=True;
//     Approx.Ln.Visible:=True;
//     Approx.Label12.Visible:=False;
//     Approx.Label13.Visible:=False;
//     end;
//   3:
//     begin
//     Approx.Caption:='Direct Aproximation of Illuminated I-V';
//     Approx.Label12.Visible:=True;
//     Approx.Label13.Visible:=True;
//     Approx.Label6.Visible:=True;
//     Approx.Ln.Visible:=True;
//     end;
//   4:
//     begin
//     Approx.Caption:='Lambert Aproximation of Illuminated I-V';
//     Approx.Label12.Visible:=False;
//     Approx.Label13.Visible:=False;
//     Approx.Label6.Visible:=False;
//     Approx.Ln.Visible:=False;
//     end;
//end;
//
//
//case Func0 of
// 1:begin  //функція Ламберта
//    eps:=5e-7;
//    Nmax:=10000;
//   end;
// 3:begin  //ВАХ освітленої структури
//    eps:=8e-8;
//    Nmax:=20000;
//   end;
// 4:begin  //ВАХ освітленої структури Ламбертом
//    eps:=1e-7;
//    Nmax:=10000;
//   end;
// else begin   //за умовчанням - безпосередньо експонентою
//       eps:=1e-8;
//       Nmax:=20000;
//       end;
// end;   //case Func0 of
//
//Approx.Label4.Caption:=inttostr(Nmax);
//
//if V^.n<7 then  Exit;
//
//
// case Func0 of
//     3:i:=5; {змінні - n,Rs,Rsh,I0,Iph}
//     4:i:=7; {змінні - n,Rs,Rsh,I0,Isc,Voc,Iph}
//  else i:=4; {змінні - n,Rs,I0,Rsh}
// end;
//
//SetLength(X,i);
//SetLength(X2,i);
//SetLength(F,i);
//
// case Func0 of
//     3:Npar:=5; {варьються n,Rs,I0,Rsh,Iph}
//     4:Npar:=3; {варьються n,Rs,Rsh}
//  else Npar:=4; {варьються n,Rs,I0,Rsh}
// end;
//
//
// case Func0 of
//    3:  VuhDatExpLightmAprox (X[0],X[1],X[2],X[3],X[4]);
//    4:  VuhDatAprox (X[0],X[1],X[2],X[3],X[4]);
//   else VuhDatAprox (X[0],X[1],X[2],X[3]);
// end;
//
// if X[0]=555 then Exit;
//
////????????????????????
//if (mode0=1)or(mode0=3) then X[3]:=1e12;
//if (mode0=2)or(mode0=3) then X[1]:=1e-4;
// case Func0 of
//    1:  if not(ParamCorect(V,LamParamIsBad,X[0],X[1],X[2],X[3])) then Exit;
//    4:  if not(ParamCorect(V,X[0],X[1],X[2],X[3],X[4])) then Exit;
//   else if not(ParamCorect(V,ExpParamIsBad,X[0],X[1],X[2],X[3])) then Exit;
// end;
//
//
// Nit:=0;
// sum2:=1;
//Approx.Show;
//repeat
// if Nit<1 then
//     case Func0 of
//        1:  if (FG_LamShot(V,X,F,Sum)<>0)  then Exit;
//        3:  if (FG_ExpLightShot(V,X,F,Sum)<>0)  then Exit;
//        4:  if (FG_LamLightShot(V,X[0],X[1],X[2],X[3],X[4],F,Sum)<>0) then Exit;
//       else if (FG_ExpShot(V,X,F,Sum)<>0)  then Exit;
//     end;
//
//  bool:=true;
//  if not(odd(Nit)) then for I := 0 to Npar-1 do X2[i]:=X[i];
//  if not(odd(Nit))or (Nit=0) then sum2:=sum;
//
//
//
//  for I := 0 to Npar-1 do
//     begin
//       if ((mode0=1)or(mode0=3))and(i=3) then Continue;
//       if ((mode0=2)or(mode0=3))and(i=1) then Continue;
//       if F[i]=0 then Continue;
//       if abs(X[i]/100/F[i])>1e30 then Continue;
//      //  showmessage('kk');
//       al:=Secant(i,0,0.1*abs(X[i]/F[i]),F[i]);
//       X[i]:=X[i]-al*F[i];
//       case Func0 of
//          1:  if not(ParamCorect(V,LamParamIsBad,X[0],X[1],X[2],X[3])) then Exit;
//          4:  if not(ParamCorect(V,X[0],X[1],X[2],X[3],X[4])) then Exit;
//         else if not(ParamCorect(V,ExpParamIsBad,X[0],X[1],X[2],X[3])) then Exit;
//       end;
//       bool:=(bool)and(abs((X2[i]-X[i])/X[i])<eps);
//       case Func0 of
//          1:  if (FG_LamShot(V,X,F,Sum)<>0) then Exit;
//          3:  if (FG_ExpLightShot(V,X,F,Sum)<>0)  then Exit;
//          4:  if (FG_LamLightShot(V,X[0],X[1],X[2],X[3],X[4],F,Sum)<>0)  then Exit;
//         else if (FG_ExpShot(V,X,F,Sum)<>0) then Exit;
//       end;
//     end;
//
//  if (Nit mod 25)=0 then
//     begin
//        Approx.Label5.Caption:=Inttostr(Nit);
//        Approx.Label7.Caption:=floattostrf(X[0],ffExponent,4,3);
//        Approx.Label8.Caption:=floattostrf(X[1],ffExponent,4,3);
//        case Func0 of
//           0,1:
//              begin
//              Approx.Label6.Caption:=floattostrf(X[2],ffExponent,4,3);
//              Approx.Label9.Caption:=floattostrf(X[3],ffExponent,4,3);
//              end;
//            3:
//              begin
//              Approx.Label6.Caption:=floattostrf(X[2],ffExponent,4,3);
//              Approx.Label9.Caption:=floattostrf(X[3],ffExponent,4,3);
//              Approx.Label13.Caption:=floattostrf(X[4],ffExponent,4,3);
//              end;
//            4:Approx.Label9.Caption:=floattostrf(X[2],ffExponent,4,3);
//           end;
//         Application.ProcessMessages;
//     end;
//  Inc(Nit);
//until (abs((sum2-sum)/sum)<eps) or bool or (Nit>Nmax) or not(Approx.Visible);
//
//
//if Approx.Visible then
//    case Func0 of
//      4:
//        begin
//        n0:=X[0];
//        Rs0:=X[1];
//        I00:=(X[3]+(X[1]*X[3]-X[4])/X[2])*exp(-X[4]/X[0]/Kb/V^.T)/
//                       (1-exp((X[1]*X[3]-X[4])/X[0]/Kb/V^.T));
//        Rsh0:=X[2];
//        Iph0:=I00*(exp(X[4]/X[0]/Kb/V^.T)-1)+X[4]/X[2];
//        Voc0:=Voc_Isc_Pm(1,V,n0,Rs0,I00,Rsh0,Iph0);
//        Isc0:=Voc_Isc_Pm(2,V,n0,Rs0,I00,Rsh0,Iph0);
//        end;
//      3:
//        begin
//        n0:=X[0];
//        Rs0:=X[1];
//        I00:=X[2];
//        Rsh0:=X[3];
//        Iph0:=X[4];
//        Voc0:=Voc_Isc_Pm(1,V,n0,Rs0,I00,Rsh0,Iph0);
//        Isc0:=Voc_Isc_Pm(2,V,n0,Rs0,I00,Rsh0,Iph0);
//        end;
//      else
//        begin
//        n0:=X[0];
//        Rs0:=X[1];
//        I00:=X[2];
//        Rsh0:=X[3];
//        end;
//    end;
//Approx.Close;
////Visible:=False;
//end;

//----------------------------------------------------------------

{Procedure Aprox (Func0:byte; V:PVector; mode0:byte; var n0,Rs0,I00,Rsh0,Isc0,Voc0,Iph0:double);overload;
{апроксимуються ВАХ при освітленні у векторі V
залежністю I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
за методом найменших квадратів зі
статистичними ваговими коефіцієнтами
з використанням функції Ламберта;

Func0 = 3 - безпосередньо виразом
          I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph;
Func0 = 4 - використовується функція Ламберта;

mode0 - режим апроксимації:
mode0 = 0 - всі параметри підбираються;
mode0 = 1 - вважається, що Rsh нескінченність (1е12);
mode0 = 1 - вважається, що Rs нульовий(1е-4)
mode0 = 3 - Rsh нескінченність + Rs нульовий
}
{begin
I00:=555;
n0:=555;
Rs0:=555;
Rsh0:=555;
Isc0:=555;
Voc0:=555;
Iph0:=555;
mode:=mode0;
Func:=Func0;
new(Vec);
IVchar(V,Vec);

case mode of
  0:begin
      Approx.Label2.Visible:=true;
      Approx.Label8.Visible:=true;
      Approx.Label3.Visible:=true;
      Approx.Label9.Visible:=true;
    end;
  1:begin
      Approx.Label2.Visible:=true;
      Approx.Label8.Visible:=true;
      Approx.Label3.Visible:=false;
      Approx.Label9.Visible:=false;
     end;
  2:begin
      Approx.Label2.Visible:=false;
      Approx.Label8.Visible:=false;
      Approx.Label3.Visible:=true;
      Approx.Label9.Visible:=true;
     end;
  3:begin
      Approx.Label2.Visible:=false;
      Approx.Label8.Visible:=false;
      Approx.Label3.Visible:=false;
      Approx.Label9.Visible:=false;
    end;
   end;//case

case Func0 of
   3:
     begin
     Approx.Caption:='Direct Aproximation of Illuminated I-V';
     Approx.Label12.Visible:=True;
     Approx.Label13.Visible:=True;
     Approx.Label6.Visible:=True;
     Approx.Ln.Visible:=True;
     end;
   4:
     begin
     Approx.Caption:='Lambert Aproximation of Illuminated I-V';
     Approx.Label12.Visible:=False;
     Approx.Label13.Visible:=False;
     Approx.Label6.Visible:=False;
     Approx.Ln.Visible:=False;
     end;
end;  //case

thread:=Apr.Create(true);
thread.FreeOnTerminate:=true;
thread.Priority:=tpNormal; // tpHigher;//tpHighest
thread.Resume;
if Approx.ShowModal=mrOk then
          begin
          thread.Terminate;
          WaitForSingleObject(thread.event, INFINITE);
          end;
dispose(Vec);
I00:=I0;
n0:=n;
Rs0:=Rs;
Rsh0:=Rsh;
Isc0:=Isc;
Voc0:=Voc;
Iph0:=Iph;

end;}

Function Voc_Isc_Pm(mode:byte;Vec:PVector;n,Rs,I0,Rsh,Iph:double):double;
{обчислюється Voc (при mode=1),
Isc (при mode=2) чи максимальну
вихідну потужність (при mode=3) по відомим значеннм
n, Rs, I0, Rsh, Iph для значень в Vec.
Використовується метод дихотомії
для розв'язку рівняння
I0*[exp(qVoc/nkT)-1]+Voc/Rsh-Iph=0
або
I0*[exp(qRsIsc/nkT)-1]+RsIsc/Rsh-Iph+Isc=0.
FF обчислюється на основі апроксимації ВАХ
функцією Ламберта
I=V/Rs-Rsh(RsIph+RsI0+V)/Rs/(Rs+Rsh)+
  nkT/q/Rs*Lambert(qRsI0Rsh/((Rs+Rsh)nkT)exp(Rsh(RsIph+RsI0+V)/(nkT(Rs+Rsh)))
a саме, методом дихотомії знаходиться екстремум функції Pm=I*V
і обчислюється саме екстремальне значення
}
 Function F_Voc(v:double):double;
   begin
    Result:=I0*(exp(v/n/Kb/Vec^.T)-1)+v/Rsh-Iph;
   end;

 Function F_Isc(i:double):double;
   begin
    Result:=I0*(exp(Rs*i/n/Kb/Vec^.T)-1)+i*Rs/Rsh-Iph+i;
   end;

 Function Pm(V:double):double;
   begin
    Result:=V*(V/Rs-Rsh*(Rs*Iph+Rs*I0+V)/Rs/(Rs+Rsh)+
    n*Kb*Vec^.T/Rs*Lambert(Rs*I0*Rsh/((Rs+Rsh)*n*Kb*Vec^.T)*
     exp(Rsh*(Rs*Iph+Rs*I0+V)/(n*Kb*Vec^.T*(Rs+Rsh)))));
   end;

 Function PmPoh(V:double):double;
  var Yi:double;
   begin

   Yi:=Lambert(Rs*I0*Rsh/((Rs+Rsh)*n*Kb*Vec^.T)*
     exp(Rsh*(Rs*Iph+Rs*I0+V)/(n*Kb*Vec^.T*(Rs+Rsh))));
    Result:=V/Rs-Rsh*(Rs*Iph+Rs*I0+V)/Rs/(Rs+Rsh)+
    n*Kb*Vec^.T/Rs*Yi+V/Rs*(1-Rsh/(Rs+Rsh)*(1-Yi/(1+Yi)));
   end;

  var i:integer;
      a,b,temp,c,Fb,Fa,min:double;
      md:byte;
      bool:boolean;
  begin

 Result:=555;
 if Vec^.T<=0 then Exit;
 if (Iph<=0) or (Iph=555) then Exit;
 if (I0<=0) or (I0=555) then Exit;
 if (n<=0) or (n=555) then Exit;
 if (Rs<0) or (Rs=555) then Exit;
 if (Rsh<=0) or (Rsh=555) then Exit;
 if mode<1 then Exit;
 if mode>3 then Exit;

// if Rs=0 then Rs:=1e-4;
 


 case mode of
  1:begin
      temp:=VocCalc(Vec);
      if temp=0 then temp:=0.01;
      a:=temp;
      b:=temp;
      repeat
       a:=a-0.1*abs(temp);
       b:=b+0.1*abs(temp);
       Fa:=F_Voc(a);
       Fb:=F_Voc(b);
      until Fb*Fa<=0;
    end;
   3:begin
      if Rs=0 then Rs:=1e-4;
      a:=0;
      b:=VocCalc(Vec);
      if b=0 then b:=0.1;
      Fa:=PmPoh(a);
      Fb:=PmPoh(b);
     end;
  else
    begin
      temp:=IscCalc(Vec);
      if temp=0 then temp:=1e-6;
      a:=temp;
      b:=temp;
      repeat
       a:=a-0.1*abs(temp);
       b:=b+0.1*abs(temp);
       Fa:=F_Isc(a);
       Fb:=F_Isc(b);
      until Fb*Fa<=0;
    end;
 end;

     i:=0;
  repeat
      inc(i);
      c:=(a+b)/2;
     case mode of
       1:begin
         Fb:=F_Voc(c);
         Fa:=F_Voc(a);
         end;
       2:begin
         Fb:=F_Isc(c);
         Fa:=F_Isc(a);
         end;
       3:begin
         Fb:=PmPoh(c);
         Fa:=PmPoh(a);
         end;
     end;
     if (Fb*Fa<=0)
       then b:=c
       else a:=c;

   if abs(a)<abs(b) then min:=abs(a)
                    else min:=abs(b);
   md:=0;
   if a=0 then md:=1;
   if b=0 then md:=2;
   if (a=0) and (b=0) then md:=3;
   case md of
      1:bool:=abs((b-a)/b)<1e-4;
      2:bool:=abs((b-a)/a)<1e-4;
      3:bool:=true;
    else bool:=abs((b-a)/min)<1e-4;
   end;

     until (i>1e5)or bool;
    if (i>1e5) then Exit;

    if mode=3 then Result:=abs(Pm(c))
              else Result:=c;
end;


Function Voc_Isc_Pm_DoubleDiod(mode:byte;E1,E2,Rs,I01,I02,Rsh,Iph:double):double;
{обчислюється Voc (при mode=1),
Isc (при mode=2) чи максимальну
вихідну потужність (при mode=3) по відомим значенням
Е1, Е2, Rs, I01, I02, Rsh, Iph, вважаючи, що  ВАХ
має описуватися двома експонентами.
Використовується метод дихотомії
для розв'язку рівняння
I01*[exp(qVoc/Е1)-1]+I02*[exp(qVoc/Е2)-1]+Voc/Rsh-Iph=0
}

 Function F_Voc(v:double):double;
   begin
    Result:=I01*(exp(v/E1)-1)+I02*(exp(v/E2)-1)+v/Rsh-Iph;
   end;

  var i:integer;
      a,b,temp,c,Fb,Fa,min:double;
      md:byte;
      bool:boolean;
  begin

 Result:=555;
 if (E1<=0)or(E2<=0) then Exit;
 if (Iph<=0) or (Iph=555) then Exit;
 if (I01<=0) or (I01=555) then Exit;
 if (I02<=0) or (I02=555) then Exit;
 if (Rs<0) or (Rs=555) then Exit;
 if (Rsh<=0) or (Rsh=555) then Exit;
 if mode<1 then Exit;
 if mode>3 then Exit;

if mode=2 then
  begin
    Result:=abs(Full_IV_2Exp(0,E1,E2,Rs,I01,I02,Rsh,Iph));
    Exit;
  end;

if mode=1 then
  begin
    temp:=0.1;
    a:=temp;
    b:=temp;

    repeat
     a:=a-0.1*abs(temp);
     b:=b+0.1*abs(temp);
     Fa:=F_Voc(a);
     Fb:=F_Voc(b);
    until Fb*Fa<=0;

    i:=0;
    repeat
      inc(i);
      c:=(a+b)/2;
      Fb:=F_Voc(c);
      Fa:=F_Voc(a);
      if (Fb*Fa<=0)
       then b:=c
       else a:=c;

     if abs(a)<abs(b) then min:=abs(a)
                      else min:=abs(b);
     md:=0;
     if a=0 then md:=1;
     if b=0 then md:=2;
     if (a=0) and (b=0) then md:=3;
     case md of
        1:bool:=abs((b-a)/b)<1e-4;
        2:bool:=abs((b-a)/a)<1e-4;
        3:bool:=true;
      else bool:=abs((b-a)/min)<1e-4;
     end;

    until (i>1e5)or bool;
    if (i>1e5) then Exit;
    Result:=c;
  end; //if mode=1 then

if mode=3 then
  begin
    temp:=0.01;
    a:=0;
    repeat
    b:=a+temp;
    Fa:=a*Full_IV_2Exp(a,E1,E2,Rs,I01,I02,Rsh,Iph);
    Fb:=b*Full_IV_2Exp(b,E1,E2,Rs,I01,I02,Rsh,Iph);
    if Fa<=Fb then
      begin
        temp:=temp/2;
        Continue;
      end;
    a:=b;
    until (abs(temp)<0.00005);
   Result:=abs(a*Full_IV_2Exp(a,E1,E2,Rs,I01,I02,Rsh,Iph));
  end; //if mode=3 then

end;



//Procedure DE2Exp (V:PVector; var n1,Rs1,I01,n2,I02:double);
//{апроксимуються дані у векторі V
//залежністю I=I01[exp((V-IRs1)/n1kT)-1]+I=I02[exp(V/n2kT)-1]
//за методом differential evoluation}
// const
//      Nmax=5000;
//      Np=40;
//      F=0.8;
//      CR=0.3;
//  type ARARSin=array of array of double;
//
//    Function KVForm(AP:Pvector; Variab:array of double):double;
//    {розраховується квадратична форма з МНК
//    Variab - значення параметрів, очікується, що
//    Variab[0] - n1;
//    Variab[1] - Rs1;
//    Variab[2] - I01;
//    Variab[3] - n2;
//    Variab[4] - I02;
//    }
//    var i:integer;
//        Zi:double;
//    begin
//    Result:=0;
//    for I := 0 to High(AP^.X) do
//       begin
//       Zi:=Variab[2]*(exp((AP^.X[i]-AP^.Y[i]*Variab[1])/(Variab[0]*Kb*AP^.T))-1)
//          +Variab[4]*(exp(AP^.X[i]/(Variab[3]*Kb*AP^.T))-1)-AP^.Y[i];
//        Result:=Result+Zi*Zi/sqr(AP^.Y[i]);
//       end;
//    end;
//
//
// Function BestXi(Variab:ARARSin):integer;
//  {вибирається представник покоління, для якого
//   квадратична форма мінімальна;
//   повертається номер учасника покоління}
//    var S:array of double;
//        i:integer;
//        Sum:double;
//  begin
//    SetLength(S,NP);
//    for I := 0 to High(S) do
//      S[i]:=KVForm(V,Variab[i]);
//    Sum:=S[0];
//    Result:=0;
//    for I := 1 to High(S) do
//        if S[i]<Sum then
//           begin
//             Sum:=S[i];Result:=i;
//           end;
//  end; //BestXi
//
//var X,Mut,Tr:ARARSin;
//    i,j,Nit:integer;
//    r:array [1..3] of integer;
//   { str:string;{}
//    temp:double;
//begin
//I0:=555;
//n:=555;
//Rs:=555;
//Rsh:=555;
//SetLength(X,Np,5);
//SetLength(Mut,Np,5);
//SetLength(Tr,Np,5);
//Randomize;
//i:=0;
//repeat
//  j:=Random(10000000);
//  X[i,0]:=j/5e7+1.5;//n1=1.5-2
//
//  j:=Random(10000000);
//  X[i,3]:=j/1e7+1; //n2=1-2
//
//{  j:=Random(100000000);
//  X[i,2]:=exp(-(j/1e10));//I01=1e-5 - 9e-10
//
//  j:=Random(10000000);
//  X[i,4]:=exp(-(j/1e9));//I01=1e-2 - 9e-14
// }
//
//  j:=Random(10000000);
//  X[i,2]:=exp(-(16+j/1e7*16));//I01=1e-5 - 9e-10
//
//  j:=Random(10000000);
//  X[i,4]:=exp(-(18+j/1e7*12));//I01=1e-2 - 9e-14
//
//  j:=Random(990000000);
//  X[i,1]:=j/1e6+10;
//
//
//  {}  try
//    KVForm(V,X[i])
//  except
//    Continue
//  end;{}
////  if ExpParamIsBad(V,X[i,0],X[i,1],X[i,2],1e12) then Continue;
////  if ExpParamIsBad(V,X[i,3],1e-4,X[i,4],1e12) then Continue;
//  inc(i);
//until i>High(X);
//
//Nit:=0;
//
//repeat
//   i:=0;
//   repeat  //Вектор мутації
//     for j := 1 to 3 do
//       begin
//        r[j]:=Random(NP-1);
//        if r[j]>=i then r[j]:=r[j]+1;
//       end;
//    Mut[i,0]:=X[r[1],0]+F*(X[r[2],0]-X[r[3],0]);
//    Mut[i,1]:=X[r[1],1]+F*(X[r[2],1]-X[r[3],1]);
//    Mut[i,3]:=X[r[1],3]+F*(X[r[2],3]-X[r[3],3]);
//
//    temp:=ln(X[r[1],2])+F*(ln(X[r[2],2])-ln(X[r[3],2]));
//    if temp > 88 then Continue;
//         Mut[i,2]:=exp(temp);
//    temp:=ln(X[r[1],4])+F*(ln(X[r[2],4])-ln(X[r[3],4]));
//    if temp > 88 then Continue;
//         Mut[i,4]:=exp(temp);
//
//{}if (Mut[i,0]<0) or (Mut[i,1]<0) or (Mut[i,3]<0) or (Mut[i,2]<0)or (Mut[i,4]<0)then Continue;
//  try
//    KVForm(V,Mut[i])
//  except
//    Continue
//  end;{}
////    if ExpParamIsBad(V,Mut[i,0],Mut[i,1],Mut[i,2],1e12) then Continue;
// //   if ExpParamIsBad(V,Mut[i,3],1e-4,Mut[i,4],1e12) then Continue;
//    inc(i);
//   until i>High(Mut);
//
//   i:=0;
//   repeat  //Пробні вектори
//     r[2]:=Random(3); //rand(i)
//     for j := 0 to 4 do
//      begin
//       r[1]:=Random(10000000);//rand(j)
//       if ((r[1]/1e7)<=CR) or (j=r[2]) then Tr[i,j]:=Mut[i,j]
//                                       else Tr[i,j]:=X[i,j];
//      end;
////   if ExpParamIsBad(V,Tr[i,0],Tr[i,1],Tr[i,2],1e12) then Continue;
////    if ExpParamIsBad(V,Tr[i,3],1e-4,Tr[i,4],1e12) then Continue;
//{}  try
//    KVForm(V,Tr[i])
//  except
//    Continue
//  end;{}
//     inc(i);
//    until i>High(Tr);
//
//for I := 0 to High(X) do
//  if KVForm(V,X[i])>KVForm(V,Tr[i]) then X[i]:=Copy(Tr[i]);
//
//inc(Nit);
//until (Nit>Nmax);
//
//j:=BestXi(X);
//I01:=X[j,2];
//n1:=X[j,0];
//Rs1:=X[j,1];
//n2:=X[j,3];
//I02:=X[j,4];
//end;

//Procedure EvolutionControlPar(FuncType:TFuncType;{Ns:integer;Xlo,Xhi:array of double;}
//                      Xmode:TArrVar_Rand; var Xnew:array of double);
// {контролює можливі значення параметрів,
// що підбираються при апроксимації еволюційними методами,
// заважаючи їм прийняти нереальні значення}
//  var k:integer;
//      Xlo,Xhi:TArrSingle;
//      temp:double;
//  begin
//  SetLength(Xlo,High(Xnew)+1);
//  SetLength(Xhi,High(Xnew)+1);
//   case FuncType of
//    diod:
//     begin
//      Xlo[0]:=0.5;Xhi[0]:=20;//n
//      Xlo[1]:=1e-10;Xhi[1]:=1e6;//Rs
//      Xlo[2]:=1e-24;Xhi[2]:=0.01;//I0
//      Xlo[3]:=10;Xhi[3]:=1e12;//Rsh
//     end;
//    photodiod:
//     begin
//      Xlo[0]:=0.5;Xhi[0]:=20;//n
//      Xlo[1]:=1e-10;Xhi[1]:=1e6;//Rs
//      Xlo[2]:=1e-24;Xhi[2]:=0.01;//I0
//      Xlo[3]:=10;Xhi[3]:=1e12;//Rsh
//      Xlo[4]:=1e-10;Xhi[4]:=0.01;//Iph
//     end;
//    DiodTwo:
//     begin
//      Xlo[0]:=1;Xhi[0]:=20;//n1
//      Xlo[1]:=1e-10;Xhi[1]:=1e6;//Rs
//      Xlo[2]:=1e-18;Xhi[2]:=0.01;//I01
//      Xlo[3]:=0.5;Xhi[3]:=3;//n2
//      Xlo[4]:=1e-24;Xhi[4]:=0.01;//I02
//     end;
//    DiodTwoFull:
//     begin
//      Xlo[0]:=1;Xhi[0]:=20;//n1
//      Xlo[1]:=1e-10;Xhi[1]:=1e6;//Rs1
//      Xlo[2]:=1e-18;Xhi[2]:=0.01;//I01
//      Xlo[3]:=0.5;Xhi[3]:=3;//n2
//      Xlo[4]:=1e-24;Xhi[4]:=0.01;//I02
//      Xlo[5]:=1e-5;Xhi[5]:=25;//Rs2
//     end;
//    DGaus:
//     begin
//      Xlo[0]:=0;Xhi[0]:=1.001;//n1
//      Xlo[1]:=0.0001;Xhi[1]:=2;//Rs1
//      Xlo[2]:=0.0000001;Xhi[2]:=2;//I01
//      Xlo[3]:=0.0001;Xhi[3]:=2;//n2
//      Xlo[4]:=0.0000001;Xhi[4]:=2;//I02
//     end;
//    DoubleDiod:
//     begin
//      Xlo[0]:=0.5;Xhi[0]:=20;//n1
//      Xlo[1]:=0.4;Xhi[1]:=1e6;//Rs
////      Xlo[1]:=1e-10;Xhi[1]:=1e6;//Rs
//      Xlo[2]:=1e-18;Xhi[2]:=0.01;//I01
//      Xlo[3]:=10;Xhi[3]:=1e12;//Rsh
////      Xlo[4]:=0.5;Xhi[4]:=10;//n2
//      Xlo[4]:=0.5;Xhi[4]:=1.5;//n2
//      Xlo[5]:=1e-24;Xhi[5]:=0.01;//I02
//     end;
//    DoubleDiodLight:
//     begin
//  {}    Xlo[0]:=0.5;Xhi[0]:=20;//n1
//      Xlo[1]:=0.5;Xhi[1]:=10;//Rs
////      Xlo[1]:=1e-10;Xhi[1]:=1e6;//Rs
//      Xlo[2]:=1e-18;Xhi[2]:=0.01;//I01
//      Xlo[3]:=10;Xhi[3]:=1e12;//Rsh
// //     Xlo[4]:=0.5;Xhi[4]:=10;//n2
//      Xlo[4]:=0.5;Xhi[4]:=1.5;//n2
//      Xlo[5]:=1e-24;Xhi[5]:=0.01;//I02
//      Xlo[6]:=1e-20;Xhi[6]:=0.01;//Iph
//   {}
//
// {     Xlo[0]:=2;Xhi[0]:=3;//n1
//      Xlo[1]:=1;Xhi[1]:=3;//Rs
//      Xlo[2]:=1e-8;Xhi[2]:=1e-6;//I01
//      Xlo[3]:=10;Xhi[3]:=1e12;//Rsh
//      Xlo[4]:=0.5;Xhi[4]:=1.5;//n2
//      Xlo[5]:=1e-12;Xhi[5]:=1e-10;//I02
//      Xlo[6]:=5e-5;Xhi[6]:=5e-4;//Iph
//      {}
//      end;
//   LinEg:
//    begin
////      Xlo[0]:=0.01;Xhi[0]:=1.5;//Fb0
////      Xlo[1]:=1e-20;Xhi[1]:=0.01;//fps
//      Xlo[0]:=1e-20;Xhi[0]:=0.01;//gamm0
//      Xlo[1]:=1e-15;Xhi[1]:=1e10;//C1
////      Xlo[2]:=0.01;Xhi[2]:=1.5;//Fb0
//    end;
//   RevZriz:
//    begin
//    Xlo[0]:=1e-20; Xhi[0]:=1e17;//I01
//    Xlo[1]:=0.001; Xhi[1]:=1.5;//E1
//    Xlo[2]:=1e-10; Xhi[2]:=1e15;//I02
//    Xlo[3]:=0.5; Xhi[3]:=1.5;//E2
//    end;
// RevShSCLC:
//    begin
//    Xlo[0]:=1e-20; Xhi[0]:=0.1;//I01
//    Xlo[1]:=0.1; Xhi[1]:=20;//m
//    Xlo[3]:=1e-20; Xhi[3]:=0.1;//I02
//    Xlo[2]:=1e-15; Xhi[2]:=1e-2;//A
//    end;
// RevShSCLC2:
//    begin
//    Xlo[0]:=1e-20; Xhi[0]:=0.1;//I01
//    Xlo[1]:=1e-30; Xhi[1]:=0.1;//I02
//    Xlo[2]:=1e-15; Xhi[2]:=1e-2;//A
//    end;
// RevShSCLC3:
//    begin
//    Xlo[0]:=1e-20; Xhi[0]:=0.1;//I01
//    Xlo[1]:=0.1; Xhi[1]:=8;//m1
//    Xlo[2]:=1e-17; Xhi[2]:=1e-3;//I02
//    Xlo[3]:=1; Xhi[3]:=25;//m2
//    Xlo[4]:=1e-15; Xhi[4]:=1e-4;//I03
//    Xlo[5]:=1e-10; Xhi[5]:=1e-6;//A
//    end;
// RevShTwo:
//    begin
//    Xlo[0]:=1e-15; Xhi[0]:=1e-4;//I01
//    Xlo[1]:=1e-17; Xhi[1]:=1e-4;//I02
//    Xlo[2]:=2e-9; Xhi[2]:=2e-8;//A1
//    Xlo[3]:=1e-11; Xhi[3]:=1e-7;//A2
//    end;
// RevZriz2:
//    begin
//    Xlo[0]:=1e-10; Xhi[0]:=1e15;//I01
//    Xlo[1]:=1e-30; Xhi[1]:=1;//B
// //   Xlo[4]:=1; Xhi[4]:=500;//Tc
//    Xlo[2]:=1e-15; Xhi[2]:=1e3;//I02
//    Xlo[3]:=0.4; Xhi[3]:=1.5;//E
//    end;
// Power2:
//    begin
//    Xlo[0]:=1e-30; Xhi[0]:=1;//A1
//    Xlo[1]:=1e-15; Xhi[1]:=1;//A2
//    Xlo[2]:=0.5; Xhi[2]:=5;//m1
//    Xlo[3]:=3; Xhi[3]:=20;//m2
//    end;
// RevZriz3:
//    begin
//    Xlo[0]:=1e-10; Xhi[0]:=1e35;//I01
//    Xlo[1]:=10; Xhi[1]:=1e15;//Tc
//    Xlo[2]:=1e-10; Xhi[2]:=1e10;//I02
//    Xlo[3]:=0.1; Xhi[3]:=1;//E
//    end;
// Tun:
//    begin
//    Xlo[0]:=1e-20; Xhi[0]:=1e38;//I0
//    Xlo[1]:=1e-3; Xhi[1]:=25;//A
//    Xlo[2]:=0.001; Xhi[2]:=100;//B
//    end;
// RevShNew:
//    begin
//    Xlo[0]:=1e-20; Xhi[0]:=1e15;//I0
//    Xlo[1]:=1e-20; Xhi[1]:=1e-4; //Al
//    Xlo[2]:=1e-8; Xhi[2]:=1e-3;//Bt
//   end;
// RevShNew2:
//    begin
//    Xlo[0]:=1e-20; Xhi[0]:=1e15;//I01
//    Xlo[1]:=1e-20; Xhi[1]:=1e-4; //Al1
//    Xlo[2]:=1e-6; Xhi[2]:=3e-4;//Bt
//    Xlo[3]:=1e-20; Xhi[3]:=1e15;//I02
//    Xlo[4]:=1e-20; Xhi[4]:=1e-4; //Al2
//   end;
//    end;//case
//for k := 0 to High(Xnew) do
//  if (Xmode[k]<>cons) then
//   begin
//    while(Xnew[k]>Xhi[k])do
//     case Xmode[k] of
//       lin:Xnew[k]:=Xnew[k]-Random*(Xhi[k]-Xlo[k]);
//       logar:
//         begin
//         temp:=ln(Xnew[k])-Random*(ln(Xhi[k])-ln(Xlo[k]));
//         while (temp>88) do temp:=temp-1;
//         Xnew[k]:=exp(temp);
//         end;
//     end;//case
//   while (Xnew[k]<Xlo[k]) do
//     case Xmode[k] of
//       lin:Xnew[k]:=Xnew[k]+Random*(Xhi[k]-Xlo[k]);
//       logar:
//         begin
//         temp:=ln(Xnew[k])+Random*(ln(Xhi[k])-ln(Xlo[k]));
//         while (temp>88) do temp:=temp-1;
//         Xnew[k]:=exp(temp);
//         end;
//     end;//case
//    end;
//
// end; // Procedure ControlPar;

//Function EvolutionBegin(FuncType:TFuncType;mode:byte; var Ns:integer; var FitFunction:TFunEvolution;
//                         var Xlo,Xhi:TArrSingle;var Xmode:TArrVar_Rand):boolean;
// {на початку апроксимації за допомогою
// еволюційних методів виконує операції,
// пов'язані з оформленням форми Approximation та інші,
// які не залежать від алгоритму, а визначаються, насамперед,
// апроксимуючою функцією;
// повертає False при помилках}
//begin
//Result:=False;
//
//case FuncType of
// diod:
//    begin
//    Ns:=4;
////    FitFunction:=ExpIVLong;
////    FitFunction:=ExpIV;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//    Xlo[0]:=1; Xhi[0]:=2;//n
//    Xlo[1]:=0; Xhi[1]:=50;//Rs
//    Xlo[2]:=1e-14; Xhi[2]:=1e-2;//I0
//    Xlo[3]:=50; Xhi[3]:=1e8;//Rsh
//    Xmode[0]:=lin;
//    Xmode[2]:=logar;
//    Approx.Ln.Caption:='I0 = ';
//    Approx.Ln.Visible:=True;
//    Approx.Label1.Caption:='n = ';
//    Approx.Label1.Visible:=True;
//    Approx.Label2.Caption:='Rs = ';
//    Approx.Label2.Visible:=True;
//    Approx.Label3.Caption:='Rsh = ';
//    Approx.Label3.Visible:=True;
//    Approx.Label6.Visible:=True;
//    Approx.Label7.Visible:=True;
//    Approx.Label12.Visible:=False;
//    Approx.Label13.Visible:=False;
//    case mode of
//      0:begin
//         Xmode[1]:=lin;
//         Xmode[3]:=logar;
//         Approx.Label8.Visible:=true;
//         Approx.Label9.Visible:=true;
//        end;
//      1:begin
//         Xmode[1]:=lin;
//         Xmode[3]:=cons;
//         Xlo[3]:=1e12;
//         Xhi[3]:=1e12;
//         Approx.Label8.Visible:=true;
//         Approx.Label9.Visible:=False;
//         Approx.Label3.Visible:=False;
//         end;
//      2:begin
//         Xmode[1]:=cons;
//         Xlo[1]:=0;
//         Xhi[1]:=0;
//         Xmode[3]:=logar;
//         Approx.Label8.Visible:=false;
//         Approx.Label2.Visible:=False;
//         Approx.Label9.Visible:=true;
//        end;
//      3:begin
//         Xmode[1]:=cons;
//         Xlo[1]:=0;
//         Xhi[1]:=0;
//         Xmode[3]:=cons;
//         Xlo[3]:=1e12;
//         Xhi[3]:=1e12;
//         Approx.Label8.Visible:=false;
//         Approx.Label2.Visible:=False;
//         Approx.Label9.Visible:=false;
//         Approx.Label3.Visible:=False;
//        end;
//      end;//case  mode
//    end;
////------------------------------- diod:------------------------
//{ photodiod:
//    begin
//    if Nit=0 then
//      begin
//        Ns:=5;
//        FitFunction:=ExpIVLight_Shot;
//        SetLength(Xmode,Ns);
//        SetLength(Xlo,Ns);
//        SetLength(Xhi,Ns);
//        Xlo[0]:=1; Xhi[0]:=2;//n
//        Xlo[1]:=0; Xhi[1]:=50;//Rs
//        Xlo[2]:=1e-14; Xhi[2]:=1e-2;//I0
//        Xlo[3]:=50; Xhi[3]:=1e8;//Rsh
//        Xlo[4]:=1e-6; Xhi[4]:=0.1;//Iph
//        Xmode[4]:=logar;
//        Xmode[0]:=norm;
//        Xmode[2]:=logar;
//        Approx.Ln.Caption:='I0 = ';
//        Approx.Ln.Visible:=True;
//        Approx.Label1.Caption:='n = ';
//        Approx.Label1.Visible:=True;
//        Approx.Label2.Caption:='Rs = ';
//        Approx.Label2.Visible:=True;
//        Approx.Label3.Caption:='Rsh = ';
//        Approx.Label3.Visible:=True;
//        Approx.Label6.Visible:=True;
//        Approx.Label7.Visible:=True;
//        Approx.Label12.Caption:='Iph = ';
//        Approx.Label12.Visible:=True;
//        Approx.Label13.Visible:=True;
//        Xmode[1]:=cons;
//        case mode of
//          0:begin
//             Xmode[3]:=logar;
//             Approx.Label8.Visible:=true;
//             Approx.Label9.Visible:=true;
//            end;
//          1:begin
//             Xmode[3]:=cons;
//             Xlo[3]:=1e12;
//             Xhi[3]:=1e12;
//             Approx.Label8.Visible:=true;
//             Approx.Label9.Visible:=False;
//             Approx.Label3.Visible:=False;
//             end;
//          2:begin
//             Xmode[3]:=logar;
//             Approx.Label8.Visible:=false;
//             Approx.Label2.Visible:=False;
//             Approx.Label9.Visible:=true;
//            end;
//          3:begin
//             Xmode[3]:=cons;
//             Xlo[3]:=1e12;
//             Xhi[3]:=1e12;
//             Approx.Label8.Visible:=false;
//             Approx.Label2.Visible:=False;
//             Approx.Label9.Visible:=false;
//             Approx.Label3.Visible:=False;
//            end;
//          end;//case  mode
//       end  //if Nit=0 then
//            else
//      begin
//        FitFunction:=ExpIVLight;
//  //      Xmode[3]:=cons;
//        Xmode[4]:=cons;
//        case mode of
//          0,1: Xmode[1]:=norm;
//          2,3: Xmode[1]:=cons;
//          end;//case  mode
//        Nit:=0;
//      end;  //if Nit=0 else
//    end; //photodiod:
// }
//{} photodiod:
//    begin
//        Ns:=5;
////        FitFunction:=ExpIVLight;
//        SetLength(Xmode,Ns);
//        SetLength(Xlo,Ns);
//        SetLength(Xhi,Ns);
//        Xlo[0]:=1; Xhi[0]:=2;//n
//        Xlo[1]:=0; Xhi[1]:=50;//Rs
//        Xlo[2]:=1e-14; Xhi[2]:=1e-2;//I0
//        Xlo[3]:=50; Xhi[3]:=1e8;//Rsh
//        Xlo[4]:=1e-8; Xhi[4]:=0.1;//Iph
//        Xmode[4]:=logar;
//        Xmode[0]:=lin;
//        Xmode[2]:=logar;
//        Approx.Ln.Caption:='I0 = ';
//        Approx.Ln.Visible:=True;
//        Approx.Label1.Caption:='n = ';
//        Approx.Label1.Visible:=True;
//        Approx.Label2.Caption:='Rs = ';
//        Approx.Label2.Visible:=True;
//        Approx.Label3.Caption:='Rsh = ';
//        Approx.Label3.Visible:=True;
//        Approx.Label6.Visible:=True;
//        Approx.Label7.Visible:=True;
//        Approx.Label12.Caption:='Iph = ';
//        Approx.Label12.Visible:=True;
//        Approx.Label13.Visible:=True;
//        case mode of
//          0:begin
//             Xmode[1]:=lin;
//             Xmode[3]:=logar;
//             Approx.Label8.Visible:=true;
//             Approx.Label9.Visible:=true;
//            end;
//          1:begin
//             Xmode[1]:=lin;
//             Xmode[3]:=cons;
//             Xlo[3]:=1e12;
//             Xhi[3]:=1e12;
//             Approx.Label8.Visible:=true;
//             Approx.Label9.Visible:=False;
//             Approx.Label3.Visible:=False;
//             end;
//          2:begin
//             Xmode[1]:=cons;
//             Xlo[1]:=0;
//             Xhi[1]:=0;
//             Xmode[3]:=logar;
//             Approx.Label8.Visible:=false;
//             Approx.Label2.Visible:=False;
//             Approx.Label9.Visible:=true;
//            end;
//          3:begin
//             Xmode[1]:=cons;
//             Xlo[1]:=0;
//             Xhi[1]:=0;
//             Xmode[3]:=cons;
//             Xlo[3]:=1e12;
//             Xhi[3]:=1e12;
//             Approx.Label8.Visible:=false;
//             Approx.Label2.Visible:=False;
//             Approx.Label9.Visible:=false;
//             Approx.Label3.Visible:=False;
//            end;
//          end;//case  mode
//    end; //photodiod:{}
////-----------------------------------photodiod------------------------
// DiodTwo,DiodTwoFull:
//    begin
//    if FuncType=DiodTwoFull then
//      begin
//      Ns:=6;
////      FitFunction:=Exp2Full;
//      end
//                           else
//      begin
//      Ns:=5;
////      FitFunction:=Exp2;
//      end;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//{}    Xlo[0]:=1.5; Xhi[0]:=2;Xmode[0]:=lin;//n1
//    Xlo[1]:=10; Xhi[1]:=2000;Xmode[1]:=lin;//Rs
//    Xlo[2]:=1e-15; Xhi[2]:=1e-5;Xmode[2]:=logar;//I01
//    Xlo[3]:=1; Xhi[3]:=1.5;Xmode[3]:=lin;//n2
//    Xlo[4]:=1e-19; Xhi[4]:=1e-6;Xmode[4]:=logar;//I02
// {}
//  {  Xlo[0]:=2.134; Xhi[0]:=2;Xmode[0]:=cons;//n1
//    Xlo[1]:=45600; Xhi[1]:=2000;Xmode[1]:=cons;//Rs
//    Xlo[2]:=7.708E-14; Xhi[2]:=1e-5;Xmode[2]:=cons;//I01
//    Xlo[3]:=1.848; Xhi[3]:=1.5;Xmode[3]:=cons;//n2
//    Xlo[4]:=6.12E-16; Xhi[4]:=1e-6;Xmode[4]:=cons;//I02
// {}
//    if FuncType=DiodTwoFull then
//      begin
//      Xlo[5]:=1e-5; Xhi[5]:=1;//Rs2
//      Xmode[5]:=lin;
//      end;
//    Approx.Ln.Caption:='n1 = ';
//    Approx.Ln.Visible:=True;
//    Approx.Label6.Visible:=True;
//    Approx.Label1.Caption:='Rs = ';
//    Approx.Label1.Visible:=True;
//    Approx.Label7.Visible:=True;
//    Approx.Label2.Caption:='I01 = ';
//    Approx.Label2.Visible:=True;
//    Approx.Label8.Visible:=True;
//    Approx.Label3.Caption:='n2 = ';
//    Approx.Label3.Visible:=True;
//    Approx.Label9.Visible:=True;
//    Approx.Label12.Caption:='I02 = ';
//    Approx.Label12.Visible:=True;
//    Approx.Label13.Visible:=True;
//    end;
////--------------------------DiodTwo,DiodTwoFull-------------------
// DGaus:
//    begin
//    Ns:=5;
////    FitFunction:=DbGausFit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//    Xlo[0]:=0.01; Xhi[0]:=0.95;Xmode[0]:=lin;//A1
////    Xlo[0]:=1; Xhi[0]:=1;Xmode[0]:=cons;//A1
//    Xlo[1]:=0.2; Xhi[1]:=0.9;Xmode[1]:=lin;//Fb1
//    Xlo[2]:=0.01; Xhi[2]:=0.4;Xmode[2]:=lin;//Sig1
//    Xlo[3]:=0.3; Xhi[3]:=1;Xmode[3]:=lin;//Fb2
//    Xlo[4]:=0.05; Xhi[4]:=0.6;Xmode[4]:=lin;//Sig2
////    Xlo[3]:=0.3; Xhi[3]:=1;Xmode[3]:=cons;//Fb2
////    Xlo[4]:=0.05; Xhi[4]:=0.6;Xmode[4]:=cons;//Sig2
//    end;
////----------------------------DGaus-----------------------
// DoubleDiod:
//    begin
//    Ns:=6;
////    FitFunction:=DoubleDiodFit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//    Xlo[0]:=1; Xhi[0]:=2;Xmode[0]:=lin;//n1
//    Xlo[1]:=0; Xhi[1]:=5;Xmode[1]:=lin;//Rs
//    Xlo[2]:=1e-8; Xhi[2]:=1e-5;Xmode[2]:=logar;//I01
//    Xlo[3]:=50; Xhi[3]:=1e3;Xmode[3]:=logar;//Rsh
//    Xlo[4]:=2; Xhi[4]:=4;Xmode[4]:=lin;//n2
//    Xlo[5]:=1e-10; Xhi[5]:=1e-6;Xmode[5]:=logar;//I02
//    Approx.Ln.Caption:='n1 = ';
//    Approx.Ln.Visible:=True;
//    Approx.Label6.Visible:=True;
//    Approx.Label1.Caption:='Rs = ';
//    Approx.Label1.Visible:=True;
//    Approx.Label7.Visible:=True;
//    Approx.Label2.Caption:='I01 = ';
//    Approx.Label2.Visible:=True;
//    Approx.Label8.Visible:=True;
//    Approx.Label3.Caption:='n2 = ';
//    Approx.Label3.Visible:=True;
//    Approx.Label9.Visible:=True;
//    Approx.Label12.Caption:='I02 = ';
//    Approx.Label12.Visible:=True;
//    Approx.Label13.Visible:=True;
//    case mode of
//      0:begin
//         Xmode[1]:=lin;
//         Xmode[3]:=logar;
//        end;
//      1:begin
//         Xmode[1]:=lin;
//         Xmode[3]:=cons;
//         Xlo[3]:=1e12;
//         Xhi[3]:=1e12;
//         end;
//      2:begin
//         Xmode[1]:=cons;
//         Xlo[1]:=0;
//         Xhi[1]:=0;
//         Xmode[3]:=logar;
//        end;
//      3:begin
//         Xmode[1]:=cons;
//         Xlo[1]:=0;
//         Xhi[1]:=0;
//         Xmode[3]:=cons;
//         Xlo[3]:=1e12;
//         Xhi[3]:=1e12;
//        end;
//      end;//case  mode
//    end;
////--------------------------DoubleDiod-------------------
// DoubleDiodLight:
//    begin
//    Ns:=7;
////    FitFunction:=DoubleDiodLightFit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//{}    Xlo[0]:=1; Xhi[0]:=2;Xmode[0]:=lin;//n1
//    Xlo[1]:=0; Xhi[1]:=5;Xmode[1]:=lin;//Rs
//    Xlo[2]:=1e-8; Xhi[2]:=1e-5;Xmode[2]:=logar;//I01
//    Xlo[3]:=50; Xhi[3]:=1e3;Xmode[3]:=logar;//Rsh
//    Xlo[4]:=2; Xhi[4]:=4;Xmode[4]:=lin;//n2
//    Xlo[5]:=1e-10; Xhi[5]:=1e-6;Xmode[5]:=logar;//I02
//    Xlo[6]:=1e-8; Xhi[6]:=0.1;Xmode[6]:=logar;//Iph
////    Xlo[6]:=1.138e-4; Xhi[6]:=0.1;Xmode[6]:=cons;//Iph
// {}
//  {  Xlo[0]:=2.4; Xhi[0]:=2.6;Xmode[0]:=norm;//n1
//    Xlo[1]:=2.1; Xhi[1]:=2.4;Xmode[1]:=norm;//Rs
//    Xlo[2]:=6.891e-7; Xhi[2]:=6.891e-7;Xmode[2]:=norm;//I01
//    Xlo[3]:=8e10; Xhi[3]:=8e12;Xmode[3]:=norm;//Rsh
//    Xlo[4]:=1.104; Xhi[4]:=1.104;Xmode[4]:=norm;//n2
//    Xlo[5]:=8.12e-11; Xhi[5]:=8.12e-11;Xmode[5]:=norm;//I02
//    Xlo[6]:=1.1e-4; Xhi[6]:=1.18e-4;Xmode[6]:=norm;//Iph
// }
//{    Xlo[0]:=2.521; Xhi[0]:=2.521;Xmode[0]:=norm;//n1
//    Xlo[1]:=2.248; Xhi[1]:=2.248;Xmode[1]:=norm;//Rs
//    Xlo[2]:=6.891e-7; Xhi[2]:=6.891e-7;Xmode[2]:=logar;//I01
//    Xlo[3]:=8.228e11; Xhi[3]:=8.228e11;Xmode[3]:=logar;//Rsh
//    Xlo[4]:=1.104; Xhi[4]:=1.104;Xmode[4]:=norm;//n2
//    Xlo[5]:=8.12e-11; Xhi[5]:=8.12e-11;Xmode[5]:=logar;//I02
//    Xlo[6]:=1.13e-4; Xhi[6]:=1.15e-4;Xmode[6]:=logar;//Iph
//}
//    Approx.Ln.Caption:='n1 = ';
//    Approx.Ln.Visible:=True;
//    Approx.Label6.Visible:=True;
//    Approx.Label1.Caption:='Rs = ';
//    Approx.Label1.Visible:=True;
//    Approx.Label7.Visible:=True;
//    Approx.Label2.Caption:='I01 = ';
//    Approx.Label2.Visible:=True;
//    Approx.Label8.Visible:=True;
//    Approx.Label3.Caption:='n2 = ';
//    Approx.Label3.Visible:=True;
//    Approx.Label9.Visible:=True;
//    Approx.Label12.Caption:='Iph = ';
//    Approx.Label12.Visible:=True;
//    Approx.Label13.Visible:=True;
//    case mode of
//      0:begin
//         Xmode[1]:=lin;
//         Xmode[3]:=logar;
//        end;
//      1:begin
//         Xmode[1]:=lin;
//         Xmode[3]:=cons;
//         Xlo[3]:=1e12;
//         Xhi[3]:=1e12;
//         end;
//      2:begin
//         Xmode[1]:=cons;
//         Xlo[1]:=0;
//         Xhi[1]:=0;
//         Xmode[3]:=logar;
//        end;
//      3:begin
//         Xmode[1]:=cons;
//         Xlo[1]:=0;
//         Xhi[1]:=0;
//         Xmode[3]:=cons;
//         Xlo[3]:=1e12;
//         Xhi[3]:=1e12;
//        end;
//      end;//case  mode
//    end;
////--------------------------DoubleDiodLight-------------------
// LinEg:
//    begin
//    Ns:=2;
////    Ns:=3;
////    FitFunction:=LinEgFit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
////    Xlo[0]:=0.1; Xhi[0]:=2;Xmode[0]:=norm;//Fb0
////    Xlo[1]:=1e-5; Xhi[1]:=1e-15;Xmode[1]:=logar;//fp
//    Xlo[0]:=1e-5; Xhi[0]:=1e-15;Xmode[0]:=logar;//gamma0
//    Xlo[1]:=1e-15; Xhi[1]:=1e5;Xmode[1]:=logar;//C1
////    Xlo[2]:=0.1; Xhi[2]:=2;Xmode[2]:=norm;//Fb0
//    end;
////--------------------------LinEg-------------------
// RevZriz:
//    begin
//    Ns:=4;
////    FitFunction:=RevZrizFit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//    Xlo[0]:=1e-10; Xhi[0]:=0.1;Xmode[0]:=logar;//I01
//    Xlo[1]:=0.1; Xhi[1]:=1;Xmode[1]:=lin;//E1
//    Xlo[2]:=1e-5; Xhi[2]:=10;Xmode[2]:=logar;//I02
//    Xlo[3]:=0.1; Xhi[3]:=1;Xmode[3]:=lin;//E2
//    Approx.Ln.Caption:='I01 = ';
//    Approx.Ln.Visible:=True;
//    Approx.Label6.Visible:=True;
//    Approx.Label1.Caption:='E1 = ';
//    Approx.Label1.Visible:=True;
//    Approx.Label7.Visible:=True;
//    Approx.Label2.Caption:='I02 = ';
//    Approx.Label2.Visible:=True;
//    Approx.Label8.Visible:=True;
//    Approx.Label3.Caption:='E2 = ';
//    Approx.Label3.Visible:=True;
//    Approx.Label9.Visible:=True;
//    Approx.Label12.Visible:=False;
//    Approx.Label13.Visible:=False;
//    end;
////--------------------------RevZriz-------------------
// RevShSCLC:
//    begin
//    Ns:=4;
////    FitFunction:=RevShSCLCFit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//    Xlo[0]:=1e-9; Xhi[0]:=0.1;Xmode[0]:=logar;//I01
//    Xlo[1]:=0.5; Xhi[1]:=4;Xmode[1]:=lin;//m
//    Xlo[2]:=1e-8; Xhi[2]:=1e-3;Xmode[2]:=logar;//A
////    Xlo[2]:=2.4066e-8; Xhi[2]:=2.4066e-8;Xmode[2]:=cons;//A
////    Xlo[3]:=5.6E-5; Xhi[3]:=5.6E-5;Xmode[3]:=cons;//I02
//    Xlo[3]:=1e-12; Xhi[3]:=0.1;Xmode[3]:=logar;//I02
//    Approx.Ln.Caption:='I01';
//    Approx.Ln.Visible:=True;
//    Approx.Label6.Visible:=True;
//    Approx.Label1.Caption:='m = ';
//    Approx.Label1.Visible:=True;
//    Approx.Label7.Visible:=True;
//    Approx.Label2.Caption:='Al = ';
//    Approx.Label2.Visible:=True;
//    Approx.Label8.Visible:=True;
//    Approx.Label3.Caption:='I02 = ';
//    Approx.Label3.Visible:=True;
//    Approx.Label9.Visible:=True;
//    Approx.Label12.Visible:=False;
//    Approx.Label13.Visible:=False;
//    end;
////--------------------------RevShSCLC-------------------
// RevShSCLC2:
//    begin
//    Ns:=3;
////    FitFunction:=RevShSCLC2Fit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//    Xlo[0]:=1e-5; Xhi[0]:=0.1;Xmode[0]:=logar;//I01
//    Xlo[1]:=1e-12; Xhi[1]:=1e-5;Xmode[1]:=logar;//I02
// //   Xlo[2]:=2.417e-8; Xhi[2]:=2.417e-8;Xmode[2]:=cons;//A
//    Xlo[2]:=1e-8; Xhi[2]:=1e-3;Xmode[2]:=logar;//A
//    Approx.Ln.Caption:='I01';
//    Approx.Ln.Visible:=True;
//    Approx.Label6.Visible:=True;
////    Approx.Label1.Caption:='m = ';
//    Approx.Label1.Visible:=False;
//    Approx.Label7.Visible:=False;
//    Approx.Label2.Caption:='Al = ';
//    Approx.Label2.Visible:=True;
//    Approx.Label8.Visible:=True;
//    Approx.Label3.Caption:='I02 = ';
//    Approx.Label3.Visible:=True;
//    Approx.Label9.Visible:=True;
//    Approx.Label12.Visible:=False;
//    Approx.Label13.Visible:=False;
//    end;
////--------------------------RevShSCLC2-------------------
// RevShSCLC3:
//    begin
//    Ns:=6;
////    FitFunction:=RevShSCLC3Fit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//    Xlo[0]:=1e-5; Xhi[0]:=0.1;Xmode[0]:=logar;//I01
//    Xlo[1]:=1; Xhi[1]:=6;Xmode[1]:=lin;//m1
//    Xlo[2]:=1e-12; Xhi[2]:=1e-5;Xmode[2]:=logar;//I02
//    Xlo[3]:=5; Xhi[3]:=25;Xmode[3]:=lin;//m2
//    Xlo[4]:=1e-12; Xhi[4]:=1e-5;Xmode[4]:=logar;//I03
//    Xlo[5]:=1e-8; Xhi[5]:=1e-6;Xmode[5]:=logar;//A
////    Xlo[5]:=2.4e-8; Xhi[5]:=2.4e-8;Xmode[5]:=cons;//A
//    Approx.Ln.Caption:='I01';
//    Approx.Ln.Visible:=True;
//    Approx.Label6.Visible:=True;
//    Approx.Label1.Caption:='m1 = ';
//    Approx.Label1.Visible:=True;
//    Approx.Label7.Visible:=True;
//    Approx.Label2.Caption:='m2 = ';
//    Approx.Label2.Visible:=True;
//    Approx.Label8.Visible:=True;
//    Approx.Label3.Caption:='I03 = ';
//    Approx.Label3.Visible:=True;
//    Approx.Label9.Visible:=True;
//    Approx.Label12.Caption:='Al = ';
//    Approx.Label12.Visible:=True;
//    Approx.Label13.Visible:=True;
//    end;
////--------------------------RevShSCLC3-------------------
// RevShTwo:
//    begin
//    Ns:=4;
////    FitFunction:=RevShTwoFit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//    Xlo[0]:=1e-12; Xhi[0]:=1e-4;Xmode[0]:=logar;//I01
//    Xlo[1]:=1e-17; Xhi[1]:=1e-4;Xmode[1]:=logar;//I02
//    Xlo[2]:=2e-9; Xhi[2]:=2e-8;Xmode[2]:=logar;//A1
//    Xlo[3]:=5e-10; Xhi[3]:=1e-7;Xmode[3]:=logar;//A2
////    Xlo[2]:=2.409e-8; Xhi[2]:=2.409e-8;Xmode[2]:=cons;//A1
////    Xlo[3]:=5.079e-8; Xhi[3]:=5.079e-8;Xmode[3]:=cons;//A2
//    Approx.Ln.Caption:='I01';
//    Approx.Ln.Visible:=True;
//    Approx.Label6.Visible:=True;
//    Approx.Label1.Caption:='Al1 = ';
//    Approx.Label1.Visible:=True;
//    Approx.Label7.Visible:=True;
//    Approx.Label2.Caption:='I02 = ';
//    Approx.Label2.Visible:=True;
//    Approx.Label8.Visible:=True;
//    Approx.Label3.Caption:='Al2 = ';
//    Approx.Label3.Visible:=True;
//    Approx.Label9.Visible:=True;
//    Approx.Label12.Visible:=False;
//    Approx.Label13.Visible:=False;
//    end;
////--------------------------RevShTwo-------------------
// RevZriz2:
//    begin
//    Ns:=4;
////    FitFunction:=RevZriz2Fit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//    Xlo[0]:=1; Xhi[0]:=1e10;Xmode[0]:=logar;//I01
//    Xlo[1]:=1e-25; Xhi[1]:=1e-5;Xmode[1]:=logar;//B
////    Xlo[4]:=10; Xhi[4]:=300;Xmode[4]:=norm;//Tc
////    Xlo[4]:=300; Xhi[4]:=300;Xmode[4]:=cons;//Tc
//    Xlo[2]:=1e-10; Xhi[2]:=0.01;Xmode[2]:=logar;//I02
//    Xlo[3]:=0.1; Xhi[3]:=1;Xmode[3]:=lin;//E
//    Approx.Ln.Caption:='I01 = ';
//    Approx.Ln.Visible:=True;
//    Approx.Label6.Visible:=True;
//    Approx.Label1.Caption:='B = ';
//    Approx.Label1.Visible:=True;
//    Approx.Label7.Visible:=True;
//    Approx.Label2.Caption:='Tc = ';
//    Approx.Label2.Visible:=False;
//    Approx.Label8.Visible:=False;
//    Approx.Label3.Caption:='I02 = ';
//    Approx.Label3.Visible:=True;
//    Approx.Label9.Visible:=True;
//    Approx.Label12.Caption:='E = ';
//    Approx.Label12.Visible:=True;
//    Approx.Label13.Visible:=True;
//    end;
////--------------------------RevZriz2-------------------
// RevZriz3:
//    begin
//    Ns:=4;
////    FitFunction:=RevZriz3Fit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//    Xlo[0]:=1e-10; Xhi[0]:=1e30;Xmode[0]:=logar;//I01
//    Xlo[1]:=10; Xhi[1]:=1e15;Xmode[1]:=logar;//Tc
//    Xlo[2]:=1e-10; Xhi[2]:=1e10;Xmode[2]:=logar;//I02
//    Xlo[3]:=0.1; Xhi[3]:=1;Xmode[3]:=lin;//E
//    Approx.Ln.Caption:='I01 = ';
//    Approx.Ln.Visible:=True;
//    Approx.Label6.Visible:=True;
//    Approx.Label1.Caption:='Tc = ';
//    Approx.Label1.Visible:=True;
//    Approx.Label7.Visible:=True;
//    Approx.Label2.Caption:='I02 = ';
//    Approx.Label2.Visible:=True;
//    Approx.Label8.Visible:=True;
//    Approx.Label3.Caption:='E = ';
//    Approx.Label3.Visible:=True;
//    Approx.Label9.Visible:=True;
//    Approx.Label12.Visible:=False;
//    Approx.Label13.Visible:=False;
//    end;
////--------------------------RevZriz3-------------------
// Power2:
//    begin
//    Ns:=4;
////    FitFunction:=Power2Fit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//    Xlo[0]:=1e-20; Xhi[0]:=1e-10;Xmode[0]:=logar;//A1
//    Xlo[1]:=1e-5; Xhi[1]:=1e-2;Xmode[1]:=logar;//A2
//    Xlo[2]:=2; Xhi[2]:=4;Xmode[2]:=lin;//m1
//    Xlo[3]:=8; Xhi[3]:=15;Xmode[3]:=lin;//m2
//    Approx.Ln.Caption:='A1 = ';
//    Approx.Ln.Visible:=True;
//    Approx.Label6.Visible:=True;
//    Approx.Label1.Caption:='m1 = ';
//    Approx.Label1.Visible:=True;
//    Approx.Label7.Visible:=True;
//    Approx.Label2.Caption:='A2 = ';
//    Approx.Label2.Visible:=True;
//    Approx.Label8.Visible:=True;
//    Approx.Label3.Caption:='m2 = ';
//    Approx.Label3.Visible:=True;
//    Approx.Label9.Visible:=True;
//    Approx.Label12.Visible:=False;
//    Approx.Label13.Visible:=False;
//    end;
////--------------------------Power2-------------------
// Tun:
//    begin
//    Ns:=3;
////    FitFunction:=TunFit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//    Xlo[0]:=1e10; Xhi[0]:=1e20;Xmode[0]:=logar;//I0
//    Xlo[1]:=5; Xhi[1]:=15;Xmode[1]:=lin;//A
//    Xlo[2]:=0.1; Xhi[2]:=30;Xmode[2]:=lin;//B
////    Xlo[2]:=0; Xhi[2]:=30;Xmode[2]:=cons;//B
//    Approx.Ln.Caption:='I0 = ';
//    Approx.Ln.Visible:=True;
//    Approx.Label6.Visible:=True;
//    Approx.Label1.Caption:='A = ';
//    Approx.Label1.Visible:=True;
//    Approx.Label7.Visible:=True;
//    Approx.Label2.Caption:='B = ';
//    Approx.Label2.Visible:=True;
//    Approx.Label8.Visible:=True;
//    Approx.Label3.Visible:=False;
//    Approx.Label9.Visible:=False;
//    Approx.Label12.Visible:=False;
//    Approx.Label13.Visible:=False;
//    end;
////--------------------------Tun-------------------
// RevShNew:
//    begin
//    Ns:=3;
////    FitFunction:=RevShNewFit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//    Xlo[0]:=1e-15; Xhi[0]:=0.001;Xmode[0]:=logar;//I0
//    Xlo[1]:=1e-12; Xhi[1]:=1e-4;Xmode[1]:=logar; //Al
////    Xlo[2]:=2.2e-5; Xhi[2]:=1e-3;Xmode[2]:=cons;//Bt
//    Xlo[2]:=1e-6; Xhi[2]:=1e-3;Xmode[2]:=logar;//Bt
//    Approx.Ln.Caption:='I0 = ';
//    Approx.Ln.Visible:=True;
//    Approx.Label6.Visible:=True;
//    Approx.Label1.Visible:=False;
//    Approx.Label7.Visible:=False;
//    Approx.Label2.Caption:='Bt = ';
//    Approx.Label2.Visible:=True;
//    Approx.Label8.Visible:=True;
//    Approx.Label3.Caption:='Al = ';
//    Approx.Label3.Visible:=True;
//    Approx.Label9.Visible:=True;
//    Approx.Label12.Visible:=False;
//    Approx.Label13.Visible:=False;
//    end;
////--------------------------RevShNew-------------------
// RevShNew2:
//    begin
//    Ns:=5;
////    FitFunction:=RevShNew2Fit;
//    SetLength(Xmode,Ns);
//    SetLength(Xlo,Ns);
//    SetLength(Xhi,Ns);
//    Xlo[0]:=1e-15; Xhi[0]:=0.001;Xmode[0]:=logar;//I01
//    Xlo[1]:=1e-12; Xhi[1]:=1e-4;Xmode[1]:=logar; //Al1
//    Xlo[2]:=1e-6; Xhi[2]:=1e-3;Xmode[2]:=logar;//Bt
//    Xlo[3]:=1e-15; Xhi[3]:=1e-5;Xmode[3]:=logar;//I02
//    Xlo[4]:=1e-12; Xhi[4]:=1e-8;Xmode[4]:=logar; //Al2
//    Approx.Ln.Caption:='I01 = ';
//    Approx.Ln.Visible:=True;
//    Approx.Label6.Visible:=True;
//    Approx.Label1.Caption:='I02 = ';
//    Approx.Label1.Visible:=True;
//    Approx.Label7.Visible:=True;
//    Approx.Label2.Caption:='Bt = ';
//    Approx.Label2.Visible:=True;
//    Approx.Label8.Visible:=True;
//    Approx.Label3.Caption:='Al1 = ';
//    Approx.Label3.Visible:=True;
//    Approx.Label9.Visible:=True;
//    Approx.Label12.Caption:='Al2 = ';
//    Approx.Label12.Visible:=True;
//    Approx.Label13.Visible:=True;
//    end;
////--------------------------RevShNew2-------------------
// else
//   Exit;
//end;
//
//Result:=True;
//end;  // Function EvolutionBegin
//
//Procedure EvolutionShow(FuncType:TFuncType;X:TArrSingle);
//{виводить написи на форму Approximation під час апроксимації}
//begin
//case FuncType of
//      diod,photodiod:
//        begin
//        Approx.Label7.Caption:=floattostrf(X[0],ffExponent,4,3);
//        Approx.Label8.Caption:=floattostrf(X[1],ffExponent,4,3);
//        Approx.Label6.Caption:=floattostrf(X[2],ffExponent,4,3);
//        Approx.Label9.Caption:=floattostrf(X[3],ffExponent,4,3);
//        if FuncType<>diod then  Approx.Label13.Caption:=floattostrf(X[4],ffExponent,4,3);
//        end;
//       DiodTwo,DiodTwoFull,DGaus,LinEg:
//        begin
//        Approx.Label6.Caption:=floattostrf(X[0],ffExponent,4,3);
//        Approx.Label7.Caption:=floattostrf(X[1],ffExponent,4,3);
//        Approx.Label8.Caption:=floattostrf(X[2],ffExponent,4,3);
//        Approx.Label9.Caption:=floattostrf(X[3],ffExponent,4,3);
//        Approx.Label13.Caption:=floattostrf(X[4],ffExponent,4,3);
//        end;
//       DoubleDiod:
//        begin
//        Approx.Label6.Caption:=floattostrf(X[0],ffExponent,4,3);
//        Approx.Label7.Caption:=floattostrf(X[1],ffExponent,4,3);
//        Approx.Label8.Caption:=floattostrf(X[2],ffExponent,4,3);
//        Approx.Label9.Caption:=floattostrf(X[4],ffExponent,4,3);
//        Approx.Label13.Caption:=floattostrf(X[5],ffExponent,4,3);
//        end;
//       DoubleDiodLight:
//        begin
//        Approx.Label6.Caption:=floattostrf(X[0],ffExponent,4,3);
//        Approx.Label7.Caption:=floattostrf(X[1],ffExponent,4,3);
//        Approx.Label8.Caption:=floattostrf(X[2],ffExponent,4,3);
//        Approx.Label9.Caption:=floattostrf(X[4],ffExponent,4,3);
//        Approx.Label13.Caption:=floattostrf(X[6],ffExponent,4,3);
//        end;
//       RevZriz:
//        begin
//        Approx.Label6.Caption:=floattostrf(X[0],ffExponent,4,3);
//        Approx.Label7.Caption:=floattostrf(X[1],ffExponent,4,3);
//        Approx.Label8.Caption:=floattostrf(X[2],ffExponent,4,3);
//        Approx.Label9.Caption:=floattostrf(X[3],ffExponent,4,3);
//        end;
//       RevZriz2:
//        begin
//        Approx.Label6.Caption:=floattostrf(X[0],ffExponent,4,3);
//        Approx.Label7.Caption:=floattostrf(X[1],ffExponent,4,3);
// //       Approx.Label8.Caption:=floattostrf(X[4],ffExponent,4,3);
//        Approx.Label9.Caption:=floattostrf(X[2],ffExponent,4,3);
//        Approx.Label13.Caption:=floattostrf(X[3],ffExponent,4,3);
//        end;
//       RevShSCLC,RevZriz3:
//        begin
//        Approx.Label6.Caption:=floattostrf(X[0],ffExponent,4,3);
//        Approx.Label7.Caption:=floattostrf(X[1],ffExponent,4,3);
//        Approx.Label8.Caption:=floattostrf(X[2],ffExponent,4,3);
//        Approx.Label9.Caption:=floattostrf(X[3],ffExponent,4,3);
//        end;
//       RevShSCLC2,RevShNew:
//        begin
//        Approx.Label6.Caption:=floattostrf(X[0],ffExponent,4,3);
//        Approx.Label8.Caption:=floattostrf(X[2],ffExponent,4,3);
//        Approx.Label9.Caption:=floattostrf(X[1],ffExponent,4,3);
//        end;
//       RevShNew2:
//        begin
//        Approx.Label6.Caption:=floattostrf(X[0],ffExponent,4,3);
//        Approx.Label7.Caption:=floattostrf(X[3],ffExponent,4,3);
//        Approx.Label8.Caption:=floattostrf(X[2],ffExponent,4,3);
//        Approx.Label9.Caption:=floattostrf(X[1],ffExponent,4,3);
//        Approx.Label13.Caption:=floattostrf(X[4],ffExponent,4,3);
//        end;
//       RevShSCLC3:
//        begin
//        Approx.Label6.Caption:=floattostrf(X[0],ffExponent,4,3);
//        Approx.Label7.Caption:=floattostrf(X[1],ffExponent,4,3);
//        Approx.Label8.Caption:=floattostrf(X[3],ffExponent,4,3);
//        Approx.Label9.Caption:=floattostrf(X[4],ffExponent,4,3);
//        Approx.Label13.Caption:=floattostrf(X[5],ffExponent,4,3);
//        end;
//       RevShTwo,Power2:
//        begin
//        Approx.Label6.Caption:=floattostrf(X[0],ffExponent,4,3);
//        Approx.Label7.Caption:=floattostrf(X[2],ffExponent,4,3);
//        Approx.Label8.Caption:=floattostrf(X[1],ffExponent,4,3);
//        Approx.Label9.Caption:=floattostrf(X[3],ffExponent,4,3);
//        end;
//       Tun:
//        begin
//        Approx.Label6.Caption:=floattostrf(X[0],ffExponent,4,3);
//        Approx.Label7.Caption:=floattostrf(X[1],ffExponent,4,3);
//        Approx.Label8.Caption:=floattostrf(X[2],ffExponent,4,3);
//        end;
//     end;
//end;

//Procedure TLBO (V:PVector; FuncType:TFuncType; mode:byte; var Param:TArrSingle);
//{апроксимуються дані у векторі V за методом teaching learning based optimization;
//FuncType визначає апроксимуючу функцію,
//mode - уточнює режим апроксимації:
//--------------FuncType = diod
//залежнісь I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh
//Param[0] - n; Param[1] - Rs; Param[2] - I0; Param[3] - Rsh;
//mode = 0 - всі чотири параметри підбираються;
//mode = 1 - вважається, що Rsh нескінченність (1е12);
//mode = 2 - вважається, що Rs нульовий(1е-4)
//mode = 3 - Rsh нескінченність + Rs нульовий;
//--------------FuncType = photodiod
//залежнісь I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
//Param[4] - Iph, решта - див. diod
//-------------FuncType = DiodTwo
//залежнісь I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp(V/n2kT)-1]
//Param[0] - n1; Param[1] - Rs; Param[2] - I01; Param[3] - n2;Param[3] - I02;
//}
//
//  type {Classroom=array of array of double;}
//       PClassroom=^TArrArrSingle;
// label TeachLabel,LeanLabel;
//
//var X:PClassroom;
//    Fit:PTArrSingle;
//    Xmean,Xnew,Xlo,Xhi:TArrSingle;
//    i,j,Nit,Tf,k,Nmax,Nl,Ns:integer;
//    temp,r:double;
//    Xmode:TArrVar_Rand;
//    FitFunction:TFunEvolution;
//
//begin
//SetLength(Param,1);
//Param[0]:=555;
//case FuncType of
// diod:
//    begin
//    Nmax:=3000;
//    Nl:=1000;
//    end;
// photodiod:
//    begin
//    Nmax:=5000;
//    Nl:=1000;
//    end;
// DiodTwo:
//    begin
//    Nmax:=10000;
//    Nl:=1000;
//    end;
//  else Exit;
//end;
//
//Nit:=0;
//if not(EvolutionBegin(FuncType,mode,Ns,FitFunction,Xlo,Xhi,Xmode)) then Exit;
////if FuncType=diod then FitFunction:=ExpIV;
//Approx.Caption:='Teaching Learning Based Optimization';
//Approx.Label4.Caption:=inttostr(Nmax);
//
//
//SetLength(Xmean,Ns);
//SetLength(Xnew,Ns);
//
//new(X);
//SetLength(X^,Nl,Ns);
//new(Fit);
//SetLength(Fit^,Nl);
//i:=0;
//Randomize;
//repeat  //початкові випадкові значення
// for k := 0 to Ns - 1 do
//   VarRand(Xlo[k],Xhi[k],Xmode[k],X^[i,k]);
//
//{if ExpParamIsBad(V,X^[i,0],X^[i,1],X^[i,2],X^[i,3]) then Continue;
//Fit^[i]:=FitFunction(V,X^[i]);}
//   try
//    Fit^[i]:=FitFunction(V,X^[i])
//   except
//    Continue;
//   end;
//  inc(i);
//  if (i mod 25)=0 then Randomize;
//until (i>High(X^));
//
//
//Approx.Show;
//temp:=1e10;
//repeat
//
////----------Teacher phase--------------
//    for I := 0 to High(Xmean) do Xmean[i]:=0;
////    j:=MinElemNumber(Fit^);
//    j:=MaxElemNumber(Fit^);
//
//    for I := 0 to Nl-1 do
//        begin
//         for k := 0 to Ns - 1 do
//          case Xmode[k] of
//            lin:Xmean[k]:=Xmean[k]+X^[i,k];
//            logar:Xmean[k]:=Xmean[k]+ln(X^[i,k]);
//          end;
//       end;  //for I := 0 to Nl-1 do
//
//   for k := 0 to Ns - 1 do
//     case Xmode[k] of
//       lin,logar:Xmean[k]:=Xmean[k]/Nl;
//       cons:Xmean[k]:=Xlo[k];
//      end;
//
//  i:=0;
// repeat
//   if (i mod 25)=0 then Randomize;
//TeachLabel:
//    if i=j then
//      begin
//        inc(i);
//        Continue;
//      end;
//
//    r:=Random;
//    Tf:=1+Random(2);
//   for k := 0 to Ns - 1 do
//     case Xmode[k] of
//       lin:Xnew[k]:=X^[i,k]+r*(X^[j,k]-Tf*Xmean[k]);
//       logar:
//          begin
//          temp:=ln(X^[i,k])+r*(ln(X^[j,k])-Tf*Xmean[k]);
//          if temp > 88 then goto TeachLabel;
//          Xnew[k]:=exp(temp);
//          end;
//       cons:Xnew[k]:=Xlo[k];
//      end;
//
//    EvolutionControlPar(FuncType,Xmode,Xnew);
//
//{if ExpParamIsBad(V,Xnew[0],Xnew[1],Xnew[2],Xnew[3]) then Continue;
//temp:=FitFunction(V,Xnew);}
//   try
//    temp:=FitFunction(V,Xnew)
//   except
//    Continue;
//   end;
//
//   if Fit^[i]>temp then
//        begin
//        for k := 0 to High(Xnew) do X^[i,k]:=Xnew[k];
//        Fit^[i]:=temp;
//        end;
//
//   inc(i);
//   
//  until i>High(Fit^);
////showmessage(inttostr(Nit));
//
////----------Learner phase--------------
//   i:=0;
//   repeat
//    if (i mod 25)=0 then Randomize;
//LeanLabel:
//    r:=Random;
//    repeat
//    Tf:=Random(Nl);
//    until (Tf<>i);
//
//    if Fit^[i]>Fit^[Tf] then r:=-1*r;
//
//   for k := 0 to Ns - 1 do
//     case Xmode[k] of
//       lin:Xnew[k]:=X^[i,k]+r*(X^[i,k]-X^[Tf,k]);
//       logar:
//          begin
//          temp:=ln(X^[i,k])+r*(ln(X^[j,k])-ln(X^[Tf,k]));
//          if temp > 88 then goto LeanLabel;
//          Xnew[k]:=exp(temp);
//          end;
//       cons:Xnew[k]:=Xlo[k];  
//      end;//case    
//
//    EvolutionControlPar(FuncType,Xmode,Xnew);
//
//{if ExpParamIsBad(V,Xnew[0],Xnew[1],Xnew[2],Xnew[3]) then Continue;
//temp:=FitFunction(V,Xnew);}
//   try
//    temp:=FitFunction(V,Xnew)
//   except
//    Continue;
//   end;
//   if Fit^[i]>temp then
//        begin
//        for k := 0 to High(Xnew) do X^[i,k]:=Xnew[k];
//        Fit^[i]:=temp;
//        end;
//   inc(i);
// until i>High(Fit^);
//
//
//  if (Nit mod 50)=0 then
//     begin
//      j:=MinElemNumber(Fit^);
//      Approx.Label5.Caption:=Inttostr(Nit);
//      EvolutionShow(FuncType,X^[j]);
//      Application.ProcessMessages;
//     end;
//
//inc(Nit);
//until (Nit>Nmax)or not(Approx.Visible);
//
//if Approx.Visible then
//  begin
//    j:=MinElemNumber(Fit^);
//    SetLength(Param,Ns);
//    for k := 0 to Ns-1 do
//       Param[k]:=X^[j,k];
//  end;
//Approx.Close;
//
//dispose(X);
//dispose(Fit);
//
//end;
//
//Procedure DifEvol (V:PVector; FuncType:TFuncType; mode:byte; var Param:TArrSingle);
//{апроксимуються дані у векторі V за методом teaching learning based optimization;
//FuncType визначає апроксимуючу функцію,
//mode - уточнює режим апроксимації:
//--------FuncType = diod
//залежнісь I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh
//Param[0] - n; Param[1] - Rs; Param[2] - I0; Param[3] - Rsh;
//mode = 0 - всі чотири параметри підбираються;
//mode = 1 - вважається, що Rsh нескінченність (1е12);
//mode = 2 - вважається, що Rs нульовий(1е-4)
//mode = 3 - Rsh нескінченність + Rs нульовий;
//-------FuncType = photodiod
//залежнісь I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
//Param[4] - Iph, решта - див. diod
//--------FuncType = DiodTwo
//залежнісь I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp(V/n2kT)-1]
//Param[0] - n1; Param[1] - Rs; Param[2] - I01; Param[3] - n2;Param[3] - I02;
//}
// const
//      //Nmax=5000;
//      F=0.8;
//      CR=0.3;
// Label
//   MutLabel;
//
//var Xlo,Xhi,Fit,FitMut:TArrSingle;
//    Ns,Np,i,j,Nit,k,Nmax:integer;
//    X,Mut:TArrArrSingle;
//    r:array [1..3] of integer;
//    temp:double;
//    Xmode:TArrVar_Rand;
//    FitFunction:TFunEvolution;
//  //  firstpart:boolean;
//
//
//begin
//SetLength(Param,1);
//Param[0]:=555;
//Nmax:=5000;
//Nit:=0;
//if FuncType=DiodTwo then Nmax:=5000;
//if FuncType=DoubleDiod then Nmax:=30000;
//if FuncType=DoubleDiodLight then Nmax:=50000;
//if FuncType=DGaus then Nmax:=10000;
//if FuncType=RevZriz2 then Nmax:=3000;
//if FuncType=RevShSCLC then Nmax:=10000;
//if FuncType=RevShTwo then Nmax:=6000;
//if FuncType=Tun then Nmax:=10000;
////if FuncType=RevShNew then Nmax:=15000;
//
//if not(EvolutionBegin(FuncType,mode,Ns,FitFunction,Xlo,Xhi,Xmode)) then Exit;
//Approx.Caption:='Differential Evolution';
//if V^.name<>'' then Approx.Caption:=Approx.Caption+', '+V^.name;
//Approx.Label4.Caption:=inttostr(Nmax);
//
//
//Np:=Ns*8;
//SetLength(X,Np,Ns);
//SetLength(Mut,Np,Ns);
//SetLength(Fit,Np);
//SetLength(FitMut,Np);
//
//
//Randomize;
//i:=0;
//repeat  //початкові випадкові значення
// for k := 0 to Ns - 1 do
//   VarRand(Xlo[k],Xhi[k],Xmode[k],X[i,k]);
//
//{if ExpParamIsBad(V,X^[i,0],X^[i,1],X^[i,2],X^[i,3]) then Continue;
//Fit^[i]:=FitFunction(V,X^[i]);}
//   try
//    Fit[i]:=FitFunction(V,X[i])
//   except
//    Continue;
//   end;
//  inc(i);
//  if (i mod 25)=0 then Randomize;
//until (i>High(X));
//
//
//
////firstpart:=true;
//Approx.Show;
//repeat
//   i:=0;
//   repeat  //Вектор мутації
//   if (i mod 25)=0 then Randomize;
//Mutlabel:
//     for j := 1 to 3 do
//         repeat
//         r[j]:=Random(Np);
//         until (r[j]<>i);
//     for k := 0 to Ns - 1 do
//      case Xmode[k] of
//        lin:Mut[i,k]:=X[r[1],k]+F*(X[r[2],k]-X[r[3],k]);
//        logar:
//          begin
//          temp:=ln(X[r[1],k])+F*(ln(X[r[2],k])-ln(X[r[3],k]));;
//          if temp > 88 then goto Mutlabel;
//          Mut[i,k]:=exp(temp);
//          end;
//       cons:Mut[i,k]:=Xlo[k];
//      end;//case Xmode[k] of
//   EvolutionControlPar(FuncType,Xmode,Mut[i]);
//   try
//    FitFunction(V,Mut[i])
//   except
//    Continue;
//   end;
//{    if ExpParamIsBad(V,Mut[i,0],Mut[i,1],Mut[i,2],Mut[i,3]) then Continue;}
//    inc(i);
//   until (i>High(Mut));  //Вектор мутації
//
//   i:=0;
//   repeat  //Пробні вектори
//     if (i mod 25)=0 then Randomize;
//     r[2]:=Random(Ns); //randn(i)
//     for k := 0 to Ns - 1 do
//      case Xmode[k] of
//        lin,logar:
//          if (Random>CR) and (k<>r[2]) then Mut[i,k]:=X[i,k];
//      end;//case Xmode[k] of
//
//     EvolutionControlPar(FuncType,Xmode,Mut[i]);
//     try
//      FitMut[i]:=FitFunction(V,Mut[i]);
//     except
//      Continue;
//     end;
// {    if ExpParamIsBad(V,Tr[i,0],Tr[i,1],Tr[i,2],Tr[i,3]) then Continue;}
//     inc(i);
//    until i>(Np-1);
//
//for I := 0 to High(X) do
//  if Fit[i]>FitMut[i] then
//     begin
//     X[i]:=Copy(Mut[i]);
//     Fit[i]:=FitMut[i]
//     end;
//
//  if (Nit mod 100)=0 then
//     begin
//      j:=MinElemNumber(Fit);
//      Approx.Label5.Caption:=Inttostr(Nit);
//      EvolutionShow(FuncType,X[j]);
//      Application.ProcessMessages;
//     end;
//
//inc(Nit);
//{if (Nit=Nmax)and(FuncType=photodiod)and firstpart then
//begin
//if not(EvolutionBegin(FuncType,mode,Ns,FitFunction,Xlo,Xhi,Xmode,Nit)) then Exit;
//j:=MinElemNumber(Fit);
////Xlo[3]:=X[j,3];
////Xhi[3]:=X[j,3];
//Xlo[4]:=X[j,4];
//Xhi[4]:=X[j,4];
//i:=0;
//repeat  //початкові випадкові значення
// for k := 0 to Ns - 1 do
//   VarRand(Xlo[k],Xhi[k],Xmode[k],X[i,k]);
//   try
//    Fit[i]:=FitFunction(V,X[i])
//   except
//    Continue;
//   end;
//  inc(i);
//  if (i mod 25)=0 then Randomize;
//until (i>High(X));
//
//firstpart:=false;
//end;}
//
//until (Nit>Nmax)or not(Approx.Visible);
//
//if Approx.Visible then
//  begin
//    j:=MinElemNumber(Fit);
//    SetLength(Param,Ns);
//    for k := 0 to Ns-1 do
//       Param[k]:=X[j,k];
//  end;
//Approx.Close;
//end;
//
//Procedure MABC (V:PVector; FuncType:TFuncType; mode:byte; var Param:TArrSingle);
//{апроксимуються дані у векторі V за методом modified artificial bee colony;
//FuncType визначає апроксимуючу функцію,
//mode - уточнює режим апроксимації:
//--------FuncType = diod
//залежнісь I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh
//Param[0] - n; Param[1] - Rs; Param[2] - I0; Param[3] - Rsh;
//mode = 0 - всі чотири параметри підбираються;
//mode = 1 - вважається, що Rsh нескінченність (1е12);
//mode = 2 - вважається, що Rs нульовий(1е-4)
//mode = 3 - Rsh нескінченність + Rs нульовий;
//-------FuncType = photodiod
//залежнісь I=I0[exp((V-IRs)/nkT)-1]+(V-IRs)/Rsh-Iph
//Param[4] - Iph, решта - див. diod
//--------FuncType = DiodTwo
//залежнісь I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp(V/n2kT)-1]
//Param[0] - n1; Param[1] - Rs; Param[2] - I01; Param[3] - n2;Param[3] - I02;
//}
//
//
//var Xlo,Xhi,Fit,FitMut,Count,Xnew:TArrSingle;
//    Ns,Np,i,j,Nit,k,Nmax,Limit:integer;
//    X:TArrArrSingle;
//    SumFit:double;
//    Xmode:TArrVar_Rand;
//    FitFunction:TFunEvolution;
//
// Procedure NewSolution(i:integer);
// Label NewSLabel;
// var j,k:integer;
//     r,temp:double;
//     bool:boolean;
// begin
// NewSLabel:
//    repeat
//     j:=Random(Np);
//    until (j<>i);
//    r:=-1+2*Random;
//     for k := 0 to Ns - 1 do
//      case Xmode[k] of
//        lin:Xnew[k]:=X[i,k]+r*(X[i,k]-X[j,k]);
//        logar:
//          begin
//          temp:=ln(X[i,k])+r*(ln(X[i,k])-ln(X[j,k]));;
//          if temp > 88 then goto NewSLabel;
//          Xnew[k]:=exp(temp);
//          end;
//       cons:Xnew[k]:=Xlo[k];
//      end;//case Xmode[k] of
//   EvolutionControlPar(FuncType,Xmode,Xnew);
//   bool:=False;
//   try
//    FitMut[i]:=FitFunction(V,Xnew)
//   except
//    bool:=True
//   end;
//   if bool then goto NewSLabel;
//  {    if ExpParamIsBad(V,Mut[i,0],Mut[i,1],Mut[i,2],Mut[i,3]) then goto NewSLabel;}
// end; // NewSolution
//
//
//
//begin
//SetLength(Param,1);
//Param[0]:=555;
//case FuncType of
// diod:
//    Nmax:=3000;
// photodiod:
//    Nmax:=10000;
// DiodTwo,DiodTwoFull:
//    Nmax:=10000;
// DGaus,LinEg:
//    Nmax:=5000;
// DoubleDiod:
//    Nmax:=20000;
// DoubleDiodLight:
//    Nmax:=20000;
// RevZriz:
//    Nmax:=15000;
// RevShSCLC:
//  Nmax:=10000;
// RevShTwo:
//  Nmax:=3000;
// else
//   Nmax:=5000;
//end;
//
//Limit:=36;
//Nit:=0;
//
////showmessage(floattostr(V^.X[0]));
//
//if not(EvolutionBegin(FuncType,mode,Ns,FitFunction,Xlo,Xhi,Xmode)) then Exit;
//Approx.Caption:='Modified Artificial Bee Colony';
//if V^.name<>'' then Approx.Caption:=Approx.Caption+', '+V^.name;
//
//
//
//
//{if (FuncType=DiodTwoFull)or(FuncType=DiodTwo) then
// begin
//    Xlo[3]:=1+14.4/V^.T;
//    Xhi[3]:=Xlo[3];
//    Xmode[3]:=cons;//n2
//
// end;}
//
//{if (FuncType=DoubleDiod) then
// begin
//    Nmax:=3000;
//  Xlo[3]:=-12130+385.13/V^.T/Kb;
////   Xlo[3]:=2577.7;
//   Xhi[3]:=Xlo[3];   Xmode[3]:=cons;//Rsh
//
//    Xlo[1]:=0.42938+0.00492*V^.T;
////    Xlo[1]:=2.199;
//    Xhi[1]:=Xlo[1];   Xmode[1]:=cons;//Rs
//
////    Xlo[4]:=(-0.00738+1.1958*V^.T*Kb)/V^.T/Kb;
////    Xhi[4]:=Xlo[4];
////    Xmode[4]:=cons;//n2
//
// end;
//{}
//
//{if (FuncType=DoubleDiodLight) then
// begin
//    Nmax:=3000;
////    Xlo[3]:=-4343.166+171.849/V^.T/Kb;
//    Xlo[3]:=2387.11;
// Xhi[3]:=Xlo[3]; Xmode[3]:=cons;//Rsh
//
////   Xlo[1]:=4.58432-0.00797*V^.T;
//   Xlo[1]:=2.34;
//    Xhi[1]:=Xlo[1];   Xmode[1]:=cons;//Rs
//
// //   Xlo[4]:=(-0.00738+1.1958*V^.T*Kb)/V^.T/Kb;
////    Xhi[4]:=Xlo[4];
////    Xmode[4]:=cons;//n2
// end;
// {}
//
//Approx.Label4.Caption:=inttostr(Nmax);
//
//Np:=Ns*8;
//SetLength(X,Np,Ns);
//SetLength(Fit,Np);
//SetLength(Count,Np);
//SetLength(FitMut,Np);
//SetLength(Xnew,Ns);
//
//
//i:=0;
//repeat  //початкові випадкові значення
// if (i mod 25)=0 then Randomize;
// for k := 0 to Ns - 1 do
//   VarRand(Xlo[k],Xhi[k],Xmode[k],X[i,k]);
//
//{if ExpParamIsBad(V,X^[i,0],X^[i,1],X^[i,2],X^[i,3]) then Continue;
//Fit^[i]:=FitFunction(V,X^[i]);}
//   try
//    Fit[i]:=FitFunction(V,X[i])
//   except
//    Continue;
//   end;
//  Count[i]:=0;
//  inc(i);
//until (i>High(X));
//
//Approx.Show;
//repeat
//   i:=0;
//   repeat  //Employed bee
//   if (i mod 25)=0 then Randomize;
//    NewSolution(i);
//        if Fit[i]>FitMut[i] then
//     begin
//     X[i]:=Copy(Xnew);
//     Fit[i]:=FitMut[i];
//     Count[i]:=0;
//     end
//                   else
//     Count[i]:=Count[i]+1;
//    inc(i);
//   until (i>(Np-1));  //Employed bee
//
//
//   SumFit:=0;   //Onlookers bee
//   for I := 0 to Np - 1 do
//     SumFit:=SumFit+1/(1+Fit[i]);
//
//   i:=0;//номер   Onlookers bee
//   j:=0; // номер джерела меду
// repeat
//     if (i mod 25)=0 then Randomize;
//    if Random<1/(1+Fit[j])/SumFit then
//      begin
//        i:=i+1;
//        NewSolution(j);
//        if Fit[j]>FitMut[j] then
//         begin
//         X[j]:=Copy(Xnew);
//         Fit[j]:=FitMut[j];
//         Count[j]:=0;
//         end
//     end;    // if Random<1/(1+Fit[j])/SumFit then
//    j:=j+1;
//    if j=Np then j:=0;
// until(i=Np);     //Onlookers bee
//
//   i:=0;
//   repeat   //scout
//   if (i mod 25)=0 then Randomize;
//{}   j:=MinElemNumber(Fit);
//   if (Count[i]>Limit){}and(i<>j){} then
//    begin
//      for k := 0 to Ns - 1 do
//         VarRand(Xlo[k],Xhi[k],Xmode[k],X[i,k]);
//     try
//      Fit[i]:=FitFunction(V,X[i])
//     except
//      Continue;
//     end;
//     Count[i]:=0;
//    end;// if Count[i]>Limit then
//    inc(i);
//    until i>(Np-1);//scout
//
//  if (Nit mod 100)=0 then
//     begin
//      j:=MinElemNumber(Fit);
//      Approx.Label5.Caption:=Inttostr(Nit);
//      EvolutionShow(FuncType,X[j]);
//      Application.ProcessMessages;
//     end;
//
//inc(Nit);
//until (Nit>Nmax)or not(Approx.Visible);
//
//if Approx.Visible then
//  begin
//    j:=MinElemNumber(Fit);
//    SetLength(Param,Ns);
//    for k := 0 to Ns-1 do
//       Param[k]:=X[j,k];
//  // showmessage(floattostr(Fit[j]));
//   end;
//Approx.Close;
//end;


Procedure DataFileWrite(fname:string;Vax:PVector;Param:TArrSingle);
var 
    Str:TStringList;
    Voc,Isc:double;
    FileHandle:integer;
begin
if not(FileExists(fname)) then
  begin
    FileHandle:=FileCreate(fname);
    FileClose(FileHandle);
  end;
Voc:=Voc_Isc_Pm_DoubleDiod(1,Param[0]*Kb*Vax^.T,Param[4]*Kb*Vax^.T,
               Param[1],Param[2],Param[5],Param[3],Param[6]);
Isc:=Voc_Isc_Pm_DoubleDiod(2,Param[0]*Kb*Vax^.T,Param[4]*Kb*Vax^.T,
               Param[1],Param[2],Param[5],Param[3],Param[6]);

Str:=TStringList.Create;
Str.LoadFromFile(fname);
Str.Add(Vax^.name+' T='+FloatToStrF(Vax^.T, ffGeneral, 4, 1)+
        ' Voc='+ FloatToStrF(Voc,ffGeneral,4,3)+
        ' Isc='+FloatToStrF(Isc,ffGeneral,4,3));
Str.SaveToFile(fname);
Str.Free;
end;


end.
