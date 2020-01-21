unit OlegDigitalManipulation;

interface

uses
  Windows,Math,OlegVector,OlegType;

type

  TFunWidowFiltr=Function(i:word):double of object;
  {функція розрахунку i-го коефіцієнта
  віконного фільтра}


  TVDigitalManipulation=class(TVector)
   private
     fA,fB:TArrSingle;
     {масиви для коефіцієнтів фільтрування}
     fNtoDelete:word;
     {кількість точок, що буде видалена після фільтрування}
     fNotOdd_N: byte;
     {порядок FIR фільтру, має бути парним}
     fFreqFact: double;
     {число в інтервалі  (0..1],
     частота зрізу як частка від частоти Найквіста}
     fNorm:double;
     {нормувальний коефіцієнт для фільтра}
     fAlphaCheb:double;
     {змінна, потрібна у вікні Чебишева}
     Procedure DigitalFiltr(a,b:TArrSingle;NtoDelete:word=0);overload;
     {змінюються масив Y на Ynew:
     Ynew[k]=a[0]*Y[k]+a[1]*Y[k-1]+...b[0]*Ynew[k-1]+b[1]*Ynew[k-2]...
     NtoDelete - кількість точок, які видаляються
     з початку масиву; потрібно, якщо видаляється
     перехідна ділянка}
     Procedure DigitalFiltr();overload;
     procedure SetDeleteTrancientNumber(ToDeleteTrancient:boolean;
                                        NtoDelete:word);
     procedure SetNotOdd_N(const NotOdd_N: byte);
     function DoubleTo01(const Value:double):double;
     procedure SetFreqFact(const FrequencyFactor:double);
     Function NormForFIR:double;
     Procedure FIR_WindowFiltr(Func:TFunWidowFiltr;
                               NotOdd_N:byte;
                               FrequencyFactor:double;
                               ToDeleteTrancient:boolean=false);
   {віконний фільтр зі скінченною імпульсною
    характеристикою (FIR - finite impulse responce);
   Func - функція, яка розраховує коефіцієнти;
   NotOdd_N - порядок фільтра, має бути парним числом;
   FrequencyFactor - частота зрізу як частка від частоти Найквіста,
   має бути (0..1];
   при ToDeleteTrancient = True з початку вектора
   видаляється кількість точок, яка відповідає
   перехідній характеристиці;
   koef - додатковий параметр, який потрібний при деяких типах
   вікон}
    function LP_Simple(i:word):double;
    function HP_Simple(i:word):double;
    function Blackman(i:word):double;
    function ChebyshevWindow(i:word):double;
    procedure LP_IIR_Chebyshev(A,B:array of double;
                               NormKoef:double;
                               TrancientNumber:word;
                               ToDeleteTrancient:boolean);
   public
    Procedure Decimation(Np:word);
   {залишається лише 0-й, Νp-й, 2Np-й.... елементи,
    при Np=0 вектор масив не міняється}
    procedure LP_IIR_Chebyshev045p2(ToDeleteTrancient:boolean=false);
   {застосовується фільтр низьких частот (LP - low pass)
   з нескінченною імпульсною характеристикою (IIR - infinite
   impulse responce) Чебишева I роду з рівнем нерівномірності АЧХ
   в області пропускання 0,5%
    та частотою зрізу 0.45 від частоти Найквіста,
   кількість полюсів дорівнює 2, коефіцієнти
   взяті з С.Смит "Цифровая обработка сигналов", 2012р, с.380-382;
    тривалість перехідної характеристики (до рівня ~10^-5)
    - близько 50 відліків;
   при ToDeleteTrancient = True з початку вектора
   видаляється кількість точок, яка відповідає
   перехідній характеристиці}
   procedure LP_IIR_Chebyshev045p6(ToDeleteTrancient:boolean=false);
  {див.вище, частота зрізу 0.45 частоти Найквіста,
   полюсів 6,
   перехіднa - 270 відліків}
  procedure LP_IIR_Chebyshev001p2(ToDeleteTrancient:boolean=false);
  {див.вище, частота зрізу 0.01 частоти Найквіста,
   полюсів 2,
   перехідна -  300 відліків}
  procedure LP_IIR_Chebyshev0025p2(ToDeleteTrancient:boolean=false);
  {див.вище, частота зрізу 0.025 частоти Найквіста,
   полюсів 2,
   перехідна - 120 відліків}
  procedure LP_IIR_Chebyshev0025p4(ToDeleteTrancient:boolean=false);
  {див.вище, частота зрізу 0.025 частоти Найквіста,
   полюсів 4,
   перехідна - 300 відліків}
  procedure LP_IIR_Chebyshev0075p4(ToDeleteTrancient:boolean=false);
  {див.вище, частота зрізу 0.075 частоти Найквіста,
   полюсів 4,
   перехідна - близько 100 відліків}
  procedure LP_IIR_Chebyshev0075p6(ToDeleteTrancient:boolean=false);
  {див.вище, частота зрізу 0.075 частоти Найквіста,
   полюсів 6,
   перехідна - близько 190 відліків}
