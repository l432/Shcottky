unit OlegMaterialSamples;

interface
uses IniFiles;
const
  MaterialName:array [0..10] of string=
           ('n-Si','p-Si','n-GaAs','n-InP','4H-SiC',
           'n-GaN','n-CdTe','CuInSe2','p-GaTe',
           'p-GaSe','Other');


type

    TMaterial=class
     private
      FName :string; // назва матеріалу
      FEg0  :double; //ширина забороненої зони T=0, []=eV
      FEps  :double; //діелектрична проникність
      FARich:double; //стала Річардсона, []=A/(m2 A2)
      FMeff :double; //відношення ефективної маси до масо спокою електрона
          //рівняння Варшні Eg(T)=Eg(0)-B*T^2/(T+A)
      FVarshA:double; //параметр А з рівняння Варшіні
      FVarshB:double; //параметр В з рівняння Варшіні
     procedure SetAbsValue(Index:integer; value:double);
     procedure SetEpsValue (value:double);
     procedure SetName (value:string);

     public
     Constructor Create(MaterialName:string);

     property Name:string read FName write SetName;
     property Eg0:double Index 1 read FEg0 write SetAbsValue;
     property Eps:double read FEps write SetEpsValue;
     property ARich:double Index 2 read FARich write SetAbsValue;
     property Meff:double Index 3 read FMeff write SetAbsValue;
     property VarshA:double Index 4 read FVarshA write SetAbsValue;
     property VarshB:double Index 5 read FVarshB write SetAbsValue;

     procedure ReadFromIniFile(ConfigFile:TIniFile);
     procedure WriteToIniFile(ConfigFile:TIniFile);

     function EgT(T:double):double;
      // ширина забороненої зони при температурі Т
     end; // TMaterial=class


implementation

procedure TMaterial.SetAbsValue(Index:integer; value: Double);
begin
case Index of
 1: FEg0:=abs(value);
 2: FARich:=abs(value);
 3: FMeff:=abs(value);
 4: FVarshA:=abs(value);
 5: FVarshB:=abs(value);
 end;
end;

procedure TMaterial.SetEpsValue(value: Double);
begin
 if value>1 then FEps:=value
            else FEps:=1;
end;

procedure TMaterial.SetName(value: string);
begin
  FName:=value;

  FEg0:=555;
  FEps:=1;
  FARich:=555;
  FMeff:=1;
  FVarshA:=555;
  FVarshB:=555;

  if (FName='n-Si')or(FName='p-Si') then
   begin
    FEg0:=1.169;
    FEps:=11.7;
    FVarshA:=1108;
    FVarshB:=7.021e-4;
   end;
  if (FName='n-Si') then
   begin
    FMeff:=1.08;
    FARich:=1.12e6;
   end;
  if (FName='p-Si') then 
   begin
    FMeff:=0.58;
    FARich:=0.32e6;
   end;

  if (FName='n-GaAs') then
   begin
    FEps:=12.9;
    FARich:=0.0816e6;
   end;
  if (FName='n-InP') then
   begin
    FEps:=12.5;
    FARich:=0.6e6;
   end;
  if (FName='4H-SiC') then
   begin
    FEps:=9.7;
    FARich:=0.75e6;
   end;
  if (FName='n-GaN') then
   begin
    FEps:=8.9;
    FARich:=0.269e6;
   end;
  if (FName='n-CdTe') then
    FARich:=0.12e6;
  if (FName='CuInSe2') then
    FARich:=0.853e6;
  if (FName='p-GaTe') then
    FARich:=1.19e6;
  if (FName='p-GaSe') then
    FARich:=2.47e6;
end;

function TMaterial.EgT(T: Double):Double;
begin
 Result:=FEg0-sqr(T)*FVarshB/(T+FVarshA);
end;

Constructor TMaterial.Create(MaterialName:string);
begin
  inherited Create;
  Name:=MaterialName;
end; // TMaterial.Create(MaterialName:string);


procedure TMaterial.ReadFromIniFile(ConfigFile:TIniFile);
begin
  Eg0:=ConfigFile.ReadFloat(Name,'Eg0',555);
  Eps:=ConfigFile.ReadFloat(Name,'Eps',1);
  ARich:=ConfigFile.ReadFloat(Name,'ARich',555);
  Meff:=ConfigFile.ReadFloat(Name,'Meff',1);
  VarshA:=ConfigFile.ReadFloat(Name,'VarshA',555);
  VarshB:=ConfigFile.ReadFloat(Name,'VarshB',555);
end;

procedure TMaterial.WriteToIniFile(ConfigFile:TIniFile);
begin
  if Eg0<>555 then ConfigFile.WriteFloat(Name,'Eg0',Eg0);
  if ARich<>555 then ConfigFile.WriteFloat(Name,'ARich',ARich);
  if VarshA<>555 then ConfigFile.WriteFloat(Name,'VarshA',VarshA);
  if VarshB<>555 then ConfigFile.WriteFloat(Name,'VarshB',VarshB);
  if Eps<>1 then ConfigFile.WriteFloat(Name,'Eps',Eps);
  if Meff<>1 then ConfigFile.WriteFloat(Name,'Meff',Meff);
end;

end.
