unit OlegMath;

interface
 uses OlegType, Dialogs, SysUtils, Math, Classes;

Type FunBool=Function(V:PVector;n0,Rs0,I00,Rsh0:double):boolean;
     TFun_IV=Function(Argument:double;Parameters:array of double;Key:double):double;
     TFunCorrection=Function (A:Pvector; var B:Pvector; fun:byte=0):boolean;
     {функція для перетворення даних в Pvector, зокрема використовується в диференціальних
     методах аналізу ВАХ}

     
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
в Х0 - ErResult;
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
в Х0 - ErResult;
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

Function MedianFiltr(a,b,c:double):double;
{повертає середнє за величиною з трьох чисел a, b, c}

Function Linear(a,b,x:double):double;
{повертає a+b*x}

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
якщо початок вибрано неправильно (не потрапляє в діапазон зміни
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

//Function IV_Diod(V,E,I0:double;I:double=0;Rs:double=0):double;
//TFun_IV=Function(Argument:double;Parameters:array of double;Key:double):double;
Function IV_Diod(V:double;Data:array of double;I:double=0):double;
{I=I0*[exp(q(V-I Rs)/E)-1]
Data[0] - Ε
Data[1] - Rs
Data[2] - Ι0
}

Function IV_DiodTunnel(V:double;Data:array of double;I:double=0):double;
{I=I0*exp[A(V-I Rs)]
Data[0] - A
Data[1] - Rs
Data[2] - Ι0
}

Function IV_DiodTATrev(V:double;Data:array of double;I:double=0):double;
{I=I0*(Ud+V-I Rs)*exp(-4 (2m*)^0.5 Et^1.5/
                     (3 q h (q Nd (Ud+V-I Rs)/2 Eps Eps0)))

Data[0] - I0
Data[1] - Et
Data[2] - Ud
Data[3] - Rs
Data[4] - meff
Data[5] - Nd
Data[6] - Eps
}

Function IV_DiodDouble(V:double;Data:array of double;I:double=0):double;
{I=I01*[exp(q(V-I Rs)/E1)-1]+I02*[exp(q(V-I Rs)/E2)-1])
Data[0] - Ε1
Data[1] - Rs
Data[2] - Ι01
Data[3] - E2
Data[4] - Ι02
}

Function IV_DiodTriple(V:double;Data:array of double;I:double=0):double;
{I=I01*[exp(q(V-I Rs)/E1)-1]+I02*[exp(q(V-I Rs)/E2)-1]
+I03*[exp(q(V-I Rs)/E3)-1])
Data[0] - Ε1
Data[1] - Rs
Data[2] - Ι01
Data[3] - E2
Data[4] - Ι02
Data[5] - E3
Data[6] - Ι03
}


//Function Full_IV(V,E,Rs,I0,Rsh:double;Iph:double=0):double;
//Function Full_IV(F:TFun_IV;V,E,I0:double;Rs:double=0;Rsh:double=1e12;Iph:double=0):double;
Function Full_IV(F:TFun_IV;V:double;Data:array of double;Rsh:double=1e12;Iph:double=0):double;
{розраховує значення функції
I=F(V,E,I0,I,Rs)+(V-I Rs)/Rsh-Iph)}

//Function Full_IV_A(V,E,Rs,I0,Rsh,Iph:double):double;

//Function Full_IV_2Exp(V,E1,E2,Rs,I01,I02,Rsh,Iph:double):double;
{розраховує значення функції
I=I01*[exp(q(V-I Rs)/E1)-1]+I02*[exp(q(V-I Rs)/E2)-1]+(V-I Rs)/Rsh-Iph)}


Function MaxElemNumber(a:array of double):integer;
{повертає номер найбільшого елементу масиву}

Function MinElemNumber(a:array of double):integer;
{повертає номер наменшого елементу масиву}

Function RevZrizFun(x,m,I0,E:double):double;
{функція I=I0*T^m*exp(-E/kT);
проте вважається, що x=1/kT
}

Function RevZrizSCLC(x,m,I0,A:double):double;
{функція I=I0*(T^m)*A^(300/T);
проте вважається, що x=1/kT
}

Function TunFun(x:double; Variab:array of double):double;

Function RandomAB(A,B:double):double;
{повертає випадкове число в межах від А до В}

Function RandomLnAB(A,B:double):double;
{повертає випадкове число в межах від А до В,
розподіляючи логарифми чисел - використовується у випадку,
коли А та В дуже відмінні}