//  Procedure LP_FIR_SimpleWindow(NotOdd_N:byte;
//                                FrequencyFactor:double;
//                                ToDeleteTrancient:boolean=false);
   {віконний фільтр нижніх частот зі скінченною імпульсною
    характеристикою (FIR - finite impulse responce);
    використовується прямокутне вікно;
   NotOdd_N - порядок фільтра, має бути парним числом;
   FrequencyFactor - частота зрізу як частка від частоти Найквіста,
   має бути (0..1]}
  Procedure LP_FIR_Blackman(NotOdd_N:byte;
                                FrequencyFactor:double;
                                ToDeleteTrancient:boolean=false);
 {вікно Блекмена}
  Procedure LP_FIR_Chebyshev(NotOdd_N:byte;
                             FrequencyFactor:double;
                             ToDeleteTrancient:boolean=false;
                             Atten:double=60);
 {вікно Чебишева,
  Atten - рівень бокових пелюсток в децибелах}
   Procedure HP_FIR_SimpleWindow(NotOdd_N:byte;
                               FrequencyFactor:double;
                                ToDeleteTrancient:boolean=false);
  {застосовується простий віконний фільтр верхіх частот зі скінченною імпульсною
   характеристикою; параметри. див. вище}

   Procedure MovingAverageFilter(const Np:word;
               ToDeleteTrancient:boolean=false);
   {фільтр ковзаючого середнього
   Np - кількість точок для усереднення}

   procedure LP_UniformIIRfilter(const FrequencyFactor:double=0.5;
                                ToDeleteTrancient:boolean=false);
   {однорідний рекурсивний фільтр (експоненційне усереднення),
    FrequencyFactor - частота зрізу як частка від частоти Найквіста,
    має бути (0..0,5)}
   procedure LP_UniformIIRfilter4k(const FrequencyFactor:double=0.5;
                                ToDeleteTrancient:boolean=false);
   {як попередній, але 4 каскади}
  end;


implementation

{ TVDigitalManipulation }

procedure TVDigitalManipulation.DigitalFiltr(a, b: TArrSingle; NtoDelete: word);
 var Yold:PTArrSingle;
     i,j:integer;
begin
 if (High(a)<0) then Exit;
 if NtoDelete>=Self.Count then
   begin
     Self.Clear;
     Exit;
   end;

 Yold:=CopyYtoPArray;
 for I := 0 to Self.HighNumber do
  begin
   Y[i]:=0;
   for j := 0 to High(a) do
      if (i-j>=0) then Y[i]:=Y[i]+a[j]*Yold^[i-j]
                  else Break;
   for j := 0 to High(b) do
      if (i-j>0) then Y[i]:=Y[i]+b[j]*Y[i-j-1]
                  else Break;
  end;
 dispose(Yold);

 Self.DeleteNfirst(NtoDelete);
end;

function TVDigitalManipulation.Blackman(i: word): double;
begin
 Result:=LP_Simple(i)*
        (0.42-0.5*cos(2*Pi*i/(fNotOdd_N-1))+0.08*cos(4*Pi*i/(fNotOdd_N-1)));
end;

function TVDigitalManipulation.ChebyshevWindow(i: word): double;
 var temp:double;
begin
  temp:=fAlphaCheb*cos(Pi*i/fNotOdd_N);

  if abs(Temp)>1 then
     Result:=LP_Simple(i)*
          cosh(fNotOdd_N*ArcCosh(abs(Temp)))/
            cosh(fNotOdd_N*ArcCosh(fAlphaCheb))
            else
     Result:=LP_Simple(i)*
          cos(fNotOdd_N*ArcCos(Temp))/
            cosh(fNotOdd_N*ArcCosh(fAlphaCheb));
end;

procedure TVDigitalManipulation.Decimation(Np: word);
 var i:integer;
begin
  if (Np<=1)or (Self.IsEmpty) then Exit;
  i:=1;
  while(i*Np)<Self.Count do
   begin
    X[i]:=X[i*Np];
    Y[i]:=Y[i*Np];
    inc(i);
   end;
  SetLenVector(i);
end;

procedure TVDigitalManipulation.DigitalFiltr;
begin
  DigitalFiltr(fA,fB,fNtoDelete);
  Self.MultiplyY(1/fNorm);
end;

