unit OlegMaterialSamples;

interface
uses IniFiles, TypInfo, OlegType,SysUtils,Dialogs, StdCtrls,OlegFunction,OlegMath;
type
    TMaterialName=(Si,GaAs,InP,H4SiC,GaN,CdTe,CdS,CdSe,CuInSe2,GaTe,GaSe,Ge,Other);
    TMaterialParametersName=(
            nEg0,   //ширина забороненої зони при T=0, []=eV
            nEps,   //діелектрична проникність
            nARich_n, //стала Річардсона для матеріалу n-типу, []=A/(m^2 A^2)
            nARich_p, //стала Річардсона для матеріалу p-типу, []=A/(m^2 A^2)
            nMe,  //відношення ефективної маси електрона до маси спокою електрона
            nMh,  //відношення ефективної маси дірки до маси спокою електрона
                //рівняння Варшні Eg(T)=Eg(0)-B*T^2/(T+A)
            nVarshA, //параметр А з рівняння Варшні
            nVarshB //параметр В з рівняння Варшні
             );
    TMaterialParameters=record
          Name:string;
          Parameters:array[TMaterialParametersName]of double;
          end;
const
  VarshB_Si=7.021e-4;
  VarshA_Si=1108;
  Eg0_Si=1.169;


  Materials:array [TMaterialName] of TMaterialParameters=

//                                Eg0,     Eps,  ARich_n,  ARich_p,  Me,   Mh,   VarshA,   VarshB
   ((Name:'Si';     Parameters: (Eg0_Si,   11.7, 1.12e6,   0.32e6,   1.08, 0.58, VarshA_Si,VarshB_Si)),
    (Name:'GaAs';   Parameters: (1.519,    12.9, 8.16e4,   ErResult, 0.06, 0.50, 204,      5.405e-4)),
    (Name:'InP';    Parameters: (1.42,     12.5, 0.6e6,    ErResult, 0.08, 0.60, 327,      4.906e-4)),
    (Name:'4H-SiC'; Parameters: (3.26,     9.7,  0.75e6,   ErResult, 1,    1,    1300,     6.5e-4)),
    (Name:'GaN';    Parameters: (3.47,     8.9,  2.64e5,   7.50e5,   0.22, 0.60, 600,      7.7e-4)),
    (Name:'CdTe';   Parameters: (1.57,     12,   0.12e6,   ErResult, 1.08, 0.60, 0,        4e-4)),
    (Name:'CdS';    Parameters: (2.557,    1,    2.34e5,   ErResult, 0.17, 1,    450,      8.21e-4)),
    (Name:'CdSe';   Parameters: (1.9,      10.2, 1.56e5,   ErResult, 0.13, 1,    0,        2.8e-4)),
    (Name:'CuInSe2';Parameters: (ErResult, 1,    8.53e5,   ErResult, 1,    1,    ErResult, ErResult)),
    (Name:'GaTe';   Parameters: (ErResult, 1,    1.19e6,   ErResult, 1,    1,    ErResult, ErResult)),
    (Name:'GaSe';   Parameters: (ErResult, 1,    2.47e6,   ErResult, 1,    1,    ErResult, ErResult)),
    (Name:'Ge';     Parameters: (0.7437,   16,   ErResult, ErResult, 0.55, 0.36, 235,      4.774e-4)),
    (Name:'Other';  Parameters: (ErResult, 1,    ErResult, ErResult, 1,    1,    ErResult, ErResult))
    );


   SecDiod='Parameters';
//   ім'я секції в .ini-файлі,
//   де зберігаються параметри діода

type

    TMaterial=class
     private
      FParameters:TMaterialParameters;
     procedure SetAbsValue(Index:integer; value:double);
     procedure SetEpsValue (value:double);

     public
     Constructor Create(MaterialName:TMaterialName);
     procedure ChangeMaterial(value:TMaterialName);

     property Name:string read FParameters.Name;
     property Eg0:double Index 1 read FParameters.Parameters[nEg0] write SetAbsValue;
     property Eps:double read FParameters.Parameters[nEps] write SetEpsValue;
     property ARich_n:double Index 2 read FParameters.Parameters[nARich_n] write SetAbsValue;
     property ARich_p:double Index 6 read FParameters.Parameters[nARich_p] write SetAbsValue;
     property Me:double Index 3 read FParameters.Parameters[nMe] write SetAbsValue;
     property Mh:double Index 7 read FParameters.Parameters[nMh] write SetAbsValue;
     property VarshA:double Index 4 read FParameters.Parameters[nVarshA] write SetAbsValue;
     property VarshB:double Index 5 read FParameters.Parameters[nVarshB] write SetAbsValue;

     procedure ReadFromIniFile(ConfigFile:TIniFile);
     procedure WriteToIniFile(ConfigFile:TIniFile);

     function Varshni(F0,T:double):double;
     function EgT(T:double):double;
      // ширина забороненої зони при температурі Т
     function Nc(T:double):double;
     function Nv(T:double):double;
//    ефективна густина станів в зоні провідності та валентній
     function n_i(T:double):double;
     function Ei(T:double):double;
     {положення рівня Фермі у власному}
     function Vth_n(T:double):double;
     function Vth_p(T:double):double;
     {теплова швидкість електронів та дірок}
     class function VarshniFull(F0,T:double;
                                Alpha:double=VarshA_Si;
                                Betta:double=VarshB_Si):double;
     class function CaugheyThomas(mu_min,mu_0,Nref,Ndoping,Alpha:double):double;
     end; // TMaterial=class

//     TMatParNameLab=array[TMaterialParametersName]of TLabel;

     TMaterialShow=class
       private
         LShowData:array[TMaterialParametersName]of TLabel;