Function ValueToStr555(Value:double):string; overload;
{перетворює Value в рядок, якщо Value=ErResult,
то результатом є порожній рядок}

Function ValueToStr555(Value:integer):string; overload;
{перетворює Value в рядок, якщо Value=ErResult,
то результатом є порожній рядок}

Function StrToFloat555(Value:string):double;
{перетворює Value в дійсне число,
якщо перетворення невдале
(рядок порожній тощо), то
результат дорівнює ErResult}

Function StrToInt555(Value:string):integer;
{перетворює Value в дійсне число,
якщо перетворення невдале
(рядок порожній тощо), то
результат дорівнює ErResult}

Function NumberMax(A:Pvector):integer;
{обчислюється кількість локальних
максимумів у векторі А;
дані мають бути упорядковані по координаті X}

Function IsEqual(a,b,eps:double):boolean;
{True, якщо відносна різниця a та b менше eps}


Function Rs_T(T:double):double;
Function Fb_T(T:double):double;
Function n_T(T:double):double;


Function GromovDistance(Xa,Ya,C0,C1,C2:double):double;
{відстань від точки (Ха,Ya) до кривої С0+C1*x+C2*ln(x)}

Function Brailsford(T,w:double;Parameters:TArrSingle):double;
{поглинання звуку, формула Брейсфорда
 alpha(T,w) = A*w/T*(B*w*exp(E/kT))/(1+(B*w*exp(E/kT)^2);
 Parameters[0] - A;
 Parameters[1] - B;
 Parameters[2] - E}

Function Trapezoid(x1,x2,y1,y2:double):double;
{повертає площу трапеції, побудовану
між точками (х1,у1), (х2,у2) та
горизонтальною віссю;
якщо х1 та х2 мають різний знак -
сумарну плошу відповідних трикутників}

Function V721A_ErrorI_DC(I:double):Double;
{визначення відносної похибки вимірювання сили постійного струму
вольтметром В7-21А залежно від виміряної величини}

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
   Result:=ErResult;
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
a:=ErResult;
b:=ErResult;
c:=ErResult;

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
if R^.N=ErResult then Exit;
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
I0:=ErResult;
E:=ErResult;
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
I0:=ErResult;
E:=ErResult;
Rsh:=ErResult;
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
 if SysEq^.N=ErResult then
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
якщо розв'язків не існує, то R^.N=ErResult}

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
        R^.N:=ErResult;
        Exit;
        end;

if R^.N=1 then
   begin
    if R^.A[0,0]=0 then R^.N:=ErResult
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
       R^.N:=ErResult;
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
 FuncG(bool1,Nr,AV,b,X1,G);

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
в Х0 - ErResult;
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
  for I := 0 to High(X0) do X0[i]:=ErResult;
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
 if SysEq^.N=ErResult then
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
 if SysEq^.N=ErResult then
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
в Х0 - ErResult;
}
  function Alph (x:double):double;
  {допоміжна функція, необхідна для використання
  у методі оптимізації за методов золотого перерізу
  при пошуку ширини кроку - див опис методу
  найшвидшого спуску}
   var X11, X12:array of double;
       i:integer;
   begin
     Result:=ErResult;
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
//  for I := 0 to High(X0) do X0[i]:=ErResult;
repeat
{----мінімізація для знахожження кроку-----------}
{}
a:=0;b:=10;
ep:=1e-10*abs(b-a);
x1:=al*a+bet*b;
x2:=al*b+bet*a;
y1:=Alph(x1);
y2:=Alph(x2);
if (y1=ErResult)or(y2=ErResult) then
 begin
  ErStr:='Error of step defination';
  for I := 0 to High(X0) do X0[i]:=ErResult;
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
if (y1=ErResult)or(y2=ErResult) then
 begin
  ErStr:='Error of step defination';
  for I := 0 to High(X0) do X0[i]:=ErResult;
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
     for I := 0 to High(X0) do X0[i]:=ErResult;
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
     for I := 0 to High(X0) do X0[i]:=ErResult;
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
for I := 0 to High(Rez) do Rez[i]:=ErResult;
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
for I := 0 to High(Rez) do Rez[i]:=ErResult;
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
     Rez[i,j]:=ErResult;
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
for I := 0 to High(Rez) do Rez[i]:=ErResult;
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
     Rez[i,j]:=ErResult;
