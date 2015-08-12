unit OlegMath;

interface
 uses OlegType, Dialogs, SysUtils, Math, Classes;

Type FunBool=Function(V:PVector;n0,Rs0,I00,Rsh0:double):boolean;

Procedure Swap (var A:integer; var B:integer); overload;
{процедура обміну значеннями між цілими змінними А та В}

procedure Swap(var A:double; var B:double); overload;
{процедура обміну значеннями між дійсними змінними А та В}

procedure Swap(var A:real; var B:real); overload;
{процедура обміну значеннями між дійсними змінними А та В}

procedure Swap(var A:Pvector; var B:Pvector); overload;
{процедура обміну значеннями між векторами, на які вказують А та В}

Function Poh(A:PVector; k:integer):double;
{знаходження похідної від функції, яка записана
в масиві А в точці з індексом k}

Procedure LinAprox (V:PVector; var a,b:double);
{апроксимуються дані у векторі V лінійною
залежністю y=a+b*x}

Procedure LinAproxBconst (V:PVector; var a:double; b:double);
{апроксимуються дані у векторі V лінійною
залежністю y=a+b*x;
параметр b вважається відомим}

Procedure LinAproxAconst (V:PVector; a:double; var b:double);
{апроксимуються дані у векторі V лінійною
залежністю y=a+b*x;
параметр a вважається відомим}


Procedure ParabAprox (V:Pvector; var a,b,c:double);
{апроксимуються дані у векторі V параболічною
залежністю y=a+b*x+с*x2}

Procedure GromovAprox (V:PVector; var a,b,c:double);
{апроксимуються дані у векторі V
залежністю y=a+b*x+c*ln(x)}

Procedure ExpAprox (V:PVector; var I0,E:double);
{апроксимуються дані у векторі V
залежністю I=I0[exp(V/E0)-1]
за методом найменших квадратів зі
статистичними ваговими коефіцієнтами}

Procedure ExpRshAprox (V:PVector; var I0,E,Rsh:double);
{апроксимуються дані у векторі V
залежністю I=I0[exp(V/E0)-1]+V/Rsh
за методом найменших квадратів зі
статистичними ваговими коефіцієнтами}


