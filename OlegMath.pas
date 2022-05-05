unit OlegMath;

interface
 uses OlegType, Dialogs, SysUtils, Math, Classes, OlegVector;

const
  {нулі та вагові коефіцієнти для поліномів Лагера}
  Lager:array [0..19]of double=(
                    0.137793,	0.354010,
                    0.729455,	0.831902,
                    1.808343,	1.330289,
                    3.401433,	1.863064,
                    5.552496,	2.450256,
                    8.330153,	3.122764,
                    11.843786, 3.934153,
                    16.279258, 4.992415,
                    21.996586, 6.572202,
                    29.920697, 9.784696);
  {нулі та вагові коефіцієнти для поліномів Eрміта}
  Hermit:array [0..5]of double=(
                    2.350605,	1.136908,
                    1.335849,	0.935581,
                    0.436077,	0.876401);

Type
     TFun_IV=Function(Argument:double;Parameters:array of double;Key:double):double;
     TFunCorrectionNew=Function (A:TVector; B:TVector; fun:byte=0):boolean;
     {функція для перетворення даних в Pvector, зокрема використовується в диференціальних
     методах аналізу ВАХ}


Procedure Swap (var A:integer; var B:integer); overload;
{процедура обміну значеннями між цілими змінними А та В}

procedure Swap(var A:double; var B:double); overload;
{процедура обміну значеннями між дійсними змінними А та В}

procedure Swap(var A:real; var B:real); overload;
{процедура обміну значеннями між дійсними змінними А та В}

procedure SwapRound (var A:integer; var B:integer); overload;
{процедура обміну значеннями між цілими змінними А та В}

procedure SwapRound (var A:double; var B:double); overload;
{процедура обміну значеннями між дійсними змінними А та В}

procedure SwapRound (var A:string; var B:string); overload;
{процедура обміну значеннями між дійсними змінними А та В}


Function Y_X0 (X1,Y1,X2,Y2,X3:double):double;overload;
{знаходить ординату точки з абсцисою Х3,
яка знаходиться між точками (Х1,Y1) та (X2,Y2) -
лінійна інтерполяція по двом точкам}
Function Y_X0 (Point1,Point2:TPointDouble;X:double):double;overload;


Function X_Y0 (X1,Y1,X2,Y2,Y3:double):double;overload;
{знаходить абсцису точки з ординатою Y3,
яка знаходиться між точками (Х1,Y1) та (X2,Y2) -
лінійна інтерполяція по двом точкам}
Function X_Y0 (Point1,Point2:TPointDouble;Y:double):double;overload;

procedure ArrayToArray(var InitArray:TArrObj; AddedArray:TArrObj);
{додаються всі елементи з AddedArray в кінець InitArray}

function SqrRelativeDifference(Double1,Double2:double):double;
{повертає квадрат відносної різниці двох чисел}

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

Function MedianFiltr(a,b,c:double):double;
{повертає середнє за величиною з трьох чисел a, b, c}

Function Linear(a,b,x:double):double;overload;
{повертає a+b*x}
Function Linear(x:double;data:array of double):double;overload;
{повертає data[0]+data[1]*x}

Function NPolinom(x:double;N:word;data:array of double):double;overload;
{повертає data[0]+data[1]*x+...data[N]*x^N}

Function NPolinom(x:double;data:array of double):double;overload;
{повертає data[0]+data[1]*x+...data[High(data)]*x^High(data)}


Function NPolinomMinusX(x:double;data:array of double):double;overload;
{повертає data[0]+data[1]*x+...data[High(data)]*x^High(data)-x,
потрібна функція для знаходження екстремума за допомогою
Bisection}

Function Int_Trap(Fun:TFun;Xmin,Xmax,deltaX:double;Parameters:array of double):double;overload;
{знаходиться інтеграл від функції Fun(X,Parameters)
в межах від Xmin до Xmax,
крок по Х при знаходженні суми deltaX}

Function Int_Trap(Fun:TFun;Xmin,Xmax:double;Parameters:array of double;Npoint:integer):double;overload;
{знаходиться інтеграл від функції Fun(X,Parameters)
в межах від Xmin до Xmax,
знаходженні суми використовуються Npoint точок}

Function GoldenSection(fun:TFunSingle; a, b:double):double;
{повертає координату мінімума функції fun
на відрізку [a,b], вважається,
що там лише один мінімум;
використовується метод золотого перерізу}

Function Lambert(x:double):double;
{обчислює значення функції Ламберта}

Function gLambert(x:double):double;
{обчислюється значення функції g(x)=log(Lambert(exp(x)));
ця функція використовується для обчислення ВАХ щоб не
підносити експрненту у дуже великий ступінь}

Function LambertAprShot(V,E,Rs,I0,Rsh:double):double;
{розраховує апроксимацію ВАХ при напрузі V
за функцією Ламверта по значеннях параметрів Е,Rs,I0,Rsh,
Е=KbTn/q, використовується спрошений варіант,
справедливий для Rs<<Rsh}


