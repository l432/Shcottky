unit OlegVectorManipulation;

interface
 uses OlegVectorNew,OlegTypeNew, OlegMaterialSamplesNew;


type

  TSplainCoef=record
         B:double;
         C:double;
         D:Double
         end;
  TSplainCoefArray=array of TSplainCoef;


    TVectorManipulation=class
      private
       fVector:TVectorNew;
//       function GetVector: TVectorNew;
       procedure SetVector(const Value: TVectorNew);
      public
       property Vector:TVectorNew read fVector write SetVector;
       Constructor Create(ExternalVector:TVectorNew);overload;
       Constructor Create();overload;
       procedure Free;
    end;

   TProcTarget=Procedure(var Target:TVectorNew) of object;

   TVectorTransform=class(TVectorManipulation)
    private
     Procedure InitTarget(var Target:TVectorNew);
     Procedure InitTargetToFun(var Target:TVectorNew);
      {��������� ��������� �� �������� �������� �������;
      �������  Target.N_begin, ��������� � �����
      � Vector �������� �>0.001 �� Y>0,
      ���������� ���������� ����� Target;
      ���� ���������� Target �� ����������}
     procedure InitArrSingle(var OutputData: TArrSingle;NumberOfData:word);
     Procedure CopyLimited (Coord:TCoord_type;var Target:TVectorNew;Clim1, Clim2:double);
     procedure Branch(Coord:TCoord_type;var Target:TVectorNew;
                      const IsPositive:boolean=True;
                      const IsRigorous:boolean=True);
     procedure Module(Coord:TCoord_type;var Target:TVectorNew);
     Procedure RRR(E:double; Target:TVectorNew);
    {�������� ������� � Newts ��� ������������,
    �������� � ��������� � ������� B ����������� exp(�^.x/E),
    � ��������� � - [exp(�^.x/E)-1]}



    public
     Procedure CopyLimitedX (var Target:TVectorNew;Xmin,Xmax:double);
       {��������� � ������ ������� � Target
        - �����, ��� ���� ������� � ������� �� Xmin �� Xmax �������
         - ���� � �� name}
     Procedure CopyLimitedY (var Target:TVectorNew;Ymin,Ymax:double);
     procedure AbsX(var Target:TVectorNew);
         {�������� � Target �����, ��� ���� X ������� ������ � ������
         �������, � Y ���� ����; ���� �=0, �� ����� ����������}
     procedure AbsY(var Target:TVectorNew);
         {�������� � Target �����, ��� ���� Y ������� ������ Y ������
         �������, � X ���� ����; ���� Y=0, �� ����� ����������}
     Procedure PositiveX(var Target:TVectorNew);//overload;
         {�������� � Target � �����, ��� ���� X ����� ����}
     procedure PositiveY(var Target:TVectorNew);
         {�������� � Target � �����, ��� ���� Y ����� ����}
     Procedure ForwardX(var Target:TVectorNew);
         {�������� � Target � �����, ��� ���� X ����� ��� ���� ����}
     Procedure ForwardY(var Target:TVectorNew);
     procedure NegativeX(var Target:TVectorNew);
         {�������� � Target � �����, ��� ���� X ����� ����}
     procedure NegativeY(var Target:TVectorNew);
         {�������� � Target � �����, ��� ���� Y ����� ����}
     Procedure ReverseX(var Target:TVectorNew);
         {�������� � Target � �����, ��� ���� X ����� ��� ���� ����}
     Procedure ReverseY(var Target:TVectorNew);
     Procedure ReverseIV(var Target:TVectorNew);
     {������ � Target ����� � �����, �� ����������
     �������� ������ ��� (��� ���� ���������� X ����� ����),
     ������� ������ ������ ���������}
     Procedure Median (var Target:TVectorNew);
      {� Target ���������� ��������� 䳿 �� ��� � Vector
      ��������� �������������� �������;
      ���� � ��������� ����� ������� ����� ����� �����,
      �� � ������������� ���� ������� �������}
     Procedure Splain3(var Target:TVectorNew;beg:double; step:double);
      {� Target ��������� ������������ �����
      � ������������� ������� �������,
      ��������� � ����� � �����������
      beg � � ������ step;
      ���� ������� ������� �����������
      (�� ��������� � ������� ���� ������� �������),
      �� � ������������� ������ ������� �������}
     Function YvalueSplain3(Xvalue:double):double;
    {������� ���������� �������� ������� � ����� Xvalue ��������������
     ����� �������, ��������� �� ����� ������ ����� � ����� V
     Result=Ai+Bi(X-Xi)+Ci(X-Xi)^2+Di(X-Xi)^3 ��� Xi-1<=X<=Xi}
     Function YvalueLagrang(Xvalue:double):double;
     {������� ���������� �������� ������� � ����� Xvalue
      �������������� ������ ��������}
     Function GromovAprox (var  OutputData:TArrSingle):boolean;
      {�������������� ��� ���������
      y=OutputData[0]+OutputData[1]*x+OutputData[2]*ln(x);
      ���� ������������ ������� - ����������� False}
     Function LinAprox (var  OutputData:TArrSingle):boolean;
     {�������������� ��� � ������ V ������
      ��������� y=OutputData[0]+OutputData[1]*x}

     Function IvanovAprox (var  OutputData:TArrSingle;
                           DD: TDiod_Schottky; OutsideTemperature: Double = 555):boolean;
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
      OutputData[0]=del;
      OutputData[1]=Fb;
      }

     Function  ImpulseNoiseSmoothing(const Coord:TCoord_type): Double;

     Function ImpulseNoiseSmoothingByNpoint(const Coord:TCoord_type;
                                       Npoint:Word=0): Double;

      {������������� ������ �������� �� ����� ����� � �����������
      �������� ���������� ����,
      �� ����� �� ImpulseNoiseSmoothing ��� ������������ �� ������
      �� Npoint ���� �� ����� ���� ������������� ������,
      ���� ������ ������������ �� ������ ....}
     Procedure ImNoiseSmoothedArray(Target:TVectorNew;Npoint:Word=0);
      {� Target ���������� ����������
      ����������� (��� ImpulseNoiseSmoothingByNpoint) Source
      �� Npoint ������}
     Procedure Itself(ProcTarget:TProcTarget);
     {�������� �������� ������� Vector}
     Procedure Smoothing (var Target:TVectorNew);
      {� Target ���������� �������� ������� �����
      � Vector;
      � ���� ����������� ����������� �� ����� ������,
      ������� ����������� � �������� �������������,
      �� ������������ ��������� ����� � �������� 0.6;
      ���� � ��������� ����� ������� ����� ����� �����,
      �� � ������������� ���� ������� �������}
     Function DerivateAtPoint(PointNumber:integer):double;
     {����������� ������� �� �������, ��� ��������
     � Vector � ����� � �������� PointNumber}
     Procedure Derivate (var Target:TVectorNew);
      {� Target ���������� ������� �� �������, ������������
      � Vector;
      ���� � ��������� ����� ������� ����� ����� �����,
      �� � ������������� ���� ������� �������}
     Function ExtremumXvalue():double;
      {��������� ������� ���������� �������,
      �� ����������� � Vector;
      ����������, �� ��������� ����;
      ���� ���������� ���� - ����������� ErResult;
      ���� ��������� �� ������ - ������� ������
      �������� :-)}
     Function MaximumCount():integer;
      {������������ ������� ���������
      ��������� � Vector;
      ��� ����� ���� ����������� �� ��������� X}
     Procedure ExKalk(Index: Integer);overload;
     Procedure ExKalk(Index: Integer; D: TDiapazon;
                      Rs: Double; DD: TDiod_Schottky;
                      out n: Double; out I0: Double; out Fb: Double);overload;
      {�� ����� ����� � Vector � ������
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
      ��� ���������� Fb  ��������� ����}
     Procedure ExKalk(DD:TDiod_Schottky;
                       out n:double; out I0:double; out Fb:double;
                       OutsideTemperature:double=ErResult);overload;
      {�� ����� ����� � Vector ������
      ����� ������������ ��� � �����������������
      �������, ������� ��������
      ����������� ����������� n,
      ������ ��������� �0
      ������ ���'��� Fb;
      ��������, �� ������������ �� �������� I=I0exp(V/nkT)
      ��� ���������� Fb ������ ��������� ����}
     Procedure ChungFun(var Target:TVectorNew);
      {������ � Target Chung-�������, ���������� �� ����� � Vector}
     Procedure ChungKalk();overload;
     Procedure ChungKalk(D:TDiapazon; out Rs:double; out n:double);overload;
      {�� ����� ����� � ������� Vector ������ �������� ��
      ����� ������������ ������� ����� (� �����������
      ��������, �������� � D), ������� ��������
      ����������� ����� Rs �� ����������� ����������� n}

     Procedure WernerFun(var Target:TVectorNew);
      {������ � Target ������� �������}
     Procedure WernerKalk();overload;
     Procedure WernerKalk(var D:TDiapazon; var Rs:double; var n:double);overload;
      {�� ����� ����� � Vector ������ �������� ��
      ����� ������������ ������� ������� (� �����������
      ��������, �������� � D), ������� ��������
      ����������� ����� Rs �� ����������� ����������� n}

     Procedure MikhAlpha_Fun(var Target:TVectorNew);
      {������ � Target �����-������� (����� ̳�������),
      Alpha=d(ln I)/d(ln V)}
     Procedure MikhBetta_Fun(var Target:TVectorNew);
      {������ � Target �����-������� (����� ̳�������),
      Betta = d(ln Alpha)/d(ln V)
      P.S. � ����� �� ������� ���������� �����}
     Procedure MikhN_Fun(var Target:TVectorNew);
      {������ � Target ��������� ������� ����������� ��
      ���������� �������, ���������� �� �������
      ����� ̳�������;
      n = q V (Alpha - 1) [1 + Betta/(Alpha-1)] / k T Alpha^2}
     Procedure MikhRs_Fun(var Target:TVectorNew);
      {������ � Target ��������� ����������� ����� ��
      ���������� �������, ���������� �� �������  ̳�������;
      Rs = V (1- Betta) / I Alpha^2}
     Procedure MikhKalk();overload;
     Procedure MikhKalk(D: TDiapazon; DD: TDiod_Schottky;
            out Rs: Double; out n: Double; out I0: Double; out Fb: Double);overload;
      {�� ����� ����� � Vector �� ���������
      ������ ̳������� ������������ ��������
      ����������� ����� Rs, ����������� ����������� n,
      ������ ���'��� Fb �� ������ ��������� �0;
      ���� ����������� �� ������, �� �����������
      ���� Rs �� I0, ���� ������� ������������ �������� ErResult;
      ���� ��������� ���������� ������� �������,
      �� � �� �������� ErResult}
     Procedure HFun(var Target:TVectorNew; DD: TDiod_Schottky; N: Double);
      {������ � Target H-�������
      DD - ���, N - ������ �����������}
     Procedure HFunKalk();overload;
     Procedure HFunKalk(D: TDiapazon; DD: TDiod_Schottky; N: Double; out Rs: Double; out Fb: Double);overload;
      {�� ����� ����� � Vector ������ �������� ��
      ����� ������������ H-������� (� �����������
      ��������, �������� � D), ������� ��������
      ����������� ����� Rs �� ������ ���'��� Fb;
      ��� �������� �-������� ������
      N - ������ �����������}
     Procedure NordeFun(var Target:TVectorNew; DD: TDiod_Schottky; Gam: Double);
      {������ � Target ������� �����;
      Gam - �������� ����� (��� �������)}
     Procedure NordDodat(D: TDiapazon; DD: TDiod_Schottky; Gamma: Double;
             out V0: Double; out I0: Double; out F0: Double);
      {�� ����� ����� � ������� � (� ����������
      �������� � D) ���� ������� ����� �� �������
      ���������� �� ������ V0, ��������
      �������� ���� ������� F0 �� �������� ������ �0,
      ��� ������� V0 � �������� �����}
     Procedure NordKalk();overload;
     Procedure NordKalk(D: TDiapazon; DD: TDiod_Schottky; Gamma, n: Double;
              out Rs: Double; out Fb: Double);overload;
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
     Procedure CibilsFunDod(var Target:TVectorNew; Va:double);
      {������ � Target ������� F(V)=V-Va*ln(I)}
     Procedure CibilsFun(var Target:TVectorNew; D:TDiapazon);
      {������ � Target ������� ѳ����;
      ������� ���� ������� �� kT �� ��� �������,
      ��� ���� ������� F(V)=V-Va*ln(I) �� �� �����,
      ���� - 0.001}
     Procedure CibilsKalk();overload;
     Procedure CibilsKalk(const D:TDiapazon;
                           out Rs:double; out n:double);overload;
      {�� ����� ����� � Vector ������ ��������
      ������� ѳ����, ������� ��������
      ����������� ����� Rs ��
      ��������� ���������� n}
     Procedure CopyDiapazonPoint(var Target:TVectorNew;D:TDiapazon;InitVector:TVectorNew);overload;
      {������ � Target � ����� � Vector, �������
      �� ���� ����� � InitVector (���������) �������������
      ������ D; ��������, �� ��� Vector
      ����� ���� ������� N_begin;
      Target.N_begin �� �������������}
     Procedure CopyDiapazonPoint(var Target:TVectorNew;Lim:Limits;InitVector:TVectorNew);overload;
     Procedure CopyDiapazonPoint(var Target:TVectorNew;D:TDiapazon);overload;
      {������ � Target � ����� � Vector, ��
      ������������� ������ D;
      Vector.N_begin �� ���� 0;
      Target.N_begin �� �������������}
     Procedure LeeFunDod(var Target:TVectorNew; Va:double);
      {������ � Target ������� F(I)=V-Va*ln(I)}
     Procedure LeeFun(var Target:TVectorNew; D:TDiapazon);
      {������ � Target ������� Lee;
      ������� ���� ������� �� kT �� ��������� ����������
      ����������� �������� ������� � ������� ���;
      ���� - 0.02;
      � ��� Target.T ����������� �� �����������,
      � �������� � ������������ �������� �+B*x+C*ln(x);
      �� ��������� ��������� �� �������� Va �
      ��������������� � ������� LeeKalk ���
      ���������� ������ ���'���; ��� ����� ������������� ������ :)}
     Procedure InVectorToOut(var Target:TVectorNew;
                              Func:TFunDouble;TtokT1:boolean=False);
      {��� TtokT1=False Target.X[i]=Vector.X[i]
       ��� TtokT1=True  Target.X[i]=1/Vector.X[i]/Kb

      Target.Y[i]=Func(Vector^.Y[i],Vector.X[i])}
     Procedure TauFun(var Target:TVectorNew;Func:TFunDouble);
      {�� ����� �� ����������, �� ����������
      � Vector ���������� ��������� �� ����
      ��������� (� �� kT), � ��� ���� ����������� ������������,
      � ����������� ����, �� �  Target ������ ��
      ���� ��������� �� �����������}
     Procedure ForwardIVwithRs(var Target:TVectorNew; Rs:double);
      {������ � Target ����� ������ ��� � Vector �
      ����������� �������� ����������� ����� Rs}
     Procedure Forward2Exp(var Target:TVectorNew; Rs:double);
      {������ � Target ��������� ��������
      I/[1-exp(-qV/kT)] �� ������� �
      ����������� �������� ����������� ����� Rs
      ��� ����� ������ � Vector}
     Procedure Reverse2Exp(var Target:TVectorNew; Rs:double);
     Procedure N_V_Fun(var Target:TVectorNew; Rs:double);
      {������ � Target ��������� ����������� �����������
      �� ������� �������������� ����� n=q/kT* d(V)/d(lnI);
      ��������� I=I(V), ��� ����������� � Vector, ��������
      ������������ � ����������� �������� ����������� ����� Rs}
     Procedure M_V_Fun(var Target:TVectorNew;
                      ForForwardBranch:boolean; tg:TGraph);
      {������� �� tg ����
       - ��������� ����������� m=d(ln I)/d(ln V) �� �������
      (��� ������� ����  I=const*V^m);
       - ������� �������-��������� ��� ���������� �������
          ln(I/V^2)=f(1/V);
      - ������� �������-��������� ��� ����������� �����������
          ln(I/V)=f(1/V^0.5);
      - ������� ������� ��� ���������� �������
          ln(I/V)=f(1/V);
      - ������� ������� ��� ����������� �����������
          ln(I/V^0.5)=f(1/V^0.5);
      - ������� ��������-���� ��� ���������� �������
          ln(I/V)=f(V^0.5);
      - ������� ��������-���� ��� ����������� �����������
          ln(I/V^0.5)=f(1/V^0.25);
      ���� ForForwardBranch=true, �� �������� ��������� ��� ����� ����,
      ���� ForForwardBranch=false - ��� ���������}
     Procedure Nss_Fun(var Target:TVectorNew;
                       Fb, Rs: Double; DD: TDiod_Schottky;
                       D: TDiapazon; nByDerivate: Boolean);
      {������ � Target ��������� ������� �����
      Nss=ep*ep0*(n-1)/q*del �� ������ ��-Ess=(Fb-V/n),
      [Nss] = ��-1 �-2; [Ec-Ess] = ��;
      n - ������ �����������,
      nByDerivate - ���� ���� ������� ����������� n(V)
           true - �� ��������� �������
           false - �� ������� ̳�������
      �� - ����������� ���������� �������������
      ��0 - ����������� �����
      del - ������� ������������� ����
      Fb - ������ ���'��� �����
      Rs - �������� ����������� �����}
     Procedure IvanovKalk(D: TDiapazon; Rs: Double; DD: TDiod_Schottky;
              out del: Double; out Fb: Double);overload;
      {�� ����� ����� � Vector (� �����������
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
     Procedure IvanovKalk();overload;
     Procedure Dit_Fun(var Target:TVectorNew;
                      Rs: Double; DD: TDiod_Schottky; D: TDiapazon);
      {������ � Target ��������� ������� �����,
      ��������� �� ������� �������,
      Dit=ep*ep0/(q^2*del)*d(Vcal-Vexp)/dVs
      �� ������ ��-Ess=(Fb-qVs),
      [Dit] = ��-1 �-2; [Ec-Ess] = ��;
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
     Procedure Kam1_Fun (var Target:TVectorNew; D:TDiapazon);
      {������ � Target ������� ������ ������� ����
      ���������� �� � ����� Vector, �� �������������
      ����� D}
     Procedure Kam1Kalk ();overload;
     Procedure Kam1Kalk (D:TDiapazon; out Rs:double; out n:double);overload;
      {�� ����� ����� � Vector ������ ��������
      ������� ������� (� �����������
      ��������, �������� � D), ������� ��������
      ����������� ����� Rs �� ����������� ����������� n}
     Procedure Kam2_Fun (var Target:TVectorNew; D:TDiapazon);
      {������ � Target ������� ������ ������� ����
      ���������� �� � ����� ������� Vector, �� �������������
      ����� D}
     Procedure Kam2Kalk ();overload;
     Procedure Kam2Kalk (const D:TDiapazon; out Rs:double; out n:double);overload;
      {�� ����� ����� � Vector ������ ��������
      ������� ������� (� �����������
      ��������, �������� � D), ������� ��������
      ����������� ����� Rs �� ����������� ����������� n}
     Procedure Gr1_Fun (var Target:TVectorNew);
      {������ � Target ������� ������� ������� ����}
     Procedure Gr2_Fun (var Target:TVectorNew; DD: TDiod_Schottky);
      {������ � Target ������� ������� ������� ����}
     Procedure Newts(Nr:integer; eps:real; Xp:IRE; var Xr:IRE; var rez:integer);
      {��������� ������������ ����� � Vector �������� y=I0(exp(x/E)-1)+x/R
      �� ������� ��������� �������� � �������������
      �������� �������������;
      �������� � ��� �������� ����������
      ����'���� ������� �������� ������ ������� �������,
      ����������� ������ ����������� �� ���������
      ����� ��������� �������, ����� ������ ����
      ��������� ������.

      Nr   - ��������� ������ ������ ������������:
      Nr=1 - ���������, �� E=const (����� �������� �
             ������ ���������� ���������, Xp[3]),
             R=const (=1e12 ��, ���������� ������� ��������� ���),
             ����� �������� ����������� ���� �������� �0;
      Nr=2 - E=const, ����������� �0 �� R;
      Nr=3 - ���'������ �� ��� ��������� (�������
             ��������� �������);
      Nr=4 - R=const (1e12 ��), ����������� �������� � �� �0

      eps  - ��������, �� ����� ����� �� ���� �������
             ���� �0 � ������ ��������� (������� ����������
             �������)

      ��   - ������ ���������� ���������

      �r   - ������, ���� ���������� ����������

      rez=0 - ������� ������� ���������
      rez=-1 - �������������� �� �������}
     Procedure ExpKalk(D: TDiapazon;
                        Rs: Double; DD: TDiod_Schottky;
                        Xp: IRE; var n: Double; var I0:
                        Double; var Fb: Double);
      {�� ����� ����� � Vector ������
      ������������ ��� �� �������� I=I0(exp(V/nkT)-1)+V/R
      (� ����������� ��������, �������� � D), ������� ��������
      ����������� ����������� n,
      ������ ��������� �0
      ������ ���'��� Fb;
      ��� �������� ��� ��������
      Rs - ���������� ���,
      ��   - ������ ���������� ���������
      ��� ���������� Fb - ��������� ����}

   end;


Function Kub (x:double;coef:array of double):double;overload;
{������� coef[0]+coef[1]*(x-coef[4])+
                  coef[2]*(x-coef[4])^2+
                  coef[3]*(x-coef[4])^3;
�������, �������, ��� ����������� �������}

Function Kub(x:double;
             Point:TPointDouble;
             SplainCoef:TSplainCoef):double;overload;

Procedure SplainCoefCalculate(V:TVectorNew;var SplainCoef:TSplainCoefArray);
{�������������� ����������� �������� ��� ������������ ����� � Vector}

//Function DerivateLagr(x,x1,x2,x3,y1,y2,y3:double):double;
Function DerivateLagr(x:double;Point1,Point2,Point3:TPointDouble):double;overload;
  {�������� ������� ��� ����������� ������� -
  ������� �� ������� ��������, ����������� �����
  ��� �����}
Function DerivateLagr(Point1,Point2,Point3:TPointDouble):double;overload;
{� ���������� �����}

Function DerivateTwoPoint(Point1,Point2:TPointDouble):double;


implementation

uses
  Math, Dialogs, SysUtils, OlegMathNew;




{ TVectorManipulation }

constructor TVectorManipulation.Create(ExternalVector: TVectorNew);
begin
//  inherited Create;
//  fVector:=TVectorNew.Create;
  Create();
  SetVector(ExternalVector);
end;

constructor TVectorManipulation.Create;
begin
  inherited Create;
  fVector:=TVectorNew.Create;
end;

procedure TVectorManipulation.Free;
begin
 fVector.Free;
 inherited Free;
end;

//function TVectorManipulation.GetVector: TVectorNew;
//begin
//// Result:=TVectorNew.Create;
//// Result.Clear;
// fVector.Copy(Result);
//end;

procedure TVectorManipulation.SetVector(const Value: TVectorNew);
begin
 Value.Copy(fVector);
end;


{ TVectorTransform }

function TVectorTransform.MaximumCount: integer;
 var i:integer;
begin
  if Vector.Count<3 then
     begin
       Result:=ErResult;
       Exit;
     end;
  Result:=0;
  for i:=1 to Vector.HighNumber-1 do
   if (Vector.Y[i]>Vector.Y[i-1])
       and(Vector.Y[i]>Vector.Y[i+1])
          then inc(Result);
end;

procedure TVectorTransform.Median(var Target: TVectorNew);
  var i:integer;
begin
  InitTarget(Target);
  if Vector.Count<3 then Exit;
  Vector.Copy(Target);
  for i:=1 to Target.HighNumber-1 do
    Target.y[i]:=MedianFiltr(Vector.y[i-1],Vector.y[i],Vector.y[i+1]);;
end;

procedure TVectorTransform.MikhAlpha_Fun(var Target: TVectorNew);
 var i:word;
     temp:TVectorTransform;
     verytemp:TVectorNew;
begin
 InitTargetToFun(Target);
 if Target.Count=0 then Exit;
 verytemp:=TVectorNew.Create;
 InitTargetToFun(verytemp);

 temp:=TVectorTransform.Create(verytemp);
 verytemp.Free;
 for I := 0 to Target.HighNumber do
   begin
     temp.Vector.X[i]:=ln(Vector.X[i+Target.N_begin]);
     temp.Vector.Y[i]:=ln(Vector.Y[i+Target.N_begin]);
   end;
{� temp ������� ln I = f(ln V)}

 for I := 0 to Target.HighNumber do
   begin
     Target.Y[i]:=temp.DerivateAtPoint(i);;
     Target.X[i]:=Vector.X[i+Target.N_begin];
   end;
 temp.Free;
 if Target.Count<3 then
         begin
           Target.Clear;
           Exit;
         end;

  repeat
  if Target.Y[0]>Target.Y[1] then
    begin
      Target.DeletePoint(0);
      Target.N_begin:=Target.N_begin+1;
      if Target.Count<3 then
               begin
                 Target.Clear;
                 Exit;
               end;
    end
                  else Break;
  until false;

  i:=0;
  repeat
  if Target.Y[i]<=0 then
    begin
      Target.DeletePoint(i);
      Target.N_begin:=Target.N_begin+1;
      if Target.Count<3 then
               begin
                 Target.Clear;
                 Exit;
               end;
    end;
  Inc(i);
  until (i>=Target.Count);
end;

procedure TVectorTransform.MikhBetta_Fun(var Target: TVectorNew);
var temp:TVectorTransform;
    i:word;
begin
  MikhAlpha_Fun(Target);
  if Target.Count=0 then Exit;
  temp:=TVectorTransform.Create(Target);
  temp.Itself(temp.Smoothing);
  for I := 0 to Target.HighNumber do
     begin
       temp.Vector.X[i]:=ln(temp.Vector.X[i]);
       temp.Vector.Y[i]:=ln(temp.Vector.Y[i]);
     end;
  {� temp ������� ln Aipha = f(ln V)}
  for I := 0 to Target.HighNumber do Target.Y[i]:=temp.DerivateAtPoint(i);
  temp.Vector:=Target;
  temp.Itself(temp.Smoothing);
  temp.Itself(temp.Smoothing);
  temp.Vector.Copy(Target);
  temp.Free;

end;

procedure TVectorTransform.MikhKalk;
begin
  MikhKalk(GraphParameters.Diapazon,Diod,
           GraphParameters.Rs,GraphParameters.n,
           GraphParameters.I0,GraphParameters.Fb)
end;

procedure TVectorTransform.MikhKalk(D: TDiapazon; DD: TDiod_Schottky; out Rs, n,
  I0, Fb: Double);
 var temp1,temp2:TVectorTransform;
     Alpha_m,Vm,Im:double;
begin
 Rs:=ErResult;
 n:=ErResult;
 Fb:=ErResult;
 I0:=ErResult;

//QueryPerformanceCounter(StartValue);

  temp1:=TVectorTransform.Create;
  MikhAlpha_Fun(temp1.fVector);
  { � temp1 �lpha-������� ̳�������,
  ���������� �� ��� [�������] ������ �}
  if temp1.Vector.IsEmpty then
              begin
               temp1.Free;
               Exit;
              end;
  temp2:=TVectorTransform.Create;
  temp1.CopyDiapazonPoint(temp2.fVector,D,Vector);
  {� temp2 ���� � ����� � temp1, ���
  ���� ������� ����� � ������ �
  ����������� ����� D }
  if temp2.Vector.Count<3 then
            begin
             temp1.Free;
             temp2.Free;
             Exit;
            end;

  repeat
    if temp2.MaximumCount<2 then Break;
    temp2.Median(temp1.fVector);
    temp1.Smoothing(temp2.fVector);
  until False;

  Vm:=temp2.ExtremumXvalue;
  if Vm=ErResult then
            begin
             temp1.Free;
             temp2.Free;
             Exit;
            end;
  Alpha_m:=temp2.Vector.Yvalue(Vm);
  Im:=Vector.Yvalue(Vm);
  Rs:=Vm/Im/sqr(Alpha_m);
  I0:=Im*exp(-Alpha_m-1);
  if Vector.T>0 then
     begin
     n:=Vm*(Alpha_m-1)/Kb/Vector.T/sqr(Alpha_m);
     Fb:=Kb*Vector.T*(Alpha_m+1)+DD.Fb(Vector.T,Im);
     end;
 temp1.Free;
 temp2.Free;

  //QueryPerformanceCounter(EndValue);
  //QueryPerformanceFrequency(Freq);
  //showmessage('tics='+inttostr(EndValue-StartValue)+#10+#13+
  //             'time='+floattostr((EndValue-StartValue)/Freq)
  //             +' s');
end;

procedure TVectorTransform.MikhN_Fun(var Target: TVectorNew);
var bet:TVectorNew;
    i:word;
begin
//  InitTarget(Target);
//  if Target.T=0 then Exit;

  MikhAlpha_Fun(Target);
  if Target.T=0 then Exit;
  if Target.Count=0 then Exit;

  bet:=TVectorNew.Create;
  MikhBetta_Fun(bet);
  for I := 0 to Target.HighNumber do
    Target.Y[i]:=Target.X[i]*(Target.Y[i]-1)*(1+bet.Y[i]/(Target.Y[i]-1))/Kb/Target.T/sqr(Target.Y[i]);

  bet.Free;

end;

procedure TVectorTransform.MikhRs_Fun(var Target: TVectorNew);
var bet:TVectorNew;
    i:word;
begin
  MikhAlpha_Fun(Target);
  if Target.Count=0 then Exit;
  MikhBetta_Fun(bet);
  for I := 0 to Target.HighNumber do
    Target.Y[i]:=Target.X[i]*(1-bet.Y[i])/Vector.Y[i+Target.N_begin]/sqr(Target.Y[i]);
  bet.Free;
end;

procedure TVectorTransform.Module(Coord: TCoord_type; var Target: TVectorNew);
 var i:integer;
begin
 InitTarget(Target);
 for I := 0 to Vector.Count-1 do
     if Vector.Point[i][Coord]=0
       then
       else
         begin
         Target.Add(Vector[i]);
         if Coord=cX then Target.X[Target.Count-1]:=Abs(Target.X[Target.Count-1]);
         if Coord=cY then Target.Y[Target.Count-1]:=Abs(Target.Y[Target.Count-1]);
         end;
end;

procedure TVectorTransform.M_V_Fun(var Target: TVectorNew;
  ForForwardBranch: boolean; tg: TGraph);
var temp:TVectorTransform;
    i:integer;
begin
 InitTargetToFun(Target);
 temp:=TVectorTransform.Create();
 if ForForwardBranch then PositiveX(temp.fVector)
                     else ReverseIV(temp.fVector);
 if temp.Vector.Count=0 then Exit;
 i:=0;
 repeat
   try
    case tg of
     fnPowerIndex:  //  m=d(ln I)/d(ln V) = f (V)
      begin
       temp.Vector.X[i]:=ln(temp.Vector.X[i]);
       temp.Vector.Y[i]:=ln(temp.Vector.Y[i]);
      end;
     fnFowlerNordheim:  // ln(I/V^2)=f(1/V)
      begin
       temp.Vector.Y[i]:=ln(temp.Vector.Y[i]/sqr(temp.Vector.X[i]));
       temp.Vector.X[i]:=1/temp.Vector.X[i];
      end;
     fnFowlerNordheimEm: // ln(I/V)=f(1/V^0.5)
      begin
       temp.Vector.Y[i]:=ln(temp.Vector.Y[i]/temp.Vector.X[i]);
       temp.Vector.X[i]:=1/sqrt(temp.Vector.X[i]);
      end;
     fnAbeles: // ln(I/V)=f(1/V)
      begin
       temp.Vector.Y[i]:=ln(temp.Vector.Y[i]/temp.Vector.X[i]);
       temp.Vector.X[i]:=1/temp.Vector.X[i];
      end;
     fnAbelesEm: // ln(I/V^0.5)=f(1/V^0.5)
      begin
       temp.Vector.X[i]:=1/sqrt(temp.Vector.X[i]);
       temp.Vector.Y[i]:=ln(temp.Vector.Y[i]*temp.Vector.X[i]);
      end;
     fnFrenkelPool: // ln(I/V)=f(V^0.5)
      begin
       temp.Vector.Y[i]:=ln(temp.Vector.Y[i]/temp.Vector.X[i]);
       temp.Vector.X[i]:=sqrt(temp.Vector.X[i]);
      end;
     fnFrenkelPoolEm: // ln(I/V^0.5)=f(V^0.25)
      begin
       temp.Vector.Y[i]:=ln(temp.Vector.Y[i]/sqrt(temp.Vector.X[i]));
       temp.Vector.X[i]:=sqrt(sqrt(temp.Vector.X[i]));
      end;
    end; //case
  Except
   Temp.Vector.DeletePoint(i);
   i:=i-1;
   end;  //try
  inc(i);
 until (i>temp.Vector.HighNumber);

 if temp.Vector.Count=0 then Exit;

 case tg of
   fnPowerIndex:
    begin
     temp.Derivate(Target);
     for i:=0 to Target.HighNumber do
        Target.X[i]:=exp(Target.X[i]);
    end;
  fnFowlerNordheim..fnFrenkelPoolEm: temp.Vector.Copy(Target);
 end; // case
end;

procedure TVectorTransform.AbsX(var Target: TVectorNew);
begin
  Module(cX,Target);
end;

procedure TVectorTransform.AbsY(var Target: TVectorNew);
begin
 Module(cY,Target);
end;

procedure TVectorTransform.Branch(Coord: TCoord_type; var Target: TVectorNew;
                const IsPositive:boolean=True;
                const IsRigorous:boolean=True);
//  var i:integer;
//begin
// InitTarget(Target);
// for I := 0 to Vector.Count-1 do
//   if (IsPositive) then
//      begin
//       if(Vector[i][Coord]>=0) then Target.Add(Vector[i])
//      end          else
//      if(Vector[i][Coord]<0) then Target.Add(Vector[i]);
//end;
 function SuitablePoint(Value:double):boolean;
  begin
   if IsPositive then
      begin
        if IsRigorous then Result:=(Value>0)
                      else Result:=(Value>=0)
      end        else
      begin
        if IsRigorous then Result:=(Value<0)
                      else Result:=(Value<=0)
      end;

  end;
 var i,N_begin:integer;

begin
 InitTarget(Target);
 N_begin:=-1;
 for I := 0 to Vector.Count-1 do
  if SuitablePoint(Vector[i][Coord]) then
    begin
      Target.Add(Vector[i]);
      if N_begin<0 then N_begin:=i
    end;
 if N_begin>=0 then Target.N_begin:=Cardinal(N_begin);
end;

procedure TVectorTransform.ChungFun(var Target: TVectorNew);
 var i:word;
     temp:TVectorTransform;
begin
 InitTargetToFun(Target);
 temp:=TVectorTransform.Create();
 temp.Vector.SetLenVector(Target.Count);
 for I := 0 to Target.HighNumber do
   begin
     temp.Vector.X[i]:=ln(Vector.Y[i+Target.N_begin]);
     temp.Vector.Y[i]:=Vector.X[i+Target.N_begin];
   end;
  for I := 0 to Target.HighNumber do
   begin
//     Target.X[i]:=exp(temp.Vector.x[i]);
     Target.X[i]:=Vector.Y[i+Target.N_begin];
     Target.Y[i]:=temp.DerivateAtPoint(i);
   end;
 temp.Free;

 Target.N_begin:=Target.N_begin+Vector.N_begin;
end;

procedure TVectorTransform.ChungKalk;
begin
  ChungKalk(GraphParameters.Diapazon,
            GraphParameters.Rs,GraphParameters.n);
end;

procedure TVectorTransform.ChungKalk(D: TDiapazon; out Rs, n: double);
  var temp1, temp2:TVectorTransform;
      OutputData:TArrSingle;
begin
  Rs:=ErResult;
  n:=ErResult;
  temp1:=TVectorTransform.Create;
  ChungFun(temp1.fVector);         // � temp1 ����� ������� �����
  if temp1.Vector.IsEmpty then
               begin
                 temp1.Free;
                 Exit;
               end;
  temp2:=TVectorTransform.Create;
  temp1.CopyDiapazonPoint(temp2.fVector,D,Vector);
  if temp2.Vector.Count<2 then
            begin
             temp1.Free;
             temp2.Free;
             Exit;
            end;
    {� temp2 ����� ������� ������� �����
    (���� ����� ������� �������)}
  temp2.LinAprox(OutputData);
  Rs:=OutputData[1];
  if Vector.T<=0 then n:=ErResult
                 else n:=OutputData[0]/Kb/Vector.T;
  temp1.Free;
  temp2.Free;
end;

procedure TVectorTransform.CibilsFun(var Target: TVectorNew; D: TDiapazon);
//������� �� ������ �������� ���� ���� Va ���������� ���������
var Va:double;
    tp:TVectorNew;
    temp,temp2:TVectorTransform;
begin
  InitTarget(Target);
  Va:=round(1000*(Kb*Vector.T+0.004))/1000;
  if Va<0.01 then Va:=0.015;

  temp:=TVectorTransform.Create;
  temp2:=TVectorTransform.Create;
  tp:=TVectorNew.Create;


  repeat
   Self.CibilsFunDod(tp,Va);
   tp.Copy(temp.Vector);
   {� temp ������� F(V)=V-Va*ln(I), ����������
   �� ��� [�������] ��������� � Vector}

   if tp.Count=0 then Break;

   temp.CopyDiapazonPoint(tp,D,Self.Vector);
   tp.Copy(temp2.Vector);
   if temp2.Vector.Count=0 then
            begin
             temp.Free;
             temp2.Free;
             tp.Free;
             Exit;
            end;
   {� temp2 - ������� ������� F(V)=V-Va*ln(I), ���
   ����������� ������ � D}


   if temp2.Vector.Count<3 then Break;
   if (temp2.DerivateAtPoint(2)*temp2.DerivateAtPoint(temp2.Vector.HighNumber-2))>0 then Break;

   Target.Add(Va,Vector.Yvalue(temp2.ExtremumXvalue));
   Va:=Va+0.001;
   if Va>Vector.X[temp.Vector.N_begin+temp.Vector.HighNumber] then Break;
  until false;


  if Target.Count<2 then Target.Clear;

  temp.Free;
  temp2.Free;
  tp.Free;
end;

procedure TVectorTransform.CibilsFunDod(var Target: TVectorNew; Va: double);
 var i:word;
begin
 InitTargetToFun(Target);
 if Target.Count=0 then Exit;

  for I := 0 to Target.HighNumber do
   begin
     Target.X[i]:=Vector.X[i+Target.N_begin];
     Target.Y[i]:=Vector.X[i+Target.N_begin]-Va*ln(Vector.Y[i+Target.N_begin]);
   end;

  Target.N_begin:=Target.N_begin+Vector.N_begin;
end;

procedure TVectorTransform.CibilsKalk;
begin
 CibilsKalk(GraphParameters.Diapazon,
             GraphParameters.Rs,GraphParameters.n);
end;

procedure TVectorTransform.CibilsKalk(const D: TDiapazon; out Rs, n: double);
  var temp1:TVectorTransform;
      outputData:TArrSingle;
begin
  Rs:=ErResult;
  n:=ErResult;
  temp1:=TVectorTransform.Create;
  CibilsFun(temp1.fVector,D);
  if temp1.Vector.Count<2 then
                begin
                temp1.Free;
                Exit;
                end;
  temp1.LinAprox(outputData);
  Rs:=1/outputData[1];
  if Vector.T>0 then n:=-outputData[0]/outputData[1]/Kb/Vector.T;
  temp1.Free;
end;

procedure TVectorTransform.CopyDiapazonPoint(var Target: TVectorNew;
                      D: TDiapazon; InitVector: TVectorNew);
 var i,j:integer;
begin
 InitTarget(Target);
 Target.T:=InitVector.T;
 j:=-1;
 for I := 0 to Vector.HighNumber do
   if InitVector.PointInDiapazon(D,i+Vector.N_begin)
     then
      begin
      if j<0 then
         begin
           j:=0;
           Target.N_begin:=Target.N_begin+i;
         end;
      Target.Add(Vector[i]);
      end;
end;

procedure TVectorTransform.CopyDiapazonPoint(var Target: TVectorNew;
  D: TDiapazon);
begin
 CopyDiapazonPoint(Target,D,Self.Vector);
end;

procedure TVectorTransform.CopyDiapazonPoint(var Target: TVectorNew;
  Lim: Limits; InitVector: TVectorNew);
 var i,j:integer;
begin
 InitTarget(Target);
 Target.T:=InitVector.T;
 j:=-1;
 for I := 0 to Vector.HighNumber do
   if InitVector.PointInDiapazon(Lim,i+Vector.N_begin)
     then
      begin
      if j<0 then
         begin
           j:=0;
           Target.N_begin:=Target.N_begin+i;
         end;
      Target.Add(Vector[i]);
      end;
end;

procedure TVectorTransform.CopyLimited(Coord: TCoord_type;
           var Target: TVectorNew; Clim1, Clim2: double);
 var i:integer;
     Cmin,Cmax:double;
begin
  if Clim1>Clim2 then
      begin
        Cmax:=Clim1;
        Cmin:=Clim2;
      end        else
      begin
        Cmax:=Clim2;
        Cmin:=Clim1;
      end;
  InitTarget(Target);
  for I := 0 to Vector.Count-1 do
    if (Vector[i][Coord]>=Cmin)and(Vector[i][Coord]<=Cmax) then
       Target.Add(Vector[i]);
end;

procedure TVectorTransform.CopyLimitedX(var Target: TVectorNew; Xmin, Xmax: double);
begin
 CopyLimited(cX,Target,Xmin, Xmax);
end;

procedure TVectorTransform.CopyLimitedY(var Target: TVectorNew; Ymin,
  Ymax: double);
begin
 CopyLimited(cY,Target,Ymin, Ymax);
end;

function TVectorTransform.DerivateAtPoint(PointNumber: integer): double;
begin
 Result:=ErResult;
 try
  if PointNumber=0
    then Result:=DerivateTwoPoint(Vector[1],Vector[0]);
  if PointNumber=Vector.HighNumber
    then Result:=DerivateTwoPoint(Vector[Vector.HighNumber],Vector[Vector.HighNumber-1]);
  if (PointNumber>0)and(PointNumber<Vector.HighNumber)
     then Result:=DerivateLagr(Vector[PointNumber-1],Vector[PointNumber],Vector[PointNumber+1]);
 except

 end;
end;

procedure TVectorTransform.Dit_Fun(var Target: TVectorNew; Rs: Double;
  DD: TDiod_Schottky; D: TDiapazon);
var i:integer;
    Vs,Vcal,del,Fb:double;
    temp:TVectorTransform;
//    aproxData:TArrSingle;
begin
  InitTarget(Target);

  if (Rs=ErResult)then Exit;
  Self.IvanovKalk(D, Rs, DD, del, Fb);
  if (Fb=ErResult)or(del<=0) then Exit;
  temp:=TVectorTransform.Create;
  CopyDiapazonPoint(temp.fVector,D);
  if temp.Vector.IsEmpty then
            begin
            temp.Free;
            Exit;
            end;

  for I := 0 to temp.Vector.HighNumber do
    begin
     Vs:=Fb-DD.Fb(Vector.T,temp.Vector.Y[i]);
     Vcal:=Vs+Rs*temp.Vector.Y[i]+
           del*sqrt(2*Qelem*DD.Semiconductor.Nd*DD.Semiconductor.Material.Eps/Eps0)*(sqrt(Fb)-sqrt(Fb-Vs));
     temp.Vector.Y[i]:=Vcal-temp.Vector.X[i];
     temp.Vector.X[i]:=Vs;
    end;

  temp.Itself(temp.Derivate);
  temp.PositiveY(Target);

  temp.Free;

  if Target.Count<2 then
       begin
         Target.Clear;
         Exit;
       end;
  for I := 0 to Target.HighNumber do
   begin
    Target.Y[i]:=Target.Y[i]*Eps0/del/Qelem;
    Target.X[i]:=Fb-Target.X[i];
   end;
end;

procedure TVectorTransform.ExKalk(Index: Integer);
begin
  ExKalk(Index,GraphParameters.Diapazon,
         GraphParameters.Rs,Diod,GraphParameters.n,
         GraphParameters.I0,GraphParameters.Fb)
end;

procedure TVectorTransform.ExKalk(Index: Integer; D: TDiapazon; Rs: Double;
                       DD: TDiod_Schottky; out n, I0, Fb: Double);
 var temp1,temp2:TVectorTransform;
    i:integer;
    outputData:TArrSingle;
begin
  n:=ErResult;
  Fb:=ErResult;
  I0:=ErResult;
  if (Rs=ErResult)
     or(DD.Semiconductor.ARich=ErResult)
     or(DD.Area=ErResult)
     or(Vector.T<=0)  then Exit;

  temp2:=TVectorTransform.Create;
  case Index of
     1:ForwardIVwithRs(temp2.fVector,Rs);
     2:Forward2Exp(temp2.fVector,Rs);
     3:Reverse2Exp(temp2.fVector,Rs);
   end;//case
  if temp2.Vector.IsEmpty then
                 begin
                  temp2.Free;
                  Exit;
                 end;
  temp1:=TVectorTransform.Create;
  temp2.CopyDiapazonPoint(temp1.fVector,D,Vector);
  temp2.Free;
  if temp1.Vector.Count<2 then
      begin
        temp1.Free;
        Exit;
      end;
  for I := 0 to temp1.Vector.HighNumber do
     temp1.Vector.Y[i]:=ln(temp1.Vector.Y[i]);

   {� temp1 ����� ������� BAX � �����������������
   ������� � ����������� Rs (���� ����� ������� �������)}
  temp1.LinAprox(outputData);
  I0:=exp(outputData[0]);
  n:=1/(Kb*Vector.T*outputData[1]);
  if Index=3 then n:=-n;
  Fb:=DD.Fb(Vector.T,I0);
  temp1.Free;
end;

function TVectorTransform.ExtremumXvalue: double;
 var temp:TVectorNew;
begin
  temp:=TVectorNew.Create;
  Self.Derivate(temp);
  Result:=temp.Xvalue(0);
  if (Result>Vector.MaxX)or(Result<Vector.MinX)
     then result:=ErResult;
  temp.Free;
end;

procedure TVectorTransform.Derivate(var Target: TVectorNew);
var i:integer;
begin
 InitTarget(Target);
 if Vector.Count<3 then Exit;
 Vector.Copy(Target);
 for i:=0 to Vector.HighNumber do
   Target.Y[i]:=DerivateAtPoint(i);
end;

procedure TVectorTransform.Forward2Exp(var Target: TVectorNew; Rs: double);
 var i:integer;
begin
 InitTarget(Target);
 if (Rs=ErResult) or (Vector.T<=0) then Exit;
 ForwardIVwithRs(Target,Rs);
 for i:=0 to Target.HighNumber do
   Target.Y[i]:=Target.Y[i]/(1-exp(-Target.X[i]/Kb/Target.T));
end;

procedure TVectorTransform.ForwardIVwithRs(var Target: TVectorNew; Rs: double);
 var i:integer;
     temp:double;
begin
  InitTarget(Target);
  if Rs=ErResult then Exit;

  Target.N_begin:=-1;
  for i:=0 to Vector.HighNumber do
     begin
     temp:=Vector.X[i]-Rs*Vector.Y[i];
     if (temp>0)and(Vector.X[i]>0) then
       begin
         if Target.N_begin<0 then
               begin
                Target.N_begin:=i;
                Target.Add(temp,Vector.Y[i]);
                Continue;
               end;
         if temp>=Target.X[Target.HighNumber] then
               begin
                Target.Add(temp,Vector.Y[i]);
                Continue;
               end;
           Break;
       end;
     end;
end;

procedure TVectorTransform.ForwardX(var Target: TVectorNew);
begin
  Branch(cX,Target,true,false);
end;

procedure TVectorTransform.ForwardY(var Target: TVectorNew);
begin
  Branch(cy,Target,true,false);
end;

procedure TVectorTransform.Gr1_Fun(var Target: TVectorNew);
begin
 InitTarget(Target);
 PositiveX(Target);
 Target.SwapXY;
end;

procedure TVectorTransform.Gr2_Fun(var Target: TVectorNew; DD: TDiod_Schottky);
 var i:integer;
begin
 NordeFun(Target,DD,2);
 for i:=0 to Target.HighNumber do Target.X[i]:=Vector.Y[i+Target.N_begin];
 {��������, ��������� ���� �������� ���� � �������,
 ���� � � ����������� �������� ����, ��� ����� �^.N_begin=0}
end;

function TVectorTransform.GromovAprox(var OutputData: TArrSingle):boolean;
var R:PSysEquation;
    i:integer;
begin
  Result:=False;
  InitArrSingle(OutputData,3);
//  if High(OutputData)<2 then SetLength(OutputData,3);
//
//  OutputData[0]:=ErResult;
//  OutputData[1]:=ErResult;
//  OutputData[2]:=ErResult;

  for I:=0 to Vector.HighNumber do
    if Vector.X[i]<0 then Exit;

  new(R);
  R^.SetLengthSys(3);
  R^.Clear;

  R^.A[0,0]:=Vector.Count;
  for i:=0 to Vector.HighNumber do
   begin
     R^.A[0,1]:=R^.A[0,1]+Vector.X[i];
     R^.A[0,2]:=R^.A[0,2]+ln(Vector.X[i]);
     R^.A[1,1]:=R^.A[1,1]+Vector.X[i]*Vector.X[i];
     R^.A[1,2]:=R^.A[1,2]+Vector.X[i]*ln(Vector.X[i]);
     R^.A[2,2]:=R^.A[2,2]+ln(Vector.X[i])*ln(Vector.X[i]);
     R^.f[0]:=R^.f[0]+Vector.Y[i];
     R^.f[1]:=R^.f[1]+Vector.Y[i]*Vector.X[i];
     R^.f[2]:=R^.f[2]+Vector.Y[i]*ln(Vector.X[i]);
   end;
  R^.A[1,0]:=R^.A[0,1];
  R^.A[2,0]:=R^.A[0,2];
  R^.A[2,1]:=R^.A[1,2];

  GausGol(R);
  if R^.N=ErResult then Exit;

  OutputData[0]:=R^.x[0];
  OutputData[1]:=R^.x[1];
  OutputData[2]:=R^.x[2];
  dispose(R);
  Result:=True;
end;

procedure TVectorTransform.HFun(var Target: TVectorNew; DD: TDiod_Schottky;
                                N: Double);
 var i:word;
begin
  InitTargetToFun(Target);
  if (n=ErResult)or
     (Vector.T<=0)or
      (Target.Count=0) then Exit;

  for I := 0 to Target.HighNumber do
     begin
       Target.X[i]:=Vector.Y[i+Target.N_begin];
       Target.Y[i]:=Vector.X[i+Target.N_begin]+N*DD.Fb(Target.T,Vector.Y[i+Target.N_begin]);
     end;

    Target.N_begin:=Target.N_begin+Vector.N_begin;
end;



procedure TVectorTransform.HFunKalk;
begin
 HFunKalk(GraphParameters.Diapazon,Diod,
         GraphParameters.n,GraphParameters.Rs,
         GraphParameters.Fb);
end;

procedure TVectorTransform.HFunKalk(D: TDiapazon; DD: TDiod_Schottky; N: Double;
  out Rs, Fb: Double);
  var temp1, temp2:TVectorTransform;
      OutputData:TArrSingle;
begin
  Rs:=ErResult;
  Fb:=ErResult;
  if N=ErResult then Exit;

  temp1:=TVectorTransform.Create;
  HFun(temp1.fVector,DD,N);         // � temp1 ����� H-�������
  if temp1.Vector.IsEmpty then
              begin
               temp1.Free;
               Exit;
              end;

  temp2:=TVectorTransform.Create;
  temp1.CopyDiapazonPoint(temp2.fVector,D,Vector);
  if temp2.Vector.Count<2 then
            begin
             temp1.Free;
             temp2.Free;
             Exit;
            end;
    {� temp2 ����� ������� H-�������
    (���� ����� ������� �������)}
  temp2.LinAprox(OutputData);
  Rs:=OutputData[1];
  Fb:=OutputData[0]/N;
  temp1.Free;
  temp2.Free;
end;

procedure TVectorTransform.ImNoiseSmoothedArray(Target: TVectorNew;
                            Npoint: Word);
 var TG:TVectorTransform;
     CountTargetElement,i:integer;
     j:Word;
begin
 InitTarget(Target);
 if Vector.Count<1 then Exit;

 if Npoint=0 then Npoint:=Trunc(sqrt(Vector.Count+1));
 if Npoint=0 then Exit;

 CountTargetElement:=Vector.Count div Npoint;
 if CountTargetElement=0
  then
   begin
   Target.Add(Self.ImpulseNoiseSmoothing(cX),Self.ImpulseNoiseSmoothing(cY));
   Exit;
   end;

 Target.SetLenVector(CountTargetElement);

  TG:=TVectorTransform.Create();
  TG.Vector.SetLenVector(Npoint);
  for I := 0 to CountTargetElement - 2 do
   begin
     for j := 0 to Npoint - 1 do
       begin
        TG.Vector.X[j]:=Self.Vector.X[I*Npoint+j];
        TG.Vector.Y[j]:=Self.Vector.Y[I*Npoint+j];
       end;
     Target.X[I]:=TG.ImpulseNoiseSmoothing(cX);
     Target.Y[I]:=TG.ImpulseNoiseSmoothing(cY);
   end;

  I:=Vector.Count mod Npoint;
  TG.Vector.SetLenVector(I+Npoint);
  for j := 0 to Npoint+I-1 do
   begin
    TG.Vector.X[j]:=Self.Vector.X[(CountTargetElement - 1)*Npoint+j];
    TG.Vector.Y[j]:=Self.Vector.Y[(CountTargetElement - 1)*Npoint+j];
   end;

  Target.X[CountTargetElement - 1]:=TG.ImpulseNoiseSmoothing(cX);
  Target.Y[CountTargetElement - 1]:=TG.ImpulseNoiseSmoothing(cY);

  TG.Free;

end;

function TVectorTransform.ImpulseNoiseSmoothing(
                   const Coord: TCoord_type): Double;
 var i_min,i_max,j,PositivDeviationCount,NegativeDeviationCount:integer;
     PositivDeviation,Value_Mean:double;
     tempVector:TVectorNew;
begin

  if Vector.Count<1 then
    begin
      Result:=ErResult;
      Exit;
    end;
  if Vector.Count<5 then
    begin
      Result:=Vector.MeanValue(Coord);
      Exit;
    end;

  i_min:=Vector.MinNumber(Coord);
  i_max:=Vector.MaxNumber(Coord);

 tempVector:=TVectorNew.Create;
 Vector.Copy(tempVector);
 if i_min=i_max then TempVector.DeletePoint(i_min)
                else
                 begin
                  TempVector.DeletePoint(max(i_min,i_max));
                  TempVector.DeletePoint(min(i_min,i_max));
                 end;

 Value_Mean:=tempVector.MeanValue(Coord);
 PositivDeviationCount:=0;
 NegativeDeviationCount:=0;
 PositivDeviation:=0;
 for j := 0 to tempVector.HighNumber do
  begin
   if tempVector[j][Coord]>Value_Mean then
    begin
      inc(PositivDeviationCount);
      PositivDeviation:=PositivDeviation+(tempVector[j][Coord]-Value_Mean);
    end;
   if tempVector[j][Coord]<Value_Mean then
      inc(NegativeDeviationCount);
  end;

 Result:=Value_Mean+
        (PositivDeviationCount-NegativeDeviationCount)
        *PositivDeviation/sqr(tempVector.HighNumber+1);
  tempVector.Free;
end;

function TVectorTransform.ImpulseNoiseSmoothingByNpoint(
           const Coord: TCoord_type; Npoint: Word): Double;
 var temp:TVectorTransform;
begin
 Result:=ErResult;
 if Vector.Count<1 then Exit;

 if Npoint=0 then Npoint:=Trunc(sqrt(Vector.Count+1));
 if Npoint=0 then Exit;


 temp:=TVectorTransform.Create;


 Self.ImNoiseSmoothedArray(temp.Vector, Npoint);
 if temp.Vector.Count=1
  then Result:=temp.Vector.Point[0][Coord]
  else Result:=temp.ImpulseNoiseSmoothingByNpoint(Coord,Npoint);
 temp.Free;

end;

procedure TVectorTransform.InitArrSingle(var OutputData: TArrSingle;
  NumberOfData: word);
  var i:word;
begin
 if High(OutputData)<(NumberOfData-1) then SetLength(OutputData,NumberOfData);
 for i := 0 to High(OutputData)
    do OutputData[i]:=ErResult;
end;

procedure TVectorTransform.InitTarget(var Target: TVectorNew);
begin
  try
   Target.Clear
  except
   Target:=TVectorNew.Create;
  end;
  Target.T:=fVector.T;
  Target.name:=fVector.name;
  Target.N_begin:=fVector.N_begin;
end;

procedure TVectorTransform.InitTargetToFun(var Target: TVectorNew);
 var i,j,Nbegin:integer;
begin
 InitTarget(Target);
 j:=0;
 Nbegin:=-1;
 for I := 0 to Vector.HighNumber do
  if (Vector.X[i]>0.001) and (Vector.Y[i]>0) then
   begin
     inc(j);
     if Nbegin<0 then Nbegin:=i;
   end;
 if j>0 then
  begin
   Target.SetLenVector(j);
   Target.N_begin:=Nbegin;
  end;
end;

procedure TVectorTransform.InVectorToOut(var Target: TVectorNew;
                     Func: TFunDouble; TtokT1: boolean);
 var i:integer;
begin
 InitTarget(Target);
 try
   Target.SetLenVector(Vector.Count);
   for i := 0 to Target.HighNumber do
    begin
      if TtokT1 then Target.X[i]:=1/(Kb*Vector.X[i])
                else Target.X[i]:=Vector.X[i];
      Target.Y[i]:=Func(Vector.Y[i],Vector.X[i]);
    end;
 except
 Target.Clear();
 end;

end;

procedure TVectorTransform.Itself(ProcTarget: TProcTarget);
 var Target:TVectorNew;
begin
 Target:=TVectorNew.Create;
 ProcTarget(Target);
 Target.Copy(Self.Vector);
 Target.Free;
end;

function TVectorTransform.IvanovAprox(var OutputData: TArrSingle;
  DD: TDiod_Schottky; OutsideTemperature: Double): boolean;
var temp:TVectorNew;
    a,b,Temperature:double;
    i:integer;
    Param:array of double;
begin
 Result:=False;
 InitArrSingle(OutputData,2);
// del:=ErResult;
//  Fb:=ErResult;
  if OutsideTemperature=ErResult then Temperature:=Vector.T
                                 else Temperature:=OutsideTemperature;
  if (Temperature<=0)or(Vector.Count=0) then Exit;
  SetLength(Param,6);

  temp:=TVectorNew.Create;
  temp.SetLenVector(Vector.Count);
  try
  for I := 0 to temp.HighNumber do
    begin
     temp.X[i]:=1/Vector.X[i];
     temp.Y[i]:=sqrt(DD.Fb(Temperature,Vector.Y[i]));
    end;
  except
   temp.Free;
   Exit;
  end;//try

  Param[0]:=temp.Count;
  for i := 1 to 5 do Param[i]:=0;
  try
    for I := 0 to temp.HighNumber do
    begin
    Param[1]:=Param[1]+temp.X[i];
    Param[2]:=Param[2]+temp.X[i]*temp.Y[i];
    Param[3]:=Param[3]+temp.X[i]*sqr(temp.Y[i]);
    Param[4]:=Param[4]+temp.X[i]*temp.Y[i]*sqr(temp.Y[i]);
    Param[5]:=Param[5]+temp.Y[i];
    end;
    temp.Free;
  except
    temp.Free;
    Exit;
  end;//try

  try
  a:=(Param[2]*(Param[0]+Param[3])-Param[1]*(Param[5]+Param[4]))/(Param[3]*Param[1]-sqr(Param[2]));
  b:=(Param[3]*(Param[0]+Param[3])-Param[2]*(Param[5]+Param[4]))/(Param[3]*Param[1]-sqr(Param[2]));
  b:=(sqrt(sqr(a)+4*b)-a)/2;
  except
    Exit;
  end;
  OutputData[0]:=a/sqrt(2*Qelem*DD.Semiconductor.Nd*DD.Semiconductor.Material.Eps/Eps0);
  OutputData[1]:=sqr(b);
  Result:=True;
end;

procedure TVectorTransform.IvanovKalk;
begin
  IvanovKalk(GraphParameters.Diapazon,
             GraphParameters.Rs,Diod,
             GraphParameters.Krec,GraphParameters.Fb)
end;

procedure TVectorTransform.Kam1Kalk;
begin
 Kam1Kalk (GraphParameters.Diapazon,
           GraphParameters.Rs,GraphParameters.n)
end;

procedure TVectorTransform.Kam1Kalk(D: TDiapazon; out Rs, n: double);
  var temp1:TVectorTransform;
      outputData:TArrSingle;
begin
  temp1:=TVectorTransform.Create;

  Kam1_Fun(temp1.fVector,D);    // � temp1 ����� ������� �������� �-����
  if temp1.Vector.IsEmpty then
      begin
       Rs:=ErResult;
       n:=ErResult;
       temp1.Free;
       Exit;
      end;

  temp1.LinAprox(outputData);
  Rs:=outputData[1];
  if Vector.T<=0 then n:=ErResult
               else n:=outputData[0]/Kb/Vector.T;
  temp1.Free;
end;

procedure TVectorTransform.Kam1_Fun(var Target: TVectorNew; D: TDiapazon);
 var temp:TVectorTransform;
     i:integer;
begin
 InitTarget(Target);

 temp:=TVectorTransform.Create;
 Vector.Copy (temp.fVector);
 Target.SetLenVector(Vector.HighNumber);
 try
  for i:=0 to Target.HighNumber do
    begin
    Target.X[i]:=(temp.Vector.Y[0]+temp.Vector.Y[temp.Vector.HighNumber])/2;
    Target.Y[i]:=temp.Vector.Int_Trap/(temp.Vector.Y[temp.Vector.HighNumber]-temp.Vector.Y[0]);
    if temp.Vector.HighNumber>1 then temp.Vector.DeletePoint(0);
    end;
  except
    temp.Free;
    Target.Clear;
    Exit;
  end;

  Target.Sorting();
  Target.Copy(temp.fVector);
  temp.vector.N_Begin:=0;

  temp.CopyDiapazonPoint(Target,D);

  temp.Free;
end;

procedure TVectorTransform.Kam2Kalk;
begin
  Kam2Kalk(GraphParameters.Diapazon,
           GraphParameters.Rs,GraphParameters.n);
end;

procedure TVectorTransform.Kam2Kalk(const D: TDiapazon; out Rs, n: double);
  var temp1:TVectorTransform;
      outputData:TArrSingle;
begin
  Rs:=ErResult;
  n:=ErResult;

  temp1:=TVectorTransform.Create;
  Kam2_Fun(temp1.fVector,D);    // � temp1 ����� ������� �������� ��-����
  if temp1.Vector.Count<2 then
      begin
       temp1.Free;
       Exit;
      end;
  temp1.LinAprox(outputData);
  Rs:=-outputData[0]/outputData[1];

  if Vector.T>0 then n:=1/Kb/outputData[1]/Vector.T
                else n:=ErResult;
  temp1.Free;
end;

procedure TVectorTransform.Kam2_Fun(var Target: TVectorNew; D: TDiapazon);
var temp:TVectorNew;
    i,j,k:integer;
begin
 InitTarget(Target);
 temp:=TVectorNew.Create;
 Self.CopyDiapazonPoint(temp,D);
{� temp � ����� ������� �, �� ������������� D}

  if temp.IsEmpty then
               begin
               temp.Free;
               Exit;
               end;
  i:=round(temp.Count*(temp.Count-1)/2);

  Target.SetLenVector(i);

  k:=0;
  try
  for i:=0 to temp.HighNumber-1 do
    for j := i+1 to temp.HighNumber do
     begin
      Target.X[k]:=(temp.X[j]-temp.X[i])/(temp.Y[j]-temp.Y[i]);
      Target.Y[k]:=ln(temp.Y[j]/temp.Y[i])/(temp.Y[j]-temp.Y[i]);
      k:=k+1;
     end;
  except
    temp.Free;
    Target.Clear;
    Exit
  end;

  temp.Free;
  //���������� ������� ���������
  Target.Sorting();
end;

procedure TVectorTransform.IvanovKalk(D: TDiapazon; Rs: Double;
  DD: TDiod_Schottky; out del, Fb: Double);
 var temp,temp2:TVectorTransform;
     OutputData: TArrSingle;
begin
  del:=ErResult;
  Fb:=ErResult;
  if Rs=ErResult then Exit;
  temp:=TVectorTransform.Create();
    ForwardIVwithRs(temp.fVector,Rs);
  if temp.Vector.Count=0 then
      begin
        temp.Free;
        Exit;
      end;
  temp2:=TVectorTransform.Create();
  temp.CopyDiapazonPoint(temp2.fVector,D,Vector);
  if temp2.Vector.Count=0 then
      begin
        temp2.Free;
        temp.Free;
        Exit;
      end;
  temp2.IvanovAprox(OutputData,DD);
  del:=OutputData[0];
  Fb:=OutputData[1];
  temp2.Free;
  temp.Free;
end;

procedure TVectorTransform.LeeFun(var Target: TVectorNew; D: TDiapazon);
var Va:double;
    tp:TVectorNew;
    temp,temp2:TVectorTransform;
    GromovKoef:TArrSingle;
begin
  InitTarget(Target);
  Va:=round(100*(Kb*Vector.T+0.004))/100;

  temp:=TVectorTransform.Create;
  temp2:=TVectorTransform.Create;
  tp:=TVectorNew.Create;

  repeat
   Self.LeeFunDod(tp,Va);
   tp.Copy(temp.Vector);
  {� temp ������� F(I)=V-Va*ln(I), ����������
  �� ��� [�������] ��������� � ������� �}
   if tp.Count=0 then Break;



   temp.CopyDiapazonPoint(tp,D,Self.Vector);
   tp.Copy(temp2.Vector);
   if temp2.Vector.Count=0 then
            begin
             temp.Free;
             temp2.Free;
             tp.Free;
             Exit;
            end;
  {� temp2 - ������� ������� F(I)=V-Va*ln(I), ���
  ����������� ������ � D}
   if temp2.Vector.Count<3 then Break;


   SetLength(GromovKoef,3);
   GromovAprox(GromovKoef);

   if not(temp2.GromovAprox(GromovKoef)) then Break;

   Target.Add(Va,-GromovKoef[2]/GromovKoef[1]);
   Va:=Va+0.02;
   if Va>2*Vector.X[temp.Vector.N_begin+temp.Vector.HighNumber]
             then Break;
  until false;

  Target.T:=GromovKoef[0];

  if Target.Count<2 then Target.Clear;
  temp.Free;
  temp2.Free;
  tp.Free;
end;

procedure TVectorTransform.LeeFunDod(var Target: TVectorNew; Va: double);
 var i:word;
begin
 InitTargetToFun(Target);
 if Target.Count=0 then Exit;

 for I := 0 to Target.HighNumber do
     begin
       Target.X[i]:=Vector.Y[i+Target.N_begin];
       Target.Y[i]:=Vector.X[i+Target.N_begin]-Va*ln(Target.X[i]);
     end;
 Target.N_begin:=Target.N_begin+Vector.N_begin;
end;

function TVectorTransform.LinAprox(var OutputData: TArrSingle): boolean;
  var Sx,Sy,Sxy,Sx2:double;
      i:integer;
begin
  Result:=False;
  InitArrSingle(OutputData,2);
  Sx:=0;Sy:=0;Sxy:=0;Sx2:=0;
  for i:=0 to Vector.HighNumber do
     begin
     Sx:=Sx+Vector.x[i];
     Sy:=Sy+Vector.y[i];
     Sxy:=Sxy+Vector.x[i]*Vector.y[i];
     Sx2:=Sx2+Vector.x[i]*Vector.x[i];
     end;
  try
  OutputData[0]:=(Sx2*Sy-Sxy*Sx)/(Vector.Count*Sx2-Sx*Sx);
  OutputData[1]:=(Vector.Count*Sxy-Sy*Sx)/(Vector.Count*Sx2-Sx*Sx);
  except
   InitArrSingle(OutputData,2);
   Exit;
  end;
  Result:=True;
end;

procedure TVectorTransform.NegativeX(var Target: TVectorNew);
begin
  Branch(cX,Target,false);
end;

procedure TVectorTransform.NegativeY(var Target: TVectorNew);
begin
 Branch(cY,Target,false);
end;

procedure TVectorTransform.Newts(Nr: integer; eps: real; Xp: IRE; var Xr: IRE;
  var rez: integer);

    Procedure FuncF (bool:boolean; Nr:integer; b:TVectorNew; X:IRE; var Y:IRE);
    {�������� ������� ��� ������������, �� ����� ������
     �'������ ���� ����������� ��������� �������� -
     � ������ Y �������� �������� �� ����������� �������
     (��� ���� ��������, ��� �������. �� ��������� ������� ������)
     ��� ��������� ������ ������������ � � }
     var i:integer;
         temp:double;
     begin
     for i:=1 to Nr do Y[i]:=0;
     for i:=0 to Vector.HighNumber do
       begin
        temp:=(X[1]*B.y[i]+Vector.x[i]/X[2]-Vector.y[i]);
        Y[1]:=Y[1]+B.y[i]*temp/Vector.y[i];
        Y[3]:=Y[3]+temp*Vector.x[i]*B.x[i]/Vector.y[i];
        Y[2]:=Y[2]+temp*Vector.x[i]/Vector.y[i];
       end;
     if bool then Swap(Y[3],Y[2]);
     end;

    Procedure FuncG (bool:boolean;Nr:integer; b:TVectorNew; X:IRE; var Z:IRE2);
    {�������� ������� ��� ������������, �� ����� ������
     �'������ ���� ����������� ��������� �������� -
     ����������� ������� (Z), ���������� ��� � ����������
     �������� �� ���� �������� ����������� ����� �� ������
     ������������ �����;
     ������ ������� - �������� �������� �� �������, �� ���������
     ������� ������ ��� ��������� ��������,
     ������������ � � (�� ������ ������������ �����)}
    var i,j:integer;
    begin
    for i:=1 to Nr do
      for j:=1 to Nr do Z[i,j]:=0;
    for i:=0 to Vector.HighNumber do
    begin
    Z[1,1]:=Z[1,1]+b.y[i]*b.y[i]/Vector.y[i];
    Z[1,3]:=Z[1,3]-Vector.x[i]/sqr(X[3])*b.x[i]*(2*X[1]*b.y[i]+Vector.x[i]/X[2]-Vector.y[i])/Vector.y[i];
    Z[1,2]:=Z[1,2]-Vector.x[i]*b.y[i]/sqr(X[2])/Vector.y[i];
    Z[3,1]:=Z[3,1]+Vector.x[i]*b.x[i]*b.y[i]/Vector.y[i];
    Z[3,3]:=Z[3,3]-sqr(Vector.x[i]/X[3])*b.x[i]*(X[1]*b.y[i]+Vector.x[i]/X[2]-Vector.y[i]+X[1]*b.x[i])/Vector.y[i];
    Z[3,2]:=Z[3,2]-sqr(Vector.x[i]/X[2])*b.x[i]/Vector.y[i];
    Z[2,1]:=Z[2,1]+Vector.x[i]*b.y[i]/Vector.y[i];
    Z[2,3]:=Z[2,3]-sqr(Vector.x[i]/X[3])*b.x[i]*X[1]/Vector.y[i];
    Z[2,2]:=Z[2,2]-sqr(Vector.x[i]/X[2])/Vector.y[i];
    end;
  if bool then
   begin
   Z[1,2]:=Z[1,3];
   Z[2,2]:=Z[3,3];
   Z[2,1]:=Z[3,1];
   end;
  end;


  const Nitmax=1000; //ma��������� ����� ��������
  var Nit,i,j:integer;
      X1,X2,F,F1:IRE;
      G:IRE2;
      B:TVectorNew;
      a,Rtemp:real;
      bool,bool1:boolean;
  Label Start;


  begin

  B:=TVectorNew.Create;
  B.SetLenVector(Vector.Count);

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

   RRR(X1[3],b);

   FuncF(bool1,Nr,b,X1,F);
   FuncG(bool1,Nr,b,X1,G);

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
         rez:=-1;
         end
                  else
         rez:=0;

  b.Free;
end;

procedure TVectorTransform.NordDodat(D: TDiapazon; DD: TDiod_Schottky;
  Gamma: Double; out V0, I0, F0: Double);
  var temp1,temp2:TVectorTransform;
begin
  V0:=ErResult;
  I0:=ErResult;
  F0:=ErResult;
  temp1:=TVectorTransform.Create;
  NordeFun(temp1.fVector, DD , Gamma);    // � temp1 ����� ������� �����
  if temp1.Vector.IsEmpty then
               begin
                 temp1.Free;
                 Exit;
               end;

  temp2:=TVectorTransform.Create;
  repeat
    if temp1.MaximumCount<2 then Break;
    temp1.Median(temp2.fVector);
    temp2.Smoothing(temp1.fVector);
  until False;
  temp1.CopyDiapazonPoint(temp2.fVector,D,Vector);
  temp2.Vector.WriteToFile('new.dat');
  if temp2.Vector.Count<3 then
            begin
             temp1.Free;
             temp2.Free;
             Exit;
            end;
  {� temp2 - ������� ������� �����, ���
  ����������� ������ � D}

  V0:=temp2.ExtremumXvalue;
  F0:=temp2.Vector.Yvalue(V0);
  I0:=Vector.Yvalue(V0);
  temp1.Free;
  temp2.Free;
end;

procedure TVectorTransform.NordeFun(var Target: TVectorNew; DD: TDiod_Schottky;
  Gam: Double);
 var i:word;
begin
  InitTargetToFun(Target);
  if  (Vector.T<=0)or
      (Target.Count=0) then Exit;
  for I := 0 to Target.HighNumber do
   begin
     Target.X[i]:=Vector.X[i+Target.N_begin];
     Target.Y[i]:=Vector.X[i+Target.N_begin]/Gam+DD.Fb(Target.T,Vector.Y[i+Target.N_begin]);
   end;
  Target.N_begin:=Target.N_begin+Vector.N_begin;
end;

procedure TVectorTransform.NordKalk;
begin
  NordKalk(GraphParameters.Diapazon,Diod,
           GraphParameters.Gamma,GraphParameters.n,
           GraphParameters.Rs,GraphParameters.Fb)
end;

procedure TVectorTransform.NordKalk(D: TDiapazon; DD: TDiod_Schottky; Gamma,
                       n: Double; out Rs, Fb: Double);
  var V0,I0,F0:double;
begin
  Rs:=ErResult;
  Fb:=ErResult;
  NordDodat(D, DD, Gamma, V0, I0, F0);
  if V0=ErResult then Exit;
  if n<>ErResult then
       begin
       Fb:=F0+(Gamma-n)/n*(V0/Gamma-Kb*Vector.T);
       Rs:=Kb*Vector.T*(Gamma-n)/I0;
       end;
end;

procedure TVectorTransform.Nss_Fun(var Target: TVectorNew; Fb, Rs: Double;
  DD: TDiod_Schottky; D: TDiapazon; nByDerivate: Boolean);
  var temp:TVectorNew;
      i:integer;
begin
  InitTarget(Target);
  if (Fb=ErResult)then Exit;
  temp:=TVectorNew.Create;
  if nByDerivate then N_V_Fun(temp,Rs)
                 else MikhN_Fun(temp);

 try
  for I := 0 to temp.HighNumber do
   if (temp.Y[i]>=1)and
      (Self.Vector.PointInDiapazon(D,i+temp.N_begin))
         then
              Target.Add(Fb-temp.x[i]/temp.y[i],
                         DD.Semiconductor.Material.Eps
                         *Eps0
                         *(temp.y[i]-1)/DD.Thick_i/1.6e-19);

 except
   Target.Clear;
 end;
  temp.Free;
end;

procedure TVectorTransform.N_V_Fun(var Target: TVectorNew; Rs: double);
var temp:TVectorTransform;
    i:integer;
begin
 InitTarget(Target);
 if Vector.T<0 then Exit;
 ForwardIVwithRs(Target,Rs);
 if (Target.Count=0)or(Target.MinY<=0) then
   begin
   Target.Clear;
   Exit;
   end;

 temp:=TVectorTransform.Create(Target);

 for i:=0 to Target.HighNumber do
  begin
  temp.vector.x[i]:=ln(Target.y[i]);
  temp.vector.y[i]:=Target.x[i];
  end;
{� temp ��������� V=f(ln(I)) � ����������� Rs}


 for I := 0 to Target.HighNumber do
  begin
//  Target.X[i]:=temp^.Y[i];
  Target.Y[i]:=temp.DerivateAtPoint(i)/Kb/Vector.T;
  end;
{�����������}
 temp.Vector:=Target;
 temp.Smoothing(Target);
 temp.Free;
end;

procedure TVectorTransform.PositiveX(var Target: TVectorNew);
begin
 Branch(cX,Target);
end;


procedure TVectorTransform.PositiveY(var Target: TVectorNew);
begin
 Branch(cY,Target);
end;


procedure TVectorTransform.Reverse2Exp(var Target: TVectorNew; Rs: double);
var i:integer;
     temp:TVectorTransform;
begin
 InitTarget(Target);
 if (Rs=ErResult) or (Vector.T<=0) then Exit;

 temp:=TVectorTransform.Create;
 ReverseIV(temp.fVector);
 if temp.Vector.Count=0 then Exit;
 for i:=0 to temp.Vector.HighNumber do
   begin
   temp.Vector.X[i]:=(temp.Vector.X[i]-Rs*temp.Vector.Y[i]);
   temp.Vector.Y[i]:=-temp.Vector.Y[i]/(1-exp(temp.Vector.X[i]/Kb/Vector.T));
   end;
 temp.PositiveY(Target);
 temp.Free;
end;

procedure TVectorTransform.ReverseIV(var Target: TVectorNew);
 var temp:TVectorTransform;
begin
 temp:=TVectorTransform.Create(Self.Vector);
 temp.Itself(temp.NegativeX);
 temp.Itself(temp.AbsX);
 temp.AbsY(Target);
 temp.Free;
end;

procedure TVectorTransform.ReverseX(var Target: TVectorNew);
begin
   Branch(cX,Target,false,false);
end;

procedure TVectorTransform.ReverseY(var Target: TVectorNew);
begin
   Branch(cY,Target,false,false);
end;

procedure TVectorTransform.RRR(E: double; Target: TVectorNew);
    var i:integer;
begin
   InitTarget(Target);
   Target.SetLenVector(Vector.Count);
   for i:=0 to Target.HighNumber do
         begin
         Target.x[i]:=exp(Vector.x[i]/E);
         Target.y[i]:=Target.x[i]-1;
         end;
end;

procedure TVectorTransform.Smoothing(var Target: TVectorNew);
const W0=17;W1=66;W2=17;
{����� ����������� ��� �������, ����� �� ����� �����}
var i:integer;
begin
  InitTarget(Target);
  if Vector.Count<3 then Exit;
  Vector.Copy(Target);
  for i:=1 to Target.HighNumber-1 do
      Target.y[i]:=(W0*Vector.y[i-1]+W1*Vector.y[i]+W2*Vector.y[i+1])/(W0+W1+W2);
  Target.y[0]:=(W1*Vector.y[0]+W2*Vector.y[1])/(W1+W2);
  Target.y[Vector.HighNumber]:=(W1*Vector.y[Vector.HighNumber]
                     +W0*Vector.y[Vector.HighNumber-1])/(W1+W0);
end;

procedure TVectorTransform.Splain3(var Target:TVectorNew;beg:double; step:double);
 var i,j:integer;
     temp:double;
     SplainCoef:TSplainCoefArray;
begin
  InitTarget(Target);
   j:=Vector.ValueNumber(cX,beg);
   if j<0 then Exit;
//  if (beg>Vector.MaxX)or(beg<Vector.MinX) then Exit;

  SplainCoefCalculate(Vector,SplainCoef);
  i:=0;
  temp:=beg;
  repeat
   inc(i);
   temp:=temp+step;
  until (temp>Vector.X[Vector.HighNumber]);

  Target.SetLenVector(i);
  for i:=0 to Target.HighNumber do
   begin
    temp:=beg+i*step;
    Target.X[i]:=temp;
    j:=Vector.ValueNumber(cX,temp);
//    for j:=0 to Vector.HighNumber-1 do
//       if (temp-Vector.X[j])*(temp-Vector.X[j+1])<=0 then Break;

    Target.Y[i]:=Kub(temp,Vector.Point[j],SplainCoef[j]);
   end;

end;

procedure TVectorTransform.TauFun(var Target: TVectorNew; Func: TFunDouble);
 var XisT:boolean;
      i: integer;
     tempV:TVectorTransform;
begin
 XisT:=(Vector.X[0]>50)and(Vector.X[Vector.HighNumber]>100);
 if XisT then  Self.InVectorToOut(Target,Func)
         else
          begin
            tempV:=TVectorTransform.Create(Vector);
            for i := 0 to tempV.Vector.HighNumber do
                    tempV.Vector.X[i]:=1/(Kb*Self.Vector.X[i]);
            tempV.InVectorToOut(Target,Func);
            tempV.Free;
          end;
end;

procedure TVectorTransform.WernerFun(var Target: TVectorNew);
 var i:word;
     temp:TVectorTransform;
begin
 InitTargetToFun(Target);
 temp:=TVectorTransform.Create();
 temp.Vector.SetLenVector(Target.Count);

 if Target.Count=0 then Exit;

  for I := 0 to Target.HighNumber do
   begin
     Target.X[i]:=Self.DerivateAtPoint(i+Target.N_begin);
     Target.Y[i]:=Target.X[i]/Vector.Y[i+Target.N_begin];
   end;

  Target.N_begin:=Target.N_begin+Vector.N_begin;

end;

procedure TVectorTransform.WernerKalk;
begin
  WernerKalk(GraphParameters.Diapazon,
             GraphParameters.Rs,GraphParameters.n);
end;

procedure TVectorTransform.WernerKalk(var D: TDiapazon; var Rs, n: double);
  var temp1, temp2:TVectorTransform;
      OutputData:TArrSingle;
begin
  Rs:=ErResult;
  n:=ErResult;
  if Vector.T<=0 then Exit;

  temp1:=TVectorTransform.Create;
  WernerFun(temp1.fVector);         // � temp1 ����� ������� �������
  if temp1.Vector.IsEmpty then
               begin
                 temp1.Free;
                 Exit;
               end;
  temp2:=TVectorTransform.Create;
  temp1.CopyDiapazonPoint(temp2.fVector,D,Vector);
  if temp2.Vector.IsEmpty then
            begin
             temp1.Free;
             temp2.Free;
             Exit;
            end;
    {� temp2 ����� ������� ������� �������
    (���� ����� ������� �������)}
  temp2.LinAprox(OutputData);
  Rs:=-OutputData[1]/OutputData[0];
  n:=1/OutputData[0]/Kb/Vector.T;
  temp1.Free;
  temp2.Free;

end;

function TVectorTransform.YvalueLagrang(Xvalue: double): double;
 var i,j:word;
     t1,t2:double;
begin
   Result:=ErResult;
   if (Xvalue-Vector.X[Vector.HighNumber])*(Xvalue-Vector.X[0])>0 then Exit;
   t1:=0;
   for i:=0 to Vector.HighNumber do
     begin
       t2:=1;
       for j:=0 to Vector.HighNumber do
         if (j<>i) then
          t2:=t2*(Xvalue-Vector.X[j])/(Vector.X[i]-Vector.X[j]);
       t1:=t1+Vector.Y[i]*t2;
     end;
  Result:=t1;

end;

function TVectorTransform.YvalueSplain3(Xvalue: double): double;
 var i:integer;
     SplainCoef:TSplainCoefArray;
begin
   Result:=ErResult;
   i:=Vector.ValueNumber(cX,Xvalue);
   if i<0 then Exit;

   if (Xvalue>Vector.MaxX)or(Xvalue<Vector.MinX) then Exit;
   SplainCoefCalculate(Vector,SplainCoef);

//  for i:=0 to Vector.HighNumber-1 do
//    if (Xvalue-Vector.X[i])*(Xvalue-Vector.X[i+1])<=0 then Break;

  Result:=Kub(Xvalue,Vector.Point[i],SplainCoef[i]);

end;

Function Kub (x:double;coef:array of double):double;overload;
{������� coef[0]+coef[1]*(x-coef[4])+
                  coef[2]*(x-coef[4])^2+
                  coef[3]*(x-coef[4])^3;
�������, �������, ��� ����������� �������}
 var x0,temp:double;
     i:integer;
begin
  Result:=0;
  if High(coef)>3 then x0:=coef[4]
                  else x0:=0;
  temp:=1;
  for I := 0 to High(coef) do
   begin
     Result:=Result+coef[i]*temp;
     temp:=temp*(x-x0);
     if i=3 then Break;
   end;
end;

Function Kub(x:double;Point:TPointDouble;SplainCoef:TSplainCoef):double;overload;
begin
  Result:=Kub(x,[Point[cY],SplainCoef.B,SplainCoef.C,SplainCoef.D,Point[cX]])
end;


Procedure SplainCoefCalculate(V:TVectorNew;var SplainCoef:TSplainCoefArray);
 var Bt,Dl,AA,BB,H:TArrSingle;
     i:integer;
  begin
   if V.HighNumber<1 then
    begin
    SetLength(SplainCoef,0);
    Exit;
    end;

   SetLength(SplainCoef,V.HighNumber);
   SetLength(Bt,V.HighNumber);
   SetLength(Dl,V.HighNumber);
   SetLength(AA,V.HighNumber);
   SetLength(BB,V.HighNumber);
   SetLength(H,V.HighNumber);
   for I := 0 to V.HighNumber - 1 do
       H[i]:=V.X[i+1]-V.X[i];

   Bt[0]:=1;
   Dl[0]:=1;
   for I := 1 to V.HighNumber - 1 do
     begin
       Bt[i]:=2*(H[i-1]+H[i]);
       Dl[i]:=3*((V.Y[i+1]-V.Y[i])/H[i]-(V.Y[i]-V.Y[i-1])/H[i-1]);
     end;

  AA[0]:=0;
  BB[0]:=1;

    AA[1]:=-H[1]/Bt[1];
    BB[1]:=(Dl[1]-H[0])/Bt[1];
    for I := 2 to V.HighNumber - 2 do
     begin
       AA[i]:=-H[i]/(Bt[i]+H[i-1]*AA[i-1]);
       BB[i]:=(Dl[i]-H[i-1]*BB[i-1])/(Bt[i]+H[i-1]*AA[i-1]);
     end;
   AA[V.HighNumber-1]:=0;
   BB[V.HighNumber-1]:=(Dl[V.HighNumber-1]-
                             H[V.HighNumber-2]*BB[V.HighNumber-2])
                             /(Bt[V.HighNumber-1]+H[V.HighNumber-2]
                               *AA[V.HighNumber-2]);

  SplainCoef[V.HighNumber-1].C:=BB[V.HighNumber-1];
  for I := V.HighNumber-2 downto 0 do
    SplainCoef[i].C:=AA[i]*SplainCoef[i+1].C+BB[i];

 SplainCoef[V.HighNumber-1].D:=-SplainCoef[V.HighNumber-1].C/3/H[V.HighNumber-1];
 SplainCoef[V.HighNumber-1].B:=(V.Y[V.HighNumber]-V.Y[V.HighNumber-1])
          /H[V.HighNumber-1]-2/3*SplainCoef[V.HighNumber-1].C*H[V.HighNumber-1];

 for I := 0 to V.HighNumber-2 do
   begin
     SplainCoef[i].D:=(SplainCoef[i+1].C-SplainCoef[i].C)/3/H[i];
     SplainCoef[i].B:=(V.Y[i+1]-V.Y[i])/H[i]-H[i]
                     /3*(SplainCoef[i+1].C+2*SplainCoef[i].C);
   end;

end;

Function DerivateLagr(x:double;Point1,Point2,Point3:TPointDouble):double;
  {�������� ������� ��� ����������� ������� -
  ������� �� ������� ��������, ����������� �����
  ��� �����}
begin
  Result:=Point1[cY]*(2*x-Point2[cX]-Point3[cX])
            /(Point1[cX]-Point2[cX])/(Point1[cX]-Point3[cX])
        +Point2[cY]*(2*x-Point1[cX]-Point3[cX])/
           (Point2[cX]-Point1[cX])/(Point2[cX]-Point3[cX])
        +Point3[cY]*(2*x-Point1[cX]-Point2[cX])
         /(Point3[cX]-Point1[cX])/(Point3[cX]-Point2[cX]);
end;

Function DerivateLagr(Point1,Point2,Point3:TPointDouble):double;
begin
  Result:=DerivateLagr(Point2[cX],Point1,Point2,Point3);
end;

Function DerivateTwoPoint(Point1,Point2:TPointDouble):double;
begin
  Result:=(Point2[cY]-Point1[cY])/(Point2[cX]-Point1[cX])
end;

procedure TVectorTransform.ExKalk(DD: TDiod_Schottky; out n, I0, Fb: double;
  OutsideTemperature: double);
  var temp2:TVectorTransform;
      i:integer;
      Temperature:double;
      outputData:TArrSingle;
begin
  if OutsideTemperature=ErResult then Temperature:=Vector.T
                                 else Temperature:=OutsideTemperature;

  n:=ErResult;
  Fb:=ErResult;
  I0:=ErResult;
  if (DD.Semiconductor.ARich=ErResult)
     or(DD.Area=ErResult)
     or(Temperature<=0) then Exit;

  temp2:=TVectorTransform.Create;
  PositiveY(temp2.fVector);
  if temp2.Vector.Count<2 then
                 begin
                  temp2.Free;
                  Exit;
                 end;
  try
  for I := 0 to temp2.Vector.HighNumber
     do temp2.Vector.Y[i]:=ln(temp2.Vector.Y[i]);
  except
    temp2.Free;
    Exit;
  end;

  temp2.LinAprox(outputData);
  I0:=exp(outputData[0]);
  n:=1/(Kb*Temperature*outputData[1]);
  Fb:=DD.Fb(Temperature,I0);
  temp2.Free;
end;

procedure TVectorTransform.ExpKalk(D: TDiapazon; Rs: Double; DD: TDiod_Schottky;
        Xp: IRE; var n, I0, Fb: Double);
  var temp1:TVectorTransform;
      i,rez:integer;
      Xr:IRE;
begin
  if (D.YMin=ErResult) or (D.YMin<=0) then D.YMin:=0;
  if (D.XMin=ErResult) then D.XMin:=0.001;
  n:=ErResult;
  Fb:=ErResult;
  I0:=ErResult;
  if Rs=ErResult then Exit;

  temp1:=TVectorTransform.Create;
  CopyDiapazonPoint(temp1.fVector,D);
  if temp1.Vector.IsEmpty then
      begin
        temp1.Free;
        Exit;
      end;
  for I := 0 to temp1.Vector.HighNumber do
                temp1.Vector.X[i]:=temp1.Vector.X[i]-Rs*temp1.Vector.Y[i];
   {� temp1 ����� BAX � ����������� Rs }

  try
   temp1.Newts(4,1e-6,Xp,Xr,rez);
  except
   temp1.Free;
   Exit;
  end;

  I0:=Xr[1];
  n:=Xr[3]/Kb/Vector.T; {n}
  if I0=0 then I0:=1;
  Fb:=DD.Fb(Vector.T,I0);
  temp1.Free;
end;

end.
