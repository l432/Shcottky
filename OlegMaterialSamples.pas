unit OlegMaterialSamples;

interface
uses IniFiles, TypInfo, OlegType,SysUtils,Dialogs;
type
    TMaterialName=(nSi,pSi,nGaAs,pGaAs,nInP,pInP,H4SiC,nGaN,pGaN,
                   nCdTe,pCdTe,nCdS,nCdSe,CuInSe2,pGaTe,pGaSe,nGe,pGe,Other);
    TMaterialParametersName=(
            nEg0,   //ширина забороненої зони при T=0, []=eV
            nEps,   //діелектрична проникність
            nARich, //стала Річардсона, []=A/(m^2 A^2)
            nMeff,  //відношення ефективної маси до масо спокою електрона
                //рівняння Варшні Eg(T)=Eg(0)-B*T^2/(T+A)
            nVarshA, //параметр А з рівняння Варшіні
            nVarshB //параметр В з рівняння Варшіні
             );
    TMaterialParameters=record
          Name:string;
          Parameters:array[TMaterialParametersName]of double;
          end;
const

  Materials:array [TMaterialName] of TMaterialParameters=
//                                Eg0,     Eps,  ARich,    Meff, VarshA,   VarshB
   ((Name:'n-Si';   Parameters: (1.169,    11.7, 1.12e6,   1.08, 1108,     7.021e-4)),
    (Name:'p-Si';   Parameters: (1.169,    11.7, 0.32e6,   0.58, 1108,     7.021e-4)),
    (Name:'n-GaAs'; Parameters: (1.519,    12.9, 8.16e4,   0.06, 204,      5.405e-4)),
    (Name:'p-GaAs'; Parameters: (1.519,    12.9, ErResult, 0.50, 204,      5.405e-4)),
    (Name:'n-InP';  Parameters: (1.39,     12.5, 0.6e6,    0.08, 0,        4.6e-4)),
    (Name:'p-InP';  Parameters: (1.39,     12.5, ErResult, 0.60, 0,        4.6e-4)),
    (Name:'4H-SiC'; Parameters: (3.26,     9.7,  0.75e6,   1,    1300,     6.5e-4)),
    (Name:'n-GaN';  Parameters: (3.47,     8.9,  2.64e5,   0.22, 600,      7.7e-4)),
    (Name:'p-GaN';  Parameters: (3.47,     8.9,  7.50e5,   0.60, 600,      7.7e-4)),
    (Name:'n-CdTe'; Parameters: (1.57,     12,   0.12e6,   1.08, 0,        4e-4)),
    (Name:'p-CdTe'; Parameters: (1.57,     12,   ErResult, 0.60, 0,        4e-4)),
    (Name:'n-CdS';  Parameters: (2.557,    1,    2.34e5,   0.17, 450,      8.21e-4)),
    (Name:'n-CdSe'; Parameters: (1.9,      10.2, 1.56e5,   0.13, 0,        2.8e-4)),
    (Name:'CuInSe2';Parameters: (ErResult, 1,    8.53e5,   1,    ErResult, ErResult)),
    (Name:'p-GaTe'; Parameters: (ErResult, 1,    1.19e6,   1,    ErResult, ErResult)),
    (Name:'p-GaSe'; Parameters: (ErResult, 1,    2.47e6,   1,    ErResult, ErResult)),
    (Name:'n-Ge';   Parameters: (0.7437,   16,   ErResult, 0.55, 235,      4.774e-4)),
    (Name:'p-Ge';   Parameters: (0.7437,   16,   ErResult, 0.36, 235,      4.774e-4)),
    (Name:'Other';  Parameters: (ErResult, 1,    ErResult, 1,    ErResult, ErResult))
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
     property ARich:double Index 2 read FParameters.Parameters[nARich] write SetAbsValue;
     property Meff:double Index 3 read FParameters.Parameters[nMeff] write SetAbsValue;
     property VarshA:double Index 4 read FParameters.Parameters[nVarshA] write SetAbsValue;
     property VarshB:double Index 5 read FParameters.Parameters[nVarshB] write SetAbsValue;

     procedure ReadFromIniFile(ConfigFile:TIniFile);
     procedure WriteToIniFile(ConfigFile:TIniFile);

     function Varshni(F0,T:double):double;
     function EgT(T:double):double;
      // ширина забороненої зони при температурі Т
     function Nc(T:double):double;
//    ефективна густина станів
     end; // TMaterial=class



    TDiodSample=class
     private
      FArea  :double; //площа []=m^2
      FNd  :double; //концентрація носіїв []=m^(-3)
      FEps_i:double; //діелектрична проникність діелектрика
      FThick_i :double; //товщина діелектричного шару []=m
      FMaterial:TMaterial;
     procedure SetAbsValue(Index:integer; value:double);
     procedure SetEpsValue (value:double);
     procedure SetMaterial(value:TMaterial);
     function Get_nu():double;

     public
     property Area:double Index 1 read FArea write SetAbsValue;
     property Eps_i:double read FEps_i write SetEpsValue;
     property Nd:double Index 2 read FNd write SetAbsValue;
     property Thick_i:double Index 3 read FThick_i write SetAbsValue;
     property Material:TMaterial read FMaterial write SetMaterial;
     property nu:double read Get_nu;

     procedure ReadFromIniFile(ConfigFile:TIniFile);
     procedure WriteToIniFile(ConfigFile:TIniFile);

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
//     function Em(T,Fb0:double;Vrev:double=0):double;
     function Em(T,Fb0:double;Vrev:double=0;C1:double=0):double;
     {максимальне значення електричного поля}
     end; // TDiod=class

var
  Semi:TMaterial;
  {містить параметри матеріалу}
  Diod:TDiodSample;
  {містить параметри зразка}

Function PAT(V,kT1,Fb0,a,hw,Nss{Parameters[0]},E{Parameters[1]}:double;Sample:TDiodSample):double;


implementation

procedure TMaterial.SetAbsValue(Index:integer; value: Double);
begin
case Index of
 1: FParameters.Parameters[nEg0]:=abs(value);
 2: FParameters.Parameters[nARich]:=abs(value);
 3: FParameters.Parameters[nMeff]:=abs(value);
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
 Result:=Varshni(Eg0,T);
end;

function TMaterial.Nc(T:double):double;
//    ефективна густина станів
begin
 Result:=2.5e25*Meff*(T/300.0)*sqrt(T/300.0);
end;




procedure TMaterial.ReadFromIniFile(ConfigFile:TIniFile);
var i:TMaterialParametersName;
begin
  for I := Low(TMaterialParametersName) to High(TMaterialParametersName) do
    FParameters.Parameters[i]:=
        ConfigFile.ReadFloat(Name,
                             GetEnumName(TypeInfo(TMaterialParametersName),ord(i)),
                             Materials[High(TMaterialName)].Parameters[i]);

//  Eg0:=ConfigFile.ReadFloat(Name,'Eg0',ErResult);
//  Eps:=ConfigFile.ReadFloat(Name,'Eps',1);
//  ARich:=ConfigFile.ReadFloat(Name,'ARich',ErResult);
//  Meff:=ConfigFile.ReadFloat(Name,'Meff',1);
//  VarshA:=ConfigFile.ReadFloat(Name,'VarshA',ErResult);
//  VarshB:=ConfigFile.ReadFloat(Name,'VarshB',ErResult);
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


//  if Eg0<>ErResult then ConfigFile.WriteFloat(Name,'Eg0',Eg0);
//  if ARich<>ErResult then ConfigFile.WriteFloat(Name,'ARich',ARich);
//  if VarshA<>ErResult then ConfigFile.WriteFloat(Name,'VarshA',VarshA);
//  if VarshB<>ErResult then ConfigFile.WriteFloat(Name,'VarshB',VarshB);
//  if Eps<>1 then ConfigFile.WriteFloat(Name,'Eps',Eps);
//  if Meff<>1 then ConfigFile.WriteFloat(Name,'Meff',Meff);
end;

//--------------------------- TDiodSample ----------------------

procedure TDiodSample.SetAbsValue(Index:integer; value: Double);
begin
case Index of
 1: FArea:=abs(value);
 2: FNd:=abs(value);
 3: FThick_i:=abs(value);
 end;
end;

procedure TDiodSample.SetEpsValue(value: Double);
begin
 if value>1 then FEps_i:=value
            else FEps_i:=1;
end;

procedure TDiodSample.ReadFromIniFile(ConfigFile:TIniFile);
begin
  Area:=ConfigFile.ReadFloat(SecDiod,'Square',3.14e-6);
  Nd:=ConfigFile.ReadFloat(SecDiod,'Concentration',5e21);
  Eps_i:=ConfigFile.ReadFloat(SecDiod,'InsulPerm',4.1);
  Thick_i:=ConfigFile.ReadFloat(SecDiod,'InsulDepth',3e-9);
end;

procedure TDiodSample.WriteToIniFile(ConfigFile:TIniFile);
begin
  ConfigFile.EraseSection(SecDiod);
  ConfigFile.WriteFloat(SecDiod,'Square',Area);
  ConfigFile.WriteFloat(SecDiod,'Concentration',Nd);
  ConfigFile.WriteFloat(SecDiod,'InsulPerm',Eps_i);
  ConfigFile.WriteFloat(SecDiod,'InsulDepth',Thick_i);
end;

procedure TDiodSample.SetMaterial(value:TMaterial);
  begin
   if Value = nil then
      Value:=TMaterial.Create(High(TMaterialName));
   FMaterial:=value;
  end;

function TDiodSample.Get_nu():double;
begin
  Result:=Eps0*Material.Eps/Qelem/Nd;
end;

function TDiodSample.kTln(T:double):double;
{повертає значення kT ln(Area*ARich*T^2)}
  begin
    Result:=Kb*T*ln(Area*Material.ARich*sqr(T));
  end;

function TDiodSample.I0(T,Fb:double):double;
{повертає струму насичення
I0=Area*Arich*T^*exp(-Fb/Kb/T)}
begin
 try
  Result:=Area*Material.Arich*sqr(T)*exp(-Fb/Kb/T);
 except
     Result:=ErResult;
 end;
end;

function TDiodSample.Fb(T,I0:double):double;
{повертає висоту бар'єру
Fb=kT*ln(Area*ARich*T^2/I0)}
  begin
    try
     Result:=Kb*T*ln(Area*Material.Arich*sqr(T)/I0);
    except
     Result:=ErResult;
    end;
  end;

function TDiodSample.Vbi(T:double):double;
{об'ємний потенціал (build in)}
  begin
   try
    Result:=Kb*T*ln(Material.Nc(T)/Nd);
    except
     Result:=ErResult;
   end;
  end;

//function TDiodSample.Em(T,Fb0:double;Vrev:double=0):double;
//{максимальне значення електричного поля}
//begin
// try
//  Result:=sqrt(2*Qelem*Nd/Material.Eps/Eps0*
//            (Material.Varshni(Fb0,T)-Vbi(T)+Vrev));
// except
//  Result:=ErResult;
// end;
//end;

function TDiodSample.Em(T,Fb0:double;Vrev:double=0;C1:double=0):double;
{максимальне значення електричного поля}
 var a,b,c,Fb,Fa:double;
     i:integer;
 function FunEmTemp(Emtemp:double):double;
  begin
   try
    Result:=Emtemp-sqrt(2*Qelem*Nd/Material.Eps/Eps0*
            (Material.Varshni(Fb0,T)-C1*Emtemp-Vbi(T)+Vrev));
   except
    Result:=ErResult;
   end;
  end;

begin
 Result:=ErResult;
 try
  if (C1=0) then
   begin
   Result:=sqrt(2*Qelem*Nd/Material.Eps/Eps0*
            (Material.Varshni(Fb0,T)-Vbi(T)+Vrev));
   end
                     else
   begin
    a:=0;
    b:=sqrt(2*Qelem*Nd/Material.Eps/Eps0*
            (Material.Varshni(Fb0,T)-Vbi(T)+Vrev));

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


Function PAT(V,kT1,Fb0,a,hw,Nss{Parameters[0]},E{Parameters[1]}:double;Sample:TDiodSample):double;
var g,gam,gam1,qE,Et:double;
begin


  qE:=Qelem*Sample.Em(1/(kT1*Kb),Fb0,V);

  Et:=E*Qelem;

  g:=a*sqr(hw*Qelem)*(1+2/(exp(hw*kT1)-1));
  gam:=sqrt(2*m0*Sample.Material.Meff)*g/(Hpl*qE*sqrt(Et));
  gam1:=sqrt(1+sqr(gam));
  Result:=Sample.Area*Nss*qE/sqrt(8*m0*Sample.Material.Meff*E)*sqrt(1-gam/gam1)*
          exp(-4*sqrt(2*m0*Sample.Material.Meff)*Et*sqrt(Et)/(3*Hpl*qE)*
              sqr(gam1-gam)*(gam1+0.5*gam));
// showmessage('gam1='+floattostr(gam1)+'  Res='+floattostr(Result));

end;


end.
