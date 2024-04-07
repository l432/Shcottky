unit OlegDefectsSi;

interface

uses OlegMaterialSamples,OlegType,Math,OlegMath;

type
  TDefectName=(Fei,
               FeB_ac,
               FeB_don,
               FeB_ort_ac,
               FeB_ort_don);

  TDefectType=(tDonor,tAcceptor);

  TDefectParametersName=(
    nSn,
    nSp,
    nEt
     );

  TDefectParameters=record
    Name:string;
    Parameters:array[TDefectParametersName]of double;
    ToValenceBand:boolean;
    DefectType:TDefectType;
    end;

const
  Defects:array [TDefectName] of TDefectParameters=

   ((Name:'Fe_i';   Parameters: (3.6e-19,  7e-21,  0.394); ToValenceBand:True; DefectType:tDonor ),
    (Name:'FeB_ac'; Parameters: (2.5e-19,  5.5e-19, 0.262); ToValenceBand:False;DefectType:tAcceptor),
    (Name:'FeB_don';Parameters: (4e-17,    2e-18,   0.10); ToValenceBand:True; DefectType:tDonor),
    (Name:'FeB_ort_ac'; Parameters: (3e-19,  1.4e-19, 0.43); ToValenceBand:False;DefectType:tAcceptor),
    (Name:'FeB_ort_don';Parameters: (3e-19,  1.4e-19, 0.07); ToValenceBand:True; DefectType:tDonor)
    );

 DefectType_Label:array[TDefectType]of string=
   ('0/+','-/0');


type

  TDefect=class
  private
    FParameters:TDefectParameters;
    FMaterial:TMaterial;
    FNd: double;
    fDefectName:TDefectName;
    procedure SetNd(const Value: double);
    function GetDefectType: string;

  public
    Constructor Create(DefectName:TDefectName);
    Procedure Free;
    property Name:string read FParameters.Name;
    property Et:double read FParameters.Parameters[nEt];
    property ToValenceBand:boolean read FParameters.ToValenceBand;
    property DefectType:string read GetDefectType;
    property Nd:double read FNd write SetNd;
    function TAUn0(T:double=300):double;
    function TAUp0(T:double=300):double;
    function TAUsrh(Ndop,delN:double;T:double=300):double;
   {Ndop - рівень легування; delN - нерівноважні носії}
    function n1(T:double=300):double;
    function p1(T:double=300):double;
    function Sn(T:double=300):double;
    function Sp(T:double=300):double;
    {поперечні перерізи захоплення електронів та дірок}
  end;

Function Fe_i_eq(MaterialLayer:TMaterialLayer;
                 Fe_i_all:double; T:double=300):double;overload;
 {рівноважна концентрація міжвузольного заліза
  Fe_i_all - повна концентрація домішкового заліза}

Function Fe_i_eq(Fe_i_all:double;
                 NA:double;T:double=300):double;overload;

Function FeB_i_eq(Fe_i_all:double;
                 NA:double;T:double=300):double;

Function Fe_i_t(time:double;MaterialLayer:TMaterialLayer;
                 Fe_i_all:double; T:double=300;
                 Em:double=0.68):double;
{концентрація міжвузольного заліза через час time
після припинення освітлення;
Em - енергія міграціїї міжвузольного заліза}

 Function t_assFeB(N_A:double;T:double=300;
                 Em:double=0.68):double;
{характерний час спарювання пари залізо-бор,
N_A - концентрація бору, []=см-3}

Function TauFeEq(MaterialLayer:TMaterialLayer;
                 Fe_i_all:double; T:double=300):double;
{час, пов'язаний з рекомбінацією на FeB та Fei
в рівновазі: вважається, що більшвсть заліза в парах,
але рівноважна частина (див. Function Fe_i_eq) неспарена
  Fe_i_all - повна концентрація домішкового заліза}

Function TauFeEqIntrin(Fe_i_all:double; NA:double;
                   T:double=300):double;
{час, пов'язаний з рекомбінацією на FeB та Fei
(див. попередню функцію) та власною рекомбінацією}

Procedure LnOnT(Fe_i_all:double);

implementation

uses
  System.SysUtils, OlegVector;

{ TDefect }

constructor TDefect.Create(DefectName: TDefectName);
begin
  inherited Create;
  fDefectName:=DefectName;
  FParameters:=Defects[fDefectName];
  FMaterial:=TMaterial.Create(Si);
end;

procedure TDefect.Free;
begin
 FMaterial.Free;
 inherited Free;
end;

function TDefect.GetDefectType: string;
begin
 Result:=DefectType_Label[FParameters.DefectType];
end;

function TDefect.n1(T: double): double;
begin
  if ToValenceBand then
      Result:=FMaterial.Nc(T)*exp(-(FMaterial.EgT(T)-Et)/Kb/T)
                   else
      Result:=FMaterial.Nc(T)*exp(-Et/Kb/T);
end;

function TDefect.p1(T: double): double;
begin
  if ToValenceBand then
      Result:=FMaterial.Nv(T)*exp(-Et/Kb/T)
                   else
      Result:=FMaterial.Nv(T)*exp(-(FMaterial.EgT(T)-Et)/Kb/T);
end;

procedure TDefect.SetNd(const Value: double);
begin
  FNd := abs(Value);
end;

function TDefect.Sn(T: double): double;
begin
  case fDefectName of
    Fei: Result:=ThermallyPower(3.47e-15,-1.48,T);
    FeB_ac: Result:=ThermallyPower(5.1e-13,-2.5,T);
    else Result:=FParameters.Parameters[nSn];
  end;