Result:=1;
end;//try
end;

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




Function MedianFiltr(a,b,c:double):double;
{повертає середнє за величиною з трьох чисел a, b, c}
 begin
  if a>b then swap(a,b);
  if b>c then swap(b,c);
  if a>b then swap(a,b);
  Result:=b;
 end;

Function Linear(a,b,x:double):double;
{повертає a+b*x}
begin
  Result:=a+b*x;
end; 

Procedure Median (A:Pvector; var B:PVector);
{в В розміщується результат дії на дані в А
медіанного трьохточкового фільтра;
якщо у вихідному масиві кількість точок менша трьох,
то у результуючому буде нульова кількість}
//Function Med(a,b,c:double):double;
//{повертає середнє за величиною з трьох чисел a, b, c}
// begin
//  if a>b then swap(a,b);
//  if b>c then swap(b,c);
//  if a>b then swap(a,b);
//  Result:=b;
//
//  {Result:=b;
//  if ((a<b)or(a=b))and((a>c)or(a=c)) then Result:=a;
//  if ((a>b)or(a=b))and((a<c)or(a=c)) then Result:=a;
//  if ((b<a)or(a=b))and((b>c)or(b=c)) then Result:=b;
//  if ((b>a)or(a=b))and((b<c)or(b=c)) then Result:=b;
//  if ((c<b)or(c=b))and((c>a)or(c=a)) then Result:=c;
//  if ((c>b)or(c=b))and((c<a)or(c=a)) then Result:=c;}
// end;

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
B^.y[i]:=MedianFiltr(A^.y[i-1],A^.y[i],A^.y[i+1]);;
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
   Result:=ErResult;
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
   Result:=ErResult;

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
  if (i>1e5) then Result:=ErResult
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
  Result:=ErResult;
  if (E=0) or(Rs=0) or (I0=0) or (Rsh=0) then Exit;
  if (E=ErResult) or(Rs=ErResult) or (I0=ErResult) or (Rsh=ErResult) then Exit;
  Result:=E/Rs*Lambert(Rs*I0/(E)*exp((V+Rs*I0)/E))+
             V/Rsh-I0;
end;

Function LambertLightAprShot (V,E,Rs,I0,Rsh,Iph:double):double;
{розраховує апроксимацію освітленої ВАХ при напрузі V
за функцією Ламверта по значеннях параметрів Е,Rs,I0,Rsh,Iph
Е=KbTn/q}
begin
  Result:=ErResult;
  if (E=0) or(Rs=0) or (I0=0) or (Rsh=0) then Exit;
  if (E=ErResult) or(Rs=ErResult) or (I0=ErResult) or (Rsh=ErResult) then Exit;
  Result:=V/Rs-Rsh*(Rs*Iph+Rs*I0+V)/Rs/(Rs+Rsh)+
          E/Rs*Lambert(Rs*I0*Rsh/E/(Rs+Rsh)*exp(Rsh*(Rs*Iph+Rs*I0+V)/E/(Rs+Rsh)));
end;

//Function IV_Diod(V,E,I0:double;I:double=0;Rs:double=0):double;
//Function IV_Diod(Data:array of double):double;
//{I=I0*[exp(q(V-I Rs)/E)-1]
//Data[0] - V
//Data[1] - Ε
//Data[2] - Ι0
//Data[3] - Rs
//Data[4] - I
//}
Function IV_Diod(V:double;Data:array of double;I:double=0):double;
{I=I0*[exp(q(V-I Rs)/E)-1]
Data[0] - Ε
Data[1] - Rs
Data[2] - Ι0
}
begin
//  Result:=I0*(exp((V-I*Rs)/E)-1);
//  Result:=Data[2]*(exp((Data[0]-Data[3]*Data[4])/Data[1])-1);
 if I=0 then Result:=Data[2]*(exp(V/Data[0])-1)
        else Result:=Data[2]*(exp((V-I*Data[1])/Data[0])-1);
end;

Function IV_DiodTunnel(V:double;Data:array of double;I:double=0):double;
{I=I0*exp[A(V-I Rs)]
Data[0] - A
Data[1] - Rs
Data[2] - Ι0
}
begin
 if I=0 then Result:=Data[2]*exp(V*Data[0])
        else Result:=Data[2]*exp((V-I*Data[1])*Data[0]);
end;

