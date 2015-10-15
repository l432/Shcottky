unit OlegGraph;
interface
uses OlegType, OlegMath, SysUtils, Dialogs, Classes, Series,
     Forms,Controls,WinProcs,OlegMaterialSamples;


Procedure Read_File (sfile:string; var a:PVector);
{���� ��� � ����� � �������� ��'�� sfile �
����� a, � ����� comments � �� ���� ��������
��������� �������� ����������� � a.T}

Procedure Write_File(sfile:string; A:PVector);
{������ � ���� � ������ sfile ��� � ������ �;
���� A^.n=0, �� ����� � ���� �� ����������}

Procedure Write_File_Series(sfile:string; Series:TLineSeries);overload;
{������ � ���� � ������ sfile ��� � Series;
���� ������� ����� ������� ��� Series �� ��������,�� ����� � ���� �� ����������}

Procedure Write_File_Series(sfile:string; Series:TPointSeries);overload;
{������ � ���� � ������ sfile ��� � Series;
���� ������� ����� ������� ��� Series �� ��������,�� ����� � ���� �� ����������}

Procedure Sorting (var A:PVector);
{��������� ���������� (������� ���������)
����� � ����� � �� ��������� ���������� �^.�}

Procedure IVchar(a:Pvector; var b:Pvector);
{�������� ���� � � � b}

Procedure LogX(A:Pvector; var B:Pvector);
{������ � A � B ����� � �����, ��� ����
���������� � ����� ����}

Procedure LogY(A:Pvector; var B:Pvector);
{������ � A � B ����� � �����, ��� ����
���������� Y ����� ����}

Procedure ForwardIV(A:Pvector; var B:Pvector);
{������ � A � B ����� � �����, �� ����������
����� ������ ��� (��� ���� ���������� X ����� ����)}

Procedure ReverseIV(A:Pvector; var B:Pvector);
{������ � A � B ����� � �����, �� ����������
�������� ������ ��� (��� ���� ���������� X ����� ����),
������� ������ ������ ���������}

Procedure PidgFun(A:Pvector; var B:Pvector);
{��������� ��������� �� �������� �������� �������;
������� ������� B^.N_begin �� B^.N_end, ���
���� � ������ � �������� �>0.01 �� Y>0,
���������� �������� B^.n �� ������ ������ B^.X �� B^.Y;
���� ���������� ������ � �� ����������}

Procedure ChungFun(A:Pvector; var B:Pvector);
{������ � B Chung-�������, ���������� �� ����� � �}

Procedure WernerFun(A:Pvector; var B:Pvector);
{������ � B ������� �������, ���������� �� ����� � �}

Procedure MikhAlpha_Fun(A:Pvector; var B:Pvector);
{������ � B �����-������� (����� ̳�������),
���������� �� ����� � �,
Alpha=d(ln I)/d(ln V)}

Procedure MikhBetta_Fun(A:Pvector; var B:Pvector);
{������ � B �����-������� (����� ̳�������),
���������� �� ����� � �,
Betta = d(ln Alpha)/d(ln V)
P.S. � ����� �� ������� ���������� �����}

Procedure MikhN_Fun(A:Pvector; var B:Pvector);
{������ � B ��������� ������� ����������� ��
���������� �������, ���������� �� �������
����� ̳�������, �� ������ ������ �;
n = q V (Alpha - 1) [1 + Betta/(Alpha-1)] / k T Alpha^2}

Procedure MikhRs_Fun(A:Pvector; var B:Pvector);
{������ � B ��������� ����������� ����� ��
���������� �������, ���������� �� �������
����� ̳�������, �� ������ ������ �;
Rs = V (1- Betta) / I Alpha^2}

Procedure HFun(A:Pvector; var B:Pvector; DD:TDiodSample; N:double);
{������ � B H-�������, ���������� �� ����� � �:
DD - ���, N - ������ �����������}

Procedure NordeFun(A:Pvector; var B:Pvector;
                    DD:TDiodSample; Gam:double);
{������ � B ������� �����, ���������� �� ����� � �;
AA - ����� г��������, Szr - ����� ��������,
Gam - �������� ����� (��� �������)}

Procedure CibilsFunDod(A:Pvector; var B:Pvector; Va:double);
{������ � B ������� F(V)=V-Va*ln(I), ���������� �� ����� � �}

Procedure CibilsFun(A:Pvector; D:TDiapazon; var B:Pvector);
{������ � B ������� ѳ����, ���������� �� ����� � �;
������� ���� ������� �� kT �� ��� �������,
��� ���� ������� F(V)=V-Va*ln(I) �� �� �����,
���� - 0.001}

Procedure LeeFunDod(A:Pvector; var B:Pvector; Va:double);
{������ � B ������� F(I)=V-Va*ln(I), ���������� �� ����� � �}