Procedure GausGol(var R:PSysEquation);
{процедура розв'язку системи лінійних рівнянь
методом Гауса з вибором головного елементу;
всі параметри рівняння, як і розв'язки, - в R}

Procedure Gaus (bool:boolean; Nrr:integer; a:IRE2; b:IRE; var x:IRE);
{розв'зок системи лнйних рівнянь методом Гауса
Nr - кількість рівнянь (розмірність системи)
a - матриця коефіцієтів
b - вектор вільних членів
x - вектор невідомих (розв'язків)
bool з'явилась при удосконаленні програми для апроксимації
експонентою, для реалізації можливості апроксимації при
різноманітті сталих параметрів. переробляти алгоритм
щоб зняти цю заплатку не хочеться}

Procedure Newts(Nr:integer; AV:Pvector; eps:real; Xp:IRE; var Xr:IRE; var rez:integer);
{процедура апроксимації даних в А за формулою y=I0(exp(x/E)-1)+x/R
за методом найменших квадратів зі статистичними
ваговими коефіцієнтами;
фактично в цій процедурі виконується
розв'язок системи нелінійних рівнянь методом Ньютона,
коефіцієнти рівнянь отримуються за допомогою
різних допоміжних функцій, явний вигляд яких
отриманий вручну.

Nr   - константа вибору режиму апроксимації:
Nr=1 - вважається, що E=const (рівний значенню у
       векторі початкових наближень, Xp[3]),
       R=const (=1e12 Ом, нескінченно великий шунтуючий опір),
       тобто фактично знаходиться лише величина І0;
Nr=2 - E=const, знаходяться І0 та R;
Nr=3 - вар'юються всі три параметри (найбільш
       загальний випадок);
Nr=4 - R=const (1e12 Ом), знаходиться величина Е та І0

eps  - параметр, не більше якого має бути відносна
       зміна І0 в сусідніх ітераціях (критерій припинення
       процесу)

Хр   - вектор початкових наближень

Хr   - вектор, куди заносяться результати

rez=0 - вдалося підібрати параметри
rez=-1 - аппроксимувати не вдалося}

Function Newton(A:Pvector; funF:TFun1D; funG:TFun2D;
                ParF:array of double; ParG:array of double;
                eps:real; Nmax:integer;
                var X0:array of double;var ErStr:string):word;
{Розв'язок системи рівнянь методом Ньютона,
F - функція, яка повертає масив значень функцій
    цієї системи;
G - функція, яка повертає масив значень якобіану
    функцій цієї системи;
ParF - масив параметрів, які використовуються
     у функції F;
ParG - масив параметрів, які використовуються
     у функції G;
A - масив даних, які використовуються при
    побудові функцій F та G;
eps - відносна точність, на яку не повинні
    відрізнятися розв'язки на двох сусудніх
    кроках, щоб можна було припинити ітераційний
    процес;
Nmax - максимальне число ітерацій;
Х0 - вектор початкових наближень, в нього ж
    розміщується результат;
ErStr - рядок, де розміщено опис помилки;
При вдалому закінченні
функція повертає 0;
ErStr='';
в Х0 - розв'язки;
При невдалому закінченні
функція повертає 1;
ErStr не нульовий;
в Х0 - 555;
}

Function SpeedSlalom(AP:Pvector; funF:TFun1D; ParF:array of double;
                eps:real; Nmax:integer;
                var X0:array of double;var ErStr:string):word;
{Розв'язок системи рівнянь методом найшвидшлго спуску,
F :TFun1D=Function(A:Pvector; Variab:array of double;
                  Param:array of double;
                  var Rez:array of double):word;
- функція, яка повертає в масиві Rez значень величини
Rez[0]- значення функціоналу, який визначається
 сумою квадратів рівнянь, які входять до системи;
Rez[1]... - значення похідних від функціоналу по різним
змінним

ParF - масив параметрів, які використовуються
     у функції F;
A - масив даних, які використовуються при
    побудові функції F;
eps - відносна точність, на яку не повинні
    відрізнятися розв'язки на двох сусудніх
    кроках, щоб можна було припинити ітераційний
    процес;
Nmax - максимальне число ітерацій;
Х0 - вектор початкових наближень, в нього ж
    розміщується результат;
ErStr - рядок, де розміщено опис помилки;
При вдалому закінченні
функція повертає 0;
ErStr='';
в Х0 - розв'язки;
При невдалому закінченні
функція повертає 1;
ErStr не нульовий;
в Х0 - 555;
}

Function SpSlExpRsh(AP:Pvector; Variab:array of double;
                     Param:array of double;
                     var Rez:array of double):word;
{функція, потрібна для проведення апроксимації
залежності в А функцією I=I0[exp(V/E0)-1]+V/Rsh;
надалі ця функція використовується у розв'язку
системи рівнянь методом найшвидшого спуску
Variab[0]=I0;
Variab[1]=E;
Variab[2]=Rsh;
Rez[0] - функціонал, який є сумою квадратів
умов мінімізації квадратичної форми;
Rez[1(2,3)] - значення похідної функціоналу
по змінній І0 (Е,Rsh) при значеннях, записаних
в  Variab
}


Function F_Exp(AP:Pvector; Variab:array of double;
                     Param:array of double;
                     var Rez:array of double):word;
{функція, потрібна для проведення апроксимації даних в А
функцією I=I0[exp(V/E0)-1] за допомогою методу Ньютона
(правильніше - апроксимація за методом найменших квадратів, але
розв'язок системи рівнянь за методом Ньютона;
повертає в Rez значення функцій, які є умовою мінімізації
квадратичної форми;
Param - в даному випадку не використовується,
при виклиці просто пустий масив}

Function G_Exp(AP:Pvector; Variab:array of double;
                  Param:array of double;
                  var Rez:T2DArray):word;
{функція, потрібна для проведення апроксимації даних в А
функцією I=I0[exp(V/E0)-1] за допомогою методу Ньютона
(правильніше - апроксимація за методом найменших квадратів, але
розв'язок системи рівнянь за методом Ньютона;
повертає в Rez значення якобіану функцій, які є умовою мінімізації
квадратичної форми;
Param - в даному випадку не використовується,
при виклиці просто пустий масив}

Function F_ExpRsh(AP:Pvector; Variab:array of double;
                     Param:array of double;
                     var Rez:array of double):word;

Function G_ExpRsh(AP:Pvector; Variab:array of double;
                  Param:array of double;
                  var Rez:T2DArray):word;

//Function LamParamIsBad(V:PVector;n0,Rs0,I00,Rsh0:double):boolean;
//{перевіряє чи параметри можна використовувати для
//апроксимації даних в V aфункцією Ламверта}

{Function LamParamCorect(V:PVector;var n0,Rs0,I00,Rsh0:double):boolean;}
{коректує значення параметрів, які використовуються
для апроксимації даних в V функцією Ламверта;
якщо коректування все ж невдале, то
повертається false}

//Function ParamCorect(V:PVector;Fun:Funbool;var n0,Rs0,I00,Rsh0:double):boolean;overload;
//{коректує значення параметрів, які використовуються
//для апроксимації ΒΑΧ в V;
//для різних апроксимаційних функцій
//використовуються різні функції Fun,
//які саме і перевіряють можливість використання параметрів,
//наприклад для апроксимації функцією Ламберта
//використовується функція LamParamIsBad  тощо...;
//якщо коректування все ж невдале, то
//повертається false}

//Function ParamCorect(V:PVector;var n0,Rs0,Rsh0,Isc,Voc:double):boolean;overload;
//{для корекції параметрів, які використовуються
//для апроксимації ΒΑΧ при освітленні в V;
//}


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

//Function FG_LamShot(AP:Pvector; Variab:array of double;
//                  var RezSum:double):word;overload;
//{на відміну від попередньої, розраховується
//лише значення квадратичної форми}

//Function aSdal_LamShot(AP:Pvector;num:word;al,F,n,Rs,I0,Rsh:double):double;
//{розраховується значення похідної квадратичної форми
//яка виникає при апроксимації ВАХ функцією
//Ламберта;
//ця функція використовується при
//покоординатному спуску і обчислюється
//похідна по al, яка описує зміну
//того чи іншого параметра апроксимації
//Param = Param - al*F,
//де  Param = n  при num = 0
//Param = Rs при num = 1
//Param = I0 при num = 2
//Param = Rsh при num = 3
//F - значення похідної квадритичної
//форми по Param при al = 0
//(те, що повертає функція FG_LamShot в RezF)
//}

//Function ExpParamIsBad(V:PVector;n,Rs,I0,Rsh:double):boolean;overload;
//{перевіряє чи параметри можна використовувати для
//апроксимації даних в V функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh}
//
//Function ExpParamIsBad(V:PVector;n,Rs,I0,Rsh,Iph:double):boolean;overload;
//{перевіряє чи параметри можна використовувати для
//апроксимації даних в V функцією
//I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh-Iph-Iph}

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

//Function FG_ExpShot(AP:Pvector; Variab:array of double;
//                  var RezSum:double):word;overload;
//{функція для апроксимації ВАХ
//функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh
//за МНК; АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//цей масив містить 4 значення, n, Rs, I0, Rsh;
//RezSum - значення квадратичної форми}

//Function ExpIV(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - n;
//Variab[1] - Rs;
//Variab[2] - I0;
//Variab[3] - Rsh}
//
//Function ExpIVLong(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - n;
//Variab[1] - Rs;
//Variab[2] - I0;
//Variab[3] - Rsh}

//Function ExpIVLight(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh-Iph
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - n;
//Variab[1] - Rs;
//Variab[2] - I0;
//Variab[3] - Rsh
//Variab[4] - Iph}
//
//Function ExpIVLight_Shot(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh-Iph
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - n;
//Variab[1] - Rs;
//Variab[2] - I0;
//Variab[3] - Rsh
//Variab[4] - Iph;
//розрахунок проводиться лише для половини точок}
//

//Function Exp2(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//при апроксимації формулою
//I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp(V/n2kT)-1]
//Variab - значення параметрів, очікується, що
//Variab[0] - n1;
//Variab[1] - Rs1;
//Variab[2] - I01;
//Variab[3] - n2;
//Variab[4] - I02}

//Function Exp2Full(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//при апроксимації формулою
//I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp((V-IRs2)/n2kT)-1]
//Variab - значення параметрів, очікується, що
//Variab[0] - n1;
//Variab[1] - Rs1;
//Variab[2] - I01;
//Variab[3] - n2;
//Variab[4] - I02;
//Variab[5] - Rs2;
//}

//Function DbGausFit(AP:Pvector; Variab:array of double):double;

//Function DbGaus(T,A1,Fb10,sig1,Fb20,sig2:double):double;

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


//Function aSdal_ExpShot(AP:Pvector;num:word;al,F,n,Rs,I0,Rsh:double):double;
//{розраховується значення похідної квадратичної форми
//яка виникає при апроксимації ВАХ функцією
//I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh;
//ця функція використовується при
//покоординатному спуску і обчислюється
//похідна по al, яка описує зміну
//того чи іншого параметра апроксимації
//Param = Param - al*F,
//де  Param = n  при num = 0
//Param = Rs при num = 1
//Param = I0 при num = 2
//Param = Rsh при num = 3
//F - значення похідної квадритичної
//форми по Param при al = 0
//(те, що повертає функція FG_ExpShot в RezF)
//}

//Function aSdal_ExpLightShot(AP:Pvector;num:word;al,F,n,Rs,I0,Rsh,Iph:double):double;
//{розраховується значення похідної квадратичної форми
//яка виникає при апроксимації ВАХ функцією
//I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh-Iph;
//ця функція використовується при
//покоординатному спуску і обчислюється
//похідна по al, яка описує зміну
//того чи іншого параметра апроксимації
//Param = Param - al*F,
//де  Param = n  при num = 0
//Param = Rs при num = 1
//Param = I0 при num = 2
//Param = Rsh при num = 3
//Param = Iph при num = 4
//F - значення похідної квадритичної
//форми по Param при al = 0
//(те, що повертає функція FG_ExpLightShot в RezF)
//}


//Function LamLightParamIsBad(V:PVector;n0,Rs0,Rsh0,Isc0,Voc0:double):boolean;
//{перевіряє чи параметри можна використовувати для
//апроксимації ВАХ при освітленні в V функцію Ламверта}

//Function FG_LamLightShot(AP:Pvector; n,Rs,Rsh,Isc,Voc:double;
//                  var RezF:array of double;
//                  var RezSum:double):word;
//{функція для апроксимації ВАХ при освітленні
//функцією Ламбертаза МНК;
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//цей масив містить 5 значеннь,
//Variab[0] - n,
//Variab[1] - Rs,
//Variab[2] -  Rsh,
//Variab[3] -  Isc,
//Variab[4] - Voc;
//RezF - значення функцій, отриманих як похідні
//від квадратичної форми;
//RezF[0] - похідна по n,
//RezF[1] - похідна по Rs,
//RezF[2] - похідна по Rsh,
//RezSum - значення квадратичної форми}

//Function aSdal_LamLightShot(AP:Pvector;num:word;al,F,n,Rs,Rsh,Isc,Voc:double):double;
//{розраховується значення похідної квадратичної форми
//яка виникає при апроксимації ВАХ при освітленні
//функцією Ламберта;
//ця функція використовується при
//покоординатному спуску і обчислюється
//похідна по al, яка описує зміну
//того чи іншого параметра апроксимації
//Param = Param - al*F,
//де  Param = n  при num = 0
//Param = Rs при num = 1
//Param = Rsh при num = 2
//F - значення похідної квадритичної
//форми по Param при al = 0
//(те, що повертає функція FG_LamLightShot в RezF)
//}

Procedure Smoothing (A:Pvector; var B:PVector);
{в В розміщується сглажена функція даних в А;
а саме проводиться усереднення по трьом точкам,
причому усереднення з ваговими коефіцієнтами,
які визначаються розподілом Гауса з дисперсією 0.6;
якщо у вихідному масиві кількість точок менша трьох,
то у результуючому буде нульова кількість}

Procedure Median (A:Pvector; var B:PVector);
{в В розміщується результат дії на дані в А
медіанного трьохточкового фільтра;
якщо у вихідному масиві кількість точок менша трьох,
то у результуючому буде нульова кількість}

Procedure Diferen (A:Pvector; var B:PVector);
{в В розміщується похідна від значень, розташованих
у векторі А;
якщо у вихідному масиві кількість точок менша трьох,
то у результуючому буде нульова кількість}

Function Lagrang(A:Pvector; x:double):double;
{функція розрахунку значення функції в точці х використовуючи
поліном Лагранжа, побудований на основі набору даних в масиві A}

Function Splain3(V:Pvector; x:double):double;
{функція розрахунку значення функції в точці х використовуючи
кубічні сплайни, побудовані на основі набору даних в масиві V
Result=Ai+Bi(X-Xi)+Ci(X-Xi)^2+Di(X-Xi)^3 при Xi-1<=X<=Xi}

Procedure Splain3Vec(V:Pvector; beg:double; step:double; var Rez:Pvector);
{розраховується інтерполяція даних у векторі V з
використанням кубічних сплайнів, починаючи з точки з координатою
beg і з кроком step;
результат заноситься в Rez;
якщо почак вибрано неправильно (не потрапляє в діапазон зміни
абсциси V, то в результуючому векторі довжина нульова}


Function Int_Trap(A:Pvector):double;
{повертає результат інтегрування за методом
трапецій по даним з масиву А;
вважається, що межі інтегралу простягаються на
весь діапазон зміни А^.X}

Function GoldenSection(fun:TFunSingle; a, b:double):double;
{повертає координату мінімума функції fun
на відрізку [a,b], вважається,
що там лише один мінімум;
використовується метод золотого перерізу}

Function Lambert(x:double):double;
{обчислює значення функції Ламберта}

Procedure LambertIV (A:Pvector; n,Rs,I0,Rsh:double; var B:PVector);
{в В розміщується результат розрахунку
ВАХ по даним напруги з А за допомогою
функції Ламберта по значеннях параметрів n,Rs,I0,Rsh}

Function LambertAprShot(V,E,Rs,I0,Rsh:double):double;
{розраховує апроксимацію ВАХ при напрузі V
за функцією Ламверта по значеннях параметрів Е,Rs,I0,Rsh,
Е=KbTn/q, використовується спрошений варіант,
справедливий для Rs<<Rsh}

Function LambertLightAprShot (V,E,Rs,I0,Rsh,Iph:double):double;
{розраховує апроксимацію освітленої ВАХ при напрузі V
за функцією Ламверта по значеннях параметрів Е,Rs,I0,Rsh,Iph
Е=KbTn/q}

Function Full_IV(V,E,Rs,I0,Rsh,Iph:double):double;
{розраховує значення функції
I=I0*[exp(q(V-I Rs)/E)-1]+(V-I Rs)/Rsh-Iph)}

Function Full_IV_A(V,E,Rs,I0,Rsh,Iph:double):double;

Function Full_IV_2Exp(V,E1,E2,Rs,I01,I02,Rsh,Iph:double):double;
{розраховує значення функції
I=I01*[exp(q(V-I Rs)/E1)-1]+I02*[exp(q(V-I Rs)/E2)-1]+(V-I Rs)/Rsh-Iph)}


//Procedure VarRand(Xlo,Xhi:double; mode:TVar_Rand; var X:double);
//{випадковим чином задає значення змінної Х в діапазоні
//від Xlo до Xhi}

Function MaxElemNumber(a:array of double):integer;
{повертає номер найбільшого елементу масиву}

Function MinElemNumber(a:array of double):integer;
{повертає номер наменшого елементу масиву}

//Function DoubleDiodFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]+(V-IRs)/Rsh
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - n1;
//Variab[1] - Rs;
//Variab[2] - I01;
//Variab[3] - Rsh
//Variab[4] - n2
//Variab[5] - I02;
//}

//Function LinEgF(x:double;Variab:array of double):double;
//
//
//Function LinEgFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації  Fb0-7.021e-4*x^2/(1108+x)-Kb*x ln fp
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - Fb0;
//Variab[1] - fp;
//}

//Function DoubleDiodLightFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]
//         +(V-IRs)/Rsh-Iph
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - n1;
//Variab[1] - Rs;
//Variab[2] - I01;
//Variab[3] - Rsh
//Variab[4] - n2
//Variab[5] - I02;
//Variab[6] - Iph;
//}

Function RevZrizFun(x,m,I0,E:double):double;
{функція I=I0*T^m*exp(-E/kT);
проте вважається, що x=1/kT
}

Function RevZrizSCLC(x,m,I0,A:double):double;
{функція I=I0*(T^m)*A^(300/T);
проте вважається, що x=1/kT
}

//Function RevZrizFitFun(x:double;Variab:array of double):double;
//
//
//Function RevZrizFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації  I01*T^(-Tpow)*exp(-E1/kT)+I02*T^2*exp(-E2/kT)
//Tpow - константа з модуля OlegType
//залежності від (kT)-1
//   I01*(x*k)^Tpow*exp(-E1*x)+I02/(x*k)^2*exp(-E2*x)
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - I10;
//Variab[1] - E1;
//Variab[2] - I20;
//Variab[3] - E2;
//}

//Function RevShSCLCFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I01*V^m+I02*exp(A*Em/kT)
//АР - виміряні точки;
//Em - максимальне поле
//Variab - значення параметрів, очікується, що
//Variab[0] - I01;
//Variab[1] - m;
//Variab[2] - A;
//Variab[3] - I02;
//}

//Function RevShSCLC2Fit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I01*(V^m1+a*V^m2)+I02*exp(A*Em/kT)*(1-exp(-eV/kT))
//m1=1+326.4/T;
//m2=1+1020/T;
//a=0.2591;
//АР - виміряні точки;
//Em - максимальне поле
//Variab - значення параметрів, очікується, що
//Variab[0] - I01;
//Variab[1] - I02;
//Variab[2] - A;
//}


//Function RevShSCLC3Fit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I01*V^m1+I02*V^m2+I03*exp(A*Em/kT)*(1-exp(-eV/kT))
//АР - виміряні точки;
//Em - максимальне поле
//Variab - значення параметрів, очікується, що
//Variab[0] - I01;
//Variab[1] - m1;
//Variab[2] - I02;
//Variab[3] - m2;
//Variab[4] - I03;
//Variab[5] - A;
//}

//Procedure CreateFile(name:string;Vax:PVector;Param:TArrSingle);
//{функція для створення файлу з даними, наприклад, апроксимаційними }

//Function RevShTwoFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I01*exp(A1*Em/kT)V^m+I02*exp(A2*Em/kT)
//АР - виміряні точки;
//Em - максимальне поле
//Variab - значення параметрів, очікується, що
//Variab[0] - I01;
//Variab[1] - I02;
//Variab[2] - A1;
//Variab[3] - A2;
//}

//Function RevShFun(x,T,I0,Al:double):double;
//{розраховується функція
//I=I01*exp(Al*Em)*(1-exp(-x/kT))
//де Em - електричне поле
//на межі метал-напівпровідник;
//}

//Function RevShNewFun(x,T,I0,Al,Bt:double):double;
//{розраховується функція
//I=I0*exp(Al*Em+Bt*Em^0.5)*(1-exp(-x/kT))
//де Em - електричне поле
//на межі метал-напівпровідник;
//}

//Function RevShNewFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//I=I0*exp(Al*Em+Bt*Em^0.5)*(1-exp(-x/kT))
//АР - виміряні точки;
//Em - максимальне поле
//Variab - значення параметрів, очікується, що
//Variab[0] - I0;
//Variab[1] - Al;
//Variab[2] - Bt;
//}

//Function RevShNew2Fit(AP:Pvector; Variab:array of double):double;

//Function RevShTwoFun(x,T:double; Variab:array of double):double;
//{розраховується
//функціz I01*exp(A1*Em/kT)V^m+I02*exp(A2*Em/kT)
//Em - максимальне поле
//Variab - значення параметрів, очікується, що
//Variab[0] - I01;
//Variab[1] - I02;
//Variab[2] - A1;
//Variab[3] - A2;
//}

//Function RevZriz2Fit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації  I01*T^(-Tpow)*B^(-Tc/T)+I02*T^2*exp(-E/kT)
//Tpow - константа з модуля OlegType
//залежності від x=1/(kT)
//   I01*(x*k)^Tpow*B^(Tc*x*k)+I02/(x*k)^2*exp(-E*x)
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - I10;
//Variab[1] - B;
//Variab[4] - Tc;
//Variab[2] - I20;
//Variab[3] - E;
//}

//Function Power2Fit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації  A1(x^m1+A2*x^m2)
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - A1;
//Variab[1] - A2;
//Variab[2] - m1;
//Variab[3] - m2;
//}

//Function RevZriz3Fit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації  I01*exp(-(Tc/T)^0.25)+I02*T^2*exp(-E/kT)
//залежності від x=1/(kT)
//   I01*exp(-(Tc*k*x)^0.25)+I02/(x*k)^2*exp(-E*x)
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - I10;
//Variab[1] - Tc;
//Variab[2] - I02;
//Variab[3] - E;
//}

Function TunFun(x:double; Variab:array of double):double;

//Function TunFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації  I0*exp(-A*(B+x)^0.5)
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - I0;
//Variab[1] - A;
//Variab[2] - B;
//}

Function RandomAB(A,B:double):double;
{повертає випадкове число в межах від А до В}

Function RandomLnAB(A,B:double):double;
{повертає випадкове число в межах від А до В,
розподіляючи логарифми чисел - використовується у випадку,
коли А та В дуже відмінні}

Function ValueToStr555(Value:double):string; overload;
{перетворює Value в рядок, якщо Value=555,
то результатом є порожній рядок}

Function ValueToStr555(Value:integer):string; overload;
{перетворює Value в рядок, якщо Value=555,
то результатом є порожній рядок}

Function StrToFloat555(Value:string):double;
{перетворює Value в дійсне число,
якщо перетворення невдале
(рядок порожній тощо), то
результат дорівнює 555}

Function StrToInt555(Value:string):integer;
{перетворює Value в дійсне число,
якщо перетворення невдале
(рядок порожній тощо), то
результат дорівнює 555}

Function NumberMax(A:Pvector):integer;
{обчислюється кількість локальних
максимумів у векторі А;
дані мають бути упорядковані по координаті X}


Function Rs_T(T:double):double;
Function Fb_T(T:double):double;
Function n_T(T:double):double;


Function GromovDistance(Xa,Ya,C0,C1,C2:double):double;
{відстань від точки (Ха,Ya) до кривої С0+C1*x+C2*ln(x)}

implementation

procedure Swap(var A:integer; var B:integer);  overload;
{процедура обміну значеннями між цілими змінними А та В}
  var C:integer;
begin
  C:=A; A:=B; B:=C;
end;

procedure Swap(var A:double; var B:double); overload;
{процедура обміну значеннями між дійсними змінними А та В}
  var C:double;
begin
  C:=A; A:=B; B:=C;
end;

procedure Swap(var A:real; var B:real); overload;
{процедура обміну значеннями між дійсними змінними А та В}
  var C:real;
begin
  C:=A; A:=B; B:=C;
end;

procedure Swap(var A:Pvector; var B:Pvector); overload;
{процедура обміну значеннями між векторами, на які вказують А та В}
  var C:Pvector;
      i:integer;
begin
  new(C);
  C^.n:=A^.n;
  C^.name:=A^.name;
  C^.T:=A^.T;
  C^.time:=A^.time;
  C^.N_begin:=A^.N_begin;
  C^.N_end:=A^.N_end;
  SetLength(C^.X,C^.n);
  SetLength(C^.Y,C^.n);
  for i:=0 to High(C^.X) do
    begin
    C^.X[i]:=A^.X[i];
    C^.Y[i]:=A^.Y[i];
    end;

  A^.n:=B^.n;
  A^.name:=B^.name;
  A^.T:=B^.T;
  A^.time:=B^.time;
  A^.N_begin:=B^.N_begin;
  A^.N_end:=B^.N_end;
  SetLength(A^.X,A^.n);
  SetLength(A^.Y,A^.n);
  for i:=0 to High(A^.X) do
    begin
    A^.X[i]:=B^.X[i];
    A^.Y[i]:=B^.Y[i];
    end;

  B^.n:=C^.n;
  B^.name:=C^.name;
  B^.T:=C^.T;
  B^.time:=C^.time;
  B^.N_begin:=C^.N_begin;
  B^.N_end:=C^.N_end;
  SetLength(B^.X,B^.n);
  SetLength(B^.Y,B^.n);
  for i:=0 to High(B^.X) do
    begin
    B^.X[i]:=C^.X[i];
    B^.Y[i]:=C^.Y[i];
    end;
  dispose(C);
end;

Function Poh (A:PVector; k:integer):double;

  Function PohPol(x,x1,x2,x3,y1,y2,y3:double):double;
  {допоміжна функція для знаходження похідної -
  похідна від поліному Лагранжа, проведеного через
  три точки}
    begin
    Result:=y1*(2*x-x2-x3)/(x1-x2)/(x1-x3)+y2*(2*x-x1-x3)/(x2-x1)/(x2-x3)+y3*(2*x-x1-x2)/(x3-x1)/(x3-x2);
    end;

  Procedure NextPoint(i1,i2:integer;F1, F:double; A:PVector;
            var x:double; var y:double; var Inext:integer);
  {процедура пошуку в масиві A такої точки (в діапазоні номерів
  від і1 до, максимум, i2), значення ординати якої за модулем
  не менше від F на  0,01% і присвоєння змінним х та у координат
  цієї точки, а Inext - номера. Якщо такої точки не знайшлося,
  то змінній х присвоюється ординати точки з номером і2,
  змінній у - число на 0.001% більше за модулем ніж F, Inext - i2.
  i2 не обов'язково має бути більшим за і1.
  Головна мета цієї функції - виключити можливість, коли
  похідна дорівнює нулеві  }
  var i:integer;
      bool:boolean;
      c:double;

  begin
   bool:=True;
   if i2>=i1 then i:=i1-1
             else i:=i1+1;

   repeat
     if i2>=i1 then i:=i+1
               else i:=i-1;

     if F=0 then c:=(F-A^.Y[i])/A^.Y[i]
            else c:=(F-A^.Y[i])/F;
     if (F=0) and (A^.Y[i]=0) then Continue;

     if (abs(c)>1e-4)and(F1<>A^.X[i]) then
           begin
            x:=A^.X[i];
            y:=A^.Y[i];
            Inext:=i;
            bool:=False;
            break;
           end;
    until (i=i2);
   if bool then
           begin
            x:=A^.X[i2];
            y:=F+F*1e-5;
            Inext:=i2;
           end;
  end;   //NextPoint

  Function RunRom(x1,x2,x3,y1,y2,y3:double):double;
 {функція розрахунку похідної по трьом точкам
 за методом Рунге-Ромберга}
var f1,f2,h1,h2:double;
 begin
 h1:=x2-x1;
 h2:=x3-x1;
 f1:=(y2-y1)/h1;
 f2:=(y3-y1)/h2;
 Result:=(f1*h2-f2*h1)/(h2-h1);
 end;

 Function PohLagr (A:PVector; x:double):double;
{функція розрахунку в точці х
похідної від поліному Лагранжа, побудованого
по всім точкам з А}
 var i,j,k:word;
     t1,t2,t3,t4:double;
  begin
   Result:=555;
   if (x-A^.X[High(A^.X)])*(x-A^.X[0])>0 then Exit;
   t1:=0;
   for i:=0 to High(A^.X) do
     begin
       t2:=1;
       t3:=0;
       for j:=0 to High(A^.X) do
         if (j<>i) then
          begin
          t2:=t2*(A^.X[i]-A^.X[j]);
          t4:=1;
          for k:=0 to High(A^.X) do
           if (k<>j)and(k<>i) then t4:=t4*(x-A^.X[k]);
          t3:=t3+t4;
          end;  //for j:=0 to High(A^.X) do
     t1:=t1+A^.Y[i]*t3/t2;
     end;
  Result:=t1;
  end;

var x1,x2,x3,y1,y2,y3:double;
    //inext:integer;
begin

Result:=0;

{похідна за методом Рунге-Ромберга}
{дає гірші результати, ніж з використанням
поліному Лежандра (див.нижче)... а може я не
зовсім правильно робив, все-таки в книжках
говорили про рівномірні мережі, а я просто
для трьох точок намагався}
{x1:=A^.x[k];
y1:=A^.y[k];

if k=0 then
  begin
  NextPoint(k+1,High(A^.X)-1,x1,y1,A,x2,y2,inext);
  NextPoint(inext+1,High(A^.X),x2,y2,A,x3,y3,inext);
  Result:=RunRom(x1,x2,x3,y1,y2,y3);
  end;

if (k=1)and(k<>(High(A^.X)-1)) then
  begin
  NextPoint(k+1,High(A^.X)-1,x1,y1,A,x2,y2,inext);
  NextPoint(inext+1,High(A^.X),x2,y2,A,x3,y3,inext);
  Result:=((A^.Y[1]-A^.Y[0])/(A^.X[1]-A^.X[0])+
  RunRom(x1,x2,x3,y1,y2,y3))/2;
  end;

if (k=1)and(k=(High(A^.X)-1)) then
  begin
  x2:=x1;
  y2:=y1;
  NextPoint(k+1,High(A^.X),x2,y2,A,x3,y3,inext);
  NextPoint(k-1,0,x2,y2,A,x1,y1,inext);
  Result:=((y3-y2)/(x3-x2)+(y2-y1)/(x2-x1))/2;
  end;

if k=High(A^.X) then
  begin
  NextPoint(k-1,1,x1,y1,A,x2,y2,inext);
  NextPoint(inext-1,0,x2,y2,A,x3,y3,inext);
  Result:=RunRom(x1,x2,x3,y1,y2,y3);
  end;

if (k=(High(A^.X)-1))and(k<>1) then
  begin
  NextPoint(k-1,1,x1,y1,A,x2,y2,inext);
  NextPoint(inext-1,0,x2,y2,A,x3,y3,inext);
  Result:=((A^.Y[High(A^.X)]-A^.Y[k])/(A^.X[High(A^.X)]-A^.X[k])+
  RunRom(x1,x2,x3,y1,y2,y3))/2;
  end;

if (k>1)and(k<(High(A^.X)-1)) then
  begin
  NextPoint(k+1,High(A^.X)-1,x1,y1,A,x2,y2,inext);
  NextPoint(inext+1,High(A^.X),x2,y2,A,x3,y3,inext);
  Result:=RunRom(x1,x2,x3,y1,y2,y3);
  NextPoint(k-1,1,x1,y1,A,x2,y2,inext);
  NextPoint(inext-1,0,x2,y2,A,x3,y3,inext);
  Result:=(Result+RunRom(x1,x2,x3,y1,y2,y3))/2;
  end;}


{похідна розраховується на основі поліному Лежандра}
{}
if k=0 then
  begin
  x1:=A^.x[k];
  y1:=A^.y[k];
  x2:=A^.x[k+1];
  y2:=A^.y[k+1];
//  x3:=A^.x[k+2];
//  y3:=A^.y[k+2];

//  NextPoint(k+1,High(A^.X),x1,y1,A,x2,y2,inext);
//  NextPoint(inext+1,High(A^.X),x2,y2,A,x3,y3,inext);
//  Result:=PohPol(x1,x1,x2,x3,y1,y2,y3);
  Result:=(y2-y1)/(x2-x1)
  end;

if k=High(A^.X) then
  begin
  x3:=A^.x[k];
  y3:=A^.y[k];
//  x1:=A^.x[k-2];
//  y1:=A^.y[k-2];
  x2:=A^.x[k-1];
  y2:=A^.y[k-1];
//  NextPoint(k-1,1,x3,y3,A,x2,y2,inext);
//  NextPoint(inext-1,0,x2,y2,A,x1,y1,inext);
//  Result:=PohPol(x3,x1,x2,x3,y1,y2,y3);
  Result:=(y3-y2)/(x3-x2)
  end;

if (k>0) and (k<High(A^.X)) then
 begin
 x2:=A^.x[k];
 y2:=A^.y[k];

  x3:=A^.x[k+1];
  y3:=A^.y[k+1];
  x1:=A^.x[k-1];
  y1:=A^.y[k-1];

// NextPoint(k+1,High(A^.X),x2,y2,A,x3,y3,inext);
// NextPoint(k-1,0,x2,y2,A,x1,y1,inext);
 Result:=PohPol(x2,x1,x2,x3,y1,y2,y3);
 end;{}

{похідна розраховується на основі поліному Лежандра -
ще один варіант: якщо в попередньому похідна знаходилася
як похідна від поліному Лежанндра, проведеного через дану точку
і дві сусідніх, то в цьому випадку похідна знаходиться
як похідна від поліному Лежандра,
проведеного через всі точки}
{дуже погано - при великій кількості точок поліном Лежандра
сильно осцилює}
// Result:=PohLagr(A,A^.X[k]);

end;

Procedure LinAprox (V:PVector; var a,b:double);
{апроксимуються дані у векторі V лінійною
залежністю y=a+b*x}
var Sx,Sy,Sxy,Sx2:double;
    i:integer;
begin
 Sx:=0;Sy:=0;Sxy:=0;Sx2:=0;
for i:=0 to High(V^.X) do
   begin
   Sx:=Sx+V^.x[i];
   Sy:=Sy+V^.y[i];
   Sxy:=Sxy+V^.x[i]*V^.y[i];
   Sx2:=Sx2+V^.x[i]*V^.x[i];
   end;
a:=(Sx2*Sy-Sxy*Sx)/(V^.n*Sx2-Sx*Sx);
b:=(V^.n*Sxy-Sy*Sx)/(V^.n*Sx2-Sx*Sx);
end;

Procedure LinAproxBconst (V:PVector; var a:double; b:double);
{апроксимуються дані у векторі V лінійною
залежністю y=a+b*x;
параметр b вважається відомим}
var Sy,Sx:double;
    i:integer;
begin
 Sy:=0;Sx:=0;
for i:=0 to High(V^.X) do
   begin
   Sx:=Sx+V^.x[i];
   Sy:=Sy+V^.y[i];
   end;
a:=(Sy-b*Sx)/V^.n;
end;

Procedure LinAproxAconst (V:PVector; a:double; var b:double);
{апроксимуються дані у векторі V лінійною
залежністю y=a+b*x;
параметр a вважається відомим}
var Sx,Sxy,Sx2:double;
    i:integer;
begin
 Sx:=0;Sxy:=0;Sx2:=0;
for i:=0 to High(V^.X) do
   begin
   Sx:=Sx+V^.x[i];
   Sxy:=Sxy+V^.x[i]*V^.y[i];
   Sx2:=Sx2+V^.x[i]*V^.x[i];
   end;
b:=(Sxy-a*Sx)/Sx2;
end;


Procedure ParabAprox (V:Pvector; var a,b,c:double);
{апроксимуються дані у векторі V параболічною
залежністю y=a+b*x+с*x2}

var Sx,Sy,Sxy,Sx2,Sx3,Sx4,Syx2,pr:double;
    i:integer;

begin
Sx:=0;Sy:=0;Sxy:=0;Sx2:=0;Sx3:=0;Sx4:=0;Syx2:=0;
 with V^ do begin
  for i:=0 to High(X) do
   begin
   Sx:=Sx+x[i];
   Sy:=Sy+y[i];
   Sxy:=Sxy+x[i]*y[i];
   Sx2:=Sx2+sqr(x[i]);
   Sx3:=Sx3+sqr(x[i])*x[i];
   Sx4:=Sx4+sqr(sqr(x[i]));
   Syx2:=Syx2+sqr(x[i])*y[i];
   end;

pr:=Sx4*(n*Sx2-Sx*Sx)-Sx3*(n*Sx3-Sx*Sx2)+Sx2*(Sx3*Sx-Sx2*Sx2);
c:=(Syx2*(n*Sx2-Sx*Sx)-Sx3*(n*Sxy-Sx*Sy)+Sx2*(Sxy*Sx-Sx2*Sy))/pr;
b:=(Sx4*(n*Sxy-Sx*Sy)-Syx2*(n*Sx3-Sx*Sx2)+Sx2*(Sx3*Sy-Sx2*Sxy))/pr;
a:=(Sx4*(Sy*Sx2-Sx*Sxy)-Sx3*(Sy*Sx3-Sxy*Sx2)+Syx2*(Sx3*Sx-Sx2*Sx2))/pr;

 end;
end;

Procedure GromovAprox (V:PVector; var a,b,c:double);
{апроксимуються дані у векторі V
залежністю y=a+b*x+c*ln(x) за методом найменших квадратів}
var R:PSysEquation;
    i,j:integer;
begin
a:=555;
b:=555;
c:=555;

for I:=0 to V^.n-1 do
  if V^.X[i]<0 then Exit;

new(R);
R^.N:=3;
SetLength(R^.f,R^.N);
SetLength(R^.x,R^.N);
SetLength(R^.A,R^.N,R^.N);
for i := 0 to High(R^.f) do
 begin
 R^.f[i]:=0;
 R^.x[i]:=0;
 for j:=0 to R^.N-1 do R^.A[i,j]:=0;
 end;

R^.A[0,0]:=V^.n;
for i:=0 to V^.n-1 do
 begin
   R^.A[0,1]:=R^.A[0,1]+V^.X[i];
   R^.A[0,2]:=R^.A[0,2]+ln(V^.X[i]);
   R^.A[1,1]:=R^.A[1,1]+V^.X[i]*V^.X[i];
   R^.A[1,2]:=R^.A[1,2]+V^.X[i]*ln(V^.X[i]);
   R^.A[2,2]:=R^.A[2,2]+ln(V^.X[i])*ln(V^.X[i]);
   R^.f[0]:=R^.f[0]+V^.Y[i];
   R^.f[1]:=R^.f[1]+V^.Y[i]*V^.X[i];
   R^.f[2]:=R^.f[2]+V^.Y[i]*ln(V^.X[i]);
 end;
R^.A[1,0]:=R^.A[0,1];
R^.A[2,0]:=R^.A[0,2];
R^.A[2,1]:=R^.A[1,2];
GausGol(R);
if R^.N=555 then Exit;
a:=R^.x[0];
b:=R^.x[1];
c:=R^.x[2];
dispose(R);
end;

Procedure ExpAprox (V:PVector; var I0,E:double);
{апроксимуються дані у векторі V
залежністю I=I0[exp(V/E)-1]
за методом найменших квадратів зі
статистичними ваговими коефіцієнтами}
var Vari,Param1,Param2:array of double;
    temp:PVector;
    i:integer;
    ErStr:string;
begin
ErStr:='';
I0:=555;
E:=555;
if V^.n<7 then Exit;

SetLength(Vari,2);
{бо дві змінних - I0,E}


{початкове наближення І0 та Е - результат
лінійної апроксимації 5 останніх точок ВАХ
в напівлогарифмічному масштабі}
new(temp);
temp^.n:=5;
SetLength(temp^.X,temp^.n);
SetLength(temp^.Y,temp^.n);
for I := 0 to High(temp^.X) do
  begin
  temp^.X[i]:=V^.X[V^.n-1-i];
  temp^.Y[i]:=ln(V^.Y[V^.n-1-i]);
  end;
LinAprox(temp,Vari[0],Vari[1]);
Vari[0]:=exp(Vari[0]);
Vari[1]:=1/Vari[1];
dispose(temp);


if
  Newton(V, F_Exp, G_Exp,Param1,Param2, 1e-4, 1000, Vari,ErStr)<>0
    then Exit;
I0:=Vari[0];
E:=Vari[1];
end;


Procedure ExpRshAprox (V:PVector; var I0,E,Rsh:double);
{апроксимуються дані у векторі V
залежністю I=I0[exp(V/E)-1]+V/Rsh
за методом найменших квадратів зі
статистичними ваговими коефіцієнтами;
в самій процедурі реалізується метод
розв'язку системи нелінійних рівнянь методом Ньютона,
а не використовується функція Newton через те, що
необхідно динамічно змінювати значення вектора
початкових наближень}
const eps=1e-4;
      Nmax=1000;
var Vari,Param1,X1,X2:array of double;
    temp:PVector;
    i,j,Nit:integer;
    ErStr:string;
    SysEq:PSysEquation;
    bool:boolean;
    Emin,tmp:double;
begin
ErStr:='';
I0:=555;
E:=555;
Rsh:=555;
if V^.n<7 then Exit;

Emin:=2*V^.X[V^.n-1]/ln(1e38*V^.y[V^.n-1]);
{Emin - мінімально можливе значення
величини Е; обмеження пов'язане з тим,
що числа типу double можуть змінюватись
в діапазоні до (приблизно)1.1е38, а при
обчисленнях фігурують доданки ~exp(2x/E)/y}

SetLength(Vari,3);
{бо три змінних - I0,E,Rsh}


{початкове наближення Rsh - опір, порахований
по двом першим точкам ВАХ}
Vari[2]:=10*abs((V^.X[1]-V^.X[0])/(V^.Y[1]-V^.Y[0]));
{початкове наближення І0 та Е - результат
лінійної апроксимації 5 останніх точок ВАХ
в напівлогарифмічному масштабі}
new(temp);
temp^.n:=5;
SetLength(temp^.X,temp^.n);
SetLength(temp^.Y,temp^.n);
for I := 0 to High(temp^.X) do
  begin
  temp^.X[i]:=V^.X[V^.n-1-i];
  temp^.Y[i]:=ln(V^.Y[V^.n-1-i]);
  end;
LinAprox(temp,Vari[0],Vari[1]);
Vari[0]:=0.1*exp(Vari[0]);
Vari[1]:=1/Vari[1];
dispose(temp);


if vari[1]<Emin then vari[1]:=Emin*1.2;


  i:=3;
  SetLength(X1,i);
  SetLength(X2,i);
  new(SysEq);
  SetLength(SysEq^.A,i,i);
  SetLength(SysEq^.f,i);
  SetLength(SysEq^.x,i);
  SysEq^.N:=i;

  for I := 0 to High(X1) do X1[i]:=Vari[i];
  Nit:=0;

repeat
{
showmessage(floattostrf(X1[0],ffExponent,3,2)+#10+
            floattostrf(X1[1],ffExponent,3,2)+#10+
            floattostrf(X1[2],ffExponent,3,2));
            {}



 if (F_ExpRsh(V,X1,Param1,SysEq^.f)<>0) or
    (G_ExpRsh(V,X1,Param1,SysEq^.A)<>0) then
    begin
     ErStr:='Error in function';
     dispose(SysEq);
       showmessage('Vari[0]='+floattostr(X1[0])+#10+
            'Vari[1]='+floattostr(X1[1])+#10+
            'Vari[2]='+floattostrf(X1[2],ffExponent,3,2));
     Exit;
    end;
 for I := 0 to High(SysEq^.f) do
   begin
     tmp:=0;
     for j:=0 to High(SysEq^.f) do
             tmp:=tmp+SysEq^.A[i,j]*X1[j];
     SysEq^.f[i]:=tmp-SysEq^.f[i];
   end;


 GausGol(SysEq);
 if SysEq^.N=555 then
   begin
     ErStr:='Error during Gauss method';
     dispose(SysEq);
     Exit;
   end;
 Inc(Nit);
 bool:=true;
  try
 for I := 0 to High(SysEq^.f) do
       bool:=bool and (abs((X1[i]-SysEq^.x[i])/X1[i])<eps);
 except
 {  Nit:=0;
   if Vari[0]<0.1 then Vari[0]:=Vari[0]*1.1;
   Vari[2]:=abs((V^.X[1]-V^.X[0])/(V^.Y[1]-V^.Y[0]));
   for I := 0 to High(X1) do X1[i]:=Vari[i];}
 {
  showmessage('Vari[0]='+floattostr(X1[0])+#10+
            'Vari[1]='+floattostr(X1[1])+#10+
            'Vari[2]='+floattostrf(X1[2],ffExponent,3,2));{}
 end;

 for I := 0 to High(X1) do X1[i]:=SysEq^.x[i];

  if ((X1[2]<10)or(X1[2]>1e10)) then
  begin
  Vari[2]:=Vari[2]*0.9;
 for I := 0 to High(X1) do X1[i]:=Vari[i];
  end;


 if (X1[1]<Emin)or (vari[2]<10)or(X1[0]=0) then
   begin
   Nit:=0;
   if Vari[0]<0.1 then Vari[0]:=Vari[0]*1.1 else Nit:=Nmax+1;
   Vari[2]:=10*abs((V^.X[1]-V^.X[0])/(V^.Y[1]-V^.Y[0]));
   for I := 0 to High(X1) do X1[i]:=Vari[i];
   end;

until bool or (Nit>Nmax);
 dispose(SysEq);
 if Nit>Nmax then
     ErStr:='The number of iterations is too much'
             else
     begin
       I0:=X1[0];
       E:=X1[1];
       Rsh:=X1[2];
       ErStr:='';
     end;

end;


Procedure GausGol(var R:PSysEquation);
{процедура розв'язку системи лінійних рівнянь
методом Гауса з вибором головного елементу;
всі параметри рівняння, як і розв'язки, - в R;
якщо розв'язків не існує, то R^.N=555}

var i,j,k,Imax,Jmax:integer;
//Imax - номер рядка головного елементу
//Jmax - номер стовпчика головного елементу
    Amax:double;
//Amax -  головний елемент
    NumX:array of integer;//масив для збереження номерів невідомих
    Rtemp:PSysEquation;

  Procedure RowSwap(i,j:integer; var R:PSysEquation);
  {процедура обміну місцями двох рядків
  у матриці R^.A з номерами i,j та
  відповідних елементів вектора вільних членів}
  var k:integer;
  begin
   for k := 0 to R^.N - 1 do Swap(R^.A[i,k],R^.A[j,k]);
   Swap(R^.f[i],R^.f[j]);
   end;

  Procedure ColSwap(i,j:integer; var R:PSysEquation);
  {процедура обміну місцями двох колонок
  у матриці R^.A з номерами i,j та
  відповідних елементів вектора невідомих}
  var k:integer;
  begin
   for k := 0 to R^.N - 1 do Swap(R^.A[k,i],R^.A[k,j]);
   Swap(R^.x[i],R^.x[j]);
  end;

begin

if R^.N<1 then
        begin
        R^.N:=555;
        Exit;
        end;

if R^.N=1 then
   begin
    if R^.A[0,0]=0 then R^.N:=555
                   else R^.x[0]:=R^.f[0]/R^.A[0,0];
    Exit;
   end;


SetLength(NumX,R^.N);
for I := 0 to High(NumX)do NumX[i]:=i;

new(Rtemp);
Rtemp^.N:=R^.N;
SetLength(Rtemp^.f,R^.N);
SetLength(Rtemp^.x,R^.N);
SetLength(Rtemp^.A,R^.N,R^.N);
for i := 0 to High(R^.f) do
 begin
 Rtemp^.f[i]:=R^.f[i];
 Rtemp^.x[i]:=R^.x[i];
 for j := 0 to R^.N - 1 do Rtemp^.A[i,j]:=R^.A[i,j];
 end;

{в наступному циклі проводиться відшук головного елементу
та прямий хід методу Гауса}
for k:=0 to Rtemp^.N-2 do
begin
{визначення головного елементу та перестановка
його на потрібне місце}
  Imax:=k;
  Jmax:=k;
  Amax:=abs(Rtemp^.A[k,k]);
  for i:=k to Rtemp^.N-1 do
     for j:=k to Rtemp^.N-1 do
       if abs(Rtemp^.A[i,j])>Amax then
         begin
          Imax:=i;
          Jmax:=j;
          Amax:=abs(Rtemp^.A[i,j]);
         end;
  if Imax<>k then RowSwap(k,Imax,Rtemp);
  if Jmax<>k then
    begin
     ColSwap(k,Jmax,Rtemp);
     Swap(NumX[k],NumX[Jmax]);
    end;
  if Rtemp^.A[k,k]=0 then
       begin
       dispose(Rtemp);
       R^.N:=555;
       Exit;
       end;
{прямий хід}
  for i:=k+1 to Rtemp^.N-1 do
   begin
    Amax:=Rtemp^.A[i,k]/Rtemp^.A[k,k];
    Rtemp^.f[i]:=Rtemp^.f[i]-Amax*Rtemp^.f[k];
    for j:=k+1 to Rtemp^.N-1 do
      Rtemp^.A[i,j]:=Rtemp^.A[i,j]-Amax*Rtemp^.A[k,j];
    Rtemp^.A[i,k]:=0;
   end;
end;

{Зворотній хід методу Гауса}
for k:=Rtemp^.N-1 downto 0 do
 begin
 Amax:=0;
 for j:=Rtemp^.N-1 downto k+1 do
   Amax:=Amax+Rtemp^.A[k,j]*Rtemp^.x[j];
 Rtemp^.x[k]:=(Rtemp^.f[k]-Amax)/Rtemp^.A[k,k];
 end;

for k := 0 to Rtemp^.N-1 do
  R^.x[NumX[k]]:=Rtemp^.x[k];

dispose(Rtemp);
end;




Procedure Gaus (bool:boolean; Nrr:integer; a:IRE2; b:IRE; var x:IRE);
{розв'зок системи лiнiйних рівнянь методом Гауса
Nr - кількість рівнянь (розмірність системи)
a - матриця коефіцієтів
b - вектор вільних членів
x - вектор невідомих (розв'язків)}

var a1:IRE2;
    b1:IRE;
    i,j,k,Nr:integer;
    h:real;
begin
if bool then Nr:=2 else Nr:=Nrr;

for i:=1 to Nr do
  begin
   b1[i]:=b[i];
   for j:=1 to Nr do a1[i,j]:=a[i,j];
  end;

for i:=1 to (Nr-1) do
  for j:=i+1 to Nr do
    begin
  {  ShowMessage('I='+IntToStr(i));}
    a1[j,i]:=-a1[j,i]/a1[i,i];
    for k:=i+1 to Nr do a1[j,k]:=a1[j,k]+a1[j,i]*a1[i,k];
    b1[j]:=b1[j]+b1[i]*a1[j,i];
    end;

x[Nr]:=b1[Nr]/a1[Nr,Nr];
for i:=Nr-1 downto 1 do
  begin
   h:=b1[i];
   for j:=i+1 to Nr do h:=h-x[j]*a1[i,j];
   x[i]:=h/a1[i,i];
  end;

end;



Procedure Newts(Nr:integer; AV:Pvector; eps:real; Xp:IRE; var Xr:IRE; var rez:integer);
{процедура апроксимації даних в А за формулою y=I0(exp(x/E)-1)+x/R
за методом найменших квадратів зі статистичними
ваговими коефіцієнтами;
фактично в цій процедурі виконується
розв'язок системи нелінійних рівнянь методом Ньютона,
коефіцієнти рівнянь отримуються за допомогою
різних допоміжних функцій, явний вигляд яких
отриманий вручну.

Nr   - константа вибору режиму апроксимації:
Nr=1 - вважається, що E=const (рівний значенню у
       векторі початкових наближень, Xp[3]),
       R=const (=1e12 Ом, нескінченно великий шунтуючий опір),
       тобто фактично знаходиться лише величина І0;
Nr=2 - E=const, знаходяться І0 та R;
Nr=3 - вар'юються всі три параметри (найбільш
       загальний випадок);
Nr=4 - R=const (1e12 Ом), знаходиться величина Е та І0

eps  - параметр, не більше якого має бути відносна
       зміна І0 в сусідніх ітераціях (критерій припинення
       процесу)

Хр   - вектор початкових наближень

Хr   - вектор, куди заносяться результати

rez=0 - вдалося підібрати параметри
rez=-1 - аппроксимувати не вдалося}

  Procedure RRR(A:Pvector; E:double; var B:Pvector);
  {допоміжна функція при апроксимації,
  фактично в компоненті х вектора B розташовано exp(А^.x/E),
  в компоненті у - [exp(А^.x/E)-1]}
    var i:integer;
    begin
 {    B^.n:=A^.n;
     SetLength(B^.X, B^.n);
     SetLength(B^.Y, B^.n);}
     for i:=0 to High (B^.X) do
       begin
       B^.x[i]:=exp(A^.x[i]/E);
       B^.y[i]:=B^.x[i]-1;
       end;
    end;

  Procedure FuncF (bool:boolean; Nr:integer; a,b:Pvector; X:IRE; var Y:IRE);
  {допоміжна функція при апроксимації, її явний вигляд
   з'явився після знаходження часткових похідних -
   у векторі Y величина похідних від квадратичної функції
   (або умов мінімізації, або функцій. як утворюють систему рівнянь)
   при значеннях змінних розташованих в Х }
   var i:integer;
       temp:double;
   begin
   for i:=1 to Nr do Y[i]:=0;
   for i:=0 to High(A^.X) do
     begin
      temp:=(X[1]*B^.y[i]+A^.x[i]/X[2]-A^.y[i]);
      Y[1]:=Y[1]+B^.y[i]*temp/A^.y[i];
      Y[3]:=Y[3]+temp*A^.x[i]*B^.x[i]/A^.y[i];
      Y[2]:=Y[2]+temp*A^.x[i]/A^.y[i];
     end;
   if bool then Swap(Y[3],Y[2]);
   end;

  Procedure FuncG (bool:boolean;Nr:integer; a,b:Pvector; X:IRE; var Z:IRE2);
  {допоміжна функція при апроксимації, її явний вигляд
   з'явився після знаходження часткових похідних -
   створюється матриця (Z), компоненти якої є значеннями
   похідних від умов мінімізації квадратичної форми на даному
   ітераційному кроці;
   іншими словами - значення похідних від функцій, які утворюють
   систему рівнянь при значеннях невідомих,
   розташованих в Х (на даному ітераційному кроці)}
  var i,j:integer;
  begin
  for i:=1 to Nr do
    for j:=1 to Nr do Z[i,j]:=0;
  for i:=0 to High(A^.X) do
  begin
  Z[1,1]:=Z[1,1]+b^.y[i]*b^.y[i]/a^.y[i];
  Z[1,3]:=Z[1,3]-a^.x[i]/sqr(X[3])*b^.x[i]*(2*X[1]*b^.y[i]+a^.x[i]/X[2]-a^.y[i])/a^.y[i];
  Z[1,2]:=Z[1,2]-a^.x[i]*b^.y[i]/sqr(X[2])/a^.y[i];
  Z[3,1]:=Z[3,1]+a^.x[i]*b^.x[i]*b^.y[i]/a^.y[i];
  Z[3,3]:=Z[3,3]-sqr(a^.x[i]/X[3])*b^.x[i]*(X[1]*b^.y[i]+a^.x[i]/X[2]-a^.y[i]+X[1]*b^.x[i])/a^.y[i];
  Z[3,2]:=Z[3,2]-sqr(a^.x[i]/X[2])*b^.x[i]/a^.y[i];
  Z[2,1]:=Z[2,1]+a^.x[i]*b^.y[i]/a^.y[i];
  Z[2,3]:=Z[2,3]-sqr(a^.x[i]/X[3])*b^.x[i]*X[1]/a^.y[i];
  Z[2,2]:=Z[2,2]-sqr(a^.x[i]/X[2])/a^.y[i];
  end;
if bool then
 begin
 Z[1,2]:=Z[1,3];
 Z[2,2]:=Z[3,3];
 Z[2,1]:=Z[3,1];
 end;
end;


const Nitmax=1000; //maксимальне число ітерацій
var Nit,i,j:integer;
    X1,X2,F,F1:IRE;
    G:IRE2;
    B:Pvector;
    a,Rtemp:real;
    bool,bool1:boolean;
Label Start;


begin

new(B);
B^.n:=AV^.n;
SetLength(B^.X, B^.n);
SetLength(B^.Y, B^.n);

if Nr=1 then Xp[2]:=1e12;
bool1:=false;
if Nr=4 then
         begin
         Xp[2]:=1e12;
         bool1:=true;
         Nr:=3
         end;

Start:

Nit:=0;
for i:=1 to 3 do X1[i]:=Xp[i];
Rtemp:=Xp[2];

repeat
 X2:=X1;
 if bool1 then X2[2]:=1e12;

 RRR(AV,X1[3],b);
 FuncF(bool1,Nr,AV,b,X1,F);
{showmessage('Vari[0]='+floattostr(X1[1])+#10+
            'Vari[1]='+floattostrf(X1[2],ffExponent,3,2)+#10+
            'Vari[2]='+floattostr(X1[3]));
showmessage('Rez[0]='+floattostr(F[1])+#10+
            'Rez[1]='+floattostr(F[2])+#10+
            'Rez[2]='+floattostr(F[3]));}
 FuncG(bool1,Nr,AV,b,X1,G);

{showmessage(
floattostrf(G[1,1],ffExponent,3,2)+' '+floattostrf(G[1,2],ffExponent,3,2)+' '+floattostrf(G[1,3],ffExponent,3,2)+#10+
floattostrf(G[2,1],ffExponent,3,2)+' '+floattostrf(G[2,2],ffExponent,3,2)+' '+floattostrf(G[2,3],ffExponent,3,2)+#10+
floattostrf(G[3,1],ffExponent,3,2)+' '+floattostrf(G[3,2],ffExponent,3,2)+' '+floattostrf(G[3,3],ffExponent,3,2)
);}


 for i:=1 to Nr do
  begin
   a:=0;
   for j:=1 to Nr do a:=a+G[i,j]*X1[j];
   F1[i]:=a-F[i];
  end;

 if bool1 then
  begin
   Swap(X1[2],X1[3]);
   for i:=1 to 2 do
     begin
     a:=0;
     for j:=1 to 2 do a:=a+G[i,j]*X1[j];
     F1[i]:=a-F[i];
     end;
   Swap(X1[2],X1[3]);
   Swap(X2[2],X2[3]);
  end;

 Gaus(bool1,Nr,G,F1,X2);
 Inc(Nit);
 if bool1 then Swap(X2[2],X2[3]);

 bool:=(abs((X1[1]-X2[1])/X2[1])<eps)and(abs((X1[3]-X2[3])/X2[3])<eps);

 X1:=X2;

 if ((X1[2]<0)or(X1[2]>1e10)) and (not(bool1)) and (Nr<>1) then
  begin
  Rtemp:=Rtemp*0.9;
  X1[1]:=Xp[1];X1[3]:=Xp[3];
  X1[2]:=Rtemp;
  end;

 if (X1[3]<1e-2) then Nit:=Nitmax+1;

 if (Nit>Nitmax)and(not(bool1)) then
   begin
   Nit:=0;
   bool1:=true;
   X1[2]:=1e12;
   X1[1]:=Xp[1];
   X1[3]:=Xp[3];
   end;


until bool or (Nit>Nitmax);

if (Nit>Nitmax)and(Xp[1]<0.1) then
       begin
        Xp[1]:=Xp[1]*3;
        goto Start;
       end;

Xr:=X1;

if (Nit>Nitmax) then
       begin
{       MessageDlg('Approximation unseccessful', mtError,[mbOk],0);}
       rez:=-1;
       end
                else
       rez:=0;

dispose(b);
end;

Function Newton(A:Pvector; funF:TFun1D; funG:TFun2D;
                ParF:array of double; ParG:array of double;
                eps:real; Nmax:integer;
                var X0:array of double;var ErStr:string):word;
{Розв'язок системи рівнянь методом Ньютона,
F - функція, яка повертає масив значень функцій
    цієї системи;
G - функція, яка повертає масив значень якобіану
    функцій цієї системи;
ParF - масив параметрів, які використовуються
     у функції F;
ParG - масив параметрів, які використовуються
     у функції G;
A - масив даних, які використовуються при
    побудові функцій F та G;
eps - відносна точність, на яку не повинні
    відрізнятися розв'язки на двох сусудніх
    кроках, щоб можна було припинити ітераційний
    процес;
Nmax - максимальне число ітерацій;
Х0 - вектор початкових наближень, в нього ж
    розміщується результат;
ErStr - рядок, де розміщено опис помилки;
При вдалому закінченні
функція повертає 0;
ErStr='';
в Х0 - розв'язки;
При невдалому закінченні
функція повертає 1;
ErStr не нульовий;
в Х0 - 555;
}
var X1,X2:array of double;
    temp:double;
    i,j, Nit:integer;
    SysEq:PSysEquation;
    bool:boolean;
begin
  i:=High(X0)+1;
//  showmessage(IntToStr(i));
  SetLength(X1,i);
  SetLength(X2,i);
  new(SysEq);
  SetLength(SysEq^.A,i,i);
  SetLength(SysEq^.f,i);
  SetLength(SysEq^.x,i);
  SysEq^.N:=i;
  for I := 0 to High(X1) do X1[i]:=X0[i];
  Nit:=0;
  Result:=1;
  for I := 0 to High(X0) do X0[i]:=555;
repeat

 if (funF(A,X1,ParF,SysEq^.f)<>0) or
    (funG(A,X1,ParG,SysEq^.A)<>0) then
    begin
     ErStr:='Error in function';
     dispose(SysEq);
     Exit;
    end;
 { for I := 0 to High(SysEq^.f) do SysEq^.f[i]:=-SysEq^.f[i];
 GausGol(SysEq);
 if SysEq^.N=555 then
   begin
     ErStr:='Error during Gauss method';
     dispose(SysEq);
     Exit;
   end;
 bool:=true;
 for I := 0 to High(SysEq^.f) do
      bool:=bool and (abs(SysEq^.x[i]/X1[i])<eps);

 for I := 0 to High(X1) do X1[i]:=X1[i]+SysEq^.x[i];{}


 for I := 0 to High(SysEq^.f) do
   begin
     temp:=0;
     for j:=0 to High(SysEq^.f) do
             temp:=temp+SysEq^.A[i,j]*X1[j];
     SysEq^.f[i]:=temp-SysEq^.f[i];
   end;


 GausGol(SysEq);
 if SysEq^.N=555 then
   begin
     ErStr:='Error during Gauss method';
     dispose(SysEq);
     Exit;
   end;
 Inc(Nit);
 bool:=true;
 for I := 0 to High(SysEq^.f) do
       bool:=bool and (abs((X1[i]-SysEq^.x[i])/X1[i])<eps);

 for I := 0 to High(X1) do X1[i]:=SysEq^.x[i];

until bool or (Nit>Nmax);
 dispose(SysEq);
 if Nit>Nmax then
     ErStr:='The number of iterations is too much'
             else
     begin
       for I := 0 to High(X1) do X0[i]:=X1[i];
       Result:=0;
       ErStr:='';
     end;
end;

Function SpeedSlalom(AP:Pvector; funF:TFun1D; ParF:array of double;
                eps:real; Nmax:integer;
                var X0:array of double;var ErStr:string):word;
{Розв'язок системи рівнянь методом найшвидшлго спуску,
F :TFun1D=Function(A:Pvector; Variab:array of double;
                  Param:array of double;
                  var Rez:array of double):word;
- функція, яка повертає в масиві Rez значень величини
Rez[0]- значення функціоналу, який визначається
 сумою квадратів рівнянь, які входять до системи;
Rez[1]... - значення похідних від функціоналу по різним
змінним

ParF - масив параметрів, які використовуються
     у функції F;
A - масив даних, які використовуються при
    побудові функції F;
eps - відносна точність, на яку не повинні
    відрізнятися розв'язки на двох сусудніх
    кроках, щоб можна було припинити ітераційний
    процес;
Nmax - максимальне число ітерацій;
Х0 - вектор початкових наближень, в нього ж
    розміщується результат;
ErStr - рядок, де розміщено опис помилки;
При вдалому закінченні
функція повертає 0;
ErStr='';
в Х0 - розв'язки;
При невдалому закінченні
функція повертає 1;
ErStr не нульовий;
в Х0 - 555;
}
  function Alph (x:double):double;
  {допоміжна функція, необхідна для використання
  у методі оптимізації за методов золотого перерізу
  при пошуку ширини кроку - див опис методу
  найшвидшого спуску}
   var X11, X12:array of double;
       i:integer;
   begin
     Result:=555;
     SetLength(X11,High(X0)+2);
     SetLength(X12,High(X0)+1);
     if (funF(AP,X0,ParF,X11)<>0) then Exit;
     for I := 0 to High(X12) do
       X12[i]:=X0[i]-x*X11[i+1];
     if (funF(AP,X12,ParF,X11)<>0) then Exit;
     Result:=X11[0];
   end;

const al=0.618;
      bet=0.382;

var Xk,Xk1:array of double;
    i,Nit:integer;
    alp, ep, x1, x2, y1, y2,a,b:double;
    bool:boolean;
begin
showmessage('X0[1]='+floattostr(X0[1]));
  i:=High(X0)+2;
  SetLength(Xk,i-1);
  SetLength(Xk1,i);
  for I := 0 to High(Xk) do Xk[i]:=X0[i];
  Nit:=0;
  Result:=1;
//  for I := 0 to High(X0) do X0[i]:=555;
repeat
{----мінімізація для знахожження кроку-----------}
{}
a:=0;b:=10;
ep:=1e-10*abs(b-a);
x1:=al*a+bet*b;
x2:=al*b+bet*a;
y1:=Alph(x1);
y2:=Alph(x2);
if (y1=555)or(y2=555) then
 begin
  ErStr:='Error of step defination';
  for I := 0 to High(X0) do X0[i]:=555;
  Exit;
 end;

repeat
if y1<y2 then
 begin
   b:=x2;
   x2:=x1;
   y2:=y1;
   x1:=al*a+bet*b;
   y1:=Alph(x1);
 end
         else
  begin
   a:=x1;
   x1:=x2;
   y1:=y2;
   x2:=al*b+bet*a;
   y2:=Alph(x2);
  end;
if (y1=555)or(y2=555) then
 begin
  ErStr:='Error of step defination';
  for I := 0 to High(X0) do X0[i]:=555;
  Exit;
 end;

until abs(b-a)<ep;
alp:=(a+b)/2;
{}
{alp:=7e-4;}
showmessage('alp='+floattostr(alp));
{------------------------------------------------}


//showmessage('X0[1]='+floattostr(X0[1]));

 if (funF(AP,X0,ParF,Xk1)<>0)  then
    begin
     ErStr:='Error in function';
     for I := 0 to High(X0) do X0[i]:=555;
     Exit;
    end;
 Inc(Nit);
 bool:=true;
showmessage('Xk[1]='+floattostr(Xk[1]));
showmessage('Xk1[2]='+floattostr(Xk1[2]));

 for I := 0 to High(X0) do X0[i]:=X0[i]-alp*Xk1[i+1];


 for I := 0 to High(X0) do
       bool:=bool and (abs((X0[i]-Xk[i])/Xk[i])<eps);

 for I := 0 to High(Xk) do Xk[i]:=X0[i];

until (bool or (Nit>Nmax));

 if Nit>Nmax then
     begin
     ErStr:='The number of iterations is too much';
     for I := 0 to High(X0) do X0[i]:=555;
     end
             else
     begin
       Result:=0;
       ErStr:='';
     end;

end;

Function SpSlExpRsh(AP:Pvector; Variab:array of double;
                     Param:array of double;
                     var Rez:array of double):word;
{функція, потрібна для проведення апроксимації
залежності в А функцією I=I0[exp(V/E)-1]+V/Rsh;
надалі ця функція використовується у розв'язку
системи рівнянь методом найшвидшого спуску;
Variab[0]=I0;
Variab[1]=E;
Variab[2]=Rsh;
Rez[0] - функціонал, який є сумою квадратів
умов мінімізації квадратичної форми;
Rez[1(2,3)] - значення похідної функціоналу
по змінній І0 (Е,Rsh) при значеннях, записаних
в  Variab
}
var i:integer;
    A,B,C,XXY,XY{,ly,K,M,K1,MMly,Mly}: double;
    f1,f2,f3,g11,g12,g13,g21,g22,g23,g31,g32,g33:extended;
begin

{showmessage('Vari[0]='+floattostr(Variab[0])+#10+
            'Vari[1]='+floattostr(Variab[1])+#10+
            'Vari[2]='+floattostr(Variab[2]));

 }
try

f1:=0;f2:=0;f3:=0;
g11:=0;g12:=0;g13:=0;
g21:=0;g22:=0;g23:=0;
{g31:=0;g32:=0;}g33:=0;

for I := 0 to High(AP^.X) do
   begin
   A:=exp(AP^.X[i]/Variab[1]);
   B:=A-1;
   C:=Variab[0]*B+AP^.X[i]/Variab[2]-AP^.Y[i];
   XY:=AP^.X[i]/AP^.Y[i];
   XXY:=AP^.X[i]*XY;

   f1:=f1+C*B/AP^.Y[i];
   f2:=f2+XY*C*A;
   f3:=f3+XY*C;
   g11:=g11+sqr(B)/AP^.Y[i];
   g12:=g12+XY*A*(2*Variab[0]*B+AP^.x[i]/Variab[2]-AP^.Y[i]);
   g13:=g13+XY*B;
   g21:=g21+XY*B*A;
   g22:=g22+XXY*A*(Variab[0]*(1-2*A)-AP^.x[i]/Variab[2]+AP^.Y[i]);
   g23:=g23+XXY*A;
   g33:=g33+XXY;

{   ly:=ln(AP^.Y[i]);
   A:=exp(AP^.X[i]/Variab[1]);
   B:=A-1;
   M:=Variab[0]*B+AP^.X[i]/Variab[2];
   K:=ln(M)-ly;
   Mly:=M*ly;
   MMly:=sqr(M)*ly;
   K1:=1-K;


   f1:=f1+B*K/Mly;
   showmessage('f1='+floattostrf(B/M,ffExponent,3,2));
   f2:=f2+A*K/Mly*AP^.X[i];
   f3:=f3+K*AP^.X[i]/Mly;
   g11:=g11+sqr(B)*K1/MMly;
   g12:=g12+A*AP^.X[i]*(B*Variab[0]-AP^.X[i]/Variab[2]*K)/MMly;
   g13:=g13+B*AP^.X[i]*K1/MMly;
   g21:=g21+B*A*K1/MMly;
   g22:=g22+A*sqr(AP^.X[i])*(A*Variab[0]+(AP^.X[i]/Variab[2]-Variab[0])*K)/MMly;
   g23:=g23+A*sqr(AP^.X[i])*K1/MMly;
   g33:=g33+sqr(AP^.X[i])*K1/MMly;}

   end;

g12:=-g12/sqr(Variab[1]);
g31:=g13;
g13:=-g13/sqr(Variab[2]);
g22:=g22/sqr(Variab[1]);
g32:=-g23*Variab[0]/sqr(Variab[1]);
g23:=-g23/sqr(Variab[2]);
g33:=-g33/sqr(Variab[2]);

Rez[0]:=sqr(f1)+sqr(f2)+sqr(f3);
Rez[1]:=2*(f1*g11+f2*g21+f3*g31);
Rez[2]:=2*(f1*g12+f2*g22+f3*g32);
Rez[3]:=2*(f1*g13+f2*g23+f3*g33);
Result:=0;
except
for I := 0 to High(Rez) do Rez[i]:=555;
Result:=1;
end;
{showmessage('Rez[0]='+floattostr(Rez[0])+#10+
            'Rez[1]='+floattostr(Rez[1])+#10+
            'Rez[2]='+floattostr(Rez[2])+#10+
            'Rez[3]='+floattostr(Rez[3])); }
//showmessage('f1='+floattostr(A));
//showmessage('f2='+floattostr(f2));
//showmessage('f3='+floattostr(f3));
//showmessage('Rez[1]='+floattostr(Rez[1]));
end;


Function F_Exp(AP:Pvector; Variab:array of double;
                     Param:array of double;
                     var Rez:array of double):word;
{функція, потрібна для проведення апроксимації даних в А
функцією I=I0[exp(V/E0)-1] за допомогою методу Ньютона
(правильніше - апроксимація за методом найменших квадратів, але
розв'язок системи рівнянь за методом Ньютона;
повертає в Rez значення функцій, які є умовою мінімізації
квадратичної форми;
Param - в даному випадку не використовується,
при виклиці просто пустий масив}
var i:integer;
    A,B,C,XY: double;
begin
try
for I := 0 to High(Rez) do Rez[i]:=0;
for I := 0 to High(AP^.X) do
   begin
   A:=exp(AP^.X[i]/Variab[1]);
   B:=A-1;
   C:=Variab[0]*B-AP^.Y[i];
   XY:=AP^.X[i]/AP^.Y[i];

   Rez[0]:=Rez[0]+C*B/AP^.Y[i];
   Rez[1]:=Rez[1]+XY*C*A;
   end;

Result:=0;
except
for I := 0 to High(Rez) do Rez[i]:=555;
Result:=1;
end; //try
end;


Function G_Exp(AP:Pvector; Variab:array of double;
                  Param:array of double;
                  var Rez:T2DArray):word;
{функція, потрібна для проведення апроксимації даних в А
функцією I=I0[exp(V/E0)-1] за допомогою методу Ньютона
(правильніше - апроксимація за методом найменших квадратів, але
розв'язок системи рівнянь за методом Ньютона;
повертає в Rez значення якобіану функцій, які є умовою мінімізації
квадратичної форми;
Param - в даному випадку не використовується,
при виклиці просто пустий масив}
var i,j:integer;
    A,B,XXY,XY: double;
begin

try
for I := 0 to High(Rez) do
  for j := 0 to High(Rez) do
     Rez[i,j]:=0;

for I := 0 to High(AP^.X) do
   begin
   A:=exp(AP^.X[i]/Variab[1]);
   B:=A-1;
   XY:=AP^.X[i]/AP^.Y[i];
   XXY:=AP^.X[i]*XY;

   Rez[0,0]:=Rez[0,0]+sqr(B)/AP^.Y[i];
   Rez[0,1]:=Rez[0,1]+XY*A*(2*Variab[0]*B-AP^.Y[i]);
   Rez[1,0]:=Rez[1,0]+XY*B*A;
   Rez[1,1]:=Rez[1,1]+XXY*A*(Variab[0]*(1-2*A)+AP^.Y[i]);

   end;

Rez[0,1]:=-Rez[0,1]/sqr(Variab[1]);
Rez[1,1]:=Rez[1,1]/sqr(Variab[1]);

Result:=0;
except
for I := 0 to High(Rez) do
  for j := 0 to High(Rez)do
     Rez[i,j]:=555;
Result:=1;
end;//try
end;


Function F_ExpRsh(AP:Pvector; Variab:array of double;
                     Param:array of double;
                     var Rez:array of double):word;
var i:integer;
    A,B,C,XY: double;
begin
try
for I := 0 to High(Rez) do Rez[i]:=0;
for I := 0 to High(AP^.X) do
   begin
   A:=exp(AP^.X[i]/Variab[1]);
   B:=A-1;
   C:=Variab[0]*B+AP^.X[i]/Variab[2]-AP^.Y[i];
   XY:=AP^.X[i]/AP^.Y[i];

   Rez[0]:=Rez[0]+C*B/AP^.Y[i];
   Rez[1]:=Rez[1]+XY*C*A;
   Rez[2]:=Rez[2]+XY*C;


   end;

Result:=0;
except
for I := 0 to High(Rez) do Rez[i]:=555;
Result:=1;
end; //try
end;

Function G_ExpRsh(AP:Pvector; Variab:array of double;
                  Param:array of double;
                  var Rez:T2DArray):word;
var i,j:integer;
    A,B,XXY,XY: double;
begin

try
for I := 0 to High(Rez) do
  for j := 0 to High(Rez) do
     Rez[i,j]:=0;


for I := 0 to High(AP^.X) do
   begin
   A:=exp(AP^.X[i]/Variab[1]);
   B:=A-1;
   XY:=AP^.X[i]/AP^.Y[i];
   XXY:=AP^.X[i]*XY;

   Rez[0,0]:=Rez[0,0]+sqr(B)/AP^.Y[i];
   Rez[0,1]:=Rez[0,1]+XY*A*(2*Variab[0]*B+AP^.x[i]/Variab[2]-AP^.Y[i]);
   Rez[0,2]:=Rez[0,2]+XY*B;
   Rez[1,0]:=Rez[1,0]+XY*B*A;
   Rez[1,1]:=Rez[1,1]+XXY*A*(Variab[0]*(1-2*A)-AP^.x[i]/Variab[2]+AP^.Y[i]);
   Rez[1,2]:=Rez[1,2]+XXY*A;
   Rez[2,2]:=Rez[2,2]+XXY;


   end;

Rez[0,1]:=-Rez[0,1]/sqr(Variab[1]);
Rez[2,0]:=Rez[0,2];
Rez[0,2]:=-Rez[0,2]/sqr(Variab[2]);
Rez[1,1]:=Rez[1,1]/sqr(Variab[1]);
Rez[2,1]:=-Rez[1,2]*Variab[0]/sqr(Variab[1]);
Rez[1,2]:=-Rez[1,2]/sqr(Variab[2]);
Rez[2,2]:=-Rez[2,2]/sqr(Variab[2]);

Result:=0;
except
for I := 0 to High(Rez) do
  for j := 0 to High(Rez)do
     Rez[i,j]:=555;
Result:=1;
end;//try
end;

//Function LamParamIsBad(V:PVector;n0,Rs0,I00,Rsh0:double):boolean;
//{перевіряє чи параметри можна використовувати для
//апроксимації даних в V функцією Ламверта}
//var bt:double;
//begin
//  Result:=true;
//  if V^.T<=0 then Exit;
//  bt:=1/kb/V^.T;
//  if n0<=0 then Exit;
//  if Rs0<0 then Exit;
//  if I00<0 then Exit;
//  if Rsh0<0 then Exit;
//  if bt/n0*(V^.X[V^.n-1]+Rs0*I00)>ln(1e38) then Exit;
//  if bt*Rs0*I00/n0*exp(Kb*V^.T/n0*(V^.X[V^.n-1]+Rs0*I00))>ln(1e38)  then Exit;
//
//  Result:=false;
//end;


//Function ParamCorect(V:PVector;Fun:Funbool;var n0,Rs0,I00,Rsh0:double):boolean;overload;
//{коректує значення параметрів, які використовуються
//для апроксимації даних в V функцією Ламверта;
//якщо коректування все ж невдале, то
//повертається false}
//begin
//  Result:=false;
//  if V^.T<=0 then Exit;
//  if Rs0<0.0001 then Rs0:=0.0001;
//  if (Rsh0<=0) or (Rsh0>1e12) then Rsh0:=1e12;
//  while (Fun(V,n0,Rs0,I00,Rsh0))and(n0<1000) do
//   n0:=n0*2;
//  while (Fun(V,n0,Rs0,I00,Rsh0))and(I00>1e-15) do
//    I00:=I00/1.5;
//  if  Fun(V,n0,Rs0,I00,Rsh0) then Exit;
//  Result:=true;
//end;



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
//

//Function ExpParamIsBad(V:PVector;n,Rs,I0,Rsh:double):boolean;overload;
//{перевіряє чи параметри можна використовувати для
//апроксимації даних в V функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh}
//var bt:double;
//    i:integer;
//begin
//  Result:=true;
//  if V^.T<=0 then Exit;
//  if n<=0 then Exit;
//  bt:=2/kb/V^.T/n;
//
//  if Rs<0 then Exit;
//  if (I0<0) or (I0>1) then Exit;
//  if Rsh<=1e-4 then Exit;
//  for I := 0 to High(V^.X) do
//    if bt*(V^.X[i]-Rs*V^.Y[i])>(88+ln(abs(V^.Y[i]))) then Exit;
//  Result:=false;
//end;
//
//Function ExpParamIsBad(V:PVector;n,Rs,I0,Rsh,Iph:double):boolean;overload;
//{перевіряє чи параметри можна використовувати для
//апроксимації даних в V функцією
//I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh-Iph-Iph}
//begin
//  Result:=ExpParamIsBad(V,n,Rs,I0,Rsh)or(Iph<1e-12)or(Iph>1);
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

//Function ExpIV(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - n;
//Variab[1] - Rs;
//Variab[2] - I0;
//Variab[3] - Rsh}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=Variab[2]*(exp((AP^.X[i]-AP^.Y[i]*Variab[1])/(Variab[0]*Kb*AP^.T))-1)
//      +(AP^.X[i]-AP^.Y[i]*Variab[1])/Variab[3]-AP^.Y[i];
//    Result:=Result+Zi*Zi/sqr(AP^.Y[i]);
//   end;
//end;

//Function ExpIVLong(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - n;
//Variab[1] - Rs;
//Variab[2] - I0;
//Variab[3] - Rsh}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
////  Zi:=Full_IV(AP^.X[i],Variab[0]*Kb*AP^.T,Variab[1],Variab[2],Variab[3],0)-AP^.Y[i];
//{}  Zi:=Full_IV(AP^.X[i],Variab[0]*Kb*AP^.T,Variab[1],Variab[2],1e13,0)
//      +(AP^.X[i]-AP^.Y[i]*Variab[1])/Variab[3]-AP^.Y[i];
//{ }
//    Result:=Result+Zi*Zi/sqr(AP^.Y[i]);
//   end;
//end;

//Function ExpIVLight(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh-Iph
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - n;
//Variab[1] - Rs;
//Variab[2] - I0;
//Variab[3] - Rsh
//Variab[4] - Iph}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=Variab[2]*(exp((AP^.X[i]-AP^.Y[i]*Variab[1])/(Variab[0]*Kb*AP^.T))-1)
//      +(AP^.X[i]-AP^.Y[i]*Variab[1])/Variab[3]-AP^.Y[i]-Variab[4];
//    Result:=Result+Zi*Zi/abs(AP^.Y[i]);
//   end;
//end;
//
//Function ExpIVLight_Shot(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I0(exp(q(V-IRs)/nkT)-1)+(V-IRs)/Rsh-Iph
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - n;
//Variab[1] - Rs;
//Variab[2] - I0;
//Variab[3] - Rsh
//Variab[4] - Iph;
//розрахунок проводиться лише для половини точок}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to (High(AP^.X) div 2) do
//   begin
//   Zi:=Variab[2]*(exp((AP^.X[i]-AP^.Y[i]*Variab[1])/(Variab[0]*Kb*AP^.T))-1)
//      +(AP^.X[i]-AP^.Y[i]*Variab[1])/Variab[3]-AP^.Y[i]-Variab[4];
//    Result:=Result+Zi*Zi{/abs(AP^.Y[i])};
//   end;
//end;
//

//Function Exp2(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//при апроксимації формулою
//I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp(V/n2kT)-1]
//Variab - значення параметрів, очікується, що
//Variab[0] - n1;
//Variab[1] - Rs1;
//Variab[2] - I01;
//Variab[3] - n2;
//Variab[4] - I02;
//}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=Full_IV(AP^.X[i],Variab[0]*Kb*AP^.T,Variab[1],Variab[2],1e13,0)+
//       Variab[4]*(exp(AP^.X[i]/(Variab[3]*Kb*AP^.T))-1)-AP^.Y[i];
//    Result:=Result+Zi*Zi/sqr(AP^.Y[i]);
//   end;
//end;
//
//Function Exp2Full(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//при апроксимації формулою
//I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp((V-IRs2)/n2kT)-1]
//Variab - значення параметрів, очікується, що
//Variab[0] - n1;
//Variab[1] - Rs1;
//Variab[2] - I01;
//Variab[3] - n2;
//Variab[4] - I02;
//Variab[5] - Rs2;
//}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=Full_IV(AP^.X[i],Variab[0]*Kb*AP^.T,Variab[1],Variab[2],1e13,0)+
//       Full_IV(AP^.X[i],Variab[3]*Kb*AP^.T,Variab[5],Variab[4],1e13,0)-AP^.Y[i];
//    Result:=Result+Zi*Zi/sqr(AP^.Y[i]);
//   end;
//end;

//Function DbGaus(T,A1,Fb10,sig1,Fb20,sig2:double):double;
//var temp,temp2:double;
//begin
//temp:=Kb*T;
//temp2:=7.021e-4*sqr(T)/(1108+T);
//Result:=-temp*ln(A1*exp(-(Fb10-temp2)/temp+sqr(sig1)/2/sqr(temp))+
//               (1-A1)*exp(-(Fb20-temp2)/temp+sqr(sig2)/2/sqr(temp)));
//end;



//Function DbGausFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//при апроксимації формулою
//I=I01[exp((V-IRs1)/n1kT)-1]+I02[exp((V-IRs2)/n2kT)-1]
//Variab - значення параметрів, очікується, що
//Variab[0] - n1;
//Variab[1] - Rs1;
//Variab[2] - I01;
//Variab[3] - n2;
//Variab[4] - I02;
//Variab[5] - Rs2;
//}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=DbGaus(AP^.X[i],Variab[0],Variab[1],Variab[2],Variab[3],Variab[4])
//        -AP^.Y[i];
//    Result:=Result+Zi*Zi{/abs(AP^.Y[i])};
//   end;
//end;


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
//
//


//Function LamLightParamIsBad(V:PVector;n0,Rs0,Rsh0,Isc0,Voc0:double):boolean;
//{перевіряє чи параметри можна використовувати для
//апроксимації ВАХ при освітленні в V функцію Ламверта}
//var nkT,t1,t2:double;
//begin
//  Result:=true;
//  if V^.T<=0 then Exit;
//  nkT:=n0*Kb*V^.T;
//  if n0<=0 then Exit;
//  if Rs0<=0 then Exit;
//  if Rsh0<=0 then Exit;
//  if Isc0<=0 then Exit;
//  if Voc0<=0 then Exit;
//  if 2*(Voc0+Isc0*Rs0)/nkT > ln(1e38) then Exit;
//  if exp(Voc0/nkT) = exp(Isc0*Rs0/nkT) then Exit;
//  t1:=(Rs0*Isc0-Voc0)/nkT;
//  if t1 > ln(1e38) then Exit;
//  t2:=Rsh0*Rs0/nkT/(Rs0+Rsh0)*
//      (Voc0/Rsh0+(Isc0+(Rs0*Isc0-Voc0)/Rsh0)/(1-exp(t1))+V^.X[V^.n-1]/Rs0);
//  if abs(t2) > ln(1e38) then Exit;
//  if Rs0/nkT*(Isc0-Voc0/(Rs0+Rsh0))*exp(-Voc0/nkT)*exp(t2)/(1-exp(t1))> ln(2e38)then Exit;
//  Result:=false;
//end;

//Function FG_LamLightShot(AP:Pvector; n,Rs,Rsh,Isc,Voc:double;
//                  var RezF:array of double;
//                  var RezSum:double):word;
//{функція для апроксимації ВАХ при освітленні
//функцією Ламбертаза МНК;
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//цей масив містить 5 значеннь,
//Variab[0] - n,
//Variab[1] - Rs,
//Variab[2] -  Rsh,
//Variab[3] -  Isc,
//Variab[4] - Voc;
//RezF - значення функцій, отриманих як похідні
//від квадратичної форми;
//RezF[0] - похідна по n,
//RezF[1] - похідна по Rs,
//RezF[2] - похідна по Rsh,
//RezSum - значення квадратичної форми}
//var i:integer;
//   Yi,Zi,Wi,GVI,Z1,Y1,F1,F12,F21,F22,F3,F31,
//   ZIi,nkT,W_W1:double;
//begin
//
//
//for I := 0 to High(RezF) do  RezF[i]:=555;
// RezSum:=555;
//Result:=1;
//
//if AP^.T<=0 then Exit;
//if LamLightParamIsBad(AP,n,Rs,Rsh,Isc,Voc) then Exit;
//
//for I := 0 to High(RezF) do  RezF[i]:=0;
//  RezSum:=0;
//
//nkT:=n*kb*AP^.T;
//GVI:=(exp(Isc*Rs/nkT)-exp(Voc/nkT));
//Z1:=Rsh/(Rs+Rsh)*((Isc+(Rs*Isc-Voc)/Rsh)/(1-exp((Rs*Isc-Voc)/nkT))+Voc/Rsh);
//Y1:=Voc/Rsh+(Isc+(Rs*Isc-Voc)/Rsh)/(1-exp((Rs*Isc-Voc)/nkT));
//F1:=exp((Isc*Rs+Voc)/nkT)*(Isc*Rs-Voc)*(Isc*(Rs+Rsh)-Voc)/(nkT*n*(Rs+Rsh)*GVI*GVI);
//F12:=(exp(2*Voc/nkT)*(Rs+Rsh)*(nkT+Isc*Rs-Voc)+
//   exp(2*Isc*Rs/nkT)*((nkT-Isc*Rs)*(Rs+Rsh)+Rs*Voc)+
//   exp((Isc*Rs+Voc)/nkT)*(-2*nkT*(Rs+Rsh)+(Rs*(Isc*Rs-Voc)*(Isc*(Rs+Rsh)-Voc))/nkT+Rsh*Voc))/sqr(GVI);
//F21:=(exp(2*Isc*Rs/nkT)*nkT*Voc-exp((Isc*Rs+Voc)/nkT)*
//    (Isc*(Rs + Rsh)*(Isc*(Rs + Rsh)-Voc)+nkT*Voc))/
//    (sqr(GVI)*nkT*sqr((Rs + Rsh)));
//F22:=(-exp(Voc/nkT)*nkT*(Rs + Rsh) +
//   exp(Isc*Rs/nkT)*((nkT - Isc*Rs)*(Rs + Rsh) + Rs*Voc))*
//   (exp(Isc*Rs/nkT)*nkT*(Isc*(Rs + Rsh)*(Rs+Rsh) - Rsh*Voc) +
//   exp(Voc/nkT)*(-Isc*(nkT + Isc*Rs)*(Rs + Rsh)*(Rs+Rsh) +
//   (nkT*Rsh + Isc* Rs* (Rs + Rsh))* Voc))/(nkT*Rs*sqr(GVI)*(Isc*(Rs+Rsh)-Voc));
//F3:=Voc/(1-exp((Voc-Isc*Rs)/nkT));
//F31:=nkT*Voc/(Rs*(Isc-Voc/(Rs+Rsh)));
//
//for I := 0 to High(AP^.X) do
//   begin
//     Yi:=Rs/nkT*(Isc-Voc/(Rs+Rsh))*exp(-Voc/nkT)/(1-exp((Rs*Isc-Voc)/nkT))*
//     exp(Rsh*Rs/nkT/(Rs+Rsh)*(AP^.X[i]/Rs+Y1));
//     Zi:=AP^.X[i]/(Rs+Rsh)-Z1+nkT/Rs*Lambert(Yi)-AP^.Y[i];
//     Wi:=Lambert(Yi);
//     if Wi=555 then Exit;
//     W_W1:=Wi/(Wi+1);
//     ZIi:=Zi/abs(AP^.Y[i]);
//
//   RezSum:=RezSum+ZIi*Zi;
//
//    RezF[0]:=RezF[0]+ZIi*(F1+Kb*AP^.T/Rs*Wi-
//              W_W1/(n*Rs*(Rs+Rsh))*(F12+Rsh*AP^.X[i]));
//
//    RezF[1]:=RezF[1]+ZIi*(-AP^.X[i]/sqr(Rs+Rsh)+F21-nkT/sqr(Rs)*Wi+
//            W_W1/(Rs*sqr(Rs+Rsh))*(F22-Rsh*AP^.X[i]));
//
//    RezF[2]:=RezF[2]+ZIi*(F3-AP^.X[i]+F31*Wi)/((1+Wi)*sqr(Rs+Rsh));
//   end;
//
//  for I := 0 to High(RezF) do RezF[i]:=RezF[i]*2;
//Result:=0;
//end;

//Function aSdal_LamLightShot(AP:Pvector;num:word;al,F,n,Rs,Rsh,Isc,Voc:double):double;
//{розраховується значення похідної квадратичної форми
//яка виникає при апроксимації ВАХ при освітленні
//функцією Ламберта;
//ця функція використовується при
//покоординатному спуску і обчислюється
//похідна по al, яка описує зміну
//того чи іншого параметра апроксимації
//Param = Param - al*F,
//де  Param = n  при num = 0
//Param = Rs при num = 1
//Param = Rsh при num = 2
//F - значення похідної квадритичної
//форми по Param при al = 0
//(те, що повертає функція FG_LamLightShot в RezF)
//}
//var i:integer;
//    Yi,Zi,Wi,GVI,Z1,Y1,F1,F12,F21,F22,F3,F31,
//    nkT,W_W1,Rez:double;
//begin
//Result:=555;
//if LamLightParamIsBad(AP,n,Rs,Rsh,Isc,Voc) then  Exit;
//
//try
//case num of
//   0:n:=n-al*F;
//   1:Rs:=Rs-al*F;
//   2:Rsh:=Rsh-al*F;
// end;//case
//
//if LamLightParamIsBad(AP,n,Rs,Rsh,Isc,Voc) then  Exit;
//nkT:=n*kb*AP^.T;
//GVI:=(exp(Isc*Rs/nkT)-exp(Voc/nkT));
//Z1:=Rsh/(Rs+Rsh)*((Isc+(Rs*Isc-Voc)/Rsh)/(1-exp((Rs*Isc-Voc)/nkT))+Voc/Rsh);
//Y1:=Voc/Rsh+(Isc+(Rs*Isc-Voc)/Rsh)/(1-exp((Rs*Isc-Voc)/nkT));
//F1:=exp((Isc*Rs+Voc)/nkT)*(Isc*Rs-Voc)*(Isc*(Rs+Rsh)-Voc)/(nkT*n*(Rs+Rsh)*GVI*GVI);
//F12:=(exp(2*Voc/nkT)*(Rs+Rsh)*(nkT+Isc*Rs-Voc)+
//   exp(2*Isc*Rs/nkT)*((nkT-Isc*Rs)*(Rs+Rsh)+Rs*Voc)+
//   exp((Isc*Rs+Voc)/nkT)*(-2*nkT*(Rs+Rsh)+(Rs*(Isc*Rs-Voc)*(Isc*(Rs+Rsh)-Voc))/nkT+Rsh*Voc))/sqr(GVI);
//F21:=(exp(2*Isc*Rs/nkT)*nkT*Voc-exp((Isc*Rs+Voc)/nkT)*
//    (Isc*(Rs + Rsh)*(Isc*(Rs + Rsh)-Voc)+nkT*Voc))/
//    (sqr(GVI)*nkT*sqr((Rs + Rsh)));
//F22:=(-exp(Voc/nkT)*nkT*(Rs + Rsh) +
//   exp(Isc*Rs/nkT)*((nkT - Isc*Rs)*(Rs + Rsh) + Rs*Voc))*
//   (exp(Isc*Rs/nkT)*nkT*(Isc*(Rs + Rsh)*(Rs+Rsh) - Rsh*Voc) +
//   exp(Voc/nkT)*(-Isc*(nkT + Isc*Rs)*(Rs + Rsh)*(Rs+Rsh) +
//   (nkT*Rsh + Isc* Rs* (Rs + Rsh))* Voc))/(nkT*Rs*sqr(GVI)*(Isc*(Rs+Rsh)-Voc));
//F3:=Voc/(1-exp((Voc-Isc*Rs)/nkT));
//F31:=nkT*Voc/(Rs*(Isc-Voc/(Rs+Rsh)));
//
//Rez:=0;
//for I := 0 to High(AP^.X) do
//   begin
//     Yi:=Rs/nkT*(Isc-Voc/(Rs+Rsh))*exp(-Voc/nkT)/(1-exp((Rs*Isc-Voc)/nkT))*
//     exp(Rsh*Rs/nkT/(Rs+Rsh)*(AP^.X[i]/Rs+Y1));
//     Zi:=AP^.X[i]/(Rs+Rsh)-Z1+nkT/Rs*Lambert(Yi)-AP^.Y[i];
//     Wi:=Lambert(Yi);
//     if Wi=555 then Exit;
//     W_W1:=Wi/(Wi+1);
//{ Yi:=Rs/nkT*(Isc-Voc/(Rs+Rsh))*exp(-Voc/nkT)/(1-exp((Rs*Isc-Voc)/nkT))*
//     exp(Rsh*Rs/nkT/(Rs+Rsh)*(AP^.X[i]/Rs+Voc/Rsh+(Isc+(Rs*Isc-Voc)/Rsh)/
//        (1-exp((Rs*Isc-Voc)/nkT))));
// Zi:=AP^.X[i]/Rs-Rsh/(Rs+Rsh)*((Isc+(Rs*Isc-Voc)/Rsh)/(1-exp((Rs*Isc-Voc)/nkT))+Voc/Rsh+AP^.X[i]/Rs)+
//     nkT/Rs*Lambert(Yi)-AP^.Y[i];
//     Wi:=Lambert(Yi);
//     if Wi=555 then Exit;
//     W_W1:=Wi/(Wi+1);{}
//
//     case num of
//      0: Rez:=Rez+Zi/abs(AP^.Y[i])*(F1+Kb*AP^.T/Rs*Wi-
//                  W_W1/(n*Rs*(Rs+Rsh))*(F12+Rsh*AP^.X[i]));
//
//      1: Rez:=Rez+Zi/abs(AP^.Y[i])*(-AP^.X[i]/sqr(Rs+Rsh)+F21-nkT/sqr(Rs)*Wi+
//                W_W1/(Rs*sqr(Rs+Rsh))*(F22-Rsh*AP^.X[i]));
//
//      2: Rez:=Rez+Zi/abs(AP^.Y[i])*(F3-AP^.X[i]+F31*Wi)/((1+Wi)*sqr(Rs+Rsh));
//  {0:Rez:=Rez+Zi/abs(AP^.Y[i])*(exp((Isc*Rs+Voc)/nkT)*(Isc*Rs-Voc)*(Isc*(Rs+Rsh)-Voc)/
//          (nkT*n*(Rs+Rsh)*(exp(Isc*Rs/nkT)-exp(Voc/nkT))*
//          (exp(Isc*Rs/nkT)-exp(Voc/nkT)))+
//          kb*AP^.T/Rs*Wi-W_W1/(nkT*n*Rs*(Rs+Rsh)*
//          (exp(Isc*Rs/nkT)-exp(Voc/nkT))*(exp(Isc*Rs/nkT)-exp(Voc/nkT)))*
//          (exp(2*Isc*Rs/nkT)*nkT*(nkT*(Rs+Rsh)-Isc*Rs*(Rs+Rsh)+
//                                 Rsh*AP^.X[i]+Rs*Voc)+
//          exp(2*Voc/nkT)*nkT*(nkT*(Rs+Rsh)+Isc*Rs*(Rs+Rsh)+Rsh*AP^.X[i]-
//                                 Rs*Voc-Rsh*Voc)+
//          exp((Isc*Rs+Voc)/nkT)*(-2*nkT*nkT*(Rs+Rsh)+Rs*(Isc*Rs-Voc)*(Isc*(Rs+Rsh)-Voc)+
//                                nkT*Rsh*(-2*AP^.X[i]+Voc))));
//
//  1:Rez:=Rez+Zi/abs(AP^.Y[i])*(-AP^.X[i]/Rs/Rs-Rsh/(Rs+Rsh)*(Isc/(Rsh*(1-exp((Isc*Rs-Voc)/nkT)))-
//                         AP^.X[i]/Rs/Rs+exp((Isc*Rs-Voc)/nkT)*Isc*(Isc+(Isc*Rs-Voc)/Rsh)/
//                         (nkT*(exp((Isc*Rs-Voc)/nkT)-1)*(exp((Isc*Rs-Voc)/nkT)-1)))+
//                         Rsh/(Rs+Rsh)/(Rs+Rsh)*(AP^.X[i]/Rs+Voc/Rsh+(Isc+(Isc*Rs-Voc)/Rsh)/
//                         (1-exp((Isc*Rs-Voc)/nkT)))-nkT/Rs/Rs*Wi+
//          W_W1/(nkT*Rs*Rs*(Rs+Rsh)*(Rs+Rsh)*(Isc*(Rs+Rsh)-Voc)*
//          (exp(Isc*Rs/nkT)-exp(Voc/nkT))*(exp(Isc*Rs/nkT)-exp(Voc/nkT)))*
//          (exp((Isc*Rs+Voc)/nkT)*(Isc*Isc*Isc*Rs*Rs*(Rs+Rsh)*(Rs+Rsh)*(Rs+Rsh)-
//                                  2*Isc*Isc*Rs*Rs*(Rs+Rsh)*(Rs+Rsh)*Voc+
//                                  nkT*Rsh*Voc*(2*nkT*(Rs+Rsh)+Rs*(-2*AP^.X[i]+Voc))-
//                                  Isc*(Rs+Rsh)*(2*nkT*nkT*(Rs+Rsh)*(Rs+Rsh)-Rs*Rs*Voc*Voc+
//                                                nkT*Rs*Rsh*(Voc-2*AP^.X[i])))-
//           exp(2*Isc*Rs/nkT)*nkT*(Isc*Isc*Rs*(Rs+Rsh)*(Rs+Rsh)*(Rs+Rsh)+
//                                  Rsh*Voc*(nkT*(Rs+Rsh)+Rs*(Voc-AP^.X[i]))-
//                                  Isc*(Rs+Rsh)*(nkT*(Rs+Rsh)*(Rs+Rsh)+
//                                                Rs*(-Rsh*AP^.X[i]+Rs*Voc+2*Rsh*Voc)))+
//           exp(2*Voc/nkT)*nkT*(Isc*Isc*Rs*(Rs+Rsh)*(Rs+Rsh)*(Rs+Rsh)-
//                               Rsh*(nkT*(Rs+Rsh)-Rs*AP^.X[i])*Voc+
//                               Isc*(Rs+Rsh)*(nkT*(Rs+Rsh)*(Rs+Rsh)-
//                                             Rs*(Rs*Voc+Rsh*(Voc+AP^.X[i]))))));
//
//  2:Rez:=Rez+Zi/abs(AP^.Y[i])*((Rs*(Isc*(Rs+Rsh)-Voc)*(exp(Voc/nkT)*AP^.X[i]+
//                         exp(Isc*Rs/nkT)*(Voc-AP^.X[i]))+
//                         (exp(Isc*Rs/nkT)-exp(Voc/nkT))*nkT*(Rs+Rsh)*Voc*Wi)/
//                         ((1+Wi)*Rs*(Rs+Rsh)*(Rs+Rsh)*(Isc*(Rs+Rsh)-Voc)*
//                          (exp(Isc*Rs/nkT)-exp(Voc/nkT))));}
//
//      end; //case
//   end;
//Rez:=2*F*Rez;
//Result:=Rez;
//except
//end;//try
//end;
//

Procedure Smoothing (A:Pvector; var B:PVector);
{в В розміщується сглажена функція даних в А;
а саме проводиться усереднення по трьом точкам,
причому усереднення з ваговими коефіцієнтами,
які визначаються розподілом Гауса з дисперсією 0.6;
якщо у вихідному масиві кількість точок менша трьох,
то у результуючому буде нульова кількість}
const W0=17;W1=66;W2=17;
{вагові коефіцієнти для нульової, першої та другої точок}
var i:integer;
begin
if A^.n<3 then
          begin
          B^.n:=0;
          Exit
          end;
SetLenVector(B,A^.n);
B^.name:=A^.name;
B^.T:=A^.T;
B^.N_begin:=A^.N_begin;
B^.N_end:=A^.N_end;
//SetLength(B^.Y, B^.n);
for i:=1 to High(B^.X)-1 do
begin
B^.x[i]:=A^.x[i];
B^.y[i]:=(W0*A^.y[i-1]+W1*A^.y[i]+W2*A^.y[i+1])/(W0+W1+W2);
end;
B^.x[0]:=A^.x[0];
B^.x[High(B^.X)]:=A^.x[High(B^.X)];
B^.y[0]:=(W1*A^.y[0]+W2*A^.y[1])/(W1+W2);
B^.y[High(B^.X)]:=(W1*A^.y[High(B^.X)]+W0*A^.y[High(B^.X)-1])/(W1+W0);
end;


Procedure Median (A:Pvector; var B:PVector);
{в В розміщується результат дії на дані в А
медіанного трьохточкового фільтра;
якщо у вихідному масиві кількість точок менша трьох,
то у результуючому буде нульова кількість}
Function Med(a,b,c:double):double;
{повертає середнє за величиною з трьох чисел a, b, c}
 begin
  if a>b then swap(a,b);
  if b>c then swap(b,c);
  if a>b then swap(a,b);
  Result:=b;
  
  {Result:=b;
  if ((a<b)or(a=b))and((a>c)or(a=c)) then Result:=a;
  if ((a>b)or(a=b))and((a<c)or(a=c)) then Result:=a;
  if ((b<a)or(a=b))and((b>c)or(b=c)) then Result:=b;
  if ((b>a)or(a=b))and((b<c)or(b=c)) then Result:=b;
  if ((c<b)or(c=b))and((c>a)or(c=a)) then Result:=c;
  if ((c>b)or(c=b))and((c<a)or(c=a)) then Result:=c;}
 end;

var i:integer;
begin
if A^.n<3 then
          begin
          B^.n:=0;
          Exit
          end;
SetLenVector(B,A^.n);
B^.name:=A^.name;
B^.T:=A^.T;
B^.N_begin:=A^.N_begin;
B^.N_end:=A^.N_end;
for i:=1 to High(B^.X)-1 do
begin
B^.x[i]:=A^.x[i];
B^.y[i]:=Med(A^.y[i-1],A^.y[i],A^.y[i+1]);;
end;
B^.x[0]:=A^.x[0];
B^.x[High(B^.X)]:=A^.x[High(B^.X)];
B^.y[0]:=A^.Y[0];
B^.y[High(B^.X)]:=A^.y[High(B^.X)];
end;

Procedure Diferen (A:Pvector; var B:PVector);
{в В розміщується похідна від значень, розташованих
у векторі А;
якщо у вихідному масиві кількість точок менша трьох,
то у результуючому буде нульова кількість}
var i:integer;
begin
if A^.n<3 then
          begin
          B^.n:=0;
          Exit
          end;
SetLenVector(B,A^.n);
B^.N_begin:=A^.N_begin;
B^.N_end:=B^.N_end;
B^.name:=A^.name;
B^.T:=A^.T;
for i:=0 to High(B^.X) do
 begin
 B^.X[i]:=A^.X[i];
 B^.Y[i]:=Poh(A,i);
 end;
end;

Function Lagrang(A:Pvector; x:double):double;
{функція розрахунку значення функції в точці х використовуючи
поліном Лагранжа, побудований на основі набору даних в масиві A}
 var i,j:word;
     t1,t2:double;
  begin
   Result:=555;
   if (x-A^.X[High(A^.X)])*(x-A^.X[0])>0 then Exit;
   t1:=0;
   for i:=0 to High(A^.X) do
     begin
       t2:=1;
       for j:=0 to High(A^.X) do
         if (j<>i) then
          t2:=t2*(x-A^.X[j])/(A^.X[i]-A^.X[j]);
           //for j:=0 to High(A^.X) do
       t1:=t1+A^.Y[i]*t2;
     end;
  Result:=t1;
  end;

Function Splain3(V:Pvector; x:double):double;
{функція розрахунку значення функції в точці х використовуючи
кубічні сплайни, побудовані на основі набору даних в масиві V
Result=Ai+Bi(X-Xi)+Ci(X-Xi)^2+Di(X-Xi)^3 при Xi-1<=X<=Xi}

 var B,C,D,Bt,Dl,AA,BB,H:TArrSingle;
      nk,i:integer;
  begin
   Result:=555;

   if (x-V^.X[High(V^.X)])*(x-V^.X[0])>0 then Exit;
   nk:=High(V^.X);
   if nk<1 then Exit;
   SetLength(B,nk);
   SetLength(C,nk);
   SetLength(D,nk);
   SetLength(Bt,nk);
   SetLength(Dl,nk);
   SetLength(AA,nk);
   SetLength(BB,nk);
   SetLength(H,nk);
   for I := 0 to nk - 1 do
       H[i]:=V^.X[i+1]-V^.X[i];

   Bt[0]:=1;
   Dl[0]:=1;
   for I := 1 to nk - 1 do
     begin
       Bt[i]:=2*(H[i-1]+H[i]);
       Dl[i]:=3*((V^.Y[i+1]-V^.Y[i])/H[i]-(V^.Y[i]-V^.Y[i-1])/H[i-1]);
     end;

  AA[0]:=0;
  BB[0]:=1;

    AA[1]:=-H[1]/Bt[1];
    BB[1]:=(Dl[1]-H[0])/Bt[1];
    for I := 2 to nk - 2 do
     begin
       AA[i]:=-H[i]/(Bt[i]+H[i-1]*AA[i-1]);
       BB[i]:=(Dl[i]-H[i-1]*BB[i-1])/(Bt[i]+H[i-1]*AA[i-1]);
     end;
   AA[nk-1]:=0;
   BB[nk-1]:=(Dl[nk-1]-H[nk-2]*BB[nk-2])/(Bt[nk-1]+H[nk-2]*AA[nk-2]);

  C[nk-1]:=BB[nk-1];
  for I := nk-2 downto 0 do
    C[i]:=AA[i]*C[i+1]+BB[i];

 D[nk-1]:=-C[nk-1]/3/H[nk-1];
 B[nk-1]:=(V^.Y[nk]-V^.Y[nk-1])/H[nk-1]-2/3*C[nk-1]*H[nk-1];

 for I := 0 to nk-2 do
   begin
     D[i]:=(C[i+1]-C[i])/3/H[i];
     B[i]:=(V^.Y[i+1]-V^.Y[i])/H[i]-H[i]/3*(C[i+1]+2*C[i]);
   end;

  for i:=0 to High(V^.X)-1 do
    if (x-V^.X[i])*(x-V^.X[i+1])<=0 then Break;

  Result:=V^.Y[i]+B[i]*(x-V^.X[i])+C[i]*sqr((x-V^.X[i]))+D[i]*(x-V^.X[i])*sqr((x-V^.X[i]));
  end;

Procedure Splain3Vec(V:Pvector; beg:double; step:double; var Rez:Pvector);
{розраховується інтерполяція даних у векторі V з
використанням кубічних сплайнів, починаючи з точки з координатою
beg і з кроком step;
результат заноситься в Rez;
якщо почак вибрано неправильно (не потрапляє в діапазон зміни
абсциси V, то в результуючому векторі довжина нульова}

 var B,C,D,Bt,Dl,AA,BB,H:TArrSingle;
      nk,i,j:integer;
      temp:double;
  begin
   SetLenVector(Rez,0);
   if (beg-V^.X[High(V^.X)])*(beg-V^.X[0])>0 then Exit;

   nk:=High(V^.X);
   if nk<1 then Exit;
   SetLength(B,nk);
   SetLength(C,nk);
   SetLength(D,nk);
   SetLength(Bt,nk);
   SetLength(Dl,nk);
   SetLength(AA,nk);
   SetLength(BB,nk);
   SetLength(H,nk);
   for I := 0 to nk - 1 do
       H[i]:=V^.X[i+1]-V^.X[i];

   Bt[0]:=1;
   Dl[0]:=1;
   for I := 1 to nk - 1 do
     begin
       Bt[i]:=2*(H[i-1]+H[i]);
       Dl[i]:=3*((V^.Y[i+1]-V^.Y[i])/H[i]-(V^.Y[i]-V^.Y[i-1])/H[i-1]);
     end;

  AA[0]:=0;
  BB[0]:=1;

    AA[1]:=-H[1]/Bt[1];
    BB[1]:=(Dl[1]-H[0])/Bt[1];
    for I := 2 to nk - 2 do
     begin
       AA[i]:=-H[i]/(Bt[i]+H[i-1]*AA[i-1]);
       BB[i]:=(Dl[i]-H[i-1]*BB[i-1])/(Bt[i]+H[i-1]*AA[i-1]);
     end;
   AA[nk-1]:=0;
   BB[nk-1]:=(Dl[nk-1]-H[nk-2]*BB[nk-2])/(Bt[nk-1]+H[nk-2]*AA[nk-2]);

  C[nk-1]:=BB[nk-1];
  for I := nk-2 downto 0 do
    C[i]:=AA[i]*C[i+1]+BB[i];

 D[nk-1]:=-C[nk-1]/3/H[nk-1];
 B[nk-1]:=(V^.Y[nk]-V^.Y[nk-1])/H[nk-1]-2/3*C[nk-1]*H[nk-1];

 for I := 0 to nk-2 do
   begin
     D[i]:=(C[i+1]-C[i])/3/H[i];
     B[i]:=(V^.Y[i+1]-V^.Y[i])/H[i]-H[i]/3*(C[i+1]+2*C[i]);
   end;

  i:=0;
  temp:=beg;
  repeat
   inc(i);
   temp:=temp+step;
  until (temp>V^.X[High(V^.X)]);

  SetLenVector(Rez,i);
  for i:=0 to High(Rez^.X) do
   begin
    temp:=beg+i*step;
    Rez^.X[i]:=temp;
    for j:=0 to High(V^.X)-1 do
       if (temp-V^.X[j])*(temp-V^.X[j+1])<=0 then Break;
    Rez^.Y[i]:=V^.Y[j]+B[j]*(temp-V^.X[j])+C[j]*sqr((temp-V^.X[j]))
              +D[j]*(temp-V^.X[j])*sqr((temp-V^.X[j]));
   end;
 Rez^.T:=V^.T;

  end;



Function Int_Trap(A:Pvector):double;
{повертає результат інтегрування за методом
трапецій по даним з масиву А;
вважається, що межі інтегралу простягаються на
весь діапазон зміни А^.X}
var i:integer;
begin
Result:=0;
for I := 1 to High(A^.X) do
   Result:=Result+(A^.X[i]-A^.X[i-1])*(A^.Y[i]+A^.Y[i-1]);
Result:=Result/2;
end;

Function GoldenSection(fun:TFunSingle; a, b:double):double;
{повертає координату мінімума функції fun
на відрізку [a,b], вважається,
що там лише один мінімум;
використовується метод золотого перерізу}
const al=0.618;
      bet=0.382;
var eps, x1, x2, y1, y2:double;
begin
eps:=1e-6*abs(b-a);
x1:=al*a+bet*b;
x2:=al*b+bet*a;
y1:=fun(x1);
y2:=fun(x2);
repeat
if y1<y2 then
 begin
   b:=x2;
   x2:=x1;
   y2:=y1;
   x1:=al*a+bet*b;
   y1:=fun(x1);
 end
         else
  begin
   a:=x1;
   x1:=x2;
   y1:=y2;
   x2:=al*b+bet*a;
   y2:=fun(x2);
  end;
until abs(b-a)<eps;
Result:=(a+b)/2;
end;

Function Lambert(x:double):double;
{обчислює значення функції Ламберта}
var temp1,temp2,eps:double;
    i:integer;
begin
  if x=0 then
     begin
       Result:=0;
       Exit;
     end;
  temp1:=0;
  i:=0;
  eps:=1;
  repeat
    temp2:=temp1-(temp1*exp(temp1)-x)/(exp(temp1)*(temp1+1)-
           (temp1+2)*(temp1*exp(temp1)-x)/(2*temp1+2));
    if temp2=0 then
         begin
           i:=1000000;
           Break;
         end;
    eps:=abs((temp2-temp1)/temp2);
    temp1:=temp2;
    inc(i);
  until (eps<1e-7)or(i>1e5);
  if (i>1e5) then Result:=555
             else Result:=temp2;
end;

Procedure LambertIV (A:Pvector; n,Rs,I0,Rsh:double; var B:PVector);
{в В розміщується результат розрахунку
ВАХ по даним напруги з А за допомогою
функції Ламберта по значеннях параметрів n,Rs,I0,Rsh}
var i:integer;
begin
B^.n:=0;
if (n=0) or(Rs=0) or (I0=0) or (Rsh=0) then Exit;
if (A^.n=0) or (A^.T=0) then Exit;
SetLenVector(B,A^.n);
for i:=0 to High(B^.X) do
 begin
   B^.X[i]:=A^.X[i];
{   B^.Y[i]:=Kb*A^.T*n/Rs*Lambert(Rs*Rsh*I0/(Kb*A^.T*n*(Rsh+Rs))*exp(Rsh*(B^.X[i]+Rs*I0)/(Kb*A^.T*n*(Rsh+Rs))))+
             B^.X[i]/(Rsh+Rs)-I0*Rsh/(Rsh+Rs);}
{   B^.Y[i]:=Kb*A^.T*n/Rs*Lambert(Rs*I0/(Kb*A^.T*n)*exp((B^.X[i]+Rs*I0)/(Kb*A^.T*n)))+
             B^.X[i]/Rsh-I0;}

    B^.Y[i]:=LambertAprShot(B^.X[i], Kb*A^.T*n,Rs,I0,Rsh);
 end;
end;

Function LambertAprShot(V,E,Rs,I0,Rsh:double):double;
{розраховує апроксимацію ВАХ при напрузі V
за функцією Ламверта по значеннях параметрів Е,Rs,I0,Rsh,
Е=KbTn/q, використовується спрошений варіант,
справедливий для Rs<<Rsh}
begin
  Result:=555;
  if (E=0) or(Rs=0) or (I0=0) or (Rsh=0) then Exit;
  if (E=555) or(Rs=555) or (I0=555) or (Rsh=555) then Exit;
  Result:=E/Rs*Lambert(Rs*I0/(E)*exp((V+Rs*I0)/E))+
             V/Rsh-I0;
end;

Function LambertLightAprShot (V,E,Rs,I0,Rsh,Iph:double):double;
{розраховує апроксимацію освітленої ВАХ при напрузі V
за функцією Ламверта по значеннях параметрів Е,Rs,I0,Rsh,Iph
Е=KbTn/q}
begin
  Result:=555;
  if (E=0) or(Rs=0) or (I0=0) or (Rsh=0) then Exit;
  if (E=555) or(Rs=555) or (I0=555) or (Rsh=555) then Exit;
  Result:=V/Rs-Rsh*(Rs*Iph+Rs*I0+V)/Rs/(Rs+Rsh)+
          E/Rs*Lambert(Rs*I0*Rsh/E/(Rs+Rsh)*exp(Rsh*(Rs*Iph+Rs*I0+V)/E/(Rs+Rsh)));
end;

Function Full_IV(V,E,Rs,I0,Rsh,Iph:double):double;
{розраховує значення функції
I=I0*[exp(q(V-I Rs)/E)-1]+(V-I Rs)/Rsh-Iph)}
    Function I_V(mode:byte;I,V,I0,Rs,kT,Rsh,Iph:double):double;
    begin
      case mode of
         1:Result:=I-I0*exp((V-I*Rs)/kT)+I0+Iph;
       else Result:=I-I0*exp((V-I*Rs)/kT)+I0-(V-I*Rs)/Rsh+Iph;
      end;
    end;

var mode,md:byte;
    i:integer;
    a,b,c,min:double;
    bool:boolean;
begin
Result:=555;
if E=0 then Exit;
mode:=0;
if Rsh>=1e12 then mode:=1;
if Rs<=1e-4 then mode:=2;
if (Rsh>=1e12)and(Rs<=1e-4) then mode:=3;
case mode of
  2:Result:=I0*(exp(V/E)-1)+V/Rsh-Iph;
  3:Result:=I0*(exp(V/E)-1)-Iph;
  else
     begin
     if Rsh>1e12 then Rsh:=1e12;
     c:=I0*(exp(V/E)-1)-Iph;
     if c*Rs>88 then c:=10/Rs;

     if abs(c)<1e-8 then
          begin
           if Iph>0 then a:=-3e-2
                    else a:=0;
           b:=3e-2;
         end
           else
         begin
          a:=c;
          b:=c;
          try
          repeat
            a:=a-0.1*abs(c);
          until I_V(mode,a,V,I0,Rs,E,Rsh,Iph)<0;
          repeat
            b:=b+0.1*abs(c);
          until I_V(mode,b,V,I0,Rs,E,Rsh,Iph)>0;

//           a:=a-0.1*abs(c);
//           b:=b+0.1*abs(c);
//          until (I_V(mode,a,V,I0,Rs,E,Rsh,Iph)*I_V(mode,b,V,I0,Rs,E,Rsh,Iph)<=0);
          except
   showmessage('c='+floattostr(c)+#10+#13+
                'a='+floattostr(a)+#10+#13+
                'b='+floattostr(b));
          end;
         end;//else
     i:=0;
     md:=0;
     repeat
       inc(i);
       c:=(a+b)/2;
       if (I_V(mode,c,V,I0,Rs,E,Rsh,Iph)*I_V(mode,a,V,I0,Rs,E,Rsh,Iph)<=0)
           then b:=c
           else a:=c;
       if abs(a)<abs(b) then min:=abs(a)
                        else min:=abs(b);
       if a=0 then md:=1;
       if b=0 then md:=2;
       if (a=0) and (b=0) then md:=3;
       case md of
         1:bool:=abs((b-a)/b)<1e-8;
         2:bool:=abs((b-a)/a)<1e-8;
         3:bool:=true;
        else bool:=abs((b-a)/min)<1e-8;
       end;//case
     until ((i>1e6)or bool);
     if (i>1e6) then Exit;
     Result:=c;
    end;//else-case
end;//case
end;

Function Full_IV_A(V,E,Rs,I0,Rsh,Iph:double):double;
{розраховує значення функції
I=I0*[exp(q(V-I Rs)/E)-1]+(V-I Rs)/Rsh-Iph)}
    Function I_V(mode:byte;I,V,I0,Rs,kT,Rsh,Iph:double):double;
    begin
      case mode of
         1:Result:=I-I0*exp((V-I*Rs)/kT)+I0{+Iph};
       else Result:=I-I0*exp((V-I*Rs)/kT)+I0-(V-I*Rs)/Rsh{+Iph};
      end;
    end;

var mode,md:byte;
    i:integer;
    a,b,c,min:double;
    bool:boolean;
begin
Result:=555;
if E=0 then Exit;
mode:=0;
if Rsh>=1e12 then mode:=1;
if Rs<=1e-4 then mode:=2;
if (Rsh>=1e12)and(Rs<=1e-4) then mode:=3;
case mode of
  2:Result:=I0*(exp(V/E)-1)+V/Rsh-Iph;
  3:Result:=I0*(exp(V/E)-1)-Iph;
  else
     begin
     if Rsh>1e12 then Rsh:=1e12;
     c:=I0*(exp(V/E)-1){-Iph};
     {if abs(c)<1e-8 then
          begin
           if Iph>0 then a:=-3e-2
                    else a:=0;
           b:=3e-2;
         end
           else
         begin}
          a:=c;
          b:=c;
          repeat
           a:=a-0.1*abs(c);
           b:=b+0.1*abs(c);
          until (I_V(mode,a,V,I0,Rs,E,Rsh,Iph)*I_V(mode,b,V,I0,Rs,E,Rsh,Iph)<=0);
{         end;//else}
     i:=0;
     md:=0;
     repeat
       inc(i);
       c:=(a+b)/2;
       if (I_V(mode,c,V,I0,Rs,E,Rsh,Iph)*I_V(mode,a,V,I0,Rs,E,Rsh,Iph)<=0)
           then b:=c
           else a:=c;
       if abs(a)<abs(b) then min:=abs(a)
                        else min:=abs(b);
       if a=0 then md:=1;
       if b=0 then md:=2;
       if (a=0) and (b=0) then md:=3;
       case md of
         1:bool:=abs((b-a)/b)<1e-8;
         2:bool:=abs((b-a)/a)<1e-8;
         3:bool:=true;
        else bool:=abs((b-a)/min)<1e-8;
       end;//case
     until ((i>1e6)or bool);
     if (i>1e6) then Exit;
     Result:=c-Iph;
    end;//else-case
end;//case
end;

Function Full_IV_2Exp(V,E1,E2,Rs,I01,I02,Rsh,Iph:double):double;
{розраховує значення функції
I=I01*[exp(q(V-I Rs)/E1)-1]+I02*[exp(q(V-I Rs)/E2)-1]+(V-I Rs)/Rsh-Iph)}
    Function I_V(mode:byte;I,V,I01,I02,Rs,kT1,kT2,Rsh,Iph:double):double;
    begin
      case mode of
         1:Result:=I-I01*exp((V-I*Rs)/kT1)+I01-I02*exp((V-I*Rs)/kT2)+I02+Iph;
       else Result:=I-I01*exp((V-I*Rs)/kT1)+I01-I02*exp((V-I*Rs)/kT2)+I02-(V-I*Rs)/Rsh+Iph;
      end;
    end;

var mode,md:byte;
    i:integer;
    a,b,c,min:double;
    bool:boolean;
begin
Result:=555;
if (E1=0)or(E2=0) then Exit;
mode:=0;
if Rsh>=1e12 then mode:=1;
if Rs<=1e-4 then mode:=2;
if (Rsh>=1e12)and(Rs<=1e-4) then mode:=3;
case mode of
  2:Result:=I01*(exp(V/E1)-1)+I02*(exp(V/E2)-1)+V/Rsh-Iph;
  3:Result:=I01*(exp(V/E1)-1)+I02*(exp(V/E2)-1)-Iph;
  else
     begin
     if Rsh>1e12 then Rsh:=1e12;
     c:=I01*(exp(V/E1)-1)+I02*(exp(V/E2)-1)-Iph;
     if abs(c)<1e-8 then
          begin
           if Iph>0 then a:=-3e-2
                    else a:=0;
           b:=3e-2;
         end
           else
         begin
          a:=c;
          b:=c;
          repeat
           a:=a-0.1*abs(c);
           b:=b+0.1*abs(c);
          until (I_V(mode,a,V,I01,I02,Rs,E1,E2,Rsh,Iph)*I_V(mode,b,V,I01,I02,Rs,E1,E2,Rsh,Iph)<=0);
         end;//else
     i:=0;
     md:=0;
     repeat
       inc(i);
       c:=(a+b)/2;
       if (I_V(mode,c,V,I01,I02,Rs,E1,E2,Rsh,Iph)*I_V(mode,a,V,I01,I02,Rs,E1,E2,Rsh,Iph)<=0)
           then b:=c
           else a:=c;
       if abs(a)<abs(b) then min:=abs(a)
                        else min:=abs(b);
       if a=0 then md:=1;
       if b=0 then md:=2;
       if (a=0) and (b=0) then md:=3;
       case md of
         1:bool:=abs((b-a)/b)<1e-8;
         2:bool:=abs((b-a)/a)<1e-8;
         3:bool:=true;
        else bool:=abs((b-a)/min)<1e-8;
       end;//case
     until ((i>1e6)or bool);
     if (i>1e6) then Exit;
     Result:=c;
    end;//else-case
end;//case
end;


//Procedure VarRand(Xlo,Xhi:double; mode:TVar_Rand; var X:double);
//{випадковим чином задає значення змінної Х в діапазоні
//від Xlo до Xhi}
//begin
//  case mode of
// //  norm: X:=random*(Xhi-Xlo);
//   logar: X:=RandomLnAB(Xlo,Xhi);//exp(ln(Xlo)+random*(ln(Xhi)-ln(Xlo)));
//   cons:  X:=Xlo;
//   else  X:=RandomAB(Xlo,Xhi);//random*(Xhi-Xlo);
//  end;
//end;


Function MaxElemNumber(a:array of double):integer;
{повертає номер найбільшого елементу масиву}
var i:integer;
    temp:double;
begin
  Result:=0;
  if High(a)<0 then Exit;
  temp:=a[0];
  for I := 0 to High(a) do
   if Temp<a[i] then
     begin
       Result:=i;
       temp:=a[i];
     end;
end;

Function MinElemNumber(a:array of double):integer;
{повертає номер наменшого елементу масиву}
var i:integer;
    temp:double;
begin
  Result:=0;
  if High(a)<0 then Exit;
  temp:=a[0];
  for I := 0 to High(a) do
   if Temp>a[i] then
     begin
       Result:=i;
       temp:=a[i];
     end;
end;

//Function DoubleDiodFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]+(V-IRs)/Rsh
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - n1;
//Variab[1] - Rs;
//Variab[2] - I01;
//Variab[3] - Rsh
//Variab[4] - n2
//Variab[5] - I02;
//}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=Variab[2]*(exp((AP^.X[i]-AP^.Y[i]*Variab[1])/(Variab[0]*Kb*AP^.T))-1)
//      +Variab[5]*(exp((AP^.X[i]-AP^.Y[i]*Variab[1])/(Variab[4]*Kb*AP^.T))-1)
//      +(AP^.X[i]-AP^.Y[i]*Variab[1])/Variab[3]-AP^.Y[i];
//    Result:=Result+Zi*Zi/sqr(AP^.Y[i]);
//   end;
//end;


//Function LinEgF(x:double;Variab:array of double):double;
//var Fb,Vbb,nu:double;
//begin
//Fb:=0.775-7.021e-4*sqr(X)/(1108+X);
////Fb:=Variab[2]-7.021e-4*sqr(X)/(1108+X);
//Vbb:=Fb-Kb*X*ln((2.5e25*1.12*Power(X/300,3.0/2.0))/7.25e21);
//nu:=8.85e-12*11.7/1.6e-19/7.25e21;
//Result:=Fb-Variab[0]*Power(Vbb/nu,1.0/3.0)-
//        Kb*X*ln(Variab[0]*Variab[1]*4*3.14*Kb*X/9*Power(nu/Vbb,2.0/3.0));
////Result:=Variab[0]-7.021e-4*sqr(X)/(1108+X)-Kb*X*ln(Variab[1]*X);
//end;
//
//
//Function LinEgFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації  Fb0-7.021e-4*x^2/(1108+x)-Kb*x ln fp
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - Fb0;
//Variab[1] - fp;
//}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
////   Zi:=Variab[0]-7.021e-4*sqr(AP^.X[i])/(1108+AP^.X[i])-Kb*AP^.X[i]*ln(Variab[1])-AP^.Y[i];
//   Zi:=LinEgF(AP^.X[i],Variab)-AP^.Y[i];
//      Result:=Result+Zi*Zi;
//   end;
//end;

//Function DoubleDiodLightFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I01[exp((V-IRs)/n1kT)-1]+I02[exp((V-IRs)/n2kT)-1]
//         +(V-IRs)/Rsh-Iph
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - n1;
//Variab[1] - Rs;
//Variab[2] - I01;
//Variab[3] - Rsh
//Variab[4] - n2
//Variab[5] - I02;
//Variab[6] - Iph;
//}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
//{  Zi:=Full_IV_2Exp(AP^.X[i],Variab[0]*Kb*AP^.T,Variab[4]*Kb*AP^.T,
//      Variab[1],Variab[2],Variab[5],Variab[3],0)-Variab[6]-AP^.Y[i];{}
//
//{}   Zi:=Variab[2]*(exp((AP^.X[i]-AP^.Y[i]*Variab[1])/(Variab[0]*Kb*AP^.T))-1)
//      +Variab[5]*(exp((AP^.X[i]-AP^.Y[i]*Variab[1])/(Variab[4]*Kb*AP^.T))-1)
//      +(AP^.X[i]-AP^.Y[i]*Variab[1])/Variab[3]-Variab[6]-AP^.Y[i];{}
//    Result:=Result+Zi*Zi/sqr(AP^.Y[i]+Variab[6]);
//   end;
//end;


Function RevZrizFun(x,m,I0,E:double):double;
{функція I=I0*T^m*exp(-E/kT);
проте вважається, що x=1/kT
}
var T:double;
begin
Result:=555;
if x<=0 then Exit;
T:=1/Kb/x;
Result:=I0*Power(T,m)*exp(-E*x);
end;

Function RevZrizSCLC(x,m,I0,A:double):double;
{функція I=I0*(T^m)*A^(300/T);
проте вважається, що x=1/kT
}
var T:double;
begin
Result:=555;
if x<=0 then Exit;
T:=1/Kb/x;
Result:=I0*Power(T,m)*Power(A,300/T);
end;


//Function RevZrizFitFun(x:double;Variab:array of double):double;
//var I1,I2:double;
//begin
//Result:=555;
//if x<=0 then Exit;
//I1:=RevZrizFun(x,-Tpow,Variab[0],Variab[1]);
//I2:=RevZrizFun(x,2,Variab[2],Variab[3]);
////Result:=I1+I2;
//Result:=I1*I2/(I1+I2);
//end;
//
//
//Function RevZrizFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації  I01*T^(-Tpow)*exp(-E1/kT)+I02*T^2*exp(-E2/kT)
//Tpow - константа з модуля OlegType
//залежності від (kT)-1
//   I01*(x*k)^Tpow*exp(-E1*x)+I02/(x*k)^2*exp(-E2*x)
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - I10;
//Variab[1] - E1;
//Variab[2] - I20;
//Variab[3] - E2;
//}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
//  Zi:=RevZrizFitFun(AP^.X[i],Variab)-AP^.Y[i];
////   Zi:=Variab[0]*exp(-Variab[1]*AP^.X[i])*Power(Kb*AP^.X[i],Tpow)
////       +Variab[2]*exp(-Variab[3]*AP^.X[i])/sqr(Kb*AP^.X[i])-AP^.Y[i];
////   Zi:=ln(Variab[0]*exp(-Variab[1]*AP^.X[i])*Power(Kb*AP^.X[i],Tpow)
////       +Variab[2]*exp(-Variab[3]*AP^.X[i])/sqr(Kb*AP^.X[i]))-ln(AP^.Y[i]);
////   Result:=Result+Zi*Zi/Power(abs(ln(AP^.Y[i])),2);
//    Result:=Result+Zi*Zi/sqr(AP^.Y[i]);
//   end;
//end;

//Function RevShSCLCFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I01*V^m+I02*exp(A*Em/kT)
//АР - виміряні точки;
//Em - максимальне поле
//Variab - значення параметрів, очікується, що
//Variab[0] - I01;
//Variab[1] - m;
//Variab[2] - A;
//Variab[3] - I02;
//}
//var i:integer;
//    Zi,Fb,Vn,temp,I0sh:double;
//begin
//Result:=0;
//Fb:=0.775-7.021e-4*sqr(AP^.T)/(AP^.T+1108);
//Vn:=Kb*AP^.T*ln(2.5e4*1.12*Power(AP^.T/300,1.5)/7.25);
//temp:=2*Qelem*7.25e21/8.85e-12/11.7;
//I0sh:=4.9e-5*1.12e6*sqr(AP^.T)*exp(-DbGaus(AP^.T,0.9995,0.775,0.018,1.066,0.0118)/Kb/AP^.T);
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=Variab[0]*Power(AP^.X[i],Variab[1])
////      +I0sh*exp(Variab[2]*sqrt(temp*(Fb-Vn+AP^.X[i]))/Kb/AP^.T)*(1-exp(-AP^.X[i]/Kb/AP^.T))-AP^.Y[i];
//      +Variab[3]*exp(Variab[2]*sqrt(temp*(Fb-Vn+AP^.X[i]))/Kb/AP^.T)*(1-exp(-AP^.X[i]/Kb/AP^.T))-AP^.Y[i];
//    Result:=Result+Zi*Zi/abs(AP^.Y[i]);
//
//   end;
//end;

//Function RevShSCLC2Fit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I01*(V^m1+a*V^m2)+I02*exp(A*Em/kT)*(1-exp(-eV/kT))
//m1=1+326.4/T;
//m2=1+1020/T;
//a=0.2591;
//АР - виміряні точки;
//Em - максимальне поле
//Variab - значення параметрів, очікується, що
//Variab[0] - I01;
//Variab[1] - I02;
//Variab[2] - A;
//}
//var i:integer;
//    Zi,Fb,Vn,temp,I0sh:double;
//begin
//Result:=0;
//Fb:=0.775-7.021e-4*sqr(AP^.T)/(AP^.T+1108);
//Vn:=Kb*AP^.T*ln(2.5e4*1.12*Power(AP^.T/300,1.5)/7.25);
//temp:=2*Qelem*7.25e21/8.85e-12/11.7;
//I0sh:=4.9e-5*1.12e6*sqr(AP^.T)*exp(-DbGaus(AP^.T,0.9995,0.775,0.018,1.066,0.0118)/Kb/AP^.T);
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=Variab[0]*(Power(AP^.X[i],1+477.6/AP^.T)+0.1169*Power(AP^.X[i],1+2212/AP^.T))
////      +I0sh*exp(Variab[2]*sqrt(temp*(Fb-Vn+AP^.X[i]))/Kb/AP^.T)*(1-exp(-AP^.X[i]/Kb/AP^.T))-AP^.Y[i];
//      +Variab[1]*exp(Variab[2]*sqrt(temp*(Fb-Vn+AP^.X[i]))/Kb/AP^.T)*(1-exp(-AP^.X[i]/Kb/AP^.T))-AP^.Y[i];
//    Result:=Result+Zi*Zi/abs(AP^.Y[i]);
//
//   end;
//end;

//Function RevShSCLC3Fit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I01*V^m1+I02*V^m2+I03*exp(A*Em/kT)*(1-exp(-eV/kT))
//АР - виміряні точки;
//Em - максимальне поле
//Variab - значення параметрів, очікується, що
//Variab[0] - I01;
//Variab[1] - m1;
//Variab[2] - I02;
//Variab[3] - m2;
//Variab[4] - I03;
//Variab[5] - A;
//}
//var i:integer;
//    Zi,Fb,Vn,temp,I0sh:double;
//begin
//Result:=0;
//Fb:=0.775-7.021e-4*sqr(AP^.T)/(AP^.T+1108);
//Vn:=Kb*AP^.T*ln(2.5e4*1.12*Power(AP^.T/300,1.5)/7.25);
//temp:=2*Qelem*7.25e21/8.85e-12/11.7;
//I0sh:=4.9e-5*1.12e6*sqr(AP^.T)*exp(-DbGaus(AP^.T,0.9995,0.775,0.018,1.066,0.0118)/Kb/AP^.T);
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=Variab[0]*Power(AP^.X[i],Variab[1])+Variab[2]*Power(AP^.X[i],Variab[3])
////      +I0sh*exp(Variab[5]*sqrt(temp*(Fb-Vn+AP^.X[i]))/Kb/AP^.T)*(1-exp(-AP^.X[i]/Kb/AP^.T))-AP^.Y[i];
//      +Variab[4]*exp(Variab[5]*sqrt(temp*(Fb-Vn+AP^.X[i]))/Kb/AP^.T)*(1-exp(-AP^.X[i]/Kb/AP^.T))-AP^.Y[i];
//    Result:=Result+Zi*Zi/abs(AP^.Y[i]);
//
//   end;
//end;


//Procedure CreateFile(name:string;Vax:PVector;Param:TArrSingle);
//{функція для створення файлу з даними, наприклад, апроксимаційними }
//var Str1:TStringList;
//    a,b,c,d,e,f:double;
//    i:integer;
//begin
//   Str1:=TStringList.Create;
//   for I := 0 to High(Vax^.X) do
//    begin
// { a:=Full_IV_2Exp(Vax^.X[i],Param[0]*Kb*Vax^.T,Param[4]*Kb*Vax^.T,
//               Param[1],Param[2],Param[5],Param[3],Param[6]);{}
//{   a:=Full_IV_2Exp(Vax^.X[i],Param[0]*Kb*Vax^.T,Param[4]*Kb*Vax^.T,
//               0,Param[2],Param[5],1e12,Param[6]);{}
//{  Str1.Add(FloatToStrF(Vax^.X[i],ffExponent,4,0)+' '+
//                      FloatToStrF(Vax^.Y[i],ffExponent,4,0)+' '+
//                       FloatToStrF(a,ffExponent,4,0))
// }
//{}    //  a:=Param[0]*Power(Vax^.X[i],Param[1]);
//      c:=0.775-7.021e-4*sqr(Vax^.T)/(Vax^.T+1108);
//      d:=Kb*Vax^.T*ln(2.5e4*1.12*Power(Vax^.T/300,1.5)/7.25);
//      e:=2*Qelem*7.25e21/8.85e-12/11.7;
////      f:=4.9e-5*1.12e6*sqr(Vax^.T)*exp(-DbGaus(Vax^.T,0.9995,0.775,0.018,1.066,0.0118)/Kb/Vax^.T);
////      b:=f*exp(Param[2]*sqrt(e*(c-d+Vax^.X[i]))/Kb/Vax^.T)*(1-exp(-Vax^.X[i]/Kb/Vax^.T));
////    b:=Param[3]*exp(Param[2]*sqrt(e*(c-d+Vax^.X[i]))/Kb/Vax^.T)*(1-exp(-Vax^.X[i]/Kb/Vax^.T));
////      b:=sqrt(e*(c-d+Vax^.X[i]));
////       b:=RevShNewFun(Vax^.X[i],Vax^.T,Param[0],Param[1],Param[2]);
//       d:=sqrt((0.744-0.162+Vax^.X[i])*e);
////       a:=192.378*exp(-0.96734*Vax^.X[i])*Power(Vax^.T,-0.83)*
////          Power((3.308e-6*(Power(Vax^.X[i],258.66/300)+0.5095*Power(Vax^.X[i],1132.2/300))),300/Vax^.T);
////       b:=6.4371e5*exp(-1.7388e-6*d)*sqr(Vax^.T)*exp(-(0.9958-5.3715e-8*d)/Vax^.T/Kb);
//       a:=9.1587e10*exp(-2.3104*Vax^.X[i])*Power(Vax^.T,-0.83)*
//          Power((7.563e-14*(Power(Vax^.X[i],477.6/300)+0.117*Power(Vax^.X[i],2212.8/300))),300/Vax^.T);
//       b:=2.609e-6*exp(-0.7997*Vax^.X[i])*sqr(Vax^.T)*exp(-(0.4076-2.41711e-8*d)/Vax^.T/Kb);
//       Str1.Add(FloatToStrF({b}Vax^.X[i]{},ffExponent,4,0)+' '+
//               FloatToStrF(Vax^.Y[i],ffExponent,4,0)+' '+
//               FloatToStrF(a,ffExponent,4,0)+' '+
//              FloatToStrF(b,ffExponent,4,0)+' '+
//               FloatToStrF(a+b,ffExponent,4,0));
//  {}
//       end;
//  Str1.SaveToFile(name);
//  Str1.Free;
//end;

//Function RevShFun(x,T,I0,Al:double):double;
//{розраховується функція
//I=I01*exp(Al*Em)*(1-exp(-x/kT))
//де Em - електричне поле
//на межі метал-напівпровідник;
//}
//var Fb,Vn,temp:double;
//begin
//Result:=555;
//if T<=0 then Exit;
//Fb:=0.775-7.021e-4*sqr(T)/(T+1108);
//Vn:=Kb*T*ln(2.5e4*1.12*Power(T/300,1.5)/7.25);
//temp:=2*Qelem*7.25e21/8.85e-12/11.7;
//Result:=I0*exp(Al*sqrt(temp*(Fb-Vn+x))/Kb/T)*(1-exp(-x/Kb/T));
//end;

//Function RevShNewFun(x,T,I0,Al,Bt:double):double;
//{розраховується функція
//I=I0*exp(Al*Em+Bt*Em^0.5)*(1-exp(-x/kT))
//де Em - електричне поле
//на межі метал-напівпровідник;
//}
//var Fb,Vn,Em:double;
//begin
//Result:=555;
//if T<=0 then Exit;
//Fb:=0.775-7.021e-4*sqr(T)/(T+1108);
//Vn:=Kb*T*ln(2.5e4*1.12*Power(T/300,1.5)/7.25);
//Em:=sqrt(2*Qelem*7.25e21/8.85e-12/11.7*(Fb-Vn+x));
//Result:=I0*exp((Al*Power(Em,1)+Bt*sqrt(Em))/Kb/T)*(1-exp(-x/Kb/T));
//end;

//Function RevShNewFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//I=I0*exp(Al*Em+Bt*Em^0.5)*(1-exp(-x/kT))
//АР - виміряні точки;
//Em - максимальне поле
//Variab - значення параметрів, очікується, що
//Variab[0] - I0;
//Variab[1] - Al;
//Variab[2] - Bt;
//}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=RevShNewFun(AP^.X[i],AP^.T,Variab[0],Variab[1],Variab[2])-AP^.Y[i];
//   Result:=Result+Zi*Zi/sqr(AP^.Y[i]);
//   end;
//end;

//Function RevShNew2Fit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//I=I0*exp(Al*Em+Bt*Em^0.5)*(1-exp(-x/kT))
//АР - виміряні точки;
//Em - максимальне поле
//Variab - значення параметрів, очікується, що
//Variab[0] - I0;
//Variab[1] - Al;
//Variab[2] - Bt;
//}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=RevShNewFun(AP^.X[i],AP^.T,Variab[0],Variab[1],Variab[2])+
//      RevShNewFun(AP^.X[i],AP^.T,Variab[3],Variab[4],0)-AP^.Y[i];
//   Result:=Result+Zi*Zi/sqr(AP^.Y[i]);
//   end;
//end;
//

//Function RevShTwoFun(x,T:double; Variab:array of double):double;
//{розраховується
//функціz I01*exp(A1*Em/kT)V^m+I02*exp(A2*Em/kT)
//Em - максимальне поле
//Variab - значення параметрів, очікується, що
//Variab[0] - I01;
//Variab[1] - I02;
//Variab[2] - A1;
//Variab[3] - A2;
//}
//{var i:integer;
//   // Zi,Fb,Vn,temp:double;}
//var I1,I2:double;
//begin
//Result:=555;
//if T<=0 then Exit;
//I1:=RevShFun(x,T,Variab[0],Variab[2]);
//I2:=RevShFun(x,T,Variab[1],Variab[3]);
//Result:=I1+I2;
////Result:=I1*I2/(I1+I2);
//end;



//Function RevShTwoFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації ВАХ
//функцією I01*exp(A1*Em/kT)+I02*exp(A2*Em/kT)
//АР - виміряні точки;
//Em - максимальне поле
//Variab - значення параметрів, очікується, що
//Variab[0] - I01;
//Variab[1] - I02;
//Variab[2] - A1;
//Variab[3] - A2;
//}
//var i:integer;
//    Zi:double;
//begin
//{}Result:=0;
//
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=RevShTwoFun(AP^.X[i],AP^.T,Variab)-AP^.Y[i];
////      Zi:=(Variab[0]*exp(Variab[2]*sqrt(temp*(Fb-Vn+AP^.X[i]))/Kb/AP^.T)
// //     +Variab[1]*exp(Variab[3]*sqrt(temp*(Fb-Vn+AP^.X[i]))/Kb/AP^.T))*(1-exp(-AP^.X[i]/Kb/AP^.T))-AP^.Y[i];
//    Result:=Result+Zi*Zi/abs(AP^.Y[i]);
//   end;
//end;

//Function RevZriz2Fit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації  I01*T^(-Tpow)*B^(-Tc/T)+I02*T^2*exp(-E/kT)
//Tpow - константа з модуля OlegType
//залежності від x=1/(kT)
//   I01*(x*k)^Tpow*B^(Tc*x*k)+I02/(x*k)^2*exp(-E*x)
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - I10;
//Variab[1] - B;
//Variab[4] - Tc;
//Variab[2] - I20;
//Variab[3] - E;
//}
//var i:integer;
//    Zi,I12:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
//   I12:=RevZrizSCLC(AP^.X[i],-Tpow,Variab[0],Variab[1])+
//        RevZrizFun(AP^.X[i],2,Variab[2],Variab[3]);
////   T1:=Kb*AP^.X[i];
//   Zi:=ln(I12)-ln(AP^.Y[i]);
////   Zi:=ln(Variab[0]*Power(T1,Tpow)*Power(Variab[1],Variab[4]*T1)
////       +Variab[2]*exp(-Variab[3]*AP^.X[i])/sqr(Kb*AP^.X[i]))-ln(AP^.Y[i]);
////   Zi:=Variab[0]*Power(T1,Tpow)*Power(Variab[1],Variab[4]*T1)
////       +Variab[2]*exp(-Variab[3]*AP^.X[i])/sqr(Kb*AP^.X[i])-(AP^.Y[i]);
//    Result:=Result+Zi*Zi/Power(abs(ln(AP^.Y[i])),2){/abs(AP^.Y[i])};
//   end;
//end;


//Function Power2Fit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації  A1(x^m1+A2*x^m2)
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - A1;
//Variab[1] - A2;
//Variab[2] - m1;
//Variab[3] - m2;
//}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=Variab[0]*(Power(AP^.X[i],Variab[2])
//       +Variab[1]*Power(AP^.X[i],Variab[3]))-AP^.Y[i];
//    Result:=Result+Zi*Zi/sqr(AP^.Y[i]);
//   end;
//end;

//Function RevZriz3Fit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації  I01*exp(-(Tc/T)^0.25)+I02*T^2*exp(-E/kT)
//залежності від x=1/(kT)
//   I01*exp(-(Tc*k*x)^0.25)+I02/(x*k)^2*exp(-E*x)
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - I10;
//Variab[1] - Tc;
//Variab[2] - I02;
//Variab[3] - E;
//}
//var i:integer;
//    Zi,T1:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
//   T1:=Kb*AP^.X[i];
//   Zi:=Variab[0]*exp(-Power((Variab[1]*T1),0.25))*Power(T1,-2)
//       +Variab[2]*exp(-Variab[3]*AP^.X[i])/sqr(T1)-AP^.Y[i];
//    Result:=Result+Zi*Zi/sqr(AP^.Y[i]);
//   end;
//end;


Function TunFun(x:double; Variab:array of double):double;
const ksi=3.29;
begin
//Result:=Variab[0]*exp(-Variab[1]*Power(x,0.5));
//  Result:=Variab[0]*exp(-Variab[1]/(Variab[2]*x)*
//    (Power((ksi+Variab[2]*x),1.5)-Power(ksi,1.5)));
 Result:=Variab[0]*exp(-Variab[1]*sqrt(Variab[2]+x));
end;

//Function TunFit(AP:Pvector; Variab:array of double):double;
//{розраховується квадратична форма з МНК
//апроксимації  I0*exp(-A*(B+x)^0.5)
//АР - виміряні точки;
//Variab - значення параметрів, очікується, що
//Variab[0] - I0;
//Variab[1] - A;
//Variab[2] - B;
//}
//var i:integer;
//    Zi:double;
//begin
//Result:=0;
//for I := 0 to High(AP^.X) do
//   begin
//   Zi:=TunFun(AP^.X[i],Variab)-AP^.Y[i];
//   //   Zi:=Variab[0]*exp(-Variab[1]*sqrt(Variab[2]+AP^.X[i]))-AP^.Y[i];
//    Result:=Result+Zi*Zi/sqr(AP^.Y[i]);
//   end;
//end;


Function RandomAB(A,B:double):double;
{повертає випадкове число в межах від А до В}
begin
  Result:=A+Random*(B-A);
end;

Function RandomLnAB(A,B:double):double;
{повертає випадкове число в межах від А до В,
розподіляючи логарифми чисел - використовується у випадку,
коли А та В дуже відмінні}
begin
  Result:=exp(ln(A)+Random*(ln(B)-ln(A)));
end;

Function ValueToStr555(Value:double):string; overload;
{перетворює Value в рядок, якщо Value=555,
то результатом є порожній рядок}
begin
if Value=555 then Result:=''
             else Result:=FloatToStrF(Value,ffGeneral,4,2);
end;

Function ValueToStr555(Value:integer):string; overload;
{перетворює Value в рядок, якщо Value=555,
то результатом є порожній рядок}
begin
if Value=555 then Result:=''
             else Result:=IntToStr(Value);
end;

Function StrToFloat555(Value:string):double;
{перетворює Value в дійсне число,
якщо перетворення невдале
(рядок порожній тощо), то
результат дорівнює 555}
begin
 try
  Result:=StrToFloat(Value);
 except
  Result:=555;
 end;
end;

Function StrToInt555(Value:string):integer;
{перетворює Value в дійсне число,
якщо перетворення невдале
(рядок порожній тощо), то
результат дорівнює 555}
begin
 try
  Result:=StrToInt(Value);
 except
  Result:=555;
 end;
end;


Function NumberMax(A:Pvector):integer;
{обчислюється кількість локальних
максимумів у векторі А;
дані мають бути упорядковані по координаті X}
var i:integer;
begin
if A^.n<3 then
   begin
     Result:=555;
     Exit;
   end;
Result:=0;
for i:=1 to High(A^.X)-1 do
 if (A^.Y[i]>A^.Y[i-1])and(A^.Y[i]>A^.Y[i+1]) then
   inc(Result);
end;

Function Rs_T(T:double):double;
begin
Result:=0.25*exp(0.044/Kb/T);
//Result:=35;
//Result:=2;
//Result:=20;
end;

Function Fb_T(T:double):double;
begin
Result:=0.75-7.021e-4*T*T/(1108+T);

//Result:=3.14e-5*1.12e6*T*T*exp(-Result/Kb/T);
//Result:=Kb*T*ln(3.14e-6*1.12e6*T*T/Result);

//Result:=0.75;
//Result:=0.5;
//Result:=Kb*T*ln(3.14e-6*1.12e6*T*T/(1e-8*Power(10,1.0/2.0)));
//Result:=Kb*T*ln(3.14e-6*1.12e6*T*T/1e-10);
//Result:=Kb*T*ln(3.14e-6*1.12e6*T*T/1e-5);
end;

Function n_T(T:double):double;
begin
Result:=1+35/T;
//Result:=1.01;
//Result:=1.5;
end;


Function GromovDistance(Xa,Ya,C0,C1,C2:double):double;
{відстань від точки (Ха,Ya) до кривої С0+C1*x+C2*ln(x)}
var Fa,Fb,a,b,c,tempa,k,min:double;
    i:integer;
    bool:boolean;
  Function Gromov(x:double):double;
  begin
    Result:=C0+C1*x+C2*ln(x);
  end;
  Function GromovDod(x:double):double;
  begin
    Result:=Ya-Gromov(x)+(Xa-x)*x/(C1*x+C2);
  end;

begin
Result:=555;
  a:=Xa;
  b:=Xa;
  repeat
   tempa:=a-0.1*Xa;
   if tempa<=0 then
     begin
     k:=0.1;
     repeat
      tempa:=a-k*Xa;
      k:=k/2;
     until tempa>0;
     end;
   a:=tempa;
   b:=b+0.1*Xa;
   Fa:=GromovDod(a);
   Fb:=GromovDod(b);
  until Fb*Fa<=0;

       i:=0;
  repeat
      inc(i);
      c:=(a+b)/2;
     Fa:=GromovDod(a);
     Fb:=GromovDod(c);
     if (Fb*Fa<=0)
       then b:=c
       else a:=c;

   if abs(a)<abs(b) then min:=abs(a)
                    else min:=abs(b);

    bool:=abs((b-a)/min)<1e-4;

     until (i>1e5)or bool;
    if (i>1e5) then Exit;
  Result:=sqrt(sqr(Xa-c)+sqr(Ya-Gromov(c)));

end;

end.