Function LambertLightAprShot (V,E,Rs,I0,Rsh,Iph:double):double;
{розраховує апроксимацію освітленої ВАХ при напрузі V
за функцією Ламверта по значеннях параметрів Е,Rs,I0,Rsh,Iph
Е=KbTn/q}

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


Function IV_DiodTunnelLight(V:double;Data:array of double;I:double=0):double;
{I=I0*exp[A(V-I Rs)-Iph]
Data[0] - A
Data[1] - Rs
Data[2] - Ι0
Data[3] - Iph
}

Function IV_DiodTAT(V:double;Data:array of double;I:double=0):double;
{I=I0(Vd+V-I Rs)*exp[-4 (2m*)^0.5 Et^1.5/ 3 q h Fm]
Data[0] - I0
Data[1] - Rs
Data[2] - Vd
Data[3] - Et
}


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

Function IV_DiodDouble(V:double;Data:array of double;I:double=0):double;
{I=I01*[exp(q(V-I Rs)/E1)-1]+I02*[exp(q(V-I Rs)/E2)-1])
Data[0] - Ε1
Data[1] - Rs
Data[2] - Ι01
Data[3] - E2
Data[4] - Ι02
}

Function IV_DiodDoubleTau(V:double;Data:array of double;I:double=0):double;


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


Function Full_IV(F:TFun_IV;V:double;Data:array of double;Rsh:double=1e12;Iph:double=0):double;
{розраховує значення функції
I=F(V,E,I0,I,Rs)+(V-I Rs)/Rsh-Iph)}

Function MaxElemNumber(const a:array of double):integer;
{повертає номер найбільшого елементу масиву}

Function MinElemNumber(const a:array of double):integer;
{повертає номер наменшого елементу масиву}

Procedure ExtremumElementNumbers(const PointerArray:PTArrSingle;
                                 var MaxElementNumber:integer;
                                 var MinElementNumber:integer);
{повертаються номери найбільшого та найменшого
елементів масиву, на який вказує PointerArray}

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

Function IsEqual(a,b:double;eps:double=1e-8):boolean;
{True, якщо відносна різниця a та b менше eps}


Function Rs_T(T:double):double;
Function Fb_T(T:double):double;
Function n_T(T:double):double;

Function Gromov(x:double;data:array of double):double;
{повертає data[0]+data[1]*x+data[2]*ln(x)}

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

Function sinh(x:double):Double;
Function cosh(x:double):Double;
Function tanh(x:double):Double;
Function arcTanh(x:double):Double;

Function CastroIV(I:double;Parameters:array of double):double;

Function ThermallyActivated(A0,Eact,T:double):double;

Function ThermallyPower(A0,PowerLaw,T:double):double;

Procedure NormalArray(Arr:TArrSingle);
{сума елементів стає рівною 1, кожен з них в [0..1]}

Function RandCauchy(const x0,gamma:double):double;
{повертає випадкове число, що
підкоряється розподілу Коші}

Function IntegralRomberg(Fun:TFunS;a,b:double;eps:double=1e-4):double;overload;
{розраховується визначений інтеграл за методом Ромберга
від функції Fun в межах від а до b
з відносною точністю eps}

Function IntegralRomberg(Fun:TFun;Parameters:array of double;a,b:double;eps:double=1e-4):double;overload;

Function  ImproperIntegral(Fun:TFun;Parameters:array of double;SemiInfinity:boolean):double;overload;
{розрахунок невизначеного інтегралу від функції Fun
в межах від 0 до нескінченності (при SemiInfinity=True)
або від -нескінченності до нескінченності (при SemiInfinity=False);
Parameters - параметри функції;
використовується підхід із застосуванням формул Гауса-Крістофеля -
див. Зализняк В.Е. Основы научных вычислений;
звичайно і для випадку, коли інтеграл розходиться щось порахує -
тобто вибір функції за людиною}

Function  ImproperIntegral(Fun:TFunS; SemiInfinity:boolean):double;overload;

Function E1dop(x:double;Parameters:array of double):double;
{Result=exp(-(x+Parameters[0]))/(x+Parameters[0]),
використовується для розрахунку частки
фотонів, які викликають міжзонні переходи}

Function E1(x:double):double;
{Result=integral from x to infinity
for function exp(-t)/t dt,
використовується для розрахунку частки
фотонів, які викликають міжзонні переходи}

Function ExpMinusX2(x:double):double;
{exp(-x^2)}

Function Erf(x:double):double;
{функція помилок
2/sqrt(Pi)*int_0^x exp(-t^2) dt}

Function NormalCDF(x:double;mu:double=0;sigma:double=1):double;
{функція розподілу ймовірності для нормального розподілу,
ймовірність того, що величина має значення не більше-рівно x
mu - середнє,
sigma^2 - дисперсія;
FCD - cumulative distribution function}

Function NormalCDF_AB(a,b:double;mu:double=0;sigma:double=1):double;
{ймовірність того, що величина має значення a<x<=b при
нормальному розподілу з середнім mu та дисперсією sigma^2}

Function NormalPDF(x:double;mu:double=0;sigma:double=1):double;
{густина розподілу ймовірності при нормальному розподілі
(функція Гауса)
mu - середнє,
sigma^2 - дисперсія;
PDF -  probability density function}

