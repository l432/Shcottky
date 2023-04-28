unit Castro;
{функції, пов'язані зі статистичною
обробкою дво-діодної зустрічної моделі}

interface

uses
  OlegVector, OlegType, OApproxCaption;

const
 Npar=9;
 I001=2e-3;
 I01Ea=0.15;
 I01const=1.5e-5;
 I002=1e3;
 I02Ea=0.43;
 n1A=7;
 n2T0=500;
 Rsh1const=8e4;
 Rsh20=9e-3;
 Rsh2Ea=0.32;
 Iph0=1e-3;

Function CasI01(const T:double):double;
Function CasI02(const T:double):double;
Function Casn1(const T:double):double;
Function Casn2(const T:double):double;
Function CasRsh1(const T:double):double;
Function CasRsh2(const T:double):double;
Function CasIph(const T:double):double;
Function CasRs(const T:double):double;

Procedure CasParDetermination(const T:double;
                              var Parameters:TArrSingle);

Function CastroIVdod(I:double;Parameters:array of double):double;
{використовується при обчисленні функції Кастро при певному значенні напруги,
а не струму
Parameters[9] - V (ота сама напруга)}

Function CastroIV_onV(V:double;Parameters:array of double;
                     const Imax:double=1; const Imin:double=0;
                     const eps:double=1e-6):double;
{розрахунок струму відповідно до моделі Кастро при певному значенні напруги,
використовується метод ділення навпіл,
Imax, Imin - інтервал для пошуку}

//Function Bisection(const F:TFun; const Parameters:array of double;
//                   const Xmax:double=5; const Xmin:double=0;
//                   const eps:double=1e-6

Procedure CastroIV_Creation(Vec:TVector;Parameters:array of double;
                           const Vmax:double=1;
                           const stepV:double=0.01;
                           const eps:double=1e-6);
{створюється ВАХ за формулою Кастро у вже існуючому Vec
від 0 до Vmax з кроком stepV}

procedure CastroFitting();

procedure SomethingForCastro();

implementation

uses
  OlegMath, System.Math, System.SysUtils, Vcl.Dialogs, OlegTests, OApproxNew;

Function CasI01(const T:double):double;
begin
//  Result:=ThermallyActivated(I001,I01Ea,T);
  Result:=I01const;
end;

Function CasI02(const T:double):double;
begin
  Result:=ThermallyActivated(I002,I02Ea,T);
end;

Function Casn1(const T:double):double;
begin
 if T>=0
   then Result:=1/Kb/T/n1A
   else Result:=ErResult;
end;

Function Casn2(const T:double):double;
begin
 if T>=0
   then Result:=1+n2T0/T
   else Result:=ErResult;
end;

Function CasRsh1(const T:double):double;
begin
 if T>=0
   then Result:=Rsh1const
   else Result:=ErResult;
end;

Function CasRsh2(const T:double):double;
begin
 Result:=ThermallyActivated(Rsh20,-Rsh2Ea,T);
end;

Function CasIph(const T:double):double;
begin
 if T>=0
   then Result:=Iph0
   else Result:=ErResult;
end;

Function CasRs(const T:double):double;
begin
 if T>=0
   then Result:=50+(T-290)
//   then Result:=0
   else Result:=ErResult;
end;

Procedure CasParDetermination(const T:double;
                              var Parameters:TArrSingle);
begin
  SetLength(Parameters,Npar);
  Parameters[0]:=CasI01(T);
  Parameters[1]:=Casn1(T);
  Parameters[2]:=CasRsh1(T);
  Parameters[3]:=CasI02(T);
  Parameters[4]:=Casn2(T);
  Parameters[5]:=CasRsh2(T);
  Parameters[6]:=CasRs(T);
  Parameters[7]:=CasIph(T);
  Parameters[8]:=T;
end;

Function CastroIVdod(I:double;Parameters:array of double):double;
{використовується при обчисленні функції Кастро при певному значенні напруги,
а не струму
Parameters[9] - V (ота сама напруга)}
begin
  Result:=Parameters[9]-CastroIV(I,Parameters);
end;

Function CastroIV_onV(V:double;Parameters:array of double;
                     const Imax:double=1; const Imin:double=0;
                     const eps:double=1e-6):double;
{розрахунок струму відповідно до моделі Кастро при певному значенні напруги,
використовується метод ділення навпіл,
Imax, Imin - інтервал для пошуку}
 var Par:array of double;
     i:byte;