Procedure LeeFun(A:Pvector; D:TDiapazon; var B:Pvector);
{������ � B ������� Lee, ���������� �� ����� � �;
������� ���� ������� �� kT �� ��������� ����������
����������� �������� ������� � ������� ���;
���� - 0.02;
� ��� B^.T ����������� �� �����������,
� �������� � ������������ �������� �+B*x+C*ln(x);
�� ��������� ��������� �� �������� Va �
��������������� � ������� LeeKalk ���
���������� ������ ���'���; ��� ����� ������������� ������ :)}

Procedure ForwardIVwithRs(A:Pvector; var B:Pvector; Rs:double);
{������ � � ����� ������ ��� � � �
����������� �������� ����������� ����� Rs}

Procedure Forward2Exp(A:Pvector; var B:Pvector; Rs:double);
{������ � � ��������� ��������
I/[1-exp(-qV/kT)] �� ������� �
����������� �������� ����������� ����� Rs
��� ����� ������ � �}

Procedure Reverse2Exp(A:Pvector; var B:Pvector; Rs:double);
{������ � � ��������� ��������
I/[1-exp(-qV/kT)] �� ������� �
����������� �������� ����������� ����� Rs
��� ��������� ������ � �}

Procedure N_V_Fun(A:Pvector; var B:Pvector; Rs:double);
{������ � � ��������� ����������� �����������
�� ������� �������������� ����� n=q/kT* d(V)/d(lnI);
��������� I=I(V), ��� ����������� � �, ��������
������������ � ����������� �������� ����������� ����� Rs}

Procedure M_V_Fun(A:Pvector; var B:Pvector; Bool:boolean; fun:word);
{�� ����� � ������ � ���� ������� ������� �� �������� fun:
fun=1 - ��������� ����������� m=d(ln I)/d(ln V) �� �������
(��� ������� ����  I=const*V^m);
2 - ������� �������-��������� ��� ���������� �������
    ln(I/V^2)=f(1/V);
3 - ������� �������-��������� ��� ����������� �����������
    ln(I/V)=f(1/V^0.5);
4 - ������� ������� ��� ���������� �������
    ln(I/V)=f(1/V);
5 - ������� ������� ��� ����������� �����������
    ln(I/V^0.5)=f(1/V^0.5);
6 - ������� ��������-���� ��� ���������� �������
    ln(I/V)=f(V^0.5);
7 - ������� ��������-���� ��� ����������� �����������
    ln(I/V^0.5)=f(1/V^0.25);
���� Bool=true, �� �������� ��������� ��� ����� ����,
���� Bool=false - ��� ���������}



Procedure Nss_Fun(A:Pvector; var B:Pvector;
           Fb,Rs:double; DD:TDiodSample; D:TDiapazon; nV:boolean);
{������ � � ��������� ������� �����
Nss=ep*ep0*(n-1)/q*del �� ������ ��-Ess=(Fb-V/n),
[Nss] = ��-1 ��-2; [Ec-Ess] = ��;
n - ������ �����������,
nV - ���� ���� ������� ����������� n
     true - �� ��������� �������
     (��� ��������� �������);
     false - �� ������� ̳�������
�� - ����������� ���������� �������������
��0 - ����������� �����
del - ������� ������������� ����
Fb - ������ ���'��� �����
Rs - �������� ����������� �����}

Procedure Dit_Fun(A:Pvector; var B:Pvector;
                  Rs:double;DD:TDiodSample; D:TDiapazon);
{������ � � ��������� ������� �����,
��������� �� ������� �������,
Dit=ep*ep0/(q^2*del)*d(Vcal-Vexp)/dVs
�� ������ ��-Ess=(Fb-qVs),
[Dit] = ��-1 ��-2; [Ec-Ess] = ��;
�� - ����������� ���������� ����������
��0 - ����������� �����
del - ������� ������������� ����
Rs - �������� ����������� �����
Vcal �� Vexp - ����������� �� �������
�������� ������� ��� ��������� ��������� ������;
Vcal=Vs+del*[Sqrt(2q*Nd*eps/eps0) (Sqrt(Fb/q)-Sqrt(Fb/q-Vs))]
Vexp=V-IRs
e� - ����������� ���������� �������������
Fb - ������ ���'��� �����
Nd - ������������ ������ � �������������;
Vs - ������ ������� �� ��� �������������
Vs=Fb/q-kT/q*ln(Szr*AA*T^2/I);
AA - ����� г��������
Szr - ����� ��������
}


Procedure IvanovAprox (V:PVector; DD:TDiodSample;
                       var del,Fb:double;
                       OutsideTemperature:double=ErResult);
{������������ ����� � ������ V ������������� ���������
I=Szr AA T^2 exp(-Fb/kT) exp(qVs/kT)
V=Vs+del*[Sqrt(2q Nd ep / eps0) (Sqrt(Fb/q)-Sqrt(Fb/q-Vs))]
��
AA - ����� г��������
Szr - ����� ��������
Fb - ������ ���'��� �����
Vs - ������ ������� �� ��� �������������
     (�������� ���������)
del - ������� ������������� ����
(���� ������ - ������� ����, ������� ��
�������� ������� ����������� ���������� ����)
Nd - ������������ ������ � �������������;
e� - ����������� ���������� �������������
��0 - ����������� �����
����������� �������� del �� Fb
}

Procedure A_B_Diapazon(Avuh,A:Pvector;
                      var B:Pvector; D:TDiapazon;
                      YminDontUsed:boolean=False);overload;
{������ � � � ����� � ������� �, �������
�� ���� ����� � ������ Avuh (���������) �������������
������ D; ��������, �� ��� ������� �
����� ���� ������� �^.N_begin �� �^.N_end (���� � �����);
B^.N_begin, B^.N_end �� ��������������
���� YminDontUsed=True, �� ���������
�� Ymin �� ���������������� - �������
��� ������ ��� ��������� ��������
}

Procedure A_B_Diapazon(A:Pvector; var B:Pvector;
                  D:TDiapazon;YminDontUsed:boolean=False);overload;
{������ � � � ����� � ������� �, ��
������������� ������ D;
B^.N_begin, B^.N_end �� ��������������
���� YminDontUsed=True, �� ���������
�� Ymin �� ���������������� - �������
��� ������ ��� ��������� ��������}


Procedure Kam1_Fun (A:Pvector; var B:Pvector; D:TDiapazon);
{������ � B ������� ������ ������� ����
���������� �� � ����� ������� �, �� �������������
����� D}

Procedure Kam2_Fun (A:Pvector; var B:Pvector; D:TDiapazon);
{������ � B ������� ������ ������� ����
���������� �� � ����� ������� �, �� �������������
����� D}

Procedure Gr1_Fun (A:Pvector; var B:Pvector);
{������ � B ������� ������� ������� ����
���������� �� ����� ������� �}

Procedure Gr2_Fun (A:Pvector; var B:Pvector; DD:TDiodSample);
{������ � B ������� ������� ������� ����
���������� �� ����� ������� �}

Procedure LimitFun(A, A1:Pvector; var B:Pvector; Lim:Limits);
{������ � � � � ����� � �����, ��� ����
� ����� �1 ����������� �����, ���������� � Lim}

Function PoinValide(Dp:TDiapazon;
                   Original, Secondary:Pvector;
                   k:integer; YminDontUsed:boolean=False): boolean;
{�������, �� ������������ ���������� �����
������� Original, ��� ������� k-�� �����
������� Secondary, ������, ��������� � ����� Dp;
��� YminDontUsed=True �� ������������ ����� ��� Ymin -
������� ��� ������ ��� ��������� ��������}

Procedure ChungKalk(A:PVector; D:TDiapazon; var Rs:double; var n:double);
{�� ����� ����� � ������� � ������ �������� ��
����� ������������ ������� ����� (� �����������
��������, �������� � D), ������� ��������
����������� ����� Rs �� ����������� ����������� n}

Procedure WernerKalk(A:PVector; var D:TDiapazon; var Rs:double; var n:double);
{�� ����� ����� � ������� � ������ �������� ��
����� ������������ ������� ������� (� �����������
��������, �������� � D), ������� ��������
����������� ����� Rs �� ����������� ����������� n}

Procedure MikhKalk(A:PVector; D:TDiapazon; DD:TDiodSample;
                   var Rs:double; var n:double; var I0:double; var Fb:double);
{�� ����� ����� � ������� � �� ���������
������ ̳������� ������������ ��������
����������� ����� Rs, ����������� ����������� n,
������ ���'��� Fb �� ������ ��������� �0;
���� ����������� �� ������, �� �����������
���� Rs �� I0, ���� ������� ������������ �������� ErResult;
���� ��������� ���������� ������� �������,
�� � �� �������� ErResult;
AA - ����� г��������,
Szr - ����� ��������}

Procedure HFunKalk(A:Pvector; D:TDiapazon; DD:TDiodSample; N:double;
                   var Rs:double; var Fb:double);
{�� ����� ����� � ������� � ������ �������� ��
����� ������������ H-������� (� �����������
��������, �������� � D), ������� ��������
����������� ����� Rs �� ������ ���'��� Fb;
��� �������� �-������� ������
N - ������ �����������}

Procedure ExKalk(Index:integer; A:Pvector; D:TDiapazon;
                 Rs:double; DD:TDiodSample;
                 var n:double; var I0:double; var Fb:double);overload;
{�� ����� ����� � ������� � ������
����� ������������ ��� � �����������������
������� (� �����������
��������, �������� � D), ������� ��������
����������� ����������� n,
������ ��������� �0
������ ���'��� Fb;
��������, �� ������������ �� �������� I=I0exp(V/nkT)
Index ����� �� ���� �������������:
1 - �������� ��������� ������ �
2 - �������� I/[1-exp(-qV/kT)] ��� ����� ����
3 - �������� I/[1-exp(-qV/kT)] ��� ��������� ����
��� �������� ��� ��������
Rs - ���������� ���,
��� ���������� Fb
AA - ����� г��������,
Szr - ����� ��������}

Procedure ExKalk_nconst(Index:integer; A:Pvector; D:TDiapazon;
                 DD:TDiodSample; Rs, n:double;
                 var I0:double; var Fb:double);overload;
{�� ����� ����� � ������� � ������
����� ������������ ��� � �����������������
������� (� �����������
��������, �������� � D),
�� �������� ����������� ����������� n
������� ��������
������ ��������� �0
������ ���'��� Fb;
��������, �� ������������ �� �������� I=I0exp(V/nkT)
Index ����� �� ���� �������������:
1 - �������� ��������� ������ �
2 - �������� I/[1-exp(-qV/kT)] ��� ����� ����
3 - �������� I/[1-exp(-qV/kT)] ��� ��������� ����
��� �������� ��� ��������
Rs - ���������� ���,
��� ���������� Fb
AA - ����� г��������,
Szr - ����� ��������}


Procedure ExKalk(A:Pvector; DD:TDiodSample;
                 var n:double; var I0:double; var Fb:double;
                 OutsideTemperature:double=ErResult);overload;
{�� ����� ����� � ������� � ������
����� ������������ ��� � �����������������
�������, ������� ��������
����������� ����������� n,
������ ��������� �0
������ ���'��� Fb;
��������, �� ������������ �� �������� I=I0exp(V/nkT)
��� ���������� Fb ������
AA - ����� г��������,
Szr - ����� ��������}

Procedure ExpKalk(A:Pvector; D:TDiapazon; Rs:double;
                 DD:TDiodSample; Xp:IRE;
                 var n:double; var I0:double; var Fb:double);
{�� ����� ����� � ������� � ������
������������ ��� �� �������� I=I0(exp(V/nkT)-1)+V/R
(� ����������� ��������, �������� � D), ������� ��������
����������� ����������� n,
������ ��������� �0
������ ���'��� Fb;
��� �������� ��� ��������
Rs - ���������� ���,
��   - ������ ���������� ���������
��� ���������� Fb
AA - ����� г��������,
Szr - ����� ��������}

Procedure NordDodat(A:Pvector; D:TDiapazon; DD:TDiodSample; Gamma:double;
                   var V0:double; var I0:double; var F0:double);
{�� ����� ����� � ������� � (� ����������
�������� � D) ���� ������� ����� �� �������
���������� �� ������ V0, ��������
�������� ���� ������� F0 �� �������� ������ �0,
��� ������� V0 � �������� �����}

Procedure NordKalk(A:Pvector; D:TDiapazon; DD:TDiodSample; Gamma:double; {Gamma:word;}
                   n:double; var Rs:double; var Fb:double);
{�� ����� ����� � ������� � ������ ��������
������� ����� (� �����������
��������, �������� � D), ������� ��������
����������� ����� Rs �� ������ ���'��� Fb;
��� �������� ������� ����� ������
AA - ����� г��������,
Szr - ����� ��������,
Gamma - �������� ����� (��� �������)
��� ���������� Rs
n - �������� ����������}

Procedure CibilsKalk(const A:Pvector; const D:TDiapazon;
                     out Rs:double; out n:double);
{�� ����� ����� � ������� � ������ ��������
������� ѳ����, ������� ��������
����������� ����� Rs ��
��������� ���������� n}

Procedure IvanovKalk(A:Pvector; D:TDiapazon; Rs:double; DD:TDiodSample;
                     var del:double; var Fb:double);
{�� ����� ����� � ������� � (� �����������
��������, �������� � D), �� ������� �������
������� �������� ������� ������������� ���� del
(���� ������ - ������� ����, ������� ��
�������� ������� ����������� ���������� ����)
�� ������ ���'��� Fb;
AA - ����� г��������
Szr - ����� ��������
Nd - ������������ ������ � �������������;
e� - ����������� ���������� �������������
Rs - ���������� ���, ������������ ������� ���������
��� ���, ���������� � ����������� Rs
}


Procedure Kam1Kalk (A:Pvector; D:TDiapazon; var Rs:double; var n:double);
{�� ����� ����� � ������� � ������ ��������
������� ������� (� �����������
��������, �������� � D), ������� ��������
����������� ����� Rs �� ����������� ����������� n}

Procedure Kam2Kalk (const A:Pvector; const D:TDiapazon; out Rs:double; out n:double);
{�� ����� ����� � ������� � ������ ��������
������� ������� (� �����������
��������, �������� � D), ������� ��������
����������� ����� Rs �� ����������� ����������� n}

Procedure Gr1Kalk (A:Pvector; D:TDiapazon; DD:TDiodSample;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{�� ����� ����� � ������� � (� �����������
��������, �������� � D) ������� �������
������� ���� ������������ ��������
����������� ����� Rs, ����������� ����������� n,
������ ���'��� Fb �� ������ ��������� �0;
���� ����������� �� ������, �� �����������
���� Rs, ���� ������� ������������ �������� ErResult;
���� ��������� ���������� ������� �������,
�� � Rs=ErResult}

Procedure Gr2Kalk (A:Pvector; D:TDiapazon; DD:TDiodSample;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{�� ����� ����� � ������� � (� �����������
��������, �������� � D) ������� �������
������� ���� ������������ ��������
����������� ����� Rs, ����������� ����������� n,
������ ���'��� Fb �� ������ ��������� �0;
���� ����������� �� ������, �� �����������
���� Rs, ���� ������� ������������ �������� ErResult;
���� ��������� ���������� ������� �������,
�� � Rs=ErResult}

Procedure BohlinKalk(A:Pvector; D:TDiapazon; DD:TDiodSample; Gamma1,Gamma2:double;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{�� ����� ����� � ������� � (� �����������
��������, �������� � D), �� ���������
������ ������ ������������ ��������
����������� ����� Rs, �������
����������� n �� ������ ���'��� Fb
(� ����� ������ ��������� �0;
��� �������� ������� ����� ������
AA - ����� г��������,
Szr - ����� ��������,
Gamma - �������� �����,
����� �������� ����� ������ ��������
�� �� ������� ����� �� Gamma}

Procedure LeeKalk (A:Pvector; D:TDiapazon; DD:TDiodSample;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{�� ����� ����� � ������� � (� �����������
��������, �������� � D) ������� ��������
������� ˳ ������������ ��������
����������� ����� Rs, ����������� ����������� n,
������ ���'��� Fb �� ������ ��������� �0;
���� ����������� �� ������, �� �����������
���� Rs, ���� ������� ������������ �������� ErResult;
���� ��������� ���������� ������� ˳,
�� � Rs=ErResult}

Function Y_X0 (X1,Y1,X2,Y2,X3:double):double;
{��������� �������� ����� � �������� �3,
��� ����������� �� ������� (�1,Y1) �� (X2,Y2) -
����� ������������ �� ���� ������}

Function X_Y0 (X1,Y1,X2,Y2,Y3:double):double;
{��������� ������� ����� � ��������� Y3,
��� ����������� �� ������� (�1,Y1) �� (X2,Y2) -
����� ������������ �� ���� ������}

function ChisloY (A:Pvector; X:double):double;
{������� ��������� �������� ����� �
�������� � ��� �������, ���� �� �����
������� � �� ������������� ���������,
�������� � �;
���� � �� �������� �������� ����
������ ������� �, �� ����������� ErResult}

function ChisloX (A:Pvector; Y:double):double;
{������� ��������� ������� ����� �
��������� Y ��� �������, ���� �� �����
������� � �� ������������� ���������,
�������� � �;
���� Y �� �������� �������� ����
������� ������� �, �� ����������� ErResult}

function Krect(A:Pvector; V:double):double;
{���������� ����������� �����������
�� ������ � ������ � ��� ������ V;
���� ����� � ��������� ������� ���� -
�������� ����������� � ����������� ErResult}

function IscCalc(A:Pvector):double;
{������������ ����� ��������� ���������
�� ������ � ������ �}

function VocCalc(A:Pvector):double;
{������������ ������� ��������� ����
�� ������ � ������ �}

Function Extrem (A:PVector):double;
{��������� ������� ���������� �������,
�� ����������� � �;
����������, �� ��������� ����;
���� ���������� ���� - ����������� ErResult;
���� ��������� �� ������ - ������� ������
�������� :-)}

Procedure GraphFill(Series:TLineSeries;Func:TFunSingle;
                    x1,x2:double;Npoint:word);overload;
{�������� Series ���������� Func(�) � �������
�� �1 �� �2 � ��������� ������� ����� Npoint+1}

Procedure GraphFill(Series:TLineSeries;Func:TFunDouble;
                    x1,x2:double;Npoint:word;y0:double);overload;
{�������� Series ���������� Func(�,y0) � �������
�� �1 �� �2 � ��������� ������� ����� Npoint+1}

Procedure VectorToGraph(A:PVector;Series:TLineSeries);
{�������� ��� � � � Series}

Procedure GraphToVector(Series:TLineSeries;A:PVector);
{�������� ��� � Series � A, ������������ ���� ������ � �� Y ���������}

Procedure GraphAverage (Lines: array of TLineSeries; delX:double=0.002;
                         NumLines:integer=0; shiftX:double=0.002);
{��������� ������, �� �����������
� ������� ������ � �������  NumLines,
�� ������� �� �������� shiftX;
����  NumLines=0, �� ����� �� ����������;
���� �����
� �������� ������� ������ �������
������ ����������� �������,
�� ����������� � �����;
���������� ��������� ������� ������ ����� ���
�������;
���� �� ��������� ������ ����� - delX}


Function Voc_Isc_Pm(mode:byte;Vec:PVector;n,Rs,I0,Rsh,Iph:double):double;
{������������ Voc (��� mode=1),
Isc (��� mode=2) �� �����������
������� ��������� (��� mode=3) �� ������ ��������
n, Rs, I0, Rsh, Iph ��� ������� � Vec.
��������������� ����� ������쳿
��� ����'���� �������
I0*[exp(qVoc/nkT)-1]+Voc/Rsh-Iph=0
���
I0*[exp(qRsIsc/nkT)-1]+RsIsc/Rsh-Iph+Isc=0.
FF ������������ �� ����� ������������ ���
�������� ��������
I=V/Rs-Rsh(RsIph+RsI0+V)/Rs/(Rs+Rsh)+
  nkT/q/Rs*Lambert(qRsI0Rsh/((Rs+Rsh)nkT)exp(Rsh(RsIph+RsI0+V)/(nkT(Rs+Rsh)))
a ����, ������� ������쳿 ����������� ��������� ������� Pm=I*V
� ������������ ���� ������������ ��������
}

Function Voc_Isc_Pm_DoubleDiod(mode:byte;E1,E2,Rs,I01,I02,Rsh,Iph:double):double;

{������������ Voc (��� mode=1),
Isc (��� mode=2) �� �����������
������� ��������� (��� mode=3) �� ������ ���������
�1, �2, Rs, I01, I02, Rsh, Iph, ��������, ��  ���
�� ����������� ����� ������������.
��������������� ����� ������쳿
��� ����'���� �������
I01*[exp(qVoc/�1)-1]+I02*[exp(qVoc/�2)-1]+Voc/Rsh-Iph=0
���
I01*[exp(qRsIsc/�1)-1]+I02*[exp(qRsIsc/�2)-1]+RsIsc/Rsh-Iph+Isc=0.
}

Procedure DataFileWrite(fname:string;Vax:PVector;Param:TArrSingle);

implementation

Procedure Read_File (sfile:string; var a:Pvector);
var F:TextFile;
    i:integer;
    ss, ss1:string;

begin
   a^.name:=sfile;
 {--------���������� ����������� �����------------}
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
 {---------���������� ������--------}
   Reset(f);
   for i := 0 to High (a^.X) do
      readln(f,a^.x[i],a^.y[i]);
   CloseFile(f);

 {-------���������� ����������� � ������� ��������, ���� �����
 ��mments ��� ��� ��� ����������� ������
 ��� ��������������� ����, �� �������� ����� �������}
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
{������ � ���� � ������ sfile ��� � ������ �;
���� A^.n=0, �� ����� � ���� �� ����������}
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
{������ � ���� � ������ sfile ��� � Series;
���� ������� ����� ������� ��� Series �� ��������,�� ����� � ���� �� ����������}
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
{������ � ���� � ������ sfile ��� � Series;
���� ������� ����� ������� ��� Series �� ��������,�� ����� � ���� �� ����������}
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
{��������� ���������� (������� ���������)
����� � ����� � �� ��������� ���������� �^.�}
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
 {�������� ���� � � � b}
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
{������ � A � B ����� � �����, ��� ����
���������� � ����� ����}

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
{������ � A � B ����� � �����, ��� ����
���������� Y ����� ����}

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
{������ � A � B ����� � �����, �� ����������
����� ������ ��� (��� ���� ���������� X ����� ����)}
begin
  LogX(A,B);
end;

Procedure ReverseIV(A:Pvector; var B:Pvector);
{������ � A � B ����� � �����, �� ����������
�������� ������ ��� (��� ���� ���������� X ����� ����),
������� ������ ������ ���������}
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
{��������� ��������� �� �������� �������� �������;
������� ������� B^.N_begin �� B^.N_end, ���
���� � ������ � �������� �>0.001 �� Y>0,
���������� �������� B^.n �� ������ ������ B^.X �� B^.Y;
���� ���������� ������ � �� ����������}
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
{������ � B Chung-�������, ���������� �� ����� � �}
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
{������ � B ������� �������, ���������� �� ����� � �}
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
{������ � B �����-������� (����� ̳�������),
���������� �� ����� � �,
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
{� temp ������� ln I = f(ln V)}

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
{������ � B �����-������� (����� ̳�������),
���������� �� ����� � �,
Betta = d(ln Alpha)/d(ln V)
P.S. � ����� �� ������� ���������� �����}
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
{� temp ������� ln Aipha = f(ln V)}
for I := 0 to High (B^.X) do B^.Y[i]:=Poh(temp,i);
Smoothing(B,temp);
Smoothing(temp,B);
dispose(temp);
end;

Procedure MikhN_Fun(A:Pvector; var B:Pvector);
{������ � B ��������� ������� ����������� ��
���������� �������, ���������� �� �������
����� ̳�������, �� ������ ������ �;
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
{������ � B ��������� ����������� ����� ��
���������� �������, ���������� �� �������
����� ̳�������, �� ������ ������ �;
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


Procedure HFun(A:Pvector; var B:Pvector; DD:TDiodSample; N:double);
{������ � B H-�������, ���������� �� ����� � �:
DD - ���, N - ������ �����������}
 var i:word;
begin
B^.n:=0;
if n=ErResult then Exit;
if A^.T<=0 then Exit;
PidgFun(A,B);
if B^.n=0 then Exit;

  for I := 0 to High (B^.X) do
   begin
     B^.X[i]:=A^.Y[i+B^.N_begin];
     B^.Y[i]:=A^.X[i+B^.N_begin]+N*DD.Fb(B^.T,A^.Y[i+B^.N_begin]);
   end;

  B^.N_begin:=B^.N_begin+A^.N_begin;
  B^.N_end:=B^.N_end+A^.N_begin;
end;

Procedure NordeFun(A:Pvector; var B:Pvector;
                   DD:TDiodSample; Gam:double);
{������ � B ������� �����, ���������� �� ����� � �;
AA - ����� г��������, Szr - ����� ��������,
Gam - �������� ����� (��� �������)}
 var i:word;
begin
B^.n:=0;
if A^.T<=0 then Exit;
PidgFun(A,B);


if B^.n=0 then Exit;

  for I := 0 to High (B^.X) do
   begin
     B^.X[i]:=A^.X[i+B^.N_begin];
     B^.Y[i]:=A^.X[i+B^.N_begin]/Gam+DD.Fb(B^.T,A^.Y[i+B^.N_begin]);
//     B^.Y[i]:=A^.X[i+B^.N_begin]/Gam-Kb*B^.T*ln(A^.Y[i+B^.N_begin]/DD.Area/DD.Material.Arich/sqr(B^.T));
   end;

  B^.N_begin:=B^.N_begin+A^.N_begin;
  B^.N_end:=B^.N_end+A^.N_begin;

end;

Procedure CibilsFunDod(A:Pvector; var B:Pvector; Va:double);
{������ � B ������� F(V)=V-Va*ln(I), ���������� �� ����� � �}
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

Procedure CibilsFun(A:Pvector; D:TDiapazon; var B:Pvector);
{������ � B ������� ѳ����, ���������� �� ����� � �
(� ����������� ���� D);
������� ���� ������� �� kT �� ��� �������,
��� ���� ������� F(V)=V-Va*ln(I) �� �� �����,
���� - 0.001}
//const Np=15;//������� ����� � ������������ �������;
//������� �� ������ �������� ���� ���� Va ���������� ���������
var Va:double;
    temp,temp2:PVector;
begin
B^.n:=0;
Va:=round(1000*(Kb*A^.T+0.004))/1000;
if Va<0.01 then Va:=0.015;
new(temp);
new(temp2);

repeat
CibilsFunDod(A,temp,Va);
{� temp ������� F(V)=V-Va*ln(I), ����������
�� ��� [�������] ��������� � ������� �}
if temp.n=0 then Break;

A_B_Diapazon(A,temp,temp2,D);
if temp2^.n=0 then
          begin
           dispose(temp);dispose(temp2);Exit;
          end;

{� temp2 - ������� ������� F(V)=V-Va*ln(I), ���
����������� ������ � D}


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


if B^.n<2 then B^.n:=0;

dispose(temp2);
dispose(temp);
end;


Procedure LeeFunDod(A:Pvector; var B:Pvector; Va:double);
{������ � B ������� F(I)=V-Va*ln(I), ���������� �� ����� � �}
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

Procedure LeeFun(A:Pvector; D:TDiapazon; var B:Pvector);
{������ � B ������� Lee, ���������� �� ����� � �;
������� ���� ������� �� kT �� ��������� ����������
����������� �������� ������� � ������� ���;
���� - 0.02;
� ��� B^.T ����������� �� �����������,
� �������� � ������������ �������� �+B*x+C*ln(x);
�� ��������� ��������� �� �������� Va �
��������������� � ������� LeeKalk ���
���������� ������ ���'���; ��� ����� ������������� ������ :)}
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
{� temp ������� F(I)=V-Va*ln(I), ����������
�� ��� [�������] ��������� � ������� �}
if temp.n=0 then Break;

A_B_Diapazon(A,temp,temp2,D);
if temp2^.n=0 then
          begin
           dispose(temp);dispose(temp2);Exit;
          end;
{� temp2 - ������� ������� F(I)=V-Va*ln(I), ���
����������� ������ � D}
if temp2.n<3 then Break;

GromovAprox (temp2,AA,BB,CC);
if AA=ErResult then Break;

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
{������ � � ����� ������ ��� � � �
����������� �������� ����������� ����� Rs}
var i,j:integer;
     temp:double;
begin
 B^.n:=0;
 if Rs=ErResult then Exit;

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
{������ � � ��������� ��������
I/[1-exp(-qV/kT)] �� ������� �
����������� �������� ����������� ����� Rs
��� ����� ������� �}
var i:integer;
begin
 B^.n:=0;
 if (Rs=ErResult) or (A^.T<=0) then Exit;
 ForwardIVwithRs(A,B,Rs);
 for i:=0 to High(B^.X) do
   B^.Y[i]:=B^.Y[i]/(1-exp(-B^.X[i]/Kb/A^.T));
end;

Procedure Reverse2Exp(A:Pvector; var B:Pvector; Rs:double);
{������ � � ��������� ��������
I/[1-exp(-qV/kT)] �� ������� �
����������� �������� ����������� ����� Rs
��� ����� ��������� � �}
var i:integer;
     temp:PVector;
begin
 B^.n:=0;
 if (Rs=ErResult) or (A^.T<=0) then Exit;
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
{������ � � ��������� ����������� �����������
�� ������� �������������� ����� n=q/kT* d(V)/d(lnI);
��������� I=I(V), ��� ����������� � �, ��������
������������ � ����������� �������� ����������� ����� Rs}
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
{� temp ��������� V=f(ln(I)) � ����������� Rs}

for I := 0 to High(B^.X) do
 begin
  B^.X[i]:=temp^.Y[i];
  B^.Y[i]:=Poh(temp,i)/Kb/A^.T;
 end;
{�����������}
Smoothing (B,temp);
Median (temp,B);
dispose(temp);
end;

Procedure M_V_Fun(A:Pvector; var B:Pvector; Bool:boolean; fun:word);
{�� ����� � ������ � ���� ������� ������� �� �������� fun:
fun=1 - ��������� ����������� m=d(ln I)/d(ln V) �� �������
(��� ������� ����  I=const*V^m);
2 - ������� �������-��������� ��� ���������� �������
    ln(I/V^2)=f(1/V);
3 - ������� �������-��������� ��� ����������� �����������
    ln(I/V)=f(1/V^0.5);
4 - ������� ������� ��� ���������� �������
    ln(I/V)=f(1/V);
5 - ������� ������� ��� ����������� �����������
    ln(I/V^0.5)=f(1/V^0.5);
6 - ������� ��������-���� ��� ���������� �������
    ln(I/V)=f(V^0.5);
7 - ������� ��������-���� ��� ����������� �����������
    ln(I/V^0.5)=f(V^0.25);
���� Bool=true, �� �������� ��������� ��� ����� ����,
���� Bool=false - ��� ���������}
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
           Fb,Rs:double; DD:TDiodSample; D:TDiapazon; nV:boolean);
{������ � � ��������� ������� �����
Nss=ep*ep0*(n-1)/q*del �� ������ ��-Ess=(Fb-V/n),
[Nss] = ��-1 ��-2; [Ec-Ess] = ��;
n - ������ �����������,
nV - ���� ���� ������� ����������� n
     true - �� ��������� �������
     (��� ��������� �������);
     false - �� ������� ̳�������
�� - ����������� ���������� �������������
��0 - ����������� �����
del - ������� ������������� ����
Fb - ������ ���'��� �����
Rs - �������� ����������� �����}
var temp:Pvector;
    i,j:integer;
    boolXY:array of boolean;
begin
B^.n:=0;
if (Fb=ErResult)then Exit;

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
{ j ������ ������� ����� � temp, ��
 ������������� ����� D � ��� ���� n �� ����� 1}

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
            B^.y[j]:=DD.Material.Eps*8.85e-14*
                    (temp^.y[i]-1)/DD.Thick_i/1.6e-19;
            j:=j+1;
           end;
  end;
except
B^.n:=0;
end; //try

dispose(temp);
end;

Procedure Dit_Fun(A:Pvector; var B:Pvector;
                  Rs:double;DD:TDiodSample; D:TDiapazon);
{������ � � ��������� ������� �����,
��������� �� ������� �������,
Dit=ep*ep0/(q^2*del)*d(Vcal-Vexp)/dVs
�� ������ ��-Ess=(Fb-qVs),
[Dit] = ��-1 ��-2; [Ec-Ess] = ��;
�� - ����������� ���������� ����������
��0 - ����������� �����
del - ������� ������������� ����
Rs - �������� ����������� �����
Vcal �� Vexp - ����������� �� �������
�������� ������� ��� ��������� ��������� ������;
Vcal=Vs+(del/ep)*[Sqrt(2q*Nd*eps/eps0) (Sqrt(Fb/q)-Sqrt(Fb/q-Vs))]
Vexp=V-IRs
e� - ����������� ���������� �������������
Fb - ������ ���'��� �����
Nd - ������������ ������ � �������������;
Vs - ������ ������� �� ��� �������������
Vs=Fb/q-kT/q*ln(Szr*AA*T^2/I);
AA - ����� г��������
Szr - ����� ��������
}
var i,j:integer;
    Vs,Vcal,del,Fb:double;
    temp:PVector;
begin
B^.n:=0;
if (Rs=ErResult)then Exit;
IvanovKalk(A,D,Rs,DD,del,Fb);
if (Fb=ErResult)or(del<=0) then Exit;
new(temp);
A_B_Diapazon(A,A,temp,D);
if temp^.n=0 then
          begin
          Dispose(temp);
          Exit;
          end;
for I := 0 to High(temp^.X) do
  begin
   Vs:=Fb+DD.Fb(A^.T,temp^.Y[i]);
   Vcal:=Vs+Rs*temp^.Y[i]+
         del*sqrt(2*Qelem*DD.Nd*DD.Material.Eps/Eps0)*(sqrt(Fb)-sqrt(Fb-Vs));
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

Procedure IvanovAprox (V:PVector; DD:TDiodSample;
                       var del,Fb:double;
                       OutsideTemperature:double=ErResult);
{������������ ����� � ������ V ������������� ���������
I=Szr AA T^2 exp(-Fb/kT) exp(qVs/kT)
V=Vs+del*[Sqrt(2q Nd ep / eps0) (Sqrt(Fb/q)-Sqrt(Fb/q-Vs))]
��
AA - ����� г��������
Szr - ����� ��������, []=�^2
Fb - ������ ���'��� �����, []=eV
Vs - ������ ������� �� ��� �������������
     (�������� ���������)
del - ������� ������������� ����, []=�
(���� ������ - ������� ����, ������� ��
�������� ������� ����������� ���������� ����)
Nd - ������������ ������ � �������������, []=�^-3;
e� - ����������� ���������� �������������
��s0 - ����������� �����
����������� �������� del �� Fb;
}

var temp:Pvector;
    a,b,Temperature:double;
    i:integer;
    Param:array of double;

begin
del:=ErResult;
Fb:=ErResult;
if OutsideTemperature=ErResult then Temperature:=V^.T
                               else Temperature:=OutsideTemperature;
if (Temperature<=0)or(V^.n=0) then Exit;
SetLength(Param,6);
new(temp);
temp^.n:=High(V^.X)+1;
SetLength(temp^.X,temp.n);
SetLength(temp^.Y,temp.n);
try
for I := 0 to High(V^.X) do
  begin
   temp^.X[i]:=1/V^.X[i];
   temp^.Y[i]:=sqrt(DD.Fb(Temperature,V^.Y[i]));
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

try
a:=(Param[2]*(Param[0]+Param[3])-Param[1]*(Param[5]+Param[4]))/(Param[3]*Param[1]-sqr(Param[2]));
b:=(Param[3]*(Param[0]+Param[3])-Param[2]*(Param[5]+Param[4]))/(Param[3]*Param[1]-sqr(Param[2]));
b:=(sqrt(sqr(a)+4*b)-a)/2;
except
  Exit;
end;
del:=a/sqrt(2*Qelem*DD.Nd*DD.Material.Eps/Eps0);
Fb:=sqr(b);

end;



Procedure A_B_Diapazon(Avuh,A:Pvector; var B:Pvector;
              D:TDiapazon;YminDontUsed:boolean=False);
{������ � � � ����� � ������� �, �������
�� ���� ����� � ������ Avuh (���������) �������������
������ D; ��������, �� ��� ������� �
����� ���� ������� �^.N_begin �� �^.N_end (���� � �����);
B^.N_begin, B^.N_end �� ��������������}

var i,j:integer;
begin
B^.T:=Avuh^.T;
j:=0;
SetLength(B^.X, j);
SetLength(B^.Y, j);
for I := 0 to High(A^.X) do
 if PoinValide(D,Avuh,A,i,YminDontUsed) then
   begin
     j:=j+1;
     SetLength(B^.X, j);
     SetLength(B^.Y, j);
     B^.X[j-1]:=A^.X[i];
     B^.Y[j-1]:=A^.Y[i];
   end;
B^.n:=j;
end;

Procedure A_B_Diapazon(A:Pvector; var B:Pvector;
                  D:TDiapazon;
                  YminDontUsed:boolean=False);overload;
{������ � � � ����� � ������� �, ��
������������� ������ D;
B^.N_begin, B^.N_end �� ��������������
���� YminDontUsed=True, �� ���������
�� Ymin �� ���������������� - �������
��� ������ ��� ��������� ��������}
//var i,j:integer;
begin
 A_B_Diapazon(A,A,B,D,YminDontUsed);
end;

Procedure Kam1_Fun (A:Pvector; var B:Pvector; D:TDiapazon);
{������ � B ������� ������ ������� ����
���������� �� � ����� ������� �, �� �������������
����� D}
var temp:Pvector;
    i,j:integer;
begin
new(temp);


//A_B_Diapazon(A,A,temp,D);
//{� temp � ����� ������� �, �� ������������� D}
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

Procedure Kam2_Fun (A:Pvector; var B:Pvector; D:TDiapazon);
{������ � B ������� ������ ������� ����
���������� �� � ����� ������� �, �� �������������
����� D}
var temp:Pvector;
    i,j,k:integer;
begin
new(temp);
A_B_Diapazon(A,A,temp,D);
{� temp � ����� ������� �, �� ������������� D}

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
//���������� ������� ���������
for I := 0 to High(B^.X)-1 do
  for j := 0 to High(B^.X)-i-1 do
      if B^.X[j]>B^.X[j+1] then
          begin
          Swap(B^.X[j],B^.X[j+1]);
          Swap(B^.Y[j],B^.Y[j+1]);
          end;
end;

Procedure Gr1_Fun (A:Pvector; var B:Pvector);
{������ � B ������� ������� ������� ����
���������� �� ����� ������� �}
var i:integer;
begin
ForwardIV(A,B);
for i:=0 to High(B^.X) do Swap(B^.X[i],B^.Y[i]);
end;


//Procedure Gr2_Fun (A:Pvector; var B:Pvector; AA, Szr:double);
Procedure Gr2_Fun (A:Pvector; var B:Pvector; DD:TDiodSample);
{������ � B ������� ������� ������� ����
���������� �� ����� ������� �}
var i:integer;
begin
NordeFun(A,B,DD,2);
for i:=0 to High(B^.X) do B^.X[i]:=A^.Y[i+B^.N_begin];
{��������, ��������� ���� �������� ���� � �������,
���� � � ����������� �������� ����, ��� ����� �^.N_begin=0}
end;


Procedure LimitFun(A, A1:Pvector; var B:Pvector; Lim:Limits);
{������ � � � � ����� � �����, ��� ����
� ����� �1 ����������� �����, ���������� � Lim}
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
      boolXY[i]:=((Lim.MinValue[0]=ErResult)or(A1^.X[i+A^.N_begin]>Lim.MinValue[0]))
       and ((Lim.MaxValue[0]=ErResult)or(A1^.X[i+A^.N_begin]<Lim.MaxValue[0]));

    if (Lim.MinXY=0) and (Lim.MaxXY=1)
     then
      boolXY[i]:=((Lim.MinValue[0]=ErResult)or(A1^.X[i+A^.N_begin]>Lim.MinValue[0]))
       and ((Lim.MaxValue[1]=ErResult) or (A1^.Y[i+A^.N_begin]<Lim.MaxValue[1]));

    if (Lim.MinXY=1) and (Lim.MaxXY=1)
     then
      boolXY[i]:=((Lim.MinValue[1]=ErResult)or(A1^.Y[i+A^.N_begin]>Lim.MinValue[1]))
       and ((Lim.MaxValue[1]=ErResult)or(A1^.Y[i+A^.N_begin]<Lim.MaxValue[1]));

    if (Lim.MinXY=1) and (Lim.MaxXY=0)
     then
      boolXY[i]:=((Lim.MinValue[1]=ErResult)or(A1^.Y[i+A^.N_begin]>Lim.MinValue[1]))
       and ((Lim.MaxValue[0]=ErResult)or(A1^.X[i+A^.N_begin]<Lim.MaxValue[0]));

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

Function PoinValide(Dp:TDiapazon;
                   Original, Secondary:Pvector;
                   k:integer; YminDontUsed:boolean=False): boolean;
{�������, �� ������������ ���������� �����
������� Original, ��� ������� k-�� �����
������� Secondary, ������, ��������� � ����� Dp;
��� YminDontUsed=True �� ������������ ����� ��� Ymin -
������� ��� ������ ��� ��������� ��������}

var Xmax, Xmin, Ymax, Ymin:boolean;
begin
Xmax:=false;Ymax:=false;Xmin:=false;Ymin:=false;
case Dp.Br of
 'F':begin
    Xmax:=(Dp.XMax=ErResult)or(Original^.X[k+Secondary.N_begin]<Dp.XMax);
    Xmin:=(Dp.XMin=ErResult)or(Original^.X[k+Secondary.N_begin]>Dp.XMin);
    Ymax:=(Dp.YMax=ErResult)or(Original^.Y[k+Secondary.N_begin]<Dp.YMax);
    Ymin:=(Dp.YMin=ErResult)or(Original^.Y[k+Secondary.N_begin]>Dp.YMin);
     end;
 'R':begin
    Xmax:=(Dp.XMax=ErResult)or(Original^.X[k+Secondary.N_begin]>-Dp.XMax);
    Xmin:=(Dp.XMin=ErResult)or(Original^.X[k+Secondary.N_begin]<-Dp.XMin);
    Ymax:=(Dp.YMax=ErResult)or(Original^.Y[k+Secondary.N_begin]>-Dp.YMax);
    Ymin:=(Dp.YMin=ErResult)or(Original^.Y[k+Secondary.N_begin]<-Dp.YMin);
    end;
 end; //case
 if YminDontUsed then Ymin:=True;

 Result:=Xmax and Xmin and Ymax and Ymin;
end;


Procedure ChungKalk(A:PVector; D:TDiapazon; var Rs:double; var n:double);
{�� ����� ����� � ������� � ������ �������� ��
����� ������������ ������� ����� (� �����������
��������, �������� � D, ������� ��������
����������� ����� Rs �� ����������� ����������� n;
���� A^.T<=0, �� n=ErResult � ������������� ���� Rs}
var temp1, temp2:Pvector;
begin
Rs:=ErResult;
n:=ErResult;
new(temp1);
ChungFun(A,temp1);         // � temp1 ����� ������� �����
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
  {� temp2 ����� ������� ������� �����
  (���� ����� ������� �������)}
LinAprox(temp2,n,Rs);
if A^.T<=0 then n:=ErResult
           else n:=n/Kb/A^.T;

dispose(temp1);dispose(temp2);
end;

Procedure WernerKalk(A:PVector; var D:TDiapazon; var Rs:double; var n:double);
{�� ����� ����� � ������� � ������ �������� ��
����� ������������ ������� ������� (� �����������
��������, �������� � D), ������� ��������
����������� ����� Rs �� ����������� ����������� n}
var temp1, temp2:Pvector;
    aa,bb:double;
//    Dev,DYmin:TArrSingle;
//    Dtemp:Diapazon;
//    Np,i,Ntemp:integer;
//    Xtemp:double;
begin
//Rs:=ErResult;
//n:=ErResult;
//if A^.T<=0 then Exit;
//new(temp1);
//WernerFun(A,temp1);         // � temp1 ����� ������� �������
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

Rs:=ErResult;
n:=ErResult;
if A^.T<=0 then Exit;
new(temp1);
WernerFun(A,temp1);         // � temp1 ����� ������� �������
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
  {� temp2 ����� ������� ������� �������
  (���� ����� ������� �������)}
LinAprox(temp2,aa,bb);
n:=1/Kb/A^.T/aa;
Rs:=-bb/aa;
dispose(temp1);dispose(temp2);
end;

Procedure MikhKalk(A:PVector; D:TDiapazon; DD:TDiodSample;
                   var Rs:double; var n:double; var I0:double; var Fb:double);
{�� ����� ����� � ������� � (���, �� �������������
����� D) �� ���������
������ ̳������� ������������ ��������
����������� ����� Rs, ����������� ����������� n,
������ ���'��� Fb �� ������ ��������� �0;
���� ����������� �� ������, �� �����������
���� Rs �� I0, ���� ������� ������������ �������� ErResult;
���� ��������� ���������� Alpha-������� ̳�������,
�� � �� �������� ErResult;
AA - ����� г��������,
Szr - ����� ��������}
var temp1,temp2:PVector;
    Alpha_m,Vm,Im:double;
begin
Rs:=ErResult;
n:=ErResult;
Fb:=ErResult;
I0:=ErResult;

//QueryPerformanceCounter(StartValue);

new(temp1);
new(temp2);

MikhAlpha_Fun(A,temp1);
{ � temp1 �lpha-������� ̳�������,
���������� �� ��� [�������] ������ �}
if temp1^.n=0 then
            begin
             dispose(temp1);
             dispose(temp2);
             Exit;
            end;
A_B_Diapazon(A,temp1,temp2,D);
{� temp2 ���� � ����� � temp1, ���
���� ������� ����� � ������ �
����������� ����� D }
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
{� temp1 �������� �lpha-������� ̳�������,
���������� ���� �� ������, �� �������������
������� D }

Vm:=Extrem(temp2);
if Vm=ErResult then
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
   Fb:=Kb*A^.T*(Alpha_m+1)+DD.Fb(A^.T,Im);
   end;


dispose(temp1);
dispose(temp2);

//QueryPerformanceCounter(EndValue);
//QueryPerformanceFrequency(Freq);
//showmessage('tics='+inttostr(EndValue-StartValue)+#10+#13+
//             'time='+floattostr((EndValue-StartValue)/Freq)
//             +' s');

end;

Procedure HFunKalk(A:Pvector; D:TDiapazon; DD:TDiodSample; N:double;
                   var Rs:double; var Fb:double);
{�� ����� ����� � ������� � ������ �������� ��
����� ������������ H-������� (� �����������
��������, �������� � D), ������� ��������
����������� ����� Rs �� ������ ���'��� Fb;
��� �������� �-������� ������
N - ������ �����������}
var temp1, temp2:Pvector;
begin
Rs:=ErResult;
Fb:=ErResult;
if N=ErResult then Exit;

new(temp1);
HFun(A,temp1,DD,N);         // � temp1 ����� H-�������
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
  {� temp2 ����� ������� H-�������
  (���� ����� ������� �������)}
LinAprox(temp2,Fb,Rs);
Fb:=Fb/N;
dispose(temp1);dispose(temp2);
end;

Procedure ExKalk(Index:integer; A:Pvector; D:TDiapazon;
                 Rs:double; DD:TDiodSample;
                 var n:double; var I0:double; var Fb:double);overload;
{�� ����� ����� � ������� � ������
����� ������������ ��� � �����������������
������� (� �����������
��������, �������� � D), ������� ��������
����������� ����������� n,
������ ��������� �0
������ ���'��� Fb;
��������, �� ������������ �� �������� I=I0exp(V/nkT)
Index ����� �� ���� �������������:
1 - �������� ��������� ������ �
2 - �������� I/[1-exp(-qV/kT)] ��� ����� ����
3 - �������� I/[1-exp(-qV/kT)] ��� ��������� ����
��� �������� ��� ��������
Rs - ���������� ���,
��� ���������� Fb
AA - ����� г��������,
Szr - ����� ��������}
var temp1,temp2:Pvector;
    i:integer;
begin
n:=ErResult;
Fb:=ErResult;
I0:=ErResult;
if (Rs=ErResult)or(DD.Material.ARich=ErResult)or(DD.Area=ErResult)or(A^.T<=0)
     then Exit;

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

 {� temp1 ����� ������� BAX � �����������������
 ������� � ����������� Rs (���� ����� ������� �������)}
LinAprox(temp1,I0,n);
I0:=exp(I0);
n:=1/(Kb*A^.T*n);
if Index=3 then n:=-n;
Fb:=DD.Fb(A^.T,I0);
//Kb*A^.T*ln(Szr*AA*sqr(A^.T)/I0);
dispose(temp1);
end;


Procedure ExKalk_nconst(Index:integer; A:Pvector; D:TDiapazon;
                 DD:TDiodSample; Rs, n:double;
                 var I0:double; var Fb:double);overload;
{�� ����� ����� � ������� � ������
����� ������������ ��� � �����������������
������� (� �����������
��������, �������� � D),
�� �������� ����������� ����������� n
������� ��������
������ ��������� �0
������ ���'��� Fb;
��������, �� ������������ �� �������� I=I0exp(V/nkT)
Index ����� �� ���� �������������:
1 - �������� ��������� ������ �
2 - �������� I/[1-exp(-qV/kT)] ��� ����� ����
3 - �������� I/[1-exp(-qV/kT)] ��� ��������� ����
��� �������� ��� ��������
Rs - ���������� ���,
��� ���������� Fb
AA - ����� г��������,
Szr - ����� ��������}
var temp1,temp2:Pvector;
    i:integer;
    n_temp:double;
begin
//n:=ErResult;
Fb:=ErResult;
I0:=ErResult;
if (Rs=ErResult)or(DD.Area=ErResult)or(DD.Material.ARich=ErResult)or(A^.T<=0) then Exit;

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

 {� temp1 ����� ������� BAX � �����������������
 ������� � ����������� Rs (���� ����� ������� �������)}
n_temp:=1/(Kb*A^.T*n);
LinAproxBconst(temp1,I0,n_temp);
I0:=exp(I0);
//n:=1/(Kb*A^.T*n);
//if Index=3 then n:=-n;
Fb:=DD.Fb(A^.T,I0);
dispose(temp1);
end;


Procedure ExKalk(A:Pvector; DD:TDiodSample;
                 var n:double; var I0:double; var Fb:double;
                 OutsideTemperature:double=ErResult);overload;
{�� ����� ����� � ������� � ������
����� ������������ ��� � �����������������
�������, ������� ��������
����������� ����������� n,
������ ��������� �0
������ ���'��� Fb;
��������, �� ������������ �� �������� I=I0exp(V/nkT)
��� ���������� Fb ������
AA - ����� г��������,
Szr - ����� ��������}
var {temp1,}temp2:Pvector;
    i:integer;
    Temperature:double;
begin
if OutsideTemperature=ErResult then Temperature:=A^.T
                               else Temperature:=OutsideTemperature;

n:=ErResult;
Fb:=ErResult;
I0:=ErResult;
if (DD.Material.ARich=ErResult)or(DD.Area=ErResult)
   or(Temperature<=0) then Exit;

new(temp2);
IVchar(A,temp2);
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
n:=1/(Kb*Temperature*n);
Fb:=DD.Fb(Temperature,I0);
dispose(temp2);
end;


Procedure ExpKalk(A:Pvector; D:TDiapazon; Rs:double;
                 DD:TDiodSample; Xp:IRE;
                 var n:double; var I0:double; var Fb:double);
{�� ����� ����� � ������� � ������
������������ ��� �� �������� �=I0(exp(V/nkT)-1)
(� ����������� ��������, �������� � D), ������� ��������
����������� ����������� n,
������ ��������� �0
������ ���'��� Fb;
��� �������� ��� ��������
Rs - ���������� ���,
��   - ������ ���������� ���������
��� ���������� Fb
AA - ����� г��������,
Szr - ����� ��������}
var temp1:Pvector;
    i,rez:integer;
    Xr:IRE;
begin
if (D.YMin=ErResult) or (D.YMin<=0) then D.YMin:=0;
if (D.XMin=ErResult) then D.XMin:=0.001;
n:=ErResult;
Fb:=ErResult;
I0:=ErResult;
if Rs=ErResult then Exit;

new(temp1);
A_B_Diapazon(A,A,temp1,D);
if temp1^.n=0 then
    begin
      dispose(temp1);
      Exit;
    end;
for I := 0 to High(temp1^.X) do
              temp1^.X[i]:=temp1^.X[i]-Rs*temp1^.Y[i];
 {� temp1 ����� BAX � ����������� Rs }

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
Fb:=DD.Fb(A^.T,I0);
dispose(temp1);
end;


Procedure NordDodat(A:Pvector; D:TDiapazon; DD:TDiodSample; Gamma:double;
                   var V0:double; var I0:double; var F0:double);
{�� ����� ����� � ������� � (� ����������
�������� � D) ���� ������� ����� �� �������
���������� �� ������ V0, ��������
�������� ���� ������� F0 �� �������� ������ �0,
��� ������� V0 � �������� �����}
var temp1,temp2:Pvector;
begin
V0:=ErResult;
I0:=ErResult;
F0:=ErResult;
new(temp1);
NordeFun(A,temp1,DD,Gamma);    // � temp1 ����� ������� �����
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
{� temp2 - ������� ������� �����, ���
����������� ������ � D}

V0:=Extrem(temp2);
//showmessage(floattostr(V0));

F0:=ChisloY(temp2,V0);
//showmessage(floattostr(F0));

I0:=ChisloY(A,V0);
dispose(temp2);
dispose(temp1);
end;


Procedure NordKalk(A:Pvector; D:TDiapazon; DD:TDiodSample; Gamma:double; {Gamma:word;}
                   n:double; var Rs:double; var Fb:double);
{�� ����� ����� � ������� � ������ ��������
������� ����� (� �����������
��������, �������� � D), ������� ��������
����������� ����� Rs �� ������ ���'��� Fb;
��� �������� ������� ����� ������
AA - ����� г��������,
Szr - ����� ��������,
Gamma - �������� ����� (��� �������)
��� ���������� Rs
n - �������� ����������}
var V0,I0,F0:double;
begin
Rs:=ErResult;
Fb:=ErResult;

NordDodat(A,D,DD,Gamma,V0,I0,F0);
if V0=ErResult then Exit;

if n<>ErResult then
     begin
     Fb:=F0+(Gamma-n)/n*(V0/Gamma-Kb*A^.T);
     Rs:=Kb*A^.T*(Gamma-n)/I0;
     end;
end;

Procedure CibilsKalk(const A:Pvector; const D:TDiapazon;
                     out Rs:double; out n:double);
{�� ����� ����� � ������� � ������ ��������
������� ѳ����, ������� ��������
����������� ����� Rs ��
��������� ���������� n}
var temp1:Pvector;
    a0,b0:double;
begin
Rs:=ErResult;
n:=ErResult;
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

Procedure IvanovKalk(A:Pvector; D:TDiapazon; Rs:double; DD:TDiodSample;
                     var del:double; var Fb:double);
{�� ����� ����� � ������� � (� �����������
��������, �������� � D), �� ������� �������
������� �������� ������� ������������� ���� del
(���� ������ - ������� ����, ������� ��
�������� ������� ����������� ���������� ����)
�� ������ ���'��� Fb;
AA - ����� г��������
Szr - ����� ��������
Nd - ������������ ������ � �������������;
e� - ����������� ���������� �������������
Rs - ���������� ���, ������������ ������� ���������
��� ���, ���������� � ����������� Rs
}
var temp,temp2:PVector;
begin
del:=ErResult;
Fb:=ErResult;
if Rs=ErResult then Exit;
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
IvanovAprox (temp2,DD,del,Fb);
dispose(temp2);
dispose(temp);
end;

Procedure Kam1Kalk (A:Pvector; D:TDiapazon; var Rs:double; var n:double);
{�� ����� ����� � ������� � ������ ��������
������� ������� (� �����������
��������, �������� � D), ������� ��������
����������� ����� Rs �� ����������� ����������� n;
���� A^.T<=0, �� n=ErResult � ������������� ���� Rs}
var temp1:Pvector;
begin
new(temp1);
Kam1_Fun(A,temp1,D);    // � temp1 ����� ������� �������� �-����
if temp1^.n=0 then
    begin
     Rs:=ErResult;
     n:=ErResult;
     dispose(temp1);
     Exit;
    end;
LinAprox(temp1,n,Rs);
if A^.T<=0 then n:=ErResult
           else n:=n/Kb/A^.T;
dispose(temp1);
end;

Procedure Kam2Kalk (const A:Pvector; const D:TDiapazon; out Rs:double; out n:double);
{�� ����� ����� � ������� � ������ ��������
������� ������� (� �����������
��������, �������� � D), ������� ��������
����������� ����� Rs �� ����������� ����������� n}
var temp1:Pvector;
begin
Rs:=ErResult;
n:=ErResult;

new(temp1);
Kam2_Fun(A,temp1,D);    // � temp1 ����� ������� �������� ��-����
if temp1^.n<2 then
    begin
     dispose(temp1);
     Exit;
    end;
LinAprox(temp1,Rs,n);
Rs:=-Rs/n;
if A^.T>0 then n:=1/n/Kb/A^.T
          else n:=ErResult;
dispose(temp1);
end;

Procedure Gr1Kalk (A:Pvector; D:TDiapazon; DD:TDiodSample;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{�� ����� ����� � ������� � (� �����������
��������, �������� � D) ������� �������
������� ���� ������������ ��������
����������� ����� Rs, ����������� ����������� n,
������ ���'��� Fb �� ������ ��������� �0;
���� ����������� �� ������, �� �����������
���� Rs, ���� ������� ������������ �������� ErResult;
���� ��������� ���������� ������� �������,
�� � Rs=ErResult}
var temp1,temp2:Pvector;
    C0,C1,C2:double;
    Dtemp:TDiapazon;
    i,j,Np:integer;
    DDD:Pvector;

begin

new(temp1);
new(DDD);
Rs:=ErResult;
n:=ErResult;
Fb:=ErResult;
I0:=ErResult;
Dtemp:=TDiapazon.Create;
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
//      DDD^.Y[Np-1]:=ErResult
//                               else


   for j := 0 to High(A^.X) do
     begin
     try
     DDD^.Y[Np-1]:=DDD^.Y[Np-1]+sqr(1-Full_IV(A^.X[j],C2,C1,exp(-C0/C2),1e13,0)/A^.Y[j]);
     except
      DDD^.Y[Np-1]:=ErResult
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
       Fb:=Kb*A^.T*C0/C2+DD.kTln(A^.T);
       I0:=exp(-C0/C2);
       end;
  end;

dispose(temp1);
Dtemp.Free;
dispose(temp2);
dispose(DDD);

//new(temp1);
//Rs:=ErResult;
//n:=ErResult;
//Fb:=ErResult;
//I0:=ErResult;
//A_B_Diapazon(A,A,temp1,D);
//// � temp1 � ����� � �, �� ������������� D
//if temp1^.n<3 then
//             begin
//             dispose(temp1);
//             Exit;
//             end;
//new(temp2);
//Gr1_Fun (temp1,temp2);
//{ � temp2 ������� ������� ������� ����,
//���������� ���� �� �������� ������}
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

Procedure Gr2Kalk (A:Pvector; D:TDiapazon; DD:TDiodSample;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{�� ����� ����� � ������� � (� �����������
��������, �������� � D) ������� �������
������� ���� ������������ ��������
����������� ����� Rs, ����������� ����������� n,
������ ���'��� Fb �� ������ ��������� �0;
���� ����������� �� ������, �� �� �������� ��� ErResult}
var temp1,temp2:Pvector;
    C0,C1,C2:double;
//    Dtemp:Diapazon;
//    i,j,Np:integer;
//    DDD:Pvector;

begin
Rs:=ErResult;
n:=ErResult;
Fb:=ErResult;
I0:=ErResult;
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
//{� temp2 ������� ������� ������� ������� ����,
//  ��� ����������� ����� � Dtemp}
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
//      DDD^.Y[Np-1]:=ErResult
//                               else
//
//   for j := 0 to High(A^.X) do
//     try
//     DDD^.Y[Np-1]:=DDD^.Y[Np-1]+sqr(1-Full_IV(A^.X[j],n*Kb*A^.T,Rs,I0,1e13,0)/A^.Y[j]);
//     except
//      DDD^.Y[Np-1]:=ErResult
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
Gr2_Fun (A,temp1,DD);
{ � temp1 ����� ������� ������� ������� ����}
if temp1^.n=0 then
             begin
             dispose(temp1);
             Exit;
             end;
new(temp2);
A_B_Diapazon(A,temp1,temp2,D);
{� temp2 ������� ������� ������� ������� ����,
  ��� ����������� ����� � D}
dispose(temp1);

if temp2^.n=0 then
          begin
           dispose(temp2);Exit;
          end;

GromovAprox(temp2,C0,C1,C2);
Rs:=2*C1;
n:=2*C2/Kb/A^.T+2;
Fb:=2*C0/n-DD.kTln(A^.T)/n*(2-n);
//Fb:=2*C0/n-Kb*A^.T/n*(2-n)*ln(DD.Area*DD.Material.Arich*sqr(A^.T));
I0:=DD.I0(A^.T,Fb);
//DD.Area*DD.Material.Arich*sqr(A^.T)*exp(-Fb/Kb/A^.T);
dispose(temp2);
end;


Procedure BohlinKalk(A:Pvector; D:TDiapazon; DD:TDiodSample; Gamma1,Gamma2:double;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{�� ����� ����� � ������� � (� �����������
��������, �������� � D), �� ���������
������ ������ ������������ ��������
����������� ����� Rs, �������
����������� n �� ������ ���'��� Fb
(� ����� ������ ��������� �0;
��� �������� ������� ����� ������
AA - ����� г��������,
Szr - ����� ��������,
Gamma - �������� �����,
����� �������� ����� ������ ��������
�� �� ������� ����� �� Gamma}
var V01,V02,I01,I02,F01,F02,temp:double;
begin
Rs:=ErResult;
n:=ErResult;
Fb:=ErResult;
I0:=ErResult;

NordDodat(A,D,DD,Gamma1,V01,I01,F01);
NordDodat(A,D,DD,Gamma2,V02,I02,F02);
if (V01=ErResult) or (V02=ErResult) then Exit;

temp:=(V01-V02+(Gamma2-Gamma1)*Kb*A^.T)/(F02-F01-V02/Gamma2+V01/Gamma1);
n:=((Gamma1*I02-Gamma2*I01)/(I02-I01));
n:=abs((n+temp)/2);

temp:=(Gamma2-n)*Kb*A^.T/I02;
Rs:=(Gamma1-n)*Kb*A^.T/I01;
Rs:=(Rs+temp)/2;


temp:=F02+V02*(1/n-1/Gamma2)-(Gamma2-n)*Kb*A^.T/n;
Fb:=F01+V01*(1/n-1/Gamma1)-(Gamma1-n)*Kb*A^.T/n;
Fb:=(Fb+temp)/2;
I0:=DD.I0(A^.T,Fb);
//Area*DD.Material.Arich*sqr(A^.T)*exp(-Fb/Kb/A^.T);
end;

Procedure LeeKalk (A:Pvector; D:TDiapazon; DD:TDiodSample;
                   var Rs:double; var n:double;
                   var Fb:double; var I0:double);
{�� ����� ����� � ������� � (� �����������
��������, �������� � D) ������� ��������
������� ˳ ������������ ��������
����������� ����� Rs, ����������� ����������� n,
������ ���'��� Fb �� ������ ��������� �0;
���� ����������� �� ������, �� �����������
���� Rs, ���� ������� ������������ �������� ErResult;
���� ��������� ���������� ������� ˳,
�� � Rs=ErResult}
var temp1:Pvector;
    a0,b0:double;
//    Dtemp:Diapazon;
//    i,j,Np:integer;
//    DDD:Pvector;

begin

Rs:=ErResult;
n:=ErResult;
Fb:=ErResult;
I0:=ErResult;

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
//      DDD^.Y[Np-1]:=ErResult*A^.n
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
            Fb:=temp1^.T/n+DD.kTln(A^.T);
            end;
dispose(temp1);
end;

Function Y_X0 (X1,Y1,X2,Y2,X3:double):double;
{��������� �������� ����� � �������� �3,
��� ����������� �� ������� (�1,Y1) �� (X2,Y2) -
����� ������������ �� ���� ������}
begin
 Result:=(Y2*X1-Y1*X2)/(X1-X2)+X3*(Y1-Y2)/(X1-X2);
end;

Function X_Y0 (X1,Y1,X2,Y2,Y3:double):double;
{��������� ������� ����� � ��������� Y3,
��� ����������� �� ������� (�1,Y1) �� (X2,Y2) -
����� ������������ �� ���� ������}
begin
 Result:=(Y3-(Y2*X1-Y1*X2)/(X1-X2))/(Y1-Y2)*(X1-X2);
end;

function ChisloY (A:Pvector; X:double):double;
{������� ��������� �������� ����� �
�������� � ��� �������, ���� �� �����
������� � �� ������������� ���������,
�������� � �;
���� � �� �������� �������� ����
������ ������� �, �� ����������� ErResult}
var i:integer;
    bool:boolean;
begin
bool:=false;
i:=1;
Result:=ErResult;
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
{������� ��������� ������� ����� �
��������� Y ��� �������, ���� �� �����
������� � �� ������������� ���������,
�������� � �;
���� Y �� �������� �������� ����
������� ������� �, �� ����������� ErResult}
var i:integer;
    bool:boolean;
begin
bool:=false;i:=1;
Result:=ErResult;
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
{���������� ����������� �����������
�� ������ � ������ � ��� ������ V;
���� ����� � ��������� ������� ���� -
�������� ����������� � ����������� ErResult}
var temp1, temp2:double;
begin
   Result:=ErResult;
   temp1:=ChisloY(A,V);
   temp2:=ChisloY(A,-V);
   if (temp1=ErResult)or(temp2=ErResult) then Exit;
   if (temp2<>0) then Result:=abs(temp1/temp2);
end;

function IscCalc(A:Pvector):double;
{������������ ����� ��������� ���������
�� ������ � ������ �}
var temp, temp2:double;
begin
 Result:=0;
 if A^.n<2 then Exit;
 temp:=ChisloY(A,0);
 temp2:=ChisloY(A,0.01);
 if {(temp=ErResult)or
    (temp2=ErResult)or
    (temp>=0)or  }
    (abs(temp2/temp)>2) then Exit
             else Result:=-temp;
 if temp=ErResult then
      Result:=(-A^.Y[1]*A^.X[0]+A^.Y[0]*A^.X[1])/(A^.X[0]-A^.X[1]);
end;

function VocCalc(A:Pvector):double;
{������������ ������� ��������� ����
�� ������ � ������ �}
var temp:double;
begin
 Result:=0;
 temp:=ChisloX(A,0);
 if (temp=ErResult)or
    (temp<=0) then Exit
              else Result:=temp;
end;

Function Extrem (A:PVector):double;
{��������� ������� ���������� �������,
�� ����������� � �;
����������, �� ��������� ����;
���� ���������� ���� - ����������� ErResult;
���� ��������� �� ������ - ������� ������
�������� :-)}
var temp:PVector;
begin
new(temp);
Diferen(A,temp);
Result:=ChisloX(temp,0);
dispose(temp);
end;

Procedure GraphFill(Series:TLineSeries;Func:TFunSingle;
                    x1,x2:double;Npoint:word);
{�������� Series ���������� Func(�) � �������
�� �1 �� �2 � ��������� ������� ����� Npoint+1}
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
{�������� Series ���������� Func(�,y0) � �������
�� �1 �� �2 � ��������� ������� ����� Npoint+1}
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

Procedure VectorToGraph(A:PVector;Series:TLineSeries);
{�������� ��� � � � Series}
var i:integer;
begin
Series.Clear;
for I := 0 to High(A^.X) do
  Series.AddXY(A^.X[i],A^.Y[i]);
end;


Procedure GraphToVector(Series:TLineSeries;A:PVector);
{�������� ��� � Series � A, ������������ ���� ������ � �� Y ���������}
var i:integer;
begin
SetLenVector(A,Series.Count);
for I := 0 to High(A^.X) do
     begin
      A^.X[i]:=Series.XValue[i];
      A^.Y[i]:=Series.YValue[i];
     end;
end;

Procedure GraphAverage (Lines: array of TLineSeries; delX:double=0.002;
                         NumLines:integer=0; shiftX:double=0.002);
{��������� ������, �� �����������
� ������� ������ � �������  NumLines,
�� ������� �� �������� shiftX;
����  NumLines=0, �� ����� �� ����������;
���� �����
� �������� ������� ������ �������
������ ����������� �������,
�� ����������� � �����;
���������� ��������� ������� ������ ����� ���
�������;
���� �� ��������� ������ ����� - delX}
var VectorArr: array of PVector;
    i:word;
    Xmin,Xmax,x,y:double;
begin

if (High(Lines)<1)or(NumLines>High(Lines))
    or(NumLines<0)  then Exit;

try
 Lines[0].Clear;
 SetLength(VectorArr,High(Lines));
 for i:= 0 to High(VectorArr) do
   begin
   new(VectorArr[i]);
   GraphToVector(Lines[i+1],VectorArr[i]);
   Sorting(VectorArr[i]);
   end;
 if (NumLines>0) then
   begin
    for i:= 0 to High(VectorArr[NumLines-1]^.X) do
     VectorArr[NumLines-1]^.X[i]:=VectorArr[NumLines-1]^.X[i]+shiftX;
    VectorToGraph(VectorArr[NumLines-1],Lines[NumLines]);
   end;

 Xmin:=VectorArr[0]^.X[0];
 Xmax:=VectorArr[0]^.X[High(VectorArr[0]^.X)];
  for i:= 1 to High(VectorArr) do
    begin
     if Xmin<VectorArr[i]^.X[0] then Xmin:=VectorArr[i]^.X[0];
     if Xmax>VectorArr[i]^.X[High(VectorArr[i]^.X)]
                   then Xmax:=VectorArr[i]^.X[High(VectorArr[i]^.X)];
    end;
  x:=Xmin;
  repeat
    y:=0;
    for i:= 0 to High(VectorArr) do
      y:=y+ChisloY(VectorArr[i],x);
    Lines[0].AddXY(x,y/(High(VectorArr)+1));
    x:=x+delX;
  until x>Xmax;

 for I := 0 to High(VectorArr) do
   dispose(VectorArr[i]);
finally
end;//try
end;


Function Voc_Isc_Pm(mode:byte;Vec:PVector;n,Rs,I0,Rsh,Iph:double):double;
{������������ Voc (��� mode=1),
Isc (��� mode=2) �� �����������
������� ��������� (��� mode=3) �� ������ ��������
n, Rs, I0, Rsh, Iph ��� ������� � Vec.
��������������� ����� ������쳿
��� ����'���� �������
I0*[exp(qVoc/nkT)-1]+Voc/Rsh-Iph=0
���
I0*[exp(qRsIsc/nkT)-1]+RsIsc/Rsh-Iph+Isc=0.
FF ������������ �� ����� ������������ ���
�������� ��������
I=V/Rs-Rsh(RsIph+RsI0+V)/Rs/(Rs+Rsh)+
  nkT/q/Rs*Lambert(qRsI0Rsh/((Rs+Rsh)nkT)exp(Rsh(RsIph+RsI0+V)/(nkT(Rs+Rsh)))
a ����, ������� ������쳿 ����������� ��������� ������� Pm=I*V
� ������������ ���� ������������ ��������
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

 Result:=ErResult;
 if Vec^.T<=0 then Exit;
 if (Iph<=0) or (Iph=ErResult) then Exit;
 if (I0<=0) or (I0=ErResult) then Exit;
 if (n<=0) or (n=ErResult) then Exit;
 if (Rs<0) or (Rs=ErResult) then Exit;
 if (Rsh<=0) or (Rsh=ErResult) then Exit;
 if mode<1 then Exit;
 if mode>3 then Exit;

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
{������������ Voc (��� mode=1),
Isc (��� mode=2) �� �����������
������� ��������� (��� mode=3) �� ������ ���������
�1, �2, Rs, I01, I02, Rsh, Iph, ��������, ��  ���
�� ����������� ����� ������������.
��������������� ����� ������쳿
��� ����'���� �������
I01*[exp(qVoc/�1)-1]+I02*[exp(qVoc/�2)-1]+Voc/Rsh-Iph=0
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

 Result:=ErResult;
 if (E1<=0)or(E2<=0) then Exit;
 if (Iph<=0) or (Iph=ErResult) then Exit;
 if (I01<=0) or (I01=ErResult) then Exit;
 if (I02<=0) or (I02=ErResult) then Exit;
 if (Rs<0) or (Rs=ErResult) then Exit;
 if (Rsh<=0) or (Rsh=ErResult) then Exit;
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