Function IV_DiodTATrev(V:double;Data:array of double;I:double=0):double;
{I=I0*(Ud+V-I Rs)*exp(-4 (2m*)^0.5 Et^1.5/
                     (3 q h (q Nd (Ud+V-I Rs)/2 Eps Eps0)))

Data[0] - I0
Data[1] - Rs
Data[2] - Ud
Data[3] - Et
Data[4] - meff
Data[5] - Nd
Data[6] - Eps
}
  var F,Vreal:double;
begin
  if I=0 then Vreal:=V
         else Vreal:=V-I*Data[1];
  F:=sqrt(Qelem*Data[5]*(Data[2]+Vreal)/2/Data[6]/Eps0);
  Result:=(Data[2]+Vreal)*Data[0]*exp(-4*sqrt(2*Data[4]*m0)*
                           Power(Qelem*Data[3],1.5)/
                           (3*Qelem*Hpl*F));
end;

Function IV_DiodDouble(V:double;Data:array of double;I:double=0):double;
{I=I01*[exp(q(V-I Rs)/E1)-1]+I02*[exp(q(V-I Rs)/E2)-1])
Data[0] - Ε1
Data[1] - Rs
Data[2] - Ι01
Data[3] - E2
Data[4] - Ι02
}
begin
 if I=0 then Result:=Data[2]*(exp(V/Data[0])-1)+Data[4]*(exp(V/Data[3])-1)
        else Result:=Data[2]*(exp((V-I*Data[1])/Data[0])-1)+
                     Data[4]*(exp((V-I*Data[1])/Data[3])-1);
end;

Function IV_DiodTriple(V:double;Data:array of double;I:double=0):double;
{I=I01*[exp(q(V-I Rs)/E1)-1]+I02*[exp(q(V-I Rs)/E2)-1])
Data[0] - Ε1
Data[1] - Rs
Data[2] - Ι01
Data[3] - E2
Data[4] - Ι02
Data[5] - E3
Data[6] - Ι03
}
begin
 if I=0 then Result:=Data[2]*(exp(V/Data[0])-1)+
                     Data[4]*(exp(V/Data[3])-1)+
                     Data[6]*(exp(V/Data[5])-1)
        else Result:=Data[2]*(exp((V-I*Data[1])/Data[0])-1)+
                     Data[4]*(exp((V-I*Data[1])/Data[3])-1)+
                     Data[6]*(exp((V-I*Data[1])/Data[5])-1);
end;

//Function Full_IV(V,E,Rs,I0,Rsh:double;Iph:double=0):double;
//Function Full_IV(F:TFun_IV;V,E,I0:double;Rs:double=0;Rsh:double=1e12;Iph:double=0):double;
Function Full_IV(F:TFun_IV;V:double;Data:array of double;Rsh:double=1e12;Iph:double=0):double;
{Data[1] має бути Rs}
{розраховує значення функції
I=F(V,E,I0,I,Rs)+(V-I Rs)/Rsh-Iph)}
//    Function I_V({mode:byte;}I,V,I0,Rs,E,Rsh,Iph:double):double;
    Function I_V(I:double):double;
    begin
      Result:=I-F(V, Data,I)+Iph;
//      Result:=I-F([V, E, I0, Rs,I])+Iph;
//      Result:=I-F(V,E,I0,I,Rs)+Iph;
//      Result:=I-I0*exp((V-I*Rs)/E)+I0+Iph;
      if Rsh<1e12 then Result:=Result-(V-I*Data[1])/Rsh;
//      case mode of
//         1:Result:=I-I0*exp((V-I*Rs)/kT)+I0+Iph;
//       else Result:=I-I0*exp((V-I*Rs)/kT)+I0-(V-I*Rs)/Rsh+Iph;
//      end;
    end;
const eps=1e-6;
      Nit_Max=1e6;
var {mode,md:byte;}
    i:integer;
    a,b,c{,min}:double;
//    bool:boolean;
begin
 try
  if Rsh>1e12 then Rsh:=1e12;
//  if (Rs<=1e-4) then
  if (Data[1]<=1e-4) then
   begin
//     if (Rsh=1e12) then Result:=F([V,E,I0,0,0])-Iph
//                   else Result:=F([V,E,I0,0,0])+V/Rsh-Iph;
     if (Rsh=1e12) then Result:=F(V,Data,0)-Iph
                   else Result:=F(V,Data,0)+V/Rsh-Iph;
     Exit;
   end;

  c:=F(V,Data,0)-Iph;