end;

function TDefect.Sp(T: double): double;
begin
  case fDefectName of
    Fei: Result:=ThermallyActivated(4.54e-20,0.05,T);
    FeB_ac: Result:=ThermallyActivated(3.32e-14,0.262,T);
    else Result:=FParameters.Parameters[nSp];
  end;
end;

function TDefect.TAUn0(T: double=300): double;
begin
 Result:=1/(Sn*Nd*FMaterial.Vth_n(T));
end;

function TDefect.TAUp0(T: double=300): double;
begin
 Result:=1/(Sp*Nd*FMaterial.Vth_p(T));
end;

function TDefect.TAUsrh(Ndop, delN, T: double): double;
  var n0:double;
begin
  n0:=sqr(FMaterial.n_i(T))/Ndop;
  Result:=(TAUn0(T)*(Ndop+p1(T)+delN)+
           TAUp0(T)*(n0+n1(T)+delN))/
            (Ndop+n0+delN);
end;


Function Fe_i_eq(MaterialLayer:TMaterialLayer;
                 Fe_i_all:double; T:double=300):double;overload;
begin
  Result:=Fe_i_all/(1+MaterialLayer.Nd*1e-29*exp(0.582/Kb/T))
                  /(1+exp((MaterialLayer.F(T)-0.394)/Kb/T));
end;

Function Fe_i_eq(Fe_i_all:double;
                 NA:double;T:double=300):double;overload;
begin
  Result:=Fe_i_all/(1+NA*1e-29*exp(0.582/Kb/T))
                  /(1+exp((Kb*T*ln(Silicon.Nv(T)/NA)-0.394)/Kb/T));
end;

Function FeB_i_eq(Fe_i_all:double;
                 NA:double;T:double=300):double;
begin
  Result:=Fe_i_all-Fe_i_eq(Fe_i_all,NA,T);
end;

Function Fe_i_t(time:double;MaterialLayer:TMaterialLayer;
                 Fe_i_all:double; T:double=300;Em:double=0.68):double;
 var Fe_i_e:double;
begin
 Fe_i_e:=Fe_i_eq(MaterialLayer,Fe_i_all,T);
// Fe_i_e:=0;
 Result:=(Fe_i_all-Fe_i_e)
          *exp(-time/t_assFeB(1e-6*MaterialLayer.Nd,T,Em))
//          exp(-1.3e-3*exp(-Em/Kb/T)*time*Power(1e-6*MaterialLayer.Nd,2.0/3.0))
//          exp(-time*exp(-Em/Kb/T)*MaterialLayer.Nd/T/5.7e11)
         +Fe_i_e;
end;

 Function t_assFeB(N_A:double;T:double=300;
                 Em:double=0.68):double;
begin
//  Result:=1/(1.3e-3*exp(-Em/Kb/T)*Power(N_A,2.0/3.0));
  Result:=5.7e5*exp(Em/Kb/T)*T/N_A;
end;

Function TauFeEq(MaterialLayer:TMaterialLayer;
                 Fe_i_all:double; T:double=300):double;
 var   dFei,dFeB:TDefect;
       t_Fei,t_FeB:double;
begin
  dFei:=TDefect.Create(Fei);
  dFeB:=TDefect.Create(FeB_ac);
  try
//   dFei.Nd:=Fe_i_all;
    dFei.Nd:=Fe_i_eq(MaterialLayer,Fe_i_all,T);
    dFeB.Nd:=Fe_i_all-dFei.Nd;
    t_Fei:=dFei.TAUsrh(MaterialLayer.Nd,0,T);
    t_FeB:=dFeB.TAUsrh(MaterialLayer.Nd,0,T);
    Result:=1/(1/t_Fei+1/t_FeB);
//    Result:=10;
  except
    Result:=ErResult;
  end;
  FreeAndNil(dFei);
  FreeAndNil(dFeB);
end;

Function TauFeEqIntrin(Fe_i_all:double; NA:double;
                   T:double=300):double;
 var   dFei,dFeB:TDefect;
//       t_Fei,t_FeB:double;
begin
  dFei:=TDefect.Create(Fei);
  dFeB:=TDefect.Create(FeB_ac);
  try
    dFei.Nd:=Fe_i_eq(Fe_i_all,NA,T);
    dFeB.Nd:=FeB_i_eq(Fe_i_all,NA,T);;
    Result:=TMaterial.TauMatthiessenRule([
             dFei.TAUsrh(NA,0,T),
             dFeB.TAUsrh(NA,0,T),
             Silicon.TAUbtb(NA,0,T),
             Silicon.TAUager_p(NA,T)]);
  except
    Result:=ErResult;
  end;
  FreeAndNil(dFei);
  FreeAndNil(dFeB);
end;


Procedure LnOnT(Fe_i_all:double);
 var Vec:TVector;
     T:double;
begin
 Vec:=TVector.Create;
 T:=290;
 repeat
//  Vec.Add(T,Silicon.TauToLdif(TauFeEqIntrin(Fe_i_all,1.36e21,T),T,true,false,1.36e21));
  Vec.Add(T,Silicon.TauToLdif(TauFeEqIntrin(Fe_i_all,3e21,T),T,true,false,3e21));
  T:=T+1;
 until T>350;
 Vec.WriteToFile('LonT.dat',8);
 FreeAndNil(Vec);
end;

end.