begin
 SetLength(Par,10);
 for I := 0 to 8 do
    Par[i]:=Parameters[i];
 Par[9]:=V;
 Result:=Bisection(CastroIVdod,Par,Imax,Imin,eps);
end;

Procedure CastroIV_Creation(Vec:TVector;Parameters:array of double;
                           const Vmax:double=1;
                           const stepV:double=0.01;
                           const eps:double=1e-6);
{створюється ВАХ за формулою Кастро у вже існуючому Vec
від 0 до Vmax з кроком stepV}
var V,Imin,Imax:double;
begin
 Vec.Clear;
 if High(Parameters)<8 then Exit;
 Vec.T:=Parameters[8];
 if (stepV<=0)
     or(Parameters[7]<0) then Exit;

 V:=0;
 Imin:=-Parameters[7]-max(1e-4,abs(Parameters[7])*0.1);
 Imax:=0+min(1e-4,abs(Parameters[7])*0.1);
 repeat
   Vec.Add(V,CastroIV_onV(V,Parameters,Imin,Imax,eps));
   if Vec.Y[Vec.HighNumber]=ErResult then Break;
   V:=V+stepV;
   Imin:=Vec.Y[Vec.HighNumber];
   Imax:=max(abs(Parameters[7]),2*abs(Imin));
   Imax:=Imin+max(Imax,1e-4);
 until V>Vmax;

end;

procedure CastroFitting();
 var FitFunction:TFitFunctionNew;
begin
  FitFunction:=FitFunctionFactory(ThinDiodeNames[0]);

  FreeAndNil(FitFunction);
end;

procedure SomethingForCastro;
// const
// par:array [0..1] of double=
//   (1.2,2);
 var Par1,Par2,Par3:array of double;
     Vec:TVector;
     x:double;
     Par4:TArrSingle;
begin
 {значення параметрів з pssA_219_2100403}
 SetLength(Par1,9);
 Par1[0]:=1.6e-9;
 Par1[1]:=1.92;
 Par1[2]:=190;
 Par1[3]:=1.6e-4;
 Par1[4]:=1.92;
 Par1[5]:=190;
 Par1[6]:=45;
 Par1[7]:=8e-3;
 Par1[8]:=300;
 SetLength(Par2,9);
 Par2[0]:=2e-12;
 Par2[1]:=1;
 Par2[2]:=150;
 Par2[3]:=6e-4;
 Par2[4]:=3;
 Par2[5]:=840;
 Par2[6]:=53;
 Par2[7]:=9e-3;
 Par2[8]:=300;
 SetLength(Par3,9);
 Par3[0]:=5.84e-5;
 Par3[1]:=6.44;
 Par3[2]:=41.2;
 Par3[3]:=1.21e-4;
 Par3[4]:=2.49;
 Par3[5]:=191;
 Par3[6]:=0;
 Par3[7]:=6.49e-3;
 Par3[8]:=300;
// SetLength(Par3,9);
// Par3[0]:=1.5e-5;
// Par3[1]:=2.4;
// Par3[2]:=1e8;
// Par3[3]:=2.4e-7;
// Par3[4]:=9.5;
// Par3[5]:=4.6e4;
// Par3[6]:=0;
// Par3[7]:=4.85e-5;
// Par3[8]:=300;

// showmessage(floattostr(CastroIV_onV(0,Par3,-0.01,0.001)));
// x:=-2e-3;
// showmessage(floattostr(CastroIV(x,Par2))+'  '+
//             floattostr(CastroIV2(x,Par2)));
// showmessage(floattostr(Lambert(1e6)));
// showmessage(ArrayToString(Par4));
// CasParDetermination(340,Par4);
// showmessage(ArrayToString(Par4));
  Vec:=TVector.Create;
  CasParDetermination(290,Par4);
  CastroIV_Creation(Vec,Par4,1.001);
  Vec.WriteToFile('Gfun290.dat',5);
  CasParDetermination(340,Par4);
  CastroIV_Creation(Vec,Par4,1.001);
  Vec.WriteToFile('Gfun340.dat',5);


  FreeAndNil(Vec);
end;

end.