function TVDigitalManipulation.DoubleTo01(const Value: double): double;
begin
 Result:=Abs(Value);
 if Result<>1 then
      Result:=Frac(Result);
end;

procedure TVDigitalManipulation.FIR_WindowFiltr(Func: TFunWidowFiltr;
                         NotOdd_N: byte;
                         FrequencyFactor: double;
                         ToDeleteTrancient: boolean);
 var i:word;
begin
 SetNotOdd_N(NotOdd_N);
 if (fNotOdd_N)=0 then Exit;

 SetFreqFact(FrequencyFactor);
 if (fFreqFact=0) then Exit;


 SetLength(fA,fNotOdd_N);
 for I := 0 to fNotOdd_N-1 do fA[i]:=Func(i);
 SetLength(fB,0);

 fNorm:=NormForFIR();

 SetDeleteTrancientNumber(ToDeleteTrancient,fNotOdd_N);
 DigitalFiltr();
end;

procedure TVDigitalManipulation.HP_FIR_SimpleWindow(NotOdd_N: byte;
  FrequencyFactor: double; ToDeleteTrancient: boolean);
begin
  FIR_WindowFiltr(HP_Simple,NotOdd_N,
       FrequencyFactor,ToDeleteTrancient);
end;

function TVDigitalManipulation.HP_Simple(i: word): double;
begin
 Result:=cos(Pi*fFreqFact*(i-(fNotOdd_N-1)/2.0))/(Pi*(i-(fNotOdd_N-1)/2.0));
end;

procedure TVDigitalManipulation.LP_FIR_Blackman(NotOdd_N: byte;
  FrequencyFactor: double; ToDeleteTrancient: boolean);
begin
  FIR_WindowFiltr(Blackman,NotOdd_N,
      FrequencyFactor,ToDeleteTrancient);
end;

procedure TVDigitalManipulation.LP_FIR_Chebyshev(NotOdd_N: byte;
  FrequencyFactor: double; ToDeleteTrancient: boolean; Atten: double);
begin
   SetNotOdd_N(NotOdd_N);
 if (fNotOdd_N)=0 then Exit;

  fAlphaCheb:=cosh(arcCosh(Power(10,abs(Atten/20.0)))/fNotOdd_N);
  FIR_WindowFiltr(ChebyshevWindow,NotOdd_N,FrequencyFactor,ToDeleteTrancient);
end;

//procedure TVDigitalManipulation.LP_FIR_SimpleWindow(NotOdd_N: byte;
//  FrequencyFactor: double; ToDeleteTrancient: boolean);
//begin
//
//end;

procedure TVDigitalManipulation.LP_IIR_Chebyshev(A, B: array of double;
                          NormKoef: double;
                          TrancientNumber: word;
                          ToDeleteTrancient: boolean);
 var i:byte;
begin
 if (High(A)<0)or(High(B)<0) then Exit;
 SetLength(fA,2*High(A)+1);
 for I := 0 to High(A) do fA[i]:=A[i];
 for I := 0 to High(A)-1 do fA[High(fA)-i]:=A[i];

 SetLength(fB,High(B)+1);
 for I := 0 to High(B) do fB[i]:=B[i];

 SetDeleteTrancientNumber(ToDeleteTrancient,TrancientNumber);
 fNorm:=NormKoef;
 DigitalFiltr();
end;

procedure TVDigitalManipulation.LP_IIR_Chebyshev001p2(
  ToDeleteTrancient: boolean);
begin
 LP_IIR_Chebyshev([8.663387e-4,1.732678e-3],
                  [1.919129,-0.9225943],
                  1.000015989,
                  300,ToDeleteTrancient);
end;

procedure TVDigitalManipulation.LP_IIR_Chebyshev0025p2(
  ToDeleteTrancient: boolean);
begin
 LP_IIR_Chebyshev([5.112374e-3,1.022475e-2],
                  [1.797154,-0.8176033],
                  1.000009682,
                  120,ToDeleteTrancient);
end;

procedure TVDigitalManipulation.LP_IIR_Chebyshev0025p4(
  ToDeleteTrancient: boolean);
begin
 LP_IIR_Chebyshev([1.504626e-5,6.018503e-5,9.027754e-5],
                  [3.725385,-5.226004,3.270902,-0.7705239],
                  0.9993363221,
                  300,ToDeleteTrancient);
end;

procedure TVDigitalManipulation.LP_IIR_Chebyshev0075p4(
  ToDeleteTrancient: boolean);
begin
 LP_IIR_Chebyshev([9.726342e-4,3.890537e-3,5.835806e-3],
                  [3.103944,-3.774453,2.111238,-0.4562908],
                  1.000022388,
                  100,ToDeleteTrancient);
end;

