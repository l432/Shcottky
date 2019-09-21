unit OlegMathShottky;

interface
 uses OlegVectorNew,OlegTypeNew, OlegMaterialSamplesNew, 
  OlegVectorManipulation;


type

   TVectorShottky=class(TVectorTransform)
    private
     Procedure InitTargetToFun(var Target:TVectorNew);
      {��������� ��������� �� �������� �������� �������;
      �������  Target.N_begin, ��������� � �����
      � Vector �������� �>0.001 �� Y>0,
      ���������� ���������� ����� Target;
      ���� ���������� Target �� ����������}
     Procedure RRR(E:double; Target:TVectorNew);
    {�������� ������� � Newts ��� ������������,
    �������� � ��������� � ������� B ����������� exp(�^.x/E),
    � ��������� � - [exp(�^.x/E)-1]}
    public
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
      {�� ����� ����� � Vector (� ����������
      �������� � D) ���� ������� ����� �� �������
      ���������� �� ������ V0, ��������
      �������� ���� ������� F0 �� �������� ������ �0,
      ��� ������� V0 � �������� �����}
     Procedure NordKalk();overload;
     Procedure NordKalk(D: TDiapazon; DD: TDiod_Schottky; Gamma, n: Double;
              out Rs: Double; out Fb: Double);overload;
      {�� ����� ����� � Vector ������ ��������
      ������� ����� (� �����������
      ��������, �������� � D), ������� ��������
      ����������� ����� Rs �� ������ ���'��� Fb;
      ��� �������� ������� ����� ������
      AA - ����� г��������,
      Szr - ����� ��������,
      Gamma - �������� ����� (��� �������)
      ��� ���������� Rs
      n - �������� ����������}
     Procedure BohlinKalk();overload;
     Procedure BohlinKalk(D:TDiapazon; DD:TDiod_Schottky; Gamma1,Gamma2:double;
                         var Rs:double; var n:double;
                         var Fb:double; var I0:double);overload;
      {�� ����� ����� � Vector (� �����������
      ��������, �������� � D), �� ���������
      ������ ������ ������������ ��������
      ����������� ����� Rs, �������
      ����������� n �� ������ ���'��� Fb
      (� ����� ������ ��������� �0;
      ��� �������� ������� ����� ������
      AA - ����� г��������,
      Szr - ����� ��������,
      Gamma - �������� �����}
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
     Procedure LeeKalk ();overload;
     Procedure LeeKalk (D:TDiapazon; DD:TDiod_Schottky;
                         out Rs:double; out n:double;
                         out Fb:double; out I0:double);overload;
      {�� ����� ����� � Vector (� �����������
      ��������, �������� � D) ������� ��������
      ������� ˳ ������������ ��������
      ����������� ����� Rs, ����������� ����������� n,
      ������ ���'��� Fb �� ������ ��������� �0;
      ���� ����������� �� ������, �� �����������
      ���� Rs, ���� ������� ������������ �������� ErResult;
      ���� ��������� ���������� ������� ˳,
      �� � Rs=ErResult}
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
     Procedure Gr1Kalk ();overload;
     Procedure Gr1Kalk (D:TDiapazon; DD:TDiod_Schottky;
                         out Rs:double; out n:double;
                         out Fb:double; out I0:double);overload;
      {�� ����� ����� � Vector (� �����������
      ��������, �������� � D) ������� �������
      ������� ���� ������������ ��������
      ����������� ����� Rs, ����������� ����������� n,
      ������ ���'��� Fb �� ������ ��������� �0;
      ���� ����������� �� ������, �� �����������
      ���� Rs, ���� ������� ������������ �������� ErResult;
      ���� ��������� ���������� ������� �������,
      �� � Rs=ErResult}
     Procedure Gr2_Fun (var Target:TVectorNew; DD: TDiod_Schottky);
      {������ � Target ������� ������� ������� ����}
     Procedure Gr2Kalk ();overload;
     Procedure Gr2Kalk (D:TDiapazon; DD:TDiod_Schottky;
                         var Rs:double; var n:double;
                         var Fb:double; var I0:double);overload;
      {�� ����� ����� � Vector (� �����������
      ��������, �������� � D) ������� �������
      ������� ���� ������������ ��������
      ����������� ����� Rs, ����������� ����������� n,
      ������ ���'��� Fb �� ������ ��������� �0;
      ���� ����������� �� ������, �� �����������
      ���� Rs, ���� ������� ������������ �������� ErResult;
      ���� ��������� ���������� ������� �������,
      �� � Rs=ErResult}
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

implementation

uses
  Math, Dialogs, SysUtils, OlegMathNew;


{ TVectorShottky }

procedure TVectorShottky.MikhAlpha_Fun(var Target: TVectorNew);
 var i:word;
     temp:TVectorShottky;
     verytemp:TVectorNew;
begin
 InitTargetToFun(Target);
 if Target.Count=0 then Exit;
 verytemp:=TVectorNew.Create;
 InitTargetToFun(verytemp);

 temp:=TVectorShottky.Create(verytemp);
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

procedure TVectorShottky.MikhBetta_Fun(var Target: TVectorNew);
var temp:TVectorShottky;
    i:word;
begin
  MikhAlpha_Fun(Target);
  if Target.Count=0 then Exit;
  temp:=TVectorShottky.Create(Target);
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

procedure TVectorShottky.MikhKalk;
begin
  MikhKalk(GraphParameters.Diapazon,Diod,
           GraphParameters.Rs,GraphParameters.n,
           GraphParameters.I0,GraphParameters.Fb)
end;

procedure TVectorShottky.MikhKalk(D: TDiapazon; DD: TDiod_Schottky; out Rs, n,
  I0, Fb: Double);
 var temp1,temp2:TVectorShottky;
     Alpha_m,Vm,Im:double;
begin
 Rs:=ErResult;
 n:=ErResult;
 Fb:=ErResult;
 I0:=ErResult;

//QueryPerformanceCounter(StartValue);

  temp1:=TVectorShottky.Create;
  MikhAlpha_Fun(temp1.fVector);
  { � temp1 �lpha-������� ̳�������,
  ���������� �� ��� [�������] ������ �}
  if temp1.Vector.IsEmpty then
              begin
               temp1.Free;
               Exit;
              end;
  temp2:=TVectorShottky.Create;
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

procedure TVectorShottky.MikhN_Fun(var Target: TVectorNew);
var bet:TVectorNew;
    i:word;
begin
  MikhAlpha_Fun(Target);
  if Target.T=0 then Exit;
  if Target.Count=0 then Exit;

  bet:=TVectorNew.Create;
  MikhBetta_Fun(bet);
  for I := 0 to Target.HighNumber do
    Target.Y[i]:=Target.X[i]*(Target.Y[i]-1)*(1+bet.Y[i]/(Target.Y[i]-1))/Kb/Target.T/sqr(Target.Y[i]);

  bet.Free;

end;

procedure TVectorShottky.MikhRs_Fun(var Target: TVectorNew);
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

procedure TVectorShottky.M_V_Fun(var Target: TVectorNew;
  ForForwardBranch: boolean; tg: TGraph);
var temp:TVectorShottky;
    i:integer;
begin
 InitTargetToFun(Target);
 temp:=TVectorShottky.Create();
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

procedure TVectorShottky.BohlinKalk;
begin
  BohlinKalk(GraphParameters.Diapazon,Diod,
             GraphParameters.Gamma1,GraphParameters.Gamma2,
             GraphParameters.Rs,GraphParameters.n,
             GraphParameters.Fb,GraphParameters.I0);
end;

procedure TVectorShottky.BohlinKalk(D: TDiapazon; DD: TDiod_Schottky; Gamma1,
  Gamma2: double; var Rs, n, Fb, I0: double);
  var V01,V02,I01,I02,F01,F02,temp:double;
begin
  Rs:=ErResult;
  n:=ErResult;
  Fb:=ErResult;
  I0:=ErResult;

  NordDodat(D, DD, Gamma1, V01, I01, F01);
  NordDodat(D, DD, Gamma2, V02, I02, F02);
  if (V01=ErResult) or (V02=ErResult) then Exit;

  temp:=(V01-V02+(Gamma2-Gamma1)*Kb*Vector.T)/(F02-F01-V02/Gamma2+V01/Gamma1);
  n:=((Gamma1*I02-Gamma2*I01)/(I02-I01));
  n:=abs((n+temp)/2);

  temp:=(Gamma2-n)*Kb*Vector.T/I02;
  Rs:=(Gamma1-n)*Kb*Vector.T/I01;
  Rs:=(Rs+temp)/2;


  temp:=F02+V02*(1/n-1/Gamma2)-(Gamma2-n)*Kb*Vector.T/n;
  Fb:=F01+V01*(1/n-1/Gamma1)-(Gamma1-n)*Kb*Vector.T/n;
  Fb:=(Fb+temp)/2;
  I0:=DD.I0(Vector.T,Fb);
end;

procedure TVectorShottky.ChungFun(var Target: TVectorNew);
 var i:word;
     temp:TVectorShottky;
begin
 InitTargetToFun(Target);
 temp:=TVectorShottky.Create();
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

procedure TVectorShottky.ChungKalk;
begin
  ChungKalk(GraphParameters.Diapazon,
            GraphParameters.Rs,GraphParameters.n);
end;

procedure TVectorShottky.ChungKalk(D: TDiapazon; out Rs, n: double);
  var temp1, temp2:TVectorShottky;
      OutputData:TArrSingle;
begin
  Rs:=ErResult;
  n:=ErResult;
  temp1:=TVectorShottky.Create;
  ChungFun(temp1.fVector);         // � temp1 ����� ������� �����
  if temp1.Vector.IsEmpty then
               begin
                 temp1.Free;
                 Exit;
               end;
  temp2:=TVectorShottky.Create;
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

procedure TVectorShottky.CibilsFun(var Target: TVectorNew; D: TDiapazon);
//������� �� ������ �������� ���� ���� Va ���������� ���������
var Va:double;
    tp:TVectorNew;
    temp,temp2:TVectorShottky;
begin
  InitTarget(Target);
  Va:=round(1000*(Kb*Vector.T+0.004))/1000;
  if Va<0.01 then Va:=0.015;

  temp:=TVectorShottky.Create;
  temp2:=TVectorShottky.Create;
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

procedure TVectorShottky.CibilsFunDod(var Target: TVectorNew; Va: double);
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

procedure TVectorShottky.CibilsKalk;
begin
 CibilsKalk(GraphParameters.Diapazon,
             GraphParameters.Rs,GraphParameters.n);
end;

procedure TVectorShottky.CibilsKalk(const D: TDiapazon; out Rs, n: double);
  var temp1:TVectorShottky;
      outputData:TArrSingle;
begin
  Rs:=ErResult;
  n:=ErResult;
  temp1:=TVectorShottky.Create;
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

procedure TVectorShottky.Dit_Fun(var Target: TVectorNew; Rs: Double;
  DD: TDiod_Schottky; D: TDiapazon);
var i:integer;
    Vs,Vcal,del,Fb:double;
    temp:TVectorShottky;
//    aproxData:TArrSingle;
begin
  InitTarget(Target);

  if (Rs=ErResult)then Exit;
  Self.IvanovKalk(D, Rs, DD, del, Fb);
  if (Fb=ErResult)or(del<=0) then Exit;
  temp:=TVectorShottky.Create;
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

procedure TVectorShottky.ExKalk(Index: Integer);
begin
  ExKalk(Index,GraphParameters.Diapazon,
         GraphParameters.Rs,Diod,GraphParameters.n,
         GraphParameters.I0,GraphParameters.Fb)
end;

procedure TVectorShottky.ExKalk(Index: Integer; D: TDiapazon; Rs: Double;
                       DD: TDiod_Schottky; out n, I0, Fb: Double);
 var temp1,temp2:TVectorShottky;
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

  temp2:=TVectorShottky.Create;
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
  temp1:=TVectorShottky.Create;
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

procedure TVectorShottky.Forward2Exp(var Target: TVectorNew; Rs: double);
 var i:integer;
begin
 InitTarget(Target);
 if (Rs=ErResult) or (Vector.T<=0) then Exit;
 ForwardIVwithRs(Target,Rs);
 for i:=0 to Target.HighNumber do
   Target.Y[i]:=Target.Y[i]/(1-exp(-Target.X[i]/Kb/Target.T));
end;

procedure TVectorShottky.ForwardIVwithRs(var Target: TVectorNew; Rs: double);
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

procedure TVectorShottky.Gr1Kalk;
begin
  Gr1Kalk (GraphParameters.Diapazon,Diod,
           GraphParameters.Rs,GraphParameters.n,
           GraphParameters.Fb,GraphParameters.I0)
end;

procedure TVectorShottky.Gr1Kalk(D: TDiapazon; DD: TDiod_Schottky; out Rs, n,
  Fb, I0: double);
  var temp1,temp2:TVectorShottky;
      Dtemp:TDiapazon;
      i,j,Np:integer;
      C:TArrSingle;
      DDD:TVectorNew;
begin

  Rs:=ErResult;
  n:=ErResult;
  Fb:=ErResult;
  I0:=ErResult;
  Dtemp:=TDiapazon.Create;
  Dtemp.Copy(D);

    i:=0;
    repeat
      if (Vector.X[i]>D.Xmin)and(Vector.Y[i]>D.Ymin) then Break;
      inc(i);
    until (i=Vector.HighNumber);

  Np:=0;

  temp1:=TVectorShottky.Create();
  temp2:=TVectorShottky.Create();
  DDD:=TVectorNew.Create();
  repeat
    Dtemp.Xmin:=0.99999*Vector.X[i];
    CopyDiapazonPoint(temp1.fVector,Dtemp);
    if temp1.Vector.Count<6 then Break;
    temp1.Gr1_Fun(temp2.fVector);
    if temp2.Vector.Count<6 then Break;
    temp2.GromovAprox(C);
    inc(Np);

    DDD.Add(Dtemp.Xmin,0);


     for j := 0 to Vector.HighNumber do
       begin
       try
       DDD.Y[Np-1]:=DDD.Y[Np-1]+sqr(1-Full_IV(IV_Diod,Vector.X[j],C[2],exp(-C[0]/C[2]),C[1])/Vector.Y[j]);
       except
        DDD.Y[Np-1]:=ErResult
       end;
       end;

    inc(i);
  until False;


  if DDD.HighNumber>-1 then
    begin
      Dtemp.Xmin:=DDD.X[DDD.MinYnumber];
      CopyDiapazonPoint(temp1.fVector,Dtemp);
      temp1.Gr1_Fun(temp2.fVector);
      temp2.GromovAprox(C);
      Rs:=C[1];
      if Vector.T>0 then
         begin
         n:=C[2]/Kb/Vector.T;
         Fb:=Kb*Vector.T*C[0]/C[2]+DD.kTln(Vector.T);
         I0:=exp(-C[0]/C[2]);
         end;
    end;

  temp1.Free;
  Dtemp.Free;
  temp2.Free;
  DDD.Free;

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

procedure TVectorShottky.Gr1_Fun(var Target: TVectorNew);
begin
 InitTarget(Target);
 PositiveX(Target);
 Target.SwapXY;
end;

procedure TVectorShottky.Gr2Kalk;
begin
  Gr2Kalk(GraphParameters.Diapazon,Diod,
          GraphParameters.Rs,GraphParameters.n,
          GraphParameters.Fb,GraphParameters.I0);
end;

procedure TVectorShottky.Gr2Kalk(D: TDiapazon; DD: TDiod_Schottky; var Rs, n,
  Fb, I0: double);
var temp1,temp2:TVectorShottky;
    c:TArrSingle;
begin
  Rs:=ErResult;
  n:=ErResult;
  Fb:=ErResult;
  I0:=ErResult;
  if Vector.T<=0 then Exit;

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


  temp1:=TVectorShottky.Create();
    Gr2_Fun(temp1.fVector, DD);
  { � temp1 ����� ������� ������� ������� ����}
  if temp1.Vector.IsEmpty then
               begin
               temp1.Free;
               Exit;
               end;
  temp2:=TVectorShottky.Create();
  temp1.CopyDiapazonPoint(temp2.fVector,D,Vector);
  {� temp2 ������� ������� ������� ������� ����,
    ��� ����������� ����� � D}
  temp1.Free;

  if temp2.Vector.IsEmpty then
            begin
             temp2.Free;
             Exit;
            end;

  temp2.GromovAprox(C);
  Rs:=2*C[1];
  n:=2*C[2]/Kb/Vector.T+2;
  Fb:=2*C[0]/n-DD.kTln(Vector.T)/n*(2-n);
  I0:=DD.I0(Vector.T,Fb);
  temp2.Free;
end;

procedure TVectorShottky.Gr2_Fun(var Target: TVectorNew; DD: TDiod_Schottky);
 var i:integer;
begin
 NordeFun(Target,DD,2);
 for i:=0 to Target.HighNumber do Target.X[i]:=Vector.Y[i+Target.N_begin];
 {��������, ��������� ���� �������� ���� � �������,
 ���� � � ����������� �������� ����, ��� ����� �^.N_begin=0}
end;

procedure TVectorShottky.HFun(var Target: TVectorNew; DD: TDiod_Schottky;
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

procedure TVectorShottky.HFunKalk;
begin
 HFunKalk(GraphParameters.Diapazon,Diod,
         GraphParameters.n,GraphParameters.Rs,
         GraphParameters.Fb);
end;

procedure TVectorShottky.HFunKalk(D: TDiapazon; DD: TDiod_Schottky; N: Double;
  out Rs, Fb: Double);
  var temp1, temp2:TVectorShottky;
      OutputData:TArrSingle;
begin
  Rs:=ErResult;
  Fb:=ErResult;
  if N=ErResult then Exit;

  temp1:=TVectorShottky.Create;
  HFun(temp1.fVector,DD,N);         // � temp1 ����� H-�������
  if temp1.Vector.IsEmpty then
              begin
               temp1.Free;
               Exit;
              end;

  temp2:=TVectorShottky.Create;
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

procedure TVectorShottky.InitTargetToFun(var Target: TVectorNew);
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

procedure TVectorShottky.InVectorToOut(var Target: TVectorNew;
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

procedure TVectorShottky.IvanovKalk;
begin
  IvanovKalk(GraphParameters.Diapazon,
             GraphParameters.Rs,Diod,
             GraphParameters.Krec,GraphParameters.Fb)
end;

procedure TVectorShottky.Kam1Kalk;
begin
 Kam1Kalk (GraphParameters.Diapazon,
           GraphParameters.Rs,GraphParameters.n)
end;

procedure TVectorShottky.Kam1Kalk(D: TDiapazon; out Rs, n: double);
  var temp1:TVectorShottky;
      outputData:TArrSingle;
begin
  temp1:=TVectorShottky.Create;

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

procedure TVectorShottky.Kam1_Fun(var Target: TVectorNew; D: TDiapazon);
 var temp:TVectorShottky;
     i:integer;
begin
 InitTarget(Target);

 temp:=TVectorShottky.Create;
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

procedure TVectorShottky.Kam2Kalk;
begin
  Kam2Kalk(GraphParameters.Diapazon,
           GraphParameters.Rs,GraphParameters.n);
end;

procedure TVectorShottky.Kam2Kalk(const D: TDiapazon; out Rs, n: double);
  var temp1:TVectorShottky;
      outputData:TArrSingle;
begin
  Rs:=ErResult;
  n:=ErResult;

  temp1:=TVectorShottky.Create;
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

procedure TVectorShottky.Kam2_Fun(var Target: TVectorNew; D: TDiapazon);
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
  Target.Sorting();
end;

procedure TVectorShottky.IvanovKalk(D: TDiapazon; Rs: Double;
  DD: TDiod_Schottky; out del, Fb: Double);
 var temp,temp2:TVectorShottky;
     OutputData: TArrSingle;
begin
  del:=ErResult;
  Fb:=ErResult;
  if Rs=ErResult then Exit;
  temp:=TVectorShottky.Create();
    ForwardIVwithRs(temp.fVector,Rs);
  if temp.Vector.Count=0 then
      begin
        temp.Free;
        Exit;
      end;
  temp2:=TVectorShottky.Create();
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

procedure TVectorShottky.LeeFun(var Target: TVectorNew; D: TDiapazon);
var Va:double;
    tp:TVectorNew;
    temp,temp2:TVectorShottky;
    GromovKoef:TArrSingle;
begin
  InitTarget(Target);
  Va:=round(100*(Kb*Vector.T+0.004))/100;

  temp:=TVectorShottky.Create;
  temp2:=TVectorShottky.Create;
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

procedure TVectorShottky.LeeFunDod(var Target: TVectorNew; Va: double);
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

procedure TVectorShottky.LeeKalk;
begin
  LeeKalk(GraphParameters.Diapazon,Diod,
          GraphParameters.Rs,GraphParameters.n,
          GraphParameters.Fb,GraphParameters.I0);
end;

procedure TVectorShottky.LeeKalk(D: TDiapazon; DD: TDiod_Schottky; out Rs, n,
  Fb, I0: double);
  var temp1:TVectorShottky;
      ab:TArrSingle;

begin
  Rs:=ErResult;
  n:=ErResult;
  Fb:=ErResult;
  I0:=ErResult;

  temp1:=TVectorShottky.Create;
  LeeFun(temp1.fVector,D);
  if temp1.Vector.Count<2 then
                begin
                temp1.Free;
                Exit;
                end;
  temp1.LinAprox(ab);
  Rs:=1/ab[1];
  if Vector.T>0 then
              begin
              n:=-ab[0]/ab[1]/Kb/Vector.T;
              I0:=exp(-temp1.Vector.T/Kb/Vector.T/n);
              Fb:=temp1.Vector.T/n+DD.kTln(Vector.T);
              end;
  temp1.Free;
end;

procedure TVectorShottky.Newts(Nr: integer; eps: real; Xp: IRE; var Xr: IRE;
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

procedure TVectorShottky.NordDodat(D: TDiapazon; DD: TDiod_Schottky;
  Gamma: Double; out V0, I0, F0: Double);
  var temp1,temp2:TVectorShottky;
begin
  V0:=ErResult;
  I0:=ErResult;
  F0:=ErResult;
  temp1:=TVectorShottky.Create;
  NordeFun(temp1.fVector, DD , Gamma);    // � temp1 ����� ������� �����
  if temp1.Vector.IsEmpty then
               begin
                 temp1.Free;
                 Exit;
               end;

  temp2:=TVectorShottky.Create;
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

procedure TVectorShottky.NordeFun(var Target: TVectorNew; DD: TDiod_Schottky;
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

procedure TVectorShottky.NordKalk;
begin
  NordKalk(GraphParameters.Diapazon,Diod,
           GraphParameters.Gamma,GraphParameters.n,
           GraphParameters.Rs,GraphParameters.Fb)
end;

procedure TVectorShottky.NordKalk(D: TDiapazon; DD: TDiod_Schottky; Gamma,
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

procedure TVectorShottky.Nss_Fun(var Target: TVectorNew; Fb, Rs: Double;
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

procedure TVectorShottky.N_V_Fun(var Target: TVectorNew; Rs: double);
var temp:TVectorShottky;
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

 temp:=TVectorShottky.Create(Target);

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

procedure TVectorShottky.Reverse2Exp(var Target: TVectorNew; Rs: double);
var i:integer;
     temp:TVectorShottky;
begin
 InitTarget(Target);
 if (Rs=ErResult) or (Vector.T<=0) then Exit;

 temp:=TVectorShottky.Create;
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

procedure TVectorShottky.RRR(E: double; Target: TVectorNew);
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

procedure TVectorShottky.TauFun(var Target: TVectorNew; Func: TFunDouble);
 var XisT:boolean;
      i: integer;
     tempV:TVectorShottky;
begin
 XisT:=(Vector.X[0]>50)and(Vector.X[Vector.HighNumber]>100);
 if XisT then  Self.InVectorToOut(Target,Func)
         else
          begin
            tempV:=TVectorShottky.Create(Vector);
            for i := 0 to tempV.Vector.HighNumber do
                    tempV.Vector.X[i]:=1/(Kb*Self.Vector.X[i]);
            tempV.InVectorToOut(Target,Func);
            tempV.Free;
          end;
end;

procedure TVectorShottky.WernerFun(var Target: TVectorNew);
 var i:word;
     temp:TVectorShottky;
begin
 InitTargetToFun(Target);
 temp:=TVectorShottky.Create();
 temp.Vector.SetLenVector(Target.Count);

 if Target.Count=0 then Exit;

  for I := 0 to Target.HighNumber do
   begin
     Target.X[i]:=Self.DerivateAtPoint(i+Target.N_begin);
     Target.Y[i]:=Target.X[i]/Vector.Y[i+Target.N_begin];
   end;

  Target.N_begin:=Target.N_begin+Vector.N_begin;

end;

procedure TVectorShottky.WernerKalk;
begin
  WernerKalk(GraphParameters.Diapazon,
             GraphParameters.Rs,GraphParameters.n);
end;

procedure TVectorShottky.WernerKalk(var D: TDiapazon; var Rs, n: double);
  var temp1, temp2:TVectorShottky;
      OutputData:TArrSingle;
begin
  Rs:=ErResult;
  n:=ErResult;
  if Vector.T<=0 then Exit;

  temp1:=TVectorShottky.Create;
  WernerFun(temp1.fVector);         // � temp1 ����� ������� �������
  if temp1.Vector.IsEmpty then
               begin
                 temp1.Free;
                 Exit;
               end;
  temp2:=TVectorShottky.Create;
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

procedure TVectorShottky.ExKalk(DD: TDiod_Schottky; out n, I0, Fb: double;
  OutsideTemperature: double);
  var temp2:TVectorShottky;
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

  temp2:=TVectorShottky.Create;
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

procedure TVectorShottky.ExpKalk(D: TDiapazon; Rs: Double; DD: TDiod_Schottky;
        Xp: IRE; var n, I0, Fb: Double);
  var temp1:TVectorShottky;
      i,rez:integer;
      Xr:IRE;
begin
  if (D.YMin=ErResult) or (D.YMin<=0) then D.YMin:=0;
  if (D.XMin=ErResult) then D.XMin:=0.001;
  n:=ErResult;
  Fb:=ErResult;
  I0:=ErResult;
  if Rs=ErResult then Exit;

  temp1:=TVectorShottky.Create;
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
