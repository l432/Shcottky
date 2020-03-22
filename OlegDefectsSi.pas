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
                 Fe_i_all:double; T:double=300):double;
 {рівноважна концентрація міжвузольного заліза
  Fe_i_all - повна концентрація домішкового заліза}

Function Fe_i_t(time:double;MaterialLayer:TMaterialLayer;
                 Fe_i_all:double; T:double=300):double;
{концентрація міжвузольного заліза через час time
після припинення освітлення}

implementation

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
                 Fe_i_all:double; T:double=300):double;
begin
  Result:=Fe_i_all/(1+MaterialLayer.Nd*1e-29*exp(0.582/Kb/T))
                  /(1+exp((MaterialLayer.F(T)-0.394)/Kb/T));
end;

Function Fe_i_t(time:double;MaterialLayer:TMaterialLayer;
                 Fe_i_all:double; T:double=300):double;
 var Fe_i_e:double;
begin
 Fe_i_e:=Fe_i_eq(MaterialLayer,Fe_i_all,T);
 Result:=(Fe_i_all-Fe_i_e)*
          exp(-1.3e-3*exp(-0.68/Kb/T)*time*Power(1e-6*MaterialLayer.Nd,2.0/3.0))
         +Fe_i_e;
end;

end.
