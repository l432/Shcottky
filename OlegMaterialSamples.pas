unit OlegMaterialSamples;

interface
uses IniFiles, TypInfo, OlegType,SysUtils,Dialogs, StdCtrls,OlegFunction;
type
//    TMaterialName=(nSi,pSi,nGaAs,pGaAs,nInP,pInP,H4SiC,nGaN,pGaN,
//                   nCdTe,pCdTe,nCdS,nCdSe,CuInSe2,pGaTe,pGaSe,nGe,pGe,Other);
//    TMaterialParametersName=(
//            nEg0,   //ширина забороненої зони при T=0, []=eV
//            nEps,   //діелектрична проникність
//            nARich, //стала Річардсона, []=A/(m^2 A^2)
//            nMeff,  //відношення ефективної маси до маси спокою електрона
//                //рівняння Варшні Eg(T)=Eg(0)-B*T^2/(T+A)
//            nVarshA, //параметр А з рівняння Варшні
//            nVarshB //параметр В з рівняння Варшні
//             );
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

  Materials:array [TMaterialName] of TMaterialParameters=
////                                Eg0,     Eps,  ARich,    Meff, VarshA,   VarshB
//   ((Name:'n-Si';   Parameters: (1.169,    11.7, 1.12e6,   1.08, 1108,     7.021e-4)),
//    (Name:'p-Si';   Parameters: (1.169,    11.7, 0.32e6,   0.58, 1108,     7.021e-4)),
//    (Name:'n-GaAs'; Parameters: (1.519,    12.9, 8.16e4,   0.06, 204,      5.405e-4)),
//    (Name:'p-GaAs'; Parameters: (1.519,    12.9, ErResult, 0.50, 204,      5.405e-4)),
//    (Name:'n-InP';  Parameters: (1.39,     12.5, 0.6e6,    0.08, 0,        4.6e-4)),
//    (Name:'p-InP';  Parameters: (1.39,     12.5, ErResult, 0.60, 0,        4.6e-4)),
//    (Name:'4H-SiC'; Parameters: (3.26,     9.7,  0.75e6,   1,    1300,     6.5e-4)),
//    (Name:'n-GaN';  Parameters: (3.47,     8.9,  2.64e5,   0.22, 600,      7.7e-4)),
//    (Name:'p-GaN';  Parameters: (3.47,     8.9,  7.50e5,   0.60, 600,      7.7e-4)),
//    (Name:'n-CdTe'; Parameters: (1.57,     12,   0.12e6,   1.08, 0,        4e-4)),
//    (Name:'p-CdTe'; Parameters: (1.57,     12,   ErResult, 0.60, 0,        4e-4)),
//    (Name:'n-CdS';  Parameters: (2.557,    1,    2.34e5,   0.17, 450,      8.21e-4)),
//    (Name:'n-CdSe'; Parameters: (1.9,      10.2, 1.56e5,   0.13, 0,        2.8e-4)),
//    (Name:'CuInSe2';Parameters: (ErResult, 1,    8.53e5,   1,    ErResult, ErResult)),
//    (Name:'p-GaTe'; Parameters: (ErResult, 1,    1.19e6,   1,    ErResult, ErResult)),
//    (Name:'p-GaSe'; Parameters: (ErResult, 1,    2.47e6,   1,    ErResult, ErResult)),
//    (Name:'n-Ge';   Parameters: (0.7437,   16,   ErResult, 0.55, 235,      4.774e-4)),
//    (Name:'p-Ge';   Parameters: (0.7437,   16,   ErResult, 0.36, 235,      4.774e-4)),
//    (Name:'Other';  Parameters: (ErResult, 1,    ErResult, 1,    ErResult, ErResult))
//    );
//                                Eg0,     Eps,  ARich_n,  ARich_p,  Me,   Mh,   VarshA,   VarshB
   ((Name:'Si';     Parameters: (1.169,    11.7, 1.12e6,   0.32e6,   1.08, 0.58, 1108,     7.021e-4)),
    (Name:'GaAs';   Parameters: (1.519,    12.9, 8.16e4,   ErResult, 0.06, 0.50, 204,      5.405e-4)),
    (Name:'InP';    Parameters: (1.39,     12.5, 0.6e6,    ErResult, 0.08, 0.60, 0,        4.6e-4)),
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
       function Rnp(T,V,I:double):double;
       {приведена швидкість рекомбінації, []=c^-1
       I - струм через діод}
       function n_i(T:double):double;
       {концентрація власних носіїв
       у шару з більшим опором}
       function TauRec(Igen, T: Double):double;
       {час рекомбінації по величині дифузійного струму;
       вважається що рекомбінація відбувається в області
       з меншою прповідністю;
       саме погане - рухливість як для електронів
       у кремнії, тобто для інших структур треба удосконалити
       функцію}
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
  Result:=F0-sqr(T)*VarshB/(T+VarshA);
end;

Constructor TMaterial.Create(MaterialName:TMaterialName);
begin
  inherited Create;
  ChangeMaterial(MaterialName);
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

function TMaterial.Nc(T:double):double;
//    ефективна густина станів
begin
 if Me=ErResult then Result:=ErResult
                else Result:=2.5e25*Me*(T/300.0)*sqrt(Me*T/300.0);
end;

function TMaterial.Nv(T: double): double;
begin
 if Mh=ErResult then Result:=ErResult
                else Result:=2.5e25*Mh*(T/300.0)*sqrt(Mh*T/300.0);
end;

function TMaterial.n_i(T: double): double;
begin
 Result:=ErResult;
 if Eg0=ErResult then Exit;
 if Name='Si' then
      begin
       Result:=1.64e21*Power(T,1.706)*exp(-EgT(T)/2/T/Kb);
       Exit;
      end;
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

function TDiod_PN.n_i(T: double): double;
begin
  if FLayerN.Nd>FLayerP.Nd then
    Result:=FLayerP.Material.n_i(T)
                           else
   Result:=FLayerN.Material.n_i(T);
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

function TDiod_PN.TauRec(Igen, T: Double): double;
 var mu:double;
begin
  mu:=0.1448*Power((300/T),2.33);
    Result:=Power(Qelem*Area,2)*Power(n_i(T),4)*mu*Kb*T/
          sqr(Nd*Igen);
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
         Kb*T*ln(FLayerP.Material.Nv(T)*FLayerN.Material.Nc(T)/FLayerP.Nd/FLayerN.Nd)-V;
end;

function TDiod_PN.W(T, V: double): double;
 var Vd:double;
begin
 Vd:=Vdif(T,V);
 if Vd=ErResult then
  begin
    Result:=ErResult;
    Exit;
  end;
 Result:=sqrt(2*FLayerP.Material.Eps*Eps0/Qelem*Vd*
             (FLayerN.Nd+FLayerP.Nd)/FLayerN.Nd/FLayerP.Nd);
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

end.
