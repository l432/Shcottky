unit OlegStatistic;

interface

uses OlegType, OlegMath, OlegVector;

type

TMetaMethod=(mmPSO, mmIPOPES, mmCHC, mmSSGA, mmSSBLX, mmSSArit, mmDEBin, mmDEExp, mmSaDE);

{Alpha - ����� ��������� (level of significance)
p-value - ��������� ��������� ������ �� � ���������� �� �����,
�� ������� H0 (��� ��, �� ������ ����) �����������}

Function NormalCDF(x:double;mu:double=0;sigma:double=1):double;
{������� �������� ��������� ��� ����������� ��������,
��������� ����, �� �������� �� �������� �� �����-���� x
mu - ������,
sigma^2 - ��������;
FCD - cumulative distribution function}

Function NormalCDF_AB(a,b:double;mu:double=0;sigma:double=1):double;
{��������� ����, �� �������� �� �������� a<x<=b ���
����������� �������� � ������� mu �� �������� sigma^2}

Function NormalPlim(z:double;mu:double=0;sigma:double=1):double;
{���������, �� ��������� �� ���������� �� ����� |z-mu|,
��� z>=mu Result=2*(1-NormalCDF(z,mu,sigma))
��� z<mu Result=2*NormalCDF((z,mu,sigma)
}

Function NormalPDF(x:double;mu:double=0;sigma:double=1):double;
{������� �������� ��������� ��� ����������� �������
(������� �����)
mu - ������,
sigma^2 - ��������;
PDF -  probability density function}


Function ChiSquaredPDF(x:double;k:word):double;
{������� �������� ��������� ��� ��-������� �������
x>=0,
k - ������� ������� �������}

Function ChiSquaredCDF(x:double;k:word):double;
{������� �������� ��������� ��� ��-������� �������,
��������� ����, �� �������� �� �������� �� �����-���� x,
x>=0,
k - ������� ������� �������, ��� k=1 �������� ����������,
���� �������� ���������, �� k>1}


Function FisherPDF(x:double;k1,k2:word):double;
{������� �������� ��������� ��� F-������� (������� Գ����),
x>=0,
k1, k2 - ������� ������� �������}

Function FisherCDF(x:double;k1,k2:word):double;
{������� �������� ��������� ��� F-�������,
��������� ����, �� �������� �� �������� �� �����-���� x,
x>=0,
k1, k2 - ������� ������� �������,
��� ���� ������� �������� ��������� k1>1, k2>1}

Function NchooseK(n,k:word):Int64;
{����������� ����������,
������� ������� �� k � n,
n!/k!(n-k)!}

Function BinomialProbKN(n,k:word;p:double):double;
{��������� ����� ��� k ������������� � n �����,
���� ���� ��� ������ ����������� �,
0<=p<=1}

Function BinomialPDF(n,k:word;p:double):double;
{������� �������� ��������� ��� ����������� �������,
k - ������� ������ �����������,
n - �������� ������� �����������, n>=k;
p - ��������� ����� ��� ������ �����������,0<p<1
}

Function BinomialCDF(n,k:word;p:double):double;
{������� �������� ��������� ��� ����������� �������,
��������� ����, �� ������ ����������� �� ����� k}

Function WinsNumber(A,B:TVector;ItIsError:boolean=True):word;
{������� ������� � A.Y �������� � B.Y,
��� ItIsError=True �������� ������ ����� ��������;
�� ���� A.X[i]=B.X[i], A.Count=B.Count,
������ ������� 0}

Function SignTestPvalue(A,B:TVector;ItIsError:boolean=True):double;

Function SignTestAbetterB(A,B:TVector;p:double=0.05;ItIsError:boolean=True):boolean;
{��������� ������� ����� ��� ��, �� � ����� ��� ������������ p-value,
0<p<1}

implementation

uses
  System.Math, Vcl.Dialogs, System.SysUtils;

Function NormalCDF(x,mu,sigma:double):double;
{������� �������� ��������� ��� ����������� ��������,
��������� ����, �� �������� �� �������� �� �����-���� x
mu - ������,
sigma^2 - ��������}
begin
  try
   Result:=0.5*(1+Erf((x-mu)/sqrt(2)/sigma))
  except
   Result:=ErResult;
  end;
end;

Function NormalCDF_AB(a,b:double;mu:double=0;sigma:double=1):double;
{��������� ����, �� �������� �� �������� a<x<=b ���
����������� �������� � ������� mu �� �������� sigma^2}
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
{������� �������� ��������� ��� ��-������� �������
k - ������� ������� �������}
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
{������� �������� ��������� ��� ��-������� �������,
��������� ����, �� �������� �� �������� �� �����-���� x
k - ������� ������� �������}
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
{������� �������� ��������� ��� F-������� (������� Գ����),
x>=0,
k1, k2 - ������� ������� �������}
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
{������� �������� ��������� ��� F-�������,
��������� ����, �� �������� �� �������� �� �����-���� x,
x>=0,
k1, k2 - ������� ������� �������,
��� ���� ������� �������� ��������� k1>1, k2>1}
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

Function WinsNumber(A,B:TVector;ItIsError:boolean=True):word;
{������� ������� � A.Y �������� � B.Y,
��� ItIsError=True �������� ������ ����� ��������;
�� ���� A.X[i]=B.X[i], A.Count=B.Count,
������ ������� 0}
 var WinsTemp:double;
     i:integer;
begin
  Result:=0;
  if A.Count<>B.Count  then Exit;
  WinsTemp:=0;
  for I := 0 to A.HighNumber do
   if IsEqual(A.X[i],B.X[i]) then
    begin
      if IsEqual(A.Y[i],B.Y[i]) then
                   begin
                    WinsTemp:=WinsTemp+0.5;
                    Continue;
                   end;
      if ItIsError and (A.Y[i]<B.Y[i]) then WinsTemp:=WinsTemp+1;
      if not(ItIsError) and (A.Y[i]>B.Y[i]) then WinsTemp:=WinsTemp+1;
//      showmessage(floattostr(A.Y[i])+' '+floattostr(B.Y[i])+' '+floattostr(WinsTemp));
    end                      else Exit;
   Result:=Floor(WinsTemp);
end;

Function SignTestPvalue(A,B:TVector;ItIsError:boolean):double;
 var Wins:word;
begin
  Wins:=WinsNumber(A,B,ItIsError);
//  Result:=2*(1-NormalCDF(Wins,A.Count/2.0,sqrt(A.Count)/2.0));
//  showmessage(floattostr(Wins)+' '+floattostr(A.Count/2.0)+' '+floattostr(A.Count));
  if Wins>A.Count/2.0 then Result:=2*(1-NormalCDF(Wins,A.Count/2.0,sqrt(A.Count)/2.0))
                      else Result:=1;
end;

Function SignTestAbetterB(A,B:TVector;p:double=0.05;ItIsError:boolean=True):boolean;
begin
  if (p<=0) or (p>=1) then
     begin
       Result:=False;
       Exit;
     end;
  Result:= (SignTestPvalue(A,B,ItIsError)<p);
end;

end.