//     c:=F([V,E,I0,0,0])-Iph;
//     c:=I0*(exp(V/E)-1)-Iph;
  if c*Data[1]>88 then c:=10/Data[1];

//     if abs(c)<1e-8 then
  if abs(c)<1e-11 then
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
          until I_V(a)<0;
//          until I_V({mode,}a,V,I0,Rs,E,Rsh,Iph)<0;
          repeat
            b:=b+0.1*abs(c);
          until I_V(b)>0;
//          until I_V({mode,}b,V,I0,Rs,E,Rsh,Iph)>0;

          except

          end;
         end;//else
     i:=0;
//     md:=0;
     repeat
       inc(i);
       c:=(a+b)/2;
       if (I_V(c)*I_V(a)<=0)
//       if (I_V({mode,}c,V,I0,Rs,E,Rsh,Iph)*I_V({mode,}a,V,I0,Rs,E,Rsh,Iph)<=0)
           then b:=c
           else a:=c;
      {
       if abs(a)<abs(b) then min:=abs(a)
                        else min:=abs(b);
       if a=0 then md:=1;
       if b=0 then md:=2;
       if (a=0) and (b=0) then md:=3;
       case md of
         1:bool:=abs((b-a)/b)<eps;
         2:bool:=abs((b-a)/a)<eps;
         3:bool:=true;
        else bool:=abs((b-a)/min)<eps;
       end;//case}
     until ((i>Nit_Max)or IsEqual(a,b,eps));
     if (i>Nit_Max) then
        begin
        Result:=ErResult;
        Exit;
        end;
     Result:=c;
 except
  Result:=ErResult;
 end;

end;

//Function Full_IV_A(V,E,Rs,I0,Rsh,Iph:double):double;
//{розраховує значення функції
//I=I0*[exp(q(V-I Rs)/E)-1]+(V-I Rs)/Rsh-Iph)}
//    Function I_V(mode:byte;I,V,I0,Rs,kT,Rsh,Iph:double):double;
//    begin
//      case mode of
//         1:Result:=I-I0*exp((V-I*Rs)/kT)+I0{+Iph};
//       else Result:=I-I0*exp((V-I*Rs)/kT)+I0-(V-I*Rs)/Rsh{+Iph};
//      end;
//    end;
//
//var mode,md:byte;
//    i:integer;
//    a,b,c,min:double;
//    bool:boolean;
//begin
//Result:=ErResult;
//if E=0 then Exit;
//mode:=0;
//if Rsh>=1e12 then mode:=1;
//if Rs<=1e-4 then mode:=2;
//if (Rsh>=1e12)and(Rs<=1e-4) then mode:=3;
//case mode of
//  2:Result:=I0*(exp(V/E)-1)+V/Rsh-Iph;
//  3:Result:=I0*(exp(V/E)-1)-Iph;
//  else
//     begin
//     if Rsh>1e12 then Rsh:=1e12;
//     c:=I0*(exp(V/E)-1){-Iph};
//     {if abs(c)<1e-8 then
//          begin
//           if Iph>0 then a:=-3e-2
//                    else a:=0;
//           b:=3e-2;
//         end
//           else
//         begin}
//          a:=c;
//          b:=c;
//          repeat
//           a:=a-0.1*abs(c);
//           b:=b+0.1*abs(c);
//          until (I_V(mode,a,V,I0,Rs,E,Rsh,Iph)*I_V(mode,b,V,I0,Rs,E,Rsh,Iph)<=0);
//{         end;//else}
//     i:=0;
//     md:=0;
//     repeat
//       inc(i);
//       c:=(a+b)/2;
//       if (I_V(mode,c,V,I0,Rs,E,Rsh,Iph)*I_V(mode,a,V,I0,Rs,E,Rsh,Iph)<=0)
//           then b:=c
//           else a:=c;
//       if abs(a)<abs(b) then min:=abs(a)
//                        else min:=abs(b);
//       if a=0 then md:=1;
//       if b=0 then md:=2;
//       if (a=0) and (b=0) then md:=3;
//       case md of
//         1:bool:=abs((b-a)/b)<1e-8;
//         2:bool:=abs((b-a)/a)<1e-8;
//         3:bool:=true;
//        else bool:=abs((b-a)/min)<1e-8;
//       end;//case
//     until ((i>1e6)or bool);
//     if (i>1e6) then Exit;
//     Result:=c-Iph;
//    end;//else-case
//end;//case
//end;

//Function Full_IV(F:TFun_IV;V,E,I0:double;Rs:double=0;Rsh:double=1e12;Iph:double=0):double;
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
Result:=ErResult;
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


Function RevZrizFun(x,m,I0,E:double):double;
{функція I=I0*T^m*exp(-E/kT);
проте вважається, що x=1/kT
}
var T:double;
begin
Result:=ErResult;
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
Result:=ErResult;
if x<=0 then Exit;
T:=1/Kb/x;
Result:=I0*Power(T,m)*Power(A,300/T);
end;

Function TunFun(x:double; Variab:array of double):double;
const ksi=3.29;
begin
//Result:=Variab[0]*exp(-Variab[1]*Power(x,0.5));
//  Result:=Variab[0]*exp(-Variab[1]/(Variab[2]*x)*
//    (Power((ksi+Variab[2]*x),1.5)-Power(ksi,1.5)));
 Result:=Variab[0]*exp(-Variab[1]*sqrt(Variab[2]+x));
end;


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
{перетворює Value в рядок, якщо Value=ErResult,
то результатом є порожній рядок}
begin
if Value=ErResult then Result:=''
             else Result:=FloatToStrF(Value,ffGeneral,4,2);
end;

Function ValueToStr555(Value:integer):string; overload;
{перетворює Value в рядок, якщо Value=ErResult,
то результатом є порожній рядок}
begin
if Value=ErResult then Result:=''
             else Result:=IntToStr(Value);
end;

Function StrToFloat555(Value:string):double;
{перетворює Value в дійсне число,
якщо перетворення невдале
(рядок порожній тощо), то
результат дорівнює ErResult}
begin
 try
  Result:=StrToFloat(Value);
 except
  Result:=ErResult;
 end;
end;

Function StrToInt555(Value:string):integer;
{перетворює Value в дійсне число,
якщо перетворення невдале
(рядок порожній тощо), то
результат дорівнює ErResult}
begin
 try
  Result:=StrToInt(Value);
 except
  Result:=ErResult;
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
     Result:=ErResult;
     Exit;
   end;
Result:=0;
for i:=1 to High(A^.X)-1 do
 if (A^.Y[i]>A^.Y[i-1])and(A^.Y[i]>A^.Y[i+1]) then
   inc(Result);
end;

Function IsEqual(a,b,eps:double):boolean;
{True, якщо відносна різниця a та b менше eps}
  var max, min:double;
begin
 min:=abs(a);
 max:=abs(b);
 if ((min=0)and(max=0)) then
  begin
    Result:=True;
    Exit;
  end;
 if min>max then Swap(min,max);
 if min=0 then Result:=(abs((b-a)/max)<eps)
          else Result:=(abs((b-a)/min)<eps);
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
Result:=ErResult;
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

Function Brailsford(T,w:double;Parameters:TArrSingle):double;
 var d:double;
begin
 Result:=ErResult;
 if (T<=0)or(w<=0)or(High(Parameters)<>2) then Exit;
 d:=Parameters[1]*w*exp(Parameters[2]/Kb/T);
 Result:=Parameters[0]*w/T*d/(1+sqr(d));
end;

Function Trapezoid(x1,x2,y1,y2:double):double;
begin
 if y1*y2<0 then
 Result:=abs((x2-x2)*(sqr(y1)+sqr(y2))/(y2-y1)/2)
            else
 Result:=abs((x2-x1)*(y1+y2)/2);
end;

Function V721A_ErrorI_DC(I:double):Double;
  function CalculError(Ilimit:double):double;
  {формула з опису приладу}
   begin
    if Ilimit=1e-3 then
       begin
        if abs(I)<Ilimit then  Result:=(0.08+0.03*(Ilimit/abs(I)-1))*0.01
                         else  Result:=0.0008;
        Exit;
       end;
    if abs(I)<Ilimit then  Result:=(0.1+0.04*(Ilimit/abs(I)-1))*0.01
                     else  Result:=0.001;
   end;
var
  j:integer;
begin
  if I=0 then
   begin
     Result:=0.4;
     Exit;
   end;

  for j := -7 to 1 do
    if abs(I)<1.2*Power(10,j) then
      begin
       Result:=CalculError(Power(10,j));
       Exit;
      end;

  Result:=ErResult;
end;


end.
