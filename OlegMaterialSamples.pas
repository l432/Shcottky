unit OlegMaterialSamples;

interface
uses IniFiles, TypInfo, OlegType;
type
    TMaterialName=(nSi,pSi,nGaAs,nInP,H4SiC,nGaN,
                   nCdTe,CuInSe2,pGaTe,pGaSe,Ge,Other);
    TMaterialParametersName=(
            nEg0,   //������ ���������� ���� ��� T=0, []=eV
            nEps,   //����������� ����������
            nARich, //����� г��������, []=A/(m^2 A^2)
            nMeff,  //��������� ��������� ���� �� ���� ������ ���������
                //������� ����� Eg(T)=Eg(0)-B*T^2/(T+A)
            nVarshA, //�������� � � ������� ������
            nVarshB //�������� � � ������� ������
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
    (Name:'n-GaAs'; Parameters: (1.519,    12.9, 8.16e4,   1,    204,      5.405e-4)),
    (Name:'n-InP';  Parameters: (ErResult, 12.5, 0.6e6,    1,    ErResult, ErResult)),
    (Name:'4H-SiC'; Parameters: (ErResult, 9.7,  0.75e6,   1,    ErResult, ErResult)),
    (Name:'n-GaN';  Parameters: (ErResult, 8.9,  2.69e5,   1,    ErResult, ErResult)),
    (Name:'n-CdTe'; Parameters: (ErResult, 1,    0.12e6,   1,    ErResult, ErResult)),
    (Name:'CuInSe2';Parameters: (ErResult, 1,    8.53e5,   1,    ErResult, ErResult)),
    (Name:'p-GaTe'; Parameters: (ErResult, 1,    1.19e6,   1,    ErResult, ErResult)),
    (Name:'p-GaSe'; Parameters: (ErResult, 1,    2.47e6,   1,    ErResult, ErResult)),
    (Name:'Ge';     Parameters: (0.7437,   1,    ErResult, 1,    235,      4.774e-4)),
    (Name:'Other';  Parameters: (ErResult, 1,    ErResult, 1,    ErResult, ErResult))
    );


   SecDiod='Parameters';
//   ��'� ������ � .ini-����,
//   �� ����������� ��������� ����

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
      // ������ ���������� ���� ��� ���������� �
     function Nc(T:double):double;
//    ��������� ������� �����
     end; // TMaterial=class



    TDiodSample=class
     private
      FArea  :double; //����� []=m^2
      FNd  :double; //������������ ���� []=m^(-3)
      FEps_i:double; //����������� ���������� ����������
      FThick_i :double; //������� ������������� ���� []=m
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
     {������� �������� kT ln(Area*ARich*T^2)}
     function I0(T,Fb:double):double;
     {������� ����� ���������
     I0=Area*Arich*T^*exp(-Fb/Kb/T)}
     function Fb(T,I0:double):double;
     {������� ������ ���'���
     Fb=kT*ln(Area*ARich*T^2/I0)}
     function Vbi(T:double):double;
     {��'����� ��������� (build in)}
     function Em(Vrev,T,Fb0:double):double;
     {����������� �������� ������������ ����}
     end; // TDiod=class

var
  Semi:TMaterial;
  {������ ��������� ��������}
  Diod:TDiodSample;
  {������ ��������� ������}


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
//    ��������� ������� �����
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
{������� �������� kT ln(Area*ARich*T^2)}
  begin
    Result:=Kb*T*ln(Area*Material.ARich*sqr(T));
  end;

function TDiodSample.I0(T,Fb:double):double;
{������� ������ ���������
I0=Area*Arich*T^*exp(-Fb/Kb/T)}
begin
 try
  Result:=Area*Material.Arich*sqr(T)*exp(-Fb/Kb/T);
 except
     Result:=ErResult;
 end;
end;

function TDiodSample.Fb(T,I0:double):double;
{������� ������ ���'���
Fb=kT*ln(Area*ARich*T^2/I0)}
  begin
    try
     Result:=Kb*T*ln(Area*Material.Arich*sqr(T)/I0);
    except
     Result:=ErResult;
    end;
  end;

function TDiodSample.Vbi(T:double):double;
{��'����� ��������� (build in)}
  begin
   try
    Result:=Kb*T*ln(Material.Nc(T)/Nd);
    except
     Result:=ErResult;
   end;
  end;

function TDiodSample.Em(Vrev,T,Fb0:double):double;
{����������� �������� ������������ ����}
begin
 try
  Result:=sqrt(2*Qelem*Nd/Material.Eps/Eps0*
            (Material.Varshni(Fb0,T)-Vbi(T)+Vrev));
 except
  Result:=ErResult;
 end;
end;

end.
