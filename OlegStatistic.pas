unit OlegStatistic;

interface

uses OlegType, OlegMath;


Function NormalCDF(x:double;mu:double=0;sigma:double=1):double;
{функція розподілу ймовірності для нормального розподілу,
ймовірність того, що величина має значення не більше-рівно x
mu - середнє,
sigma^2 - дисперсія;
FCD - cumulative distribution function}

Function NormalCDF_AB(a,b:double;mu:double=0;sigma:double=1):double;
{ймовірність того, що величина має значення a<x<=b при
нормальному розподілу з середнім mu та дисперсією sigma^2}

Function NormalPlim(z:double;mu:double=0;sigma:double=1):double;
{ймовірність, що відхилення від середнього не менші |z-mu|,
при z>=mu Result=2*(1-NormalCDF(z,mu,sigma))
при z<mu Result=2*NormalCDF((z,mu,sigma)
}

Function NormalPDF(x:double;mu:double=0;sigma:double=1):double;
{густина розподілу ймовірності при нормальному розподілі
(функція Гауса)
mu - середнє,
sigma^2 - дисперсія;
PDF -  probability density function}


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

Function NchooseK(n,k:word):Int64;
{Біноміальний коефіцієнт,
кількість виборок по k з n,
n!/k!(n-k)!}

Function BinomialProbKN(n,k:word;p:double):double;
{ймовірність успіху при k випробуваннях з n спроб,
якщо успіх при одному випробуванні р,
0<=p<=1}

Function BinomialPDF(n,k:word;p:double):double;
{густина розподілу ймовірності при біноміальному розподілі,
k - кількість вдалих випробувань,
n - загальна кількість випробувань, n>=k;
p - ймовірність успіху при одному випровуванні,0<p<1
}

Function BinomialCDF(n,k:word;p:double):double;
{функція розподілу ймовірності при біноміальному розподілі,
ймовірність того, що вдалих випробувань не більше k}



implementation

uses
  System.Math;

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

Function NormalPlim(z:double;mu:double=0;sigma:double=1):double;
begin
  if z>=mu then Result:=2*(1-NormalCDF(z,mu,sigma))
           else Result:=2*NormalCDF(z,mu,sigma)
end;

Function NormalPDF(x:double;mu:double=0;sigma:double=1):double;
begin
  try
   Result:=1/sigma/sqrt(2*Pi)*exp(-sqr((x-mu)/sigma)/2);
  except
   Result:=ErResult;
  end;
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

Function NchooseK(n,k:word):Int64;
begin
  if k>n then
    begin
      Result:=0;
      Exit;
    end;
  Result:=Round(Factorial(n)/Factorial(k)/Factorial(n-k));
end;

Function BinomialProbKN(n,k:word;p:double):double;
begin
  if (p<0)or(p>1)or(k>n) then
   begin
     Result:=0;
     Exit;
   end;
  Result:=Power(p,k)*Power((1-p),(n-k));
end;

Function BinomialPDF(n,k:word;p:double):double;
begin
  if (p<0)or(p>1)or(k>n) then
   begin
     Result:=ErResult;
     Exit;
   end;
  Result:=NchooseK(n,k)*BinomialProbKN(n,k,p);
end;

Function BinomialCDF(n,k:word;p:double):double;
 var i:word;
begin
 if (p<0)or(p>1)or(k>n) then
   begin
     Result:=ErResult;
     Exit;
   end;
 Result:=0;
 for I := 0 to k do
   Result:=Result+BinomialPDF(n,i,p);
end;

end.