Function GammaDod(x:double;Parameters:array of double):double;
{Result=exp(-x)*x^(Parameters[0]-1),
використовується при розрахунку Гамма-функції}

Function Gamma(x:double):double;overload;
{розрахунок Гамма-функції,
Result=integral_0^inf t^(x-1) exp(-t) dt
працює не ідеально, бачив похибку близько відсотка}

Function Gamma(n:word):double;overload;

Function Factorial(n:word):Int64;
{обчислення факторіалу}

Function GammaLowerIncomplete(s,x:double):double;
{Result=inegral_0^x t^(s-1)*exp(-t)dt
неідеальна, особливо при малих значеннях s}

Function ChiSquaredPDF(x:double;k:word):double;
{густина розподілу ймовірності при хі-квадрат розподілі
x>=0,
k - кількість ступенів вільності}

Function ChiSquaredCDF(x:double;k:word):double;
{функція розподілу ймовірності при хі-квадрат розподілі,
ймовірність того, що величина має значення не більше-рівно x,
x>=0,
k - кількість ступенів вільності, для k=1 рахувало препаршиво,
тому поставив обмеження, що k>1}

Function BettaDod(x:double;Parameters:array of double):double;
{Result=x^(Parameters[0]-1)*(1-x)^(Parameters[1]-1),
використовується при розрахунку Бетта-функції}

Function Betta(x,y:double):double;
{Бетта-функція,
Result=integral_0^1 t^(x-1)*(1-t)^(y-1) dt
при малих значеннях аргументів (менше 1-2) поганенько рахує}

Function BettaIncomplete(x,a,b:double):double;
{Бетта-функція,
Result=integral_0^x t^(a-1)*(1-t)^(b-1) dt
0<=x<=1
при малих значеннях аргументів (менше 1-2) поганенько рахує}

Function BettaRegularizedIncomplete(x,a,b:double):double;

Function FisherPDF(x:double;k1,k2:word):double;
{густина розподілу ймовірності при F-розподілі (розподілі Фішера),
x>=0,
k1, k2 - кількість ступенів вільності}

Function FisherCDF(x:double;k1,k2:word):double;
{функція розподілу ймовірності при F-розподілі,
ймовірність того, що величина має значення не більше-рівно x,
x>=0,
k1, k2 - кількість ступенів вільності,
про всяк випадок поставив обмеження k1>1, k2>1}


implementation

uses
  OlegMaterialSamples;

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

procedure SwapRound (var A:integer; var B:integer); overload;
{процедура обміну значеннями між цілими змінними А та В}
  var C:integer;
begin
  C:=A; A:=B; B:=C;
end;

procedure SwapRound (var A:double; var B:double); overload;
{процедура обміну значеннями між дійсними змінними А та В}
  var C:double;
begin
  C:=A; A:=B; B:=C;
end;

procedure SwapRound (var A:string; var B:string); overload;
{процедура обміну значеннями між дійсними змінними А та В}
  var C:string;
begin
  C:=A; A:=B; B:=C;
end;



Function Y_X0 (X1,Y1,X2,Y2,X3:double):double;overload;
{знаходить ординату точки з абсцисою Х3,
яка знаходиться між точками (Х1,Y1) та (X2,Y2) -
лінійна інтерполяція по двом точкам}
begin
 try
 Result:=(Y2*X1-Y1*X2)/(X1-X2)+X3*(Y1-Y2)/(X1-X2);
 except
 Result:=ErResult;
 end;
end;

Function Y_X0 (Point1,Point2:TPointDouble;X:double):double;overload;
begin
 Result:=Y_X0(Point1[cX],Point1[cY],Point2[cX],Point2[cY],X)
end;


Function X_Y0 (X1,Y1,X2,Y2,Y3:double):double;
{знаходить абсцису точки з ординатою Y3,
яка знаходиться між точками (Х1,Y1) та (X2,Y2) -
лінійна інтерполяція по двом точкам}
begin
 try
 Result:=(Y3-(Y2*X1-Y1*X2)/(X1-X2))/(Y1-Y2)*(X1-X2);
 except
 Result:=ErResult;
 end;
end;

Function X_Y0 (Point1,Point2:TPointDouble;Y:double):double;overload;
begin
  Result:=X_Y0(Point1[cX],Point1[cY],Point2[cX],Point2[cY],Y);
end;



procedure ArrayToArray(var InitArray:TArrObj; AddedArray:TArrObj);
{додаються всі елементи з AddedArray в кінець InitArray}
 var i:integer;
begin
  SetLength(InitArray,High(InitArray)+High(AddedArray)+2);
  for I := 0 to High(AddedArray) do
   InitArray[High(InitArray)-High(AddedArray)+i]:=AddedArray[i];
end;

function SqrRelativeDifference(Double1,Double2:double):double;
{повертає квадрат відносної різниці двох чисел}
begin
  Result:=0;
  if Double1<>0 then
     Result:=Result+sqr((Double1-Double2)/Double1)
                else
     if Double2<>0 then
        Result:=Result+sqr((Double1-Double2)/Double2)
                   else Result:=0;
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
 R^.CopyTo(Rtemp^);


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