//         LInputData:array[TMaterialParametersName]of TLabel;
         CBSelect:TComboBox;
         Prefix:string;//префікс, щоб відрізняти записи в ini-файлі
         ConfigFile:TIniFile;
         procedure CBSelectChange(Sender: TObject);
         procedure LInputDataClick (Sender: TObject);
         procedure ShowData();
       public
        Material:TMaterial;
        Constructor Create(LSD{,LID}:array of TLabel;
                           CBSel:TComboBox;
                           Pr:string;
                           CF:TIniFile
                           );
        Procedure Free;
     end;   //TMaterialShow=class

    Silicon=class
      private
       class function Rajkanan(Ephoton:double;T:double=300):double;
       {розраховується коефіцієнт поглинання за складною
       формулою, []=1/m}
       class function Green(Lambda:double):double;
       {визначається коефіцієнт поглинання
       pа даними роботи Green & Keevers при 300 К
       [Lambda]=нм, [Result]=1/м}
      public
      class function Eg(T:double=300):double;
      class function A(A0,T,n:double):double;
      {функція A=A0*(T/300)^n}
      class function mu_n(T: Double=300; Ndoping: Double=1e21):double;
      class function mu_p(T: Double=300; Ndoping: Double=1e21):double;
      {рухливості електронів та дірок за формулами з книги
      Schroder, p.503,
      Ndoping - концентрація легуючої домішки,
      []=м^-3
      [Result]=м^2/(В с}
      class function D_n(T: Double=300; Ndoping: Double=1e21):double;
      class function D_p(T: Double=300; Ndoping: Double=1e21):double;
      {коефіцієнт дифузії, []= м^2/с}
      class function Absorption(Lambda:double;T:double=300):double;
      {коефіцієнт поглинання світла,
      [Lambda]=нм, [Result]=1/м}

    end;

    TMaterialLayer=class
      private
       fIsNType:boolean;//тип провідності
       FNd:double; //концентрація носіїв []=m^(-3)
       FMaterial:TMaterial;
       procedure SetNd(value:double);
       procedure SetMaterial(value:TMaterial);
       function  GetARich: Double;
       function  GetMeff: Double;
      public
      property IsNType:boolean read fIsNType write fIsNType;
      property Nd:double read FNd write SetNd;
      property Material:TMaterial read FMaterial write SetMaterial;
      property ARich:Double read GetARich;
      property Meff:Double read GetMeff;
    end; // TMaterialLayer=class



    TMaterialLayerShow=class
     private
      procedure NdRead();
      procedure CBNTypeClick(Sender: TObject);
     public
      NdShow:TParameterShow;
      CBNType:TCheckBox;
      MaterialLayer:TMaterialLayer;
      Constructor Create(ML:TMaterialLayer;
                         CBNT:TCheckBox;
                         STData: TStaticText;
                         STCaption:TLabel
//                         BChange:TButton
          );
      procedure Free;

    end;//TMaterialLayerShow=class

    TDiodMaterial=class
     private
      FArea  :double; //площа []=m^2
      procedure SetArea(value:double);
     public
     property Area:double read FArea write SetArea;
     procedure ReadFromIniFile(ConfigFile:TIniFile);virtual;abstract;
     procedure WriteToIniFile(ConfigFile:TIniFile);virtual;abstract;
    end;//  TDiod=class

    TDiod_Schottky=class(TDiodMaterial)
     private
      FEps_i:double; //діелектрична проникність діелектрика
      FThick_i :double; //товщина діелектричного шару []=m
      FSemiconductor:TMaterialLayer;
     procedure SetThick(value:double);
     procedure SetEps (value:double);
     procedure SetMaterialLayer(value:TMaterialLayer);
//     function GetMaterial():TMaterial;
     function Get_nu():double;

     public
     Constructor Create;
     Procedure Free;
     property Eps_i:double read FEps_i write SetEps;
     property Thick_i:double read FThick_i write SetThick;
     property Semiconductor:TMaterialLayer read FSemiconductor write SetMaterialLayer;
//     property Material:TMaterial read GetMaterial;
     property nu:double read Get_nu;

     procedure ReadFromIniFile(ConfigFile:TIniFile); override;
     procedure WriteToIniFile(ConfigFile:TIniFile);override;

     function kTln(T:double):double;
     {повертає значення kT ln(Area*ARich*T^2)}
     function I0(T,Fb:double):double;
     {повертає струм насичення
     I0=Area*Arich*T^*exp(-Fb/Kb/T)}
     function Fb(T,I0:double):double;
     {повертає висоту бар'єру
     Fb=kT*ln(Area*ARich*T^2/I0)}
     function Vbi(T:double):double;
     {об'ємний потенціал (build in)}
     function Em(T,Fb0:double;Vrev:double=0;C1:double=0):double;
     {максимальне значення електричного поля}
     end; // TDiod=class

     TDiod_SchottkyShow=class
       private
        SemiconductorShow:TMaterialLayerShow;
        AreaShow,Eps_iShow,Thick_iShow:TParameterShow;
        procedure AreaRead();
        procedure EpsRead();
        procedure ThickRead();
       public
        Diod_Schottky:TDiod_Schottky;
        Constructor Create(DSc:TDiod_Schottky;
                         CBNT:TCheckBox;
                         STDataNd,STDataArea,STDataEps,STDataThick: TStaticText;
                         STCaptionNd,STCaptionArea,STCaptionEps,STCaptionThick:TLabel
          );
        procedure Free;
     end;

     TDiod_PN=class(TDiodMaterial)
      private
       FLayerN:TMaterialLayer;
       FLayerP:TMaterialLayer;
       function GetNd():double;
      public
       Constructor Create;
       procedure Free;
       property LayerN:TMaterialLayer read FLayerN write FLayerN;
       property LayerP:TMaterialLayer read FLayerP write FLayerP;
       property Nd:double read GetNd;
       {рівень легування для шару з більшим опором}
       procedure ReadFromIniFile(ConfigFile:TIniFile); override;
       procedure WriteToIniFile(ConfigFile:TIniFile);override;
       function Vdif(T:double;V:double=0):double;
       {дифузійний потенціал, пряма напруга V додатня, зворотня від'ємна, []=B}
       function W(T:double;V:double=0):double;
       {ширина ОПЗ, пряма напруга V додатня, зворотня від'ємна, []=м}
       function Wp(T:double;V:double=0):double;
       {ширина ОПЗ в р-області, пряма напруга V додатня, зворотня від'ємна, []=м}
       function Wn(T:double;V:double=0):double;
       {ширина ОПЗ в n-області, пряма напруга V додатня, зворотня від'ємна, []=м}
       function Rnp(T,V,I:double):double;
       {приведена швидкість рекомбінації, []=c^-1
       I - струм через діод}
       function n_i(T:double=300):double;
       {концентрація власних носіїв
       у шарі з більшим опором}
       function mu(T:double=300):double;
       {рухливість неосновних носіїв
       у шарі з більшим опором;
       правда використовується рухливість
       у кремнії}
       function TauRec(Igen, T: Double):double;
       {час рекомбінації по величині дифузійного струму;
       вважається що рекомбінація відбувається в області
       з меншою провідністю;}
       function Igen(TauRec, T: Double):double;
       {функція, зворотня до попередньої}
       function TauToLdif(tau,T:double):double;
       {довжина дифузії для неосновних
       носіїв в області з меншою провідністю
       tau - час життя цих носіїв}
       function LdifToTauRec(L,T:double):double;
       {зворотня функція}
       function TauGen(Iscr, T: Double):double;
       {час рекомбінації в ОПЗ по рекомбінаційного струму}
       function Iscr(TauGen, T, Voltage: Double):double;
       {функція, зворотня до попередньої}
       function fi(x,T:double;V:double=0):double;
       {значення потенціалу в ОПЗ,
       якщо х<0 - то це точка в n-області,
       перевірки на те що х має знаходитися
       в інтервалі [-Wn, Wp] нема;
       вважається що 0 відповідає
       точці x=-Wn}
       function n_SCR(x,T:double;V:double=0):double;
       function p_SCR(x,T:double;V:double=0):double;
       {повертає значення концентрації електронів (дірок)
       в точці ОПЗ з координатою х
       якщо х<0 - то це точка в n-області,
       перевірки на те що х має знаходитися
       в інтервалі [-Wn, Wp] нема}
       function R_Shockley(x,T:double;V:double=0):double;
       {темп рекомбінації згідно механізма Шоклі-Ріда
       в в точці ОПЗ з координатою х}
       function R_DAP(x,T:double;V:double=0):double;
       {темп рекомбінації згідно з механізмом
       міждефектної рекомбінації
        JApplPhys_78_3185.pdf}
       function I_Shockley(T,V:double):double;
       {струм в ОПЗ, розрахований по темпу рекомбінації}
       function Iscr_rec(T,V,tau_n,Kpn,Et:double):double;overload;
       {рекомбінаційний струм в ОПЗ, розрахований
       за теорією Шоклі в загальному вигляді
       формули з Proc23IEEE_PVSC_1993_p321-326.pdf
       tau_n - рекомбінаційний параметр для електронів
               (=1/(sigma_n*Vth*Nt))
       Kpn=tau_p/tau_n;
       Et - положення рівня відносно Ev
       }
       function Iscr_rec(T,V:double):double;overload;
    end; // TDiod_PN=class(TDiodMaterial)

    TDiod_PNShow=class
       private
        LayerNShow:TMaterialLayerShow;
        LayerPShow:TMaterialLayerShow;
        AreaShow:TParameterShow;
        procedure AreaRead();
       public
        Diod_PN:TDiod_PN;
        Constructor Create(Dpn:TDiod_PN;
                         CBNTn,CBNTp:TCheckBox;
                         STDataNdN,STDataNdP,STDataArea: TStaticText;
                         STCaptionNdN,STCaptionNdP,STCaptionArea:TLabel
          );
        procedure Free;
    end;



var
  Diod:TDiod_Schottky;
  DiodPN:TDiod_PN;

Function PAT(V,kT1,Fb0,a,hw,Nss{Parameters[0]},E{Parameters[1]}:double;Sample:TDiod_Schottky):double;

Procedure AllSCR(DiodPN:TDiod_PN;
                 var Vec:PVector;Func:TFunTriple;
                 T:double=300;V:double=0;
                 FileName:string='';
                 Npoint:integer=100);
{в Vec розміщується щось, що розраховується
в кожній точці ОПЗ діода DiodPN;
Npoint - кількість відрізків, на які ділиться
ОПЗ в n-області та ОПЗ в р-області,
Vec^.Y[i]=Func(Vec^.X[i],T,V)
Якщо FileName<>'', то отримана залежність
записується у файл
}


implementation

uses
  Controls, Graphics, Math;

procedure TMaterial.SetAbsValue(Index:integer; value: Double);
begin
case Index of
 1: FParameters.Parameters[nEg0]:=abs(value);
 2: FParameters.Parameters[nARich_n]:=abs(value);
 6: FParameters.Parameters[nARich_p]:=abs(value);
 3: FParameters.Parameters[nMe]:=abs(value);
 7: FParameters.Parameters[nMh]:=abs(value);
 4: FParameters.Parameters[nVarshA]:=abs(value);
 5: FParameters.Parameters[nVarshB]:=abs(value);
 end;
end;

procedure TMaterial.SetEpsValue(value: Double);
begin
 if value>1 then FParameters.Parameters[nEps]:=value
            else FParameters.Parameters[nEps]:=1;
end;

function TMaterial.Varshni(F0,T:double):double;
begin
  Result:=VarshniFull(F0,T,VarshA,VarshB);
//  Result:=F0-sqr(T)*VarshB/(T+VarshA);
end;

class function TMaterial.VarshniFull(F0,T:double;
                                Alpha:double=VarshA_Si;
                                Betta:double=VarshB_Si):double;
begin
 Result:=F0-sqr(T)*Betta/(T+Alpha);
end;

function TMaterial.Vth_n(T: double): double;
begin
 if Name='Si' then
      begin
       Result:=sqrt(8*Qelem*Kb*T/m0/Pi/0.28);
       Exit;
      end;
 {J.Appl.Phys., 67, p2944}
 if Me=ErResult then Result:=ErResult
                else Result:=sqrt(3*Qelem*Kb*T/m0/Me)
end;

function TMaterial.Vth_p(T: double): double;
begin
 if Name='Si' then
      begin
       Result:=sqrt(8*Qelem*Kb*T/m0/Pi/0.41);
       Exit;
      end;
 {J.Appl.Phys., 67, p2944}
 if Mh=ErResult then Result:=ErResult
                else Result:=sqrt(3*Qelem*Kb*T/m0/Mh)
end;

Constructor TMaterial.Create(MaterialName:TMaterialName);
begin
  inherited Create;
  ChangeMaterial(MaterialName);
end;

class function TMaterial.CaugheyThomas(mu_min, mu_0, Nref, Ndoping,
  Alpha:double): double;
begin
 Result:=mu_min+mu_0/(1+Power(Ndoping/Nref,Alpha));
end;

procedure TMaterial.ChangeMaterial(value:TMaterialName);
begin
 FParameters:=Materials[value];
end;


function TMaterial.EgT(T: Double):Double;
begin
 if Eg0=ErResult then Result:=ErResult
                 else Result:=Varshni(Eg0,T);
end;

function TMaterial.Ei(T: double): double;
begin
 if Name='Si' then
      begin
       Result:=EgT(T)+Kb*T*ln(n_i(T)/Nc(T));
       Exit;
      end;
 if (Eg0=ErResult)or
    (Me=ErResult)or
    (Mh=ErResult)   then Result:=ErResult
                    else
                    Result:=0.5*(EgT(T)+Kb*T*ln(Nv(T)/Nc(T)));

end;

function TMaterial.Nc(T:double):double;
//    ефективна густина станів
begin
 if Name='Si' then
      begin
       Result:=2.86e25*Power(T/300.0,1.58);
       Exit;
      end;
 {J.Appl.Phys., 67, p2944}
 if Me=ErResult then Result:=ErResult
                else Result:=2.5e25*Me*(T/300.0)*sqrt(Me*T/300.0);
end;

function TMaterial.Nv(T: double): double;
begin
 if Name='Si' then
      begin
       Result:=3.1e25*Power(T/300.0,1.85);
       Exit;
      end;
 {J.Appl.Phys., 67, p2944}       
 if Mh=ErResult then Result:=ErResult
                else Result:=2.5e25*Mh*(T/300.0)*sqrt(Mh*T/300.0);
end;

function TMaterial.n_i(T: double): double;
begin
 if Name='Si' then
      begin
       Result:=1.64e21*Power(T,1.706)*exp(-EgT(T)/2/T/Kb);
       Exit;
      end;
 Result:=ErResult;
 if Eg0=ErResult then Exit;
 if (Mh=ErResult)or(Me=ErResult) then Exit;
 Result:=sqrt(Nc(T)*Nv(T)*exp(-EgT(T)/T/Kb));
end;

procedure TMaterial.ReadFromIniFile(ConfigFile:TIniFile);
var i:TMaterialParametersName;
begin
  for I := Low(TMaterialParametersName) to High(TMaterialParametersName) do
    FParameters.Parameters[i]:=
        ConfigFile.ReadFloat(Name,
                             GetEnumName(TypeInfo(TMaterialParametersName),ord(i)),
                             Materials[High(TMaterialName)].Parameters[i]);
end;

procedure TMaterial.WriteToIniFile(ConfigFile:TIniFile);
var i:TMaterialParametersName;
begin
  ConfigFile.EraseSection(Name);
  for I := Low(TMaterialParametersName) to High(TMaterialParametersName) do
   if FParameters.Parameters[i]<> Materials[High(TMaterialName)].Parameters[i]
     then ConfigFile.WriteFloat(Name,
                          GetEnumName(TypeInfo(TMaterialParametersName),ord(i)),
                          FParameters.Parameters[i]);
 end;

//--------------------------- TDiodSample ----------------------

//procedure TDiodSample.SetAbsValue(Index:integer; value: Double);
//begin
//case Index of
// 1: FArea:=abs(value);
// 2: FNd:=abs(value);
// 3: FThick_i:=abs(value);
// end;
//end;
//
//procedure TDiodSample.SetEpsValue(value: Double);
//begin
// if value>1 then FEps_i:=value
//            else FEps_i:=1;
//end;
//
//procedure TDiodSample.ReadFromIniFile(ConfigFile:TIniFile);
//begin
//  Area:=ConfigFile.ReadFloat(SecDiod,'Square',3.14e-6);
//  Nd:=ConfigFile.ReadFloat(SecDiod,'Concentration',5e21);
//  Eps_i:=ConfigFile.ReadFloat(SecDiod,'InsulPerm',4.1);
//  Thick_i:=ConfigFile.ReadFloat(SecDiod,'InsulDepth',3e-9);
//end;
//
//procedure TDiodSample.WriteToIniFile(ConfigFile:TIniFile);
//begin
//  ConfigFile.EraseSection(SecDiod);
//  ConfigFile.WriteFloat(SecDiod,'Square',Area);
//  ConfigFile.WriteFloat(SecDiod,'Concentration',Nd);
//  ConfigFile.WriteFloat(SecDiod,'InsulPerm',Eps_i);
//  ConfigFile.WriteFloat(SecDiod,'InsulDepth',Thick_i);
//end;
//
//procedure TDiodSample.SetMaterial(value:TMaterial);
//  begin
//   if Value = nil then
//      Value:=TMaterial.Create(High(TMaterialName));
//   FMaterial:=value;
//  end;
//
//function TDiodSample.Get_nu():double;
//begin
//  Result:=Eps0*Material.Eps/Qelem/Nd;
//end;
//
//function TDiodSample.kTln(T:double):double;
//{повертає значення kT ln(Area*ARich*T^2)}
//  begin
//    Result:=Kb*T*ln(Area*Material.ARich*sqr(T));
//  end;
//
//function TDiodSample.I0(T,Fb:double):double;
//{повертає струму насичення
//I0=Area*Arich*T^*exp(-Fb/Kb/T)}
//begin
// try
//  Result:=Area*Material.Arich*sqr(T)*exp(-Fb/Kb/T);
// except
//     Result:=ErResult;
// end;
//end;
//
//function TDiodSample.Fb(T,I0:double):double;
//{повертає висоту бар'єру
//Fb=kT*ln(Area*ARich*T^2/I0)}
//  begin
//    try
//     Result:=Kb*T*ln(Area*Material.Arich*sqr(T)/I0);
//    except
//     Result:=ErResult;
//    end;
//  end;
//
//function TDiodSample.Vbi(T:double):double;
//{об'ємний потенціал (build in)}
//  begin
//   try
//    Result:=Kb*T*ln(Material.Nc(T)/Nd);
//    except
//     Result:=ErResult;
//   end;
//  end;
//
////function TDiodSample.Em(T,Fb0:double;Vrev:double=0):double;
////{максимальне значення електричного поля}
////begin
//// try
////  Result:=sqrt(2*Qelem*Nd/Material.Eps/Eps0*
////            (Material.Varshni(Fb0,T)-Vbi(T)+Vrev));
//// except
////  Result:=ErResult;
//// end;
////end;
//
//function TDiodSample.Em(T,Fb0:double;Vrev:double=0;C1:double=0):double;
//{максимальне значення електричного поля}
// var a,b,c,Fb,Fa:double;
//     i:integer;
// function FunEmTemp(Emtemp:double):double;
//  begin
//   try
//    Result:=Emtemp-sqrt(2*Qelem*Nd/Material.Eps/Eps0*
//            (Material.Varshni(Fb0,T)-C1*Emtemp-Vbi(T)+Vrev));
//   except
//    Result:=ErResult;
//   end;
//  end;
//
//begin
// Result:=ErResult;
// try
//  if (C1=0) then
//   begin
//   Result:=sqrt(2*Qelem*Nd/Material.Eps/Eps0*
//            (Material.Varshni(Fb0,T)-Vbi(T)+Vrev));
//   end
//                     else
//   begin
//    a:=0;
//    b:=sqrt(2*Qelem*Nd/Material.Eps/Eps0*
//            (Material.Varshni(Fb0,T)-Vbi(T)+Vrev));
//
//    Fa:=FunEmTemp(a);
//    Fb:=FunEmTemp(b);
//    if (Fa=ErResult)or(Fb=ErResult) then Exit;
//    repeat
//     if Fb*Fa<=0 then Break;
//     b:=2*b;
//     Fb:=FunEmTemp(b);
//    until false;
//    i:=0;
//    repeat
//      inc(i);
//      c:=(a+b)/2;
//      Fb:=FunEmTemp(c);
//      Fa:=FunEmTemp(a);
//      if (Fb*Fa<=0) or (Fb=ErResult)
//        then b:=c
//        else a:=c;
//    until (i>1e5)or(abs((b-a)/c)<1e-4);
//    if (i>1e5) then Exit;
//    Result:=c;
//   end;
// except
////  Result:=ErResult;
// end;
//end;


Function PAT(V,kT1,Fb0,a,hw,Nss{Parameters[0]},E{Parameters[1]}:double;Sample:TDiod_Schottky):double;
var g,gam,gam1,qE,Et:double;
begin


  qE:=Qelem*Sample.Em(1/(kT1*Kb),Fb0,V);

  Et:=E*Qelem;

  g:=a*sqr(hw*Qelem)*(1+2/(exp(hw*kT1)-1));
  gam:=sqrt(2*m0*Sample.Semiconductor.Meff)*g/(Hpl*qE*sqrt(Et));
  gam1:=sqrt(1+sqr(gam));
  Result:=Sample.Area*Nss*qE/sqrt(8*m0*Sample.Semiconductor.Meff*E)*sqrt(1-gam/gam1)*
          exp(-4*sqrt(2*m0*Sample.Semiconductor.Meff)*Et*sqrt(Et)/(3*Hpl*qE)*
              sqr(gam1-gam)*(gam1+0.5*gam));
// showmessage('gam1='+floattostr(gam1)+'  Res='+floattostr(Result));

end;

Procedure AllSCR(DiodPN:TDiod_PN;
                 var Vec:PVector;Func:TFunTriple;
                 T:double=300;V:double=0;
                 FileName:string='';
                 Npoint:integer=100);
// const Npoint=100;
 var i:integer;
     step,X{,T,V}:double;
//     Vec:PVector;
begin
// new(Vec);
// T:=300;
// V:=0.1;
 Vec.Clear;
 step:=DiodPN.Wn(T,V)/Npoint;
 for I := 0 to Npoint do
   begin
    X:=-DiodPN.Wn(T,V)+step*i;
    Vec.Add(X,Func(X,T,V));
   end;
 step:=DiodPN.Wp(T,V)/Npoint;
 for I := 1 to Npoint do
   begin
    X:=step*i;
    Vec.Add(X,Func(X,T,V));
   end;
 if FileName<>'' then Vec.Write_File(FileName);

// Vec.Clear;
// step:=DiodPN.Wn(T,V)/Npoint;
// for I := 0 to Npoint do
//   begin
//    X:=-DiodPN.Wn(T,V)+step*i;
////    Vec.Add(X,sqrt(DiodPN.FLayerP.FMaterial.Nc(T)*DiodPN.FLayerP.FMaterial.Nv(T)*
////                   exp(-DiodPN.FLayerP.FMaterial.EgT(T)/Kb/T)));
//    Vec.Add(X,DiodPN.p_SCR(X,T,V));
//   end;
// step:=DiodPN.Wp(T,V)/Npoint;
// for I := 1 to Npoint do
//   begin
//    X:=step*i;
////    Vec.Add(X,sqrt(DiodPN.FLayerP.FMaterial.Nc(T)*DiodPN.FLayerP.FMaterial.Nv(T)*
////                   exp(-DiodPN.FLayerP.FMaterial.EgT(T)/Kb/T)));
//    Vec.Add(X,DiodPN.p_SCR(X,T,V));
//   end;
// Vec.Write_File('pSCR.dat');
//
// Dispose(Vec);
end;

{ TMaterialShow }

procedure TMaterialShow.CBSelectChange(Sender: TObject);
begin
 if Material.Name=CBSelect.Text then Exit;
 if (Material.Name=Materials[High(TMaterialName)].Name) then
   Material.WriteToIniFile(ConfigFile);
 Material.ChangeMaterial(TMaterialName(CBSelect.ItemIndex));
 if (CBSelect.Text=Materials[High(TMaterialName)].Name) then
   Material.ReadFromIniFile(ConfigFile);
 ShowData();
end;

constructor TMaterialShow.Create(LSD{, LID}: array of TLabel;
                                 CBSel: TComboBox;
                                 Pr: string;
                                 CF:TIniFile
                                 );
  var i:integer;
      iMPN:TMaterialParametersName;
begin
  inherited Create;
  Prefix:=Pr;
  ConfigFile:=CF;
  if High(LSD)<ord(High(TMaterialParametersName))
    then
    showmessage('Label array is deficient for material parameters');
  

  for I := ord(Low(TMaterialParametersName)) to ord(High(TMaterialParametersName)) do
//   begin
    LShowData[TMaterialParametersName(i)]:=LSD[i];
//    LInputData[TMaterialParametersName(i)]:=LID[i];
//    LInputData[TMaterialParametersName(i)].OnClick:=LInputDataClick;
//  end;

  for IMPN := Low(TMaterialParametersName) to High(TMaterialParametersName) do
       case iMPN of
        nMe,nARich_n:LShowData[IMPN].Font.Color:=clBlue;
        nMh,nARich_p:LShowData[IMPN].Font.Color:=clRed;
        else LShowData[IMPN].Font.Color:=clGreen;
       end;

  CBSelect:=CBSel;
  CBSelect.Sorted:=False;
  for i :=Ord(Low(TMaterialName)) to ord(High(TMaterialName)) do
      CBSelect.Items.Add(Materials[TMaterialName(i)].Name);
  CBSelect.ItemIndex:=ConfigFile.ReadInteger(SecDiod,Prefix+'Material',0);
  CBSelect.OnChange:=CBSelectChange;

 Material:=TMaterial.Create(TMaterialName(CBSelect.ItemIndex));
 if Material.Name=Materials[High(TMaterialName)].Name
    then Material.ReadFromIniFile(ConfigFile);

 ShowData();
end;

procedure TMaterialShow.Free;
begin
  ConfigFile.WriteInteger(SecDiod,Prefix+'Material',CBSelect.ItemIndex);
  if Material.Name=Materials[High(TMaterialName)].Name
      then  Material.WriteToIniFile(ConfigFile);
  inherited Free;
end;

procedure TMaterialShow.LInputDataClick(Sender: TObject);
 var
//     Value:double;
     st:string;
     i:TMaterialParametersName;
begin
  for I := Low(TMaterialParametersName) to High(TMaterialParametersName) do
//    if (Sender as TLabel)=LInputData[i] then
    if (Sender as TLabel)=LShowData[i] then
      begin
        st:=LShowData[i].Caption;
        if (st='ErResult')or(st='?') then st:='';
        st:=InputBox('Input value',
                     'the material parameter value is expected',
                     st);
        StrToNumber(st, ErResult, Material.FParameters.Parameters[i]);
//        Material.FParameters.Parameters[i]:=Value;
      end;
  ShowData();
end;

procedure TMaterialShow.ShowData;
 var i:TMaterialParametersName;
     temp:string;
begin
  for I := Low(TMaterialParametersName) to High(TMaterialParametersName) do
   begin

    if Material.FParameters.Parameters[i]<>ErResult then
     begin
       case i of
        nEg0,nEps,nMe,nMh:temp:=FloatToStrF(Material.FParameters.Parameters[i],ffFixed,3,2);
//        nARich_n,nArich_p,nVarshB:temp:=FloatToStrF(Material.FParameters.Parameters[i],ffExponent,3,2);
        nVarshA:temp:=FloatToStrF(Material.FParameters.Parameters[i],ffgeneral,5,1);
        else temp:=FloatToStrF(Material.FParameters.Parameters[i],ffExponent,3,2);
       end;
     end
                                                    else
     temp:='?';
    LShowData[i].Caption:=temp;
   end;

  if Material.Name=Materials[High(TMaterialName)].Name then
   for I := Low(TMaterialParametersName) to High(TMaterialParametersName) do
     begin
//       LInputData[i].Visible:=True;
       LShowData[i].OnClick:=LInputDataClick;
       LShowData[i].Cursor:=crHandPoint;
     end
                                                       else
   for I := Low(TMaterialParametersName) to High(TMaterialParametersName) do
     begin
//       LInputData[i].Visible:=False;
       LShowData[i].OnClick:=nil;
       LShowData[i].Cursor:=crDefault;
     end;
end;



function TMaterialLayer.GetARich: Double;
begin
 try
  if IsNType then Result:=Material.ARich_n
             else Result:=Material.ARich_p;
 except
  Result:=ErResult;
 end;
end;

function TMaterialLayer.GetMeff: Double;
begin
 try
  if IsNType then Result:=Material.Me
             else Result:=Material.Mh;
 except
  Result:=1;
 end;
end;


procedure TMaterialLayer.SetMaterial(value: TMaterial);
begin
   if Value = nil then
      Value:=TMaterial.Create(High(TMaterialName));
   FMaterial:=value;
end;

procedure TMaterialLayer.SetNd(value: Double);
begin
  fNd:=abs(value);
end;

{ TDiod }
procedure TDiodMaterial.SetArea(value: Double);
begin
  fArea:=abs(value);
end;

{ TDiod_Schottky }

constructor TDiod_Schottky.Create;
begin
 inherited Create;
 FSemiconductor:=TMaterialLayer.Create;
end;

procedure TDiod_Schottky.Free;
begin
 FSemiconductor.Free;
 inherited Free;
end;

procedure TDiod_Schottky.ReadFromIniFile(ConfigFile: TIniFile);
begin
  Area:=ConfigFile.ReadFloat(SecDiod,'Square Schottky',3.14e-6);
  Semiconductor.Nd:=ConfigFile.ReadFloat(SecDiod,'Concentration Schottky',5e21);
  Semiconductor.IsNType:=ConfigFile.ReadBool(SecDiod,'Layer type Schottky',True);
  Eps_i:=ConfigFile.ReadFloat(SecDiod,'InsulPerm',4.1);
  Thick_i:=ConfigFile.ReadFloat(SecDiod,'InsulDepth',3e-9);
end;

procedure TDiod_Schottky.WriteToIniFile(ConfigFile: TIniFile);
begin
  ConfigFile.WriteFloat(SecDiod,'Square Schottky',Area);
  ConfigFile.WriteFloat(SecDiod,'Concentration Schottky',Semiconductor.Nd);
  ConfigFile.WriteFloat(SecDiod,'InsulPerm',Eps_i);
  ConfigFile.WriteFloat(SecDiod,'InsulDepth',Thick_i);
  ConfigFile.WriteBool(SecDiod,'Layer type Schottky',Semiconductor.IsNType);
end;

procedure TDiod_Schottky.SetEps(value: double);
begin
 if value>1 then FEps_i:=value
            else FEps_i:=1;
end;

procedure TDiod_Schottky.SetMaterialLayer(value: TMaterialLayer);
begin
   if Value = nil then
      Value:=TMaterialLayer.Create;
   FSemiconductor:=value;
end;


procedure TDiod_Schottky.SetThick(value: double);
begin
 FThick_i:=abs(value);
end;

function TDiod_Schottky.Vbi(T: double): double;
{об'ємний потенціал (build in)}
  begin
   try
    Result:=Kb*T*ln(Semiconductor.Material.Nc(T)/Semiconductor.Nd);
    except
     Result:=ErResult;
   end;
  end;

function TDiod_Schottky.Em(T, Fb0, Vrev, C1: double): double;
{максимальне значення електричного поля}
 var a,b,c,Fb,Fa:double;
     i:integer;
 function FunEmTemp(Emtemp:double):double;
  begin
   try
    Result:=Emtemp-sqrt(2*Qelem*Semiconductor.Nd/Semiconductor.Material.Eps/Eps0*
            (Semiconductor.Material.Varshni(Fb0,T)-C1*Emtemp-Vbi(T)+Vrev));
   except
    Result:=ErResult;
   end;
  end;

begin
 Result:=ErResult;
 try
  if (C1=0) then
   begin
   Result:=sqrt(2*Qelem*Semiconductor.Nd/Semiconductor.Material.Eps/Eps0*
            (Semiconductor.Material.Varshni(Fb0,T)-Vbi(T)+Vrev));
   end
                     else
   begin
    a:=0;
    b:=sqrt(2*Qelem*Semiconductor.Nd/Semiconductor.Material.Eps/Eps0*
            (Semiconductor.Material.Varshni(Fb0,T)-Vbi(T)+Vrev));

    Fa:=FunEmTemp(a);
    Fb:=FunEmTemp(b);
    if (Fa=ErResult)or(Fb=ErResult) then Exit;
    repeat
     if Fb*Fa<=0 then Break;
     b:=2*b;
     Fb:=FunEmTemp(b);
    until false;
    i:=0;
    repeat
      inc(i);
      c:=(a+b)/2;
      Fb:=FunEmTemp(c);
      Fa:=FunEmTemp(a);
      if (Fb*Fa<=0) or (Fb=ErResult)
        then b:=c
        else a:=c;
    until (i>1e5)or(abs((b-a)/c)<1e-4);
    if (i>1e5) then Exit;
    Result:=c;
   end;
 except
//  Result:=ErResult;
 end;
end;


function TDiod_Schottky.Fb(T, I0: double): double;
{повертає висоту бар'єру
Fb=kT*ln(Area*ARich*T^2/I0)}
 begin
  try
   if Semiconductor.ARich=ErResult then
         Result:=ErResult
                                   else
         Result:=Kb*T*ln(Area*Semiconductor.Arich*sqr(T)/I0);
  except
   Result:=ErResult;
  end;
 end;

//function TDiod_Schottky.GetMaterial: TMaterial;
//begin
// Result:=FSemiconductor.Material;
//end;

function TDiod_Schottky.Get_nu: double;
begin
 try
  Result:=Eps0*Semiconductor.Material.Eps/Qelem/Semiconductor.Nd;
 except
   Result:=ErResult;
 end;
end;

function TDiod_Schottky.I0(T, Fb: double): double;
{повертає струму насичення
I0=Area*Arich*T^*exp(-Fb/Kb/T)}
begin
  try
   if Semiconductor.ARich=ErResult then
         Result:=ErResult
                                   else
         Result:=Area*Semiconductor.ARich*sqr(T)*exp(-Fb/Kb/T);
  except
   Result:=ErResult;
  end;
end;

function TDiod_Schottky.kTln(T: double): double;
{повертає значення kT ln(Area*ARich*T^2)}
 begin
  try
   if Semiconductor.ARich=ErResult then
     Result:=ErResult
                                   else
     Result:=Kb*T*ln(Area*Semiconductor.ARich*sqr(T));
  except
   Result:=ErResult;
  end;
 end;


{ TMaterialLayerShow }

procedure TMaterialLayerShow.CBNTypeClick(Sender: TObject);
begin
 MaterialLayer.IsNType:=CBNType.Checked;
end;

constructor TMaterialLayerShow.Create(ML: TMaterialLayer;
                                      CBNT: TCheckBox;
                                      STData: TStaticText;
                                      STCaption:TLabel
//                                      BChange: TButton
                                      );
begin
  inherited Create;
  MaterialLayer:=ML;
  CBNType:=CBNT;
  CBNType.Caption:='n-type';
  CBNType.Checked:=MaterialLayer.IsNType;
  CBNType.OnClick:=CBNTypeClick;

  NdShow:=TParameterShow.Create(STData,STCaption,
                               'Carrier concentration, m^(-3):',
//                               BChange,'input',
                               'Carrier concentration',
                               'Input carrier concentration, [ ] = m^(-3)',
                               MaterialLayer.Nd);
  NdShow.Hook:=NdRead;                             
end;

procedure TMaterialLayerShow.Free;
begin
 NdShow.Free;
 inherited Free;
end;

procedure TMaterialLayerShow.NdRead;
begin
  MaterialLayer.Nd:=NdShow.Data;
end;

{ TDiod_SchottkyShow }

procedure TDiod_SchottkyShow.AreaRead;
begin
  Diod_Schottky.Area:=AreaShow.Data;
end;

constructor TDiod_SchottkyShow.Create(DSc: TDiod_Schottky;
             CBNT: TCheckBox;
             STDataNd, STDataArea, STDataEps, STDataThick: TStaticText; STCaptionNd,
             STCaptionArea, STCaptionEps, STCaptionThick: TLabel
//             BChangeNd, BChangeArea,BChangeEps, BChangeThick: TButton
             );
begin
 inherited Create;
 Diod_Schottky:=DSc;
 SemiconductorShow:=TMaterialLayerShow.Create(Diod_Schottky.Semiconductor,
                       CBNT,STDataNd,STCaptionNd);
 AreaShow:=TParameterShow.Create(STDataArea,STCaptionArea,
                               'Area, m^2:',
                               'Diode area',
                               'Input contact area, [ ] = m^2',
                               Diod_Schottky.Area);
  AreaShow.Hook:=AreaRead;
  Eps_iShow:=TParameterShow.Create(STDataEps,STCaptionEps,
                               'Permittivity:',
                               'Layer permittivity',
                               'Permittivity of the interfacial insulator layer',
                               Diod_Schottky.Eps_i);
  Eps_iShow.Hook:=EpsRead;
  Thick_iShow:=TParameterShow.Create(STDataThick,STCaptionThick,
                               'Thickness, m:',
                               'Layer thickness',
                               'Thickness of the interfacial insulator layer, [ ] = m',
                               Diod_Schottky.FThick_i);
  Thick_iShow.Hook:=ThickRead;
end;

procedure TDiod_SchottkyShow.EpsRead;
begin
  Diod_Schottky.Eps_i:=Eps_iShow.Data;
end;

procedure TDiod_SchottkyShow.Free;
begin
 Thick_iShow.Free;
 Eps_iShow.Free;
 AreaShow.Free;
 SemiconductorShow.Free;
 inherited Free;
end;

procedure TDiod_SchottkyShow.ThickRead;
begin
  Diod_Schottky.Thick_i:=Thick_iShow.Data;
end;

{ TDiod_PN }

constructor TDiod_PN.Create;
begin
 inherited Create;
 FLayerN:=TMaterialLayer.Create;
 FLayerN.IsNType:=True;
 FLayerP:=TMaterialLayer.Create;
 FLayerP.IsNType:=False;
end;

function TDiod_PN.fi(x, T: double;V:double=0): double;
begin
 if x<0 then
   Result:=Qelem*FLayerN.Nd/(2*FLayerP.Material.Eps*Eps0)*
           sqr(Wn(T,V)+x)
        else
   Result:=Vdif(T,V)-Qelem*FLayerP.Nd/(2*FLayerP.Material.Eps*Eps0)*
           sqr(Wp(T,V)-x);
end;

procedure TDiod_PN.Free;
begin
 FLayerN.Free;
 FLayerP.Free;
 inherited Free;
end;

function TDiod_PN.GetNd: double;
begin
  if FLayerN.Nd>FLayerP.Nd then
    Result:=FLayerP.Nd
                           else
   Result:=FLayerN.Nd;
end;

function TDiod_PN.Igen(TauRec, T: Double): double;
begin
  Result:=Qelem*Area*Power(n_i(T),2)/Nd*sqrt(mu(T)*Kb*T/TauRec);
end;

function TDiod_PN.Iscr(TauGen, T, Voltage: Double): double;
begin
 Result:=Qelem*Area*n_i(T)*W(T,Voltage)/2/TauGen;
end;

function TDiod_PN.Iscr_rec(T, V: double): double;
 var tau_n, Kpn, Et: double;
begin
 Result:=0;
// tau_n:=1e-6;
// Kpn:=1e-3;
// Et:=0.75;
// Result:=Iscr_rec(T, V, tau_n, Kpn, Et){+Igen(1e-7,T)*exp(V/Kb/T)};
 tau_n:=1e-9;
 Kpn:=1e-2;
 Et:=0.5;
 Result:=Result+Iscr_rec(T, V, tau_n, Kpn, Et){+Igen(1e-7,T)*exp(V/Kb/T)};

end;

function TDiod_PN.Iscr_rec(T, V, tau_n, Kpn, Et: double): double;
 var kT,Tetta,b,Er0,ff,Alpha,Betta:double;
begin
 kT:=Kb*T;
 Tetta:=(Vdif(T,V)-V)/kT;
 Er0:=FLayerP.Material.Ei(T)-kT/2*ln(Kpn);
 b:=exp(-V/2/kT)*cosh((Et-Er0)/kT);
 Alpha:=2*sinh(Tetta/2);
 Betta:=sqrt(FLayerP.Nd/FLayerN.Nd/Kpn)+
        sqrt(FLayerN.Nd/FLayerP.Nd*Kpn)+
        2*b*cosh(Tetta/2);
 if sqr(b)<1 then
         ff:=ArcTan(Alpha/Betta*sqrt(1-sqr(b)))/sqrt(1-sqr(b))
    else if sqr(b)>1 then
         ff:=ArcTanh(Alpha/Betta*sqrt(sqr(b)-1))/sqrt(sqr(b)-1)
      else
         ff:=Alpha/Betta;

 Result:=2*Area*Qelem*FLayerP.Material.n_i(T)*sinh(V/2/kT)/
         (tau_n*sqrt(Kpn))*W(T,V)/Tetta*ff;
end;

function TDiod_PN.I_Shockley(T, V: double): double;
 var Vec:PVector;
begin
  new(Vec);
  AllSCR(Self,Vec,R_Shockley,T,V);
//  AllSCR(Self,Vec,R_DAP,T,V,'dd.dat',10);
//  AllSCR(Self,Vec,R_DAP,T,V,'dd.dat');
//  AllSCR(Self,Vec,R_DAP,T,V);
  Result:=Area*Qelem*Int_Trap(Vec);
  dispose(Vec);
end;



function TDiod_PN.TauToLdif(tau, T: double): double;
begin
 Result:=sqrt(tau*mu(T)*Kb*T);
end;

function TDiod_PN.LdifToTauRec(L,T:double):double;
begin
 Result:=sqr(L)/(mu(T)*Kb*T);
end;

function TDiod_PN.mu(T: double=300): double;
begin
 if FLayerN.Nd>FLayerP.Nd then
    Result:=Silicon.mu_n(T,Nd)
                          else
    Result:=Silicon.mu_p(T,Nd);
end;

function TDiod_PN.n_i(T: double=300): double;
begin
  if FLayerN.Nd>FLayerP.Nd then
    Result:=FLayerP.Material.n_i(T)
                           else
   Result:=FLayerN.Material.n_i(T);
end;

function TDiod_PN.n_SCR(x, T: double;V:double=0): double;
begin
 Result:=FLayerN.Nd*exp(-fi(x,T,V)/Kb/T)
end;

function TDiod_PN.p_SCR(x, T: double;V:double=0): double;
begin
// Result:=FLayerP.Material.Nv(T)*FLayerN.Material.Nc(T)/FLayerN.Nd*
//         exp(-(FLayerP.Material.EgT(T)-fi(x,T))/Kb/T);
 Result:=FLayerP.Nd*exp(-(Vdif(T,V)-fi(x,T,V))/Kb/T);
end;

procedure TDiod_PN.ReadFromIniFile(ConfigFile: TIniFile);
begin
  Area:=ConfigFile.ReadFloat(SecDiod,'Square pn-Diod',130e-6);
  LayerP.Nd:=ConfigFile.ReadFloat(SecDiod,'Concentration p-layer',1e16);
  LayerN.Nd:=ConfigFile.ReadFloat(SecDiod,'Concentration n-layer',1e20);
end;

function TDiod_PN.Rnp(T, V, I: double): double;
 var Vd, Wd:double;
begin
 Wd:=W(T,V);
 if (Wd=ErResult)or (Area=ErResult) then
   begin
     Result:=ErResult;
     Exit
   end;
 Vd:=Vdif(T,V);
 Result:=I/(Wd*Area*FLayerP.Material.n_i(T)*(exp(V/2/Kb/T)-1))*
          (Vd-V)/2/Kb/T/Qelem;

end;

function TDiod_PN.R_DAP(x, T, V: double): double;
  const Eta=0;
        Etd=0.1;
//--------JApplPhys_78_3185.pdf
//        Etd=-0.35;
        Cad0=1.1e-13;
        r0=5e-9;
        a0=3.23e-9;
        Nt=1e26;
        A=0.215;
  var p,n,ni,ee,p1,n1,p2,n2,
      Sig_nA,Sig_pA,Sig_nD,Sig_pD,
      tau_nA,tau_pA,tau_nD,tau_pD,
      rrA,rrD,Ra,Rd,
      Rad,r,R12,S12:double;
  function L(r:double):double;
   begin
     Result:=(1+r/a0+sqr(r/a0)/3)*exp(-r/a0);
   end;
begin
 p:=p_SCR(x, T, V);
 n:=n_SCR(x, T, V);
 ni:=FLayerP.Material.n_i(T);
 ee:=exp(-(Etd-Eta)/Kb/T);
 p1:=ni*exp(-Eta/Kb/T);
 n1:=ni*exp(Eta/Kb/T);
 p2:=ni*exp(-Etd/Kb/T);
 n2:=ni*exp(Etd/Kb/T);
 r:=r0;
 Sig_nD:=A*sqr(r);
 Sig_pA:=A*sqr(r);
 Sig_pD:=Sig_nD/1e12;
 Sig_nA:=Sig_pA/1e12;
 tau_nA:=1/(Nt*Sig_nA*FLayerP.Material.Vth_n(T));
 tau_pA:=1/(Nt*Sig_pA*FLayerP.Material.Vth_p(T));
 tau_nD:=1/(Nt*Sig_nD*FLayerP.Material.Vth_n(T));
 tau_pD:=1/(Nt*Sig_pD*FLayerP.Material.Vth_p(T));
 Rad:=Cad0*L(r)*sqr(Nt);




 //--------JApplPhys_78_3185.pdf
//  ee:=exp((Etd-Eta)/Kb/T);
// Rad:=1e35;
// tau_nA:=1e-7;
// tau_pA:=1e-8;
// tau_nD:=100;
// tau_pD:=1e-7;
//-------------------------

 rrA:=tau_nA*(p+p1)+tau_pA*(n+n1);
 rrD:=tau_nD*(p+p2)+tau_pD*(n+n2);
 Ra:=(n*p-sqr(ni))/rrA;
 Rd:=(n*p-sqr(ni))/rrD;

 S12:=(1-ee*tau_nA*tau_pD/tau_nD/tau_pA)/
      (tau_nA*tau_pD*(1-ee))*(n*p-sqr(ni));
 R12:=rrA*rrD/(2*Rad*tau_nA*tau_pD*tau_nD*tau_pA*(1-ee))+
      (tau_nA*(p+p1)+tau_pD*(n+n2))/(2*tau_nA*tau_pD*(1-ee))+
      ee*(tau_nD*(p+p2)+tau_pA*(n+n1))/(2*tau_nD*tau_pA*(1-ee));
 Result:=Ra+Rd+(sqrt(sqr(R12)-S12)-R12)*
         (tau_nA*tau_pD*(n+n2)*(p+p1)-tau_nD*tau_pA*(n+n1)*(p+p2))/
         (rrA*rrD);

//--------JApplPhys_78_3185.pdf
// R12:=(p+p2)*rrA/(2*Rad*tau_nA*tau_pD*tau_pA*(1-ee))+
//       (tau_nA*(p+p1)+tau_pD*(n+n2))/(2*tau_nA*tau_pD*(1-ee));
// Result:=Ra+(R12-sqrt(sqr(R12)-
//                       (n*p-sqr(ni))/(tau_nA*tau_pD*(1-ee))))*
//          tau_pA*(n+n1)/rrA;
//--------------------------

// Result:=Rad*(n*p-sqr(ni))/(n+n1)/(p+p2);

// showmessage('x='+ floattostr(x)+#13+
//             '(np-ni^2)='+ floattostr((n*p-sqr(ni))/(tau_nA*tau_pD*(1-ee))/2/R12)+#13+
//              floattostr(Result)+#13+
//             'Ra='+ floattostr(Ra)+#13+
//             'R12='+ floattostr(R12)+#13+
//             'p1='+ floattostr(p1)+#13+
//             'n1='+ floattostr(n1)+#13+
//             'p2='+ floattostr(p2)+#13+
//             'n2='+ floattostr(n2)+#13+
//             'p='+ floattostr(p)+#13+
//             'n='+ floattostr(n)+#13+
//             'ee='+floattostr(ee));
end;

function TDiod_PN.R_Shockley(x, T, V: double): double;
 var p,n,ni:double;
begin
 p:=p_SCR(x, T, V);
 n:=n_SCR(x, T, V);
 ni:=FLayerP.Material.n_i(T);
 Result:=(n*p-sqr(ni))/(1e-6*(n+p+2*ni));
end;

function TDiod_PN.TauGen(Iscr, T: Double): double;
begin
  Result:=Qelem*Area*n_i(T)*W(T)/2/Iscr;
end;

function TDiod_PN.TauRec(Igen, T: Double): double;
// var mu:double;
begin
//  mu:=0.1448*Power((300/T),2.33);
    Result:=Power(Qelem*Area,2)*Power(n_i(T),4)*mu(T)*Kb*T/sqr(Nd*Igen);
end;

function TDiod_PN.Vdif(T, V: double): double;
begin
 if (FLayerP.FMaterial.Eg0=ErResult)or
    (FLayerP.Material.Mh=ErResult)or
    (FLayerN.Material.Me=ErResult)or
    (FLayerP.Nd=ErResult)or
    (FLayerN.Nd=ErResult) then
      begin
       Result:=ErResult;
       Exit;
      end;
 Result:=FLayerP.Material.EgT(T)-
         Kb*T*ln(FLayerP.Material.Nv(T)*FLayerN.Material.Nc(T)/FLayerP.Nd/FLayerN.Nd)
         -V;
end;

function TDiod_PN.W(T, V: double): double;
 var Vd:double;
begin
 Vd:=Vdif(T,V)-2*Kb*T;
 if Vd=ErResult then
  begin
    Result:=ErResult;
    Exit;
  end;
 Result:=sqrt(2*FLayerP.Material.Eps*Eps0/Qelem*Vd*
             (FLayerN.Nd+FLayerP.Nd)/FLayerN.Nd/FLayerP.Nd);
end;

function TDiod_PN.Wn(T, V: double): double;
 var Wtotal:double;
begin
 Wtotal:=W(T,V);
 if Wtotal=ErResult then
    Result:=ErResult
                    else
    Result:=Wtotal*FLayerP.Nd/(FLayerN.Nd+FLayerP.Nd)
end;

function TDiod_PN.Wp(T, V: double): double;
 var Wtotal:double;
begin
 Wtotal:=W(T,V);
 if Wtotal=ErResult then
    Result:=ErResult
                    else
    Result:=Wtotal*FLayerN.Nd/(FLayerN.Nd+FLayerP.Nd)
end;

procedure TDiod_PN.WriteToIniFile(ConfigFile: TIniFile);
begin
  ConfigFile.WriteFloat(SecDiod,'Square pn-Diod',Area);
  ConfigFile.WriteFloat(SecDiod,'Concentration p-layer',LayerP.Nd);
  ConfigFile.WriteFloat(SecDiod,'Concentration n-layer',LayerN.Nd);
end;

{ TDiod_PNShow }

procedure TDiod_PNShow.AreaRead;
begin
 Diod_PN.Area:=AreaShow.Data;
end;

constructor TDiod_PNShow.Create(Dpn: TDiod_PN;
                                CBNTn, CBNTp: TCheckBox;
                                STDataNdN, STDataNdP, STDataArea: TStaticText;
                                STCaptionNdN, STCaptionNdP, STCaptionArea: TLabel);
begin
 inherited Create;
 Diod_PN:=Dpn;
 LayerNShow:=TMaterialLayerShow.Create(Diod_PN.LayerN,
                       CBNTn,STDataNdN,STCaptionNdN);
 LayerNShow.MaterialLayer.fIsNType:=True;
 LayerPShow:=TMaterialLayerShow.Create(Diod_PN.LayerP,
                       CBNTp,STDataNdP,STCaptionNdP);
 LayerPShow.MaterialLayer.fIsNType:=False;
 LayerNShow.NdShow.STCaption.Caption:='Electron density, m^(-3):';
 LayerPShow.NdShow.STCaption.Caption:='Hole concentration, m^(-3):';
 LayerNShow.CBNType.OnClick:=nil;
 LayerNShow.CBNType.Checked:=True;
 LayerNShow.CBNType.Enabled:=False;
 LayerPShow.CBNType.OnClick:=nil;
 LayerPShow.CBNType.Checked:=True;
 LayerPShow.CBNType.Enabled:=False;
 LayerPShow.CBNType.Caption:='p-type';
 AreaShow:=TParameterShow.Create(STDataArea,STCaptionArea,
                               'Area, m^2:',
                               'Diode area',
                               'Input contact area, [ ] = m^2',
                               Diod_PN.Area);
  AreaShow.Hook:=AreaRead;
end;

procedure TDiod_PNShow.Free;
begin
 AreaShow.Free;
 LayerPShow.Free;
 LayerNShow.Free;
 inherited Free;
end;

{ Silicon }

class function Silicon.A(A0, T, n: double): double;
begin
 Result:=A0*Power(T/300.0,n);
end;

class function Silicon.Absorption(Lambda:double;T:double=300): double;
 var
     Ephoton,GreenAbs,Result300:double;
begin
  Result:=ErResult;
  if (T<20)or(T>500)or(Lambda<250)or(Lambda>=1450) then Exit;
  GreenAbs:=Green(Lambda);
  if T=300 then
   begin
     Result:=GreenAbs;
     Exit;
   end;
  Ephoton:=Hpl*2*Pi*3e8/(Lambda*1e-9*Qelem);//[]=eV

  Result300:=Rajkanan(Ephoton);
  if Result300=0 then Exit;

  Result:=Rajkanan(Ephoton,T);
  if Result=0 then Exit;

  Result:=Result/Result300*GreenAbs;
end;

class function Silicon.D_n(T: Double=300; Ndoping: Double=1e21): double;
begin
 Result:=mu_n(T,Ndoping)*Kb*T;
end;

class function Silicon.D_p(T: Double=300; Ndoping: Double=1e21): double;
begin
 Result:=mu_p(T,Ndoping)*Kb*T;
end;

class function Silicon.Eg(T: double=300): double;
begin
 Result:=TMaterial.VarshniFull(Eg0_Si,T)
end;

class function Silicon.Green(Lambda: double): double;
  const  Si_absorption:array [0..241]of double=(
                      250,	1.84E+06,
                      260,	1.97E+06,
                      270,	2.18E+06,
                      280,	2.36E+06,
                      290,	2.24E+06,
                      300,	1.73E+06,
                      310,	1.44E+06,
                      320,	1.28E+06,
                      330,	1.17E+06,
                      340,	1.09E+06,
                      350,	1.04E+06,
                      360,	1.02E+06,
                      370,	6.97E+05,
                      380,	2.93E+05,
                      390,	1.50E+05,
                      400,	9.52E+04,
                      410,	6.74E+04,
                      420,	5.00E+04,
                      430,	3.92E+04,
                      440,	3.11E+04,
                      450,	2.55E+04,
                      460,	2.10E+04,
                      470,	1.72E+04,
                      480,	1.48E+04,
                      490,	1.27E+04,
                      500,	1.11E+04,
                      510,	9.70E+03,
                      520,	8.80E+03,
                      530,	7.85E+03,
                      540,	7.05E+03,
                      550,	6.39E+03,
                      560,	5.78E+03,
                      570,	5.32E+03,
                      580,	4.88E+03,
                      590,	4.49E+03,
                      600,	4.14E+03,
                      610,	3.81E+03,
                      620,	3.52E+03,
                      630,	3.27E+03,
                      640,  3.04E+03,
                      650,	2.81E+03,
                      660,	2.58E+03,
                      670,	2.38E+03,
                      680,	2.21E+03,
                      690,	2.05E+03,
                      700,	1.90E+03,
                      710,	1.77E+03,
                      720,	1.66E+03,
                      730,	1.54E+03,
                      740,	1.42E+03,
                      750,	1.30E+03,
                      760,	1.19E+03,
                      770,	1.10E+03,
                      780,	1.01E+03,
                      790,	9.28E+02,
                      800,	8.50E+02,
                      810,	7.75E+02,
                      820,	7.07E+02,
                      830,	6.47E+02,
                      840,	5.91E+02,
                      850,	5.35E+02,
                      860,	4.80E+02,
                      870,	4.32E+02,
                      880,	3.83E+02,
                      890,	3.43E+02,
                      900,	3.06E+02,
                      910,	2.72E+02,
                      920,	2.40E+02,
                      930,	2.10E+02,
                      940,	1.83E+02,
                      950,	1.57E+02,
                      960,	1.34E+02,
                      970,	1.14E+02,
                      980,	9.59E+01,
                      990,	7.92E+01,
                      1000,	6.40E+01,
                      1010,	5.11E+01,
                      1020,	3.99E+01,
                      1030,	3.02E+01,
                      1040,	2.26E+01,
                      1050,	1.63E+01,
                      1060,	1.11E+01,
                      1070,	8.00E+00,
                      1080,	6.20E+00,
                      1090,	4.70E+00,
                      1100,	3.50E+00,
                      1110,	2.70E+00,
                      1120,	2.00E+00,
                      1130,	1.50E+00,
                      1140,	1.00E+00,
                      1150,	6.80E-01,
                      1160,	4.20E-01,
                      1170,	2.20E-01,
                      1180,	6.50E-02,
                      1190,	3.60E-02,
                      1200,	2.20E-02,
                      1210,	1.30E-02,
                      1220,	8.20E-03,
                      1230,	4.70E-03,
                      1240,	2.40E-03,
                      1250,	1.00E-03,
                      1260,	3.60E-04,
                      1270,	2.00E-04,
                      1280,	1.20E-04,
                      1290,	7.10E-05,
                      1300,	4.50E-05,
                      1310,	2.70E-05,
                      1320,	1.60E-05,
                      1330,	8.00E-06,
                      1340,	3.50E-06,
                      1350,	1.70E-06,
                      1360,	1.00E-06,
                      1370,	6.70E-07,
                      1380,	4.50E-07,
                      1390,	2.50E-07,
                      1400,	2.00E-07,
                      1410,	1.50E-07,
                      1420,	8.50E-08,
                      1430,	7.70E-08,
                      1440,	4.20E-08,
                      1450,	3.20E-08);
 var Vect:PVector;
     i:integer;
begin
  if Lambda=900 then
   begin
     Result:=30600;
     Exit;
   end;
  
  new(Vect);
  Vect^.SetLenVector(trunc(High(Si_absorption)/2));
  for I := 0 to High(Vect^.X) do
    begin
     Vect^.X[i]:=Si_absorption[2*i];
     Vect^.Y[i]:=Si_absorption[2*i+1];
    end;
  Result:=Splain3(Vect,Lambda)*100;
  dispose(Vect);
end;

class function Silicon.mu_n(T: Double=300; Ndoping: Double=1e21): double;
 var  mu_min,mu_0,Nref,Alpha:double;
begin
 mu_min:=A(92e-4,T,-0.57);
 mu_0:=A(0.1268,T,-2.33);
 Nref:=A(1.3e23,T,2.4);
 Alpha:=A(0.91,T,-0.146);
 Result:=TMaterial.CaugheyThomas(mu_min,mu_0,Nref,Ndoping,Alpha);
end;

class function Silicon.mu_p(T: Double=300; Ndoping: Double=1e21): double;
 var  mu_min,mu_0,Nref,Alpha:double;
begin
 mu_min:=A(54.3e-4,T,-0.57);
 mu_0:=A(0.04069,T,-2.23);
 Nref:=A(2.35e23,T,2.4);
 Alpha:=A(0.88,T,-0.146);
 Result:=TMaterial.CaugheyThomas(mu_min,mu_0,Nref,Ndoping,Alpha);
end;

class function Silicon.Rajkanan(Ephoton, T: double): double;
 const Eg0:array[0..2]of double=(Eg0_Si,2.5,3.2); {[]=eB}
       Ep:array[0..1]of double=(1.827e-2,5.773e-2);  {[]=eB}
       C:array[0..1]of double=(5.5,4.0);  {[]=1}
       A:array[0..2]of double=(3.231e2,7.237e3,1.052e6);  {[]=1/(cm eB^2)}
 var kT,S1ij,S2ij:double;
     EgT:array[0..2]of double;
     i,j:byte;
begin
  Result:=0;
  kT:=Kb*T;
  for I := 0 to High(Eg0) do
       EgT[i]:=TMaterial.VarshniFull(Eg0[i],T);

  for I := 0 to 1 do
    for j := 0 to 1 do
      begin
        S1ij:=(Ephoton-EgT[j]+Ep[i]);
        if S1ij<0 then S1ij:=0;
        S2ij:=(Ephoton-EgT[j]-Ep[i]);
        if S2ij<0 then S2ij:=0;
        Result:=Result+C[i]*A[j]*
                (sqr(S1ij)/(exp(Ep[i]/kT)-1)+
                sqr(S2ij)/(1-exp(-Ep[i]/kT)));
      end;
  if Ephoton>EgT[2] then
    Result:=Result+A[2]*sqrt(Ephoton-EgT[2]);
  Result:=Result*100;
end;

end.