procedure TVDigitalManipulation.LP_IIR_Chebyshev0075p6(
  ToDeleteTrancient: boolean);
begin
 LP_IIR_Chebyshev([1.797538e-5,1.078523e-4,2.696307e-4,3.595076e-4],
                  [4.921746,-10.35734,11.89764,-7.854533,2.822109,-0.4307710],
                  1.001239652,
                  190,ToDeleteTrancient);
end;

procedure TVDigitalManipulation.LP_IIR_Chebyshev045p2(
  ToDeleteTrancient: boolean);
begin
  LP_IIR_Chebyshev([0.8001101,1.600220],
                  [-1.556269,-0.6441713],
                  0.9999999688,
                  50,ToDeleteTrancient);
end;

procedure TVDigitalManipulation.LP_IIR_Chebyshev045p6(
  ToDeleteTrancient: boolean);
begin
  LP_IIR_Chebyshev([0.4760635,2.856381,7.1400952,9.521270],
                  [-4.522403,-8.676844,-9.007512,-5.328429,-1.702543,-0.2303303],
                  0.9999438133,
                  50,ToDeleteTrancient);
end;

function TVDigitalManipulation.LP_Simple(i: word): double;
begin
 Result:=sin(Pi*fFreqFact*(i-(fNotOdd_N-1)/2.0))/(Pi*(i-(fNotOdd_N-1)/2.0));
end;

procedure TVDigitalManipulation.LP_UniformIIRfilter(
  const FrequencyFactor: double; ToDeleteTrancient: boolean);
 var x:double;
begin
 SetFreqFact(FrequencyFactor);
 if (fFreqFact=0) then Exit;
 if fFreqFact>0.5 then fFreqFact:=fFreqFact/2.0;
 x:=exp(-2*Pi*fFreqFact);
 SetLength(fA,1);
 SetLength(fB,1);
 fA[0]:=1-x;
 fB[0]:=x;

 fNorm:=1;
 if ToDeleteTrancient then
   fNtoDelete:=Ceil(3.0/exp(ln(fFreqFact)*0.85395));

 DigitalFiltr();
end;

procedure TVDigitalManipulation.LP_UniformIIRfilter4k(
  const FrequencyFactor: double; ToDeleteTrancient: boolean);
 var x:double;
begin
 SetFreqFact(FrequencyFactor);
 if (fFreqFact=0) then Exit;
 if fFreqFact>0.5 then fFreqFact:=fFreqFact/2.0;
 x:=exp(-2*Pi*fFreqFact);
 SetLength(fA,1);
 SetLength(fB,4);
 fA[0]:=Power((1-x),4);
 fB[0]:=4*x;
 fB[1]:=-6*x*x;
 fB[2]:=4*x*x*x;
 fB[3]:=-sqr(sqr(x));

 fNorm:=1;
 if ToDeleteTrancient then
   fNtoDelete:=Ceil(2.8/exp(ln(fFreqFact)*1.0163));
 DigitalFiltr();
end;

procedure TVDigitalManipulation.MovingAverageFilter(const Np: word;
  ToDeleteTrancient: boolean);
 var I: word;
begin
 if Np<2 then Exit;
 SetLength(fA,Np);
 SetLength(fB,0);
 for I := 0 to High(fA) do fA[i]:=1/Np;
 fNorm:=1;

 SetDeleteTrancientNumber(ToDeleteTrancient,Np);
 DigitalFiltr();
 if not(ToDeleteTrancient) then
  for I := 0 to Np - 2 do
    Y[i]:=Y[i]*Np/(i+1)
end;

function TVDigitalManipulation.NormForFIR: double;
 var i:byte;
     vec:TVDigitalManipulation;
begin
 vec:=TVDigitalManipulation.Create;
 Vec.SetLenVector(fNotOdd_N);
  for I := 0 to Vec.HighNumber do
    begin
    Vec.X[i]:=i;
    Vec.Y[i]:=1;
    end;
 vec.DigitalFiltr(fA,fB);
 Result:=Vec.Y[fNotOdd_N-1];
 vec.Free;
end;

procedure TVDigitalManipulation.SetDeleteTrancientNumber(
               ToDeleteTrancient: boolean; NtoDelete: word);
begin
 if ToDeleteTrancient then fNtoDelete:=NtoDelete
                      else fNtoDelete:=0;
end;

procedure TVDigitalManipulation.SetFreqFact(const FrequencyFactor: double);
begin
 fFreqFact:=DoubleTo01(FrequencyFactor);
end;

procedure TVDigitalManipulation.SetNotOdd_N(const NotOdd_N: byte);
begin
  if odd(NotOdd_N) then fNotOdd_N:=NotOdd_N+1
                   else fNotOdd_N:=NotOdd_N;
end;

end.