Function Linear(x:double;data:array of double):double;
begin
  try
  Result:=data[0]+data[1]*x;
  except
  Result:=ErResult;
  end;
end;


Function NPolinom(x:double;N:word;data:array of double):double;overload;
{повертає data[0]+data[1]*x+...data[N]*x^N}
 var i:integer;
     temp:double;
begin
 if High(data)<=N then Result:=NPolinom(x,data)
                  else
 begin
   Result:=data[0];
   temp:=1;
   for I := 1 to N do
    begin
     temp:=temp*x;
     Result:=Result+temp*data[i];
    end;
 end;
end;

Function NPolinom(x:double;data:array of double):double;overload;
{повертає data[0]+data[1]*x+...data[High(data)]*x^High(data)}
 var i:integer;
     temp:double;
begin
 Result:=data[0];
 temp:=1;
 for I := 1 to High(data) do
  begin
   temp:=temp*x;
   Result:=Result+temp*data[i];
  end;
end;

Function NPolinomMinusX(x:double;data:array of double):double;overload;
begin
  Result:=NPolinom(x,data)-x;
end;

Function Int_Trap(Fun:TFun;Xmin,Xmax,deltaX:double;Parameters:array of double):double;
var Vec:TVector;
begin
  Vec:=TVector.Create;
  Vec.Filling(Fun,Xmin,Xmax,deltaX,Parameters);
  Result:=Vec.Int_Trap;
  Vec.Free;
end;

Function Int_Trap(Fun:TFun;Xmin,Xmax:double;Parameters:array of double;Npoint:integer):double;
var Vec:TVector;
begin
  Vec:=TVector.Create;
  Vec.Filling(Fun,Xmin,Xmax,Parameters,Npoint);
  Result:=Vec.Int_Trap;
  Vec.Free;
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
var temp1,temp2{,eps}:double;
    i:integer;
begin
  if x=0 then
     begin
       Result:=0;
       Exit;
     end;
  temp1:=0;
  i:=0;
  repeat
    temp2:=temp1-(temp1*exp(temp1)-x)/(exp(temp1)*(temp1+1)-
           (temp1+2)*(temp1*exp(temp1)-x)/(2*temp1+2));
    if temp2=0 then
         begin
           i:=1000000;
           Break;
         end;
    temp1:=temp2;
    inc(i);
  until (IsEqual(temp2,temp1,1e-7))or(i>1e5);
  if (i>1e5) then Result:=ErResult
             else Result:=temp2;
end;

Function gLambert(x:double):double;
{обчислюється значення функції g(x)=log(Lambert(exp(x)));
ця функція використовується для обчислення ВАХ щоб не
підносити експрненту у дуже великий ступінь}
 const Nit_Max=1e5;
       eps=1e-7;
 var e,y0,y1,ey0:double;
     i:integer;
     ToStopIteration:boolean;
begin
 e:=exp(1);
 if x<=-e then y0:=x
          else
     if x>=e then y0:=log10(x)
             else y0:=-e+(1+e)/2/e*(x+e);

 i:=0;
  try
    repeat
     ey0:=exp(y0);
     inc(i);
     y1:=y0-2*(y0+ey0-x)*(1+ey0)/(2*sqr(1+ey0)-(y0+ey0-x)*ey0);
     if abs(y0)<=1 then ToStopIteration:=abs(y0-y1)<eps
                   else ToStopIteration:=IsEqual(y0,y1,eps);
     y0:=y1;
    until (ToStopIteration or (i>Nit_Max));

  except

  end;
  Result:=y0;

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

Function IV_Diod(V:double;Data:array of double;I:double=0):double;
{I=I0*[exp(q(V-I Rs)/E)-1]
Data[0] - Ε  aбо n
Data[1] - Rs
Data[2] - Ι0
Data[3] - T (якщо Data[0] - n)
}
begin
 if High(Data)=2 then Result:=Data[2]*(exp((V-I*Data[1])/Data[0])-1)
    else if High(Data)=3 then Result:=Data[2]*(exp((V-I*Data[1])/(Data[0]*Kb*Data[3]))-1)
         else Result:=ErResult;

end;

Function IV_DiodTunnel(V:double;Data:array of double;I:double=0):double;
{I=I0*exp[A(V-I Rs)]
Data[0] - A
Data[1] - Rs
Data[2] - Ι0
}
begin
  Result:=Data[2]*exp((V-I*Data[1])*Data[0]);
end;


Function IV_DiodTunnelLight(V:double;Data:array of double;I:double=0):double;
{I=I0*exp[A(V-I Rs)-Iph]
Data[0] - A
Data[1] - Rs
Data[2] - Ι0
Data[3] - Iph
}
begin
  Result:=Data[2]*exp((V-I*Data[1])*Data[0])-Data[3];
end;

Function IV_DiodTAT(V:double;Data:array of double;I:double=0):double;
{I=I0(Vd+V-I Rs)*exp[-4 (2m*)^0.5 Et^1.5/ 3 q h Fm]
Data[0] - I0
Data[1] - Rs
Data[2] - Vd
Data[3] - Et
}
 var F:double;
begin
 F:=sqrt(Qelem*Diod.Semiconductor.Nd*(Data[2]+V-I*Data[1])/
                  (2*Diod.Semiconductor.Material.Eps*Eps0));

 Result:=Data[0]*(Data[2]+V-I*Data[1])*exp(-4*sqrt(2*Diod.Semiconductor.Meff*m0)*
                  Power(Qelem*Data[3],1.5)/(3*Qelem*Hpl*F));
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
   Vreal:=V-I*Data[1];
  F:=sqrt(Qelem*Data[5]*(Data[2]+Vreal)/2/Data[6]/Eps0);
  Result:=(Data[2]+Vreal)*Data[0]*exp(-4*sqrt(2*Data[4]*m0)*
                           Power(Qelem*Data[3],1.5)/
                           (3*Qelem*Hpl*F));
end;

Function IV_DiodDouble(V:double;Data:array of double;I:double=0):double;
{I=I01*[exp(q(V-I Rs)/E1)-1]+I02*[exp(q(V-I Rs)/E2)-1])
Data[0] - Ε1 або n1
Data[1] - Rs
Data[2] - Ι01
Data[3] - E2 або n2
Data[4] - Ι02
Data[5] - T (якщо Ei використовуються)
}
begin
 if High(Data)=4 then Result:=IV_Diod(V,[Data[0],Data[1],Data[2]],I)+
                              IV_Diod(V,[Data[3],Data[1],Data[4]],I)
    else if High(Data)=5 then Result:=IV_Diod(V,[Data[0],Data[1],Data[2],Data[5]],I)+
                              IV_Diod(V,[Data[3],Data[1],Data[4],Data[5]],I)
         else Result:=ErResult;
end;

Function IV_DiodDoubleTau(V:double;Data:array of double;I:double=0):double;
{I=I01*[exp(q(V-I Rs)/E1)-1]+I02*[exp(q(V-I Rs)/E2)-1])
Data[0] - n1
Data[1] - Rs
Data[2] - tau_n
Data[3] - n2
Data[4] - tau_g
Data[5] - T
}
begin
 Data[2]:=DiodPN.Igen(Data[2],Data[5]);
 Data[4]:=DiodPN.Iscr(Data[4],Data[5],V-I*Data[1]);
 Result:=IV_DiodDouble(V,Data,I);
// Vreal:=V-I*Data[1];
// I01:=DiodPN.Igen(Data[2],Data[5]);
// I02:=DiodPN.Iscr(Data[4],Data[5],Vreal);
//  Result:=IV_DiodDouble(V,[Data[0],Data[1],I01,Data[3],I02,Data[5]],I);

end;


Function IV_DiodTriple(V:double;Data:array of double;I:double=0):double;
{I=I01*[exp(q(V-I Rs)/E1)-1]+I02*[exp(q(V-I Rs)/E2)-1])
Data[0] - Ε1 або n1
Data[1] - Rs
Data[2] - Ι01
Data[3] - E2  або n2
Data[4] - Ι02
Data[5] - E3  або n3
Data[6] - Ι03
Data[7] - T (якщо Ei використовуються)
}
begin
 if High(Data)=6 then Result:=IV_Diod(V,[Data[0],Data[1],Data[2]],I)+
                              IV_DiodDouble(V,[Data[3],Data[1],Data[4],Data[5],Data[6]],I)
    else if High(Data)=7 then Result:=IV_Diod(V,[Data[0],Data[1],Data[2],Data[7]],I)+
                              IV_DiodDouble(V,[Data[3],Data[1],Data[4],Data[5],Data[6],Data[7]],I)
         else Result:=ErResult;

// if I=0 then Result:=Data[2]*(exp(V/Data[0])-1)+
//                     Data[4]*(exp(V/Data[3])-1)+
//                     Data[6]*(exp(V/Data[5])-1)
//        else Result:=Data[2]*(exp((V-I*Data[1])/Data[0])-1)+
//                     Data[4]*(exp((V-I*Data[1])/Data[3])-1)+
//                     Data[6]*(exp((V-I*Data[1])/Data[5])-1);
end;

Function Full_IV(F:TFun_IV;V:double;Data:array of double;Rsh:double=1e12;Iph:double=0):double;
{Data[1] має бути Rs}
{розраховує значення функції
I=F(V,E,I0,I,Rs)+(V-I Rs)/Rsh-Iph)}
    Function I_V(I:double):double;
    begin
      Result:=I-F(V, Data,I)+Iph;
      if Rsh<1e12 then Result:=Result-(V-I*Data[1])/Rsh;
    end;
const eps=1e-6;
      Nit_Max=1e6;
var i:integer;
    a,b,c,Ia,Ic:double;
begin
 try
  if Rsh>1e12 then Rsh:=1e12;
  if (Data[1]<=1e-4) then
   begin
     if (Rsh=1e12) then Result:=F(V,Data,0)-Iph
                   else Result:=F(V,Data,0)+V/Rsh-Iph;
     Exit;
   end;

  c:=F(V,Data,0)-Iph;
  if c*Data[1]>88 then c:=10/Data[1];

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
          repeat
            b:=b+0.1*abs(c);
          until I_V(b)>0;

          except

          end;
         end;//else
     i:=0;
     Ia:=I_V(a);
     repeat
       inc(i);
       c:=(a+b)/2;
       Ic:=I_V(c);
       if (Ic*Ia<=0)
           then b:=c
           else begin
                a:=c;
                Ia:=Ic;
                end;

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


Function MaxElemNumber(const a:array of double):integer;
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

Function MinElemNumber(const a:array of double):integer;
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

Procedure ExtremumElementNumbers(const PointerArray:PTArrSingle;
                                 var MaxElementNumber:integer;
                                 var MinElementNumber:integer);
 var i:integer;
     tempMax,tempMin:double;
begin
 if High(PointerArray^)<0 then Exit;
 MaxElementNumber:=0;
 MinElementNumber:=0;
 tempMax:=PointerArray^[0];
 tempMin:=PointerArray^[0];

 for I := 0 to High(PointerArray^) do
  begin
   if tempMin>PointerArray^[i] then
     begin
       MinElementNumber:=i;
       tempMin:=PointerArray^[i];
     end;
   if tempMax<PointerArray^[i] then
     begin
       MaxElementNumber:=i;
       tempMax:=PointerArray^[i];
     end;
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


Function IsEqual(a,b:double;eps:double=1e-8):boolean;
{True, якщо відносна різниця a та b менше eps}
begin
 if ((a=0)and(b=0)) then
  begin
    Result:=True;
    Exit;
  end;
 Result:=(abs(b-a)/Max(abs(a),abs(b))<eps)
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

end;

Function n_T(T:double):double;
begin
Result:=1+35/T;
//Result:=1.01;
//Result:=1.5;
end;


Function Gromov(x:double;data:array of double):double;
{повертає data[0]+data[1]*x+data[2]*ln(x)}
begin
  Result:= data[0]+data[1]*x+data[2]*ln(x);
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
 if (T<=0)or(w<=0)or(High(Parameters)<2) then Exit;
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

Function sinh(x:double):Double;
begin
 Result:=(exp(x)-exp(-x))/2;
end;

Function cosh(x:double):Double;
begin
 Result:=(exp(x)+exp(-x))/2;
end;

Function tanh(x:double):Double;
begin
  Result:=(exp(x)-exp(-x))/(exp(x)+exp(-x));
end;

Function arcTanh(x:double):Double;
begin
  Result:=ln((1+x)/(1-x))/2;
end;

Function CastroIV(I:double;Parameters:array of double):double;
 var Vt,temp10,temp20,temp11,temp21,x1,x2:double;

begin
 Vt:=Kb*Parameters[8];

 temp10:=1/Vt/Parameters[1];// q/kTn
 temp20:=1/Vt/Parameters[4];

 temp11:=Parameters[2]*temp10; // Rsh q/kTn
 temp21:=Parameters[5]*temp20;

 x1:=log10(temp11*Parameters[0])+temp11*(I+Parameters[7]+Parameters[0]);
 x2:=log10(temp21*Parameters[3])-temp21*(I-Parameters[3]);
 Result:=I*Parameters[6]+gLambert(x1)/temp10
         -gLambert(x2)/temp20
         -log10(temp11*Parameters[0])/temp10
         +log10(temp21*Parameters[3])/temp20;

end;

Function ThermallyActivated(A0,Eact,T:double):double;
begin
 if T>0 then Result:=A0*exp(-Eact/T/Kb)
        else Result:=ErResult;
end;

Function ThermallyPower(A0,PowerLaw,T:double):double;
begin
 if T>0 then Result:=A0*Power(T,PowerLaw)
        else Result:=ErResult;
end;


Procedure NormalArray(Arr:TArrSingle);

 var i:integer;
     summa:Extended;
     minVal:double;
begin
 minVal:=MinValue(Arr);
 if minVal<0 then
   begin
    minVal:=abs(minVal);
    for i:=0 to High(Arr) do Arr[i]:=Arr[i]+minVal;
   end;
 summa:=Sum(Arr);
 if summa=0 then Exit;
 for i:=0 to High(Arr) do Arr[i]:=Arr[i]/Summa;
end;


Function RandCauchy(const x0,gamma:double):double;
begin
  Result:=x0+gamma*tan(Pi*(Random-0.5));
end;


Function IntegralRomberg(Fun:TFunS;a,b:double;eps:double=1e-4):double;
{розраховується визначений інтеграл за методом Ромберга
від функції Fun в межах від а до b
з відносною точністю eps}
 var step:double;
     koef:array of double;
     IterationNumber,Nstep,i:integer;
     Integ,Kf_temp,Kf_temp2:double;

begin
  Nstep:=10;
  step:=(b-a)/Nstep;
  Integ:=0;
  for I := 1 to Nstep-1 do
    Integ:=Integ+Fun(a+i*step);
  Integ:=(Integ+0.5*(Fun(a)+Fun(b)))*step;
  IterationNumber:=1;
  SetLength(koef,IterationNumber);
  koef[0]:=Integ;
  repeat
    Nstep:=2*Nstep;
    step:=(b-a)/Nstep;
    inc(IterationNumber);
    SetLength(koef,IterationNumber);
    Integ:=0;
    for I := 1 to round(Nstep/2) do
      Integ:=Integ+Fun(a+(2*i-1)*step);
    Integ:=0.5*koef[0]+step*Integ;
    Kf_temp:=koef[0];
    Kf_temp2:=0;
    koef[0]:=Integ;
    for I := 1 to High(koef) do
     begin
       if i<High(koef) then Kf_temp2:=koef[i];
       koef[i]:=(power(2,2*i)*koef[i-1]-Kf_temp)/(power(2,2*i)-1);
       if i<High(koef) then Kf_temp:=Kf_temp2;
     end;
  until IsEqual(koef[High(koef)],koef[High(koef)-1],eps);
  Result:=koef[High(koef)];
end;

Function IntegralRomberg(Fun:TFun;Parameters:array of double;a,b:double;eps:double=1e-4):double;overload;
 var step:double;
     koef:array of double;
     IterationNumber,Nstep,i:integer;
     Integ,Kf_temp,Kf_temp2:double;

begin
  Nstep:=10;
  step:=(b-a)/Nstep;
  Integ:=0;
  for I := 1 to Nstep-1 do
    Integ:=Integ+Fun(a+i*step,Parameters);
  Integ:=(Integ+0.5*(Fun(a,Parameters)+Fun(b,Parameters)))*step;
  IterationNumber:=1;
  SetLength(koef,IterationNumber);
  koef[0]:=Integ;
  repeat
    Nstep:=2*Nstep;
    step:=(b-a)/Nstep;
    inc(IterationNumber);
    SetLength(koef,IterationNumber);
    Integ:=0;
    for I := 1 to round(Nstep/2) do
      Integ:=Integ+Fun(a+(2*i-1)*step,Parameters);
    Integ:=0.5*koef[0]+step*Integ;
    Kf_temp:=koef[0];
    Kf_temp2:=0;
    koef[0]:=Integ;
    for I := 1 to High(koef) do
     begin
       if i<High(koef) then Kf_temp2:=koef[i];
       koef[i]:=(power(2,2*i)*koef[i-1]-Kf_temp)/(power(2,2*i)-1);
       if i<High(koef) then Kf_temp:=Kf_temp2;
     end;
  until IsEqual(koef[High(koef)],koef[High(koef)-1],eps);
  Result:=koef[High(koef)];
end;

Function  ImproperIntegral(Fun:TFun;Parameters:array of double;SemiInfinity:boolean):double;overload;
{розрахунок невизначеного інтегралу від функції Fun
в межах від 0 до нескінченності (при SemiInfinity=True)
або від -нескінченності до нескінченності (при SemiInfinity=False);
Parameters - параметри функції}
  var i:byte;
begin
  Result:=0;
  if SemiInfinity then
   for I := 0 to trunc(High(Lager)/2) do
     Result:=Result+Lager[2*i+1]*Fun(Lager[2*i],Parameters)
                  else
   begin
   for I := 0 to trunc(High(Hermit)/2) do
     begin
//     showmessage(floattostr());
     Result:=Result+Hermit[2*i+1]
        *(Fun(Hermit[2*i],Parameters)+Fun(-Hermit[2*i],Parameters))
     end;
   end;
end;

Function  ImproperIntegral(Fun:TFunS; SemiInfinity:boolean):double;overload;
  var i:byte;
begin
  Result:=0;
  if SemiInfinity then
   for I := 0 to trunc(High(Lager)/2) do
     Result:=Result+Lager[2*i+1]*Fun(Lager[2*i])
                  else
   begin
   for I := 0 to trunc(High(Hermit)/2) do
     begin
//     showmessage(floattostr());
     Result:=Result+Hermit[2*i+1]
        *(Fun(Hermit[2*i])+Fun(-Hermit[2*i]))
     end;
   end;

end;

Function E1dop(x:double;Parameters:array of double):double;
{Result=exp(-(x+Parameters[0]))/(x+Parameters[0]),
використовується для розрахунку частки
фотонів, які викликають міжзонні переходи}
begin
  try
   Result:=exp(-(x+Parameters[0]))/(x+Parameters[0]);
  except
   Result:=ErResult;
  end;
end;

Function E1(x:double):double;
begin
 Result:=ImproperIntegral(E1dop,[x],True);
end;


Function ExpMinusX2(x:double):double;
{exp(-x^2)}
begin
  Result:=exp(-sqr(x));
end;

Function Erf(x:double):double;
{функція помилок
2/sqrt(Pi)*int_0^x exp(-t^2) dt}
begin
  Result:=2/sqrt(Pi)*IntegralRomberg(ExpMinusX2,0,x,1e-8);
end;


Function NormalCDF(x,mu,sigma:double):double;
{функція розподілу ймовірності для нормального розподілу,
ймовірність того, що величина має значення не більше-рівно x
mu - середнє,
sigma^2 - дисперсія}
begin
  try
   Result:=0.5*(1+Erf((x-mu)/sqrt(2)/sigma))
  except
   Result:=ErResult;
  end;
end;

Function NormalCDF_AB(a,b:double;mu:double=0;sigma:double=1):double;
{ймовірність того, що величина має значення a<x<=b при
нормальному розподілу з середнім mu та дисперсією sigma^2}
begin
  if sigma=0 then
   begin
     Result:=ErResult;
     Exit
   end;
  Result:=NormalCDF(b,mu,sigma)-NormalCDF(a,mu,sigma);
end;

Function NormalPDF(x:double;mu:double=0;sigma:double=1):double;
begin
  try
   Result:=1/sigma/sqrt(2*Pi)*exp(-sqr((x-mu)/sigma)/2);
  except
   Result:=ErResult;
  end;
end;

Function GammaDod(x:double;Parameters:array of double):double;
{Result=exp(-x)*x^(Parameters[0]-1),
використовується при розрахунку Гамма-функції}
begin
 try
  Result:=exp(-x)*Power(x,Parameters[0]-1);
 except
  Result:=ErResult;
 end;
end;

Function Gamma(x:double):double;overload;
{розрахунок Гамма-функції,
Result=integral_0^inf t^(x-1) exp(-t) dt}
begin
 Result:=ImproperIntegral(GammaDod,[x],True);
end;

Function Gamma(n:word):double;overload;
begin
  if n=0 then
   begin
     Result:=ErResult;
     Exit
   end;
  Result:=Factorial(n-1);
end;

Function Factorial(n:word):Int64;
{обчислення факторіалу}
begin
  if n=0 then Result:=1
         else Result:=n*Factorial(n-1);
end;

Function GammaLowerIncomplete(s,x:double):double;
{Result=inegral_0^x t^(s-1)*exp(-t)dt}
begin
 if (x<0)or(s<=0) then
   begin
     Result:=ErResult;
     Exit
   end;
  Result:=IntegralRomberg(GammaDod,[s],0,x,1e-8);
end;

Function ChiSquaredPDF(x:double;k:word):double;
{густина розподілу ймовірності при хі-квадрат розподілі
k - кількість ступенів вільності}
 var G,k2:double;
begin
 if (k<1)or(x<0)or((k=1)and(x<=0)) then
   begin
     Result:=ErResult;
     Exit
   end;
 k2:=k/2.0;
 if odd(k) then G:=Gamma(k2)
           else G:=Gamma(round(k2));
 Result:=Power(x,k2-1)*exp(-x/2.0)
         /Power(2,k2)/G;
end;

Function ChiSquaredCDF(x:double;k:word):double;
{функція розподілу ймовірності при хі-квадрат розподілі,
ймовірність того, що величина має значення не більше-рівно x
k - кількість ступенів вільності}
  var G,k2:double;
begin
 if (k<2)or(x<0) then
   begin
     Result:=ErResult;
     Exit
   end;
 k2:=k/2.0;
 if odd(k) then G:=Gamma(k2)
           else G:=Gamma(round(k2));
 Result:=GammaLowerIncomplete(k2,x/2.0)/G;
end;

Function BettaDod(x:double;Parameters:array of double):double;
{Result=x^(Parameters[0]-1)*(1-x)^(Parameters[1]-1),
використовується при розрахунку Бетта-функції}
begin
 Result:=Power(x,(Parameters[0]-1))*Power((1-x),(Parameters[1]-1));
end;

Function Betta(x,y:double):double;
{Бетта-функція,
Result=integral_0^1 t^(x-1)*(1-t)^(y-1) dt}
begin
  Result:=IntegralRomberg(BettaDod,[x,y],0,1,1e-8);
end;

Function BettaIncomplete(x,a,b:double):double;
begin
 if (x<0)or(x>1) then
   begin
     Result:=ErResult;
     Exit
   end;
 Result:=IntegralRomberg(BettaDod,[a,b],0,x,1e-8);
end;

Function BettaRegularizedIncomplete(x,a,b:double):double;
begin
 if (x<0)or(x>1) then
   begin
     Result:=ErResult;
     Exit
   end;
 Result:=BettaIncomplete(x,a,b)/Betta(a,b);
end;

Function FisherPDF(x:double;k1,k2:word):double;
{густина розподілу ймовірності при F-розподілі (розподілі Фішера),
x>=0,
k1, k2 - кількість ступенів вільності}
begin
 if (x<0)or(x>1) then
   begin
     Result:=ErResult;
     Exit
   end;
 Result:=Power(k1/k2,k1/2.0)*Power(x,k1/2.0-1)
         *Power((1+k1/k2*x),-(k1+k2)/2.0)/Betta(k1/2.0,k2/2.0);
end;

Function FisherCDF(x:double;k1,k2:word):double;
{функція розподілу ймовірності при F-розподілі,
ймовірність того, що величина має значення не більше-рівно x,
x>=0,
k1, k2 - кількість ступенів вільності,
про всяк випадок поставив обмеження k1>1, k2>1}
begin
 if (x<0)or(x>1) then
   begin
     Result:=ErResult;
     Exit
   end;
 Result:=BettaRegularizedIncomplete(k1*x/(k1*x+k2),k1/2.0,k2/2.0);
end;


end.
